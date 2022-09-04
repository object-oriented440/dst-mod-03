---
--- @author zsh in 2022/8/27 16:44
---

local API = require('m3.chang.dst.apis');
local name = API:namedPrefab();

local assets = {
    Asset("ANIM", "anim/piggyback.zip"),
    Asset("ANIM", "anim/swap_piggyback.zip"),
    Asset("ANIM", "anim/ui_piggyback_2x6.zip"),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "swap_piggyback")
    else
        owner.AnimState:OverrideSymbol("swap_body", "swap_piggyback", "swap_body")
    end

    inst.components.container:Open(owner)

    owner:AddTag('dst_m3_pigman_killer');

    if owner and owner.components.leader then
        owner.components.leader:RemoveFollowersByTag("pig");
        owner:AddTag("monster");
    end
    inst.updatetask = inst:DoPeriodicTask(0.5, function()
        if owner and owner.components.leader then
            owner.components.leader:RemoveFollowersByTag("pig");
        end
    end, 1)

end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.container:Close(owner)

    owner:RemoveTag('dst_m3_pigman_killer');

    if (inst.updatetask) then
        inst.updatetask:Cancel();
        inst.updatetask = nil;
    end

    if owner and owner.components.leader then
        if not owner:HasTag("spiderwhisperer") then
            if not owner:HasTag("playermonster") then
                owner:RemoveTag("monster");
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("piggyback")
    inst.AnimState:SetBuild("swap_piggyback")
    inst.AnimState:PlayAnimation("anim")

    inst.MiniMapEntity:SetIcon("piggyback.png")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    inst:AddTag("backpack")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    MakeInventoryFloatable(inst, "small", 0.1, 0.85)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem:ChangeImageName('piggyback')

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = TUNING.PIGGYBACK_SPEED_MULT

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("piggyback")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab(name, fn, assets)
