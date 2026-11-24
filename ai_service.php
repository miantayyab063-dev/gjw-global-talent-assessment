<?php
/** Server-side AI adapter. Never call from browser or expose API key. */
declare(strict_types=1);
function gjwAiJson(array $cfg,string $system,string $user,int $maxTokens=1600):array{
 $key=(string)($cfg['ai_api_key']??'');
 if(trim($key)==='')throw new RuntimeException('AI API not configured: set ai_api_key in private config.php.');
 if(!function_exists('curl_init'))throw new RuntimeException('PHP cURL extension is required for AI integration.');
 $payload=['model'=>$cfg['ai_model']??'gpt-4.1-mini','input'=>[
 ['role'=>'system','content'=>[['type'=>'input_text','text'=>$system]]],
 ['role'=>'user','content'=>[['type'=>'input_text','text'=>mb_strcut($user,0,6000,'UTF-8')]]],
 ],'max_output_tokens'=>$maxTokens,'store'=>false];
 $h=curl_init('https://api.openai.com/v1/responses');
 curl_setopt_array($h,[CURLOPT_POST=>true,CURLOPT_POSTFIELDS=>json_encode($payload,JSON_THROW_ON_ERROR),CURLOPT_HTTPHEADER=>['Authorization: Bearer '.$key,'Content-Type: application/json'],CURLOPT_RETURNTRANSFER=>true,CURLOPT_TIMEOUT=>35,CURLOPT_CONNECTTIMEOUT=>8,CURLOPT_SSL_VERIFYPEER=>true]);
 $body=curl_exec($h);$err=curl_error($h);$status=(int)curl_getinfo($h,CURLINFO_HTTP_CODE);curl_close($h);
 if($body===false||$status<200||$status>=300)throw new RuntimeException('AI provider unavailable (HTTP '.$status.'). '.$err);
 $response=json_decode($body,true);if(!is_array($response))throw new RuntimeException('Invalid AI provider response');
 $text='';foreach($response['output']??[] as $part)foreach($part['content']??[] as $c)if(($c['type']??'')==='output_text')$text.=$c['text']??'';
 $text=trim($text);if(str_starts_with($text,'```'))$text=preg_replace('/^```(?:json)?\s*|\s*```$/u','',$text);
 $out=json_decode(trim($text),true);if(!is_array($out))throw new RuntimeException('AI output was not valid JSON, no data saved.');return $out;
}
function gjwGenerateQuestions(array $cfg,string $profession):array{
 $output=gjwAiJson($cfg,'You create safe, professionally relevant skill-assessment practice questions. Return strictly JSON object {"questions":[{"prompt":string,"a":string,"b":string,"c":string,"d":string,"correct":"a"|"b"|"c"|"d","explanation":string}]}. Do not include personal or protected characteristics. All facts should be easy for an expert to verify. Generate exactly 3 questions. No markdown.','Profession: '.$profession,1800);
 $qs=$output['questions']??[];if(!is_array($qs)||count($qs)!==3)throw new RuntimeException('AI returned wrong question count.');
 foreach($qs as $row){foreach(['prompt','a','b','c','d','explanation'] as $field)if(!is_string($row[$field]??null)||trim($row[$field])===''||strlen($row[$field])>800)throw new RuntimeException('Malformed AI question');if(!in_array($row['correct']??'',['a','b','c','d'],true))throw new RuntimeException('Malformed answer key');}
 return $qs;
}
