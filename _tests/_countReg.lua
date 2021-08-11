do
local count = 0
for _ in pairs(debug.getregistry()) do count = count + 1 end
print('\n\ncount = '..count..' Heap = '..node.heap())
end