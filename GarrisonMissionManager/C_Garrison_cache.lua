local addon_name, addon_env = ...

-- [AUTOLOCAL START]
local C_Garrison = C_Garrison
local LE_FOLLOWER_TYPE_GARRISON_6_0 = LE_FOLLOWER_TYPE_GARRISON_6_0
local LE_GARRISON_TYPE_6_0 = LE_GARRISON_TYPE_6_0
local wipe = wipe
-- [AUTOLOCAL END]

local getters = {}
local cache = setmetatable({}, { __index = function(t, key)
   local result = getters[key]()
   t[key] = result
   return result
end})
addon_env.c_garrison_cache = cache

local GetBuildings = C_Garrison.GetBuildings
getters.GetBuildings = function()
   return GetBuildings(LE_GARRISON_TYPE_6_0)
end

local salvage_yard_level_building_id = { [52]  = 1, [140] = 2, [141] = 3 }
getters.salvage_yard_level = function()
   local buildings = cache.GetBuildings
   for idx = 1, #buildings do
      local buildingID = buildings[idx].buildingID
      local possible_salvage_yard_level = salvage_yard_level_building_id[buildingID]
      if possible_salvage_yard_level then return possible_salvage_yard_level end
   end
   return false
end

local GetPossibleFollowersForBuilding = C_Garrison.GetPossibleFollowersForBuilding
local cache_GetPossibleFollowersForBuilding = setmetatable({}, { __index = function(t, key)
   local result = GetPossibleFollowersForBuilding(LE_FOLLOWER_TYPE_GARRISON_6_0, key)
   t[key] = result
   return result
end})

getters.GetPossibleFollowersForBuilding = function()
   wipe(cache_GetPossibleFollowersForBuilding)
   return cache_GetPossibleFollowersForBuilding
end

-- wipe removes all entries, but leaves MT alone, as this test shows
-- WIPE_META_TEST = setmetatable({}, { __index = function(t, key) return "test" end})
