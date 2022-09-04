---
--- @author zsh in 2022/9/3 7:22
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
local Assertion = require('chang_m3.modules.utils.Assertion');

-- ģ���ʼ��
local Set = {};
local self = Set;

local function returnList(set)
    local res = {};
    for k, v in pairs(set) do
        if (v) then
            table.insert(res, k);
        end
    end
    return res;
end

---�ж�ĳԪ���Ƿ��Ǽ����е�ֵ���� ipairs ���������ϲ��ܳ��ֿ�ֵ��
function Set.contains(set, e)
    Assertion.isType(set, 'list'); -- �жϣ��м䲻���ڿն��ı����б�

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

function Set.new(list)
    Assertion.isType(list, 'list'); -- �жϣ��м䲻���ڿն��ı����б�

    list = list or {};
    local set = {};

    for _, v in ipairs(list) do
        set[v] = true;
    end

    return set;
end

---�������������ݶ����б�
local function paramsIsSequence(...)
    local args = { ... };
    Assertion.isType(args, 'sequence');

    local length = #args;
    for i = 1, length do
        Assertion.isType(args[i], 'sequence');
    end

    return true;
end

---����
---@vararg table[]
function Set.union(...)
    paramsIsSequence(...);

    local args = { ... };
    local length = #args;

    local set = self.new();

    for i = 1, length do
        for _, v in ipairs(args[i]) do
            if (true or not set[v]--[[����Ҫ�ж�]]) then
                set[v] = true;
            end
        end
    end

    return returnList(set);
end

---����
---@vararg table[]
function Set.intersection(...)
    paramsIsSequence(...);

    local args = { ... };
    local length = #args;
    local res = args[1];

    -- NOTE: ��Ŀ����������� 1 and 2 or 3 ��������Ҫ 1 and 2�������߼����㣬�޷���ʾ if else ������
    -- NOTE: ���ǵݹ��ѭ��
    -- �ص��ǣ���һ����ʱ����������ÿ��ѭ��������Ҫ����������浽�ⲿ�������棡
    for i = 2, length do

        --[[ �ò��ֿ��Ա��һ������ ]]
        local tmp = {};
        for _, v in ipairs(args[i]) do
            if (self.contains(res, v)) then
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

-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------



--[[do
    -- Test code
    do
        local function foo()
            bar()
        end

        local function bar()
            foo()
        end
        return ;
    end

    do
        local foo, bar;
        foo = function()
            bar();
        end

        bar = function()
            foo();
        end
        return ;
    end
end]]

return Set;
 