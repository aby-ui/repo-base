-- a LDB object that will show/hide the chocolatebar set in the chocolatebar options
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale("ChocolateBar")
local acetimer = LibStub("AceTimer-3.0")
local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")
local debug = ChocolateBar and ChocolateBar.Debug or function() end
local ReportPlayedTimeToChat = true
local dataobj, db
local name, server

local function RequestTimePlayed()
	ReportPlayedTimeToChat = false
	return _G.RequestTimePlayed()
end

dataobj = LibStub("LibDataBroker-1.1"):NewDataObject("CB_PlayedTime", {
	type = "data source",
	--icon = "Interface\\AddOns\\ChocolateBar\\pics\\ChocolatePiece",
	label = "Played Time",
	text  = "---",
	defauldDisabled = true,
	OnClick = function(self, button, ...)
		if button == "RightButton" then
			--CB_PlayedTime:OpenOptions()
			--LibStub("AceConfigDialog-3.0"):Open("CB_PlayedTime")
			dataobj:OpenOptions()
		end
		--LibQTip:Release(tooltip)
		tooltip = nil
	end
})

local function formatTime(time)
  local days = floor(time/86400)
  local hours = floor(mod(time, 86400)/3600)
  local minutes = floor(mod(time,3600)/60)
  --return format("%d d %d h %d m", days, hours, minutes)
	if days > 0 then
		return format("%d|cffffd200d|r %d|cffffd200h|r %d|cffffd200m|r", days, hours, minutes)
	else
		return format("%d|cffffd200h|r %d|cffffd200m|r", hours, minutes)
	end
end

function dataobj:OnTooltipShow()
	RequestTimePlayed()
	self:AddLine("PlayedTime")
	local totaltime = 0
	--table.sort(db, function(a,b) return b.total < a.total end)
	for k, v in pairs(db) do
			local time = v.total and v.total or 1
			--self:AddLine(string.format("%s: %s", k, formatTime(time)))
			self:AddDoubleLine(k, formatTime(time), 1, 1, 1, 1, 1, 1)
			totaltime = totaltime + time
	end
	self:AddLine(" ")
	self:AddLine()
	self:AddLine(string.format("Total: %s", formatTime(totaltime)))
end

local function getPlayerIdentifier()
	if not name or not server then
		name, server = UnitFullName("player")
	end
	return string.format("%s-%s", name, server)
end

local function GetMaxLevelForPlayerExpansion()
	return not ChocolateBar:IsRetail() and 60 or _G.GetMaxLevelForPlayerExpansion()
end

local function playedTimeEvent(self, event, totalTimeInSeconds, timeAtThisLevel)
	if not db[getPlayerIdentifier()] then db[getPlayerIdentifier()] = {} end
	local dbChar = db[getPlayerIdentifier()]
	local days = totalTimeInSeconds / 3600 / 24
	dbChar.total = totalTimeInSeconds
	dbChar.timeStamp = GetTime()
	dbChar.timeAtThisLevel = timeAtThisLevel
	if UnitLevel("player") == GetMaxLevelForPlayerExpansion() then
		dataobj.text  =  string.format("%s", formatTime(totalTimeInSeconds))
		dataobj.label = "Played Time"
	else
		dataobj.text  =  string.format("%s", formatTime(timeAtThisLevel))
		dataobj.label = "Time On Level"
	end
end

local function updateText()
	local dbChar = db[getPlayerIdentifier()]
	if dbChar then
		local diff = GetTime() - dbChar.timeStamp
		dataobj.text = formatTime(dbChar.timeAtThisLevel + diff)
	end
end

local frame2 = CreateFrame("Frame")

local function onEnteringWorld()
	db = CB_PlayedTime and CB_PlayedTime or {}
	CB_PlayedTime = db
	RequestTimePlayed()
	acetimer:ScheduleRepeatingTimer(function()
							updateText()
	end, 5)

	dataobj:RegisterOptions(db)
	frame2:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function dataobj:Reset()
	CB_PlayedTime = {}
	db = CB_PlayedTime
end

function dataobj:Delete(name)
	if name and CB_PlayedTime[name] then
		CB_PlayedTime[name] = nil
		db = CB_PlayedTime
		debug("deleted", name)
	end
end

local hookedChatFrame_DisplayTimePlayed = ChatFrame_DisplayTimePlayed
ChatFrame_DisplayTimePlayed = function(...)
	if ReportPlayedTimeToChat then
		return hookedChatFrame_DisplayTimePlayed(...)
	end
	ReportPlayedTimeToChat = true
	return
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", playedTimeEvent)
frame:RegisterEvent("TIME_PLAYED_MSG")
frame2:RegisterEvent("PLAYER_ENTERING_WORLD")
frame2:SetScript("OnEvent", onEnteringWorld)
