if file.exists('_max7219.lua') then
    node.compile('_max7219.lua')
    file.remove('_max7219.lua')
end

dat = {}
wth = {}
dig = {}
dofile'_setuser.lua'
node.task.post(0, function() dofile('askds18b20.lua') end)
if dat.clnt then print('MQTT Client:', dat.clnt, 'Broker:', dat.brk); dat.boot = true end

dofile'setglobfn.lua'

max7219 = require('_max7219')
max7219.setup(dat.numMd, dat.SSPin, dat.bright)

local a, b = node.bootreason()
if a == 2 and b ==6 then max7219.clear(); dofile'_startmax.lua' end
if dat.PINUART then dofile'_setSUART.lua' end
if dat.MQTT_INTERVAL then dofile'mqttset.lua' end
node.task.post(0, function() dofile('main.lua') end) 