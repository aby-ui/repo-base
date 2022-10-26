--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local Display = Addon.GeneralOptions:New('DisplayOptions', CreateAtlasMarkup('poi-town'))

function Display:Populate()
	self.sets = Addon.sets.display
	self:Add('Header', L.DisplayInventory, 'GameFontHighlight', true)
	self:AddRow(35*6, function()
		for i, event in ipairs {'banker', 'guildBanker', 'voidStorageBanker', 'auctioneer', 'mailInfo', 'merchant', 'tradePartner', 'crafting', 'socketing', 'scrappingMachine', 'playerFrame'} do
			self:AddCheck(event):SetWidth(250)
		end
	end)

	self:Add('Header', L.CloseInventory, 'GameFontHighlight', true)
	self:AddRow(35*3, function()
		for i, event in ipairs {'mapFrame', 'combat', 'vehicle'} do
			self:AddCheck(event):SetWidth(250)
		end
	end)
end
