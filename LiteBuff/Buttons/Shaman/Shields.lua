------------------------------------------------------------
-- Shields.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "SHAMAN" then return end

local _, addon = ...
local L = addon.L

local button = addon:CreateActionButton("ShamanShields1", L["shields"], nil, 3600, "PLAYER_AURA")
button:SetSpell(324)
button:SetAttribute("spell", button.spell)
button:RequireSpell(324)
button:SetFlyProtect()

button = addon:CreateActionButton("ShamanShields2", L["shields"], nil, 3600, "PLAYER_AURA")
button:SetSpell(52127)
button:SetAttribute("spell", button.spell)
button:RequireSpell(52127)
button:SetFlyProtect()