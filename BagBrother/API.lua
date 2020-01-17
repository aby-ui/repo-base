--[[
Copyright 2011-2020 João Cardoso
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


function BagBrother:SaveBag(bag, onlyItems, saveSize)
	local size = GetContainerNumSlots(bag)
	if size > 0 then
		local items = {}
		for slot = 1, size do
			local _, count, _,_,_,_, link = GetContainerItemInfo(bag, slot)
			items[slot] = self:ParseItem(link, count)
		end

		if not onlyItems then
			self:SaveEquip(ContainerIDToInventoryID(bag), size)
		elseif saveSize then
			items.size = size
		end

		self.Player[bag] = items
	else
		self.Player[bag] = nil
	end
end

function BagBrother:SaveEquip(i, count)
	local link = GetInventoryItemLink('player', i)
	local count = count or GetInventoryItemCount('player', i)

	self.Player.equip[i] = self:ParseItem(link, count)
end

function BagBrother:ParseItem(link, count)
	if link then
		local id = tonumber(link:match('item:(%d+):')) -- check for profession window bug
		if id == 0 and TradeSkillFrame then
			local focus = GetMouseFocus():GetName()

			if focus == 'TradeSkillSkillIcon' then
				link = GetTradeSkillItemLink(TradeSkillFrame.selectedSkill)
			else
				local i = focus:match('TradeSkillReagent(%d+)')
				if i then
					link = GetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, tonumber(i))
				end
			end
		end

		if link:find('0:0:0:0:0:%d+:%d+:%d+:0:0') then
			link = link:match('|H%l+:(%d+)')
		else
			link = link:match('|H%l+:([%d:]+)')
		end

		if count and count > 1 then
			link = link .. ';' .. count
		end

		return link
	end
end
