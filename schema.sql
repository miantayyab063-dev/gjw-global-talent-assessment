CREATE TABLE IF NOT EXISTS users (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(160) NOT NULL, email VARCHAR(190) NOT NULL UNIQUE, mobile VARCHAR(40) UNIQUE, pass_hash VARCHAR(255) NOT NULL, role ENUM('candidate','super_admin','hr','interviewer') NOT NULL DEFAULT 'candidate', email_verified_at DATETIME NULL, verify_token_hash CHAR(64) NULL, registration_started_at DATETIME NULL, locale VARCHAR(8) NOT NULL DEFAULT 'en', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS applications (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, user_id BIGINT UNSIGNED NOT NULL, reference VARCHAR(32) UNIQUE NOT NULL, profession VARCHAR(190) NOT NULL, country VARCHAR(100) NOT NULL DEFAULT 'Pakistan', interview_language VARCHAR(80) DEFAULT 'English', data_json LONGTEXT NULL, step INT NOT NULL DEFAULT 1, status VARCHAR(50) NOT NULL DEFAULT 'draft', project_prompt TEXT NULL, project_response TEXT NULL, project_started_at DATETIME NULL, project_ends_at DATETIME NULL, video_retries TINYINT NOT NULL DEFAULT 0, consent_at DATETIME NULL, fee_pkr INT NOT NULL DEFAULT 2000, registration_started_at DATETIME NULL, late_fee_waived TINYINT(1) NOT NULL DEFAULT 0, exchange_pkr_per_usd DECIMAL(10,4) NOT NULL DEFAULT 276.00, final_score DECIMAL(5,2) NULL, result_approved_at DATETIME NULL, closed_at DATETIME NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, FOREIGN KEY(user_id) REFERENCES users(id), INDEX(status), INDEX(user_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS documents (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, application_id BIGINT UNSIGNED NOT NULL, kind ENUM('cv','identity','intro_video','payment_receipt') NOT NULL, original_name VARCHAR(255) NOT NULL, relative_path VARCHAR(255) NOT NULL, mime VARCHAR(100) NOT NULL, uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(application_id) REFERENCES applications(id), INDEX(application_id,kind)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS payments (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, application_id BIGINT UNSIGNED NOT NULL, kind ENUM('assessment','reschedule') NOT NULL DEFAULT 'assessment', amount_pkr INT NOT NULL, transfer_reference VARCHAR(120), status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending', reviewer_id BIGINT UNSIGNED NULL, reviewed_at DATETIME NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(application_id) REFERENCES applications(id), UNIQUE KEY single_kind_payment(application_id,kind)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS interviews (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, application_id BIGINT UNSIGNED NOT NULL, starts_at_utc DATETIME NOT NULL, duration_min INT NOT NULL DEFAULT 20, provider ENUM('jitsi','meet','zoom','other') NOT NULL DEFAULT 'meet', meeting_url VARCHAR(500) NOT NULL, status ENUM('scheduled','completed','no_show','cancelled') NOT NULL DEFAULT 'scheduled', joined_at DATETIME NULL, assessed_at DATETIME NULL, video_mark DECIMAL(5,2) NULL, presentation_mark DECIMAL(5,2) NULL, feedback TEXT NULL, consent_confirmed_at DATETIME NULL, created_by BIGINT UNSIGNED NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(application_id) REFERENCES applications(id), INDEX(starts_at_utc)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS questions (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, profession VARCHAR(190) NOT NULL DEFAULT '*', prompt TEXT NOT NULL, a VARCHAR(500) NOT NULL, b VARCHAR(500) NOT NULL, c VARCHAR(500) NOT NULL, d VARCHAR(500) NOT NULL, correct ENUM('a','b','c','d') NOT NULL, explanation TEXT NULL, enabled TINYINT NOT NULL DEFAULT 1) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS attempts (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, application_id BIGINT UNSIGNED NOT NULL UNIQUE, started_at DATETIME NOT NULL, submitted_at DATETIME NULL, questions_json LONGTEXT NOT NULL, answers_json LONGTEXT NULL, mcq_mark DECIMAL(5,2) NULL, FOREIGN KEY(application_id) REFERENCES applications(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS audit_logs (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, actor_id BIGINT UNSIGNED NULL, application_id BIGINT UNSIGNED NULL, action VARCHAR(100) NOT NULL, details TEXT NULL, occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, INDEX(application_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS settings (`key` VARCHAR(100) PRIMARY KEY, `value` TEXT NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT IGNORE INTO settings (`key`,`value`) VALUES ('bank_instructions','BANK ALFALAH — ASSESSMENT PAYMENTS\nAccount title Configure locally.\nIBAN Configure locally.\nBranch Configure locally.\nBranch code Configure locally.\nSWIFT Configure locally.\nPlease confirm recipient details with your bank before paying. Keep the real transaction ID and upload the receipt. A screenshot is not proof of settlement until admin verifies the bank transaction.\n\nEnglish: The fee pays for assessment administration, not a guaranteed job. Refund eligibility is subject to written policy and verified attendance/results.\nاردو: یہ فیس اسیسمنٹ کے انتظام کے لیے ہے، ملازمت کی ضمانت نہیں۔ ریفنڈ تحریری پالیسی اور تصدیق کے مطابق ہوگا۔\nالعربية: هذه الرسوم مقابل إدارة التقييم وليست ضماناً للتوظيف. يخضع الاسترداد للسياسة المكتوبة والتحقق.'),('qr_image',''),('question_count','20'),('refund_policy','Conditional refund on pass, subject to the published terms and verification'),('missed_fee_pkr','5000'),('fx_pkr_per_usd','275.69'),('project_default','Describe a challenging project in your profession, your actions and the outcome.'),('video_prompt','Introduce yourself, summarize your skills and explain why you are suitable for the role.');

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

-- Mobile uniqueness uses a separate index; empty mobiles should be stored as NULL.

INSERT IGNORE INTO settings (`key`,`value`) VALUES ('international_late_extra_pkr','0');

CREATE TABLE IF NOT EXISTS fee_waiver_requests (application_id BIGINT UNSIGNED PRIMARY KEY, reason TEXT NOT NULL, status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending', reviewed_by BIGINT UNSIGNED NULL, reviewed_at DATETIME NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(application_id) REFERENCES applications(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- v0.6: run once after legacy migrations; use schema.sql for new install first.
CREATE TABLE IF NOT EXISTS coupons (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 code_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL UNIQUE,
 code_hint VARCHAR(4) NOT NULL,
 kind ENUM('full','fixed','percent') NOT NULL,
 discount_value DECIMAL(11,2) NOT NULL DEFAULT 0,
 max_uses INT UNSIGNED NOT NULL DEFAULT 1,
 used_count INT UNSIGNED NOT NULL DEFAULT 0,
 expires_at DATETIME NOT NULL,
 active TINYINT NOT NULL DEFAULT 1,
 created_by BIGINT UNSIGNED NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 INDEX(expires_at),FOREIGN KEY(created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS coupon_requests (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 coupon_id BIGINT UNSIGNED NOT NULL,
 application_id BIGINT UNSIGNED NOT NULL,
 status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
 base_amount_pkr INT NOT NULL,discount_pkr INT NOT NULL DEFAULT 0,balance_pkr INT NOT NULL,
 reviewed_by BIGINT UNSIGNED NULL,reviewed_at DATETIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY unique_coupon_per_application(application_id,coupon_id),
 INDEX (application_id,status),
 FOREIGN KEY(coupon_id) REFERENCES coupons(id),FOREIGN KEY(application_id) REFERENCES applications(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO settings (`key`,`value`) VALUES ('bank_qr_filename','bank-qr.png');

-- v0.8 writing assessment and CV AI drafts (fresh installation only)
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
