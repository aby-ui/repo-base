------------------------------------------------------------
-- MarkOfTheWild.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "DRUID" then return end

local _, addon = ...
local L = addon.L

local button = addon:CreateActionButton("DruidMarkOfTheWild", 1126, nil, 3600, "DUAL", "GROUP_AURA")
button:SetSpell(1126, "STATS")
button:SetAttribute("spell", button.spell)
button:RequireSpell(1126)
button:SetFlyProtect()