--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local PATRONS = {{title='Jenkins',people={'Gnare','ProfessahX','Zaneius Valentine'}},{},{title='Ambassador',people={'Fernando Bandeira','Michael Irving','Julia F','Peggy Webb','Lolari','Craig Falb','Mary Barrentine','Patryk Kalis','Lifeprayer','Steve Lund','Grimmcanuck','Donna Wasson'}}} -- generated patron list

local Credits = LibStub('Sushi-3.1').CreditsGroup(Addon.GeneralOptions)
Credits:SetSubtitle(nil, 'http://www.patreon.com/jaliborc')
Credits:SetFooter('By João Cardoso and Jason Greer')
Credits:SetPeople(PATRONS)
