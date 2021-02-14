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

local SUG = TMW.SUG
local strlowerCache = TMW.strlowerCache
local GetSpellTexture = TMW.GetSpellTexture

local strfindsug = SUG.strfindsug

local Type = rawget(TMW.Types, "item")

if not Type then return end


local Item = TMW.C.Item
local ItemCache = TMW:GetModule("ItemCache")
local ItemCache_Cache


function Type:GuessIconTexture(ics)
	if ics.Name and ics.Name ~= "" then
		local item = TMW:GetItems(ics.Name)[1]
		if item then
			return item:GetIcon()
		end
	end
end

function Type:DragReceived(icon, t, data, subType)
	local ics = icon:GetSettings()

	if t ~= "item" or not data then
		return
	end

	ics.Name = TMW:CleanString(ics.Name .. ";" .. data)
	return true -- signal success
end


