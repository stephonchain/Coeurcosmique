import SwiftUI

struct OracleAboutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false

    var body: some View {
        ZStack {
            CosmicBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    // Drag indicator
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)

                    // Oracle icon
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.cosmicRose.opacity(0.3),
                                            Color.cosmicPurple.opacity(0.1),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)

                            Text("♡")
                                .font(.system(size: 56))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.cosmicRose, .cosmicPurple, .cosmicGold],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .scaleEffect(appeared ? 1 : 0.7)
                        .opacity(appeared ? 1 : 0)

                        Text("Oracle Cœur Cosmique")
                            .font(.cosmicTitle(26))
                            .foregroundStyle(Color.cosmicText)
                            .multilineTextAlignment(.center)

                        Text("42 cartes · Un voyage vers l'âme")
                            .font(.cosmicCaption())
                            .foregroundStyle(Color.cosmicRose)
                            .textCase(.uppercase)
                            .kerning(2)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                    // Divider
                    oracleDivider

                    // Origin story
                    VStack(spacing: 16) {
                        sectionTitle("Naissance de l'Oracle")

                        Text("L'Oracle Cœur Cosmique est né de la rencontre entre deux âmes guidées par une même quête de sens : Stéphane et Candice. Porté par l'intuition profonde de Candice, énergéticienne au don lumineux, cet oracle a été créé comme un pont entre le visible et l'invisible — un outil de reconnexion à soi et à l'énergie universelle.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicText.opacity(0.85))
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 30)

                    // Philosophy
                    VStack(spacing: 16) {
                        sectionTitle("Le Cœur Cosmique")

                        Text("Au centre de chaque être se trouve un espace sacré, inaltérable et éternel : le Cœur Cosmique. C'est le fondement même de l'âme, le point de jonction entre ton essence la plus intime et l'immensité de l'Univers. Ce n'est pas un lieu, mais un état — celui de l'alignement profond avec qui tu es vraiment.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicText.opacity(0.85))
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)

                        Text("Cet oracle existe pour t'aider à retrouver ce lien. Chaque carte est une clé, un murmure de l'Univers qui t'invite à revenir vers cette lumière intérieure que la vie quotidienne peut parfois voiler, mais jamais éteindre.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicText.opacity(0.85))
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 40)

                    // Energy & meaning
                    VStack(spacing: 16) {
                        sectionTitle("L'Énergie des 42 Cartes")

                        Text("Les 42 cartes de l'Oracle Cœur Cosmique sont autant de facettes de l'énergie universelle. De l'Humilité à l'Élégance, de la Force à la Grâce, chacune porte un message lumineux et positif — une invitation à explorer ta propre lumière.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicText.opacity(0.85))
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)

                        Text("Elles parlent d'amour, de courage, de transformation et d'éveil. Elles ne prédisent pas l'avenir — elles éclairent le présent. Elles ne jugent pas — elles accompagnent. Leur énergie est celle de la bienveillance cosmique : cette force douce et puissante qui pousse chaque être vers son plein épanouissement.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicText.opacity(0.85))
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 50)

                    // 42
                    VStack(spacing: 16) {
                        sectionTitle("Pourquoi 42 ?")

                        Text("42 est la Réponse à la Grande Question sur la Vie, l'Univers et le Reste — du moins selon Douglas Adams. Nous avons choisi ce nombre comme un clin d'œil à cette quête universelle de sens, avec la conviction que les vraies réponses ne se trouvent pas dans un supercalculateur, mais dans les profondeurs de ton propre cœur.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicText.opacity(0.85))
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 60)

                    // How to use
                    VStack(spacing: 16) {
                        sectionTitle("Comment utiliser l'Oracle")

                        VStack(alignment: .leading, spacing: 14) {
                            usageStep(
                                number: "1",
                                text: "Recentre-toi. Prends quelques respirations profondes et pose une intention claire dans ton cœur."
                            )
                            usageStep(
                                number: "2",
                                text: "Choisis un type de tirage : un message unique pour une guidance rapide, ou un tirage multiple pour une lecture plus profonde."
                            )
                            usageStep(
                                number: "3",
                                text: "Accueille le message avec ouverture. Il n'y a pas de mauvaise carte — chacune est un cadeau de l'Univers."
                            )
                            usageStep(
                                number: "4",
                                text: "Laisse le message résonner en toi. La carte qui t'est destinée porte toujours une vérité que ton cœur reconnaît."
                            )
                        }
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 70)

                    // Closing
                    VStack(spacing: 12) {
                        Text("✦")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.cosmicGold)

                        Text("Que la lumière de ton Cœur Cosmique\nt'accompagne à chaque instant.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicRose)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .italic()
                    }
                    .padding(.vertical, 12)
                    .opacity(appeared ? 1 : 0)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                appeared = true
            }
        }
    }

    // MARK: - Components

    private var oracleDivider: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Color.cosmicDivider).frame(height: 1)
            Text("♡")
                .font(.system(size: 10))
                .foregroundStyle(Color.cosmicRose)
            Rectangle().fill(Color.cosmicDivider).frame(height: 1)
        }
        .padding(.horizontal, 20)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.cosmicHeadline(18))
            .foregroundStyle(
                LinearGradient(
                    colors: [.cosmicRose, .cosmicGold],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }

    private func usageStep(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(number)
                .font(.cosmicNumber(14))
                .foregroundStyle(Color.cosmicRose)
                .frame(width: 24, height: 24)
                .background(
                    Circle().fill(Color.cosmicRose.opacity(0.12))
                )

            Text(text)
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicText.opacity(0.85))
                .lineSpacing(4)
        }
    }
}
