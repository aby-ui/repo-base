--[[
	main.lua
		Show and hide frame
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Guild = Bagnon:NewModule('GuildBank', Addon)

function Guild:OnEnable()
	self:RegisterEvent('GUILDBANKFRAME_CLOSED', 'OnClose')
end

function Guild:OnOpen()
	Addon.Cache.AtGuild = true
	Addon:ShowFrame('guild')
	QueryGuildBankTab(GetCurrentGuildBankTab())
end

function Guild:OnClose()
	Addon.Cache.AtGuild = nil
	Addon:HideFrame('guild')
end
