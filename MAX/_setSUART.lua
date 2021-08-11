local pin = dat.PINUART
dat.PINUART = nil
-- baudrate 9600, nil as Tx, pin as Rx
s = softuart.setup(9600, nil, pin)

function  decode(data)
    local t = string.match(data, '{"t":(%d+)}')
    t = tonumber(t)
    if t and t > 0 and t < 120 then
        wth.sauna = t
        print('HC-12: '..wth.sauna)
        if tm then
			local dat = string.format("%04d.%02d.%02d %02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"])
			wth.hc12 =  dat
		end
    end
end

s:on("data", '}', function(data)
    node.task.post(0, function() decode(data) end)
end)