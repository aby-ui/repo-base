--[[
	owners.lua
		Utility methods for owner display operations
--]]

local ADDON, Addon = ...
local ALTERNATIVE_ICONS = 'Interface/CharacterFrame/TEMPORARYPORTRAIT-%s-%s'
local ICONS = 'Interface/Icons/Achievement_Character_%s_%s'
local CLASS_COLOR = '|cff%02x%02x%02x'

local ICONLESS_RACES = {
	['Worgen'] = true,
	['Goblin'] = true,
	['VoidElf'] = true,
	['Nightborne'] = true,
	['LightforgedDraenei'] = true,
	['HighmountainTauren'] = true,
}

function Addon:MultipleOwnersFound()
	local owners = LibStub('LibItemCache-2.0'):IterateOwners()
	return owners() and owners() -- more than one
end

function Addon:GetOwnerIcon(owner)
	if owner.isguild then
		return owner.faction == 'Alliance' and 'Interface/Icons/inv_bannerpvp_02' or 'Interface/Icons/inv_bannerpvp_01'
	end

	local gender = owner.gender == 3 and 'Female' or 'Male'
	local race = owner.race
	if not race then
		return ''
	end

	if not ICONLESS_RACES[race] and (race ~= 'Pandaren' or owner.gender == 3) then
		if race == 'Scourge' then
			race = 'Undead'
		end

		return ICONS:format(race, gender)
	end

	return ALTERNATIVE_ICONS:format(gender, race)
end

function Addon:GetOwnerColorString(owner)
	local color = self:GetOwnerColor(owner)
	local brightness = color.r + color.g + color.b
	local scale = max(1.8 / brightness, 1.0) * 255

	return CLASS_COLOR:format(min(color.r * scale, 255), min(color.g * scale, 255), min(color.b * scale, 255)) .. '%s|r'
end

function Addon:GetOwnerColor(owner)
	return owner.isguild and PASSIVE_SPELL_FONT_COLOR or (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[owner.class or 'PRIEST']
end
