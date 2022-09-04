---
--- @author zsh in 2022/9/3 14:25
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
local Assertion = require('chang_m3.modules.utils.Assertion');

-- ģ���ʼ��
local String = {};
local self = String;

--[[
    ħ���ַ��� ( ) . % + - * ? [ ] ^ $

    .       �����ַ�
    %a      ��ĸ
    %c      �����ַ�
    %d      ����
    %g      ���ո���Ŀɴ�ӡ�ַ�
    %l      Сд��ĸ
    %p      ������
    %s      �հ��ַ�
    %u      ��д��ĸ
    %w      ��ĸ������
    %x      ʮ����������

    %b      ƥ��ɶԵ��ַ������� `%b()` ƥ���������ſ�ʼ���Զ�Ӧ�����Ž������Ӵ�
    ^       ��Ŀ���ַ�����ͷ��ʼƥ��
    $       ƥ�䵽Ŀ���ַ����Ľ�β


    string.byte(s, i, j)
    string.char(...)
    string.dump(func, strip)

    string.find(s, pattern, init, plain)
    string.format(formatstring, ...)
    string.gmatch(s, pattern)
    string.gsub(s, pattern, repl, n)
    string.match(s, pattern, init)
    string.sub(s, i, j)

    string.pack(fmt, v1, v2, ...)
    string.unpack(fmt, s, pos)
    string.packsize(fmt)

    string.rep(s, n, sep)
    string.reverse(s)

    string.len(s)
    string.lower(s)
    string.upper(s)
]]


function String.isString(v)
    return type(v) == 'string';
end

---�޳��ַ������˵Ŀո�
---@param s string  �ַ���
---@return string   �滻����ַ���
function String.trimSpace(s)
    -- '^%s*(.*)%S$'
    local str, _ = string.gsub(s, '^%s*(.-)%s*$', '%1'); -- ע�⣺- ����ַ�
    return str;
end

function String.getLength(s)
    if (type(s) ~= 'string') then
        return 0;
    end
    return #s;
end


-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------


return String;