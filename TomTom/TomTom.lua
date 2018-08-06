--[[--------------------------------------------------------------------------
--  TomTom by Cladhaire <cladhaire@gmail.com>
--
--  All Rights Reserved
----------------------------------------------------------------------------]]

-- Simple localization table for messages
local L = TomTomLocals
local ldb = LibStub("LibDataBroker-1.1")
local hbd = LibStub("HereBeDragons-2.0")

local addonName, addon = ...
local TomTom = addon

addon.hbd = hbd

-- Local definitions
local GetCurrentCursorPosition
local WorldMap_OnUpdate
local Block_OnClick,Block_OnUpdate,Block_OnEnter,Block_OnLeave
local Block_OnDragStart,Block_OnDragStop
local callbackTbl
local RoundCoords

local waypoints = {}

function TomTom:Initialize(event, addon)
    self.defaults = {
        profile = {
            general = {
                confirmremoveall = true,
                announce = false,
                corpse_arrow = true,
            },
            block = {
                enable = false,
                accuracy = 1,
                bordercolor = {1, 0.8, 0, 0.8},
                bgcolor = {0, 0, 0, 0.4},
                lock = false,
                height = 30,
                width = 100,
                fontsize = 12,
                throttle = 0.2,
            },
            mapcoords = {
                playerenable = false,
                playeraccuracy = 1,
                cursorenable = false,
                cursoraccuracy = 1,
				throttle = 0.1,
            },
            arrow = {
                enable = true,
                goodcolor = {0, 1, 0},
                badcolor = {1, 0, 0},
                middlecolor = {1, 1, 0},
				exactcolor = {0, 1, 0},
                arrival = 15,
                lock = false,
                noclick = false,
                showtta = true,
				showdistance = true,
				stickycorpse = false,
                autoqueue = true,
                menu = true,
                scale = 1.0,
                alpha = 1.0,
                title_width = 0,
                title_height = 0,
                title_scale = 1,
                title_alpha = 1,
                setclosest = true,
				closestusecontinent = false,
                enablePing = false,
				hideDuringPetBattles = true,
            },
            minimap = {
                enable = true,
                otherzone = true,
                tooltip = true,
                menu = true,
            },
            worldmap = {
                enable = true,
                tooltip = true,
                otherzone = true,
                clickcreate = true,
                menu = true,
                create_modifier = "C",
            },
            comm = {
                enable = true,
                prompt = false,
            },
            persistence = {
                cleardistance = 10,
                savewaypoints = true,
            },
            feeds = {
                coords = false,
                coords_throttle = 0.3,
                coords_accuracy = 1,
                arrow = false,
                arrow_throttle = 0.1,
            },
            poi = {
                enable = true,
                modifier = "C",
                setClosest = false,
                arrival = 20,
            },
        },
    }

    self.waydefaults = {
        global = {
            converted = {
                ["*"] = {},
            },
        },
        profile = {
            ["*"] = {},
        },
    }

    self.db = LibStub("AceDB-3.0"):New("TomTomDB", self.defaults, "Default")
    self.waydb = LibStub("AceDB-3.0"):New("TomTomWaypointsM", self.waydefaults)

    self.db.RegisterCallback(self, "OnProfileChanged", "ReloadOptions")
    self.db.RegisterCallback(self, "OnProfileCopied", "ReloadOptions")
    self.db.RegisterCallback(self, "OnProfileReset", "ReloadOptions")
    self.waydb.RegisterCallback(self, "OnProfileChanged", "ReloadWaypoints")
    self.waydb.RegisterCallback(self, "OnProfileCopied", "ReloadWaypoints")
    self.waydb.RegisterCallback(self, "OnProfileReset", "ReloadWaypoints")

    self.tooltip = CreateFrame("GameTooltip", "TomTomTooltip", nil, "GameTooltipTemplate")
    self.tooltip:SetFrameStrata("DIALOG")

    self.dropdown = CreateFrame("Frame", "TomTomDropdown", nil, "UIDropDownMenuTemplate")

    -- Both the waypoints and waypointprofile tables are going to contain subtables for each
    -- of the mapids that might exist. Under these will be a hash of key/waypoint pairs consisting
    -- of the waypoints for the given map file.
    self.waypoints = waypoints
    self.waypointprofile = self.waydb.profile

    self:RegisterEvent("PLAYER_LEAVING_WORLD")
    self:RegisterEvent("CHAT_MSG_ADDON")
    -- Since we are now using just (map, x, y), register a new protocol number
    C_ChatInfo.RegisterAddonMessagePrefix("TOMTOM4")

	-- Watch for pet battle start/end so we can hide/show the arrow
	self:RegisterEvent("PET_BATTLE_OPENING_START", "ShowHideCrazyArrow")
	self:RegisterEvent("PET_BATTLE_CLOSE", "ShowHideCrazyArrow")

    self:ReloadOptions()
    self:ReloadWaypoints()

    if self.db.profile.feeds.coords then
        -- Create a data feed for coordinates
        local feed_coords = ldb:NewDataObject("TomTom_Coords", {
            type = "data source",
            icon = "Interface\\Icons\\INV_Misc_Map_01",
            text = "",
        })

        local coordFeedFrame = CreateFrame("Frame")
        local throttle, counter = self.db.profile.feeds.coords_throttle, 0
        function TomTom:_privateupdatecoordthrottle(x)
            throttle = x
        end

        coordFeedFrame:SetScript("OnUpdate", function(self, elapsed)
            counter = counter + elapsed
            if counter < throttle then
                return
            end

            counter = 0
            local m, x, y = TomTom:GetCurrentPlayerPosition()

            if x and y then
                local opt = TomTom.db.profile.feeds
                feed_coords.text = string.format("%s", RoundCoords(x, y, opt.coords_accuracy))
            end
        end)
    end
end

-- Some utility functions that can pack/unpack data from a waypoint

-- Returns a hashable 'key' for a given waypoint consisting of the
-- map, x, y and the waypoints title. This isn't truly
-- unique, but should be close enough to determine duplicates, etc.
function TomTom:GetKey(waypoint)
    local m,x,y = unpack(waypoint)
    return self:GetKeyArgs(m, x, y, waypoint.title)
end

function TomTom:GetKeyArgs(m, x, y, title)
	-- Fudge the x/y values so they avoid precision/printf issues
	local x = x * 10000
	local y = y * 10000

    local key = string.format("%d:%s:%s:%s", m, x*10e4, y*10e4, tostring(title))
	return key
end

-- Returns the player's current coordinates without flipping the map or
-- causing any other weirdness. This can and will cause the coordinates to be
-- weird if you zoom the map out to your parent, but there is no way to
-- recover this without changing/setting the map zoom. Deal with it =)
function TomTom:GetCurrentCoords()
	local x, y = hbd:GetPlayerZonePosition()
	if x and y and x > 0 and y > 0 then
		return x, y
	end
end

function TomTom:GetCurrentPlayerPosition()
    local x, y, mapID = hbd:GetPlayerZonePosition()
    return mapID, x, y
end

function TomTom:ReloadOptions()
    -- This handles the reloading of all options
    self.profile = self.db.profile

    self:ShowHideWorldCoords()
    self:ShowHideCoordBlock()
    self:ShowHideCrazyArrow()
    self:EnableDisablePOIIntegration()
end

function TomTom:ClearAllWaypoints()
    for mapId, entries in pairs(waypoints) do
        for key, waypoint in pairs(entries) do
            -- The waypoint IS the UID now
            self:ClearWaypoint(waypoint)
        end
    end
end

function TomTom:ResetWaypointOptions()
	local minimap = self.profile.minimap.enable
	local world = self.profile.worldmap.enable
    local cleardistance = self.profile.persistence.cleardistance
    local arrivaldistance = self.profile.arrow.arrival

	for map, data in pairs(self.waypointprofile) do
		for key, waypoint in pairs(data) do
			waypoint.minimap = minimap
			waypoint.world = world
			waypoint.cleardistance = cleardistance
			waypoint.arrivaldistance = arrivaldistance
		end
	end
end

function TomTom:ReloadWaypoints()
    self:ClearAllWaypoints()

    waypoints = {}
    self.waypoints = waypoints
    self.waypointprofile = self.waydb.profile

    local cm, cx, cy = TomTom:GetCurrentPlayerPosition()

    for mapId,data in pairs(self.waypointprofile) do
        local same = mapId == cm
        local minimap = self.profile.minimap.enable and (self.profile.minimap.otherzone or same)
        local world = self.profile.worldmap.enable and (self.profile.worldmap.otherzone or same)
        for key,waypoint in pairs(data) do
            local m,x,y = unpack(waypoint)
            local title = waypoint.title

			-- Set up default options
			local options = {
				desc = title,
				title = title,
				persistent = waypoint.persistent,
				minimap = minimap,
				world = world,
				callbacks = nil,
				silent = true,
			}

			-- Override options with what is stored in the profile
			for k,v in pairs(waypoint) do
				if type(k) == "string" then
					if k ~= "callbacks" then
						-- we can never import callbacks, so ditch them
						options[k] = v
					end
				end
			end

            self:AddWaypoint(m, x, y, options)
        end
    end
end

function TomTom:UpdateCoordFeedThrottle()
    self:_privateupdatecoordthrottle(self.db.profile.feeds.coords_throttle)
end


function TomTom:ShowHideWorldCoords()
    -- Bail out if we're not supposed to be showing this frame
    if self.profile.mapcoords.playerenable or self.db.profile.mapcoords.cursorenable then
        -- Create the frame if it doesn't exist
        if not TomTomWorldFrame then
            TomTomWorldFrame = CreateFrame("Frame", "TomTomWorldFrame", WorldMapFrame.BorderFrame)
            TomTomWorldFrame.Player = TomTomWorldFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            TomTomWorldFrame.Cursor = TomTomWorldFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            TomTomWorldFrame:SetScript("OnUpdate", WorldMap_OnUpdate)
        end

        TomTomWorldFrame.Player:ClearAllPoints()
        TomTomWorldFrame.Cursor:ClearAllPoints()

        if WorldMapMixin.isMaximized then
            TomTomWorldFrame.Player:SetPoint("TOPLEFT", WorldMapFrame.BorderFrame, "TOPLEFT",   30, -4)
            TomTomWorldFrame.Cursor:SetPoint("TOPLEFT",  WorldMapFrame.BorderFrame, "TOPRIGHT",  -170, -4)
        else
            TomTomWorldFrame.Player:SetPoint("TOPLEFT", WorldMapFrame.BorderFrame, "TOPLEFT", 100, -4)
            TomTomWorldFrame.Cursor:SetPoint("TOPLEFT",  WorldMapFrame.BorderFrame, "TOPRIGHT", -270, -4)
        end

        TomTomWorldFrame.Player:Hide()
        TomTomWorldFrame.Cursor:Hide()

        if self.profile.mapcoords.playerenable then
            TomTomWorldFrame.Player:Show()
        end

        if self.profile.mapcoords.cursorenable then
            TomTomWorldFrame.Cursor:Show()
        end

        -- Show the frame
        TomTomWorldFrame:Show()
    elseif TomTomWorldFrame then
        TomTomWorldFrame:Hide()
    end
end

function TomTom:ShowHideCoordBlock()
    -- Bail out if we're not supposed to be showing this frame
    if self.profile.block.enable then
        -- Create the frame if it doesn't exist
        if not TomTomBlock then
            -- Create the coordinate display
            TomTomBlock = CreateFrame("Button", "TomTomBlock", UIParent)
            TomTomBlock:SetWidth(120)
            TomTomBlock:SetHeight(32)
            TomTomBlock:SetToplevel(1)
            TomTomBlock:SetFrameStrata("LOW")
            TomTomBlock:SetMovable(true)
            TomTomBlock:EnableMouse(true)
            TomTomBlock:SetClampedToScreen()
            TomTomBlock:RegisterForDrag("LeftButton")
            TomTomBlock:RegisterForClicks("RightButtonUp")
            TomTomBlock:SetPoint("TOP", Minimap, "BOTTOM", -20, -10)

            TomTomBlock.Text = TomTomBlock:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            TomTomBlock.Text:SetJustifyH("CENTER")
            TomTomBlock.Text:SetPoint("CENTER", 0, 0)

            TomTomBlock:SetBackdrop({
                bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                edgeSize = 16,
                insets = {left = 4, right = 4, top = 4, bottom = 4},
            })
            TomTomBlock:SetBackdropColor(0,0,0,0.4)
            TomTomBlock:SetBackdropBorderColor(1,0.8,0,0.8)

            -- Set behavior scripts
            TomTomBlock:SetScript("OnUpdate", Block_OnUpdate)
            TomTomBlock:SetScript("OnClick", Block_OnClick)
            TomTomBlock:SetScript("OnEnter", Block_OnEnter)
            TomTomBlock:SetScript("OnLeave", Block_OnLeave)
            TomTomBlock:SetScript("OnDragStop", Block_OnDragStop)
            TomTomBlock:SetScript("OnDragStart", Block_OnDragStart)
        end
        -- Show the frame
        TomTomBlock:Show()

        local opt = self.profile.block

        -- Update the backdrop color, and border color
        TomTomBlock:SetBackdropColor(unpack(opt.bgcolor))
        TomTomBlock:SetBackdropBorderColor(unpack(opt.bordercolor))

        -- Update the height and width
        TomTomBlock:SetHeight(opt.height)
        TomTomBlock:SetWidth(opt.width)

        -- Update the font size
        local font,height = TomTomBlock.Text:GetFont()
        TomTomBlock.Text:SetFont(font, opt.fontsize, select(3, TomTomBlock.Text:GetFont()))

    elseif TomTomBlock then
        TomTomBlock:Hide()
    end
end

-- Hook the WorldMap OnClick
local world_click_verify = {
    ["A"] = function() return IsAltKeyDown() end,
    ["C"] = function() return IsControlKeyDown() end,
    ["S"] = function() return IsShiftKeyDown() end,
}

-- This is now a registered click handler.
-- If we return false, it gets passed on to the next handler.
-- We need to return true when we handle the click.
local function WorldMap_OnClick (self, ...)
    local mouseButton, button = ...
    if mouseButton == "RightButton" then
        -- Check for all the modifiers that are currently set
        for mod in TomTom.db.profile.worldmap.create_modifier:gmatch("[ACS]") do
            if not world_click_verify[mod] or not world_click_verify[mod]() then
                return false
            end
        end

        local m = WorldMapFrame.mapID
        local x,y = WorldMapFrame:GetNormalizedCursorPosition()

        if not m or m == 0 then
            return false
        end

        local uid = TomTom:AddWaypoint(m, x, y, { title = L["TomTom waypoint"],})
        return true
    else
        return false
    end
end

-- Add WorldMap_OnClick as a Click Handler on the WorldMapFrame Canvas
WorldMapFrame:AddCanvasClickHandler(WorldMap_OnClick,10)

local function WaypointCallback(event, arg1, arg2, arg3)
    if event == "OnDistanceArrive" then
        TomTom:ClearWaypoint(arg1)
    elseif event == "OnTooltipShown" then
        local tooltip = arg1
        if arg3 then
            tooltip:SetText(L["TomTom waypoint"])
            tooltip:AddLine(string.format(L["%s yards away"], math.floor(arg2)), 1, 1 ,1)
            tooltip:Show()
        else
            tooltip.lines[2]:SetFormattedText(L["%s yards away"], math.floor(arg2), 1, 1, 1)
        end
    end
end

--[[-------------------------------------------------------------------
--  Dropdown menu code
-------------------------------------------------------------------]]--

StaticPopupDialogs["TOMTOM_REMOVE_ALL_CONFIRM"] = {
	preferredIndex = STATICPOPUPS_NUMDIALOGS,
    text = L["Are you sure you would like to remove ALL TomTom waypoints?"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        TomTom.waydb:ResetProfile()
        TomTom:ReloadWaypoints()
    end,
    timeout = 30,
    whileDead = 1,
    hideOnEscape = 1,
}

local dropdown_info = {
    -- Define level one elements here
    [1] = {
        { -- Title
        text = L["Waypoint Options"],
        isTitle = 1,
    },
    {
        -- set as crazy arrow
        text = L["Set as waypoint arrow"],
        func = function()
            local uid = TomTom.dropdown.uid
            local data = uid
            TomTom:SetCrazyArrow(uid, TomTom.profile.arrow.arrival, data.title or L["TomTom waypoint"])
        end,
    },
    {
        -- Send waypoint
        text = L["Send waypoint to"],
        hasArrow = true,
        value = "send",
    },
    { -- Remove waypoint
    text = L["Remove waypoint"],
    func = function()
        local uid = TomTom.dropdown.uid
        local data = uid
        TomTom:RemoveWaypoint(uid)
        --TomTom:PrintF("Removing waypoint %0.2f, %0.2f in %s", data.x, data.y, data.zone)
    end,
},
{ -- Remove all waypoints from this zone
text = L["Remove all waypoints from this zone"],
func = function()
    local uid = TomTom.dropdown.uid
    local data = uid
    local mapId = data[1]
    for key, waypoint in pairs(waypoints[mapId]) do
        TomTom:RemoveWaypoint(waypoint)
    end
end,
        },
        { -- Remove ALL waypoints
        text = L["Remove all waypoints"],
        func = function()
            if TomTom.db.profile.general.confirmremoveall then
                StaticPopup_Show("TOMTOM_REMOVE_ALL_CONFIRM")
            else
                StaticPopupDialogs["TOMTOM_REMOVE_ALL_CONFIRM"].OnAccept()
                return
            end
        end,
    },
    { -- Save this waypoint
    text = L["Save this waypoint between sessions"],
    checked = function()
        return TomTom:UIDIsSaved(TomTom.dropdown.uid)
    end,
    func = function()
        -- Add/remove it from the SV file
        local uid = TomTom.dropdown.uid
        local data = waypoints[uid]
        if data then
            local key = TomTom:GetKey(data)
            local mapId = data[1]

            if mapId then
                if UIDIsSavedTomTom.waypointprofile[mapId][key] then
                    TomTom.waypointprofile[mapId][key] = nil
                else
                    TomTom.waypointprofile[mapId][key] = data
                end
            end
        end
    end,
},
    },
    [2] = {
        send = {
            {
                -- Title
                text = L["Waypoint communication"],
                isTitle = true,
            },
            {
                -- Party
                text = L["Send to party"],
                func = function()
                    TomTom:SendWaypoint(TomTom.dropdown.uid, "PARTY")
                end
            },
            {
                -- Raid
                text = L["Send to raid"],
                func = function()
                    TomTom:SendWaypoint(TomTom.dropdown.uid, "RAID")
                end
            },
            {
                -- Battleground
                text = L["Send to battleground"],
                func = function()
                    TomTom:SendWaypoint(TomTom.dropdown.uid, "BATTLEGROUND")
                end
            },
            {
                -- Guild
                text = L["Send to guild"],
                func = function()
                    TomTom:SendWaypoint(TomTom.dropdown.uid, "GUILD")
                end
            },
        },
    },
}

local function init_dropdown(self, level)
    -- Make sure level is set to 1, if not supplied
    level = level or 1

    -- Get the current level from the info table
    local info = dropdown_info[level]

    -- If a value has been set, try to find it at the current level
    if level > 1 and UIDROPDOWNMENU_MENU_VALUE then
        if info[UIDROPDOWNMENU_MENU_VALUE] then
            info = info[UIDROPDOWNMENU_MENU_VALUE]
        end
    end

    -- Add the buttons to the menu
    for idx,entry in ipairs(info) do
        if type(entry.checked) == "function" then
            -- Make this button dynamic
            local new = {}
            for k,v in pairs(entry) do new[k] = v end
            new.checked = new.checked()
            entry = new
        else
            entry.checked = nil
        end

        UIDropDownMenu_AddButton(entry, level)
    end
end

function TomTom:InitializeDropdown(uid)
    self.dropdown.uid = uid
    UIDropDownMenu_Initialize(self.dropdown, init_dropdown)
end

function TomTom:UIDIsSaved(uid)
    local data = uid
    if data then
        local key = TomTom:GetKey(data)
        local mapId = data[1]

        if data then
            return not not TomTom.waypointprofile[mapId][key]
        end
    end
    return false
end

function TomTom:SendWaypoint(uid, channel)
    local data = uid
    local m, x, y = unpack(data)
    local msg = string.format("%d:%f:%f:%s", m, x, y, data.title or "")
    C_ChatInfo.SendAddonMessage("TOMTOM4", msg, channel)
end

function TomTom:CHAT_MSG_ADDON(event, prefix, data, channel, sender)
    if prefix ~= "TOMTOM4" then return end
    if sender == UnitName("player") then return end

    local m,x,y,title = string.split(":", data)
    if not title:match("%S") then
        title = string.format(L["Waypoint from %s"], sender)
    end

    m = tonumber(m)
    x = tonumber(x)
    y = tonumber(y)

    local zoneName = hbd:GetLocalizedMap(m)
    self:AddWaypoint(m, x, y, {title = title})
    local msg = string.format(L["|cffffff78TomTom|r: Added '%s' (sent from %s) to zone %s"], title, sender, zoneName)
    ChatFrame1:AddMessage(msg)
end

--[[-------------------------------------------------------------------
--  Define callback functions
-------------------------------------------------------------------]]--
local function _minimap_onclick(event, uid, self, button)
    if TomTom.db.profile.minimap.menu then
        TomTom:InitializeDropdown(uid)
        ToggleDropDownMenu(1, nil, TomTom.dropdown, "cursor", 0, 0)
    end
end

local function _world_onclick(event, uid, self, button)
    if TomTom.db.profile.worldmap.menu then
        TomTom:InitializeDropdown(uid)
        ToggleDropDownMenu(1, nil, TomTom.dropdown, "cursor", 0, 0)
    end
end

local function _both_tooltip_show(event, tooltip, uid, dist)
    local data = uid

    tooltip:SetText(data.title or L["Unknown waypoint"])
    if dist and tonumber(dist) then
        tooltip:AddLine(string.format(L["%s yards away"], math.floor(dist)), 1, 1, 1)
    else
        tooltip:AddLine(L["Unknown distance"])
    end
    local m,x,y = unpack(data)
    local zoneName = hbd:GetLocalizedMap(m)

    tooltip:AddLine(string.format(L["%s (%.2f, %.2f)"], zoneName, x*100, y*100), 0.7, 0.7, 0.7)
    tooltip:Show()
end

local function _minimap_tooltip_show(event, tooltip, uid, dist)
    if not TomTom.db.profile.minimap.tooltip then
        tooltip:Hide()
        return
    end
    return _both_tooltip_show(event, tooltip, uid, dist)
end

local function _world_tooltip_show(event, tooltip, uid, dist)
    if not TomTom.db.profile.worldmap.tooltip then
        tooltip:Hide()
        return
    end
    return _both_tooltip_show(event, tooltip, uid, dist)
end

local function _both_tooltip_update(event, tooltip, uid, dist)
    if dist and tonumber(dist) then
        tooltip.lines[2]:SetFormattedText(L["%s yards away"], math.floor(dist), 1, 1, 1)
    else
        tooltip.lines[2]:SetText(L["Unknown distance"])
    end
end

local function _both_clear_distance(event, uid, range, distance, lastdistance)
	-- Only clear the waypoint if we weren't inside it when it was set
    if lastdistance and not UnitOnTaxi("player") then
        TomTom:RemoveWaypoint(uid)
    end
end

local function _both_ping_arrival(event, uid, range, distance, lastdistance)
    if TomTom.profile.arrow.enablePing then
        PlaySoundFile("Interface\\AddOns\\TomTom\\Media\\ping.mp3")
    end
end

local function _remove(event, uid)
    local data = uid
    local key = TomTom:GetKey(data)
    local mapId = data[1]
    local sv = TomTom.waypointprofile[mapId]

    if sv and sv[key] then
        sv[key] = nil
    end

    -- Remove this entry from the waypoints table
    if waypoints[mapId] then
        waypoints[mapId][key] = nil
    end
end

local function noop() end

function TomTom:RemoveWaypoint(uid)
    local data = uid
    self:ClearWaypoint(uid)

    local key = TomTom:GetKey(data)
    local mapId = data[1]
    local sv = TomTom.waypointprofile[mapId]

    if sv and sv[key] then
        sv[key] = nil
    end

    -- Remove this entry from the waypoints table
    if waypoints[mapId] then
        waypoints[mapId][key] = nil
    end
end


function TomTom:AddWaypointToCurrentZone(x, y, desc)
    local m = TomTom:GetCurrentPlayerPosition()
    if not m then
        return
    end

    return self:AddWaypoint(m, x/100, y/100, {title = desc})
end

-- Return a set of default callbacks that can be used by addons to provide
-- more detailed functionality without losing the tooltip and onclick
-- functionality.
--
-- Options that are used in this 'opts' table in this function:
--  * cleardistance - When the player is this far from the waypoint, the
--    waypoint will be removed.
--  * arrivaldistance - When the player is within this radius of the waypoint,
--    the crazy arrow will change to the 'downwards' arrow, indicating that
--    the player has arrived.

function TomTom:DefaultCallbacks(opts)
    opts = opts or {}

	local callbacks = {
		minimap = {
			onclick = _minimap_onclick,
			tooltip_show = _minimap_tooltip_show,
			tooltip_update = _both_tooltip_update,
		},
		world = {
			onclick = _world_onclick,
			tooltip_show = _world_tooltip_show,
			tooltip_update = _both_tooltip_show,
		},
		distance = {
		},
	}

    local cleardistance = self.profile.persistence.cleardistance
    local arrivaldistance = self.profile.arrow.arrival

    -- Allow both of these to be overriden by options
    if opts.cleardistance then
        cleardistance = opts.cleardistance
    end
    if opts.arrivaldistance then
        arrivaldistance = opts.arrivaldistance
    end

    if cleardistance == arrivaldistance then
        callbacks.distance[cleardistance] = function(...)
            _both_clear_distance(...);
            _both_ping_arrival(...);
        end
    else
        if cleardistance > 0 then
            callbacks.distance[cleardistance] = _both_clear_distance
        end
        if arrivaldistance > 0 then
            callbacks.distance[arrivaldistance] = _both_ping_arrival
        end
    end

	return callbacks
end

function TomTom:AddWaypoint(m, x, y, opts)
	opts = opts or {}

	-- Default values
    if opts.persistent == nil then opts.persistent = self.profile.persistence.savewaypoints end
    if opts.minimap == nil then opts.minimap = self.profile.minimap.enable end
    if opts.world == nil then opts.world = self.profile.worldmap.enable end
    if opts.crazy == nil then opts.crazy = self.profile.arrow.autoqueue end
	if opts.cleardistance == nil then opts.cleardistance = self.profile.persistence.cleardistance end
	if opts.arrivaldistance == nil then opts.arrivaldistance = self.profile.arrow.arrival end

    if not opts.callbacks then
		opts.callbacks = TomTom:DefaultCallbacks(opts)
	end

    local zoneName = hbd:GetLocalizedMap(m)

    -- Ensure there isn't already a waypoint at this location
    local key = self:GetKey({m, x, y, title = opts.title})
    if waypoints[m] and waypoints[m][key] then
        return waypoints[m][key]
    end

    -- uid is the 'new waypoint' called this for historical reasons
    local uid = {m, x, y, title = opts.title}

    -- Copy over any options, so we have them
    for k,v in pairs(opts) do
        if not uid[k] then
            uid[k] = v
        end
    end

    -- No need to convert x and y because they're already 0-1 instead of 0-100
    self:SetWaypoint(uid, opts.callbacks, opts.minimap, opts.world)
    if opts.crazy then
        self:SetCrazyArrow(uid, opts.arrivaldistance, opts.title)
    end

    waypoints[m] = waypoints[m] or {}
    waypoints[m][key] = uid

    -- If this is a persistent waypoint, then add it to the waypoints table
    if opts.persistent then
        self.waypointprofile[m][key] = uid
    end

    if not opts.silent and self.profile.general.announce then
        local ctxt = RoundCoords(x, y, 2)
        local desc = opts.title and opts.title or ""
        local sep = opts.title and " - " or ""
        local msg = string.format(L["|cffffff78TomTom:|r Added a waypoint (%s%s%s) in %s"], desc, sep, ctxt, zoneName)
        ChatFrame1:AddMessage(msg)
    end

    return uid
end

-- Check to see if a given uid/waypoint is actually set somewhere
function TomTom:IsValidWaypoint(waypoint)
    local m = waypoint[1]
    local key = self:GetKey(waypoint)
    if waypoints[m] and waypoints[m][key] then
        return true
    else
        return false
    end
end

function TomTom:WaypointExists(m, x, y, desc)
    local key = self:GetKeyArgs(m, x, y, desc)
    if waypoints[m] and waypoints[m][key] then
        return true
    else
        return false
    end
end

function TomTom:SetCustomWaypoint(m, x, y, opts)
    opts.persistent = false
    return self:AddWaypoint(m, x, y, opts)
end

do
    -- Original Code courtesy ckknight, modified for BFA by Ludovicus
    function GetCurrentCursorPosition()
        local cx, cy = WorldMapFrame:GetNormalizedCursorPosition()

        if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
            return nil, nil
        end

        return cx, cy
    end

    local coord_fmt = "%%.%df, %%.%df"
    function RoundCoords(x,y,prec)
        local fmt = coord_fmt:format(prec, prec)
        return fmt:format(x*100, y*100)
    end


	local coord_throttle = 0
    function WorldMap_OnUpdate(self, elapsed)
		coord_throttle = coord_throttle + elapsed
		if coord_throttle <= TomTom.profile.mapcoords.throttle then
			return
		end

		coord_throttle = 0
        local x,y = TomTom:GetCurrentCoords()
        local opt = TomTom.db.profile

        if not x or not y then
            self.Player:SetText("Player: ---")
        else
            self.Player:SetFormattedText("Player: %s", RoundCoords(x, y, opt.mapcoords.playeraccuracy))
        end

        local cX, cY = GetCurrentCursorPosition()

        if not cX or not cY then
            self.Cursor:SetText("Cursor: ---")
        else
            self.Cursor:SetFormattedText("Cursor: %s", RoundCoords(cX, cY, opt.mapcoords.cursoraccuracy))
        end
    end
end

do
    local bcounter = 0
    function Block_OnUpdate(self, elapsed)
        bcounter = bcounter + elapsed
        if (not TomTom) or not (TomTom.profile) then return; end
        if bcounter > TomTom.profile.block.throttle then
            bcounter = bcounter - TomTom.profile.block.throttle

            local x,y = TomTom:GetCurrentCoords()

            local opt = TomTom.db.profile
            if not x or not y then
                local blank = ("-"):rep(8)
                self.Text:SetText(blank)
            else
                self.Text:SetFormattedText("%s", RoundCoords(x, y, opt.block.accuracy))
            end
        end
    end

    function Block_OnDragStart(self, button, down)
        if not TomTom.db.profile.block.lock then
            self:StartMoving()
        end
    end

    function Block_OnDragStop(self, button, down)
        self:StopMovingOrSizing()
    end

    function Block_OnClick(self, button, down)
        local m,x,y = TomTom:GetCurrentPlayerPosition()
        local zoneName = hbd:GetLocalizedMap(m)
        local desc = string.format("%s: %.2f, %.2f", zoneName, x*100, y*100)
        TomTom:AddWaypoint(m, x, y, {
            title = desc,
        })
    end
end

function TomTom:DebugListLocalWaypoints()
    local m,x,y = self:GetCurrentPlayerPosition()
    local ctxt = RoundCoords(x, y, 2)
    local czone = hbd:GetLocalizedMap(m)
    self:Printf(L["You are at (%s) in '%s' (map: %d)"], ctxt, czone or "UNKNOWN", m)
    if waypoints[m] then
        for key, wp in pairs(waypoints[m]) do
            local ctxt = RoundCoords(wp[2], wp[3], 2)
            local desc = wp.title and wp.title or L["Unknown waypoint"]
            local indent = "   "
            self:Printf(L["%s%s - %s (map: %d)"], indent, desc, ctxt, wp[1])
        end
    else
        local indent = "   "
        self:Printf(L["%sNo waypoints in this zone"], indent)
    end
end

function TomTom:DebugListAllWaypoints()
    local m,x,y = self:GetCurrentPlayerPosition()
    local ctxt = RoundCoords(x, y, 2)
    local czone = hbd:GetLocalizedMap(m)
    self:Printf(L["You are at (%s) in '%s' (map: %d)"], ctxt, czone or "UNKNOWN", m)
    for m in pairs(waypoints) do
        local zoneName = hbd:GetLocalizedMap(m)
        self:Printf("%s:", zoneName)
        for key, wp in pairs(waypoints[m]) do
            local ctxt = RoundCoords(wp[2], wp[3], 2)
            local desc = wp.title and wp.title or L["Unknown waypoint"]
            local indent = "   "
            self:Printf(L["%s%s - %s (map: %d)"], indent, desc, ctxt, wp[1])
        end
    end
end

local function usage()
    ChatFrame1:AddMessage(L["|cffffff78TomTom |r/way |cffffff78Usage:|r"])
    ChatFrame1:AddMessage(L["|cffffff78/way <x> <y> [desc]|r - Adds a waypoint at x,y with descrtiption desc"])
    ChatFrame1:AddMessage(L["|cffffff78/way <zone> <x> <y> [desc]|r - Adds a waypoint at x,y in zone with description desc"])
    ChatFrame1:AddMessage(L["|cffffff78/way reset all|r - Resets all waypoints"])
    ChatFrame1:AddMessage(L["|cffffff78/way reset <zone>|r - Resets all waypoints in zone"])
    ChatFrame1:AddMessage(L["|cffffff78/way local|r - Lists active waypoints in current zone"])
    ChatFrame1:AddMessage(L["|cffffff78/way list|r - Lists all active waypoints"])
end


function TomTom:GetCZWFromMapID(m)
    local zone, continent, world

    local mapInfo = C_Map.GetMapInfo(m)
    repeat
        mapInfo = C_Map.GetMapInfo(m)
        if mapInfo.mapInfo == 3 then
            -- Its a zone map
            zone = m
        elseif mapInfo.mapInfo == 2 then
            continent = m
        elseif mapInfo.mapInfo == 1 then
            world = m
        end
        m = mapInfo.parentMapID
    until (m == 946)
    return continent, world, zone
end

function TomTom:GetClosestWaypoint()
    local m,x,y = self:GetCurrentPlayerPosition()
    local c,w,z = TomTom:GetCZWFromMapID(m)

    local closest_waypoint = nil
    local closest_dist = nil

    if not self.profile.arrow.closestusecontinent then
		-- Simple search within this zone
		if waypoints[m] then
			for key, waypoint in pairs(waypoints[m]) do
				local dist = TomTom:GetDistanceToWaypoint(waypoint)
				if (dist and closest_dist == nil) or (dist and dist < closest_dist) then
					closest_dist = dist
					closest_waypoint = waypoint
				end
			end
		end
	else
		-- Search all waypoints on this continent
		for map, waypoints in pairs(waypoints) do
			if c == TomTom:GetCZWFromMapID(map) then
				for key, waypoint in pairs(waypoints) do
					local dist = TomTom:GetDistanceToWaypoint(waypoint)
					if (dist and closest_dist == nil) or (dist and dist < closest_dist) then
						closest_dist = dist
						closest_waypoint = waypoint
					end
				end
			end
		end
	end

    if closest_dist then
        return closest_waypoint
    end
end

function TomTom:SetClosestWaypoint()
    local uid = self:GetClosestWaypoint()
    if uid then
        local data = uid
        TomTom:SetCrazyArrow(uid, TomTom.profile.arrow.arrival, data.title)
        local m, x, y = unpack(data)
        local zoneName = hbd:GetLocalizedMap(m)
        local ctxt = RoundCoords(x, y, 2)
        local desc = data.title and data.title or ""
        local sep = data.title and " - " or ""
        local msg = string.format(L["|cffffff78TomTom:|r Selected waypoint (%s%s%s) in %s"], desc, sep, ctxt, zoneName)
        ChatFrame1:AddMessage(msg)
    else
        local msg
        if not self.profile.arrow.closestusecontinent then
           msg = L["|cffffff78TomTom:|r Could not find a closest waypoint in this zone."]
        else
           msg = L["|cffffff78TomTom:|r Could not find a closest waypoint in this continent."]
        end
        ChatFrame1:AddMessage(msg)
    end
end

SLASH_TOMTOM_CLOSEST_WAYPOINT1 = "/cway"
SLASH_TOMTOM_CLOSEST_WAYPOINT2 = "/closestway"
SlashCmdList["TOMTOM_CLOSEST_WAYPOINT"] = function(msg)
    TomTom:SetClosestWaypoint()
end

SLASH_TOMTOM_WAYBACK1 = "/wayb"
SLASH_TOMTOM_WAYBACK2 = "/wayback"
SlashCmdList["TOMTOM_WAYBACK"] = function(msg)
    local title = L["Wayback"]
    if msg and msg:match("%S") then
        title = msg
    end

    local backm,backx,backy = TomTom:GetCurrentPlayerPosition()
    TomTom:AddWaypoint(backm,backx, backy, {
        title = title,
    })
end

SLASH_TOMTOM_WAY1 = "/way"
SLASH_TOMTOM_WAY2 = "/tway"
SLASH_TOMTOM_WAY3 = "/tomtomway"

TomTom.NameToMapId = {}
local NameToMapId = TomTom.NameToMapId
do
    -- Fetch the names of the zones
    for id in pairs(hbd.mapData) do
--        if (hbd.mapData[id].mapType == Enum.UIMapType.Zone) or (hbd.mapData[id].mapType == Enum.UIMapType.Micro) then
        if hbd.mapData[id][1] > 0 then
            -- Record only Zone or Micro maps
            local name = hbd.mapData[id].name
            if name and NameToMapId[name] then
                if type(NameToMapId[name]) ~= "table" then
                    -- convert to table
                    NameToMapId[name] = {NameToMapId[name]}
                end
                table.insert(NameToMapId[name], id)
            else
                NameToMapId[name] = id
            end
        end
    end
    -- Handle any duplicates
    local newEntries = {}
    for name, mapID in pairs(NameToMapId) do
        if type(mapID) == "table" then
            NameToMapId[name] = nil
            for idx, mapId in pairs(mapID) do
                local parent = hbd.mapData[mapId].parent
                local parentName = hbd.mapData[parent].name
                if parentName then
                    newEntries[name .. ":" .. parentName] = mapId
                end
            end
        end
    end
    -- Add the de-duplicated entries
    for name, mapID in pairs(newEntries) do
        NameToMapId[name] = mapID
    end
end

local wrongseparator = "(%d)" .. (tonumber("1.1") and "," or ".") .. "(%d)"
local rightseparator =   "%1" .. (tonumber("1.1") and "." or ",") .. "%2"

-- Make comparison only lowercase letters and numbers
local function lowergsub(s) return s:lower():gsub("[^%a%d]", "") end

SlashCmdList["TOMTOM_WAY"] = function(msg)
    msg = msg:gsub("(%d)[%.,] (%d)", "%1 %2"):gsub(wrongseparator, rightseparator)
    local tokens = {}
    for token in msg:gmatch("%S+") do table.insert(tokens, token) end

    -- Lower the first token
    local ltoken = tokens[1] and tokens[1]:lower()

    if ltoken == "local" then
        TomTom:DebugListLocalWaypoints()
        return
    elseif ltoken == "list" then
        TomTom:DebugListAllWaypoints()
        return
    elseif ltoken == "reset" then
        local ltoken2 = tokens[2] and tokens[2]:lower()
        if ltoken2 == "all" then
            if TomTom.db.profile.general.confirmremoveall then
                StaticPopup_Show("TOMTOM_REMOVE_ALL_CONFIRM")
            else
                StaticPopupDialogs["TOMTOM_REMOVE_ALL_CONFIRM"].OnAccept()
                return
            end

        elseif tokens[2] then
            -- Reset the named zone
            local zone = table.concat(tokens, " ", 2)
            -- Find a fuzzy match for the zone

            local matches = {}
            local lzone = lowergsub(zone)

            for name, mapId in pairs(NameToMapId) do
                local lname = lowergsub(name)
                if lname == lzone then
                    -- We have an exact match
                    matches = {name}
                    break
                elseif lname:match(lzone) then
                    table.insert(matches, name)
                end
            end

            if #matches > 7 then
                local msg = string.format(L["Found %d possible matches for zone %s.  Please be more specific"], #matches, zone)
                ChatFrame1:AddMessage(msg)
                return
            elseif #matches > 1 then
                table.sort(matches)

                ChatFrame1:AddMessage(string.format(L["Found multiple matches for zone '%s'.  Did you mean: %s"], zone, table.concat(matches, ", ")))
                return
            elseif #matches == 0 then
                local msg = string.format(L["Could not find any matches for zone %s."], zone)
                ChatFrame1:AddMessage(msg)
                return
            end

            local zoneName = matches[1]
            local mapId = NameToMapId[zoneName]

            local numRemoved = 0
            if waypoints[mapId] then
                for key, uid in pairs(waypoints[mapId]) do
                    TomTom:RemoveWaypoint(uid)
                    numRemoved = numRemoved + 1
                end
                ChatFrame1:AddMessage(L["Removed %d waypoints from %s"]:format(numRemoved, zoneName))
            else
                ChatFrame1:AddMessage(L["There were no waypoints to remove in %s"]:format(zoneName))
            end
        end
    elseif tokens[1] and not tonumber(tokens[1]) then
        -- Example: /way Elwynn Forest 34.2 50.7 Party in the forest!
        -- tokens[1] = Elwynn
        -- tokens[2] = Forest
        -- tokens[3] = 34.2
        -- tokens[4] = 50.7
        -- tokens[5] = Party
        -- ...
        --
        -- Find the first numeric token
        local zoneEnd
        for idx = 1, #tokens do
            local token = tokens[idx]
            if tonumber(token) then
                -- We've encountered a number, so the zone name must have
                -- ended at the prior token
                zoneEnd = idx - 1
                break
            end
        end

        if not zoneEnd then
            usage()
            return
        end

        -- This is a waypoint set, with a zone before the coords
        local zone = table.concat(tokens, " ", 1, zoneEnd)
        local x,y,desc = select(zoneEnd + 1, unpack(tokens))

        if desc then desc = table.concat(tokens, " ", zoneEnd + 3) end

        -- Find a fuzzy match for the zone
        local matches = {}
        local lzone = lowergsub(zone)

        for name,mapId in pairs(NameToMapId) do
            local lname = lowergsub(name)
            if lname == lzone then
                -- We have an exact match
                matches = {name}
                break
            elseif lname:match(lzone) then
                table.insert(matches, name)
            end
        end

        if #matches > 7 then
            local msg = string.format(L["Found %d possible matches for zone %s.  Please be more specific"], #matches, zone)
            ChatFrame1:AddMessage(msg)
            return
        elseif #matches > 1 then
            local msg = string.format(L["Found multiple matches for zone '%s'.  Did you mean: %s"], zone, table.concat(matches, ", "))
            ChatFrame1:AddMessage(msg)
            return
        elseif #matches == 0 then
            local msg = string.format(L["Could not find any matches for zone %s."], zone)
            ChatFrame1:AddMessage(msg)
            return
        end

        -- There was only one match, so proceed
        local zoneName = matches[1]
        local mapId = NameToMapId[zoneName]

        x = x and tonumber(x)
        y = y and tonumber(y)

        if not x or not y then
            return usage()
        end

        x = tonumber(x)
        y = tonumber(y)
        TomTom:AddWaypoint(mapId, x/100, y/100, {
            title = desc or L["TomTom waypoint"],
        })
    elseif tonumber(tokens[1]) then
        -- A vanilla set command
        local x,y,desc = unpack(tokens)
        if not x or not tonumber(x) then
            return usage()
        elseif not y or not tonumber(y) then
            return usage()
        end
        if desc then
            desc = table.concat(tokens, " ", 3)
        end
        x = tonumber(x)
        y = tonumber(y)

        local m = TomTom:GetCurrentPlayerPosition()
        if m and x and y then
            TomTom:AddWaypoint(m, x/100, y/100, {
                title = desc or L["TomTom waypoint"],
            })
        end
    else
        return usage()
    end
end

