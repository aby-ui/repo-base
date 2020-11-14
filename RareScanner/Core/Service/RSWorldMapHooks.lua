-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local RSWorldMapHooks = private.NewLib("RareScannerWorldMapHooks")

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner service libraries
local RSMinimap = private.ImportLib("RareScannerMinimap")

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

function RSWorldMapHooks.HookDropDownMenu()
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
				info.text = "RareScanner";

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
				info.checked = RSConfigDB.IsShowingNpcs()
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_SHOW_CONTAINERS"];
				info.value = SHOW_CONTAINER_ICONS;
				info.checked = RSConfigDB.IsShowingContainers()
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_SHOW_EVENTS"];
				info.value = SHOW_EVENT_ICONS;
				info.checked = RSConfigDB.IsShowingEvents()
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_FILTER"];
				info.value = DISABLE_LAST_SEEN_FILTER;
				info.checked = not RSConfigDB.IsMaxSeenTimeFilterEnabled()
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_CONTAINER_FILTER"];
				info.value = DISABLE_LAST_SEEN_CONTAINER_FILTER;
				info.checked = not RSConfigDB.IsMaxSeenTimeContainerFilterEnabled()
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_EVENT_FILTER"];
				info.value = DISABLE_LAST_SEEN_EVENT_FILTER;
				info.checked = not RSConfigDB.IsMaxSeenTimeEventFilterEnabled()
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_SHOW_NOT_DISCOVERED"];
				info.value = SHOW_NOT_DISCOVERED_ICONS;
				info.checked = RSConfigDB.IsShowingNotDiscoveredMapIcons()
				UIDropDownMenu_AddButton(info);

				info.text = AL["MAP_MENU_SHOW_NOT_DISCOVERED_OLD"];
				info.value = SHOW_NOT_DISCOVERED_ICONS_OLD;
				info.checked = RSConfigDB.IsShowingOldNotDiscoveredMapIcons()
				UIDropDownMenu_AddButton(info);
			end)

			hooksecurefunc(overlayFrame, 'OnSelection', function(self, value, checked)
				if (value == SHOW_RARE_NPC_ICONS) then
					RSConfigDB.SetShowingNpcs(checked)
					RSMinimap.RefreshAllData(true)
				elseif (value == SHOW_CONTAINER_ICONS) then
					RSConfigDB.SetShowingContainers(checked)
					RSMinimap.RefreshAllData(true)
				elseif (value == SHOW_EVENT_ICONS) then
					RSConfigDB.SetShowingEvents(checked)
					RSMinimap.RefreshAllData(true)
				elseif (value == SHOW_NOT_DISCOVERED_ICONS) then
					RSConfigDB.SetShowingNotDiscoveredMapIcons(checked)
					RSMinimap.RefreshAllData(true)
				elseif (value == SHOW_NOT_DISCOVERED_ICONS_OLD) then
					RSConfigDB.SetShowingOldNotDiscoveredMapIcons(checked)
					RSMinimap.RefreshAllData(true)
				elseif (value == DISABLE_LAST_SEEN_FILTER) then
					if (checked) then
						RSConfigDB.DisableMaxSeenTimeFilter()
					else
						RSConfigDB.EnableMaxSeenTimeFilter()
					end
					RSMinimap.RefreshAllData(true)
				elseif (value == DISABLE_LAST_SEEN_CONTAINER_FILTER) then
					if (checked) then
						RSConfigDB.DisableMaxSeenContainerTimeFilter()
					else
						RSConfigDB.EnableMaxSeenContainerTimeFilter()
					end
					RSMinimap.RefreshAllData(true)
				elseif (value == DISABLE_LAST_SEEN_EVENT_FILTER) then
					if (checked) then
						RSConfigDB.DisableMaxSeenEventTimeFilter()
					else
						RSConfigDB.EnableMaxSeenEventTimeFilter()
					end
					RSMinimap.RefreshAllData(true)
				end
				self:GetParent():RefreshAllDataProviders();
			end)
			break
		end
	end
end
