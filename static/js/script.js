document.addEventListener('DOMContentLoaded', function() {
    const noteSelect = document.getElementById('note');
    const symboleDisplay = document.getElementById('symbole');
    const calculerBtn = document.getElementById('calculer');
    const resultatDiv = document.getElementById('resultat');
    
    // Mettre à jour le symbole quand la note change
    noteSelect.addEventListener('change', updateSymbol);
    
    // Initialiser le symbole avec la première option
    updateSymbol();
    
    // Ajouter l'événement au bouton Calculer
    calculerBtn.addEventListener('click', calculerDuree);
    
    function updateSymbol() {
        const selectedNote = noteSelect.value;
        fetch('/get_symbol', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ note: selectedNote })
        })
        .then(response => response.json())
        .then(data => {
            symboleDisplay.textContent = `Symbole : ${data.symbole}`;
        })
        .catch(error => {
            console.error('Erreur:', error);
        });
    }
    
    function calculerDuree() {
        // Récupérer les valeurs du formulaire
        const mesures = document.getElementById('mesures').value;
        const numerateur = document.getElementById('numerateur').value;
        const denominateur = document.getElementById('denominateur').value;
        const note = noteSelect.value;
        const tempo = document.getElementById('tempo').value;
        
        // Valider les entrées
        if (!mesures || !numerateur || !denominateur || !tempo) {
            alert('Veuillez remplir tous les champs.');
            return;
        }
        
        // Envoyer les données au serveur
        fetch('/calculer', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                mesures: mesures,
                numerateur: numerateur,
                denominateur: denominateur,
                note: note,
                tempo: tempo
            })
        })
        .then(response => {
            if (!response.ok) {
                return response.json().then(data => {
                    throw new Error(data.error || 'Une erreur est survenue');
                });
            }
            return response.json();
        })
        .then(data => {
            // Afficher les résultats
            document.getElementById('millenaires').textContent = data.duree.millenaires;
            document.getElementById('centuries').textContent = data.duree.centuries;
            document.getElementById('years').textContent = data.duree.years;
            document.getElementById('months').textContent = data.duree.months;
            document.getElementById('days').textContent = data.duree.days;
            document.getElementById('hours').textContent = data.duree.hours;
            document.getElementById('minutes').textContent = data.duree.minutes;
            document.getElementById('seconds').textContent = data.duree.seconds;
            document.getElementById('milliseconds').textContent = data.duree.milliseconds;
            
            // Afficher la section des résultats
            resultatDiv.classList.remove('hidden');
        })
        .catch(error => {
            alert(error.message);
            console.error('Erreur:', error);
        });
    }
}); 