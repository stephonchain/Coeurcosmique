# Cœur Cosmique — Tarot iOS

App iOS SwiftUI pour des tirages de Tarot en français, avec une base complète prête pour la production.

## Ce qui est implémenté

- Core Tarot (`TarotCore`) :
  - deck Rider-Waite FR de **78 cartes**,
  - mots-clés + significations droite/renversée,
  - interprétations (générale, amour, carrière, spirituel),
  - moteur de tirage aléatoire sans doublons.
- Tirages :
  - Carte du jour,
  - Passé / Présent / Futur,
  - Relationnel,
  - Situation / Action / Résultat.
- Persistance locale :
  - carte du jour (UserDefaults),
  - journal de tirages (historique JSON en local).
- UI SwiftUI prête à intégrer dans un target iOS :
  - onglet tirage,
  - onglet journal,
  - onglet catalogue des 78 cartes.

## Lancer les tests

```bash
swift test
```

## Structure

- `Sources/TarotCore/` : logique métier réutilisable.
- `ios/CoeurCosmiqueApp/` : écrans SwiftUI à copier dans un projet Xcode iOS.

## Intégration Notion (prochaine étape)

Le contenu complet (descriptions éditoriales exactes de ton Notion) n'est pas encore synchronisé automatiquement. L'app contient déjà une base complète utilisable, et la prochaine itération consiste à:

1. exporter la base Notion (CSV/Markdown/API),
2. mapper les champs vers `TarotCard` (keywords, interprétation, rituels, mantras),
3. remplacer/enrichir le dataset local.
