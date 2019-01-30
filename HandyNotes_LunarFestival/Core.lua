
------------------------------------------
--  This addon was heavily inspired by  --
--    HandyNotes_Lorewalkers            --
--    HandyNotes_LostAndFound           --
--  by Kemayo                           --
------------------------------------------


-- declaration
local _, LunarFestival = ...
LunarFestival.points = {}


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
	[8619]  = "Inside the dungeon.", -- Elder Morndeep, Blackrock Depths
	[8635]  = "Inside Earthsong Falls.", -- Elder Splitrock, Maraudon
	[8644]  = "Inside Lower Blackrock Spire.", -- Elder Stonefort, Lower Blackrock Spire
	[8647]  = "Speak to Zidormi at the north of the zone to gain access to this Elder.",
	[8648]  = "Speak to Zidormi in Tirisfal to gain access to The Undercity.",
	[8652]  = "Speak to Zidormi in Tirisfal to gain access to Brill.",
	[8676]  = "Inside the dungeon.", -- Elder Wildmane, Zul'Farrak
	[8713]  = "Inside the dungeon.", -- Elder Starsong, Sunken Temple
	[8715]  = "Speak to Zidormi in Darkshore to gain access to Teldrassil.",
	[8718]  = "Speak to Zidormi in Darkshore to gain access to Darnassus.",
	[8721]  = "Speak to Zidormi in Darkshore to gain access to Lor'danel.",
	[8727]  = "Inside the dungeon.", -- Elder Farwhisper, Stratholme
	[13017] = "Inside the dungeon.", -- Elder Jarten, Utgarde Keep
	[13021] = "Inside the dungeon.", -- Elder Igasho, The Nexus
	[13022] = "Inside the dungeon.", -- Elder Nurgen, Azjol-Nerub
	[13023] = "Inside the dungeon.", -- Elder Kilias, Drak'Tharon Keep
	[13065] = "Inside the dungeon.", -- Elder Ohanzee, Gundrak
	[13066] = "Inside the dungeon.", -- Elder Yurauk, Halls of Stone
	[13067] = "Inside the dungeon.", -- Elder Chogan'gada, Utgarde Pinnacle
}

-- upvalues
local _G = getfenv(0)

local C_Timer_NewTicker = _G.C_Timer.NewTicker
local C_Calendar = _G.C_Calendar
local GameTooltip = _G.GameTooltip
local GetAchievementCriteriaInfo = _G.GetAchievementCriteriaInfo
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
local points = LunarFestival.points


-- plugin handler for HandyNotes
function LunarFestival:OnEnter(mapFile, coord)
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

	if self:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	local point = points[mapFile] and points[mapFile][coord]
	local nameOfElder = GetAchievementCriteriaInfo(point[2], point[3])

	tooltip:SetText(nameOfElder)

	if notes[point[1]] then
		tooltip:AddLine(notes[point[1]])
		tooltip:AddLine(" ")
	end

	if TomTom then
		tooltip:AddLine("Right-click to set a waypoint.", 1, 1, 1)
		tooltip:AddLine("Control-Right-click to set waypoints to every Elder.", 1, 1, 1)
	end

	tooltip:Show()
end

function LunarFestival:OnLeave()
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end


local function createWaypoint(mapFile, coord)
	local x, y = HandyNotes:getXY(coord)
	local point = points[mapFile] and points[mapFile][coord]
	local nameOfElder = GetAchievementCriteriaInfo(point[2], point[3])

	TomTom:AddWaypoint(mapFile, x, y, { title = nameOfElder, persistent = nil, minimap = true, world = true })
end

local function createAllWaypoints()
	for mapFile, coords in next, points do
		if not continents[mapFile] then
		for coord, questID in next, coords do
			if coord and (db.completed or not completedQuests[questID[1]]) then
				createWaypoint(mapFile, coord)
			end
		end
		end
	end
	TomTom:SetClosestWaypoint()
end

function LunarFestival:OnClick(button, down, mapFile, coord)
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
		if not LunarFestival.isEnabled then return end
		if not t then return end

		local coord, value = next(t, prev)
		while coord do
			if value and (db.completed or not completedQuests[value[1]]) then
				local icon = value[4] and "interface\\icons\\spell_hunter_lonewolf" or "interface\\icons\\inv_misc_elvencoins"
				return coord, nil, icon, db.icon_scale, db.icon_alpha
			end

			coord, value = next(t, coord)
		end
	end

	function LunarFestival:GetNodes2(mapID, minimap)
		return iterator, points[mapID]
	end
end


-- config
local options = {
	type = "group",
	name = "春节长者", --"Lunar Festival",
	desc = "春节长者地图位置.", --"Lunar Festival elder NPC locations"
	get = function(info) return db[info[#info]] end,
	set = function(info, v)
		db[info[#info]] = v
		LunarFestival:Refresh()
	end,
	args = {
		desc = {
			name = "These settings control the look and feel of the icon.",
			type = "description",
			order = 1,
		},
		completed = {
			name = "Show completed",
			desc = "Show icons for elder NPCs you have already visited.",
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
	local calendar = C_Calendar.GetDate()
	local month, day, year = calendar.month, calendar.monthDay, calendar.year

	local monthInfo = C_Calendar.GetMonthInfo()
	local curMonth, curYear = monthInfo.month, monthInfo.year

	local monthOffset = -12 * (curYear - year) + month - curMonth
	local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)

	for i=1, numEvents do
		local event = C_Calendar.GetDayEvent(monthOffset, day, i)

		if event.iconTexture == 235469 or event.iconTexture == 235470 or event.iconTexture == 235471 then
			local hour = tonumber(date("%H"))

			if event.sequenceType == "ONGOING" or (event.sequenceType == "END" and hour <= event.endTime.hour) or (event.sequenceType == "START" and hour >= event.startTime.hour) then
				setEnabled = true
			else
				setEnabled = false
			end
		end
	end

	if setEnabled and not LunarFestival.isEnabled then
		completedQuests = GetQuestsCompleted(completedQuests)

		LunarFestival.isEnabled = true
		LunarFestival:Refresh()
		LunarFestival:RegisterEvent("QUEST_TURNED_IN", "Refresh")

		HandyNotes:Print("春节开始了，长者的位置已经在地图上标记出来了.")
	elseif not setEnabled and LunarFestival.isEnabled then
		LunarFestival.isEnabled = false
		LunarFestival:Refresh()
		LunarFestival:UnregisterAllEvents()

		HandyNotes:Print("春节结束了，明年再见!")
	end
end


-- initialise
function LunarFestival:OnEnable()
	self.isEnabled = false

	local HereBeDragons = LibStub("HereBeDragons-2.0", true)
	if not HereBeDragons then
		HandyNotes:Print("Your installed copy of HandyNotes is out of date and the Lunar Festival plug-in will not work correctly.  Please update HandyNotes to version 1.5.0 or newer.")
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

	local calendar = C_Calendar.GetDate()
	C_Calendar.SetAbsMonth(calendar.month, calendar.year)

	C_Timer_NewTicker(15, CheckEventActive)
	HandyNotes:RegisterPluginDB("LunarFestival", self, options)

	db = LibStub("AceDB-3.0"):New("HandyNotes_LunarFestivalDB", defaults, "Default").profile
end

function LunarFestival:Refresh(_, questID)
	if questID then completedQuests[questID] = true end
	self:SendMessage("HandyNotes_NotifyUpdate", "LunarFestival")
end


-- activate
LibStub("AceAddon-3.0"):NewAddon(LunarFestival, "HandyNotes_LunarFestival", "AceEvent-3.0")
