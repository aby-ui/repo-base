--[[
	main.lua
		The bagnon driver thingy
--]]

local MODULE, Module =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Vault = LibStub('AceAddon-3.0'):NewAddon(Module, MODULE, 'AceEvent-3.0')

function Vault:OnEnable()
	self:RegisterMessage('CACHE_VAULT_OPENED', 'OnOpen')
	self:RegisterMessage('CACHE_VAULT_CLOSED', 'OnClose')
end

function Vault:OnOpen()
	IsVoidStorageReady()
	Addon:ShowFrame('vault'):SetOwner(nil)

	if not CanUseVoidStorage() then
		if Addon.VAULT_COST > GetMoney() then
			StaticPopup_Show(ADDON .. 'CANNOT_PURCHASE_VAULT')
		else
			StaticPopup_Show(ADDON .. 'VAULT_PURCHASE')
		end
	end
end

function Vault:OnClose()
	Addon:HideFrame('vault')
	StaticPopup_Hide(ADDON .. 'CANNOT_PURCHASE_VAULT')
	StaticPopup_Hide(ADDON .. 'VAULT_PURCHASE')
end
