"""
Script de configuration pour py2app
Usage:
    python setup.py py2app
"""

from setuptools import setup

APP = ['app.py']
DATA_FILES = [
    ('templates', ['templates/index.html']),
]
OPTIONS = {
    'argv_emulation': False,
    'packages': ['flask', 'jinja2', 'werkzeug', 'itsdangerous', 'click', 'markupsafe'],
    'includes': ['jinja2.ext'],
    'excludes': ['_tkinter', 'tkinter', 'Tkinter', 'cryptography', 'watchdog', 'win32com'],
    'iconfile': 'icon.icns',
    'plist': {
        'CFBundleName': 'CalculateurDureeMusicale',
        'CFBundleDisplayName': 'Calculateur de Durée Musicale',
        'CFBundleIdentifier': 'com.duree.musicale',
        'CFBundleVersion': '1.0.0',
        'CFBundleShortVersionString': '1.0.0',
        'NSHumanReadableCopyright': 'Libre d\'utilisation',
        'LSBackgroundOnly': False,
        'NSHighResolutionCapable': True,
    },
}

setup(
    name='CalculateurDureeMusicale',
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
) 