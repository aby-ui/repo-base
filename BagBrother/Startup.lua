--[[
Copyright 2011-2019 João Cardoso
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


local Brother = CreateFrame('Frame', 'BagBrother')
Brother:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
Brother:RegisterEvent('PLAYER_LOGIN')


--[[ Server Ready ]]--

function Brother:PLAYER_LOGIN()
	self:RemoveEvent('PLAYER_LOGIN')
	self:StartupCache()
	self:SetupEvents()
	self:UpdateData()
end

function Brother:StartupCache()
	local player, realm = UnitFullName('player')
	BrotherBags = BrotherBags or {}
	BrotherBags[realm] = BrotherBags[realm] or {}

	self.Realm = BrotherBags[realm]
	self.Realm[player] = self.Realm[player] or {equip = {}}
	self.Player = self.Realm[player]

	local player = self.Player
	player.faction = UnitFactionGroup('player') == 'Alliance'
	player.class = select(2, UnitClass('player'))
	player.race = select(2, UnitRace('player'))
	player.sex = UnitSex('player')
end

function Brother:SetupEvents()
	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('PLAYER_MONEY')
	self:RegisterEvent('GUILD_ROSTER_UPDATE')
	self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED')

	if CanUseVoidStorage then
		self:RegisterEvent('VOID_STORAGE_OPEN')
		self:RegisterEvent('VOID_STORAGE_CLOSE')
	end

	if CanGuildBankRepair then
		self:RegisterEvent('GUILDBANKFRAME_OPENED')
		self:RegisterEvent('GUILDBANKFRAME_CLOSED')
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
	end
end

function Brother:UpdateData()
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		self:BAG_UPDATE(i)
	end

	for i = 1, INVSLOT_LAST_EQUIPPED do
		self:PLAYER_EQUIPMENT_CHANGED(i)
	end

	self:GUILD_ROSTER_UPDATE()
	self:PLAYER_MONEY()
end


--[[ API ]]--

function Brother:RemoveEvent(event)
	self:UnregisterEvent(event)
	self[event] = nil
end
