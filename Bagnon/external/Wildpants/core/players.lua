--[[
	players.lua
		Utility methods for player display operations
--]]

local ADDON, Addon = ...
local ALTERNATIVE_ICONS = 'Interface/CharacterFrame/TEMPORARYPORTRAIT-%s-%s'
local ICONS = 'Interface/Icons/Achievement_Character_%s_%s'
local CLASS_COLOR = '|cff%02x%02x%02x'

function Addon:GetPlayerIcon(player)
	local _, race, sex = self.Cache:GetPlayerInfo(player)
	if not race then
		return
	else
		sex = sex == 3 and 'Female' or 'Male'
	end

	if race ~= 'Worgen' and race ~= 'Goblin' and (race ~= 'Pandaren' or sex == 'Female') then
		if race == 'Scourge' then
			race = 'Undead'
		end

		return ICONS:format(race, sex)
	end

	return ALTERNATIVE_ICONS:format(sex, race)
end

function Addon:GetPlayerColorString(player)
	local color = self:GetPlayerColor(player)
	local brightness = color.r + color.g + color.b
	local scale = max(1.8 / brightness, 1.0) * 255

	return CLASS_COLOR:format(min(color.r * scale, 255), min(color.g * scale, 255), min(color.b * scale, 255)) .. '%s|r'
end

function Addon:GetPlayerColor(player)
	local class = self.Cache:GetPlayerInfo(player) or 'PRIEST'
	return (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
end