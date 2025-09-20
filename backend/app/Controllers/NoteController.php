<?php
require_once __DIR__ . '/../Models/Note.php';

class NoteController {
    public function getAllNotes() {
        $db = Database::getConnection();
        $noteModel = new Note($db);
        $notes = $noteModel->getAll();
        echo json_encode($notes);
    }
}
