import base64
b=lambda f,m: f"'data:{m};base64,"+base64.b64encode(open(f,'rb').read()).decode()+"'"
s=open('src.html').read()
s=s.replace('__F_LAT__',b('inter-latin.woff2','font/woff2')).replace('__F_CYR__',b('inter-cyrillic.woff2','font/woff2')).replace('__F_CYX__',b('inter-cyrillic-ext.woff2','font/woff2'))
for k in ['P1','P2','P3','P4']:
    s=s.replace(f"'__{k}__'",b(f'{k.lower()}.jpg','image/jpeg'))
open('ozon-motion.html','w').write(s)
