---
--- @author zsh in 2022/9/3 6:06
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
local Table = require('chang_m3.modules.utils.Table');

-- ģ���ʼ��
local Load = {};
local self = Load;

---nil: �ļ������ڣ�string������ʧ�ܣ�function���ļ����ڣ����﷨���󣬿ɳ��Լ���
---@param path string
---@return nil|string|function
function Load.loadfile(path)
    local f, msg = loadfile(path);
    if (not f) then
        print('Load.loadfile --> ERROR!!!', msg);
        if (string.find(msg, 'No such file or directory')) then
            return nil;
        end
        return msg;
    end
    return f;
end

-- ���� pcall
-- 1��f �ǿ��Թ��ɱհ��ģ�Ҳ����ͨ�����εķ�ʽ��arg1,... ���� f �Ĳ���
-- 2��pcall �ǰ�ȫģʽ������ִ�У�֪����������pcall ��ֹ�������ᱨ��

---����ģʽ���ú��� f����ִ���������򷵻� f ��ȫ����������򷵻� nil
---@param f function
function Load.pcall(f, arg1, ...)
    local args = Table.pack(pcall(f, arg1, ...));
    local ok = args[1];
    local results = Table.pop_front(args);

    if (not ok) then
        print('Load.pcall --> ERROR!!!', results[1]);
        return nil;
    else
        return Table.unpack(results);
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

---���� changpcall ��ͬ��ֻ�Ƕ��˸���Ϣ������� `msgh`
---@param f function
---@param msgh function
function Load.xpcall(f, msgh, arg1, ...)
    local old_msgh = msgh;
    msgh = function(msg--[[��Ȼ����ֻ��һ�������ǿ��Թ��ɱհ�ѽ��]])
        -- ע�������Ǵ���ģ��ɱ䳤������Ҫ���ⲿת�ɱ�Ȼ�󹹳ɱհ�ʹ�ã�
        -- print('msgh >',...);
        print('Load.xpcall --> ERROR!!!', msg);
        if (old_msgh and type(old_msgh) == 'function') then
            old_msgh(msg);
        end
    end

    -- NOTE: ֱ�ӷ��� status �� ���з���ֵ��msg ������ msgh���������ˣ�
    local results = Table.pack(xpcall(f, msgh, arg1, ...));

    if (not results[1]) then
        return nil;
    end

    return Table.unpack(Table.pop_front(results));
end

--[[do
    Load.xpcall(function()
        a = a + 1;
    end, nil, 1, 2, 3);
    return ;
end]]

--[[do
    -- Test code
    print(Load:changxpcall(function(...)
        --a = 'a';
        --b = a * c;
        return 'a', 'b', 'c', ...;
    end, nil, 1, 2, 3, 4, 5));
end]]

-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------
-- ����Ѿ��Ҳ������򵥵Ľ����������ʹ�� load ����
-- ���ܺ��� load �Ĺ��ܺ�ǿ�󣬵�����Ӧ�ý�����ʹ�á���Ϊ�����������ѡ�ĺ������ԣ�
-- �ú����Ŀ����ϴ��ҿ��ܻ������������⡣
---`[���á����Ľ�]`��дһ���ú����� dostring ����
function Load.dostring(chunk, chunkname, mode, env)
    env = env or _G; -- ��������ģ���ռ�����󣬳������⣡��û��Ҫ��env Ĭ���� ȫ�ֻ��� _G��
    local f, msg = load(chunk, chunkname, mode, env);
    if (not f) then
        print('ERROR!!!', msg);
    else
        return f();
    end

    --assert(load(chunk, chunkname, mode, env))();
end

--[[do
    -- Test code
    i = 0;
    ---@language Lua
    local f, msg = load([=[
        i=i+1;
    ]=], nil, nil, _ENV);
    f();

    print(i);

    env = 'test';
    local f,msg = load(function()
        _ENV = _G;

    end)

    print(env);
end]]

-- FIXME: dst �� Lua �汾Ϊ 5.1��֮�� EmmyLua �� language level ��Ϊ 5.1����Ȼ����ȫ
-- TODO: ȥ�˽�һ�� dofile��load��loadfile��pcall��pxcall ����Ĵ���Ļ����Ƿ���ⲿһ�����Ƿ�ͬ�����Թ��ɱհ�������
-- TODO: ִ��ʱ�Ƿ�����޸��ڴ����ݣ�������ȫ�ֱ����߾ֲ���������
---`[��ʵ�֡�������������]`
function Load.ploadcall(chunk, chunkname, mode, env, arg1, ...)
    -- ֱ�ӽ��������ó� _G����ΪûŪ�����ĵ�ģ��� env ��������ʵ���໹�� Lua �� _ENV �ƺ�Ū�Ĳ���̫������
    -- load ����˵�ǣ�Ĭ��Ϊȫ�ֻ������������ȫ�ֻ���ָ���ǲ��� _G �أ�
    -- _G ��ʲô�أ�����ȫ�ֻ�����
    env = env or _G;

    local f, msg = load(chunk, chunkname, mode, env);

end

--[[do
    -- Test code
    -- _ENV = _G;
    local x = 2;
    -- Test code
    local f, msg = load('print("hello");print(_ENV.x);x=1;');
    print(f);
    f();
    print(x);
    return ;
end]]

--[[do
    -- Test code
    -- ���� do ... end Ϊһ��������������ô load ������ʵľ��� _G ��
    -- ���������������� _ENV������ i ���� _G ����� i������ _ENV ����� i
    -- ���� _G ����������ȫ�ֱ������������õ� _ENV Ϊ�ֲ�ȫ�ֱ�����
    local f = load('i=i+1');

    -- �����
    _G.i=0;
    f();print(_G.i);
    f();print(_G.i);
    -- ���������� _ENV �����汨��Ĭ�� _ENV = _G �ģ���
    i=0;
    f();print(i);
    f();print(i);
    return;
end]]

return Load;