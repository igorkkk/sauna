do
local subscribe, merror, mconnect, msg
function subscribe(con)
    dat.broker = true
    con:subscribe(dat.clnt.."/com/#", 0)
    con:publish(dat.clnt..'/state', "On", 0, 1)
    print("Subscribed: "..dat.clnt.."/com/#")    
end

function merror(con, reason)
    dat.broker = false
    print('MQTT Error!')
    if con then con:close() end
    if m then m:close() end
    con, reason, m, ct = nil,nil,nil,nil
    tmr.create():alarm(10000, tmr.ALARM_SINGLE, mconnect)
    return collectgarbage()
end
function msg(con, top, dt)
	if not killtop then killtop = {} end
    top = string.match(top, "/(%w+)$")
    print('Got', top, dt)
    if top and dt then
        table.insert(killtop, {top, dt})
        if not dat.analiz then
            node.task.post(0, function() dofile('mqttanalize.lua') end)
        end
    end
end
function mconnect(t)
    t = nil
    if (wifi.sta.getip()) then
        return dofile('mqttmake.lua')(subscribe, merror, msg)
    else
        return merror()
    end
end
mconnect()
end