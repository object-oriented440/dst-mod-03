---
--- @author zsh in 2022/8/20 22:24
---

_ENV = { _G = _G };
_G.setmetatable(_ENV, { __index = function(_, k)
    return _G.rawget(_G, k);
end });

local Assertion = {};

---@param v any 变量
---@param whatType string 需要判断是什么类型？
---@param stackLevel number|"'1'"|"'2'"|"'3'"|"'etc...'"
function Assertion:isType(v, whatType, stackLevel)
    v = v or nil; -- 避免传入空值？注意这个空值不是 nil，而是 `return;` 这种形式被 type 接收！
    -- 但是 nil 和 false 才为 false，这个空值到底是什么呢？还是这只是个 bug？

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

--[[do
    -- Test code: type() `bad argument #1 to 'type' (value expected)`
    local test = function()
        return ;
    end;
    local a = test();
    io.write('{', tostring(a), '}\n');
    io.flush();
    print(type(a)); -- test() 返回 空气 给 a，a 自动赋值了 nil
    print(type(test())); -- 这种情况，`bad argument #1 to 'type' (value expected)`
end]]

return Assertion;
 