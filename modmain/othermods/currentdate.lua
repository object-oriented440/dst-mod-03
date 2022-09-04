---
--- @author zsh in 2022/8/28 16:00
---

-- 导入部分
---@type widget
local Widget = require 'widgets/widget'; -- 导入官方的不用括号，导入自己的用括号。标记一下！
---@type text
local Text = require 'widgets/text';

local Date = require('chang_m3.modules.utils.Date');
local Table = require('chang_m3.modules.utils.Table');
local Tool = require('chang_m3.dst.modtool');
local S, F = Table.security.getSecurities();

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------

local Property = {
    ['timeText'] = setmetatable({
        font = NUMBERFONT, -- fonts.lua
        size = 18,
        text = '00:00:00',
        colour = { 255, 255, 255, 1 }
    }, {
        __call = function(t)
            return t.font, t.size, t.text, t.colour
        end
    })
}

---@class currentdate:widget
local CurrentDate = Class(Widget, function(self, owner)
    Widget._ctor(self, 'dst_m3_CurrentDate'); -- 调用父类的初始化函数，super(...)

    self:SetScale(2, 2);

    self.timeText = self:AddChild(Text(Property.timeText()));
end);

function CurrentDate:OnUpdate()
    local h, m, s = Date.getHMS();
    self.timeText:SetString(h .. ' : ' .. m .. ' : ' .. s);
end

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------


env.AddClassPostConstruct('widgets/controls', function(self, owner)
    self.dst_m3_currentdate = self:AddChild(CurrentDate(owner));

    do
        ---@type currentdate
        local currentdate = self.dst_m3_currentdate;

        currentdate:SetHAnchor(0); -- x  1,0,2 代表：左中右
        currentdate:SetVAnchor(1); -- y  1,0,2 代表：上中下
        --currentdate:SetPosition(150, -200);
        currentdate:SetPosition(0, -20);

        currentdate:Show();

        local placeholder = CreateEntity();
        F(placeholder, 'DoPeriodicTask', 1, function()
            currentdate:OnUpdate();
        end);
    end

end)