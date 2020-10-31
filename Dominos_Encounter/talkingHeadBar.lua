local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")

-- bar
local TalkingHeadBar = Dominos:CreateClass('Frame', Dominos.Frame)

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
        showInPetBattleUI = true,
        showInOverrideUI = true
    }
end

function TalkingHeadBar:Layout()
    local frame = TalkingHeadFrame
    local width, height

    if frame then
        frame:ClearAllPoints()
        frame:SetPoint('CENTER', self)
        frame:SetParent(self)

        width, height = frame:GetSize()
    else
        width, height = 570, 155
    end

    local pW, pH = self:GetPadding()
    self:SetSize(width + pW, height + pH)
end

function TalkingHeadBar:OnCreateMenu(menu)
    self:AddLayoutPanel(menu)
    menu:AddFadingPanel()
end

function TalkingHeadBar:AddLayoutPanel(menu)
    local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

    local panel = menu:NewPanel(l.Layout)

    panel.scaleSlider = panel:NewScaleSlider()
    panel.paddingSlider = panel:NewPaddingSlider()
end

-- module
local TalkingHeadBarModule = Dominos:NewModule('TalkingHeadBar', 'AceEvent-3.0')

function TalkingHeadBarModule:Load()
    self.frame = TalkingHeadBar:New()
    self:RegisterEvent("ADDON_LOADED")
end

function TalkingHeadBarModule:Unload()
    if self.frame then
        self.frame:Free()
    end
end

function TalkingHeadBarModule:ADDON_LOADED(event, addon)
    if addon == 'Blizzard_TalkingHeadUI' then
        self:UnregisterEvent(event)

        self:OnTalkingHeadUILoaded()
    end
end

function TalkingHeadBarModule:OnTalkingHeadUILoaded()
    TalkingHeadFrame.ignoreFramePositionManager = true

    -- onshow/hide call UpdateManagedFramePositions on the blizzard end so
    -- turn that bit off
    TalkingHeadFrame:SetScript("OnShow", nil)
    TalkingHeadFrame:SetScript("OnHide", nil)

    self.frame:Layout()
end