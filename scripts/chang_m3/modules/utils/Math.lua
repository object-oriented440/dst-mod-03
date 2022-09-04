---
--- @author zsh in 2022/9/3 7:14
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��


-- ģ���ʼ��
local Math = {};
local self = Math;

-- FIXME: p23
---`[�����ơ�������]`�����������ȡ��
---@return number
function Math.round(x)
    return math.floor(x + 0.5); -- ��������
end

---������λС��
---@return number
function Math.setPrecision(number, n)
    return number - number % tonumber('1e-' .. n);
end

---`[���� Lua 5.1]` Lua 5.3 �� floor ����
---@return number
function Math.floorDivision(a, b)
    return tonumber(tostring((a - (a % b)) / b):sub(1, -3));
end

---`[��ʵ��]`
function Math.SaturationArithmetic(x, min, max)
    if (x<min) then
        return min;
    elseif (x > max) then
        return max;
    else
        return x;
    end
end

-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------
Math.Binary={};
Math.Octal={};
Math.Decimal={};
Math.Hexadecimal={};

local Binary = Math.Binary;
local Octal = Math.Octal;
local Decimal = Math.Decimal;
local Hexadecimal = Math.Hexadecimal;

---ͨ�ý���ת��
local function commonHexBinDecOct(R1, R2, x)

end

local tmp = '';
-- FIXME:
---`[��ʵ�֡�������]`ʮ����תΪ������
function Decimal.Binary(x)
    -- ���� number Ϊ 32 λ
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

        local i, r = Math.floorDiv(x, 2), x % 2;
        --print(i,r);

        self.Binary(i);

        tmp = tmp .. r;

        return tmp;
    end
end

--[[do
    -- Test code
    print(Decimal.Binary(100));
end]]

---`[��ʵ��]`ʮ����תΪ�˽���
function Decimal.Octal(x)

end

---`[��ʵ��]`ʮ����תΪʮ������
function Decimal.Hexadecimal(x)

end
-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------


return Math;