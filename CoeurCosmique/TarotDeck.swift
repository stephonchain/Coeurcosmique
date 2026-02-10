import Foundation

enum TarotDeck {
    static let allCards: [TarotCard] = majorArcana + minorArcana(for: .cups) + minorArcana(for: .wands) + minorArcana(for: .swords) + minorArcana(for: .pentacles)

    // MARK: - Wikimedia Commons base URL

    private static let wikiBase = "https://upload.wikimedia.org/wikipedia/commons"

    // MARK: - Major Arcana (22 cards)

    static let majorArcana: [TarotCard] = [
        makeMajor(0, "Le Mat",
            ["élan", "foi", "nouveau cycle"],
            "Ose un départ guidé par l'intuition.",
            "Évite la précipitation, recentre ton cap.",
            love: "En amour, Le Mat invite à oser la spontanéité et l'authenticité sans calcul.",
            career: "Professionnellement, c'est le moment de tenter un virage audacieux.",
            spiritual: "Un voyage intérieur commence ; laisse-toi guider par la confiance.",
            image: "\(wikiBase)/9/90/RWS_Tarot_00_Fool.jpg"),

        makeMajor(1, "Le Magicien",
            ["volonté", "création", "pouvoir personnel"],
            "Tu as les ressources pour manifester ton intention.",
            "Attention à la dispersion et aux promesses non tenues.",
            love: "En amour, tu as le pouvoir de créer la relation que tu désires.",
            career: "Tes talents sont prêts à être mis en lumière, agis maintenant.",
            spiritual: "Tu es le canal entre le ciel et la terre, aligne tes pensées.",
            image: "\(wikiBase)/d/de/RWS_Tarot_01_Magician.jpg"),

        makeMajor(2, "La Papesse",
            ["intuition", "mystère", "sagesse"],
            "Écoute ton monde intérieur avant d'agir.",
            "Un secret ou un déni brouille ton jugement.",
            love: "L'amour se révèle dans le silence et la patience.",
            career: "Observe avant de prendre une décision importante.",
            spiritual: "La connaissance profonde t'attend dans la méditation.",
            image: "\(wikiBase)/8/88/RWS_Tarot_02_High_Priestess.jpg"),

        makeMajor(3, "L'Impératrice",
            ["abondance", "fertilité", "expression"],
            "Crée, nourris et laisse la vie circuler.",
            "Risque de surprotection ou de stagnation créative.",
            love: "Une énergie d'amour inconditionnel enveloppe tes relations.",
            career: "Un projet créatif est prêt à éclore, nourris-le.",
            spiritual: "Connecte-toi à la Terre Mère et à ta nature créatrice.",
            image: "\(wikiBase)/d/d2/RWS_Tarot_03_Empress.jpg"),

        makeMajor(4, "L'Empereur",
            ["structure", "cadre", "autorité"],
            "Stabilise tes bases avec discipline.",
            "Rigidité ou besoin de contrôle excessif.",
            love: "Construis des fondations solides dans ta relation.",
            career: "Le leadership et l'organisation sont tes atouts aujourd'hui.",
            spiritual: "L'ancrage et la discipline structurent ton chemin spirituel.",
            image: "\(wikiBase)/c/c3/RWS_Tarot_04_Emperor.jpg"),

        makeMajor(5, "Le Pape",
            ["enseignement", "valeurs", "tradition"],
            "Appuie-toi sur une sagesse éprouvée.",
            "Remets en question une règle devenue limitante.",
            love: "Cherche un amour qui respecte tes valeurs profondes.",
            career: "Un mentor ou un enseignement pourrait changer ta perspective.",
            spiritual: "La tradition porte des clés, mais ta vérité est unique.",
            image: "\(wikiBase)/8/8d/RWS_Tarot_05_Hierophant.jpg"),

        makeMajor(6, "L'Amoureux",
            ["choix", "union", "alignement"],
            "Un choix de cœur demande cohérence.",
            "Ambivalence affective ou hésitation à s'engager.",
            love: "Un choix amoureux majeur se présente, écoute ton cœur.",
            career: "Choisis un chemin professionnel aligné avec tes valeurs.",
            spiritual: "L'union du cœur et de l'esprit est ta quête.",
            image: "\(wikiBase)/d/db/RWS_Tarot_06_Lovers.jpg"),

        makeMajor(7, "Le Chariot",
            ["élan", "victoire", "maîtrise"],
            "Avance avec détermination vers ton objectif.",
            "Le manque de direction ralentit ta progression.",
            love: "L'amour avance quand tu prends les rênes avec confiance.",
            career: "La victoire est proche, maintiens ton cap avec discipline.",
            spiritual: "Maîtrise tes forces intérieures pour avancer sur ton chemin.",
            image: "\(wikiBase)/9/9b/RWS_Tarot_07_Chariot.jpg"),

        makeMajor(8, "La Justice",
            ["équilibre", "vérité", "responsabilité"],
            "Choisis l'équité et la clarté.",
            "Évite les jugements hâtifs et l'injustice.",
            love: "L'honnêteté est le socle d'une relation saine.",
            career: "Un contrat ou une décision légale demande ton attention.",
            spiritual: "Le karma agit, aligne-toi avec ta conscience.",
            image: "\(wikiBase)/e/e0/RWS_Tarot_11_Justice.jpg"),

        makeMajor(9, "L'Hermite",
            ["retrait", "quête", "discernement"],
            "Prends du recul pour entendre ta vérité.",
            "Isolement prolongé ou fermeture au monde.",
            love: "Parfois, il faut être seul·e pour mieux revenir vers l'autre.",
            career: "Le retrait stratégique nourrit une vision plus claire.",
            spiritual: "La solitude est un sanctuaire pour l'âme qui cherche.",
            image: "\(wikiBase)/4/4d/RWS_Tarot_09_Hermit.jpg"),

        makeMajor(10, "La Roue de Fortune",
            ["cycle", "changement", "destin"],
            "Un tournant s'ouvre, reste adaptable.",
            "Résistance au changement ou sentiment d'impuissance.",
            love: "Les cycles de l'amour tournent, accueille ce qui vient.",
            career: "Un changement inattendu ouvre de nouvelles portes.",
            spiritual: "Tout est cyclique, fais confiance au mouvement de la vie.",
            image: "\(wikiBase)/3/3c/RWS_Tarot_10_Wheel_of_Fortune.jpg"),

        makeMajor(11, "La Force",
            ["courage", "douceur", "maîtrise émotionnelle"],
            "La vraie force naît de la patience du cœur.",
            "Fatigue nerveuse ou perte de confiance.",
            love: "La douceur et la patience apprivoisent les cœurs.",
            career: "Ta résilience est ton plus grand atout professionnel.",
            spiritual: "La maîtrise de soi est le plus haut degré de force.",
            image: "\(wikiBase)/f/f5/RWS_Tarot_08_Strength.jpg"),

        makeMajor(12, "Le Pendu",
            ["pause", "nouvelle perspective", "lâcher-prise"],
            "Une pause consciente éclaire la suite.",
            "Blocage dans une attente stérile.",
            love: "Lâcher le contrôle permet à l'amour de circuler.",
            career: "Voir les choses sous un nouvel angle change tout.",
            spiritual: "Le sacrifice conscient mène à l'illumination.",
            image: "\(wikiBase)/2/2b/RWS_Tarot_12_Hanged_Man.jpg"),

        makeMajor(13, "L'Arcane sans nom",
            ["transformation", "fin", "renaissance"],
            "Clôture nécessaire avant une renaissance.",
            "Peur de laisser mourir l'ancien.",
            love: "Une relation se transforme profondément, laisse faire.",
            career: "La fin d'un cycle professionnel annonce un renouveau.",
            spiritual: "Meurs à l'ancien pour renaître plus lumineux·se.",
            image: "\(wikiBase)/d/d7/RWS_Tarot_13_Death.jpg"),

        makeMajor(14, "Tempérance",
            ["harmonie", "guérison", "fluidité"],
            "Trouve le juste dosage dans tes choix.",
            "Excès, impatience ou dispersion énergétique.",
            love: "L'équilibre entre donner et recevoir nourrit l'amour.",
            career: "La patience et la mesure portent des fruits durables.",
            spiritual: "L'alchimie intérieure opère dans la douceur.",
            image: "\(wikiBase)/f/f8/RWS_Tarot_14_Temperance.jpg"),

        makeMajor(15, "Le Diable",
            ["attachement", "désir", "ombre"],
            "Observe ce qui t'enchaîne pour te libérer.",
            "Dépendance, peur ou auto-sabotage.",
            love: "Distingue le désir de l'amour véritable.",
            career: "Ne laisse pas l'ambition te couper de tes valeurs.",
            spiritual: "Confronte ton ombre pour intégrer ta pleine lumière.",
            image: "\(wikiBase)/5/55/RWS_Tarot_15_Devil.jpg"),

        makeMajor(16, "La Maison Dieu",
            ["révélation", "rupture", "libération"],
            "Une vérité fracasse l'ancien pour te réaligner.",
            "Crainte du changement, résistance à la mue.",
            love: "Un bouleversement libère de faux semblants.",
            career: "Une rupture professionnelle inattendue est un cadeau déguisé.",
            spiritual: "L'ego s'effondre pour laisser place à la vérité.",
            image: "\(wikiBase)/5/53/RWS_Tarot_16_Tower.jpg"),

        makeMajor(17, "L'Étoile",
            ["espoir", "inspiration", "foi"],
            "Tu es guidé·e, reste confiant·e.",
            "Doute, découragement ou perte de sens.",
            love: "L'amour vrai brille déjà dans ta vie, ouvre les yeux.",
            career: "L'inspiration guide tes projets vers le succès.",
            spiritual: "Tu es connecté·e à une guidance céleste, fais confiance.",
            image: "\(wikiBase)/d/db/RWS_Tarot_17_Star.jpg"),

        makeMajor(18, "La Lune",
            ["inconscient", "sensibilité", "imaginaire"],
            "Accueille tes émotions et tes rêves.",
            "Confusion émotionnelle, illusions ou anxiété.",
            love: "Les émotions profondes éclairent tes vrais besoins affectifs.",
            career: "Fie-toi à ton intuition plutôt qu'aux apparences.",
            spiritual: "Les rêves et l'imaginaire portent des messages sacrés.",
            image: "\(wikiBase)/7/7f/RWS_Tarot_18_Moon.jpg"),

        makeMajor(19, "Le Soleil",
            ["joie", "clarté", "rayonnement"],
            "Succès, vitalité et vérité partagée.",
            "Égo blessé ou joie freinée par le doute.",
            love: "La joie et la clarté illuminent tes relations.",
            career: "Un succès éclatant se profile, célèbre tes victoires.",
            spiritual: "Ta lumière intérieure rayonne et inspire les autres.",
            image: "\(wikiBase)/1/17/RWS_Tarot_19_Sun.jpg"),

        makeMajor(20, "Le Jugement",
            ["appel", "éveil", "renouveau"],
            "Réponds à l'appel de ton âme.",
            "Rester figé·e dans le passé freine l'élan.",
            love: "Un appel profond transforme ta vision de l'amour.",
            career: "Un changement radical s'impose, réponds à l'appel.",
            spiritual: "L'éveil de conscience te libère des anciens schémas.",
            image: "\(wikiBase)/d/dd/RWS_Tarot_20_Judgement.jpg"),

        makeMajor(21, "Le Monde",
            ["accomplissement", "intégration", "expansion"],
            "Cycle accompli, ouverture vers une nouvelle étape.",
            "Difficulté à clôturer ou peur de grandir.",
            love: "L'amour atteint un palier de plénitude et d'harmonie.",
            career: "Un accomplissement majeur couronne tes efforts.",
            spiritual: "Tu as intégré une leçon fondamentale, un nouveau cycle s'ouvre.",
            image: "\(wikiBase)/f/ff/RWS_Tarot_21_World.jpg")
    ]

    // MARK: - Minor Arcana Image URLs

    private static let minorImageURLs: [String: [String]] = [
        "Cups": [
            "\(wikiBase)/3/36/Cups01.jpg",
            "\(wikiBase)/f/f8/Cups02.jpg",
            "\(wikiBase)/7/7a/Cups03.jpg",
            "\(wikiBase)/3/35/Cups04.jpg",
            "\(wikiBase)/d/d7/Cups05.jpg",
            "\(wikiBase)/1/17/Cups06.jpg",
            "\(wikiBase)/a/ae/Cups07.jpg",
            "\(wikiBase)/6/60/Cups08.jpg",
            "\(wikiBase)/2/24/Cups09.jpg",
            "\(wikiBase)/8/84/Cups10.jpg",
            "\(wikiBase)/a/ad/Cups11.jpg",
            "\(wikiBase)/f/fa/Cups12.jpg",
            "\(wikiBase)/6/62/Cups13.jpg",
            "\(wikiBase)/0/04/Cups14.jpg",
        ],
        "Wands": [
            "\(wikiBase)/1/11/Wands01.jpg",
            "\(wikiBase)/0/0f/Wands02.jpg",
            "\(wikiBase)/f/ff/Wands03.jpg",
            "\(wikiBase)/a/a4/Wands04.jpg",
            "\(wikiBase)/9/9d/Wands05.jpg",
            "\(wikiBase)/3/3b/Wands06.jpg",
            "\(wikiBase)/e/e4/Wands07.jpg",
            "\(wikiBase)/6/6b/Wands08.jpg",
            "\(wikiBase)/e/e7/Wands09.jpg",
            "\(wikiBase)/0/0b/Wands10.jpg",
            "\(wikiBase)/6/6a/Wands11.jpg",
            "\(wikiBase)/1/16/Wands12.jpg",
            "\(wikiBase)/0/0d/Wands13.jpg",
            "\(wikiBase)/c/ce/Wands14.jpg",
        ],
        "Swords": [
            "\(wikiBase)/1/1a/Swords01.jpg",
            "\(wikiBase)/9/9e/Swords02.jpg",
            "\(wikiBase)/0/02/Swords03.jpg",
            "\(wikiBase)/b/bf/Swords04.jpg",
            "\(wikiBase)/2/23/Swords05.jpg",
            "\(wikiBase)/2/29/Swords06.jpg",
            "\(wikiBase)/3/34/Swords07.jpg",
            "\(wikiBase)/a/a7/Swords08.jpg",
            "\(wikiBase)/2/2f/Swords09.jpg",
            "\(wikiBase)/d/d4/Swords10.jpg",
            "\(wikiBase)/4/4c/Swords11.jpg",
            "\(wikiBase)/b/b0/Swords12.jpg",
            "\(wikiBase)/d/d4/Swords13.jpg",
            "\(wikiBase)/3/33/Swords14.jpg",
        ],
        "Pents": [
            "\(wikiBase)/f/fd/Pents01.jpg",
            "\(wikiBase)/9/9f/Pents02.jpg",
            "\(wikiBase)/4/42/Pents03.jpg",
            "\(wikiBase)/3/35/Pents04.jpg",
            "\(wikiBase)/9/96/Pents05.jpg",
            "\(wikiBase)/a/a6/Pents06.jpg",
            "\(wikiBase)/6/6a/Pents07.jpg",
            "\(wikiBase)/4/49/Pents08.jpg",
            "\(wikiBase)/f/f0/Pents09.jpg",
            "\(wikiBase)/4/42/Pents10.jpg",
            "\(wikiBase)/e/ec/Pents11.jpg",
            "\(wikiBase)/d/d5/Pents12.jpg",
            "\(wikiBase)/8/88/Pents13.jpg",
            "\(wikiBase)/1/1c/Pents14.jpg",
        ],
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

        let imageURLs = minorImageURLs[imageKey] ?? []

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
            let url = idx < imageURLs.count ? imageURLs[idx] : nil
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
                imageURL: url
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
            imageURL: image
        )
    }
}
