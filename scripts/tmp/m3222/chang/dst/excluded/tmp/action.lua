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
        execute = nil|false|���� true,,
        id = '', -- ���� id����Ҫȫ��д��ĸ
        str = '', -- ��Ϸ����ʾ�Ķ�������

        ---��������ʱִ�еĺ�����ע������ server ��
        fn = function(act) ... return ture|false|nil; end, ---@param act BufferedAction,

        actiondata = {}, -- ��Ҫ��ӵ�һЩ������ز��������磺���ȼ���ʩ�ž����
        state = '', -- Ҫ�󶨵� SG �� state
    ]]
    custom_actions = custom_actions or {};

    --[[
        actiontype = '', -- ������'SCENE'|'USEITEM'|'POINT'|'EQUIPPED'|'INVENTORY'|'ISVALID'
        component = '', -- ָ���� inst �� component����ͬ�����µ� inst ָ����Ŀ�겻ͬ��ע��һ��
        tests = {
            -- ����󶨶�������������������������붯�������У������ִ����һ���������ɶ������ȼ����ж���
            {
                execute = nil|false|���� true,
                id = '', -- ���� id��ͬ��

                ---ע������ client ��
                testfn = function() ... return ture|false|nil; end; -- �������� actiontype ����ͬ��
            },
        }
    ]]
    component_actions = component_actions or {};

    for _, data in pairs(custom_actions) do
        if (data.execute ~= false and data.id and data.str and data.fn and data.state) then
            data.id = string.upper(data.id);

            -- ����Զ��嶯��
            env.AddAction(data.id, data.str, data.fn);

            if (type(data.actiondata) == 'table') then
                for k, v in pairs(data.actiondata) do
                    ACTIONS[data.id][k] = v;
                end
            end

            -- ��Ӷ���������Ϊͼ
            env.AddStategraphActionHandler("wilson", ActionHandler(ACTIONS[data.id], data.state));
            env.AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS[data.id], data.state));
        end
    end

    for _, data in pairs(component_actions) do
        if (data.actiontype and data.component and data.tests) then
            -- ��Ӷ���������������������󶨣�
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