---
--- @author zsh in 2022/8/28 2:03
---


local env = {
    require = require,
    --print = print
};


--[[
local function RunInEnvironment(fn,fnenv)
    local f = loadfile('','tb',fnenv);
end]]

-- ���� env�������ļ�����ֵ���ǽ��� _ENV����֪����ô�����ֵģ�
local f, msg = loadfile('m3/chang/modules/tmp/t.lua', 'tb', env);

if (not f) then
    print(msg);
else
    f();
end
