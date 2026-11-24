<?php
/** CLI only: set cron daily. Deletes private files linked to applications closed >90 days ago. */
declare(strict_types=1);
if(PHP_SAPI!=='cli'){http_response_code(404);exit;}
require_once __DIR__.'/app_config.php';
$cfg=require gjwConfigPath();
$db=new PDO('mysql:host='.$cfg['db_host'].';dbname='.$cfg['db_name'].';charset=utf8mb4',$cfg['db_user'],$cfg['db_pass'],[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);
$base=realpath($cfg['storage_dir']);if(!$base)exit("Private storage not found.\n");
$select=$db->prepare('SELECT d.id,d.relative_path FROM documents d JOIN applications a ON a.id=d.application_id WHERE a.closed_at IS NOT NULL AND a.closed_at < DATE_SUB(UTC_TIMESTAMP(),INTERVAL 90 DAY) LIMIT 500');
$select->execute();$del=$db->prepare('DELETE FROM documents WHERE id=?');$done=0;
foreach($select->fetchAll(PDO::FETCH_ASSOC) as $r){
 $path=realpath($base.'/'.$r['relative_path']);
 if($path!==false&&str_starts_with($path,$base.DIRECTORY_SEPARATOR)&&is_file($path)&&!unlink($path)){error_log('Retention file deletion failed '.$r['id']);continue;}
 $del->execute([$r['id']]);$done++;
}
echo "Expired private document records removed: $done\n";
