# GJW Global Talent Assessment v0.8 — Hostinger deployment & verification

**Target domain:** https://applyforjob.miantayyab.com

**Current status: DEVELOPMENT / STAGING, NOT PRODUCTION READY.** This ZIP has not been uploaded to Hostinger or run against its MySQL database. The user-supplied bank QR is included, not independently verified by a bank.

## New features in v0.8 compared with v0.7

- CV AI extraction route (`?p=cv_ai&id=...`) with separate explicit processing consent, server-side OpenAI adapter and editable review; auto-populated only when profile is empty.
- Text-based PDF CV parser via Composer and DOCX via PHP ZipArchive. Binary DOC and camera photos do **not** support AI text extraction in this release; candidates can still submit the CV and fill data manually.
- Admin-assessed 15-minute live interview duration rule (external meeting links remain; true embedded/recorded WebRTC is **not** integrated).
- 30-minute MCQ server deadline with expiration handling. Expired unsubmitted answers receive zero; admin should review technical/accessibility disruptions.
- 15-minute two-topic writing assessment with maximum 1,500 characters per answer, persisted in `writing_assessments`, admin review visible. AI prompts are attempted if a key is configured; otherwise explicitly curated fallback prompts.
- Final 200-mark publication now requires the writing section to be submitted; admin can review answers while grading the 50-mark professional presentation component (writing is not a separately scored fourth category).
- Candidate result visibility held for at least four hours after written assessment completion and subject to admin approval. This is **not** a guarantee of result at exactly four hours.
- CLI executable policy tests and environment report added.

## Installation (fresh installation)

1. Keep public registrations and real payment acceptance **disabled** during installation/testing. Back up any existing website files and database first.
2. Hostinger hPanel: ensure domain, HTTPS, PHP 8.2+, MySQL and CLI cron/Composer support.
3. Copy app files into the correct subdomain document root. Keep storage directory **outside web root**; ensure writable permissions. `.htaccess` blocks direct access to config files, setup scripts, vendor and internal tests on Apache/LiteSpeed; verify explicitly via HTTP.
4. Create an isolated MySQL user/database; **fresh database:** import `schema.sql` once. Do not run migration files again on fresh schema.
5. Copy `config.example.php` to `config.php` and set real DB credentials, `app_url`, secure HMAC keys, optional AI key, SMTP details and private storage path. Store only in Hostinger private file manager/secrets; no credentials inside downloaded ZIP or chat.
6. Install Composer dependencies in SSH/CLI: `composer install --no-dev --prefer-dist --optimize-autoloader`. Ensure `pdo_mysql`, `curl`, `fileinfo`, `openssl`, `mbstring`, `zip` are enabled.
7. Create initial Super Admin with `bootstrap_admin.php` using secure CLI; lock/delete bootstrap tool afterward. Set admin email to the already confirmed address from private configuration.
8. Use CLI `php tests/verify_environment.php` and `php tests/db_smoke.php` against **staging database**. The latter rolls back test fixtures; keep full error logs outside web root.
9. Open the website and test authentication, identity blocking, CV upload/extraction, document capture, project timer, video upload, bank receipt/approval, coupon, schedule, MCQ deadline, writing submission, result release, three-language UI and history on a separate staging account. Test denial paths, mobile devices and role-specific access.
10. Validate bank QR inside the official banking app (recipient name, IBAN, amount); no automatic reconciliation is implemented. Keep payment acceptance disabled until authenticated bank verification procedures are in place.
11. Set up `cleanup_retention.php` as a private CLI cron only after checking 90-day retention policy, application closure dates, backup retention and data deletion requirements.

## Upgrade from existing v0.7 database

1. **Back up database and application files.** Never import a full schema over an existing database.
2. Import **only** `migration_v08.sql` for a confirmed v0.7 database, once. If prior migrations are uncertain, compare `information_schema` first. Do not re-run non-idempotent ALTER statements.
3. Update all PHP/JS/CSS assets together and install Composer libraries; keep the previous deployed release for rollback.
4. Run CLI tests and complete browser UAT before activating public traffic.

## Still NOT implemented / NOT verified

- Live Hostinger deployment, PDO/MySQL CRUD checks, real email sending, real payment reconciliation, complete three-language manual translation audit, external AI API responses, bank QR scanning.
- True in-portal WebRTC calling, live attendance, video recording of calls, server-side compression and recording retention.
- Full user-selectable admin/candidate interview slots, real-time candidate presence dashboard, 60-minute **contiguous** session orchestration across live video, MCQ and writing. The current 15/30/15 pieces have individual controls but are not one automatically enforced continuous room/session.
- AI-generated MCQs still require an API key and admin expert review; AI course learning plans are not fully automatic and externally verified.
- End-to-end payment refunds, anti-fraud blacklisting/appeals, WhatsApp business notifications, PDF/XLSX exports, production threat-model penetration testing.

**Never publish a production-ready claim based only on PHP syntax and static checks.**
