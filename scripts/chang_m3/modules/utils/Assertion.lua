---
--- @author zsh in 2022/9/3 5:26
---

-- �������������Ƿ���������Ǵ�������ģ������￪���߿��ٶ�λ�����λ�á�

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
local ADP = require('chang_m3.modules.utils.ADP');

-- ģ���ʼ��
local Assertion = {};
local self = Assertion;

---@param v any ����
---@param whatType string|"'sequence'"|"'list'" ��Ҫ�ж���ʲô���ͣ�
---@param stackLevel number|"'1'"|"'2'"|"'3'"|"'etc...'"
function Assertion.isType(v, whatType, stackLevel)
    -- ���⴫���ֵ��ע�������ֵ���� nil������ `return;` ������ʽ�� type ���գ�
    -- ���� nil �� false ��Ϊ false�������ֵ������ʲô�أ�������ֻ�Ǹ� bug��
    v = v or nil;

    local level = stackLevel or 3;

    local string_error_msg = string.format("Invalid variable type '%s', expected '%s'.", type(whatType), 'string');
    local other_error_msg = string.format("Invalid variable type '%s', expected '%s'.", type(v), whatType);

    if (type(whatType) ~= 'string') then
        error(string_error_msg, level);
    elseif (whatType == 'sequence' or whatType == 'list' or whatType == 'set'--[[����Ҳ���б�ɣ�]]) then
        if (not ADP.isSequence(v)) then
            error(other_error_msg, level);
        end
    elseif (type(v) ~= whatType) then
        error(other_error_msg, level);
    end

    return true;
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


