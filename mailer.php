<?php
/** Authenticated email; requires PHPMailer from composer install. */
declare(strict_types=1);
function gjwSendEmail(array $cfg,string $recipient,string $subject,string $plainText):bool{
 $autoload=__DIR__.'/vendor/autoload.php';
 if(!is_file($autoload))return false;
 require_once $autoload;
 if(!class_exists('PHPMailer\\PHPMailer\\PHPMailer'))return false;
 foreach(['smtp_host','smtp_user','smtp_pass','mail_from'] as $k)if(empty($cfg[$k]))return false;
 if(!filter_var($recipient,FILTER_VALIDATE_EMAIL))return false;
 try{
  $m=new \PHPMailer\PHPMailer\PHPMailer(true);$m->isSMTP();
  $m->Host=$cfg['smtp_host'];$m->SMTPAuth=true;$m->Username=$cfg['smtp_user'];$m->Password=$cfg['smtp_pass'];
  $m->SMTPSecure=\PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;
  $m->Port=(int)($cfg['smtp_port']??587);$m->CharSet='UTF-8';
  $m->setFrom($cfg['mail_from'],'GJW Global Talent Assessment');$m->addAddress($recipient);
  $m->Subject=$subject;$m->Body=$plainText;$m->isHTML(false);return $m->send();
 }catch(\Throwable $ex){error_log('GJW SMTP send failed');return false;}
}
