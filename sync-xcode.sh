#!/bin/bash

# Script pour synchroniser les fichiers Xcode avec Git
# À exécuter après avoir ajouté/supprimé des fichiers dans Xcode

cd "/Users/Steph_1/Library/Mobile Documents/com~apple~CloudDocs/STEVE ROVER/APPS iOS/Cosmic Heart/Coeurcosmique"

echo "🔍 Vérification des modifications Xcode..."

# Vérifier si project.pbxproj a été modifié
if git diff --name-only | grep -q "CoeurCosmique.xcodeproj/project.pbxproj"; then
    echo "✅ Modifications détectées dans project.pbxproj"
    echo ""
    echo "📝 Ajout et commit du fichier projet..."
    
    git add CoeurCosmique.xcodeproj/project.pbxproj
    git commit -m "chore: Update Xcode project references"
    
    echo ""
    echo "🚀 Push vers le dépôt distant..."
    git push
    
    echo ""
    echo "✨ Synchronisation terminée !"
    echo "👉 Les fichiers persisteront maintenant après un pull."
else
    echo "ℹ️  Aucune modification détectée dans project.pbxproj"
    echo "Ajoute d'abord les fichiers dans Xcode, puis réexécute ce script."
fi
