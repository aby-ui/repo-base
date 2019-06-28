------------------------------------------------------------
-- Blessings.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "PALADIN" then return end

local _, addon = ...
local L = addon.L

--[[
local spellList = {}
addon:BuildSpellList(spellList, 20217, "STATS")
addon:BuildSpellList(spellList, 19740, "MASTERY")

local button = addon:CreateActionButton("PaladinBlessings", L["blessings"], nil, 3600, "DUAL", "GROUP_AURA")
button:SetScrollable(spellList)
button:RequireSpell(20217)
button:SetFlyProtect()
]]

local button = addon:CreateActionButton("PaladinBlessingsKing", 203538, nil, 3600, nil, "GROUP_UNIQUE")
button:SetSpell(203538)
button:SetAttribute("spell", button.spell)
button:AllowSelf()
button:RequireSpell(203538)
button:AlertIfMissing(242981)
button:SetFlyProtect()
local Button_OnUpdateTimer = button.OnUpdateTimer
button.OnUpdateTimer = function(self, ...)
    local status, expires = Button_OnUpdateTimer(self, ...)
    if status ~= "R" and self.affectedUnit ~= "player" then return "Y", expires end
    return status, expires
end

local button = addon:CreateActionButton("PaladinBlessingsWisdom", 203539, nil, 3600, nil, "GROUP_UNIQUE")
button:SetSpell(203539)
button:SetAttribute("spell", button.spell)
button:AllowSelf()
button:RequireSpell(203539)
button:AlertIfMissing(242981)
button:SetFlyProtect()
local Button_OnUpdateTimer = button.OnUpdateTimer
button.OnUpdateTimer = function(self, ...)
    local status, expires = Button_OnUpdateTimer(self, ...)
    if status ~= "R" and self.affectedUnit ~= "player" then return "Y", expires end
    return status, expires
end