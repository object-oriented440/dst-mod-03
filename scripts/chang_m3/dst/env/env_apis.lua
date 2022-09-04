---
--- @author zsh in 2022/9/3 21:10
---

-- 导入部分
local Tool = require('chang_m3.dst.modtool');
local Table = require('chang_m3.modules.utils.Table');

-- 模块初始化
local envAPI = {};
local self = envAPI;

local env = Tool:getModENV();

---@param custom_actions table
---@param component_actions table
function envAPI.addCustomActions(custom_actions, component_actions)
    --[[
        execute = nil|false|其他 true,,
        id = '', -- 动作 id，需要全大写字母
        str = '', -- 游戏内显示的动作名称

        ---动作触发时执行的函数，注意这是 server 端
        fn = function(act) ... return ture|false|nil; end, ---@param act BufferedAction,

        actiondata = {}, -- 需要添加的一些动作相关参数，比如：优先级、施放距离等
        state = '', -- 要绑定的 SG 的 state
    ]]
    custom_actions = custom_actions or {};

    --[[
        actiontype = '', -- 场景，'SCENE'|'USEITEM'|'POINT'|'EQUIPPED'|'INVENTORY'|'ISVALID'
        component = '', -- 指的是 inst 的 component，不同场景下的 inst 指代的目标不同，注意一下
        tests = {
            -- 允许绑定多个动作，如果满足条件都会插入动作序列中，具体会执行哪一个动作则由动作优先级来判定。
            {
                execute = nil|false|其他 true,
                id = '', -- 动作 id，同上

                ---注意这是 client 端
                testfn = function() ... return ture|false|nil; end; -- 参数根据 actiontype 而不同！
            },
        }
    ]]
    component_actions = component_actions or {};

    for _, data in pairs(custom_actions) do
        if (data.execute ~= false and data.id and data.str and data.fn and data.state) then
            data.id = string.upper(data.id);

            -- 添加自定义动作
            env.AddAction(data.id, data.str, data.fn);

            if (type(data.actiondata) == 'table') then
                for k, v in pairs(data.actiondata) do
                    ACTIONS[data.id][k] = v;
                end
            end

            -- 添加动作驱动行为图
            env.AddStategraphActionHandler("wilson", ActionHandler(ACTIONS[data.id], data.state));
            env.AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS[data.id], data.state));
        end
    end

    for _, data in pairs(component_actions) do
        if (data.actiontype and data.component and data.tests) then
            -- 添加动作触发器（动作和组件绑定）
            env.AddComponentAction(data.actiontype, data.component, function(...)
                data.tests = data.tests or {};
                for _, v in pairs(data.tests) do
                    if (v.execute ~= false and v.id and v.testfn and v.testfn(...)) then
                        table.insert((select(-2, ...)), ACTIONS[v.id]);
                    end
                end
            end)
        end
    end

end

-- TODO:
function envAPI.modifyOldActions(old_actions)
    --[[

    ]]
    old_actions = old_actions or {};

    for _, data in pairs(old_actions) do
        if (data.execute ~= false and data.id) then
            local action = ACTIONS[data.id];

            if (type(data.actiondata) == 'table') then
                for k, v in pairs(data.actiondata) do
                    action[k] = v;
                end
            end

            if (type(data.state) == 'table' and action) then
                local testfn = function(sg)
                    local old_handler = sg.actionhandlers[action].deststate;
                    sg.actionhandlers[action].deststate = function(doer, action)
                        if data.state.testfn and data.state.testfn(doer, action) and data.state.deststate then
                            return data.state.deststate(doer, action);
                        end
                        return old_handler(doer, action);
                    end
                end

                if data.state.client_testfn then
                    testfn = data.state.client_testfn;
                end

                env.AddStategraphPostInit("wilson", testfn);
                env.AddStategraphPostInit("wilson_client", testfn);
            end
        end
    end
end

-- FIXME: 本来是打算生成对应的预制物，然后获得预制物的 build 的，但是执行此处时，预制物尚且不存在。。。
---找到预制物的 `build`，记得判空
---@param name string @预制物名
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

---让 `prefabs` 预制物可以换 `name` 预制物的皮肤（前提是：prefabs 的 build == name 预制物的）
---@param name string @预制物名
---@param prefabs string @预制物表
function envAPI.reskin(name, build, prefabs)
    --[[    local GLOBAL = env.GLOBAL; -- tips：没必要，因为这个 GLOBAL 就是 _G
        local rawget = GLOBAL.rawget;
        local rawset = GLOBAL.rawset;]]

    -- FIXME:
    local build = getBuild(name) or build;

    if (build) then
        local fn_name = name .. '_clear_fn';
        local fn = rawget(_G, fn_name);
        if (not fn) then
            print('`' .. fn_name .. '` global function does not exist!');
        else
            rawset(_G, fn_name, function(inst, def_build)
                if not (Table.containsValue(prefabs, inst.prefab)) then
                    return fn(inst, def_build);
                else
                    inst.AnimState:SetBuild(build);
                end
            end);

            if ((rawget(_G, 'PREFAB_SKINS') or {})[name] and (rawget(_G, 'PREFAB_SKINS_IDS') or {})[name]) then
                for _, reskin_prefab in ipairs(prefabs) do
                    PREFAB_SKINS[reskin_prefab] = PREFAB_SKINS[name];
                    PREFAB_SKINS_IDS[reskin_prefab] = PREFAB_SKINS_IDS[name];
                end
            end
        end
    end
end

---添加配方
---@param recipes table
function envAPI.addRecipes(recipes)
    if (not env or type(recipes) ~= 'table') then
        return ;
    end
    local S, F = Table.security.getSecurities();
    local AddRecipe2 = env.AddRecipe2 or S;

    for _, v in pairs(recipes) do
        if (v.CanMake ~= false) then
            AddRecipe2(v.name, v.ingredients, v.tech, v.config, v.filters);
        end
    end
end




-------------------------------------------------------------------------------------------------
-- [[ 弃用 ]]
-------------------------------------------------------------------------------------------------


return envAPI;