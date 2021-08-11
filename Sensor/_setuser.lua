-- Pin DS18b20
dat.pinds = 4

-- IP Address MAX7219
dat.IP_SERVER = '192.168.1.112'

-- Soft Uart: baudrate of 9600, D2 - Tx, D3 - Rx.
-- D3 - nil 
s = softuart.setup(9600, 2, nil)

--- set Real Temperature Table:

rtt = {}
rtt[20] = 15
rtt[30] = 29
rtt[40] = 48
rtt[53] = 55
rtt[70] = 70
rtt[82] = 82
rtt[90] = 95
rtt[100] = 100
rtt[110] = 110
