---
--- @author zsh in 2022/8/26 22:46
---



local KEY = require('m3.chang.dst.key');

local Action = {};

---@param env table
---@param custom_actions table
---@param component_actions table
function Action:addCustomActions(env, custom_actions, component_actions)
    if (not type(env) == 'table') then
        return ;
    end
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

function Action:modifyOldActions(env, old_actions)
    if (not type(env) == 'table') then
        return ;
    end
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

return Action;