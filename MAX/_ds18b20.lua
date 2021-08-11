local M={}
M.adrtbl = {}
M.pin = 4
M.del = 750
M.ttable = {}

function M.getaddrs()
    ow.setup(M.pin)
    ow.reset_search(M.pin)
    repeat
        local adr = ow.search(M.pin)
        if(adr ~= nil) then
            table.insert(M.adrtbl, adr)
        end
    until (adr == nil)
    ow.reset_search(M.pin)
	if #M.adrtbl ~= 0 then
		M.askTemp()
	else
		print('No DS18b20!')
        if M.call then M.call() end
		return
	end
end

function M.askTemp()
	ow.setup(M.pin)
    for _, v in pairs(M.adrtbl) do
        ow.reset(M.pin)
        ow.select(M.pin, v)
        ow.write(M.pin, 0x44, 1)
    end
    v = nil

	tmr.create():alarm(M.del, tmr.ALARM_SINGLE, function (t) 
		t = nil
		M.readResult()
	end)
end

function M.readResult()    
    local data, crc, t
    for _, v in pairs(M.adrtbl) do
        ow.reset(M.pin)
        ow.select(M.pin, v)
        ow.write(M.pin,0xBE,1)
        data = ow.read_bytes(M.pin, 9)
		crc = ow.crc8(string.sub(data,1,8))
        if (crc == data:byte(9)) then
            t = (data:byte(1) + data:byte(2) * 256)
            if (t > 32767) then t = t - 65536 end
            t = t * 625 /10000
            --table.insert(M.ttable, t)
            wth.ds18b20 = string.format("%.1f",t)
            -------
			-- local as = ""
            -- for ii = 1, #v do
            --     local hx = string.format("%02X", (string.byte(v, ii)))
            --     as = as ..hx
            -- end
            
            -- M.ttable[as] = t
            -- M.ttable[as] = string.format("%.2f",t)
			-- table.insert(M.ttable, {as, string.format("%.2f",t)})

			-------
		end
    end
	data, crc, t = nil, nil, nil
	if M.call then M.call(M.ttable) end
end

function M.getTemp(ttable, call, pin, del)
	if #M.adrtbl == 0 then
		M.pin = pin or M.pin
		M.del = del or M.del
        M.ttable = ttable or M.ttable
        if call then M.call = call end
		M.getaddrs(ttable, call)
	else
		M.askTemp()
	end
end
return M