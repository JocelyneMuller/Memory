<?php
require_once __DIR__ . '/../Models/Competence.php';

class CompetenceController {
    private $competenceModel;

    public function __construct() {
        $this->competenceModel = new Competence();
    }

    public function getAllCompetences() {
        try {
            $competences = $this->competenceModel->getAll();
            echo json_encode(['success' => true, 'data' => $competences]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
        }
    }

    public function getCompetence($id) {
        try {
            $competence = $this->competenceModel->getById($id);
            if ($competence) {
                echo json_encode(['success' => true, 'data' => $competence]);
            } else {
                http_response_code(404);
                echo json_encode(['success' => false, 'error' => 'Compétence non trouvée']);
            }
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
        }
    }

    public function createCompetence() {
        try {
            $data = json_decode(file_get_contents('php://input'), true);

            if (empty($data['libelle'])) {
                http_response_code(400);
                echo json_encode(['success' => false, 'error' => 'Le libellé est requis']);
                return;
            }

            $result = $this->competenceModel->create($data['libelle']);

            if ($result['success']) {
                http_response_code(201);
            }
            echo json_encode($result);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
        }
    }

    public function updateCompetence($id) {
        try {
            $data = json_decode(file_get_contents('php://input'), true);

            if (empty($data['libelle'])) {
                http_response_code(400);
                echo json_encode(['success' => false, 'error' => 'Le libellé est requis']);
                return;
            }

            $result = $this->competenceModel->update($id, $data['libelle']);
            echo json_encode($result);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
        }
    }

    public function deleteCompetence($id) {
        try {
            $result = $this->competenceModel->delete($id);
            echo json_encode($result);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'error' => $e->getMessage()]);
        }
    }
}