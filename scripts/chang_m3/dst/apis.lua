---
--- @author zsh in 2022/9/3 21:20
---

-- 导入部分
local Table = require('chang_m3.modules.utils.Table');
local Load = require('chang_m3.modules.utils.Load');

local Tool = require('chang_m3.dst.modtool');

-- 模块初始化
local API = {};
local self = API;

---物品优先入容器功能
---@field itemIntoContainerFirst fun(inventory:inventory,priority:table):void
---@field setListenForEvent fun(container:EntityScript):void
API.ItemIntoContainerFirst = {
    ---@param inventory inventory
    itemIntoContainerFirst = function(inventory, priority)
        if (Tool.IsOverTime()) then
            return ;
        end

        local S, F = Table.security.getSecurities();

        local old_GiveItem = inventory.GiveItem;

        inventory.GiveItem = function(self, inst, slot, src_pos)
            if inst and (inst.components.inventoryitem == nil or not inst:IsValid()) then
                print("Warning: Can't give item because it's not an inventory item.")
                return
            end

            local eslot = self:IsItemEquipped(inst)

            if eslot then
                self:Unequip(eslot) -- 卸载装备
            end

            local new_item = inst ~= self.activeitem
            if new_item then
                for k, v in pairs(self.equipslots) do
                    if v == inst then
                        new_item = false
                        break
                    end
                end
            end

            if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner ~= self.inst then
                inst.components.inventoryitem:RemoveFromOwner(true)
            end

            local objectDestroyed = inst.components.inventoryitem:OnPickup(self.inst, src_pos)
            if objectDestroyed then
                return
            end

            local can_use_suggested_slot = false

            if not slot and inst.prevslot and not inst.prevcontainer then
                slot = inst.prevslot
            end
            if not slot and inst.prevslot and inst.prevcontainer then
                if inst.prevcontainer.inst:IsValid() and inst.prevcontainer:IsOpenedBy(self.inst) then
                    local item = inst.prevcontainer:GetItemInSlot(inst.prevslot)
                    if item == nil then
                        if inst.prevcontainer:GiveItem(inst, inst.prevslot) then
                            return true
                        end
                    elseif item.prefab == inst.prefab and item.skinname == inst.skinname and
                            item.components.stackable ~= nil and
                            inst.prevcontainer:AcceptsStacks() and
                            inst.prevcontainer:CanTakeItemInSlot(inst, inst.prevslot) and
                            item.components.stackable:Put(inst) == nil then
                        return true
                    end
                end
                inst.prevcontainer = nil
                inst.prevslot = nil
                slot = nil
            end

            if slot then
                local olditem = self:GetItemInSlot(slot)
                can_use_suggested_slot = slot ~= nil
                        and slot <= self.maxslots
                        and (olditem == nil or (olditem and olditem.components.stackable and olditem.prefab == inst.prefab and olditem.skinname == inst.skinname))
                        and self:CanTakeItemInSlot(inst, slot)
            end

            --[[ 此处这个 if 判断语句是我的内容，其余是官方代码 ]]
            if (not slot and not inst.dst_mx_priority_container_flag) then

                local opencontainers = self.opencontainers;

                local vip_containers = {};
                local priority_containers = priority;

                for c, v in pairs(opencontainers) do
                    if (c and v) then
                        if (Table:containsKey(priority_containers, c.prefab)) then
                            vip_containers[#vip_containers + 1] = c;
                        end
                    end
                end

                table.sort(vip_containers, function(entity1, entity2)
                    local p1, p2;
                    if (entity1 and entity2) then
                        p1, p2 = priority_containers[entity1.prefab], priority_containers[entity2.prefab];
                    end
                    if (p1 and p2) then
                        return p1 > p2;
                    end
                end);

                for _, c in ipairs(vip_containers) do
                    ---@type container
                    local container = c and c.components.container;
                    if (container and container:IsOpen()) then
                        if (container:GiveItem(inst, nil, src_pos)) then
                            -- tips: self.inst 是人物，PushEvent 可以发出声音
                            -- self.inst:PushEvent("gotnewitem", { item = inst, slot = slot })

                            if (TheFocalPoint and TheFocalPoint.SoundEmitter) then
                                F(TheFocalPoint.SoundEmitter, PlaySound, "dontstarve/HUD/collect_resource");
                            end
                            return true;
                        end
                    end
                end
            end
            return old_GiveItem(self, inst, slot, src_pos);
        end
    end,
    ---@param inst EntityScript
    redirectItemFlag = function(inst)
        if (not (inst and inst.components.container)) then
            return 2 ^ 31 - 1;
        end

        ---@type container
        local container = inst.components.container;

        for _, v in pairs(container.slots) do
            v.dst_mx_priority_container_flag = true;
        end

        if (container.numslots < 47) then
            return 1;
        else
            return 2;
        end
    end,
    clearAllFlag = function(inst)
        ---@type container
        local container = inst.components.container;
        if (container) then
            for _, v in pairs(container.slots) do
                v.dst_mx_priority_container_flag = nil;
            end
        end
    end,
    ---@param inst EntityScript
    setListenForEvent = function(inst)
        inst:ListenForEvent('dropitem', function(inst, data)
            inst:DoTaskInTime(0, function()
                if (data and data.item) then
                    data.item.dst_mx_priority_container_flag = nil;
                end
            end)
        end)
        inst:ListenForEvent('itemlose', function(inst, data)
            inst:DoTaskInTime(0, function()
                if (data and data.prev_item) then
                    data.prev_item.dst_mx_priority_container_flag = nil;
                end
            end)
        end)
        inst:ListenForEvent('gotnewitem', function(inst, data)
            if (data and data.item) then
                data.item.dst_mx_priority_container_flag = true;
            end
        end)
        inst:ListenForEvent('itemget', function(inst, data)
            if (data and data.item) then
                data.item.dst_mx_priority_container_flag = true;
            end
        end)
    end
}

---获得执行该函数的文件的无后缀名
---@return string
function API.getFileNameNoExtension(stackLevel)
    stackLevel = stackLevel or 2;

    local debugInfo = debug.getinfo(stackLevel, 'S');
    local source = debugInfo.source;
    local filename = string.sub(source, string.find(source, '[^/|\\]*$'));
    return (string.gsub(filename, '%.lua', '')); -- 加个括号，因为 string.gsub 有两个返回值
end

---回溯 level 层文件夹，类似 ../../../
local function getupfilename(level)
    level = level or 3;

    local source = debug.getinfo(2, 'S').source;

    local source_cuts = {};

    for cut in string.gmatch(source, '[^@][^/\\]+') do
        table.insert(source_cuts, string.find(cut, '[/\\]') and string.sub(cut, 2) or cut);
    end

    return source_cuts[#source_cuts - level];
end

---将预制物命名为：'dst_' .. 模组标志字符 .. '_' .. 文件名 的格式！
---@return string
function API.namedPrefab()
    local name = self.getFileNameNoExtension(3); -- xxx.chang.dst
    local folder_name = getupfilename(2);
    folder_name = string.match(folder_name,'chang_(.*)$') or 'template';
    return 'dst_' .. folder_name .. '_' .. name;
end

do
    -- Test code
    print(self.namedPrefab());
    return;
end

---按预制物名字字典序整理容器
---@type fun(inst:table):void
---@param inst table
function API.arrangeContainer(inst)
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
function API.consumeMaterial(inst)
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
---@param src table
---@param dest table
function API.transferContainerAllItems(src, dest)
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

-- 注意一下：Prefab 这个类执行的时候，做了那些事情。
--（我依稀的记得，有个函数里面的错误 `按道理来说，不会出现函数里面的错误吧`。是编译错误还是运行错误？）

-- 注意了！返回值中不要有 nil！获取不到！用的是 ipairs！也就是说，和 prefab 有关的文件要么不导入，要么就导入。
-- 不要 if (true) then return nil; end

---在安全模式下导入预制物
---@param filepaths table @文件路径
---@return table[] @预制物列表
function API.loadPrefabs(filepaths)
    local prefabs_list = {};
    for _, filename in ipairs(filepaths) do
        if (not string.find(filename, '.lua$')) then
            filename = filename .. '.lua';
        end
        local f, msg = loadfile(filename); -- 找不到文件路径不会报错！
        if (not f) then
            print('ERROR!!!', msg);
        else
            for _, prefab in pairs({ Load.xpcall(f) }) do
                if (type(prefab) == 'table' and prefab.is_a and prefab:is_a(Prefab)) then
                    table.insert(prefabs_list, prefab);
                end
            end
        end
    end
    return prefabs_list;
end

local mytags = {};
---@alias entity EntityScript
---@param inst entity
---@param tag string
function API.AddTag(inst, tag)
    if (type(inst) ~= 'table' or type(tag) ~= 'string') then
        print('>', inst, tag);
        print('ERROR!!!', 'please check the params!');
        return ;
    end
    if (not inst:HasTag(tag)) then
        mytags[tag] = true;
        inst:AddTag(tag);
    end
end

---@param inst EntityScript
---@param tag string
function API.RemoveTag(inst, tag)
    if (type(inst) ~= 'table' or type(tag) ~= 'string') then
        print('>', inst, tag);
        print('ERROR!!!', 'please check the params!');
        return ;
    end
    if (mytags[tag]) then
        mytags[tag] = nil;
        inst:RemoveTag(tag);
    end
end
-------------------------------------------------------------------------------------------------
-- [[ 弃用 ]]
-------------------------------------------------------------------------------------------------


return API;