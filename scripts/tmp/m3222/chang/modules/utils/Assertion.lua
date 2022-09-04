---
--- @author zsh in 2022/8/20 22:24
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local Assertion = {};

---@param v any ����
---@param whatType string ��Ҫ�ж���ʲô���ͣ�
---@param stackLevel number|"'1'"|"'2'"|"'3'"|"'etc...'"
function Assertion:isType(v, whatType, stackLevel)
    v = v or nil; -- ���⴫���ֵ��ע�������ֵ���� nil������ `return;` ������ʽ�� type ���գ�
    -- ���� nil �� false ��Ϊ false�������ֵ������ʲô�أ�������ֻ�Ǹ� bug��

    local level = stackLevel or 3;
    if (type(whatType) ~= 'string') then
        error(string.format("Invalid variable type '%s', expected '%s'.", type(whatType), 'string'), level);
    end
    if (type(v) == whatType) then
        return true;
    else
        error(string.format("Invalid variable type '%s', expected '%s'.", type(v), whatType), level);
    end
end

--[[do
    -- Test code: type() `bad argument #1 to 'type' (value expected)`
    local test = function()
        return ;
    end;
    local a = test();
    io.write('{', tostring(a), '}\n');
    io.flush();
    print(type(a)); -- test() ���� ���� �� a��a �Զ���ֵ�� nil
    print(type(test())); -- ���������`bad argument #1 to 'type' (value expected)`
end]]

return Assertion;
 