local L = GridManaBarsLocale

local GridRoster = Grid:GetModule("GridRoster")
local GridStatus = Grid:GetModule("GridStatus")
local GridMBFrame = Grid:GetModule("GridFrame"):GetModule("GridMBFrame")

GridMBStatus = GridStatus:NewModule("GridMBStatus", "AceTimer-3.0")

GridMBStatus.menuName = "ManaBar"

GridMBStatus.defaultDB = {
	hiderage = false,
	hidepetbars = true,
	unit_mana = {
		color = { r=1, g=1, b=1, a=1 },
		text = "Mana",
		enable = true,
		priority = 30,
		range = false
	}
}

GridMBStatus.options = false

local manabar_options = {

	hiderage = {
		type = "toggle",
		name = L["Ignore Non-Mana"],
		desc = L["Don't track power for non-mana users"],
		get = function()
			return GridMBStatus.db.profile.hiderage
		end,
		set = function(_, v)
			GridMBStatus.db.profile.hiderage = v
            GridMBStatus:UpdateAllUnits()
		end,
	},

	hidepet = {
		type = "toggle",
		name = L["Ignore Pets"],
		desc = L["Don't track power for pets"],
		get = function()
			return GridMBStatus.db.profile.hidepetbars
		end,
		set = function(_, v)
			GridMBStatus.db.profile.hidepetbars = v
            GridMBStatus:UpdateAllUnits()
		end,
	}
}

Mixin(GridMBFrame.options.args, manabar_options)

function GridMBStatus:OnInitialize()
	self.super.OnInitialize(self)

	self:RegisterStatus('unit_mana',L["Mana"], manabar_options, true)
	GridStatus.options.args['unit_mana'].args['color'] = nil
end

function GridMBStatus:StartTimer()
    self:StopTimer()
    self._timer = self:ScheduleRepeatingTimer("UpdateAllUnits", GridMBFrame.db.profile.update_interval)
end

function GridMBStatus:StopTimer()
    if self._timer then
        self:CancelTimer(self._timer)
    end
end

function GridMBStatus:OnStatusEnable(status)
    if status == "unit_mana" then
        self:StartTimer()
    end
end

function GridMBStatus:OnStatusDisable(status)
    if status == "unit_mana" then
        for guid, unitid in GridRoster:IterateRoster() do
            self.core:SendStatusLost(guid, "unit_mana")
        end
    end
end

function GridMBStatus:Reset()
	self.super.Reset(self)
	self:UpdateAllUnits()
end

function GridMBStatus:UpdateAllUnits()
    for guid, unitid in GridRoster:IterateRoster() do
        self:UpdateUnitPower(unitid, guid)
    end
end

local UnitIsDeadOrGhost, UnitIsConnected, UnitPower, UnitPowerMax = UnitIsDeadOrGhost, UnitIsConnected, UnitPower, UnitPowerMax

local CustomPowerBarColor = {}
CustomPowerBarColor["MANA"] = { r = 0.25, g = 0.50, b = 1.00 };

function GridMBStatus:UpdateUnitPower(unitid, guid)
    local self = GridMBStatus --for GridBorderStyle setfenv

	if not self.db.profile.unit_mana.enable or UnitIsDeadOrGhost(unitid) or not UnitIsConnected(unitid) then
		self.core:SendStatusLost(guid, "unit_mana")
		return
    end

    if self.db.profile.hidepetbars and (not UnitIsPlayer(unitid)) then
        self.core:SendStatusLost(guid, "unit_mana")
        return
    end

    local powerType, powerToken = UnitPowerType(unitid)

    if self.db.profile.hiderage and not UnitIsUnit(unitid, "player") and powerType~=0 then
        self.core:SendStatusLost(guid, "unit_mana")
        return
    end

	local cur, max = UnitPower(unitid), UnitPowerMax(unitid)
	local priority = self.db.profile.unit_mana.priority

	if cur == max then
		priority=1
    end

    local col = CustomPowerBarColor[powerToken] or PowerBarColor[powerToken] or PowerBarColor["MANA"]

    self.core:SendStatusGained(
        guid, "unit_mana",
        priority,
        nil,
        col,
        nil,
        cur,max,
        nil
    )
end