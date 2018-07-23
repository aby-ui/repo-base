--[[------------------------------------------------------------
yleaf & warbaby 2011-2016
---------------------------------------------------------------]]

local GridStatus = Grid:GetModule("GridStatus")
local GridStatusHealth = GridStatus:GetModule("GridStatusHealth", true)
local GridRoster = Grid:GetModule("GridRoster")

local GridQuickHealth = Grid:NewModule("GridQuickHealth")

--[[------------------------------------------------------------
Status Update Code
---------------------------------------------------------------]]
local UnitIsDeadOrGhost, UnitHealth, UnitHealthMax, UnitClass = UnitIsDeadOrGhost, UnitHealth, UnitHealthMax, UnitClass
local max_cache, cur_cache = {}, {}

local function OnUpdate()
    --print("OnUpdate", GridQuickHealth.db.profile.update_interval)
    for guid, unitid in GridRoster:IterateRoster() do
        --ignore pets
        if not GridRoster:GetOwnerUnitidByUnitid(unitid) then
            local cur, max = UnitHealth(unitid), UnitHealthMax(unitid)
            if(max ~= max_cache[unitid] or cur ~= cur_cache[unitid]) then
                max_cache[unitid] = max
                cur_cache[unitid] = cur

                GridStatusHealth:UpdateUnitHealthQuick('QuickHealth', guid, unitid, cur, max, true)
                GridStatusHealth:UpdateUnitHealthQuick('QuickHealth', guid, unitid, cur, max)
            end
        end
    end
end

local function UnitClassColor(unitid)
    local _, class = UnitClass(unitid)
    if class then
        return GridStatus.db.profile.colors[class]
    end
end

--Transport from GridStatusHealth:UpdateUnit, remove unused branches
--But why not set Bar indicator directly ?
function GridStatusHealth:UpdateUnitHealthQuick(event, guid, unitid, cur, max, ignoreRange)
    local healthSettings = self.db.profile.unit_health
    local healthPriority = healthSettings.priority

    if healthSettings.deadAsFullHealth and UnitIsDeadOrGhost(unitid) then
        cur = max
    end

    if cur == max then
        healthPriority = 1
    end

    self.core:SendStatusGained(guid, "unit_health",
        healthPriority,
        (not ignoreRange and healthSettings.range),
        (healthSettings.useClassColors and UnitClassColor(unitid) or healthSettings.color),
        "QH",
        cur,
        max,
        healthSettings.icon)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:SetScript("OnEvent", function(self, event)
    wipe(max_cache)
    wipe(cur_cache)
    --GridStatusHealth:UnregisterEvent("UNIT_HEALTH")  --for test only
    --GridStatusHealth:UnregisterEvent("UNIT_MAXHEALTH")
end)

--[[------------------------------------------------------------
Grid Module Code
---------------------------------------------------------------]]
local L = Grid.L
if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    L['Quick Health']  = '快速血条变化'
    L['Update Interval'] = '刷新时间间隔'
end

GridQuickHealth.defaultDB = {
    update_interval = 0.1,
}

local options = {
    type = "group",
    name = L["Quick Health"],
    order = 1500,
    args = {
        update_interval = {
            type = 'range', min = 0.01, max = 0.3, step = 0.01,
            name = L['Update Interval'],
            get = function()
                return GridQuickHealth.db.profile.update_interval
            end,
            set = function(_, v)
                GridQuickHealth.db.profile.update_interval = v
                GridQuickHealth.ticker:Cancel()
                GridQuickHealth.ticker = C_Timer.NewTicker(GridQuickHealth.db.profile.update_interval, OnUpdate)
            end,
        }
    }
}

GridQuickHealth.options = options

function GridQuickHealth:OnInitialize()
    if not self.db then
        self.db = Grid.db:RegisterNamespace('GridQuickHealth', { profile = GridQuickHealth.defaultDB })
    end

    GridQuickHealth.ticker = C_Timer.NewTicker(GridQuickHealth.db.profile.update_interval, OnUpdate)

    --Grid.options.args.quick_health = options
end

function GridQuickHealth:OnEnable() end
function GridQuickHealth:OnDisable() end
