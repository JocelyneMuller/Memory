/* ------------------------------------------------------------------
   Script durci pour phpMyAdmin (MySQL 8.0+ sous MAMP)
   Schéma = Memory
------------------------------------------------------------------- */

CREATE DATABASE IF NOT EXISTS `Memory`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 0;
-- Réinitialise proprement le schéma Memory si tu ré-exécutes le script
DROP TABLE IF EXISTS
  `Memory`.`Role_Permission`, `Memory`.`Utilisateur_Role`, `Memory`.`Utilisateur_Competence`,
  `Memory`.`Note_Tag`, `Memory`.`Tag_Categorie`,
  `Memory`.`Commentaire`, `Memory`.`Note`, `Memory`.`Tache`, `Memory`.`Rapport`, `Memory`.`Notification`,
  `Memory`.`Administrateur`,
  `Memory`.`Tag`, `Memory`.`Categorie`, `Memory`.`Permission`, `Memory`.`Role`,
  `Memory`.`Competence`, `Memory`.`Projet`, `Memory`.`Utilisateur`;
SET FOREIGN_KEY_CHECKS = 1;

USE `Memory`;

-- =========================
-- Utilisateur
-- =========================
CREATE TABLE `Utilisateur` (
  `id_Utilisateur` INT AUTO_INCREMENT PRIMARY KEY,
  `Nom`           VARCHAR(50) NOT NULL,
  `Email`         VARCHAR(50) NOT NULL UNIQUE,
  `Mot_de_passe`  VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Administrateur (1:1 avec Utilisateur)
-- =========================
CREATE TABLE `Administrateur` (
  `id_Admin`       INT AUTO_INCREMENT PRIMARY KEY,
  `id_Utilisateur` INT NOT NULL,
  UNIQUE KEY `uk_administrateur_utilisateur` (`id_Utilisateur`),
  CONSTRAINT `fk_admin_utilisateur`
    FOREIGN KEY (`id_Utilisateur`)
    REFERENCES `Utilisateur`(`id_Utilisateur`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Role
-- =========================
CREATE TABLE `Role` (
  `id_Role`  INT AUTO_INCREMENT PRIMARY KEY,
  `Nom_role` VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Permission
-- =========================
CREATE TABLE `Permission` (
  `id_Permission` INT AUTO_INCREMENT PRIMARY KEY,
  `Libelle`       VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Rôle - Permission (n-n)
-- =========================
CREATE TABLE `Role_Permission` (
  `id_Role`       INT NOT NULL,
  `id_Permission` INT NOT NULL,
  PRIMARY KEY (`id_Role`, `id_Permission`),
  KEY `idx_role_permission_permission` (`id_Permission`),
  CONSTRAINT `fk_role_permission_role`
    FOREIGN KEY (`id_Role`) REFERENCES `Role`(`id_Role`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_role_permission_permission`
    FOREIGN KEY (`id_Permission`) REFERENCES `Permission`(`id_Permission`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Utilisateur - Rôle (n-n)
-- =========================
CREATE TABLE `Utilisateur_Role` (
  `id_Utilisateur` INT NOT NULL,
  `id_Role`        INT NOT NULL,
  PRIMARY KEY (`id_Utilisateur`, `id_Role`),
  KEY `idx_utilisateur_role_role` (`id_Role`),
  CONSTRAINT `fk_utilisateur_role_utilisateur`
    FOREIGN KEY (`id_Utilisateur`) REFERENCES `Utilisateur`(`id_Utilisateur`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_utilisateur_role_role`
    FOREIGN KEY (`id_Role`) REFERENCES `Role`(`id_Role`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Projet
-- =========================
CREATE TABLE `Projet` (
  `id_Projet`        INT AUTO_INCREMENT PRIMARY KEY,
  `Nom`              VARCHAR(50) NOT NULL UNIQUE,
  `Description`      TEXT,
  `Date_de_creation` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `Date_d_archive`   DATE NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Compétence
-- =========================
CREATE TABLE `Competence` (
  `id_Competence` INT AUTO_INCREMENT PRIMARY KEY,
  `Libelle`       VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Utilisateur - Compétence (n-n)
-- =========================
CREATE TABLE `Utilisateur_Competence` (
  `id_Utilisateur` INT NOT NULL,
  `id_Competence`  INT NOT NULL,
  PRIMARY KEY (`id_Utilisateur`, `id_Competence`),
  KEY `idx_utilisateur_competence_competence` (`id_Competence`),
  CONSTRAINT `fk_utilisateur_competence_utilisateur`
    FOREIGN KEY (`id_Utilisateur`) REFERENCES `Utilisateur`(`id_Utilisateur`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_utilisateur_competence_competence`
    FOREIGN KEY (`id_Competence`) REFERENCES `Competence`(`id_Competence`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Note
-- =========================
CREATE TABLE `Note` (
  `id_Note`        INT AUTO_INCREMENT PRIMARY KEY,
  `Titre`          VARCHAR(50),
  `Date_creation`  DATE NOT NULL DEFAULT (CURRENT_DATE),
  `id_Utilisateur` INT NULL,
  `id_Projet`      INT NULL,
  KEY `idx_note_utilisateur` (`id_Utilisateur`),
  KEY `idx_note_projet` (`id_Projet`),
  CONSTRAINT `fk_note_utilisateur`
    FOREIGN KEY (`id_Utilisateur`) REFERENCES `Utilisateur`(`id_Utilisateur`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_note_projet`
    FOREIGN KEY (`id_Projet`) REFERENCES `Projet`(`id_Projet`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Tag
-- =========================
CREATE TABLE `Tag` (
  `id_Tag`  INT AUTO_INCREMENT PRIMARY KEY,
  `Nom`     VARCHAR(50) NOT NULL UNIQUE,
  `Contenu` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Catégorie
-- =========================
CREATE TABLE `Categorie` (
  `id_Categorie` INT AUTO_INCREMENT PRIMARY KEY,
  `Nom`          VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Note - Tag (n-n)
-- =========================
CREATE TABLE `Note_Tag` (
  `id_Note` INT NOT NULL,
  `id_Tag`  INT NOT NULL,
  PRIMARY KEY (`id_Note`, `id_Tag`),
  KEY `idx_note_tag_tag` (`id_Tag`),
  CONSTRAINT `fk_note_tag_note`
    FOREIGN KEY (`id_Note`) REFERENCES `Note`(`id_Note`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_note_tag_tag`
    FOREIGN KEY (`id_Tag`) REFERENCES `Tag`(`id_Tag`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Tag - Catégorie (n-n)
-- =========================
CREATE TABLE `Tag_Categorie` (
  `id_Tag`       INT NOT NULL,
  `id_Categorie` INT NOT NULL,
  PRIMARY KEY (`id_Tag`, `id_Categorie`),
  KEY `idx_tag_categorie_categorie` (`id_Categorie`),
  CONSTRAINT `fk_tag_categorie_tag`
    FOREIGN KEY (`id_Tag`) REFERENCES `Tag`(`id_Tag`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tag_categorie_categorie`
    FOREIGN KEY (`id_Categorie`) REFERENCES `Categorie`(`id_Categorie`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Commentaire
-- =========================
CREATE TABLE `Commentaire` (
  `id_Commentaire` INT AUTO_INCREMENT PRIMARY KEY,
  `Contenu`        TEXT,
  `id_Utilisateur` INT NULL,
  `id_Note`        INT NOT NULL,
  KEY `idx_commentaire_utilisateur` (`id_Utilisateur`),
  KEY `idx_commentaire_note` (`id_Note`),
  CONSTRAINT `fk_commentaire_utilisateur`
    FOREIGN KEY (`id_Utilisateur`) REFERENCES `Utilisateur`(`id_Utilisateur`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_commentaire_note`
    FOREIGN KEY (`id_Note`) REFERENCES `Note`(`id_Note`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Tâche
-- =========================
CREATE TABLE `Tache` (
  `id_Tache`      INT AUTO_INCREMENT PRIMARY KEY,
  `Titre`         VARCHAR(50),
  `Description`   VARCHAR(500),
  `Date_creation` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `Date_echeance` DATE NULL,
  `Statut`        ENUM('à faire', 'en cours', 'terminé') NOT NULL DEFAULT 'à faire',
  `id_Utilisateur` INT NULL,
  KEY `idx_tache_utilisateur` (`id_Utilisateur`),
  CONSTRAINT `fk_tache_utilisateur`
    FOREIGN KEY (`id_Utilisateur`) REFERENCES `Utilisateur`(`id_Utilisateur`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ck_tache_dates`
    CHECK (`Date_echeance` IS NULL OR `Date_creation` IS NULL OR `Date_echeance` >= `Date_creation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Rapport
-- =========================
CREATE TABLE `Rapport` (
  `id_Rapport`    INT AUTO_INCREMENT PRIMARY KEY,
  `Date_creation` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `Contenu`       TEXT,
  `id_Projet`     INT NOT NULL,
  KEY `idx_rapport_projet` (`id_Projet`),
  CONSTRAINT `fk_rapport_projet`
    FOREIGN KEY (`id_Projet`) REFERENCES `Projet`(`id_Projet`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Notification
-- =========================
CREATE TABLE `Notification` (
  `id_Notification` INT AUTO_INCREMENT PRIMARY KEY,
  `Date_creation`   DATE NOT NULL DEFAULT (CURRENT_DATE),
  `est_lue`         BOOLEAN NOT NULL DEFAULT FALSE,
  `Contenu`         VARCHAR(200),
  `id_Utilisateur`  INT NOT NULL,
  KEY `idx_notification_utilisateur` (`id_Utilisateur`),
  CONSTRAINT `fk_notification_utilisateur`
    FOREIGN KEY (`id_Utilisateur`) REFERENCES `Utilisateur`(`id_Utilisateur`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
