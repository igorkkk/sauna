node.task.post(0, function() dofile('mqttpub.lua')  end)
local exit, gettime, sh, sm
local count = 0
local exitcount = dat.exitcount
exit = function()
	exit, gettime, sh, sm, count, exitcount = nil, nil, nil, nil, nil, nil
	dispatch()
end

gettime = function()
	count = count + 1
	if count >= exitcount then return exit() end

	tm = rtctime.epoch2cal(rtctime.get()+dat.tz*60*60)
	if tm['year']==1970 then return exit() end
	sh = ''..tm.hour
	sm = ''..tm.min
	if #sh == 1 then sh = '0'.. sh end
	if #sm == 1 then sm = '0'.. sm end
	dat.lasttime = sh..sm
	if dat.mnow == dat.lasttime then
		if dat.dotp then
			dat.dotp = false
			dat.dot1 = bit.clear(dat.dot1, 0)
			dat.dot2 = bit.clear(dat.dot2, 0)
		else
			dat.dotp = true
			dat.dot1 = bit.set(dat.dot1, 0)
			dat.dot2 = bit.set(dat.dot2, 0)
		end
		max7219.sb(2,4,dat.dot1)
		max7219.sb(2,6,dat.dot2)
		return
	else
		dat.mnow = dat.lasttime
		printdata(dat.lasttime, ':')
	end
end

dat.mnow = '0000'
dat.dotp = false
dat.tikfn = gettime