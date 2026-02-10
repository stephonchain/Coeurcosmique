import SwiftUI

struct CosmicBackground: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            LinearGradient.cosmicBackgroundGradient
                .ignoresSafeArea()

            // Subtle star field
            Canvas { context, size in
                let starCount = 60
                for i in 0..<starCount {
                    let seed = Double(i * 7919 + 1)
                    let x = (seed.truncatingRemainder(dividingBy: size.width * 3)).truncatingRemainder(dividingBy: size.width)
                    let y = (seed * 1.3).truncatingRemainder(dividingBy: size.height)
                    let brightness = (sin(phase + seed * 0.1) + 1) / 2 * 0.6 + 0.1
                    let starSize = (seed.truncatingRemainder(dividingBy: 2)) + 0.5

                    context.opacity = brightness
                    let rect = CGRect(x: x, y: y, width: starSize, height: starSize)
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(.white)
                    )
                }
            }
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    phase = .pi * 2
                }
            }

            // Soft radial accent
            RadialGradient(
                colors: [
                    Color.cosmicPurple.opacity(0.08),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [
                    Color.cosmicGold.opacity(0.04),
                    Color.clear
                ],
                center: .bottomLeading,
                startRadius: 50,
                endRadius: 350
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    CosmicBackground()
}
