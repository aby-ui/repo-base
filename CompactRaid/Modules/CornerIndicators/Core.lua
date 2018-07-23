------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2010/10/16
------------------------------------------------------------

local ipairs = ipairs
local type = type
local _

local L = CompactRaid:GetLocale("CornerIndicators")

local module = CompactRaid:CreateModule("CornerIndicators", "CHAR", L["title"], L["desc"], 1)
if not module then return end

module.initialOff = 1
module.INDICATOR_KEYS = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "LEFT", "RIGHT", "TOP", "BOTTOM" }

-- Class categories: 1 physical, 2 magical
local CLASS_CATEGORIES = {
	WARRIOR = 1,
	ROGUE = 1,
	DEATHKNIGHT = 1,
	HUNTER = 1,
	PRIEST = 2,
	MAGE = 2,
	WARLOCK = 2,
}

local function ConvertData(db)
	local key
	for _, key in ipairs(module.INDICATOR_KEYS) do
		if type(db[key]) == "table" then
			db[key] = module:EncodeData(db[key])
		end
	end
end

function module:OnTalentGroupChange(talentGroup, talentdb, firstTime)
	ConvertData(talentdb)
	self:InitOptionData()
	self:UpdateAllIndicators(nil, 1, 1, 1, 1)
end

function module:OnRestoreDefaults()
	self:InitOptionData()
	self:UpdateAllIndicators(nil, 1, 1, 1, 1)
end

function module:OnUnitChange(frame, displayedUnit, unit, inVehicle, class)
	local visual = self:GetVisual(frame)
	visual.unit = displayedUnit
	if not displayedUnit then
		visual:Hide()
		return
	end

	visual.class = class
	visual.inVehicle = inVehicle
	visual.category = CLASS_CATEGORIES[class]
	visual:Show()
	visual:UpdateAura()
end

function module:OnRangeChange(frame, inRange)
	local visual = self:GetVisual(frame)
	visual.inRange = inRange
	visual:UpdateAura()
end
