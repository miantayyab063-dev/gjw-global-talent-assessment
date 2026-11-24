<?php
if(PHP_SAPI!=='cli'){http_response_code(404);exit;}
$requirements=['PHP version >= 8.2'=>PHP_VERSION_ID>=80200,'PDO MySQL driver'=>in_array('mysql',PDO::getAvailableDrivers(),true),'cURL extension'=>extension_loaded('curl'),'FileInfo extension'=>extension_loaded('fileinfo'),'OpenSSL extension'=>extension_loaded('openssl'),'mbstring extension'=>extension_loaded('mbstring'),'ZipArchive extension'=>class_exists('ZipArchive'),'Composer autoload present'=>is_file(dirname(__DIR__).'/vendor/autoload.php')];
foreach($requirements as $label=>$result)echo ($result?'PASS':'MISSING')." $label\n";
require_once dirname(__DIR__).'/app_config.php';
$cfgFile=gjwConfigPath();echo (is_file($cfgFile)?'PRESENT':'MISSING')." Private configuration\n";
?>