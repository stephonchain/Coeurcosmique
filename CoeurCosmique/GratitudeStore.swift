import Foundation

// MARK: - Gratitude Entry

struct GratitudeEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let text: String
    let createdAt: Date
    
    init(id: UUID = UUID(), text: String, createdAt: Date = Date()) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
    }
}

// MARK: - Gratitude Store

@MainActor
class GratitudeStore: ObservableObject {
    @Published private(set) var entries: [GratitudeEntry] = []
    
    private let saveKey = "SavedGratitudeEntries"
    
    init() {
        loadEntries()
    }
    
    // MARK: - CRUD Operations
    
    func add(_ text: String) {
        let entry = GratitudeEntry(text: text)
        entries.insert(entry, at: 0)
        saveEntries()
    }
    
    func addMultiple(_ texts: [String]) {
        for text in texts where !text.isEmpty {
            let entry = GratitudeEntry(text: text)
            entries.insert(entry, at: 0)
        }
        saveEntries()
    }
    
    func delete(_ entry: GratitudeEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    // MARK: - Analytics
    
    func currentStreak() -> Int {
        guard !entries.isEmpty else { return 0 }
        
        let sortedEntries = entries.sorted { $0.createdAt > $1.createdAt }
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        for entry in sortedEntries {
            let entryDate = Calendar.current.startOfDay(for: entry.createdAt)
            
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
        return entries.contains { Calendar.current.startOfDay(for: $0.createdAt) == today }
    }
    
    func todayEntries() -> [GratitudeEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.filter { Calendar.current.startOfDay(for: $0.createdAt) == today }
    }
    
    // MARK: - Persistence
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([GratitudeEntry].self, from: data) else {
            return
        }
        entries = decoded.sorted { $0.createdAt > $1.createdAt }
    }
}
