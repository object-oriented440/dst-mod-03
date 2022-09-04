---
--- @author zsh in 2022/8/20 16:27
---

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

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });


local Error = require('m3.chang.modules.utils.incomplete.Error');

local String = {};

function String:isString(var)
    return type(var)=='string';
end

---�޳��ַ������˵Ŀո�
---@param s string  �ַ���
---@return string   �滻����ַ���
function String:trimSpace(s)
    local str, _ = string.gsub(s, '^%s*(.-)%s*$', '%1'); -- ע�⣺- ����ַ�
    return str;
end

function String:getLength(s)
    Error:isType(s,'string');
    return #s;
end


return String;