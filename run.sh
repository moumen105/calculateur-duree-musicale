#!/bin/bash

# Vérifier si Python est installé
if ! command -v python3 &> /dev/null; then
    echo "Python 3 n'est pas installé. Veuillez l'installer pour exécuter cette application."
    exit 1
fi

# Vérifier si l'environnement virtuel existe, sinon le créer
if [ ! -d "venv" ]; then
    echo "Création de l'environnement virtuel..."
    python3 -m venv venv
fi

# Activer l'environnement virtuel
source venv/bin/activate

# Installer les dépendances si nécessaire
pip install -r requirements.txt

# Lancer l'application
echo "Démarrage de l'application Calculateur de Durée Musicale..."
python app.py

# Désactiver l'environnement virtuel à la sortie
deactivate 