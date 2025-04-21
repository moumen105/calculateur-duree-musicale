#!/bin/bash

echo "Initialisation du dépôt Git pour le Calculateur de Durée Musicale"

# Vérifier si Git est installé
if ! command -v git &> /dev/null; then
    echo "Git n'est pas installé. Veuillez l'installer pour continuer."
    exit 1
fi

# Initialiser le dépôt local
git init

# Ajouter les fichiers au suivi
git add app.py templates/ requirements.txt Procfile README.md .gitignore

# Créer le premier commit
git commit -m "Version initiale du Calculateur de Durée Musicale"

echo "Configuration pour GitHub et Render terminée !"
echo
echo "Pour publier sur GitHub, exécutez les commandes suivantes :"
echo
echo "1. Créez un nouveau dépôt sur GitHub sans README, .gitignore ou license"
echo "2. Puis exécutez les commandes suivantes en remplaçant l'URL par celle de votre dépôt :"
echo
echo "   git remote add origin https://github.com/votre-nom/calculateur-duree-musicale.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo
echo "3. Une fois sur GitHub, connectez-vous à Render pour déployer l'application"

git status 

git rebase --abort 

git push -f origin main 