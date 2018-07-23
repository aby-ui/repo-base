------------------------------------------------------------
-- Legacies.lua
--
-- Abin
-- 2012/10/02
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "MONK" then return end

local _, addon = ...

local button = addon:CreateActionButton("MonkLegacyOfTheEmperor", 115921, nil, 3600, "DUAL", "GROUP_AURA")
button:SetSpell(115921, "STATS")
button:SetAttribute("spell", button.spell)
button:RequireSpell(115921)
button:SetFlyProtect()

button = addon:CreateActionButton("MonkLegacyOfTheWhiteTiger", 116781, nil, 3600, "DUAL", "GROUP_AURA")
button:SetSpell(116781, "CRITICAL_STRIKE")
button:SetAttribute("spell", button.spell)
button:RequireSpell(116781)
button:SetFlyProtect()