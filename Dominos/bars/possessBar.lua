--------------------------------------------------------------------------------
-- Possess bar
-- Handles the exit button for vehicles and taxis
--------------------------------------------------------------------------------

local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

--------------------------------------------------------------------------------
-- Button setup
--------------------------------------------------------------------------------

local function possessButton_OnEnter(self)
	if UnitOnTaxi("player") then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_SetTitle(GameTooltip, TAXI_CANCEL)
		GameTooltip:AddLine(TAXI_CANCEL_DESCRIPTION, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		GameTooltip:Show()
	elseif UnitControllingVehicle("player") and CanExitVehicle() then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip_SetTitle(GameTooltip, LEAVE_VEHICLE)
		GameTooltip:Show()
    else
        local id = self:GetID()
        if id == POSSESS_CANCEL_SLOT then
            GameTooltip:SetText(CANCEL)
        else
            GameTooltip:SetPossession(id)
        end
	end
end

local function getOrCreatePossessButton(id)
    local name = ('%sPossessButton%d'):format(AddonName, id)
    local button = _G[name]

    if not button then
        if PossessButtonMixin then
            button = CreateFrame("CheckButton", name, nil, "SmallActionButtonTemplate", id)
            Mixin(button, PossessButtonMixin)

            button:OnLoad()
            button:SetScript("OnClick", button.OnClick)
            button:SetScript("OnEnter", possessButton_OnEnter)
            button:SetScript("OnLeave", button.OnLeave)
        else
            button = CreateFrame("CheckButton", name, nil, "ActionButtonTemplate", id)
            button:SetSize(30, 30)
            button:SetScript("OnClick", PossessButton_OnClick)
            button:SetScript("OnEnter", possessButton_OnEnter)
            button:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end

        Addon.BindableButton:AddQuickBindingSupport(button)
    end

    return button
end

--------------------------------------------------------------------------------
-- Bar setup
--------------------------------------------------------------------------------

local PossessBar = Addon:CreateClass('Frame', Addon.ButtonBar)

function PossessBar:New()
    return PossessBar.proto.New(self, 'possess')
end

function PossessBar:GetDisplayName()
    return L.PossessBarDisplayName
end

-- disable UpdateDisplayConditions as we're not using showstates for this
function PossessBar:GetDisplayConditions()
    return '[canexitvehicle][possessbar]show;hide'
end

function PossessBar:GetDefaults()
    return {
        point = 'CENTER',
        x = 244,
        y = 0,
        spacing = 4,
        padW = 2,
        padH = 2
    }
end

function PossessBar:NumButtons()
    return 1
end

function PossessBar:AcquireButton()
    return getOrCreatePossessButton(POSSESS_CANCEL_SLOT)
end

function PossessBar:OnAttachButton(button)
    button:Show()
    button:UpdateHotkeys()

    Addon:GetModule('ButtonThemer'):Register(button, L.PossessBarDisplayName)
    Addon:GetModule('Tooltips'):Register(button)
end

function PossessBar:OnDetachButton(button)
    Addon:GetModule('ButtonThemer'):Unregister(button, L.PossessBarDisplayName)
    Addon:GetModule('Tooltips'):Unregister(button)
end

function PossessBar:Update()
    local button = self.buttons[1]
    local texture = (GetPossessInfo(button:GetID()))
    local icon = button.icon

    if UnitControllingVehicle("player") and CanExitVehicle() or not texture then
        icon:SetTexture([[Interface\Vehicles\UI-Vehicles-Button-Exit-Up]])
        icon:SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
    else
        icon:SetTexture(texture)
        icon:SetTexCoord(0, 1, 0, 1)
    end

    icon:SetVertexColor(1, 1, 1)
    icon:SetDesaturated(false)

    button:SetChecked(false)
    button:Enable()
end

-- export
Addon.PossessBar = PossessBar

--------------------------------------------------------------------------------
-- Module
--------------------------------------------------------------------------------

local PossessBarModule = Addon:NewModule('PossessBar', 'AceEvent-3.0')

function PossessBarModule:Load()
    if not self.loaded then
        self:BanishFrame(PossessBar)
        self:BanishFrame(PossessActionBar)
        self:BanishFrame(MainMenuBarVehicleLeaveButton)
        self.Update = Addon:Defer(self.Update, 0.01, self)

        self.loaded = true
    end

    self.bar = PossessBar:New()

	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "Update")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "Update")
	self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "Update")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Update")
    self:RegisterEvent("VEHICLE_UPDATE", "Update")

    if not Addon:IsBuild("classic") then
	    self:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR", "Update")
        self:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR", "Update")
        self:RegisterEvent("UPDATE_POSSESS_BAR", "Update")
        self:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR", "Update")
    end
end

function PossessBarModule:Unload()
    self:UnregisterAllEvents()

    if self.bar then
        self.bar:Free()
    end
end

function PossessBarModule:BanishFrame(frame)
    if frame then
        frame:UnregisterAllEvents()
        frame:SetParent(Addon.ShadowUIParent)
        frame:Hide()
    end
end

function PossessBarModule:Update()
    if self.bar then
        self.bar:Update()
    end
end
