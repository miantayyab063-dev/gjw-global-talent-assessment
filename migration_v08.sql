-- Apply ONCE to a v0.7 installation. Back up the database first.
ALTER TABLE applications ADD COLUMN assessment_finished_at DATETIME NULL;
CREATE TABLE IF NOT EXISTS writing_assessments (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 application_id BIGINT UNSIGNED NOT NULL UNIQUE,
 prompt_one TEXT NOT NULL,
 prompt_two TEXT NOT NULL,
 response_one TEXT NULL,
 response_two TEXT NULL,
 started_at DATETIME NOT NULL,
 submitted_at DATETIME NULL,
 expired TINYINT(1) NOT NULL DEFAULT 0,
 FOREIGN KEY(application_id) REFERENCES applications(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS cv_ai_drafts (
 application_id BIGINT UNSIGNED PRIMARY KEY,
 document_id BIGINT UNSIGNED NOT NULL,
 extracted_json LONGTEXT NOT NULL,
 consent_at DATETIME NOT NULL,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 FOREIGN KEY(application_id) REFERENCES applications(id) ON DELETE CASCADE,
 FOREIGN KEY(document_id) REFERENCES documents(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
