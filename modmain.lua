---
--- @author zsh in 2022/8/26 17:35
---

-- 预导入部分
require('chang_m3.dst.env.env_init')(env);
require('chang_m3.dst.debug.cosolecommands');

-- 导入部分


env.PrefabFiles = {
    'dst_m3_prefabs_set'
}

env.Assets = {
    Asset("ATLAS", "images/gadgets/jingzhe.xml"),
    Asset("IMAGE", "images/gadgets/jingzhe.tex"),

    Asset("ANIM", "anim/big_box_ui_120.zip")
}


env.modimport('modmain/init/languages.lua');

env.modimport('modmain/init/othermods.lua');

env.modimport('modmain/init/postinits.lua');

env.modimport('modmain/init/roots.lua');






