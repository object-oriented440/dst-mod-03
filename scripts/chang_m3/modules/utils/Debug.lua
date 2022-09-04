---
--- @author zsh in 2022/9/3 5:44
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
require('debug'); -- ��ʽ����һ�µ��Կ�
print('The debug library is used');

-- ģ���ʼ��
local Debug = {};
local self = Debug;

---���ݺ���������������ջ�е����к��������δ�ӡ�� localvalue ������ֵ
---@param func_name string @ ����ջ�е�ĳ������������
function Debug.printAllLocalValue(func_name)
    ---@type DebugInfo
    local func_data; -- �����Ƿ��ܹ���ʡ�ռ䣿����Ҫ���������ʱ����
    local success = false;

    for level = 2, math.huge do
        func_data = debug.getinfo(level, 'n')
        if (not func_data) then
            break ;
        elseif (func_data.name == func_name) then
            -- Test code
            --print(type(func_data.name));
            local k, v;
            for index = 1, math.huge do
                k, v = debug.getlocal(level, index);
                if (not k) then
                    break ;
                else
                    print('[' .. index .. ']', tostring(k) .. ' - ' .. tostring(v));
                    success = true;
                end
            end
        end
    end
    if (not success) then
        print('Debug.printAllLocalValue --> not found');
    end

    return success;
end

---���ݺ���������������ջ�е����к��������δ�ӡ�� upvalue ������ֵ
---@param func_name string @ ����ջ�е�ĳ������������
function Debug.printAllUpValue(func_name)
    ---@type DebugInfo
    local func_data;
    local success = false;

    for level = 2, math.huge do
        func_data = debug.getinfo(level, 'nf');
        if (not func_data) then
            break ;
        elseif (func_data.name == func_name and func_data.func) then
            local func = func_data.func;
            local k, v;
            for index = 1, math.huge do
                k, v = debug.getupvalue(func, index);
                if (not k) then
                    break ;
                else
                    print('[' .. index .. ']', tostring(k) .. ' - ' .. tostring(v));
                    success = true;
                end
            end
        end
    end
    if (not success) then
        print('Debug.printAllUpValue --> not found');
    end

    return success;
end

---���ݺ�������������������ջ���ҳ���һ������Ϊ `local_name` �ı�����������ֵ��δ�ҵ����� nil
---@param flag any @ ���ռ���
function Debug.getlocalvalue(func_name, local_name, flag)
    ---@type DebugInfo
    local func_data;

    for level = 2, math.huge do
        func_data = debug.getinfo(level, 'n');
        if (not func_data) then
            break ;
        elseif (func_data.name == func_name) then
            local k, v;
            for index = 1, math.huge do
                k, v = debug.getlocal(level, index);
                if (not k) then
                    break ;
                elseif (k == local_name) then
                    if (flag == 'setlocalvalue') then
                        return v, level, index;
                    else
                        return v;
                    end
                end
            end
        end
    end
    print('Debug.getlocalvalue --> not found');
    return nil;
end

---���ݺ�������������������ջ������һ������Ϊ `local_name` �ı���������ֵ
function Debug.setlocalvalue(func_name, local_name, new_value)
    local localvalue, level, index = self.getlocalvalue(func_name, local_name, 'setlocalvalue');
    if (localvalue and level and index) then
        -- NOTE: getlocalvalue ������ϳ�ջ����� level Ҫ -1
        debug.setlocal(level - 1, index, new_value);
        return true;
    end
    print('Debug.setlocalvalue --> setup failed');
end

---���ݺ�������������������ջ���ҳ���һ������Ϊ `upvalue_name` �ı�����������ֵ��δ�ҵ����� nil
---@param flag any @ ���ռ���
function Debug.getupvalue(func_name, upvalue_name, flag)
    ---@type DebugInfo
    local func_data;

    for level = 2, math.huge do
        func_data = debug.getinfo(level, 'nf');
        if (not func_data) then
            break ;
        elseif (func_data.name == func_name and func_data.func) then
            local func = func_data.func;
            local k, v;
            for index = 1, math.huge do
                k, v = debug.getupvalue(func, index);
                if (not k) then
                    break ;
                elseif (k == upvalue_name) then
                    if (flag == 'setupvalue') then
                        return v, func, index;
                    else
                        return v;
                    end
                end
            end
        end
    end
    print('Debug.getupvalue --> not found');
    return nil;
end

---���ݺ�������������������ջ������һ������Ϊ `upvalue_name` �ı���������ֵ
function Debug.setupvalue(func_name, upvalue_name, new_value)
    local upvalue, func, index = self.getupvalue(func_name, upvalue_name, 'setupvalue');
    if (upvalue and func and index) then
        -- tips: param1, f:number|function
        debug.setupvalue(func, index, new_value);
        return true;
    end
    print('Debug.setupvalue --> setup failed');
end

--[[do
    -- Test code: set\get localvalue\upvalue��printAll LocalValue\UpValue
    local f1, f2, f3, current;

    f1 = function()
        local f1a = 'f1a_v';
        local f1b = 'f1b_v';
        f2();
    end

    f2 = function()
        local f2a = 'f2a_v';
        local f2b = 'f2b_v';
        f3();
    end

    local f3_upvalue = 'f3_up_1';
    f3 = function()
        local f3a = 'f3a_v';
        local f3b = 'f3b_v';

        f3_upvalue = f3_upvalue;
        current();
    end

    current = function()
        self.printAllLocalValue('f3');
        print();
        self.printAllUpValue('f3');
        print();
        print(self.getlocalvalue('f3', 'f3a'));
        print();
        print(self.getupvalue('f3', 'current'));
        print();

        print(self.getlocalvalue('f3', 'f3a'));
        print(self.setlocalvalue('f3', 'f3a', 'f3a_new'))
        print(self.getlocalvalue('f3', 'f3a'));
        print();

        print(self.getupvalue('f3', 'f3_upvalue'));
        -- NOTE: ����û�� return��tostring\type ���᣺bad argument #1 to 'tostring' (value expected)
        -- NOTE: ������Ӧ�ø�ÿ���������� return ������ xxx == nil --> true���� tostring(xxx) �� tostring(nil) ��
        print(self.setupvalue('f3', 'f3_upvalue', 'f3_upvalue_new'));
        print(self.getupvalue('f3', 'f3_upvalue'));
        print();
    end

    f1();
    --print:
    --[1]	f3a - f3a
    --[2]	f3b - f3b
    return ;
end]]

--[[do
    -- Test code
    local Table = require('chang_m3.modules.utils.Table');
    local print = function(...)
        _G.print(...);
    end
    local func_data = debug.getinfo(print);
    Table.deepPrint(func_data);
    return ;
end]]
-------------------------------------------------------------------------------------------------
-- [[ ��ʵ�֡������ơ��������������� ]]
-------------------------------------------------------------------------------------------------
---`[���Ľ�]`�ҵ�ָ�������е�ָ���ֲ�����������ҵ����򷵻� value
---@param func_name string @������
---@param local_name string @�ֲ�������
---@param isset nil|boolean @�Ƿ��� setlocalvalue ����Ҫʹ�õ�
function Debug.getlocalvalue__(func_name, local_name, isset)
    if (type(func_name) ~= 'string' and type(local_name) ~= 'string') then
        --error('< Please pass in the correct parameters >', 2);
        return nil;
    end
    local MATH_HUGE = math.huge;
    local MAX_LEVEL = 20; -- ������ջ��
    local MAX_INDEX = 20; -- ������������
    for level = 1, MAX_LEVEL do
        local info = debug.getinfo(level, 'n');
        if (info == nil) then
            -- �� print
            --io.write('< There is no function:`', tostring(func_name), '` >\n');
            return nil;
        else
            if (info.name == func_name) then
                for i = 1, MAX_INDEX do
                    local name, value = debug.getlocal(level, i);
                    if (name == nil) then
                        --io.write('< There is no local variable `', tostring(local_name), '` in function `', tostring(func_name), '` >\n');
                        return nil;
                    end
                    if (name == local_name) then
                        --io.write('< find the local variable `', tostring(local_name), '` in function `', tostring(func_name), '` >\n');
                        if (isset) then
                            return value, level, i;
                        end
                        return value;
                    end
                end
            end
        end
    end
    --io.write('< MAX_LEVEL:', tostring(MAX_LEVEL), ', MAX_INDEX:', MAX_INDEX, ' >\n');
    --io.write('< cannot find the local variable `', tostring(local_name), '` in function `', tostring(func_name), '` >\n');
    return nil;
end

---`[���Ľ�]`����ָ�������е�ָ���ֲ�������ֵ������ҵ��Ļ���
---@param func_name string
---@param local_name string
---@param new_value any @��ֵ
function Debug.setlocalvalue__(func_name, local_name, new_value)
    if (type(func_name) ~= 'string' or type(local_name) ~= 'string') then
        --error('< Please pass in the correct parameters! >', 2);
        return nil;
    end
    local value, level, i = self.getlocalvalue(func_name, local_name, true);
    if (level and i) then
        debug.setlocal(level - 1, i, new_value) -- level - 1 ������
    end
end

---`[���Ľ�]`�ҵ�ָ������/�հ���ָ������������ҵ��˾ͷ��� value
---@param func_name string @�հ���
---@param upvalue_name string @������
---@param isset nil|boolean @�Ƿ��� setupvalue ����Ҫʹ�õ�
function Debug.getupvalue__(func_name, upvalue_name, isset)
    if (type(func_name) ~= 'string' or type(upvalue_name) ~= 'string') then
        --error('< Please pass in the correct parameters! >', 2);
        return nil;
    end
    local MATH_HUGE = math.huge;
    local MAX_LEVEL = 20; -- ������ջ��
    local MAX_INDEX = 20; -- ������������
    for level = 1, MAX_LEVEL do
        local info = debug.getinfo(level, 'nf');
        if (info == nil) then
            --io.write('< There is no function/closure:`', tostring(func_name), '` >\n');
            return nil;
        else
            if (info.name == func_name) then
                for i = 1, MAX_INDEX do
                    local name, value = debug.getupvalue(info.func, i);
                    if (name == nil) then
                        --io.write('< There is no upvalue `', tostring(upvalue_name), '` in function/closure `', tostring(func_name), '` >\n');
                        return nil;
                    end
                    if (name == upvalue_name) then
                        --io.write('< find the upvalue `', tostring(upvalue_name), '` in function/closure `', tostring(func_name), '` >\n');
                        if (isset) then
                            return value, info.func, i;
                        end
                        return value;
                    end
                end
            end
        end
    end
    --io.write('< MAX_LEVEL:', tostring(MAX_LEVEL), ', MAX_INDEX:', MAX_INDEX, ' >\n');
    --io.write('< cannot find upvalue `', tostring(upvalue_name), '` in function `', tostring(func_name), '` >\n');
    return nil;
end

---`[���Ľ�]`����ָ�������е�ָ���ֲ�������ֵ������ҵ��Ļ���
---@param func_name string
---@param upvalue_name string
---@param new_value any @��ֵ
function Debug.setupvalue__(func_name, upvalue_name, new_value)
    if (type(func_name) ~= 'string' or type(upvalue_name) ~= 'string') then
        --error('< Please pass in the correct parameters! >', 2);
        return nil;
    end
    local value, func, i = self.getupvalue(func_name, upvalue_name, true);
    if (func and i) then
        debug.setupvalue(func, i, new_value);
    end
end

-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------
-- TODO:�����ƣ�����ֱ��ʹ�õ��Կ��ṩ�� debug.traceback���ַ����� �Ľ��汾
---`[������]` ��ӡ ���øú���ʱ �Ļ�Ծջ��ջ����
function Debug.traceback()
    for level = 1, math.huge do
        local info = debug.getinfo(level, 'Sl');
        if (info == nil) then
            break ;
        end

        if (info.what == 'C') then
            print(string.format('%d\tC function', level));
        else
            print(string.format('%d\t[%s]:%d', level, info.short_src, info.currentline));
        end
    end
end

return Debug;