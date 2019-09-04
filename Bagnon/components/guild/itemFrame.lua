--[[
	itemFrame.lua
		A guild bank item slot container
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local ItemFrame = Addon:NewClass('GuildItemFrame', 'Frame', Addon.ItemFrame)
ItemFrame.Button = Addon.GuildItemSlot
ItemFrame.Transposed = true

function ItemFrame:RegisterEvents()
	self:UnregisterSignals()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterSignal('UPDATE_ALL', 'RequestLayout')

	if self:IsCached() then
		self:RegisterSignal('GUILD_TAB_CHANGED', 'ForAll', 'Update')
  else
    self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', 'ForAll', 'Update')
    self:RegisterEvent('GUILDBANK_ITEM_LOCK_CHANGED', 'ForAll', 'UpdateLocked')
	end
end

function ItemFrame:IsShowingBag(bag)
	return bag == GetCurrentGuildBankTab()
end

function ItemFrame:NumSlots()
	return 98
end
