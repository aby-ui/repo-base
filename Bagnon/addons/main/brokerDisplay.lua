--[[
	brokerDisplay.lua
		A databroker display object
--]]

local ADDON, Addon = ...
local LDB = LibStub('LibDataBroker-1.1')
local Display = Addon.Parented:NewClass('BrokerDisplay', 'Button')


--[[ Construct ]]--

function Display:New(parent)
	local f = self:Super(Display):New(parent)
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

function Display:CreateArrowButton(text)
	local b = CreateFrame('Button', nil, self)
	b:SetNormalFontObject('GameFontNormal')
	b:SetHighlightFontObject('GameFontHighlight')
	b:SetToplevel(true)
	b:SetSize(18, 18)
	b:SetText(text)

	return b
end


--[[ Messages ]]--

function Display:ObjectCreated(_, name)
	if self:GetObjectName() == name then
		self:UpdateDisplay()
	end
end

function Display:AttributeChanged(_, object, attr)
	if self:GetObjectName() == object then
		if attr == 'icon' then
			self:UpdateIcon()
		elseif attr == 'text' then
			self:UpdateText()
		end
	end
end


--[[ Frame Events ]]--

function Display:OnEnter()
	local object = self:GetObject()
	if object then
		if object.OnEnter then
			object.OnEnter(self)
		else
			GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_TOPLEFT' or 'ANCHOR_TOPRIGHT')

			if object.OnTooltipShow then
				object.OnTooltipShow(GameTooltip)
			else
				GameTooltip:SetText(self:GetObjectName())
			end

			GameTooltip:Show()
		end
	end
end

function Display:OnLeave()
	local object = self:GetObject()
	if object and object.OnLeave then
		object.OnLeave(self)
	elseif GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

function Display:OnClick(...)
	local object = self:GetObject()
	if object and object.OnClick then
		object.OnClick(self, ...)
	end
end

function Display:OnShow()
	self:Update()
end

function Display:OnHide()
	LDB.UnregisterAllCallbacks(self)
end

function Display:OnMouseWheel(direction)
	if direction > 0 then
		self:SetNextObject()
	else
		self:SetPreviousObject()
	end
end


--[[ Update ]]--

function Display:Update()
	self:RegisterEvents()
	self:UpdateDisplay()
end

function Display:RegisterEvents()
	LDB.RegisterCallback(self, 'LibDataBroker_DataObjectCreated', 'ObjectCreated')
	LDB.RegisterCallback(self, 'LibDataBroker_AttributeChanged', 'AttributeChanged')
end

function Display:UpdateDisplay()
	self:UpdateText()
	self:UpdateIcon()
end

function Display:UpdateText()
	local obj = self:GetObject()
	local text = obj and (obj.text or obj.label or '') or 'Select Databroker Plugin'

	self.text:SetText(text)
	self:Layout()
end

function Display:UpdateIcon()
	local obj = self:GetObject()
	local icon = obj and obj.icon
	self.icon:SetTexture(icon)
	self.icon:SetShown(icon)
	self:Layout()
end

function Display:Layout()
	if self.icon:IsShown() then
		self.text:SetPoint('LEFT', self.icon, 'RIGHT', 2, 0)
		self.text:SetPoint('RIGHT', self.right, 'LEFT', -2, 0)
	else
		self.text:SetPoint('LEFT', self.left, 'RIGHT', 2, 0)
		self.text:SetPoint('RIGHT', self.right, 'LEFT', -2, 0)
	end
end


--[[ LDB Objects ]]--

function Display:SetNextObject()
	local current = self:GetObjectName()
	local objects = self:GetAvailableObjects()
	local i = FindInTableIf(objects, function(o) return o == current end)

	self:SetObject(objects[(i or 0) + 1])
end

function Display:SetPreviousObject()
	local current = self:GetObjectName()
	local objects = self:GetAvailableObjects()
	local i = FindInTableIf(objects, function(o) return o == current end)

	self:SetObject(objects[(i or 2) - 1])
end

function Display:SetObject(name)
	self:GetProfile().brokerObject = name
	self:UpdateDisplay()

	if GameTooltip:IsOwned(self) then
		self:OnEnter()
	end
end

function Display:GetObject()
	return LDB:GetDataObjectByName(self:GetObjectName())
end

function Display:GetObjectName()
	return self:GetProfile().brokerObject
end

function Display:GetAvailableObjects()
	wipe(self.objects)

	for name, obj in LDB:DataObjectIterator() do
		tinsert(self.objects, name)
	end

	sort(self.objects)
	return self.objects
end
