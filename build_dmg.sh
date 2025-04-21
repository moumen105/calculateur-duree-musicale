#!/bin/bash

echo "Préparation de la création du fichier .dmg pour l'application Calculateur de Durée Musicale..."

# Vérifier si Python est installé
if ! command -v python3 &> /dev/null; then
    echo "Python 3 n'est pas installé. Veuillez l'installer pour créer l'application."
    exit 1
fi

# Vérifier si py2app est installé, sinon l'installer
if ! pip show py2app &> /dev/null; then
    echo "Installation de py2app..."
    pip install py2app
fi

# Activer l'environnement virtuel si existant
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Nettoyer les anciens builds
echo "Nettoyage des anciens builds..."
rm -rf build dist

# Installer les dépendances nécessaires
echo "Installation des dépendances..."
pip install -r requirements.txt

# Construire l'application avec py2app
echo "Construction de l'application..."
python setup.py py2app

# Vérifier si l'application a été créée avec succès
if [ -d "dist/CalculateurDureeMusicale.app" ]; then
    echo "Application créée avec succès dans le dossier dist/"
    
    # Créer le DMG si create-dmg est installé
    if command -v create-dmg &> /dev/null; then
        echo "Création du fichier DMG..."
        create-dmg \
            --volname "CalculateurDureeMusicale" \
            --volicon "icon.icns" \
            --window-pos 200 120 \
            --window-size 800 400 \
            --icon-size 100 \
            --icon "CalculateurDureeMusicale.app" 200 190 \
            --hide-extension "CalculateurDureeMusicale.app" \
            --app-drop-link 600 185 \
            "dist/CalculateurDureeMusicale.dmg" \
            "dist/CalculateurDureeMusicale.app"
        
        echo "Fichier DMG créé avec succès : dist/CalculateurDureeMusicale.dmg"
    else
        echo "Pour créer un fichier DMG, veuillez installer create-dmg :"
        echo "brew install create-dmg"
        echo ""
        echo "Alternativement, vous pouvez utiliser l'utilitaire Disk Utility de macOS pour créer un DMG manuellement."
    fi
else
    echo "Erreur lors de la création de l'application."
    exit 1
fi

# Désactiver l'environnement virtuel si activé
if [ -d "venv" ]; then
    deactivate
fi 