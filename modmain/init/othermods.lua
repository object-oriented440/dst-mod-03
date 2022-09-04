---
--- @author zsh in 2022/8/28 15:56
---

env.modimport('modmain/othermods/looktietu.lua');

env.modimport('modmain/othermods/ui_mobile.lua');

env.modimport('modmain/othermods/currentdate.lua');

-- 练习，目的：传送 UI
-- 待解决：
-- 1、弄清楚各种小部件的写法，以及如何保存数据等，以及如何实现其他功能，比如点击后某某某预制物变化！而不局限于 playerhud
-- 2、已知：screens/xxx/ 比如 controls playerhud 有什么作用都去看看
-- 3、饥荒模组太花时间了，而且感觉根本学不到什么东西，应该是我太菜了！
--（ 2022-09-03-01:35 告辞！据考研 111 天 22 时 23 分，希望未来的我看见这句话不会后悔浪费了这么长时间
--（不只说饥荒模组，包括其他各种各样的不安心准备考研的事，唉） ）
-- 4、如果不后悔，再回来写的话，请将饥荒所有知识全部学完！（比如 stategraphs、brains、图片动画处理等）
-- 只有这样才不会被技术局限，才能实现很多花里胡哨的东西！否则，就是垃圾。（网络也要掌握）
-- 5、测试一下，关于饥荒的 _ENV(Lua 本体) 和 env(科雷的，setfenv 等函数) ！
env.modimport('modmain/othermods/transferpanel.lua');
