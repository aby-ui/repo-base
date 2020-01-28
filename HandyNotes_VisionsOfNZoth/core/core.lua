-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...

local Addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME,
    "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME);
if not HandyNotes then return end

ns.addon = Addon;
ns.locale = L;
ns.maps = {};

ns.status = {
    Green = function (t) return string.format('(|cFF00FF00%s|r)', t) end,
    Gray = function (t) return string.format('(|cFF999999%s|r)', t) end,
    Red = function (t) return string.format('(|cFFFF0000%s|r)', t) end,
    Orange = function (t) return string.format('(|cFFFF8C00%s|r)', t) end
}

-------------------------------------------------------------------------------
----------------------------------- HELPERS -----------------------------------
-------------------------------------------------------------------------------

local DropdownMenu = CreateFrame("Frame", ADDON_NAME.."DropdownMenu");
DropdownMenu.displayMode = "MENU";
local function initializeDropdownMenu (button, level, mapID, coord)
    if not level then return end
    local node = ns.maps[mapID].nodes[coord];
    local spacer = {text='', disabled=1, notClickable=1, notCheckable=1};

    if (level == 1) then
        UIDropDownMenu_AddButton({
            text=L["context_menu_title"], isTitle=1, notCheckable=1
        }, level);

        UIDropDownMenu_AddButton(spacer, level);

        if select(2, IsAddOnLoaded('TomTom')) then
            UIDropDownMenu_AddButton({
                text=L["context_menu_add_tomtom"], notCheckable=1,
                func=function (button)
                    local x, y = HandyNotes:getXY(coord);
                    TomTom:AddWaypoint(mapID, x, y, {
                        title = ns.NameResolver:GetCachedName(node.label),
                        persistent = nil,
                        minimap = true,
                        world = true
                    });
                end
            }, level);
        end

        UIDropDownMenu_AddButton({
            text=L["context_menu_hide_node"], notCheckable=1,
            func=function (button)
                Addon.db.char[mapID..'_coord_'..coord] = true;
                Addon:Refresh()
            end
        }, level);

        UIDropDownMenu_AddButton({
            text=L["context_menu_restore_hidden_nodes"], notCheckable=1,
            func=function ()
                table.wipe(Addon.db.char)
                Addon:Refresh()
            end
        }, level);

        UIDropDownMenu_AddButton(spacer, level);

        UIDropDownMenu_AddButton({
            text=CLOSE, notCheckable=1,
            func=function() CloseDropDownMenus() end
        }, level);
    end
end

-------------------------------------------------------------------------------
---------------------------------- CALLBACKS ----------------------------------
-------------------------------------------------------------------------------

function Addon:OnEnter(mapID, coord)
    local node = ns.maps[mapID].nodes[coord];
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip;

    if self:GetCenter() > UIParent:GetCenter() then
        tooltip:SetOwner(self, "ANCHOR_LEFT");
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT");
    end

    ns.NameResolver:Resolve(node.label, function (label)
        tooltip:SetText(label or UNKNOWN)

        -- optional top-right text
        if node.rlabel then
            local rtext = _G[tooltip:GetName()..'TextRight1']
            rtext:SetTextColor(1, 1, 1)
            rtext:SetText(node.rlabel)
            rtext:Show()
        end

        if node.sublabel then
            tooltip:AddLine(node.sublabel, 1, 1, 1)
        end

        if node.note and Addon.db.profile.show_notes then
            if node.sublabel then tooltip:AddLine(" ") end
            tooltip:AddLine(node.note, 1, 1, 1, true)
        end

        if Addon.db.profile.show_loot then
            local firstAchieve, firstOther = true, true
            for i, reward in ipairs(node.rewards or {}) do

                -- Add a blank line between achievements and other rewards
                local isAchieve = ns.isinstance(reward, ns.reward.Achievement)
                if isAchieve and firstAchieve then
                    tooltip:AddLine(" ")
                    firstAchieve = false
                elseif not isAchieve and firstOther then
                    tooltip:AddLine(" ")
                    firstOther = false
                end

                reward:render(tooltip);
            end
        end

        node._hover = true
        ns.MinimapDataProvider:RefreshAllData()
        ns.WorldMapDataProvider:RefreshAllData()
        tooltip:Show()
    end)
end

function Addon:OnLeave(mapID, coord)
    local node = ns.maps[mapID].nodes[coord]
    node._hover = false
    ns.MinimapDataProvider:RefreshAllData()
    ns.WorldMapDataProvider:RefreshAllData()
    if self:GetParent() == WorldMapButton then
        WorldMapTooltip:Hide();
    else
        GameTooltip:Hide();
    end
end

function Addon:OnClick(button, down, mapID, coord)
    local node = ns.maps[mapID].nodes[coord]
    if button == "RightButton" and down then
        DropdownMenu.initialize = function (button, level)
            initializeDropdownMenu(button, level, mapID, coord)
        end;
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
end

-------------------------------------------------------------------------------
------------------------------------ MAIN -------------------------------------
-------------------------------------------------------------------------------

function Addon:RegisterWithHandyNotes()
    do
        local map, minimap
        local function iter(nodes, precoord)
            if not nodes then return nil end
            if minimap and self.db.profile.hide_minimap then return nil end
            local force = self.db.profile.force_nodes
            local coord, node = next(nodes, precoord)
            while coord do -- Have we reached the end of this zone?
                if node and (force or map:enabled(node, coord, minimap)) then
                    local icon, scale, alpha = node:display()
                    return coord, nil, icon, scale, alpha
                end
                coord, node = next(nodes, coord) -- Get next node
            end
            return nil, nil, nil, nil
        end
        function Addon:GetNodes2(mapID, _minimap)
            ns.debugMap('Loading nodes for map: '..mapID..' (minimap='..tostring(_minimap)..')')
            map = ns.maps[mapID]
            minimap = _minimap

            if map then
                map:prepare()
                return iter, map.nodes, nil
            end

            -- mapID not handled by this plugin
            return iter, nil, nil
        end
    end

    if self.db.profile.development then
        ns.BootstrapDevelopmentEnvironment()
    end

    HandyNotes:RegisterPluginDB(ADDON_NAME, self, ns.options)

    self:RegisterBucketEvent({
        "LOOT_CLOSED", "PLAYER_MONEY", "SHOW_LOOT_TOAST",
        "SHOW_LOOT_TOAST_UPGRADE"
    }, 2, "Refresh")

    self:Refresh()
end

function Addon:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", ADDON_NAME)
    ns.MinimapDataProvider:RefreshAllData()
    ns.WorldMapDataProvider:RefreshAllData()
end
