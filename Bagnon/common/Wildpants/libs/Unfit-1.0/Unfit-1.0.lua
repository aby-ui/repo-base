--[[
Copyright 2011-2022 João Cardoso
Unfit is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this library give you permission to embed it
with independent modules to produce an addon, regardless of the license terms of these
independent modules, and to copy and distribute the resulting software under terms of your
choice, provided that you also meet, for each embedded independent module, the terms and
conditions of the license of that module. Permission is not granted to modify this library.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

This file is part of Unfit.
--]]

local Lib = LibStub:NewLibrary('Unfit-1.0', 10)
if not Lib then return end


--[[ Data ]]--

do
	local _, Class = UnitClass('player')
	local Unusable

	if Class == 'DEATHKNIGHT' then
		Unusable = { -- weapon, armor, dual-wield
			{Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
			{Enum.ItemArmorSubclass.Shield}
		}
	elseif Class == 'DEMONHUNTER' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
			{Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield}
		}
	elseif Class == 'DRUID' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
			{Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
			true
		}
	elseif Class == 'HUNTER' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Wand},
			{Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield}
		}
	elseif Class == 'MAGE' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow},
			{Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
			true
		}
	elseif Class == 'MONK' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
			{Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield}
		}
	elseif Class == 'PALADIN' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
			{},
			true
		}
	elseif Class == 'PRIEST' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow},
			{Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
			true
		}
	elseif Class == 'ROGUE' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Wand},
			{Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield}
		}
	elseif Class == 'SHAMAN' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
			{Enum.ItemArmorSubclass.Plate}
		}
	elseif Class == 'WARLOCK' then
		Unusable = {
			{Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow},
			{Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
			true
		}
	elseif Class == 'WARRIOR' then
		Unusable = {{Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Wand}, {}}
	else
		Unusable = {{}, {}}
	end


	Lib.unusable = {}
	Lib.cannotDual = Unusable[3]

	for i, class in ipairs({Enum.ItemClass.Weapon, Enum.ItemClass.Armor}) do
		local list = {}
		for _, subclass in ipairs(Unusable[i]) do
			list[subclass] = true
		end

		Lib.unusable[class] = list
	end
end


--[[ API ]]--

function Lib:IsItemUnusable(...)
	if ... then
		local slot, _,_, class, subclass = select(9, GetItemInfo(...))
		return Lib:IsClassUnusable(class, subclass, slot)
	end
end

function Lib:IsClassUnusable(class, subclass, slot)
	if class and subclass and Lib.unusable[class] then
		return slot ~= '' and Lib.unusable[class][subclass] or slot == 'INVTYPE_WEAPONOFFHAND' and Lib.cannotDual
	end
end
