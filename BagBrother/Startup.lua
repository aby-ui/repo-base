--[[
Copyright 2011-2018 João Cardoso
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
Brother:RegisterEvent('ADDON_LOADED')
Brother:RegisterEvent('PLAYER_LOGIN')


--[[ Cache Loaded ]]--

function Brother:ADDON_LOADED()
	self:RemoveEvent('ADDON_LOADED')
	self:StartupCache()
	self:SetupCharacter()
end

function Brother:StartupCache()
	local Player = UnitName('player')
	local Realm = GetRealmName()
	
	BrotherBags = BrotherBags or {}
	BrotherBags[Realm] = BrotherBags[Realm] or {}
	
	self.Realm = BrotherBags[Realm]
	self.Realm[Player] = self.Realm[Player] or {equip = {}}
	self.Player = self.Realm[Player]
end

function Brother:SetupCharacter()
	local player = self.Player
	player.faction = UnitFactionGroup('player') == 'Alliance'
	player.class = select(2, UnitClass('player'))
	player.race = select(2, UnitRace('player'))
	player.sex = UnitSex('player')
end


--[[ Server Ready ]]--

function Brother:PLAYER_LOGIN()
    if self['ADDON_LOADED'] then
        self['ADDON_LOADED'](self)
    end
	self:RemoveEvent('PLAYER_LOGIN')
	self:SetupEvents()
	self:UpdateData()
end

function Brother:SetupEvents()
	self:RegisterEvent('UNIT_INVENTORY_CHANGED')
	self:RegisterEvent('PLAYER_MONEY')
	self:RegisterEvent('BAG_UPDATE')

	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED')

	self:RegisterEvent('VOID_STORAGE_OPEN')
	self:RegisterEvent('VOID_STORAGE_CLOSE')

	self:RegisterEvent('GUILD_ROSTER_UPDATE')
	self:RegisterEvent('GUILDBANKFRAME_OPENED')
	self:RegisterEvent('GUILDBANKFRAME_CLOSED')
	self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED')
end

function Brother:UpdateData()
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		self:BAG_UPDATE(i)
	end

	self:UNIT_INVENTORY_CHANGED('player')
	self:GUILD_ROSTER_UPDATE()
	self:PLAYER_MONEY()
end

function Brother:RemoveEvent(event)
	self:UnregisterEvent(event)
	self[event] = nil
end
