---
--- @author zsh in 2022/8/31 23:11
---

-- ���벿��
local Tool = require('m3.chang.dst.modtool');

-- ��ʼ��ģ��
return function(env)
    Tool:setModENV(env);
    Tool:setModinfoConfig(env);
end