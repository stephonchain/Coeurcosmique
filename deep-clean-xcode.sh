#!/bin/bash

# Script de nettoyage complet Xcode pour résoudre les problèmes de cache

cd "/Users/Steph_1/Library/Mobile Documents/com~apple~CloudDocs/STEVE ROVER/APPS iOS/Cosmic Heart/Coeurcosmique"

echo "🧹 Nettoyage complet Xcode..."

# 1. Fermer Xcode
echo "1️⃣ Fermeture de Xcode..."
osascript -e 'quit app "Xcode"' 2>/dev/null
sleep 2

# 2. Nettoyer DerivedData
echo "2️⃣ Nettoyage DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null

# 3. Nettoyer build local
echo "3️⃣ Nettoyage build local..."
rm -rf build/ 2>/dev/null

# 4. Nettoyer caches Xcode
echo "4️⃣ Nettoyage caches Xcode..."
rm -rf ~/Library/Caches/com.apple.dt.Xcode/* 2>/dev/null

# 5. Clean xcodebuild
echo "5️⃣ Clean avec xcodebuild..."
xcodebuild clean -project CoeurCosmique.xcodeproj -scheme CoeurCosmique 2>/dev/null

echo ""
echo "✅ Nettoyage terminé !"
echo ""
echo "👉 MAINTENANT :"
echo "1. Ouvre Xcode : open CoeurCosmique.xcodeproj"
echo "2. Dans Xcode : Product → Clean Build Folder (Cmd + Shift + K)"
echo "3. Rebuild : Cmd + B"
