return function(subscribe, merror, msg)
    m = mqtt.Client(dat.clnt, 25, dat.clnt, 'pass22')
    m:lwt(dat.clnt..'/state', "Off", 0, 1)
    m:on("offline", merror)
    m:on("message", msg)
    print('Connect to', dat.brk)
    m:connect(dat.brk, dat.port, false, subscribe, merror)
end