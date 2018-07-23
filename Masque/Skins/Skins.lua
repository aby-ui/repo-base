--[[
	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Skins\Skins.lua
	* Author.: StormFX

]]

local _, Core = ...
local error, setmetatable, type = error, setmetatable, type

-- Skin Data
local Skins = {}
Core.Skins = Skins

-- Skin List
local SkinList = {}
Core.SkinList = SkinList

-- Layers
local Layers = {
	"Backdrop",
	"Icon",
	"Flash",
	"Cooldown",
	"Pushed",
	"Normal",
	"Disabled",
	"Checked",
	"Border",
	"Gloss",
	"AutoCastable",
	"Highlight",
	"Name",
	"Count",
	"HotKey",
	"Duration",
	"Shine",
}

-- Hidden Layer
local Hidden = {
	Hide = true,
}

-- Adds data to the skin tables, bypassing the skin validation.
function Core:AddSkin(SkinID, SkinData)
	for i = 1, #Layers do
		local Layer = Layers[i]
		if type(SkinData[Layer]) ~= "table" then
			if Layer == "Shine" and type(SkinData.AutoCast) == "table" then
				SkinData[Layer] = SkinData.AutoCast
			else
				SkinData[Layer] = Hidden
			end
		end
	end
	Skins[SkinID] = SkinData
	SkinList[SkinID] = SkinID
end

-- API method for validating and adding skins.
function Core.API:AddSkin(SkinID, SkinData, Replace)
	local debug = Core.db.profile.Debug
	if type(SkinID) ~= "string" then
		if debug then
			error("Bad argument to method 'AddSkin'. 'SkinID' must be a string.", 2)
		end
		return
	end
	if Skins[SkinID] and not Replace then
		return
	end
	if type(SkinData) ~= "table" then
		if debug then
			error("Bad argument to method 'AddSkin'. 'SkinData' must be a table.", 2)
		end
		return
	end
	local Template = SkinData.Template
	if Template then
		if Skins[Template] then
			setmetatable(SkinData, {__index=Skins[Template]})
		else
			if debug then
				error(("Invalid template reference by skin '%s'. Skin '%s' does not exist."):format(SkinID, Template), 2)
			end
			return
		end
	end
	Core:AddSkin(SkinID, SkinData)
end

-- API method for returning the skins table.
function Core.API:GetSkins()
	return Skins
end

-- API method returning a specific skin.
function Core.API:GetSkin(SkinID)
	return SkinID and Skins[SkinID]
end
