makedispatch = function ()
    local count = 1
    local comtb = {}
    
    if dat.SHOW_TIME then table.insert(comtb, {'prtTime.lua', dat.SHOW_TIME} ) end
    if dat.SHOW_SAUNA then table.insert(comtb, {'prtSauna.lua', dat.SHOW_SAUNA}) end
    if dat.SHOW_DS then table.insert(comtb, {'prtDS.lua', dat.SHOW_DS}) end

    return function()
        collectgarbage()
        node.task.post(0, function() dat.exitcount = comtb[count][2]; dofile(comtb[count][1]) end)
        count = (count == #comtb) and 1 or (count + 1)
    end
end
dispatch = makedispatch()
makedispatch = nil
dispatch()