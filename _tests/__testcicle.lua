-- do
--     enddig = 10000
--     for i = 1, enddig do
--         print(i)
--         --i = i + 1
--     end
-- end

do
    local crasy
    local enddig = 10000
    local start = 1
    crasy = function ()
        print(start)
        start = start + 1
        if start <= enddig then
            node.task.post(0, function() crasy() end)
        end
    end
    crasy()
end