import base64
f=base64.b64encode(open('inter.woff2','rb').read()).decode()
s=open('src.html').read().replace('__FONT__',"'data:font/woff2;base64,"+f+"'")
open('one-line.html','w').write(s)
