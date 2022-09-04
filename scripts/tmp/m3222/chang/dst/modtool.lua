---
--- @author zsh in 2022/8/29 0:09
---

local KEY = require('m3.chang.dst.key');

local ModTool = {};

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---`[�뱣֤ÿ��ģ���������ֵ��Ψһ�ԣ�]`���� guid
---@return string
function ModTool:getModKey()
    return KEY;
end

---��ģ���ȫ�ֱ��� `_M`
---@return table
function ModTool:getModGlobal()
    local g = rawget(_G, KEY);
    if (g) then
        return g;
    else
        global(KEY); -- NOTE: ����Ҫȥ��֤һ�£��� modmain.lua �� require ��ģ�����ֵ�ǲ�����Ȼ�� _G
        _G[KEY] = {};
        return _G[KEY];
    end
end

---`[�� modmain.lua �ʼ��λ��ִ��]`������ _M��_M`[KEY]`��_M`[KEY]`.env
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

---����һ��ʱ��������ʱ�䲻���µĻ���ĳЩ����Ĭ��ʧЧ
function ModTool:IsOverTime()
    local period = '2022-11-27 23:59:59'; -- �ֶ����¡�����
    return os.date('%Y-%m-%d %H:%M:%S') > period;
end

local safety_mt = {
    __index = function(t, ...)
        --print('__index >', ...); -- tips: ���� print
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

local Nsafety; -- ����ģ��
-- �ȼ��� C# �� ? : ���ڱ��ʽ a?.b���� a Ϊ nil ʱ�������� nil ����������쳣��
-- ��� zip = ((((a or S).b or S).c or S).zipcode or S)()���������ʹ����г����� nil����ȫ���ʲ���������ȷ�ش��� nil ������ nil
---`[����]`��������
---`[��ȫ���ʷ� a?.b �� ?]`���һ�ſ������㰲ȫ���ʵı�
function ModTool:NormalSafeNavigationOperator()
    Nsafety = Nsafety or setmetatable({}, {
        __newindex = safety_mt.__newindex,
        __call = safety_mt.__call
    });
    return Nsafety;
end

local Fsafety;
---`[����]`��������
---`[ֻ����Ҫ : ���ú���ʱʹ�ã�]`��ȫ���ʷ�
function ModTool:FuncSafeNavigationOperator()
    Fsafety = Fsafety or setmetatable({}, {
        __index = safety_mt.__index,
        __newindex = safety_mt.__newindex,
        __call = safety_mt.__call
    });
    return Fsafety;
end

---`[����]`��������
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
-- TODO: inst.components.cmp1.func() --> (inst or S1).components.cmp1.func()��ֻҪ��;������ nil���򷵻� nil
---`[��ȫʹ��-�������]`
function ModTool:dotSecurity()

end

---`[����]`��������
---`[��ȫʹ��-ð�Ų�����]`��֤ (((inst or {}).components or {}).cmp1 or {}):func(...) ������������ᱨ��
---��������鷳�������������пվ͹��ˣ�
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
---`[����]`��������
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