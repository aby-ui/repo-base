local addon_name, addon_env = ...

-- [AUTOLOCAL START]
local C_Garrison = C_Garrison
local CastSpellOnFollower = C_Garrison.CastSpellOnFollower
local GARRISON_FOLLOWER_MAX_LEVEL = GARRISON_FOLLOWER_MAX_LEVEL
local GarrisonMissionFrame = GarrisonMissionFrame
local GetFollowerInfo = C_Garrison.GetFollowerInfo
local GetFollowerItems = C_Garrison.GetFollowerItems
local type = type
-- [AUTOLOCAL END]

local Widget = addon_env.Widget

local function SetGameTooltipToItem(self)
   GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
   if (self.itemID) then
      GameTooltip:SetItemByID(self.itemID)
      return
   end
end

-- Clickable buttons attached to follower tab
local upgrade_item_button = {}
-- Fontstrings attached to their respective buttons
local upgrade_item_quantity = {}

-- List of items of each type and their strength; filled in respective file for Garrison/Order Hall
local upgrade_items = {}
local upgrade_item_strength = {}
addon_env.upgrade_items = upgrade_items
addon_env.upgrade_item_strength = upgrade_item_strength

local template_upgrade_button = {
   "Button",
   nil,
   "SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate",
   Height = 42, Width = 42,
   OnEnter = SetGameTooltipToItem,
   OnLeave = addon_env.HideGameTooltip,
   -- HighlightTexture = Widget{
   --    "Texture",
   --    Texture = "Interface\\BUTTONS\\UI-Common-MouseHilight",
   --    TexCoord = { 0.15, 0.85, 0.15, 0.85 },
   --    BlendMode = "ADD",
   -- },
}

local function UpgradeItemButton_CastSpellOnCurrentFollower()
   CastSpellOnFollower(GarrisonMissionFrame.FollowerTab.followerID)
end

local function UpgradeItems_InitButtons()
   for item_type = 1, #upgrade_items do
      local item_list = upgrade_items[item_type]
      local prev = item_list.anchor
      template_upgrade_button[2] = item_list.parent

      for item_idx = 1, #item_list do
         local item_id = item_list[item_idx]
         if not upgrade_item_button[item_id] then

            template_upgrade_button.TextureToItem = item_id
            local u = Widget(template_upgrade_button)
            u.itemID = item_id
            u:SetPoint("LEFT", prev, "RIGHT", 1, 0)

            local strength = upgrade_item_strength[item_id]
            if strength then
               -- Widget{"FontString", u, "NumberFontNormal", TOPLEFT = true, Text = strength > 100 and strength or "+" .. strength}
               u:SetAttribute("type", "item")
               u:SetAttribute("item", "item:" .. item_id)
               u:SetAttribute("shift-type*", "item")
               u:SetAttribute("shift-item*", "item:" .. item_id)
               u.UpgradeItemButton_CastSpellOnCurrentFollower = UpgradeItemButton_CastSpellOnCurrentFollower
               SecureHandlerWrapScript(u, "OnClick", u, "return nil, 'postclick'", [[
                  if self:GetEffectiveAttribute("type", button) == "item" then
                     self:CallMethod("UpgradeItemButton_CastSpellOnCurrentFollower")
                  end
               ]])
            else
               u:SetAttribute("type", "item")
               u:SetAttribute("item", "item:" .. item_id)
            end

            upgrade_item_quantity[item_id] = Widget{"FontString", u, "NumberFontNormal", BOTTOMRIGHT = true }

            upgrade_item_button[item_id] = u
            prev = u
         end
      end
   end
end
addon_env.UpgradeItems_InitButtons = UpgradeItems_InitButtons

local upgrade_item_normal_textures = setmetatable({}, { __index = function(t, key)
   local u = upgrade_item_button[key]
   local result = u:GetNormalTexture()
   return result
end})

local function UpdateUpgradeItemStates(self, followerID, followerInfo)
   if not followerID then
      -- Ugh, kind of hackish/ugly too.
      local FollowerTab = GarrisonMissionFrame.FollowerTab
      if not FollowerTab and FollowerTab:IsVisible() then
         FollowerTab = OrderHallMissionFrame.FollowerTab
         if not FollowerTab and FollowerTab:IsVisible() then return end
      end
      followerID = FollowerTab.followerID
      if not followerID then return end
      if not followerInfo then followerInfo = GetFollowerInfo(followerID) end
   end

   if not followerInfo.isCollected then return end
   if followerInfo.level < GARRISON_FOLLOWER_MAX_LEVEL then return end

   self:Show()
   local _, ilvl_weapon, _, ilvl_armor = GetFollowerItems(followerID)

   for item_type = 1, #upgrade_items do
      local ilvl_current_type = item_type == 1 and ilvl_weapon or ilvl_armor
      local item_list = upgrade_items[item_type]
      local prev = item_list.parent
      for item_idx = 1, #item_list do
         local item_id = item_list[item_idx]

         local count = GetItemCount(item_id)
         if count > 0 then
            upgrade_item_quantity[item_id]:SetText(count)
            local texture = upgrade_item_normal_textures[item_id]
            texture:SetDesaturated(false)
            texture:SetAlpha(1)

            local strength = upgrade_item_strength[item_id]
            if strength then
               local action_button_type = "item"
               local shift_action_button_type = "item"
               if ilvl_current_type == 675 or (strength > 600 and ilvl_current_type >= strength) then
                  -- Fadeout and disable button if upgrade is absolutely useless
                  -- i.e. follower has max level or fixed level upgrade is lower than follower current ilevel
                  texture:SetVertexColor(1, 1, 1)
                  texture:SetAlpha(0.3)
                  action_button_type = nil
                  shift_action_button_type = nil
               elseif (strength > 3 and strength < 100 and ilvl_current_type + strength > 677) or (strength > 600 and strength - ilvl_current_type < 7) then
                  -- Dye upgrade yellow and allow only forced use through shift-click if it would be too much waste to use it
                  -- i.e fixed level upgrade providing less than 7 levels or small upgrades providing less than 4 levels.
                  texture:SetVertexColor(1, 1, 0)
                  action_button_type = nil
               else
                  texture:SetVertexColor(1, 1, 1)
               end
               local button = upgrade_item_button[item_id]
               button:SetAttribute("type", action_button_type)
               button:SetAttribute("shift-type*", shift_action_button_type)
            end
         else
            upgrade_item_quantity[item_id]:SetText(nil)
            local texture = upgrade_item_normal_textures[item_id]
            texture:SetDesaturated(true)
            texture:SetAlpha(0.3)
            texture:SetVertexColor(1, 1, 1)
         end
      end
   end
end

local function UpgradeParent_OnEvent(self, event)
   if event == "BAG_UPDATE_DELAYED" or event == "PLAYER_REGEN_ENABLED" then
      return UpdateUpgradeItemStates(self)
   else
      self:Hide()
   end
end

local function UpgradeItems_InitEvents(base_frame, upgrade_buttons_parent)
   local FollowerList = base_frame.FollowerList
   local FollowerTab = base_frame.FollowerTab

   hooksecurefunc(FollowerList, "ShowFollower", function(self)
      local followerID = FollowerTab.followerID
      if not followerID then return end
      local followerInfo = GetFollowerInfo(followerID)

      UpdateUpgradeItemStates(upgrade_buttons_parent, followerID, followerInfo)
   end)

   upgrade_buttons_parent:HookScript("OnShow", function(self)
      UpdateUpgradeItemStates(self)
      upgrade_buttons_parent:RegisterEvent("BAG_UPDATE_DELAYED")
      upgrade_buttons_parent:RegisterEvent("PLAYER_REGEN_ENABLED")
      upgrade_buttons_parent:RegisterEvent("PLAYER_REGEN_DISABLED")
   end)

   upgrade_buttons_parent:HookScript("OnHide", function()
      upgrade_buttons_parent:UnregisterEvent("BAG_UPDATE_DELAYED")
      upgrade_buttons_parent:UnregisterEvent("PLAYER_REGEN_ENABLED")
      upgrade_buttons_parent:UnregisterEvent("PLAYER_REGEN_DISABLED")
   end)

   upgrade_buttons_parent:SetScript("OnEvent", UpgradeParent_OnEvent)
end
addon_env.UpgradeItems_InitEvents = UpgradeItems_InitEvents
