
SCENE：参数inst, doer, actions, right。
这一场景指的是在游戏主界面上对着实体的操作。比如右键点击收获浆果。

USEITEM：参数inst, doer, target, actions, right。
这一场景是选取一件物品，再点击地图上的东西或装备栏的物品，比如给篝火添加燃料

POINT：参数inst, doer, pos, actions, right。
这一场景指的是对地图上任意一点执行的操作，比如装备传送法杖后，你可以右键点击地板，传送过去。

EQUIPPED：参数inst, doer, target, actions, right 。
这一场景指的是装备了一件物品后，可以实施的操作，比如装备斧头后可以砍树。

INVENTORY：参数inst, doer, actions, right。
这一场景是点击物品栏执行的操作。比如右键点击物品栏里的木甲，就会自动装备到身上。

ISVALID：参数inst, action, right。
这个不是定义的场景，是用于检测动作是否合法的，我们可以忽略它。