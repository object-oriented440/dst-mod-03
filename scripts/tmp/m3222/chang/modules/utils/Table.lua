---
--- @author zsh in 2022/8/20 16:34
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local Assertion = require('m3.chang.modules.utils.Assertion');

local Table = {
    ---`[弃用]`
    safety = setmetatable({}, {
        __newindex = function(t, k, v)
            print('>', k, v);
            print('ERROR!!!', 'You cannot update the index!');
        end,
        __call = function(t, ...)
            print('>', ...);
            local func_data = debug.getinfo(2, 'Sl');
            print('ERROR!!!', func_data.short_src .. ':' .. func_data.currentline .. ': You might have attempted to call a nil value! Please check it!');
        end
    })
};

local function enterTable(tab, n, msg)
    -- 获得缩进
    local indentation = '';
    for i = 1, n do
        indentation = indentation .. '    ';
    end

    -- FIXME: 临时的，避免环的存在导致堆栈溢出！
    if (n == 20) then
        return ;
    end

    -- 递归条件：遍历整张表
    local cnt = 0;
    for k, v in pairs(tab) do
        cnt = cnt + 1;
        if not (type(k) == 'string' and string.match(k, '^_+')) then
            if (type(v) ~= 'table') then
                if (cnt ~= Table:getSize(tab)) then
                    table.insert(msg, string.format(type(k) == 'string' and (indentation .. '[\"%s\"] = %s,') or (indentation .. '[%s] = %s,'), tostring(k), tostring(v)));
                else
                    table.insert(msg, string.format(type(k) == 'string' and (indentation .. '[\"%s\"] = %s') or (indentation .. '[%s] = %s'), tostring(k), tostring(v)));
                end
            else
                table.insert(msg, string.format(type(k) == 'string' and (indentation .. '[\"%s\"] = ' .. '{') or (indentation .. '[%s] = ' .. '{'), tostring(k)));
                enterTable(v, n + 1, msg);
                table.insert(msg, cnt ~= Table:getSize(tab) and (indentation .. '},') or (indentation .. '}'))
            end
        end
    end

end


function Table:isTable(v)
    return type(v) == 'table';
end


function Table:isList(t)
    return self:isSequence(t);
end

function Table:isSequence(t)
    Assertion:isType(t, 'table');

    local list_index = {};
    for k, _ in pairs(t) do
        -- nil 也赋序号？对 √

        if (type(k)) then
            table.insert(list_index, k);
        end
    end

    table.sort(list_index);

    do
        local length = #list_index;
        if (list_index[length] == length) then
            return true;
        end
    end
end

-- 说明：next 函数，next(t,k) 返回下一个键以及 k 对应的值
function Table:isEmpty(t)
    Assertion:isType(t, 'table');
    return not next(t, nil);
end

---Return the table length
---@param t table
function Table:getSize(t)
    Assertion:isType(t, 'table');

    local length = 0;
    for _, _ in pairs(t) do
        length = length + 1;
    end
    return length;
end

-- 注意，@type 的注释需要写在上面才显示，其他写在 @ 后面即可显示
---浅层打印表内容
---@type fun(tab:table,fn:function)
---@param tab table
---@param fn function @自定义的打印函数，参数为 k,v
---@return nil
function Table:print(tab, fn)
    if (not self:isTable(tab)) then
        --io.write(tostring(tab), '\n');
        print(tab);
        return ;
    end

    -- TODO:
    if (type(fn) == 'function') then
        for k, v in pairs(tab) do
            fn(k, v);
        end
        return ;
    end

    local msg = {};

    for k, v in pairs(tab) do
        if (type(k) == 'string') then
            table.insert(msg, '[\"' .. tostring(k) .. '\"] = ' .. tostring(v) .. '\n');
        else
            table.insert(msg, '[' .. tostring(k) .. '] = ' .. tostring(v) .. '\n');
        end
    end

    local str = table.concat(msg);

    print(str);
end


-- FIXME:不允许存在共享的子表和环（环：表中存自身），未实现！
---打印表内的所有内容
function Table:deepPrint(tab)
    if (not self:isTable(tab)) then
        --io.write(tostring(tab), '\n');
        print(tab);
        return ;
    end
    local msg = {};
    table.insert(msg, '{');
    enterTable(tab, 1, msg);
    table.insert(msg, '}');
    print(table.concat(msg, '\n'));
end

---浅拷贝表
function Table:clone(tab)
    Assertion:isType(tab, 'table');

    local c = {};
    for k, v in pairs(tab) do
        c[k] = v;
    end

    return c;
end

---`[Lua 5.3]`浅拷贝表
function Table:clone2(t)
    Assertion:isType(tab, 'table');

    local c = {};
    table.move(t, 1, #t, 1, c);
    return c;
end

---深拷贝表
function Table:deepClone(tab)
    Assertion:isType(tab, 'table');

    local c = {};
    for k, v in pairs(tab) do
        c[k] = self:deepClone(v);
    end
    return c;
end

-- Lua 5.2 添加的 table.pack，就是类似 { ... } 这个功能，然后获取 ... 的长度，显式 ['n'] = length 存起来。
---`[兼容 Lua 5.1]`在确实需要处理存在空洞的列表时，应该将列表的长度显式地保存起来！
---@vararg table[]
function Table:pack(...)
    local args = { ... };

    -- 注意这里！空洞也有索引！
    local keys = {};
    for k, _ in pairs(args) do
        table.insert(keys, k);
    end
    table.sort(keys);

    local length = keys[#keys];

    args['n'] = length;

    return args;
end

-- NOTE: table.unpack 用 C 语言编写的，且使用了长度操作符，所以无法有效处理存在空洞的列表。
-- 所以，意思是：千万不要在列表里设置 nil ！！！使用 table.unpack 如果传入的 list 中存在空洞，则会存在问题！
-- 这时候，就要显式地限制返回元素的范围了！
--[[do
    -- Test code
    local t1 = { 1, nil, 2, nil }; -- # -- > 1
    local t2 = { 1, nil, 2, nil, 3, nil }; -- # -- > 3
    local t3 = { 1, nil, 2, nil, 3, nil, 4, nil }; -- # -- > 1

    local ta = table.pack(1, nil, 2, nil); -- # -- > 1
    local tb = table.pack(1, nil, 2, nil, 3, nil); -- # -- > 3
    local tc = table.pack(1, nil, 2, nil, 3, nil, 4, nil); -- # -- > 1

    print(table.unpack(ta, 1, ta.n));
    print(table.unpack(tb, 1, tb.n));
    print(table.unpack(tc, 1, tc.n));
end]]

---建议配合 Table:pack(...) 使用
---@param list table[]
---@param i number
---@param j number
function Table:unpack(list, i, j)
    i = i or 1;

    -- NOTE：#list 千万不要在有空洞的 nil 里面使用！因为有时候居然正确，有时候会错误！
    -- NOTE: 比如：{ 1,nil,2,nil,3,nil } --> #list == 3
    -- NOTE: 不同于 iparis，ipairs 遇 nil 即停！
    j = j or list.n or #list;

    if (i <= j) then
        return list[i], self:unpack(list, i + 1, j);
    end
end

local function add_list_n(list, amount)
    amount = amount or 1;
    if (list.n) then
        list.n = list.n + amount;
    end
end

local function sub_list_n(list, amount)
    amount = amount or 1;
    if (list.n) then
        list.n = list.n - amount;
    end
end

-- 由于 table 标准库中的这些函数是使用 C 语言实现的，所以移动元素所涉及的循环的性能开销也并不是太昂贵，因而，对于几百个元素的小数组来说这种实现已经足矣。
---头 插入数据
function Table:push_front(list, e)
    table.insert(list, 1, e);
    add_list_n(list);
    return list;
end

---`[Lua 5.3]`头 插入数据
function Table:push_front2(list, e)
    table.move(list, 1, #list, 2);
    list[1] = e;
    add_list_n(list);
    return list;
end

---尾 插入数据
function Table:push_back(list, e)
    table.insert(list, e);
    add_list_n(list);
    return list;
end

---头 删除数据
function Table:pop_front(list)
    table.remove(list, 1);
    sub_list_n(list);
    return list;
end

---`[Lua 5.3]`头 删除数据
function Table:pop_front2(list)
    table.move(list, 2, #list, 1);
    list[#list] = nil; -- 显示删除最后一个元素
    sub_list_n(list);
    return list;
end

---尾 删除数据
function Table:pop_back(list)
    table.remove(list);
    sub_list_n(list);
    return list;
end

--[[do
    -- Test code: push_front、push_back、pop_front、pop_back
    local a = {};
    Table:push_front(a,1);
    Table:push_front(a,2);

    Table:push_back(a,4);
    Table:push_back(a,3);

    Table:pop_front(a);
    Table:pop_back(a);

    for i, v in ipairs(a) do
        print(i,v);
    end

    Table:print(a);
end]]

---`[Lua 5.3]`将列表 a 的元素克隆到列表 b 的末尾
function Table:add2(a, b)
    table.move(a, 1, #a, #b + 1, b);
    add_list_n(b, #a);
    return b;
end

-- 显然，传入的 t 是列表也是有问题的！因为很多时候，列表自带 ['n'] = length 键！
---判断某元素是否是表中的键
function Table:containsKey(t, e)
    if (t == nil or e == nil) then
        return false;
    end

    for k, _ in pairs(t) do
        if (k == e) then
            return true;
        end
    end
    return false;
end

-- 显然，传入的 t 是列表也是有问题的！因为很多时候，列表自带 ['n'] = length 键！
---判断某元素是否是表中的值
function Table:containsValue(t, e)
    if (t == nil or e == nil) then
        return false;
    end

    for _, v in pairs(t) do
        if (v == e) then
            return true;
        end
    end
    return false;
end


--[[do
    -- Test code
    local a = {};
    a[1] = a;
    Table:deepPrint(a)
end]]

return Table;
 