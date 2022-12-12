--[[
	logToggle.lua
		A guild log toggle widget
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Toggle = Addon.Tipped:NewClass('LogToggle', 'CheckButton', ADDON..'MenuCheckButtonTemplate')

Toggle.Icons = {
	'Interface/Icons/INV_Crate_03',
	'Interface/Icons/INV_Misc_Coin_01',
	'Interface/Icons/Inv_misc_note_02'
}

Toggle.Titles = {
	GUILD_BANK_LOG,
	GUILD_BANK_MONEY_LOG,
	GUILD_BANK_TAB_INFO
}


--[[ Construct ]]--

function Toggle:NewSet(parent)
	local set = {}
	for id in ipairs(self.Icons) do
		set[id] = self(parent, id)
	end
	return set
end

function Toggle:New(parent, id)
	local b = self:Super(Toggle):New(parent)
	b:RegisterFrameSignal('LOG_SELECTED', 'OnLogSelected')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b.Icon:SetTexture(self.Icons[id])
	b.id = id
	return b
end


--[[ Events ]]--

function Toggle:OnLogSelected(_, logID)
	self:SetChecked(logID == self.id)
end

function Toggle:OnClick()
	self:SendFrameSignal('LOG_SELECTED', self:GetChecked() and self.id)
end

function Toggle:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(self.Titles[self.id])
	GameTooltip:Show()
end
