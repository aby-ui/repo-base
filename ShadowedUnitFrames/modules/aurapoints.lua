local AuraPoints = setmetatable({
	isComboPoints = true,
	spells = {
		--["MAGE"] = {max = 4, name = GetSpellInfo(36032), filter = "HARMFUL"},
	}
}, {__index = ShadowUF.ComboPoints})

local trackSpell = AuraPoints.spells[select(2, UnitClass("player"))]
if( not trackSpell or not trackSpell.name ) then return end

ShadowUF:RegisterModule(AuraPoints, "auraPoints", ShadowUF.L["Aura Combo Points"])
local auraConfig = {max = trackSpell.max, key = "auraPoints", colorKey = "AURAPOINTS", icon = "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\combo"}

function AuraPoints:OnEnable(frame)
	frame.auraPoints = frame.auraPoints or CreateFrame("Frame", nil, frame)
	frame.auraPoints.cpConfig = auraConfig
	frame.comboPointType = auraConfig.key

	frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
	frame:RegisterUpdateFunc(self, "Update")
end

function AuraPoints:GetComboPointType()
	return "auraPoints"
end

function AuraPoints:GetPoints(unit)
	return select(3, ShadowUF.UnitAuraBySpell("player", trackSpell.name, trackSpell.filter)) or 0
end
