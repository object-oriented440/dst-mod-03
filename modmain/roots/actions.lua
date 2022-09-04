---
--- @author zsh in 2022/8/29 3:44
---

local Locale = require('chang_m3.dst.locale');
local Text = Locale.getModText();

local envAPI = require('chang_m3.dst.env.env_apis');

local custom_actions = {
    ['DST_M3_HAMMER_CONTAINER_CHEST'] = {
        execute = true,
        id = 'DST_M3_HAMMER_CONTAINER_CHEST',
        str = Text.ACTION.Hammer,
        fn = function(act)
            local target, doer = act.target, act.doer;
            if (target and doer and target.dst_m3_onhammered) then
                target.dst_m3_onhammered(target, doer);
                return true;
            end
        end,
        state = 'domediumaction'
    }
}

local component_actions = {
    {
        actiontype = 'SCENE',
        component = 'workable',
        tests = {
            {
                execute = custom_actions['DST_M3_HAMMER_CONTAINER_CHEST'].execute,
                id = 'DST_M3_HAMMER_CONTAINER_CHEST',
                testfn = function(inst, doer, actions, right)
                    return inst and inst:HasTag('dst_m3_container_canharmmer') and right;
                end
            }
        }
    }
}

envAPI.addCustomActions(custom_actions, component_actions);

local old_actions = {
    {
        execute = true,
        id = "PICK", -- 采集
        actiondata = nil,
        state = {
            testfn = function(doer, action)
                if doer:HasTag("dst_m3_fast_picker") then
                    return true
                end
            end,
            deststate = function(doer, action)
                return "attack" --原：doshortaction
            end
        }
    },
    {
        execute = true,
        id = "HARVEST", -- 收获
        actiondata = nil,
        state = {
            testfn = function(doer, action)
                if doer:HasTag("dst_m3_fast_picker") then
                    return true
                end
            end,
            deststate = function(doer, action)
                return "attack"
            end
        }
    },
    {
        execute = true,
        id = "TAKEITEM", -- 拿东西
        actiondata = nil,
        state = {
            testfn = function(doer, action)
                if doer:HasTag("dst_m3_fast_picker") then
                    return true
                end
            end,
            deststate = function(doer, action)
                return "attack"
            end
        }
    },
}

envAPI.modifyOldActions(old_actions);

