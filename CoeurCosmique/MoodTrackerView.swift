import SwiftUI
import Charts

struct MoodTrackerView: View {
    @StateObject private var store = MoodTrackerStore()
    @State private var showAddEntry = false
    @State private var selectedMood: MoodType = .joyful
    @State private var selectedEnergy: EnergyLevel = .moderate
    @State private var entryNote: String = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Humeur & Énergie")
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicText)
                    
                    Text("Suis ton état émotionnel")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)
                
                // Today's Entry Card
                if store.hasEntryForToday() {
                    todayCompleteCard
                } else {
                    quickAddCard
                }
                
                // Streak Card
                if store.currentStreak() > 0 {
                    streakCard
                }
                
                // Analytics Overview
                analyticsOverviewCard
                
                // 30-Day History Chart
                if !store.entriesForLast30Days().isEmpty {
                    energyChartCard
                }
                
                // Recent Entries
                if !store.entries.isEmpty {
                    recentEntriesSection
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showAddEntry) {
            addEntrySheet
        }
    }
    
    // MARK: - Quick Add Card
    
    private var quickAddCard: some View {
        VStack(spacing: 16) {
            Text("Comment te sens-tu aujourd'hui ?")
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicText)
            
            Button {
                showAddEntry = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                    Text("Ajouter une entrée")
                        .font(.cosmicHeadline(15))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [.cosmicPurple, .cosmicRose],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .glow(.cosmicPurple, radius: 8)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .cosmicCard(cornerRadius: 16)
    }
    
    // MARK: - Today Complete Card
    
    private var todayCompleteCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.cosmicGold)
                
                Text("Entrée d'aujourd'hui enregistrée")
                    .font(.cosmicHeadline(15))
                    .foregroundStyle(Color.cosmicText)
                
                Spacer()
            }
            
            if let todayEntry = store.entries.first(where: {
                Calendar.current.isDateInToday($0.date)
            }) {
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text(todayEntry.mood.emoji)
                            .font(.system(size: 32))
                        Text(todayEntry.mood.rawValue)
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                    
                    Divider()
                        .frame(height: 40)
                    
                    VStack(spacing: 4) {
                        Text(todayEntry.energy.emoji)
                            .font(.system(size: 32))
                        Text("Énergie \(todayEntry.energy.rawValue)/6")
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.cosmicGold.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Streak Card
    
    private var streakCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 24))
                .foregroundStyle(Color.cosmicGold)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(store.currentStreak()) jour\(store.currentStreak() > 1 ? "s" : "") consécutif\(store.currentStreak() > 1 ? "s" : "")")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)
                
                Text("Continue comme ça ! 🎉")
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            
            Spacer()
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.cosmicGold.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Analytics Overview
    
    private var analyticsOverviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Aperçu - 7 derniers jours")
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicText)
            
            HStack(spacing: 16) {
                // Average Energy
                VStack(spacing: 8) {
                    Text(String(format: "%.1f", store.averageEnergy()))
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicPurple)
                    
                    Text("Énergie moyenne")
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cosmicPurple.opacity(0.1))
                )
                
                // Most Common Mood
                if let commonMood = store.mostCommonMood() {
                    VStack(spacing: 8) {
                        Text(commonMood.emoji)
                            .font(.system(size: 32))
                        
                        Text("Humeur fréquente")
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.cosmicRose.opacity(0.1))
                    )
                }
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }
    
    // MARK: - Energy Chart
    
    private var energyChartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Évolution de l'énergie")
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicText)
            
            let entries = store.entriesForLast30Days().reversed()
            
            Chart {
                ForEach(entries) { entry in
                    LineMark(
                        x: .value("Date", entry.date, unit: .day),
                        y: .value("Énergie", entry.energy.rawValue)
                    )
                    .foregroundStyle(Color.cosmicPurple)
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Date", entry.date, unit: .day),
                        y: .value("Énergie", entry.energy.rawValue)
                    )
                    .foregroundStyle(Color.cosmicPurple)
                }
            }
            .chartYScale(domain: 0...6)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.day().month(), centered: true)
                }
            }
            .frame(height: 180)
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }
    
    // MARK: - Recent Entries
    
    private var recentEntriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Historique")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)
            
            LazyVStack(spacing: 10) {
                ForEach(store.entries.prefix(10)) { entry in
                    entryRow(entry)
                }
            }
        }
    }
    
    private func entryRow(_ entry: MoodEntry) -> some View {
        HStack(spacing: 12) {
            // Date
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.date, style: .date)
                    .font(.cosmicBody(13))
                    .foregroundStyle(Color.cosmicText)
                
                Text(entry.date, style: .time)
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            
            Spacer()
            
            // Mood
            HStack(spacing: 6) {
                Text(entry.mood.emoji)
                    .font(.system(size: 20))
                Text(entry.mood.rawValue)
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            
            // Energy
            HStack(spacing: 6) {
                Text(entry.energy.emoji)
                    .font(.system(size: 20))
                Text("\(entry.energy.rawValue)/6")
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cosmicCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
    
    // MARK: - Add Entry Sheet
    
    private var addEntrySheet: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Mood Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Comment te sens-tu ?")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(Color.cosmicText)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 12) {
                            ForEach(MoodType.allCases) { mood in
                                Button {
                                    selectedMood = mood
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(mood.emoji)
                                            .font(.system(size: 28))
                                        Text(mood.rawValue)
                                            .font(.cosmicCaption(10))
                                            .foregroundStyle(Color.cosmicTextSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedMood == mood ? Color.cosmicRose.opacity(0.2) : Color.cosmicCard)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(
                                                selectedMood == mood ? Color.cosmicRose : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Energy Slider
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Niveau d'énergie")
                                .font(.cosmicHeadline(16))
                                .foregroundStyle(Color.cosmicText)
                            
                            Spacer()
                            
                            Text(selectedEnergy.emoji)
                                .font(.system(size: 24))
                        }
                        
                        VStack(spacing: 8) {
                            Slider(value: Binding(
                                get: { Double(selectedEnergy.rawValue) },
                                set: { selectedEnergy = EnergyLevel(rawValue: Int($0)) ?? .moderate }
                            ), in: 0...6, step: 1)
                            .tint(.cosmicPurple)
                            
                            HStack {
                                Text("Faible")
                                    .font(.cosmicCaption(11))
                                    .foregroundStyle(Color.cosmicTextSecondary)
                                Spacer()
                                Text("Élevée")
                                    .font(.cosmicCaption(11))
                                    .foregroundStyle(Color.cosmicTextSecondary)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cosmicCard)
                        )
                    }
                    
                    // Optional Note
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Note (optionnel)")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(Color.cosmicText)
                        
                        TextField("Comment te sens-tu ?", text: $entryNote, axis: .vertical)
                            .lineLimit(3...6)
                            .font(.cosmicBody(14))
                            .foregroundStyle(Color.cosmicText)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cosmicCard)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.cosmicBackground)
            .navigationTitle("Nouvelle entrée")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        showAddEntry = false
                    }
                    .foregroundStyle(Color.cosmicTextSecondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        saveEntry()
                    }
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicPurple)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func saveEntry() {
        let entry = MoodEntry(
            mood: selectedMood,
            energy: selectedEnergy,
            note: entryNote.isEmpty ? nil : entryNote
        )
        
        store.addEntry(entry)
        
        // Reset
        selectedMood = .joyful
        selectedEnergy = .moderate
        entryNote = ""
        showAddEntry = false
    }
}

#Preview {
    MoodTrackerView()
}
