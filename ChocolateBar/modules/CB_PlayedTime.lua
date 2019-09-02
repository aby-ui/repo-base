-- a LDB object that will show/hide the chocolatebar set in the chocolatebar options
local LibStub = LibStub
local L = LibStub("AceLocale-3.0"):GetLocale("ChocolateBar")
local acetimer = LibStub("AceTimer-3.0")
local db
local debug = ChocolateBar and ChocolateBar.Debug or function() end
local ReportPlayedTimeToChat = true

local function RequestTimePlayed() 
	ReportPlayedTimeToChat = false
	return _G.RequestTimePlayed()
end

local dataobj = LibStub("LibDataBroker-1.1"):NewDataObject("PlayedTime", {
	type = "data source",
	--icon = "Interface\\AddOns\\ChocolateBar\\pics\\ChocolatePiece",
	label = "Played Time",
	text  = "---",
	enabled = true,
})

acetimer:ScheduleTimer(function()
			debug("ScheduleTimer")
			RequestTimePlayed()
		end, 60)	

function dataobj:OnTooltipShow()
RequestTimePlayed()
	self:AddLine("PlayedTime")
	local totaltime = 0
	for k, v in pairs(db) do
			local time = v.total and v.total or 1
			--self:AddLine(string.format("%s: %s", k, formatTime(time)))
			self:AddDoubleLine(k, formatTime(time), 1, 1, 1, 1, 1, 1)
			totaltime = totaltime + time
	end
	self:AddLine(" ")
	self:AddLine(string.format("Total: %s", formatTime(totaltime)))
end

local function getPlayerIdentifier()
  local _, engClass, _, _, _, name, server = GetPlayerInfoByGUID(UnitGUID("player"))
  return string.format("%s-%s", name, server)
end

local function playedTimeEvent(self, event, totalTimeInSeconds, timeAtThisLevel)
	if not db[getPlayerIdentifier()] then db[getPlayerIdentifier()] = {} end
	local dbChar = db[getPlayerIdentifier()]
	local days = totalTimeInSeconds / 3600 / 24
	dbChar.total = totalTimeInSeconds
	dataobj.text  =  string.format("Played: %s", formatTime(totalTimeInSeconds))
end

function formatTime(time)
  local days = floor(time/86400)
  local hours = floor(mod(time, 86400)/3600)
  local minutes = floor(mod(time,3600)/60)
  return format("%d days %d hours %d minutes", days, hours, minutes)
end

local function onEnteringWorld()
	db = CB_PlayedTime and CB_PlayedTime or {}
	CB_PlayedTime = db
	RequestTimePlayed()
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
local frame2 = CreateFrame("Frame")
frame2:SetScript("OnEvent", onEnteringWorld)
frame2:RegisterEvent("PLAYER_ENTERING_WORLD")
