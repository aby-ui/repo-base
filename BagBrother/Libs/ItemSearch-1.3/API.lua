--[[
Copyright 2013-2022 João Cardoso
ItemSearch is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this library give you permission to embed it
with independent modules to produce an addon, regardless of the license terms of these
independent modules, and to copy and distribute the resulting software under terms of your
choice, provided that you also meet, for each embedded independent module, the terms and
conditions of the license of that module. Permission is not granted to modify this library.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

This file is part of ItemSearch.
--]]

local Lib = LibStub:NewLibrary('ItemSearch-1.3', 1)
if Lib then
	Lib.Unusable, Lib.Bangs = {}, {}
	Lib.Filters = nil
else
	return
end

local C = LibStub('C_Everywhere')
local Unfit = LibStub('Unfit-1.0')
local Parser = LibStub('CustomSearch-1.0')
local L = {
    PLAYER_CLASS = LOCALIZED_CLASS_NAMES_MALE[UnitClassBase('player')],
    CLASS_REQUIREMENT = ITEM_CLASSES_ALLOWED:format('(.*)'),
    IN_SET = EQUIPMENT_SETS:format('(.*)'),
}


--[[ Main API ]]--

function Lib:Matches(item, search)
	if type(item) == 'table' then
    	return Parser({location = item, link = C_Item.GetItemLink(item)}, search, self.Filters)
	else
		return Parser({link = item}, search, self.Filters)
	end
end

function Lib:IsUnusable(id)
    if Unfit:IsItemUnusable(id) then
        return true
	elseif Lib.Unusable[id] == nil and IsEquippableItem(id) then
		Lib.Unusable[id] = (function()
			local lines = C.TooltipInfo.GetItemByID(id).lines
			for i = #lines-1, 5, -1 do
				local class = lines[i].args[2].stringVal:match(L.CLASS_REQUIREMENT)
				if class then
					return not class:find(L.PLAYER_CLASS)
				end
			end
		end)() or false
    end
	return Lib.Unusable[id]
end

function Lib:IsQuestItem(id)
	local _,_,_,_,_,_,_,_,_,_,_,class,_,bind = GetItemInfo(id)

	if (class == Enum.ItemClass.Questitem or bind == LE_ITEM_BIND_ON_ACQUIRE) and Lib.Bangs[id] == nil then
		Lib.Bangs[id] = (function()
			local lines = C.TooltipInfo.GetItemByID(id).lines
			for i = 2, min(4, #lines) do
				if lines[i].args[2].stringVal:find(ITEM_STARTS_QUEST) then
					return true
				end
			end
		end)() or false
	end

	if Lib.Bangs[id] then
		return true, true
	else
		return class == Enum.ItemClass.Questitem or bind == LE_ITEM_BIND_QUEST
	end
end


--[[ Equipment Sets ]]--

if IsAddOnLoaded('ItemRack') then
	function Lib:BelongsToSet(id, search)
		if IsEquippableItem(id) then
			for name, set in pairs(ItemRackUser.Sets) do
				if name:sub(1,1) ~= '' and (not search or Parser:Find(search, name)) then
					for _, item in pairs(set.equip) do
						if ItemRack.SameID(id, item) then
							return true
						end
					end
				end
			end
		end
	end

elseif C_EquipmentSet then
	function Lib:BelongsToSet(id, search)
		if IsEquippableItem(id) then
			for i, setID in pairs(C_EquipmentSet.GetEquipmentSetIDs()) do
				local name = C_EquipmentSet.GetEquipmentSetInfo(setID)
				if not search or Parser:Find(search, name) then
					local items = C_EquipmentSet.GetItemIDs(setID)
					for _, item in pairs(items) do
						if id == item then
							return true
						end
					end
				end
			end
		end
	end

else
	function Lib:BelongsToSet() end
end
