# Coeur Cosmique — App iOS de Tarot

App iOS moderne et minimaliste de Tarot et motivation, entierement en francais, construite avec SwiftUI.

## Ouvrir dans Xcode

1. Cloner le repo : `git clone https://github.com/stephonchain/Coeurcosmique.git`
2. Ouvrir `CoeurCosmique.xcodeproj` dans Xcode 15+
3. Selectionner un simulateur iPhone (iOS 17+)
4. Build & Run (Cmd+R)

## Fonctionnalites

- **Carte du jour** : tirage quotidien avec message de motivation
- **Tirages** : 5 types de tirage (Guidance, Passe/Present/Futur, Relationnel, Situation/Action/Resultat, Oui/Non)
- **Collection** : galerie des 78 cartes du Tarot Rider-Waite avec recherche et filtres
- **Journal** : historique de toutes tes lectures passees
- **Messages de motivation** : affirmations quotidiennes en francais
- **Design cosmique** : theme sombre avec accents dores, animations de retournement de cartes

## Architecture

```
CoeurCosmique/                    # App iOS (ouvrir .xcodeproj)
  CoeurCosmiqueApp.swift          # Point d'entree
  ContentView.swift               # TabView principale + barre custom
  AppViewModel.swift              # ViewModel principal (ObservableObject)
  CosmicTheme.swift               # Couleurs, polices, styles
  TarotCard.swift                 # Modele de carte
  TarotDeck.swift                 # 78 cartes Rider-Waite FR
  TarotSpread.swift               # Types de tirage
  TarotReadingEngine.swift        # Moteur de tirage aleatoire
  DailyCardStore.swift            # Persistance carte du jour
  ReadingHistoryStore.swift       # Historique des lectures
  MotivationalMessages.swift      # Messages de motivation
  HomeView.swift                  # Ecran d'accueil
  DrawView.swift                  # Ecran de tirage
  CollectionView.swift            # Galerie des cartes
  CardDetailView.swift            # Detail d'une carte
  JournalView.swift               # Historique
  TarotCardView.swift             # Composants carte (front/back/flip)
  CosmicBackground.swift          # Fond anime avec etoiles
  Assets.xcassets/                # Icones et couleurs

Sources/TarotCore/                # Librairie Swift Package (legacy)
Tests/TarotCoreTests/             # Tests unitaires
```

## 78 Cartes incluses

- **22 Arcanes Majeurs** : Le Mat, Le Magicien, La Papesse, L'Imperatrice, L'Empereur, Le Pape, L'Amoureux, Le Chariot, La Justice, L'Hermite, La Roue de Fortune, La Force, Le Pendu, L'Arcane sans nom, Temperance, Le Diable, La Maison Dieu, L'Etoile, La Lune, Le Soleil, Le Jugement, Le Monde
- **56 Arcanes Mineurs** : Coupes, Batons, Epees, Deniers (As a Roi, 14 cartes par couleur)

Chaque carte comprend :
- Mots-cles en francais
- Signification en position droite et inversee
- Interpretations contextuelles (general, amour, carriere, spirituel)

## Configuration requise

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+
