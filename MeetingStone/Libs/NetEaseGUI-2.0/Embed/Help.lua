
local GUI = LibStub('NetEaseGUI-2.0')
local Help = GUI:NewEmbed('Help', 4)
if not Help then
    return
end
---- Help

local function HelpOnClick(self)
    local enable = self.helpPlate and not HelpPlate_IsShowing(self.helpPlate)
    if enable then
        HelpPlate_Show(self.helpPlate, self:GetParent(), self, true)
    else
        HelpPlate_Hide(true)
    end
    if type(self.callback) == 'function' then
        self.callback(enable)
    end
end

local function HelpOnHide()
    HelpPlate_Hide()
end

local function HelpOnShow(self)
    local parent = self:GetParent()
    repeat
        if parent.PortraitFrame then
            return self:SetFrameLevel(parent.PortraitFrame:GetFrameLevel()+1)
        end
        parent = parent:GetParent()
    until not parent
end

function Help:AddHelpButton(parent, helpPlate, callback, anchor)
    local HelpButton = CreateFrame('Button', nil, parent, 'MainHelpPlateButton')
    
    HelpButton.helpPlate = helpPlate
    HelpButton:SetPoint('TOPLEFT', anchor or self, 'TOPLEFT', 39, 20)
    HelpButton:SetScript('OnClick', HelpOnClick)
    HelpButton:SetScript('OnHide', HelpOnHide)
    HelpButton:SetScript('OnShow', HelpOnShow)
    HelpButton.callback = callback

    self.helpButtons[parent] = HelpButton

    return HelpButton
end

function Help:HideHelpButtons()
    for _, button in pairs(self.helpButtons) do
        button:Hide()
    end
    HelpPlate_Hide()
end

function Help:ShowHelpButtons()
    for _, button in pairs(self.helpButtons) do
        button:Show()
    end
end

function Help:ShowHelpPlate(parent)
    local HelpButton = self.helpButtons[parent]
    if HelpButton then
        if not HelpPlate_IsShowing(HelpButton.helpPlate) then
            HelpButton:Click()
        end
    end
end

function Help:OnEmbed(target)
    target.helpButtons = {}
end