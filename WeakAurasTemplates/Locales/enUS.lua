local L = WeakAuras.L

-- WeakAuras/Templates
	L["Ability Charges"] = "Ability Charges"
	L["Add Triggers"] = "Add Triggers"
	L["Always Active"] = "Always Active"
	L["Back"] = "Back"
	L["Bloodlust/Heroism"] = "Bloodlust/Heroism"
	L["buff"] = "buff"
	L["Buff"] = "Buff"
	L["Buffs"] = "Buffs"
	L["Cancel"] = "Cancel"
	L["Cast"] = "Cast"
	L["cooldown"] = "cooldown"
	L["Cooldowns"] = "Cooldowns"
	L["Debuffs"] = "Debuffs"
	L["Enchants"] = "Enchants"
	L["General"] = "General"
	L["General Azerite Traits"] = "General Azerite Traits"
	L["Health"] = "Health"
	L["Keeps existing triggers intact"] = "Keeps existing triggers intact"
	L["On Procc Trinkets (Buff)"] = "On Procc Trinkets (Buff)"
	L["On Use Trinkets (Buff)"] = "On Use Trinkets (Buff)"
	L["On Use Trinkets (CD)"] = "On Use Trinkets (CD)"
	L["Pet alive"] = "Pet alive"
	L["Pet Behavior"] = "Pet Behavior"
	L["PvP Azerite Traits"] = "PvP Azerite Traits"
	L["PvP Talents"] = "PvP Talents"
	L["PVP Trinkets (Buff)"] = "PVP Trinkets (Buff)"
	L["PVP Trinkets (CD)"] = "PVP Trinkets (CD)"
	L["Replace all existing triggers"] = "Replace all existing triggers"
	L["Replace Triggers"] = "Replace Triggers"
	L["Resources"] = "Resources"
	L["Resources and Shapeshift Form"] = "Resources and Shapeshift Form"
	L["Runes"] = "Runes"
	L["Shapeshift Form"] = "Shapeshift Form"
	L["Specific Azerite Traits"] = "Specific Azerite Traits"
	L["Stagger"] = "Stagger"
	L["Totems"] = "Totems"
	L["Unknown Item"] = "Unknown Item"
	L["Unknown Spell"] = "Unknown Spell"


-- Make missing translations available
setmetatable(WeakAuras.L, {__index = function(self, key)
  self[key] = (key or "")
  return key
end})
