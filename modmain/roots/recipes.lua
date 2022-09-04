---
--- @author zsh in 2022/8/29 3:44
---

local envAPI = require('chang_m3.dst.env.env_apis');

---@language Lua
local template = [[
    Recipes[#Recipes + 1] = {
        CanMake = true,
        name = "mc_packsack",
        ingredients = {
            Ingredient("cutstone", 3)
        },
        tech = TECH.NONE,
        config = {
            placer = nil,
            description = nil,
            canbuild = nil,
            min_spacing = nil,

            nounlock = nil, --
            numtogive = nil,
            builder_tag = nil,
            sg_state = nil,
            buildingstate = nil,
            atlas = "images/inventoryimages1.xml",
            image = "backpack.tex",
            testfn = nil,
            product = nil,
            build_mode = nil,
            build_distance = nil
        },
        filters = {
            "CONTAINERS"
        }
    };
]];
template = nil; -- ��Ϊ nil��������ô˵�أ��ַ��������Ƕ�����������û�ã�


-- ȫ�ֱ�����ֵ���ֲ�������������߶�ȫ�ֱ����ķ����ٶȣ���������Ȼ�����ÿռ任ʱ����
-- Lua ������������Ӧ�û��� Java �����������ʱ��δ��ʹ�õı������ᱻ����İɣ�

local Recipes = {}

-- ����
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_backpack',
    ingredients = {
        Ingredient("cutgrass", 4), Ingredient("twigs", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages1.xml",
        image = "backpack.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- �ǹ���
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_candybag',
    ingredients = {
        Ingredient("cutgrass", 6)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages1.xml",
        image = "candybag.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- ��Ƥ��
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_icepack',
    ingredients = {
        Ingredient("bearger_fur", 1), Ingredient("gears", 1), Ingredient("transistor", 1)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages1.xml",
        image = "icepack.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- С���
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_piggyback',
    ingredients = {
        Ingredient("pigskin", 4), Ingredient("silk", 6), Ingredient("rope", 2)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages2.xml",
        image = "piggyback.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- ���Ӵ�
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_seedpouch',
    ingredients = {
        Ingredient("slurtle_shellpieces", 2), Ingredient("cutgrass", 4), Ingredient("seeds", 2)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages2.xml",
        image = "seedpouch.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- ��ʦ��
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_spicepack',
    ingredients = {
        Ingredient("cutgrass", 4), Ingredient("twigs", 4), Ingredient("nitre", 2)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages2.xml",
        image = "spicepack.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- ����˹����
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_krampus_sack',
    ingredients = {
        Ingredient("krampus_sack", 1)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages1.xml",
        image = "krampus_sack.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- ��������
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_cane',
    ingredients = {
        Ingredient("goldnugget", 2), Ingredient("walrus_tusk", 1), Ingredient("twigs", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages1.xml",
        image = "cane.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- С����
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_small_container_item',
    ingredients = {
        Ingredient("goldnugget", 2), Ingredient("walrus_tusk", 1), Ingredient("twigs", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages2.xml",
        image = "treasurechest.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

-- ������
Recipes[#Recipes + 1] = {
    CanMake = true,
    name = 'dst_m3_big_container_item',
    ingredients = {
        Ingredient("goldnugget", 2), Ingredient("walrus_tusk", 1), Ingredient("twigs", 4)
    },
    tech = TECH.NONE,
    config = {
        placer = nil,
        min_spacing = nil,
        nounlock = nil,
        numtogive = nil,
        builder_tag = nil,
        atlas = "images/inventoryimages1.xml",
        image = "dragonflychest.tex"
    },
    filters = {
        "CONTAINERS"
    }
};

envAPI.addRecipes(Recipes);