--------- Time Zone
dat.tz = 3
--------- Clock Brightness (0 - 15)
dat.bright = 3

--------- Time to Show Data at Clock (sec)
dat.SHOW_TIME = 10 --  0 if not wifi
dat.SHOW_SAUNA = 7

---------- DS18b20 Pin and Show time
dat.pinds = 4
dat.SHOW_DS = 4 -- 0 if not ds18b20

--------- MQTT Settings
dat.MQTT_INTERVAL = 30
dat.brk = '192.168.1.125'
dat.port = 1883
dat.clnt = 'banjaclock'

--------- HC-12 RX Pin
dat.PINUART = 3

--------- MAX7219 modules and SS Pin
dat.numMd = 4
dat.SSPin = 8

--------- Font

dig['1'] = {0,16,48,16,16,16,16,56}
dig['2'] = {0,56,68,4,56,64,64,124}
dig['3'] = {0,124,4,8,24,4,68,56}
dig['4'] = {0,8,24,40,72,124,8,8}
dig['5'] = {0,124,64,120,4,4,68,56}
dig['6'] = {0,28,32,64,120,68,68,56}
dig['7'] = {0,124,4,4,8,16,32,64}
dig['8'] = {0,56,68,68,56,68,68,56}
dig['9'] = {0,56,68,68,60,4,8,112}
dig['0'] = {0,56,68,76,84,100,68,56}
dig['+'] = {0,0,4,4,31,4,4,0}
dig['-'] = {0,0,0,0,124,0,0,0} 
dig['z'] = {0,0,0,0,0,0,0,0}
dig['R'] = {0,0,4,2,127,2,4,0}
dig['H'] = {0x18,0x24,0x42,0xc3,0x5a,0x5a,0x42,0x7e}
dig['y'] = {0x00,0x6c,0x92,0x82,0x82,0x44,0x28,0x10} -- heart