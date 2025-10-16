<?php
// Test simple de l'API Competences

// Test de connexion à la base
require_once __DIR__ . '/app/Core/Database.php';

try {
    $db = Database::getConnection();
    echo "✅ Connexion à la base de données : OK\n\n";

    // Test du modèle Competence
    require_once __DIR__ . '/app/Models/Competence.php';
    $competenceModel = new Competence();

    // Récupérer toutes les compétences
    echo "📋 Liste des compétences :\n";
    $competences = $competenceModel->getAll();

    if (empty($competences)) {
        echo "  Aucune compétence trouvée.\n\n";

        // Ajouter une compétence de test
        echo "➕ Ajout d'une compétence de test...\n";
        $result = $competenceModel->create('JavaScript');
        if ($result['success']) {
            echo "  ✅ Compétence créée avec l'ID : " . $result['id'] . "\n";
        }

        // Récupérer à nouveau
        $competences = $competenceModel->getAll();
    }

    // Afficher les compétences
    foreach ($competences as $comp) {
        echo "  - ID: " . $comp['id_Competence'] . " | " . $comp['Libelle'] . "\n";
    }

    echo "\n✅ Tous les tests sont passés !\n";

} catch (Exception $e) {
    echo "❌ Erreur : " . $e->getMessage() . "\n";
}