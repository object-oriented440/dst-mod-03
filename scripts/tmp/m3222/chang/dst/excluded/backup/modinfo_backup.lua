---
--- @author zsh in 2022/8/26 17:35
---

local L = (locale == 'zh' or locale == 'zht' or locale == 'zhr') and true or false;

local checkinfo = {
    "name", -- 绝对不能少
    "description", -- 绝对不能少
    "author", -- 绝对不能少
    "version", -- 绝对不能少
    "api_version", -- 绝对不能少
    "dont_starve_compatible", -- 默认 true
    "reign_of_giants_compatible", -- 默认 true
    "configuration_options",
    "dst_compatible" -- 默认 true
}

local modname = folder_name; -- mod 文件夹的名字


if (not env) then
    name = 'env == nil';
elseif (not env.folder_name) then
    name = 'env.folder_name == nil';
elseif (not env.env) then
    name = 'env.env == nil';
else
    name = 'mod-003';
end

author = 'chang';

version = ''; -- 会被去除首尾的空格，且全部转为小写字母。每次发布要和上一次不一样，不然发布不上去！

description = '';

-- mod 的图标，放在同级目录下即可
icon = '';
icon_atlas = '';

client_only_mod = false;
all_clients_require_mod = true;

-- 如果 forumthread 是非空字符串（具体见：function ModWrangler:GetLinkForMod(mod_name)）
-- url = string.format("http://forums.kleientertainment.com/index.php?%s", forumthread)
-- 然后在 modsscreen.lua 中 可以调用 VisitURL(url) 方法，所以 ModsScreen 是什么？
forumthread = nil;

api_version = 10;
dont_starve_compatible = true;
reign_of_giants_compatible = false;
dst_compatible = false;

--version_compatible = version; -- 如果是 string，则就是你设置的。否则，默认 version

--game_modes = {}; -- AddGameMode(...) 这是啥？

-- 本 mod 必须是服务端 mod，元素是表
--mod_dependencies = { {} };

configuration_options = {

};