import SwiftUI

// MARK: - Image Loader (handles Wikimedia User-Agent + caching)

@MainActor
final class CardImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false

    private static let cache = NSCache<NSString, UIImage>()

    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "User-Agent": "CoeurCosmique/1.0 (iOS; Tarot App)"
        ]
        return URLSession(configuration: config)
    }()

    func load(from urlString: String) {
        let key = urlString as NSString
        if let cached = Self.cache.object(forKey: key) {
            self.image = cached
            return
        }

        guard let url = URL(string: urlString) else { return }
        isLoading = true

        Task {
            do {
                let (data, _) = try await Self.session.data(from: url)
                if let loaded = UIImage(data: data) {
                    Self.cache.setObject(loaded, forKey: key)
                    self.image = loaded
                }
            } catch {}
            self.isLoading = false
        }
    }
}

// MARK: - Card Image (loads from URL)

struct CardImage: View {
    let url: String?
    var size: TarotCardFront.CardSize = .medium
    @StateObject private var loader = CardImageLoader()

    var body: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if loader.isLoading {
                ProgressView()
                    .tint(Color.cosmicGold)
            } else {
                fallbackView
            }
        }
        .onAppear {
            if let url { loader.load(from: url) }
        }
    }

    private var fallbackView: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.cosmicPurple.opacity(0.3), Color.cosmicCard],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Text("✦")
                    .font(.system(size: size == .large ? 40 : size == .medium ? 28 : 18))
                    .foregroundStyle(Color.cosmicGold.opacity(0.5))
            )
    }
}

// MARK: - Card Front (showing card image)

struct TarotCardFront: View {
    let card: TarotCard
    let isReversed: Bool
    var size: CardSize = .medium

    enum CardSize {
        case small, medium, large

        var width: CGFloat {
            switch self {
            case .small: return 100
            case .medium: return 140
            case .large: return 220
            }
        }

        var height: CGFloat { width * 1.6 }

        var titleFont: Font {
            switch self {
            case .small: return .cosmicCaption(10)
            case .medium: return .cosmicCaption(12)
            case .large: return .cosmicHeadline(16)
            }
        }
    }

    var body: some View {
        ZStack {
            // Card border
            RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                .fill(Color.cosmicCard)
                .overlay(
                    RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.cosmicGold.opacity(0.5),
                                    Color.cosmicGold.opacity(0.2),
                                    Color.cosmicGold.opacity(0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )

            // Card image
            CardImage(url: card.imageURL, size: size)
                .clipShape(RoundedRectangle(cornerRadius: size == .large ? 12 : 8))
                .padding(size == .large ? 8 : 5)

            // Bottom name overlay
            VStack {
                Spacer()

                VStack(spacing: 1) {
                    Text(card.name)
                        .font(size.titleFont)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    if isReversed {
                        Text("Inversée")
                            .font(.cosmicCaption(size == .large ? 10 : 7))
                            .foregroundStyle(Color.cosmicRose)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, size == .large ? 7 : 4)
                .frame(maxWidth: .infinity)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: size == .large ? 16 : 12,
                        bottomTrailingRadius: size == .large ? 16 : 12,
                        topTrailingRadius: 0
                    )
                )
            }
        }
        .frame(width: size.width, height: size.height)
        .rotationEffect(isReversed ? .degrees(180) : .zero)
        .shadow(color: cardGlowColor.opacity(0.3), radius: 12)
    }

    private var cardGlowColor: Color {
        switch card.arcana {
        case .major: return .cosmicGold
        case .cups: return .blue
        case .wands: return .orange
        case .swords: return .cyan
        case .pentacles: return .green
        }
    }
}

// MARK: - Card Back (face down)

struct TarotCardBack: View {
    var size: TarotCardFront.CardSize = .medium

    var body: some View {
        Image("card-back")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: size == .large ? 16 : 12))
            .overlay(
                RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                    .strokeBorder(
                        LinearGradient.cosmicGoldGradient,
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color.cosmicPurple.opacity(0.3), radius: 8)
    }
}

// MARK: - Flippable Card

struct FlippableTarotCard: View {
    let card: TarotCard
    let isReversed: Bool
    @Binding var isFlipped: Bool
    var size: TarotCardFront.CardSize = .medium
    var onFullScreen: (() -> Void)? = nil

    var body: some View {
        ZStack {
            TarotCardBack(size: size)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )

            TarotCardFront(card: card, isReversed: isReversed, size: size)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .onTapGesture {
            if isFlipped, let onFullScreen {
                onFullScreen()
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isFlipped.toggle()
                }
            }
        }
    }
}

// MARK: - Collection Grid Card

struct CollectionCardView: View {
    let card: TarotCard

    var body: some View {
        TarotCardFront(card: card, isReversed: false, size: .small)
    }
}

#Preview("Card Front") {
    ZStack {
        CosmicBackground()
        TarotCardFront(
            card: TarotDeck.majorArcana[17],
            isReversed: false,
            size: .large
        )
    }
}

#Preview("Card Back") {
    ZStack {
        CosmicBackground()
        TarotCardBack(size: .large)
    }
}
