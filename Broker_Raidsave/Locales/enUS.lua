--[[
************************************************************************
Project				: Broker_Raidsave
Author				: torhal
Project Revision	: 2.1.2-beta
Project Date		: 20111012085940

File				: Locales\enUS.lua
Commit Author		: zhinjio
Commit Revision		: 2
Commit Date			: 20110529065627
************************************************************************
Description	:
	English translation strings
TODO		:
************************************************************************
--]]
local MODNAME = "BRRaidSave"
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale( MODNAME, "enUS", true )
if not L then return end

L["(Current)"] = true
L["(Updating...)"] = true
L["12-Hour"] = true
L["24-Hour"] = true
L["Activates and displays a scrolling slider bar, for the tooltip."] = true
L["Adds a new column, indicating the dungeon or raid difficulty for the specific instance name and ID."] = true
L["Ascending"] = true
L["Chinese"] = true
L["Condensed"] = true
L["Descending"] = true
L["Difficulty"] = true
L["Display style for the date instance IDs expire."] = true
L["Display style for the time instance IDs expire."] = true
L["Display style for the time until reset."] = true
L["Display the date/time the instance ID expires."] = true
L["Display the name of the day of the week, for the instance expiration string."] = true
L["Display the time the instance ID is still valid."] = true
L["Don't display instances with expired ID's on the plugin text."] = true
L["Don't display instances with expired ID's on the tooltip."] = true
L["Enable scrolling"] = true
L["European"] = true
L["Expired"] = true
L["Expired: "] = true
L["Expires"] = true
L["Expiry date format"] = true
L["Expiry time format"] = true
L["Extended"] = true
L["Full"] = true
L["General Options"] = true
L["Hide expired instances from plugin text"] = true
L["Hide expired instances from tooltip"] = true
L["Hide hint text"] = true
L["Hides the tooltip information/hint text."] = true
L["ID"] = true
L["Instance"] = true
L["Instance Expiration"] = true
L["Instance Information"] = true
L["List Ordering"] = true
L["Minimalistic LDB plugin that allows tracking of raid IDs across characters."] = true
L["No Instances"] = true
L["No saved instances found."] = true
L["Only show the number of saved instances, in the format [Group]:[Raid]:[Expired]."] = true
L["Order style for the saved instances list."] = true
L["Remaining"] = true
L["Remaining time format"] = true
L["Sets the tooltip maximum height, after which it will be scrollable."] = true
L["Short"] = true
L["Short text"] = true
L["Show day in week"] = true
L["Show instance IDs"] = true
L["Show instance difficulty mode"] = true
L["Show instance expiration data"] = true
L["Show or hide the numeric instance IDs."] = true
L["Show text for no saved instances"] = true
L["Show the plugin text instead of number, when the character has no saved instances."] = true
L["Show time remaining"] = true
L["Sort by difficulty"] = true
L["Sort by name"] = true
L["Sorts the instances on the tooltip, using the instance difficulty as a reference."] = true
L["Sorts the instances on the tooltip, using the name of the instance as a reference."] = true
L["Tooltip Maximum Height"] = true
L["US/American"] = true
L["|cff0090ffBlue|r |cff19ff19colored instance names, indicate|r |cff0090ffextended|r |cff19ff19IDs.|r"] = true
L["|cffeda55fLeft Click|r |cff19ff19on instance name to toggle ID extension."] = true
L["|cffeda55fLeft Click|r |cff19ff19on plugin to toggle Blizzard's Raid Information frame."] = true
L["|cffeda55fRight Click|r |cff19ff19on plugin to open Configuration Menu."] = true
L["|cffeda55fShift+Left Click|r |cff19ff19to paste instance info into chat."] = true


--[[
************************************************************************
CHANGELOG:

Date : 05/29/11
	initial version
************************************************************************
]]--