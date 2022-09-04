---
--- @author zsh in 2022/8/31 17:03
---

local L = (locale == 'zh' or locale == 'zht' or locale == 'zhr') and true or false;

local table = {
    concat = function(list, sep, i, j)
        list = list or {};
        sep = sep or '';
        i = i or 1;
        j = j or #list;

        local str = '';

        for index = i, j do
            str = str .. list[index];
            if (index ~= j) then
                str = str .. sep;
            end
        end

        return str;
    end
};

local info = {
    author = 'chang',
    forumthread = nil,
    priority = -2 ^ 31,
    description = function(version, releaseTime, content)
        version = version or '1.0.0';
        releaseTime = releaseTime or '2022-08';
        content = content or '';
        return (L and "感谢你的订阅！\n"
                .. content .. "\n"
                .. "                                                【模组】：" .. folder_name .. "\n"
                .. "                                                【作者】：" .. "chang" .. "\n"
                .. "                                                【版本】：" .. version .. "\n"
                .. "                                                【时间】：" .. releaseTime .. "\n"
                or "Thanks for subscribing!\n"
                .. content .. "\n"
                .. "                                                【mod    】：" .. folder_name .. "\n"
                .. "                                                【author 】：" .. "chang" .. "\n"
                .. "                                                【version】：" .. version .. "\n"
                .. "                                                【release】：" .. releaseTime .. "\n"
        );

    end,
    api_version = 10,
    icon = 'modicon.tex';
    icon_atlas = 'modicon.xml';
    dont_starve_compatible = true,
    reign_of_giants_compatible = false, -- 是否兼容巨人国
    dst_compatible = true
}

name = '模组 003';
version = '1.0.0';
description = info.description(version, '2022-08-31');

client_only_mod = false;
all_clients_require_mod = true;

author = info.author;
forumthread = info.forumthreadl
priority = info.priority;
api_version = info.api_version;
icon = info.icon;
icon_atlas = info.icon_atlas;
dont_starve_compatible = info.dont_starve_compatible;
reign_of_giants_compatible = info.reign_of_giants_compatible;
dst_compatible = info.dst_compatible;

local config = {
    template = function()
        return {
            name = '',
            label = '',
            hover = '',
            options = {
                {
                    description = '',
                    hover = '',
                    data = '0'
                }
            },
            default = '0'
        }
    end,
    addBlockLabel = function(label)
        return {
            name = '',
            label = label or '',
            hover = '',
            options = {
                {
                    description = '',
                    hover = '',
                    data = '0'
                }
            },
            default = '0'
        }
    end,
    option = function(description, data, hover)
        return {
            description = description or '',
            data = data or '',
            hover = hover or ''
        };
    end,
    OPEN = L and '开启' or 'Open',
    CLOSE = L and '关闭' or 'Close',
    SHORTAGE = L and '超少' or 'Shortage',
    LESS = L and '少' or 'Less',
    DEFAULT = L and '默认' or 'Default',
    MUCH = L and '多' or 'Much',
    LARGE = L and '超多' or 'Large'
}

local option = config.option;

configuration_options = {
    -- Temp
    {
        name = 'language',
        label = L and '语言' or 'Language',
        hover = '',
        options = {
            option(L and '中文简体' or 'Simple Chinese', 'zh'),
            option('English', 'en'),
        },
        default = 'zh'
    }
};

--[[do
    -- Test code
    if (not env) then
        name = 'env == nil';
        -- NOTE: env == nil
        -- NOTE: 所以说，klei 的环境设置与 _ENV 不同！
        -- NOTE: modinfo 环境未设置 env.env = env，所以调用 env(隐式：env.env) == nil!
    elseif (not env.folder_name) then
        name = 'env.folder_name == nil';
    elseif (not env.env) then
        name = 'env.env == nil';
    else
        name = 'mod-003';
    end
end]]




