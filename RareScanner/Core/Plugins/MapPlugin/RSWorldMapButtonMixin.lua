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
local SHOW_DEAD_RARE_NPC_ICONS = "rsHideDeadRareNpcs"
local SHOW_HUNTING_PARTY_NPC_ICONS = "rsHideHuntingPartyRareNpcs"
local SHOW_PRIMAL_STORM_NPC_ICONS = "rsHidePrimalStormRareNpcs"
local SHOW_CONTAINER_ICONS = "rsHideContainers"
local SHOW_OPEN_CONTAINER_ICONS = "rsHideOpenContainers"
local SHOW_NOT_TRACKEABLE_CONTAINER_ICONS = "rsHideNotTrackeableContainers"
local SHOW_EVENT_ICONS = "rsHideEvents"
local SHOW_COMPLETED_EVENT_ICONS = "rsHideCompletedEvents"
local SHOW_DRAGON_GLYPHS_ICONS = "rsHideDragonGlyphs"
local SHOW_NOT_DISCOVERED_ICONS = "rsHideNotDiscovered"
local SHOW_NOT_DISCOVERED_ICONS_OLD = "rsHideNotDiscoveredOld"
local DISABLE_LAST_SEEN_FILTER = "rsDisableLastSeenFilter"
local DISABLE_LAST_SEEN_CONTAINER_FILTER = "rsDisableLastSeenContainerFilter"
local DISABLE_LAST_SEEN_EVENT_FILTER = "rsDisableLastSeenEventFilter"


RSWorldMapButtonMixin = { }

local rareNPCsID = 1
local containersID = 2
local eventsID = 3
local othersID = 4

local function WorldMapButtonDropDownMenu_Initialize(dropDown)
	local OnSelection = function(self, value)
		if (value == SHOW_RARE_NPC_ICONS) then
			if (RSConfigDB.IsShowingNpcs()) then
				RSConfigDB.SetShowingNpcs(false)
			else
				RSConfigDB.SetShowingNpcs(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_DEAD_RARE_NPC_ICONS) then
			if (RSConfigDB.IsShowingDeadNpcs()) then
				RSConfigDB.SetShowingDeadNpcs(false)
			else
				RSConfigDB.SetShowingDeadNpcs(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_HUNTING_PARTY_NPC_ICONS) then
			if (RSConfigDB.IsShowingHuntingPartyRareNPCs()) then
				RSConfigDB.SetShowingHuntingPartyRareNPCs(false)
			else
				RSConfigDB.SetShowingHuntingPartyRareNPCs(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_PRIMAL_STORM_NPC_ICONS) then
			if (RSConfigDB.IsShowingPrimalStormRareNPCs()) then
				RSConfigDB.SetShowingPrimalStormNPCs(false)
			else
				RSConfigDB.SetShowingPrimalStormNPCs(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == DISABLE_LAST_SEEN_FILTER) then
			if (RSConfigDB.IsMaxSeenTimeFilterEnabled()) then
				RSConfigDB.DisableMaxSeenTimeFilter()
			else
				RSConfigDB.EnableMaxSeenTimeFilter()
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_CONTAINER_ICONS) then
			if (RSConfigDB.IsShowingContainers()) then
				RSConfigDB.SetShowingContainers(false)
			else
				RSConfigDB.SetShowingContainers(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_OPEN_CONTAINER_ICONS) then
			if (RSConfigDB.IsShowingOpenedContainers()) then
				RSConfigDB.SetShowingOpenedContainers(false)
			else
				RSConfigDB.SetShowingOpenedContainers(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_NOT_TRACKEABLE_CONTAINER_ICONS) then
			if (RSConfigDB.IsShowingNotTrackeableContainers()) then
				RSConfigDB.SetShowingNotTrackeableContainers(false)
			else
				RSConfigDB.SetShowingNotTrackeableContainers(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == DISABLE_LAST_SEEN_CONTAINER_FILTER) then
			if (RSConfigDB.IsMaxSeenTimeContainerFilterEnabled()) then
				RSConfigDB.DisableMaxSeenContainerTimeFilter()
			else
				RSConfigDB.EnableMaxSeenContainerTimeFilter()
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_EVENT_ICONS) then
			if (RSConfigDB.IsShowingEvents()) then
				RSConfigDB.SetShowingEvents(false)
			else
				RSConfigDB.SetShowingEvents(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_COMPLETED_EVENT_ICONS) then
			if (RSConfigDB.IsShowingCompletedEvents()) then
				RSConfigDB.SetShowingCompletedEvents(false)
			else
				RSConfigDB.SetShowingCompletedEvents(true)
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == DISABLE_LAST_SEEN_EVENT_FILTER) then
			if (RSConfigDB.IsMaxSeenTimeEventFilterEnabled()) then
				RSConfigDB.DisableMaxSeenEventTimeFilter()
			else
				RSConfigDB.EnableMaxSeenEventTimeFilter()
			end
			RSMinimap.RefreshAllData(true)
		elseif (value == SHOW_DRAGON_GLYPHS_ICONS) then
			if (RSConfigDB.IsShowingDragonGlyphs()) then
				RSConfigDB.SetShowingDragonGlyphs(false)
			else
				RSConfigDB.SetShowingDragonGlyphs(true)
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
		end
		WorldMapFrame:RefreshAllDataProviders();
	end
		
	LibDD:UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
		if ((level or 1) == 1) then
  			local info = LibDD:UIDropDownMenu_CreateInfo()
  			info.text = "|TInterface\\AddOns\\RareScanner\\Media\\Icons\\OriginalSkull:18:18:::::0:32:0:32|t "..AL["MAP_MENU_RARE_NPCS"]
  			info.menuList = rareNPCsID
  			info.hasArrow = true
  			info.notCheckable = true
  			LibDD:UIDropDownMenu_AddButton(info)
  			
  			info = LibDD:UIDropDownMenu_CreateInfo()
  			info.text = "|TInterface\\AddOns\\RareScanner\\Media\\Icons\\OriginalChest:18:18:::::0:32:0:32|t "..AL["MAP_MENU_CONTAINERS"]
  			info.menuList = containersID
  			info.hasArrow = true
  			info.notCheckable = true
  			LibDD:UIDropDownMenu_AddButton(info)
  			
  			info = LibDD:UIDropDownMenu_CreateInfo()
  			info.text = "|TInterface\\AddOns\\RareScanner\\Media\\Icons\\OriginalStar:18:18:::::0:32:0:32|t "..AL["MAP_MENU_EVENTS"]
  			info.menuList = eventsID
  			info.hasArrow = true
  			info.notCheckable = true
  			LibDD:UIDropDownMenu_AddButton(info)
  			
  			info = LibDD:UIDropDownMenu_CreateInfo()
  			info.text = "|TInterface\\AddOns\\RareScanner\\Media\\Icons\\DragonGlyphSmall:18:18:::::0:32:0:32|t "..AL["MAP_MENU_OTHERS"]
  			info.menuList = othersID
  			info.hasArrow = true
  			info.notCheckable = true
  			LibDD:UIDropDownMenu_AddButton(info)
			
			local info = LibDD:UIDropDownMenu_CreateInfo();
			info.isNotRadio = true;
			info.keepShownOnClick = false;
			info.func = OnSelection;
			
			info.text = AL["MAP_MENU_SHOW_NOT_DISCOVERED"];
			info.arg1 = SHOW_NOT_DISCOVERED_ICONS;
			info.checked = RSConfigDB.IsShowingNotDiscoveredMapIcons()
			LibDD:UIDropDownMenu_AddButton(info, level);
		
			info.text = AL["MAP_MENU_SHOW_NOT_DISCOVERED_OLD"];
			info.arg1 = SHOW_NOT_DISCOVERED_ICONS_OLD;
			info.checked = RSConfigDB.IsShowingOldNotDiscoveredMapIcons()
			LibDD:UIDropDownMenu_AddButton(info, level);
		else
			local info = LibDD:UIDropDownMenu_CreateInfo();
			info.isNotRadio = true;
			info.keepShownOnClick = false;
			info.func = OnSelection;
				
			if (menuList == rareNPCsID) then
				info.text = AL["MAP_MENU_SHOW_RARE_NPCS"];
				info.arg1 = SHOW_RARE_NPC_ICONS;
				info.checked = RSConfigDB.IsShowingNpcs()
				LibDD:UIDropDownMenu_AddButton(info, level);
			
				info.text = AL["MAP_MENU_SHOW_DEAD_RARE_NPCS"];
				info.arg1 = SHOW_DEAD_RARE_NPC_ICONS;
				info.checked = RSConfigDB.IsShowingDeadNpcs()
				info.disabled = not RSConfigDB.IsShowingNpcs()
				LibDD:UIDropDownMenu_AddButton(info, level);
			
				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_FILTER"];
				info.arg1 = DISABLE_LAST_SEEN_FILTER;
				info.checked = not RSConfigDB.IsMaxSeenTimeFilterEnabled()
				info.disabled = not RSConfigDB.IsShowingNpcs()
				LibDD:UIDropDownMenu_AddButton(info, level);
			
				info.text = AL["MAP_MENU_SHOW_HUNTING_PARTY_RARE_NPCS"];
				info.arg1 = SHOW_HUNTING_PARTY_NPC_ICONS;
				info.checked = RSConfigDB.IsShowingHuntingPartyRareNPCs()
				info.disabled = not RSConfigDB.IsShowingNpcs()
				LibDD:UIDropDownMenu_AddButton(info, level);
			
				info.text = AL["MAP_MENU_SHOW_PRIMAL_STORM_RARE_NPCS"];
				info.arg1 = SHOW_PRIMAL_STORM_NPC_ICONS;
				info.checked = RSConfigDB.IsShowingPrimalStormRareNPCs()
				info.disabled = not RSConfigDB.IsShowingNpcs()
				LibDD:UIDropDownMenu_AddButton(info, level);
			elseif (menuList == containersID) then
				info.text = AL["MAP_MENU_SHOW_CONTAINERS"];
				info.arg1 = SHOW_CONTAINER_ICONS;
				info.checked = RSConfigDB.IsShowingContainers()
				LibDD:UIDropDownMenu_AddButton(info, level);
				
				info.text = AL["MAP_MENU_SHOW_OPEN_CONTAINERS"];
				info.arg1 = SHOW_OPEN_CONTAINER_ICONS;
				info.checked = RSConfigDB.IsShowingOpenedContainers()
				info.disabled = not RSConfigDB.IsShowingContainers()
				LibDD:UIDropDownMenu_AddButton(info, level);
			
				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_CONTAINER_FILTER"];
				info.arg1 = DISABLE_LAST_SEEN_CONTAINER_FILTER;
				info.checked = not RSConfigDB.IsMaxSeenTimeContainerFilterEnabled()
				info.disabled = not RSConfigDB.IsShowingContainers()
				LibDD:UIDropDownMenu_AddButton(info, level);
			
				info.text = AL["MAP_MENU_SHOW_NOT_TRACKEABLE_CONTAINERS"];
				info.arg1 = SHOW_NOT_TRACKEABLE_CONTAINER_ICONS;
				info.checked = RSConfigDB.IsShowingNotTrackeableContainers()
				info.disabled = not RSConfigDB.IsShowingContainers()
				LibDD:UIDropDownMenu_AddButton(info, level);
			elseif (menuList == eventsID) then
				info.text = AL["MAP_MENU_SHOW_EVENTS"];
				info.arg1 = SHOW_EVENT_ICONS;
				info.checked = RSConfigDB.IsShowingEvents()
				LibDD:UIDropDownMenu_AddButton(info, level);
				
				info.text = AL["MAP_MENU_SHOW_COMPLETED_EVENTS"];
				info.arg1 = SHOW_COMPLETED_EVENT_ICONS;
				info.checked = RSConfigDB.IsShowingCompletedEvents()
				info.disabled = not RSConfigDB.IsShowingEvents()
				LibDD:UIDropDownMenu_AddButton(info, level);
			
				info.text = AL["MAP_MENU_DISABLE_LAST_SEEN_EVENT_FILTER"];
				info.arg1 = DISABLE_LAST_SEEN_EVENT_FILTER;
				info.checked = not RSConfigDB.IsMaxSeenTimeEventFilterEnabled()
				info.disabled = not RSConfigDB.IsShowingEvents()
				LibDD:UIDropDownMenu_AddButton(info, level);
			elseif (menuList == othersID) then
				info.text = AL["MAP_MENU_SHOW_DRAGON_GLYPHS"];
				info.arg1 = SHOW_DRAGON_GLYPHS_ICONS;
				info.checked = RSConfigDB.IsShowingDragonGlyphs()
				LibDD:UIDropDownMenu_AddButton(info, level);
			end
		end
	end)
end

function RSWorldMapButtonMixin:OnLoad()
	self.DropDown = LibDD:Create_UIDropDownMenu("WorldMapButtonDropDownMenu", self)
	self.DropDown:SetClampedToScreen(true)
	WorldMapButtonDropDownMenu_Initialize(self.DropDown)
end

function RSWorldMapButtonMixin:OnMouseDown(button)
    self.Icon:SetPoint('TOPLEFT', self, "TOPLEFT", 7, -6)
    local xOffset = WorldMapFrame.isMaximized and 30 or 0
    self.DropDown.point = WorldMapFrame.isMaximized and 'TOPRIGHT' or 'TOPLEFT'
    LibDD:ToggleDropDownMenu(1, nil, self.DropDown, self, xOffset, -5)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

function RSWorldMapButtonMixin:OnMouseUp()
	self.Icon:SetPoint('TOPLEFT', 7.2, -6)
end

function RSWorldMapButtonMixin:OnEnter()
    GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    GameTooltip_SetTitle(GameTooltip, "RareScanner")
    GameTooltip:Show()
end

function RSWorldMapButtonMixin:Refresh()
	-- Needed even if not used
end