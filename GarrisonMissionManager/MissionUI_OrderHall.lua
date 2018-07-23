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

local artifact_research_notes_item_id = 139390
local _, _, _, _, artifact_research_notes_texture = GetItemInfoInstant(artifact_research_notes_item_id)
local artifact_research_container_id

local ap_ready_icon = Widget{
   "Frame", GarrisonLandingPageMinimapButton,
   Width = 20, Height = 20,
   EnableMouse = false,
   TOP = { "BOTTOM", 0, 20 },
   Hide = true,

   -- children = {
   --    { "Texture", TextureToItem = artifact_research_notes_item_id, SetAllPoints = true }
   -- }
}
Widget{
   "Texture", ap_ready_icon,
   TextureToItem = artifact_research_notes_item_id
}:SetAllPoints() -- TODO: make some shortcut in LazyWidget for one time texture

ap_ready_icon:SetScript("OnEvent", function(self, event, bag, texture)
   if texture == artifact_research_notes_texture then
      After(1, addon_env.ThrottleRequestLandingPageShipmentInfo)
      -- in case first one hits throttle delay
      After(6, addon_env.ThrottleRequestLandingPageShipmentInfo)
   end
end)

local artifact_research_default_ticker_period = 60 * 10
local function CheckIfArtifactResearchIsReady()
   local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, itemName, itemTexture, UNKNOWN1, itemID
   if not artifact_research_container_id then
      local shipments = GetLooseShipments(LE_GARRISON_TYPE_7_0)
      for idx = 1, #shipments do
         local container_id = shipments[idx]
         name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, itemName, itemTexture, UNKNOWN1, itemID = GetLandingPageShipmentInfoByContainerID(container_id)
         if itemID == artifact_research_notes_item_id then
            artifact_research_container_id = container_id
            break
         else
            shipmentsReady = nil
         end
      end
   end

   if not shipmentsReady and artifact_research_container_id then
      name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, itemName, itemTexture, UNKNOWN1, itemID = GetLandingPageShipmentInfoByContainerID(artifact_research_container_id)
   end
   
   if duration then
      local artifact_research_almost_completed_time = duration - (time() - creationTime) + 2
      if artifact_research_almost_completed_time >= 0 and artifact_research_almost_completed_time < artifact_research_default_ticker_period then
         -- Schedule extra call in addition and before the usual ticker if research is almost complete, so we can show it right away.
         After(artifact_research_almost_completed_time, addon_env.ThrottleRequestLandingPageShipmentInfo)
         -- in case first one hits throttle delay
         After(artifact_research_almost_completed_time + 6, addon_env.ThrottleRequestLandingPageShipmentInfo)
      end
   end

   if shipmentsReady and shipmentsReady > 0 then
      ap_ready_icon:RegisterEvent("ITEM_PUSH")
      ap_ready_icon:Show()
   else
      ap_ready_icon:Hide()
      ap_ready_icon:UnregisterEvent("ITEM_PUSH")
   end
end
addon_env.CheckIfArtifactResearchIsReady = CheckIfArtifactResearchIsReady
addon_env.ThrottleRequestLandingPageShipmentInfo()

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

   local function TickerCheckArtifactResearch()
      After(artifact_research_default_ticker_period, TickerCheckArtifactResearch)
      addon_env.ThrottleRequestLandingPageShipmentInfo()
   end
   After(1, TickerCheckArtifactResearch)

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
