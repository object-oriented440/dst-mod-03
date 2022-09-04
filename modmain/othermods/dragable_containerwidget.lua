---
--- @author zsh in 2022/9/4 15:31
---

-- 未完成
-- 可参考：cookbookdata.lua 等

do
    return;
end

local id = 'm3_dragable_containerwidget';

local WidgetPositionData = Class(function(self, id)
    self.id = id; -- 唯一标识
    self.default = {}; -- table<instance of containerwidget:table,default_position:Vector3>
    self.new_positions = {}; -- table<prefab name:string,new_position:Vector3>
end);


function WidgetPositionData:Save(force_save)
    if force_save or (self.save_enabled and self.dirty) then
        local str = json.encode({
            new_positions = self.new_positions
        })
        TheSim:SetPersistentString(self.id, str, false)
        self.dirty = false
    end
end

function WidgetPositionData:Load()
    self.new_positions = {}
    TheSim:GetPersistentString(self.id, function(load_success, data)
        if load_success and data then
            local status, widgetPositionData = pcall(function()
                return json.decode(data)
            end)
            if status and widgetPositionData then
                self.new_positions = widgetPositionData.new_positions or {}
            else
                print("Faild to load the widgetPositionData!", status, widgetPositionData);
            end
        end
    end)
end

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

---@param self containerwidget
env.AddClassPostConstruct("widgets/containerwidget", function(self)
    local old_Open = self.Open;

    self.Open = function(self, ...)
        if (old_Open) then
            old_Open(self, ...);
        end

        ---@type EntityScript
        local container = select(1, ...);
        local doer = select(2, ...);

        local widget = container.replica.container:GetWidget();


    end
end)