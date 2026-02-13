import Foundation

enum TarotDeck {
    static let allCards: [TarotCard] = majorArcana + minorArcana(for: .cups) + minorArcana(for: .wands) + minorArcana(for: .swords) + minorArcana(for: .pentacles)

    // MARK: - Major Arcana (22 cards) — Rider-Waite French names

    static let majorArcana: [TarotCard] = [
        makeMajor(0, "Le Fou",
            ["élan", "foi", "nouveau cycle"],
            "Ose un départ guidé par l'intuition.",
            "Évite la précipitation, recentre ton cap.",
            love: "En amour, Le Fou invite à oser la spontanéité et l'authenticité sans calcul.",
            career: "Professionnellement, c'est le moment de tenter un virage audacieux.",
            spiritual: "Un voyage intérieur commence ; laisse-toi guider par la confiance.",
            image: "RWS_Tarot_00_Fool"),

        makeMajor(1, "Le Magicien",
            ["volonté", "création", "pouvoir personnel"],
            "Tu as les ressources pour manifester ton intention.",
            "Attention à la dispersion et aux promesses non tenues.",
            love: "En amour, tu as le pouvoir de créer la relation que tu désires.",
            career: "Tes talents sont prêts à être mis en lumière, agis maintenant.",
            spiritual: "Tu es le canal entre le ciel et la terre, aligne tes pensées.",
            image: "RWS_Tarot_01_Magician"),

        makeMajor(2, "La Grande Prêtresse",
            ["intuition", "mystère", "sagesse"],
            "Écoute ton monde intérieur avant d'agir.",
            "Un secret ou un déni brouille ton jugement.",
            love: "L'amour se révèle dans le silence et la patience.",
            career: "Observe avant de prendre une décision importante.",
            spiritual: "La connaissance profonde t'attend dans la méditation.",
            image: "RWS_Tarot_02_High_Priestess"),

        makeMajor(3, "L'Impératrice",
            ["abondance", "fertilité", "expression"],
            "Crée, nourris et laisse la vie circuler.",
            "Risque de surprotection ou de stagnation créative.",
            love: "Une énergie d'amour inconditionnel enveloppe tes relations.",
            career: "Un projet créatif est prêt à éclore, nourris-le.",
            spiritual: "Connecte-toi à la Terre Mère et à ta nature créatrice.",
            image: "RWS_Tarot_03_Empress"),

        makeMajor(4, "L'Empereur",
            ["structure", "cadre", "autorité"],
            "Stabilise tes bases avec discipline.",
            "Rigidité ou besoin de contrôle excessif.",
            love: "Construis des fondations solides dans ta relation.",
            career: "Le leadership et l'organisation sont tes atouts aujourd'hui.",
            spiritual: "L'ancrage et la discipline structurent ton chemin spirituel.",
            image: "RWS_Tarot_04_Emperor"),

        makeMajor(5, "L'Hiérophante",
            ["enseignement", "valeurs", "tradition"],
            "Appuie-toi sur une sagesse éprouvée.",
            "Remets en question une règle devenue limitante.",
            love: "Cherche un amour qui respecte tes valeurs profondes.",
            career: "Un mentor ou un enseignement pourrait changer ta perspective.",
            spiritual: "La tradition porte des clés, mais ta vérité est unique.",
            image: "RWS_Tarot_05_Hierophant"),

        makeMajor(6, "Les Amoureux",
            ["choix", "union", "alignement"],
            "Un choix de cœur demande cohérence.",
            "Ambivalence affective ou hésitation à s'engager.",
            love: "Un choix amoureux majeur se présente, écoute ton cœur.",
            career: "Choisis un chemin professionnel aligné avec tes valeurs.",
            spiritual: "L'union du cœur et de l'esprit est ta quête.",
            image: "RWS_Tarot_06_Lovers"),

        makeMajor(7, "Le Chariot",
            ["élan", "victoire", "maîtrise"],
            "Avance avec détermination vers ton objectif.",
            "Le manque de direction ralentit ta progression.",
            love: "L'amour avance quand tu prends les rênes avec confiance.",
            career: "La victoire est proche, maintiens ton cap avec discipline.",
            spiritual: "Maîtrise tes forces intérieures pour avancer sur ton chemin.",
            image: "RWS_Tarot_07_Chariot"),

        makeMajor(8, "La Force",
            ["courage", "douceur", "maîtrise émotionnelle"],
            "La vraie force naît de la patience du cœur.",
            "Fatigue nerveuse ou perte de confiance.",
            love: "La douceur et la patience apprivoisent les cœurs.",
            career: "Ta résilience est ton plus grand atout professionnel.",
            spiritual: "La maîtrise de soi est le plus haut degré de force.",
            image: "RWS_Tarot_08_Strength"),

        makeMajor(9, "L'Ermite",
            ["retrait", "quête", "discernement"],
            "Prends du recul pour entendre ta vérité.",
            "Isolement prolongé ou fermeture au monde.",
            love: "Parfois, il faut être seul·e pour mieux revenir vers l'autre.",
            career: "Le retrait stratégique nourrit une vision plus claire.",
            spiritual: "La solitude est un sanctuaire pour l'âme qui cherche.",
            image: "RWS_Tarot_09_Hermit"),

        makeMajor(10, "La Roue de Fortune",
            ["cycle", "changement", "destin"],
            "Un tournant s'ouvre, reste adaptable.",
            "Résistance au changement ou sentiment d'impuissance.",
            love: "Les cycles de l'amour tournent, accueille ce qui vient.",
            career: "Un changement inattendu ouvre de nouvelles portes.",
            spiritual: "Tout est cyclique, fais confiance au mouvement de la vie.",
            image: "RWS_Tarot_10_Wheel_of_Fortune"),

        makeMajor(11, "La Justice",
            ["équilibre", "vérité", "responsabilité"],
            "Choisis l'équité et la clarté.",
            "Évite les jugements hâtifs et l'injustice.",
            love: "L'honnêteté est le socle d'une relation saine.",
            career: "Un contrat ou une décision légale demande ton attention.",
            spiritual: "Le karma agit, aligne-toi avec ta conscience.",
            image: "RWS_Tarot_11_Justice"),

        makeMajor(12, "Le Pendu",
            ["pause", "nouvelle perspective", "lâcher-prise"],
            "Une pause consciente éclaire la suite.",
            "Blocage dans une attente stérile.",
            love: "Lâcher le contrôle permet à l'amour de circuler.",
            career: "Voir les choses sous un nouvel angle change tout.",
            spiritual: "Le sacrifice conscient mène à l'illumination.",
            image: "RWS_Tarot_12_Hanged_Man"),

        makeMajor(13, "La Mort",
            ["transformation", "fin", "renaissance"],
            "Clôture nécessaire avant une renaissance.",
            "Peur de laisser mourir l'ancien.",
            love: "Une relation se transforme profondément, laisse faire.",
            career: "La fin d'un cycle professionnel annonce un renouveau.",
            spiritual: "Meurs à l'ancien pour renaître plus lumineux·se.",
            image: "RWS_Tarot_13_Death"),

        makeMajor(14, "La Tempérance",
            ["harmonie", "guérison", "fluidité"],
            "Trouve le juste dosage dans tes choix.",
            "Excès, impatience ou dispersion énergétique.",
            love: "L'équilibre entre donner et recevoir nourrit l'amour.",
            career: "La patience et la mesure portent des fruits durables.",
            spiritual: "L'alchimie intérieure opère dans la douceur.",
            image: "RWS_Tarot_14_Temperance"),

        makeMajor(15, "Le Diable",
            ["attachement", "désir", "ombre"],
            "Observe ce qui t'enchaîne pour te libérer.",
            "Dépendance, peur ou auto-sabotage.",
            love: "Distingue le désir de l'amour véritable.",
            career: "Ne laisse pas l'ambition te couper de tes valeurs.",
            spiritual: "Confronte ton ombre pour intégrer ta pleine lumière.",
            image: "RWS_Tarot_15_Devil"),

        makeMajor(16, "La Tour",
            ["révélation", "rupture", "libération"],
            "Une vérité fracasse l'ancien pour te réaligner.",
            "Crainte du changement, résistance à la mue.",
            love: "Un bouleversement libère de faux semblants.",
            career: "Une rupture professionnelle inattendue est un cadeau déguisé.",
            spiritual: "L'ego s'effondre pour laisser place à la vérité.",
            image: "RWS_Tarot_16_Tower"),

        makeMajor(17, "L'Étoile",
            ["espoir", "inspiration", "foi"],
            "Tu es guidé·e, reste confiant·e.",
            "Doute, découragement ou perte de sens.",
            love: "L'amour vrai brille déjà dans ta vie, ouvre les yeux.",
            career: "L'inspiration guide tes projets vers le succès.",
            spiritual: "Tu es connecté·e à une guidance céleste, fais confiance.",
            image: "RWS_Tarot_17_Star"),

        makeMajor(18, "La Lune",
            ["inconscient", "sensibilité", "imaginaire"],
            "Accueille tes émotions et tes rêves.",
            "Confusion émotionnelle, illusions ou anxiété.",
            love: "Les émotions profondes éclairent tes vrais besoins affectifs.",
            career: "Fie-toi à ton intuition plutôt qu'aux apparences.",
            spiritual: "Les rêves et l'imaginaire portent des messages sacrés.",
            image: "RWS_Tarot_18_Moon"),

        makeMajor(19, "Le Soleil",
            ["joie", "clarté", "rayonnement"],
            "Succès, vitalité et vérité partagée.",
            "Égo blessé ou joie freinée par le doute.",
            love: "La joie et la clarté illuminent tes relations.",
            career: "Un succès éclatant se profile, célèbre tes victoires.",
            spiritual: "Ta lumière intérieure rayonne et inspire les autres.",
            image: "RWS_Tarot_19_Sun"),

        makeMajor(20, "Le Jugement",
            ["appel", "éveil", "renouveau"],
            "Réponds à l'appel de ton âme.",
            "Rester figé·e dans le passé freine l'élan.",
            love: "Un appel profond transforme ta vision de l'amour.",
            career: "Un changement radical s'impose, réponds à l'appel.",
            spiritual: "L'éveil de conscience te libère des anciens schémas.",
            image: "RWS_Tarot_20_Judgement"),

        makeMajor(21, "Le Monde",
            ["accomplissement", "intégration", "expansion"],
            "Cycle accompli, ouverture vers une nouvelle étape.",
            "Difficulté à clôturer ou peur de grandir.",
            love: "L'amour atteint un palier de plénitude et d'harmonie.",
            career: "Un accomplissement majeur couronne tes efforts.",
            spiritual: "Tu as intégré une leçon fondamentale, un nouveau cycle s'ouvre.",
            image: "RWS_Tarot_21_World")
    ]

    // MARK: - Minor Arcana Image Names (local assets)

    private static let minorImageNames: [String: [String]] = [
        "Cups": (1...14).map { String(format: "Cups%02d", $0) },
        "Wands": (1...14).map { String(format: "Wands%02d", $0) },
        "Swords": (1...14).map { String(format: "Swords%02d", $0) },
        "Pents": (1...14).map { String(format: "Pents%02d", $0) },
    ]

    // MARK: - Minor Arcana (56 cards)

    private static func minorArcana(for suit: TarotCard.Arcana) -> [TarotCard] {
        let suitName = suit.displayName
        let suitEnergy: String
        let loveFlavor: String
        let careerFlavor: String
        let spiritFlavor: String
        let imageKey: String

        switch suit {
        case .cups:
            suitEnergy = "émotionnelle"
            loveFlavor = "la tendresse et la profondeur des sentiments"
            careerFlavor = "l'harmonie au sein de l'équipe et la satisfaction"
            spiritFlavor = "l'ouverture du cœur et la compassion"
            imageKey = "Cups"
        case .wands:
            suitEnergy = "créative"
            loveFlavor = "la passion et l'élan qui vivifient la relation"
            careerFlavor = "l'initiative audacieuse et l'ambition inspirée"
            spiritFlavor = "le feu intérieur et l'enthousiasme sacré"
            imageKey = "Wands"
        case .swords:
            suitEnergy = "mentale"
            loveFlavor = "la clarté et l'honnêteté dans les échanges"
            careerFlavor = "la stratégie et l'analyse pour avancer"
            spiritFlavor = "le discernement et la vérité intérieure"
            imageKey = "Swords"
        case .pentacles:
            suitEnergy = "matérielle"
            loveFlavor = "la stabilité et l'engagement concret"
            careerFlavor = "la prospérité et la construction durable"
            spiritFlavor = "l'ancrage et la connexion à la terre"
            imageKey = "Pents"
        default:
            suitEnergy = "globale"
            loveFlavor = "l'amour"
            careerFlavor = "le travail"
            spiritFlavor = "la spiritualité"
            imageKey = ""
        }

        let imageNames = minorImageNames[imageKey] ?? []

        let ranks: [(String, [String], String, String)] = [
            ("As", ["commencement", "potentiel", "graine"],
             "Un nouveau départ \(suitEnergy) plein de promesses.",
             "Un blocage empêche l'élan \(suitEnergy) de s'exprimer."),
            ("Deux", ["dualité", "équilibre", "choix"],
             "Un partenariat ou un choix \(suitEnergy) s'offre à toi.",
             "L'indécision freine ton énergie \(suitEnergy)."),
            ("Trois", ["expansion", "collaboration", "croissance"],
             "L'énergie \(suitEnergy) s'épanouit et porte ses premiers fruits.",
             "Des tensions entravent la collaboration \(suitEnergy)."),
            ("Quatre", ["stabilité", "pause", "fondation"],
             "Un temps de consolidation \(suitEnergy) s'impose.",
             "La stagnation ou l'excès de prudence bloque l'énergie \(suitEnergy)."),
            ("Cinq", ["conflit", "épreuve", "transformation"],
             "Une épreuve \(suitEnergy) invite à la résilience.",
             "Le conflit intérieur \(suitEnergy) demande une résolution."),
            ("Six", ["harmonie", "générosité", "réconciliation"],
             "L'harmonie \(suitEnergy) est retrouvée, partage cette énergie.",
             "Un déséquilibre dans les échanges \(suitEnergy) persiste."),
            ("Sept", ["réflexion", "stratégie", "patience"],
             "La réflexion \(suitEnergy) guide une stratégie gagnante.",
             "L'impatience ou la confusion brouille tes plans \(suitEnergy)."),
            ("Huit", ["mouvement", "progrès", "maîtrise"],
             "Un progrès rapide \(suitEnergy) se manifeste.",
             "La précipitation ou le manque de direction \(suitEnergy) ralentit."),
            ("Neuf", ["accomplissement", "abondance", "maturité"],
             "L'aboutissement \(suitEnergy) est proche, savoure le chemin.",
             "L'isolement ou le doute entache ta réussite \(suitEnergy)."),
            ("Dix", ["plénitude", "cycle complet", "transition"],
             "Un cycle \(suitEnergy) se boucle, ouvre-toi à la suite.",
             "Le poids d'un cycle \(suitEnergy) achevé appelle le lâcher-prise."),
            ("Valet", ["curiosité", "apprentissage", "message"],
             "Un message ou un apprentissage \(suitEnergy) arrive.",
             "L'immaturité ou la naïveté \(suitEnergy) demande vigilance."),
            ("Cavalier", ["action", "élan", "quête"],
             "L'action \(suitEnergy) dynamise ta quête.",
             "L'impulsivité \(suitEnergy) risque de te déséquilibrer."),
            ("Reine", ["réceptivité", "intuition", "nourriture"],
             "L'énergie \(suitEnergy) s'exprime avec grâce et intuition.",
             "L'excès \(suitEnergy) ou la dépendance guette."),
            ("Roi", ["maîtrise", "leadership", "sagesse"],
             "La maîtrise \(suitEnergy) te positionne en leader sage.",
             "L'autoritarisme ou la rigidité \(suitEnergy) isole.")
        ]

        return ranks.enumerated().map { idx, rank in
            let (rankName, keywords, upright, reversed) = rank
            let name = "\(rankName) de \(suitName)"
            let assetName = idx < imageNames.count ? imageNames[idx] : ""
            return TarotCard(
                number: idx + 1,
                name: name,
                arcana: suit,
                keywords: keywords,
                uprightMeaning: upright,
                reversedMeaning: reversed,
                interpretation: TarotCard.Interpretation(
                    general: "\(name) t'invite à harmoniser ton quotidien avec ton intention \(suitEnergy).",
                    love: "En amour, \(name) évoque \(loveFlavor).",
                    career: "Au travail, \(name) souligne \(careerFlavor).",
                    spiritual: "Spirituellement, \(name) nourrit \(spiritFlavor)."
                ),
                imageName: assetName
            )
        }
    }

    // MARK: - Helpers

    private static func makeMajor(
        _ number: Int,
        _ name: String,
        _ keywords: [String],
        _ upright: String,
        _ reversed: String,
        love: String,
        career: String,
        spiritual: String,
        image: String
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
                love: love,
                career: career,
                spiritual: spiritual
            ),
            imageName: image
        )
    }
}
