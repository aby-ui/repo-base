local addonName, ptable = ...
ptable.CONST = {}
local C = ptable.CONST

-- Updated for 7.0.3
C.armor, C.weapon = {}, {}
for k = 0, 20 do
	C.weapon[k+1] = GetItemSubClassInfo(LE_ITEM_CLASS_WEAPON,k)
end
for k = 0, 11 do
	C.armor[k+1] = GetItemSubClassInfo(LE_ITEM_CLASS_ARMOR,k)
end

C.WEAPONLABEL = GetItemClassInfo(LE_ITEM_CLASS_WEAPON)
C.ARMORLABEL = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)
C.JEWELRY = {['INVTYPE_FINGER']='', ['INVTYPE_NECK']=''}

-- Most of the constants are never used but it's convinient to have them here as a reminder and shortcut
C.ITEMS = {
	['One-Handed Axes'] = C.weapon[1],
	['Two-Handed Axes'] = C.weapon[2],
	['Bows'] = C.weapon[3],
	['Guns'] = C.weapon[4],
	['One-Handed Maces'] = C.weapon[5],
	['Two-Handed Maces'] = C.weapon[6],
	['Polearms'] = C.weapon[7],
	['One-Handed Swords'] = C.weapon[8],
	['Two-Handed Swords'] = C.weapon[9],
	['Staves'] = C.weapon[10],
	['Fist Weapons'] = C.weapon[11],
	--['Miscellaneous'] = select(12, weapon)
	['Daggers'] = C.weapon[13],
	['Thrown'] = C.weapon[14],
	['Crossbows'] = C.weapon[15],
	['Wands'] = C.weapon[16],
	--['Fishing Pole'] = select(17, weapon)
	-- armor
	--['Miscellaneous'] = C.armor[1]
	['Cloth'] = C.armor[2],
	['Leather'] = C.armor[3],
	['Mail'] = C.armor[4],
	['Plate'] = C.armor[5],
	['Shields'] = C.armor[7], -- from 5.4 '6' is a cosmetic
	--[[3rd slot
	['Librams'] = C.armor[7],
	['Idols'] = C.armor[8],
	['Totems'] = C.armor[9],
	]]--
}

C.SLOTS = {
	["INVTYPE_AMMO"]={"AmmoSlot"},
	["INVTYPE_HEAD"]={"HeadSlot"},
	["INVTYPE_NECK"]={"NeckSlot"},
	["INVTYPE_SHOULDER"]={"ShoulderSlot"},
	["INVTYPE_CHEST"]={"ChestSlot"},
	["INVTYPE_WAIST"]={"WaistSlot"},
	["INVTYPE_LEGS"]={"LegsSlot"},
	["INVTYPE_FEET"]={"FeetSlot"},
	["INVTYPE_WRIST"]={"WristSlot"},
	["INVTYPE_HAND"]={"HandsSlot"}, 
	["INVTYPE_FINGER"]={"Finger0Slot", "Finger1Slot"}, 
	["INVTYPE_TRINKET"]={"Trinket0Slot", "Trinket1Slot"},
	["INVTYPE_CLOAK"]={"BackSlot"},

	["INVTYPE_WEAPON"]={"MainHandSlot", "SecondaryHandSlot"},
	["INVTYPE_2HWEAPON"]={"MainHandSlot"},
	["INVTYPE_RANGED"]={"MainHandSlot"},
	["INVTYPE_RANGEDRIGHT"]={"MainHandSlot"},
	["INVTYPE_WEAPONMAINHAND"]={"MainHandSlot"}, 
	["INVTYPE_SHIELD"]={"SecondaryHandSlot"},
	["INVTYPE_WEAPONOFFHAND"]={"SecondaryHandSlot"},
	["INVTYPE_HOLDABLE"]={"SecondaryHandSlot"}
}


--[[ 
from GlobalStrings.lua
ITEM_MOD_CRIT_RATING_SHORT = "Critical Strike";
ITEM_MOD_DODGE_RATING_SHORT = "Dodge";
ITEM_MOD_PARRY_RATING_SHORT = "Parry";

ITEM_MOD_EXPERTISE_RATING_SHORT = "Expertise";
ITEM_MOD_HASTE_RATING_SHORT = "Haste";
ITEM_MOD_HIT_RATING_SHORT = "Hit";

ITEM_MOD_MASTERY_RATING_SHORT = "Mastery";
ITEM_MOD_SPELL_PENETRATION_SHORT = "Spell Penetration";
ITEM_MOD_SPELL_POWER_SHORT = "Spell Power";
]]--