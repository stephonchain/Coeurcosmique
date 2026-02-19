import Foundation

enum RuneDeck {

    // MARK: - All Cards

    static let allCards: [RuneCard] = aettFreyja + aettHeimdall + aettTyr

    // MARK: - Aett de Freyja (1-8) – La Création de la Matière

    static let aettFreyja: [RuneCard] = [
        RuneCard(
            number: 1,
            name: "FEHU",
            letter: "F",
            aett: .freyja,
            conceptTraditionnel: "Bétail, Richesse, Abondance mobile",
            visionCosmique: "Le Big Bang",
            visionCosmiqueDescription: "Énergie brute en expansion, feu créateur initial, carburant de tout projet naissant.",
            message: "Tu possèdes des réserves d'énergie immenses. Ne les stocke pas, fais-les circuler. L'abondance vient du mouvement.",
            imageName: "rune_fehu"
        ),
        RuneCard(
            number: 2,
            name: "URUZ",
            letter: "U",
            aett: .freyja,
            conceptTraditionnel: "Aurochs, Force vitale, Santé, Courage",
            visionCosmique: "La Gravité",
            visionCosmiqueDescription: "La force qui condense la poussière d'étoiles en planètes, puissance brute qui façonne la volonté.",
            message: "Période de structuration intense. Utilise ton « poids » pour façonner ta réalité. Force et endurance sont tes alliées.",
            imageName: "rune_uruz"
        ),
        RuneCard(
            number: 3,
            name: "THURISAZ",
            letter: "Th",
            aett: .freyja,
            conceptTraditionnel: "Géant, Épine, Marteau de Thor",
            visionCosmique: "L'Entropie",
            visionCosmiqueDescription: "Forces du chaos qui testent la résistance des structures, tempête électromagnétique qui purifie.",
            message: "Un obstacle se dresse non pour te bloquer, mais pour briser tes anciennes défenses. Éveille ton guerrier intérieur.",
            imageName: "rune_thurisaz"
        ),
        RuneCard(
            number: 4,
            name: "ANSUZ",
            letter: "A",
            aett: .freyja,
            conceptTraditionnel: "Dieu (Odin), Parole, Souffle, Communication",
            visionCosmique: "Le Signal",
            visionCosmiqueDescription: "Onde porteuse de l'information universelle, vibration du Verbe créateur.",
            message: "Sois à l'écoute des signaux, des synchronicités, de ton intuition. Le cosmos essaie de te parler.",
            imageName: "rune_ansuz"
        ),
        RuneCard(
            number: 5,
            name: "RAIDHO",
            letter: "R",
            aett: .freyja,
            conceptTraditionnel: "Chariot, Voyage, Rythme, Loi",
            visionCosmique: "L'Orbite",
            visionCosmiqueDescription: "Mouvement cyclique planétaire parfait, alignement avec la trajectoire idéale.",
            message: "Remets-toi en mouvement. Suis ton propre rythme. Le voyage importe plus que la destination.",
            imageName: "rune_raidho"
        ),
        RuneCard(
            number: 6,
            name: "KENAZ",
            letter: "K",
            aett: .freyja,
            conceptTraditionnel: "Torche, Feu domestique, Créativité, Guérison",
            visionCosmique: "L'Étoile",
            visionCosmiqueDescription: "Lumière perçant l'obscurité du vide, connaissance technique transformant la matière.",
            message: "Une révélation soudaine, une idée brillante. Tu as le feu sacré pour créer ou guérir.",
            imageName: "rune_kenaz"
        ),
        RuneCard(
            number: 7,
            name: "GEBO",
            letter: "G",
            aett: .freyja,
            conceptTraditionnel: "Don, Échange, Partenariat",
            visionCosmique: "L'Interaction",
            visionCosmiqueDescription: "Loi d'action-réaction, deux forces s'équilibrant pour créer un système stable.",
            message: "Donne pour recevoir. Cherche l'harmonie dans tes relations. Une alliance entre égaux se profile.",
            imageName: "rune_gebo"
        ),
        RuneCard(
            number: 8,
            name: "WUNJO",
            letter: "W",
            aett: .freyja,
            conceptTraditionnel: "Joie, Bonheur, Perfection",
            visionCosmique: "La Résonance",
            visionCosmiqueDescription: "État où toutes les fréquences sont en phase, harmonie des sphères.",
            message: "Le succès arrive. Savoure l'alignement parfait des événements. Célèbre ta victoire.",
            imageName: "rune_wunjo"
        )
    ]

    // MARK: - Aett de Heimdall (9-16) – Les Forces du Changement

    static let aettHeimdall: [RuneCard] = [
        RuneCard(
            number: 9,
            name: "HAGALAZ",
            letter: "H",
            aett: .heimdall,
            conceptTraditionnel: "Grêle, Perturbation, Crise radicale",
            visionCosmique: "L'Impact de Météorite",
            visionCosmiqueDescription: "Événement externe soudain changeant le paysage, destruction créatrice.",
            message: "Accepte le chaos. Ce qui s'effondre n'était pas assez solide. Libération déguisée en catastrophe.",
            imageName: "rune_hagalaz"
        ),
        RuneCard(
            number: 10,
            name: "NAUDHIZ",
            letter: "N",
            aett: .heimdall,
            conceptTraditionnel: "Besoin, Nécessité, Contrainte, Friction",
            visionCosmique: "Le Vide (Vacuum)",
            visionCosmiqueDescription: "Pression nécessaire pour qu'une étoile s'allume, épreuve forçant l'évolution.",
            message: "Identifie l'essentiel. Utilise la contrainte comme un levier de changement. La friction crée le feu.",
            imageName: "rune_naudhiz"
        ),
        RuneCard(
            number: 11,
            name: "ISA",
            letter: "I",
            aett: .heimdall,
            conceptTraditionnel: "Glace, Immobilité, Concentration, Moi",
            visionCosmique: "Le Zéro Absolu",
            visionCosmiqueDescription: "Arrêt du mouvement moléculaire, cristallisation du temps.",
            message: "Ne bouge pas. Ce n'est pas le moment d'agir. Gèle la situation pour mieux observer. Recentrage total.",
            imageName: "rune_isa"
        ),
        RuneCard(
            number: 12,
            name: "JERA",
            letter: "J",
            aett: .heimdall,
            conceptTraditionnel: "Récolte, Année, Cycle des saisons",
            visionCosmique: "La Révolution Planétaire",
            visionCosmiqueDescription: "Temps cyclique, cause et effet à long terme.",
            message: "Patience. Tu récolteras exactement ce que tu as semé. Le temps est ton allié.",
            imageName: "rune_jera"
        ),
        RuneCard(
            number: 13,
            name: "EIHWAZ",
            letter: "Ei",
            aett: .heimdall,
            conceptTraditionnel: "If (arbre), Vie et Mort, Endurance, Colonne vertébrale",
            visionCosmique: "Le Trou de Ver",
            visionCosmiqueDescription: "Canal reliant les dimensions, structure indestructible de la réalité.",
            message: "Une transformation profonde est en cours. Tu es protégé durant ce passage entre deux états.",
            imageName: "rune_eihwaz"
        ),
        RuneCard(
            number: 14,
            name: "PERTHRO",
            letter: "P",
            aett: .heimdall,
            conceptTraditionnel: "Cornet à dés, Hasard, Destin, Matrice",
            visionCosmique: "La Mécanique Quantique",
            visionCosmiqueDescription: "Champ de probabilités, état non observé et indéterminé.",
            message: "L'inconnu est à l'œuvre. Fais confiance au hasard. Une vérité cachée émergera de la boîte noire.",
            imageName: "rune_perthro"
        ),
        RuneCard(
            number: 15,
            name: "ALGIZ",
            letter: "Z",
            aett: .heimdall,
            conceptTraditionnel: "Élan, Protection, Connexion divine",
            visionCosmique: "L'Antenne",
            visionCosmiqueDescription: "Capacité à recevoir les fréquences supérieures, bouclier énergétique.",
            message: "Tu es protégé et guidé. Élève ta vibration. Suis ton instinct supérieur.",
            imageName: "rune_algiz"
        ),
        RuneCard(
            number: 16,
            name: "SOWILO",
            letter: "S",
            aett: .heimdall,
            conceptTraditionnel: "Soleil, Succès, Victoire, Guidage",
            visionCosmique: "La Fusion Nucléaire",
            visionCosmiqueDescription: "Source d'énergie inépuisable rayonnant sans effort, centre du système.",
            message: "Rayonne ce que tu es. Victoire assurée par ta présence lumineuse. Clarté totale.",
            imageName: "rune_sowilo"
        )
    ]

    // MARK: - Aett de Tyr (17-24) – La Synthèse Spirituelle

    static let aettTyr: [RuneCard] = [
        RuneCard(
            number: 17,
            name: "TIWAZ",
            letter: "T",
            aett: .tyr,
            conceptTraditionnel: "Dieu Tyr, Justice, Sacrifice, Étoile Polaire",
            visionCosmique: "L'Axe de Rotation",
            visionCosmiqueDescription: "Principe directeur inébranlable autour duquel tout tourne, justice universelle.",
            message: "Sois droit, juste, et prêt au sacrifice pour tes idéaux. Victoire par l'honnêteté et la discipline.",
            imageName: "rune_tiwaz"
        ),
        RuneCard(
            number: 18,
            name: "BERKANO",
            letter: "B",
            aett: .tyr,
            conceptTraditionnel: "Bouleau, Maternité, Croissance, Renouveau",
            visionCosmique: "La Nébuleuse",
            visionCosmiqueDescription: "Berceau d'étoiles, force douce et continue d'expansion de la vie.",
            message: "Un nouveau projet ou une nouvelle vie germe. Protège ce début fragile. Croissance douce et silencieuse.",
            imageName: "rune_berkano"
        ),
        RuneCard(
            number: 19,
            name: "EHWAZ",
            letter: "E",
            aett: .tyr,
            conceptTraditionnel: "Cheval, Mouvement, Duo, Confiance",
            visionCosmique: "L'Intrication",
            visionCosmiqueDescription: "Deux particules intriquées agissant comme une seule, voyage astral.",
            message: "Progrès rapide grâce à une alliance de confiance. Corps et esprit travaillent ensemble.",
            imageName: "rune_ehwaz"
        ),
        RuneCard(
            number: 20,
            name: "MANNAZ",
            letter: "M",
            aett: .tyr,
            conceptTraditionnel: "Homme, Soi, Société, Intelligence",
            visionCosmique: "La Conscience Collective",
            visionCosmiqueDescription: "Réseau neuronal de l'univers, âme incarnée dans la matière.",
            message: "Connais-toi toi-même. Ton intellect et ton humanité sont les clés. Connecte-toi à ta famille d'âmes.",
            imageName: "rune_mannaz"
        ),
        RuneCard(
            number: 21,
            name: "LAGUZ",
            letter: "L",
            aett: .tyr,
            conceptTraditionnel: "Eau, Lac, Intuition, Inconscient",
            visionCosmique: "L'Onde",
            visionCosmiqueDescription: "Flux d'énergie traversant l'espace, émotions comme vecteurs de réalité.",
            message: "Laisse-toi porter par le courant. Écoute tes rêves. Sois fluide.",
            imageName: "rune_laguz"
        ),
        RuneCard(
            number: 22,
            name: "INGWAZ",
            letter: "Ng",
            aett: .tyr,
            conceptTraditionnel: "Dieu Ing, Fertilité interne, Gestation",
            visionCosmique: "L'ADN",
            visionCosmiqueDescription: "Code complet contenu dans une cellule avant la division, énergie potentielle stockée.",
            message: "Retraite fertile en toi-même. Tout est là, prêt à éclore. Termine ce cycle avant de t'ouvrir au nouveau.",
            imageName: "rune_ingwaz"
        ),
        RuneCard(
            number: 23,
            name: "OTHALA",
            letter: "O",
            aett: .tyr,
            conceptTraditionnel: "Terre ancestrale, Propriété, Racines",
            visionCosmique: "La Galaxie d'Origine",
            visionCosmiqueDescription: "Structure stable dont nous sommes issus, héritage génétique et spirituel.",
            message: "Honore tes racines et ce que tu as acquis. Consolide tes fondations. C'est ton royaume.",
            imageName: "rune_othala"
        ),
        RuneCard(
            number: 24,
            name: "DAGAZ",
            letter: "D",
            aett: .tyr,
            conceptTraditionnel: "Jour, Aube, Équilibre des polarités, Éveil",
            visionCosmique: "Le Saut Quantique",
            visionCosmiqueDescription: "Passage instantané de la nuit au jour, illumination, hyperespace.",
            message: "Changement radical de paradigme. La lumière chasse l'ombre. Tu passes à un niveau supérieur de conscience.",
            imageName: "rune_dagaz"
        )
    ]
}
