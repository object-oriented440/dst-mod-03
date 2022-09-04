---
--- @author zsh in 2022/8/27 22:54
---

local KEY = require('m3.chang.dst.key');

local Tool = {};

---����һ��ʱ��������ʱ�䲻���µĻ���ĳЩ����Ĭ��ʧЧ
function Tool:IsDstUpdateTime()
    local period = '2022-11-27 23:59:59'; -- �ֶ����¡�����
    return os.date('%Y-%m-%d %H:%M:%S') > period;
end

---[`�뱣֤ÿ��ģ���������ֵ��Ψһ�ԣ�`]���� guid
---@return string
function Tool:getKEY()
    return KEY;
end

---��ģ���ȫ�ֱ���
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