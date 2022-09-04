---
--- @author zsh in 2022/9/2 21:52
---

---
--- @author zsh in 2022/9/2 18:11
---

-- 导入部分
local API = require('m3.chang.dst.apis');
local Locale = require('m3.chang.dst.locale');

local Text = Locale:getModText();

local item_name = 'dst_m3_big_container_item';
local chest_name = 'dst_m3_big_container_chest';

local assets = {
    Asset("ANIM", "anim/dragonfly_chest.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
}

local no_substitute = false;

local widgetsetup = {
    widget = {
        -- TODO: 锚点在哪？确定：锚点就是屏幕的锚点！针对于整个屏幕！
        slotpos = {},
        animbank = no_substitute and "ui_chester_shadow_3x4" or 'big_box_ui_120',
        animbuild = no_substitute and "ui_chester_shadow_3x4" or 'big_box_ui_120',
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
        buttoninfo = {
            text = Text.ArrangeContainer,
            position = no_substitute and Vector3(0, -170, 0) or Vector3(-5, 193, 0), -- TODO: 锚点在哪？
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
    type = "big_container",
    itemtestfn = function(container, item, slot)
        return not (item:HasTag("irreplaceable") or item:HasTag("_container") or item:HasTag("bundle") or item:HasTag("nobundling"))
    end
}

-- Temp 1: 相减 + 1，为总次数！
-- Temp 2: 小部件好像都是几何中心为原点？ 比如小方格，认为中心点为原点？好像不对。。。又好像对！感觉就是中心点！
if (not no_substitute) then
    -- Error:[string "scripts/prefabs/container_classified.lua"]:15: wrong number of arguments to 'insert'
    -- 额，没看懂，为什么会这样错。2022-09-03
    widgetsetup.widget.slotpos = {};
    local spacer = 30;
    local posX;
    local posY;

    -- TODO: 一维数组、二维数组、三维数组，内存中的方向是怎样的？
    for z = 0, 2 do
        for y = 7, 0, -1 do
            for x = 0, 4 do
                posX = 80 * x - 600 + 80 * 5 * z + spacer * z;
                posY = 80 * y - 100;

                if y > 3 then
                    posY = posY + spacer;
                end

                table.insert(widgetsetup.widget.slotpos, Vector3(posX, posY, 0));
            end
        end
    end
else
    for y = 2.5, -0.5, -1 do
        for x = 0, 2 do
            table.insert(widgetsetup.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
        end
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

    inst:AddTag('dst_m3_container');
    inst:AddTag('dst_m3_container_canharmmer');

    inst.MiniMapEntity:SetIcon("dragonflychest.png")

    inst.AnimState:SetBank("dragonfly_chest")
    inst.AnimState:SetBuild("dragonfly_chest")
    inst.AnimState:PlayAnimation("closed")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    -- Temp
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
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")

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
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")

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
            ent.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")

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

    return Prefab(item_name, fn, assets), MakePlacer(item_name .. "_placer", "dragonfly_chest", "dragonfly_chest", "closed");
end

local function MakeChest()

    local function onopenfn(inst, data)
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end

    local function onclosefn(inst, data)
        inst.AnimState:PlayAnimation("close")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
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
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
    end

    local function onbuild(inst, data)
        inst.AnimState:PlayAnimation("place")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/common/dragonfly_chest_craft")
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

        inst.dst_m3_onhammered = function(inst, worker)
            onhammered(inst, worker);
            if (worker) then
                worker.components.talker:Say(Text.HammerSuccess);
            end
        end;

        inst:ListenForEvent("onbuilt", onbuild);

        return inst
    end

    return Prefab(chest_name, fn, assets), MakePlacer(chest_name .. "_placer", "dragonfly_chest", "dragonfly_chest", "closed");
end

local Set = require('m3.chang.modules.utils.Set');

return unpack(Set:union({ MakeItem() }, { MakeChest() }));