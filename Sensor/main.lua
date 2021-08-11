local cc = coap.Client()
local ip = 'coap://'..dat.IP_SERVER..':5683/v1/f/saunanow'
dat.IP_SERVER = nil

local rtt = rtt -- Забираем в локальную таблицу соответствия тепрератур и
--  уничтожаем ее как глобальную
_G.rtt = nil

------------ Real Temperature --------
local filter = function (t)
	t = tonumber(t)
	local min, max = 0, 200
	
	for k in pairs(rtt) do
		if k <= t and min < k then min = k end
	end
	for k in pairs(rtt) do
		if k > min then
			if k < max then max = k  end
		end
	end
	return rtt[min] + ((rtt[max] - rtt[min]) * ((t - min)/(max - min)))
end
------------------------------------

local worknow = function()
	local ttbl = {} -- таблица для приема температуры от датчка
	local function work()
        ds = nil
        package.loaded["_ds18b20"]=nil
		
		if not ttbl.temp then
			print 'Lost DS18b20'
			return
		else
			print('\nGot Temperature '..ttbl.temp)
		end
		if rtt then
			ttbl.temp = filter(ttbl.temp)
		end
		ttbl.temp = string.format("%d", ttbl.temp)
		print('Real Temperature Is ', ttbl.temp)

		local myip = (wifi.sta.getip()) -- есть wifi?
		if myip then
    		print('Send ' ..ttbl.temp.. ' to '..ip..' \tfrom ip '..myip)
			cc:post(coap.NON, ip, ttbl.temp)
		elseif s then
			print('Lost Wi-Fi!, Write Soft UART')
			local t = '{"t":'..ttbl.temp..'}'
			print('HC-12 Send: '..t)
			s:write(t)
		end
    end
    ds = require('_ds18b20')
    ds.getTemp(ttbl, work)
end

tmr.create():alarm(30000, 1, worknow)
worknow()