---
--- @author zsh in 2022/8/28 1:18
---

if (true) then
    return ;
end

local function placeholder()

end

--[[
    注意了！！！这个 env 就是 mod，modinfo 也存在里面！
]]

--[[ mods.lua function CreateEnvironment(modname, isworldgen, isfrontend) ]]

local env = {
    -- lua
    pairs = pairs,
    ipairs = ipairs,
    print = print,
    math = math,
    table = table,
    type = type,
    string = string,
    tostring = tostring,
    require = require,
    Class = Class,

    -- runtime
    TUNING = TUNING,

    -- worldgen
    LEVELCATEGORY = LEVELCATEGORY,
    GROUND = GROUND,
    WORLD_TILES = WORLD_TILES,
    LOCKS = LOCKS,
    KEYS = KEYS,
    LEVELTYPE = LEVELTYPE,

    -- utility
    GLOBAL = _G,
    modname = modname,
    MODROOT = MODS_ROOT .. modname .. "/",
}

env.env = env;

env.modinfo = initenv -- mods.lua function ModWrangler:LoadMods(worldgen)

env.modimport = placeholder;

--[[ modutil.lua local function InsertPostInitFunctions(env, isworldgen, isfrontend) ]]

env.modassert = placeholder
env.moderror = placeholder

env.postinitfns = {}
env.postinitdata = {}

if isfrontend then
    env.ReloadFrontEndAssets = placeholder;
end

if not isworldgen then
    env.ReloadPreloadAssets = placeholder;
end

env.AddCustomizeGroup = placeholder;

env.RemoveCustomizeGroup = placeholder;

env.AddCustomizeItem = placeholder;

env.RemoveCustomizeItem = placeholder;

env.GetCustomizeDescription = placeholder;

env.postinitfns.LevelPreInit = {}
env.AddLevelPreInit = placeholder;
env.postinitfns.LevelPreInitAny = {}
env.AddLevelPreInitAny = placeholder;
env.postinitfns.TaskSetPreInit = {}
env.AddTaskSetPreInit = placeholder;
env.postinitfns.TaskSetPreInitAny = {}
env.AddTaskSetPreInitAny = placeholder;
env.postinitfns.TaskPreInit = {}
env.AddTaskPreInit = placeholder;
env.postinitfns.RoomPreInit = {}
env.AddRoomPreInit = placeholder;

env.AddLocation = placeholder;
env.AddLevel = placeholder;
env.AddTaskSet = placeholder;
env.AddTask = placeholder;
env.AddRoom = placeholder;
env.AddStartLocation = placeholder;

env.AddGameMode = placeholder;

env.GetModConfigData = placeholder;

env.postinitfns.GamePostInit = {}
env.AddGamePostInit = placeholder;

env.postinitfns.SimPostInit = {}
env.AddSimPostInit = placeholder;

env.AddGlobalClassPostConstruct = placeholder;

env.AddClassPostConstruct = placeholder;

env.RegisterTileRange = placeholder;

env.AddTile = placeholder;

env.ChangeTileRenderOrder = placeholder;

env.SetTileProperty = placeholder;

env.ChangeMiniMapTileRenderOrder = placeholder;

env.SetMiniMapTileProperty = placeholder;

env.AddFalloffTexture = placeholder;

env.ChangeFalloffRenderOrder = placeholder;

env.SetFalloffProperty = placeholder;

env.ReleaseID = ReleaseID.IDs
env.CurrentRelease = CurrentRelease

if isworldgen then
    return
end

env.AddAction = placeholder;

env.AddComponentAction = placeholder;
env.AddPopup = placeholder;
env.postinitdata.MinimapAtlases = {}
env.AddMinimapAtlas = placeholder;
env.postinitdata.StategraphActionHandler = {}
env.AddStategraphActionHandler = placeholder;
env.postinitdata.StategraphState = {}
env.AddStategraphState = placeholder;

env.postinitdata.StategraphEvent = {}
env.AddStategraphEvent = placeholder;

env.postinitfns.ModShadersInit = {}
env.AddModShadersInit = placeholder;

env.postinitfns.ModShadersSortAndEnable = {}
env.AddModShadersSortAndEnable = placeholder;

env.postinitfns.StategraphPostInit = {}
env.AddStategraphPostInit = placeholder;

env.postinitfns.ComponentPostInit = {}
env.AddComponentPostInit = placeholder;

-- You can use this as a post init for any prefab. If you add a global prefab post init function, it will get called on every prefab that spawns.
-- This is powerful but also be sure to check that you're dealing with the appropriate type of prefab before doing anything intensive, or else
-- you might hit some performance issues. The next function down, player post init, is both itself useful and a good example of how you might
-- want to write your global prefab post init functions.
env.postinitfns.PrefabPostInitAny = {}
env.AddPrefabPostInitAny = placeholder;

-- An illustrative example of how to use a global prefab post init, in this case, we're making a player prefab post init.
env.AddPlayerPostInit = placeholder;

env.postinitfns.PrefabPostInit = {}
env.AddPrefabPostInit = placeholder;

env.postinitfns.RecipePostInitAny = {}
env.AddRecipePostInitAny = placeholder;

env.postinitfns.RecipePostInit = {}
env.AddRecipePostInit = placeholder;

-- the non-standard ones

env.AddBrainPostInit = placeholder;

env.AddIngredientValues = placeholder;

env.cookerrecipes = {}
env.AddCookerRecipe = placeholder;

env.AddModCharacter = placeholder;

env.RemoveDefaultCharacter = placeholder;

-- data: see PROTOTYPER_DEFS in recipes.lua for examples
env.AddPrototyperDef = placeholder;

env.AddRecipeToFilter = placeholder;

env.RemoveRecipeFromFilter = placeholder;

-- filters = {"TOOLS", "LIGHT"}
env.AddRecipe2 = placeholder;

env.AddCharacterRecipe = placeholder;

env.AddDeconstructRecipe = placeholder;

env.AddRecipe = placeholder;

env.Recipe = placeholder;

env.AddRecipeTab = placeholder;

env.Prefab = Prefab

env.Asset = Asset

env.Ingredient = Ingredient

env.LoadPOFile = placeholder;

env.RemapSoundEvent = placeholder;

env.RemoveRemapSoundEvent = placeholder;

env.AddReplicableComponent = placeholder;

env.AddModRPCHandler = placeholder;

env.AddClientModRPCHandler = placeholder;

env.AddShardModRPCHandler = placeholder;

env.GetModRPCHandler = placeholder;

env.GetClientModRPCHandler = placeholder;

env.GetShardModRPCHandler = placeholder;

env.SendModRPCToServer = placeholder;

env.SendModRPCToClient = placeholder;

env.SendModRPCToShard = placeholder;

env.MOD_RPC = MOD_RPC --legacy, mods should use GetModRPC below
env.CLIENT_MOD_RPC = CLIENT_MOD_RPC --legacy, mods should use GetClientModRPC below
env.SHARD_MOD_RPC = SHARD_MOD_RPC --legacy, mods should use GetShardModRPC below

env.GetModRPC = placeholder;
env.GetClientModRPC = placeholder;
env.GetShardModRPC = placeholder;

env.SetModHUDFocus = placeholder;

env.AddUserCommand = placeholder;

env.AddVoteCommand = placeholder;

env.ExcludeClothingSymbolForModCharacter = placeholder;

env.RegisterInventoryItemAtlas = placeholder;

-- For modding loading tips
env.AddLoadingTip = placeholder;

env.RemoveLoadingTip = placeholder;

-- Loading tip weights when playing the game for the first time (LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START),
-- or after a certain amount of time (LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END), based on the weights table to be modified.
-- For play time in between, weights are interpolated from the difference between start and end category weights.
env.SetLoadingTipCategoryWeights = placeholder;

env.SetLoadingTipCategoryIcon = placeholder;

