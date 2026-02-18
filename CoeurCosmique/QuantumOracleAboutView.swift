import SwiftUI

struct QuantumOracleAboutView: View {
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
                                            Color.cosmicPurple.opacity(0.3),
                                            Color.cosmicRose.opacity(0.1),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)

                            Text("∞")
                                .font(.system(size: 56))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.cosmicPurple, .cosmicRose, .cosmicGold],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .scaleEffect(appeared ? 1 : 0.7)
                        .opacity(appeared ? 1 : 0)

                        Text("Oracle du Lien Quantique")
                            .font(.cosmicTitle(26))
                            .foregroundStyle(Color.cosmicText)
                            .multilineTextAlignment(.center)

                        Text("42 cartes · 6 familles cosmiques")
                            .font(.cosmicCaption())
                            .foregroundStyle(Color.cosmicPurple)
                            .textCase(.uppercase)
                            .kerning(2)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                    // Divider
                    quantumDivider

                    // Genesis
                    VStack(spacing: 16) {
                        sectionTitle("La Genèse de l'Intrication")

                        Text("Au commencement, il n'y avait que la Singularité : un point de conscience pure contenant en lui toutes les âmes, tous les mondes et toutes les histoires possibles. Nous étions Un. Puis vint le Grand Souffle — le Big Bang — et l'Un est devenu le Multiple.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicText.opacity(0.85))
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)

                        Text("Mais dans cette explosion originelle, une loi secrète a été gravée dans la structure même de la réalité : la Loi de l'Intrication Quantique. Deux particules ayant interagi une fois restent liées à jamais, peu importe la distance. Le lien est absolu, immédiat et éternel.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicText.opacity(0.85))
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 30)

                    // The three pillars
                    VStack(spacing: 16) {
                        sectionTitle("La Science de l'Âme")

                        VStack(alignment: .leading, spacing: 14) {
                            pillar(
                                symbol: "◈",
                                title: "Non-Localité",
                                text: "La conscience est un champ qui s'étend au-delà du corps. Vos mains imprègnent les cartes de votre signature vibratoire. Vous ne tirez jamais une carte par hasard."
                            )
                            pillar(
                                symbol: "◇",
                                title: "Superposition",
                                text: "Votre avenir n'est pas une route unique, mais un éventail de chemins possibles. L'Oracle vous montre quelle superposition est en train de devenir dominante."
                            )
                            pillar(
                                symbol: "⟡",
                                title: "Effet Observateur",
                                text: "En consultant l'Oracle, vous devenez l'Observateur Conscient de votre vie. En voyant la dynamique en jeu, vous modifiez déjà le résultat par votre prise de conscience."
                            )
                        }
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 40)

                    // The 6 families
                    VStack(spacing: 16) {
                        sectionTitle("Les 6 Familles Cosmiques")

                        VStack(alignment: .leading, spacing: 14) {
                            familyRow(
                                number: "I",
                                title: "Lois Fondamentales",
                                cards: "1–7",
                                description: "Les principes immuables de l'univers. La physique de Dieu."
                            )
                            familyRow(
                                number: "II",
                                title: "Cosmologie de l'Âme",
                                cards: "8–14",
                                description: "Votre paysage intérieur, les grottes et sommets de la psyché."
                            )
                            familyRow(
                                number: "III",
                                title: "Paradoxes Temporels",
                                cards: "15–21",
                                description: "Le temps est élastique. Cycles, synchronicité et timing divin."
                            )
                            familyRow(
                                number: "IV",
                                title: "Conscience Multidimensionnelle",
                                cards: "22–28",
                                description: "Identité, mission et pouvoir personnel. Incarne ta lumière."
                            )
                            familyRow(
                                number: "V",
                                title: "Anomalies Cosmiques",
                                cards: "29–35",
                                description: "L'inattendu. Miracles, ruptures de patterns et cadeaux cachés."
                            )
                            familyRow(
                                number: "VI",
                                title: "Forces de Liaison",
                                cards: "36–42",
                                description: "L'amour et l'interaction. La chimie entre les âmes."
                            )
                        }
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 50)

                    // The three spreads
                    VStack(spacing: 16) {
                        sectionTitle("Les 3 Protocoles de Tirage")

                        VStack(alignment: .leading, spacing: 14) {
                            spreadRow(
                                cards: "3",
                                title: "L'Intrication des Âmes",
                                subtitle: "Le Scanner Relationnel",
                                description: "Comprendre ce qui se joue entre vous et une autre personne. Révèle les énergies invisibles de la relation."
                            )
                            spreadRow(
                                cards: "4",
                                title: "Le Chat de Schrödinger",
                                subtitle: "La Matrice de Choix",
                                description: "Face à un dilemme ou un choix binaire. Ouvre les deux boîtes de possibles pour voir ce qu'il y a dedans."
                            )
                            spreadRow(
                                cards: "5",
                                title: "Le Saut Quantique",
                                subtitle: "La Flèche d'Évolution",
                                description: "Pour les grandes transitions de vie. Dessine la trajectoire de votre âme du point le plus bas au plus haut."
                            )
                        }
                    }
                    .padding(20)
                    .cosmicCard()
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 60)

                    // Ritual
                    VStack(spacing: 16) {
                        sectionTitle("Le Calibrage du Spin")

                        Text("Avant d'interroger l'Oracle, synchronisez votre fréquence avec celle de l'Univers.")
                            .font(.cosmicBody(14))
                            .foregroundStyle(Color.cosmicTextSecondary)
                            .multilineTextAlignment(.center)

                        VStack(alignment: .leading, spacing: 14) {
                            usageStep(
                                number: "1",
                                text: "L'Arrêt du Temps — Respirez profondément, posez vos mains sur le paquet. Seul existe cet instant."
                            )
                            usageStep(
                                number: "2",
                                text: "La Descente dans le Cœur — Visualisez votre conscience descendre vers votre Cœur Cosmique, un Pulsar émettant un champ magnétique puissant."
                            )
                            usageStep(
                                number: "3",
                                text: "L'Intention Vibratoire — Formulez votre question avec clarté et connexion. L'Univers répond aux vibrations, pas aux mots."
                            )
                            usageStep(
                                number: "4",
                                text: "Le Mélange — Laissez vos mains agir sans réfléchir. Elles sont guidées par votre magnétisme. Tirez les cartes qui « collent » à vos doigts."
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

                        Text("La réponse n'est pas dans la carte.\nLa carte n'est que la clé.\nLa réponse est, et a toujours été, en vous.")
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicPurple)
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

    private var quantumDivider: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Color.cosmicDivider).frame(height: 1)
            Text("∞")
                .font(.system(size: 10))
                .foregroundStyle(Color.cosmicPurple)
            Rectangle().fill(Color.cosmicDivider).frame(height: 1)
        }
        .padding(.horizontal, 20)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.cosmicHeadline(18))
            .foregroundStyle(
                LinearGradient(
                    colors: [.cosmicPurple, .cosmicGold],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }

    private func pillar(symbol: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(symbol)
                .font(.system(size: 16))
                .foregroundStyle(Color.cosmicPurple)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.cosmicHeadline(14))
                    .foregroundStyle(Color.cosmicText)

                Text(text)
                    .font(.cosmicBody(13))
                    .foregroundStyle(Color.cosmicText.opacity(0.8))
                    .lineSpacing(4)
            }
        }
    }

    private func familyRow(number: String, title: String, cards: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(number)
                .font(.cosmicNumber(12))
                .foregroundStyle(Color.cosmicPurple)
                .frame(width: 24, height: 24)
                .background(
                    Circle().fill(Color.cosmicPurple.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.cosmicHeadline(13))
                        .foregroundStyle(Color.cosmicText)

                    Text("(\(cards))")
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }

                Text(description)
                    .font(.cosmicBody(12))
                    .foregroundStyle(Color.cosmicText.opacity(0.75))
                    .lineSpacing(3)
            }
        }
    }

    private func spreadRow(cards: String, title: String, subtitle: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(cards)
                .font(.cosmicNumber(14))
                .foregroundStyle(Color.cosmicRose)
                .frame(width: 28, height: 28)
                .background(
                    Circle().fill(Color.cosmicRose.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.cosmicHeadline(14))
                    .foregroundStyle(Color.cosmicText)

                Text(subtitle)
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicPurple)
                    .textCase(.uppercase)
                    .kerning(1)

                Text(description)
                    .font(.cosmicBody(12))
                    .foregroundStyle(Color.cosmicText.opacity(0.75))
                    .lineSpacing(3)
            }
        }
    }

    private func usageStep(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Text(number)
                .font(.cosmicNumber(14))
                .foregroundStyle(Color.cosmicPurple)
                .frame(width: 24, height: 24)
                .background(
                    Circle().fill(Color.cosmicPurple.opacity(0.12))
                )

            Text(text)
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicText.opacity(0.85))
                .lineSpacing(4)
        }
    }
}
