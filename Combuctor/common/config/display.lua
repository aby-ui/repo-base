--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local Display = Addon.GeneralOptions:New('DisplayOptions', CreateAtlasMarkup('poi-town'))

function Display:Populate()
	self:Add('Header', L.DisplayInventory, 'GameFontHighlight', true)
	self:AddRow(35*5, function()
		for i, event in ipairs {'Bank', 'Guildbank', 'Auction', 'Mail', 'Player', 'Trade', 'Gems', 'Scrapping', 'Craft'} do
			self:AddCheck('display' .. event):SetWidth(250)
		end
	end)

	self:Add('Header', L.CloseInventory, 'GameFontHighlight', true)
	self:AddRow(35*3, function()
		for i, event in ipairs {'Bank', 'Vendor', 'Map', 'Combat', 'Vehicle'} do
			self:AddCheck('close' .. event):SetWidth(250)
		end
	end)
end
