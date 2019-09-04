--[[
	itemFrame.lua
		A void storage item frame. Three kinds:
			nil -> deposited items
			DEPOSIT -> items to deposit
			WITHDRAW -> items to withdraw
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local ItemFrame = Addon:NewClass('VaultItemFrame', 'Button', Addon.ItemFrame)
ItemFrame.Button = Addon.VaultSlot


--[[ Modifications ]]--

function ItemFrame:New(parent, bags, title)
	local f = Addon.ItemFrame.New(self, parent, bags)
	f.Title = f:CreateFontString(nil, nil, 'GameFontHighlight')
	f.Title:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', 0, 5)
	f.Title:SetText(title)
	f.Transposed = f:GetType() == 'vault'

	return f
end

function ItemFrame:RegisterEvents()
	self:UnregisterSignals()
	self:RegisterFrameSignal('PLAYER_CHANGED', 'Update')
	self:RegisterSignal('UPDATE_ALL', 'RequestLayout')

	if self:IsCached() then
		self:RegisterEvent('VOID_STORAGE_OPEN', 'RegisterEvents')
	else
		local type = self:GetType()
		if type == DEPOSIT then
			self:RegisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', 'RequestLayout')
		elseif type == WITHDRAW then
			self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'RequestLayout')
		else
			self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'ForAll', 'Update')
			self:RegisterEvent('VOID_STORAGE_UPDATE', 'ForAll', 'Update')
			self:RegisterEvent('VOID_TRANSFER_DONE', 'ForAll', 'Update')
		end
	end
end

function ItemFrame:Layout()
	Addon.ItemFrame.Layout(self)

	if self.Title:GetText() then
		local anyItems = self:NumButtons() > 0
		self:SetHeight(self:GetHeight() + (anyItems and 20 or 0))
		self.Title:SetShown(anyItems)
	end
end


--[[ Properties ]]--

function ItemFrame:NumSlots()
	if self:GetType() == DEPOSIT then
		return GetNumVoidTransferDeposit()
	elseif self:GetType() == WITHDRAW then
		return GetNumVoidTransferWithdrawal()
	else
		return 160
	end
end

function ItemFrame:GetType()
	return self.bags[1]
end
