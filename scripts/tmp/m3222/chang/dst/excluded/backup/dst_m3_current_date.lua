---
--- @author zsh in 2022/8/28 1:07
---

local Widget = require('widgets/widget'); -- 超父类
local Image = require('widgets/image'); -- Image 类
local Text = require('widgets/text') -- 文本类

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
    Widget._ctor(self, 'CurrentDateWidget'); -- 调用父类的初始化函数，super(...)

    -- 设置各种参数
    self:SetScale(2, 2);

    -- tips: 这里的 self 就是我自己的，只要不和 Widget 重复，随便取
    self.image01 = self:AddChild(Image('images/gadgets/jingzhe.xml', 'jingzhe.tex'));

    local test01 = TEXT.test01;
    self.text01 = self:AddChild(Text(
            test01.font, test01.size, test01.text, test01.colour
    ));


end)

-- 定义一个更新文本内容的方法
function CurrentDate:OnUpdate(time)
    self.text01:SetString(time);
end

return CurrentDate;