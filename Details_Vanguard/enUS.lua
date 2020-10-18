local Loc = LibStub("AceLocale-3.0"):NewLocale("Details_Vanguard", "enUS", true) 

if (not Loc) then
	return 
end 

Loc ["STRING_PLUGIN_NAME"] = "Vanguard"
Loc ["STRING_HEALVSDAMAGETOOLTIP"] = "Incoming heal is the amount of healing expected for the next seconds.\nIncoming damage is calculated by Vanguard using the average damage\ntaken on the last seconds.\n\n|cff33CC00*Click for more information."
Loc ["STRING_AVOIDVSHITSTOOLTIP"] = "This is the amount of dodge and parry against the\namount of successful hits received on the last few seconds.\n\n|cff33CC00*Click for more information."
Loc ["STRING_DAMAGESCROLL"] = "Latest damage received amount."
Loc ["STRING_REPORT"] = "Details Vanguard Report"
Loc ["STRING_REPORT_AVOIDANCE"] = "Avoidance statistic for"
Loc ["STRING_REPORT_AVOIDANCE_TOOLTIP"] = "Send avoidance report"

Loc ["STRING_HEALRECEIVED"] = "Heal Received"
Loc ["STRING_HPS"] = "RHPS"
Loc ["STRING_HITS"] = "Hits Received"
Loc ["STRING_DODGE"] = "Dodge"
Loc ["STRING_PARRY"] = "Parry"
Loc ["STRING_DAMAGETAKEN"] = "Damage Taken"
Loc ["STRING_DTPS"] = "DTPS"
Loc ["STRING_DEBUFF"] = "Debuff"
Loc ["STRING_DURATION"] = "Duration"
