local runfile = 'setglobals.lua'
print("Try Run ", runfile)
if runfile and file.exists(runfile) then
	dofile(runfile)
else
	print('Lost runfile!')
end
