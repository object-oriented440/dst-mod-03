---
--- @author zsh in 2022/8/28 2:06
---


-- require ��ģ��Ļ������Ƕ����ģ�
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
for i, v in ipairs(a) do -- �����ַ���Ҳ���Ǹ���ֻ����������Ĭ�� string ������һ����
    print(1)
end


