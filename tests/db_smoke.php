<?php
declare(strict_types=1);
// CLI ONLY. Runs within a rolled-back transaction on a configured MySQL database.
if(PHP_SAPI!=='cli'){http_response_code(404);exit;}
$root=dirname(__DIR__);
require_once $root.'/app_config.php';
$cfg=require gjwConfigPath();
$pdo=new PDO('mysql:host='.$cfg['db_host'].';dbname='.$cfg['db_name'].';charset=utf8mb4',$cfg['db_user'],$cfg['db_pass'],[
 PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false
]);
function check(bool $ok,string $label):void{echo ($ok?'PASS':'FAIL')." $label\n";if(!$ok)throw new RuntimeException($label);}
$needed=['users','applications','documents','payments','interviews','questions','attempts','audit_logs','settings','candidate_identifiers','course_catalog','fee_waiver_requests','writing_assessments','cv_ai_drafts'];
foreach($needed as $table){$st=$pdo->query('SHOW TABLES LIKE '.$pdo->quote($table));check((bool)$st->fetch(),"schema.$table exists");}
$pdo->beginTransaction();
try{
 $token=bin2hex(random_bytes(10));$email="test-$token@example.invalid";
 $stmt=$pdo->prepare('INSERT INTO users(name,email,pass_hash,role) VALUES(?,?,?,?)');$stmt->execute(['Database smoke test',$email,password_hash('test-strong-password-123',PASSWORD_DEFAULT),'candidate']);
 $uid=(int)$pdo->lastInsertId();$stmt=$pdo->prepare('SELECT id FROM users WHERE email=?');$stmt->execute([$email]);check((int)$stmt->fetchColumn()===$uid,'candidate write and read-back');
 $ref='TEST-'.strtoupper(substr($token,0,16));$stmt=$pdo->prepare('INSERT INTO applications(user_id,reference,profession) VALUES(?,?,?)');$stmt->execute([$uid,$ref,'Data Entry Operator']);$aid=(int)$pdo->lastInsertId();
 $pdo->prepare('UPDATE applications SET data_json=?,step=4 WHERE id=?')->execute([json_encode(['skills'=>'Excel','experience'=>'Data entry']),$aid]);
 $stmt=$pdo->prepare('SELECT user_id,step,data_json FROM applications WHERE id=?');$stmt->execute([$aid]);$app=$stmt->fetch();check((int)$app['user_id']===$uid&&(int)$app['step']===4&&json_decode($app['data_json'],true)['skills']==='Excel','application JSON saved and read-back');
 $secret=(string)($cfg['identity_hmac_key']??'');check(strlen($secret)>=32&&!str_contains($secret,'REPLACE_WITH'),'identity HMAC configuration');
 $fingerprint=hash_hmac('sha256','passport:TEST'.$token,$secret);
 $pdo->prepare('INSERT INTO candidate_identifiers(user_id,id_type,identifier_hash,masked_value) VALUES(?,?,?,?)')->execute([$uid,'passport',$fingerprint,'••••1234']);
 $duplicateBlocked=false;
 try{$pdo->prepare('INSERT INTO candidate_identifiers(user_id,id_type,identifier_hash,masked_value) VALUES(?,?,?,?)')->execute([$uid,'passport',$fingerprint,'••••1234']);}
 catch(PDOException $e){$duplicateBlocked=true;}
 check($duplicateBlocked,'duplicate identity unique index enforced');
 $pdo->prepare('INSERT INTO audit_logs(actor_id,application_id,action) VALUES(?,?,?)')->execute([$uid,$aid,'test_history']);
 $stmt=$pdo->prepare('SELECT COUNT(*) FROM audit_logs WHERE application_id=? AND action=?');$stmt->execute([$aid,'test_history']);check((int)$stmt->fetchColumn()===1,'application history write and read-back');
 $pdo->prepare('INSERT INTO payments(application_id,amount_pkr,transfer_reference) VALUES(?,?,?)')->execute([$aid,2000,'TEST-'.$token]);
 $stmt=$pdo->prepare('SELECT kind,status,amount_pkr,transfer_reference FROM payments WHERE application_id=?');
 $stmt->execute([$aid]);$payment=$stmt->fetch();
 check((bool)$payment&&$payment['kind']==='assessment'&&$payment['status']==='pending'&&(int)$payment['amount_pkr']===2000&&$payment['transfer_reference']==='TEST-'.$token,'simulated payment record saved and read-back');
 $pdo->prepare('INSERT INTO documents(application_id,kind,original_name,relative_path,mime) VALUES(?,?,?,?,?)')->execute([$aid,'payment_receipt','test.pdf',$aid.'/test.pdf','application/pdf']);
 $stmt=$pdo->prepare('SELECT relative_path FROM documents WHERE application_id=? AND kind=?');
 $stmt->execute([$aid,'payment_receipt']);check($stmt->fetchColumn()===$aid.'/test.pdf','receipt metadata saved and read-back');
 $stmt=$pdo->query('SELECT COUNT(*) FROM course_catalog WHERE active=1');check((int)$stmt->fetchColumn()>0,'course catalog populated');
}finally{if($pdo->inTransaction())$pdo->rollBack();}
check(true,'test fixtures rolled back; no smoke-test records retained');
