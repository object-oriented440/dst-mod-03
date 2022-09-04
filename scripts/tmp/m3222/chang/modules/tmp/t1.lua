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

-- 传入 env，但是文件的上值还是叫做 _ENV，不知道怎么改名字的！
local f, msg = loadfile('m3/chang/modules/tmp/t.lua', 'tb', env);

if (not f) then
    print(msg);
else
    f();
end
