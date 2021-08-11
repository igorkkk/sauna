local runfile = "_sendCoap.lua"

if rtcmem.read32(0) == 501 then
	print("Try Start Server!")
	rtcmem.write32(0, 0)
	if file.exists('ide.lua') then
		dofile("ide.lua")
	else
		print('No IDE, Restart!')
	end

else
	sntp.sync()
	print("Try Run ", runfile)
	tmr.create():alarm(1000, 0, function()
		if runfile and file.exists(runfile) then
			dofile(runfile)
		else
			print("No runfile! Start IDE")
			if file.exists('ide.lua') then
				rtcmem.write32(0, 501)
				node.restart()
			else
				print('Stop, No IDE!')
			end
		end
	end)
end