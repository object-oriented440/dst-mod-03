---
--- @author zsh in 2022/8/26 22:47
---


local Date = require('m3.chang.modules.utils.Date');
local Math = require('m3.chang.modules.utils.Math');

local DST = {};

---获得执行该函数的文件的无后缀名
---@return string
function DST:getFileNameNoExtension(stackLevel)
    stackLevel = stackLevel or 2;

    local debugInfo = debug.getinfo(stackLevel, 'S');
    local source = debugInfo.source;
    local filename = string.sub(source, string.find(source, '[^/|\\]*$'));
    return (string.gsub(filename, '%.lua', '')); -- 加个括号，因为 string.gsub 有两个返回值
end


---按预制物名字字典序整理容器
---@type fun(inst:table):void
---@param inst table
function DST:arrangeContainer(inst)
    if not (inst and inst.components.container) then
        -- not: 取反
        return ;
    end

    ---@type container
    local container = inst.components.container;

    local slots = container.slots;

    local keys = {};

    -- pairs 是随机的
    for k, _ in pairs(slots) do
        keys[#keys + 1] = k;
    end
    table.sort(keys);

    -- ipairs 是顺序的
    for k, v in ipairs(keys) do
        if (k ~= v) then
            -- 存在空洞
            local item = container:RemoveItemBySlot(v);
            container:GiveItem(item, k); -- TODO:如果超过堆叠上限会发生什么？ Answer: 会掉落
        end
    end
    -- 此时，slot 不存在空洞
    slots = container.slots;

    -- 空洞处理完毕，根据预制物的名字进行字典序
    table.sort(slots, function(entity1, entity2)
        local a, b = tostring(entity1.prefab), tostring(entity2.prefab);

        --[[        -- 如果预制物名字末尾存在数字，且除末尾数字外，相等，按序号大小排列
                -- NOTE: 没必要，因为字符串可以判断大小
                local prefix_name1,num1 = string.match(a, '(.-)(%d+)$');
                local prefix_name2,num2 = string.match(b, '(.-)(%d+)$');
                if (prefix_name1 == prefix_name2 and num1 and num2) then
                    return tonumber(num1) < tonumber(num2);
                end]]

        return a < b and true or false; -- 便于自己理解
    end)

    -- 此时，slots 已经排序好了，开始整理
    for i, v in ipairs(slots) do
        local item = container:RemoveItemBySlot(i);
        container:GiveItem(item); -- slot == nil，会遍历每一个格子把 item 塞进去，item == nil，返回 true
    end

end

---消耗材料
---@param inst table @被消耗的预制物
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


---转移容器内的预制物
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