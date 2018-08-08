--[[
	qualityButton.lua
		A radio button associated with an item quality
--]]

local ADDON, Addon = ...
local QualityButton = Addon:NewClass('QualityButton', 'Checkbutton')
QualityButton.SIZE = 18


do
	local flags = {}
	for quality = 0, 7 do
		flags[quality] = bit.lshift(1, quality)
	end

	flags[5] = flags[5] + flags[6]
	QualityButton.Flags = flags
end


--[[ Constructor ]]--

function QualityButton:New(parent, quality, qualityColor)
	local button = self:Bind(CreateFrame('Checkbutton', nil, parent, 'UIRadioButtonTemplate'))
	local r, g, b = GetItemQualityColor(qualityColor)
	local bg = button:CreateTexture(nil, 'ARTWORK', nil, 2)
	bg:SetColorTexture(r, g, b)
	bg:SetPoint('CENTER')
	bg:SetSize(6,6)

	button.bg = bg
	button.quality = quality
	button.qualityColor = qualityColor
	button.flag = self.Flags[quality]

	button:RegisterFrameSignal('QUALITY_CHANGED', 'UpdateHighlight')
	button:SetScript('OnClick', self.OnClick)
	button:SetScript('OnEnter', self.OnEnter)
	button:SetScript('OnLeave', self.OnLeave)

	button:GetNormalTexture():SetVertexColor(r, g, b)
	button:GetHighlightTexture():SetDesaturated(true)
	button:SetSize(self.SIZE, self.SIZE)
	button:SetCheckedTexture(nil)
	button:UpdateHighlight()

	return button
end


--[[ Frame Events ]]--

function QualityButton:OnClick()
	local frame = self:GetFrame()
	if self:IsSelected() then
		if IsModifierKeyDown() or frame.quality == self.flag then
			frame.quality = frame.quality - self.flag
		else
			frame.quality = self.flag
		end
	elseif IsModifierKeyDown() then
		frame.quality = frame.quality + self.flag
	else
		frame.quality = self.flag
	end

	self:SendFrameSignal('QUALITY_CHANGED')
	self:SendFrameSignal('FILTERS_CHANGED')
end

function QualityButton:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	GameTooltip:SetText(_G['ITEM_QUALITY'..self.quality..'_DESC'], GetItemQualityColor(self.qualityColor))
	GameTooltip:Show()
end

function QualityButton:OnLeave()
	GameTooltip:Hide()
end


--[[ Update ]]--

function QualityButton:UpdateHighlight()
	if self:IsSelected() then
		self:LockHighlight()
		self.bg:SetVertexColor(.25, .25, .25)
	else
		self:UnlockHighlight()
		self.bg:SetVertexColor(.15, .15, .15)
	end
end

function QualityButton:IsSelected()
	local frame = self:GetFrame()
	return frame.quality > 0 and frame:IsShowingQuality(self.quality)
end