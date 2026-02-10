import Foundation

public struct TarotCard: Equatable, Identifiable, Codable {
    public enum Arcana: String, Codable, CaseIterable {
        case major
        case cups
        case wands
        case swords
        case pentacles

        public var displayName: String {
            switch self {
            case .major: return "Arcanes Majeurs"
            case .cups: return "Coupes"
            case .wands: return "Bâtons"
            case .swords: return "Épées"
            case .pentacles: return "Deniers"
            }
        }
    }

    public struct Interpretation: Equatable, Codable {
        public let general: String
        public let love: String
        public let career: String
        public let spiritual: String

        public init(general: String, love: String, career: String, spiritual: String) {
            self.general = general
            self.love = love
            self.career = career
            self.spiritual = spiritual
        }
    }

    public let id: UUID
    public let number: Int
    public let name: String
    public let arcana: Arcana
    public let keywords: [String]
    public let uprightMeaning: String
    public let reversedMeaning: String
    public let interpretation: Interpretation

    public init(
        id: UUID = UUID(),
        number: Int,
        name: String,
        arcana: Arcana,
        keywords: [String],
        uprightMeaning: String,
        reversedMeaning: String,
        interpretation: Interpretation
    ) {
        self.id = id
        self.number = number
        self.name = name
        self.arcana = arcana
        self.keywords = keywords
        self.uprightMeaning = uprightMeaning
        self.reversedMeaning = reversedMeaning
        self.interpretation = interpretation
    }
}

public struct DrawnCard: Equatable, Identifiable {
    public let id: UUID
    public let card: TarotCard
    public let isReversed: Bool

    public init(card: TarotCard, isReversed: Bool) {
        self.id = UUID()
        self.card = card
        self.isReversed = isReversed
    }

    public var interpretation: String {
        isReversed ? card.reversedMeaning : card.uprightMeaning
    }
}
