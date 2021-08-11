local cc = coap.Client()
local ip = 'coap://'..dat.IP_SERVER..':5683/v1/f/saunanow'

if not dat.IP_SERVER then
	cc, ip = nil, nil
else
	dat.IP_SERVER = nil
end

local sor = sor
_G.sor = nil

------------ Real Temperature ---------------
local filter = function (t)
	t = tonumber(t)
	local min, max, result = 0, 200, 0
	
	for k in pairs(sor) do
		if k <= t and min < k then min = k end
	end
	for k in pairs(sor) do
		if k > min then
			if k < max then max = k  end
		end
	end
	result = sor[min] + ((sor[max] - sor[min]) * ((t - min)/(max - min)))
	return string.format("%d", result)
end
------------------------------------


local worknow = function()
	local function work()
        ds = nil
        package.loaded["_ds18b20"]=nil
		
		if not wth.temp then
			print 'Lost DS18b20'
			return dofile('mqttpub.lua')
		else
			print('\nGot Temperature '..wth.temp)
		end
		wth.temp = filter(wth.temp)
		print('Real Temperature Is ', wth.temp)

		local myip = (wifi.sta.getip())
		if cc and wth.temp and myip then
    		print('Send ' ..wth.temp.. ' to '..ip..' \tfrom ip '..myip)
			cc:post(coap.NON, ip, wth.temp)
		elseif s then
			print('Lost Wi-Fi!, Write Soft UART')
			local t = '{"t":'..wth.temp..'}'
			print('HC-12 Send: '..t)
			s:write(t)
		end
		node.task.post(0, function() dofile('mqttpub.lua') end)
    end
    ds = require('_ds18b20')
    ds.getTemp(wth, work)
end

tmr.create():alarm(30000, 1, worknow)
worknow()