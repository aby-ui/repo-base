--[[
	vault.lua
		Starts the vault frame on demand
--]]

local MODULE, Module =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Vault = Addon:NewModule('Vault', Module)

local COST = 100 * 100 * 100
local POPUP_ID = MODULE .. 'Purchase'
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Sushi = LibStub('Sushi-3.1')

CloseVoidStorageFrame = CloseVoidStorageFrame or function()
	C_PlayerInteractionManager.ClearInteraction(Enum.PlayerInteractionType.VoidStorageBanker)
end

function Vault:OnEnable()
	self:RegisterMessage('CACHE_VAULT_OPENED', 'OnOpen')
	self:RegisterMessage('CACHE_VAULT_CLOSED', 'OnClose')
end

function Vault:OnOpen()
	IsVoidStorageReady()
	Addon.Frames:Show('vault')

	if not CanUseVoidStorage() then
		if COST > GetMoney() then
			Sushi.Popup {
				id = POPUP_ID,
				text = format(L.CannotPurchaseVault, GetMoneyString(COST, true)),
				button1 = CHAT_LEAVE, button2 = L.AskMafia,
				timeout = 0, hideOnEscape = 1,
				OnAccept = CloseVoidStorageFrame,
				OnCancel = CloseVoidStorageFrame,
			}
		else
			Sushi.Popup {
				id = POPUP_ID,
				text = format(L.PurchaseVault, GetMoneyString(COST, true)),
				button1 = UNLOCK, button2 = NO,
				timeout = 0, hideOnEscape = 1,
				OnCancel = CloseVoidStorageFrame,
				OnAccept = function()
					PlaySound(SOUNDKIT.UI_VOID_STORAGE_UNLOCK)
					UnlockVoidStorage()
				end,
			}
		end
	end
end

function Vault:OnClose()
	Sushi.Popup:Hide(POPUP_ID)
	Addon.Frames:Hide('vault')
end
