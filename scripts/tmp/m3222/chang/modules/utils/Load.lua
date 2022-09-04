---
--- @author zsh in 2022/8/21 13:45
--- dofile��load��loadfile��pcall��xpcall

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
local Table = require('m3.chang.modules.utils.Table');

local Load = {};

---@param path string
---@return nil|string|function @ nil: �ļ������ڣ�string������ʧ�ܣ�function���ļ����ڣ����﷨���󣬿ɳ��Լ���
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

-- FIXME: dst �� Lua �汾Ϊ 5.1��֮�� EmmyLua �� language level ��Ϊ 5.1����Ȼ����ȫ
-- TODO: ȥ�˽�һ�� dofile��load��loadfile��pcall��pxcall ����Ĵ���Ļ����Ƿ���ⲿһ�����Ƿ�ͬ�����Թ��ɱհ�������
-- TODO: ִ��ʱ�Ƿ�����޸��ڴ����ݣ�������ȫ�ֱ����߾ֲ���������
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
    --msgh = type(msgh) == 'function' and msgh or debug.traceback; -- debug.traceback ֱ�� error ��
    msgh = type(msgh) == 'function' and msgh or function(msg)
        -- ����ֻ��һ��
        print('xpcall --> ERROR!!!', msg);
    end

    -- NOTE: ֱ�ӷ��� status �� ���з���ֵ��msg ������ msgh���������ˣ�
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

-- ����Ѿ��Ҳ������򵥵Ľ����������ʹ�� load ����
---��дһ���ú����� dostring ����
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
 