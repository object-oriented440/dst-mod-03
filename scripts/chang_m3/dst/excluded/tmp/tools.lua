---
--- @author zsh in 2022/8/27 22:54
---

local KEY = require('m3.chang.dst.key');

local Tool = {};

---设置一个时间间隔，长时间不更新的话，某些内容默认失效
function Tool:IsDstUpdateTime()
    local period = '2022-11-27 23:59:59'; -- 手动更新。。。
    return os.date('%Y-%m-%d %H:%M:%S') > period;
end

---[`请保证每个模组这个返回值的唯一性！`]返回 guid
---@return string
function Tool:getKEY()
    return KEY;
end

---本模组的全局变量
---@return table
function Tool:getModGlobal()
    local g = rawget(_G, KEY);
    if (g) then
        return g;
    else
        global(KEY);
        _G[KEY] = {};
        return _G[KEY];
    end
end

return Tool;