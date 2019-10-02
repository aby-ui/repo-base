-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local pairs, format, ipairs, rawget, wipe, _G, bit = 
	  pairs, format, ipairs, rawget, wipe, _G, bit

-- GLOBALS: TellMeWhen_CLEUOptions


local Type = TMW.Types.cleu
Type.Config = {}
local Config = Type.Config


Config.Events = {
		"",
	"SPACE",

	"CAT_SWING",
		"SWING_DAMAGE", -- normal
		"SWING_MISSED", -- normal
	"SPACE",
		"SWING_MISSED_DODGE", -- normal (fake event)
		"SWING_MISSED_PARRY", -- normal (fake event)
		"SWING_MISSED_BLOCK", -- normal (fake event)
		-- These are spell events, but are in the melee section
		-- because only melee spells can be dodged/parried/blocked
		"SPELL_MISSED_DODGE", -- normal (fake event)
		"SPELL_MISSED_PARRY", -- normal (fake event)
		"SPELL_MISSED_BLOCK", -- normal (fake event)
	"SPACE",
		"SPELL_EXTRA_ATTACKS", -- normal
	"SPACE",
		"RANGE_DAMAGE", -- normal
		"RANGE_MISSED", -- normal


	"CAT_SPELL",
		"SPELL_DAMAGE", -- normal
		"SPELL_DAMAGE_CRIT", -- normal (fake event)
		"SPELL_DAMAGE_NONCRIT", -- normal (fake event)
		"SPELL_MISSED", -- normal
		"SPELL_REFLECT", -- normal (fake event)

	"SPACE",
		"SPELL_CREATE", -- normal
		"SPELL_SUMMON", -- normal
	"SPACE",
		"SPELL_HEAL", -- normal
		"SPELL_HEAL_CRIT", -- normal (fake event)
		"SPELL_HEAL_NONCRIT", -- normal (fake event)
		"SPELL_RESURRECT", -- normal
	"SPACE",
		"SPELL_ENERGIZE", -- normal
		"SPELL_DRAIN", -- normal
		"SPELL_LEECH", -- normal
	"SPACE",
		"DAMAGE_SHIELD", -- normal
		"DAMAGE_SHIELD_MISSED", -- normal


	"CAT_AURA",
		"SPELL_DISPEL",-- extraSpellID/name
		"SPELL_DISPEL_FAILED",-- extraSpellID/name
		"SPELL_STOLEN",-- extraSpellID/name
	"SPACE",
		"SPELL_AURA_APPLIED", -- normal
		"SPELL_AURA_APPLIED_DOSE",
		"SPELL_AURA_REFRESH", -- normal
		"SPELL_AURA_REMOVED", -- normal
		"SPELL_AURA_REMOVED_DOSE",
		"SPELL_AURA_BROKEN",

		"SPELL_AURA_BROKEN_SPELL",-- extraSpellID/name
	"SPACE",
		"SPELL_PERIODIC_DAMAGE",
		"SPELL_PERIODIC_DRAIN",
		"SPELL_PERIODIC_ENERGIZE",
		"SPELL_PERIODIC_LEECH",
		"SPELL_PERIODIC_HEAL",
		"SPELL_PERIODIC_MISSED",


	"CAT_CAST",
		"SPELL_CAST_FAILED",
		"SPELL_CAST_START",
		"SPELL_CAST_SUCCESS",
	"SPACE",
		"SPELL_INTERRUPT",-- extraSpellID/name
		"SPELL_INTERRUPT_SPELL",-- extraSpellID/name (fake event)


	"CAT_MISC",
		"DAMAGE_SPLIT",
	"SPACE",
		"ENCHANT_APPLIED",
		"ENCHANT_REMOVED",
	"SPACE",
		"ENVIRONMENTAL_DAMAGE",
	"SPACE",
		"UNIT_DIED",
		"UNIT_DESTROYED",
		"SPELL_INSTAKILL",
		"PARTY_KILL",
}

Config.Flags = {
					-- "COMBATLOG_OBJECT_REACTION_MASK",
    "COMBATLOG_OBJECT_REACTION_FRIENDLY",
    "COMBATLOG_OBJECT_REACTION_NEUTRAL",
    "COMBATLOG_OBJECT_REACTION_HOSTILE",

    "SPACE",		-- "COMBATLOG_OBJECT_TYPE_MASK",
    "COMBATLOG_OBJECT_TYPE_PLAYER",
    "COMBATLOG_OBJECT_TYPE_NPC",
    "COMBATLOG_OBJECT_TYPE_PET",
    "COMBATLOG_OBJECT_TYPE_GUARDIAN",
    "COMBATLOG_OBJECT_TYPE_OBJECT",

	"SPACE",		-- "COMBATLOG_OBJECT_CONTROL_MASK",
    "COMBATLOG_OBJECT_CONTROL_PLAYER",
    "COMBATLOG_OBJECT_CONTROL_NPC",

	"SPACE",		-- "COMBATLOG_OBJECT_AFFILIATION_MASK",
    "COMBATLOG_OBJECT_AFFILIATION_MINE",
    "COMBATLOG_OBJECT_AFFILIATION_PARTY",
    "COMBATLOG_OBJECT_AFFILIATION_RAID",
    "COMBATLOG_OBJECT_AFFILIATION_OUTSIDER",

	"SPACE",		--"COMBATLOG_OBJECT_SPECIAL_MASK",
	"COMBATLOG_OBJECT_TARGET",
	"COMBATLOG_OBJECT_FOCUS",
    "COMBATLOG_OBJECT_MAINTANK",
    "COMBATLOG_OBJECT_MAINASSIST",
    "COMBATLOG_OBJECT_NONE",
}

Config.BetterMasks = {
	-- some of the default masks contain bits that arent used by any flags (read: they suck), so we will make our own
	COMBATLOG_OBJECT_REACTION_MASK = bit.bor(
		COMBATLOG_OBJECT_REACTION_FRIENDLY,
		COMBATLOG_OBJECT_REACTION_NEUTRAL,
		COMBATLOG_OBJECT_REACTION_HOSTILE
	),
    COMBATLOG_OBJECT_TYPE_MASK = bit.bor(
		COMBATLOG_OBJECT_TYPE_PLAYER,
		COMBATLOG_OBJECT_TYPE_NPC,
		COMBATLOG_OBJECT_TYPE_PET,
		COMBATLOG_OBJECT_TYPE_GUARDIAN,
		COMBATLOG_OBJECT_TYPE_OBJECT
	),
	COMBATLOG_OBJECT_CONTROL_MASK = bit.bor(
		COMBATLOG_OBJECT_CONTROL_PLAYER,
		COMBATLOG_OBJECT_CONTROL_NPC
	),
	COMBATLOG_OBJECT_AFFILIATION_MASK = bit.bor(
		COMBATLOG_OBJECT_AFFILIATION_MINE,
		COMBATLOG_OBJECT_AFFILIATION_PARTY,
		COMBATLOG_OBJECT_AFFILIATION_RAID,
		COMBATLOG_OBJECT_AFFILIATION_OUTSIDER
	),
}


function Config:LoadConfig()
	if TellMeWhen_CLEUOptions then
		Config:Menus_SetTexts()

		Config:CheckMasks()
	end
end


--- Warn the user if they have disabled all flags in a single category.
function Config:CheckMasks()
	TMW.HELP:Hide("CLEU_WHOLECATEGORYEXCLUDED")

	-- Check the flags of the icon to make sure that the user hasn't excluded every flag in a given category.
	-- If they have, then they have effectively disabled the icon. Tell the user if they have done this.
	for _, key in TMW:Vararg("SourceFlags", "DestFlags") do
		for maskName, mask in pairs(Config.BetterMasks) do
			if bit.band(TMW.CI.ics[key], mask) == 0 then
				local category = L["CLEU_" .. maskName]
				TMW.HELP:Show{
					code = "CLEU_WHOLECATEGORYEXCLUDED",
					codeOrder = 2,
					icon = TMW.CI.icon,
					relativeTo = TellMeWhen_CLEUOptions[key],
					x = 23,
					y = 3,
					text = format(L["CLEU_WHOLECATEGORYEXCLUDED"], category)
				}
				return
			end
		end
	end
end

--- Helper function to count how many flags that are disabled in a flag set.
-- This information gets displayed on the flag dropdowns.
function Config:CountDisabledBits(bitfield)
	local n = 0
	for _ = 1, 32 do
		local digit = bit.band(bitfield, 1)
		bitfield = bit.rshift(bitfield, 1)
		if digit == 0 then
			n = n + 1
		end
	end
	return n
end


---------- Dropdowns ----------
function Config:Menus_SetTexts()
	local n = 0
	if TMW.CI.ics.CLEUEvents[""] then
		n = L["CLEU_EVENTS_ALL"]
	else
		for k, v in pairs(TMW.CI.ics.CLEUEvents) do
			if v then
				n = n + 1
			end
		end
	end
	if n == 0 then
		n = " |cFFFF5959(0)|r |TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t"
	else
		n = " (|cff59ff59" .. n .. "|r)"
	end
	TellMeWhen_CLEUOptions.CLEUEvents:SetText(L["CLEU_EVENTS"] .. n)

	local n = Config:CountDisabledBits(TMW.CI.ics.SourceFlags)
	if n ~= 0 then
		n = "|cFFFF5959(" .. n .. ")|r "
	else
		n = "(" .. n .. ") "
	end
	TellMeWhen_CLEUOptions.SourceFlags:SetText(n .. L["CLEU_FLAGS_SOURCE"])

	local n = Config:CountDisabledBits(TMW.CI.ics.DestFlags)
	if n ~= 0 then
		n = "|cFFFF5959(" .. n .. ")|r "
	else
		n = "(" .. n .. ") "
	end
	TellMeWhen_CLEUOptions.DestFlags:SetText(n .. L["CLEU_FLAGS_DEST"])
end


local function EventMenu_OnClick(button, dropdown)
	if button.value == "" and not TMW.CI.ics.CLEUEvents[""] then -- if we are checking "Any Event" then uncheck all others
		wipe(TMW.CI.ics.CLEUEvents)
		TMW.DD:CloseDropDownMenus()
	elseif button.value ~= "" and TMW.CI.ics.CLEUEvents[""] then -- if we are checking a specific event then uncheck "Any Event"
		TMW.CI.ics.CLEUEvents[""] = false
		TMW.DD:CloseDropDownMenus()
	end

	TMW.CI.ics.CLEUEvents[button.value] = not TMW.CI.ics.CLEUEvents[button.value]
	
	dropdown:OnSettingSaved()
end
function Config.EventMenu(dropdown)
	local currentCategory
	for _, event in ipairs(Config.Events) do
		if event:find("^CAT_") then --and event ~= currentCategory then
			if TMW.DD.MENU_LEVEL == 1 then
				local info = TMW.DD:CreateInfo()
				info.text = L["CLEU_" .. event]
				info.value = event
				info.notCheckable = true
				info.hasArrow = true
				TMW.DD:AddButton(info)
			end
			currentCategory = event

		elseif (TMW.DD.MENU_LEVEL == 1 and not currentCategory) or (TMW.DD.MENU_LEVEL == 2 and TMW.DD.MENU_VALUE == currentCategory) then
			if event == "SPACE" then

				TMW.DD:AddSpacer()
			else
				local info = TMW.DD:CreateInfo()

				info.text = L["CLEU_" .. event]

				local tooltipText = rawget(L, "CLEU_" .. event .. "_DESC")
				if tooltipText then
					info.tooltipTitle = info.text
					info.tooltipText = tooltipText
				end

				info.value = event
				info.checked = TMW.CI.ics.CLEUEvents[event]
				info.keepShownOnClick = true
				info.isNotRadio = true
				info.func = EventMenu_OnClick
				info.arg1 = dropdown

				TMW.DD:AddButton(info)
			end
		end
	end
end



local function FlagsMenu_OnClick(button, dropdown)
	TMW.CI.ics[dropdown.flagSet] = bit.bxor(TMW.CI.ics[dropdown.flagSet], _G[button.value])

	dropdown:OnSettingSaved()
end
function Config.FlagsMenu(dropdown)
	Config:CheckMasks()

	for _, flag in ipairs(Config.Flags) do
		if flag == "SPACE" then
			TMW.DD:AddSpacer()
		else
			local info = TMW.DD:CreateInfo()

			info.text = L["CLEU_" .. flag]

			info.tooltipTitle = L["CLEU_" .. flag]
			info.tooltipText = L["CLEU_" .. flag .. "_DESC"]

			info.value = flag
			info.checked = bit.band(TMW.CI.ics[dropdown.flagSet], _G[flag]) ~= _G[flag]
			info.keepShownOnClick = true
			info.isNotRadio = true
			info.func = FlagsMenu_OnClick
			info.arg1 = dropdown

			TMW.DD:AddButton(info)
		end
	end
end




local SUG = TMW.SUG
local SpellCache = TMW:GetModule("SpellCache")

local Module = SUG:NewModule("cleu", SUG:GetModule("buff"))
function Module:Table_Get()
	return SpellCache:GetCache(), TMW.BE.buffs, TMW.BE.debuffs, TMW.BE.casts
end
function Module:Entry_Colorize_3(f, id)
	if TMW.BE.casts[id] then
		f.Background:SetVertexColor(1, .96, .41, 1) -- rogue yellow
	end
end

-- No specials. Override the inherited function.
Module.Table_GetSpecialSuggestions_1 = TMW.NULLFUNC
