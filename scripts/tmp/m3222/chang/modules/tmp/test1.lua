---
--- @author zsh in 2022/8/26 22:12
---

--[[print('hello');

print(utf8.len('helloÄãºÃ'));]]

print(loadfile('aaa'));
--[[local ok, res = pcall(loadfile, 'hh');
print(pcall(loadfile, 'hh'));]]
--print(string.find(res, 'No such file or directory'));

local Load = require('m3.chang.modules.utils.Load');

print(type(Load:changloadfile('chang/modules/tmp/test2.lua')));