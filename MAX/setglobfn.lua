function printdata(data, sep)
	-- print('data, sep', data, sep)
	local izzr
	local prt = {}
	local function copytb(tb, ind)
		for i = 1, 8 do
			tb[i] = dig[ind][i]
		end 
	end
	for i = 1, 4 do
		izzr = string.sub(data, i, i)
		prt[i] = {}
		copytb(prt[i], izzr)
	end
	izzr = nil
	if sep == ":" then 
		if not dat.dotp then
			prt[2][4] = prt[2][4] + 1
			prt[2][6] = prt[2][6] + 1
			dat.dotp = true
		end
		dat.dot1 = prt[2][4]
		dat.dot2 = prt[2][6]
	end
	
	if sep == '.' then 
		prt[3][8] = prt[3][8] + 1 
	end
	max7219.write(prt)
	prt, copytb = nil, nil
end

function maketemp(t, firstSign)
	local sep = string.find(t,"%.") or 0
	local first = string.sub(t, 1, sep -1)
	local second = sep ==  0 and '0' or string.sub(t, sep+1, sep+1) or '0'
	second = second == '' and '0' or second
	if firstSign then first = firstSign..first end
	if #first ~= 4 then first = first..second end
	dat.mnow = first
	first, sep, second = nil, nil ,nil
	if not firstSign or firstSign == 'H' then
		printdata(dat.mnow, '.')
	else
		printdata(dat.mnow)
	end
end

local tik = tmr.create()
tik:alarm(1000, 1, function()
	if dat.tikfn then dat.tikfn() end
end)

-- Listen COAP: 
cs=coap.Server()
cs:listen(5683)

function saunanow(payload)
	print("Got Coap Data:", payload)
	payload = tonumber(payload)
	if payload then 
		wth.sauna = math.floor(payload)
		if tm then
			local dat = string.format("%04d.%02d.%02d %02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"])
			wth.coap =  dat
		end
	end
end
cs:func("saunanow") -- post coap://192.168.18.103:5683/v1/f/sau