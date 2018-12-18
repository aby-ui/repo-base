------------------------------------------------------------
-- Healthstone.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local IsShiftKeyDown = IsShiftKeyDown

local _, addon = ...
local L = addon.L

local ceateSpell = addon:BuildSpellList(nil, 6201)
local shiftCeateSpell = addon:BuildSpellList(nil, 29893)

local button = addon:CreateActionButton("WarlockHealthstone", 6262, nil, 120, "DUAL", "ITEM")
button:SetFlyProtect("type1", "item", "type2", "spell", "shift-type2", "spell")
button:SetSpell(6262)
button:SetItem(5512, 3, 1)
button:SetSpell2(29893)
button.icon2:Hide()
button:RequireSpell(6201)

button:SetAttribute("item", button.spell)
button:SetAttribute("spell", ceateSpell.spell)
button:SetAttribute("shift-spell2", shiftCeateSpell.spell)

function button:OnEnable()
	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	self:MODIFIER_STATE_CHANGED()
end

function button:OnTooltipRightText(tooltip)
	tooltip:AddLine(L["right click"]..ceateSpell.spell, 1, 1, 1, 1)
	tooltip:AddLine("Shift - "..L["right click"]..shiftCeateSpell.spell, 1, 1, 1, 1)
end

function button:OnUpdateTimer()
	return self.itemCount > 0 and "G", self.itemCooldownExpires
end

function button:MODIFIER_STATE_CHANGED()
	if IsShiftKeyDown() then
		button:SetSpell2(shiftCeateSpell)
		self.icon2:Show()
	else
		button:SetSpell2(ceateSpell)
		self.icon2:Hide()
	end
	self:UpdateTooltip()
end