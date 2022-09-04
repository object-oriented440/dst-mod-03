---
--- @author zsh in 2022/8/27 21:44
---


-- 导入部分
local Locale = require('chang_m3.dst.locale');
local File = require('chang_m3.modules.utils.File');

local L = Locale.getLoc();

-- 建议和文本有关的都放在这里，然后让这一个文件是 UTF-8 编码格式就行了。
-- 其次，每次的 loc.lua 都要将 TEXT 设置成 @class ModText，这样就能保证编译器提示功能生效了
-- 否则，只能通过 TEXT.XXX 这样的添加方式，但是这种添加方式肯定没有构造器创建省时，因为不需要进行扩容。
---@class ModText @singleton
local TEXT = {
    ACTION = {
        Magic = L and '进阶' or 'Advance',
        Hammer = L and '徒手拆' or 'Hands down',
    },
    UI = {
      TransferPanel = L and '传送面板' or 'Transfer Panel'
    },
    ArrangeContainer = L and '一键整理' or 'Arrange',
    DestroyContainer = L and '一键销毁' or 'Destroy',
    PickContainer = L and '一键采集' or 'Pick',
    DeploySuccess = L and '放置成功！' or 'deploy success!',
    HammerSuccess = L and '拆除成功！' or 'hammer success!',
};

---@class ModConst @singleton
local CONST = {

}



--[[do
    -- Test code
    -- 这样才可以让编辑器的代码提示功能生效
    TEXT.ACTION = {};
    TEXT.ACTION.Magic = L and '进阶' or 'advance';
    TEXT.ACTION.Hammer = L and '拆除' or 'hammer';

    TEXT.ContainerArrange = L and '一键整理' or 'arrange';
    TEXT.ContainerDestroy = L and '一键销毁' or 'destroy';
end]]



local prefabsInfo = {
    ['dst_m3_backpack'] = {
        names = L and '背包' or 'backpack',
        describe = nil,
        recipe_desc = L and '' or ''
    },
    ['dst_m3_candybag'] = {
        names = L and '糖果袋' or 'candybag',
        describe = nil,
        recipe_desc = L and '' or ''
    },
    ['dst_m3_icepack'] = {
        names = L and '熊皮包' or 'icepack',
        describe = nil,
        recipe_desc = L and '' or ''
    },
    ['dst_m3_krampus_sack'] = {
        names = L and '坎普斯背包' or 'krampus_sack',
        describe = nil,
        recipe_desc = L and '' or ''
    },
    ['dst_m3_piggyback'] = {
        names = L and '小猪包' or 'piggyback',
        describe = nil,
        recipe_desc = L and '' or ''
    },
    ['dst_m3_seedpouch'] = {
        names = L and '种子袋' or 'seedpouch',
        describe = nil,
        recipe_desc = L and '' or ''
    },
    ['dst_m3_spicepack'] = {
        names = L and '厨师袋' or 'spicepack',
        describe = nil,
        recipe_desc = L and '' or ''
    },

    ['dst_m3_cane'] = {
        names = L and '步行手杖' or 'cane',
        describe = nil,
        recipe_desc = L and '' or ''
    },

    ['dst_m3_small_container_item'] = {
        names = L and '便携·小箱子' or 'small chest',
        describe = nil,
        recipe_desc = L and '' or ''
    },
    ['dst_m3_small_container_chest'] = {
        names = L and '建筑·小箱子' or 'small chest',
        describe = nil,
        recipe_desc = L and '' or ''
    },

    ['dst_m3_big_container_item'] = {
        names = L and '便携·大箱子' or 'big chest',
        describe = nil,
        recipe_desc = L and '' or ''
    },
    ['dst_m3_big_container_chest'] = {
        names = L and '建筑·大箱子' or 'big chest',
        describe = nil,
        recipe_desc = L and '' or ''
    },
};



Locale.setModText(TEXT);
Locale.setModConst(CONST);
Locale.prefabSTRINGS(prefabsInfo);

 