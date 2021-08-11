local bn = tonumber(wth.sauna)
if not bn then print('Lost Temp At Sauna') end
local exitcount = dat.exitcount
local prtb, exit, now, check
local count = 0
exit = function()
	prtb, exit, now, check, count = nil, nil, nil, nil, nil
	dispatch()
end

prtb = function()
	count = count + 1
	now = ''..wth.sauna
	if #now==2 then now = 'y+'..now 
	elseif #now==3 then now = 'y'..now
	end
	printdata(now)
end

check = function(t)
	bn = tonumber(wth.sauna)
	if bn < 20 or count > dat.SHOW_SAUNA then exit() else prtb() end
end

if not bn or bn > 120 or bn < 0 then return exit() end
dat.tikfn = check
prtb()