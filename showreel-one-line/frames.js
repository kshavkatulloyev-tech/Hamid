const {chromium}=require('playwright');const fs=require('fs');
(async()=>{const times=JSON.parse(process.argv[2]);const out=process.argv[3];fs.mkdirSync(out,{recursive:true});
const b=await chromium.launch();const p=await b.newPage({viewport:{width:1920,height:1080}});
const errs=[];p.on('pageerror',e=>errs.push(e.message));p.on('console',m=>{if(m.type()==='error')errs.push(m.text())});
await p.goto('file://'+__dirname+'/one-line.html');await p.evaluate(()=>window.ready);
for(const t of times){await p.evaluate(t=>window.seek(t),t);await p.screenshot({path:`${out}/t${t.toFixed(3)}.png`});}
if(errs.length)console.log('ERR',errs.slice(0,5));await b.close();})();
