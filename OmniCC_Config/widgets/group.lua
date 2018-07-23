--[[
	group.lua
		Defines a general group panel
--]]

OmniCCOptions = OmniCCOptions or {}
OmniCCOptions.Group = {}

local backdrop = {
  bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
  edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
  edgeSize = 16,
  tile = true, tileSize = 16,
  insets = {left = 4, right = 4, top = 4, bottom = 4}
}

function OmniCCOptions.Group:New(name, parent)
	local f = CreateFrame('Frame', parent:GetName() .. name, parent)
	f:SetBackdrop(backdrop)
	f:SetBackdropBorderColor(0.4, 0.4, 0.4)
	f:SetBackdropColor(0, 0, 0, 0.3)

	local t = f:CreateFontString(f:GetName() .. 'Text', 'BACKGROUND', 'GameFontHighlightSmall')
	t:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 5, 0)
	t:SetText(name)
	f.text = t

	return f
end