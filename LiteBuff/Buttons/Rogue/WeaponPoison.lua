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
addon:BuildSpellList(spellList1, 2823)
addon:BuildSpellList(spellList1, 8679)

local button1 = addon:CreateActionButton("RoguePoison1", L["damage poisons"], nil, 3600, "PLAYER_AURA")
button1:SetFlyProtect()
button1:SetScrollable(spellList1)

--163fix 2015.10 致命药膏升级为速效毒药，buff名字改变，测试两个buff
local spell2823 = GetSpellInfo(2823)
local spellAlt = GetSpellInfo(157584)
if spellAlt then
    function button1:OnUpdateTimer(spell, spell2)
        local expires = addon:GetUnitBuffTimer("player", spell)
        if not expires and spell == spell2823 then
            expires = addon:GetUnitBuffTimer("player", spellAlt)
        end
        return expires, expires
    end
end

local spellList2 = {}
addon:BuildSpellList(spellList2, 3408)
--addon:BuildSpellList(spellList2, 5761)
addon:BuildSpellList(spellList2, 108211)
--addon:BuildSpellList(spellList2, 108215)

local button2 = addon:CreateActionButton("RoguePoison2", L["utility poisons"], nil, 3600, "PLAYER_AURA")
button2:SetFlyProtect()
button2:SetScrollable(spellList2)
--button2:RequireSpell(108211)


------------------------------------------------------------
-- Draenor Upgrade Passive, same spell but different buff
------------------------------------------------------------
-- MORTAL_WOUNDS
--AddDebuffGroup("DEADLY_POISON", 2823, 157584, 108211)