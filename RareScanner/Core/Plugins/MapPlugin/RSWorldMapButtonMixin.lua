-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner service libraries
local RSMinimap = private.ImportLib("RareScannerMinimap")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- Thirdparty
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

-- Constants
local SHOW_RARE_NPC_ICONS = "rsHideRareNpcs"
local SHOW_CONTAINER_ICONS = "rsHideContainers"
local SHOW_EVENT_ICONS = "rsHideEvents"
local SHOW_NOT_DISCOVERED_ICONS = "rsHideNotDiscovered"
local SHOW_NOT_DISCOVERED_ICONS_OLD = "rsHideNotDiscoveredOld"
local DISABLE_LAST_SEEN_FILTER = "rsDisableLastSeenFilter"
local DISABLE_LAST_SEEN_CONTAINER_FILTER = "rsDisableLastSeenContainerFilter"
local DISABLE_LAST_SEEN_EVENT_FILTER = "rsDisableLastSeenEventFilter"


RSWorldMapButtonMixin = { }

local function WorldMapButtonDropDownMenu_Initialize(dropDown)
	local OnSelection = function(self, value)
		if (value == SHOW_RARE_NPC_ICONS) then
			if (RSConfigDB.IsShowingNpcs()) then
				RSConfigDB.SetShowingNpcs(false)
			else
				RSConfigDB.SetShowingNpcs(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_CONTAINER_ICONS) then
			if (RSConfigDB.IsShowingContainers()) then
				RSConfigDB.SetShowingContainers(false)
			else
				RSConfigDB.SetShowingContainers(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_EVENT_ICONS) then
			if (RSConfigDB.IsShowingEvents()) then
				RSConfigDB.SetShowingEvents(false)
			else
				RSConfigDB.SetShowingEvents(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_NOT_DISCOVERED_ICONS) then
			if (RSConfigDB.IsShowingNotDiscoveredMapIcons()) then
				RSConfigDB.SetShowingNotDiscoveredMapIcons(false)
			else
				RSConfigDB.SetShowingNotDiscoveredMapIcons(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_NOT_DISCOVERED_ICONS_OLD) then
			if (RSConfigDB.IsShowingOldNotDiscoveredMapIcons()) then
				RSConfigDB.SetShowingOldNotDiscoveredMapIcons(false)
			else
				RSConfigDB.SetShowingOldNotDiscoveredMapIcons(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == DISABLE_LAST_SEEN_FILTER) then
			if (RSConfigDB.IsMaxSeenTimeFilterEnabled()) then
				RSConfigDB.DisableMaxSeenTimeFilter()
			else
				RSConfigDB.EnableMaxSeenTimeFilter()
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == DISABLE_LAST_SEEN_CONTAINER_FILTER) then
			if (RSConfigDB.IsMaxSeenTimeContainerFilterEnabled()) then
				RSConfigDB.DisableMaxSeenContainerTimeFilter()
			else
				RSConfigDB.EnableMaxSeenContainerTimeFilter()
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == DISABLE_LAST_SEEN_EVENT_FILTER) then
			if (RSConfigDB.IsMaxSeenTimeEventFilterEnabled()) then
				RSConfigDB.DisableMaxSeenEventTimeFilter()
			else
				RSConfigDB.EnableMaxSeenEventTimeFilter()
			end
			RSMinimap.RefreshAllData(true)
		end
		WorldMapFrame:RefreshAllDataProviders();
	end
		
	LibDD:UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
		local info = LibDD:UIDropDownMenu_CreateInfo();
		info.isNotRadio = true;
		info.keepShownOnClick = false;
		info.func = OnSelection;
	
		info.text = AL["MAP_MENU_SHOW_RARE_NPCS"];
		info.arg1 = SHOW_RARE_NPC_ICONS;
		info.checked = RSConfigDB.IsShowingNpcs()
		LibDD:UIDropDownMenu_AddButton(info);
	
		info.text = AL["MAP_MENU_SHOW_CONTAINERS"];
		info.arg1 = SHOW_CONTAINER_ICONS;
		info.checked = RSConfigDB.IsShowingContainers()
		LibDD:UIDropDownMenu_AddButton(info);
	
		info.text = AL["MAP_MENU_SHOW_EVENTS"];
		info.arg1 = SHOW_EVENT_ICONS;
		info.checked = RSConfigDB.IsShowingEvents()
		LibDD:UIDropDownMenu_AddButton(info);
	
		info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_FILTER"];
		info.arg1 = DISABLE_LAST_SEEN_FILTER;
		info.checked = not RSConfigDB.IsMaxSeenTimeFilterEnabled()
		LibDD:UIDropDownMenu_AddButton(info);
	
		info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_CONTAINER_FILTER"];
		info.arg1 = DISABLE_LAST_SEEN_CONTAINER_FILTER;
		info.checked = not RSConfigDB.IsMaxSeenTimeContainerFilterEnabled()
		LibDD:UIDropDownMenu_AddButton(info);
	
		info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_EVENT_FILTER"];
		info.arg1 = DISABLE_LAST_SEEN_EVENT_FILTER;
		info.checked = not RSConfigDB.IsMaxSeenTimeEventFilterEnabled()
		LibDD:UIDropDownMenu_AddButton(info);
	
		info.text = AL["MAP_MENU_SHOW_NOT_DISCOVERED"];
		info.arg1 = SHOW_NOT_DISCOVERED_ICONS;
		info.checked = RSConfigDB.IsShowingNotDiscoveredMapIcons()
		LibDD:UIDropDownMenu_AddButton(info);
	
		info.text = AL["MAP_MENU_SHOW_NOT_DISCOVERED_OLD"];
		info.arg1 = SHOW_NOT_DISCOVERED_ICONS_OLD;
		info.checked = RSConfigDB.IsShowingOldNotDiscoveredMapIcons()
		LibDD:UIDropDownMenu_AddButton(info);
	end)
end

function RSWorldMapButtonMixin:OnLoad()
	self.DropDown = LibDD:Create_UIDropDownMenu("WorldMapButtonDropDownMenu", self)
	self.DropDown:SetClampedToScreen(true)
	WorldMapButtonDropDownMenu_Initialize(self.DropDown)
end

function RSWorldMapButtonMixin:OnMouseDown(button)
    self.Icon:SetPoint('TOPLEFT', 8, -8)
    local xOffset = WorldMapFrame.isMaximized and 30 or 0
    self.DropDown.point = WorldMapFrame.isMaximized and 'TOPRIGHT' or 'TOPLEFT'
    LibDD:ToggleDropDownMenu(1, nil, self.DropDown, self, xOffset, -5)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

function RSWorldMapButtonMixin:OnMouseUp()
	self.Icon:SetPoint('TOPLEFT', self, 'TOPLEFT', 6, -6)
end

function RSWorldMapButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    GameTooltip_SetTitle(GameTooltip, "RareScanner")
    GameTooltip:Show()
end

function RSWorldMapButtonMixin:Refresh()
	-- Remove when this error is fixed: https://www.curseforge.com/wow/addons/krowis-world-map-buttons#c1
end