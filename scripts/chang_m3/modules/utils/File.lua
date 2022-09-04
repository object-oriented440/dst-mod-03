---
--- @author zsh in 2022/9/3 6:00
---

-- ����ģ���ռ����
_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

-- ���벿��
local Assertion = require('chang_m3.modules.utils.Assertion');

-- ģ���ʼ��
local File = {};
local self = File;

---@param filepath string
function File.readwholefile(filepath)
    local file, msg = io.open(filepath);
    if (not file) then
        print(msg);
        return nil;
    else

    end
end

---@param mode string @ Ĭ�� 'w'
function File.writefile(filepath, content, mode)
    mode = mode or 'w';
    local f, msg = io.open(filepath, mode);
    if (not f) then
        print('write failed!', msg);
    else
        --[[        -- Test code
                print(tostring(f)); -- file (00000000006FED50)]]

        f:write(content);
        f:flush();
        f:close();
        return true;
    end
end

---`[���Ľ�]`�ж��ļ��Ƿ���ڣ�û��ʲô�򵥵ķ�����һ����ǣ�����ȥ������ļ���
---@param filepath string @�ļ�·��
function File.exists(filepath)
    local file, msg = io.open(filepath);
    if (file) then
        file:close();
        return true;
    else
        print('File.exists --> ERROR', msg);
        return false;
    end
end

---`[���Ľ�]`����ļ���С����λ�ֽ�
---@param file_or_path userdata|string @io.open(filename)���ص�����������ļ�·��
---@return number @�ļ���С����λ B
function File.getSize(file_or_path)
    if (type(file_or_path) ~= 'string' or type(file_or_path) ~= 'userdata') then
        error(string.format("Invalid variable type '%s', expected '%s'.", type(file_or_path), 'string|userdata'));
    end

    if (type(file_or_path) == 'string') then
        local f, msg = io.open(file_or_path, 'r');
        if (not f) then
            --io.stderr:write(error_msg, '\n');
            print(msg);
            return nil;
        else
            local size = f:seek('end');
            f:close();
            return size;
        end
    else
        local file = file_or_path;
        local current = file:seek();
        local size = file:seek('end');
        file:seek('set', current);
        return size;
    end
end



-------------------------------------------------------------------------------------------------
-- [[ ���� ]]
-------------------------------------------------------------------------------------------------
---`[����]`��õ�ǰ�ѱ�ʹ�õ��ڴ�
---@param unit_conversion boolean @�Ƿ�ת����λ��Ĭ��ת��Ϊ �ֽ� B|byte������ bit��1B = 8bit��
---@return number @Ĭ�ϵ�λ `B`���� �ֽڡ���λ `KB`������ǧ�ֽ�
function File.getUsedMemory(unit_conversion)
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