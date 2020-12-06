----------------------------------------------------------------------------------------------------
------------------------------------------AddOn NAMESPACE-------------------------------------------
----------------------------------------------------------------------------------------------------

local FOLDER_NAME, private = ...

local addon = LibStub("AceAddon-3.0"):NewAddon(FOLDER_NAME, "AceEvent-3.0", "AceTimer-3.0")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")
local AceDB = LibStub("AceDB-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(FOLDER_NAME)
private.locale = L

addon.constants = private.constants

_G.HandyNotes_CovenantSanctum = addon

local IsQuestCompleted = C_QuestLog.IsQuestFlaggedCompleted
local constantsicon = private.constants.icon

----------------------------------------------------------------------------------------------------
-----------------------------------------------LOCALS-----------------------------------------------
----------------------------------------------------------------------------------------------------

local requires          = L["handler_tooltip_requires"]
local sanctum_feature   = L["handler_tooltip_sanctum_feature"]
local TNRank            = L["handler_tooltip_TNTIER"]

----------------------------------------------------------------------------------------------------
--------------------------------------------GET NPC NAMES-------------------------------------------
----------------------------------------------------------------------------------------------------

local NPClinkSanctum = CreateFrame("GameTooltip", "NPClinkSanctum", UIParent, "GameTooltipTemplate")
local function getCreatureNamebyID(id)
	NPClinkSanctum:SetOwner(UIParent, "ANCHOR_NONE")
	NPClinkSanctum:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
    local name      = _G["NPClinkSanctumTextLeft1"]:GetText()
    local sublabel  = _G["NPClinkSanctumTextLeft2"]:GetText()
    return name, sublabel
end

----------------------------------------------------------------------------------------------------
------------------------------------------------ICON------------------------------------------------
----------------------------------------------------------------------------------------------------

local function SetIcon(point)
    local icon_key

    for i, k in ipairs({
        "anvil", "flightmaster", "innkeeper", "mail", "portal", "reforge", "stablemaster", "vendor", "weaponsmith"
    }) do
        if point[k] then icon_key = k end
    end

    if (icon_key and constantsicon[icon_key]) then
        return constantsicon[icon_key]
    end
end

local GetPointInfo = function(point)
    local icon
    if point then
        local label = getCreatureNamebyID(point.npc) or point.label or UNKNOWN
        if (point.covenant and point.sanctumtalent) then
            local TALENT = C_Garrison.GetTalentInfo(point.sanctumtalent)
            icon = TALENT["researched"] and SetIcon(point) or private.constants.icon["MagePortalHorde"]
        else
            icon = SetIcon(point)
        end
        return label, icon, point.scale, point.alpha
    end
end

local GetPoinInfoByCoord = function(uMapID, coord)
    return GetPointInfo(private.DB.points[uMapID] and private.DB.points[uMapID][coord])
end

----------------------------------------------------------------------------------------------------
----------------------------------------------TOOLTIP-----------------------------------------------
----------------------------------------------------------------------------------------------------

local function SetTooltip(tooltip, point)

    if point then
        if point.npc then
            local name, sublabel = getCreatureNamebyID(point.npc)
            if name then
                tooltip:AddLine(name)
            end
            if sublabel then
                tooltip:AddLine(sublabel,1,1,1)
            end
        end
        if point.label then
            tooltip:AddLine(point.label)
        end
        if point.covenant and point.sanctumtalent then
            local TALENT = C_Garrison.GetTalentInfo(point.sanctumtalent)
            if not TALENT["researched"] then
                tooltip:AddLine(requires.." "..sanctum_feature..":", 1) -- red
                tooltip:AddLine(TALENT["name"], 1, 1, 1) -- white
                tooltip:AddTexture(TALENT["icon"], {margin={right=2}})
                tooltip:AddLine((GetLocale() == "zhCN" and "   · " or "   • ")..format(TNRank, TALENT["tier"]+1), 0.6, 0.6, 0.6) -- grey
            end
        end
    else
        tooltip:SetText(UNKNOWN)
    end
    tooltip:Show()
end

local SetTooltipByCoord = function(tooltip, uMapID, coord)
    return SetTooltip(tooltip, private.DB.points[uMapID] and private.DB.points[uMapID][coord])
end

----------------------------------------------------------------------------------------------------
-------------------------------------------PluginHandler--------------------------------------------
----------------------------------------------------------------------------------------------------

local PluginHandler = {}
local info = {}

function PluginHandler:OnEnter(uMapID, coord)
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
    if ( self:GetCenter() > UIParent:GetCenter() ) then -- compare X coordinate
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end
    SetTooltipByCoord(tooltip, uMapID, coord)
end

function PluginHandler:OnLeave(uMapID, coord)
    if self:GetParent() == WorldMapButton then
        WorldMapTooltip:Hide()
    else
        GameTooltip:Hide()
    end
end

local function hideNode(button, uMapID, coord)
    private.hidden[uMapID][coord] = true
    addon:Refresh()
end

local function closeAllDropdowns()
    CloseDropDownMenus(1)
end

local function addTomTomWaypoint(button, uMapID, coord)
    if TomTom then
        local x, y = HandyNotes:getXY(coord)
        TomTom:AddWaypoint(uMapID, x, y, {
            title = GetPoinInfoByCoord(uMapID, coord),
            persistent = nil,
            minimap = true,
            world = true
        })
    end
end

--------------------------------------------CONTEXT MENU--------------------------------------------

do
    local currentMapID = nil
    local currentCoord = nil
    local function generateMenu(button, level)
        if (not level) then return end
        if (level == 1) then
--      local spacer = {text='', disabled=true, notClickable=true, notCheckable=true}

            -- Create the title of the menu
            info = UIDropDownMenu_CreateInfo()
            info.isTitle = true
            info.text = L["handler_context_menu_addon_name"]
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, level)

--            UIDropDownMenu_AddButton(spacer, level)

            if TomTom and not private.db.easy_waypoint then
                -- Waypoint menu item
                info = UIDropDownMenu_CreateInfo()
                info.text = L["handler_context_menu_add_tomtom"]
                info.notCheckable = true
                info.func = addTomTomWaypoint
                info.arg1 = currentMapID
                info.arg2 = currentCoord
                UIDropDownMenu_AddButton(info, level)
            end

            -- Hide menu item
            info = UIDropDownMenu_CreateInfo()
            info.text         = L["handler_context_menu_hide_node"]
            info.notCheckable = true
            info.func         = hideNode
            info.arg1         = currentMapID
            info.arg2         = currentCoord
            UIDropDownMenu_AddButton(info, level)

--          UIDropDownMenu_AddButton(spacer, level)

            -- Close menu item
            info = UIDropDownMenu_CreateInfo()
            info.text         = CLOSE
            info.func         = closeAllDropdowns
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, level)
        end
    end

    local HL_Dropdown = CreateFrame("Frame", FOLDER_NAME.."DropdownMenu")
    HL_Dropdown.displayMode = "MENU"
    HL_Dropdown.initialize = generateMenu

    function PluginHandler:OnClick(button, down, uMapID, coord)
        if ((down or button ~= "RightButton") and private.db.easy_waypoint and TomTom) then
            return
        end
        if ((button == "RightButton" and not down) and (not private.db.easy_waypoint or not TomTom)) then
            currentMapID = uMapID
            currentCoord = coord
            ToggleDropDownMenu(1, nil, HL_Dropdown, self, 0, 0)
        end
        if (IsControlKeyDown() and private.db.easy_waypoint and TomTom) then
            currentMapID = uMapID
            currentCoord = coord
            ToggleDropDownMenu(1, nil, HL_Dropdown, self, 0, 0)
        else
        if private.db.easy_waypoint and TomTom then
            addTomTomWaypoint(button, uMapID, coord)
        end
        end
    end
end

do

local currentMapID = nil
    local function iter(t, prestate)
        if not t then return nil end
        local state, value = next(t, prestate)
        while state do
            if value and private:ShouldShow(state, value, currentMapID) then
                local _, icon, scale, alpha = GetPointInfo(value)
                    scale = (scale or 1) * private.db.icon_scale
                    alpha = (alpha or 1) * private.db.icon_alpha
                return state, nil, icon, scale, alpha
            end
            state, value = next(t, state)
        end
        return nil, nil, nil, nil, nil, nil
    end
    function PluginHandler:GetNodes2(uMapID, minimap)
        currentMapID = uMapID
        return iter, private.DB.points[uMapID], nil
    end
    function private:ShouldShow(coord, point, currentMapID)
    if not private.db.force_nodes then
        if (private.hidden[currentMapID] and private.hidden[currentMapID][coord]) then
            return false
        end
        -- this will check if any node is for specific covenant
        if (point.covenant and point.covenant ~= C_Covenants.GetActiveCovenantID()) then
            return false
        end
        if (point.anvil and not private.db.show_vendor) then return false; end
        if (point.flightmaster and not private.db.show_others) then return false; end
        if (point.innkeeper and not private.db.show_innkeeper) then return false; end
        if (point.portal and (not private.db.show_portal or IsAddOnLoaded("HandyNotes_TravelGuide"))) then return false; end
        if (point.mail and not private.db.show_mail) then return false; end
        if (point.reforge and not private.db.show_reforge) then return false; end
        if (point.stablemaster and not private.db.show_stablemaster) then return false; end
        if (point.vendor and not private.db.show_vendor) then return false; end
        if (point.weaponsmith and not private.db.show_weaponsmith) then return false; end
    end
        return true
    end
end

---------------------------------------------------------------------------------------------------
----------------------------------------------REGISTER---------------------------------------------
---------------------------------------------------------------------------------------------------

function addon:OnInitialize()
    self.db = AceDB:New(FOLDER_NAME.."DB", private.constants.defaults)

    profile = self.db.profile
    private.db = profile

    global = self.db.global
    private.global = global

    private.hidden = self.db.char.hidden

    if private.global.dev then
        private.devmode()
    end

    -- Initialize database with HandyNotes
    HandyNotes:RegisterPluginDB(addon.pluginName, PluginHandler, private.config.options)
end

function addon:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", addon.pluginName)
end

function addon:OnEnable()
end

----------------------------------------------EVENTS-----------------------------------------------

local frame, events = CreateFrame("Frame"), {};
function events:ZONE_CHANGED(...)
    addon:Refresh()

    if private.global.dev and private.db.show_prints then
        print("Covenant Santcum: refreshed after ZONE_CHANGED")
    end
end

function events:ZONE_CHANGED_INDOORS(...)
    addon:Refresh()

    if private.global.dev and private.db.show_prints then
        print("Covenant Santcum: refreshed after ZONE_CHANGED_INDOORS")
    end
end

function events:QUEST_FINISHED(...)
    addon:Refresh()

    if private.global.dev and private.db.show_prints then
        print("Covenant Santcum: refreshed after QUEST_FINISHED")
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
 events[event](self, ...); -- call one of the functions above
end);

for k, v in pairs(events) do
 frame:RegisterEvent(k); -- Register all events for which handlers have been defined
end