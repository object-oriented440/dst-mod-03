---
--- @author zsh in 2022/9/3 21:11
---

-- 导入部分
local KEY = require('chang_m3.dst.key');

-- 模块初始化
local ModTool = {};
local self = ModTool;

---`[请保证每个模组这个返回值的唯一性！]`返回 guid
---@return string
function ModTool.getModKey()
    return KEY;
end

---本模组的全局变量 `_M`
---@return table
function ModTool.getModGlobal()
    local g = rawget(_G, KEY);
    if (g) then
        return g;
    else
        global(KEY); -- NOTE: 我需要去验证一下，在 modmain.lua 里 require 的模块的上值是不是仍然是 _G
        _G[KEY] = {};
        return _G[KEY];
    end
end

---`[在 modmain.lua 最开始的位置执行]`设置了 _M、_M`[KEY]`、_M`[KEY]`.env
function ModTool.setModENV(env)
    setmetatable(env, { __index = function(_, k)
        return rawget(_G, k);
    end });
    self.getModGlobal().env = env;
end

function ModTool.getModENV()
    local env = self.getModGlobal().env;
    if (not env) then
        error('env == nil', 2);
    end
    return env;
end

function ModTool.setModinfoConfig(env)
    local config = env.modinfo.configuration_options;
    local _M = self.getModGlobal();
    _M.ModConfig = {};
    for _, option in ipairs(config) do
        if (option.name and option.name ~= '') then
            _M.ModConfig[option.name] = env.GetModConfigData(option.name);
        end
    end
end

function ModTool.getModinfoConfig()
    return self.getModGlobal().ModConfig;
end

---设置一个时间间隔，长时间不更新的话，某些内容默认失效
function ModTool.IsOverTime()
    local period = '2022-11-27 23:59:59'; -- 手动更新。。。
    return os.date('%Y-%m-%d %H:%M:%S') > period;
end

---判断是否已经发布到创意工坊
function ModTool.IsAlreadyUpload()
    local env = self.getModENV();
    local modname = env.modname;
    local Already_Upload = (modname and string.match(modname, 'workshop%-.+')) and true or false;

    if (Already_Upload) then
        return true;
    end
end
-------------------------------------------------------------------------------------------------
-- [[ 弃用 ]]
-------------------------------------------------------------------------------------------------


return ModTool;