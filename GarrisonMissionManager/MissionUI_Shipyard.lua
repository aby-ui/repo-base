local addon_name, addon_env = ...

-- Confused about mix of CamelCase and_underscores?
-- Camel case comes from copypasta of how Blizzard calls returns/fields in their code and deriveates
-- Underscore are my own variables

-- [AUTOLOCAL START]
local After = C_Timer.After
local GARRISON_SHIP_OIL_CURRENCY = GARRISON_SHIP_OIL_CURRENCY
local GetCurrencyInfo = GetCurrencyInfo
local GetFollowerSoftCap = C_Garrison.GetFollowerSoftCap
local GetItemInfoInstant = GetItemInfoInstant
local GetNumActiveFollowers = C_Garrison.GetNumActiveFollowers
local LE_FOLLOWER_TYPE_SHIPYARD_6_2 = LE_FOLLOWER_TYPE_SHIPYARD_6_2
local UnitGUID = UnitGUID
local dump = DevTools_Dump
local match = string.match
local pairs = pairs
local print = print
local tinsert = table.insert
local tsort = table.sort
local wipe = wipe
-- [AUTOLOCAL END]

local Widget = addon_env.Widget
local gmm_buttons = addon_env.gmm_buttons
local top_for_mission = addon_env.top_for_mission
local GetFilteredFollowers = addon_env.GetFilteredFollowers
local UpdateMissionListButton = addon_env.UpdateMissionListButton

local MissionPage = GarrisonShipyardFrame.MissionTab.MissionPage

local function ShipyardMissionList_PartyButtonOnClick(self)
   if addon_env.RegisterManualInterraction then addon_env.RegisterManualInterraction() end
   addon_env.mission_page_pending_click = "ShipyardMissionPage1"
   return self:GetParent():Click()
end

local shipyard_mission_list_gmm_button_template = {
   "Button", nil, "UIPanelButtonTemplate",
   Width = 80, Height = 40, FrameLevelOffset = 3, Scale = 0.60,
   OnClick = ShipyardMissionList_PartyButtonOnClick,
}
local shipyard_mission_list_gmm_loot_template = {
   "Button", nil, "UIPanelButtonTemplate",
   Width = 40, Height = 40, FrameLevelOffset = 3, Scale = 0.75,
   OnClick = ShipyardMissionList_PartyButtonOnClick,
   Hide = 1,
}

local loot_frames = {}

local function GarrisonShipyardMap_UpdateMissions_More()
   -- Blizzard updates those when not visible too, but there's no reason to copy them.
   local self = GarrisonShipyardFrame.MissionTab.MissionList
   if not self:IsVisible() then return end

   local missions = self.missions
   local mission_frames = self.missionFrames

   if addon_env.top_for_mission_dirty then
      wipe(top_for_mission)
      addon_env.top_for_mission_dirty = false
   end

   local filtered_followers = GetFilteredFollowers(LE_FOLLOWER_TYPE_SHIPYARD_6_2)
   local more_missions_to_cache
   local _, oil = GetCurrencyInfo(GARRISON_SHIP_OIL_CURRENCY)

   for i = 1, #missions do
      local mission = missions[i]

      -- Cache mission frames
      local frame = mission_frames[i]
      if frame then
         if (mission.offeredGarrMissionTextureID ~= 0 and not mission.inProgress and not mission.canStart) then
            frame:Hide()
         else
            local gmm_button = gmm_buttons['ShipyardMissionList' .. i]
            if not gmm_button then
               shipyard_mission_list_gmm_button_template.parent = frame
               gmm_button = Widget(shipyard_mission_list_gmm_button_template)
               gmm_button:SetText(i)
               gmm_button:SetPoint("TOP", frame, "BOTTOM", 0, 10)
               gmm_buttons['ShipyardMissionList' .. i] = gmm_button

               shipyard_mission_list_gmm_loot_template.parent = gmm_button
               local loot_frame = Widget(shipyard_mission_list_gmm_loot_template)
               loot_frame:SetPoint("LEFT", gmm_button, "RIGHT", -3, 0)
               loot_frames[i] = loot_frame
            end

            if (mission.inProgress) then
               gmm_button:Hide()
            else
               gmm_button:Show()
               more_missions_to_cache = UpdateMissionListButton(mission, filtered_followers, frame, gmm_button, more_missions_to_cache, oil, 0.5)
               local reward_texture
               for id, reward in pairs(mission.rewards) do
                  if reward.itemID then
                     local _, _, _, _, itemTexture = GetItemInfoInstant(reward.itemID)
                     reward_texture = itemTexture
                  elseif reward.currencyID then
                     local currency_id = reward.currencyID
                     if currency_id ~= 0 then
                        local _, _, currencyTexture = GetCurrencyInfo(reward.currencyID);
                        reward_texture = currencyTexture
                     end
                  end
                  if reward_texture then break end
               end
               local loot_frame = loot_frames[i]
               if reward_texture then
                  loot_frame:SetNormalTexture(reward_texture)
                  loot_frame:Show()
               else
                  loot_frame:Hide()
               end
            end
         end
      end
   end

   if more_missions_to_cache and more_missions_to_cache > 0 then
      After(0.001, GarrisonShipyardMap_UpdateMissions_More)
   end
end
hooksecurefunc("GarrisonShipyardMap_UpdateMissions", GarrisonShipyardMap_UpdateMissions_More)

local function ShipyardInitUI()
   local prefix = "Shipyard" -- hardcoded, because it is used in OUR frame names and should be static for GMM_Click
   local follower_type = LE_FOLLOWER_TYPE_SHIPYARD_6_2
   local o = addon_env.InitGMMFollowerOptions({
      follower_type                = follower_type,
      gmm_prefix                   = prefix,
      custom_mission_list          = true
   })

   addon_env.MissionPage_ButtonsInit(follower_type)

   ShipyardInitUI = nil
end
ShipyardInitUI()

local BestForCurrentSelectedMission = addon_env.BestForCurrentSelectedMission
hooksecurefunc(GarrisonShipyardFrame, "ShowMission", function()
   BestForCurrentSelectedMission(LE_FOLLOWER_TYPE_SHIPYARD_6_2, MissionPage, "ShipyardMissionPage")
end)

gmm_buttons.StartShipyardMission = MissionPage.StartMissionButton

local spec_count = {}
local spec_name = {}
local spec_list = {}
hooksecurefunc("GossipFrameOptionsUpdate", function(...)
   local guid = UnitGUID("npc")
   if not (guid and (match(guid, "^Creature%-0%-%d+%-%d+%-%d+%-94429%-") or match(guid, "^Creature%-0%-%d+%-%d+%-%d+%-95002%-"))) then return end

   local filtered_followers = GetFilteredFollowers(LE_FOLLOWER_TYPE_SHIPYARD_6_2)
   wipe(spec_count)
   for idx = 1, #filtered_followers do
      local follower = filtered_followers[idx]
      local spec = follower.classSpec
      local prev_count = spec_count[spec] or 0
      spec_count[spec] = prev_count + 1
      spec_name[spec] = follower.className
   end
   wipe(spec_list)
   for spec in pairs(spec_name) do tinsert(spec_list, spec) end
   tsort(spec_list)
   for idx = 1, #spec_list do
      local spec = spec_list[idx]
      print(spec_name[spec] .. ": " .. spec_count[spec])
   end

   local max_followers = GetFollowerSoftCap(LE_FOLLOWER_TYPE_SHIPYARD_6_2)
   local num_active_followers = GetNumActiveFollowers(LE_FOLLOWER_TYPE_SHIPYARD_6_2)
   print(GARRISON_FLEET .. ": " .. num_active_followers .. "/" .. max_followers)
end)
