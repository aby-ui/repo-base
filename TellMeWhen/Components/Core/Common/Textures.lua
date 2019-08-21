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

local strsub, pairs
	= strsub, pairs

-- Module creation
TMW.COMMON.Textures = CreateFrame("Frame")

-- Upvalues
local Textures = TMW.COMMON.Textures


local VarTextures_item = {}
local function UpdateVarTextures_item()
	local updated = false

	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local old = VarTextures_item[i]
		local new = GetInventoryItemTexture("player", i) or nil

		if old ~= new then
			VarTextures_item[i] = new
			updated = true
		end
	end

	if updated then
		TMW:Fire("TMW_TEXTURES_VARTEX_ITEM_CHANGED")
	end
end

Textures:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_EQUIPMENT_CHANGED" then
		UpdateVarTextures_item()
	end
end)


function Textures:EvaluateTexturePath(CustomTex, ...)
	

	local keepItemCallback = false
	local result = ""

	if CustomTex == nil then
		result = nil
	elseif CustomTex:sub(1, 1) == "$" then
		local varType, varData = CustomTex:match("^$([^%.:]+)%.?([^:]*)$")
		
		if varType then
			varType = varType:lower():trim(" ")
		end
		if varData then
			varData = varData:trim(" ")
		end
		
		if varType == "item" then
			varData = tonumber(varData)
			
			if varData and varData >= INVSLOT_FIRST_EQUIPPED and varData <= INVSLOT_LAST_EQUIPPED then
				if not Textures:IsEventRegistered("PLAYER_EQUIPMENT_CHANGED") then
					Textures:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
					UpdateVarTextures_item()
				end

				TMW:RegisterCallback("TMW_TEXTURES_VARTEX_ITEM_CHANGED", ...)
				keepItemCallback = true
				
				result = VarTextures_item[varData]
			end
		end

	elseif CustomTex:lower() == "blank" or CustomTex:lower() == "none" then
		result = ""

	else
		result = Textures:GetTexturePathFromSetting(CustomTex)
	end

	if not keepItemCallback then
		TMW:UnregisterCallback("TMW_TEXTURES_VARTEX_ITEM_CHANGED", ...)
	end

	return result
end


function Textures:GetTexturePathFromSetting(setting)
	setting = tonumber(setting) or setting
		
	if setting and setting ~= "" then

		if TMW.GetSpellTexture(setting) then
			return TMW.GetSpellTexture(setting)
		end

		-- If there is a slash in it, then it is probably a full path
		if strfind(setting, "[\\/]") then 
			return setting
		else
			-- If there isn't a slash in it, then it is probably be a wow icon in interface\icons.
			-- it still might be a file in wow's root directory, but there is no way to tell for sure
			return "Interface/Icons/" .. setting
		end			
	end
end