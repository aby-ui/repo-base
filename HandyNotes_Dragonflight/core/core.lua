-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...

local Addon = LibStub('AceAddon-3.0'):NewAddon(ADDON_NAME, 'AceBucket-3.0',
    'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local HandyNotes = LibStub('AceAddon-3.0'):GetAddon('HandyNotes', true)
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON_NAME)
if not HandyNotes then return end

ns.addon = Addon
ns.locale = L
ns.maps = {}

_G[ADDON_NAME] = Addon

-------------------------------------------------------------------------------
----------------------------------- HELPERS -----------------------------------
-------------------------------------------------------------------------------

local DropdownMenu = CreateFrame('Frame', ADDON_NAME .. 'DropdownMenu')
DropdownMenu.displayMode = 'MENU'
local function InitializeDropdownMenu(level, mapID, coord)
    if not level then return end
    local node = ns.maps[mapID].nodes[coord]
    local spacer = {text = '', disabled = 1, notClickable = 1, notCheckable = 1}

    if (level == 1) then
        UIDropDownMenu_AddButton({
            text = ns.plugin_name,
            isTitle = 1,
            notCheckable = 1
        }, level)

        UIDropDownMenu_AddButton(spacer, level)

        UIDropDownMenu_AddButton({
            text = L['context_menu_set_waypoint'],
            notCheckable = 1,
            disabled = not C_Map.CanSetUserWaypointOnMap(mapID),
            func = function(button)
                local x, y = HandyNotes:getXY(coord)
                C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, x,
                    y))
                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
            end
        }, level)

        if select(2, IsAddOnLoaded('TomTom')) then
            UIDropDownMenu_AddButton({
                text = L['context_menu_add_tomtom'],
                notCheckable = 1,
                func = function(button)
                    local x, y = HandyNotes:getXY(coord)
                    TomTom:AddWaypoint(mapID, x, y, {
                        title = ns.RenderLinks(node.label, true),
                        from = ns.plugin_name,
                        persistent = nil,
                        minimap = true,
                        world = true
                    })
                end
            }, level)
        end

        UIDropDownMenu_AddButton({
            text = L['context_menu_hide_node'],
            notCheckable = 1,
            func = function(button)
                Addon.db.char[mapID .. '_coord_' .. coord] = true
                Addon:RefreshImmediate()
            end
        }, level)

        UIDropDownMenu_AddButton({
            text = L['context_menu_restore_hidden_nodes'],
            notCheckable = 1,
            func = function()
                wipe(Addon.db.char)
                Addon:RefreshImmediate()
            end
        }, level)

        UIDropDownMenu_AddButton(spacer, level)

        UIDropDownMenu_AddButton({
            text = CLOSE,
            notCheckable = 1,
            func = function() CloseDropDownMenus() end
        }, level)
    end
end

-------------------------------------------------------------------------------
---------------------------------- CALLBACKS ----------------------------------
-------------------------------------------------------------------------------

function Addon:OnEnter(mapID, coord)
    local map = ns.maps[mapID]
    local node = map.nodes[coord]

    if self:GetCenter() > UIParent:GetCenter() then
        GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
    else
        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    end

    -- items do not appear to have their info loaded consistently when the map is
    -- prepared, so we prepare the node's assets again here before rendering
    node:Prepare()
    map:SetFocus(node, coord, true, true)

    -- Rendering in the next frame appears to help asset name issues
    C_Timer.After(0, function()
        node:Render(GameTooltip, map:CanFocus(node))
        ns.MinimapDataProvider:RefreshAllData()
        ns.WorldMapDataProvider:RefreshAllData()
        GameTooltip:Show()
    end)
end

function Addon:OnLeave(mapID, coord)
    local map = ns.maps[mapID]
    local node = map.nodes[coord]
    map:SetFocus(node, coord, false, true)
    ns.MinimapDataProvider:RefreshAllData()
    ns.WorldMapDataProvider:RefreshAllData()
    node:Unrender(GameTooltip)
    GameTooltip:Hide()
end

function Addon:OnClick(button, down, mapID, coord)
    local map = ns.maps[mapID]
    local node = map.nodes[coord]
    if button == 'RightButton' and down then
        DropdownMenu.initialize = function(_, level)
            InitializeDropdownMenu(level, mapID, coord)
        end
        ToggleDropDownMenu(1, nil, DropdownMenu, self, 0, 0)
    elseif button == 'LeftButton' and down then
        if map:CanFocus(node) then
            map:SetFocus(node, coord, not map:IsFocused(coord))
            Addon:RefreshImmediate()
        end
    end
end

function Addon:OnInitialize()
    ns.class = select(2, UnitClass('player'))
    ns.faction = UnitFactionGroup('player')
    self.db = LibStub('AceDB-3.0'):New(ADDON_NAME .. 'DB', ns.optionDefaults,
        'Default')
    self:RegisterEvent('PLAYER_ENTERING_WORLD', function()
        self:UnregisterEvent('PLAYER_ENTERING_WORLD')
        self:ScheduleTimer('RegisterWithHandyNotes', 1)
    end)

    -- Add global groups to settings panel
    ns.CreateGlobalGroupOptions()

    -- Add quick-toggle menu button to top-right corner of world map
    local template = ADDON_NAME .. 'WorldMapOptionsButtonTemplate'
    ns.world_map_button = LibStub('Krowi_WorldMapButtons-1.4'):Add(template,
        'DROPDOWNTOGGLEBUTTON')

    -- Query localized expansion title
    if not ns.expansion then error('Expansion not set: ' .. ADDON_NAME) end
    local expansion_name = EJ_GetTierInfo(ns.expansion)
    ns.plugin_name = 'HandyNotes: ' .. expansion_name
    ns.options.name = ('%02d - '):format(ns.expansion) .. expansion_name
end

-------------------------------------------------------------------------------
------------------------------------ MAIN -------------------------------------
-------------------------------------------------------------------------------

function Addon:RegisterWithHandyNotes()
    do
        local map, minimap, force
        local function iter(nodes, precoord)
            if not nodes then return nil end
            if minimap and ns:GetOpt('hide_minimap') then return nil end
            local coord, node = next(nodes, precoord)
            while coord do -- Have we reached the end of this zone?
                if node and (force or map:IsNodeEnabled(node, coord, minimap)) then
                    local icon, scale, alpha =
                        node:GetDisplayInfo(map.id, minimap)
                    return coord, nil, icon, scale, alpha
                end
                coord, node = next(nodes, coord) -- Get next node
            end
            return nil, nil, nil, nil
        end
        function Addon:GetNodes2(mapID, isMinimap)
            if ns:GetOpt('show_debug_map') then
                ns.Debug('Loading nodes for map: ' .. mapID .. ' (minimap=' ..
                             tostring(isMinimap) .. ')')
            end

            map = ns.maps[mapID]
            minimap = isMinimap
            force = ns:GetOpt('force_nodes') or ns.dev_force

            if map then
                map:Prepare()
                return iter, map.nodes, nil
            end

            -- mapID not handled by this plugin
            return iter, nil, nil
        end
    end

    if ns:GetOpt('development') then ns.BootstrapDevelopmentEnvironment() end

    HandyNotes:RegisterPluginDB(ADDON_NAME, self, ns.options)

    -- Refresh in any cases where node status may have changed
    self:RegisterBucketEvent({
        'BAG_UPDATE_DELAYED', -- looted an item
        'CRITERIA_EARNED', -- new achievement criteria earned
        'CRITERIA_UPDATE', -- criteria progress
        'LOOT_CLOSED', -- loot window closed
        'PLAYER_MONEY', -- player earned gold
        'PLAYER_REGEN_ENABLED', -- exited combat
        'QUEST_TURNED_IN', -- complete button pressed or WQ completed
        'SHOW_LOOT_TOAST_UPGRADE', -- special loot obtained w/ upgrades
        'SHOW_LOOT_TOAST', -- special loot obtained
        'ZONE_CHANGED_NEW_AREA' -- player entered new zone
    }, 2, 'Refresh')

    -- Also refresh whenever the size of the world map frame changes
    hooksecurefunc(WorldMapFrame, 'OnFrameSizeChanged', function(...)
        if self.world_map_maximized ~= WorldMapFrame:IsMaximized() then
            self.world_map_maximized = WorldMapFrame:IsMaximized()
            self:RefreshImmediate()
        end
    end)
    self.world_map_maximized = WorldMapFrame:IsMaximized()

    self:Refresh()
end

function Addon:Refresh()
    if self._refreshTimer or InCombatLockdown() then return end
    self._refreshTimer = C_Timer.NewTimer(0.1, function()
        self._refreshTimer = nil
        self:RefreshImmediate()
    end)
end

function Addon:RefreshImmediate()
    self:SendMessage('HandyNotes_NotifyUpdate', ADDON_NAME)
    ns.MinimapDataProvider:RefreshAllData()
    ns.WorldMapDataProvider:RefreshAllData()
end
