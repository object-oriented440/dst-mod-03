---
--- @author zsh in 2022/8/29 23:19
---

---@class dst_m3_pigman_killer
---@field killCount number
local Killer = Class(function(self,inst)
    self.inst = inst;

    self.killCount = 0;
end)

function Killer:Kill(afflicter)
    if (not afflicter) then
        return;
    end

    self.killCount = self.killCount + 1;

    -- TODO: 提示一下
end



function Killer:OnSave()
    return {
        killCount = self.killCount;
    };
end


function Killer:OnLoad(data)
    if (data) then
        if (data.killCount) then
            self.killCount = data.killCount;
        end
    end
end


return Killer;