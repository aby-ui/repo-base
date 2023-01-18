--[[
Copyright 2011-2023 João Cardoso
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


local Brother = LibStub('WildAddon-1.0'):NewAddon('BagBrother')

function Brother:OnEnable()
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
	
	self:RegisterEvent('BAG_UPDATE')
	self:RegisterEvent('PLAYER_MONEY')
	self:RegisterEvent('GUILD_ROSTER_UPDATE')
	self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED')

	if C_PlayerInteractionManager then
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
	elseif CanUseVoidStorage then
		self:RegisterEvent('VOID_STORAGE_OPEN')
		self:RegisterEvent('VOID_STORAGE_CLOSE')
	end

	if CanGuildBankRepair then
		self:RegisterEvent('GUILDBANKFRAME_OPENED')
		self:RegisterEvent('GUILDBANKFRAME_CLOSED')
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
	end

	for i = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS do
		self:BAG_UPDATE(nil, i)
	end

	if HasKey and HasKey() then
		self:BAG_UPDATE(nil, KEYRING_CONTAINER)
	end

	for i = 1, INVSLOT_LAST_EQUIPPED do
		self:SaveEquip(i)
	end

	self:GUILD_ROSTER_UPDATE()
	self:PLAYER_MONEY()
end
