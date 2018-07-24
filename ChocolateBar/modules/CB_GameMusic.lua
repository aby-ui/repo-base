-- a LDB object that will show/hide the chocolatebar set in the chocolatebar options
local LibStub = LibStub
local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")
local L = LibStub("AceLocale-3.0"):GetLocale("ChocolateBar")
local wipe, pairs = wipe, pairs

local function mute(self)
	ChocolateBar:Debug("mute")
end

local dataobj = LibStub("LibDataBroker-1.1"):NewDataObject("MoreChocolate", {
	type = "data source",
	icon = "Interface\\AddOns\\ChocolateBar\\pics\\ChocolatePiece",
	label = "Sound",
	text  = "MoreChocolate",

	OnClick = function(self, btn)
		if btn == "LeftButton" then
			mute()
		end
	end,

	OnScroll = OnScroll
})

local function OnScroll(self, vector)
	ChocolateBar:Debug(vector)
	local cVar = "Sound_MasterVolume" --Sound_MusicVolume  Sound_SFXVolume

	local vol = GetCVar(cVar)
	local step = IsAltKeyDown() and vector * .01 or vector * .1
	vol = vol + step
	if vol > 1 then vol = 1 end
	if vol < 0 then vol = 0 end
	SetCVar(voltypeCVar, vol);
	dataobj.text = "Master: "..math.floor((_G.GetCVar(cVar)*100)).."%"
end

--local module = ChocolateBar:NewModule("MoreChocolate", defaults, options)
