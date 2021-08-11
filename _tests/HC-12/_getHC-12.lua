-- UART: baudrate of 9600, D2 - Tx, D3 - Rx
s = softuart.setup(9600, nil, 3)
wth = {}

function  decode(data)
    print('Last t:', wth.banja)
    local t = string.match(data, '{"t":(%d+)}')
    t = tonumber(t)
    if t and t > 0 and t < 120 then
        wth.banja = t or 0
    end
    print('New t:', wth.banja)
end

s:on("data", '}', function(data)
    print('Got From HC-12: '..data)
    node.task.post(0, function() decode(data) end)
end)