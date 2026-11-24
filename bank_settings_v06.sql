INSERT INTO settings (`key`,`value`) VALUES ('bank_instructions','BANK ALFALAH — ASSESSMENT PAYMENTS
Account title Configure locally.
IBAN Configure locally.
Branch Configure locally.
Branch code Configure locally.
SWIFT Configure locally.
Please confirm recipient details with your bank before paying. Keep the real transaction ID and upload the receipt. A screenshot is not proof of settlement until admin verifies the bank transaction.

English: The fee pays for assessment administration, not a guaranteed job. Refund eligibility is subject to written policy and verified attendance/results.
اردو: یہ فیس اسیسمنٹ کے انتظام کے لیے ہے، ملازمت کی ضمانت نہیں۔ ریفنڈ تحریری پالیسی اور تصدیق کے مطابق ہوگا۔
العربية: هذه الرسوم مقابل إدارة التقييم وليست ضماناً للتوظيف. يخضع الاسترداد للسياسة المكتوبة والتحقق.') ON DUPLICATE KEY UPDATE value=VALUES(value);
