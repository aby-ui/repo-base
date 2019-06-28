local Loc = LibStub("AceLocale-3.0"):NewLocale("Details_Threat", "enUS", true) 

if (not Loc) then
	return 
end 

Loc ["STRING_PLUGIN_NAME"] = "Tiny Threat"

Loc ["STRING_SLASH_ANIMATE"] = "animate"
Loc ["STRING_SLASH_SPEED"] = "speed"
Loc ["STRING_SLASH_AMOUNT"] = "amount"

Loc ["STRING_COMMAND_LIST"] = "Available Commands:"
Loc ["STRING_SLASH_SPEED_DESC"] = "Changes the frequency (in seconds) which the window is updated, allow values between 0.1 and 3.0"
Loc ["STRING_SLASH_SPEED_CHANGED"] = "Update Speed changed to "
Loc ["STRING_SLASH_SPEED_CURRENT"] = "Update Speed current value is "
