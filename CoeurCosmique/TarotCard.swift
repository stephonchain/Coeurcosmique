import Foundation

struct TarotCard: Equatable, Identifiable, Codable, Hashable {
    enum Arcana: String, Codable, CaseIterable, Hashable {
        case major
        case cups
        case wands
        case swords
        case pentacles

        var displayName: String {
            switch self {
            case .major: return "Arcanes Majeurs"
            case .cups: return "Coupes"
            case .wands: return "Bâtons"
            case .swords: return "Épées"
            case .pentacles: return "Deniers"
            }
        }

        var symbol: String {
            switch self {
            case .major: return "✦"
            case .cups: return "🏆"
            case .wands: return "🪄"
            case .swords: return "⚔️"
            case .pentacles: return "⭐"
            }
        }
    }

    struct Interpretation: Equatable, Codable, Hashable {
        let general: String
        let love: String
        let career: String
        let spiritual: String
    }

    let id: UUID
    let number: Int
    let name: String
    let arcana: Arcana
    let keywords: [String]
    let uprightMeaning: String
    let reversedMeaning: String
    let interpretation: Interpretation
    let imageName: String

    init(
        id: UUID = UUID(),
        number: Int,
        name: String,
        arcana: Arcana,
        keywords: [String],
        uprightMeaning: String,
        reversedMeaning: String,
        interpretation: Interpretation,
        imageName: String = ""
    ) {
        self.id = id
        self.number = number
        self.name = name
        self.arcana = arcana
        self.keywords = keywords
        self.uprightMeaning = uprightMeaning
        self.reversedMeaning = reversedMeaning
        self.interpretation = interpretation
        self.imageName = imageName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var romanNumeral: String {
        let numerals = ["0", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X",
                        "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI"]
        guard arcana == .major, number >= 0, number < numerals.count else {
            return "\(number)"
        }
        return numerals[number]
    }
}

struct DrawnCard: Equatable, Identifiable, Codable, Hashable {
    let id: UUID
    let cardID: UUID
    let isReversed: Bool

    init(card: TarotCard, isReversed: Bool) {
        self.id = UUID()
        self.cardID = card.id
        self.isReversed = isReversed
    }

    func resolve(from deck: [TarotCard]) -> TarotCard? {
        deck.first { $0.id == cardID }
    }

    func interpretation(from deck: [TarotCard]) -> String {
        guard let card = resolve(from: deck) else { return "" }
        return isReversed ? card.reversedMeaning : card.uprightMeaning
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
