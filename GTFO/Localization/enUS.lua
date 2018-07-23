--------------------------------------------------------------------------
-- enUS.lua 
--------------------------------------------------------------------------
--[[
GTFO English Localization
Author: Zensunim of Malygos
]]--

GTFOLocal = 
{
	Active_Off = "Addon suspended",
	Active_On = "Addon resumed",
	Group_None = "None",
	Group_NotInGroup = "You are not in a party or raid.",
	Group_PartyMembers = "%d out of %d party members are using this addon.",
	Group_RaidMembers = "%d out of %d raiders are using this addon.",
	Help_Intro = "v%s (|cFFFFFFFFCommand List|r)",
	Help_Options = "Display options",
	Help_Suspend = "Suspend/Resume addon",
	Help_Suspended = "The addon is currently suspended.",
	Help_TestFail = "Play a test sound (fail alert)",
	Help_TestHigh = "Play a test sound (high damage)",
	Help_TestLow = "Play a test sound (low damage)",
	Help_Version = "Show other raiders running this addon",
	Loading_Loaded = "v%s loaded.",
	Loading_LoadedSuspended = "v%s loaded. (|cFFFF1111Suspended|r)",
	Loading_LoadedWithPowerAuras = "v%s loaded with Power Auras.",
	Loading_NewDatabase = "v%s: New database version detected, resetting defaults.",
	Loading_OutOfDate = "v%s is now available for download!  |cFFFFFFFFPlease update.|r",
	Loading_PowerAurasOutOfDate = "Your version of |cFFFFFFFFPower Auras Classic|r is out-of-date!  GTFO & Power Auras integration could not be loaded.",
	TestSound_Fail = "Test sound (fail alert) playing.",
	TestSound_FailMuted = "Test sound (fail alert) playing. [|cFFFF4444MUTED|r]",
	TestSound_High = "Test sound (high damage) playing.",
	TestSound_HighMuted = "Test sound (high damage) playing. [|cFFFF4444MUTED|r]",
	TestSound_Low = "Test sound (low damage) playing.",
	TestSound_LowMuted = "Test sound (low damage) playing. [|cFFFF4444MUTED|r]",
	UI_Enabled = "Enabled",
	UI_EnabledDescription = "Enable the GTFO addon.",
	UI_Fail = "Fail Alert sounds",
	UI_FailDescription = "Enable GTFO alert sounds for when you were SUPPOSED to move away -- hopefully you learn for next time!",
	UI_HighDamage = "Raid/High Damage sounds",
	UI_HighDamageDescription = "Enable GTFO buzzer sounds for dangerous environments that you should move out of immediately.",
	UI_LowDamage = "PvP/Environment/Low Damage sounds",
	UI_LowDamageDescription = "Enable GTFO boop sounds -- use your discretion whether or not to move from these low damage environments",
	UI_Test = "Test",
	UI_TestDescription = "Test the sound.",
	UI_Volume = "GTFO Volume",
	UI_VolumeDescription = "Set the volume of the sounds playing.",
	UI_VolumeLoud = "4: Loud",
	UI_VolumeMax = "Max",
	UI_VolumeMin = "Min",
	UI_VolumeNormal = "3: Normal (Recommended)",
	UI_VolumeQuiet = "1: Quiet",
	UI_VolumeSoft = "2: Soft",
	UI_VolumeLouder = "5: Loud",
	-- 3.0
	UI_Unmute = "Play sounds when muted",
	-- 3.1
	Help_TestFriendlyFire = "Play a test sound (friendly fire)",
	TestSound_FriendlyFire = "Test sound (friendly fire) playing.",
	TestSound_FriendlyFireMuted = "Test sound (friendly fire) playing. [|cFFFF4444MUTED|r]",
	UI_FriendlyFire = "Friendly Fire sounds",
	UI_FriendlyFireDescription = "Enable GTFO alert sounds for when fellow teammates are walking explosions -- one of you better move!",
	LoadingPopup_Message = "Your settings for GTFO have been reset to default.  Do you want to configure your settings now?",
	ClosePopup_Message = "You can configure your GTFO settings later by typing: %s",
	UI_TestMode = "Experimental/Beta Mode",
	UI_TestModeDescription = "Activate untested/unverified alerts (Beta/PTR)",
	UI_TestModeDescription2 = "Please report any issues to |cFF44FFFF%s@%s.%s|r",
	UI_Trivial = "Trivial content alerts",
	UI_TrivialDescription = "Enable alerts for low-level encounters that would otherwise be considered trivial for your character's current level.",
	-- 4.1
	Recount_Name = "GTFO Alerts",
	Recount_Environmental = "Environmental",
	AlertType_High = "High",
	AlertType_Low = "Low",
	AlertType_Fail = "Fail",
	AlertType_FriendlyFire = "Friendly Fire",
	-- 4.3.1
	UI_UnmuteDescription = "If you have the master sound muted, GTFO will temporarily turn on sound briefly to play GTFO sounds.",
	-- 4.6
	Skada_AlertList = "GTFO Alert Types",
	Skada_SpellList = "GTFO Spells",
	Skada_Category = "Alerts",	
	-- 4.12
	UI_SpecialAlerts = "Special Alerts",
	UI_SpecialAlertsHeader = "Activate Special Alerts",
	-- 4.12.3
	Version_On = "Version update reminders on",
	Version_Off = "Version update reminders off",
	-- 4.19
	UI_TrivialSlider = "Minimum % of HP",
	UI_TrivialDescription2 = "Set the slider to the minimum % amount of HP damage taken for alerts to not be considered trivial.",
	-- 4.32
	UI_UnmuteDescription2 = "This requires the master volume (and selected channel) sliders to be higher than 0%.",
	UI_SoundChannel = "Sound Channel",
	UI_SoundChannelDescription = "This is the volume channel that GTFO alert sounds will attach themselves to.",
}
