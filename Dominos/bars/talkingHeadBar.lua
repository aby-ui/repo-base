--------------------------------------------------------------------------------
-- Talking Head Bar
-- Lets you move around the talking heads display
--------------------------------------------------------------------------------

local AddonName, Addon = ...

if not (TalkingHeadFrame and Addon:IsBuild("retail")) then
    return
end

local L = LibStub("AceLocale-3.0"):GetLocale(AddonName)

-- bar
local TalkingHeadBar = Addon:CreateClass('Frame', Addon.Frame)

function TalkingHeadBar:New()
    return TalkingHeadBar.proto.New(self, 'talk')
end

TalkingHeadBar:Extend(
    'OnAcquire', function(self)
    self:Layout()
end
)

function TalkingHeadBar:GetDefaults()
    return {
        point = 'BOTTOM',
        x = 0,
        y = 74,
        displayLayer = 'LOW',
        showInPetBattleUI = true,
        showInOverrideUI = true
    }
end

function TalkingHeadBar:GetDisplayName()
    return L.TalkingHeadBarDisplayName
end

function TalkingHeadBar:Layout()
    self:RepositionTalkingHeadFrame()
    local width, height = TalkingHeadFrame:GetSize()

    local pW, pH = self:GetPadding()
    self:SetSize(width + pW, height + pH)
end

function TalkingHeadBar:RepositionTalkingHeadFrame()
    TalkingHeadFrame:ClearAllPointsBase()
    TalkingHeadFrame:SetPointBase('CENTER', self)
    TalkingHeadFrame:SetParent(self)
end

function TalkingHeadBar:OnCreateMenu(menu)
    self:AddLayoutPanel(menu)
    menu:AddFadingPanel()
    menu:AddAdvancedPanel(true)
end

function TalkingHeadBar:AddLayoutPanel(menu)
    local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

    local panel = menu:NewPanel(l.Layout)

    panel.muteButton = panel:NewCheckButton
    {
        name = _G.MUTE,
        get = function() return panel.owner:MuteSounds() end,
        set = function(_, enable) panel.owner:SetMuteSounds(enable) end
    }

    panel:AddBasicLayoutOptions()

    return panel
end

function TalkingHeadBar:SetMuteSounds(enable)
    self.sets.muteSounds = (enable and true) or nil

    -- mute if currently playing
    if enable and TalkingHeadFrame and TalkingHeadFrame.voHandle then
        StopSound(TalkingHeadFrame.voHandle, 0)
        TalkingHeadFrame.voHandle = nil
    end
end

function TalkingHeadBar:MuteSounds()
    return self.sets.muteSounds and true
end

-- module
local TalkingHeadBarModule = Addon:NewModule('TalkingHeadBar')

function TalkingHeadBarModule:Load()
    self.frame = TalkingHeadBar:New()

    if not self.loaded then
        self:OnTalkingHeadUILoaded()
        self.loaded = true
    end
end

function TalkingHeadBarModule:Unload()
    if self.frame then
        self.frame:Free()
    end
end

function TalkingHeadBarModule:OnTalkingHeadUILoaded()
    TalkingHeadFrame.ignoreFramePositionManager = true

    -- OnShow/OnHide call UpdateManagedFramePositions on the blizzard end so
    -- turn that bit off
    TalkingHeadFrame:SetScript("OnShow", nil)
    TalkingHeadFrame:SetScript("OnHide", nil)

    hooksecurefunc(TalkingHeadFrame, 'PlayCurrent', function()
        if not self.frame:MuteSounds() then
            return
        end

        if TalkingHeadFrame.voHandle then
            StopSound(TalkingHeadFrame.voHandle, 0)
            TalkingHeadFrame.voHandle = nil
        end
    end)

    -- position workarounds
    hooksecurefunc(AlertFrame, 'UpdateAnchors', function()
        self:OnAlertFrameAnchorsUpdated()
    end)

    hooksecurefunc(TalkingHeadFrame, 'ApplySystemAnchor', function()
        self:OnAlertFrameAnchorsUpdated()
    end)
end

-- reposition the talking head frame when it moves
function TalkingHeadBarModule:OnAlertFrameAnchorsUpdated()
    if (not self.frame) then return end

    local _, relFrame = TalkingHeadFrame:GetPoint()

    if self.frame ~= relFrame then
        self.frame:RepositionTalkingHeadFrame()
    end
end
