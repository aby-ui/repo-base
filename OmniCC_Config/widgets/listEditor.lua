--[[
	listEditor.lua
		Displays an editable list
--]]

OmniCCOptions = OmniCCOptions or {}

local Classy = LibStub('Classy-1.0')
local PADDING = 2
local BUTTON_HEIGHT = 18
local SCROLL_STEP = BUTTON_HEIGHT + PADDING

--[[
	Remove button
--]]

local function removeButton_OnEnter(self)
	self:GetParent():LockHighlight()
end

local function removeButton_OnLeave(self)
	if not self:GetParent():IsMouseOver() then
		self:Hide()
	end
	self:GetParent():UnlockHighlight()
end

--[[
	a list button
--]]

local ListButton = Classy:New('Button')

function ListButton:New(parent, onClick, onRemove)
	local b = self:Bind(CreateFrame('Button', nil, parent))
	b:SetHeight(BUTTON_HEIGHT)
	b:SetScript('OnClick', onClick)
	b:SetScript('OnEnter', function(self) self.removeButton:Show() end)
	b:SetScript('OnLeave', function(self) if not self.removeButton:IsMouseOver() then self.removeButton:Hide() end end)

	local ht = b:CreateTexture(nil, 'BACKGROUND')
	ht:SetTexture([[Interface\QuestFrame\UI-QuestLogTitleHighlight]])
	ht:SetVertexColor(0.196, 0.388, 0.8)
	ht:SetBlendMode('ADD')
	ht:SetAllPoints(b)
	b:SetHighlightTexture(ht)

	local text = b:CreateFontString(nil, 'ARTWORK')
	text:SetJustifyH('LEFT')
	text:SetAllPoints(b)
	b:SetFontString(text)
	b:SetNormalFontObject('GameFontNormal')
	b:SetHighlightFontObject('GameFontHighlight')

	--create remove button
	local removeButton = CreateFrame('Button', nil, b, 'UIPanelCloseButton')
	removeButton:SetSize(BUTTON_HEIGHT, BUTTON_HEIGHT)
	removeButton:SetPoint('RIGHT')
	removeButton:Hide()
	removeButton:SetScript('OnClick', onRemove)
	removeButton:SetScript('OnEnter', removeButton_OnEnter)
	removeButton:SetScript('OnLeave', removeButton_OnLeave)
	b.removeButton = removeButton

	return b
end

function ListButton:SetValue(value)
	self.value = value
end

function ListButton:GetValue()
	return self.value
end


--[[
	Edit Frame
--]]

local EditFrame = Classy:New('Frame')

local function editBox_OnEnterPressed(self)
	local parent = self:GetParent()
	if parent:CanAddItem() then
		parent:AddItem(parent:GetValue())
	end
end

local function editBox_OnTextChanged(self)
	local parent = self:GetParent()
	parent:UpdateAddButton()
end

local function addButton_OnClick(self)
	local parent = self:GetParent()
	parent:AddItem(parent:GetValue())
end

function EditFrame:New(parent)
	--create parent frame
	local f = self:Bind(CreateFrame('Frame', parent:GetName() .. 'EditFrame', parent))

	--create edit box
	local editBox = CreateFrame('EditBox', f:GetName() .. 'Edit', f, 'InputBoxTemplate')
	editBox:SetPoint('TOPLEFT', f, 'TOPLEFT', 8, 0)
	editBox:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -54, 0)
	editBox:SetScript('OnEnterPressed', editBox_OnEnterPressed)
	editBox:SetScript('OnTextChanged', editBox_OnTextChanged)
	editBox:SetAutoFocus(false)
	f.edit = editBox

	--create add button
	local addButton = CreateFrame('Button', f:GetName() .. 'Add', f, 'UIPanelButtonTemplate')
	addButton:SetText(ADD)
	addButton:SetSize(48, 24)
	addButton:SetPoint('LEFT', editBox, 'RIGHT', 4, 0)
	addButton:SetScript('OnClick', addButton_OnClick)
	f.add = addButton

	return f
end

function EditFrame:GetValue()
	return self.edit:GetText()
end

function EditFrame:AddItem()
	self:GetParent():AddItem(self:GetValue())
end

function EditFrame:CanAddItem()
	return self:GetParent():CanAddItem(self.edit:GetText())
end

function EditFrame:UpdateAddButton()
	self:GetParent():UpdateAddButton()
end

function EditFrame:RemoveItem()
	self:GetParent():RemoveItem(self:GetValue())
end


--[[
	The list panel
--]]

local ListEditor = Classy:New('Frame')
OmniCCOptions.ListEditor = ListEditor

function ListEditor:New(name, parent)
	local f = self:Bind(CreateFrame('Frame', parent:GetName() .. name, parent))
	f:SetScript('OnShow', f.Load)
	return f
end

function ListEditor:OnSizeChanged()
	self:UpdateScrollFrameSize()
end

do
	local function scrollFrame_OnSizeChanged(self)
		local scrollChild = self:GetParent().scrollChild
		scrollChild:SetWidth(self:GetWidth())

		local scrollBar  = self:GetParent().scrollBar
		local scrollMax = max(scrollChild:GetHeight() - self:GetHeight(), 0)
		scrollBar:SetMinMaxValues(0, scrollMax)
		scrollBar:SetValue(0)
	end

	local function scrollFrame_OnMouseWheel(self, delta)
		local scrollBar = self:GetParent().scrollBar
		local min, max = scrollBar:GetMinMaxValues()
		local current = scrollBar:GetValue()

		if IsShiftKeyDown() and (delta > 0) then
		   scrollBar:SetValue(min)
		elseif IsShiftKeyDown() and (delta < 0) then
		   scrollBar:SetValue(max)
		elseif (delta < 0) and (current < max) then
		   scrollBar:SetValue(current + SCROLL_STEP)
		elseif (delta > 0) and (current > 1) then
		   scrollBar:SetValue(current - SCROLL_STEP)
		end
	end

	function ListEditor:CreateScrollFrame()
		local scrollFrame = CreateFrame('ScrollFrame', nil, self)
		scrollFrame:EnableMouseWheel(true)
		scrollFrame:SetScript('OnSizeChanged', scrollFrame_OnSizeChanged)
		scrollFrame:SetScript('OnMouseWheel', scrollFrame_OnMouseWheel)

		return scrollFrame
	end

	function ListEditor:UpdateScrollFrameSize()
		local w, h = self:GetSize()
		w = w - 16
		h = h - 48

		if self.scrollBar:IsShown() then
			w = w - (self.scrollBar:GetWidth() + 4)
		end

		self.scrollFrame:SetSize(w, h)
	end
end

do
	local function scrollBar_OnValueChanged(self, value)
		local scrollFrame = self:GetParent().scrollFrame
		scrollFrame:SetVerticalScroll(value)
	end

	function ListEditor:CreateScrollBar()
		local scrollBar = CreateFrame('Slider', nil, self)

		local bg = scrollBar:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(true)
		bg:SetTexture(0, 0, 0, 0.5)

		local thumb = scrollBar:CreateTexture(nil, 'OVERLAY')
		thumb:SetTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
		thumb:SetSize(25, 25)
		scrollBar:SetThumbTexture(thumb)

		scrollBar:SetOrientation('VERTICAL')

		scrollBar:SetScript('OnValueChanged', scrollBar_OnValueChanged)
		return scrollBar
	end
end

function ListEditor:CreateScrollChild()
	local scrollChild = CreateFrame('Frame')
	scrollChild:SetWidth(self.scrollFrame:GetWidth())
	self.scrollFrame:SetScrollChild(scrollChild)

	return scrollChild
end

function ListEditor:CreateEditFrame()
	return EditFrame:New(self)
end


function ListEditor:OnShow()
	self:UpdateList()
	self:UpdateSelected()
end

function ListEditor:Load()
	local editFrame = self:CreateEditFrame()
	editFrame:SetPoint('TOPLEFT', self, 'TOPLEFT', 8, -4)
	editFrame:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -8, -36)
	self.editFrame = editFrame

	local scrollFrame = self:CreateScrollFrame()
	scrollFrame:SetPoint('TOPLEFT', editFrame, 'BOTTOMLEFT', 0, -4)
	self.scrollFrame = scrollFrame

	local scrollChild = self:CreateScrollChild()
	scrollFrame:SetScrollChild(scrollChild)
	self.scrollChild = scrollChild

	local scrollBar = self:CreateScrollBar()
	scrollBar:SetPoint('TOPRIGHT',  editFrame, 'BOTTOMRIGHT', 0, -4)
	scrollBar:SetPoint('BOTTOMRIGHT', -8, 6)
	scrollBar:SetWidth(16)
	self.scrollBar = scrollBar

	local listButton_OnClick = function(b) self:Select(b:GetValue()) end
	local listButton_OnRemove = function(b) self:RemoveItem(b:GetParent():GetValue()) end
	self.buttons = setmetatable({}, {__index = function(t, k)
		local button = ListButton:New(scrollChild, listButton_OnClick, listButton_OnRemove); button:SetID(k)
		if k == 1 then
			button:SetPoint('TOPLEFT')
			button:SetPoint('TOPRIGHT')
		else
			local prevButton = t[k-1]
			button:SetPoint('TOPLEFT', prevButton, 'BOTTOMLEFT', 0, -PADDING)
			button:SetPoint('TOPRIGHT', prevButton, 'BOTTOMRIGHT', 0, -PADDING)
		end
		t[k] = button
		return button
	end})

	scrollFrame:SetSize(346, 244)

	self:SetScript('OnShow', self.OnShow)
	self:OnShow()
end

function ListEditor:UpdateList()
	local items = self:GetItems()

	for i, v in pairs(items) do
		local b = self.buttons[i]
		b:SetText(v)
		b:SetValue(v)
		b:Show()
	end

	for i = #items + 1, #self.buttons do
		self.buttons[i]:Hide()
	end

	local scrollHeight = #items * (BUTTON_HEIGHT + PADDING) - PADDING
	local scrollMax = max(scrollHeight - self.scrollFrame:GetHeight(), 0)

	local scrollBar = self.scrollBar
	scrollBar:SetMinMaxValues(0, scrollMax)
	scrollBar:SetValue(min(scrollMax, scrollBar:GetValue()))
	if scrollMax > 0 then
		self.scrollBar:Show()
	else
		self.scrollBar:Hide()
	end

	self.scrollChild:SetHeight(scrollHeight)
	self:UpdateScrollFrameSize()
	self:UpdateSelected()
end

function ListEditor:Select(value)
	self.selected = value
	if self.OnSelect then
		self:OnSelect(value)
	end
	self:UpdateSelected()
end

function ListEditor:AddItem(value, index)
	if self:OnAddItem(value, index or 1) then
		self:UpdateList()
		self:UpdateAddButton()
	end
end

function ListEditor:RemoveItem(value)
	if self:OnRemoveItem(value) then
		self:UpdateList()

		local nextItem = ''
		for i, v in pairs(self:GetItems()) do
			nextItem = v
			break
		end
		self:UpdateAddButton()
	end
end

function ListEditor:UpdateSelected()
	for i, v in pairs(self:GetItems()) do
		if v == self.selected then
			self.buttons[i]:LockHighlight()
		else
			self.buttons[i]:UnlockHighlight()
		end
	end
end

function ListEditor:CanAddItem()
	local text = self.editFrame.edit:GetText():gsub('%s', '')
	if text == '' then
		return false
	end

	for i, v in pairs(self:GetItems()) do
		if text == v or text:lower() == v then
			return false
		end
	end

	return true
end

function ListEditor:UpdateAddButton()
	if self:CanAddItem() then
		self.editFrame.add:Enable()
	else
		self.editFrame.add:Disable()
	end
end