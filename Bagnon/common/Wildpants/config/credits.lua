--[[
	display.lua
		Automatic display settings menu
--]]

local CONFIG = ...
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local PATRONS = {{},{title='Jenkins',people={'Gnare','Seventeen','Grumpyitis','Justin Hall','Debora S Ogormanwh','Angryclown','Johnny Rabbit'}},{title='Ambassador',people={'Fernando Bandeira','Julia F','Lolari ','Owen Pitcairn','Rafael Lins','Mediocre Monk','Joanie Nelson','Nitro ','Guidez ','Ptsdthegamer','Dodgen','Frostedmhrp','Burt Humburg','Unhalted','Connie ','Adam Mann','Kopernikus ','Bc Spear','Kendall Lane','Jury ','Bob Farrell','Dominik','Jeff Stokes','Tigran Andrew','Marinoco ','Keks','Jeffrey Jones','Swallow@area52','Daniel Foster','Peter Hollaubek','Daniel  Di Battist','Lars Norberg'}}} -- generated patron list

local Credits = LibStub('Sushi-3.1').CreditsGroup(Addon.GeneralOptions, PATRONS, 'Patrons |TInterface/Addons/BagBrother/Art/Patreon:12:12|t')
Credits:SetSubtitle(ADDON .. ' is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/jaliborc|r.', 'http://www.patreon.com/jaliborc')
Credits:SetFooter('Copyright 2006-2022 João Cardoso and Jason Greer')
