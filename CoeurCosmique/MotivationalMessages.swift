import Foundation

enum MotivationalMessages {
    static let daily: [String] = [
        "Tu es exactement là où tu dois être.",
        "Fais confiance au processus, même dans l'ombre.",
        "Chaque jour est une page blanche de ton histoire sacrée.",
        "L'univers conspire en ta faveur, ouvre les yeux.",
        "Ta lumière intérieure est ton guide le plus fidèle.",
        "Ce qui est pour toi ne passera jamais à côté de toi.",
        "Respire. Tout se met en place.",
        "Tu portes en toi la force de mille étoiles.",
        "Aujourd'hui, choisis de croire en ta magie.",
        "Laisse ton intuition te montrer le chemin.",
        "Le courage, c'est avancer même quand le chemin est flou.",
        "Tu mérites l'amour que tu donnes aux autres.",
        "Chaque épreuve est un tremplin vers ta version la plus haute.",
        "Accueille le changement, il porte un cadeau caché.",
        "Ton âme sait ce que ton mental cherche encore.",
        "La patience est la clé des transformations profondes.",
        "Tu n'es pas en retard, tu es en devenir.",
        "Ose demander ce que ton cœur désire vraiment.",
        "La vulnérabilité est ta plus grande force.",
        "Aujourd'hui est un bon jour pour recommencer.",
        "Ton énergie attire ce qui te ressemble.",
        "Lâche ce qui ne te fait plus grandir.",
        "Tu es la créatrice de ta propre réalité.",
        "Chaque petit pas compte sur le chemin de l'éveil.",
        "Aligne tes actions avec tes intentions les plus pures.",
        "La gratitude ouvre les portes de l'abondance.",
        "Fais de ta vie un rituel sacré.",
        "Tu es déjà entière, tu n'as rien à prouver.",
        "Le silence intérieur est ton plus beau refuge.",
        "Honore ton rythme, il est unique et parfait.",
        "Les étoiles t'observent avec fierté.",
    ]

    static func randomMessage() -> String {
        daily.randomElement() ?? daily[0]
    }

    static func messageForDate(_ date: Date = Date()) -> String {
        let calendar = Calendar.current
        let day = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = (day - 1) % daily.count
        return daily[index]
    }

    static let greetings: [String: String] = [
        "morning": "Bonjour, belle âme",
        "afternoon": "Bon après-midi, belle âme",
        "evening": "Bonsoir, belle âme",
        "night": "Bonne nuit, belle âme"
    ]

    static func greeting(for date: Date = Date()) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12: return greetings["morning"]!
        case 12..<17: return greetings["afternoon"]!
        case 17..<22: return greetings["evening"]!
        default: return greetings["night"]!
        }
    }
}
