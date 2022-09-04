---
--- @author zsh in 2022/8/26 23:58
--- modworldgenmain.lua 比 modmain.lua 提前加载

do
    -- Test code
    return ;
end

if (env == nil) then
    return ;
else
    GLOBAL.setmetatable(env, { __index = function(_, k)
        return GLOBAL.rawget(GLOBAL, k);
    end });
end

local Date = require('m3.chang.modules.utils.Date');

local filename = env.MODROOT .. 'log.txt';
local f, msg = io.open(filename, 'a');

if (not f) then
    print('ERROR!!!', msg);
else
    f:write('hello!modworldgenmain.lua\n');
    f:write('current time: [ ', Date:getCurrentTime(), ' ]\n');
    f:close();
end