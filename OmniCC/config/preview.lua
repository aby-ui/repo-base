local AddonName, Addon = ...
local OmniCC = _G.OmniCC
local L = LibStub("AceLocale-3.0"):GetLocale("OmniCC")
local DEFAULT_DURATION = 30

local function getRandomIcon()
    local icons = {}

    for i = 1, GetNumSpellTabs() do
        local offset, numSpells = select(3, GetSpellTabInfo(i))
        local tabEnd = offset + numSpells

        for j = offset, tabEnd - 1 do
            local texture = GetSpellBookItemTexture(j, "player")
            if texture then
                tinsert(icons, texture)
            end
        end
    end

    return icons[math.random(1, #icons)]
end

-- preview dialog
local PreviewDialog = CreateFrame("Frame", AddonName .. "PreviewDialog", InterfaceOptionsFrame, "UIPanelDialogTemplate")

PreviewDialog:Hide()
PreviewDialog:ClearAllPoints()
PreviewDialog:SetPoint("LEFT", InterfaceOptionsFrame, "RIGHT", 0, 0)
PreviewDialog:EnableMouse(true)
PreviewDialog:SetClampedToScreen(true)
PreviewDialog:SetFrameStrata("DIALOG")
PreviewDialog:SetMovable(true)
PreviewDialog:SetSize(165, 155)
PreviewDialog:SetToplevel(true)
PreviewDialog:SetScript(
    "OnShow",
    function(self)
        self.icon:SetTexture(getRandomIcon())
        self:StartCooldown(self.duration:GetValue())
    end
)

PreviewDialog:SetScript(
    "OnHide",
    function(self)
        if self:IsShown() then
            self:Hide()
        end

        self.cooldown:Clear()
    end
)

-- title region
local tr = CreateFrame("Frame", nil, PreviewDialog, "TitleDragAreaTemplate")
tr:SetAllPoints(PreviewDialog:GetName() .. "TitleBG")

-- title text
local text = PreviewDialog:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
text:SetPoint("CENTER", tr)
text:SetText(L.Preview)

-- container
local container = CreateFrame("Frame", nil, PreviewDialog)
container:SetPoint("TOPLEFT", 10, -27)
container:SetPoint("BOTTOMRIGHT", -7, 9)

-- contianer bg
local bg = container:CreateTexture(nil, "BACKGROUND")
bg:SetColorTexture(1, 1, 1, 0.3)
bg:SetAllPoints(container)

-- action icon
local icon = container:CreateTexture(nil, "ARTWORK")
icon:SetPoint("TOP", 0, -4)
icon:SetSize(ActionButton1:GetWidth() * 2, ActionButton1:GetHeight() * 2)
PreviewDialog.icon = icon

-- cooldown
local cooldown = CreateFrame("Cooldown", nil, container, "CooldownFrameTemplate")
cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL
cooldown:SetAllPoints(icon)
cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")
cooldown:SetSwipeColor(0, 0, 0)
cooldown:SetDrawEdge(false)
cooldown:SetScript(
    "OnCooldownDone",
    function(self)
        if PreviewDialog:IsVisible() then
            PreviewDialog:StartCooldown(PreviewDialog.duration:GetValue())
        end
    end
)

PreviewDialog.cooldown = cooldown

-- duration input
local editBoxText = container:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
editBoxText:SetText(L.Duration)
editBoxText:SetPoint("TOP", icon, "BOTTOM", 0, -2)

local editBox = CreateFrame('EditBox', "$parentDurationInput", container, "NumericInputSpinnerTemplate")
editBox:SetAutoFocus(false)
editBox:SetPoint("TOP", editBoxText, "BOTTOM", 4, -2)
editBox:SetWidth(container:GetWidth() - 54)
editBox:SetMinMaxValues(0, 9999999)
editBox:SetMaxLetters(7)
editBox:SetValue(DEFAULT_DURATION)
editBox:SetOnValueChangedCallback(function(self, value)
    PreviewDialog:StartCooldown(value or 0)
end)

PreviewDialog.duration = editBox

-- preview
function PreviewDialog:SetTheme(theme)
    self.cooldown._occ_settings_force = theme

    if OmniCC.Cooldown.UpdateSettings(self.cooldown) then
        local display = OmniCC.Display:Get(self.cooldown:GetParent())
        if display then
            display:UpdateCooldownText()
        end
    end

    self:Show()
end

function PreviewDialog:StartCooldown(duration)
    self.cooldown:SetCooldownDuration(tonumber(duration) or 0)
end

-- exports
Addon.PreviewDialog = PreviewDialog
