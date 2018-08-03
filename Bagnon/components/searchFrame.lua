--[[
	searchFrame.lua
		A searcn frame widget
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SearchFrame = Addon:NewClass('SearchFrame', 'EditBox')

SearchFrame.Backdrop = {
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
	insets = {left = 2, right = 2, top = 2, bottom = 2},
	tile = true,
	tileSize = 16,
	edgeSize = 16,
}


--[[ Constructor ]]--

function SearchFrame:New(parent)
	local f = self:Bind(CreateFrame('EditBox', nil, parent))
	f:SetToplevel(true)
	f:Hide()

	f:SetFrameStrata('DIALOG')
	f:SetTextInsets(8, 8, 0, 0)
	f:SetFontObject('ChatFontNormal')

	f:SetBackdrop(f.Backdrop)
	f:SetBackdropColor(0, 0, 0, 0.8)
	f:SetBackdropBorderColor(1, 1, 1, 0.8)

	f:RegisterSignal('SEARCH_TOGGLED', 'OnToggle')
	f:SetScript('OnTextChanged', f.OnTextChanged)
	f:SetScript('OnEscapePressed', f.OnEscape)
	f:SetScript('OnEnterPressed', f.OnEscape)
	f:SetScript('OnShow', f.OnShow)
	f:SetScript('OnHide', f.OnHide)
	f:SetAutoFocus(false)

	return f
end


--[[ Frame Events ]]--

function SearchFrame:OnToggle(_, shownFrame)
	if shownFrame then
		if not self:IsShown() then
			UICoreFrameFadeIn(self, 0.1)

			if shownFrame == self:GetFrameID() then
				self:HighlightText()
				self:SetFocus()
			end
		end
	else
		self:Hide()
	end
end

function SearchFrame:OnShow()
	self:RegisterSignal('SEARCH_CHANGED', 'UpdateText')
	self:UpdateText()
end

function SearchFrame:OnHide()
	self:UnregisterSignal('SEARCH_CHANGED')
	self:ClearFocus()
end

function SearchFrame:OnTextChanged()
	local text = self:GetText():lower()
	if text ~= Addon.search then
		Addon.search = text
		Addon:SendSignal('SEARCH_CHANGED', text)
	end
end

function SearchFrame:OnEscape()
	Addon.canSearch = nil
	self:SendSignal('SEARCH_TOGGLED', nil)
	self:Hide()
end


--[[ API ]]--

function SearchFrame:UpdateText()
	if Addon.search ~= self:GetText() then
		self:SetText(Addon.search or '')
	end
end
