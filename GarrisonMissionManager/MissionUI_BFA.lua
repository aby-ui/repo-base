local addon_name, addon_env = ...

-- Confused about mix of CamelCase and_underscores?
-- Camel case comes from copypasta of how Blizzard calls returns/fields in their code and deriveates
-- Underscore are my own variables

-- [AUTOLOCAL START]
local CreateFrame = CreateFrame
local LE_FOLLOWER_TYPE_GARRISON_8_0 = LE_FOLLOWER_TYPE_GARRISON_8_0
local After = C_Timer.After
-- [AUTOLOCAL END]

local Widget = addon_env.Widget
addon_env.event_frame = addon_env.event_frame or CreateFrame("Frame")
local event_frame = addon_env.event_frame
local event_handlers = addon_env.event_handlers
local RegisterEvent = event_frame.RegisterEvent
local UnregisterEvent = event_frame.UnregisterEvent

local BestForCurrentSelectedMission = addon_env.BestForCurrentSelectedMission

function addon_env.BFAInitUI()
   if not BFAMissionFrame then return end

   -- Hardcoded
   local prefix = "BFA" -- hardcoded, because it is used in OUR frame names and should be static for GMM_Click
   local follower_type = LE_FOLLOWER_TYPE_GARRISON_8_0
   local o = addon_env.InitGMMFollowerOptions({
      follower_type                = follower_type,
      gmm_prefix                   = prefix,
      party_requires_one_non_troop = true
   })

   -- Detected/calculated
   local options = GarrisonFollowerOptions[follower_type]
   local base_frame = o.base_frame
   local currency = C_Garrison.GetCurrencyTypes(options.garrisonType)
   local MissionTab = base_frame.MissionTab
   local MissionPage = MissionTab.MissionPage
   local MissionList = MissionTab.MissionList
   local mission_page_prefix = prefix .. "MissionPage"
   local mission_list_prefix = prefix .. "MissionList"

   addon_env.MissionPage_ButtonsInit(follower_type)
   hooksecurefunc(base_frame, "ShowMission", addon_env.ShowMission_More)
   addon_env.update_if_visible[MissionPage] = function() addon_env.ShowMission_More(base_frame, MissionPage.missionInfo) end

   addon_env.MissionList_ButtonsInit(follower_type)
   local MissionList_Update_More = addon_env.MissionList_Update_More

   local function MissionList_Update_More_With_Settings()
      MissionList_Update_More(MissionList, MissionList_Update_More_With_Settings, mission_list_prefix, follower_type, currency)
   end

   hooksecurefunc(MissionList,            "Update", MissionList_Update_More_With_Settings)
   hooksecurefunc(MissionList.listScroll, "update", MissionList_Update_More_With_Settings)
   MissionList_Update_More_With_Settings()
   addon_env.update_if_visible[MissionList] = MissionList_Update_More_With_Settings

   hooksecurefunc(base_frame.FollowerList, "UpdateData", addon_env.GarrisonFollowerList_Update_More)

   addon_env.BFAInitUI = nil
end

if BFAMissionFrame and addon_env.BFAInitUI then
   addon_env.BFAInitUI()
end

-- /dump C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_8_0)
