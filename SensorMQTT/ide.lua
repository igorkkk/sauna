local function r(e)
local d=e==nil and true or e
srv=net.createServer(net.TCP)
srv:listen(80,function(r)
local s=0
local a=0
local o=0
local h=""
local t=""
local i=""
r:on("receive",function(n,e)
if a==0 then
_,_,h,t,i=string.find(e,"([A-Z]+) /([^?]*)%??(.*) HTTP")
end
if h=="POST"then
if a==0 then
_,_,o,e=string.find(e,"Content%-Length: (%d+)(.+)")
if o then
o=tonumber(o)
s=1
a=1
else
print("bad length")
end
end
if a==1 then
local i=string.len(e)
local n="\r\n\r\n"
local o
for o=1,i do
if string.byte(n,s)==string.byte(e,o)then
s=s+1
if s==5 then
e=string.sub(e,o+1,i)
file.open(t,"w")
file.close()
a=2
break
end
else
s=1
end
end
if a==1 then
return
end
end
if a==2 then
if e then
o=o-string.len(e)
file.open(t,"a+")
file.write(e)
file.close()
else
n:send("HTTP/1.1 200 OK\r\n\r\nERROR")
a=0
end
if o==0 then
n:send("HTTP/1.1 200 OK\r\n\r\nOK")
a=0
end
end
return
end
o=-1
if t=="favicon.ico"then
n:send("HTTP/1.1 404 file not found")
return
end
local e="HTTP/1.1 200 OK\r\n\r\n"
if t~=""and i==""then
o=0
n:send(e)
return
end
e=e.."<html><body><h1><a href='/'>NodeMCU IDE</a></h1>"
if i=="edit"then
if d then
local a='ace/mode/'
if t:match(".css")then a=a..'css'
elseif t:match(".html")then a=a..'html'
elseif t:match(".json")then a=a..'json'
elseif t:match(".js")then a=a..'javascript'
else a=a..'lua'
end
e=e.."<style type='text/css'>#editor{width: 100%; height: 80%}</style><div id='editor'></div><script src='//rawgit.com/ajaxorg/ace-builds/master/src-min-noconflict/ace.js'></script>"
.."<script>var e=ace.edit('editor');e.setTheme('ace/theme/monokai');e.getSession().setMode('"..a.."');function getSource(){return e.getValue();};function setSource(s){e.setValue(s);}</script>"
else
e=e.."<textarea name=t cols=79 rows=17></textarea></br>"
.."<script>function getSource() {return document.getElementsByName('t')[0].value;};function setSource(s) {document.getElementsByName('t')[0].value = s;};</script>"
end
e=e.."<script>function tag(c){document.getElementsByTagName('w')[0].innerHTML=c};var x=new XMLHttpRequest();x.onreadystatechange=function(){if(x.readyState==4) setSource(x.responseText);};"
.."x.open('GET',location.pathname);x.send()</script><button onclick=\"tag('Saving, wait!');x.open('POST',location.pathname);x.onreadystatechange=function(){console.log(x.readyState);"
.."if(x.readyState==4) tag(x.responseText);};x.send(new Blob([getSource()],{type:'text/plain'}));\">Save</button> <a href='?run'>run</a> <w></w>"
elseif i=="run"then
e=e.."<verbatim>"
function s_output(t)e=e..t end
node.output(s_output,0)
local a,t=pcall(dofile,t)
tmr.alarm(0,1000,tmr.ALARM_SINGLE,function()
node.output(nil)
if t then
local a=tostring(t):sub(1,1300)
t=nil
e=e.."<br>Result of the run: "..a.."<br>"
end
e=e.."</verbatim></body></html>"
n:send(e)
end)
return
elseif i=="compile"then
collectgarbage()
node.compile(t)
t=""
elseif i=="delete"then
file.remove(t)
t=""
elseif i=="restart"then
node.restart()
return
end
local a={}
a[#a+1]=e
e=nil
if t==""then
local e=file.list();
a[#a+1]="<table border=1 cellpadding=3><tr><th>Name</th><th>Size</th><th>Edit</th><th>Compile</th><th>Delete</th></tr>"
for e,t in pairs(e)do
local t="<tr><td><a href='"..e.."'>"..e.."</a></td><td>"..t.."</td><td>"
local o=e:sub(-4,-1)==".lua"or e:sub(-4,-1)==".css"or e:sub(-5,-1)==".html"or e:sub(-5,-1)==".json"
if o then
t=t.."<a href='"..e.."?edit'>edit</a>"
end
t=t.."</td><td>"
if e:sub(-4,-1)==".lua"then
t=t.."<a href='"..e.."?compile'>compile</a>"
end
t=t.."</td><td><a href='"..e.."?delete'>delete</a></td></tr>"
a[#a+1]=t
end
a[#a+1]="</table><a href='#' onclick='v=prompt(\"Filename\");if (v!=null) { this.href=\"/\"+v+\"?edit\"; return true;} else return false;'>Create new</a> &nbsp; &nbsp; "
a[#a+1]="<a href='#' onclick='var x=new XMLHttpRequest();x.open(\"GET\",\"/?restart\");x.send();setTimeout(function(){location.href=\"/\"},5000);this.innerText=\"Please wait\";return false'>Restart</a>"
end
a[#a+1]="</body></html>"
local function e(e)
if#a>0 then
e:send(table.remove(a,1))
else
e:close()
a=nil
end
end
n:on("sent",e)
e(n)
end)
r:on("sent",function(e)
if o>=0 and h=="GET"then
if file.open(t,"r")then
file.seek("set",o)
local t=512
local a=file.read(t)
file.close()
if a then
e:send(a)
o=o+t
if string.len(a)==t then return end
end
end
end
e:close()
e=nil
end)
end)
end
if wifi.sta.status()==wifi.STA_GOTIP then
reboottmr=tmr.create()
reboottmr:alarm(600000,0,function()node.restart()end)
print("http://"..wifi.sta.getip().."/")
print('Starts Reboot Timer: reboottmr. Reboot at 10 min')
r()
else
print("WiFi connecting...")
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,function()
wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
print("http://"..wifi.sta.getip().."/")
r()
end)
end