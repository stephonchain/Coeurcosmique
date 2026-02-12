import Foundation

struct OracleCard: Equatable, Identifiable, Codable, Hashable {
    let id: UUID
    let number: Int
    let name: String
    let keywords: [String]
    let message: String
    let extendedMeaning: String
    let imageName: String

    init(
        id: UUID = UUID(),
        number: Int,
        name: String,
        keywords: [String],
        message: String,
        extendedMeaning: String,
        imageName: String
    ) {
        self.id = id
        self.number = number
        self.name = name
        self.keywords = keywords
        self.message = message
        self.extendedMeaning = extendedMeaning
        self.imageName = imageName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct DrawnOracleCard: Equatable, Identifiable, Codable, Hashable {
    let id: UUID
    let cardID: UUID

    init(card: OracleCard) {
        self.id = UUID()
        self.cardID = card.id
    }

    func resolve(from deck: [OracleCard]) -> OracleCard? {
        deck.first { $0.id == cardID }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
