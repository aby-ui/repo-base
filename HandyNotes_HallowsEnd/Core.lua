
------------------------------------------
--  This addon was heavily inspired by  --
--    HandyNotes_Lorewalkers            --
--    HandyNotes_LostAndFound           --
--  by Kemayo                           --
------------------------------------------


-- declaration
local _, HallowsEnd = ...
HallowsEnd.points = {}


-- our db and defaults
local db
local defaults = { profile = { completed = false, icon_scale = 1.4, icon_alpha = 0.8 } }


-- upvalues
local _G = getfenv(0)

local C_Timer_NewTicker = _G.C_Timer.NewTicker
local C_Calendar = _G.C_Calendar
local GameTooltip = _G.GameTooltip
local GetGameTime = _G.GetGameTime
local GetQuestsCompleted = _G.GetQuestsCompleted
local gsub = _G.string.gsub
local IsControlKeyDown = _G.IsControlKeyDown
local LibStub = _G.LibStub
local next = _G.next
local UIParent = _G.UIParent
local WorldMapButton = _G.WorldMapButton
local WorldMapTooltip = _G.WorldMapTooltip

local HandyNotes = _G.HandyNotes
local TomTom = _G.TomTom

local completedQuests = {}
local points = HallowsEnd.points


-- plugin handler for HandyNotes
function HallowsEnd:OnEnter(mapFile, coord)
	mapFile = gsub(mapFile, "_terrain%d+$", "")

	local point = points[mapFile] and points[mapFile][coord]
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

	if self:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	if point == "Zidormi" then
		tooltip:SetText("希多尔米")
		tooltip:AddLine("如果你找不到糖果罐，与时间守护者对话回到过去.", 1, 1, 1)
		tooltip:AddLine(" ")
	else
		tooltip:SetText("万圣节糖罐")
	end

	if false and TomTom then
		tooltip:AddLine("右键设置TomTom路径指示.", 1, 1, 1)
		tooltip:AddLine("Control-Right-click to set waypoints to every bucket.", 1, 1, 1)
	end

	tooltip:Show()
end

function HallowsEnd:OnLeave()
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end


local function createWaypoint(mapFile, coord)
	local x, y = HandyNotes:getXY(coord)
	local m = HandyNotes:GetMapFiletoMapID(mapFile)

	if m then
		TomTom:AddMFWaypoint(m, nil, x, y, { title = "万圣节糖罐" })
		TomTom:SetClosestWaypoint()
--	else
--		print(mapFile, m, x, y)
	end
end

local function createAllWaypoints()
	for mapFile, coords in next, points do
		for coord, questID in next, coords do
			if coord and questID ~= "Zidormi" and (db.completed or not completedQuests[questID]) then
				createWaypoint(mapFile, coord)
			end
		end
	end
end

function HallowsEnd:OnClick(button, down, mapFile, coord)
	if TomTom and button == "RightButton" and not down then
		if IsControlKeyDown() then
			createAllWaypoints()
		else
			createWaypoint(mapFile, coord)
		end
	end
end


do
	-- custom iterator we use to iterate over every node in a given zone
	local function iter(t, prestate)
		if not HallowsEnd.isEnabled then return nil end
		if not t then return nil end

		local state, value = next(t, prestate)

		while state do -- have we reached the end of this zone?
			if value and (db.completed or not completedQuests[value]) then
				if value == "Zidormi" then
					return state, nil, "interface\\icons\\spell_holy_borrowedtime", db.icon_scale, db.icon_alpha
				else
					return state, nil, "interface\\icons\\achievement_halloween_candy_01", db.icon_scale, db.icon_alpha
				end
			end

			state, value = next(t, state) -- get next data
		end

		return nil, nil, nil, nil
	end

	local function iterCont(t, prestate)
		if not HallowsEnd.isEnabled then return nil end
		if not t then return nil end

		local zone = t.Z
		local mapFile = HandyNotes:GetMapIDtoMapFile(t.C[zone])
		local cleanMapFile = gsub(mapFile, "_terrain%d+$", "")
		local data = points[cleanMapFile]
		local state, value

		while mapFile do
			if data then -- only if there is data for this zone
				state, value = next(data, prestate)

				while state do -- have we reached the end of this zone?
					if value and (db.completed or not completedQuests[value]) then -- show on continent?
						if value == "Zidormi" then
							return state, mapFile, "interface\\icons\\spell_holy_borrowedtime", db.icon_scale, db.icon_alpha
						else
							return state, mapFile, "interface\\icons\\achievement_halloween_candy_01", db.icon_scale, db.icon_alpha
						end
					end

					state, value = next(data, state) -- get next data
				end
			end

			-- get next zone
			zone = next(t.C, zone)
			t.Z = zone
			mapFile = HandyNotes:GetMapIDtoMapFile(t.C[zone])
			cleanMapFile = gsub(mapFile or "", "_terrain%d+$", "")
			data = points[cleanMapFile]
			prestate = nil
		end
	end

	function HallowsEnd:GetNodes(mapFile)
		local C = HandyNotes:GetContinentZoneList(mapFile) -- Is this a continent?

		if C then
			local tbl = { C = C, Z = next(C) }
			return iterCont, tbl, nil
		else
			mapFile = gsub(mapFile, "_terrain%d+$", "")
			return iter, points[mapFile], nil
		end
	end
end


-- config
local options = {
	type = "group",
	name = "Hallow's End",
	desc = "Hallow's End candy bucket locations.",
	get = function(info) return db[info[#info]] end,
	set = function(info, v)
		db[info[#info]] = v
		HallowsEnd:Refresh()
	end,
	args = {
		desc = {
			name = "These settings control the look and feel of the icon.",
			type = "description",
			order = 1,
		},
		completed = {
			name = "Show completed",
			desc = "Show icons for candy buckets you have already visited.",
			type = "toggle",
			width = "full",
			arg = "completed",
			order = 2,
		},
		icon_scale = {
			type = "range",
			name = "Icon Scale",
			desc = "Change the size of the icons.",
			min = 0.25, max = 2, step = 0.01,
			arg = "icon_scale",
			order = 3,
		},
		icon_alpha = {
			type = "range",
			name = "Icon Alpha",
			desc = "Change the transparency of the icons.",
			min = 0, max = 1, step = 0.01,
			arg = "icon_alpha",
			order = 4,
		},
	},
}


-- check
local setEnabled = false
local function CheckEventActive()
	local date = C_Calendar.GetDate()
	local month, day, year = date.month, date.monthDay, date.year

	local monthInfo = C_Calendar.GetMonthInfo()
	local curMonth, curYear = monthInfo.month, monthInfo.year

	local monthOffset = -12 * (curYear - year) + month - curMonth
	local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)

	for i=1, numEvents do
		local event = C_Calendar.GetDayEvent(monthOffset, day, i)

		if event.iconTexture == 235460 or event.iconTexture == 235461 or event.iconTexture == 235462 then
			if event.sequenceType == "ONGOING" then
				setEnabled = true
			else
				local hour = GetGameTime()

				if event.sequenceType == "END" and hour <= event.endTime.hour or event.sequenceType == "START" and hour >= event.startTime.hour then
					setEnabled = true
				else
					setEnabled = false
				end
			end
		end
	end

	if setEnabled and not HallowsEnd.isEnabled then
		completedQuests = GetQuestsCompleted(completedQuests)

		HallowsEnd.isEnabled = true
		HallowsEnd:Refresh()
		HallowsEnd:RegisterEvent("QUEST_TURNED_IN", "Refresh")

		--HandyNotes:Print("万圣节活动开始了，糖罐的位置已经标记在你的地图上（破碎群岛的暂时不全）")
	elseif not setEnabled and HallowsEnd.isEnabled then
		HallowsEnd.isEnabled = false
		HallowsEnd:Refresh()
		HallowsEnd:UnregisterAllEvents()

		--HandyNotes:Print("万圣节活动结束了，明年再见!")
	end

	if UnitFactionGroup("player") == "Alliance" then
		points["Westfall"] = nil

		if completedQuests[26322] then
			-- Sentinel Hill is on fire, the bucket is in the tower
			points["Westfall"] = { [56824732] = 12340 }
		else
			-- Sentinel Hill is not on fire, the bucket is in the inn
			points["Westfall"] = { [52915374] = 12340 }
		end
	end
end


-- initialise
function HallowsEnd:OnEnable()
	self.isEnabled = false

	local HereBeDragons = LibStub("HereBeDragons-2.0", true)
	if not HereBeDragons then
		HandyNotes:Print("Your installed copy of HandyNotes is out of date and the Hallow's End plug-in will not work correctly.  Please update HandyNotes to version 1.5.0 or newer.")
		return
	end

	local date = C_Calendar.GetDate()
	C_Calendar.SetAbsMonth(date.month, date.year)

	C_Timer_NewTicker(15, CheckEventActive)
	HandyNotes:RegisterPluginDB("HallowsEnd", self, options)

	db = LibStub("AceDB-3.0"):New("HandyNotes_HallowsEndDB", defaults, "Default").profile
end

function HallowsEnd:Refresh(_, questID)
	if questID then completedQuests[questID] = true end
	self:SendMessage("HandyNotes_NotifyUpdate", "HallowsEnd")
end


-- activate
LibStub("AceAddon-3.0"):NewAddon(HallowsEnd, "HandyNotes_HallowsEnd", "AceEvent-3.0")
