-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSUtils = private.NewLib("RareScannerUtils")

---============================================================================
-- Table utils
---============================================================================

function RSUtils.FilterRepeated(originTable, tableToCompate)
	if (originTable and type(originTable) == "table") then
		local notRepeatedValues = {}
		
		for _, value in ipairs(originTable) do
			if (tableToCompate and type(tableToCompate) == "table" and not RSUtils.Contains(tableToCompate, value) and not RSUtils.Contains(notRepeatedValues, value)) then
				table.insert(notRepeatedValues, value)
			elseif (not RSUtils.Contains(notRepeatedValues, value)) then
				table.insert(notRepeatedValues, value)
			end
		end
		
		if (next(notRepeatedValues) ~= nil) then
			return notRepeatedValues
		end
	end
	
	return nil
end

function RSUtils.JoinTables(table1, table2)
	local joinedTable = {}
	if (table1 and type(table1) == "table") then
		for _, value in ipairs (table1) do
			if (not RSUtils.Contains(joinedTable, value)) then
				tinsert(joinedTable, value)
			end
		end
	end
	
	if (table2 and type(table2) == "table") then
		for _, value in ipairs (table2) do
			if (not RSUtils.Contains(joinedTable, value)) then
				tinsert(joinedTable, value)
			end
		end
	end
	
	if (next(joinedTable) ~= nil) then
		return joinedTable
	end
	
	return nil
end

function RSUtils.Contains(cTable, item)
	if (not cTable or not item) then
		return false
	end

	if (type(cTable) == "table") then
		for k, v in pairs(cTable) do
			if (type(v) == "table") then
				return RSUtils.Contains(v, item)
			elseif (type(item) == "table") then
				return RSUtils.Contains(item, v)
			elseif (type(v) == "string" and string.find(string.upper(v), string.upper(item))) then
				return true;
			elseif (v == item) then
				return true;
			end
		end
	else
		if (type(item) == "table") then
			return RSUtils.Contains(item, cTable)
		elseif (type(cTable) == "string" and string.find(string.upper(cTable), string.upper(item))) then
			return true;
		elseif (cTable == item) then
			return true;
		end
	end
	
	return false;
end

function RSUtils.Distance(POIa, POIb)
  local dx = POIa.x - POIb.x
  local dy = POIa.y - POIb.y
  return math.sqrt ( (dx * dx) + (dy * dy) )
end

--- 
-- @param #string text Text to add color
-- @param #string color Color
-- @return Text with color
---
function RSUtils.TextColor(text, color)
   return string.format("|cff%s%s|r", color, text)
end