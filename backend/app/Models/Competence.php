<?php
require_once __DIR__ . '/../Core/Database.php';

class Competence {
    private $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function getAll() {
        $sql = "SELECT * FROM Competence ORDER BY Libelle";
        $stmt = $this->db->query($sql);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getById($id) {
        $sql = "SELECT * FROM Competence WHERE id_Competence = :id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['id' => $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function create($libelle) {
        $sql = "INSERT INTO Competence (Libelle) VALUES (:libelle)";
        $stmt = $this->db->prepare($sql);
        $result = $stmt->execute(['libelle' => $libelle]);

        if ($result) {
            return [
                'success' => true,
                'id' => $this->db->lastInsertId(),
                'message' => 'Compétence créée avec succès'
            ];
        }
        return ['success' => false, 'message' => 'Erreur lors de la création'];
    }

    public function update($id, $libelle) {
        $sql = "UPDATE Competence SET Libelle = :libelle WHERE id_Competence = :id";
        $stmt = $this->db->prepare($sql);
        $result = $stmt->execute([
            'id' => $id,
            'libelle' => $libelle
        ]);

        if ($result) {
            return ['success' => true, 'message' => 'Compétence mise à jour avec succès'];
        }
        return ['success' => false, 'message' => 'Erreur lors de la mise à jour'];
    }

    public function delete($id) {
        $sql = "DELETE FROM Competence WHERE id_Competence = :id";
        $stmt = $this->db->prepare($sql);
        $result = $stmt->execute(['id' => $id]);

        if ($result) {
            return ['success' => true, 'message' => 'Compétence supprimée avec succès'];
        }
        return ['success' => false, 'message' => 'Erreur lors de la suppression'];
    }
}