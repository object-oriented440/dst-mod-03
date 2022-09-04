---
--- @author zsh in 2022/8/29 23:15
---


---@param inst EntityScript
env.AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then
        return inst;
    end

    inst:AddComponent('dst_m3_pigman_killer');
end)

for _, pig in ipairs({ 'pigman', 'pigguard', 'moonpig' }) do
    ---@param inst EntityScript
    env.AddPrefabPostInit(pig, function(inst)

        if not TheWorld.ismastersim then
            return inst;
        end

        inst:ListenForEvent('death', function(inst, data)
            ---@type EntityScript
            local afflicter = data.afflicter;

            if (afflicter and afflicter:HasTag('dst_m3_pigman_killer')) then
                ---@type inventory
                local inventory = afflicter.components.inventory;
                ---@type lootdropper
                local lootdropper = inst.components.lootdropper;
                ---@type dst_m3_pigman_killer
                local pigman_killer = afflicter.components.dst_m3_pigman_killer;

                local loots = lootdropper:GenerateLoot();
                for _, loot in ipairs(loots) do
                    local ent = SpawnPrefab(loot);
                    if (ent) then
                        inventory:GiveItem(ent, nil, Vector3(afflicter.Transform:GetWorldPosition()));
                    end
                end

                if (pigman_killer) then
                    pigman_killer:Kill(afflicter);
                end
            end
        end)
    end)
end