---
--- @author zsh in 2022/8/21 22:40
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

--[[
    math.floor      向负无穷取整
    math.ceil       向正无穷取整
    math.modf       向 0 取整，两个返回值，一个是整数一个是小数

]]

--[[---@field Binary table
---@field Octal table
---@field Decimal table
---@field Hexadecimal table]]
local Math = {
    Binary = {},
    Octal = {},
    Decimal = {},
    Hexadecimal = {}
};

local Binary = Math.Binary;
local Octal = Math.Octal;
local Decimal = Math.Decimal;
local Hexadecimal = Math.Hexadecimal;


-- FIXME: p23
---`[need fix]`向最近的整数取整
function Math:round(x)
    return math.floor(x + 0.5); -- 不够完善
end

---保留几位小数
function Math:setPrecision(number, n)
    return number - number % tonumber('1e-' .. n);
end

---`[兼容 Lua 5.1]` Lua 5.3 的 floor 除法
---@param a number
---@param b number
---@return number
function Math:floorDiv(a, b)
    return tonumber(tostring((a - (a % b)) / b):sub(1, -3));
end

---通用进制转换
local function commonHexBinDecOct(R1, R2, x)

end

local tmp = '';
-- FIXME:
---十进制转为二进制
function Decimal:Binary(x)
    -- 假设 number 为 32 位
    --[[    do
            local str = '';
            for i = 31, 0, -1 do
                local x2 = x - 2 ^ i;
                if (x2 >= 0) then
                    str = str .. '1';
                    x = x2;
                else
                    if (str:sub(1, 1) == '1') then
                        str = str .. '0';
                    end
                end
            end
            return str;
        end]]

    do

        if (x == 0) then
            return ;
        end

        local i, r = Math:floorDiv(x, 2), x % 2;
        --print(i,r);

        self:Binary(i);

        tmp = tmp .. r;

        return tmp;
    end
end

-- TODO: 饱和运算
function Math:SaturationArithmetic(x, min, max)
    if (x<min) then
        return min;
    elseif (x > max) then
        return max;
    else
        return x;
    end
end

do
    -- Test code
    print(Decimal:Binary(100));
end

---十进制转为八进制
function Decimal:Octal(x)

end

---十进制转为十六进制
function Decimal:Hexadecimal(x)

end

return Math;