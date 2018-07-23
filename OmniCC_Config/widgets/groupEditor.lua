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
	remove button
--]]
local removeButton_New, removeButton_OnClick
do
	removeButton_New = function(parent)
		local b = CreateFrame('Button', nil, parent); b:Hide()
		b:SetSize(BUTTON_HEIGHT, BUTTON_HEIGHT)
		b:SetScript('OnClick', removeButton_OnClick)
		b:SetDisabledTexture([[Interface\Buttons\UI-MinimizeButton-Disabled]])
		b:SetNormalTexture([[Interface\Buttons\UI-MinimizeButton-Up]])
		b:SetPushedTexture([[Interface\Buttons\UI-MinimizeButton-Down]])
		b:SetHighlightTexture([[Interface\Buttons\UI-MinimizeButton-Highlight]])
	
		parent.removeButton = b
		return b
	end

	removeButton_OnClick = function(self)
		local button = self:GetParent()
		local list = button:GetParent()
		list:RemoveItem(button:GetValue())
	end
end
--[[
	a list button
--]]

local ListButton = Classy:New('Button')

function ListButton:New(parent, onClick)
	local b = self:Bind(CreateFrame('Button', nil, parent))
	b:SetHeight(BUTTON_HEIGHT)
	b:SetScript('OnClick', onClick)
	b:SetScript('OnEnter', self.OnEnter)
	b:SetScript('OnLeave', self.OnLeave)
	
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
	local removeButton = removeButton_New(b)
	removeButton:SetPoint('RIGHT', 0, -2)

	return b
end

function ListButton:OnEnter()
	self.removeButton:Show()
end

function ListButton:OnLeave()
	if self.removeButton:IsMouseOver() then
		self.removeButton:Hide()
	end
end

function ListButton:SetValue(value)
	self:SetText(value)
end

function ListButton:GetValue()
	return self:GetText() or ''
end


--[[
	Edit Frame
--]]

local EditFrame = Classy:New('Frame')

local function editBox_OnEnterPressed(self)
	local parent = self:GetParent()
	parent:AddItem(parent:GetValue())
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
	local editBox = CreateFrame('EditBox', f:GetName() .. 'EditBox', f, 'InputBoxTemplate')
	editBox:SetPoint('TOPLEFT', f, 'TOPLEFT', 8, 0); editBox:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -60, 0)
	editBox:SetScript('OnEnterPressed', editBox_OnEnterPressed)
	editBox:SetScript('OnTextChanged', editBox_OnTextChanged)
	editBox:SetAutoFocus(false)
	f.editBox = editBox
	
	--create add button
	local addButton = CreateFrame('Button', f:GetName() .. 'AddButton', f)
	addButton:SetSize(24, 24)
	addButton:SetPoint('RIGHT', editBox, 'LEFT', -2, 0)
	addButton:SetScript('OnClick', addButton_OnClick)
	addButton:SetNormalTexture([[Interface\Buttons\UI-PlusButton-UP]])
	addButton:SetPushedTexture([[Interface\Buttons\UI-PlusButton-DOWN]])
	addButton:SetHighlightTexture([[Interface\Buttons\UI-PlusButton-Hilight]])
	f.addButton = addButton
	
	return f
end

function EditFrame:SetValue(value)
	self.editBox:SetText(value)
end

function EditFrame:GetValue()
	return self.editBox:GetText()
end

function EditFrame:AddItem()
	self:GetParent():AddItem(self:GetValue())
end

function EditFrame:RemoveItem()
	self:GetParent():RemoveItem(self:GetValue())
end

function EditFrame:UpdateAddButton()
	self:GetParent():UpdateAddButton()
end


--[[
	The list panel
--]]

local GroupEditor = Classy:New('Frame')
OmniCCOptions.GroupEditor = GroupEditor

function ListEditor:New(title, parent)
	local f = self:Bind(CreateFrame('Frame', parent:GetName() .. title, parent, 'OptionsBoxTemplate'))
	f:SetScript('OnShow', f.Load)
	f:SetScript('OnSizeChanged', f.OnSizeChanged)
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
	scrollFrame:SetPoint('TOPLEFT',  editFrame, 'BOTTOMLEFT', 0, -4)
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
	self.buttons = setmetatable({}, {__index = function(t, k)
		local button = ListButton:New(scrollChild, listButton_OnClick)
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
	self.editFrame:SetValue(value)
	self:UpdateSelected()
end

function ListEditor:UpdateSelected()
--	for i, v in pairs(self:GetItems()) do
--		self.buttons[i]:SetChecked(self.selected == v)
--	end
end

function ListEditor:AddItem(value)
	if self:OnAddItem(value) then
		self:UpdateList()
	end
end

function ListEditor:RemoveItem(value)
	if self:OnRemoveItem(value) then
		self:UpdateList()

		local nextItem = ''
		for i, v in ipairs(self:GetItems()) do
			nextItem = v
			break
		end
		self.editFrame:SetValue(nextItem)
	end
end
function ListEditor:OnAddItem(value)
	assert(false, 'Hey, you forgot to set OnAddItem for ' .. self:GetName())
end

function ListEditor:OnRemoveItem(value)
	assert(false, 'Hey, you forgot to set OnRemoveItem for ' .. self:GetName())
end

function ListEditor:IsAddButtonEnabled()
	return true
end

function ListEditor:GetItems()
	assert(false, 'Hey, you forgot to set GetItems for ' .. self:GetName())
end