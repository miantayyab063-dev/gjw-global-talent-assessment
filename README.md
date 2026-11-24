# GJW Global Talent Assessment — Hostinger PHP/MySQL working foundation

**Target:** `https://applyforjob.miantayyab.com`  
**Company:** Gulf Job Works  
**Product:** Global Talent Assessment / Live Assessment Interview  
**Runtime:** PHP 8.2+ with PDO MySQL, Fileinfo, sessions, mod_rewrite optional; MySQL 8/MariaDB.

## What is implemented

- Responsive candidate landing, email + password registration (mobile also accepted as login identifier), email verification and login.
- Multiple candidate applications, profession autocomplete or custom entry, country, preferred interview language.
- CV, identity (CNIC or passport), receipt and browser-recorded introductory video upload with private server-side file storage; consent and max two recorded video submissions.
- Editable profile information (manual entry); partial draft saves when submitted; candidate steps and history in MySQL.
- Timed project question (2 minutes from reveal, with server-side deadline check).
- Pakistan PKR 2,000, international PKR 5,600 displayed in USD using admin-configured FX snapshot on application creation.
- Bank transfer reference and proof submission; staff payment review. Bank QR included as user-supplied image; not independently verified.
- Staff scheduling with external HTTPS Google Meet/Zoom/Jitsi/other meeting URL; candidate live countdown. Appointment times are UTC in this initial version.
- Staff-controlled interview completion/no-show status and professional evaluation (video 50 + presentation/communication 50).
- Random technical MCQ selection from admin-maintained profession bank (up to 100 questions), out of 100; final reviewed score out of 200 and feedback.
- Super Admin, HR and Interviewer role checks. Admin review/dashboard, CSV export, configurable question count/policies/FX/instructions and audit logs.
- PHP CSRF tokens on POST, password hashing, escaped HTML output, PDO prepared statements, restrictive private uploads and least-privilege roles.

## Deployment to Hostinger (hPanel)

1. Add website/subdomain `applyforjob.miantayyab.com` under Gulf Job Works hosting. Enable SSL and PHP 8.2+ in hPanel. Do not publish until security review.
2. hPanel **Databases → MySQL Databases**: create a new MySQL database/user and keep credentials private. Import `schema.sql` using phpMyAdmin.
3. Place the **contents** of this directory into the subdomain's `public_html` (or configured document root). Copy `config.example.php` to `config.php` and update DB name/user/password, app URL and mail sender.
4. Create an `assessment_private` directory **one level above the document root** (not browseable) and set `storage_dir` in `config.php` to its ABSOLUTE full server path; ensure PHP can write there. Do **not** deploy inside `public_html` or allow directory listing.
5. Set `upload_max_filesize >= 64M`, `post_max_size >= 70M`, `max_execution_time` per Hostinger plan. Native browser recording generates up to 90 seconds, with file size capped at 60 MB; some recordings can exceed limit. Configure storage budget and retention.
6. Using SSH only, run `php bootstrap_admin.php your-admin@example.com 'YOUR-LONG-UNIQUE-PASSWORD'`. Delete `bootstrap_admin.php`, `config.example.php` and `schema.sql` from the public root after setup. Never run bootstrap from the web.
7. Before public signups, configure reliable authenticated outbound email (the starter uses PHP `mail()` which may be unconfigured or throttled). Confirm SPF/DKIM/DMARC and verification email delivery. Use a production mail library/SMTP implementation.
8. In the admin **Configuration** screen add Bank Alfalah instructions and approved payment/refund/no-show wording. QR file is bundled in assets/bank-qr.png and the Admin QR upload function exists; banking-app payee verification still required.
9. Add at least the configured number of validated questions to the question bank for each profession. Publish only legally approved and reviewed questions.
10. Test from a real phone over HTTPS, verifying browsers' camera/microphone permissions, payment review, scheduled interviews, timezone, admin roles, download access and a complete candidate lifecycle.

## Operational limits / pending production work

This is a functional **foundation / MVP**, **NOT** a production-ready finished platform. It has NOT been connected to a live Hostinger account or actual bank/email/video provider. No full end-to-end runtime testing against a real MySQL server has been performed. PHP syntax checks pass.

- **AI CV extraction/autofill:** manual profile only until an AI parser and background OCR/PDF/DOCX extraction service are integrated. Add prompt injection protection and require candidate confirmation; OCR alone should not be treated as verified.
- **AI-generated projects + unique MCQs:** project uses admin default prompt; MCQs are random from admin-authored question bank. API-based generation, factual review, fairness, anti-duplication and quality controls remain pending.
- **3-language interface:** language selector exists, full English/Urdu/Arabic string catalog and RTL localization **not yet implemented**. Free-form candidate interview languages are accepted.
- **Video interview:** external provider links are supported. In-app embedded calls, secure room authorization, meeting tokens, participant attendance telemetry, recording and consent verification need provider API integration. The current meeting URL is visible to the authenticated candidate; authorized-join restriction is not technically enforced at the video provider level.
- **Live video introduction:** 90-second cap is enforced only in the browser; server verifies MIME and file size but not duration. Full security hardening requires server-side media inspection/transcoding and protected object storage. `getUserMedia()` requires HTTPS.
- **Late project answer:** the server rejects submissions after 120 seconds, but the form remains visible after expiry. Add a client-side closed-state and auto-submit for full UX.
- **Payments:** human review and receipt upload supported. No bank-transfer API confirmation, automatic bank verification, USD FX live updates, international acquiring service, payment settlement, or refunds automated. Exchange rate must be approved and updated by admin; this app snapshots the configured rate per application.
- **Missed interviews:** staff can mark no-show; automatic PKR 5,000 rescheduling payment, evidence-based no-show review, grace windows, dispute and fee-waiver flow are **not implemented**. Do not charge until those controls and applicable policy are implemented.
- **Email + WhatsApp notifications:** not implemented except registration email attempt using PHP `mail()`. Scheduling should not depend on an unconfirmed notification.
- **Storage retention:** 90-day deletion job, user deletion request workflow, and audit review/export are **not implemented**. Must be completed before production with sensitive documents.
- **Admin:** role names are supported, but staff invitations and password reset are not yet implemented. Bootstrapped Super Admin can be added from CLI. PDF/XLSX exports not yet implemented (CSV works).
- **Assessment integrity:** No proctoring; no configured MCQ time limit, question generation rate-limits, anti-abuse, random answer ordering, fairness calibrations or scoring appeals. Add these for production.
- **Security:** Add CSP, rate limiting, password reset and verification expiry, email send queues, file AV scanning, audit protection, file retention, provider auth, secure backups, error monitoring, incident response and comprehensive independent penetration testing.

## Privacy and fairness

Sensitive identity documents and candidate videos require explicit informed consent, scoped access, fixed retention and a deletion process. Restrict access to authorized admins only; a generic admin role should not automatically confer access to every identity file without business need. Assess **job-relevant** communication and performance, not physical attractiveness, disability, accent or protected traits. No-show charges should never apply to verified platform failures or without an appeal/review mechanism. Confirm that assessment fees, refund rules and international payment handling are compliant with relevant laws.

## Test checklist

1. Confirm a candidate cannot access another candidate's application or file.
2. Confirm unauthorized staff cannot approve payments, schedule interviews or publish scores.
3. Ensure applicants cannot access test before completed interview and verified payment.
4. Ensure MCQ answer key never reaches browser response before scoring.
5. Check project form submission after 120 seconds is refused.
6. Check path traversal, invalid files, giant uploads, malformed requests and duplicate email.
7. Confirm score is capped at 200 and only published after reviewed grading.
8. Confirm SSL / HTTPS is on, private files inaccessible via direct URLs, MySQL credentials are never public.
9. Verify local vs UTC countdown under multiple timezones.
10. Test notifications, refund, no-show appeal, data deletion and backups once those integrations are implemented.

## 2026-11-21 code audit and changes (review build v0.2)

A second code review found and patched several issues:

- Logout now requires POST and a valid CSRF token, avoiding forced sign-out via a GET link.
- Candidate upload endpoint now limits upload categories and checks the uploaded temporary file. Published applications cannot accept more uploads or edit their profile.
- Project assessment now requires CV, identity and profile first. Empty/late/repeated answers are blocked on the server; expired questions no longer show the submit form after refresh.
- Project response and introductory recording are required before assessment payment proof submission. Pending/approved payments cannot be overwritten by another receipt submission.
- Profile fields now use a debounced auto-save request with visible success/failure indicator.
- Consent checkbox must actually be checked when consenting to recording.
- Admin payment decisions require a pending payment. Admin cannot schedule an interview without an approved payment or add another appointment while an interview is already scheduled/completed.
- Interview attendance is limited to scheduled interviews; an appointment may not be marked attended/no-show before its start time.
- Video/presentation mark validation rejects non-numeric/out-of-range values. Published results are locked against regrading; repeat MCQ submissions have an additional guard.
- Downloads gain sandbox response headers and extra security/cache headers; guest language preferences are preserved within the session.

**Verification performed here:** PHP lint of the three PHP files; Node JavaScript syntax check; 17 targeted *static* checks (total 21 pass). These source checks do **not** establish functional correctness across a live MySQL database or real Hostinger deployment. The available PHP CLI does not have `pdo_mysql`, and no running MySQL service or browser automation is available in this environment. The database schema has not been executed and the video, upload, email and end-to-end flows are **not runtime validated**.

### Required production blockers

Do not launch publicly yet. Outstanding work includes the AI ATS parser and AI question generation, actual Arabic/Urdu translations, bank QR receipt workflow and fee appeal/refund, secure meeting room authorization and recording, WhatsApp and authenticated SMTP, admin staff management and password recovery, automated sensitive-data retention/deletion, IP-based brute-force/rate limiting, background email delivery, secure logging, actual XLSX/PDF exports, malware and media duration validation, question review/equity, and browser/database acceptance tests. Also check legal authorization, candidate privacy policy, and national/international recruiting fee restrictions before collecting assessment payments.

## v0.3 — Duplicate identity, application timeline, staff logins, career courses

**New installation:** Import `schema.sql` into an EMPTY MySQL database. **Existing installation:** back up your database and import only `migration_v03.sql` once. Existing users/applications are not deleted by migration. Use the Hostinger database import function or a secure terminal session.

Add `identity_hmac_key` to `config.php` with a dedicated secret generated on your computer or Hostinger shell using `php -r "echo bin2hex(random_bytes(32)), PHP_EOL;"`. The key must be secret, cannot be changed without a planned data migration, and is different from an admin password. Never share it over chat or email. Identity checks are applied when the candidate provides a CNIC/passport/ID in their profile; an account without a submitted ID cannot progress through profile completion, but duplicate identity cannot be blocked at initial email registration. Authenticity of ID documents requires independent manual/approved verification. Existing accounts need to enter their identity number on next profile save. The system stores fingerprints and last-four masks, not readable full ID numbers.

The admin sign-in is shared (`?p=login`); run `php bootstrap_admin.php you@example.com 'YOUR-VERY-STRONG-PASSWORD'` once via Hostinger SSH/terminal with `config.php` already configured. Do not place a real password in shell history if you can avoid it. Delete `bootstrap_admin.php` after creation. The Super Admin opens `?p=team` to create HR and Interviewer logins. No default admin username or password is shipped.

Candidates open `?p=dashboard` for their application cards and milestone timeline; individual applications have skill-matched course suggestions. Admin/HR uses `?p=courses` to curate titles, descriptions, providers and HTTPS learning URLs. Recommendations are currently keyword based, not an AI evaluator; courses do not imply accreditation or a guaranteed job.

### Actual database test on Hostinger
Run `php tests/db_smoke.php` after migration, with a dedicated testing DB first if possible. It checks all 11 tables, actual MySQL insert/read/update operations, duplicate identity rejection, event recording and course data, then rolls back inserted fixtures. It does NOT simulate browser camera/microphone, email delivery, external calling, AI parsing, bank payment or every click. Execute it only via CLI, never as a public website endpoint.

### Remaining production-blocking work
An end-to-end test with connected MySQL and a real browser is still necessary. Payment data, identity-document access, identity-change disputes, consent, 90-day retention deletion, authenticated SMTP, WhatsApp, provider video recording, AI CV parsing, AI questions and multilingual translations require further integration, security review and acceptance testing. Sensitive documents must be stored outside public_html, and document access should be limited to specifically authorized roles rather than exposing all identities to every admin.

## v0.4 — live camera document capture, registration clock, manual CV, and fee review

This revision adds the features requested for `applyforjob.miantayyab.com`:

- Opening the **Register** page starts a 20-minute registration timer stored initially in the session and then on the user record. The first application inherits that timestamp, even if email verification requires a new browser session. Subsequent applications start at application creation.
- The application wizard displays a countdown that runs **negative after 20 minutes**, with a **60-second grace period**. The server computes the actual fee independently of the browser. For Pakistani candidates, the configured base PKR 2,000 changes to PKR 4,000 only after the full 21 minutes, unless an approved waiver is recorded. International extra fee defaults to PKR 0 and must be explicitly configured if legally permitted. Candidates must review the updated fee; if it changes while the payment page is open, submission is stopped and they are asked to review again. **Do not transfer an amount until its final invoice is shown**.
- The application now accepts JPG/PNG camera photographs for CV and identity (as well as original formats). The `Capture with camera` button uses WebRTC over **HTTPS**, allows preview/retake, and uploads to the private document storage. This version captures a single page per press; it does not automatically stitch pages into PDFs or check document authenticity. File upload is still available when browser camera permissions are denied.
- Candidates without an ATS CV can fill in the profile manually, but must still provide a securely uploaded identity document and mandatory identity number to progress. **The AI CV extraction service is not built in**, so photographed/image CVs also require manual entry.
- Candidates can request a late-fee exception in the payment section; admin/HR can approve or reject it on the review page, and decisions are audit-logged. Technical problems, accessibility needs and server incidents warrant review. The timer **never removes saved work** or locks a user out solely for running out of time.
- Super Admin / HR / Interviewer logins, unique CNIC/passport fingerprints, candidate history, career course recommendations and test scoring remain included from v0.3.

### Install / upgrade

**New installation:** Import `schema.sql` into an empty MySQL database. It includes v0.3 and v0.4 tables/columns; do **not** import migration files into that same fresh database.

**Upgrade existing v0.3:** Back up the database, apply **only** `migration_v04.sql`. Do not apply this file twice: `ALTER TABLE ADD COLUMN` will fail on the second import. If you are upgrading from v0.2, first run `migration_v03.sql` then `migration_v04.sql`.

Run `python3 tests/check_project.py` for code/static checks, followed by `php tests/db_smoke.php` through Hostinger's CLI for MySQL write/read/rollback checks. Verify account creation, verification, uploads, camera, identity locks, charge quotation, admin review, and dashboard history through a real HTTPS browser before public launch.

### Pricing and compliance

The time-based extra fee is a configurable business rule; it is **not** a gateway-captured payment. Payment proof is manually reviewed and the bank transfer must be independently reconciled. Clear disclosure before starting the timer, reasonable accommodations/waivers, fair refund and no-show rules, and legal checks for charging job candidates internationally are essential. The default language translations, AI CV parsing, automatic AI-generated question sets, direct integrated video provider, secure call recording, WhatsApp and authenticated email delivery are **not yet fully implemented**. Do not treat this package as production certified or store sensitive ID documents on a public server until the security controls and live integration tests are complete.

## v0.5 targeted patch — work performed in this session

This is a **limited, unverified development patch, not the complete implementation** of the latest requested 60-minute interview platform. Read the original warnings above before deploying.

### Changed in source
- Candidate signup requests a **National ID number and/or passport number** at registration, and commits the newly registered identity fingerprint in the same MySQL transaction as account creation. A known duplicate fingerprint blocks signup with another email. Both numbers are optional individually, but at least one is required. It is not government-ID authenticity verification.
- CV upload is required before project progression and assessment payment, with manual profile corrections still available. The existing AI-ATS integration is not functional.
- Introduction video submission was reduced from two to **one**; recommended browser recorder bitrate is lowered to limit storage use. This is a client bitrate setting, not guaranteed maximum filesize or server-side 90-second media-duration proof. Production must add server-side media verification and concurrency-safe one-shot locking.
- The *existing* 20-minute signup deadline + 60-second grace is retained. When elapsed, candidate application, upload, and test routes redirect to a mandatory late payment review page. The page accepts a real bank transfer reference and private receipt, and an admin must approve it before the user can continue. A manually reviewed exception can also unlock the flow. This is a **server-side gate**: mere JavaScript dismissal does not authorize continuation. The extra fee for Pakistan is PKR 2,000 on top of the initial PKR 2,000; international late fee remains separately configured.
- Identity upload from the ordinary file picker is rejected by the server, and the camera capture UI sends its source marker. A marker alone cannot prove a real camera feed or stop a modified client; real identity verification requires a trusted vendor/manual review.
- The portal and receipt steps remain otherwise as in v0.4. Late-gate form blocks progression until manual receipt approval; no money is charged or reconciled automatically.

### Not yet implemented / requires additional engineering and/or customer integrations
- Fully translated **every screen** in English, Arabic and Urdu (with proper RTL layout, dates/number formatting and verification).
- Automatic CV parsing and AI skill-gap/courses/recruitment question generation; requires AI service account, API credentials, per-candidate validation and quality checks. OpenAI file inputs support PDFs and some document formats, but actual integrations are not included.
- Sequential one-way, individually sealed education/degree/diploma/certification/company/skills/contact forms; the present single editable profile remains.
- Active anti-AI cheating detection cannot be guaranteed from browser text alone; avoid making unsupported surveillance claims. This version does not monitor AI usage.
- 60-minute session: 15-minute live video, 30-minute timed MCQs and 15-minute two writing assignments, exact time enforcement, and the 3–4 hour result display window.
- Embedded live video room/recording, consent event capture, authorized room token control and server-side compression, deletion, storage lifecycle, and real-time staff/candidate presence.
- Automated verified WhatsApp and SMTP alerts, Bank Alfalah account/QR/image upload, bank transaction reconciliation, refunds, coupon generation, appeal/no-show rebooking settlement, automatic USD foreign exchange data and margin disclosure.
- Admin suspension/appeal process and verified-fraud controls, automated 90-day deletion, continuous audit monitoring, full acceptance/security tests on Hostinger.

**Existing schema.sql is unchanged**; all modified features reuse existing tables. If deploying to an established database, take a full backup first. **Do not accept public registrations, bank payments, ID documents or media recordings until the remaining security, legal, consent, banking and end-to-end runtime checks are complete.**
