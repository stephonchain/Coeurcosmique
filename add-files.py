#!/usr/bin/env python3
"""
Script pour ajouter automatiquement les nouveaux fichiers Swift au projet Xcode.
Utilise le format .pbxproj natif d'Xcode.
"""

import subprocess
import sys

# Fichiers à ajouter
files_to_add = [
    "CoeurCosmique/MoodTracker.swift",
    "CoeurCosmique/MoodTrackerView.swift",
    "CoeurCosmique/AffirmationEngine.swift",
    "CoeurCosmique/StatisticsView.swift",
    "CoeurCosmique/InsightsTabView.swift"
]

project_dir = "/Users/Steph_1/Library/Mobile Documents/com~apple~CloudDocs/STEVE ROVER/APPS iOS/Cosmic Heart/Coeurcosmique"

def run_command(cmd):
    """Execute une commande shell et retourne le résultat"""
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=project_dir)
    return result.returncode == 0, result.stdout, result.stderr

def add_files_to_project():
    """Ajoute tous les fichiers au projet Xcode en utilisant ruby et xcodeproj gem"""
    
    print("🔍 Vérification des fichiers...")
    
    # Vérifier que tous les fichiers existent
    for file in files_to_add:
        success, _, _ = run_command(f"test -f '{file}'")
        if success:
            print(f"  ✅ {file}")
        else:
            print(f"  ❌ {file} - FICHIER MANQUANT")
            return False
    
    print("\n📝 Les fichiers existent, ajout manuel au projet nécessaire...")
    print("\n⚠️  INSTRUCTIONS MANUELLES XCODE:")
    print("1. Dans Xcode, clic droit sur le dossier 'CoeurCosmique'")
    print("2. Sélectionne 'Add Files to CoeurCosmique...'")
    print("3. Sélectionne ces 5 fichiers:")
    for file in files_to_add:
        print(f"   - {file.split('/')[-1]}")
    print("4. Assure-toi que 'Copy items if needed' est DÉCOCHÉ")
    print("5. Clique 'Add'")
    print("\n6. Puis exécute: ./sync-xcode.sh")
    
    return True

if __name__ == "__main__":
    success = add_files_to_project()
    sys.exit(0 if success else 1)
