---
--- @author zsh in 2022/8/20 16:26
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local Date = {};

---按照一定的格式获得当前时间
---@param format string|"'%Y-%m-%d %H:%M:%S'"
---@return string
function Date:getCurrentTime(format)
    local fmt = format or '%Y-%m-%d %H:%M:%S';
    return os.date(fmt);
end

---获得年月日
---@return string
function Date:getYmd()
    return os.date('%Y'), os.date('%m'), os.date('%d');
end

---获得时分秒
---@return string
function Date:getHMS()
    return os.date('%H'), os.date('%M'), os.date('%S');
end

---`[弃用]`
---@return number|string
function Date:getYear(isstring)
    if (isstring) then
        return os.date('%Y');
    end
    return tonumber(os.date('%Y'));
end

---`[弃用]`
---@return number|string
function Date:getMonth(isstring)
    if (isstring) then
        return os.date('%m');
    end
    return tonumber(os.date('%m'));
end

---`[弃用]`
---@return number|string
function Date:getDay(isstring)
    if (isstring) then
        return os.date('%d');
    end
    return tonumber(os.date('%d'));
end

return Date;