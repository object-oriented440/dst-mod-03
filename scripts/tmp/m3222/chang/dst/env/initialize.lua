---
--- @author zsh in 2022/8/31 23:11
---

-- 导入部分
local Tool = require('m3.chang.dst.modtool');

-- 初始化模组
return function(env)
    Tool:setModENV(env);
    Tool:setModinfoConfig(env);
end