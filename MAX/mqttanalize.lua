if #killtop ~= 0 then
    local restart =  function()
	    rtcmem.write32(0, 501)
	    m:publish(dat.clnt..'/ip', (wifi.sta.getip()), 0, 1)
	    tmr.create():alarm(2000, 0, function() node.restart() end)
    end

	local com = table.remove(killtop)
	local top = com[1]
	local dt = com[2]
	if top and dt then
		if top == 'ide' and dt == 'On' 	then restart()
		elseif top == 'bright' and tonumber(dt) then dat.bright = tonumber(dt)%16; max7219.setIntensity(dat.bright) 
		elseif top == 'out' and tonumber(dt) then wth.out = math.floor(tonumber(dt))
		end
		node.task.post(0, function() dofile('mqttpub.lua') end)
	end
	com, top, dt, restart = nil, nil, nil, nil
end