---
--- @author zsh in 2022/9/2 18:17
---


local API = require('chang_m3.dst.apis');

---@param self inventory
env.AddComponentPostInit('inventory', function(self)
    API.ItemIntoContainerFirst.itemIntoContainerFirst(self, {
        ["dst_m3_small_container_item"] = 9,
        ["dst_m3_big_container_item"] = 10,
    });
end)