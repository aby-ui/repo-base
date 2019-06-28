-- ***************************************************
-- **             DBM Range Check Frame             **
-- **         http://www.deadlybossmods.com         **
-- ***************************************************
--
-- This addon is written and copyrighted by:
--    * Paul Emmerich (Tandanu @ EU-Aegwynn) (DBM-Core)
--    * Martin Verges (Nitram @ EU-Azshara) (DBM-GUI)
--
-- The localizations are written by:
--    * enGB/enUS: Tandanu				http://www.deadlybossmods.com
--    * deDE: Tandanu					http://www.deadlybossmods.com
--    * zhCN: Diablohu					http://wow.gamespot.com.cn
--    * ruRU: BootWin					bootwin@gmail.com
--    * ruRU: Vampik					admin@vampik.ru
--    * zhTW: Hman						herman_c1@hotmail.com
--    * zhTW: Azael/kc10577				paul.poon.kw@gmail.com
--    * koKR: BlueNyx/nBlueWiz			bluenyx@gmail.com / everfinale@gmail.com
--    * esES: Snamor/1nn7erpLaY      	romanscat@hotmail.com
--
-- Special thanks to:
--    * Arta
--    * Omegal @ US-Whisperwind (continuing mod support for 3.2+)
--    * Tennberg (a lot of fixes in the enGB/enUS localization)
--
--
-- The code of this addon is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License. (see license.txt)
-- All included textures and sounds are copyrighted by their respective owners.
--
--
--  You are free:
--    * to Share ?to copy, distribute, display, and perform the work
--    * to Remix ?to make derivative works
--  Under the following conditions:
--    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
--    * Noncommercial. You may not use this work for commercial purposes.
--    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
--
--
-- This file makes use of the following free (Creative Commons Sampling Plus 1.0) sounds:
--    * alarmclockbeeps.ogg by tedthetrumpet (http://www.freesound.org/usersViewSingle.php?id=177)
--    * blip_8.ogg by Corsica_S (http://www.freesound.org/usersViewSingle.php?id=7037)
--  The full of text of the license can be found in the file "Sounds\Creative Commons Sampling Plus 1.0.txt".

---------------
--  Globals  --
---------------
DBM.RangeCheck = {}

--------------
--  Locals  --
--------------
local rangeCheck = DBM.RangeCheck
local mainFrame = CreateFrame("Frame")
local updater
local textFrame
local createTextFrame
local radarFrame
local createRadarFrame
local updateIcon
local updateRangeFrame
local dropdownFrame
local initializeDropdown
local activeRange = 0
local dots = {}
local dims

--------------------------------------------------------
--  Cache frequently used global variables in locals  --
--------------------------------------------------------
local UnitPosition = UnitPosition
local GetPlayerFacing = GetPlayerFacing
local UnitName, UnitClass, UnitIsUnit, UnitIsDeadOrGhost, UnitIsConnected, UnitInPhase, UnitAffectingCombat, UnitExists = UnitName, UnitClass, UnitIsUnit, UnitIsDeadOrGhost, UnitIsConnected, UnitInPhase, UnitAffectingCombat, UnitExists
local IsInRaid, GetNumGroupMembers, GetNumSubgroupMembers = IsInRaid, GetNumGroupMembers, GetNumSubgroupMembers
local GetRaidTargetIndex = GetRaidTargetIndex
local GetTime = GetTime
local CheckInteractDistance, IsItemInRange, UnitInRange = CheckInteractDistance, IsItemInRange, UnitInRange
local max, sin, cos, pi, pi2 = math.max, math.sin, math.cos, math.pi, math.pi * 2
local GetBestMapForUnit = C_Map.GetBestMapForUnit

-- for Phanx' Class Colors
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local BLIP_TEX_COORDS = {
	["WARRIOR"]		 = { 0, 0.125, 0, 0.25 },
	["PALADIN"]		 = { 0.125, 0.25, 0, 0.25 },
	["HUNTER"]		 = { 0.25, 0.375, 0, 0.25 },
	["ROGUE"]		 = { 0.375, 0.5, 0, 0.25 },
	["PRIEST"]		 = { 0.5, 0.625, 0, 0.25 },
	["DEATHKNIGHT"]	 = { 0.625, 0.75, 0, 0.25 },
	["SHAMAN"]		 = { 0.75, 0.875, 0, 0.25 },
	["MAGE"]		 = { 0.875, 1, 0, 0.25 },
	["WARLOCK"]		 = { 0, 0.125, 0.25, 0.5 },
	["DRUID"]		 = { 0.25, 0.375, 0.25, 0.5 },
	["MONK"]		 = { 0.125, 0.25, 0.25, 0.5 },
	["DEMONHUNTER"]	 = { 0.375, 0.5, 0.25, 0.5 },
}
---------------------
--  Dropdown Menu  --
---------------------

-- todo: this dropdown menu is somewhat ugly and unflexible....
do
	local sound0 = "none"
	local sound1 = "Interface\\AddOns\\DBM-Core\\Sounds\\blip_8.ogg"
	local sound2 = "Interface\\AddOns\\DBM-Core\\Sounds\\alarmclockbeeps.ogg"
	local function setSound(self, option, sound)
		DBM.Options[option] = sound
		if sound ~= "none" then
			DBM:PlaySoundFile(sound)
		end
	end

	local function setRange(self, range)
		rangeCheck:Hide(true)
		rangeCheck:Show(range, mainFrame.filter, true, mainFrame.redCircleNumPlayers or 1)
	end

	local function setThreshold(self, threshold)
		rangeCheck:Hide(true)
		rangeCheck:Show(mainFrame.range, mainFrame.filter, true, threshold)
	end

	local function setFrames(self, option)
		DBM.Options.RangeFrameFrames = option
		rangeCheck:Hide(true)
		rangeCheck:Show(mainFrame.range, mainFrame.filter, true, mainFrame.redCircleNumPlayers or 1)
	end

	local function toggleLocked()
		DBM.Options.RangeFrameLocked = not DBM.Options.RangeFrameLocked
	end

	function initializeDropdown(dropdownFrame, level, menu)
		local info
		if level == 1 then
			info = UIDropDownMenu_CreateInfo()
			info.text = DBM_CORE_RANGECHECK_SETRANGE
			info.notCheckable = true
			info.hasArrow = true
			info.keepShownOnClick = true
			info.menuList = "range"
			UIDropDownMenu_AddButton(info, 1)

			info = UIDropDownMenu_CreateInfo()
			info.text = DBM_CORE_RANGECHECK_SETTHRESHOLD
			info.notCheckable = true
			info.hasArrow = true
			info.keepShownOnClick = true
			info.menuList = "threshold"
			UIDropDownMenu_AddButton(info, 1)

			info = UIDropDownMenu_CreateInfo()
			info.text = DBM_CORE_RANGECHECK_SOUNDS
			info.notCheckable = true
			info.hasArrow = true
			info.keepShownOnClick = true
			info.menuList = "sounds"
			UIDropDownMenu_AddButton(info, 1)

			info = UIDropDownMenu_CreateInfo()
			info.text = DBM_CORE_RANGECHECK_OPTION_FRAMES
			info.notCheckable = true
			info.hasArrow = true
			info.keepShownOnClick = true
			info.menuList = "frames"
			UIDropDownMenu_AddButton(info, 1)

			info = UIDropDownMenu_CreateInfo()
			info.text = LOCK_FRAME
			if DBM.Options.RangeFrameLocked then
				info.checked = true
			end
			info.func = toggleLocked
			UIDropDownMenu_AddButton(info, 1)

			info = UIDropDownMenu_CreateInfo()
			info.text = HIDE
			info.notCheckable = true
			info.func = function() rangeCheck:Hide(true) end
			info.arg1 = rangeCheck
			UIDropDownMenu_AddButton(info, 1)

		elseif level == 2 then
			if menu == "range" then
				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SETRANGE_TO:format(4)
				info.func = setRange
				info.arg1 = 4
				info.checked = (mainFrame.range == 4)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SETRANGE_TO:format(6)
				info.func = setRange
				info.arg1 = 6
				info.checked = (mainFrame.range == 6)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SETRANGE_TO:format(8)
				info.func = setRange
				info.arg1 = 8
				info.checked = (mainFrame.range == 8)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SETRANGE_TO:format(10)
				info.func = setRange
				info.arg1 = 10
				info.checked = (mainFrame.range == 10)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SETRANGE_TO:format(13)
				info.func = setRange
				info.arg1 = 13
				info.checked = (mainFrame.range == 13)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SETRANGE_TO:format(18)
				info.func = setRange
				info.arg1 = 18
				info.checked = (mainFrame.range == 18)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SETRANGE_TO:format(30)
				info.func = setRange
				info.arg1 = 30
				info.checked = (mainFrame.range == 30)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SETRANGE_TO:format(43)
				info.func = setRange
				info.arg1 = 43
				info.checked = (mainFrame.range == 43)
				UIDropDownMenu_AddButton(info, 2)
			elseif menu == "threshold" then
				info = UIDropDownMenu_CreateInfo()
				info.text = 1
				info.func = setThreshold
				info.arg1 = 1
				info.checked = (mainFrame.redCircleNumPlayers == 1)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = 2
				info.func = setThreshold
				info.arg1 = 2
				info.checked = (mainFrame.redCircleNumPlayers == 2)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = 3
				info.func = setThreshold
				info.arg1 = 3
				info.checked = (mainFrame.redCircleNumPlayers == 3)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = 4
				info.func = setThreshold
				info.arg1 = 4
				info.checked = (mainFrame.redCircleNumPlayers == 4)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = 5
				info.func = setThreshold
				info.arg1 = 5
				info.checked = (mainFrame.redCircleNumPlayers == 5)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = 6
				info.func = setThreshold
				info.arg1 = 6
				info.checked = (mainFrame.redCircleNumPlayers == 6)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = 8
				info.func = setThreshold
				info.arg1 = 8
				info.checked = (mainFrame.redCircleNumPlayers == 8)
				UIDropDownMenu_AddButton(info, 2)
			elseif menu == "sounds" then
				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SOUND_OPTION_1
				info.notCheckable = true
				info.hasArrow = true
				info.menuList = "RangeFrameSound1"
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_SOUND_OPTION_2
				info.notCheckable = true
				info.hasArrow = true
				info.menuList = "RangeFrameSound2"
				UIDropDownMenu_AddButton(info, 2)
			elseif menu == "frames" then
				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_OPTION_TEXT
				info.func = setFrames
				info.arg1 = "text"
				info.checked = (DBM.Options.RangeFrameFrames == "text")
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_OPTION_RADAR
				info.func = setFrames
				info.arg1 = "radar"
				info.checked = (DBM.Options.RangeFrameFrames == "radar")
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_RANGECHECK_OPTION_BOTH
				info.func = setFrames
				info.arg1 = "both"
				info.checked = (DBM.Options.RangeFrameFrames == "both")
				UIDropDownMenu_AddButton(info, 2)
			end
		elseif level == 3 then
			local option = menu
			info = UIDropDownMenu_CreateInfo()
			info.text = DBM_CORE_RANGECHECK_SOUND_0
			info.func = setSound
			info.arg1 = option
			info.arg2 = sound0
			info.checked = (DBM.Options[option] == sound0)
			UIDropDownMenu_AddButton(info, 3)

			info = UIDropDownMenu_CreateInfo()
			info.text = DBM_CORE_RANGECHECK_SOUND_1
			info.func = setSound
			info.arg1 = option
			info.arg2 = sound1
			info.checked = (DBM.Options[option] == sound1)
			UIDropDownMenu_AddButton(info, 3)

			info = UIDropDownMenu_CreateInfo()
			info.text = DBM_CORE_RANGECHECK_SOUND_2
			info.func = setSound
			info.arg1 = option
			info.arg2 = sound2
			info.checked = (DBM.Options[option] == sound2)
			UIDropDownMenu_AddButton(info, 3)
		end
	end
end

-----------------
-- Play Sounds --
-----------------
local soundUpdate = 0
local function updateSound(num)
	if not UnitAffectingCombat("player") or (GetTime() - soundUpdate) < 5 then return end
	soundUpdate = GetTime()
	if num == 1 then
		if DBM.Options.RangeFrameSound1 ~= "none" then
			DBM:PlaySoundFile(DBM.Options.RangeFrameSound1)
		end
	elseif num > 1 then
		if DBM.Options.RangeFrameSound2 ~= "none" then
			DBM:PlaySoundFile(DBM.Options.RangeFrameSound2)
		end
	end
end

------------------------
--  Create the frame  --
------------------------
local frameBackdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	tile = true,
	tileSize = 16,
	insets = { left = 2, right = 14, top = 2, bottom = 2 },
}

function createTextFrame()
	local elapsed = 0
	local textFrame = CreateFrame("GameTooltip", "DBMRangeCheck", UIParent, "GameTooltipTemplate")
	dropdownFrame = CreateFrame("Frame", "DBMRangeCheckDropdown", textFrame, "UIDropDownMenuTemplate")
	textFrame:SetFrameStrata("DIALOG")
	textFrame:SetBackdrop(frameBackdrop)
	textFrame:SetPoint(DBM.Options.RangeFramePoint, UIParent, DBM.Options.RangeFramePoint, DBM.Options.RangeFrameX, DBM.Options.RangeFrameY)
	textFrame:SetHeight(64)
	textFrame:SetWidth(64)
	textFrame:EnableMouse(true)
	textFrame:SetToplevel(true)
	textFrame:SetMovable(1)
	GameTooltip_OnLoad(textFrame)
	textFrame:SetPadding(16, 0)
	textFrame:RegisterForDrag("LeftButton")
	textFrame:SetScript("OnDragStart", function(self)
		if not DBM.Options.RangeFrameLocked then
			self:StartMoving()
		end
	end)
	textFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		--ValidateFramePosition(self)
		local point, _, _, x, y = self:GetPoint(1)
		DBM.Options.RangeFrameX = x
		DBM.Options.RangeFrameY = y
		DBM.Options.RangeFramePoint = point
	end)
	textFrame:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			UIDropDownMenu_Initialize(dropdownFrame, initializeDropdown)
			ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 5, -10)
		end
	end)
	return textFrame
end

function createRadarFrame()
	local radarFrame = CreateFrame("Frame", "DBMRangeCheckRadar", UIParent)
	radarFrame:SetFrameStrata("DIALOG")
	radarFrame:SetPoint(DBM.Options.RangeFrameRadarPoint, UIParent, DBM.Options.RangeFrameRadarPoint, DBM.Options.RangeFrameRadarX, DBM.Options.RangeFrameRadarY)
	radarFrame:SetHeight(128)
	radarFrame:SetWidth(128)
	radarFrame:EnableMouse(true)
	radarFrame:SetToplevel(true)
	radarFrame:SetMovable(1)
	radarFrame:RegisterForDrag("LeftButton")
	radarFrame:SetScript("OnDragStart", function(self)
		if not DBM.Options.RangeFrameLocked then
			self:StartMoving()
		end
	end)
	radarFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		--ValidateFramePosition(self)
		local point, _, _, x, y = self:GetPoint(1)
		DBM.Options.RangeFrameRadarX = x
		DBM.Options.RangeFrameRadarY = y
		DBM.Options.RangeFrameRadarPoint = point
	end)
	radarFrame:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			UIDropDownMenu_Initialize(dropdownFrame, initializeDropdown)
			ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 5, -10)
		end
	end)

	local bg = radarFrame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(radarFrame)
	bg:SetBlendMode("BLEND")
	bg:SetColorTexture(0, 0, 0, 0.3)
	radarFrame.background = bg

	local circle = radarFrame:CreateTexture(nil, "ARTWORK")
	circle:SetSize(85, 85)
	circle:SetPoint("CENTER")
	circle:SetTexture("Interface\\AddOns\\DBM-Core\\textures\\radar_circle.blp")
	circle:SetVertexColor(0, 1, 0)
	circle:SetBlendMode("ADD")
	radarFrame.circle = circle

	local player = radarFrame:CreateTexture(nil, "OVERLAY")
	player:SetSize(32, 32)
	player:SetTexture(136431)--"Interface\\Minimap\\MinimapArrow.blp"
	player:SetBlendMode("ADD")
	player:SetPoint("CENTER")

	local text = radarFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	text:SetWidth(128)
	text:SetHeight(15)
	text:SetPoint("BOTTOMLEFT", radarFrame, "TOPLEFT", 0,0)
	text:SetTextColor(1, 1, 1, 1)
	text:Show()
	radarFrame.text = text

	local inRangeText = radarFrame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	inRangeText:SetWidth(128)
	inRangeText:SetHeight(15)
	inRangeText:SetPoint("TOPLEFT", radarFrame, "BOTTOMLEFT", 0,0)
	inRangeText:SetTextColor(1, 1, 1, 1)
	inRangeText:Hide()
	radarFrame.inRangeText = inRangeText

	for i = 1, 40 do
		local dot = radarFrame:CreateTexture(nil, "OVERLAY")
		dot:SetSize(24, 24)
		dot:SetTexture(249183)--"Interface\\Minimap\\PartyRaidBlips"
		dot:Hide()
		dots[i] = dot
	end

	radarFrame:Hide()
	return radarFrame
end

----------------
--  OnUpdate  --
----------------
do
	local rotation, pixelsperyard, activeDots, numPlayers, circleColor, prevRange, prevThreshold, prevNumClosePlayer, prevclosestRange, prevColor, prevType = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	local unitList = {}

	local function setDot(id, sinTheta, cosTheta)
		local dot = dots[id]
		local x = dots[id].x
		local y = dots[id].y
		local range = dots[id].range
		if range < (activeRange * 1.5) then -- if person is closer than 1.5 * range, show the dot. Else hide it
			local dx = ((x * cosTheta) - (-y * sinTheta)) * pixelsperyard -- Rotate the X,Y based on player facing
			local dy = ((x * sinTheta) + (-y * cosTheta)) * pixelsperyard
			dot:ClearAllPoints()
			dot:SetPoint("CENTER", radarFrame, "CENTER", dx, dy)
			if not dot.isShown then
				dot.isShown = true
				dot:Show()
			end
		elseif dot.isShown then
			dot.isShown = nil
			dot:Hide()
		end
	end

	function updateIcon()
		numPlayers = GetNumGroupMembers()
		activeDots = max(numPlayers, activeDots)
		for i = 1, activeDots do
			local dot = dots[i]
			if i <= numPlayers then
				unitList[i] = IsInRaid() and "raid"..i or "party"..i
				local uId = unitList[i]
				local _, class = UnitClass(uId)
				local icon = GetRaidTargetIndex(uId)
				dot.class = class
				if icon and icon < 9 then
					dot.icon = icon
					--137001-137008
					dot:SetTexture(13700 .. icon)--format("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d", icon)
					dot:SetTexCoord(0, 1, 0, 1)
					dot:SetSize(16, 16)
					dot:SetDrawLayer("OVERLAY", 1)
				else
					dot.icon = nil
					class = class or "PRIEST"
					local c = RAID_CLASS_COLORS[class]
					dot:SetTexture(249183)--"Interface\\Minimap\\PartyRaidBlips"
					dot:SetTexCoord(BLIP_TEX_COORDS[class][1], BLIP_TEX_COORDS[class][2], BLIP_TEX_COORDS[class][3], BLIP_TEX_COORDS[class][4])
					dot:SetSize(24, 24)
					dot:SetDrawLayer("OVERLAY", 0)
				end
			elseif dot.isShown then
				dot.isShown = nil
				dot:Hide()
			end
		end
	end

	function updateRangeFrame()
		if mainFrame.hideTime > 0 and GetTime() > mainFrame.hideTime then
			rangeCheck:Hide()
			return
		end
		activeRange = mainFrame.range
		local restricted = mainFrame.restrictions
		local tEnabled = textFrame.isShown
		local rEnabled = radarFrame.isShown
		local reverse = mainFrame.reverse
		local warnThreshold = mainFrame.redCircleNumPlayers
		if tEnabled then
			textFrame:ClearLines()
			if reverse then
				if warnThreshold > 1 then
					textFrame:SetText(DBM_CORE_RANGECHECK_RHEADERT:format(activeRange, warnThreshold), 1, 1, 1)
				else
					textFrame:SetText(DBM_CORE_RANGECHECK_RHEADER:format(activeRange), 1, 1, 1)
				end
			else
				if warnThreshold > 1 then
					textFrame:SetText(DBM_CORE_RANGECHECK_HEADERT:format(activeRange, warnThreshold), 1, 1, 1)
				else
					textFrame:SetText(DBM_CORE_RANGECHECK_HEADER:format(activeRange), 1, 1, 1)
				end
			end
		end
		if rEnabled and (prevRange ~= activeRange or prevThreshold ~= mainFrame.redCircleNumPlayers) then
			prevRange = activeRange
			pixelsperyard = min(radarFrame:GetWidth(), radarFrame:GetHeight()) / (activeRange * 3)
			radarFrame.circle:SetSize(activeRange * pixelsperyard * 2, activeRange * pixelsperyard * 2)
			if reverse then
				radarFrame.text:SetText(DBM_CORE_RANGERADAR_RHEADER:format(activeRange, mainFrame.redCircleNumPlayers))
			else
				radarFrame.text:SetText(DBM_CORE_RANGERADAR_HEADER:format(activeRange, mainFrame.redCircleNumPlayers))
			end
		end

		local playerMapId = GetBestMapForUnit("player") or 0
		if not restricted then
			rotation = pi2 - (GetPlayerFacing() or 0)
		end
		local sinTheta = sin(rotation)
		local cosTheta = cos(rotation)
		local closePlayer = 0
		local closestRange = nil
		local closetName = nil
		local filter = mainFrame.filter
		local type = reverse and 2 or filter and 1 or 0
		local onlySummary = mainFrame.onlySummary
		for i = 1, numPlayers do
			local uId = unitList[i]
			local dot = dots[i]
			local mapId = GetBestMapForUnit(uId) or 0
			if UnitExists(uId) and playerMapId == mapId and not UnitIsUnit(uId, "player") and not UnitIsDeadOrGhost(uId) and UnitIsConnected(uId) and UnitInPhase(uId) and (not filter or filter(uId)) then
				local range--Juset set to a number in case any api fails and returns nil
				if restricted then--API restrictions are in play, so pretend we're back in BC
					--Start at bottom and work way up.
					--Definitely not most efficient way of doing it. Refactor later
					--All ranges aer tested and compared against UnitDistanceSquared.
					--Worgsaw has a tooltip of 6 but doesn't factor in hitboxes/etc. It doesn't return false until UnitDistanceSquared of 8. bandages 18 even though spell range is 15, etc. Acorn actually is 5 in both though
					if IsItemInRange(90175, uId) then range = 4--Gin-Ji Knife Set
					elseif IsItemInRange(37727, uId) then range = 6--Ruby Acorn
					elseif IsItemInRange(63427, uId) then range = 8--Worgsaw
					elseif CheckInteractDistance(uId, 3) then range = 10
					elseif CheckInteractDistance(uId, 2) then range = 11
					elseif IsItemInRange(32321, uId) then range = 13--reports 12 but actual range tested is 13
					elseif IsItemInRange(6450, uId) then range = 18--Bandages. (despite popular sites saying it's 15 yards, it's actually 18 yards verified by UnitDistanceSquared
					elseif IsItemInRange(21519, uId) then range = 22--Item says 20, returns true until 22.
					elseif CheckInteractDistance(uId, 1) then range = 30
					elseif UnitInRange(uId) then range = 43--item check of 34471 also good for 43
					elseif IsItemInRange(32698, uId)  then range = 48--Wrangling Rope
					elseif IsItemInRange(116139, uId)  then range = 53
					elseif IsItemInRange(32825, uId) then range = 60
					elseif IsItemInRange(35278, uId) then range = 80
					else range = 1000 end--Just so it has a numeric value, even if it's unknown to protect from nil errors
				else
					range = UnitDistanceSquared(uId) ^ 0.5
				end
				local inRange = false
				if range < (activeRange+0.5) then
					closePlayer = closePlayer + 1
					inRange = true
					if not closestRange then
						closestRange = range
					elseif range < closestRange then
						closestRange = range
					end
					if not closetName then closetName = UnitName(uId) end
				end
				if tEnabled and inRange and not onlySummary and closePlayer < 6 then -- display up to 5 players in text range frame.
					local playerName = UnitName(uId)
					local color = RAID_CLASS_COLORS[dot.class] or NORMAL_FONT_COLOR
					local icon = dot.icon
					local text = icon and ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0|t %s"):format(icon, playerName) or playerName
					textFrame:AddLine(text, color.r, color.g, color.b)
				end
				if rEnabled then
					local playerX, playerY = UnitPosition("player")
					local x, y = UnitPosition(uId)
					if not x and not y then
						rangeCheck:Hide(true)
						return
					end
					local cy = x - playerX
					local cx = y - playerY
					dot.x = -cx
					dot.y = -cy
					dot.range = range
					setDot(i, sinTheta, cosTheta)
				end
			elseif rEnabled and dot.isShown then
				dot.isShown = nil
				dot:Hide()
			end
		end

		if tEnabled then
			--Green Text (Regular range frame and not near too many players, or reverse range frame and we ARE near enough)
			if (reverse and closePlayer >= warnThreshold) or (not reverse and closePlayer < warnThreshold) then
				textFrame:AddLine(DBM_CORE_RANGECHECK_IN_RANGE_TEXT:format(closePlayer, activeRange), 0, 1, 0)
			--Red Text (Regular range frame and we are near too many players, or reverse range frame and we aren't near enough)
			else
				updateSound(closePlayer)
				textFrame:AddLine(DBM_CORE_RANGECHECK_IN_RANGE_TEXT:format(closePlayer, activeRange), 1, 0, 0)
			end
			textFrame:Show()
		end
		if rEnabled then
			if prevNumClosePlayer ~= closePlayer or prevclosestRange ~= closestRange or prevType ~= type then
				if closePlayer == 1 then
					radarFrame.inRangeText:SetText(DBM_CORE_RANGERADAR_IN_RANGE_TEXTONE:format(closetName, closestRange))
				else
					radarFrame.inRangeText:SetText(DBM_CORE_RANGERADAR_IN_RANGE_TEXT:format(closePlayer, closestRange))
				end
				if closePlayer >= warnThreshold then -- only show the text if the circle is red
					circleColor = reverse and 1 or 2
					radarFrame.inRangeText:Show()
				else
					circleColor = reverse and 2 or 1
					radarFrame.inRangeText:Hide()
				end
				prevNumClosePlayer = closePlayer
				prevclosestRange = closestRange
				prevType = type
			end

			if UnitIsDeadOrGhost("player") then
				circleColor = 3
			end

			if prevColor ~= circleColor then
				if circleColor == 1 then
					radarFrame.circle:SetVertexColor(0, 1, 0)
				elseif circleColor == 2 then
					radarFrame.circle:SetVertexColor(1, 0, 0)
				else
					radarFrame.circle:SetVertexColor(1, 1, 1)
				end
				prevColor = circleColor
			end
			if circleColor == 2 then--Red
				updateSound(closePlayer)
			end
		end
	end
end

updater = mainFrame:CreateAnimationGroup()
updater:SetLooping("REPEAT")
local anim = updater:CreateAnimation()
anim:SetDuration(0.05)

mainFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "GROUP_ROSTER_UPDATE" or event == "RAID_TARGET_UPDATE" then
		updateIcon()
	end
end)

-----------------------
--  Check functions  --
-----------------------
local getDistanceBetween, getDistanceBetweenALL
do
	local function itsBCAgain(uId)
		if IsItemInRange(90175, uId) then return 4
		elseif IsItemInRange(37727, uId) then return 6
		elseif IsItemInRange(63427, uId) then return 8
		elseif CheckInteractDistance(uId, 3) then return 10
		elseif CheckInteractDistance(uId, 2) then return 11
		elseif IsItemInRange(32321, uId) then return 13
		elseif IsItemInRange(6450, uId) then return 18
		elseif IsItemInRange(21519, uId) then return 22
		elseif CheckInteractDistance(uId, 1) then return 30
		elseif UnitInRange(uId) then return 43
		elseif IsItemInRange(32698, uId) then return 48
		elseif IsItemInRange(116139, uId) then return 53
		elseif IsItemInRange(32825, uId) then return 60
		elseif IsItemInRange(35278, uId) then return 80
		else return 1000 end--Just so it has a numeric value, even if it's unknown to protect from nil errors
	end

	function getDistanceBetweenALL(checkrange)
		local range = 1000
		for uId in DBM:GetGroupMembers() do
			if UnitExists(uId) and not UnitIsUnit(uId, "player") and not UnitIsDeadOrGhost(uId) and UnitIsConnected(uId) and UnitInPhase(uId) then
				if DBM:HasMapRestrictions() then--API restrictions are in play, so pretend we're back in BC
					range = itsBCAgain(uId)
				else
					range = UnitDistanceSquared(uId) ^ 0.5
				end
				if checkrange < (range+0.5) then
					return true--return and end once anyone found
				end
			end
		end
		return false--No one was foundi nrnage
	end

	function getDistanceBetween(uId, x, y)
		local restrictionsActive = DBM:HasMapRestrictions()
		if not x then--If only one arg then 2nd arg is always assumed to be player
			if restrictionsActive then
				return itsBCAgain(uId)
			else
				return UnitDistanceSquared(uId) ^ 0.5
			end
		end
		if type(x) == "string" and UnitExists(x) then -- arguments: uId, uId2
			--First attempt to avoid UnitPosition if any of args is player UnitDistanceSquared should work
			if UnitIsUnit("player", uId) then
				if restrictionsActive then
					return itsBCAgain(x)
				else
					return UnitDistanceSquared(x) ^ 0.5
				end
			elseif UnitIsUnit("player", x) then
				if restrictionsActive then
					return itsBCAgain(uId)
				else
					return UnitDistanceSquared(uId) ^ 0.5
				end
			else--Neither unit is player, no way to avoid UnitPosition
				if restrictionsActive then return 1000 end--Cannot compare two units that don't involve player with restrictions, just fail quietly
				local uId2 = x
				x, y = UnitPosition(uId2)
				if not x then
					print("getDistanceBetween failed for: " .. uId .. " (" .. tostring(UnitExists(uId)) .. ") and " .. uId2 .. " (" .. tostring(UnitExists(uId2)) .. ")")
					return
				end
			end
		end
		if restrictionsActive then return 1000 end--Cannot check distance between player and a location (not another unit, again, fail quietly)
		local startX, startY = UnitPosition(uId)
		local dX = startX - x
		local dY = startY - y
		return (dX * dX + dY * dY) ^ 0.5
	end
end

---------------
--  Methods  --
---------------
local restoreRange, restoreFilter, restoreThreshold, restoreReverse = nil, nil, nil, nil
function rangeCheck:Show(range, filter, forceshow, redCircleNumPlayers, reverse, hideTime, onlySummary)
	if (DBM:GetNumRealGroupMembers() < 2 or DBM.Options.DontShowRangeFrame) and not forceshow then return end
	if type(range) == "function" then -- the first argument is optional
		return self:Show(nil, range)
	end
	range = range or 10
	redCircleNumPlayers = redCircleNumPlayers or 1
	textFrame = textFrame or createTextFrame()
	radarFrame = radarFrame or createRadarFrame()
	local restrictionsActive = DBM:HasMapRestrictions()
	if (DBM.Options.RangeFrameFrames == "text" or DBM.Options.RangeFrameFrames == "both" or restrictionsActive) and not textFrame.isShown then
		if restrictionsActive then
			if range <= 4 then
				range = 4
			elseif range <= 6 then
				range = 6
			elseif range <= 8 then
				range = 8
			elseif range <= 10 then
				range = 10
			elseif range <= 11 then
				range = 11
			elseif range <= 13 then
				range = 13
			elseif range <= 18 then
				range = 18
			elseif range <= 22 then
				range = 22
			elseif range <= 30 then
				range = 30
			elseif range <= 43 then
				range = 43
			elseif range <= 48 then
				range = 48
			elseif range <= 53 then
				range = 53
			elseif range <= 60 then
				range = 60
			elseif range <= 80 then
				range = 80
			end
		end
		textFrame.isShown = true
		textFrame:Show()
		textFrame:SetOwner(UIParent, "ANCHOR_PRESERVE")
	end
	--TODO, add check for restricted area here so we can prevent radar frame loading.
	if not restrictionsActive and (DBM.Options.RangeFrameFrames == "radar" or DBM.Options.RangeFrameFrames == "both") and not radarFrame.isShown then
		radarFrame.isShown = true
		radarFrame:Show()
	end
	mainFrame.range = range
	mainFrame.filter = filter
	mainFrame.redCircleNumPlayers = redCircleNumPlayers
	mainFrame.reverse = reverse
	mainFrame.hideTime = hideTime and (GetTime() + hideTime) or 0
	mainFrame.restrictions = restrictionsActive
	mainFrame.onlySummary = onlySummary
	if not mainFrame.eventRegistered then
		mainFrame.eventRegistered = true
		updateIcon()
		mainFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
		mainFrame:RegisterEvent("RAID_TARGET_UPDATE")
	end
	updater:SetScript("OnLoop", updateRangeFrame)
	updater:Play()
	if forceshow and not DBM.Options.DontRestoreRange then--Force means user activated range frame, store user value for restore function
		restoreRange, restoreFilter, restoreThreshold, restoreReverse = mainFrame.range, mainFrame.filter, mainFrame.redCircleNumPlayers, mainFrame.reverse
	end
end

function rangeCheck:Hide(force)
	if restoreRange and not force then--Restore range frame to way it was when boss mod is done with it
		rangeCheck:Show(restoreRange, restoreFilter, true, restoreThreshold, restoreReverse)
	else
		restoreRange, restoreFilter, restoreThreshold, restoreReverse = nil, nil, nil, nil
		DBM.Options.RestoreRange = nil--Set nil here because it means force was passed.
		updater:Stop()
		activeRange = 0
		if mainFrame.eventRegistered then
			mainFrame.eventRegistered = nil
			mainFrame:UnregisterAllEvents()
		end
		if textFrame then
			textFrame.isShown = nil
			textFrame:Hide()
		end
		if radarFrame then
			radarFrame.isShown = nil
			radarFrame:Hide()
		end
	end
end

function rangeCheck:IsShown()
	return textFrame and textFrame.isShown or radarFrame and radarFrame.isShown
end

function rangeCheck:IsRadarShown()
	return radarFrame and radarFrame.isShown
end

function rangeCheck:UpdateRestrictions(force)
	mainFrame.restrictions = force or DBM:HasMapRestrictions()
end

function rangeCheck:SetHideTime(hideTime)
	mainFrame.hideTime = hideTime and (GetTime() + hideTime) or 0
end

-- GetDistance(uId) -- distance between you and the given uId
-- GetDistance(uId, x, y) -- distance between uId and the coordinates
-- GetDistance(uId, uId2) -- distance between the two uIds
function rangeCheck:GetDistance(...)
	return getDistanceBetween(...)
end

function rangeCheck:GetDistanceAll(...)
	return getDistanceBetweenALL(...)
end
