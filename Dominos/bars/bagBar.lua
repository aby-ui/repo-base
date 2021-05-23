--------------------------------------------------------------------------------
--	Bag Bar - A bar for holding bag buttons
--------------------------------------------------------------------------------

local AddonName, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(AddonName)

-- register buttons for use later
local BagButtons = {}

local BagBar = Addon:CreateClass('Frame', Addon.ButtonBar)

function BagBar:New()
    return BagBar.proto.New(self, 'bags')
end

function BagBar:GetDisplayName()
    return L.BagBarDisplayName
end

function BagBar:GetDefaults()
    return {
        displayLayer = 'LOW',
        point = 'BOTTOMRIGHT',
        oneBag = false,
        keyRing = true,
        spacing = 2
    }
end

function BagBar:SetShowBags(enable)
    self.sets.oneBag = not enable
    self:ReloadButtons()
end

function BagBar:ShowBags()
    return not self.sets.oneBag
end

function BagBar:SetShowKeyRing(enable)
    self.sets.keyRing = enable or false
    self:ReloadButtons()
end

function BagBar:ShowKeyRing()
    if Addon:IsBuild('bcc', 'classic') then
        return self.sets.keyRing
    end
end

-- Frame Overrides
function BagBar:AcquireButton(index)
    if index < 1 then
        return nil
    end

    local keyRingIndex = self:ShowKeyRing() and 1 or 0

    local backpackIndex
    if self:ShowBags() then
        backpackIndex = keyRingIndex + NUM_BAG_SLOTS + 1
    else
        backpackIndex = keyRingIndex + 1
    end

    if index == keyRingIndex then
        return _G[AddonName .. 'KeyRingButton']
    elseif index == backpackIndex then
        return MainMenuBarBackpackButton
    elseif index > keyRingIndex and index < backpackIndex then
        return _G[('CharacterBag%dSlot'):format(NUM_BAG_SLOTS - (index - keyRingIndex))]
    end
end

function BagBar:NumButtons()
    local count = 1

    if self:ShowKeyRing() then
        count = count + 1
    end

    if self:ShowBags() then
        count = count + NUM_BAG_SLOTS
    end

    return count
end

function BagBar:OnCreateMenu(menu)
    local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

    local layoutPanel = menu:NewPanel(L.Layout)

    layoutPanel:NewCheckButton {
        name = L.BagBarShowBags,
        get = function()
            return layoutPanel.owner:ShowBags()
        end,
        set = function(_, enable)
            layoutPanel.owner:SetShowBags(enable)
            layoutPanel.colsSlider:UpdateRange()
            layoutPanel.colsSlider:UpdateValue()
        end
    }

    if Addon:IsBuild('bcc', 'classic') then
        layoutPanel:NewCheckButton {
            name = L.BagBarShowKeyRing,
            get = function()
                return layoutPanel.owner:ShowKeyRing()
            end,
            set = function(_, enable)
                layoutPanel.owner:SetShowKeyRing(enable)
                layoutPanel.colsSlider:UpdateRange()
                layoutPanel.colsSlider:UpdateValue()
            end
        }
    end

    layoutPanel:AddLayoutOptions()

    menu:AddFadingPanel()
    menu:AddAdvancedPanel()
end

--------------------------------------------------------------------------------
--	module
--------------------------------------------------------------------------------

local BagBarModule = Addon:NewModule('BagBar')

function BagBarModule:OnInitialize()
    for slot = (NUM_BAG_SLOTS - 1), 0, -1 do
        self:RegisterButton(('CharacterBag%dSlot'):format(slot))
    end

    if Addon:IsBuild('bcc', 'classic') then
        -- force hide the old keyring button
        KeyRingButton:Hide()

        hooksecurefunc(
            'MainMenuBar_UpdateKeyRing',
            function()
                KeyRingButton:Hide()
            end
        )

        -- setup the dominos specific one
        local keyring = CreateFrame('CheckButton', AddonName .. 'KeyRingButton', UIParent, 'ItemButtonTemplate')
        keyring:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
        keyring:SetID(KEYRING_CONTAINER)

        keyring:SetScript(
            'OnClick',
            function(_, button)
                if CursorHasItem() then
                    PutKeyInKeyRing()
                else
                    ToggleBag(KEYRING_CONTAINER)
                end
            end
        )

        keyring:SetScript(
            'OnReceiveDrag',
            function(_)
                if CursorHasItem() then
                    PutKeyInKeyRing()
                end
            end
        )

        keyring:SetScript(
            'OnEnter',
            function(self)
                GameTooltip:SetOwner(self, 'ANCHOR_LEFT')

                local color = HIGHLIGHT_FONT_COLOR
                GameTooltip:SetText(KEYRING, color.r, color.g, color.b)
                GameTooltip:AddLine()
            end
        )

        keyring:SetScript(
            'OnLeave',
            function()
                GameTooltip:Hide()
            end
        )

        keyring.icon:SetTexture([[Interface\Icons\INV_Misc_Bag_16]])

        self:RegisterButton(keyring:GetName())

        MainMenuBarBackpackButton:HookScript(
            'OnClick',
            function(_, button)
                if IsControlKeyDown() then
                    ToggleBag(KEYRING_CONTAINER)
                end
            end
        )
    end

    self:RegisterButton('MainMenuBarBackpackButton')
end

function BagBarModule:OnEnable()
    for _, button in pairs(BagButtons) do
        Addon:GetModule('ButtonThemer'):Register(
            button,
            'Bag Bar',
            {
                Icon = button.icon
            }
        )
    end
end

function BagBarModule:Load()
    self.frame = BagBar:New()
end

function BagBarModule:Unload()
    if self.frame then
        self.frame:Free()
        self.frame = nil
    end
end

local function resize(o, size)
    o:SetSize(size, size)
end

function BagBarModule:RegisterButton(name)
    local button = _G[name]
    if not button then
        return
    end

    button:Hide()

    if Addon:IsBuild('retail') then
        resize(button, 36)
        resize(button.IconBorder, 37)
        resize(button.IconOverlay, 37)
        resize(_G[button:GetName() .. 'NormalTexture'], 64)
    end

    tinsert(BagButtons, button)
end
