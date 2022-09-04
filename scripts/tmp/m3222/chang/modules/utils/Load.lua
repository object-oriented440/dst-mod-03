---
--- @author zsh in 2022/8/21 13:45
--- dofile、load、loadfile、pcall、xpcall

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- 导入部分
local Table = require('m3.chang.modules.utils.Table');

local Load = {};

---@param path string
---@return nil|string|function @ nil: 文件不存在，string：编译失败，function：文件存在，无语法错误，可尝试加载
function Load:changloadfile(path)
    local f, msg = loadfile(path); -- xpcall(f,debug.traceback,arg1,...)
    if (not f) then
        print('ERROR!!!', msg);
        if (string.find(msg, 'No such file or directory')) then
            return nil;
        end
        return msg;
    end
    return f;
end

-- FIXME: dst 的 Lua 版本为 5.1，之后将 EmmyLua 的 language level 改为 5.1，不然不安全
-- TODO: 去了解一下 dofile、load、loadfile、pcall、pxcall 里面的代码的环境是否和外部一样（是否同样可以构成闭包！），
-- TODO: 执行时是否可以修改内存数据！（比如全局表，或者局部变量！）
function Load:ploadcall(chunk, chunkname, mode, env, arg1, ...)
    do
        -- DoNothing
        return;
    end

    local f, msg = load(chunk, chunkname, mode, env);
    if (not (chunkname and mode and env)) then
        -- TODO:
    end
    if (not f) then
        local func_data = debug.getinfo(2, 'Sl');
        print('ERROR!!!', msg, tostring(func_data.short_src) .. ':' .. tostring(func_data.currentline));
    else
        local ok, res = pcall(f);
        if (not ok) then
            print('ERROR!!!', res);
        else
            return res;
        end
    end
end

--[[do
    local x = 2;
    -- Test code
    local f, msg = load('print("hello");print(_ENV.x);x=1;');
    print(f);
    f();
    print(x);
    return ;
end]]

function Load:changpcall(f, arg1, ...)
    local args = Table:pack(pcall(f, arg1, ...));
    local ok = args[1];
    local results = Table:pop_front(args);

    if (not ok) then
        print('pcall --> ERROR!!!', results[1]);
    else
        return Table:unpack(results);
    end
end

--[[do
    -- Test code
    print(Load:changpcall(function(...)
        a = 'a';
        b = a * c;
        return 'a', 'b', 'c', ...;
    end, 1, 2, 3, 4, 5));
end]]

function Load:changxpcall(f, msgh, ...)
    --msgh = type(msgh) == 'function' and msgh or debug.traceback; -- debug.traceback 直接 error 了
    msgh = type(msgh) == 'function' and msgh or function(msg)
        -- 参数只有一个
        print('xpcall --> ERROR!!!', msg);
    end

    -- NOTE: 直接返回 status 和 所有返回值！msg 传给了 msgh，不返回了！
    local results = Table:pack(xpcall(f, msgh, ...));

    if (results[1]) then
        return Table:unpack(Table:pop_front(results));
    end
end

--[[do
    -- Test code
    print(Load:changxpcall(function(...)
        --a = 'a';
        --b = a * c;
        return 'a', 'b', 'c', ...;
    end, nil, 1, 2, 3, 4, 5));
end]]

-- 如果已经找不到更简单的解决方法后，再使用 load 函数
---编写一个用后即弃的 dostring 函数
function Load:dostring(chunk, chunkname, mode, env)
    local f, msg = load(chunk, chunkname, mode, env);
    if (not f) then
        print('ERROR!!!', msg);
    else
        return f();
    end

    --assert(load(chunk, chunkname, mode, env))();
end

return Load;
 