---
--- @author zsh in 2022/8/26 23:47
---

local API = require('m3.chang.dst.apis');
local Set = require('m3.chang.modules.utils.Set'); -- Set:union(gameself, myself) 多此一举


return unpack(API.loadPrefabs({
    'prefabs/m3/gameself/backpack.lua', -- 背包
    'prefabs/m3/gameself/candybag.lua', -- 糖果袋
    'prefabs/m3/gameself/icepack.lua', -- 保鲜背包
    'prefabs/m3/gameself/krampus_sack.lua', -- 坎普斯背包
    'prefabs/m3/gameself/piggyback.lua', -- 小猪包
    'prefabs/m3/gameself/seedpouch.lua', -- 种子袋
    'prefabs/m3/gameself/spicepack.lua', -- 厨师袋

    'prefabs/m3/gameself/cane.lua', -- 步行手杖

    'prefabs/m3/myself/small_container.lua', -- 小箱子
    'prefabs/m3/myself/big_container.lua' --大箱子

}));
