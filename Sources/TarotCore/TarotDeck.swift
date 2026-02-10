import Foundation

public enum TarotDeck {
    public static let riderWaiteFR: [TarotCard] = majorArcana + minorArcana(for: .cups) + minorArcana(for: .wands) + minorArcana(for: .swords) + minorArcana(for: .pentacles)

    // Backward compatibility with previous naming
    public static let riderWaiteLite: [TarotCard] = riderWaiteFR

    private static let majorArcana: [TarotCard] = [
        makeMajor(0, "Le Mat", ["élan", "foi", "nouveau cycle"], "Ose un départ guidé par l'intuition.", "Évite la précipitation, recentre ton cap."),
        makeMajor(1, "Le Magicien", ["volonté", "création", "pouvoir personnel"], "Tu as les ressources pour manifester ton intention.", "Attention à la dispersion et aux promesses non tenues."),
        makeMajor(2, "La Papesse", ["intuition", "mystère", "sagesse"], "Écoute ton monde intérieur avant d'agir.", "Un secret ou un déni brouille ton jugement."),
        makeMajor(3, "L'Impératrice", ["abondance", "fertilité", "expression"], "Crée, nourris et laisse la vie circuler.", "Risque de surprotection ou de stagnation créative."),
        makeMajor(4, "L'Empereur", ["structure", "cadre", "autorité"], "Stabilise tes bases avec discipline.", "Rigidité ou besoin de contrôle excessif."),
        makeMajor(5, "Le Pape", ["enseignement", "valeurs", "tradition"], "Appuie-toi sur une sagesse éprouvée.", "Remets en question une règle devenue limitante."),
        makeMajor(6, "L'Amoureux", ["choix", "union", "alignement"], "Un choix de cœur demande cohérence.", "Ambivalence affective ou hésitation à s'engager."),
        makeMajor(7, "Le Chariot", ["élan", "victoire", "maîtrise"], "Avance avec détermination vers ton objectif.", "Le manque de direction ralentit ta progression."),
        makeMajor(8, "La Justice", ["équilibre", "vérité", "responsabilité"], "Choisis l'équité et la clarté.", "Évite les jugements hâtifs et l'injustice."),
        makeMajor(9, "L'Hermite", ["retrait", "quête", "discernement"], "Prends du recul pour entendre ta vérité.", "Isolement prolongé ou fermeture au monde."),
        makeMajor(10, "La Roue de Fortune", ["cycle", "changement", "destin"], "Un tournant s'ouvre, reste adaptable.", "Résistance au changement ou sentiment d'impuissance."),
        makeMajor(11, "La Force", ["courage", "douceur", "maîtrise émotionnelle"], "La vraie force naît de la patience du cœur.", "Fatigue nerveuse ou perte de confiance."),
        makeMajor(12, "Le Pendu", ["pause", "nouvelle perspective", "lâcher-prise"], "Une pause consciente éclaire la suite.", "Blocage dans une attente stérile."),
        makeMajor(13, "L'Arcane sans nom", ["transformation", "fin", "renaissance"], "Clôture nécessaire avant une renaissance.", "Peur de laisser mourir l'ancien."),
        makeMajor(14, "Tempérance", ["harmonie", "guérison", "fluidité"], "Trouve le juste dosage dans tes choix.", "Excès, impatience ou dispersion énergétique."),
        makeMajor(15, "Le Diable", ["attachement", "désir", "ombre"], "Observe ce qui t'enchaîne pour te libérer.", "Dépendance, peur ou auto-sabotage."),
        makeMajor(16, "La Maison Dieu", ["révélation", "rupture", "libération"], "Une vérité fracasse l'ancien pour te réaligner.", "Crainte du changement, résistance à la mue."),
        makeMajor(17, "L'Étoile", ["espoir", "inspiration", "foi"], "Tu es guidé·e, reste confiant·e.", "Doute, découragement ou perte de sens."),
        makeMajor(18, "La Lune", ["inconscient", "sensibilité", "imaginaire"], "Accueille tes émotions et tes rêves.", "Confusion émotionnelle, illusions ou anxiété."),
        makeMajor(19, "Le Soleil", ["joie", "clarté", "rayonnement"], "Succès, vitalité et vérité partagée.", "Égo blessé ou joie freinée par le doute."),
        makeMajor(20, "Le Jugement", ["appel", "éveil", "renouveau"], "Réponds à l'appel de ton âme.", "Rester figé·e dans le passé freine l'élan."),
        makeMajor(21, "Le Monde", ["accomplissement", "intégration", "expansion"], "Cycle accompli, ouverture vers une nouvelle étape.", "Difficulté à clôturer ou peur de grandir.")
    ]

    private static func minorArcana(for suit: TarotCard.Arcana) -> [TarotCard] {
        let suitName = suit.displayName
        let suitEnergy: String
        switch suit {
        case .cups: suitEnergy = "émotionnelle"
        case .wands: suitEnergy = "créative"
        case .swords: suitEnergy = "mentale"
        case .pentacles: suitEnergy = "matérielle"
        case .major: suitEnergy = "globale"
        }

        let ranks = [
            "As", "Deux", "Trois", "Quatre", "Cinq", "Six", "Sept", "Huit", "Neuf", "Dix", "Valet", "Cavalier", "Reine", "Roi"
        ]

        return ranks.enumerated().map { idx, rank in
            let name = "\(rank) de \(suitName)"
            return TarotCard(
                number: idx + 1,
                name: name,
                arcana: suit,
                keywords: ["\(rank.lowercased())", suitName.lowercased(), "énergie \(suitEnergy)"],
                uprightMeaning: "\(name): l'énergie \(suitEnergy) circule de manière constructive.",
                reversedMeaning: "\(name): un déséquilibre \(suitEnergy) invite à te réaligner.",
                interpretation: TarotCard.Interpretation(
                    general: "\(name) t'invite à harmoniser ton quotidien avec ton intention.",
                    love: "En amour, \(name) suggère d'exprimer clairement ton besoin \(suitEnergy).",
                    career: "Dans le travail, \(name) recommande d'ordonner tes priorités \(suitEnergy).",
                    spiritual: "Spirituellement, \(name) rappelle d'ancrer ton ressenti dans des rituels simples."
                )
            )
        }
    }

    private static func makeMajor(
        _ number: Int,
        _ name: String,
        _ keywords: [String],
        _ upright: String,
        _ reversed: String
    ) -> TarotCard {
        TarotCard(
            number: number,
            name: name,
            arcana: .major,
            keywords: keywords,
            uprightMeaning: upright,
            reversedMeaning: reversed,
            interpretation: TarotCard.Interpretation(
                general: "\(name) t'invite à te réaligner avec ta vérité intérieure.",
                love: "En amour, \(name) met en lumière ce qui demande authenticité et maturité.",
                career: "Dans le pro, \(name) encourage une décision alignée avec ta mission.",
                spiritual: "Spirituellement, \(name) ouvre un passage d'évolution et de conscience."
            )
        )
    }
}
