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

_G.HandyNotes_Oribos = addon

local IsQuestCompleted = C_QuestLog.IsQuestFlaggedCompleted
local constantsicon = private.constants.icon

----------------------------------------------------------------------------------------------------
-----------------------------------------------LOCALS-----------------------------------------------
----------------------------------------------------------------------------------------------------

local requires          = L["handler_tooltip_requires"]
local RequiresQuest     = L["handler_tooltip_quest"]
local RetrievindData    = L["handler_tooltip_data"]

----------------------------------------------------------------------------------------------------
--------------------------------------------GET NPC NAMES-------------------------------------------
----------------------------------------------------------------------------------------------------

local NPClinkOribos = CreateFrame("GameTooltip", "NPClinkOribos", UIParent, "GameTooltipTemplate")
local function GetCreatureNamebyID(id)
	NPClinkOribos:SetOwner(UIParent, "ANCHOR_NONE")
	NPClinkOribos:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
    local name      = _G["NPClinkOribosTextLeft1"]:GetText()
    local sublabel  = _G["NPClinkOribosTextLeft2"]:GetText()
    return name, sublabel
end

----------------------------------------------------------------------------------------------------
---------------------------------------------PROFESSIONS--------------------------------------------
----------------------------------------------------------------------------------------------------

function addon:CharacterHasProfession(SkillLineID)
    local prof1, prof2 = GetProfessions()
    local ID1 = prof1 and select(7, GetProfessionInfo(prof1))
    local ID2 = prof2 and select(7, GetProfessionInfo(prof2))

    if (ID1 == SkillLineID or ID2 == SkillLineID) then
        return true
    end
    return false
end

local function HasTwoProfessions()
    local prof1, prof2 = GetProfessions()
    if prof1 and prof2 then
        return true
    end
    return false
end

----------------------------------------------------------------------------------------------------
------------------------------------------------ICON------------------------------------------------
----------------------------------------------------------------------------------------------------

local function SetIcon(point)
    local icon_key = (private.db.picons_vendor and point.icon == "vendor" and point.picon)
                  or (private.db.picons_trainer and point.icon == "trainer" and point.picon)
                  or point.icon

    if (icon_key and constantsicon[icon_key]) then
        return constantsicon[icon_key]
    end
end

local function GetIconScale(icon, picon)
    -- makes the picon smaller
    if picon ~= nil and private.db.picons_vendor and icon == "vendor" then return private.db["icon_scale_vendor"] * 0.75 end
    if picon ~= nil and private.db.picons_trainer and icon == "trainer" then return private.db["icon_scale_trainer"] * 0.75 end
    -- anvil npcs are vendors
    if icon == "anvil" then
        return private.db["icon_scale_vendor"]
    -- combine the four zone gateway icons
    elseif icon == "kyrian" or icon == "necrolord" or icon == "nightfae" or icon == "venthyr" then
        return  private.db["icon_scale_zonegateway"]
    end

    return private.db["icon_scale_"..icon]
end

local function GetIconAlpha(icon)
    -- anvil npcs are vendors
    if icon == "anvil" then
        return private.db["icon_alpha_vendor"]
    -- combine the four zone gateway icons
    elseif icon == "kyrian" or icon == "necrolord" or icon == "nightfae" or icon == "venthyr" then
        return  private.db["icon_alpha_zonegateway"]
    end

    return private.db["icon_alpha_"..icon]
end

local GetPointInfo = function(point)
    local icon
    if point then
        local label = GetCreatureNamebyID(point.npc) or point.label or UNKNOWN
        if (point.portal and (point.lvl or point.quest)) then
            if (point.lvl and (UnitLevel("player") < point.lvl)) and (point.quest and not IsQuestCompleted(point.quest)) then
                icon = private.constants.icon["MagePortalHorde"]
            elseif (point.lvl and (UnitLevel("player") < point.lvl)) then
                icon = private.constants.icon["MagePortalHorde"]
            elseif (point.quest and not IsQuestCompleted(point.quest)) then
                icon = private.constants.icon["MagePortalHorde"]
            else
                icon = SetIcon(point)
            end
        else
            icon = SetIcon(point)
        end
        return label, icon, point.icon, point.picon, point.scale, point.alpha -- icon returns the path
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
            local name, sublabel = GetCreatureNamebyID(point.npc)
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
        if point.note then
            tooltip:AddLine(point.note)
        end
        if (point.quest and not IsQuestCompleted(point.quest)) then
            if C_QuestLog.GetTitleForQuestID(point.quest) ~= nil then
                tooltip:AddLine(RequiresQuest..": ["..C_QuestLog.GetTitleForQuestID(point.quest).."] (ID: "..point.quest..")",1,0,0)
            else
                tooltip:AddLine(RetrievindData,1,0,1) -- pink
                C_Timer.After(1, function() addon:Refresh() end) -- Refresh
                -- print("refreshed")
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
                local _, icon, iconname, piconname, scale, alpha = GetPointInfo(value)
                    scale = (scale or 1) * GetIconScale(iconname, piconname)
                    alpha = (alpha or 1) * GetIconAlpha(iconname)
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
        -- this will check if any node is for a specific class
        if (point.class and point.class ~= select(2, UnitClass("player"))) then
            return false
        end
        -- this will check if any node is for a specific faction
        if (point.faction and point.faction ~= select(1, UnitFactionGroup("player"))) then
            return false
        end
        -- this will check if any node is for a specific covenant
        if (point.covenant and point.covenant ~= C_Covenants.GetActiveCovenantID()) then
            return false
        end
        -- this will check if the node is for a specific profession
        if (point.profession and (not addon:CharacterHasProfession(point.profession) and HasTwoProfessions()) and private.db.show_onlymytrainers and not point.auctioneer) then
            return false
        end
        if (point.icon == "auctioneer" and (not addon:CharacterHasProfession(point.profession) or not private.db.show_auctioneer)) then return false end
        if (point.icon == "banker" and not private.db.show_banker) then return false end
        if (point.icon == "barber" and not private.db.show_barber) then return false end
        if (point.icon == "greatvault" and not private.db.show_greatvault) then return false end
        if (point.icon == "guildvault" and not private.db.show_guildvault) then return false end
        if (point.icon == "innkeeper" and not private.db.show_innkeeper) then return false end
        if (point.icon == "mail" and not private.db.show_mail) then return false end
        if (point.icon == "portal" and (not private.db.show_portal or IsAddOnLoaded("HandyNotes_TravelGuide"))) then return false end
        if (point.icon == "tpplatform" and (not private.db.show_tpplatform or IsAddOnLoaded("HandyNotes_TravelGuide"))) then return false end
        if (point.icon == "reforge" and not private.db.show_reforge) then return false end
        if (point.icon == "stablemaster" and not private.db.show_stablemaster) then return false end
        if (point.icon == "trainer" and not private.db.show_trainer) then return false end
        if (point.icon == "portaltrainer" and not private.db.show_portaltrainer) then return false end
        if (point.icon == "transmogrifier" and not private.db.show_transmogrifier) then return false end
        if ((point.icon == "vendor" or point.icon == "anvil") and not private.db.show_vendor) then return false end
        if (point.icon == "void" and not private.db.show_void) then return false end
        if ((point.icon == "kyrian" or point.icon == "necrolord" or point.icon == "nightfae" or point.icon == "venthyr") and not private.db.show_zonegateway) then return false end
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
        print("Oribos: refreshed after ZONE_CHANGED")
        print("MapID: "..C_Map.GetBestMapForUnit("player"))
    end

    if C_Map.GetBestMapForUnit("player") == 1671 then
        if private.db.fmaster_waypoint_dropdown == 1 or private.db.fmaster_waypoint_dropdown == 3 then
            C_Map.ClearUserWaypoint()
        end
        if IsAddOnLoaded("TomTom") and (private.db.fmaster_waypoint_dropdown == 2 or private.db.fmaster_waypoint_dropdown == 3) then
            TomTom:RemoveWaypoint(private.uid)
        end
    end
end

function events:ZONE_CHANGED_INDOORS(...)
    addon:Refresh()

    if private.global.dev and private.db.show_prints then
        print("Oribos: refreshed after ZONE_CHANGED_INDOORS")
    end

    -- Set automatically a waypoint (Blizzard, TomTom or both) to the flightmaster.
    if private.db.fmaster_waypoint and C_Map.GetBestMapForUnit("player") == 1671 then
        if IsAddOnLoaded("TomTom") and private.db.fmaster_waypoint_dropdown == 2 or private.db.fmaster_waypoint_dropdown == 3 then
            private.uid = TomTom:AddWaypoint(1671, 61.91/100, 68.78/100, {title = GetCreatureNamebyID(162666)})
        end
        if private.db.fmaster_waypoint_dropdown == 1 or private.db.fmaster_waypoint_dropdown == 3 then
            C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(1550, 47.02/100, 51.16/100))
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        end
    elseif C_Map.GetBestMapForUnit("player") == 1670 then
        if private.db.fmaster_waypoint_dropdown == 1 or private.db.fmaster_waypoint_dropdown == 3 then
            C_Map.ClearUserWaypoint()
        end
        if IsAddOnLoaded("TomTom") and (private.db.fmaster_waypoint_dropdown == 2 or private.db.fmaster_waypoint_dropdown == 3) then
            TomTom:RemoveWaypoint(private.uid)
        end
    end
end

function events:QUEST_FINISHED(...)
    addon:Refresh()

    if private.global.dev and private.db.show_prints then
        print("Oribos: refreshed after QUEST_FINISHED")
    end
end

function events:SKILL_LINES_CHANGED(...)
    addon:Refresh()

    if private.global.dev and private.db.show_prints then
        print("Oribos: refreshed after SKILL_LINES_CHANGED")
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
 events[event](self, ...); -- call one of the functions above
end);

for k, v in pairs(events) do
 frame:RegisterEvent(k); -- Register all events for which handlers have been defined
end