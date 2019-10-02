--[[
	owners.lua
		Utility methods for owner display operations
--]]

local ADDON, Addon = ...
local DEFAULT_COORDS = {0, 1, 0, 1}
local CLASS_COLOR = '|cff%02x%02x%02x'

local HORDE_BANNER = 'Interface\\Icons\\inv_bannerpvp_01'
local ALLIANCE_BANNER = 'Interface\\Icons\\inv_bannerpvp_02'
local RACE_TEXTURE = 'Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races'
local RACE_COORDS

if Addon.IsRetail then
	RACE_COORDS = {
		HUMAN_MALE		= {0, 0.125, 0, 0.25},
		DWARF_MALE		= {0.125, 0.25, 0, 0.25},
		GNOME_MALE		= {0.25, 0.375, 0, 0.25},
		NIGHTELF_MALE	= {0.375, 0.5, 0, 0.25},
		TAUREN_MALE		= {0, 0.125, 0.25, 0.5},
		SCOURGE_MALE	= {0.125, 0.25, 0.25, 0.5},
		TROLL_MALE		= {0.25, 0.375, 0.25, 0.5},
		ORC_MALE		= {0.375, 0.5, 0.25, 0.5},
		HUMAN_FEMALE	= {0, 0.125, 0.5, 0.75},
		DWARF_FEMALE	= {0.125, 0.25, 0.5, 0.75},
		GNOME_FEMALE	= {0.25, 0.375, 0.5, 0.75},
		NIGHTELF_FEMALE	= {0.375, 0.5, 0.5, 0.75},
		TAUREN_FEMALE	= {0, 0.125, 0.75, 1.0},
		SCOURGE_FEMALE	= {0.125, 0.25, 0.75, 1.0},
		TROLL_FEMALE	= {0.25, 0.375, 0.75, 1.0},
		ORC_FEMALE		= {0.375, 0.5, 0.75, 1.0},
		BLOODELF_MALE	= {0.5, 0.625, 0.25, 0.5},
		BLOODELF_FEMALE	= {0.5, 0.625, 0.75, 1.0},
		DRAENEI_MALE	= {0.5, 0.625, 0, 0.25},
		DRAENEI_FEMALE	= {0.5, 0.625, 0.5, 0.75},
		GOBLIN_MALE		= {0.629, 0.750, 0.25, 0.5},
		GOBLIN_FEMALE	= {0.629, 0.750, 0.75, 1.0},
		WORGEN_MALE		= {0.629, 0.750, 0, 0.25},
		WORGEN_FEMALE	= {0.629, 0.750, 0.5, 0.75},
		PANDAREN_MALE	= {0.756, 0.881, 0, 0.25},
		PANDAREN_FEMALE	= {0.756, 0.881, 0.5, 0.75},
		NIGHTBORNE_MALE	= {0.375, 0.5, 0, 0.25},
		NIGHTBORNE_FEMALE	= {0.375, 0.5, 0.5, 0.75},
		HIGHMOUNTAINTAUREN_MALE		= {0, 0.125, 0.25, 0.5},
		HIGHMOUNTAINTAUREN_FEMALE	= {0, 0.125, 0.75, 1.0},
		VOIDELF_MALE	= {0.5, 0.625, 0.25, 0.5},
		VOIDELF_FEMALE	= {0.5, 0.625, 0.75, 1.0},
		LIGHTFORGEDDRAENEI_MALE	= {0.5, 0.625, 0, 0.25},
		LIGHTFORGEDDRAENEI_FEMALE	= {0.5, 0.625, 0.5, 0.75},
		DARKIRONDWARF_MALE		= {0.125, 0.25, 0, 0.25},
		DARKIRONDWARF_FEMALE	= {0.125, 0.25, 0.5, 0.75},
		MAGHARORC_MALE			= {0.375, 0.5, 0.25, 0.5},
		MAGHARORC_FEMALE		= {0.375, 0.5, 0.75, 1.0},
		ZANDALARITROLL_MALE		= {0.25, 0.375, 0, 0.25},
		ZANDALARITROLL_FEMALE	= {0.25, 0.375, 0.5, 0.75},
		KULTIRAN_MALE		= {0, 0.125, 0, 0.25},
		KULTIRAN_FEMALE		= {0, 0.125, 0.5, 0.75},
	}
else
	RACE_COORDS = {
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
end

function Addon:MultipleOwnersFound()
	local owners = LibStub('LibItemCache-2.0'):IterateOwners()
	return owners() and owners() -- more than one
end

function Addon:GetOwnerIconString(owner, size, x, y)
	local texture, coords = self:GetOwnerIcon(owner)
	local a, b, c, d = unpack(coords)

	return format('|T%s:%s:%s:%s:%s:128:128:%s:%s:%s:%s|t', texture, size, size, x, y, a*128,b*128,c*128,d*128)
end

function Addon:GetOwnerIcon(owner)
	if owner.race then
		local gender = owner.gender == 3 and 'FEMALE' or 'MALE'
		local race = strupper(owner.race)

		return RACE_TEXTURE, RACE_COORDS[race .. '_' .. gender]
	else
		return owner.faction == 'Alliance' and ALLIANCE_BANNER or HORDE_BANNER, DEFAULT_COORDS
	end
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
