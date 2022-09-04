---
--- @author zsh in 2022/8/28 20:37
---


--[[
    说明流程：

    1、确定下来客机需要用到的主机的数据！然后每个数据设置一个 通信变量，建议设置成：self._xxx = net_bool|net_string|net_entity|net_ushortint|net_byte|net_tinybyte|net_smallbyte|net_float|net_event|net_smallbytearray

    2、客机类设置监听器，监听通信变量设置的事件（注意要设置成只在客机监听），然后提供给主机类对应的接口。

    3、主机组件在数据有变化的时候，调用客机的接口，set(xxx) 触发数据更新事件，在事件处理函数中 value() 赋值！

]]

local Table = require('m3.chang.modules.utils.Table');

---@class server
local Server = Class(function(self,inst)
    self.inst = inst;

    self.dest = {};
end)

function Server:setDest(data)
    self.dest = data;

    ---@type server_replica
    local server_replica = self.inst.server_replica;
    if (server_replica) then
        server_replica:setDest(data);
    end
end

function Server:getDest()
    return self.dest;
end


return Server;

