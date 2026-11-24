-- Apply to existing v0.6 database after taking a backup.
INSERT IGNORE INTO settings (`key`,`value`) VALUES ('bank_qr_filename','bank-qr.png');
