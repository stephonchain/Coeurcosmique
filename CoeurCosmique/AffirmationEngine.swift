import Foundation

// MARK: - Affirmation

struct Affirmation: Identifiable, Codable {
    let id: UUID
    let text: String
    let cardName: String
    var isFavorite: Bool
    
    init(id: UUID = UUID(), text: String, cardName: String, isFavorite: Bool = false) {
        self.id = id
        self.text = text
        self.cardName = cardName
        self.isFavorite = isFavorite
    }
}

// MARK: - Affirmation Engine

@MainActor
class AffirmationEngine: ObservableObject {
    @Published private(set) var currentAffirmation: Affirmation?
    @Published private(set) var favorites: [Affirmation] = []
    
    private let favoritesKey = "SavedFavoriteAffirmations"
    
    // Database of affirmations per oracle card
    private let affirmationsDatabase: [String: [String]] = [
        // Oracle Cards
        "Reine": [
            "Je règne sur ma vie avec grâce et dignité",
            "Je suis souveraine de mes choix et de mon destin",
            "Je m'accorde le droit de briller pleinement"
        ],
        "Énergie": [
            "Je canalise mon énergie vers ce qui compte vraiment",
            "Ma vitalité rayonne et inspire les autres",
            "Je suis une source inépuisable de force et de lumière"
        ],
        "Magie": [
            "Je crois en l'impossible et attire les miracles",
            "La magie opère dans chaque instant de ma vie",
            "Je suis ouvert·e à l'émerveillement et aux synchronicités"
        ],
        "Bénédiction": [
            "Je suis béni·e et protégé·e par des forces bienveillantes",
            "Chaque instant porte la trace du sacré",
            "Je reconnais et accueille les bénédictions dans ma vie"
        ],
        "Équilibre": [
            "Je trouve mon centre en toutes circonstances",
            "J'harmonise tous les aspects de mon être",
            "Prendre soin de moi est une priorité essentielle"
        ],
        "Humilité": [
            "J'accepte mes limites avec bienveillance",
            "La simplicité est ma plus grande force",
            "Je reste humble face aux mystères de la vie"
        ],
        "Amour": [
            "Je suis amour, je donne et reçois l'amour librement",
            "Mon cœur s'ouvre à l'infini",
            "L'amour guide chacune de mes actions"
        ],
        "Sagesse": [
            "Je puise dans ma sagesse intérieure pour guider mes pas",
            "Chaque expérience enrichit ma compréhension du monde",
            "Je fais confiance à mon intuition profonde"
        ],
        "Gratitude": [
            "Je suis reconnaissant·e pour tout ce que j'ai",
            "La gratitude transforme ma vie en abondance",
            "Chaque jour, je trouve des raisons de remercier"
        ],
        "Paix": [
            "La paix commence en moi et rayonne autour de moi",
            "Je choisis la sérénité en toutes circonstances",
            "Mon cœur est un havre de paix"
        ],
        "Force": [
            "Je suis plus fort·e que je ne l'imagine",
            "J'ai en moi toutes les ressources pour surmonter les défis",
            "Ma force intérieure est inébranlable"
        ],
        "Patience": [
            "J'accorde du temps à ce qui doit mûrir",
            "La patience me permet de voir plus loin",
            "Je fais confiance au rythme naturel de ma vie"
        ],
        "Créativité": [
            "Je suis une source infinie de créativité",
            "Mon imagination me guide vers de nouvelles possibilités",
            "Je laisse ma créativité s'exprimer librement"
        ],
        "Inspiration": [
            "Je suis inspiré·e et j'inspire les autres",
            "Des idées brillantes me viennent naturellement",
            "Je suis un canal d'inspiration divine"
        ],
        "Victoire": [
            "Je célèbre chaque victoire, grande ou petite",
            "Le succès est mon droit de naissance",
            "Je triomphe avec humilité et gratitude"
        ],
        "Libération": [
            "Je me libère de tout ce qui ne me sert plus",
            "Je laisse partir le passé avec amour",
            "Je suis libre de créer ma propre réalité"
        ],
        "Abondance": [
            "L'abondance coule naturellement vers moi",
            "Je mérite de recevoir en plénitude",
            "Ma vie déborde de richesses en tous genres"
        ],
        "Guérisseuse": [
            "Je possède un pouvoir de guérison profond",
            "Ma présence apporte réconfort et transformation",
            "Je guéris et je me guéris avec amour"
        ],
        "Vision": [
            "Je vois clairement le chemin devant moi",
            "Ma vision intérieure illumine mon parcours",
            "Je fais confiance à ma capacité à voir au-delà"
        ],
        "Beauté": [
            "Je reconnais la beauté en moi et autour de moi",
            "Je rayonne de l'intérieur",
            "La beauté de mon âme éclaire le monde"
        ],
        "Grâce": [
            "Je me déplace dans la vie avec grâce et fluidité",
            "Je suis porté·e par une légèreté divine",
            "La grâce guide mes pas"
        ],
        "Élégance": [
            "Je cultive l'élégance dans mes pensées et mes actes",
            "Ma présence est raffinée et inspirante",
            "L'élégance est mon art de vivre"
        ],
        "Spiritualité": [
            "Je suis connecté·e à ma dimension spirituelle",
            "Mon âme guide mon chemin",
            "Je m'élève vers des plans de conscience supérieurs"
        ],
        "Éveil": [
            "Je m'éveille à ma véritable nature",
            "Chaque jour, je deviens plus conscient·e",
            "Mon éveil transforme ma perception du monde"
        ],
        "Voyage": [
            "Chaque voyage enrichit mon âme",
            "Je suis ouvert·e aux découvertes et aux rencontres",
            "La vie est une aventure magnifique"
        ],
        "Succès": [
            "Le succès me sourit dans tous mes projets",
            "Je mérite de réussir et de briller",
            "Mes efforts portent leurs fruits"
        ],
        "Chance": [
            "La chance est de mon côté",
            "Je suis au bon endroit au bon moment",
            "Les opportunités s'ouvrent sur mon chemin"
        ],
        "Communication": [
            "Je communique avec clarté et authenticité",
            "Mes mots créent des ponts entre les cœurs",
            "Je m'exprime avec confiance et bienveillance"
        ],
        "Désir": [
            "J'honore mes désirs profonds",
            "Mes aspirations me guident vers mon épanouissement",
            "Je m'autorise à désirer et à manifester"
        ],
        "Passion": [
            "Je vis avec passion et intensité",
            "Mon feu intérieur illumine mon chemin",
            "Je m'engage pleinement dans ce qui m'anime"
        ],
        "Réflexion": [
            "Je prends le temps de réfléchir avant d'agir",
            "Ma réflexion m'apporte clarté et discernement",
            "Je cultive un espace de réflexion intérieure"
        ],
        "Raison": [
            "Je fais confiance à ma logique et mon bon sens",
            "L'équilibre entre raison et intuition me guide",
            "Je prends des décisions éclairées"
        ],
        "Sincérité": [
            "Je suis authentique dans toutes mes relations",
            "Ma sincérité crée des liens profonds",
            "Je m'exprime avec vérité et cœur"
        ],
        "Simplicité": [
            "Je trouve la beauté dans la simplicité",
            "L'essentiel suffit à mon bonheur",
            "Je simplifie ma vie pour mieux vivre"
        ],
        "Stabilité": [
            "Je suis ancré·e et stable comme un roc",
            "Ma base solide me permet de m'élever",
            "Je cultive la stabilité dans ma vie"
        ],
        "Persévérance": [
            "Je persévère avec détermination",
            "Rien ne peut m'arrêter quand je crois en moi",
            "Ma persévérance transforme les obstacles en opportunités"
        ],
        "Adaptation": [
            "Je m'adapte avec fluidité aux changements",
            "Ma souplesse est une force",
            "J'embrasse l'imprévu avec confiance"
        ],
        "Récompense": [
            "Je reçois les récompenses de mes efforts",
            "L'univers me rend ce que je donne",
            "Je célèbre mes accomplissements"
        ],
        "Épanouissement": [
            "Je m'épanouis pleinement",
            "Chaque jour, je deviens la meilleure version de moi-même",
            "Mon épanouissement rayonne autour de moi"
        ],
        "Gardienne": [
            "Je protège ce qui m'est précieux",
            "Je suis gardienne de mes valeurs et de mes rêves",
            "Ma vigilance bienveillante guide mes proches"
        ],
        "Énigme": [
            "J'accueille les mystères de la vie avec curiosité",
            "Chaque énigme révèle une vérité profonde",
            "Je suis confortable avec l'inconnu"
        ],
        "Métamorphose": [
            "Je me transforme avec grâce",
            "Chaque métamorphose me rapproche de ma vérité",
            "J'embrasse le changement comme une renaissance"
        ]
    ]
    
    init() {
        loadFavorites()
    }
    
    // MARK: - Generate Affirmation
    
    func generateAffirmation(forCard cardName: String) -> Affirmation {
        let affirmations = affirmationsDatabase[cardName] ?? [
            "Je suis aligné·e avec mon chemin",
            "Je fais confiance au processus de la vie",
            "Je suis exact·e·ment là où je dois être"
        ]
        
        let randomText = affirmations.randomElement() ?? affirmations[0]
        let affirmation = Affirmation(text: randomText, cardName: cardName)
        
        currentAffirmation = affirmation
        return affirmation
    }
    
    func regenerateCurrentAffirmation() {
        guard let current = currentAffirmation else { return }
        _ = generateAffirmation(forCard: current.cardName)
    }
    
    // MARK: - Favorites
    
    func toggleFavorite(_ affirmation: Affirmation) {
        if let index = favorites.firstIndex(where: { $0.id == affirmation.id }) {
            favorites.remove(at: index)
        } else {
            var fav = affirmation
            fav.isFavorite = true
            favorites.append(fav)
        }
        saveFavorites()
    }
    
    func isFavorite(_ affirmation: Affirmation) -> Bool {
        favorites.contains(where: { $0.id == affirmation.id })
    }
    
    // MARK: - Persistence
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let decoded = try? JSONDecoder().decode([Affirmation].self, from: data) else {
            return
        }
        favorites = decoded
    }
}
