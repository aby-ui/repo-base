--[[
	dialogs.lua
		Static dialog popups for the void storage window
--]]


local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
Addon.VAULT_COST = 100 * 100 * 100

StaticPopupDialogs[ADDON .. 'VAULT_PURCHASE'] = {
	text = format(L.PurchaseVault, GetMoneyString(Addon.VAULT_COST, true)),
	button1 = UNLOCK,
	button2 = NO,

	OnAccept = function(self)
		PlaySound(SOUNDKIT.UI_VOID_STORAGE_UNLOCK)
		UnlockVoidStorage()
	end,

	OnCancel = CloseVoidStorageFrame,
	timeout = 0, preferredIndex = STATICPOPUP_NUMDIALOGS,
	hideOnEscape = 1
}

StaticPopupDialogs[ADDON .. 'CANNOT_PURCHASE_VAULT'] = {
	text = format(L.CannotPurchaseVault, GetMoneyString(Addon.VAULT_COST, true)),
	button1 = CHAT_LEAVE,
	button2 = L.AskMafia,

	OnAccept = CloseVoidStorageFrame,
	OnCancel = CloseVoidStorageFrame,
	timeout = 0, preferredIndex = STATICPOPUP_NUMDIALOGS,
	hideOnEscape = 1
}

StaticPopupDialogs[ADDON .. 'COMFIRM_TRANSFER'] = {
	text = L.ConfirmTransfer,
	button1 = YES,
	button2 = NO,

	OnAccept = function(dialog, frame)
		ExecuteVoidTransfer()
		frame:SendFrameSignal('TRANFER_TOGGLED')
	end,

	OnCancel = function(dialog, frame)
		frame:SendFrameSignal('TRANFER_TOGGLED')
	end,

	timeout = 0, preferredIndex = STATICPOPUP_NUMDIALOGS,
	hideOnEscape = 1
}
