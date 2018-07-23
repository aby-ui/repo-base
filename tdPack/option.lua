
local tdPack = tdCore(...)
local L = tdPack:GetLocale()

local GUI = tdCore('GUI')

local ItemDialog = GUI:NewModule('ItemDialog', GUI('Dialog'):New())

local function ItemInfoOnClick(self)
    self:GetParent():LoadCursor()
end

function ItemDialog:New(parent)
    local obj = self:Bind(GUI('Dialog'):New(UIParent))
    obj:SetWidth(400)
    obj:Hide()
    obj:HookScript('OnShow', self.OnShow)
    
    local tabWidget = GUI('TabWidget'):New(obj)
    tabWidget:SetPoint('TOPLEFT', 10, -26)
    tabWidget:SetPoint('TOPRIGHT', -64, -26)
    tabWidget:SetHeight(85)
    
    local idWidget = GUI('Widget'):New(tabWidget)
    idWidget:Into()
    idWidget:SetLabelText(L['By id'])
    idWidget:GetValueFontString():SetPoint('TOPLEFT', 20, -20)
    
    local typeWidget = GUI('Widget'):New(tabWidget)
    typeWidget:Into()
    typeWidget:SetLabelText(L['By type'])
    
    local typeCheckBox = GUI('CheckBox'):New(typeWidget)
    typeCheckBox:SetLabelText(L['Type'])
    typeCheckBox:Into(0, -8, 0)
    
    local subtypeCheckBox = GUI('CheckBox'):New(typeWidget)
    subtypeCheckBox:SetLabelText(L['Sub type'])
    subtypeCheckBox:Into(0, -8, 130)
    
    local inputWidget = GUI('Widget'):New(tabWidget)
    inputWidget:Into()
    inputWidget:SetLabelText(L['By input'])
    
    local lineEdit = GUI('LineEdit'):New(inputWidget)
    lineEdit:SetLabelText(L['Please input rule:'])
    lineEdit:Into()
    
    local itemInfo = GUI('Button'):New(obj)
    itemInfo:SetBackdrop{
        bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        edgeSize = 14, tileSize = 20, tile = true,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    }
    itemInfo:SetBackdropColor(0, 0, 0, 0.4)
    itemInfo:SetBackdropBorderColor(1, 1, 1, 1)

    itemInfo:SetNormalFontObject('GameFontHighlightSmall')
    itemInfo:SetHighlightTexture([[Interface\TokenFrame\UI-TokenFrame-CategoryButton]])
    itemInfo:GetHighlightTexture():SetTexCoord(0, 1, 0.609375, 0.796875)
    itemInfo:GetHighlightTexture():SetAlpha(0.5)
    itemInfo:GetHighlightTexture():SetPoint('TOPLEFT', 3, -3)
    itemInfo:GetHighlightTexture():SetPoint('BOTTOMRIGHT', -3, 3)
    itemInfo:SetNormalTexture(nil)
    itemInfo:SetPushedTexture(nil)

    itemInfo:GetLabelFontString():SetPoint('LEFT', 10, 0)
    itemInfo:SetFontString(itemInfo:GetLabelFontString())
    itemInfo:SetPoint('BOTTOMLEFT', 10, 36)
    itemInfo:SetPoint('BOTTOMRIGHT', -64, 36)
    itemInfo:SetHeight(36)
    
    itemInfo:SetScript('OnClick', ItemInfoOnClick)
    itemInfo:SetScript('OnReceiveDrag', ItemInfoOnClick)
    
    obj.tabWidget = tabWidget
    obj.lineEdit = lineEdit
    obj.typeCheckBox = typeCheckBox
    obj.subtypeCheckBox = subtypeCheckBox
    obj.itemInfo = itemInfo
    obj.idWidget = idWidget
    
    return obj
end

function ItemDialog:OnShow()
    self.itemID = nil
    self.itemType = nil
    self.itemSubType = nil
    self.itemInfo:SetLabelText([[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t ]] .. L['|cff00ff00Drag item to here|r'])
    self.typeCheckBox:SetLabelText(L['Type'])
    self.subtypeCheckBox:SetLabelText(L['Sub type'])
    self.idWidget:SetValueText('')
    self.lineEdit:SetText('')
    self.typeCheckBox:SetChecked(true)
    self.subtypeCheckBox:SetChecked(true)
    
    self:LoadCursor()
end

function ItemDialog:GetShowHeight()
    return 185
end

function ItemDialog:LoadCursor()
    local type, _, link = GetCursorInfo()
    if type == 'item' then
        ClearCursor()
        self:SetItem(tdPack:GetItemID(link))
    end
end

function ItemDialog:SetItem(itemID)
    local itemName, itemType, itemSubType, _, itemQuality, _, itemTexture = tdPack:GetItemInfo(itemID)
    
    local r, g, b = GetItemQualityColor(itemQuality)
    
    self.itemID = itemID
    self.itemType = itemType
    self.itemSubType = itemSubType
    
    self.itemInfo:SetFormattedText('|T%s:24|t |cff%02x%02x%02x%s|r', itemTexture, r * 0xff, g * 0xff, b * 0xff, itemName)
    self.typeCheckBox:SetFormattedText('%s - %s', L['Type'], itemType)
    self.subtypeCheckBox:SetFormattedText('%s - %s', L['Sub type'], itemSubType)
    self.idWidget:SetValueText('ID: ' .. itemID)
end

function ItemDialog:GetResultValue()
    local addidx = self.tabWidget:GetSelectedIndex()
    if not self.itemID and addidx ~= 3 then
        return
    end
    if addidx == 1 then
        return self.itemID
    elseif addidx == 2 then
        return (self.typeCheckBox:GetChecked() and '#' .. self.itemType or '') ..
               (self.subtypeCheckBox:GetChecked() and '##' .. self.itemSubType or '')
    elseif addidx == 3 then
        local value = self.lineEdit:GetText()
        return value:trim() ~= '' and value or nil 
    end
end

local function OnAdd(self)
    self:ShowDialog(
        'ItemDialog',
        self:GetLabelText() .. ' - ' .. L['Add rule'],
        function (dlg, rule)
            if not rule then
                self:ShowDialog('Dialog', L['Add fail'])
                return
            end
            self:GetItemList():InsertItem(rule)
            self:SetProfileValue(self:GetItemList())
            self:Refresh()
        end)
end

local function ImportFromJPack()
    if not IsAddOnLoaded('JPack') then
        GUI:ShowDialog(tdPack, 'Dialog', L['%s not loaded.']:format('JPack'), GUI.DialogIcon.Critical)
        return
    end
    
    GUI:ShowDialog(
        tdPack,
        'Dialog',
        L['Import %s rules will |cffff0000clear the current rules|r and |cffff0000reload addons|r, continue?']:format('JPack'),
        GUI.DialogIcon.Question,
        function()
            tdPack:GetProfile().Orders.CustomOrder = JPACK_ORDER
            tdPack:GetProfile().SaveToBank = JPACK_DEPOSIT
            tdPack:GetProfile().LoadFromBank = JPACK_DRAW
            ReloadUI()
        end
    )
end

function tdPack:LoadOption()
    self:InitOption({
        type = 'TabWidget',
        {
            type = 'Widget', label = GENERAL,
            {
                type = 'CheckBox', label = L['Pack desc on default'],
                profile = {self:GetName(), 'desc'},
            },
            {
                type = 'CheckBox', label = L['Save to bank on default'],
                profile = {self:GetName(), 'savetobank'},
            },
            {
                type = 'CheckBox', label = L['Load to bag on default'],
                profile = {self:GetName(), 'loadtobag'},
            },
            {
                type = 'CheckBox', label = L['Show tdPack message'], name = 'ShowMessageToggle',
                profile = {self:GetName(), 'showmessage'},
            },
            {
                type = 'ComboBox', label = L['Message frame'],
                profile = {self:GetName(), 'messageframe'}, depend = 'ShowMessageToggle',
                itemList = {
                    { value = 1, text = L['Show message in chat frame']},
                    { value = 2, text = L['Show message in error frame']}
                }
            },
            {
                type = 'ComboBox', label = L['Import rules from other addon'] .. [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t]],
                itemList = {
                    {text = L['Import rules from |cffffffff%s|r']:format('JPack'), onClick = ImportFromJPack},
                }
            },
        },
        {
            type = 'ListWidget', label = L['Custom order'], itemObject = tdCore('GUI')('ListWidgetLinkItem'),
            verticalArgs = {-1, 0, 0, 0}, allowOrder = true,
            selectMode = 'MULTI', extraButtons = {GUI.ListButton.Add, GUI.ListButton.Delete, GUI.ListButton.SelectAll, GUI.ListButton.SelectNone},
            profile = {self:GetName(), 'Orders', 'CustomOrder'},
            scripts = {
                OnAdd = OnAdd,
            },
        },
        {
            type = 'ListWidget', label = L['EquipLoc order'], itemObject = tdCore('GUI')('ListWidgetLinkItem'),
            verticalArgs = {-1, 0, 0, 0}, allowOrder = true, selectMode = 'NONE',
            profile = {self:GetName(), 'Orders', 'EquipLocOrder'},
            listObject = GUI('List'):New({GetText = function(self, index)
                return _G[self:GetValue(index)] .. ' - ' .. self:GetValue(index)
            end})
        },
        {
            type = 'ListWidget', label = L['Save to bank rule'], itemObject = tdCore('GUI')('ListWidgetLinkItem'),
--            verticalArgs = {-1, 0, 0, 0},
            selectMode = 'MULTI', extraButtons = {GUI.ListButton.Add, GUI.ListButton.Delete, GUI.ListButton.SelectAll, GUI.ListButton.SelectNone},
            profile = {self:GetName(), 'SaveToBank'},
            scripts = {
                OnAdd = OnAdd,
            },
        },
        {
            type = 'ListWidget', label = L['Load from bank rule'], itemObject = tdCore('GUI')('ListWidgetLinkItem'),
            verticalArgs = {-1, 0, 0, 0},
            selectMode = 'MULTI', extraButtons = {GUI.ListButton.Add, GUI.ListButton.Delete, GUI.ListButton.SelectAll, GUI.ListButton.SelectNone},
            profile = {self:GetName(), 'LoadFromBank'},
            scripts = {
                OnAdd = OnAdd,
            },
        },
    })
end