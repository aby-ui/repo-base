local ExtraAbilityContainer = _G.ExtraAbilityContainer
if not ExtraAbilityContainer then
    return
end

local _, Addon = ...
local BAR_ID = 'extra'

local ExtraAbilityBar = Addon:CreateClass('Frame', Addon.Frame)

function ExtraAbilityBar:New()
    local bar = ExtraAbilityBar.proto.New(self, BAR_ID)

    -- drop need for showstates for this case
    if bar:GetShowStates() == '[extrabar]show;hide' then
        bar:SetShowStates(nil)
    end

    return bar
end

ExtraAbilityBar:Extend(
    'OnAcquire', function(self)
        local container = ExtraAbilityContainer

        container:ClearAllPoints()
        container:SetPoint('CENTER', self)
        container:SetParent(self)

        self.container = container

        self:Layout()
        self:UpdateShowBlizzardTexture()
    end
)

function ExtraAbilityBar:ThemeBar(enable)
    if HasExtraActionBar() then
        local button = ExtraActionBarFrame and ExtraActionBarFrame.button
        if button then
            if enable then
                Addon:GetModule('ButtonThemer'):Register(button, 'Extra Bar')
            else
                Addon:GetModule('ButtonThemer'):Unregister(button, 'Extra Bar')
            end
        end
    end

    local zoneAbilities = C_ZoneAbility.GetActiveAbilities()

    if #zoneAbilities > 0 then
        local container = ZoneAbilityFrame and ZoneAbilityFrame.SpellButtonContainer
        for button in container:EnumerateActive() do
            if button then
                if enable then
                    Addon:GetModule('ButtonThemer'):Register(
                        button, 'Extra Bar', {Icon = button.Icon}
                    )
                else
                    Addon:GetModule('ButtonThemer'):Unregister(
                        button, 'Extra Bar'
                    )
                end
            end
        end
    end
end

function ExtraAbilityBar:GetDefaults()
    return {
        point = 'CENTER',
        x = 0,
        y = -244,
        showInPetBattleUI = true,
        showInOverrideUI = true
    }
end

function ExtraAbilityBar:Layout()
    local w, h = 256, 120
    local pW, pH = self:GetPadding()

    self:SetSize(w + pW, h + pH)
end

function ExtraAbilityBar:OnCreateMenu(menu)
    self:AddLayoutPanel(menu)

    menu:AddFadingPanel()
end

function ExtraAbilityBar:AddLayoutPanel(menu)
    local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

    local panel = menu:NewPanel(l.Layout)

    panel:NewCheckButton{
        name = l.ExtraBarShowBlizzardTexture,
        get = function()
            return panel.owner:ShowingBlizzardTexture()
        end,
        set = function(_, enable)
            panel.owner:ShowBlizzardTexture(enable)
        end
    }

    panel.scaleSlider = panel:NewScaleSlider()
    panel.paddingSlider = panel:NewPaddingSlider()
end

function ExtraAbilityBar:ShowBlizzardTexture(show)
    self.sets.hideBlizzardTeture = not show

    self:UpdateShowBlizzardTexture()
end

function ExtraAbilityBar:ShowingBlizzardTexture()
    return not self.sets.hideBlizzardTeture
end

function ExtraAbilityBar:UpdateShowBlizzardTexture()
    if self:ShowingBlizzardTexture() then
        ExtraActionBarFrame.button.style:Show()
        ZoneAbilityFrame.Style:Show()

        self:ThemeBar(false)
    else
        ExtraActionBarFrame.button.style:Hide()
        ZoneAbilityFrame.Style:Hide()

        self:ThemeBar(true)
    end
end

local ExtraAbilityBarModule = Addon:NewModule('ExtraAbilityBar', 'AceEvent-3.0')

function ExtraAbilityBarModule:Load()
    if not self.initialized then
        self.initialized = true

        -- disable mouse interactions on the extra action bar
        -- as it can sometimes block the UI from being interactive
        if ExtraActionBarFrame:IsMouseEnabled() then
            ExtraActionBarFrame:EnableMouse(false)
        end

        -- prevent the stock UI from messing with the extra ability bar position
        ExtraAbilityContainer.ignoreFramePositionManager = true

        -- watch for new frames to be added to the container as we will want to
        -- possibly theme them later (if they're new buttons)
        hooksecurefunc(
            ExtraAbilityContainer, 'AddFrame', function()
                if self.frame then
                    self.frame:ThemeBar(not self.frame:ShowingBlizzardTexture())
                end
            end
        )

        Addon.BindableButton:AddQuickBindingSupport(_G.ExtraActionButton1)
    end

    self.frame = ExtraAbilityBar:New()
end

function ExtraAbilityBarModule:Unload()
    if self.frame then
        self.frame:Free()
    end
end
