---
--- @author zsh in 2022/8/20 16:26
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local Date = {};

---����һ���ĸ�ʽ��õ�ǰʱ��
---@param format string|"'%Y-%m-%d %H:%M:%S'"
---@return string
function Date:getCurrentTime(format)
    local fmt = format or '%Y-%m-%d %H:%M:%S';
    return os.date(fmt);
end

---���������
---@return string
function Date:getYmd()
    return os.date('%Y'), os.date('%m'), os.date('%d');
end

---���ʱ����
---@return string
function Date:getHMS()
    return os.date('%H'), os.date('%M'), os.date('%S');
end

---`[����]`
---@return number|string
function Date:getYear(isstring)
    if (isstring) then
        return os.date('%Y');
    end
    return tonumber(os.date('%Y'));
end

---`[����]`
---@return number|string
function Date:getMonth(isstring)
    if (isstring) then
        return os.date('%m');
    end
    return tonumber(os.date('%m'));
end

---`[����]`
---@return number|string
function Date:getDay(isstring)
    if (isstring) then
        return os.date('%d');
    end
    return tonumber(os.date('%d'));
end

return Date;