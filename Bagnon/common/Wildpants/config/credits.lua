--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local PATRONS = {{title='Jenkins',people={'Gnare ','Justin Rusbatch','Jennifufu'}},{},{title='Ambassador',people={'Fernando Bandeira','Julia F','Lolari ','Craig Falb','Mónica Sanchez Calzado','Denny Hyde','Amanda Chesher','Lynx','Owen Pitcairn','Robert Cohen ','Rafael Lins'}}} -- generated patron list

local Credits = LibStub('Sushi-3.1').CreditsGroup(Addon.GeneralOptions)
Credits:SetSubtitle(nil, 'http://www.patreon.com/jaliborc')
Credits:SetFooter('By João Cardoso and Jason Greer')
Credits:SetPeople(PATRONS)
