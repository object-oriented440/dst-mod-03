---
--- @author zsh in 2022/8/28 1:34
---


-- Test code
print("env's metatable!!!")
print(getmetatable(env));

-- 注意，此处 require，请不要使用饥荒的 GLOBAL
-- tips: 不需要！等一下去看看 main.lua，判断出来 mod 在什么时候加载的
local Date = require('m3.chang.modules.utils.Date');

---@type currentdate
local CurrentDate = require('m3.chang.dst.backup.dst_m3_current_date');

-- self,... 这里传入的就是 'widgets/controls' 的 _ctor 函数的参数
env.AddClassPostConstruct('widgets/controls', function(self, owner)
    -- self 就是 'widgets/controls' 的 Controls，所以需要添加唯一标识的变量
    self.m3_currentdate = self:AddChild(CurrentDate(owner)); -- 我的组件类的实例化，然后 AddChild

    ---@type currentdate
    local currentdate = self.m3_currentdate;

    currentdate:SetHAnchor(1); -- 设置原点 x 坐标位置，0、1、2 分别对应屏幕中、左、右
    currentdate:SetVAnchor(1); -- 设置原点 y 坐标位置，0、1、2 分别对应屏幕中、上、下

    -- 设置 widget 的位置，上面通过 SetHAnchor，SetVAnchor 两个函数设置了大致位置，这里的
    -- 坐标原点就是以这两个函数设置的方向为基础计算的，左减右加，上加下减
    -- 举例：如上设置是将 widget 放在左上，那么屏幕的左上角的坐标就是 (0,0) 根据左减右加，上加下减，
    -- tips: 就是正常的坐标轴，上为 y 的正半轴，左为 x 的负半轴（左减右加，上加下减）
    -- 就可以知道，SetPosition(200, -100) 是将 widget 往右移了 200 单位，往下移了 100 单位
    currentdate:SetPosition(200, -100);

    currentdate:Show();

    local inst = env.GLOBAL.CreateEntity();

    -- 周期触发计时器！！！
    inst:DoPeriodicTask(1, function()
        -- 更新文本信息
        self.CurrentDateWidget:OnUpdate(Date:getYear(true) .. ":" .. Date:getMonth(true) .. ":" .. Date:getDay(true))
    end)
end)