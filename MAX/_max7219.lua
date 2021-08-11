local M = {}
local nOfM = 4
local SSPin = 8
local DECOD = 0x09
local INTENS = 0x0A
local SCAN = 0x0B
local SHUT = 0x0C
local DIST = 0x0F

local function sByte(modul, register, data)
	local dt
	local step = 1
	gpio.write(SSPin, gpio.LOW)
	while step <= nOfM do
		dt = step == modul and (bit.lshift(register, 8) + data) or 0
		spi.send(1, dt)
		step = step + 1
	end
	gpio.write(SSPin, gpio.HIGH)
	step, dt = nil, nil
end

function M.setup(nofm, sspin, intensity)
	nOfM = nofm or nOfM
	SSPin = sspin or SSPin
	intensity = intensity or 3
	spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 16, 8)
	gpio.mode(SSPin, gpio.OUTPUT)
	gpio.write(SSPin, gpio.HIGH)
	for i = 1, nOfM do
	  sByte(i, SCAN, 7)
	  sByte(i, DECOD, 0x00)
	  sByte(i, DIST, 0)
	  sByte(i, INTENS, intensity)
	  sByte(i, SHUT, 1)
	end
end

function M.setIntensity(intensity)
  for i = 1, nOfM do
    sByte(i, INTENS, intensity)
  end
end

function M.clear()
  for i = 1, nOfM do
		for ii = 1, 8 do
			sByte(i, ii, 0)
		end
   end
end

-- function M.shutdown(sd)
--   local sdRg = sd and 0 or 1
--   for i = 1, nOfM do
--     sByte(i, SHUT, sdRg)
--   end
--   sdRg = nil
-- end

function M.write(chars)
	local step = 1
	for l = 1, 8 do
		gpio.write(SSPin, gpio.LOW)
		while step <= nOfM do
			spi.send(1, bit.lshift(l, 8) + chars[step][l])
			step = step + 1
		end
		gpio.write(SSPin, gpio.HIGH)
		step = 1
	end
	step = nil
end

M.sb = sByte
return M