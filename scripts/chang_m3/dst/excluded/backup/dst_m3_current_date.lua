---
--- @author zsh in 2022/8/28 1:07
---

local Widget = require('widgets/widget'); -- ������
local Image = require('widgets/image'); -- Image ��
local Text = require('widgets/text') -- �ı���

local Date = require('m3.chang.modules.utils.Date');

local TEXT = {
    test01 = {
        font = NUMBERFONT, -- fonts.lua
        size = 18,
        text = '00:00:00',
        colour = { 255, 0, 0, 1 }
    }
}

---@class currentdate
local CurrentDate = Class(Widget, function(self, owner)
    Widget._ctor(self, 'CurrentDateWidget'); -- ���ø���ĳ�ʼ��������super(...)

    -- ���ø��ֲ���
    self:SetScale(2, 2);

    -- tips: ����� self �������Լ��ģ�ֻҪ���� Widget �ظ������ȡ
    self.image01 = self:AddChild(Image('images/gadgets/jingzhe.xml', 'jingzhe.tex'));

    local test01 = TEXT.test01;
    self.text01 = self:AddChild(Text(
            test01.font, test01.size, test01.text, test01.colour
    ));


end)

-- ����һ�������ı����ݵķ���
function CurrentDate:OnUpdate(time)
    self.text01:SetString(time);
end

return CurrentDate;