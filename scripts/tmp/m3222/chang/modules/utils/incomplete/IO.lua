---
--- @author zsh in 2022/8/20 22:39
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local IO = {};

function IO:fwrite(fmt, ...)
    return io.write(string.format(fmt, ...)); -- type: userdata
end


return IO;