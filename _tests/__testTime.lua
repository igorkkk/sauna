do
    local sntpp = sntp
    local gottime, losttimeserver
    local tz = 3
    gottime = function(a, b, c, d)
        print('\n\nNow Got Time!')
        print(a,b,c)
        table.foreach(d, print)
        print('\n\n')
        local tm = rtctime.epoch2cal(rtctime.get()+tz*60*60)
        if not tm or not tm["year"] or tm["year"] == 1970 then 
            print('Wrong time to send boot reason!') 
        else
            print(string.format("%04d.%02d.%02d %02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"]))
        end
    end

    losttimeserver = function()
        print('\n\nLost NTP Server!\n\n')
    end
    sntpp.sync(nil, gottime, losttimeserver, true)
    -- sntp.sync(nil, nil, nil, true)
end