---
--- @author zsh in 2022/8/12 20:19
--- Simple List

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local GF = require('global.GlobalFunction');

local List = {};

-- TODO: #
-- ����������иñ�ʶ��˵���ڱ�ʶ���й��ܴ������д����ʵ�ֵĹ�����˵���л����˵����
-- FIXME:
-- ����������иñ�ʶ��˵����ʶ��������Ҫ���������������Ǵ���ģ����ܹ�������Ҫ�޸��������������˵���м���˵����

---�ж� list �Ƿ�Ϊ ����
--[[
    ���У�
    �����м���ڿն���nil ֵ�����б���ԣ����г��Ȳ������ǲ��ɿ��ģ���ֻ���������У�����Ԫ�ؾ���Ϊ nil ���б���
    ��׼ȷ��˵�����У�sequence������ָ���� n ��������ֵ���͵ļ�����ɵļ��� {1,...,n} �γɵı�
    ����ע�⣺ֵΪ nil �ļ�ʵ�ʲ��ڱ��У���
    �ر�أ���������ֵ���ͼ��ı���ǳ���Ϊ������С�
    -- NOTE: # ��ͬ�� fori
    -- n1������ fori ��˵���� nil ��ͣ��������ֵ��
    -- n2������ # ��˵��# ����ʶ�� �������͵ļ� �� Ԫ�أ�Ĭ����ӵļ�Ҳ�ǵģ����ǲ����ü���Ԫ�أ�

    -- NOTE: ���������԰��������ҵĲ��ԣ�# �� fori ��డ������������

    NOTE: �Ȳ�����ô�࣬�������䣺
    ���ϣ������� table �Ǵ��⵱һ���������������ã���ô #t �Ǻܷ���Ļ��table���ȵķ�����
    �������� table �� key ����ֵ���������������������͵� key��
    ��ô���ǲ�Ҫָ�� # �ܸ������������塿�Ľ������
]]
-- TODO: ���ܴ���ȱ��
-- FIXME: ������룿
function List:isList(list)
    return type(list) == 'table';
end

function List:empty(list)
    return #list == 0;
end

---���б� a �е�Ԫ�ظ��Ƶ��б� b ��ĩβ
function List:listAdd(src, dest)
    table.move(src, 1, #src, #dest + 1, dest);
end

function List:insert()
    
end

---ͷ����
---@param list table[] @�б�
---@param newElement userdata @��Ҫ�������Ԫ��
function List:push_front(list, newElement)
    table.move(list, 1, #list, 2);
    list[1] = newElement;
end

---ͷɾ��
function List:push_back(list)
    table.move(list, 2, #list, 1);
    list[#list] = nil;
end

---βɾ��
function List:pop_back(list)
    if (not self:isList(list)) then
        GF:printErrorInfo('param is not a list');
        return nil;
    end

    if (self:empty(list)) then
        io.write('list is empty\n');
        io.flush();
        return nil;
    end

    local pop = list[#list];
    list[#list] = nil;
    return pop;
end

local function test()
    local list = {
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    };

    GF:printTableAll(list);

    while (not List:empty(list)) do
        io.write(List:pop_back(list), '\n');
    end

    GF:printTableAll(list);
end

if (true) then
    print(package.path);
    test();
end

return List;
 