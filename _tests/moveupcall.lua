local locdig = {{},{},{},{}}
local lines = {{},{},{},{},{},{},{},{}}
local numberOfModules = 4
local SSPin = 8

for kk = 1, 4 do
	local di =  string.sub(dat.mnow, kk, kk)
	for i = 1, 8 do
		locdig[kk][i] = dig[di][i]
	end 
end

for i = 1, 8 do
	for ii = 1, 4 do
	  table.insert(lines[i], locdig[ii][i])
	end
end 

function uplines()
	for i = 1, 7 do
		for ii = 1, 4 do
			lines[i][ii] = lines[i+1][ii]
		end
	end
	lines[8] = {0,0,0,0}
end  

local function sendLine (register, data)
	local stp = 1
	gpio.write(SSPin, gpio.LOW)
	while stp <= numberOfModules do
		spi.send(1, bit.lshift(register, 8) + data[stp])
		stp = stp + 1
	end
	gpio.write(SSPin, gpio.HIGH)
end

function disp()
	for i = 1, 8 do
		sendLine(i, lines[i])
	end
end
disp()
step = function()
	uplines()
	disp()
end

local stps = 1
tmr.create():alarm(55, 1, function(t)
	if stps <= 8 then
		stps = stps + 1
		step()
	else
		t:stop()
		t:unregister()
		t = nil
		stps = nil
		dat.mnow = '0000'
		locdig, lines, numberOfModules, SSPin, di, uplines, sendLine, step, disp, step = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		if dat.call then dat.call() end
	end
end)
