---
--- @author zsh in 2022/8/18 15:25
--- 关于调试库

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });


-- 导入部分
require('debug'); -- 显示加载一下调试库
print('The debug library is used');

local Debug = {};

-- TODO:待完善，建议直接使用调试库提供的 debug.traceback（字符串） 改进版本
---打印 调用该函数时 的活跃栈的栈回溯
function Debug:traceback()
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

-- getlocalvalue
---找到指定函数中的指定局部变量，如果找到了则返回 value
---@param func_name string @函数名
---@param local_name string @局部变量名
---@param isset nil|boolean @是否是 setlocalvalue 函数要使用的
function Debug:getlocalvalue(func_name, local_name, isset)
    if (type(func_name) ~= 'string' and type(local_name) ~= 'string') then
        --error('< Please pass in the correct parameters >', 2);
        return nil;
    end
    local MATH_HUGE = math.huge;
    local MAX_LEVEL = 20; -- 最大回溯栈数
    local MAX_INDEX = 20; -- 最大变量索引数
    for level = 1, MAX_LEVEL do
        local info = debug.getinfo(level, 'n');
        if (info == nil) then
            -- 用 print
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

-- setLocalInSpecifiedFunction
---设置指定函数中的指定局部变量的值（如果找到的话）
---@param func_name string
---@param local_name string
---@param new_value any @新值
function Debug:setlocalvalue(func_name, local_name, new_value)
    if (type(func_name) ~= 'string' or type(local_name) ~= 'string') then
        --error('< Please pass in the correct parameters! >', 2);
        return nil;
    end
    local value, level, i = self:getlocalvalue(func_name, local_name, true);
    if (level and i) then
        debug.setlocal(level - 1, i, new_value) -- level - 1 ！！！
    end
end

-- getupvalueOfSpecifiedClosure
---找到指定函数/闭包的指定变量，如果找到了就返回 value
---@param func_name string @闭包名
---@param upvalue_name string @变量名
---@param isset nil|boolean @是否是 setupvalue 函数要使用的
function Debug:getupvalue(func_name, upvalue_name, isset)
    if (type(func_name) ~= 'string' or type(upvalue_name) ~= 'string') then
        --error('< Please pass in the correct parameters! >', 2);
        return nil;
    end
    local MATH_HUGE = math.huge;
    local MAX_LEVEL = 20; -- 最大回溯栈数
    local MAX_INDEX = 20; -- 最大变量索引数
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

-- setupvalueOfSpecifiedClosure
---设置指定函数中的指定局部变量的值（如果找到的话）
---@param func_name string
---@param upvalue_name string
---@param new_value any @新值
function Debug:setupvalue(func_name, upvalue_name, new_value)
    if (type(func_name) ~= 'string' or type(upvalue_name) ~= 'string') then
        --error('< Please pass in the correct parameters! >', 2);
        return nil;
    end
    local value, func, i = self:getupvalue(func_name, upvalue_name, true);
    if (func and i) then
        debug.setupvalue(func, i, new_value);
    end
end

return Debug;