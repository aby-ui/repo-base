--[[
	qualityButton.lua
		A radio button associated with an item quality
--]]

local ADDON, Addon = ...
local QualityButton = Addon.Tipped:NewClass('QualityButton', 'Checkbutton', 'UIRadioButtonTemplate')
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
	local R,G,B = GetItemQualityColor(qualityColor)
	local b = self:Super(QualityButton):New(parent)
	local bg = b:CreateTexture(nil, 'ARTWORK', nil, 2)
	bg:SetColorTexture(R,G,B)
	bg:SetPoint('CENTER')
	bg:SetSize(6,6)

	b.bg = bg
	b.quality = quality
	b.qualityColor = qualityColor
	b.flag = self.Flags[quality]

	b:RegisterFrameSignal('QUALITY_CHANGED', 'UpdateHighlight')
	b:GetHighlightTexture():SetDesaturated(true)
	b:GetNormalTexture():SetVertexColor(R,G,B)
	b:SetScript('OnClick', self.OnClick)
	b:SetScript('OnEnter', self.OnEnter)
	b:SetScript('OnLeave', self.OnLeave)
	b:SetSize(self.SIZE, self.SIZE)
	b:SetCheckedTexture(nil)
	b:UpdateHighlight()
	return b
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
