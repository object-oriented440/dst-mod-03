---
--- @author zsh in 2022/8/28 1:34
---


-- Test code
print("env's metatable!!!")
print(getmetatable(env));

-- ע�⣬�˴� require���벻Ҫʹ�ü��ĵ� GLOBAL
-- tips: ����Ҫ����һ��ȥ���� main.lua���жϳ��� mod ��ʲôʱ����ص�
local Date = require('m3.chang.modules.utils.Date');

---@type currentdate
local CurrentDate = require('m3.chang.dst.backup.dst_m3_current_date');

-- self,... ���ﴫ��ľ��� 'widgets/controls' �� _ctor �����Ĳ���
env.AddClassPostConstruct('widgets/controls', function(self, owner)
    -- self ���� 'widgets/controls' �� Controls��������Ҫ���Ψһ��ʶ�ı���
    self.m3_currentdate = self:AddChild(CurrentDate(owner)); -- �ҵ�������ʵ������Ȼ�� AddChild

    ---@type currentdate
    local currentdate = self.m3_currentdate;

    currentdate:SetHAnchor(1); -- ����ԭ�� x ����λ�ã�0��1��2 �ֱ��Ӧ��Ļ�С�����
    currentdate:SetVAnchor(1); -- ����ԭ�� y ����λ�ã�0��1��2 �ֱ��Ӧ��Ļ�С��ϡ���

    -- ���� widget ��λ�ã�����ͨ�� SetHAnchor��SetVAnchor �������������˴���λ�ã������
    -- ����ԭ��������������������õķ���Ϊ��������ģ�����Ҽӣ��ϼ��¼�
    -- ���������������ǽ� widget �������ϣ���ô��Ļ�����Ͻǵ�������� (0,0) ��������Ҽӣ��ϼ��¼���
    -- tips: ���������������ᣬ��Ϊ y �������ᣬ��Ϊ x �ĸ����ᣨ����Ҽӣ��ϼ��¼���
    -- �Ϳ���֪����SetPosition(200, -100) �ǽ� widget �������� 200 ��λ���������� 100 ��λ
    currentdate:SetPosition(200, -100);

    currentdate:Show();

    local inst = env.GLOBAL.CreateEntity();

    -- ���ڴ�����ʱ��������
    inst:DoPeriodicTask(1, function()
        -- �����ı���Ϣ
        self.CurrentDateWidget:OnUpdate(Date:getYear(true) .. ":" .. Date:getMonth(true) .. ":" .. Date:getDay(true))
    end)
end)