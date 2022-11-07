local _, Cell = ...
local F = Cell.funcs

-- stolen from elvui
local hiddenParent = CreateFrame("Frame", nil, _G.UIParent)
hiddenParent:SetAllPoints()
hiddenParent:Hide()

local function HideFrame(frame)
    if not frame then return end
    
    frame:UnregisterAllEvents()
    frame:Hide()
    frame:SetParent(hiddenParent)

    local health = frame.healthBar or frame.healthbar
    if health then
        health:UnregisterAllEvents()
    end

    local power = frame.manabar
    if power then
        power:UnregisterAllEvents()
    end

    local spell = frame.castBar or frame.spellbar
    if spell then
        spell:UnregisterAllEvents()
    end

    local altpowerbar = frame.powerBarAlt
    if altpowerbar then
        altpowerbar:UnregisterAllEvents()
    end

    local buffFrame = frame.BuffFrame
    if buffFrame then
        buffFrame:UnregisterAllEvents()
    end

    local petFrame = frame.PetFrame
    if petFrame then
        petFrame:UnregisterAllEvents()
    end
end

function F:HideBlizzardParty()
    if Cell.isRetail then
        _G.PartyFrame:UnregisterAllEvents()
        for frame in _G.PartyFrame.PartyMemberFramePool:EnumerateActive() do
            HideFrame(frame)
        end
    else
        for i = 1, 4 do
            HideFrame(_G["PartyMemberFrame"..i])
            HideFrame(_G["CompactPartyMemberFrame"..i])
        end
    end
end

function F:HideBlizzardRaid()
    CompactRaidFrameManager_SetSetting("IsShown", "0")
    _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
    _G.CompactRaidFrameManager:UnregisterAllEvents()
    _G.CompactRaidFrameManager:SetParent(hiddenParent)
end