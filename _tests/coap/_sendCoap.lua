IP_SERVER = '192.168.34.105'

-----------------------------------
cc = coap.Client()
ip = 'coap://'..IP_SERVER..':5683/v1/f/steamnow'

testcoap = function ()
    local t = math.random(35, 95)
    t = ""..math.floor(t)
    print('Coap send ', t)
    print('Send to '..ip..' \tfrom ', (wifi.sta.getip()))
    cc:post(coap.NON, ip, t)
end

tmr.create():alarm(30000, tmr.ALARM_AUTO, testcoap)