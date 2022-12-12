--[[
	itemGroup.lua
		A guild bank item slot container
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Group = Addon.ItemGroup:NewClass('GuildItemGroup')
Group.Button = Addon.GuildItem
Group.Transposed = true

function Group:RegisterEvents()
	self:UnregisterAll()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:RegisterSignal('UPDATE_ALL', 'RequestLayout')

	if self:IsCached() then
		self:RegisterSignal('GUILD_TAB_CHANGED', 'ForAll', 'Update')
  else
    self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', 'ForAll', 'Update')
    self:RegisterEvent('GUILDBANK_ITEM_LOCK_CHANGED', 'ForAll', 'UpdateLocked')
	end
end

function Group:IsShowingBag(bag)
	return bag == GetCurrentGuildBankTab()
end

function Group:NumSlots()
	return 98
end
