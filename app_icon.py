"""
Script pour créer une icône pour l'application
Nécessite PIL (Pillow)
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_icon():
    try:
        # Créer une image carrée avec un fond transparent
        img_size = 1024
        img = Image.new('RGBA', (img_size, img_size), color=(0, 0, 0, 0))
        draw = ImageDraw.Draw(img)
        
        # Dessiner un cercle bleu comme fond
        circle_margin = 50
        circle_size = img_size - (2 * circle_margin)
        circle_pos = (circle_margin, circle_margin)
        circle_end = (circle_margin + circle_size, circle_margin + circle_size)
        draw.ellipse([circle_pos, circle_end], fill=(77, 148, 255, 255))
        
        # Ajouter le texte au centre, ici un symbole de note
        try:
            font = ImageFont.truetype("Arial.ttf", 600)
        except IOError:
            # Si Arial n'est pas disponible, utiliser une police par défaut
            font = ImageFont.load_default()
        
        # Symbole de note de musique ♩
        text = "♩"
        
        # Utiliser textbbox au lieu de textsize (qui est déprécié)
        left, top, right, bottom = draw.textbbox((0, 0), text, font=font)
        text_width = right - left
        text_height = bottom - top
        
        text_position = ((img_size - text_width) // 2, (img_size - text_height) // 2 - 100)
        draw.text(text_position, text, fill=(255, 255, 255, 255), font=font)
        
        # Sauvegarder l'image en format PNG
        img.save("icon.png", "PNG")
        
        print("Icône créée avec succès : icon.png")
        
        # Sur macOS, convertir en icône .icns
        if os.path.exists("/usr/bin/sips") and os.path.exists("/usr/bin/iconutil"):
            os.system("mkdir -p icon.iconset")
            
            # Générer différentes tailles d'icônes
            for size in [16, 32, 64, 128, 256, 512, 1024]:
                os.system(f"sips -z {size} {size} icon.png --out icon.iconset/icon_{size}x{size}.png")
                os.system(f"sips -z {size*2} {size*2} icon.png --out icon.iconset/icon_{size}x{size}@2x.png")
            
            # Créer le fichier .icns
            os.system("iconutil -c icns icon.iconset")
            os.system("rm -rf icon.iconset")
            
            print("Fichier icône .icns créé avec succès : icon.icns")
    except Exception as e:
        print(f"Erreur lors de la création de l'icône : {e}")
        print("Installez Pillow avec : pip install pillow")

if __name__ == "__main__":
    create_icon() 