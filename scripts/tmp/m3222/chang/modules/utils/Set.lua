---
--- @author zsh in 2022/8/27 3:09
---


_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local Assertion = require('m3.chang.modules.utils.Assertion');
local Table = require('m3.chang.modules.utils.Table');

local Set = {};

local function returnList(set)
    local res = {};

    for k, v in pairs(set) do
        if (v) then
            table.insert(res, k);
        end
    end

    return res;
end

---�ж�ĳԪ���Ƿ��Ǽ����е�ֵ��Ҫ�� ipairs ���������ϲ��ܳ��ֿ�ֵ��
function Set:contains(set, e)
    if (set == nil or e == nil) then
        return false;
    end

    if (set.n) then
        for i = 1, set.n do
            if (set[i] == e) then
                return true;
            end
        end
    else
        for _, v in ipairs(set) do
            if (v == e) then
                return true;
            end
        end
    end
end

function Set:new(list)
    list = list or {};
    local set = {};

    for i, v in ipairs(list) do
        set[v] = true;
    end

    return set;
end

---����
---@vararg table[]
function Set:union(...)
    local args = { ... };
    local length = #args;
    local set = self:new();

    for i = 1, length do
        local l = args[i];

        --[[        -- Test code
                Assertion:isType(l, 'table');
                if (not Table:isSequence(l)) then
                    print('ERROR!!!', 'not is a sequence')
                end]]

        for _, v in ipairs(l) do
            if (true or not set[v]--[[����Ҫ�ж�]]) then
                set[v] = true;
            end
        end
    end

    return returnList(set);
end

---����
---@vararg table[]
function Set:intersection(...)
    local args = { ... };
    local length = #args;
    local res = args[1];

    -- ���ԡ�����
    --[[    -- �ҵ���С�ļ���
        local min = math.huge;
        for i = 1, length do
            min = #args[i] < min and #args[i] or min;
        end
        -- NOTE: ��Ŀ����������� 1 and 2 or 3 ��������Ҫ 1 and 2�������߼����㣬�޷���ʾ if else ������
        min = (min == math.huge) and 1 or min;

        local first = args[min];
        for i = 1, length do
            if (i ~= min) then
                local l = args[i];

                for _, v in ipairs(l) do
                    if (contains(first, v)) then
                        print(v);
                        set[v] = true;
                    end
                end
            end
        end]]

    --[[    for i, v in ipairs(args[2]) do
            if (contains(args[1], v)) then
                table.insert(res, v)
            end
        end]]

    -- NOTE: ���ǵݹ��ѭ��
    -- �ص��ǣ���һ����ʱ����������ÿ��ѭ��������Ҫ����������浽�ⲿ�������棡
    for i = 2, length do

        --[[ �ò��ֿ��Ա��һ������ ]]
        local tmp = {};
        for _, v in ipairs(args[i]) do
            if (self:contains(res, v)) then
                table.insert(tmp, v);
            end
        end
        res = tmp;
        tmp = nil; -- ����Ҫ
        --[[ �ò��ֿ��Ա��һ������ ]]

    end

    return res;
end

--[[do
    -- Test code
    Table:print(Set:union(
            { 1, 2, 3 },
            { 3, 4, 5 },
            { 4, 5, 6, 10, 23, 4 }
    ))

    --for k in pairs({ 4, 5, 6 }) do
    --    print(k);
    --end

    Table:print(Set:intersection(
            { 1, 5, 3 },
            { 3, 4, 5 },
            { 3, 5, 6 }
    ))


    print(#{ nil, 1 });
end]]

return Set;