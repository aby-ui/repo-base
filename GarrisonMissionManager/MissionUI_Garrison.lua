local addon_name, addon_env = ...

-- [AUTOLOCAL START]
local C_Garrison = C_Garrison
local CastSpellOnFollower = C_Garrison.CastSpellOnFollower
local CreateFrame = CreateFrame
local GARRISON_CURRENCY = GARRISON_CURRENCY
local GARRISON_FOLLOWER_MAX_LEVEL = GARRISON_FOLLOWER_MAX_LEVEL
local GarrisonMissionFrame = GarrisonMissionFrame
local GetFollowerAbilities = C_Garrison.GetFollowerAbilities
local GetFollowerInfo = C_Garrison.GetFollowerInfo
local GetFollowerInfoForBuilding = C_Garrison.GetFollowerInfoForBuilding
local GetFollowerItems = C_Garrison.GetFollowerItems
local GetItemInfo = GetItemInfo
local GetLandingPageShipmentInfo = C_Garrison.GetLandingPageShipmentInfo
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS
local LE_FOLLOWER_TYPE_GARRISON_6_0 = LE_FOLLOWER_TYPE_GARRISON_6_0
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE
local pairs = pairs
local print = print
local tinsert = table.insert
local type = type
local wipe = wipe
-- [AUTOLOCAL END]

local MissionPage = GarrisonMissionFrame.MissionTab.MissionPage
local MissionPageFollowers = MissionPage.Followers
local FollowerTab = GarrisonMissionFrame.FollowerTab

local c_garrison_cache = addon_env.c_garrison_cache
local Widget = addon_env.Widget
local event_frame = addon_env.event_frame
local event_handlers = addon_env.event_handlers
local gmm_frames = addon_env.gmm_frames

local tts = LibStub:GetLibrary("LibTTScan-1.0", true)

hooksecurefunc("GarrisonMissionButton_SetRewards", function(self, rewards, numRewards)
   local index = 1
   local Rewards = self.Rewards
   for id, reward in pairs(rewards) do
      local button = Rewards[index]
      local item_id = reward.itemID
      if item_id and reward.quantity == 1 then
         local _, link, itemRarity, itemLevel = GetItemInfo(item_id)
         local text
         if itemRarity and itemLevel and itemLevel >= 500 then
            text = ITEM_QUALITY_COLORS[itemRarity].hex .. itemLevel
         end
         if not text and tts then
            text = tts.GetItemArtifactPower(item_id)
         end
         if text then
            local Quantity = button.Quantity
            Quantity:SetText(text)
            Quantity:Show()
         end
      end
      index = index + 1
   end
end)

local upgrade_buttons_parent = CreateFrame("Frame", nil, FollowerTab.ItemWeapon)

tinsert(addon_env.upgrade_items, { parent = upgrade_buttons_parent, anchor = FollowerTab.ItemWeapon, 114128, 114129, 114131, 114616, 114081, 114622, 120302 })
tinsert(addon_env.upgrade_items, { parent = upgrade_buttons_parent, anchor = FollowerTab.ItemArmor,  114745, 114808, 114822, 114807, 114806, 114746, 120301 })

local upgrade_item_strength = addon_env.upgrade_item_strength
upgrade_item_strength[114128] = 3
upgrade_item_strength[114129] = 6
upgrade_item_strength[114131] = 9
upgrade_item_strength[114616] = 615
upgrade_item_strength[114081] = 630
upgrade_item_strength[114622] = 645
upgrade_item_strength[114745] = 3
upgrade_item_strength[114808] = 6
upgrade_item_strength[114822] = 9
upgrade_item_strength[114807] = 615
upgrade_item_strength[114806] = 630
upgrade_item_strength[114746] = 645

addon_env.UpgradeItems_InitButtons()
addon_env.UpgradeItems_InitEvents(GarrisonMissionFrame, upgrade_buttons_parent)

local mechanic_id = {}
for idx, data in pairs (C_Garrison.GetAllEncounterThreats(LE_FOLLOWER_TYPE_GARRISON_6_0)) do
   tinsert(mechanic_id, data.id)
end

local function DrawAbilityCounters(frame, followerID, followerInfo)
   local self = FollowerTab
   local abilities = followerInfo.abilities or GetFollowerAbilities(followerID)

   for i=1, #abilities do
      local ability = abilities[i]

      local abilityFrame = self.AbilitiesFrame.Abilities[i]

      abilityFrame.Name:SetText(ability.name .. '!')
   end
end

local shipment_followers = {}
CheckPartyForProfessionFollowers = function()
   if not MissionPage:IsVisible() then return end
   local party_followers_count = #MissionPageFollowers
   local present
   for idx = 1, party_followers_count do
      if MissionPageFollowers[idx].info then present = true end
      gmm_frames["MissionPageFollowerWarning" .. idx]:Hide()

      local follower = MissionPageFollowers[idx].info
      local xp_bar = gmm_frames["MissionPageFollowerXP" .. idx]
      if (not follower or follower.xp == 0 or follower.levelXP == 0) then
         xp_bar:Hide()
         gmm_frames["MissionPageFollowerXPGainBase" .. idx]:Hide()
         gmm_frames["MissionPageFollowerXPGainBonus" .. idx]:Hide()
      else
         xp_bar:Hide()
         xp_bar:SetWidth((follower.xp/follower.levelXP) * 104)
      end
   end
   if not present then return end

   local requested = addon_env.ThrottleRequestLandingPageShipmentInfo()
   if requested then return end

   wipe(shipment_followers)
   local buildings = c_garrison_cache.GetBuildings
   for idx = 1, #buildings do
      local building = buildings[idx]
      local buildingID = building.buildingID;
      if buildingID then
         local nameLanding, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, itemName, itemIcon, itemQuality, itemID = GetLandingPageShipmentInfo(buildingID)
         -- Level 2
         -- No follower
         -- Have follower in possible list
         -- GMM_dumpl("name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, itemName, itemIcon, itemQuality, itemID", C_Garrison.GetLandingPageShipmentInfo(buildingID))
         -- GMM_dumpl("id, name, texPrefix, icon, description, rank, currencyID, currencyQty, goldQty, buildTime, needsPlan, isPrebuilt, possSpecs, upgrades, canUpgrade, isMaxLevel, hasFollowerSlot, knownSpecs, currSpec, specCooldown, isBuilding, startTime, buildDuration, timeLeftStr, canActivate", C_Garrison.GetOwnedBuildingInfo(buildingID))
         if shipmentCapacity and shipmentCapacity > 0 then
            local plotID = building.plotID
            local id, name, texPrefix, icon, description, rank, currencyID, currencyQty, goldQty, buildTime, needsPlan, isPrebuilt, possSpecs, upgrades, canUpgrade, isMaxLevel, hasFollowerSlot, knownSpecs, currSpec, specCooldown, isBuilding, startTime, buildDuration, timeLeftStr, canActivate = C_Garrison.GetOwnedBuildingInfo(plotID)
            -- print(nameLanding, hasFollowerSlot, rank, shipmentsReady)
            if hasFollowerSlot and rank and rank > 1 then -- TODO: check if just hasFollowerSlot is enough
               local followerName, level, quality, displayID, followerID, garrFollowerID, status, portraitIconID = GetFollowerInfoForBuilding(plotID)
               if not followerName then
                  local possible_followers = c_garrison_cache.GetPossibleFollowersForBuilding[plotID]
                  if #possible_followers > 0 then
                     for idx = 1, #possible_followers do
                        local possible_follower = possible_followers[idx]
                        for party_idx = 1, party_followers_count do
                           local party_follower = MissionPageFollowers[party_idx].info
                           if party_follower and possible_follower.followerID == party_follower.followerID then
                              shipment_followers[party_idx .. 'b'] = name
                              shipment_followers[party_idx .. 'r'] = shipmentsTotal and (shipmentsTotal - shipmentsReady)
                              shipment_followers[party_idx .. 't'] = timeleftString
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end

   for idx = 1, party_followers_count do
      local warning = gmm_frames["MissionPageFollowerWarning" .. idx]
      local building_name = shipment_followers[idx .. 'b']
      local time_left = shipment_followers[idx .. 't']
      local incomplete_shipments = shipment_followers[idx .. 'r']
      if building_name then
         if time_left then
            warning:SetFormattedText("%s%s %s (%d)", RED_FONT_COLOR_CODE, time_left, building_name, incomplete_shipments)
         else
            warning:SetFormattedText("%s%s", YELLOW_FONT_COLOR_CODE, building_name)
         end
         warning:Show()
      end
   end
end
addon_env.CheckPartyForProfessionFollowers = CheckPartyForProfessionFollowers
hooksecurefunc(GarrisonMissionFrame, "UpdateMissionParty", CheckPartyForProfessionFollowers)

local function MissionPage_WarningInit()
   for idx = 1, #MissionPageFollowers do
      local follower_frame = MissionPageFollowers[idx]
      -- TODO: inherit from name?
      local warning = follower_frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      warning:SetWidth(185)
      warning:SetHeight(1)
      warning:SetPoint("BOTTOM", follower_frame, "TOP", 0, -68)
      gmm_frames["MissionPageFollowerWarning" .. idx] = warning

      gmm_frames["MissionPageFollowerXP" .. idx]          = Widget{type = "Texture", parent = follower_frame, SubLayer = 3, Width = 104, Height = 4, BOTTOMLEFT = {55, 2}, Color = { 0.212, 0, 0.337 }, Hide = true }
      gmm_frames["MissionPageFollowerXPGainBase" .. idx]  = Widget{type = "Texture", parent = follower_frame, SubLayer = 2, Width = 104, Height = 4, BOTTOMLEFT = {55, 2}, Color = { 0.6, 1, 0 }, Hide = true }
      gmm_frames["MissionPageFollowerXPGainBonus" .. idx] = Widget{type = "Texture", parent = follower_frame, SubLayer = 1, Width = 104, Height = 4, BOTTOMLEFT = {55, 2}, Color = { 0, 0.75, 1 }, Hide = true }
   end
end

addon_env.MissionPage_ButtonsInit("MissionPage", MissionPage)
MissionPage_WarningInit()
addon_env.mission_page_button_prefix_for_type_id[LE_FOLLOWER_TYPE_GARRISON_6_0] = "MissionPage"
hooksecurefunc(GarrisonMissionFrame, "ShowMission", addon_env.ShowMission_More)

addon_env.MissionList_ButtonsInit(GarrisonMissionFrame.MissionTab.MissionList, "GarnisonMissionList")
local MissionList_Update_More = addon_env.MissionList_Update_More
local function GarrisonMissionFrame_MissionList_Update_More()
   MissionList_Update_More(GarrisonMissionFrame.MissionTab.MissionList, GarrisonMissionFrame_MissionList_Update_More, "GarnisonMissionList", LE_FOLLOWER_TYPE_GARRISON_6_0, GARRISON_CURRENCY)
end

hooksecurefunc(GarrisonMissionFrame.MissionTab.MissionList,            "Update", GarrisonMissionFrame_MissionList_Update_More)
hooksecurefunc(GarrisonMissionFrame.MissionTab.MissionList.listScroll, "update", GarrisonMissionFrame_MissionList_Update_More)

hooksecurefunc(GarrisonMissionFrame.FollowerList, "UpdateData", addon_env.GarrisonFollowerList_Update_More)
