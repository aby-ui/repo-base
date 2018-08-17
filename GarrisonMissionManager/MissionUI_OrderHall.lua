local addon_name, addon_env = ...

-- Confused about mix of CamelCase and_underscores?
-- Camel case comes from copypasta of how Blizzard calls returns/fields in their code and deriveates
-- Underscore are my own variables

-- [AUTOLOCAL START]
local CreateFrame = CreateFrame
local LE_FOLLOWER_TYPE_GARRISON_7_0 = LE_FOLLOWER_TYPE_GARRISON_7_0
local GetLandingPageShipmentInfoByContainerID = C_Garrison.GetLandingPageShipmentInfoByContainerID
local GetLooseShipments = C_Garrison.GetLooseShipments
local After = C_Timer.After
-- [AUTOLOCAL END]

local Widget = addon_env.Widget
addon_env.event_frame = addon_env.event_frame or CreateFrame("Frame")
local event_frame = addon_env.event_frame
local event_handlers = addon_env.event_handlers
local RegisterEvent = event_frame.RegisterEvent
local UnregisterEvent = event_frame.UnregisterEvent

local BestForCurrentSelectedMission = addon_env.BestForCurrentSelectedMission

function addon_env.OrderHallInitUI()
   if not OrderHallMissionFrame then return end

   -- Hardcoded
   local prefix = "OrderHall" -- hardcoded, because it is used in OUR frame names and should be static for GMM_Click
   local follower_type = LE_FOLLOWER_TYPE_GARRISON_7_0

   -- Detected/calculated
   local options = GarrisonFollowerOptions[follower_type]
   local base_frame = _G[options.missionFrame]
   local currency = C_Garrison.GetCurrencyTypes(options.garrisonType)
   local MissionTab = base_frame.MissionTab
   local MissionPage = MissionTab.MissionPage
   local MissionList = MissionTab.MissionList
   local mission_page_prefix = prefix .. "MissionPage"
   local mission_list_prefix = prefix .. "MissionList"

   addon_env.MissionPage_ButtonsInit(mission_page_prefix, MissionPage)
   addon_env.mission_page_button_prefix_for_type_id[follower_type] = mission_page_prefix
   hooksecurefunc(base_frame, "ShowMission", addon_env.ShowMission_More)
   addon_env.update_if_visible[MissionPage] = function() addon_env.ShowMission_More(base_frame, MissionPage.missionInfo) end

   addon_env.MissionList_ButtonsInit(MissionList, mission_list_prefix)
   local MissionList_Update_More = addon_env.MissionList_Update_More

   local function MissionList_Update_More_With_Settings()
      MissionList_Update_More(MissionList, MissionList_Update_More_With_Settings, mission_list_prefix, follower_type, currency)
   end

   hooksecurefunc(MissionList,            "Update", MissionList_Update_More_With_Settings)
   hooksecurefunc(MissionList.listScroll, "update", MissionList_Update_More_With_Settings)
   MissionList_Update_More_With_Settings()
   addon_env.update_if_visible[MissionList] = MissionList_Update_More_With_Settings

   hooksecurefunc(base_frame.FollowerList, "UpdateData", addon_env.GarrisonFollowerList_Update_More)

   addon_env.OrderHallInitUI = nil
end

if OrderHallMissionFrame and addon_env.OrderHallInitUI then
   addon_env.OrderHallInitUI()
end

-- Set an additional timer to catch load if we STILL manage to miss it?
-- /dump C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0)
-- /dump C_Garrison.GetFollowerShipments(LE_GARRISON_TYPE_7_0)
-- /dump C_Garrison.GetLooseShipments(LE_GARRISON_TYPE_7_0)
-- /dump C_Garrison.GetLandingPageShipmentInfoByContainerID
-- local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString = C_Garrison.GetLandingPageShipmentInfoByContainerID(188)
-- C_Garrison.RequestLandingPageShipmentInfo();
-- /dump OrderHallMissionFrame.FollowerList.UpdateData
