local myname, ns = ...

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")
local HL = LibStub("AceAddon-3.0"):NewAddon(myname, "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(myname, false)
ns.HL = HL

local next = next
local GameTooltip = GameTooltip
local HandyNotes = HandyNotes

local function work_out_texture(atlas)
    local texture, _, _, left, right, top, bottom = GetAtlasInfo(atlas)
    return {
        icon = texture,
        tCoordLeft = left,
        tCoordRight = right,
        tCoordTop = top,
        tCoordBottom = bottom,
    }
end
local enabled_texture = work_out_texture("MagePortalAlliance")
local disabled_texture = work_out_texture("MagePortalHorde")
local enabled_entrance_texture = work_out_texture("map-icon-SuramarDoor.tga")
enabled_entrance_texture.r = 0
enabled_entrance_texture.g = 0
enabled_entrance_texture.b = 1
local disabled_entrance_texture = work_out_texture("map-icon-SuramarDoor.tga")
disabled_entrance_texture.r = 1
disabled_entrance_texture.g = 0
disabled_entrance_texture.b = 0

local get_point_info = function(point)
    if point then
        local texture
        if IsQuestFlaggedCompleted(point.quest) then
            texture = point.entrance and enabled_entrance_texture or enabled_texture
        else
            texture = point.entrance and disabled_entrance_texture or disabled_texture
        end
        return point.label, texture
    end
end
local get_point_info_by_coord = function(uiMapId, coord)
    return get_point_info(ns.points[uiMapId] and ns.points[uiMapId][coord])
end

local function handle_tooltip(tooltip, point)
    if point then
        tooltip:AddLine(point.label)
        if IsQuestFlaggedCompleted(point.quest) then
            tooltip:AddLine(ACTIVE_PETS, 0, 1, 0) -- Active
			tooltip:AddLine(point.note , 1, 1, 1) -- Active
        else
            tooltip:AddLine(FACTION_INACTIVE, 1, 0, 0) -- Inactive
			tooltip:AddLine(point.note, 1, 1, 1) -- Inactive
        end
    else
        tooltip:SetText(UNKNOWN)
    end
    tooltip:Show()
end
local handle_tooltip_by_coord = function(tooltip, uiMapId, coord)
    return handle_tooltip(tooltip, ns.points[uiMapId] and ns.points[uiMapId][coord])
end

---------------------------------------------------------
-- Plugin Handlers to HandyNotes
local HLHandler = {}
local info = {}

function HLHandler:OnEnter(uiMapId, coord)
    local tooltip = GameTooltip
    if ( self:GetCenter() > UIParent:GetCenter() ) then -- compare X coordinate
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end
    handle_tooltip_by_coord(tooltip, uiMapId, coord)
end

local function createWaypoint(button, uiMapId, coord)
    if TomTom then
        local x, y = HandyNotes:getXY(coord)
        TomTom:AddWaypoint(uiMapId, x, y, {
            title = get_point_info_by_coord(uiMapId, coord),
            persistent = nil,
            minimap = true,
            world = true
        })
    end
end

local function hideNode(button, uiMapId, coord)
    ns.hidden[uiMapId][coord] = true
    HL:Refresh()
end

local function closeAllDropdowns()
    CloseDropDownMenus(1)
end

do
    local currentZone, currentCoord
    local function generateMenu(button, level)
        if (not level) then return end
        wipe(info)
        if (level == 1) then
            -- Create the title of the menu
            info.isTitle      = 1
            info.text         = "HandyNotes - " .. myname:gsub("HandyNotes_", "")
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)
            wipe(info)

            if TomTom then
                -- Waypoint menu item
                info.text = "Create waypoint"
                info.notCheckable = 1
                info.func = createWaypoint
                info.arg1 = currentZone
                info.arg2 = currentCoord
                UIDropDownMenu_AddButton(info, level)
                wipe(info)
            end

            -- Close menu item
            info.text         = "Close"
            info.func         = closeAllDropdowns
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)
            wipe(info)
        end
    end
    local HL_Dropdown = CreateFrame("Frame", myname.."DropdownMenu")
    HL_Dropdown.displayMode = "MENU"
    HL_Dropdown.initialize = generateMenu

    function HLHandler:OnClick(button, down, uiMapId, coord)
        if button == "RightButton" and not down then
            currentZone = uiMapId
            currentCoord = coord
            ToggleDropDownMenu(1, nil, HL_Dropdown, self, 0, 0)
        end
    end
end

function HLHandler:OnLeave(uiMapId, coord)
    GameTooltip:Hide()
end

do
    -- This is a custom iterator we use to iterate over every node in a given zone
    local currentLevel, currentZone
    local function iter(t, prestate)
        if not t then return nil end
        local state, value = next(t, prestate)
        while state do -- Have we reached the end of this zone?
            if value and ns:ShouldShow(value) and (ns.db.leyline or not value.IsGrid) then
                local label, icon = get_point_info(value)
                return state, nil, icon, ns.db.icon_scale, ns.db.icon_alpha
            end
            state, value = next(t, state) -- Get next data
        end
        return nil, nil, nil, nil
    end
    function HLHandler:GetNodes2(uiMapId, minimap)
        currentLevel = level
        currentZone = uiMapId
        return iter, ns.points[uiMapId], nil
    end
    function ns:ShouldShow(point)
        if point.entrance and not ns.db.entrances then
            return false
        end
        if point.level and point.level ~= currentLevel then
            return false
        end
        if point.hide_after and IsQuestFlaggedCompleted(point.hide_after) then
            return false
        end
        if point.hide_before and not ns.db.upcoming and not IsQuestFlaggedCompleted(point.hide_before) then
            return false
        end
        return true
    end
end

---------------------------------------------------------
-- Addon initialization, enabling and disabling

function HL:OnInitialize()
    -- Set up our database
    self.db = LibStub("AceDB-3.0"):New(myname.."DB", ns.defaults)
    ns.db = self.db.profile
    ns.hidden = self.db.char.hidden
    -- Initialize our database with HandyNotes
    HandyNotes:RegisterPluginDB(myname:gsub("HandyNotes_", ""), HLHandler, ns.options)

    -- watch for LOOT_CLOSED
    self:RegisterEvent("LOOT_CLOSED")
end

function HL:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", myname:gsub("HandyNotes_", ""))
end

function HL:LOOT_CLOSED()
    self:Refresh()
end
