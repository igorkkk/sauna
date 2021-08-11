if not tm or not tm["year"] or tm["year"] == 1970 then print('Wrong time to send boot reason!'); return end
do
    local a, b = node.bootreason()
    print('boot a, b', a, b)
    local atb = {'power-on', 'reset', 'reset pin', 'WDT reset'}
    local btb = {'power-on', 'hard WDT', 'exception', 'soft WDT', 'soft restart', 'WFDS', 'ext'}
    a = atb[a] or 'lost'
    b = btb[b] or 'lost'
    m:publish(dat.clnt..'/boot', a..' : '..b..' at '..string.format("%04d.%02d.%02d %02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"]),0,1)
    dat.boot = nil
    print('Boot Reason Sent! '..a..' : '..b)
    a, b, atb, btb = nil, nil, nil, nil
end