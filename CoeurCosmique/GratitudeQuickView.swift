import SwiftUI

struct GratitudeQuickView: View {
    @StateObject private var store = GratitudeStore()
    @Binding var isPresented: Bool
    @State private var gratitudes: [String] = ["", "", ""]
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cosmicBackground
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header Icon
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.cosmicGold.opacity(0.2), .cosmicGold.opacity(0.05)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 36))
                                    .foregroundStyle(Color.cosmicGold)
                            }
                            
                            Text("3 gratitudes du jour")
                                .font(.cosmicTitle(24))
                                .foregroundStyle(Color.cosmicText)
                            
                            Text("Prends un moment pour reconnaître les belles choses de ta journée")
                                .font(.cosmicBody(14))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .padding(.top, 8)
                        
                        // 3 Gratitude Fields
                        VStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { index in
                                gratitudeField(index: index)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Streak Display
                        if store.currentStreak() > 0 {
                            streakCard
                        }
                        
                        // Save Button
                        Button {
                            saveGratitudes()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16))
                                Text("Enregistrer")
                                    .font(.cosmicHeadline(16))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: [.cosmicGold, .cosmicGold.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .glow(.cosmicGold, radius: 8)
                        }
                        .buttonStyle(.plain)
                        .disabled(gratitudes.allSatisfy { $0.isEmpty })
                        .opacity(gratitudes.anyNotEmpty ? 1 : 0.6)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Gratitude")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }
            }
            .overlay {
                if showSuccess {
                    successOverlay
                }
            }
        }
    }
    
    // MARK: - Gratitude Field
    
    private func gratitudeField(index: Int) -> some View {
        HStack(spacing: 12) {
            // Number badge
            Text("\(index + 1)")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicGold)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.cosmicGold.opacity(0.15))
                )
            
            // Text field
            TextField("Je suis reconnaissant·e pour...", text: $gratitudes[index])
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicText)
                .textFieldStyle(.plain)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cosmicCard)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            !gratitudes[index].isEmpty ? Color.cosmicGold.opacity(0.3) : Color.clear,
                            lineWidth: 1
                        )
                )
        }
    }
    
    // MARK: - Streak Card
    
    private var streakCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color.cosmicGold)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(store.currentStreak()) jour\(store.currentStreak() > 1 ? "s" : "") consécutif\(store.currentStreak() > 1 ? "s" : "")")
                    .font(.cosmicHeadline(15))
                    .foregroundStyle(Color.cosmicText)
                
                Text("Continue comme ça ! 💫")
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cosmicGold.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.cosmicGold.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Success Overlay
    
    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.cosmicGold)
                
                Text("Gratitudes enregistrées ✨")
                    .font(.cosmicTitle(20))
                    .foregroundStyle(.white)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cosmicCard)
                    .shadow(color: .black.opacity(0.3), radius: 20)
            )
        }
        .transition(.opacity)
    }
    
    // MARK: - Actions
    
    private func saveGratitudes() {
        let validGratitudes = gratitudes.filter { !$0.isEmpty }
        guard !validGratitudes.isEmpty else { return }
        
        store.addMultiple(validGratitudes)
        
        // Show success
        withAnimation {
            showSuccess = true
        }
        
        // Dismiss after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation {
                showSuccess = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPresented = false
            }
        }
    }
}

// MARK: - Helper Extension

extension Array where Element == String {
    var anyNotEmpty: Bool {
        contains { !$0.isEmpty }
    }
}

#Preview {
    GratitudeQuickView(isPresented: .constant(true))
}
