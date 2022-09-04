---
--- @author zsh in 2022/9/1 3:24
---

--[[ 第二次练习，注释不多，注释具体在 第一次练习 里面 ]]

--[[
-- 导入部分
local Widget = require 'widgets/widget'; -- 导入官方的不用括号，导入自己的用括号。标记一下！
local Text = require 'widgets/text';

local Date = require('m3.chang.modules.utils.Date');

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
    local h, m, s = Date:getHMS();
    self.timeText:SetString(h .. ' : ' .. m .. ' : ' .. s);
end

return CurrentDate;]]
