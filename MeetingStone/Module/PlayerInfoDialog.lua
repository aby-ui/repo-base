
BuildEnv(...)

PlayerInfoDialog = GUI:GetClass('TitlePanel'):New(UIParent) do
    GUI:Embed(PlayerInfoDialog, 'Tab')
    PlayerInfoDialog:Hide()
    PlayerInfoDialog:SetSize(400, 250)
    PlayerInfoDialog:SetFrameStrata('DIALOG')
    PlayerInfoDialog:SetText(L['联系方式'])
    PlayerInfoDialog:SetScript('OnHide', StaticPopupSpecial_Hide)
end

local InfoParent = CreateFrame('Frame', nil, PlayerInfoDialog) do
    InfoParent:SetPoint('TOPLEFT', 30, -45)
    InfoParent:SetPoint('TOPRIGHT', -30, -45)
    InfoParent:SetHeight(140)
    InfoParent:Hide()
end

local AccountInput = GUI:GetClass('InputBox'):New(InfoParent) do
    AccountInput:SetPoint('TOPLEFT', 100, 0)
    AccountInput:SetSize(200, 15)
    AccountInput:SetMaxLetters(128)
    AccountInput:SetLabel(L['战网帐号'])
    PlayerInfoDialog:RegisterInputBox(AccountInput)
end

local AddressInput = GUI:GetClass('InputBox'):New(InfoParent) do
    AddressInput:SetPoint('TOPLEFT', AccountInput, 'BOTTOMLEFT', 0, -15)
    AddressInput:SetSize(200, 15)
    AddressInput:SetMaxLetters(256)
    AddressInput:SetLabel(L['联系地址'])
    PlayerInfoDialog:RegisterInputBox(AddressInput)
end

local ContactInput = GUI:GetClass('InputBox'):New(InfoParent) do
    ContactInput:SetPoint('TOPLEFT', AddressInput, 'BOTTOMLEFT', 0, -15)
    ContactInput:SetSize(200, 15)
    ContactInput:SetMaxLetters(18)
    ContactInput:SetLabel(L['联系人'])
    PlayerInfoDialog:RegisterInputBox(ContactInput)
end

local TelInput = GUI:GetClass('InputBox'):New(InfoParent) do
    TelInput:SetPoint('TOPLEFT', ContactInput, 'BOTTOMLEFT', 0, -15)
    TelInput:SetSize(200, 15)
    TelInput:SetMaxLetters(18)
    TelInput:SetNumeric(true)
    TelInput:SetLabel(L['联系电话'])
    PlayerInfoDialog:RegisterInputBox(TelInput)
end

local ErrorInfo = InfoParent:CreateFontString(nil, 'ARTWORK', 'GameFontRedSmall') do
    ErrorInfo:SetPoint('BOTTOM', 0, 10)
    ErrorInfo:SetPoint('LEFT')
    ErrorInfo:SetPoint('RIGHT')
end

local Line = InfoParent:CreateTexture(nil, 'OVERLAY') do
    Line:SetPoint('BOTTOMLEFT')
    Line:SetPoint('BOTTOMRIGHT')
    Line:SetHeight(1)
    Line:SetColorTexture(1, 1, 1, 0.6)
end

local Summary = PlayerInfoDialog:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmallLeft') do
    Summary:SetPoint('BOTTOM', 0, 55)
    Summary:SetPoint('LEFT', 50, 0)
    Summary:SetPoint('RIGHT', -50, 0)
    Summary:SetWordWrap(true)
    Summary:SetText('要写点什么要写点什么，文案跑哪里去了？要写点什么要写点什么，文案跑哪里去了？哪里去了？')
end

local AcceptButton = CreateFrame('Button', nil, PlayerInfoDialog, 'UIPanelButtonTemplate') do
    AcceptButton:SetPoint('BOTTOMRIGHT', PlayerInfoDialog, 'BOTTOM', 0, 20)
    AcceptButton:SetSize(120, 22)
    AcceptButton:SetText(OKAY)
    AcceptButton:SetScript('OnClick', function(self)
        if InfoParent:IsShown() then
            Activities:SetPersonInfo(ContactInput:GetText(), TelInput:GetText(), AccountInput:GetText(), AddressInput:GetText())
            HideParentPanelAby(self)
        else
            if PlayerInfoDialog.foldText then
                Summary:SetText(PlayerInfoDialog.foldText)
            end
            InfoParent:Show()
        end
    end)
end

local CancelButton = CreateFrame('Button', nil, PlayerInfoDialog, 'UIPanelButtonTemplate') do
    CancelButton:SetPoint('BOTTOMLEFT', PlayerInfoDialog, 'BOTTOM', 0, 20)
    CancelButton:SetSize(120, 22)
    CancelButton:SetText(CANCEL)
    CancelButton:SetScript('OnClick', HideParentPanelAby)
end

local Filters = {
    { key = 'Account', object = AccountInput },
    { key = 'Address', object = AddressInput },
    { key = 'Contact', object = ContactInput },
    { key = 'Tel', object = TelInput },
}

local function OnTextChanged()
    PlayerInfoDialog:UpdateButton()
end

AccountInput:SetScript('OnTextChanged', OnTextChanged)
AddressInput:SetScript('OnTextChanged', OnTextChanged)
ContactInput:SetScript('OnTextChanged', OnTextChanged)
TelInput:SetScript('OnTextChanged', OnTextChanged)
InfoParent:SetScript('OnShow', function()
    PlayerInfoDialog:UpdateInput()
    PlayerInfoDialog:UpdateButton()
    PlayerInfoDialog:UpdateHeight()
end)
InfoParent:SetScript('OnHide', function()
    PlayerInfoDialog:UpdateButton()
    PlayerInfoDialog:UpdateHeight()
end)

function PlayerInfoDialog:CheckInput()
    if not InfoParent:IsShown() then
        return
    end
    if AccountInput:IsVisible() then
        local email = AccountInput:GetText():trim()
        if email == '' then
            return L['战网帐号不能为空']
        end
        if not email:match('^.+@.+%..+$') then
            return L['战网帐号格式不正确']
        end
    end

    if AddressInput:IsVisible() then
        local address = AddressInput:GetText():trim()
        if address == '' then
            return L['收货地址不能为空']
        end
    end
    
    if ContactInput:IsVisible() then
        local contact = ContactInput:GetText():trim()
        if contact == '' then
            return L['联系人不能为空']
        end
    end

    if TelInput:IsVisible() then
        local tel = TelInput:GetText():trim()
        if tel == '' then
            return L['联系电话不能为空']
        end
    end
end

function PlayerInfoDialog:UpdateHeight()
    local height = 100 + Summary:GetHeight()

    Summary:SetJustifyH(height > 150 and 'LEFT' or 'MIDDLE')

    if InfoParent:IsShown() then
        height = height + InfoParent:GetHeight() + 10   
    end

    self:SetHeight(height)
end

function PlayerInfoDialog:UpdateInput()
    local contact, tel, email, address = Activities:GetPersonInfo()

    self.email = email
    self.contact = contact
    self.tel = tel
    self.address = address

    AccountInput:SetText(email)
    AddressInput:SetText(address)
    ContactInput:SetText(contact)
    TelInput:SetText(tel)
end

function PlayerInfoDialog:UpdateButton()
    AcceptButton:SetText(InfoParent:IsShown() and OKAY or self.acceptText or L['完善联系方式'])

    local err = self:CheckInput()
    AcceptButton:SetEnabled(not err)
    ErrorInfo:SetText(err or '')
end

function PlayerInfoDialog:UpdateFilter()
    local filters = {} do
        if self.filters then
            for key in self.filters:gmatch('[^,]+') do
                filters[key] = true
            end
        end
    end

    local count = 0
    local prevObject
    for _, v in ipairs(Filters) do
        if not filters[v.key] then
            v.object:Show()
            if not prevObject then
                v.object:SetPoint('TOPLEFT', 100, 0)
            else
                v.object:SetPoint('TOPLEFT', prevObject, 'BOTTOMLEFT', 0, -15)
            end
            prevObject = v.object
            count = count + 1
        else
            v.object:Hide()
        end
    end

    InfoParent:SetHeight(count * 30 + 20)
end

PlayerInfoDialog:SetScript('OnShow', function(self)
    self:UpdateFilter()
    self:UpdateButton()
    self:UpdateHeight()
end)

function PlayerInfoDialog:Open(text, title, fold, noCancel, filters, acceptText)
    self.filters = filters
    self.acceptText = acceptText
    self.noCancel = noCancel
    self.foldText = fold
    self:SetText(title)
    Summary:SetText(text)
    CancelButton:SetEnabled(not noCancel)
    self.CloseButton:SetShown(not noCancel)
    InfoParent:SetShown(not fold)
    StaticPopupSpecial_Show(self)
end