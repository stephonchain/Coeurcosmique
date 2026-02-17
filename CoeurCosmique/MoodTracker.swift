import Foundation

// MARK: - Mood Type

enum MoodType: String, Codable, CaseIterable, Identifiable {
    case joyful = "Joyeux"
    case calm = "Calme"
    case grateful = "Reconnaissant"
    case anxious = "Anxieux"
    case sad = "Triste"
    case angry = "En colère"
    case confused = "Confus"
    case peaceful = "Paisible"
    
    var id: String { rawValue }
    
    var emoji: String {
        switch self {
        case .joyful: return "😊"
        case .calm: return "😌"
        case .grateful: return "🙏"
        case .anxious: return "😰"
        case .sad: return "😢"
        case .angry: return "😠"
        case .confused: return "😕"
        case .peaceful: return "🕊️"
        }
    }
    
    var color: String {
        switch self {
        case .joyful, .grateful: return "cosmicGold"
        case .calm, .peaceful: return "cosmicPurple"
        case .anxious, .confused: return "cosmicTextSecondary"
        case .sad, .angry: return "cosmicRose"
        }
    }
}

// MARK: - Energy Level

enum EnergyLevel: Int, Codable, CaseIterable, Identifiable {
    case veryLow = 0
    case low = 1
    case slightlyLow = 2
    case moderate = 3
    case slightlyHigh = 4
    case high = 5
    case veryHigh = 6
    
    var id: Int { rawValue }
    
    var label: String {
        switch self {
        case .veryLow: return "Très faible"
        case .low: return "Faible"
        case .slightlyLow: return "Légèrement faible"
        case .moderate: return "Modérée"
        case .slightlyHigh: return "Légèrement élevée"
        case .high: return "Élevée"
        case .veryHigh: return "Très élevée"
        }
    }
    
    var emoji: String {
        switch self {
        case .veryLow: return "💤"
        case .low: return "😴"
        case .slightlyLow: return "🙂"
        case .moderate: return "😊"
        case .slightlyHigh: return "✨"
        case .high: return "⚡"
        case .veryHigh: return "🔥"
        }
    }
}

// MARK: - Mood Entry

struct MoodEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let mood: MoodType
    let energy: EnergyLevel
    let note: String?
    let linkedCardName: String? // Optional link to a drawn card
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        mood: MoodType,
        energy: EnergyLevel,
        note: String? = nil,
        linkedCardName: String? = nil
    ) {
        self.id = id
        self.date = date
        self.mood = mood
        self.energy = energy
        self.note = note
        self.linkedCardName = linkedCardName
    }
}

// MARK: - Mood Tracker Store

@MainActor
class MoodTrackerStore: ObservableObject {
    @Published private(set) var entries: [MoodEntry] = []
    
    private let saveKey = "SavedMoodEntries"
    
    init() {
        loadEntries()
    }
    
    // MARK: - CRUD Operations
    
    func addEntry(_ entry: MoodEntry) {
        entries.insert(entry, at: 0)
        saveEntries()
    }
    
    func deleteEntry(_ entry: MoodEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func updateEntry(_ entry: MoodEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    // MARK: - Analytics
    
    func entriesForLast30Days() -> [MoodEntry] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return entries.filter { $0.date >= thirtyDaysAgo }
    }
    
    func averageEnergy(forLast days: Int = 7) -> Double {
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let recentEntries = entries.filter { $0.date >= startDate }
        
        guard !recentEntries.isEmpty else { return 0 }
        
        let total = recentEntries.reduce(0) { $0 + $1.energy.rawValue }
        return Double(total) / Double(recentEntries.count)
    }
    
    func mostCommonMood(forLast days: Int = 7) -> MoodType? {
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let recentEntries = entries.filter { $0.date >= startDate }
        
        let moodCounts = Dictionary(grouping: recentEntries, by: { $0.mood })
            .mapValues { $0.count }
        
        return moodCounts.max(by: { $0.value < $1.value })?.key
    }
    
    func averageEnergyForCard(_ cardName: String) -> Double? {
        let cardEntries = entries.filter { $0.linkedCardName == cardName }
        
        guard !cardEntries.isEmpty else { return nil }
        
        let total = cardEntries.reduce(0) { $0 + $0.energy.rawValue }
        return Double(total) / Double(cardEntries.count)
    }
    
    func currentStreak() -> Int {
        guard !entries.isEmpty else { return 0 }
        
        let sortedEntries = entries.sorted { $0.date > $1.date }
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        for entry in sortedEntries {
            let entryDate = Calendar.current.startOfDay(for: entry.date)
            
            if entryDate == currentDate {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if entryDate < currentDate {
                break
            }
        }
        
        return streak
    }
    
    func hasEntryForToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.contains { Calendar.current.startOfDay(for: $0.date) == today }
    }
    
    // MARK: - Persistence
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) else {
            return
        }
        entries = decoded.sorted { $0.date > $1.date }
    }
}
