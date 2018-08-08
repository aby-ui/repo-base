------------------------------------------------------------
-- Fortitude.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------
if select(2, UnitClass("player")) ~= "PRIEST" then return end

local _, addon = ...
local L = addon.L

local button = addon:CreateActionButton("PriestFortitude", 21562, nil, 3600, "GROUP_AURA")
button:SetSpell(21562, "STAMINA")
button:SetAttribute("spell", button.spell)
button:RequireSpell(21562)
button:SetFlyProtect()