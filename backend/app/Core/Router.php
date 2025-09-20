$router->get('/api/notes', function () {
    $controller = new NoteController();
    $controller->getAllNotes();
});
