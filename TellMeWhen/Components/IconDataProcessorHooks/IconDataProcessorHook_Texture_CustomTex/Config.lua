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

local ItemCache = TMW:GetModule("ItemCache")
local ItemCache_Cache

local Module = SUG:NewModule("texture_withVarTex", SUG:GetModule("texture"))
Module.Slots = {}

function Module:Table_GetSpecialSuggestions_1(suggestions)
	local lastName = SUG.lastName
	
	if SUG.lastName:sub(1, 1) == "$" then
		local varType, varData = lastName:match("^$([^%.:]+)%.?([^:]*)$")
		if varData == "" then
			varData = nil
		end
		
		if varData == nil or varType == "item" then
			for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
				if GetInventoryItemID("player", i) then -- Make sure this slot has an item in it
					local id = "$item." .. i
					
					if varData == nil then
						suggestions[#suggestions + 1] = id
					elseif strfind(i, "^" .. varData) then
						suggestions[#suggestions + 1] = id
					end					
				end
			end
		end
	end
end
function Module:Entry_Colorize_2(f, id)
	if tostring(id):find("^$item") then
		f.Background:SetVertexColor(.23, .20, .29, 1) -- color item slots purpleish
	end
end
function Module:Entry_AddToList_2(f, id)
	if tostring(id):find("^$item") then
		local _, varData = id:match("^$([^%.:]+)%.?([^:]*)$")
		
		varData = tonumber(varData)
		
		local itemID = GetInventoryItemID("player", varData) -- get the itemID of the slot
		local link = GetInventoryItemLink("player", varData)

		f.overrideInsertName = L["SUG_INSERTITEMSLOT"]

		local name = GetItemInfo(itemID)

		f.Name:SetText(link and link:gsub("[%[%]]", ""))
		f.ID:SetText(id)

		f.insert = id

		f.tooltipmethod = "SetHyperlink"
		f.tooltiparg = link

		f.Icon:SetTexture(GetItemIcon(itemID))
	end
end
function Module.Sorter_VarTex(a, b)
	print(a, b)
	local varTypeA, varDataA = a:match("^$([^%.:]+)%.?([^:]*)$")
	local varTypeB, varDataB = b:match("^$([^%.:]+)%.?([^:]*)$")
	
	if varTypeA ~= varTypeB then
		return varTypeA < varTypeB
	end
	
	if varTypeA == "item" then
		return tonumber(varDataA) < tonumber(varDataB)
	end
end
function Module:Table_GetSorter()
	if SUG.lastName:sub(1, 1) == "$" then
		return self.Sorter_VarTex
	else
		return self.Sorter_Spells, self.Sorter_Bucket
	end
end

