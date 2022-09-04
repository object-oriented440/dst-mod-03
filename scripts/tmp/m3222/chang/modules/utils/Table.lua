---
--- @author zsh in 2022/8/20 16:34
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local Assertion = require('m3.chang.modules.utils.Assertion');

local Table = {
    ---`[����]`
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
    -- �������
    local indentation = '';
    for i = 1, n do
        indentation = indentation .. '    ';
    end

    -- FIXME: ��ʱ�ģ����⻷�Ĵ��ڵ��¶�ջ�����
    if (n == 20) then
        return ;
    end

    -- �ݹ��������������ű�
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
        -- nil Ҳ����ţ��� ��

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

-- ˵����next ������next(t,k) ������һ�����Լ� k ��Ӧ��ֵ
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

-- ע�⣬@type ��ע����Ҫд���������ʾ������д�� @ ���漴����ʾ
---ǳ���ӡ������
---@type fun(tab:table,fn:function)
---@param tab table
---@param fn function @�Զ���Ĵ�ӡ����������Ϊ k,v
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


-- FIXME:��������ڹ�����ӱ�ͻ����������д�������δʵ�֣�
---��ӡ���ڵ���������
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

---ǳ������
function Table:clone(tab)
    Assertion:isType(tab, 'table');

    local c = {};
    for k, v in pairs(tab) do
        c[k] = v;
    end

    return c;
end

---`[Lua 5.3]`ǳ������
function Table:clone2(t)
    Assertion:isType(tab, 'table');

    local c = {};
    table.move(t, 1, #t, 1, c);
    return c;
end

---�����
function Table:deepClone(tab)
    Assertion:isType(tab, 'table');

    local c = {};
    for k, v in pairs(tab) do
        c[k] = self:deepClone(v);
    end
    return c;
end

-- Lua 5.2 ��ӵ� table.pack���������� { ... } ������ܣ�Ȼ���ȡ ... �ĳ��ȣ���ʽ ['n'] = length ��������
---`[���� Lua 5.1]`��ȷʵ��Ҫ������ڿն����б�ʱ��Ӧ�ý��б�ĳ�����ʽ�ر���������
---@vararg table[]
function Table:pack(...)
    local args = { ... };

    -- ע������ն�Ҳ��������
    local keys = {};
    for k, _ in pairs(args) do
        table.insert(keys, k);
    end
    table.sort(keys);

    local length = keys[#keys];

    args['n'] = length;

    return args;
end

-- NOTE: table.unpack �� C ���Ա�д�ģ���ʹ���˳��Ȳ������������޷���Ч������ڿն����б�
-- ���ԣ���˼�ǣ�ǧ��Ҫ���б������� nil ������ʹ�� table.unpack �������� list �д��ڿն������������⣡
-- ��ʱ�򣬾�Ҫ��ʽ�����Ʒ���Ԫ�صķ�Χ�ˣ�
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

---������� Table:pack(...) ʹ��
---@param list table[]
---@param i number
---@param j number
function Table:unpack(list, i, j)
    i = i or 1;

    -- NOTE��#list ǧ��Ҫ���пն��� nil ����ʹ�ã���Ϊ��ʱ���Ȼ��ȷ����ʱ������
    -- NOTE: ���磺{ 1,nil,2,nil,3,nil } --> #list == 3
    -- NOTE: ��ͬ�� iparis��ipairs �� nil ��ͣ��
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

-- ���� table ��׼���е���Щ������ʹ�� C ����ʵ�ֵģ������ƶ�Ԫ�����漰��ѭ�������ܿ���Ҳ������̫������������ڼ��ٸ�Ԫ�ص�С������˵����ʵ���Ѿ����ӡ�
---ͷ ��������
function Table:push_front(list, e)
    table.insert(list, 1, e);
    add_list_n(list);
    return list;
end

---`[Lua 5.3]`ͷ ��������
function Table:push_front2(list, e)
    table.move(list, 1, #list, 2);
    list[1] = e;
    add_list_n(list);
    return list;
end

---β ��������
function Table:push_back(list, e)
    table.insert(list, e);
    add_list_n(list);
    return list;
end

---ͷ ɾ������
function Table:pop_front(list)
    table.remove(list, 1);
    sub_list_n(list);
    return list;
end

---`[Lua 5.3]`ͷ ɾ������
function Table:pop_front2(list)
    table.move(list, 2, #list, 1);
    list[#list] = nil; -- ��ʾɾ�����һ��Ԫ��
    sub_list_n(list);
    return list;
end

---β ɾ������
function Table:pop_back(list)
    table.remove(list);
    sub_list_n(list);
    return list;
end

--[[do
    -- Test code: push_front��push_back��pop_front��pop_back
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

---`[Lua 5.3]`���б� a ��Ԫ�ؿ�¡���б� b ��ĩβ
function Table:add2(a, b)
    table.move(a, 1, #a, #b + 1, b);
    add_list_n(b, #a);
    return b;
end

-- ��Ȼ������� t ���б�Ҳ��������ģ���Ϊ�ܶ�ʱ���б��Դ� ['n'] = length ����
---�ж�ĳԪ���Ƿ��Ǳ��еļ�
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

-- ��Ȼ������� t ���б�Ҳ��������ģ���Ϊ�ܶ�ʱ���б��Դ� ['n'] = length ����
---�ж�ĳԪ���Ƿ��Ǳ��е�ֵ
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
 