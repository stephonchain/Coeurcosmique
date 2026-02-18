import Foundation

struct AIInterpretationRequest: Encodable {
    let spread: String
    let question: String?
    let cards: [CardPosition]

    struct CardPosition: Encodable {
        let position: String
        let name: String
        let family: String
        let essence: [String]
        let messageProfond: String
        let spreadInterpretation: String
    }
}

struct AIInterpretationResponse: Decodable {
    let interpretation: String
}

enum AIInterpretationError: LocalizedError {
    case noEndpoint
    case networkError(Error)
    case invalidResponse
    case serverError(String)

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
        }
    }
}

actor AIInterpretationService {

    static let shared = AIInterpretationService()

    /// Backend endpoint that proxies to the AI provider.
    /// Configure via Info.plist key `AI_INTERPRETATION_ENDPOINT`
    /// or set at runtime before first use.
    var endpointURL: URL? = {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "AI_INTERPRETATION_ENDPOINT") as? String,
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }()

    // MARK: - Public

    func interpret(reading: QuantumOracleReading, deck: [QuantumOracleCard]) async throws -> String {
        guard let url = endpointURL else {
            throw AIInterpretationError.noEndpoint
        }

        let request = buildRequest(reading: reading, deck: deck)
        let body = try JSONEncoder().encode(request)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        urlRequest.timeoutInterval = 30

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
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

        let decoded = try JSONDecoder().decode(AIInterpretationResponse.self, from: data)
        return decoded.interpretation
    }

    // MARK: - Build prompt payload

    private func buildRequest(reading: QuantumOracleReading, deck: [QuantumOracleCard]) -> AIInterpretationRequest {
        let cards = reading.cards.enumerated().compactMap { index, drawn -> AIInterpretationRequest.CardPosition? in
            guard let card = drawn.resolve(from: deck) else { return nil }
            let label = index < reading.spread.labels.count ? reading.spread.labels[index] : ""
            let spreadInterp = interpretationText(card: card, spread: reading.spread, position: index)

            return AIInterpretationRequest.CardPosition(
                position: label,
                name: "\(card.number). \(card.name)",
                family: card.family.title,
                essence: card.essence,
                messageProfond: card.messageProfond,
                spreadInterpretation: spreadInterp
            )
        }

        return AIInterpretationRequest(
            spread: reading.spread.title,
            question: reading.question,
            cards: cards
        )
    }

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
