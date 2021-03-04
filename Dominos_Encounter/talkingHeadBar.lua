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

function TalkingHeadBar:GetDisplayName()
	return GetLocale():sub(1,2)=='zh' and '剧情对话' or 'Talking Heads'
end

function TalkingHeadBar:GetDisplayLevel()
    return 'LOW'
end

function TalkingHeadBar:Layout()
    local width, height

    if TalkingHeadFrame then
        self:RepositionTalkingHeadFrame()
        width, height = TalkingHeadFrame:GetSize()
    else
        width, height = 570, 155
    end

    local pW, pH = self:GetPadding()
    self:SetSize(width + pW, height + pH)
end

function TalkingHeadBar:RepositionTalkingHeadFrame()
    local frame = TalkingHeadFrame
    if frame then
        frame:ClearAllPoints()
        frame:SetPoint('CENTER', self)
        frame:SetParent(self)
        return true
    end
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

    panel.scaleSlider = panel:NewScaleSlider()
    panel.paddingSlider = panel:NewPaddingSlider()
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
    return self.sets.muteSounds or false
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

    -- OnShow/OnHide call UpdateManagedFramePositions on the blizzard end so
    -- turn that bit off
    TalkingHeadFrame:SetScript("OnShow", nil)
    TalkingHeadFrame:SetScript("OnHide", nil)

    hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
        if not self.frame:MuteSounds() then
            return
        end

        if TalkingHeadFrame.voHandle then
            StopSound(TalkingHeadFrame.voHandle, 0)
            TalkingHeadFrame.voHandle = nil
        end
    end)

    hooksecurefunc(AlertFrame, "UpdateAnchors", function()
        if self.frame then
            self.frame:RepositionTalkingHeadFrame()
        end
    end)

    if not InCombatLockdown() then
        self.frame:Layout()
    end
end
