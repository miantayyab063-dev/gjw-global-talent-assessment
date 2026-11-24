# v0.5 — Targeted Patch Testing Report

## Test environment
- PHP CLI syntax check (`php -l`), Node.js JavaScript syntax check (`node --check`), repository source-level assertions (`tests/check_project.py`).
- No `pdo_mysql` driver or local MySQL daemon is available in this execution environment; connection, SQL writes, row locks and migrations **not tested**.
- Browser, camera, external AI, real live conferencing, Hostinger bank/QR and SMTP credentials **not available**, therefore not tested end-to-end.

## Verified by static inspection / syntax only
- National ID/passport signup and HMAC duplicate check code path exists.
- Signup identity and account insertion placed inside a DB transaction.
- Live camera capture is required on the identity upload route by source marker.
- One permitted intro video upload per application is checked by the upload handler.
- CV is required for project/payment transitions.
- Deadline + 60-second grace and mandatory payment review branch present; enforced on candidate application, upload and MCQ routes.
- Late payment receipt submission and admin verification use the existing payments table.
- Candidate can submit an exception request from the payment-gated page.
- Recording bitrate options configured in browser JavaScript.

## Major release blockers
- Browser camera source field can be spoofed. Source marker is not identity authenticity verification.
- Recording upload and retry race require database transaction/locking, media validation and consent proof.
- Full translations, AI parsing/generation, embedded calls, notifications, coupon, 60-minute timed assessment, identity suspension, retention and live financial reconciliation are still missing.
- Actual payment verification is **manual**; never claim screenshot or transaction ID is automatically genuine.

## Readiness
**NO-GO for public production launch.** Complete live environment testing and remaining modules first.
