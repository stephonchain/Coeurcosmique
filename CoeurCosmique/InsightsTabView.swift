import SwiftUI

struct InsightsTabView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedSection: InsightsSection = .mood
    
    var body: some View {
        VStack(spacing: 0) {
            // Section Picker
            sectionPicker
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            // Content
            TabView(selection: $selectedSection) {
                MoodTrackerView()
                    .tag(InsightsSection.mood)
                
                StatisticsView(viewModel: viewModel)
                    .tag(InsightsSection.statistics)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    // MARK: - Section Picker
    
    private var sectionPicker: some View {
        HStack(spacing: 0) {
            ForEach(InsightsSection.allCases, id: \.self) { section in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedSection = section
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: section.icon)
                            .font(.system(size: 12))
                        
                        Text(section.title)
                            .font(.cosmicHeadline(14))
                    }
                    .foregroundStyle(
                        selectedSection == section
                            ? Color.cosmicBackground
                            : Color.cosmicTextSecondary
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(
                                selectedSection == section
                                    ? LinearGradient(colors: [.cosmicPurple, .cosmicRose], startPoint: .leading, endPoint: .trailing)
                                    : LinearGradient(colors: [Color.clear], startPoint: .leading, endPoint: .trailing)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule().fill(Color.cosmicCard)
        )
        .overlay(
            Capsule().strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
        )
    }
}

enum InsightsSection: String, CaseIterable {
    case mood = "Humeur"
    case statistics = "Stats"
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .mood: return "face.smiling"
        case .statistics: return "chart.bar"
        }
    }
}

#Preview {
    InsightsTabView(viewModel: AppViewModel())
}
