---
--- @author zsh in 2022/8/28 20:37
---

local function ondestdirty(self, inst)
    -- �����������������ֵ
    self.dest = inst.replica.dest._dest:value();
end

local Table = require('m3.chang.modules.utils.Table');

-- tips: д��replica�����һ��Ҫ�� AddReplicableComponent("dest") ����ע��һ�£������ǲ�����Ч��

---@class server_replica
local Server = Class(function(self, inst)
    self.inst = inst;

    self.dest = {};

    -- ����һ���ַ������͵�ͨ�ű���
    -- Ȼ���ṩ��������һ���ӿڣ��������ã�self._dest:set(value) ��� value ����������������ֵ
    self._dest = net_string(inst.GUID, 'dest._dest', 'destdirty');
    -- ӵ�и������ʵ��� GUID��Ψһ��һ�����֡��¼���

    if not TheWorld.ismastersim then
        -- �ڿͻ���������¼�
        inst:ListenEvent('destdirty', function(inst, data)
            --[[            ---@type server_replica
                        local self = inst.replica.server or Table.safety; -- û��Ҫ���ҿ���ֱ�Ӵ� self���հ�]]
            ondestdirty(self, inst);
        end);
    end

end)

---�ṩ��������Ľӿڣ���������øýӿڣ�Ȼ��ͻ��������˶�Ӧ�¼���Ȼ����¿ͻ�������
function Server:setDest(data)
    if TheWorld.ismastersim then
        self._dest:set(data);
    end
end