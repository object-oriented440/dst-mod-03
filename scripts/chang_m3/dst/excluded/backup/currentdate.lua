---
--- @author zsh in 2022/9/1 3:24
---

--[[ �ڶ�����ϰ��ע�Ͳ��࣬ע�;����� ��һ����ϰ ���� ]]

--[[
-- ���벿��
local Widget = require 'widgets/widget'; -- ����ٷ��Ĳ������ţ������Լ��������š����һ�£�
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
    Widget._ctor(self, 'dst_m3_CurrentDate'); -- ���ø���ĳ�ʼ��������super(...)

    self:SetScale(2, 2);

    self.timeText = self:AddChild(Text(Property.timeText()));
end);

function CurrentDate:OnUpdate()
    local h, m, s = Date:getHMS();
    self.timeText:SetString(h .. ' : ' .. m .. ' : ' .. s);
end

return CurrentDate;]]
