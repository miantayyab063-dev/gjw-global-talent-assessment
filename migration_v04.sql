-- Import on EXISTING v0.3 installations only; perform a full backup before migrating.
ALTER TABLE users ADD COLUMN registration_started_at DATETIME NULL AFTER verify_token_hash;
UPDATE users SET registration_started_at=created_at WHERE registration_started_at IS NULL;
ALTER TABLE applications ADD COLUMN registration_started_at DATETIME NULL AFTER fee_pkr;
ALTER TABLE applications ADD COLUMN late_fee_waived TINYINT(1) NOT NULL DEFAULT 0 AFTER registration_started_at;
UPDATE applications SET registration_started_at=created_at WHERE registration_started_at IS NULL;
INSERT IGNORE INTO settings (`key`,`value`) VALUES ('international_late_extra_pkr','0');

CREATE TABLE IF NOT EXISTS fee_waiver_requests (application_id BIGINT UNSIGNED PRIMARY KEY, reason TEXT NOT NULL, status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending', reviewed_by BIGINT UNSIGNED NULL, reviewed_at DATETIME NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(application_id) REFERENCES applications(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
