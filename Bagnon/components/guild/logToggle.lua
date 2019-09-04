--[[
	logToggle.lua
		A guild log toggle widget
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local LogToggle = Addon:NewClass('LogToggle', 'CheckButton')

LogToggle.Icons = {
	[[Interface\Icons\INV_Crate_03]],
	[[Interface\Icons\INV_Misc_Coin_01]],
	[[Interface\Icons\INV_Letter_20]]
}

LogToggle.Titles = {
	GUILD_BANK_LOG,
	GUILD_BANK_MONEY_LOG,
	GUILD_BANK_TAB_INFO
}


--[[ Constructors ]]--

function LogToggle:NewSet(parent)
	local set = {}
	for id in ipairs(self.Icons) do
		set[id] = self:New(parent, id)
	end
	return set
end

function LogToggle:New(parent, id)
	local b = self:Bind(CreateFrame('CheckButton', nil, parent, ADDON..'MenuCheckButtonTemplate'))
	b:RegisterFrameSignal('LOG_SELECTED', 'OnLogSelected')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b.Icon:SetTexture(self.Icons[id])
	b.id = id

	return b
end


--[[ Events ]]--

function LogToggle:OnLogSelected(_, logID)
	self:SetChecked(logID == self.id)
end

function LogToggle:OnClick()
	self:SendFrameSignal('LOG_SELECTED', self:GetChecked() and self.id)
end

function LogToggle:OnEnter()
	GameTooltip:SetOwner(self, (self:GetRight() > (GetScreenWidth() / 2)) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')
	GameTooltip:SetText(self.Titles[self.id])
	GameTooltip:Show()
end

function LogToggle:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
