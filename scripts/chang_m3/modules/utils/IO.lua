---
--- @author zsh in 2022/9/3 14:31
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��


-- ģ���ʼ��
local IO = {};
local self = IO;

---`[������]`
function IO.fwrite(fmt, ...)
    return io.write(string.format(fmt, ...)); -- type: userdata
end




-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------


return IO;