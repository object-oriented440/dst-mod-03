---
--- @author zsh in 2022/9/3 23:47
---

-- 导入部分
local Assertion = require('chang_m3.modules.utils.Assertion');
local Date = require('chang_m3.modules.utils.Date');
local Debug = require('chang_m3.modules.utils.Debug');
local File = require('chang_m3.modules.utils.File');
local IO = require('chang_m3.modules.utils.IO');
local Load = require('chang_m3.modules.utils.Load');
local Math = require('chang_m3.modules.utils.Math');
local Set = require('chang_m3.modules.utils.Set');
local String = require('chang_m3.modules.utils.String');
local Table = require('chang_m3.modules.utils.Table');
local Thread = require('chang_m3.modules.utils.Thread');
local Timer = require('chang_m3.modules.utils.Timer');

-- 主程序块部分

:: T1 ::
do
    -- Test code
    goto T2;
    _G[1] = 'number1';
    _G[true] = 'true';
    _G[{}] = '{}';
    _G[function()
    end] = 'function';
    Table.print(_G, 't');
    Table.deepPrint(_G, 'f');
end

:: T2 ::
print('T2-');










