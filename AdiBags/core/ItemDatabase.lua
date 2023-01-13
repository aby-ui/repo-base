--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2023 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

--<GLOBALS
local _G = _G
local TRADE_GOODS = _G.Enum.ItemClass.Tradegoods
local UNKNOWN = _G.UNKNOWN
--GLOBALS>

local addonName, addon = ...

local ItemDatabase = {}

function ItemDatabase:ReagentData(slotData)
  if not slotData.isCraftingReagent then return false end
  if not slotData.classID == TRADE_GOODS then return false end
  return {
    expacName = addon.EXPANSION_MAP[slotData.expacID],
    subclassName = addon.TRADESKILL_MAP[slotData.subclassID] or UNKNOWN,
  }
end

addon.ItemDatabase = ItemDatabase
