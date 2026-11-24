-- v0.3 identity and career recommendation tables; import migration_v03.sql for existing installations.
CREATE TABLE IF NOT EXISTS candidate_identifiers (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id BIGINT UNSIGNED NOT NULL,
 id_type ENUM('cnic','passport','national_id') NOT NULL,
 identifier_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 masked_value VARCHAR(24) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_identifier_hash(identifier_hash),
 UNIQUE KEY uq_user_identifier_type(user_id,id_type),
 FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS course_catalog (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 title VARCHAR(190) NOT NULL,
 keywords VARCHAR(600) NOT NULL,
 description TEXT NOT NULL,
 provider VARCHAR(160) NOT NULL DEFAULT 'Provider to be verified',
 url VARCHAR(600) NULL,
 active TINYINT(1) NOT NULL DEFAULT 1,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 INDEX(active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO course_catalog (title,keywords,description) VALUES
('Advanced Excel & Data Management','data entry excel computer operator admin office','Improve spreadsheets, formulas, reporting and data quality skills.'),
('ERP / SAP Fundamentals','erp sap finance inventory supply chain','Learn fundamental enterprise workflows before selecting a specialized module.'),
('Professional Communication & Business English','english communication receptionist customer service office','Strengthen written communication, interview communication and customer support.'),
('Occupational Health & Safety Basics','safety officer hse construction','Learn workplace hazard identification, incident reporting and risk controls.'),
('Web Development Foundations','software developer web html css javascript','Build web development and programming foundations.'),
('Accounting & Financial Reporting','accountant accounting finance bookkeeping','Practice reconciliations, bookkeeping and financial reporting.'),
('Clinical Communication & Patient Safety','nurse nursing healthcare medical','Improve patient safety, clinical communication and care documentation.'),
('Modern Teaching Methods','teacher teaching education tutoring','Explore assessment planning, classroom management and inclusive teaching.');

-- Mobile uniqueness enforced for new accounts; review duplicates before applying this index.
-- ALTER TABLE users ADD UNIQUE KEY uq_mobile(mobile);
