---
--- @author zsh in 2022/8/26 22:47
---


local Date = require('m3.chang.modules.utils.Date');
local Math = require('m3.chang.modules.utils.Math');

local DST = {};

---���ִ�иú������ļ����޺�׺��
---@return string
function DST:getFileNameNoExtension(stackLevel)
    stackLevel = stackLevel or 2;

    local debugInfo = debug.getinfo(stackLevel, 'S');
    local source = debugInfo.source;
    local filename = string.sub(source, string.find(source, '[^/|\\]*$'));
    return (string.gsub(filename, '%.lua', '')); -- �Ӹ����ţ���Ϊ string.gsub ����������ֵ
end


---��Ԥ���������ֵ�����������
---@type fun(inst:table):void
---@param inst table
function DST:arrangeContainer(inst)
    if not (inst and inst.components.container) then
        -- not: ȡ��
        return ;
    end

    ---@type container
    local container = inst.components.container;

    local slots = container.slots;

    local keys = {};

    -- pairs �������
    for k, _ in pairs(slots) do
        keys[#keys + 1] = k;
    end
    table.sort(keys);

    -- ipairs ��˳���
    for k, v in ipairs(keys) do
        if (k ~= v) then
            -- ���ڿն�
            local item = container:RemoveItemBySlot(v);
            container:GiveItem(item, k); -- TODO:��������ѵ����޻ᷢ��ʲô�� Answer: �����
        end
    end
    -- ��ʱ��slot �����ڿն�
    slots = container.slots;

    -- �ն�������ϣ�����Ԥ��������ֽ����ֵ���
    table.sort(slots, function(entity1, entity2)
        local a, b = tostring(entity1.prefab), tostring(entity2.prefab);

        --[[        -- ���Ԥ��������ĩβ�������֣��ҳ�ĩβ�����⣬��ȣ�����Ŵ�С����
                -- NOTE: û��Ҫ����Ϊ�ַ��������жϴ�С
                local prefix_name1,num1 = string.match(a, '(.-)(%d+)$');
                local prefix_name2,num2 = string.match(b, '(.-)(%d+)$');
                if (prefix_name1 == prefix_name2 and num1 and num2) then
                    return tonumber(num1) < tonumber(num2);
                end]]

        return a < b and true or false; -- �����Լ����
    end)

    -- ��ʱ��slots �Ѿ�������ˣ���ʼ����
    for i, v in ipairs(slots) do
        local item = container:RemoveItemBySlot(i);
        container:GiveItem(item); -- slot == nil�������ÿһ�����Ӱ� item ����ȥ��item == nil������ true
    end

end

---���Ĳ���
---@param inst table @�����ĵ�Ԥ����
function DST:consumeMaterial(inst)
    if (inst) then
        ---@type stackable
        local stackable = inst.components.stackable;

        if (stackable) then
            stackable:Get():Remove();
        else
            inst:Remove();
        end
    end
end


---ת�������ڵ�Ԥ����
---@param old table
---@param new table
function DST:transferContainerAllItems(src, dest)
    ---@type container
    local src_container = src and src.components.container;

    ---@type container
    local dest_container = dest and dest.components.container;

    if (src_container and dest_container) then
        for i = 1, src_container.numslots do
            local item = src_container:RemoveItemBySlot(i);
            dest_container:GiveItem(item);
        end
    end

end

return DST;