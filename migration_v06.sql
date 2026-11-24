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
