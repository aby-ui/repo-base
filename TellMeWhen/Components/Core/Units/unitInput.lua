-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local ceil, pairs, floor, wipe, strtrim =
	  ceil, pairs, floor, wipe, strtrim

local UNITS = TMW.UNITS

local cachedunits = {}
local temp = {}

local NUM_TOOLTIP_LINES = 50
	
function UNITS:GetUnitInputDetailedTooltip(editbox)
	-- gets a string to set as a tooltip of all of the spells names in the name box in the IE. Splits up equivalancies and turns IDs into names
	local text = TMW:CleanString(editbox)
	if cachedunits[text] then return cachedunits[text] end

	local tbl = UNITS:GetOriginalUnitTable(text)

	local str = ""
	local numadded = 0
	local numperline = ceil(#tbl/NUM_TOOLTIP_LINES)

	for k, v in pairs(tbl) do
		if not temp[v] then
			--Prevents display of the same unit twice.
			
			numadded = numadded + 1
			str = str ..
			v ..
			"; " ..
			(floor(numadded/numperline) == numadded/numperline and "\r\n" or "")
		end
		temp[v] = true
	end
	
	wipe(temp)
	
	str = strtrim(str, "\r\n ;")
	cachedunits[text] = str
	return str
end
