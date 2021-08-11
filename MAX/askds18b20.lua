if not dat.pinds then return end
do
    local function work()
        ds = nil
        package.loaded["_ds18b20"]=nil
    end

    ds = require('_ds18b20')
    ds.getTemp(nil, work)
end