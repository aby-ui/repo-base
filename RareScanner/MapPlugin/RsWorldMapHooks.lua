-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- Constants
local SHOW_RARE_NPC_ICONS = "rsHideRareNpcs"
local SHOW_CONTAINER_ICONS = "rsHideContainers"
local SHOW_EVENT_ICONS = "rsHideEvents"
local SHOW_NOT_DISCOVERED_ICONS = "rsHideNotDiscovered"
local SHOW_NOT_DISCOVERED_ICONS_OLD = "rsHideNotDiscoveredOld"
local DISABLE_LAST_SEEN_FILTER = "rsDisableLastSeenFilter"
local DISABLE_LAST_SEEN_CONTAINER_FILTER = "rsDisableLastSeenContainerFilter"
local DISABLE_LAST_SEEN_EVENT_FILTER = "rsDisableLastSeenEventFilter"

function RareScanner:HookDropDownMenu()
	for _, overlayFrame in next, WorldMapFrame.overlayFrames do
		if(overlayFrame.Border and overlayFrame.Border:GetTexture() == 'Interface\\Minimap\\MiniMap-TrackingBorder') then
			hooksecurefunc(overlayFrame, 'InitializeDropDown', function(self)
				local function OnSelection(button)
					self:OnSelection(button.value, button.checked);
				end
  
				UIDropDownMenu_AddSeparator();
				local info = UIDropDownMenu_CreateInfo();
				
				info.isTitle = true;
				info.notCheckable = true;
				info.text = GetLocale():sub(1,2)=="zh" and "稀有精英探测" or "RareScanner";
				
				UIDropDownMenu_AddButton(info);
				info.text = nil;
				 
				info.isTitle = nil;
				info.disabled = nil;
				info.notCheckable = nil;
				info.isNotRadio = true;
				info.keepShownOnClick = true;
				info.func = OnSelection;

				info.text = AL["MAP_MENU_SHOW_RARE_NPCS"];
				info.value = SHOW_RARE_NPC_ICONS;
				info.checked = private.db.map.displayNpcIcons
				UIDropDownMenu_AddButton(info);
				 
				info.text = AL["MAP_MENU_SHOW_CONTAINERS"];
				info.value = SHOW_CONTAINER_ICONS;
				info.checked = private.db.map.displayContainerIcons
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_SHOW_EVENTS"];
				info.value = SHOW_EVENT_ICONS;
				info.checked = private.db.map.displayEventIcons
				UIDropDownMenu_AddButton(info);

                --[[
				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_FILTER"];
				info.value = DISABLE_LAST_SEEN_FILTER;
				info.checked = private.db.map.disableLastSeenFilter
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_CONTAINER_FILTER"];
				info.value = DISABLE_LAST_SEEN_CONTAINER_FILTER;
				info.checked = private.db.map.disableLastSeenContainerFilter
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_EVENT_FILTER"];
				info.value = DISABLE_LAST_SEEN_EVENT_FILTER;
				info.checked = private.db.map.disableLastSeenEventFilter
				UIDropDownMenu_AddButton(info);
				--]]
				 
				info.text = AL["MAP_MENU_SHOW_NOT_DISCOVERED"];
				info.value = SHOW_NOT_DISCOVERED_ICONS;
				info.checked = private.db.map.displayNotDiscoveredMapIcons
				UIDropDownMenu_AddButton(info);
				 
				info.text = AL["MAP_MENU_SHOW_NOT_DISCOVERED_OLD"];
				info.value = SHOW_NOT_DISCOVERED_ICONS_OLD;
				info.checked = private.db.map.displayOldNotDiscoveredMapIcons
				UIDropDownMenu_AddButton(info);
			end)
			
			local origOverlayFrame_onSelection = overlayFrame.OnSelection;
			overlayFrame.OnSelection = function(self, value, checked)
				if (value == SHOW_RARE_NPC_ICONS) then
					private.db.map.displayNpcIcons = checked
				elseif (value == SHOW_CONTAINER_ICONS) then
					private.db.map.displayContainerIcons = checked
				elseif (value == SHOW_EVENT_ICONS) then
					private.db.map.displayEventIcons = checked
				elseif (value == SHOW_NOT_DISCOVERED_ICONS) then
					private.db.map.displayNotDiscoveredMapIcons = checked
				elseif (value == SHOW_NOT_DISCOVERED_ICONS_OLD) then
					private.db.map.displayOldNotDiscoveredMapIcons = checked
				elseif (value == DISABLE_LAST_SEEN_FILTER) then
					if (not private.db.map.maxSeenTimeBak) then
						private.db.map.maxSeenTimeBak = private.db.map.maxSeenTime
					end
					private.db.map.disableLastSeenFilter = checked
					if (private.db.map.disableLastSeenFilter) then
						private.db.map.maxSeenTime = 0
					else
						private.db.map.maxSeenTime = private.db.map.maxSeenTimeBak 
					end
				elseif (value == DISABLE_LAST_SEEN_CONTAINER_FILTER) then
					if (not private.db.map.maxSeenContainerTimeBak) then
						private.db.map.maxSeenContainerTimeBak = private.db.map.maxSeenTimeContainer
					end
					private.db.map.disableLastSeenContainerFilter = checked
					if (private.db.map.disableLastSeenContainerFilter) then
						private.db.map.maxSeenTimeContainer = 0
					else
						private.db.map.maxSeenTimeContainer = private.db.map.maxSeenContainerTimeBak 
					end
				elseif (value == DISABLE_LAST_SEEN_EVENT_FILTER) then
					if (not private.db.map.maxSeenEventTimeBak) then
						private.db.map.maxSeenEventTimeBak = private.db.map.maxSeenTimeEvent
					end
					private.db.map.disableLastSeenEventFilter = checked
					if (private.db.map.disableLastSeenEventFilter) then
						private.db.map.maxSeenTimeEvent = 0
					else
						private.db.map.maxSeenTimeEvent = private.db.map.maxSeenEventTimeBak 
					end
				end
				origOverlayFrame_onSelection(self, value, checked)
			end
			break
		end
	end
end
