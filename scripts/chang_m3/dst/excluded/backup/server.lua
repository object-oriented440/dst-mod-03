---
--- @author zsh in 2022/8/28 20:37
---


--[[
    ˵�����̣�

    1��ȷ�������ͻ���Ҫ�õ������������ݣ�Ȼ��ÿ����������һ�� ͨ�ű������������óɣ�self._xxx = net_bool|net_string|net_entity|net_ushortint|net_byte|net_tinybyte|net_smallbyte|net_float|net_event|net_smallbytearray

    2���ͻ������ü�����������ͨ�ű������õ��¼���ע��Ҫ���ó�ֻ�ڿͻ���������Ȼ���ṩ���������Ӧ�Ľӿڡ�

    3����������������б仯��ʱ�򣬵��ÿͻ��Ľӿڣ�set(xxx) �������ݸ����¼������¼��������� value() ��ֵ��

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

