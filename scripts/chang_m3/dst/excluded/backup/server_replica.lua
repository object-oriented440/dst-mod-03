---
--- @author zsh in 2022/8/28 20:37
---

local function ondestdirty(self, inst)
    -- 这就是主机传过来的值
    self.dest = inst.replica.dest._dest:value();
end

local Table = require('m3.chang.modules.utils.Table');

-- tips: 写了replica组件，一定要用 AddReplicableComponent("dest") 函数注册一下，否则是不会生效的

---@class server_replica
local Server = Class(function(self, inst)
    self.inst = inst;

    self.dest = {};

    -- 定义一个字符串类型的通信变量
    -- 然后提供给主机类一个接口，主机调用：self._dest:set(value) 这个 value 就是主机传过来的值
    self._dest = net_string(inst.GUID, 'dest._dest', 'destdirty');
    -- 拥有该组件的实体的 GUID、唯一的一个名字、事件名

    if not TheWorld.ismastersim then
        -- 在客机监听这个事件
        inst:ListenEvent('destdirty', function(inst, data)
            --[[            ---@type server_replica
                        local self = inst.replica.server or Table.safety; -- 没必要，我可以直接传 self，闭包]]
            ondestdirty(self, inst);
        end);
    end

end)

---提供给主机类的接口，主机类调用该接口，然后客机监听到了对应事件，然后更新客机的数据
function Server:setDest(data)
    if TheWorld.ismastersim then
        self._dest:set(data);
    end
end