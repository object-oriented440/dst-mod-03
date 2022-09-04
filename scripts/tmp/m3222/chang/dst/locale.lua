---
--- @author zsh in 2022/8/26 23:31
---

local Tool = require('m3.chang.dst.modtool');
local KEY = Tool:getModKey();

local Lang = true;
local function fn()
    local locale = LOC.GetLocaleCode();
    Lang = (locale == 'zh' or locale == 'zht' or locale == 'zhr') and true or false;
end
pcall(fn);

local function L(ch, en)
    return Lang and tostring(ch) or tostring(en);
end

local Locale = {};

---@return boolean
function Locale:getLoc()
    return Lang;
end

---@return fun(ch:string,en:string):string
function Locale:getLocFn()
    return L;
end

---@param text string
---@return ModText
function Locale:setModText(text)
    if (type(text) ~= 'table') then
        return ;
    end
    local _M = Tool:getModGlobal();
    _M.TEXT = text;
    return _M.TEXT;
end

---��ģ�������ı�
---@return ModText
function Locale:getModText()
    local _M = Tool:getModGlobal();
    if (not _M.TEXT) then
        error('_M.TEXT == nil',2);
    end
    return _M.TEXT;
end

function Locale:setModConst(const)
    if (type(const) ~= 'table') then
        return ;
    end
    local _M = Tool:getModGlobal();
    _M.CONST = const;
    return _M.CONST;
end


function Locale:getModConst()
    local _M = Tool:getModGlobal();
    if (not _M.CONST) then
        error('_M.CONST == nil',2);
    end
    return _M.CONST;
end

---@alias prefabInfo table<string,string> @��������������ע����ĺ�չ��

---Ԥ����� STRINGS.NAMES | STRINGS.CHARACTERS.GENERIC.DESCRIBE | STRINGS.RECIPE_DESC
---@param prefabsInfo table<string,prefabInfo> @�ֵ����ͣ��������Ա�֤ pairs ��Ҳ��������ʾ
function Locale:prefabSTRINGS(prefabsInfo)
    if (type(prefabsInfo) ~= 'table') then
        return ;
    end
    for name, info in pairs(prefabsInfo) do
        for k, content in pairs(info) do
            do
                local condition = k;
                local switch = {
                    ['names'] = function() -- name, content ������Ϊ�˱���հ�����
                        if (content) then
                            STRINGS.NAMES[name:upper()] = content;
                        end
                    end,
                    ['describe'] = function() -- name, content ������Ϊ�˱���հ�����
                        if (content) then
                            STRINGS.CHARACTERS.GENERIC.DESCRIBE[name:upper()] = content;
                        end
                    end,
                    ['recipe_desc'] = function() -- name, content ������Ϊ�˱���հ�����
                        if (content) then
                            STRINGS.RECIPE_DESC[name:upper()] = content;
                        end
                    end
                };
                if (switch[condition]) then
                    switch[condition](); -- name, content ������Ϊ�˱���հ�����
                end
            end
        end
    end
end

return Locale;