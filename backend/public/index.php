<?php
require_once __DIR__ . '/../app/Core/Router.php';
require_once __DIR__ . '/../app/Core/Database.php';
require_once __DIR__ . '/../app/Controllers/CompetenceController.php';
require_once __DIR__ . '/../app/Controllers/NoteController.php';

// Routes pour les Compétences
$router->get('/api/competences', function () {
    $controller = new CompetenceController();
    $controller->getAllCompetences();
});

$router->get('/api/competences/{id}', function ($id) {
    $controller = new CompetenceController();
    $controller->getCompetence($id);
});

$router->post('/api/competences', function () {
    $controller = new CompetenceController();
    $controller->createCompetence();
});

$router->put('/api/competences/{id}', function ($id) {
    $controller = new CompetenceController();
    $controller->updateCompetence($id);
});

$router->delete('/api/competences/{id}', function ($id) {
    $controller = new CompetenceController();
    $controller->deleteCompetence($id);
});

// Routes pour les Notes
$router->get('/api/notes', function () {
    $controller = new NoteController();
    $controller->getAllNotes();
});

// Lancer le router
$router->run();