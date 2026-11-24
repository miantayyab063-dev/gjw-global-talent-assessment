<?php
return [
 'db_host'=>'localhost','db_name'=>'u000000000_assessment','db_user'=>'u000000000_admin','db_pass'=>'CHANGE_ME',
 'real_payments_enabled'=>false,
 'app_url'=>'https://applyforjob.miantayyab.com',
 'mail_from'=>'HR@GULFCAREERINSTITUTE.COM',
 'initial_admin_email'=>'miantayyab063@gmail.com',
 'coupon_hmac_key'=>'REPLACE_WITH_64_RANDOM_HEX_CHARACTERS',
 'ai_api_key'=>'', // set privately only when account is provisioned
 'ai_model'=>'gpt-4.1-mini',
 'mail_transport'=>'smtp',
 'smtp_host'=>'smtp.hostinger.com', // confirm actual mailbox service hostname
 'smtp_port'=>587,
 'smtp_user'=>'HR@GULFCAREERINSTITUTE.COM',
 'smtp_pass'=>'', // set privately; never include in ZIP
 'identity_hmac_key'=>'REPLACE_WITH_64_RANDOM_HEX_CHARACTERS_GENERATED_USING_SECURE_RANDOM',
 'storage_dir'=>dirname(__DIR__).'/assessment_private', // outside public_html is essential
];
