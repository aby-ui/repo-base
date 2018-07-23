--[[
Copyright 2011-2017 João Cardoso
BagBrother is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of BagBrother.
--]]

local EquipmentSlots = INVSLOT_LAST_EQUIPPED
local BagSlots = NUM_BAG_SLOTS
local BankSlots = NUM_BANKBAGSLOTS
local VaultSlots = 80 * 2

local FirstBankSlot = 1 + BagSlots
local LastBankSlot = BankSlots + BagSlots
local Backpack = BACKPACK_CONTAINER
local Bank = BANK_CONTAINER
local Reagents = REAGENTBANK_CONTAINER


--[[ Continuous Events ]]--

function BagBrother:BAG_UPDATE(bag)
	local isBag = bag > Bank and bag <= BagSlots
	
	if isBag then
  		self:SaveBag(bag, bag == Backpack)
	end
end

function BagBrother:UNIT_INVENTORY_CHANGED(unit)
	if unit == 'player' then
		for i = 1, EquipmentSlots do
			self:SaveEquip(i)
		end
	end
end

function BagBrother:PLAYER_MONEY()
	self.Player.money = GetMoney()
end


--[[ Bank Events ]]--

function BagBrother:BANKFRAME_OPENED()
	self.atBank = true
end

function BagBrother:BANKFRAME_CLOSED()
	if self.atBank then
		for i = FirstBankSlot, LastBankSlot do
			self:SaveBag(i)
		end

		if IsReagentBankUnlocked() then
			self:SaveBag(Reagents, true)
		end

		self:SaveBag(Bank, true)
		self.atBank = nil
	end
end


--[[ Void Storage Events ]]--

function BagBrother:VOID_STORAGE_OPEN()
	self.atVault = true
end

function BagBrother:VOID_STORAGE_CLOSE()
	if self.atVault then
		self.Player.vault = {}
		self.atVault = nil

		for i = 1, VaultSlots do
			local id = GetVoidItemInfo(1, i)
    		self.Player.vault[i] = id and tostring(id) or nil
  		end
  	end
end


--[[ Guild Events ]]--

function BagBrother:GUILDBANKFRAME_OPENED()
	self.atGuild = true
end

function BagBrother:GUILDBANKFRAME_CLOSED()
	self.atGuild = nil
end

function BagBrother:GUILD_ROSTER_UPDATE()
	self.Player.guild = GetGuildInfo('player')
end

function BagBrother:GUILDBANKBAGSLOTS_CHANGED()
	if self.atGuild then
		local id = GetGuildInfo('player') .. '*'
		local tab = GetCurrentGuildBankTab()
		local tabs = self.Realm[id] or {}

		for i = 1, GetNumGuildBankTabs() do
			tabs[i] = tabs[i] or {}
			tabs[i].name, tabs[i].icon, tabs[i].view, tabs[i].deposit, tabs[i].withdraw = GetGuildBankTabInfo(i)
			tabs[i].info = nil
		end

		local items = tabs[tab]
		if items then
			for i = 1, 98 do
				local link = GetGuildBankItemLink(tab, i)
				local _, count = GetGuildBankItemInfo(tab, i)

				items[i] = self:ParseItem(link, count)
			end
		end

		self.Realm[id] = tabs
	end
end
