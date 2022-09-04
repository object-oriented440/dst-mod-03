---
--- @author zsh in 2022/9/3 6:07
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
local Assertion = require('chang_m3.modules.utils.Assertion');
local File = require('chang_m3.modules.utils.File');

-- ģ���ʼ��
local Table = {};
local self = Table;

Table.security = {
    ---���ʹ�ã�
    ---
    ---����������a?.b?.c?.d --> (((a or S).b or S).c or S).d ���ٸ�`?`����ٸ�`(`������Ԫ������
    ---
    ---������������((a or S).b or S)() ������������
    S = setmetatable({}, {
        __newindex = function(t, k, v)
            -- DoNothing
        end,
        __call = function(t, ...)
            print('__call >', ...);
            local func_data = debug.getinfo(2, 'Sl');
            print('Table.security.S.__call --> ERROR', func_data.short_src .. ':' .. func_data.currentline .. ': attempted to call a nil value!');
            return nil;
        end
    }),
    ---���� inst.components.cmp1��func1�����Ա�֤��ȫ���ú�����
    ---
    ---�������ã�inst.components.cmp1:func1()�������򷵻� nil��
    ---@param t table
    ---@param func_name string
    F = function(t, func_name, arg1, ...)
        if (not self.isTable(t) or type(func_name) ~= 'string') then
            return nil;
        end
        if (t and (t == _G and rawget(t, func_name) or t[func_name])) then
            return t[func_name](t, arg1, ...);
        end
    end,
    ---���� S �� F
    getSecurities = function()
        return Table.security.S, Table.security.F;
    end
}

---@return boolean
function Table.isTable(v)
    return type(v) == 'table';
end

---`[ADP�д����ظ�����]`�жϣ��м䲻���ڿն��ı����б�
---@return boolean
function Table.isSequence(t)
    if (type(t) ~= 'table') then
        return false;
    end

    local list_index = {};
    for k, _ in pairs(t) --[[nil Ҳ�����]] do
        if (type(k) == 'number') then
            table.insert(list_index, k);
        end
    end

    table.sort(list_index);

    local length = #list_index;
    if (list_index[length] == length) then
        return true;
    end

    return false;
end

--[[do
    -- Test code
    for _, t in pairs({
        { 1, nil, 2, nil },
        { 1, nil, 2, nil, 3, nil },
        { 1, nil, 2, nil, 3, nil, 4, nil }
    }) do
        print(self.isSequence(t));
    end
    return;
end]]

-- ˵����next ������next(t,k) ������һ�����Լ� k ��Ӧ��ֵ��next(t, nil) ���صڶ������͵�һ����ֵ
---@return boolean
function Table.isEmpty(t)
    if (type(t) ~= 'table') then
        return false;
    end
    return not next(t, nil);
end

---@return number
function Table.getSize(t)
    if (type(t) ~= 'table') then
        return 0;
    end

    -- ������ ['n'] ��
    if (t.n) then
        return t.n;
    end

    local length = 0;
    for _, _ in pairs(t) do
        length = length + 1;
    end
    return length;
end

local function commonprint(content, mode, filepath)
    if (mode == 't') then
        print(content);
    elseif (mode == 'f') then
        File.writefile(filepath, content, 'w');
    elseif (mode == 'tf') then
        print(content);
        File.writefile(filepath, content, 'w');
    else
        print(content);
    end
end

function Table.print(t, mode, filepath)
    if (not self.isTable(t)) then
        print(t);
        return ;
    end

    local msg = {};
    --table.insert(msg, '{\n');
    for k, v in pairs(t) do
        if (type(k) == 'string') then
            table.insert(msg, '    [\"' .. tostring(k) .. '\"] = ' .. tostring(v) .. ',\n');
        else
            table.insert(msg, '    [' .. tostring(k) .. '] = ' .. tostring(v) .. ',\n');
        end
    end

    if (self.getSize(t) > 0) then
        local last = msg[#msg];
        msg[#msg] = string.sub(last, 1, #last - 2) .. '\n';
    end

    --table.insert(msg, '}\n');

    table.sort(msg, function(a, b)
        local regex = '%["(.+)"%]';
        local k1, k2 = string.match(a, regex), string.match(b, regex);
        if (k1 and k2) then
            return k1 < k2;
        end

        if (not k1 and k2) then
            return false;
        end

        if (k1 and not k2) then
            return true;
        end
    end)

    self.push_front(msg, '{\n');
    self.push_back(msg, '}\n');

    local content = table.concat(msg);

    filepath = filepath or 'chang/modules/tmp/table.txt';
    commonprint(content, mode, filepath);
end

---`[������]`
local function enterTable(tab, n, msg)
    -- �������
    local indentation = '';
    for _ = 1, n do
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
                if (cnt ~= self.getSize(tab)) then
                    table.insert(msg, string.format(type(k) == 'string' and (indentation .. '[\"%s\"] = %s,') or (indentation .. '[%s] = %s,'), tostring(k), tostring(v)));
                else
                    table.insert(msg, string.format(type(k) == 'string' and (indentation .. '[\"%s\"] = %s') or (indentation .. '[%s] = %s'), tostring(k), tostring(v)));
                end
            else
                table.insert(msg, string.format(type(k) == 'string' and (indentation .. '[\"%s\"] = ' .. '{') or (indentation .. '[%s] = ' .. '{'), tostring(k)));
                enterTable(v, n + 1, msg);
                table.insert(msg, cnt ~= self.getSize(tab) and (indentation .. '},') or (indentation .. '}'))
            end
        end
    end

end

-- FIXME: ���ܴ��ڹ�����ӱ�ͻ����������д�����
---`[������]`
function Table.deepPrint(t, mode, filepath)
    if (not self.isTable(t)) then
        print(t);
        return ;
    end
    local msg = {};
    table.insert(msg, '{');
    enterTable(t, 1, msg);
    table.insert(msg, '}');

    local content = table.concat(msg, '\n');

    filepath = filepath or 'chang/modules/tmp/deep_table.txt';
    commonprint(content, mode, filepath);
end

function Table.clone(t)
    Assertion.isType(t, 'table');

    local c = {};
    for k, v in pairs(t) do
        c[k] = v;
    end

    return c;
end

---`[Lua 5.3]`ǳ������
function Table.clone2(t)
    Assertion:isType(t, 'table');

    local c = {};
    table.move(t, 1, #t, 1, c);
    return c;
end

function Table.deepClone(t)
    Assertion:isType(t, 'table');

    local c = {};
    for k, v in pairs(t) do
        c[k] = self.deepClone(v); -- ��һ�ѱհ�
    end
    return c;
end

-- Lua 5.2 ��ӵ� table.pack���������� { ... } ������ܣ�Ȼ���ȡ ... �ĳ��ȣ���ʽ ['n'] = length ��������
-- ��ȷʵ��Ҫ������ڿն����б�ʱ��Ӧ�ý��б�ĳ�����ʽ�ر���������
---`[���� Lua 5.1]`�����ɴ���������ɵ��б�˳�򲻱䣩���ü� ['n'] ���б�ĳ�����ʽ�ر���������
---@vararg any
---@return table
function Table.pack(...)
    local args = { ... };

    if (self.isSequence(args)) then
        args.n = #args;
        return args;
    end

    local keys = {};
    for k, _ in pairs(args) --[[ע�⣺�ն�Ҳ��������]] do
        table.insert(keys, k);
    end
    table.sort(keys);

    args.n = keys[#keys];

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

---`[���� Lua 5.1]`������� Table:pack(...) ʹ��
function Table.unpack(list, i, j)
    if (not self.isSequence(list)) then
        error('Not a sequence!', 2);
    end
    i = i or 1;

    -- NOTE��#list ǧ��Ҫ���пն��� nil ����ʹ�ã���Ϊ��ʱ���Ȼ��ȷ����ʱ������
    -- NOTE: ���磺{ 1, nil, 2, nil } --> #list == 1, { 1,nil,2,nil,3,nil } --> #list == 3
    -- NOTE: ��ͬ�� iparis��ipairs �� nil ��ͣ��
    j = j or list.n or #list;

    if (i <= j) then
        return list[i], self.unpack(list, i + 1, j);
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

-- NOTE: ���� table ��׼���е���Щ������ʹ�� C ����ʵ�ֵģ������ƶ�Ԫ�����漰��ѭ�������ܿ���Ҳ������̫������������ڼ��ٸ�Ԫ�ص�С������˵����ʵ���Ѿ����ӡ�

---`[FIXME: Ӧ���Ƶ��б�ģ���У�]`ͷ ��������
function Table.push_front(list, e)
    table.insert(list, 1, e);
    add_list_n(list);
    return list;
end

---`[FIXME: Ӧ���Ƶ��б�ģ���У�]``[Lua 5.3]`ͷ ��������
function Table.push_front2(list, e)
    table.move(list, 1, #list, 2);
    list[1] = e;
    add_list_n(list);
    return list;
end

---`[FIXME: Ӧ���Ƶ��б�ģ���У�]`β ��������
function Table.push_back(list, e)
    table.insert(list, e);
    add_list_n(list);
    return list;
end

---`[FIXME: Ӧ���Ƶ��б�ģ���У�]`ͷ ɾ������
function Table.pop_front(list)
    table.remove(list, 1);
    sub_list_n(list);
    return list;
end

---`[FIXME: Ӧ���Ƶ��б�ģ���У�]``[Lua 5.3]`ͷ ɾ������
function Table.pop_front2(list)
    table.move(list, 2, #list, 1);
    list[#list] = nil; -- ��ʾɾ�����һ��Ԫ��
    sub_list_n(list);
    return list;
end

---`[FIXME: Ӧ���Ƶ��б�ģ���У�]`β ɾ������
function Table.pop_back(list)
    table.remove(list);
    sub_list_n(list);
    return list;
end

---`[FIXME: Ӧ���Ƶ��б�ģ���У�]``[Lua 5.3]`���б� a ��Ԫ�ؿ�¡���б� b ��ĩβ
function Table:add2(a, b)
    table.move(a, 1, #a, #b + 1, b);
    add_list_n(b, #a);
    return b;
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

---�ж�ĳԪ���Ƿ��Ǳ��еļ�
function Table.containsKey(t, e)
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

---�ж�ĳԪ���Ƿ��Ǳ��е�ֵ
function Table.containsValue(t, e)
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

-------------------------------------------------------------------------------------------------
-- [[ dst util.lua ]]
-------------------------------------------------------------------------------------------------
---����һ������ ���������м� ��������б�
---@return table
function Table.getkeys(t)
    if (not self.isTable(t)) then
        return nil;
    end
    local keys = {};
    for k, _ in pairs(t) do
        table.insert(keys, k);
    end
    return keys;
end

---�������������������κοն������֣�1, 2, 3, ..., n
function Table.reverse(t)
    Assertion.isType(t, 'list');

    local size = #t;
    local new_sequence = {};

    for i, v in ipairs(t) do
        new_sequence[size - i + 1] = v;
    end

    return new_sequence;
end

---table<k,v> --> table<v,k>
function Table.invert(t)
    local invt = {};
    for k, v in pairs(t) do
        invt[v] = k;
    end
    return invt;
end

-- NOTE: δ����� ...


--[[do
    -- Test code: Table.security.S��Table.security.F
    local S, F = Table.security.getSecurities();

    --Table.print(S);

    --S();

    print((((inst or S).components or S).cmp1 or S)());

    local i = 100;
    local a = {
        1111,
        func1 = function(t)
            print(t[1]);
            i = 1000;
        end
    };
    print(F(a, 'func1'));
    print(i);
end]]
-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------
---`[����]`
function Table:isList(t)
    return self.isSequence(t);
end

return Table;