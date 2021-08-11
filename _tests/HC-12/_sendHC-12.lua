
-- Create UART with baudrate of 9600, D2 as Tx pin and D3 as Rx pin
s = softuart.setup(9600, 2, nil)
-----------------------------------
testHC_12 = function ()
    local t = math.random(35, 110)
    t = ""..math.floor(t)
    t = '{"t":'..t..'}'
    print('HC-12 Send: '..t)
    s:write(t)
end

tmr.create():alarm(15000, tmr.ALARM_AUTO, testHC_12)