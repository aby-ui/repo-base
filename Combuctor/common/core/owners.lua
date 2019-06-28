--[[
	owners.lua
		Utility methods for owner display operations
--]]

local ADDON, Addon = ...
local CLASS_COLOR = '|cff%02x%02x%02x'
local RACE_PORTRAITS = 'Interface\\CharacterFrame\\TEMPORARYPORTRAIT-%GENDER-%RACE'
local RACE_ICONS

do
	local characters = 'Interface\\Icons\\Achievement_Character_%RACE_%GENDER'
	local heads = 'Interface\\Icons\\Achievement_%RACEHead'
	local inventory = 'Interface\\Icons\\INV_%RACE%GENDER'

	RACE_ICONS = {
		BloodElf = {characters, characters},
		Draenei = {characters, characters},
		Dwarf = {characters, characters},
		Gnome = {characters, characters},
		Goblin = {heads},
		Human = {characters, characters},
		Nightborne = {inventory, inventory},
		NightElf = {characters, characters},
		Orc = {characters, characters},
		Pandaren = {nil, characters},
		Tauren = {characters, characters},
		Troll = {characters, characters},
		Undead = {characters, characters},
	}
end

function Addon:MultipleOwnersFound()
	local owners = LibStub('LibItemCache-2.0'):IterateOwners()
	return owners() and owners() -- more than one
end

function Addon:GetOwnerIcon(owner)
	if owner.isguild then
		return owner.faction == 'Alliance' and 'Interface/Icons/inv_bannerpvp_02' or 'Interface/Icons/inv_bannerpvp_01'
	end

	local race = owner.race
	if race == 'Scourge' then
		race = 'Undead'
	elseif not race then
		return ''
	end

	local icon = RACE_ICONS[race] and RACE_ICONS[race][owner.gender-1] or RACE_PORTRAITS
	local gender = owner.gender == 3 and 'Female' or 'Male'

	return icon:gsub('%%RACE', race):gsub('%%GENDER', gender)
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
