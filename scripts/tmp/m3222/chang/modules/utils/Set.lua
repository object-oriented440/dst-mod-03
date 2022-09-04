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

---判断某元素是否是集合中的值，要用 ipairs 遍历！集合不能出现空值！
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

---并集
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
            if (true or not set[v]--[[不需要判断]]) then
                set[v] = true;
            end
        end
    end

    return returnList(set);
end

---交集
---@vararg table[]
function Set:intersection(...)
    local args = { ... };
    local length = #args;
    local res = args[1];

    -- 不对。。。
    --[[    -- 找到最小的集合
        local min = math.huge;
        for i = 1, length do
            min = #args[i] < min and #args[i] or min;
        end
        -- NOTE: 三目运算符必须是 1 and 2 or 3 ！！！不要 1 and 2，这是逻辑运算，无法表示 if else ！！！
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

    -- NOTE: 这是递归改循环
    -- 重点是：多一个临时变量！！！每次循环结束都要将这个变量存到外部变量里面！
    for i = 2, length do

        --[[ 该部分可以变成一个函数 ]]
        local tmp = {};
        for _, v in ipairs(args[i]) do
            if (self:contains(res, v)) then
                table.insert(tmp, v);
            end
        end
        res = tmp;
        tmp = nil; -- 不需要
        --[[ 该部分可以变成一个函数 ]]

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