local addon_name, addon_env = ...

-- [AUTOLOCAL START]
local After = C_Timer.After
local C_Garrison = C_Garrison
local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local CreateFrame = CreateFrame
local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE
local GARRISON_CURRENCY = GARRISON_CURRENCY
local GARRISON_FOLLOWER_IN_PARTY = GARRISON_FOLLOWER_IN_PARTY
local GARRISON_FOLLOWER_ON_MISSION = GARRISON_FOLLOWER_ON_MISSION
local GARRISON_FOLLOWER_ON_MISSION_WITH_DURATION = GARRISON_FOLLOWER_ON_MISSION_WITH_DURATION
local GARRISON_SHIP_OIL_CURRENCY = GARRISON_SHIP_OIL_CURRENCY
local GarrisonMissionFrame = GarrisonMissionFrame
local GetCurrencyInfo = GetCurrencyInfo
local GetFollowerInfo = C_Garrison.GetFollowerInfo
local GetFollowerMissionTimeLeft = C_Garrison.GetFollowerMissionTimeLeft
local GetFollowerStatus = C_Garrison.GetFollowerStatus
local GetItemInfoInstant = GetItemInfoInstant
local GetTime = GetTime
local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
local LE_FOLLOWER_TYPE_GARRISON_6_0 = LE_FOLLOWER_TYPE_GARRISON_6_0
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE
local RemoveFollowerFromMission = C_Garrison.RemoveFollowerFromMission
local dump = DevTools_Dump
local format = string.format
local pairs = pairs
local print = print
local tconcat = table.concat
local wipe = wipe
-- [AUTOLOCAL END]

local gmm_buttons = addon_env.gmm_buttons
local gmm_frames = addon_env.gmm_frames
local top = addon_env.top
local top_yield = addon_env.top_yield
local top_unavailable = addon_env.top_unavailable
local top_for_mission = addon_env.top_for_mission
local c_garrison_cache = addon_env.c_garrison_cache
local button_suffixes = addon_env.button_suffixes
local event_frame = addon_env.event_frame
local GetFilteredFollowers = addon_env.GetFilteredFollowers
local FindBestFollowersForMission = addon_env.FindBestFollowersForMission

local ignored_followers
function addon_env.LocalIgnoredFollowers()
   ignored_followers = addon_env.ignored_followers
end
addon_env.LocalIgnoredFollowers()

local currency_texture = {}
for _, currency in pairs({ GARRISON_CURRENCY, GARRISON_SHIP_OIL_CURRENCY, 823 --[[Apexis]] }) do
   local _, _, texture = GetCurrencyInfo(currency)
   currency_texture[currency] = "|T" .. texture .. ":0|t"
end

local time_texture = "|TInterface\\Icons\\spell_holy_borrowedtime:0|t"

local salvage_item = {
   bag       = 139593,
   crate     = 114119, -- outdated
   big_crate = 140590,
}

local salvage_textures = setmetatable({}, { __index = function(t, key)
   local item_id = salvage_item[key]

   if item_id then
      local itemID, itemType, itemSubType, itemEquipLoc, itemTexture = GetItemInfoInstant(item_id)
      itemTexture = "|T" .. itemTexture .. ":0|t"
      t[key] = itemTexture
      return itemTexture
   end
   return --[[ some default texture ]]
end})

local ilevel_maximums = {}
local gmm_follower_options = {}
addon_env.gmm_follower_options = gmm_follower_options
local function InitGMMFollowerOptions(gmm_options)
   local follower_type = gmm_options.follower_type
   local options = GarrisonFollowerOptions[follower_type]

   local gmm_prefix = gmm_options.gmm_prefix
   local base_frame = _G[options.missionFrame]
   local MissionTab = base_frame.MissionTab

   -- Calculated shortcuts
   gmm_options.base_frame  = base_frame
   gmm_options.currency    = C_Garrison.GetCurrencyTypes(options.garrisonType)
   gmm_options.MissionTab  = MissionTab
   gmm_options.MissionPage = MissionTab.MissionPage
   gmm_options.MissionList = MissionTab.MissionList
   gmm_options.gmm_button_mission_page_prefix = gmm_prefix .. "MissionPage"
   gmm_options.gmm_button_mission_list_prefix = gmm_prefix .. "MissionList"

   gmm_follower_options[follower_type] = gmm_options

   if gmm_options.ilevel_max then
      ilevel_maximums[gmm_options.ilevel_max] = true
   end

   return gmm_options
end
addon_env.InitGMMFollowerOptions = InitGMMFollowerOptions

local function SetTeamButtonText(button, top_entry)
   if top_entry.successChance then
      local xp_bonus, xp_bonus_icon
      if top_entry.xp_reward_wasted then
         local salvage_yard_level = c_garrison_cache.salvage_yard_level
         xp_bonus = ''
         if salvage_yard_level == 1 or top_entry.mission_level <= 94 then
            xp_bonus_icon = salvage_textures.bag
         elseif salvage_yard_level == 2 then
            xp_bonus_icon =  salvage_textures.crate
         elseif salvage_yard_level == 3 then
            xp_bonus_icon = salvage_textures.big_crate
         end
      else
         xp_bonus = top_entry.xpBonus
         if xp_bonus == 0 or top_entry.all_followers_maxed then
            xp_bonus = ''
            xp_bonus_icon = ''
         else
            xp_bonus_icon = " |TInterface\\Icons\\XPBonus_Icon:0|t"
         end
      end

      local multiplier, multiplier_icon = "", ""
      if top_entry.gold_rewards and top_entry.goldMultiplier > 1 then
         multiplier = top_entry.goldMultiplier
         multiplier_icon = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
      elseif top_entry.material_rewards and top_entry.materialMultiplier > 1 then
         multiplier = top_entry.materialMultiplier
         multiplier_icon = currency_texture[top_entry.material_rewards]
      end

      button:SetFormattedText(
         "%d%%\n%s%s%s%s%s",
         top_entry.successChance,
         xp_bonus, xp_bonus_icon,
         multiplier, multiplier_icon,
         top_entry.isMissionTimeImproved and time_texture or ""
      )
   else
      button:SetText()
   end
end

addon_env.concat_list = addon_env.concat_list or {}
local concat_list = addon_env.concat_list
local function SetTeamButtonTooltip(button)
   local followers = #button

   if followers > 0 then
      wipe(concat_list)
      local idx = 0

      for follower_idx = 1, #button do
         local follower = button[follower_idx]
         local name = button["name" .. follower_idx]
         local status = GetFollowerStatus(follower)
         if status == GARRISON_FOLLOWER_ON_MISSION then
            status = format(GARRISON_FOLLOWER_ON_MISSION_WITH_DURATION, GetFollowerMissionTimeLeft(follower))
         elseif status == GARRISON_FOLLOWER_IN_PARTY then
            status = nil
         end

         if idx ~= 0 then
            idx = idx + 1
            concat_list[idx] = "\n"
         end

         if status then
            idx = idx + 1
            concat_list[idx] = RED_FONT_COLOR_CODE
         end

         idx = idx + 1
         concat_list[idx] = name

         if status and status ~= GARRISON_FOLLOWER_IN_PARTY then
            idx = idx + 1
            concat_list[idx] = " ("
            idx = idx + 1
            concat_list[idx] = status
            idx = idx + 1
            concat_list[idx] = ")"
            idx = idx + 1
            concat_list[idx] = FONT_COLOR_CODE_CLOSE
         end
      end

      GameTooltip:SetOwner(button, "ANCHOR_CURSOR_RIGHT")
      GameTooltip:SetText(tconcat(concat_list, ''))
      GameTooltip:Show()
   end
end

local function MissionPage_PartyButtonOnClick(self)
   local method_base = self.method_base
   local follower_frames = self.follower_frames

   if self[1] then
      event_frame:UnregisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
      for idx = 1, #follower_frames do
         method_base:RemoveFollowerFromMission(follower_frames[idx])
      end

      for idx = 1, #follower_frames do
         local followerFrame = follower_frames[idx]
         local follower = self[idx]
         if follower then
            local followerInfo = C_Garrison.GetFollowerInfo(follower)
            method_base:AssignFollowerToMission(followerFrame, followerInfo)
         end
      end
      event_frame:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
   end

   method_base:UpdateMissionParty(follower_frames)
end

local function MissionList_PartyButtonOnClick(self)
   if addon_env.RegisterManualInterraction then addon_env.RegisterManualInterraction() end
   local pending_click
   local follower_type = self.follower_type
   if follower_type then
      pending_click = gmm_follower_options[follower_type].gmm_button_mission_page_prefix .. '1'
   else
      pending_click = "MissionPage1"
   end
   addon_env.mission_page_pending_click = pending_click
   return self:GetParent():Click()
end

function addon_env.MissionPage_ButtonsInit(follower_type)
   local opt = gmm_follower_options[follower_type]

   local button_prefix = opt.gmm_button_mission_page_prefix
   local parent_frame  = opt.MissionPage
   local method_base   = opt.base_frame

   local prev
   for suffix_idx = 1, #button_suffixes do
      local suffix = button_suffixes[suffix_idx]
      for idx = 1, 3 do
         local name = button_prefix .. suffix .. idx
         if not gmm_buttons[name] then
            local set_followers_button = CreateFrame("Button", nil, parent_frame, "UIPanelButtonTemplate")
            -- Ugly, but I can't just parent to BorderFrame - buttons would be visible even on map screen
            set_followers_button:SetFrameLevel(set_followers_button:GetFrameLevel() + 4)
            set_followers_button.follower_frames = parent_frame.Followers
            set_followers_button.method_base = method_base
            set_followers_button:SetText(idx)
            set_followers_button:SetWidth(100)
            set_followers_button:SetHeight(50)
            if not prev then
               set_followers_button:SetPoint("TOPLEFT", parent_frame, "TOPRIGHT", 0, 0)
            else
               set_followers_button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, 0)
            end

            if suffix ~= "Unavailable" then
               set_followers_button:SetScript("OnClick", MissionPage_PartyButtonOnClick)
            else
               set_followers_button:SetScript("OnMouseDown", nil)
               set_followers_button:SetScript("OnMouseUp", nil)
               set_followers_button:HookScript("OnShow", addon_env.OnShowEmulateDisabled)
            end

            set_followers_button:SetScript('OnEnter', SetTeamButtonTooltip)
            set_followers_button:SetScript('OnLeave', addon_env.HideGameTooltip)

            prev = set_followers_button
            gmm_buttons[name] = set_followers_button
         end
      end
   end
   gmm_buttons[button_prefix .. 'Yield1']:SetPoint("TOPLEFT", gmm_buttons[button_prefix .. '3'], "BOTTOMLEFT", 0, -50)
   gmm_buttons[button_prefix .. 'Unavailable1']:SetPoint("TOPLEFT", gmm_buttons[button_prefix .. 'Yield3'], "BOTTOMLEFT", 0, -50)

   local button = CreateFrame("Button", nil, parent_frame)
   button:SetNormalTexture("Interface\\Buttons\\UI-LinkProfession-Up")
   button:SetPushedTexture("Interface\\Buttons\\UI-LinkProfession-Down")
   button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
   button:SetHeight(30)
   button:SetWidth(30)
   button.tooltip = BROWSER_COPY_LINK .. " (Wowhead)"
   button:SetPoint("RIGHT", parent_frame.Stage.Title, "LEFT", 0, 0)
   button:SetScript("OnEnter", addon_env.OnEnterShowGameTooltip)
   button:SetScript("OnLeave", addon_env.HideGameTooltip)
   button:SetScript("OnClick", function()
      local chat_box = ACTIVE_CHAT_EDIT_BOX or LAST_ACTIVE_CHAT_EDIT_BOX
      if chat_box then
         local missionInfo = parent_frame.missionInfo
         local mission_id = missionInfo.missionID
         if mission_id then
            local existing_text = chat_box:GetText()
            local inserted_text = ("http://www.wowhead.com/mission=%s"):format(mission_id)
            if existing_text:find(inserted_text, 1, true) then return end
            -- TODO: what really should be cheked is that there's no space before cursor
            if existing_text ~= "" and not existing_text:find(" $") then inserted_text = " " .. inserted_text end
            ChatEdit_ActivateChat(chat_box)
            chat_box:Insert(inserted_text)
         end
      end
   end)
end

function addon_env.MissionList_ButtonsInit(follower_type)
   local opt = gmm_follower_options[follower_type]
   local blizzard_mission_list = opt.MissionList
   local frame_prefix          = opt.gmm_button_mission_list_prefix

   local level_anchor = blizzard_mission_list.listScroll
   local blizzard_buttons = blizzard_mission_list.listScroll.buttons
   for idx = 1, #blizzard_buttons do
      local blizzard_button = blizzard_buttons[idx]
      if not gmm_buttons[frame_prefix .. idx] then
         -- move first reward to left a little, rest are anchored to first
         local reward = blizzard_button.Rewards[1]
         for point_idx = 1, reward:GetNumPoints() do
            local point, relative_to, relative_point, x, y = reward:GetPoint(point_idx)
            if point == "RIGHT" then
               x = x - 60
               reward:SetPoint(point, relative_to, relative_point, x, y)
               break
            end
         end

         local set_followers_button = CreateFrame("Button", nil, blizzard_button, "UIPanelButtonTemplate")
         set_followers_button:SetText(idx)
         set_followers_button:SetWidth(80)
         set_followers_button:SetHeight(40)
         set_followers_button:SetPoint("LEFT", blizzard_button, "RIGHT", -65, 0)
         set_followers_button:SetScript("OnClick", MissionList_PartyButtonOnClick)
         set_followers_button.follower_type = follower_type
         gmm_buttons[frame_prefix .. idx] = set_followers_button
      end

      if not gmm_frames[frame_prefix .. 'ExpirationText' .. idx] then
         local expiration = blizzard_button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
         expiration:SetWidth(500)
         expiration:SetHeight(1)
         expiration:SetPoint("BOTTOMRIGHT", blizzard_button, "BOTTOMRIGHT", -10, 8)
         expiration:SetJustifyH("RIGHT")
         gmm_frames[frame_prefix .. 'ExpirationText' .. idx] = expiration
      end
   end
   -- GarrisonMissionFrame.MissionTab.MissionList.listScroll.scrollBar:SetFrameLevel(gmm_buttons['MissionList1']:GetFrameLevel() - 3)
end

local function BestForCurrentSelectedMission(type_id, mission_page, button_prefix)
   if addon_env.RegisterManualInterraction then addon_env.RegisterManualInterraction() end

   local missionInfo = mission_page.missionInfo
   local mission_id = missionInfo.missionID

   -- print("Mission ID:", mission_id)

   local filtered_followers = GetFilteredFollowers(type_id)

   local mission = missionInfo

   -- dump(mission)

   FindBestFollowersForMission(mission, filtered_followers)

   for suffix_idx = 1, #button_suffixes do
      local suffix = button_suffixes[suffix_idx]
      for idx = 1, 3 do
         local button = gmm_buttons[button_prefix .. suffix .. idx]
         if addon_env.b then button:Disable() end
         local top_entry
         if suffix == 'Yield' then
            if top.yield or top.material_rewards or top.gold_rewards then
               top_entry = top_yield[idx]
            else
               top_entry = false
            end
         elseif suffix == 'Unavailable' then
            top_entry = top_unavailable[idx]
         else
            top_entry = top[idx]
         end

         if top_entry ~= false then
            local follower = top_entry[1] if follower then button[1] = follower.followerID button.name1 = follower.name else button[1] = nil end
            local follower = top_entry[2] if follower then button[2] = follower.followerID button.name2 = follower.name else button[2] = nil end
            local follower = top_entry[3] if follower then button[3] = follower.followerID button.name3 = follower.name else button[3] = nil end
            SetTeamButtonText(button, top_entry)
            button:Show()
         else
            button:Hide()
         end
      end
   end

   local mission_page_pending_click = addon_env.mission_page_pending_click
   if mission_page_pending_click then
      MissionPage_PartyButtonOnClick(gmm_buttons[mission_page_pending_click])
      addon_env.mission_page_pending_click = nil
   end
end
addon_env.BestForCurrentSelectedMission = BestForCurrentSelectedMission

local function ShowMission_More(self, missionInfo)
   local mission_page = self.MissionTab.MissionPage
   if not mission_page:IsShown() then return end
   local follower_type_id = self.followerTypeID

   local stage = mission_page.Stage
   if mission_page.showItemLevel then
      mission_page.showItemLevel = false
      stage.Level:SetPoint("CENTER", stage.Header, "TOPLEFT", 30, -36)
      stage.ItemLevel:Hide()
   end

   if missionInfo.iLevel > 0 and missionInfo.iLevel ~= 760 then
      stage.Level:SetText(missionInfo.iLevel)
      mission_page.ItemLevelHitboxFrame:Show()
   else
      mission_page.ItemLevelHitboxFrame:Hide()
   end

   BestForCurrentSelectedMission(follower_type_id, mission_page, gmm_follower_options[follower_type_id].gmm_button_mission_page_prefix)
end
addon_env.ShowMission_More = ShowMission_More

local function UpdateMissionListButton(mission, filtered_followers, blizzard_button, gmm_button, more_missions_to_cache, resources, inactive_alpha)
   local cant_complete = mission.cost > resources
   if not cant_complete then
      local options = gmm_follower_options[filtered_followers.type]
      if options.party_requires_one_non_troop then
         cant_complete = not filtered_followers.free_non_troop
      else
         cant_complete = mission.numFollowers > filtered_followers.free
      end
   end

   if cant_complete then
      blizzard_button:SetAlpha(inactive_alpha or 0.3)
      gmm_button:SetText()
   else
      local top_for_this_mission = top_for_mission[mission.missionID]
      if not top_for_this_mission then
         if more_missions_to_cache then
            more_missions_to_cache = more_missions_to_cache + 1
         else
            more_missions_to_cache = 0
            FindBestFollowersForMission(mission, filtered_followers, "mission_list")
            local top1 = top[1]
            top_for_this_mission = {}
            top_for_this_mission.successChance = top1.successChance
            if top_for_this_mission.successChance then
               top_for_this_mission.materialMultiplier = top1.materialMultiplier
               top_for_this_mission.material_rewards = top1.material_rewards
               top_for_this_mission.goldMultiplier = top1.goldMultiplier
               top_for_this_mission.gold_rewards = top1.gold_rewards
               top_for_this_mission.xpBonus = top1.xpBonus
               top_for_this_mission.isMissionTimeImproved = top1.isMissionTimeImproved
               top_for_this_mission.xp_reward_wasted = top1.xp_reward_wasted
               top_for_this_mission.all_followers_maxed = top1.all_followers_maxed
               top_for_this_mission.mission_level = top1.mission_level
            end
            top_for_mission[mission.missionID] = top_for_this_mission
         end
      end

      if top_for_this_mission then
         SetTeamButtonText(gmm_button, top_for_this_mission)
      else
         gmm_button:SetText("...")
      end
      blizzard_button:SetAlpha(1)
   end
   gmm_button:Show()

   return more_missions_to_cache
end
addon_env.UpdateMissionListButton = UpdateMissionListButton

-- Add more data to mission list over Blizzard's own
local mission_expiration_format_days  = "%s" .. DAY_ONELETTER_ABBR:gsub(" ", "") .. " %02d:%02d"
local mission_expiration_format_hours = "%s" ..                                        "%d:%02d"
local function MissionList_Update_More(self, caller, frame_prefix, follower_type, currency)
   -- Blizzard updates those when not visible too, but there's no reason to copy them.
   if not self:IsVisible() then return end
   local scrollFrame = self.listScroll
   local buttons = scrollFrame.buttons
   local numButtons = #buttons

   if self.showInProgress then
      for i = 1, numButtons do
         gmm_buttons[frame_prefix .. i]:Hide()
         gmm_frames[frame_prefix .. 'ExpirationText' .. i]:SetText()
         buttons[i]:SetAlpha(1)
      end
      return
   end

   local missions = self.availableMissions
   local numMissions = #missions
   if numMissions == 0 then return end

   if addon_env.top_for_mission_dirty then
      wipe(top_for_mission)
      addon_env.top_for_mission_dirty = false
   end

   local missions = self.availableMissions
   local offset = HybridScrollFrame_GetOffset(scrollFrame)

   local filtered_followers = GetFilteredFollowers(follower_type)
   local more_missions_to_cache
   local _, garrison_resources = GetCurrencyInfo(currency)

   local time = GetTime()

   for i = 1, numButtons do
      local button = buttons[i]
      local alpha = 1
      local index = offset + i
      if index <= numMissions then
         local mission = missions[index]
         local gmm_button = gmm_buttons[frame_prefix .. i]

         more_missions_to_cache = UpdateMissionListButton(mission, filtered_followers, button, gmm_button, more_missions_to_cache, garrison_resources)

         local is_rare = mission.isRare

         local expiration_text_set
         local offerEndTime = mission.offerEndTime

         -- offerEndTime seems to be present on all missions, though Blizzard UI shows tooltips only on rare
         -- some Legion missions actually have no end time - seems like they're permanent
         if offerEndTime then
            local xp_only_rewards
            if not is_rare then
               for _, reward in pairs(mission.rewards) do
                  if reward.followerXP and xp_only_rewards == nil then xp_only_rewards = true end
                  if not reward.followerXP then xp_only_rewards = false break end
               end
            end

            if not xp_only_rewards then
               local remaining = offerEndTime - time -- seconds at this line, but will be reduced to minutes/hours/days below
               local color_code = (remaining < (60 * 60 * 8)) and RED_FONT_COLOR_CODE or ''
               local seconds = remaining % 60
               remaining = (remaining - seconds) / 60
               local minutes = remaining % 60
               remaining = (remaining - minutes) / 60
               local hours = remaining % 24
               local days = (remaining - hours) / 24
               if days > 0 then
                  gmm_frames[frame_prefix .. 'ExpirationText' .. i]:SetFormattedText(mission_expiration_format_days, color_code, days, hours, minutes)
               else
                  gmm_frames[frame_prefix .. 'ExpirationText' .. i]:SetFormattedText(mission_expiration_format_hours, color_code, hours, minutes)
               end
               expiration_text_set = true
            end
         end

         if not expiration_text_set then
            gmm_frames[frame_prefix .. 'ExpirationText' .. i]:SetText()
         end

         -- Just overwrite level with ilevel if it is not 0. There's no use knowing what base level mission have.
         -- Blizzard UI also checks that mission is max "normal" UI, but there's at least one mission mistakenly marked as level 90, despite requiring 675 ilevel.
         -- 760 exception is for Order Hall missions bellow max level.
         if button.ItemLevel:IsShown() then
            button.ItemLevel:Hide()
            -- Restore position that Blizzard's UI changes if mission have both ilevel and rare! text
            if mission.isRare then
               button.Level:SetPoint("CENTER", button, "TOPLEFT", 40, -36)
            end
         end

         if mission.iLevel > 0 and mission.iLevel ~= 760 then
            button.Level:SetFormattedText("|cffffffd9%d", mission.iLevel)
         end
      end
   end

   if more_missions_to_cache and more_missions_to_cache > 0 then
      -- print(more_missions_to_cache, GetTime())
      After(0.001, caller)
   end
end
addon_env.MissionList_Update_More = MissionList_Update_More

local maxed_follower_color_code = "|cff22aa22"

local function GarrisonMissionFrame_SetFollowerPortrait_More(portraitFrame, followerInfo, forMissionPage)
   if not forMissionPage then return end

   local MissionPage = portraitFrame:GetParent():GetParent()
   local mentor_level = MissionPage.mentorLevel
   local mentor_i_level = MissionPage.mentorItemLevel

   local level = followerInfo.level
   local i_level = followerInfo.iLevel

   local boosted

   if mentor_i_level and mentor_i_level > (i_level or 0) then
      i_level = mentor_i_level
      boosted = true
   end
   if mentor_level and mentor_level > level then
      level = mentor_level
      boosted = true
   end

   if followerInfo.isMaxLevel then
      local level_border = portraitFrame.LevelBorder
      level_border:SetAtlas("GarrMission_PortraitRing_iLvlBorder")
      level_border:SetWidth(70)
      portraitFrame.Level:SetFormattedText("%s%s %d", (ilevel_maximums[i_level] and not boosted) and maxed_follower_color_code or "", ITEM_LEVEL_ABBR, i_level)
   end
end
hooksecurefunc("GarrisonMissionPortrait_SetFollowerPortrait", GarrisonMissionFrame_SetFollowerPortrait_More)

local function GarrisonFollowerList_Update_More(self)
   -- Somehow Blizzard UI insists on updating hidden frames AND explicitly updates them OnShow.
   --  Following suit is just a waste of CPU, so we'll update only when frame is actually visible.
   if not self:IsVisible() then return end

   local followerFrame = self:GetParent()
   local followers = followerFrame.FollowerList.followers
   local followersList = followerFrame.FollowerList.followersList
   local numFollowers = #followersList
   local scrollFrame = followerFrame.FollowerList.listScroll
   local offset = HybridScrollFrame_GetOffset(scrollFrame)
   local buttons = scrollFrame.buttons
   local numButtons = #buttons

   for i = 1, numButtons do
      local button = buttons[i]
      local index = offset + i

      local show_ilevel
      local follower_frame = button.Follower
      local portrait_frame = follower_frame.PortraitFrame
      local level_border = portrait_frame.LevelBorder

      if ( index <= numFollowers ) then
         local follower_index = followersList[index]
         -- follower_index 0 - category header
         if follower_index ~= 0 then
            local follower = followers[follower_index]
            if ( follower.isCollected ) then
               if ignored_followers[follower.followerID] then
                  local BusyFrame = follower_frame.BusyFrame
                  BusyFrame.Texture:SetColorTexture(0.5, 0, 0, 0.3)
                  BusyFrame:Show()
               end

               if follower.isMaxLevel then
                  level_border:SetAtlas("GarrMission_PortraitRing_iLvlBorder")
                  level_border:SetWidth(70)
                  local i_level = follower.iLevel
                  portrait_frame.Level:SetFormattedText("%s%s %d", ilevel_maximums[i_level] and maxed_follower_color_code or "", ITEM_LEVEL_ABBR, i_level)
                  follower_frame.ILevel:SetText(nil)
                  show_ilevel = true
               end
            end
         end
      end
      if follower_index ~= 0 and not show_ilevel then
         level_border:SetAtlas("GarrMission_PortraitRing_LevelBorder")
         level_border:SetWidth(58)
      end
   end
end
addon_env.GarrisonFollowerList_Update_More = GarrisonFollowerList_Update_More

local last_shipment_request = 0
local function ThrottleRequestLandingPageShipmentInfo()
   local time = GetTime()
   if last_shipment_request + 5 < time then
      last_shipment_request = time
      event_frame:RegisterEvent("GARRISON_LANDINGPAGE_SHIPMENTS")
      C_Garrison.RequestLandingPageShipmentInfo()
      return true
   end
end
addon_env.ThrottleRequestLandingPageShipmentInfo = ThrottleRequestLandingPageShipmentInfo
