if not m or not dat.broker then 
    print('Lost MQTT Broker To Publish!')
else
local count = 0
for _ in pairs(debug.getregistry()) do  count = count + 1 end
wth.reg = count
    wth.heap = node.heap()
    local json = sjson.encode(wth)
    print('json = ', json)
    if json then m:publish(dat.clnt..'/data', json, 2, 0) end
    json = nil
    if dat.boot then dofile('sendboot.lua') end
end