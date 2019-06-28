--noinspection UnusedDef
local addon=select(2,...)
TCLUUID = TCLUUID or {0}
local c,a,s,h,m,o,n,e,y="Player",string.char,string.gsub,bit.band,bit.rshift,{},{},TCLUUID,{4,3,2,1,6,5,8,7}
local u,q=s(s(UnitGUID(c),c,""),"-",""),{0x00,0x40,0x81,0x13,0xd2,0x1d,0xb2,0x01}
for i=1,10 do n[i]=a(i+47)n[i+10]=a(i+64)end for i=0,15 do for i1=0,15 do o[i*16+i1]=n[i+1]..n[i1+1]end end
function addon.TomCatsLibs.UUID.getUUID() local x,t,r = {},GetServerTime(),0 e[1]=h(e[1]+1,0xffff) x[9]=o[m(e[1],8)]x[10]=o[h(e[1],0xff)]
    for i=1,8 do local tt=r+q[i] if (i<5)then tt=tt+((h(m(t,(i-1)*8),255))*0x989680)end x[y[i]]=h(tt,255)r= m(tt,0x8)end
    x[7]=x[7]+16 x[11]=u for i=1,8 do x[i]=o[x[i]]end return ("%s%s%s%s-%s%s-%s%s-%s%s-%s"):format(unpack(x))end