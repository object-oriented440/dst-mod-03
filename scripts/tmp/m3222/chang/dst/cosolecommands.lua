---
--- @author zsh in 2022/8/26 22:44
---


local Tool = require('m3.chang.dst.modtool');
local KEY = Tool:getModKey();
local env = Tool:getModENV();


local Prefabs = env.Prefabs;

-- NOTE: 还有，饥荒到底有没有 _ENV，为什么设置了没有用！
function dst_m3_print_Prefabs()
    if (not Prefabs) then
        print('ERROR!!!', 'Prefabs does not exist!');
    end
    Prefabs = Prefabs or {};
    for name, prefab in pairs(Prefabs) do
        print(name, prefab); -- prefab 为 Prefab 类的实例
    end
end

function dst_m3_unpackTest()

    local t1 = { 1, nil, 2, nil }; -- # -- > 1
    local t2 = { 1, nil, 2, nil, 3, nil }; -- # -- > 3
    local t3 = { 1, nil, 2, nil, 3, nil, 4, nil }; -- # -- > 1

    print(#t1, #t2, #t3);

    print(unpack(t1));
    print(unpack(t2));
    print(unpack(t3));
end