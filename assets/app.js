function startCountdown(id,iso,doneText='Time completed'){const el=document.getElementById(id);if(!el)return;function tick(){let s=Math.max(0,Math.ceil((new Date(iso).getTime()-Date.now())/1000));const d=Math.floor(s/86400),h=Math.floor(s%86400/3600),m=Math.floor(s%3600/60),ss=s%60;el.textContent=s?(d?d+'d ':'')+[h,m,ss].map(x=>String(x).padStart(2,'0')).join(':'):doneText;}tick();setInterval(tick,1000)}
async function recordIntro(uploadUrl,token,applicationId){const out=document.getElementById('recStatus'),preview=document.getElementById('preview');if(!navigator.mediaDevices||!window.MediaRecorder){out.textContent='Recording requires a supported browser over HTTPS.';return}let stream;try{stream=await navigator.mediaDevices.getUserMedia({video:true,audio:true})}catch(e){out.textContent='Camera or microphone permission was denied.';return}const mime=['video/webm;codecs=vp8,opus','video/webm','video/mp4'].find(t=>MediaRecorder.isTypeSupported(t))||'';const chunks=[];const r=new MediaRecorder(stream,{...(mime?{mimeType:mime}:{}),videoBitsPerSecond:320000,audioBitsPerSecond:48000});r.ondataavailable=e=>{if(e.data.size)chunks.push(e.data)};r.onstop=async()=>{stream.getTracks().forEach(t=>t.stop());const blob=new Blob(chunks,{type:r.mimeType||'video/webm'});preview.src=URL.createObjectURL(blob);preview.controls=true;out.textContent='Uploading recording securely...';const fd=new FormData();fd.append('csrf',token);fd.append('app_id',applicationId);fd.append('file',blob,'introduction.'+(blob.type.includes('mp4')?'mp4':'webm'));fd.append('kind','intro_video');try{const res=await fetch(uploadUrl,{method:'POST',body:fd,credentials:'same-origin'});const json=await res.json();out.textContent=json.message||'Upload finished';if(json.ok)setTimeout(()=>location.reload(),1200)}catch(e){out.textContent='Upload unsuccessful. Please retry.'}};r.start(1000);let remaining=90;out.textContent='Recording — 90 seconds remaining';const t=setInterval(()=>{remaining--;out.textContent='Recording — '+remaining+' seconds remaining';if(remaining<=0){clearInterval(t);r.stop()}},1000);document.getElementById('recordBtn').disabled=true}
async function saveDraft(url,token,id){const f=document.getElementById('profileForm');if(!f)return;let fd=new FormData(f);fd.append('csrf',token);fd.append('app_id',id);fd.append('autosave','1');try{await fetch(url,{method:'POST',body:fd,credentials:'same-origin'})}catch(e){}}

function enableDraftAutosave(url,token){
  const form=document.getElementById('profileForm');
  const status=document.getElementById('draftStatus');
  if(!form)return;
  let timeout=null, inFlight=false, dirty=false;
  const save=async()=>{
    if(inFlight){dirty=true;return;}
    inFlight=true;
    const data=new FormData(form);
    ['cnic_number','passport_number','national_id_number'].forEach(name=>data.delete(name)); // identity committed only on explicit Save Profile
    data.set('csrf',token);
    data.set('autosave','1');
    if(status)status.textContent=' Saving…';
    try{
      const response=await fetch(url,{method:'POST',body:data,credentials:'same-origin'});
      if(!response.ok)throw new Error('Save failed');
      const result=await response.json();
      if(!result.ok)throw new Error('Save failed');
      if(status)status.textContent=' Draft saved';
    }catch(err){if(status)status.textContent=' Auto-save unavailable. Use Save Profile.';}
    finally{inFlight=false;if(dirty){dirty=false;save();}}
  };
  form.addEventListener('input',()=>{clearTimeout(timeout);if(status)status.textContent=' Unsaved changes';timeout=setTimeout(save,1200)});
  form.addEventListener('submit',()=>clearTimeout(timeout));
}

// The visual counter uses server-issued UTC deadlines; actual late-fee determination is server-side.
function registrationCountdown(){
 const el=document.getElementById('registrationTimer');if(!el)return;
 const deadline=Date.parse(el.dataset.deadline||'');if(!Number.isFinite(deadline)){el.textContent='Timer not available';return;}
 function tick(){const secs=Math.ceil((deadline-Date.now())/1000);const abs=Math.abs(secs);const mm=String(Math.floor(abs/60)).padStart(2,'0');const ss=String(abs%60).padStart(2,'0');el.textContent=(secs<0?'-':'')+mm+':'+ss;const graceLeft=60+secs;el.classList.toggle('late',graceLeft<0);el.title=secs>=0?'Registration time remaining':graceLeft>=0?'Grace period, no extra fee yet':'Additional charge may apply; request review if you need an exception';}
 tick();setInterval(tick,1000);
}
document.addEventListener('DOMContentLoaded',registrationCountdown);

// A browser-camera photo is uploaded to the candidate-owned private document endpoint.
async function capturePhoto(url,csrf,applicationId,kind){
 if(!['cv','identity'].includes(kind))return;
 if(!navigator.mediaDevices?.getUserMedia){alert('Camera capture requires HTTPS and a supported browser. Use file upload instead.');return;}
 let stream;
 try{stream=await navigator.mediaDevices.getUserMedia({video:{facingMode:{ideal:'environment'}},audio:false});}
 catch(e){alert('Camera access unavailable. You can use the file upload option.');return;}
 const overlay=document.createElement('div');overlay.className='camera-overlay';
 const box=document.createElement('div');box.className='camera-dialog';
 const title=document.createElement('h3');title.textContent=kind==='cv'?'Capture CV page':'Capture identity document';
 const tip=document.createElement('p');tip.textContent='Hold the whole document inside the frame, with readable text and no glare. Review the image before submitting.';
 const video=document.createElement('video');video.autoplay=true;video.playsInline=true;video.muted=true;video.srcObject=stream;
 const preview=document.createElement('img');preview.style.display='none';preview.alt='Captured document preview';
 const snap=document.createElement('button');snap.type='button';snap.textContent='Capture photo';
 const retry=document.createElement('button');retry.type='button';retry.textContent='Retake';retry.style.display='none';
 const submit=document.createElement('button');submit.type='button';submit.textContent='Save photo securely';submit.style.display='none';
 const close=document.createElement('button');close.type='button';close.textContent='Cancel';close.className='secondary';
 const status=document.createElement('p');status.setAttribute('role','status');let imageBlob=null;
 function stop(){stream?.getTracks().forEach(t=>t.stop());overlay.remove();}
 close.onclick=stop;
 snap.onclick=()=>{if(!video.videoWidth){status.textContent='Camera initializing. Try again.';return;}
   const canvas=document.createElement('canvas');const scale=Math.min(1,1800/video.videoWidth);canvas.width=Math.round(video.videoWidth*scale);canvas.height=Math.round(video.videoHeight*scale);canvas.getContext('2d').drawImage(video,0,0,canvas.width,canvas.height);
   canvas.toBlob(blob=>{if(!blob){status.textContent='Unable to capture image.';return;}imageBlob=blob;preview.src=URL.createObjectURL(blob);preview.style.display='block';video.style.display='none';snap.style.display='none';retry.style.display='inline-block';submit.style.display='inline-block';},'image/jpeg',0.88);
 };
 retry.onclick=()=>{imageBlob=null;preview.style.display='none';video.style.display='block';snap.style.display='inline-block';retry.style.display='none';submit.style.display='none';};
 submit.onclick=async()=>{if(!imageBlob)return;submit.disabled=true;status.textContent='Saving photo…';const data=new FormData();data.append('csrf',csrf);data.append('app_id',String(applicationId));data.append('kind',kind);data.append('capture_source','camera');data.append('file',imageBlob,kind+'-camera.jpg');try{const r=await fetch(url,{method:'POST',body:data,credentials:'same-origin',redirect:'follow'});if(!r.ok)throw Error('Upload failed');stop();location.reload();}catch(e){status.textContent='Could not save. Try uploading a file instead.';submit.disabled=false;}};
 box.append(title,tip,video,preview,snap,retry,submit,close,status);overlay.append(box);document.body.append(overlay);
}
