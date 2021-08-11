local count = 0
local check, exit
local exitcount = dat.exitcount

exit = function()
	exit, count, check, exitcount = nil, nil, nil, nil
	dispatch()
end

check = function()
	count = count + 1
	if count > exitcount then return exit() end
end

if wth.ds18b20 then
	dat.tikfn = check
	maketemp(wth.ds18b20, 'H')
	node.task.post(0, function() dofile('askds18b20.lua') end)
else
	exit()
end