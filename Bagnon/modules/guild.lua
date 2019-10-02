--[[
	main.lua
		Starts the guild bank frame on demand
--]]

local MODULE, Module =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Guild = LibStub('AceAddon-3.0'):NewAddon(Module, MODULE, 'AceEvent-3.0')

function Guild:OnEnable()
	self:RegisterMessage('CACHE_GUILD_OPENED', 'OnOpen')
	self:RegisterMessage('CACHE_GUILD_CLOSED', 'OnClose')
end

function Guild:OnOpen()
	QueryGuildBankTab(GetCurrentGuildBankTab())
	Addon:ShowFrame('guild'):SetOwner(nil)
end

function Guild:OnClose()
	Addon:HideFrame('guild')
end
