---
--- @author zsh in 2022/8/28 2:06
---


-- require 的模块的环境算是独立的！
local Debug = require('m3.chang.modules.utils.Debug');

local Table = require('m3.chang.modules.utils.Table');
local Math = require('m3.chang.modules.utils.Math');




--[[
Table:print(_ENV);
print(getmetatable(_G));

print(print)]]

--print('{' .. string.match('  aaaaa c ac   ', "^%s*(.*%S)") .. '}')

local a = '';
print(a.workshop); -- nil
for i, v in ipairs(a) do -- 所以字符串也算是个表，只不过，我们默认 string 和其他一样！
    print(1)
end


