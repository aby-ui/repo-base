
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
	[12340] = "如果哨兵岭着火了，糖果罐在塔里，否则在旅馆里.",
	[12349] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Theramore Isle, Alliance
	[28959] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Dreadmaul Hold, Horde
	[28960] = "如果你找不到糖果罐，与时间守护者对话回到过去.", -- Nethergarde Keep, Alliance
	[39657] = "需要3层要塞.", -- Frostwall/Lunarfall Garrison
}

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
	local point = points[mapFile] and points[mapFile][coord]
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

	if self:GetCenter() > UIParent:GetCenter() then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	tooltip:SetText("万圣节糖罐")

	if notes[point] then
		tooltip:AddLine(notes[point])
		tooltip:AddLine(" ")
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


local function createWaypoint(mapID, coord)
	local x, y = HandyNotes:getXY(coord)
	TomTom:AddWaypoint(mapID, x, y, { title = "万圣节糖罐", persistent = nil, minimap = true, world = true })
end

local function createAllWaypoints()
	for mapID, coords in next, points do
		for coord, questID in next, coords do
			if coord and (db.completed or not completedQuests[questID]) then
				createWaypoint(mapID, coord)
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

	function HallowsEnd:GetNodes2(mapID, minimap)
		return iterator, points[mapID]
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


-- initialise
function HallowsEnd:OnEnable()
	self.isEnabled = false

	local HereBeDragons = LibStub("HereBeDragons-2.0", true)
	if not HereBeDragons then
		HandyNotes:Print("Your installed copy of HandyNotes is out of date and the Hallow's End plug-in will not work correctly.  Please update HandyNotes to version 1.5.0 or newer.")
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
