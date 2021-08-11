local sendLine, st
local numMd = dat.numMd
local SSPin = dat.SSPin
local mdig = {}
mdig[1]={0x0e,0x12,0x12,0x12,0x12,0x12,0x3f,0x00}
mdig[2]={0x00,0x94,0x96,0x95,0x74,0x14,0x64,0x00}
mdig[3]={0x00,0x4e,0xd2,0x52,0x5e,0x52,0x52,0x00}
mdig[4]={0x00,0x98,0xa4,0xa4,0xe4,0xa4,0x98,0x00}
local lines = {{},{},{},{},{},{},{},{}}
for i = 1, 8 do
	for ii = 1, 4 do table.insert(lines[i], mdig[ii][i]) end
end
sendLine = function (register, data)
	st = 1
	gpio.write(SSPin, gpio.LOW)
	while st <= numMd do
		spi.send(1, bit.lshift(register, 8) + data[st])
		st = st + 1
	end
	gpio.write(SSPin, gpio.HIGH)
end
for i = 1, 8 do
	sendLine(i, lines[i])
end