
------------------------------------------
--  This addon was heavily inspired by  --
--    HandyNotes_Lorewalkers            --
--    HandyNotes_LostAndFound           --
--  by Kemayo                           --
------------------------------------------


-- declaration
local _, SummerFestival = ...
SummerFestival.points = {}


-- our db and defaults
local db
local defaults = { profile = { completed = false, icon_scale = 1.4, icon_alpha = 0.8 } }

local continents = {
	[12]  = true, -- Kalimdor
	[13]  = true, -- Eastern Kingdoms
	[101] = true, -- Outland
	[113] = true, -- Northrend
	[424] = true, -- Pandaria
	[572] = true, -- Draenor
	[619] = true, -- Broken Isles
	[875] = true, -- Zandalar
	[876] = true, -- Kul Tiras
}

local notes = {
	-- Blasted Lands
	["11737"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire.",
	["11808"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire.",
	["28917"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire.",
	["28930"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire.",

	-- Darkshore
	["11740"] = "Speak to Zidormi in Darkshore to gain access to Lor'danel.",
	["11811"] = "Speak to Zidormi in Darkshore to gain access to Lor'danel.",

	-- Silithus
	["11760"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire.",
	["11800"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire.",
	["11831"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire.",
	["11836"] = "Speak to Zidormi at the north of the zone to gain access to this bonfire.",

	-- Teldrassil
	["9332"]  = "Speak to Zidormi in Darkshore to gain access to Darnassus.",
	["11753"] = "Speak to Zidormi in Darkshore to gain access to Teldrassil.",
	["11824"] = "Speak to Zidormi in Darkshore to gain access to Teldrassil.",

	-- Tirisfal Glades
	["9326"]  = "Speak to Zidormi in Tirisfal to gain access to The Undercity.",
	["11786"] = "Speak to Zidormi in Tirisfal to gain access to Brill.",
	["11862"] = "Speak to Zidormi in Tirisfal to gain access to Brill.",
}


-- upvalues
local C_Timer_After = C_Timer.After
local C_Calendar = C_Calendar
local GameTooltip = GameTooltip
local GetGameTime = GetGameTime
local GetQuestsCompleted = GetQuestsCompleted
local IsControlKeyDown = IsControlKeyDown
local LibStub = LibStub
local next = next
local UIParent = UIParent

local HandyNotes = HandyNotes
local TomTom = TomTom

local completedQuests = {}
local points = SummerFestival.points


-- plugin handler for HandyNotes
function SummerFestival:OnEnter(mapFile, coord)
	if self:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	local point = points[mapFile] and points[mapFile][coord]
	local text
	local questID, mode = point:match("(%d+):(.*)")

	if mode == "H" then -- honour the flame
		text = "祭拜这团火焰" --"Honour the Flame"
	elseif mode == "D" then -- desecrate this fire
		text = "亵渎这团火焰" --"Desecrate this Fire"
	elseif mode == "C" then -- stealing the enemy's flame
		text = "偷取城市火焰" --"Capture the City's Flame"
	end

	GameTooltip:SetText(text)

	if notes[questID] then
		GameTooltip:AddLine(notes[questID])
		GameTooltip:AddLine(" ")
	end

	if TomTom then
		GameTooltip:AddLine("右键点击设置TomTom路径点.", 1, 1, 1)
		GameTooltip:AddLine("Ctrl右键设置全部篝火路径点.", 1, 1, 1)
	end

	GameTooltip:Show()
end

function SummerFestival:OnLeave()
	GameTooltip:Hide()
end


local function createWaypoint(mapFile, coord)
	local x, y = HandyNotes:getXY(coord)
	local point = points[mapFile] and points[mapFile][coord]

	TomTom:AddWaypoint(mapFile, x, y, { title = "Midsummer Bonfire", persistent = nil, minimap = true, world = true })
end

local function createAllWaypoints()
	local questID, mode

	for mapFile, coords in next, points do
		if not continents[mapFile] then
		for coord, value in next, coords do
			questID, mode = value:match("(%d+):(.*)")

			if coord and (db.completed or not completedQuests[tonumber(questID)]) then
				createWaypoint(mapFile, coord)
			end
		end
		end
	end
	TomTom:SetClosestWaypoint()
end

function SummerFestival:OnClick(button, down, mapFile, coord)
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
	local function iterator(t, prev)
		if not SummerFestival.isEnabled then return end
		if not t then return end

		local coord, value = next(t, prev)
		while coord do
			local questID, mode = value:match("(%d+):(.*)")
			local icon

			if mode == "H" then -- honour the flame
				icon = "interface\\icons\\inv_summerfest_firespirit"
			elseif mode == "D" then -- desecrate this fire
				icon = "interface\\icons\\spell_fire_masterofelements"
			elseif mode == "C" then -- stealing the enemy's flame
				icon = "interface\\icons\\spell_fire_flameshock"
			end

			if value and (db.completed or not completedQuests[tonumber(questID)]) then
				return coord, nil, icon, db.icon_scale, db.icon_alpha
			end

			coord, value = next(t, coord)
		end
	end

	function SummerFestival:GetNodes2(mapID, minimap)
		return iterator, points[mapID]
	end
end


-- config
local options = {
	type = "group",
	name = "仲夏节", --""Midsummer Festival",
	desc = "仲夏节篝火位置", --"Midsummer Fesitval bonfire locations.",
	get = function(info) return db[info[#info]] end,
	set = function(info, v)
		db[info[#info]] = v
		SummerFestival:Refresh()
	end,
	args = {
		desc = {
			name = "These settings control the look and feel of the icon.",
			type = "description",
			order = 1,
		},
		completed = {
			name = "Show completed",
			desc = "Show icons for bonfires you have already visited.",
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
	local calendar = C_DateAndTime.GetCurrentCalendarTime()
	local month, day, year = calendar.month, calendar.monthDay, calendar.year

	local monthInfo = C_Calendar.GetMonthInfo()
	local curMonth, curYear = monthInfo.month, monthInfo.year

	local monthOffset = -12 * (curYear - year) + month - curMonth
	local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)

	for i=1, numEvents do
		local event = C_Calendar.GetDayEvent(monthOffset, day, i)

		if event.iconTexture == 235472 or event.iconTexture == 235473 or event.iconTexture == 235474 then
			local hour, minute = GetGameTime()

			setEnabled = event.sequenceType == "ONGOING" -- or event.sequenceType == "INFO"

			if event.sequenceType == "START" then
				setEnabled = hour >= event.startTime.hour and (hour > event.startTime.hour or minute >= event.startTime.minute)
			elseif event.sequenceType == "END" then
				setEnabled = hour <= event.endTime.hour and (hour < event.endTime.hour or minute <= event.endTime.minute)
			end
		end
	end

	if setEnabled and not SummerFestival.isEnabled then
		completedQuests = GetQuestsCompleted(completedQuests)

		SummerFestival.isEnabled = true
		SummerFestival:Refresh()
		SummerFestival:RegisterEvent("QUEST_TURNED_IN", "Refresh")

		HandyNotes:Print("仲夏节开始了! 篝火位置已经标记在了地图上.")
	elseif not setEnabled and SummerFestival.isEnabled then
		SummerFestival.isEnabled = false
		SummerFestival:Refresh()
		SummerFestival:UnregisterAllEvents()

		HandyNotes:Print("The Midsummer Fire Festival has ended.  See you next year!")
	end
end

local function RepeatingCheck()
	CheckEventActive()
	C_Timer_After(60, RepeatingCheck)
end


-- initialise
function SummerFestival:OnEnable()
	self.isEnabled = false

	local HereBeDragons = LibStub("HereBeDragons-2.0", true)
	if not HereBeDragons then
		HandyNotes:Print("Your installed copy of HandyNotes is out of date and the Summer Festival plug-in will not work correctly.  Please update HandyNotes to version 1.5.0 or newer.")
		return
	end

	for continentMapID in next, continents do
		local children = C_Map.GetMapChildrenInfo(continentMapID)
		for _, map in next, children do
			local coords = points[map.mapID]
			if coords then
				for coord, criteria in next, coords do
					local mx, my = HandyNotes:getXY(coord)
					local cx, cy = HereBeDragons:TranslateZoneCoordinates(mx, my, map.mapID, continentMapID)
					if cx and cy then
						points[continentMapID] = points[continentMapID] or {}
						points[continentMapID][HandyNotes:getCoord(cx, cy)] = criteria
					end
				end
			end
		end
	end

	-- special treatment for Teldrassil as the HereBeDragons-2.0 library isn't recognising it as a "child zone" of Kalimdor at the moment
	if UnitFactionGroup("player") == "Alliance" then
		points[12][43611031] = "11824:H" -- Dolanaar
	elseif UnitFactionGroup("player") == "Horde" then
		points[12][43541026] = "11753:D" -- Dolanaar
		points[12][40370935] = "9332:C"  -- Stealing Darnassus' Flame
	end

	local calendar = C_DateAndTime.GetCurrentCalendarTime()
	C_Calendar.SetAbsMonth(calendar.month, calendar.year)
	CheckEventActive()

	HandyNotes:RegisterPluginDB("SummerFestival", self, options)
	db = LibStub("AceDB-3.0"):New("HandyNotes_SummerFestivalDB", defaults, "Default").profile

	self:RegisterEvent("CALENDAR_UPDATE_EVENT", CheckEventActive)
	self:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST", CheckEventActive)
	self:RegisterEvent("ZONE_CHANGED", CheckEventActive)

	C_Timer_After(60, RepeatingCheck)
end

function SummerFestival:Refresh(_, questID)
	if questID then completedQuests[questID] = true end
	self:SendMessage("HandyNotes_NotifyUpdate", "SummerFestival")
end


-- activate
LibStub("AceAddon-3.0"):NewAddon(SummerFestival, "HandyNotes_SummerFestival", "AceEvent-3.0")
