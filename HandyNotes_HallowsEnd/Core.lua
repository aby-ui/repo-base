
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

local standingWithAldor, standingWithScryers

local continents = {
	[12]  = true, -- Kalimdor
	[13]  = true, -- Eastern Kingdoms
	[101] = true, -- Outland
	[113] = true, -- Northrend
	[203] = true, -- Vashj'ir
	[224] = true, -- Stranglethorn Vale
	[424] = true, -- Pandaria
	[572] = true, -- Draenor
	[619] = true, -- Broken Isles
	[875] = true, -- Zandalar
	[876] = true, -- Kul Tiras
	[947] = true, -- Azeroth
}

local notes = {
	[12331] = "和黑海岸的希多尔米对话可以回到泰达希尔.",
	[12334] = "和黑海岸的希多尔米对话可以回到泰达希尔.",
	[12340] = "如果哨兵岭着火了，糖果罐在塔里，否则在旅馆里.",
	[12349] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Theramore Isle, Alliance
	[12363] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Brill, Horde
	[12368] = "和提瑞斯法的希多尔米对话可以回到幽暗城.",
	[12380] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Hammerfall, Horde
	[12401] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Cenarion Hold, Silithus
	[13472] = "在下面的酒馆里.",	
	[28954] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Refuge Pointe, Alliance
	[28959] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Dreadmaul Hold, Horde
	[28960] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Nethergarde Keep, Alliance
	[32022] = "烈酒窖二楼.",
	[39657] = "需要3层要塞.", -- Frostwall/Lunarfall Garrison
}

-- upvalues
local C_Calendar = _G.C_Calendar
local C_DateAndTime = _G.C_DateAndTime
local C_Map = _G.C_Map
local C_Timer_After = _G.C_Timer.After
local GameTooltip = _G.GameTooltip
local GetFactionInfoByID = _G.GetFactionInfoByID
local GetGameTime = _G.GetGameTime
local GetQuestsCompleted = _G.GetQuestsCompleted
local IsControlKeyDown = _G.IsControlKeyDown
local LibStub = _G.LibStub
local UIParent = _G.UIParent
local UnitFactionGroup = _G.UnitFactionGroup

local HandyNotes = _G.HandyNotes
local TomTom = _G.TomTom

local completedQuests = {}
local points = HallowsEnd.points


-- plugin handler for HandyNotes
function HallowsEnd:OnEnter(mapFile, coord)
	local point = points[mapFile] and points[mapFile][coord]

	if self:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	GameTooltip:SetText("万圣节糖罐")

	if notes[point] then
		GameTooltip:AddLine(notes[point])
		GameTooltip:AddLine(" ")
	end

	if false and TomTom then
		GameTooltip:AddLine("右键设置TomTom路径指示.", 1, 1, 1)
		GameTooltip:AddLine("Ctrl右键把所有糖罐位置加入路径.", 1, 1, 1)
	end

	GameTooltip:Show()
end

function HallowsEnd:OnLeave()
		GameTooltip:Hide()
end


local function createWaypoint(mapID, coord)
	local x, y = HandyNotes:getXY(coord)
	TomTom:AddWaypoint(mapID, x, y, { title = "万圣节糖罐", persistent = nil, minimap = true, world = true })
end

local function createAllWaypoints()
	for mapFile, coords in next, points do
		if not continents[mapFile] then
		for coord, questID in next, coords do
			if coord and (db.completed or not completedQuests[questID]) then
				createWaypoint(mapFile, coord)
			end
		end
		end
	end
	TomTom:SetClosestWaypoint()
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
	local function iterator(t, prev)
		if not HallowsEnd.isEnabled then return end
		if not t then return end

		local coord, v = next(t, prev)
		while coord do
			if v and (db.completed or not completedQuests[v]) then
				return coord, nil, "interface\\icons\\achievement_halloween_candy_01", db.icon_scale, db.icon_alpha
			end

			coord, v = next(t, coord)
		end
	end

	function HallowsEnd:GetNodes2(mapID)
		return iterator, points[mapID]
	end
end


-- config
local options = {
	type = "group",
	name = "万圣节糖罐", --"Hallow's End",
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
	local calendar = C_DateAndTime.GetCurrentCalendarTime()
	local month, day, year = calendar.month, calendar.monthDay, calendar.year

	local monthInfo = C_Calendar.GetMonthInfo()
	local curMonth, curYear = monthInfo.month, monthInfo.year

	local monthOffset = -12 * (curYear - year) + month - curMonth
	local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)

	for i=1, numEvents do
		local event = C_Calendar.GetDayEvent(monthOffset, day, i)

		if event.iconTexture == 235460 or event.iconTexture == 235461 or event.iconTexture == 235462 then
			local hour, minute = GetGameTime()

			setEnabled = event.sequenceType == "ONGOING" -- or event.sequenceType == "INFO"

			if event.sequenceType == "START" then
				setEnabled = hour >= event.startTime.hour and (hour > event.startTime.hour or minute >= event.startTime.minute)
			elseif event.sequenceType == "END" then
				setEnabled = hour <= event.endTime.hour and (hour < event.endTime.hour or minute <= event.endTime.minute)
			end
		end
	end

	if setEnabled and not HallowsEnd.isEnabled then
		completedQuests = GetQuestsCompleted(completedQuests)

		-- special treatment for Westfall
		if UnitFactionGroup("player") == "Alliance" and completedQuests[26322] then
			points[52] = { [56824732] = 12340 } -- if Sentinel Hill is on fire, the bucket is in the tower instead of the inn
		end

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
end

local function RepeatingCheck()
	CheckEventActive()
	C_Timer_After(60, RepeatingCheck)
end


-- initialise
function HallowsEnd:OnEnable()
	self.isEnabled = false

	local HereBeDragons = LibStub("HereBeDragons-2.0", true)
	if not HereBeDragons then
		HandyNotes:Print("Your installed copy of HandyNotes is out of date and the Hallow's End plug-in will not work correctly.  Please update HandyNotes to version 1.5.0 or newer.")
		return
	end

	-- special treatment for Aldor/Scryers
	_, _, standingWithAldor = GetFactionInfoByID(932)
	_, _, standingWithScryers = GetFactionInfoByID(934)

	-- hated by Aldor
	if standingWithAldor <= 4 then
		points[104][56305980] = 12409 -- Sanctum of the Stars
		points[111][56208180] = 12404 -- Scryer's Tier
	end

	-- hated by Scryers
	if standingWithScryers <= 4 then
		points[104][61002820] = 12409 -- Altar of Sha'tar
		points[111][28104900] = 12404 -- Aldor Rise
	end

	for continentMapID in next, continents do
		local children = C_Map.GetMapChildrenInfo(continentMapID, nil, true)
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

	local calendar = C_DateAndTime.GetCurrentCalendarTime()
	C_Calendar.SetAbsMonth(calendar.month, calendar.year)
	CheckEventActive()

	HandyNotes:RegisterPluginDB("HallowsEnd", self, options)
	db = LibStub("AceDB-3.0"):New("HandyNotes_HallowsEndDB", defaults, "Default").profile

	self:RegisterEvent("CALENDAR_UPDATE_EVENT", CheckEventActive)
	self:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST", CheckEventActive)
	self:RegisterEvent("ZONE_CHANGED", CheckEventActive)

	C_Timer_After(60, RepeatingCheck)
end

function HallowsEnd:Refresh(_, questID)
	if questID then completedQuests[questID] = true end
	self:SendMessage("HandyNotes_NotifyUpdate", "HallowsEnd")
end


-- activate
LibStub("AceAddon-3.0"):NewAddon(HallowsEnd, "HandyNotes_HallowsEnd", "AceEvent-3.0")
