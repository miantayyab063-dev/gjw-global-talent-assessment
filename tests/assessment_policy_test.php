<?php
declare(strict_types=1);
require_once dirname(__DIR__).'/assessment_policy.php';
function ok(bool $condition,string $message):void{if(!$condition){fwrite(STDERR,"FAIL: $message\n");exit(1);}echo "PASS: $message\n";}
$utc='2026-01-01 00:00:00';$start=strtotime($utc.' UTC');
ok(!gjwDeadlineExceeded($utc,1800,$start+1800),'MCQ accepted up to 30 min');
ok(gjwDeadlineExceeded($utc,1800,$start+1801),'MCQ rejected after 30 min');
ok(!gjwDeadlineExceeded($utc,900,$start+900),'Writing accepted through 15 min');
ok(gjwDeadlineExceeded($utc,900,$start+901),'Writing deadline enforced after 15 min');
ok(!gjwResultVisible(null,$utc,$start+15000),'Unapproved result hidden');
ok(!gjwResultVisible($utc,$utc,$start+14399),'Approved result hidden before four hours');
ok(gjwResultVisible($utc,$utc,$start+14400),'Approved result released at four hours');
$qs=gjwWritingPrompts(['ai_api_key'=>''],'Data Entry Operator');
ok(count($qs)===2&&$qs[0]!==$qs[1],'Two distinct safe prompts without AI configured');
?>