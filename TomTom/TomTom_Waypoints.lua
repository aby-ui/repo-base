--[[--------------------------------------------------------------------------
--  TomTom - A navigational assistant for World of Warcraft
--
--  This file contains the internal implementation of TomTom's waypoints.
--  None of these functions should be called directly by addons if they want
--  the waypoints to obey normal TomTom options and behavior.  In otherwords
--  don't call TomTom:SetWaypoint() or TomTom:ClearWaypoint(), use the public
--  TomTom:AddWaypoint() and TomTom:RemoveWaypoint() instead.
----------------------------------------------------------------------------]]

local addon_name, addon = ...
local hbd = addon.hbd
local hbdp = LibStub("HereBeDragons-Pins-2.0")

-- Create a tooltip to be used when mousing over waypoints
local tooltip = CreateFrame("GameTooltip", "TomTomTooltip", UIParent, "GameTooltipTemplate")
do
    -- Set the the tooltip's lines
    local i = 1
    tooltip.lines = {}
    repeat
        local line = getglobal("TomTomTooltipTextLeft"..i)
        if line then
            tooltip.lines[i] = line
        end
        i = i + 1
    until not line
end

-- Store a reference to the minimap parent
local minimapParent = Minimap

-- Create a local table used as a frame pool
local pool = {}
local all_points = {}

-- Local declarations
local Minimap_OnEnter,Minimap_OnLeave,Minimap_OnUpdate,Minimap_OnClick,Minimap_OnEvent
local Arrow_OnUpdate
local World_OnEnter,World_OnLeave,World_OnClick

local square_half = math.sqrt(0.5)
local rad_135 = math.rad(135)

local function rotateArrow(self)
    if self.disabled then return end

    local angle = hbdp:GetVectorToIcon(self)
    if not angle then return self:Hide() end
    angle = angle + rad_135

    if GetCVar("rotateMinimap") == "1" then
        --local cring = MiniMapCompassRing:GetFacing()
        local cring = GetPlayerFacing()
        angle = angle - cring
    end

    local sin,cos = math.sin(angle) * square_half, math.cos(angle) * square_half
    self.arrow:SetTexCoord(0.5-sin, 0.5+cos, 0.5+cos, 0.5+sin, 0.5-cos, 0.5-sin, 0.5+sin, 0.5-cos)
end

function TomTom:ReparentMinimap(minimap)
    minimapParent = minimap
    for idx, waypoint in ipairs(all_points) do
        waypoint:SetParent(minimap)
    end
end

local waypointMap = {}

function TomTom:SetWaypoint(waypoint, callbacks, show_minimap, show_world)
    local m, x, y = unpack(waypoint)
    local profile = self.profile

    -- Try to acquire a waypoint from the frame pool
    local point = table.remove(pool)

    if not point then
        point = {}

        local minimap = CreateFrame("Button", nil, minimapParent)
        minimap:SetHeight(20)
        minimap:SetWidth(20)
        minimap:RegisterForClicks("RightButtonUp")

        -- Add to the "All points" table so we can reparent easily
        table.insert(all_points, minimap)

        minimap.icon = minimap:CreateTexture(nil,"OVERLAY")
        minimap.icon:SetPoint("CENTER", 0, 0)
        minimap.icon:SetBlendMode("BLEND")  -- ADD/BLEND

        minimap.arrow = minimap:CreateTexture(nil,"OVERLAY")
        minimap.arrow:SetTexture("Interface\\AddOns\\TomTom\\Images\\MinimapArrow-Green")
        minimap.arrow:SetPoint("CENTER", 0 ,0)
        minimap.arrow:SetHeight(40)
        minimap.arrow:SetWidth(40)
        minimap.arrow:Hide()

        -- Add the behavior scripts
        minimap:SetScript("OnEnter", Minimap_OnEnter)
        minimap:SetScript("OnLeave", Minimap_OnLeave)
        minimap:SetScript("OnUpdate", Minimap_OnUpdate)
        minimap:SetScript("OnClick", Minimap_OnClick)
        minimap:RegisterEvent("PLAYER_ENTERING_WORLD")
        minimap:SetScript("OnEvent", Minimap_OnEvent)

        if not TomTomMapOverlay then
            local overlay = CreateFrame("Frame", "TomTomMapOverlay", WorldMapFrame.BorderFrame)
            overlay:SetFrameStrata("HIGH")
            overlay:SetFrameLevel(9000)
            overlay:SetAllPoints(true)
        end

        local worldmap = CreateFrame("Button", nil, TomTomMapOverlay)
        worldmap:RegisterForClicks("RightButtonUp")
        worldmap.icon = worldmap:CreateTexture(nil, "OVERLAY")
        worldmap.icon:SetAllPoints()
        worldmap.icon:SetBlendMode("BLEND")
        worldmap:RegisterEvent("NEW_WMO_CHUNK")
        worldmap:SetScript("OnEnter", World_OnEnter)
        worldmap:SetScript("OnLeave", World_OnLeave)
        worldmap:SetScript("OnClick", World_OnClick)

        point.worldmap = worldmap
        point.minimap = minimap
    end

    waypointMap[waypoint] = point

    point.m = m
    point.x = x
    point.y = y
    point.show_world = show_world
    point.show_minimap = show_minimap
    point.callbacks = callbacks
    point.worldmap.callbacks = callbacks and callbacks.world
    point.minimap.callbacks = callbacks and callbacks.minimap

    -- Set up the minimap.icon
    if waypoint.minimap_displayID then
         SetPortraitTextureFromCreatureDisplayID(point.minimap.icon, waypoint.minimap_displayID)
    else
        point.minimap.icon:SetTexture(waypoint.minimap_icon or profile.minimap.default_icon)
    end
    point.minimap.icon:SetHeight(waypoint.minimap_icon_size or profile.minimap.default_iconsize)
    point.minimap.icon:SetWidth(waypoint.minimap_icon_size or profile.minimap.default_iconsize)

    -- Set up the worldmap.icon
    if waypoint.worldmap_displayID then
         SetPortraitTextureFromCreatureDisplayID(point.worldmap.icon, waypoint.worldmap_displayID)
    else
        point.worldmap.icon:SetTexture(waypoint.worldmap_icon or profile.worldmap.default_icon)
    end
    point.worldmap:SetHeight(waypoint.worldmap_icon_size or profile.worldmap.default_iconsize)
    point.worldmap:SetWidth(waypoint.worldmap_icon_size or profile.worldmap.default_iconsize)

    -- Process the callbacks table to put distances in a consumable format
    if callbacks and callbacks.distance then
        point.dlist = {}

        for k,v in pairs(callbacks.distance) do
            table.insert(point.dlist, k)
        end

        table.sort(point.dlist)
    end

	-- Clear the state for callbacks
	point.state = nil
	point.lastdist = nil

    -- Link the actual frames back to the waypoint object
    point.minimap.point = point
    point.worldmap.point = point
    point.uid = waypoint

    -- Place the waypoint
    -- AddMinimapIconMap(ref, icon, uiMapID, x, y, showInParentZone, floatOnEdge)
    hbdp:AddMinimapIconMap(self, point.minimap, m, x, y, true, true)

    if show_world then
        -- show worldmap pin on its parent zone map (if any)
        -- HBD_PINS_WORLDMAP_SHOW_PARENT    = 1
        -- show worldmap pin on the continent map
        -- HBD_PINS_WORLDMAP_SHOW_CONTINENT = 2
        -- show worldmap pin on the continent and world map
        -- HBD_PINS_WORLDMAP_SHOW_WORLD     = 3
        hbdp:AddWorldMapIconMap(self, point.worldmap, m, x, y, 3)
    else
        point.worldmap.disabled = true
    end

    if not show_minimap then
        -- Hide the minimap icon/arrow if minimap is off
        point.minimap:EnableMouse(false)
        point.minimap.icon:Hide()
        point.minimap.arrow:Hide()
        point.minimap.disabled = true
        rotateArrow(point.minimap)
    else
        point.minimap:EnableMouse(true)
        point.minimap.disabled = false
        rotateArrow(point.minimap)
    end
end

function TomTom:HideWaypoint(uid, minimap, worldmap)
    local point = waypointMap[uid]
    if point then
        if minimap then
            point.minimap.disabled = true
            point.minimap:Hide()
        end

        if worldmap then
            point.worldmap.disabled = true
            point.worldmap:Hide()
        end
    end
end

function TomTom:ShowWaypoint(uid)
    local point = waypointMap[uid]
    if point then
        point.minimap.disabled = not point.data.show_minimap
        point.minimap:Show()

        point.worldmap.disabled = not point.data.show_worldmap
        point.worldmap:Show()
    end
end

-- This function removes the waypoint from the active set
function TomTom:ClearWaypoint(uid)
    local point = waypointMap[uid]
    if point then
        hbdp:RemoveMinimapIcon(self, point.minimap)
        hbdp:RemoveWorldMapIcon(self, point.worldmap)
        point.minimap:Hide()
        point.worldmap:Hide()

        -- Clear our handles to the callback tables
        point.callbacks = nil
        point.minimap.callbacks = nil
        point.worldmap.callbacks = nil

        -- Clear disabled flags
        point.minimap.disabled = nil
        point.worldmap.disabled = nil

        point.dlist = nil
        point.uid = nil
        table.insert(pool, point)
        waypointMap[uid] = nil
    end
end

function TomTom:GetDistanceToWaypoint(uid)
    local point = waypointMap[uid]
    if point then
        local angle, distance = hbdp:GetVectorToIcon(point.minimap)
        return distance
    end
end

function TomTom:GetDirectionToWaypoint(uid)
    local point = waypointMap[uid]
    return point and hbdp:GetVectorToIcon(point.minimap)
end

do
    local tooltip_uid,tooltip_callbacks

    local function tooltip_onupdate(self, elapsed)
        if tooltip_callbacks and tooltip_callbacks.tooltip_update then
            local dist,x,y = TomTom:GetDistanceToWaypoint(tooltip_uid)
            tooltip_callbacks.tooltip_update("tooltip_update", tooltip, tooltip_uid, dist)
        end
    end

    function Minimap_OnClick(self, button)
        local data = self.callbacks

        if data and data.onclick then
            data.onclick("onclick", self.point.uid, self, button)
        end
    end

    function Minimap_OnEnter(self, motion)
        local data = self.callbacks

        if data and data.tooltip_show then
            local uid = self.point.uid
            local dist,x,y = TomTom:GetDistanceToWaypoint(uid)

            tooltip_uid = uid
            tooltip_callbacks = data

            -- Parent to UIParent, unless it's hidden
            if UIParent:IsVisible() then
                tooltip:SetParent(UIParent)
            else
                tooltip:SetParent(self)
            end

            tooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")

            data.tooltip_show("tooltip_show", tooltip, uid, dist)
            tooltip:Show()

            -- Set the update script if there is one
            if data.tooltip_update then
                tooltip:SetScript("OnUpdate", tooltip_onupdate)
            else
                tooltip:SetScript("OnUpdate", nil)
            end
        end
    end

    function Minimap_OnLeave(self, motion)
        tooltip_uid,tooltip_callbacks = nil,nil
        tooltip:Hide()
    end

    World_OnEnter = Minimap_OnEnter
    World_OnLeave = Minimap_OnLeave
    World_OnClick = Minimap_OnClick

    local minimap_count = 0

    function Minimap_OnUpdate(self, elapsed)
        local angle, dist = hbdp:GetVectorToIcon(self)
        local disabled = self.disabled

        if not dist then
            self:Hide()
            return
        end

        minimap_count = minimap_count + elapsed

        if minimap_count < 0.1 then return end

        -- Reset the counter
        minimap_count = 0

        local edge = hbdp:IsMinimapIconOnEdge(self)
        local data = self.point
        local callbacks = data.callbacks

        if edge then
            -- Check to see if this is a transition
            if not disabled then
                self.icon:Hide()
                self.arrow:Show()

                -- Rotate the icon, as required
                angle = angle + rad_135

                if GetCVar("rotateMinimap") == "1" then
                    --local cring = MiniMapCompassRing:GetFacing()
                    local cring = GetPlayerFacing()
                    angle = angle - cring
                end

                local sin,cos = math.sin(angle) * square_half, math.cos(angle) * square_half
                self.arrow:SetTexCoord(0.5-sin, 0.5+cos, 0.5+cos, 0.5+sin, 0.5-cos, 0.5-sin, 0.5+sin, 0.5-cos)
            end
        else
            if not disabled then
                self.icon:Show()
                self.arrow:Hide()
            end
        end

        if callbacks and callbacks.distance then
            local list = data.dlist

            local state = data.state
            local newstate

            -- Calculate the initial state
            if not state then
                for i=1,#list do
                    if dist <= list[i] then
                        state = i
                        break
                    end
                end

                -- Handle the case where we're outside the largest circle
                if not state then state = -1 end

                data.state = state
            else
                -- Calculate the new state
                for i=1,#list do
                    if dist <= list[i] then
                        newstate = i
                        break
                    end
                end

                -- Handle the case where we're outside the largest circle
                if not newstate then newstate = -1 end
            end

            -- If newstate is set, then this is a transition
            -- If only state is set, this is the initial state

            if state ~= newstate then
                -- Handle the initial state
                newstate = newstate or state
                local distance = list[newstate]
                local callback = callbacks.distance[distance]
                if callback then
                    callback("distance", data.uid, distance, dist, data.lastdist)
                end
                data.state = newstate
            end

            -- Update the last distance with the current distance
            data.lastdist = dist
        end
    end

    function Minimap_OnEvent(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            local data = self.point
            if data and data.uid and waypointMap[data.uid] then
                hbdp:AddMinimapIconMap(TomTom, self, data.m, data.x, data.y, true)
            end
        end
    end
end
