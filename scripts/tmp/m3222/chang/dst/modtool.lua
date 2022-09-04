---
--- @author zsh in 2022/8/29 0:09
---

local KEY = require('m3.chang.dst.key');

local ModTool = {};

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---`[请保证每个模组这个返回值的唯一性！]`返回 guid
---@return string
function ModTool:getModKey()
    return KEY;
end

---本模组的全局变量 `_M`
---@return table
function ModTool:getModGlobal()
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
function ModTool:setModENV(env)
    setmetatable(env, { __index = function(_, k)
        return rawget(_G, k);
    end });
    self:getModGlobal().env = env;
end

function ModTool:getModENV()
    local env = self:getModGlobal().env;
    if (not env) then
        error('env == nil', 2);
    end
    return env;
end

function ModTool:setModinfoConfig(env)
    local config = env.modinfo.configuration_options;
    local _M = self:getModGlobal();
    _M.ModConfig = {};
    for _, option in ipairs(config) do
        if (option.name and option.name ~= '') then
            _M.ModConfig[option.name] = env.GetModConfigData(option.name);
        end
    end
end

function ModTool:getModinfoConfig()
    return self:getModGlobal().ModConfig;
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---设置一个时间间隔，长时间不更新的话，某些内容默认失效
function ModTool:IsOverTime()
    local period = '2022-11-27 23:59:59'; -- 手动更新。。。
    return os.date('%Y-%m-%d %H:%M:%S') > period;
end

local safety_mt = {
    __index = function(t, ...)
        --print('__index >', ...); -- tips: 不必 print
        --local func_data = debug.getinfo(2, 'Sl');
        --print('NOTE', func_data.short_src .. ':' .. func_data.currentline .. ': Return safety!');
        return t;
    end,
    __newindex = function(t, ...)
        print('__newindex >', ...);
        local func_data = debug.getinfo(2, 'Sl');
        print('NOTE', func_data.short_src .. ':' .. func_data.currentline .. ': You cannot update the index!');
    end,
    __call = function(t, ...)
        print('__call >', ...);
        local func_data = debug.getinfo(2, 'Sl');
        print('NOTE', func_data.short_src .. ':' .. func_data.currentline .. ': You might have attempted to call a nil value! Please check it!');
        return nil;
    end
}

local Nsafety; -- 单例模型
-- 等价于 C# 的 ? : 对于表达式 a?.b，当 a 为 nil 时，其结果是 nil 而不会产生异常。
-- 如果 zip = ((((a or S).b or S).c or S).zipcode or S)()，上述访问过程中出现了 nil，安全访问操作符会正确地处理 nil 并返回 nil
---`[弃用]`垃圾函数
---`[安全访问符 a?.b 的 ?]`获得一张可以让你安全访问的表
function ModTool:NormalSafeNavigationOperator()
    Nsafety = Nsafety or setmetatable({}, {
        __newindex = safety_mt.__newindex,
        __call = safety_mt.__call
    });
    return Nsafety;
end

local Fsafety;
---`[弃用]`垃圾函数
---`[只在需要 : 调用函数时使用！]`安全访问符
function ModTool:FuncSafeNavigationOperator()
    Fsafety = Fsafety or setmetatable({}, {
        __index = safety_mt.__index,
        __newindex = safety_mt.__newindex,
        __call = safety_mt.__call
    });
    return Fsafety;
end

---`[弃用]`垃圾函数
function ModTool:getAllSafeOp()
    return self:NormalSafeNavigationOperator(), self:FuncSafeNavigationOperator();
end


--[[do
    -- Test code
    --local S = ModTool:SafeNavigationOperator();
    local F = ModTool:FSafeNavigationOperator();
    F:a();
    return;
end]]

local securityMT = {
    __index = function(t, k)
        return t;
    end,
    __newindex = function(t, k, v)
        -- DoNothing
    end,
    __call = function(t, ...)
        print('__call >', t, ...);
    end
};
-- TODO: inst.components.cmp1.func() --> (inst or S1).components.cmp1.func()，只要中途出现了 nil，则返回 nil
---`[安全使用-点操作符]`
function ModTool:dotSecurity()

end

---`[弃用]`垃圾函数
---`[安全使用-冒号操作符]`保证 (((inst or {}).components or {}).cmp1 or {}):func(...) 这种情况，不会报错。
---但是这很麻烦，所以我明明判空就够了！
---@param t table
---@param funcname string
function ModTool:colonSecurity(t, funcname, arg1, ...)
    if (type(t) ~= 'table' or type(funcname) ~= 'string') then
        return nil;
    end
    if (t and t[funcname]) then
        return t[funcname](t, arg1, ...);
    end
end

local funcS;
---`[弃用]`垃圾函数
function ModTool:funcSecurity()
    funcS = funcS or setmetatable({}, { securityMT.__index, securityMT.__newindex, securityMT.__call });
    return funcS;
end

do

    return ;
end



---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

function ModTool:IsAlreadyUpload()
    local env = ModTool:getModENV();
    local modname = env.modname;
    local Already_Upload = (modname and string.match(modname, 'workshop%-.+')) and true or false;

    if (Already_Upload) then
        return true;
    end
end

return ModTool;