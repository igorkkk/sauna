do
    local min, max, result = 0, 200, 0
    local rtt = {}
    local filter
    rtt[20] = 20
    -- rtt[30] = 30
    -- rtt[40] = 48
    -- rtt[53] = 55
    -- rtt[70] = 70
    -- rtt[82] = 82
    -- rtt[90] = 95
    -- rtt[100] = 100
    rtt[110] = 115

    filter = function (t)
        for k in pairs(rtt) do
            if k <= t and min < k then min = k end
        end
        for k in pairs(rtt) do
            if k > min then
                if k < max then max = k  end
            end
        end
        return rtt[min] + ((rtt[max] - rtt[min]) * ((t - min)/(max - min)))
    end

    
    local t = 55
    filter(t)
end