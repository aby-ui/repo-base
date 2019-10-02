--[[
	brokerDisplay.lua
		A databroker display object
--]]

local ADDON, Addon = ...
local LDB = LibStub('LibDataBroker-1.1')
local BrokerDisplay = Addon:NewClass('BrokerDisplay', 'Button')


--[[ Constructor ]]--

function BrokerDisplay:New(parent)
	local f = self:Bind(CreateFrame('Button', nil, parent))
	f:SetScript('OnMouseWheel', f.OnMouseWheel)
	f:SetScript('OnEnter', f.OnEnter)
	f:SetScript('OnLeave', f.OnLeave)
	f:SetScript('OnClick', f.OnClick)
	f:SetScript('OnShow', f.OnShow)
	f:SetScript('OnHide', f.OnHide)
	f:RegisterForClicks('anyUp')
	f:EnableMouseWheel(true)

	local left = f:CreateArrowButton('<')
	left:SetScript('OnClick', function() f:SetPreviousObject() end)
	left:SetPoint('LEFT')

	local right = f:CreateArrowButton('>')
	right:SetScript('OnClick', function() f:SetNextObject() end)
	right:SetPoint('RIGHT')

	local icon = f:CreateTexture(nil, 'OVERLAY')
	icon:SetPoint('LEFT', left, 'RIGHT')
	icon:SetSize(18, 18)

	local text = f:CreateFontString()
	text:SetFontObject('NumberFontNormalRight')
	text:SetJustifyH('LEFT')

	f.objects = {}
	f.icon, f.text = icon, text
	f.left, f.right = left, right
	f:SetHeight(26)
	f:Update()

	return f
end

function BrokerDisplay:CreateArrowButton(text)
	local b = CreateFrame('Button', nil, self)
	b:SetNormalFontObject('GameFontNormal')
	b:SetHighlightFontObject('GameFontHighlight')
	b:SetToplevel(true)
	b:SetSize(18, 18)
	b:SetText(text)

	return b
end


--[[ Messages ]]--

function BrokerDisplay:ObjectCreated(_, name)
	if self:GetObjectName() == name then
		self:UpdateDisplay()
	end
end

function BrokerDisplay:AttributeChanged(_, object, attr)
	if self:GetObjectName() == object then
		if attr == 'icon' then
			self:UpdateIcon(object)
		elseif attr == 'text' then
			self:UpdateText(object)
		end
	end
end


--[[ Frame Events ]]--

function BrokerDisplay:OnEnter()
	local object = self:GetObject()
	if not object then
		return
	end

	if object.OnEnter then
		object.OnEnter(self)
	elseif object.OnTooltipShow then
		GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_TOPLEFT' or 'ANCHOR_TOPRIGHT')
		object.OnTooltipShow(GameTooltip)
		GameTooltip:Show()
	else
		GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_TOPLEFT' or 'ANCHOR_TOPRIGHT')
		GameTooltip:SetText(self:GetObjectName())
		GameTooltip:Show()
	end
end

function BrokerDisplay:OnLeave()
	local object = self:GetObject()
	if object and object.OnLeave then
		object.OnLeave(self)
	elseif GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

function BrokerDisplay:OnClick(...)
	local object = self:GetObject()
	if object and object.OnClick then
		object.OnClick(self, ...)
	end
end

function BrokerDisplay:OnShow()
	self:Update()
end

function BrokerDisplay:OnHide()
	LDB.UnregisterAllCallbacks(self)
end

function BrokerDisplay:OnMouseWheel(direction)
	if direction > 0 then
		self:SetNextObject()
	else
		self:SetPreviousObject()
	end
end


--[[ Update ]]--

function BrokerDisplay:Update()
	self:RegisterEvents()
	self:UpdateDisplay()
end

function BrokerDisplay:RegisterEvents()
	LDB.RegisterCallback(self, 'LibDataBroker_DataObjectCreated', 'ObjectCreated')
	LDB.RegisterCallback(self, 'LibDataBroker_AttributeChanged', 'AttributeChanged')
end

function BrokerDisplay:UpdateDisplay()
	local obj = self:GetObject()
	self:UpdateText(obj)
	self:UpdateIcon(obj)
end

function BrokerDisplay:UpdateText(obj)
	local text

	if obj then
		text = obj.text or obj.label or ''
	else
		text = 'Select Databroker Plugin'
	end

	self.text:SetText(text)
	self:Layout()
end

function BrokerDisplay:UpdateIcon(obj)
	local icon = obj and obj.icon

	self.icon:SetTexture(icon)
	self.icon:SetShown(icon)
	self:Layout()
end

function BrokerDisplay:Layout()
	if self.icon:IsShown() then
		self.text:SetPoint('LEFT', self.icon, 'RIGHT', 2, 0)
		self.text:SetPoint('RIGHT', self.right, 'LEFT', -2, 0)
	else
		self.text:SetPoint('LEFT', self.left, 'RIGHT', 2, 0)
		self.text:SetPoint('RIGHT', self.right, 'LEFT', -2, 0)
	end
end


--[[ LDB Objects ]]--

function BrokerDisplay:SetNextObject()
	local objects = self:GetAvailableObjects()
	local current = self:GetObjectName()

	for i, object in ipairs(objects) do
		if current == object then
			return self:SetObject(objects[(i % #objects) + 1])
		end
	end

	self:SetObject(objects[1])
end

function BrokerDisplay:SetPreviousObject()
	local objects = self:GetAvailableObjects()
	local current = self:GetObjectName()

	for i, object in ipairs(objects) do
		if current == object then
			return self:SetObject(objects[i == 1 and #objects or i - 1])
		end
	end

	self:SetObject(objects[1])
end

function BrokerDisplay:SetObject(name)
	self:GetProfile().brokerObject = name
	self:UpdateDisplay()

	if GameTooltip:IsOwned(self) then
		self:OnEnter()
	end
end

function BrokerDisplay:GetObject()
	return LDB:GetDataObjectByName(self:GetObjectName())
end

function BrokerDisplay:GetObjectName()
	return self:GetProfile().brokerObject
end

function BrokerDisplay:GetAvailableObjects()
	wipe(self.objects)

	for name, obj in LDB:DataObjectIterator() do
		tinsert(self.objects, name)
	end

	sort(self.objects)
	return self.objects
end
