import Foundation

// MARK: - Proxy Request / Response

private struct ProxyRequest: Encodable {
    let spread: String
    let question: String?
    let deckType: String
    let cards: [CardPosition]
    /// Pre-built user prompt so the proxy can forward it directly to Claude
    let userMessage: String

    struct CardPosition: Encodable {
        let position: String
        let name: String
        let family: String
        let essence: [String]
        let messageProfond: String
        let spreadInterpretation: String
    }
}

private struct ProxyResponse: Decodable {
    // Format proxy : { "interpretation": "..." }
    let interpretation: String?
    // Format brut Anthropic : { "content": [{ "type": "text", "text": "..." }] }
    let content: [ContentBlock]?

    struct ContentBlock: Decodable {
        let type: String
        let text: String?
    }

    var text: String? {
        if let interpretation { return interpretation }
        return content?.first(where: { $0.type == "text" })?.text
    }
}

// MARK: - Errors

enum AIInterpretationError: LocalizedError {
    case noEndpoint
    case networkError(Error)
    case invalidResponse
    case serverError(String)
    case noCardsResolved

    var errorDescription: String? {
        switch self {
        case .noEndpoint:
            return "Service d'interprétation non configuré."
        case .networkError(let error):
            return "Erreur réseau : \(error.localizedDescription)"
        case .invalidResponse:
            return "Réponse invalide du serveur."
        case .serverError(let message):
            return message
        case .noCardsResolved:
            return "Impossible de résoudre les cartes tirées."
        }
    }
}

// MARK: - Service

actor AIInterpretationService {

    static let shared = AIInterpretationService()

    /// Proxy endpoint URL
    private let proxyURL: URL? = URL(string: "https://coeurcosmique-proxy.vercel.app/api/interpret")

    /// Bearer token sent to the proxy for auth
    private let proxyToken: String? = "75FC49FC-55F2-4915-9EBB-65E4B3133D9F"

    // MARK: - Public: Quantum Oracle

    func interpret(reading: QuantumOracleReading, deck: [QuantumOracleCard]) async throws -> String {
        let payload = try buildQuantumPayload(reading: reading, deck: deck)
        return try await sendRequest(payload: payload)
    }

    // MARK: - Public: Tarot

    func interpretTarot(reading: TarotReading, deck: [TarotCard]) async throws -> String {
        let payload = try buildTarotPayload(reading: reading, deck: deck)
        return try await sendRequest(payload: payload)
    }

    // MARK: - Public: Runes Cosmiques

    func interpretRune(reading: RuneReading, deck: [RuneCard]) async throws -> String {
        let payload = try buildRunePayload(reading: reading, deck: deck)
        return try await sendRequest(payload: payload)
    }

    // MARK: - Public: Oracle du Coeur Cosmique

    func interpretOracle(reading: OracleReading, deck: [OracleCard]) async throws -> String {
        let payload = try buildOraclePayload(reading: reading, deck: deck)
        return try await sendRequest(payload: payload)
    }

    // MARK: - Network

    private func sendRequest(payload: ProxyRequest) async throws -> String {
        guard let url = proxyURL else {
            throw AIInterpretationError.noEndpoint
        }

        let body = try JSONEncoder().encode(payload)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = proxyToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body
        request.timeoutInterval = 30

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw AIInterpretationError.networkError(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw AIInterpretationError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Erreur \(http.statusCode)"
            throw AIInterpretationError.serverError(message)
        }

        let decoded = try JSONDecoder().decode(ProxyResponse.self, from: data)
        guard let result = decoded.text else {
            throw AIInterpretationError.invalidResponse
        }
        return result
    }

    // MARK: - Build Quantum Payload

    private func buildQuantumPayload(reading: QuantumOracleReading, deck: [QuantumOracleCard]) throws -> ProxyRequest {
        let cards = reading.cards.enumerated().compactMap { index, drawn -> ProxyRequest.CardPosition? in
            guard let card = drawn.resolve(from: deck) else { return nil }
            let label = index < reading.spread.labels.count ? reading.spread.labels[index] : "Position \(index + 1)"
            let spreadInterp = quantumInterpretationText(card: card, spread: reading.spread, position: index)

            return ProxyRequest.CardPosition(
                position: label,
                name: "\(card.number). \(card.name)",
                family: card.family.title,
                essence: card.essence,
                messageProfond: card.messageProfond,
                spreadInterpretation: spreadInterp
            )
        }

        guard !cards.isEmpty else {
            throw AIInterpretationError.noCardsResolved
        }

        let userMessage = buildUserMessage(spread: reading.spread.title, question: reading.question, cards: cards)

        return ProxyRequest(
            spread: reading.spread.title,
            question: reading.question,
            deckType: "quantum",
            cards: cards,
            userMessage: userMessage
        )
    }

    // MARK: - Build Tarot Payload

    private func buildTarotPayload(reading: TarotReading, deck: [TarotCard]) throws -> ProxyRequest {
        let cards = reading.cards.enumerated().compactMap { index, drawn -> ProxyRequest.CardPosition? in
            guard let card = drawn.resolve(from: deck) else { return nil }
            let label = index < reading.spread.labels.count ? reading.spread.labels[index] : "Position \(index + 1)"

            let orientation = drawn.isReversed ? "Inversée" : "Droite"
            let meaning = drawn.isReversed ? card.reversedMeaning : card.uprightMeaning

            return ProxyRequest.CardPosition(
                position: label,
                name: card.name,
                family: card.arcana.displayName,
                essence: card.keywords,
                messageProfond: meaning,
                spreadInterpretation: "\(orientation). \(card.interpretation.general)"
            )
        }

        guard !cards.isEmpty else {
            throw AIInterpretationError.noCardsResolved
        }

        let userMessage = buildTarotUserMessage(
            spread: reading.spread.title,
            question: reading.question,
            cards: cards,
            drawnCards: reading.cards,
            deck: deck
        )

        return ProxyRequest(
            spread: reading.spread.title,
            question: reading.question,
            deckType: "tarot",
            cards: cards,
            userMessage: userMessage
        )
    }

    // MARK: - Build Oracle Payload

    private func buildOraclePayload(reading: OracleReading, deck: [OracleCard]) throws -> ProxyRequest {
        let cards = reading.cards.enumerated().compactMap { index, drawn -> ProxyRequest.CardPosition? in
            guard let card = drawn.resolve(from: deck) else { return nil }
            let label = index < reading.spread.labels.count ? reading.spread.labels[index] : "Position \(index + 1)"

            return ProxyRequest.CardPosition(
                position: label,
                name: "\(card.number). \(card.name)",
                family: "Oracle du Coeur Cosmique",
                essence: card.keywords,
                messageProfond: card.message,
                spreadInterpretation: card.extendedMeaning
            )
        }

        guard !cards.isEmpty else {
            throw AIInterpretationError.noCardsResolved
        }

        let userMessage = buildOracleUserMessage(
            spread: reading.spread.title,
            question: reading.question,
            cards: cards
        )

        return ProxyRequest(
            spread: reading.spread.title,
            question: reading.question,
            deckType: "oracle",
            cards: cards,
            userMessage: userMessage
        )
    }

    // MARK: - Build User Prompts

    private func buildUserMessage(spread: String, question: String?, cards: [ProxyRequest.CardPosition]) -> String {
        var lines: [String] = []

        lines.append("Tirage : \(spread)")
        if let question, !question.isEmpty {
            lines.append("Question : \(question)")
        }
        lines.append("")

        for card in cards {
            lines.append("--- \(card.position) ---")
            lines.append("Carte : \(card.name)")
            lines.append("Famille : \(card.family)")
            lines.append("Essence : \(card.essence.joined(separator: ", "))")
            lines.append("Message profond : \(card.messageProfond)")
            lines.append("Interprétation positionnelle : \(card.spreadInterpretation)")
            lines.append("")
        }

        lines.append("Fournis une synthèse unifiée de ce tirage.")
        return lines.joined(separator: "\n")
    }

    private func buildTarotUserMessage(
        spread: String,
        question: String?,
        cards: [ProxyRequest.CardPosition],
        drawnCards: [DrawnCard],
        deck: [TarotCard]
    ) -> String {
        var lines: [String] = []

        lines.append("Tirage : \(spread)")
        if let question, !question.isEmpty {
            lines.append("Question : \(question)")
        }
        lines.append("")

        for (index, card) in cards.enumerated() {
            let drawn = index < drawnCards.count ? drawnCards[index] : nil
            let tarotCard = drawn?.resolve(from: deck)
            let orientation = drawn?.isReversed == true ? "Inversée" : "Droite"

            lines.append("--- \(card.position) ---")
            lines.append("Carte : \(card.name)")
            lines.append("Arcane : \(card.family)")
            lines.append("Orientation : \(orientation)")
            lines.append("Mots-clés : \(card.essence.joined(separator: ", "))")
            if let tarotCard {
                lines.append("Sens droit : \(tarotCard.uprightMeaning)")
                lines.append("Sens inversé : \(tarotCard.reversedMeaning)")
                lines.append("Interprétation générale : \(tarotCard.interpretation.general)")
                lines.append("Amour : \(tarotCard.interpretation.love)")
                lines.append("Carrière : \(tarotCard.interpretation.career)")
                lines.append("Spiritualité : \(tarotCard.interpretation.spiritual)")
                if !tarotCard.element.isEmpty {
                    lines.append("Élément : \(tarotCard.element)")
                }
            }
            lines.append("")
        }

        lines.append("Fournis une synthèse unifiée de ce tirage en tenant compte de l'orientation de chaque carte et de sa position.")
        return lines.joined(separator: "\n")
    }

    private func buildOracleUserMessage(
        spread: String,
        question: String?,
        cards: [ProxyRequest.CardPosition]
    ) -> String {
        var lines: [String] = []

        lines.append("Tirage : \(spread)")
        if let question, !question.isEmpty {
            lines.append("Question : \(question)")
        }
        lines.append("")

        for card in cards {
            lines.append("--- \(card.position) ---")
            lines.append("Carte : \(card.name)")
            lines.append("Mots-clés : \(card.essence.joined(separator: ", "))")
            lines.append("Message : \(card.messageProfond)")
            lines.append("Signification étendue : \(card.spreadInterpretation)")
            lines.append("")
        }

        lines.append("Fournis une synthèse unifiée de ce tirage en reliant le message de chaque carte à sa position.")
        return lines.joined(separator: "\n")
    }

    // MARK: - Build Rune Payload

    private func buildRunePayload(reading: RuneReading, deck: [RuneCard]) throws -> ProxyRequest {
        let cards = reading.cards.enumerated().compactMap { index, drawn -> ProxyRequest.CardPosition? in
            guard let card = drawn.resolve(from: deck) else { return nil }
            let label = index < reading.spread.labels.count ? reading.spread.labels[index] : "Position \(index + 1)"

            return ProxyRequest.CardPosition(
                position: label,
                name: "\(card.number). \(card.name) (\(card.letter))",
                family: card.aett.title,
                essence: [card.conceptTraditionnel],
                messageProfond: card.message,
                spreadInterpretation: "\(card.visionCosmique) — \(card.visionCosmiqueDescription)"
            )
        }

        guard !cards.isEmpty else {
            throw AIInterpretationError.noCardsResolved
        }

        let userMessage = buildRuneUserMessage(
            spread: reading.spread.title,
            question: reading.question,
            cards: cards,
            drawnCards: reading.cards,
            deck: deck
        )

        return ProxyRequest(
            spread: reading.spread.title,
            question: reading.question,
            deckType: "rune",
            cards: cards,
            userMessage: userMessage
        )
    }

    private func buildRuneUserMessage(
        spread: String,
        question: String?,
        cards: [ProxyRequest.CardPosition],
        drawnCards: [DrawnRuneCard],
        deck: [RuneCard]
    ) -> String {
        var lines: [String] = []

        lines.append("Tirage Runique : \(spread)")
        if let question, !question.isEmpty {
            lines.append("Question : \(question)")
        }
        lines.append("")

        for (index, card) in cards.enumerated() {
            let runeCard = index < drawnCards.count ? drawnCards[index].resolve(from: deck) : nil

            lines.append("--- \(card.position) ---")
            lines.append("Rune : \(card.name)")
            lines.append("Aett : \(card.family)")
            if let runeCard {
                lines.append("Concept traditionnel : \(runeCard.conceptTraditionnel)")
                lines.append("Vision cosmique : \(runeCard.visionCosmique) — \(runeCard.visionCosmiqueDescription)")
                lines.append("Message : \(runeCard.message)")
            }
            lines.append("")
        }

        lines.append("Fournis une synthèse unifiée de ce tirage runique en reliant la sagesse ancestrale de chaque rune, sa vision cosmique et sa position dans le tirage.")
        return lines.joined(separator: "\n")
    }

    // MARK: - Helpers

    private func quantumInterpretationText(card: QuantumOracleCard, spread: QuantumSpreadType, position: Int) -> String {
        switch spread {
        case .lienDesAmes:
            switch position {
            case 0: return card.interpretation.alphaYou
            case 1: return card.interpretation.betaOther
            case 2: return card.interpretation.linkResult
            default: return ""
            }
        case .chatDeSchrodinger:
            switch position {
            case 0: return card.interpretation.situation
            case 1: return card.interpretation.actionBoxA
            case 2: return card.interpretation.nonActionBoxB
            case 3: return card.interpretation.collapseResult
            default: return ""
            }
        case .sautQuantique:
            switch position {
            case 0: return card.interpretation.gravity
            case 1: return card.interpretation.darkEnergy
            case 2: return card.interpretation.horizon
            case 3: return card.interpretation.wormhole
            case 4: return card.interpretation.newGalaxy
            default: return ""
            }
        }
    }
}
