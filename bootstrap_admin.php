<?php
// CLI ONLY: php bootstrap_admin.php admin@example.com 'strong-long-password'
if(PHP_SAPI!=='cli'){http_response_code(404);exit;}
if($argc<3||strlen($argv[2])<12)exit("Usage: php bootstrap_admin.php email@example.com '12+ character password'\n");
require_once __DIR__.'/app_config.php';
$cfg=require gjwConfigPath();$pdo=new PDO('mysql:host='.$cfg['db_host'].';dbname='.$cfg['db_name'].';charset=utf8mb4',$cfg['db_user'],$cfg['db_pass'],[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);$email=strtolower($argv[1]);if(!filter_var($email,FILTER_VALIDATE_EMAIL))exit("Invalid email\n");$stmt=$pdo->prepare('INSERT INTO users(name,email,pass_hash,role,email_verified_at) VALUES(?,?,?,?,UTC_TIMESTAMP())');$stmt->execute(['Super Administrator',$email,password_hash($argv[2],PASSWORD_DEFAULT),'super_admin']);echo "Admin created. Delete bootstrap_admin.php from web root.\n";
