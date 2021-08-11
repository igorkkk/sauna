if not dat then dat = {} end
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

local function leftlines()
local bt = 0
for x = 1, 8 do
  bt = 0
  for i = 4, 1, -1 do
      lines[x][i] = bit.lshift(lines[x][i], 1) + bt
	  bt = lines[x][i] > 255 and 1 or 0
	  lines[x][i] = bit.band(lines[x][i], 0xFF)
  end
end  
end

local function sendLine (register, data)
	local step = 1
	gpio.write(SSPin, gpio.LOW)
	while step <= numberOfModules do
		spi.send(1, bit.lshift(register, 8) + data[step])
		step = step + 1
	end
	gpio.write(SSPin, gpio.HIGH)
end

local function disp()
	for i = 1, 8 do
		sendLine(i, lines[i])
	end
end
disp()
local step = function()
	leftlines()
	disp()
end

local stps = 1

while stps <= 31 do
	stps = stps + 1
	step()
end
if dat.call then dat.call() end