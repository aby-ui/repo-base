do return end --TODO aby8
-----------------------
--      战场增强     --
-----------------------
local addonName = ...

local BF = {}
LibStub('AceEvent-3.0'):Embed(BF)
LibStub('AceTimer-3.0'):Embed(BF)
local requestTimer

function requestBoard()
    if(select(2, IsInInstance()) == 'pvp') then
        return RequestBattlefieldScoreData()
    else
        BF:CancelRequestTimer()
    end
end

function BF:CancelRequestTimer()
    if(requestTimer) then
        BF:CancelTimer(requestTimer)
        requestTimer = nil
    end
end

function BF:CreateCountText(f, n)
    local txt = f:CreateFontString(nil, 'OVERLAY')
    f[n] = txt

    txt:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')
    txt:SetPoint('CENTER', _G[f:GetName()..'Icon'])

    return txt
end

function BF:UPDATE_BATTLEFIELD_SCORE()
    if(not AlwaysUpFrame2) then return end

    local atxt = AlwaysUpFrame1._txt or self:CreateCountText(AlwaysUpFrame1, '_txt')
    local htxt = AlwaysUpFrame2._txt or self:CreateCountText(AlwaysUpFrame2, '_txt')

    if(select(2, IsInInstance()) == 'pvp') then
        local _, _, _, _, num_horde = GetBattlefieldTeamInfo(0)
        local _, _, _, _, num_alliance = GetBattlefieldTeamInfo(1)
        htxt:SetText(num_horde)
        atxt:SetText(num_alliance)
    else
        htxt:SetText''
        atxt:SetText''
    end
end

function BF:Init()
    self:RegisterEvent'PLAYER_ENTERING_WORLD'
end

function BF:PLAYER_DEAD()
    if(U1GetCfgValue(addonName, 'bfautorelease')) then
        return RepopMe()
    end
end

do
    local no_scoreboard = (U1IsAddonEnabled'capping' or U1IsAddonEnabled'battleinfo')
    function BF:PLAYER_ENTERING_WORLD()
        if(select(2, IsInInstance()) == 'pvp') then
            self:RegisterEvent'PLAYER_DEAD'
            if(not no_scoreboard) then
                self:RegisterEvent'UPDATE_BATTLEFIELD_SCORE'
                RequestBattlefieldScoreData()

                if(not requestTimer) then
                    requestTimer = self:ScheduleRepeatingTimer(requestBoard, 5)
                end
            end
        else
            self:UnregisterEvent'PLAYER_DEAD'
            self:UnregisterEvent'UPDATE_BATTLEFIELD_SCORE'
            if(requestTimer) then
                self:CancelRequestTimer()
            end
        end
    end
end

BF:Init()

--------------------------------
--      队友地图标记颜色      --
--------------------------------


local has_mapster = select(5, GetAddOnInfo'mapster') ~= 'MISSING'
if(not has_mapster) then return end

local RaidColor = {}
LibStub('AceEvent-3.0'):Embed(RaidColor)
LibStub('AceTimer-3.0'):Embed(RaidColor)

U1PLUGIN_ColorRostersOnMap = RaidColor


local path = [[Interface\AddOns\Mapster\Artwork\]]

local _size = 18
local stop_timer, start_timer
local noop = function() end

local function fixUnit(tex, unit)
    local _, _, subgroup = GetRaidRosterInfo(string.sub(unit, 5)+0)
    local _, class = UnitClass(unit)

    tex:SetTexture(path..'Group'..subgroup)

    if(not tex._SetVertexColor) then
        tex._SetVertexColor = tex.SetVertexColor
        tex.SetVertexColor = noop
    end

    local t = RAID_CLASS_COLORS[class]
    if(GetTime() % 1 < .5) then
        if UnitAffectingCombat(unit) then
            tex:_SetVertexColor(.8, 0, 0)
        elseif UnitIsDeadOrGhost(unit) then
            tex:_SetVertexColor(.2, .2, .2)
        elseif PlayerIsPVPInactive(unit) then
            tex:_SetVertexColor(.5, .2, .8)
        end
    elseif t then
        tex:_SetVertexColor(t.r, t.g, t.b)
    else
        tex:_SetVertexColor(.8, .8, .8)
    end
end

local function fixBMunit(i, unit)
    local tex = _G['BattlefieldMinimapRaid'..i..'Icon']
    fixUnit(tex, unit)
end

local function fixWMunit(i, unit)
    local tex = _G['WorldMapRaid'..i..'Icon']
    fixUnit(tex, unit)

    if(not tex._SetTexCoord) then
        tex._SetTexCoord = tex.SetTexCoord
        tex.SetTexCoord = noop
    end

    tex:_SetTexCoord(0, 1, 0, 1)
    _G['WorldMapRaid'..i]:SetSize(_size, _size)
end

local function group_icon_update()
    local battlefiledmapShown = BattlefieldMinimap and BattlefieldMinimap:IsVisible()
    local worldMapShown = WorldMapFrame:IsVisible()

    if not (battlefiledmapShown or worldMapShown) then
        return stop_timer()
    end

    --no BattlefieldMinimapRaid1 in 7.1
    --[[local numRaid = GetNumGroupMembers()
    if(numRaid > 0) then
        for i = 1, numRaid do
            local bmunit = battlefiledmapShown and _G['BattlefieldMinimapRaid'..i].unit
            local wmunit = _G['WorldMapRaid' .. i] and _G['WorldMapRaid' .. i].unit

            if(battlefiledmapShown and bmunit) then
                fixBMunit(i, bmunit)
            end

            if(worldMapShown and wmunit) then
                fixWMunit(i, wmunit)
            end
        end
    end--]]
end

do
    local _timer
    function stop_timer()
        if(_timer) then
            RaidColor:CancelTimer(_timer)
            _timer = nil
        end
    end

    function start_timer()
        if(not _timer) then
            _timer = RaidColor:ScheduleRepeatingTimer(group_icon_update, .5)
        end
    end
end

function RaidColor:WORLD_MAP_UPDATE()
    return start_timer()
end

function RaidColor:Init()
    if(U1GetCfgValue(addonName, 'map_raid_color')) then
        return self:Enable()
    else
        return self:Disable()
    end
end

function RaidColor:Enable()
    if(self._enabled) then return end
    self._enabled = true

    self:RegisterEvent'WORLD_MAP_UPDATE'
    start_timer()
end

function RaidColor:Disable()
    if(not self._enabled) then return end
    self._enabled = false

    self:UnregisterEvent'WORLD_MAP_UPDATE'
    stop_timer()

    -- return self:Restore()
end

-- local recover = function(icon, texture)
--     if(icon and texture) then
--         return icon:SetTexture(texture)
--     end
-- end

-- function RaidColor:Restore()
--     for i = 1, 40 do
--         local tex = _G['BattlefieldMinimapRaid'..i..'Icon']
--         recover(tex, [[Interface\WorldMap\WorldMapPartyIcon]])
--         local tex = _G['WorldMapRaid'..i..'Icon']
--         recover(tex, [[Interface\Minimap\PartyRaidBlips]])
--     end
-- end

-- done in config
-- RaidColor:Init()
