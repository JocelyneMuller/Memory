<?php
/**
 * Classe de gestion de la connexion à la base de données
 * 
 * Implémente le pattern Singleton pour s'assurer qu'une seule
 * connexion PDO existe pendant toute la durée de l'application.
 * 
 * @author Votre Nom
 * @version 1.0
 * @since 2025-09-20
 */
class Database {
    /**
     * Instance unique de la connexion PDO
     * @var PDO|null
     */
    private static $connection = null;

    /**
     * Récupère l'instance unique de connexion à la base de données
     * 
     * Crée une nouvelle connexion PDO si elle n'existe pas encore,
     * sinon retourne la connexion existante.
     * 
     * @return PDO Instance de connexion à la base de données
     * @throws PDOException En cas d'erreur de connexion
     */
    public static function getConnection() {
        if (self::$connection === null) {
            try {
                $host = 'localhost';
                $dbname = 'Memory';
                $username = 'root';
                $password = 'root';

                self::$connection = new PDO(
                    "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
                    $username,
                    $password,
                    [
                        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
                    ]
                );
            } catch(PDOException $e) {
                die("Erreur de connexion : " . $e->getMessage());
            }
        }
        return self::$connection;
    }
}