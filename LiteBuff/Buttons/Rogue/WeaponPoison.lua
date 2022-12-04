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

local button1 = addon:CreateActionButton("RoguePoison1", L["damage poisons"], nil, 3600, "PLAYER_AURA")
--button1.auraMap = { [GetSpellInfo(315584)] = GetSpellInfo(2823) } --之前似乎速效药膏的BUFFID和技能ID不同
button1:SetFlyProtect()
--button1:RequireSpell(315584) --有问题，2级技能名字不一样，技能书按名字来，但是IsSpellKnown用真实ID
--button1:SetScrollable(spellList1)

--伤害性毒药
local spellIDs1 = {
    315584, --通用: 速效药膏
    8679,   --通用: 致伤药膏
    2823,   --奇袭: 夺命药膏
    381664, --奇袭天赋倒数第四排: 增效药膏
}
function button1:OnSpellUpdate()
    wipe(spellList1)
    for _, id in ipairs(spellIDs1) do
        if IsSpellKnown(id) then
            addon:BuildSpellList(spellList1, id)
        end
        button1:SetScrollable(spellList1)
    end
end

local spellList2 = {}
local spellIDs2 = {
    3408, --减速药膏
    5761, 381637, ----迟钝药膏, 萎缩药膏 通用天赋第三排二选一
}

local button2 = addon:CreateActionButton("RoguePoison2", L["utility poisons"], nil, 3600, "PLAYER_AURA")
button2:SetFlyProtect()
--button2:RequireSpell(3408)
--button2:SetScrollable(spellList2)

function button2:OnSpellUpdate()
    wipe(spellList2)
    for _, id in ipairs(spellIDs2) do
        if IsSpellKnown(id) then
            addon:BuildSpellList(spellList2, id)
        end
        button2:SetScrollable(spellList2)
    end
end

------------------------------------------------------------
-- Draenor Upgrade Passive, same spell but different buff
------------------------------------------------------------
-- MORTAL_WOUNDS
--AddDebuffGroup("DEADLY_POISON", 2823, 157584, 108211)