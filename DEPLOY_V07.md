# GJW applyforjob.miantayyab.com deployment handoff — v0.7

## Deployment status
**NOT deployed.** This package updates the app URL and bundles the supplied Bank Alfalah QR image, but does not establish a Hostinger connection. No live MySQL, camera, video, email or bank transaction tests have been completed.

## Target settings
- URL: https://applyforjob.miantayyab.com
- Bank: Configure locally.
- IBAN Configure locally.
- Branch Configure locally.
- SWIFT Configure locally.
- Super Admin first email: miantayyab063@gmail.com
- Sender email: HR@GULFCAREERINSTITUTE.COM

## Secure install
1. Make a backup of the Hostinger website and database; keep the public candidate portal disabled during staging.
2. Set document root for applyforjob.miantayyab.com; upload PHP app files to the correct root. Protect secrets, schema, scripts, tests, and storage from the web. PHP 8.2+, PDO MySQL, fileinfo, cURL, OpenSSL and SSL required.
3. Fresh install: import `schema.sql` only (it already contains the v0.3-v0.6 tables). Existing v0.6 installation: back up first, then import `migration_v07.sql` only. Older databases require a careful version-by-version migration audit; do not rerun non-idempotent ALTER TABLE statements. Validate with `tests/db_smoke.php`.
4. Copy config.example.php to config.php; insert real MySQL credentials locally, set identity_hmac_key/coupon_hmac_key each to cryptographically random 64-character hexadecimal keys, private storage directory outside public web root, and authenticated SMTP credentials. Do not publish config.php.
5. Install Composer dependencies as required by composer.json in a supported CLI environment.
6. Create first Super Admin using bootstrap_admin.php from secure CLI; remove bootstrap/setup tools from accessible web folders after use.
7. QR image is included at assets/bank-qr.png. **It is user supplied and not independently bank verified**. Open in the official banking app and verify payee/IBAN and amount before activating payments. DB setting bank_qr_filename should be bank-qr.png.
8. Use a staging test candidate to verify registration, duplicate ID, CV + camera, timer and fee gate, admin review, scheduling, technical tests, result and app history. Also test English, Urdu and Arabic.
9. Check HTTPS, session management, CSRF, upload file rejection, staff roles, retention and DB backup restoration. Fix high severity findings before public launch.

## External integrations still not live
- AI CV extraction/question generation requires provider key and usage account.
- In-browser video/recording requires a managed WebRTC provider, egress and storage; existing meeting links do not count as this feature.
- Payment receipts require a human check against actual bank records; QR screenshot alone is not bank reconciliation.
- SMTP needs working credentials; live email delivery not tested.
- Full English/Urdu/Arabic translation and workflows must pass native-language review.
- No claim of end-to-end production readiness is made.
