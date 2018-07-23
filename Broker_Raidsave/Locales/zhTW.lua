--[[
************************************************************************
Project				: Broker_RaidSave
Author				: torhal
Project Revision	: 2.1.2-beta
Project Date		: 20111012085940

File				: Locales\zhTW.lua
Commit Author		: zhinjio
Commit Revision		: 2
Commit Date			: 20110529065627
************************************************************************
Description	:
	Traditional Chinese translation strings
TODO		:
************************************************************************
--]]
local MODNAME = "BRRaidSave"
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale( MODNAME, "zhTW" )
if not L then return end

L["(Current)"] = "(目前)"
L["(Updating...)"] = "(更新中...)"
L["12-Hour"] = "12小時制"
L["24-Hour"] = "24小時制"
-- L["Activates and displays a scrolling slider bar, for the tooltip."] = "Activates and displays a scrolling slider bar, for the tooltip."
L["Adds a new column, indicating the dungeon or raid difficulty for the specific instance name and ID."] = "新增一列, 說明副本或團隊難度的副本進度名稱和ID。"
L["Ascending"] = "升序"
L["Chinese"] = "中式"
L["Condensed"] = "扼要的"
L["Descending"] = "降序"
L["Difficulty"] = "地域難度"
L["Display style for the date instance IDs expire."] = "顯示副本進度期限的日期樣式。"
L["Display style for the time instance IDs expire."] = "顯示副本進度期限的時間樣式。"
L["Display style for the time until reset."] = "顯示直到重置的時間樣式。"
L["Display the date/time the instance ID expires."] = "顯示副本進度ID 日期/時間 的期限。"
L["Display the name of the day of the week, for the instance expiration string."] = "Display the name of the day of the week, for the instance expiration string."
L["Display the time the instance ID is still valid."] = "顯示副本進度ID仍然有效的時間。"
-- L["Don't display instances with expired ID's on the plugin text."] = "Don't display instances with expired ID's on the plugin text."
L["Don't display instances with expired ID's on the tooltip."] = "提示上不要顯示過期的副本進度ID。"
-- L["Enable scrolling"] = "Enable scrolling"
L["European"] = "歐式"
L["Expired"] = "過期"
-- L["Expired: "] = "Expired: "
L["Expires"] = "期限"
L["Expiry date format"] = "日期期限格式"
L["Expiry time format"] = "時間期限格式"
L["Extended"] = "擴展的"
L["Full"] = "完整的"
L["General Options"] = "一般選項"
-- L["Hide expired instances from plugin text"] = "Hide expired instances from plugin text"
-- L["Hide expired instances from tooltip"] = "Hide expired instances from tooltip"
-- L["Hide hint text"] = "Hide hint text"
-- L["Hides the tooltip information/hint text."] = "Hides the tooltip information/hint text."
L["ID"] = "ID"
L["Instance"] = "副本進度"
L["Instance Expiration"] = "副本進度期限"
L["Instance Information"] = "副本進度資訊"
L["List Ordering"] = "列表清單"
L["Minimalistic LDB plugin that allows tracking of raid IDs across characters."] = "Minimalistic LDB plugin that allows tracking of raid IDs across characters."
L["No Instances"] = "無副本進度"
L["No saved instances found."] = "無副本儲存進度"
-- L["Only show the number of saved instances, in the format [Group]:[Raid]:[Expired]."] = "Only show the number of saved instances, in the format [Group]:[Raid]:[Expired]."
L["Order style for the saved instances list."] = "儲存的副本列表清單樣式"
L["Remaining"] = "重置"
L["Remaining time format"] = "重置時間格式"
-- L["Sets the tooltip maximum height, after which it will be scrollable."] = "Sets the tooltip maximum height, after which it will be scrollable."
L["Short"] = "簡短的"
L["Short text"] = "簡短文字"
L["Show day in week"] = "在星期內顯示天"
L["Show instance IDs"] = "顯示副本進度ID"
L["Show instance difficulty mode"] = "顯示副本難度"
L["Show instance expiration data"] = "顯示副本進度期限日期"
L["Show or hide the numeric instance IDs."] = "顯示或隱藏副本進度的ID數字"
-- L["Show text for no saved instances"] = "Show text for no saved instances"
-- L["Show the plugin text instead of number, when the character has no saved instances."] = "Show the plugin text instead of number, when the character has no saved instances."
L["Show time remaining"] = "顯示剩餘時間"
L["Sort by difficulty"] = "依難度排序"
L["Sort by name"] = "依名稱排序"
L["Sorts the instances on the tooltip, using the instance difficulty as a reference."] = "提示中排序的副本進度，使用副本難度作為一個參考。"
L["Sorts the instances on the tooltip, using the name of the instance as a reference."] = "提示中排序的副本進度，使用副本名稱作為一個參考。"
-- L["Tooltip Maximum Height"] = "Tooltip Maximum Height"
L["US/American"] = "美式"
-- L["|cff0090ffBlue|r |cff19ff19colored instance names, indicate|r |cff0090ffextended|r |cff19ff19IDs.|r"] = "|cff0090ffBlue|r |cff19ff19colored instance names, indicate|r |cff0090ffextended|r |cff19ff19IDs.|r"
-- L["|cffeda55fLeft Click|r |cff19ff19on instance name to toggle ID extension."] = "|cffeda55fLeft Click|r |cff19ff19on instance name to toggle ID extension."
L["|cffeda55fLeft Click|r |cff19ff19on plugin to toggle Blizzard's Raid Information frame."] = "|cffeda55f左鍵點擊|r |cff19ff19在插件上切換顯示遊戲內建的團隊副本進度框架。"
L["|cffeda55fRight Click|r |cff19ff19on plugin to open Configuration Menu."] = "|cffeda55f右鍵點擊|r |cff19ff19在插件上開啟設定選單。"
-- L["|cffeda55fShift+Left Click|r |cff19ff19to paste instance info into chat."] = "|cffeda55fShift+Left Click|r |cff19ff19to paste instance info into chat."


--[[
************************************************************************
CHANGELOG:

Date : 05/29/11
	initial version
************************************************************************
]]--