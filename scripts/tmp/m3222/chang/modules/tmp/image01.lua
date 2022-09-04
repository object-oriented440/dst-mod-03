---
--- @author zsh in 2022/9/1 19:25
---


--[[
local filename = 'm3/chang/modules/tmp/image/img.png';

local f = assert(io.open(filename));

local str = f:read('*l');

print(type(str));


print(str);]]

print('A'>'a');
