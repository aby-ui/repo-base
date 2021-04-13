
-- CHANGES TO LOCALIZATION SHOULD BE MADE USING http://www.wowace.com/addons/Broker_MicroMenu/localization/

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("CB_PlayedTime", "enUS", true)

if L then
	L["Reset"] = true
	L["Reset time for all Characters"] = true
	L["General"] = true
end
