import Foundation

// MARK: - Anthropic API Types

private struct AnthropicRequest: Encodable {
    let model: String
    let max_tokens: Int
    let system: String
    let messages: [Message]

    struct Message: Encodable {
        let role: String
        let content: String
    }
}

private struct AnthropicResponse: Decodable {
    let content: [ContentBlock]

    struct ContentBlock: Decodable {
        let type: String
        let text: String?
    }
}

// MARK: - Errors

enum AIInterpretationError: LocalizedError {
    case noAPIKey
    case networkError(Error)
    case invalidResponse
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "Clé API non configurée."
        case .networkError(let error):
            return "Erreur réseau : \(error.localizedDescription)"
        case .invalidResponse:
            return "Réponse invalide du serveur."
        case .serverError(let message):
            return message
        }
    }
}

// MARK: - Service

actor AIInterpretationService {

    static let shared = AIInterpretationService()

    private static let apiURL = URL(string: "https://api.anthropic.com/v1/messages")!
    private static let model = "claude-haiku-4-5-20251001"
    private static let anthropicVersion = "2023-06-01"

    /// API key loaded from Info.plist key `ANTHROPIC_API_KEY`
    private let apiKey: String? = {
        Bundle.main.object(forInfoDictionaryKey: "ANTHROPIC_API_KEY") as? String
    }()

    // MARK: - Public

    func interpret(reading: QuantumOracleReading, deck: [QuantumOracleCard]) async throws -> String {
        guard let key = apiKey, !key.isEmpty else {
            throw AIInterpretationError.noAPIKey
        }

        let userPrompt = buildUserPrompt(reading: reading, deck: deck)

        let body = AnthropicRequest(
            model: Self.model,
            max_tokens: 1024,
            system: Self.systemPrompt,
            messages: [
                .init(role: "user", content: userPrompt)
            ]
        )

        var request = URLRequest(url: Self.apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "x-api-key")
        request.setValue(Self.anthropicVersion, forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONEncoder().encode(body)
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

        let decoded = try JSONDecoder().decode(AnthropicResponse.self, from: data)
        guard let text = decoded.content.first(where: { $0.type == "text" })?.text else {
            throw AIInterpretationError.invalidResponse
        }
        return text
    }

    // MARK: - System Prompt

    private static let systemPrompt = """
    Tu es l'Oracle du Lien Quantique, un guide spirituel et intuitif qui interprète les tirages \
    de l'Oracle de l'Intrication Quantique dans l'application Cœur Cosmique.

    Ton rôle est de fournir une synthèse unifiée d'un tirage en reliant :
    1. Le sens profond de chaque carte tirée
    2. La position de chaque carte dans le tirage (et ce que cette position représente)
    3. La question ou intention du consultant (si elle est fournie)

    Règles :
    - Réponds en français, avec un ton bienveillant, poétique mais accessible.
    - Tutoie le consultant.
    - Fais le lien entre les cartes : montre comment elles dialoguent entre elles.
    - Si une question est posée, ancre ton interprétation autour de cette question.
    - Si aucune question n'est posée, offre une guidance générale.
    - Utilise le vocabulaire quantique (intrication, superposition, fréquence, vibration, observateur) \
    naturellement, sans forcer.
    - Ne répète pas les informations mot pour mot, synthétise et enrichis.
    - Termine par un conseil actionnable ou une invitation à la réflexion.
    - Reste concis : 150 à 250 mots maximum.
    - N'utilise pas d'émojis.
    """

    // MARK: - Build User Prompt

    private func buildUserPrompt(reading: QuantumOracleReading, deck: [QuantumOracleCard]) -> String {
        var lines: [String] = []

        lines.append("Tirage : \(reading.spread.title)")
        if let q = reading.question, !q.isEmpty {
            lines.append("Question : \(q)")
        }
        lines.append("")

        for (index, drawn) in reading.cards.enumerated() {
            guard let card = drawn.resolve(from: deck) else { continue }
            let label = index < reading.spread.labels.count ? reading.spread.labels[index] : "Position \(index + 1)"
            let spreadInterp = interpretationText(card: card, spread: reading.spread, position: index)

            lines.append("--- \(label) ---")
            lines.append("Carte : \(card.number). \(card.name)")
            lines.append("Famille : \(card.family.title)")
            lines.append("Essence : \(card.essence.joined(separator: ", "))")
            lines.append("Message profond : \(card.messageProfond)")
            lines.append("Interprétation positionnelle : \(spreadInterp)")
            lines.append("")
        }

        lines.append("Fournis une synthèse unifiée de ce tirage.")
        return lines.joined(separator: "\n")
    }

    // MARK: - Helpers

    private func interpretationText(card: QuantumOracleCard, spread: QuantumSpreadType, position: Int) -> String {
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
