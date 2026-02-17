import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: AppViewModel
    @StateObject private var moodStore = MoodTrackerStore()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Statistiques")
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicText)
                    
                    Text("Tes insights personnels")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)
                
                // Streak Cards
                HStack(spacing: 12) {
                    // Drawing Streak
                    streakCard(
                        title: "Série de tirages",
                        value: calculateDrawingStreak(),
                        color: .cosmicPurple
                    )
                    
                    // Mood Streak
                    streakCard(
                        title: "Série d'humeur",
                        value: moodStore.currentStreak(),
                        color: .cosmicRose
                    )
                }
                
                // Total Readings Card
                totalReadingsCard
                
                // Top 5 Cards
                topCardsSection
                
                // Weekly Pattern
                weeklyPatternCard
                
                // Monthly Evolution
                monthlyEvolutionCard
                
                // Mood Correlation (if applicable)
                if !moodStore.entries.isEmpty && totalReadings > 0 {
                    moodCorrelationCard
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Streak Card
    
    private func streakCard(title: String, value: Int, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text("\(value)")
                .font(.cosmicTitle(32))
                .foregroundStyle(Color.cosmicText)
            
            Text(title)
                .font(.cosmicCaption(11))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(color.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Total Readings
    
    private var totalReadings: Int {
        viewModel.history.count + viewModel.oracleHistory.count
    }
    
    private var totalReadingsCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "book.fill")
                .font(.system(size: 32))
                .foregroundStyle(.cosmicGold)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(totalReadings)")
                    .font(.cosmicTitle(36))
                    .foregroundStyle(Color.cosmicText)
                
                Text("lecture\(totalReadings > 1 ? "s" : "") totale\(totalReadings > 1 ? "s" : "")")
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            
            Spacer()
        }
        .padding(20)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.cosmicGold.opacity(0.2), lineWidth: 1)
        )
    }
    
    // MARK: - Top Cards Section
    
    private var topCardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top 5 - Cartes les plus tirées")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)
            
            let topCards = calculateTopCards()
            
            if topCards.isEmpty {
                emptyStateCard(
                    icon: "star.fill",
                    message: "Aucune donnée encore.\nFais des tirages pour voir tes statistiques !"
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(Array(topCards.prefix(5).enumerated()), id: \.offset) { index, cardData in
                        topCardRow(
                            rank: index + 1,
                            cardName: cardData.name,
                            count: cardData.count,
                            isOracle: cardData.isOracle
                        )
                    }
                }
            }
        }
    }
    
    private func topCardRow(rank: Int, cardName: String, count: Int, isOracle: Bool) -> some View {
        HStack(spacing: 12) {
            // Rank
            Text("\(rank)")
                .font(.cosmicHeadline(18))
                .foregroundStyle(rank <= 3 ? Color.cosmicGold : Color.cosmicTextSecondary)
                .frame(width: 30)
            
            // Card info
            VStack(alignment: .leading, spacing: 2) {
                Text(cardName)
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicText)
                
                Text(isOracle ? "Oracle" : "Tarot")
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            
            Spacer()
            
            // Count
            Text("\(count)×")
                .font(.cosmicHeadline(16))
                .foregroundStyle(isOracle ? Color.cosmicRose : Color.cosmicPurple)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cosmicCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    (isOracle ? Color.cosmicRose : Color.cosmicPurple).opacity(0.1),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Weekly Pattern
    
    private var weeklyPatternCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pattern hebdomadaire")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)
            
            let weeklyData = calculateWeeklyPattern()
            
            Chart {
                ForEach(weeklyData, id: \.day) { data in
                    BarMark(
                        x: .value("Jour", data.dayName),
                        y: .value("Tirages", data.count)
                    )
                    .foregroundStyle(Color.cosmicPurple)
                }
            }
            .frame(height: 180)
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }
    
    // MARK: - Monthly Evolution
    
    private var monthlyEvolutionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Évolution mensuelle")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)
            
            let monthlyData = calculateMonthlyEvolution()
            
            if !monthlyData.isEmpty {
                Chart {
                    ForEach(monthlyData, id: \.month) { data in
                        LineMark(
                            x: .value("Mois", data.monthName),
                            y: .value("Tirages", data.count)
                        )
                        .foregroundStyle(Color.cosmicGold)
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(
                            x: .value("Mois", data.monthName),
                            y: .value("Tirages", data.count)
                        )
                        .foregroundStyle(Color.cosmicGold)
                    }
                }
                .frame(height: 180)
            } else {
                emptyStateCard(
                    icon: "chart.line.uptrend.xyaxis",
                    message: "Pas encore assez de données"
                )
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }
    
    // MARK: - Mood Correlation
    
    private var moodCorrelationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Corrélation humeur & cartes")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)
            
            Text("Quand tu tires cette carte, ton énergie moyenne est...")
                .font(.cosmicCaption(12))
                .foregroundStyle(Color.cosmicTextSecondary)
            
            let correlations = calculateMoodCorrelations()
            
            if !correlations.isEmpty {
                VStack(spacing: 8) {
                    ForEach(correlations.prefix(3), id: \.cardName) { correlation in
                        HStack(spacing: 12) {
                            Text(correlation.cardName)
                                .font(.cosmicBody(13))
                                .foregroundStyle(Color.cosmicText)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Text(String(format: "%.1f", correlation.avgEnergy))
                                    .font(.cosmicHeadline(16))
                                    .foregroundStyle(.cosmicPurple)
                                Text("/6")
                                    .font(.cosmicCaption(12))
                                    .foregroundStyle(Color.cosmicTextSecondary)
                            }
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.cosmicPurple.opacity(0.08))
                        )
                    }
                }
            } else {
                emptyStateCard(
                    icon: "brain.head.profile",
                    message: "Continue à enregistrer ton humeur pour voir les corrélations !"
                )
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }
    
    // MARK: - Empty State
    
    private func emptyStateCard(icon: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(Color.cosmicTextSecondary.opacity(0.5))
            
            Text(message)
                .font(.cosmicBody(13))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Calculations
    
    private func calculateDrawingStreak() -> Int {
        let allDates = (viewModel.history.map { $0.createdAt } + viewModel.oracleHistory.map { $0.createdAt })
            .sorted(by: >)
        
        guard !allDates.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        for date in allDates {
            let readingDate = Calendar.current.startOfDay(for: date)
            
            if readingDate == currentDate {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if readingDate < currentDate {
                break
            }
        }
        
        return streak
    }
    
    private func calculateTopCards() -> [(name: String, count: Int, isOracle: Bool)] {
        var cardCounts: [String: (count: Int, isOracle: Bool)] = [:]
        
        // Count tarot cards
        for entry in viewModel.history {
            for cardName in entry.cardNames {
                cardCounts[cardName, default: (0, false)].count += 1
            }
        }
        
        // Count oracle cards
        for entry in viewModel.oracleHistory {
            for cardName in entry.cardNames {
                cardCounts[cardName, default: (0, true)] = (cardCounts[cardName]?.count ?? 0 + 1, true)
            }
        }
        
        return cardCounts
            .map { (name: $0.key, count: $0.value.count, isOracle: $0.value.isOracle) }
            .sorted { $0.count > $1.count }
    }
    
    private func calculateWeeklyPattern() -> [(day: Int, dayName: String, count: Int)] {
        var dayCounts: [Int: Int] = [:]
        
        let allDates = viewModel.history.map { $0.createdAt } + viewModel.oracleHistory.map { $0.createdAt }
        
        for date in allDates {
            let weekday = Calendar.current.component(.weekday, from: date)
            dayCounts[weekday, default: 0] += 1
        }
        
        let dayNames = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"]
        
        return (1...7).map { day in
            (day: day, dayName: dayNames[day - 1], count: dayCounts[day] ?? 0)
        }
    }
    
    private func calculateMonthlyEvolution() -> [(month: Int, monthName: String, count: Int)] {
        var monthCounts: [String: Int] = [:]
        
        let allDates = viewModel.history.map { $0.createdAt } + viewModel.oracleHistory.map { $0.createdAt }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yy"
        formatter.locale = Locale(identifier: "fr_FR")
        
        for date in allDates {
            let monthKey = formatter.string(from: date)
            monthCounts[monthKey, default: 0] += 1
        }
        
        return monthCounts
            .map { (month: 0, monthName: $0.key, count: $0.value) }
            .sorted { $0.monthName < $1.monthName }
    }
    
    private func calculateMoodCorrelations() -> [(cardName: String, avgEnergy: Double)] {
        var correlations: [(String, Double)] = []
        
        for entry in moodStore.entries {
            guard let cardName = entry.linkedCardName else { continue }
            
            if let avgEnergy = moodStore.averageEnergyForCard(cardName) {
                correlations.append((cardName, avgEnergy))
            }
        }
        
        return correlations
            .sorted { $0.1 > $1.1 }
            .map { (cardName: $0.0, avgEnergy: $0.1) }
    }
}

#Preview {
    StatisticsView(viewModel: AppViewModel())
}
