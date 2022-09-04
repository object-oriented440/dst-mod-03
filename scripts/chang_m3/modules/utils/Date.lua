---
--- @author zsh in 2022/9/3 5:40
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��


-- ģ���ʼ��
local Date = {};
local self = Date;

---@param format string @%Y-%m-%d %H:%M:%S
---@return string
function Date.getCurrentTime(format)
    local fmt = format or '%Y-%m-%d %H:%M:%S';
    return os.date(fmt);
end

---@return string
function Date.getYmd()
    return os.date('%Y'), os.date('%m'), os.date('%d');
end

---@return string
function Date.getHMS()
    return os.date('%H'), os.date('%M'), os.date('%S');
end

-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------
---`[����]`
---@return number|string
function Date.getYear(isstring)
    if (isstring) then
        return os.date('%Y');
    end
    return tonumber(os.date('%Y'));
end

---`[����]`
---@return number|string
function Date.getMonth(isstring)
    if (isstring) then
        return os.date('%m');
    end
    return tonumber(os.date('%m'));
end

---`[����]`
---@return number|string
function Date.getDay(isstring)
    if (isstring) then
        return os.date('%d');
    end
    return tonumber(os.date('%d'));
end

return Date;