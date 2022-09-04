---
--- @author zsh in 2022/8/20 19:15
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local Error = {};


-- FIXME
function Error:traceback()
    for i = 1, math.huge do
        local info = debug.getinfo(2, 'Sl');
        if (not info) then
            break ;
        end

    end
end

--[[---@language TEXT
local text = [=[
    �� �� ��
    ����
    ��


]=];]]


---@param v any ����
---@param whatType string ��Ҫ�ж���ʲô���ͣ�
---@param stackLevel number|"'1'"|"'2'"|"'3'"|"'etc...'"
function Error:isType(v, whatType, stackLevel)
    local level = stackLevel or 3;
    if (type(whatType) ~= 'string') then
        error(string.format("Invalid variable type '%s', expected '%s'.", type(whatType), 'string'), level);
    end
    if (type(v) == whatType) then
        return true;
    else
        error(string.format("Invalid variable type '%s', expected '%s'.", type(v), whatType), level);
    end
end

---���ϸ�� assert(v,message)
function Error:no_strict_assert(v, message)
    if (v) then
        return v;
    end

    local func_data = debug.getinfo(2, 'Sl');
    io.stderr:write('no strict assert: ', func_data.short_src, ':', func_data.currentline, ': ', message, '\n');
    io.stderr:write(debug.traceback(), '\n');

    return nil; -- ע�⣬�����д return nil������ֵ��Ȼ�޷��� type �ж����ͣ���Ϊѹ��û��ֵ�������档
end



-- io.stderr:write
---@deprecated
function Error.fwrite(fmt, ...)
    local n = select('#', ...);
    local match_n;

    io.stderr:write(string.format(fmt, ...), '\n');
end

local function main()
    local traceback = debug.traceback() .. '\n';
    --print(traceback);

    local max = 0;
    local count = 0;
    for line in string.gmatch(traceback, '.*\n') do
        -- ? Ϊʲôƥ�䲻�ˣ�
        count = count + 1;
        print(line);
        print(#line);
        if (max < #line) then
            max = #line;
        end
    end
    --print(count);
--[[    print(max);
    print(#[==[	modules/Error.lua:43: in local 'main_test']==]);]]

end

--main();

return Error;