local SPELL_ID = 221772
local SPELL_NAME = GetSpellInfo(SPELL_ID)
local SPELL_ICON = select(3, GetSpellInfo(SPELL_ID))

local _, Grid = ...
local L = Grid.L

local settings

local GridRoster = Grid:GetModule("GridRoster")

local GridStatusOverflow = Grid:NewStatusModule("GridStatusOverflow")
GridStatusOverflow.menuName = SPELL_NAME
GridStatusOverflow.options = false

GridStatusOverflow.defaultDB = {
	alert_overflow = {
		enable = true,
		priority = 99,
		color = { r = 1, g = 0.5, b = 0.5, a = 1 },
		minimumValue = 100,
	},
}

local extraOptionsForStatus = {
	minimumValue = {
		width = "double",
		type = "range", min = 0, max = 10000, step = 100, isPercent = false,
		name = L["Minimum Value"].. "",
		get = function()
			return GridStatusOverflow.db.profile.alert_overflow.minimumValue
		end,
		set = function(_, v)
			GridStatusOverflow.db.profile.alert_overflow.minimumValue = v
		end,
	},
}

function GridStatusOverflow:PostInitialize()
	self:RegisterStatus("alert_overflow", SPELL_NAME .. "数值", extraOptionsForStatus, true)
	settings = self.db.profile.alert_overflow
end

function GridStatusOverflow:OnStatusEnable(status)
	if status == "alert_overflow" then
		self:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", "UpdateUnit")
		self:UpdateAllUnits()
	end
end

function GridStatusOverflow:OnStatusDisable(status)
	if status == "alert_overflow" then
		self:UnregisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
		self.core:SendStatusLostAllUnits("alert_overflow")
	end
end

function GridStatusOverflow:PostReset()
	settings = self.db.profile.alert_overflow
end

function GridStatusOverflow:UpdateAllUnits()
	for guid, unit in GridRoster:IterateRoster() do
		self:UpdateUnit("UpdateAllUnits", unit)
	end
end

local UnitGetTotalHealAbsorbs, UnitGUID, UnitHealth, UnitHealthMax, UnitIsDeadOrGhost, UnitIsVisible, UnitDebuff
    = UnitGetTotalHealAbsorbs, UnitGUID, UnitHealth, UnitHealthMax, UnitIsDeadOrGhost, UnitIsVisible, UnitDebuff

function GridStatusOverflow:UpdateUnit(event, unit)
	if not unit then return end

	local guid = UnitGUID(unit)
	if not GridRoster:IsGUIDInRaid(guid) then return end
	local duration, expires = nil, nil --select(6, UnitDebuff(unit, SPELL_NAME))

	local amount = UnitIsVisible(unit) and UnitGetTotalHealAbsorbs(unit) or 0
	if amount > (settings.minimumValue or 0) then
        self.core:SendStatusGained(guid, "alert_overflow",
            settings.priority,
            nil,
            settings.color,
            format("%d", amount / 10000 + 0.5),
            amount,
            amount,
            SPELL_ICON,
            duration and expires - duration or nil,
            duration or nil
        )
	else
		self.core:SendStatusLost(guid, "alert_overflow")
	end
end
