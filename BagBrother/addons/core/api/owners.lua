--[[
	owners.lua
		Utility methods for owner display operations
--]]

local ADDON, Addon = ...
local Owners = Addon:NewModule('Owners')

local DEFAULT_COORDS = {0, 1, 0, 1}
local CLASS_COLOR = '|cff%02x%02x%02x'
local ALLIANCE_BANNER = 'Interface/Icons/Inv_BannerPvP_02'
local HORDE_BANNER = 'Interface/Icons/Inv_BannerPvP_01'
local RACE_TEXTURE, RACE_TABLE

if Addon.IsClassic then
	RACE_TEXTURE = 'Interface/Glues/CharacterCreate/UI-CharacterCreate-Races'
	RACE_TABLE = {
		HUMAN_MALE		= {0, 0.25, 0, 0.25},
		DWARF_MALE		= {0.25, 0.5, 0, 0.25},
		GNOME_MALE		= {0.5, 0.75, 0, 0.25},
		NIGHTELF_MALE	= {0.75, 1.0, 0, 0.25},
		TAUREN_MALE		= {0, 0.25, 0.25, 0.5},
		SCOURGE_MALE	= {0.25, 0.5, 0.25, 0.5},
		TROLL_MALE		= {0.5, 0.75, 0.25, 0.5},
		ORC_MALE		= {0.75, 1.0, 0.25, 0.5},
		HUMAN_FEMALE	= {0, 0.25, 0.5, 0.75},
		DWARF_FEMALE	= {0.25, 0.5, 0.5, 0.75},
		GNOME_FEMALE	= {0.5, 0.75, 0.5, 0.75},
		NIGHTELF_FEMALE	= {0.75, 1.0, 0.5, 0.75},
		TAUREN_FEMALE	= {0, 0.25, 0.75, 1.0},
		SCOURGE_FEMALE	= {0.25, 0.5, 0.75, 1.0},
		TROLL_FEMALE	= {0.5, 0.75, 0.75, 1.0},
		ORC_FEMALE		= {0.75, 1.0, 0.75, 1.0},
	}
else
	RACE_TABLE = {
		highmountaintauren = 'highmountain',
		lightforgeddraenei = 'lightforged',
		scourge = 'undead',
		zandalaritroll = 'zandalari',
	}
end

function Owners:MultipleFound()
	local iter = Addon:IterateOwners()
	return iter() and iter() -- more than one
end

function Owners:GetIcon(owner)
	if owner.race then
		if RACE_TEXTURE then
			return RACE_TEXTURE, RACE_TABLE[owner.race:upper() .. '_' .. (owner.gender == 3 and 'FEMALE' or 'MALE')]
		end

		local race = owner.race:lower()
		return format('raceicon-%s-%s', RACE_TABLE[race] or race, owner.gender == 3 and 'female' or 'male')
	end

	return owner.faction == 'Alliance' and ALLIANCE_BANNER or HORDE_BANNER, DEFAULT_COORDS
end

function Owners:GetIconString(owner, size, x, y)
	local icon, coords = self:GetIcon(owner)
	if coords then
		local u,v,w,z = unpack(coords)
		return CreateTextureMarkup(icon, 128,128, size,size, u,v,w,z, x,y)
	else
		return CreateAtlasMarkup(icon, size,size, x,y)
	end
end

function Owners:GetColorString(owner)
	local color = self:GetColor(owner)
	local brightness = color.r + color.g + color.b
	local scale = max(1.8 / brightness, 1.0) * 255

	return CLASS_COLOR:format(min(color.r * scale, 255), min(color.g * scale, 255), min(color.b * scale, 255)) .. '%s|r'
end

function Owners:GetColor(owner)
	return owner.class and (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[owner.class] or PASSIVE_SPELL_FONT_COLOR
end
