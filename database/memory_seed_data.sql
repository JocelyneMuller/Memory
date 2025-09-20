-- Vider les données existantes (sans supprimer les tables)
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM Note_Tag;
DELETE FROM Tag_Categorie;
DELETE FROM Commentaire;
DELETE FROM Rapport;
DELETE FROM Tache;
DELETE FROM Notification;
DELETE FROM Administrateur;
DELETE FROM Utilisateur_Role;
DELETE FROM Role_Permission;
DELETE FROM Utilisateur_Competence;
DELETE FROM Note;
DELETE FROM Projet;
DELETE FROM Utilisateur;
DELETE FROM Role;
DELETE FROM Permission;
DELETE FROM Competence;
DELETE FROM Tag;
DELETE FROM Categorie;
SET FOREIGN_KEY_CHECKS = 1;


-- ============================
-- 1. Utilisateurs
-- ============================
INSERT INTO Utilisateur (Nom, Email, Mot_de_passe) VALUES
('Alice Dupont', 'alice@example.com', 'azerty'),
('Bruno Martin', 'bruno@example.com', '123456'),
('Chloé Dubois', 'chloe@example.com', 'motdepasse');

-- ============================
-- 2. Administrateurs
-- ============================
-- On rend Alice (email = 'alice@example.com') administratrice
INSERT INTO Administrateur (id_Utilisateur)
SELECT id_Utilisateur FROM Utilisateur WHERE Email = 'alice@example.com';

-- ============================
-- 3. Rôles
-- ============================
INSERT INTO Role (Nom_role) VALUES
('admin'),
('utilisateur'),
('contributeur');

-- ============================
-- 4. Permissions
-- ============================
INSERT INTO Permission (Libelle) VALUES
('Créer'),
('Lire'),
('Mettre à jour'),
('Supprimer');

-- ============================
-- 5. Rôle-Permission
-- ============================
-- L’admin a toutes les permissions
INSERT INTO Role_Permission (id_Role, id_Permission)
SELECT r.id_Role, p.id_Permission
FROM Role r, Permission p
WHERE r.Nom_role = 'admin';

-- L’utilisateur a seulement "Lire"
INSERT INTO Role_Permission (id_Role, id_Permission)
SELECT r.id_Role, p.id_Permission
FROM Role r
JOIN Permission p ON p.Libelle = 'Lire'
WHERE r.Nom_role = 'utilisateur';

-- ============================
-- 6. Utilisateur-Rôle
-- ============================
-- Alice : admin
INSERT INTO Utilisateur_Role (id_Utilisateur, id_Role)
SELECT u.id_Utilisateur, r.id_Role
FROM Utilisateur u, Role r
WHERE u.Email = 'alice@example.com' AND r.Nom_role = 'admin';

-- Bruno : contributeur
INSERT INTO Utilisateur_Role (id_Utilisateur, id_Role)
SELECT u.id_Utilisateur, r.id_Role
FROM Utilisateur u, Role r
WHERE u.Email = 'bruno@example.com' AND r.Nom_role = 'contributeur';

-- Chloé : utilisateur
INSERT INTO Utilisateur_Role (id_Utilisateur, id_Role)
SELECT u.id_Utilisateur, r.id_Role
FROM Utilisateur u, Role r
WHERE u.Email = 'chloe@example.com' AND r.Nom_role = 'utilisateur';

-- ============================
-- 7. Compétences
-- ============================
INSERT INTO Competence (Libelle) VALUES
('MySQL'),
('PHP'),
('Git');

-- ============================
-- 8. Utilisateur-Compétence
-- ============================
INSERT INTO Utilisateur_Competence (id_Utilisateur, id_Competence)
SELECT u.id_Utilisateur, c.id_Competence
FROM Utilisateur u, Competence c
WHERE u.Email = 'bruno@example.com' AND c.Libelle = 'Git';

-- ============================
-- 9. Projet
-- ============================
INSERT INTO Projet (Nom, Description) VALUES
('App Gestion Notes', 'Application de gestion de notes partagées');

-- ============================
-- 10. Notes
-- ============================
INSERT INTO Note (Titre, id_Utilisateur, id_Projet) 
SELECT 'Créer un contrôleur en PHP', u.id_Utilisateur, p.id_Projet
FROM Utilisateur u, Projet p
WHERE u.Email = 'alice@example.com' AND p.Nom = 'App Gestion Notes';

-- ============================
-- 11. Tags
-- ============================
INSERT INTO Tag (Nom, Contenu) VALUES
('php', 'Langage serveur'),
('mvc', 'Architecture modèle-vue-contrôleur');

-- ============================
-- 12. Catégories
-- ============================
INSERT INTO Categorie (Nom) VALUES
('Tech'),
('Backend');

-- ============================
-- 13. Note-Tag
-- ============================
INSERT INTO Note_Tag (id_Note, id_Tag)
SELECT n.id_Note, t.id_Tag
FROM Note n, Tag t
WHERE n.Titre = 'Créer un contrôleur en PHP' AND t.Nom = 'php';

-- ============================
-- 14. Tag-Catégorie
-- ============================
INSERT INTO Tag_Categorie (id_Tag, id_Categorie)
SELECT t.id_Tag, c.id_Categorie
FROM Tag t, Categorie c
WHERE t.Nom = 'php' AND c.Nom = 'Backend';

-- ============================
-- 15. Commentaire
-- ============================
INSERT INTO Commentaire (Contenu, id_Utilisateur, id_Note)
SELECT 'Super clair ! Merci !', u.id_Utilisateur, n.id_Note
FROM Utilisateur u, Note n
WHERE u.Email = 'bruno@example.com' AND n.Titre = 'Créer un contrôleur en PHP';

-- ============================
-- 16. Tâches
-- ============================
INSERT INTO Tache (Titre, Description, id_Utilisateur, Statut)
SELECT 'Configurer l’environnement', 'Installer VSCode, MAMP et Git', u.id_Utilisateur, 'en cours'
FROM Utilisateur u
WHERE u.Email = 'alice@example.com';

-- ============================
-- 17. Rapport
-- ============================
INSERT INTO Rapport (Contenu, id_Projet)
SELECT 'Avancement au 02 août : 70%', id_Projet FROM Projet WHERE Nom = 'App Gestion Notes';

-- ============================
-- 18. Notifications
-- ============================
INSERT INTO Notification (Contenu, id_Utilisateur)
SELECT 'Bienvenue dans le projet !', id_Utilisateur FROM Utilisateur WHERE Email = 'chloe@example.com';
