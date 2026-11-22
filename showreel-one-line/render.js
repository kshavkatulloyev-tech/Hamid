const {chromium}=require('playwright');const fs=require('fs');const {spawn}=require('child_process');
(async()=>{
 const FPS=60,SUB=3,DUR=15,N=FPS*DUR*SUB;
 const b=await chromium.launch();const p=await b.newPage({viewport:{width:1920,height:1080}});
 await p.goto('file://'+__dirname+'/one-line.html');await p.evaluate(()=>window.ready);
 const wav=await p.evaluate(()=>window.renderAudio());fs.writeFileSync('soundtrack.wav',Buffer.from(wav,'base64'));console.log('audio ok');
 const cdp=await p.context().newCDPSession(p);
 const ff=spawn('ffmpeg',['-v','error','-y','-f','image2pipe','-framerate',String(FPS*SUB),'-c:v','mjpeg','-i','-',
  '-vf',"tmix=frames=3:weights='1 1 1',select='eq(mod(n\\,3)\\,2)',setpts=N/60/TB",'-r','60','-c:v','libx264','-preset','slow','-crf','14','-pix_fmt','yuv420p','video.mp4'],{stdio:['pipe','inherit','inherit']});
 const t0=Date.now();
 for(let i=0;i<N;i++){
  const t=(i-1)/(FPS*SUB); // subframes centred on each output frame
  await p.evaluate(t=>window.seek(t),t);
  const r=await cdp.send('Page.captureScreenshot',{format:'jpeg',quality:94});
  const buf=Buffer.from(r.data,'base64'); if(!ff.stdin.write(buf)) await new Promise(r=>ff.stdin.once('drain',r));
  if(i%300===0)console.log(i,'/',N,((Date.now()-t0)/1000).toFixed(0)+'s');
 }
 ff.stdin.end(); await new Promise(r=>ff.on('close',r)); await b.close(); console.log('video ok');
})();
