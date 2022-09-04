---
--- @author zsh in 2022/8/27 0:42
---

--[[do
    local a = function()
    end;
    local b = a;
    --b = nil;
    print(a, b);

    -- ���Է��ֺ������е�ַ�ģ��������Ǵ�ֵ��

    return;
end]]

--[[local fns = {};
local counters = {};
debug.sethook(function()
    local f = debug.getinfo(2, 'f').func;
    local name = debug.getinfo(2, 'n').name;

    if (not fns[f]) then
        fns[f] = name;
        counters[f] = 1;
    else
        counters[f] = 2;
        -- ����������Ļ������º����������ˣ�Ҳ�ᱨ����Ϊ��һ��ִ�е������Ѿ��������ˡ�
        if (fns[f] == 'modifyPackagePath') then
            error('please require this module, do not dofile this module!', 3);
            -- stackLevel == 2 ʱ�����Է��֣�hook �ĺ�����mask = 'c'�����ں������õĿ�ͷ���ã�
        end
    end
end, 'c');]]

-- ��Ч������
if (true) then
    return nil;
end

local function modifyPackagePath(level, stackLevel)
    level = level or 2;
    stackLevel = stackLevel or 2;

    --print(package.path);

    --local Table = require('chang_m3.modules.utils.Table');

    -- ��ʱ��package.path �ĽṹΪ��`;xxx;xxx;xxx`

    -- �洢�� package.path �н�ȡ�Ĳ��֣�<';xxx/xxx/',number>
    local prefixs = {};

    for p in string.gmatch(package.path, ';[^;]*') do
        --print(p);

        local i = string.find(p, '?.lua');
        if (i) then
            prefixs[string.sub(p, 1, i - 1)] = i;
        end
    end

    -- �ļ��� source ·��
    local source = debug.getinfo(stackLevel, 'S').source;

    -- �洢����ȡ�� source�����ڲ��ң�<'%w'> ����
    local source_cuts = {};
    for cut in string.gmatch(source, '[^@][^/\\]+') do
        --print(cut);

        table.insert(source_cuts, string.find(cut, '[/\\]') and string.sub(cut, 2) or cut);
    end

    --Table:print(source_cuts);

    -- ��ǰ�ļ���Ը�Ŀ¼���ڵĲ�Σ� require ������ IDE ���õ� Sources Root ·����
    local find = source_cuts[#source_cuts - level];
    --print(find);

    -- ��� package.path
    for v, i in pairs(prefixs) do
        package.path = (v .. find .. string.sub(v, -1, -1) .. '?.lua') .. package.path;
    end

    --for p in string.gmatch(package.path, ';[^;]*') do
    --    print(p);
    --end
end

modifyPackagePath(3);

--debug.sethook();

return true;

