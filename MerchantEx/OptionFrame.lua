------------------------------------------------------------
-- OptionFrame.lua
--
-- Abin
-- 2011/1/05
------------------------------------------------------------

local pairs = pairs
local ipairs = ipairs
local GetItemInfo = GetItemInfo
local GetMerchantItemLink = GetMerchantItemLink
local ClearCursor = ClearCursor
local ChatEdit_GetActiveWindow = ChatEdit_GetActiveWindow
local IsShiftKeyDown = IsShiftKeyDown
local GetCursorInfo = GetCursorInfo
local type = type
local GetRealmName = GetRealmName
local UnitName = UnitName
local UIErrorsFrame = UIErrorsFrame
local ChatFrameEditBox = ChatFrameEditBox
local GameTooltip = GameTooltip

local addon = MerchantEx
local L = MERCHANTEX_LOCALE

------------------------------------------------
-- Main option frame
------------------------------------------------

local frame = UICreateInterfaceOptionPage("MerchantExOptionFrame", L["title"].." "..addon.version, nil, nil, UIParent)
frame:SetDialogStyle("TOOLTIP", 1)
frame:SetSize(360, 405)
frame:SetClampedToScreen(true)

local group = frame:CreateMultiSelectionGroup(L["auto options"], 1)
frame.optionGroup = group
frame:AnchorToTopLeft(group, 0, 30)

group:AddButton(L["repair"], "repair")
group:AddButton(L["guild repair"], "guild") -- char only
group:AddButton(L["sell"], "sell")
group:AddButton(L["details"], "details")
group:AddButton(L["buy"], "buy")
--group:AddButton(L["overbuy"], "overbuy")

group[3]:ClearAllPoints()
group[3]:SetPoint("TOPLEFT", group[1], "BOTTOMLEFT")
group[4]:ClearAllPoints()
group[4]:SetPoint("TOPLEFT", group[2], "BOTTOMLEFT")
group[5]:ClearAllPoints()
group[5]:SetPoint("TOPLEFT", group[3], "BOTTOMLEFT")
--group[6]:ClearAllPoints()
--group[6]:SetPoint("TOPLEFT", group[4], "BOTTOMLEFT")

function group:OnCheckInit(value)
	return addon.db.option[value]
end

function group:OnCheckChanged(value, checked)
	addon.db.option[value] = checked
	addon:Interact(1)
end

local tradeListText = frame:CreateFontString(frame:GetName().."TradeListText", "ARTWORK", "GameFontNormal")
tradeListText:SetPoint("TOPLEFT", group[5], "BOTTOMLEFT", 0, -8)
tradeListText:SetText(L["trade options"])

local tabFrame = UICreateTabFrame(frame:GetName().."TabFrame", frame)
frame.tabFrame = tabFrame
tabFrame:SetPoint("TOPLEFT", tradeListText, "BOTTOMLEFT", 0, -28)
tabFrame:SetPoint("BOTTOMRIGHT", -16, 16)

tabFrame:AddTab(L["exceptions"], "exception")
tabFrame:AddTab(L["buyings"], "buy")

local list = UICreateVirtualScrollList(tabFrame:GetName().."List", tabFrame, 9)
tabFrame.list = list
list:SetPoint("TOPLEFT", 8, -8)
list:SetPoint("BOTTOMRIGHT", -8, 8)

local function PopList(list, t, char)
	local id, qty
	for id, qty in pairs(t) do
		local _, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
		if link then
			list:InsertData({ id = id, link = link, texture = texture, qty = qty, char = char })
		end
	end
end

function tabFrame:OnTabTooltip(id, data)
	GameTooltip:AddLine(id == 1 and L["exceptions"] or L["buyings"])
	GameTooltip:AddLine(L[data.." tooltip"], 1, 1, 1, 1)
	if self:GetSelection() == id then
		GameTooltip:AddLine(L["capture prompt"], 0, 1, 0, 1)
	end
end

function tabFrame:OnTabSelected(id, data)
	list:Clear()
	list.category = data
	list.db = addon.db[data]
	frame.confirmFrame:Hide()

	PopList(list, addon.db[data])
	if data == "exception" then
		PopList(list, addon.db.myexception, 1)
	end
end

------------------------------------------------
-- Confirm frame
------------------------------------------------

local capturedItem = {}

local confirmFrame = CreateFrame("Frame", tabFrame:GetName().."InputFrame", tabFrame)
frame.confirmFrame = confirmFrame
confirmFrame:Hide()
confirmFrame:SetAllPoints(list)

local inputButton = CreateFrame("Button", confirmFrame:GetName().."Button", confirmFrame)
inputButton:SetSize(32, 32)
inputButton:SetPoint("TOPLEFT", 6, -20)
inputButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
inputButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
inputButton:EnableMouseWheel(true)

local inputIcon = inputButton:CreateTexture(inputButton:GetName().."Icon", "ARTWORK")
inputIcon:SetAllPoints(inputButton)

local inputLink = confirmFrame:CreateFontString(confirmFrame:GetName().."Link", "ARTWORK", "GameFontHighlightLeft")
inputLink:SetPoint("LEFT", inputIcon, "RIGHT", 16, 0)

local promptText = confirmFrame:CreateFontString(confirmFrame:GetName().."PromptText", "ARTWORK", "GameFontHighlightLeft")
promptText:SetJustifyV("TOP")
promptText:SetNonSpaceWrap(true)
promptText:SetPoint("TOPLEFT", inputButton, "BOTTOMLEFT", 0, -24)
promptText:SetPoint("BOTTOMRIGHT", -8, 0)

local qtyEdit = frame:CreateEditBox(L["buy qty"])
qtyEdit:SetParent(confirmFrame)
qtyEdit.text:ClearAllPoints()
qtyEdit.text:SetPoint("TOPLEFT", promptText, "TOPLEFT")
qtyEdit:SetPoint("LEFT", qtyEdit.text, "RIGHT", 12, 0)
qtyEdit:SetNumeric(true)
qtyEdit:SetWidth(80)

local okayButton = frame:CreatePressButton(OKAY)
okayButton:SetParent(confirmFrame)
okayButton:SetSize(90, 24)
okayButton:SetPoint("BOTTOMRIGHT", tabFrame, "BOTTOM", -2, 24)

okayButton:SetScript("OnClick", function(self)
	local buyCount = 0
	if list.category == "buy" then
		buyCount = qtyEdit:GetNumber()
		if not buyCount or buyCount < 1 then
			qtyEdit:SetNumber(capturedItem.maxStack)
			qtyEdit:SetFocus()
			qtyEdit:HighlightText()
			return
		end
	end

	local db, id, link, texture = list.db, capturedItem.id, capturedItem.link, capturedItem.texture
	local bottom = list:GetDataCount()
	local position = list:FindItemById(id)
	local data = list:GetData(position)
	if data then
		data.id, data.link, data.texture, data.qty = id, link, texture, buyCount
		list:ShiftData(position, bottom)
	else
		data = { id = id, link = link, texture = texture, qty = buyCount }
		bottom = list:InsertData(data)
	end

	db[id] = buyCount
	confirmFrame.insertPosition = bottom
	confirmFrame:Hide()
	addon:Interact(1)
end)

local cancelButton = frame:CreatePressButton(CANCEL)
cancelButton:SetParent(confirmFrame)
cancelButton:SetSize(90, 24)
cancelButton:SetPoint("LEFT", okayButton, "RIGHT", 4, 0)

cancelButton:SetScript("OnClick", function(self)
	confirmFrame:Hide()
end)

inputButton:SetScript("OnEnter", function(self)
	if capturedItem.link then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetHyperlink(capturedItem.link)
	end
end)

inputButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

confirmFrame:SetScript("OnShow", function(self)
	list:Hide()
end)

confirmFrame:SetScript("OnHide", function(self)
	wipe(capturedItem)
	self:Hide()
	list:Show()
	if self.insertPosition then
		list:EnsureVisible(self.insertPosition)
		self.insertPosition = nil
	end
end)

qtyEdit:SetScript('OnEnterPressed', function()
    okayButton:Click()
end)

qtyEdit:SetScript('OnEscapePressed', function()
    cancelButton:Click()
end)

------------------------------------------------
-- Drag & drop supports
------------------------------------------------

local function OnHyperlinkCapture(item)
	if type(item) ~= "string" then
		return
	end

	local id, _, link, quality, maxStack, texture, vendorPrice = addon:ParseLink(item)
	if not id then
		return
	end

	if not vendorPrice or vendorPrice == 0 then
		UIErrorsFrame:AddMessage(L["this item cannot be traded"], 1, 0, 0)
		return
	end

	if list.category == "exception" and quality ~= 0 and quality ~= 1 then
		UIErrorsFrame:AddMessage(L["must be gray or white items"], 1, 0, 0)
		return
	end

	capturedItem.id, capturedItem.link, capturedItem.quality, capturedItem.maxStack, capturedItem.texture = id, link, quality, maxStack, texture

	confirmFrame:Show()
	inputIcon:SetTexture(capturedItem.texture)
	inputLink:SetText(capturedItem.link)

	if list.category == "exception" then
		qtyEdit:Hide()
		promptText:SetText(capturedItem.quality == 0 and L["keep prompt"] or L["sell prompt"])
		promptText:Show()
	else
		qtyEdit:Show()
		qtyEdit:SetNumber(capturedItem.maxStack)
		qtyEdit:SetFocus()
		qtyEdit:HighlightText()
		promptText:Hide()
	end

	return id
end

local function OnItemDrop(self)
	local infoType, info1, info2 = GetCursorInfo()
	local link
	if infoType == "item" then
		link = info2
	elseif infoType == "merchant" then
		link = GetMerchantItemLink(info1)
	elseif infoType then
		UIErrorsFrame:AddMessage(L["must be an item"], 1, 0, 0)
	end

	if OnHyperlinkCapture(link) then
		ClearCursor()
	end
end

local function AddDragDropSupport(frame, ...)
	frame:EnableMouse(true)
	frame:HookScript("OnReceiveDrag", OnItemDrop)
	frame:HookScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			OnItemDrop(self)
		end
	end)

	local children = select("#", ...)
	if children > 0 then
		frame.children = { ... }
		frame:RegisterEvent("CURSOR_UPDATE")
		frame:HookScript("OnEvent", function(self, event)
			if event == "CURSOR_UPDATE" then
				local empty = not GetCursorInfo()
				local child
				for _, child in ipairs(self.children) do
					child:EnableMouse(empty)
				end
			end
		end)
	end
end

hooksecurefunc("ChatFrame_OnHyperlinkShow", function(self, id, link)
	local editbox
	if ChatEdit_GetActiveWindow then
		editbox = ChatEdit_GetActiveWindow()
	else
		editbox = ChatFrameEditBox and ChatFrameEditBox:IsShown()
	end

	if not editbox and IsShiftKeyDown() and frame:IsVisible() then
		OnHyperlinkCapture(link)
	end
end)

AddDragDropSupport(list)
AddDragDropSupport(confirmFrame, inputButton, qtyEdit, okayButton, cancelButton)

------------------------------------------------
-- List definition
------------------------------------------------

function list:FindItemById(id)
	return self:FindData(id, function(t, i) return t.id == i end)
end

local function CharOnlyCheckButton_OnClick(self)
	if GetCursorInfo() then
		self:SetChecked(not self:GetChecked())
		return
	end

	local data = self:GetParent().data
	local id = data.id
	if self:GetChecked() then
		data.char = 1
		addon.db.exception[id] = nil
		addon.db.myexception[id] = 0
	else
		data.char = nil
		addon.db.exception[id] = 0
		addon.db.myexception[id] = nil
	end
end

local function DeleteButton_OnClick(self)
	if not GetCursorInfo() then
		local id = self:GetParent().data.id
		list:RemoveData(list:FindItemById(id))
        if(list.category == 'exception') then
            addon.db.exception[id] = nil
            addon.db.myexception[id] = nil
        else
            list.db[id] = nil
        end
	end
end

function list:OnButtonCreated(button)
	button.icon = button:CreateTexture(button:GetName().."Icon", "ARTWORK")
	button.icon:SetSize(16, 16)
	button.icon:SetPoint("LEFT", 4, 0)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	button.text = button:CreateFontString(button:GetName().."Text", "ARTWORK", "GameFontHighlightSmallLeft")
	button.text:SetPoint("LEFT", button.icon, "RIGHT", 8, 0)

	button.delete = CreateFrame("Button", button:GetName().."Delete", button, "UIPanelCloseButton")
	button.delete:SetSize(16, 16)
	button.delete:SetPoint("RIGHT", -4, 0)
	button.delete:SetScript("OnClick", DeleteButton_OnClick)

	button.check = CreateFrame("CheckButton", button:GetName().."Check", button, "InterfaceOptionsSmallCheckButtonTemplate")
	_G[button.check:GetName().."Text"]:SetText(L["char"])
	button.check:SetPoint("RIGHT", button.delete, "LEFT", -45, 0)
	button.check:SetHitRectInsets(0, 0, 0, 0)
	button.check:SetScript("OnClick", CharOnlyCheckButton_OnClick)

	AddDragDropSupport(button, button.delete, button.check)
end

function list:OnButtonUpdate(button, data)
	button.icon:SetTexture(data.texture)

	if self.category == "exception" then
		button.text:SetText(data.link)
		button.check:Show()
		button.check:SetChecked(data.char)
	else
		button.text:SetText(data.link.." x"..data.qty)
		button.check:Hide()
	end
end

function list:OnButtonTooltip(button, data)
	GameTooltip:SetHyperlink(data.link)
end

------------------------------------------------
-- User data manipulation
------------------------------------------------

local function InitDB(db)
	local k, v
	for k, v in pairs(db) do
		local id
		if type(k) == "string" then
			-- Convert data format from previous versions
			local link, qty
			if type(v) == "table" then
				link, qty = v.link, v.qty
				if type(qty) ~= "number" or qty < 1 then
					qty = 1
				end
			else
				link = v
			end

			id = addon:GetItemId(link)
			if id then
				db[id] = qty or 0
			end

			db[k] = nil

		elseif type(k) == "number" then
			-- Current version
			id = k
		else
			-- Invalid entry, never happens actually
			db[k] = nil
		end

		if id then
			GetItemInfo(id) -- Query the game server NOW, so we might get item info when we open the option frame
		end
	end
end

frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("MERCHANT_CLOSED")
frame:RegisterEvent("PLAYER_MONEY")

frame:SetScript("OnEvent", function(self, event)
	if event == "VARIABLES_LOADED" then
		if type(MerchantExDB) ~= "table" then
			MerchantExDB = {}
		end

		if type(MerchantExDB.option) ~= "table" then
			MerchantExDB.option = { repair = 1, sell = 1, buy = 1 }
		end

		if type(MerchantExDB.exception) ~= "table" then
			MerchantExDB.exception = {}
		end

		if type(MerchantExDB.myexception) ~= "table" then
			MerchantExDB.myexception = {} -- This was added by other developers whom I do agree with
		end

		if type(MerchantExDB.buy) ~= "table" then
			MerchantExDB.buy = {}
		end

		local profile = (GetRealmName() or "SF").."-"..(UnitName("player") or "Default")

		if type(MerchantExDB.myexception[profile]) ~= "table" then
			MerchantExDB.myexception[profile] = {}
		end

		if type(MerchantExDB.buy[profile]) ~= "table" then
			MerchantExDB.buy[profile] = {}
		end

		addon.db.option = MerchantExDB.option
		addon.db.exception = MerchantExDB.exception
		addon.db.myexception = MerchantExDB.myexception[profile]
		addon.db.buy = MerchantExDB.buy[profile]

		InitDB(addon.db.exception)
		InitDB(addon.db.myexception)
		InitDB(addon.db.buy)

		self:ClearAllPoints()
		self:SetPoint("CENTER")

		tabFrame:SelectTab(1)

		SLASH_MERCHANTEX1 = "/merchantex"
		SLASH_MERCHANTEX2 = "/merc"
		SlashCmdList["MERCHANTEX"] = function() frame:Toggle() end


        do
            local btn = CreateFrame('Button', 'MerchantExToggleButton', MerchantFrame, 'UIPanelButtonTemplate')
            btn:SetPoint('TOPLEFT', 70, -32)
            btn:SetSize(80,23)
            btn:SetText'商人助手'
            btn:SetScript('OnClick', function()
                return frame:Toggle()
            end)
        end

	elseif event == "MERCHANT_SHOW" then
        if MerchantFrame:IsVisible() then
            addon.moneyBefore = GetMoney() or 0
        end
        addon.balance = addon:Interact()
    elseif event == "MERCHANT_CLOSED" then
        if addon.moneyBefore then
            local total = (GetMoney() or 0) - addon.moneyBefore
            local balance = addon.balance or 0
            addon:Final(total, balance)
            addon.moneyBefore = nil
            addon.balance = nil
        end
	end
end)
