---
--- @author zsh in 2022/9/3 21:11
---

-- ���벿��
local KEY = require('chang_m3.dst.key');

-- ģ���ʼ��
local ModTool = {};
local self = ModTool;

---`[�뱣֤ÿ��ģ���������ֵ��Ψһ�ԣ�]`���� guid
---@return string
function ModTool.getModKey()
    return KEY;
end

---��ģ���ȫ�ֱ��� `_M`
---@return table
function ModTool.getModGlobal()
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

---����һ��ʱ��������ʱ�䲻���µĻ���ĳЩ����Ĭ��ʧЧ
function ModTool.IsOverTime()
    local period = '2022-11-27 23:59:59'; -- �ֶ����¡�����
    return os.date('%Y-%m-%d %H:%M:%S') > period;
end

---�ж��Ƿ��Ѿ����������⹤��
function ModTool.IsAlreadyUpload()
    local env = self.getModENV();
    local modname = env.modname;
    local Already_Upload = (modname and string.match(modname, 'workshop%-.+')) and true or false;

    if (Already_Upload) then
        return true;
    end
end
-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------


return ModTool;