------------------------------------------------------------
-- WaterElement.lua
--
-- Abin
-- 2012/9/11
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "MAGE" then return end

local UnitExists = UnitExists

local _, addon = ...
local L = addon.L

local button = addon:CreateActionButton("MageWaterElement", L["pets"], nil, nil, "DUAL")
button:SetSpell(31687)
button:SetAttribute("spell1", button.spell)
button:SetSpell2(33395)
button:SetAttribute("spell2", button.spell2)
button:RequireSpell(31687)
button:SetFlyProtect()

function button:OnUpdateTimer()
	return UnitExists("pet") and "NONE" or "R"
end