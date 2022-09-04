---
--- @author zsh in 2022/8/26 23:33
---

local Table = require('m3.chang.modules.utils.Table');
local Load = require('m3.chang.modules.utils.Load');
local DST = require('m3.chang.dst.tmp.dst');

local Prefab = {};


---���� level ���ļ��У����� ../../../
---@return string
local function getupfilename(level)
    level = level or 3;

    local source = debug.getinfo(2, 'S').source;

    local source_cuts = {};

    for cut in string.gmatch(source, '[^@][^/\\]+') do
        table.insert(source_cuts, string.find(cut, '[/\\]') and string.sub(cut, 2) or cut);
    end

    return source_cuts[#source_cuts - level];
end

---��Ԥ��������Ϊ��'dst_' .. ģ���־�ַ� .. '_' .. �ļ��� �ĸ�ʽ��
---@return string
function Prefab:namedPrefab()
    local name = DST:getFileNameNoExtension(3);
    local modname = getupfilename();
    return 'dst_' .. modname .. '_' .. name;
end

-- ע��һ�£�Prefab �����ִ�е�ʱ��������Щ���顣
--������ϡ�ļǵã��и���������Ĵ��� `��������˵��������ֺ�������Ĵ����`���Ǳ�����������д��󣿣�
---�ڰ�ȫģʽ�µ���Ԥ����
---@param filepaths table @�ļ�·��
---@return table @Ԥ�����б�
function Prefab:loadPrefabs(filepaths)
    local prefabs_list = {};
    for _, filename in ipairs(filepaths) do
        local f, msg = loadfile(filename); -- �Ҳ����ļ�·�����ᱨ��
        if (not f) then
            print('ERROR!!!', msg);
        else
            for _, prefab in ipairs({ Load:changxpcall(f, nil) }) do
                table.insert(prefabs_list, prefab);
            end
        end
    end
    return prefabs_list;
end

---����䷽
function Prefab:addRecipes(env, recipes)
    if (not env or type(recipes) ~= 'table') then
        return ;
    end
    local AddRecipe2 = env.AddRecipe2 or Table.safety;

    for _, v in pairs(recipes) do
        if (v.CanMake ~= false) then
            AddRecipe2(v.name, v.ingredients, v.tech, v.config, v.filters);
        end
    end
end

--do
--    -- Test code
--    Prefab:addRecipes({},{{}});
--end

---�ҵ�Ԥ����� `build`���ǵ��п�
---@param prefab string @Ԥ������
local function getBuild(name)
    local inst = SpawnPrefab(name);
    if (not inst) then
        print('prefab: `' .. name .. '` does not exist!');
        return nil;
    end
    local str = inst.entity:GetDebugString();
    inst:Remove();
    inst = nil;

    local bank, build, anim = string.match(str, 'bank: (.+) build: (.+) anim: .+:(.+) Frame');

    if (not build) then
        print('cannot find ' .. 'prefab: `' .. name .. '`\'s build!')
        return nil;
    end

    return build;
end

---�� `prefabs` Ԥ������Ի� `name` Ԥ�����Ƥ����ǰ���ǣ�prefabs �� build == name Ԥ����ģ�
---@param env table
---@param prefab string @Ԥ������
function Prefab:reskin(env, name, prefabs)
    if (not env or type(name) ~= 'string') then
        return ;
    end
    local GLOBAL = env.GLOBAL; -- tips��û��Ҫ����Ϊ��� GLOBAL ���� _G
    local rawget = GLOBAL.rawget;
    local rawset = GLOBAL.rawset;

    local build = getBuild(name);

    if (build) then
        local fn_name = name .. '_clear_fn';
        local fn = rawget(GLOBAL, fn_name);
        if (not fn) then
            print('`' .. fn_name .. '` global function does not exist!');
        else
            rawset(GLOBAL, fn_name, function(inst, def_build)
                if not (Table:containsValue(prefabs, inst.prefab)) then
                    return fn(inst, def_build);
                else
                    inst.AnimState:SetBuild(build);
                end
            end);

            if ((rawget(GLOBAL, 'PREFAB_SKINS') or {})[name] and (rawget(GLOBAL, 'PREFAB_SKINS_IDS') or {})[name]) then
                for _, reskin_prefab in ipairs(prefabs) do
                    GLOBAL.PREFAB_SKINS[reskin_prefab] = GLOBAL.PREFAB_SKINS[name];
                    GLOBAL.PREFAB_SKINS_IDS[reskin_prefab] = GLOBAL.PREFAB_SKINS_IDS[name];
                end
            end
        end
    end
end

return Prefab;