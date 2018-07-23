
if select(2, UnitClass("player")) ~= "MAGE" then return end

local _, addon = ...
local L = addon.L

local spellFOTele = {
    1, -- Horde
    8, -- Alliance
}

local spellFOPortal = {
    11, -- Horde
    12, -- Alliance
}

local spellTele = {
    176242,
    176248,
}

local spellPortal = {
    176244,
    176246,
}

local button = addon:CreateActionButton('MagePortal', '传送门', nil, nil, 'DUAL')

-- button:SetScrollable(spellList, 'spell1', [[
local _scrollSnippet = [[
    local spell2 = self:GetAttribute('spell2List'..index)
    self:SetAttribute('spell2', spell2)
    self:CallMethod('SetSpell2', spell2)
]]

button:SetFlyProtect()
local spellList = {}
local spellList2 = {}

local buildList = function(splist, fot, spt)
    for _, id in next, fot do
        local name, desc, numSlots, isKnown = GetFlyoutInfo(id)
        if(isKnown) then
            for slot = 1, numSlots do
                local spellID, overrideSpellID, isKnown, spellName, slotSpecID = GetFlyoutSlotInfo(id, slot)
                --print(GetSpellInfo(spellID))
                if(isKnown) then
                    addon:BuildSpellList(splist, spellID)
                end
            end
        end
    end
    for _, id in next, spt do
        -- local name = GetSpellInfo(id)
        local isKnown = IsSpellKnown(id)
        if(isKnown) then
            addon:BuildSpellList(splist, id)
        end
    end
end

local update = function()
    wipe(spellList)
    wipe(spellList2)

    buildList(spellList, spellFOTele, spellTele)
    buildList(spellList2, spellFOPortal, spellPortal)


    if(#spellList > 0) then
        for count, tbl in next, spellList2 do
            button:SetAttribute('spell2List'..count, tbl.spell)
        end
        -- local name, desc, numSlots, isKnown = GetFlyoutInfo(spellFOPortal)
        -- if(isKnown) then
        --     local count = 0
        --     for slot = 1, numSlots do
        --         local spellID, overrideSpellID, isKnown, spellName, slotSpecID = GetFlyoutSlotInfo(spellFOPortal, slot)
        --         if(isKnown) then
        --             count = count + 1
        --             button:SetAttribute('spell2List'..count, spellName)
        --         end
        --     end
        -- end

        if(not button:IsShown()) then button:Show() end
        button:SetScrollable(spellList, 'spell1', _scrollSnippet)
        button.spellList2 = spellList2
        button:__163_UpdateButton()
        button:__UpdateScrollAttr_163()
        button:InvokeMethod'OnTalentSwitch'
    else
        if(button:IsShown()) then button:Hide() end
    end
end

addon:__163_OnSpellChanged(update)

