---
--- @author zsh in 2022/9/2 18:11
---

-- 导入部分
local API = require('m3.chang.dst.apis');
local Locale = require('m3.chang.dst.locale');

local Text = Locale:getModText();

local item_name = 'dst_m3_small_container_item';
local chest_name = 'dst_m3_small_container_chest';

local assets = {
    Asset("ANIM", "anim/treasure_chest.zip"),
    Asset("ANIM", "anim/ui_chest_3x2.zip"),
}

local widgetsetup = {
    widget = {
        -- TODO: 锚点在哪？
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
        buttoninfo = {
            text = Text.ArrangeContainer,
            position = Vector3(0, -140, 0),
            fn = function(inst, doer)
                if inst.components.container then
                    API:arrangeContainer(inst);
                elseif inst.replica.container and not inst.replica.container:IsBusy() then
                    SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
                end
            end,
            validfn = function(inst)
                return inst.replica.container and not inst.replica.container:IsEmpty();
            end
        }
    },
    type = "small_container",
    itemtestfn = function(container, item, slot)
        return not (item:HasTag("irreplaceable") or item:HasTag("_container") or item:HasTag("bundle") or item:HasTag("nobundling"))
    end
}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(widgetsetup.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

local function commonfn()
    ---@type EntityScript
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon('treasurechest.png');

    inst:AddTag('dst_m3_container');
    inst:AddTag('dst_m3_container_canharmmer');

    inst.AnimState:SetBank('chest')
    inst.AnimState:SetBuild('treasure_chest')
    inst.AnimState:PlayAnimation("closed")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    -- 暂定
    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup(nil, widgetsetup)
--[[    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true]]

    API.ItemIntoContainerFirst.setListenForEvent(inst);

    MakeSnowCovered(inst)

    return inst;
end

local function MakeItem()

    ---@param inst EntityScript
    local function onopenfn(inst, data)
        if not inst:HasTag("burnt") then
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
        end

        if (inst.task) then
            inst.task:Cancel();
            inst.task = nil;
        end

        local time = API.ItemIntoContainerFirst.redirectItemFlag(inst);
        inst.task = inst:DoPeriodicTask(time, function()
            API.ItemIntoContainerFirst.redirectItemFlag(inst)
        end)
    end

    local function onclosefn(inst, data)
        if not inst:HasTag("burnt") then
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
        end

        if (inst.task) then
            inst.task:Cancel();
            inst.task = nil;
        end

        API.ItemIntoContainerFirst.redirectItemFlag(inst);
    end

    local function ondeploy(inst, pt, deployer, rot)

        local ent = SpawnPrefab(chest_name, inst.skinname, inst.skin_id);
        if (ent) then
            ent.Transform:SetPosition(pt:Get());

            API.ItemIntoContainerFirst.clearAllFlag(inst);
            API:transferContainerAllItems(inst, ent);

            inst:Remove();

            -- 播放动画
            ent.AnimState:PlayAnimation("place")
            ent.AnimState:PushAnimation("closed", false)
            ent.SoundEmitter:PlaySound("dontstarve/common/chest_craft")

            -- Temp
            if (deployer) then
                deployer.components.talker:Say(Text.DeploySuccess);
            end
        end
    end

    local function fn()
        local inst = commonfn();

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.container.onopenfn = onopenfn
        inst.components.container.onclosefn = onclosefn

        inst:AddComponent('inventoryitem')
        inst.components.inventoryitem:ChangeImageName('treasurechest');

        inst:AddComponent('deployable')
        inst.components.deployable.ondeploy = ondeploy;

        return inst
    end

    return Prefab(item_name, fn, assets), MakePlacer(item_name .. "_placer", "chest", "treasure_chest", "closed");
end

local function MakeChest()

    local function onopenfn(inst, data)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("open")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
        end
    end

    local function onclosefn(inst, data)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("close")
            inst.AnimState:PushAnimation("closed", false)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
        end
    end

    local function onhammered(inst, worker)
        local ent = SpawnPrefab(item_name, inst.skinname, inst.skin_id);
        local fx = SpawnPrefab("collapse_small");

        if (ent) then
            ent.Transform:SetPosition(inst.Transform:GetWorldPosition());

            API:transferContainerAllItems(inst, ent);

            if (fx) then
                fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                fx:SetMaterial("wood")
            end

            inst:Remove();
        end
    end

    local function onhit(inst, worker)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("closed", false)
        end
    end

    local function onbuild(inst, data)
        inst.AnimState:PlayAnimation("place")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
    end

    local function fn()
        local inst = commonfn();

        inst:AddTag("structure")
        inst:AddTag("chest")

        if not TheWorld.ismastersim then
            return inst;
        end

        inst.components.container.onopenfn = onopenfn
        inst.components.container.onclosefn = onclosefn

        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(2)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        inst.dst_m3_onhammered = function(inst,worker)
            onhammered(inst,worker);
            if (worker) then
                worker.components.talker:Say(Text.HammerSuccess);
            end
        end;

        inst:ListenForEvent("onbuilt", onbuild);

        return inst
    end

    return Prefab(chest_name, fn, assets), MakePlacer(chest_name .. "_placer", "chest", "treasure_chest", "closed");
end

local Set = require('m3.chang.modules.utils.Set');

return unpack(Set:union({ MakeItem() }, { MakeChest() }));