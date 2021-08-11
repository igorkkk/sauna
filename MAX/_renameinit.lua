if file.exists("init.lua") then
    file.rename("init.lua","__init.lua")
    node.restart()
elseif file.exists("__init.lua") then
    print("Make autostart! \n 15 sec!")
    tmr.create():alarm(15000, 0, function()
        file.rename("__init.lua","init.lua")
        node.restart()
    end)
end