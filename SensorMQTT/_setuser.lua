-- Pin DS18b20
dat.pinds = 4

-- IP Address MAX7219
dat.IP_SERVER = '192.168.1.112'


--------- MQTT Settings
dat.MQTT_INTERVAL = 30
dat.brk = '192.168.1.125'
dat.port = 1883
dat.clnt = 'banjasauna'

---- Time Zobe -----
dat.tz = 3

-- Soft Uart: baudrate of 9600, D2 - Tx, D3 - Rx.
-- D3 - nil 
s = softuart.setup(9600, 2, nil)

-------- Set Real Temperature: 
sor = {}
sor[20] = 20
sor[30] = 30
sor[40] = 40
sor[53] = 55
sor[70] = 70
sor[82] = 82
sor[90] = 95
sor[100] = 100
sor[110] = 110
sor[125] = 125
