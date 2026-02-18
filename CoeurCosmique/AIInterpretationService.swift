import Foundation

// MARK: - Proxy Request / Response

private struct ProxyRequest: Encodable {
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

private struct ProxyResponse: Decodable {
    let interpretation: String
}

// MARK: - Errors

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

// MARK: - Service

actor AIInterpretationService {

    static let shared = AIInterpretationService()

    /// Proxy endpoint URL
    private let proxyURL: URL? = URL(string: "https://coeurcosmique-proxy.vercel.app/api/interpret")

    /// Bearer token sent to the proxy for auth
    private let proxyToken: String? = "75FC49FC-55F2-4915-9EBB-65E4B3133D9F"

    // MARK: - Public

    func interpret(reading: QuantumOracleReading, deck: [QuantumOracleCard]) async throws -> String {
        guard let url = proxyURL else {
            throw AIInterpretationError.noEndpoint
        }

        let payload = buildPayload(reading: reading, deck: deck)
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
        return decoded.interpretation
    }

    // MARK: - Build Payload

    private func buildPayload(reading: QuantumOracleReading, deck: [QuantumOracleCard]) -> ProxyRequest {
        let cards = reading.cards.enumerated().compactMap { index, drawn -> ProxyRequest.CardPosition? in
            guard let card = drawn.resolve(from: deck) else { return nil }
            let label = index < reading.spread.labels.count ? reading.spread.labels[index] : "Position \(index + 1)"
            let spreadInterp = interpretationText(card: card, spread: reading.spread, position: index)

            return ProxyRequest.CardPosition(
                position: label,
                name: "\(card.number). \(card.name)",
                family: card.family.title,
                essence: card.essence,
                messageProfond: card.messageProfond,
                spreadInterpretation: spreadInterp
            )
        }

        return ProxyRequest(
            spread: reading.spread.title,
            question: reading.question,
            cards: cards
        )
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
