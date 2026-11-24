# v0.6 integration deployment and verification checklist

This package is a **development / staging build**, not a certified production release. A successful local PHP syntax check is not an end-to-end functional test.

## Supplied business details
- App URL: https://applyforjob.miantayyab.com
- Bank: Configure locally.
- IBAN Configure locally.
- Branch Configure locally.
- SWIFT Configure locally.
- SMTP sender: HR@GULFCAREERINSTITUTE.COM
- First admin email: miantayyab063@gmail.com

## Installation
1. Hostinger hPanel: create the subdomain; enable HTTPS and PHP 8.2+ with `pdo_mysql`, `fileinfo`, `curl`, and `openssl` extensions.
2. Create an independent MySQL database and user. Import `schema.sql` for a fresh installation only. For upgrading an older installation, take a backup, apply any missing legacy migrations **in order**, then `migration_v06.sql` and `bank_settings_v06.sql`. Confirm the existing database has all tables before proceeding.
3. Place app files in the document root. Create private upload storage **outside** the web document root, with writable access by PHP.
4. Copy `config.example.php` to `config.php` and set database details, secure `identity_hmac_key` and `coupon_hmac_key` (64 random hex characters each), correct private storage location, and SMTP settings. Never share secrets through chat or include them in a public archive.
5. Run `php bootstrap_admin.php miantayyab063@gmail.com` **according to the bootstrap usage printed by that script**; provide a unique strong password using its documented method. Delete the bootstrap file from the public root when complete.
6. Sign in as Super Admin and use **Configuration → Upload / Replace Bank QR** to upload the original Bank Alfalah QR PNG/JPG. This image was provided inline in the conversation but was not available as a local source image in the build filesystem; it is intentionally **not** fabricated in the ZIP. Scan and check payee details with the bank before launch.
7. Set SMTP credentials privately in `config.php`. For AI, separately provision an API billing account and set `ai_api_key`; do not expose it in JavaScript. AI MCQ questions require admin review before bank publication.
8. Install composer dependencies as required by `composer.json` (`composer install --no-dev`), if supported by Hostinger. Restrict access to config, SQL, scripts and tests with server rules or deploy these files outside the public root.
9. Test full registration → verification → file upload → late fee lock → staff payment approval → scheduling → assessment → result. Test on mobile browsers, in Arabic RTL, Urdu RTL and English. Verify storage retention and backups.
10. Do not accept real payments or sensitive applicant documents until QA, security review and privacy/consent processes are complete.

## Payment safety
- QR and bank screenshots are not transaction reconciliation. Staff must check the bank transaction in the official account.
- Coupon requests are **not** transaction IDs. A coupon can reduce or waive a fee only upon authorized approval.
- Publish exact assessment/refund and rescheduling terms before taking payment. Avoid unverified automatic fraud, plagiarism or AI-use accusations.

## Remaining production integrations
- Actual QR file; QR scan/payee verification on a banking app.
- Hostinger database/SFTP/hPanel access (user-controlled).
- SMTP password and successful live delivery testing.
- AI API credential, usage billing, data-processing terms; live OpenAI API calls not tested.
- Managed WebRTC/video room and recording provider account, webhook and storage credentials (not implemented fully).
- Full Arabic/Urdu UI and manual/native-language QA; `assets/i18n.js` is a partial dictionary only.
- Automated bank reconciliation requires bank-issued authorized API or manual verification.
- In-browser end-to-end QA; database migrations, private storage permissions, retention and backup recovery tests.
