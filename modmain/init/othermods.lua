---
--- @author zsh in 2022/8/28 15:56
---

env.modimport('modmain/othermods/looktietu.lua');

env.modimport('modmain/othermods/ui_mobile.lua');

env.modimport('modmain/othermods/currentdate.lua');

-- ��ϰ��Ŀ�ģ����� UI
-- �������
-- 1��Ū�������С������д�����Լ���α������ݵȣ��Լ����ʵ���������ܣ���������ĳĳĳԤ����仯������������ playerhud
-- 2����֪��screens/xxx/ ���� controls playerhud ��ʲô���ö�ȥ����
-- 3������ģ��̫��ʱ���ˣ����Ҹо�����ѧ����ʲô������Ӧ������̫���ˣ�
--�� 2022-09-03-01:35 ��ǣ��ݿ��� 111 �� 22 ʱ 23 �֣�ϣ��δ�����ҿ�����仰�������˷�����ô��ʱ��
--����ֻ˵����ģ�飬�����������ָ����Ĳ�����׼�����е��£����� ��
-- 4���������ڣ��ٻ���д�Ļ����뽫��������֪ʶȫ��ѧ�꣡������ stategraphs��brains��ͼƬ��������ȣ�
-- ֻ�������Ų��ᱻ�������ޣ�����ʵ�ֺܶ໨����ڵĶ��������򣬾���������������ҲҪ���գ�
-- 5������һ�£����ڼ��ĵ� _ENV(Lua ����) �� env(���׵ģ�setfenv �Ⱥ���) ��
env.modimport('modmain/othermods/transferpanel.lua');
