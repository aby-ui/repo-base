------------------------------------------------------------
-- WeaponPoison.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "ROGUE" then return end

local _, addon = ...
local L = addon.L

local spellList1 = {}
addon:BuildSpellList(spellList1, 315584) --315584)
addon:BuildSpellList(spellList1, 8679)

local button1 = addon:CreateActionButton("RoguePoison1", L["damage poisons"], nil, 3600, "PLAYER_AURA")
button1.auraMap = { [GetSpellInfo(315584)] = GetSpellInfo(2823) } --速效药膏，致命药膏
button1:SetFlyProtect()
--button1:RequireSpell(315584) --有问题，2级技能名字不一样，技能书按名字来，但是IsSpellKnown用真实ID
button1:SetScrollable(spellList1)

local spellList2 = {}
addon:BuildSpellList(spellList2, 3408)
addon:BuildSpellList(spellList2, 5761)

local button2 = addon:CreateActionButton("RoguePoison2", L["utility poisons"], nil, 3600, "PLAYER_AURA")
button2:SetFlyProtect()
button2:RequireSpell(3408)
button2:SetScrollable(spellList2)


------------------------------------------------------------
-- Draenor Upgrade Passive, same spell but different buff
------------------------------------------------------------
-- MORTAL_WOUNDS
--AddDebuffGroup("DEADLY_POISON", 2823, 157584, 108211)