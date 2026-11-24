<?php
declare(strict_types=1);
/** Pure policy helpers for independent CLI verification. UTC database timestamps expected. */
function gjwDeadlineExceeded(string $start,int $seconds,?int $now=null):bool{
 $timestamp=strtotime($start.' UTC');
 if($timestamp===false)throw new InvalidArgumentException('Invalid UTC start timestamp');
 return ($now??time())>$timestamp+$seconds;
}
function gjwResultVisible(?string $approvedAt,?string $finishedAt,?int $now=null):bool{
 if(!$approvedAt||!$finishedAt)return false;
 $release=strtotime($finishedAt.' UTC');
 return $release!==false && ($now??time()) >= $release+14400;
}
function gjwWritingPrompts(array $cfg,string $profession):array{
 $profession=trim($profession);
 if(!empty($cfg['ai_api_key'])){
  try{
   $r=gjwAiJson($cfg,'Return only JSON {"topic_one":"...","topic_two":"..."}. Provide two different relevant brief work-related writing prompts requiring original reasoned explanations; avoid protected attributes and private data. Each prompt should be 40-300 characters.', 'Profession: '.$profession,400);
   $a=trim((string)($r['topic_one']??''));$b=trim((string)($r['topic_two']??''));
   if(strlen($a)>=40&&strlen($a)<=300&&strlen($b)>=40&&strlen($b)<=300&&$a!==$b)return [$a,$b];
  }catch(Throwable $e){error_log('Writing AI unavailable, using fixed prompts');}
 }
 return ["Describe a real work challenge in the role of $profession and explain your solution and its measurable outcome.","Explain two technical or professional skills required for $profession and how you verify the quality of your work."];
}
