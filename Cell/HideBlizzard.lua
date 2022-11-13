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
    _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

    if _G.CompactPartyFrame then
        _G.CompactPartyFrame:UnregisterAllEvents()
    end

    if _G.PartyFrame then
        _G.PartyFrame:UnregisterAllEvents()
        _G.PartyFrame:SetScript('OnShow', nil)
        for frame in _G.PartyFrame.PartyMemberFramePool:EnumerateActive() do
            HideFrame(frame)
        end
        HideFrame(_G.PartyFrame)
    else
        for i = 1, 4 do
            HideFrame(_G["PartyMemberFrame"..i])
            HideFrame(_G["CompactPartyMemberFrame"..i])
        end
        HideFrame(_G.PartyMemberBackground)
    end
end

function F:HideBlizzardRaid()
    _G.UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

    if _G.CompactRaidFrameContainer then
        _G.CompactRaidFrameContainer:UnregisterAllEvents()
    end
    
    if CompactRaidFrameManager_SetSetting then
        CompactRaidFrameManager_SetSetting("IsShown", "0")
    end

    if _G.CompactRaidFrameManager then
        _G.CompactRaidFrameManager:UnregisterAllEvents()
        _G.CompactRaidFrameManager:SetParent(hiddenParent)
    end
end