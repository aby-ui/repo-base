local Parrot = Parrot

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_CombatStatus")

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Combat status"],
	name = "Enter combat",
	localName = L["Enter combat"],
	defaultTag = L["+Combat"],
	blizzardEvents = {
		["PLAYER_REGEN_DISABLED"] = {},
	},
	color = "ffffff", -- white
}

Parrot:RegisterCombatEvent{
	category = "Notification",
	subCategory = L["Combat status"],
	name = "Leave combat",
	localName = L["Leave combat"],
	defaultTag = L["-Combat"],
	blizzardEvents = {
		["PLAYER_REGEN_ENABLED"] = {},
	},
	color = "ffffff", -- white
}

Parrot:RegisterPrimaryTriggerCondition {
	name = "Enter combat",
	localName = L["Enter combat"],
	events = {
		PLAYER_REGEN_DISABLED = true,
	},
	exclusive = true,
}

Parrot:RegisterPrimaryTriggerCondition {
	name = "Leave combat",
	localName = L["Leave combat"],
	events = {
		PLAYER_REGEN_ENABLED = true,
	},
	exclusive = true,
}

Parrot:RegisterSecondaryTriggerCondition {
	name = "In combat",
	localName = L["In combat"],
	notLocalName = L["Not in combat"],
	check = function()
		return InCombatLockdown()
	end,
	exclusive = true,
}
