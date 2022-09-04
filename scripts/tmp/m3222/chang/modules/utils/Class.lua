---
--- @author zsh in 2022/8/8 18:08
--- {link:https://zhuanlan.zhihu.com/p/76717305}

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- Class.lua
-- ��lua 5.1���� (������ 5.0).
local function Class(base, init)
    local c = {}    -- Ҫ���ص��µ�class����
    if not init and type(base) == 'function' then
        init = base
        base = nil
    elseif type(base) == 'table' then
        -- �µ���(c)�ǻ���(base)��ǳ����
        for i, v in pairs(base) do
            c[i] = v
        end
        c._base = base -- type(base) == 'table'
    end
    -- ��c������������ʵ�������Ԫ��(metatable)��
    -- ����ʵ��������c�в��ҷ���.
    c.__index = c

    -- ��¶һ�����캯�������÷�ʽ: <classname>(<args>)
    local mt = {} -- ��c��Ԫ��
    mt.__call = function(class_tbl, ...)
        -- 1. ����c��Ϊ����Ԫ�� 2. ��ʼ��
        local obj = {}
        setmetatable(obj, c) --����c��Ϊ����ob��Ԫ��
        if init then
            init(obj, ...) --����û�е��û����init������init��Ϊ��ʱ��Ҫ�������init���ֶ����û����init
        else
            -- ȷ������Ķ�������ʼ����
            if base and base.init then
                base.init(obj, ...)
            end
        end
        return obj
    end --mt.__call() �������

    c.init = init
    c.is_a = function(self, klass)
        local m = getmetatable(self)
        while m do
            if m == klass then
                return true
            end
            m = m._base
        end
        return false
    end

    setmetatable(c, mt)
    return c
end

return Class;

 