---
--- @author zsh in 2022/8/31 17:33
---


local table = {
    concat = function(list, sep, i, j)
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

local msg = table.concat({
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
},'---[[]]---\n');

print(msg);

