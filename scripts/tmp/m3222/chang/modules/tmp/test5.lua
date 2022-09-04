---
--- @author zsh in 2022/8/29 3:46
---



--print('hello')

--[[
local r = -3 % 12;
print(r);]]

for i = 0, 127 do
    if (i % 10 == 0) then
        io.write('\n');
    end
    io.write(tostring(i), '\t');
end