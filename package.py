"""
Script pour créer une application exécutable avec PyInstaller
"""

import os
import sys
import subprocess

def create_executable():
    print("Création d'une application exécutable avec PyInstaller...")
    
    # Installer PyInstaller si nécessaire
    try:
        import PyInstaller
    except ImportError:
        print("Installation de PyInstaller...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "PyInstaller"])
    
    # Créer le dossier dist si nécessaire
    if not os.path.exists("dist"):
        os.makedirs("dist")
    
    # Options pour PyInstaller
    options = [
        "--name=CalculateurDureeMusicale",
        "--onefile",  # Créer un seul fichier exécutable
        "--windowed",  # Application GUI sans console
        "--add-data=templates:templates",  # Ajouter le dossier templates
    ]
    
    # Ajouter l'icône si elle existe
    if os.path.exists("icon.icns"):
        options.append(f"--icon=icon.icns")
    
    # Construire la commande PyInstaller
    command = [sys.executable, "-m", "PyInstaller"] + options + ["app.py"]
    
    # Exécuter la commande
    print("Exécution de la commande PyInstaller...")
    print(" ".join(command))
    subprocess.check_call(command)
    
    print("Application exécutable créée avec succès !")
    print(f"Vous pouvez trouver l'exécutable dans le dossier 'dist'")

if __name__ == "__main__":
    create_executable() 