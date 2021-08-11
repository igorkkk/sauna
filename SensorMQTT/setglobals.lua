dat = {}
dat.boot = true
wth = {}
dofile'_setuser.lua'
dofile'mqttset.lua'
sntp.sync(nil, nil, nil, true)
node.task.post(0, function() dofile('main.lua') end)