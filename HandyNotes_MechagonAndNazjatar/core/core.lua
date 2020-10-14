-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...

local Addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME,
    "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
if not HandyNotes then return end

ns.addon = Addon
ns.locale = L
ns.maps = {}

_G[ADDON_NAME] = Addon

-------------------------------------------------------------------------------
----------------------------------- HELPERS -----------------------------------
-------------------------------------------------------------------------------

local DropdownMenu = CreateFrame("Frame", ADDON_NAME.."DropdownMenu")
DropdownMenu.displayMode = "MENU"
local function InitializeDropdownMenu(level, mapID, coord)
    if not level then return end
    local node = ns.maps[mapID].nodes[coord]
    local spacer = {text='', disabled=1, notClickable=1, notCheckable=1}

    if (level == 1) then
        UIDropDownMenu_AddButton({
            text=L["context_menu_title"], isTitle=1, notCheckable=1
        }, level)

        UIDropDownMenu_AddButton(spacer, level)

        UIDropDownMenu_AddButton({
            text=L["context_menu_set_waypoint"], notCheckable=1,
            disabled=not C_Map.CanSetUserWaypointOnMap(mapID),
            func=function (button)
                local x, y = HandyNotes:getXY(coord)
                C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, x, y))
                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
            end
        }, level)

        if select(2, IsAddOnLoaded('TomTom')) then
            UIDropDownMenu_AddButton({
                text=L["context_menu_add_tomtom"], notCheckable=1,
                func=function (button)
                    local x, y = HandyNotes:getXY(coord)
                    TomTom:AddWaypoint(mapID, x, y, {
                        title = ns.NameResolver:Resolve(node.label),
                        persistent = nil,
                        minimap = true,
                        world = true
                    })
                end
            }, level)
        end

        UIDropDownMenu_AddButton({
            text=L["context_menu_hide_node"], notCheckable=1,
            func=function (button)
                Addon.db.char[mapID..'_coord_'..coord] = true
                Addon:Refresh()
            end
        }, level)

        UIDropDownMenu_AddButton({
            text=L["context_menu_restore_hidden_nodes"], notCheckable=1,
            func=function ()
                wipe(Addon.db.char)
                Addon:Refresh()
            end
        }, level)

        UIDropDownMenu_AddButton(spacer, level)

        UIDropDownMenu_AddButton({
            text=CLOSE, notCheckable=1,
            func=function() CloseDropDownMenus() end
        }, level)
    end
end

-------------------------------------------------------------------------------
---------------------------------- CALLBACKS ----------------------------------
-------------------------------------------------------------------------------

function Addon:OnEnter(mapID, coord)
    local node = ns.maps[mapID].nodes[coord]
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

    if self:GetCenter() > UIParent:GetCenter() then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end

    node:Render(tooltip)
    node._hover = true
    ns.MinimapDataProvider:RefreshAllData()
    ns.WorldMapDataProvider:RefreshAllData()
    tooltip:Show()
end

function Addon:OnLeave(mapID, coord)
    local node = ns.maps[mapID].nodes[coord]
    node._hover = false
    ns.MinimapDataProvider:RefreshAllData()
    ns.WorldMapDataProvider:RefreshAllData()
    if self:GetParent() == WorldMapButton then
        WorldMapTooltip:Hide()
    else
        GameTooltip:Hide()
    end
end

function Addon:OnClick(button, down, mapID, coord)
    local node = ns.maps[mapID].nodes[coord]
    if button == "RightButton" and down then
        DropdownMenu.initialize = function (_, level)
            InitializeDropdownMenu(level, mapID, coord)
        end
        ToggleDropDownMenu(1, nil, DropdownMenu, self, 0, 0)
    elseif button == "LeftButton" and down then
        if node.pois then
            node._focus = not node._focus
            Addon:Refresh()
        end
    end
end

function Addon:OnInitialize()
    ns.faction = UnitFactionGroup('player')
    self.db = LibStub("AceDB-3.0"):New(ADDON_NAME..'DB', ns.optionDefaults, "Default")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function ()
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        self:ScheduleTimer("RegisterWithHandyNotes", 1)
    end)

    -- Add global groups to settings panel
    ns.CreateGlobalGroupOptions()

    -- Add quick-toggle menu button to top-right corner of world map
    WorldMapFrame:AddOverlayFrame(
        ADDON_NAME.."WorldMapOptionsButtonTemplate",
        "DROPDOWNTOGGLEBUTTON", "TOPRIGHT",
        WorldMapFrame:GetCanvasContainer(), "TOPRIGHT", -68, -2
    )
end

-------------------------------------------------------------------------------
------------------------------------ MAIN -------------------------------------
-------------------------------------------------------------------------------

function Addon:RegisterWithHandyNotes()
    do
        local map, minimap
        local function iter(nodes, precoord)
            if not nodes then return nil end
            if minimap and ns:GetOpt('hide_minimap') then return nil end
            local coord, node = next(nodes, precoord)
            while coord do -- Have we reached the end of this zone?
                if node and map:IsNodeEnabled(node, coord, minimap) then
                    local icon, scale, alpha = node:GetDisplayInfo(map)
                    return coord, nil, icon, scale, alpha
                end
                coord, node = next(nodes, coord) -- Get next node
            end
            return nil, nil, nil, nil
        end
        function Addon:GetNodes2(mapID, _minimap)
            if ns:GetOpt('show_debug_map') then
                ns.Debug('Loading nodes for map: '..mapID..' (minimap='..tostring(_minimap)..')')
            end
            map = ns.maps[mapID]
            minimap = _minimap

            if map then
                map:Prepare()
                return iter, map.nodes, nil
            end

            -- mapID not handled by this plugin
            return iter, nil, nil
        end
    end

    if ns:GetOpt('development') then
        ns.BootstrapDevelopmentEnvironment()
    end

    HandyNotes:RegisterPluginDB(ADDON_NAME, self, ns.options)

    self:RegisterBucketEvent({
        "LOOT_CLOSED", "PLAYER_MONEY", "SHOW_LOOT_TOAST",
        "SHOW_LOOT_TOAST_UPGRADE", "QUEST_TURNED_IN"
    }, 2, "Refresh")

    self:Refresh()
end

function Addon:Refresh()
    if self._refreshTimer then return end
    self._refreshTimer = C_Timer.NewTimer(0.1, function ()
        self._refreshTimer = nil
        self:SendMessage("HandyNotes_NotifyUpdate", ADDON_NAME)
        ns.MinimapDataProvider:RefreshAllData()
        ns.WorldMapDataProvider:RefreshAllData()
    end)
end
