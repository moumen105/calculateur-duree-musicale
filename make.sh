#!/bin/bash

# Couleurs pour améliorer la lisibilité
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Afficher l'aide
show_help() {
    echo -e "${BLUE}Calculateur de Durée Musicale - Utilitaire de gestion${NC}"
    echo
    echo "Usage: ./make.sh [commande]"
    echo
    echo "Commandes disponibles:"
    echo -e "  ${GREEN}run${NC}      Exécuter l'application web"
    echo -e "  ${GREEN}setup${NC}    Installer les dépendances nécessaires"
    echo -e "  ${GREEN}icon${NC}     Générer l'icône de l'application"
    echo -e "  ${GREEN}dmg${NC}      Construire l'application macOS (.dmg) avec py2app"
    echo -e "  ${GREEN}exe${NC}      Construire un exécutable avec PyInstaller"
    echo -e "  ${GREEN}clean${NC}    Nettoyer les fichiers temporaires"
    echo -e "  ${GREEN}help${NC}     Afficher cette aide"
}

# Configuration de l'environnement
setup_env() {
    echo -e "${BLUE}Installation des dépendances...${NC}"
    
    # Vérifier si Python est installé
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Python 3 n'est pas installé. Veuillez l'installer pour exécuter cette application.${NC}"
        exit 1
    fi
    
    # Créer l'environnement virtuel si nécessaire
    if [ ! -d "venv" ]; then
        echo -e "${YELLOW}Création de l'environnement virtuel...${NC}"
        python3 -m venv venv
    fi
    
    # Activer l'environnement virtuel
    source venv/bin/activate
    
    # Installer les dépendances
    pip install -r requirements.txt
    
    echo -e "${GREEN}Configuration terminée avec succès.${NC}"
}

# Exécuter l'application
run_app() {
    echo -e "${BLUE}Démarrage de l'application...${NC}"
    
    # Activer l'environnement virtuel
    source venv/bin/activate
    
    # Lancer l'application
    python app.py
}

# Générer l'icône
create_icon() {
    echo -e "${BLUE}Génération de l'icône...${NC}"
    
    # Activer l'environnement virtuel
    source venv/bin/activate
    
    # Exécuter le script de génération d'icône
    python app_icon.py
    
    echo -e "${GREEN}Génération de l'icône terminée.${NC}"
}

# Construire le DMG
build_dmg() {
    echo -e "${BLUE}Création du fichier DMG...${NC}"
    
    # Vérifier si les dépendances sont installées
    source venv/bin/activate
    if ! pip show py2app &> /dev/null; then
        echo -e "${YELLOW}Installation de py2app...${NC}"
        pip install py2app
    fi
    
    # Générer l'icône si elle n'existe pas
    if [ ! -f "icon.icns" ]; then
        echo -e "${YELLOW}L'icône n'existe pas, génération en cours...${NC}"
        python app_icon.py
    fi
    
    # Nettoyer les anciens builds
    echo -e "${YELLOW}Nettoyage des anciens builds...${NC}"
    rm -rf build dist
    
    # Construire l'application avec py2app
    echo -e "${YELLOW}Construction de l'application...${NC}"
    python setup.py py2app
    
    # Vérifier si l'application a été créée avec succès
    if [ -d "dist/CalculateurDureeMusicale.app" ]; then
        echo -e "${GREEN}Application créée avec succès dans le dossier dist/${NC}"
        
        # Créer le DMG si create-dmg est installé
        if command -v create-dmg &> /dev/null; then
            echo -e "${YELLOW}Création du fichier DMG...${NC}"
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
            
            echo -e "${GREEN}Fichier DMG créé avec succès : dist/CalculateurDureeMusicale.dmg${NC}"
        else
            echo -e "${YELLOW}Pour créer un fichier DMG, veuillez installer create-dmg :${NC}"
            echo -e "${BLUE}brew install create-dmg${NC}"
            echo ""
            echo -e "${YELLOW}Alternativement, vous pouvez utiliser l'utilitaire Disk Utility de macOS pour créer un DMG manuellement.${NC}"
        fi
    else
        echo -e "${RED}Erreur lors de la création de l'application.${NC}"
        exit 1
    fi
}

# Créer un exécutable avec PyInstaller
build_exe() {
    echo -e "${BLUE}Création d'un exécutable avec PyInstaller...${NC}"
    
    # Activer l'environnement virtuel
    source venv/bin/activate
    
    # S'assurer que PyInstaller est installé
    if ! pip show pyinstaller &> /dev/null; then
        echo -e "${YELLOW}Installation de PyInstaller...${NC}"
        pip install pyinstaller
    fi
    
    # Générer l'icône si elle n'existe pas
    if [ ! -f "icon.icns" ]; then
        echo -e "${YELLOW}L'icône n'existe pas, génération en cours...${NC}"
        python app_icon.py
    fi
    
    # Exécuter le script de création d'exécutable
    echo -e "${YELLOW}Exécution du script de création d'exécutable...${NC}"
    python package.py
    
    echo -e "${GREEN}Exécutable créé avec succès.${NC}"
}

# Nettoyer les fichiers temporaires
clean() {
    echo -e "${BLUE}Nettoyage des fichiers temporaires...${NC}"
    
    # Supprimer les dossiers de build
    rm -rf build dist *.egg-info
    
    # Supprimer les fichiers Python compilés
    find . -name "*.pyc" -delete
    find . -name "__pycache__" -delete
    
    echo -e "${GREEN}Nettoyage terminé.${NC}"
}

# Traiter la commande fournie
case "$1" in
    run)
        setup_env
        run_app
        ;;
    setup)
        setup_env
        ;;
    icon)
        setup_env
        create_icon
        ;;
    dmg)
        setup_env
        build_dmg
        ;;
    exe)
        setup_env
        build_exe
        ;;
    clean)
        clean
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo -e "${RED}Commande non reconnue : $1${NC}"
        show_help
        exit 1
        ;;
esac

exit 0 