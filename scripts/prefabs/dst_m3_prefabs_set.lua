---
--- @author zsh in 2022/8/26 23:47
---

local API = require('m3.chang.dst.apis');
local Set = require('m3.chang.modules.utils.Set'); -- Set:union(gameself, myself) ���һ��


return unpack(API.loadPrefabs({
    'prefabs/m3/gameself/backpack.lua', -- ����
    'prefabs/m3/gameself/candybag.lua', -- �ǹ���
    'prefabs/m3/gameself/icepack.lua', -- ���ʱ���
    'prefabs/m3/gameself/krampus_sack.lua', -- ����˹����
    'prefabs/m3/gameself/piggyback.lua', -- С���
    'prefabs/m3/gameself/seedpouch.lua', -- ���Ӵ�
    'prefabs/m3/gameself/spicepack.lua', -- ��ʦ��

    'prefabs/m3/gameself/cane.lua', -- ��������

    'prefabs/m3/myself/small_container.lua', -- С����
    'prefabs/m3/myself/big_container.lua' --������

}));
