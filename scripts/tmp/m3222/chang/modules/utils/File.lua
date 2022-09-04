---
--- @author zsh in 2022/8/18 13:53
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- 导入部分
local Error = require('m3.chang.modules.utils.incomplete.Error');

local File = {};

---判断文件是否存在（没有什么简单的方法，一般就是：试着去打开这个文件）
---@param filepath string @文件路径
function File:exists(filepath)
    local file, message = io.open(filepath);
    if (file) then
        file:close();
        return true;
    else
        --io.stderr:write(message, '\n');
        print(message);
        return false;
    end
end

-- FIXME: 一个字符并不是一个字节！但是这个指向的好像就是字节，再说吧！
---获得文件大小，单位`B`
---@param file_or_path userdata|string @io.open(filename)返回的流对象或者文件路径
---@return number @文件大小，单位`B`
function File:getSize(file_or_path)
    if (type(file_or_path) ~= 'string' or type(file_or_path) ~= 'userdata') then
        error(string.format("Invalid variable type '%s', expected '%s'.", type(file_or_path), 'string|userdata'));
    end

    if (type(file_or_path) == 'string') then
        local f, error_msg = io.open(file_or_path, 'r');
        if (f) then
            local size = f:seek('end');
            f:close();
            return size;
        else
            --io.stderr:write(error_msg, '\n');
            print(error_msg)
            return nil;
        end
    else
        local file = file_or_path;
        local current = file:seek();
        local size = file:seek('end');
        file:seek('set', current);
        return size;
    end
end

-- FIXME: 有什么用？
---获得当前已被使用的内存
---@param unit_conversion boolean @是否转换单位，默认转换为 字节 B|byte（不是 bit，1B = 8bit）
---@return number @默认单位 `B`，即 字节。单位 `KB`，即：千字节
function File:getUsedMemory(unit_conversion)
    return unit_conversion ~= false and collectgarbage('count') * 1024 or collectgarbage('count');
end

--[[-- Test code ???
collectgarbage("stop")
print(File:getUsedMemory(false));
local s = File:getUsedMemory();
--local a = {}; -- 32 B ?
--local b = function()  end; -- 16 B ?
local c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
local e = File:getUsedMemory();
print((e - s));]]

return File;