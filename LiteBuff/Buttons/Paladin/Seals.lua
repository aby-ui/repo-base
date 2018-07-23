------------------------------------------------------------
-- Seals.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "PALADIN" then return end

local UnitGUID = UnitGUID

local _, addon = ...
local L = addon.L

--163uiedit
local seals =  {
    31801,
    20154,
    20164,
    20165,
    105361,
}

local spellList = {}

local button = addon:CreateActionButton("PaladinSeals", L["seals"], nil, nil, "STANCE")
button:SetAttribute("type", "spell")

--163uiedit
local function update()
    wipe(spellList)
    for _, id in next, seals do
        if(IsSpellKnown(id)) then
            addon:BuildSpellList(spellList, id)
        end
    end

    button:SetScrollable(spellList)
end

addon:__163_OnSpellChanged(update)

