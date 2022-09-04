---
--- @author zsh in 2022/9/3 14:10
---

-- ADP: The Acyclic Dependencies Principle����ѭ������ԭ��
-- ��ģ��Ϊ����ģ�飬��ʱ�����������ģ���ѭ���������⣡

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
-- ��������������

-- ģ���ʼ��
local ADP = {};
local self = ADP;

---`[utils/Table.lua]`�жϣ��м䲻���ڿն��ı����б�
---@return boolean
function ADP.isSequence(t)
    if (type(t) ~= 'table') then
        return false;
    end

    local list_index = {};
    for k, _ in pairs(t) --[[nil Ҳ�����]] do
        if (type(k) == 'number') then
            table.insert(list_index, k);
        end
    end

    table.sort(list_index);

    local length = #list_index;
    if (list_index[length] == length) then
        return true;
    end

    return false;
end



-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------


return ADP;
 