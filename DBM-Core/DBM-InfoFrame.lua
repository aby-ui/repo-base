-- **             DBM Info Frame             **
-- **     http://www.deadlybossmods.com      **
-- ********************************************
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
--    * Omegal @ US-Kel'Thuzad (continuing mod support for 3.2+)
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
DBM.InfoFrame = {}

--------------
--  Locals  --
--------------
local infoFrame = DBM.InfoFrame
local frame
local createFrame
local onUpdate
local dropdownFrame
local initializeDropdown
local currentMapId
local maxlines = 5
local modLines = 5
local currentEvent
local headerText = "DBM Info Frame"	-- this is only used if DBM.InfoFrame:SetHeader(text) is not called before :Show()
local lines = {}
local sortMethod = 1--1 Default, 2 SortAsc, 3 GroupId
local sortedLines = {}
local icons = {}
local value = {}
local playerName = UnitName("player")

-------------------
-- Local Globals --
-------------------
--Entire InfoFrame is a looping onupdate function. All of these globals get used several times a second
local GetRaidTargetIndex = GetRaidTargetIndex
local UnitName = UnitName
local UnitHealth, UnitPower, UnitPowerMax = UnitHealth, UnitPower, UnitPowerMax
local UnitIsDeadOrGhost, UnitThreatSituation = UnitIsDeadOrGhost, UnitThreatSituation
local UnitPosition = UnitPosition
local twipe = table.wipe
local select, tonumber = select, tonumber
local mfloor = math.floor
local getGroupId = DBM.GetGroupId

-- for Phanx' Class Colors
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

---------------------
--  Dropdown Menu  --
---------------------
-- todo: this dropdown menu is somewhat ugly and unflexible....
do
	local function toggleLocked()
		DBM.Options.InfoFrameLocked = not DBM.Options.InfoFrameLocked
	end
	local function toggleShowSelf()
		DBM.Options.InfoFrameShowSelf = not DBM.Options.InfoFrameShowSelf
	end

	local function setLines(self, line)
		DBM.Options.InfoFrameLines = line
		if line ~= 0 then
			maxlines = line
		else
			maxlines = modLines or 5
		end
	end

	function initializeDropdown(dropdownFrame, level, menu)
		local info
		if level == 1 then
			info = UIDropDownMenu_CreateInfo()
			info.text = LOCK_FRAME
			if DBM.Options.InfoFrameLocked then
				info.checked = true
			end
			info.func = toggleLocked
			UIDropDownMenu_AddButton(info, 1)

			info = UIDropDownMenu_CreateInfo()
			info.keepShownOnClick = true
			info.text = DBM_CORE_INFOFRAME_SHOW_SELF
			if DBM.Options.InfoFrameShowSelf then
				info.checked = true
			end
			info.func = toggleShowSelf
			UIDropDownMenu_AddButton(info, 1)

			info = UIDropDownMenu_CreateInfo()
			info.text = DBM_CORE_INFOFRAME_SETLINES
			info.notCheckable = true
			info.hasArrow = true
			info.keepShownOnClick = true
			info.menuList = "lines"
			UIDropDownMenu_AddButton(info, 1)

			info = UIDropDownMenu_CreateInfo()
			info.text = HIDE
			info.notCheckable = true
			info.func = infoFrame.Hide
			info.arg1 = infoFrame
			UIDropDownMenu_AddButton(info, 1)
		elseif level == 2 then
			if menu == "lines" then
				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_INFOFRAME_LINESDEFAULT
				info.func = setLines
				info.arg1 = 0
				info.checked = (DBM.Options.InfoFrameLines == 0)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_INFOFRAME_LINES_TO:format(3)
				info.func = setLines
				info.arg1 = 3
				info.checked = (DBM.Options.InfoFrameLines == 3)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_INFOFRAME_LINES_TO:format(5)
				info.func = setLines
				info.arg1 = 5
				info.checked = (DBM.Options.InfoFrameLines == 5)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_INFOFRAME_LINES_TO:format(8)
				info.func = setLines
				info.arg1 = 8
				info.checked = (DBM.Options.InfoFrameLines == 8)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_INFOFRAME_LINES_TO:format(10)
				info.func = setLines
				info.arg1 = 10
				info.checked = (DBM.Options.InfoFrameLines == 10)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_INFOFRAME_LINES_TO:format(15)
				info.func = setLines
				info.arg1 = 15
				info.checked = (DBM.Options.InfoFrameLines == 15)
				UIDropDownMenu_AddButton(info, 2)

				info = UIDropDownMenu_CreateInfo()
				info.text = DBM_CORE_INFOFRAME_LINES_TO:format(20)
				info.func = setLines
				info.arg1 = 20
				info.checked = (DBM.Options.InfoFrameLines == 20)
				UIDropDownMenu_AddButton(info, 2)
			end
		end
	end
end


------------------------
--  Create the frame  --
------------------------
local frameBackdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",--131071
	tile = true,
	tileSize = 16,
	insets = { left = 2, right = 14, top = 2, bottom = 2 },
}

function createFrame()
	local elapsed = 0
	local frame = CreateFrame("GameTooltip", "DBMInfoFrame", UIParent, "GameTooltipTemplate")
	dropdownFrame = CreateFrame("Frame", "DBMInfoFrameDropdown", frame, "UIDropDownMenuTemplate")
	frame:SetFrameStrata("DIALOG")
	frame:SetBackdrop(frameBackdrop)
	frame:SetPoint(DBM.Options.InfoFramePoint, UIParent, DBM.Options.InfoFramePoint, DBM.Options.InfoFrameX, DBM.Options.InfoFrameY)
	frame:SetHeight(maxlines*12)
	frame:SetWidth(64)
	frame:EnableMouse(true)
	frame:SetToplevel(true)
	frame:SetMovable(1)
	GameTooltip_OnLoad(frame)
	frame:SetPadding(16, 0)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		if not DBM.Options.InfoFrameLocked then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		--ValidateFramePosition(self)
		local point, _, _, x, y = self:GetPoint(1)
		DBM.Options.InfoFrameX = x
		DBM.Options.InfoFrameY = y
		DBM.Options.InfoFramePoint = point
	end)
	frame:SetScript("OnEvent", function(self, event, ...)
		if infoFrame[event] then
			infoFrame[event](self, ...)
		end
	end)
	frame:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			UIDropDownMenu_Initialize(dropdownFrame, initializeDropdown)
			ToggleDropDownMenu(1, nil, dropdownFrame, "cursor", 5, -10)
		end
	end)
	return frame
end


------------------------
--  Update functions  --
------------------------
local updateCallbacks = {}
local function sortFuncDesc(a, b) return lines[a] > lines[b] end
local function sortFuncAsc(a, b) return lines[a] < lines[b] end
local function namesortFuncAsc(a, b) return a < b end
local function sortGroupId(a, b) return getGroupId(DBM, a) < getGroupId(DBM, b) end
local function updateLines(preSorted)
	twipe(sortedLines)
	if preSorted then
		-- copy table as code from mod keeps around references this this and the "normal" table is wiped regularly
		for i, v in ipairs(preSorted) do
			sortedLines[i] = v
		end
	else
		for i in pairs(lines) do
			sortedLines[#sortedLines + 1] = i
		end
		if sortMethod == 3 then
			table.sort(sortedLines, sortGroupId)
		elseif sortMethod == 2 then
			table.sort(sortedLines, sortFuncAsc)
		else
			table.sort(sortedLines, sortFuncDesc)
		end
	end
	for i, v in ipairs(updateCallbacks) do
		v(sortedLines)
	end
end

local function updateNamesortLines()
	twipe(sortedLines)
	for i in pairs(lines) do
		sortedLines[#sortedLines + 1] = i
	end
	table.sort(sortedLines, namesortFuncAsc)
	for i, v in ipairs(updateCallbacks) do
		v(sortedLines)
	end
end

local function updateLinesCustomSort(sortFunc)
	twipe(sortedLines)
	for i in pairs(lines) do
		sortedLines[#sortedLines + 1] = i
	end
	table.sort(sortedLines, sortFunc)
	for i, v in ipairs(updateCallbacks) do
		v(sortedLines)
	end
end

--8.2 TODO FIXME if broken.
local function updateIcons()
	twipe(icons)
	for uId in DBM:GetGroupMembers() do
		local icon = GetRaidTargetIndex(uId)
		local icon2 = GetRaidTargetIndex(uId.."target")
		if icon then
			icons[UnitName(uId)] = ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0|t"):format(icon)
		end
		if icon2 then
			icons[UnitName(uId.."target")] = ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0|t"):format(icon2)
		end
	end
	for i = 1, 5 do
		local icon = GetRaidTargetIndex("boss"..i)
		if icon then
			icons[UnitName("boss"..i)] = ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0|t"):format(icon)
		end
	end
end

local function updateHealth()
	twipe(lines)
	local threshold = value[1]
	for uId in DBM:GetGroupMembers() do
		if UnitHealth(uId) < threshold and not UnitIsDeadOrGhost(uId) then
			lines[UnitName(uId)] = UnitHealth(uId) - threshold
		end
	end
	updateLines()
	updateIcons()
end

local function updatePlayerPower()
	twipe(lines)
	local threshold = value[1]
	local powerType = value[2]
	local spellFilter = value[3]
	for uId in DBM:GetGroupMembers() do
		if spellFilter and DBM:UnitDebuff(uId, spellFilter) then
			--Do nothing
		else
			local maxPower = UnitPowerMax(uId, powerType)
			if maxPower ~= 0 and not UnitIsDeadOrGhost(uId) and UnitPower(uId, powerType) / UnitPowerMax(uId, powerType) * 100 >= threshold then
				lines[UnitName(uId)] = UnitPower(uId, powerType)
			end
		end
	end
	if DBM.Options.InfoFrameShowSelf and not lines[playerName] and UnitPower("player", powerType) > 0 then
		lines[playerName] = UnitPower("player", powerType)
	end
	updateLines()
	updateIcons()
end

local function updateEnemyPower()
	twipe(lines)
	local threshold = value[1]
	local powerType = value[2]
	local specificUnit = value[3]
	if powerType then--Only do power type defined
		if specificUnit then
			local currentPower, maxPower = UnitPower(specificUnit, powerType), UnitPowerMax(specificUnit, powerType)
			if maxPower and maxPower ~= 0 then--Prevent division by 0 in addition to filtering non existing units that may still return false on UnitExists()
				if currentPower / maxPower * 100 >= threshold then
					lines[UnitName(specificUnit)] = currentPower
				end
			end
		else
			if specificUnit then
				local currentPower, maxPower = UnitPower(specificUnit), UnitPowerMax(specificUnit)
				if maxPower and maxPower ~= 0 then--Prevent division by 0 in addition to filtering non existing units that may still return false on UnitExists()
					if currentPower / maxPower * 100 >= threshold then
						lines[UnitName(specificUnit)] = currentPower
					end
				end
			else
				for i = 1, 5 do
					local uId = "boss"..i
					local currentPower, maxPower = UnitPower(uId), UnitPowerMax(uId)
					if maxPower and maxPower ~= 0 then--Prevent division by 0 in addition to filtering non existing units that may still return false on UnitExists()
						if currentPower / maxPower * 100 >= threshold then
							lines[UnitName(uId)] = currentPower
						end
					end
				end
			end
		end
	else--Check primary power type and alternate power types together. This should only be used if BOTH power types exist on same boss, else fix your shit MysticalOS
		for i = 1, 5 do
			local uId = "boss"..i
			--Primary Power
			local currentPower, maxPower = UnitPower(uId), UnitPowerMax(uId)
			if maxPower and maxPower ~= 0 then--Prevent division by 0 in addition to filtering non existing units that may still return false on UnitExists()
				if currentPower / maxPower * 100 >= threshold then
					lines[UnitName(uId)] = currentPower
				end
			end
			--Alternate Power
			local currentAltPower, maxAltPower = UnitPower(uId, 10), UnitPowerMax(uId, 10)
			if maxAltPower and maxAltPower ~= 0 then--Prevent division by 0 in addition to filtering non existing units that may still return false on UnitExists()
				if currentAltPower / maxAltPower * 100 >= threshold then
					lines[UnitName(uId)] = DBM_CORE_INFOFRAME_ALT..currentAltPower
				end
			end
		end
	end
	updateLines()
	updateIcons()
end

local function updateEnemyAbsorb()
	twipe(lines)
	local spellInput = value[1]
	local totalAbsorb = value[2]
	local specificUnit = value[3]
	if specificUnit then
		if UnitExists(specificUnit) then
			local absorbAmount
			if spellInput then--Get specific spell absorb
				absorbAmount = select(16, DBM:UnitBuff(specificUnit, spellInput)) or select(16, DBM:UnitDebuff(specificUnit, spellInput))
			else--Get all of them
				absorbAmount = UnitGetTotalAbsorbs(specificUnit)
			end
			if absorbAmount and absorbAmount > 0 then
				local text
				if totalAbsorb then
					text = absorbAmount / totalAbsorb * 100
				else
					text = absorbAmount
				end
				lines[UnitName(specificUnit)] = mfloor(text).."%"
			end
		end
	else
		for i = 1, 5 do
			local uId = "boss"..i
			if UnitExists(uId) then
				local absorbAmount
				if spellInput then--Get specific spell absorb
					absorbAmount = select(16, DBM:UnitBuff(uId, spellInput)) or select(16, DBM:UnitDebuff(uId, spellInput))
				else--Get all of them
					absorbAmount = UnitGetTotalAbsorbs(uId)
				end
				if absorbAmount and absorbAmount > 0 then
					local text
					if totalAbsorb then
						text = absorbAmount / totalAbsorb * 100
					else
						text = absorbAmount
					end
					lines[UnitName(uId)] = mfloor(text).."%"
				end
			end
		end
	end
	updateLines()
	updateIcons()
end

local function updateAllAbsorb()
	twipe(lines)
	local spellInput = value[1]
	local totalAbsorb = value[2]
	local totalAbsorb2 = value[3]
	for i = 1, 5 do
		local uId = "boss"..i
		if UnitExists(uId) then
			local absorbAmount
			if spellInput then--Get specific spell absorb
				absorbAmount = select(16, DBM:UnitBuff(uId, spellInput)) or select(16, DBM:UnitDebuff(uId, spellInput))
			else--Get all of them
				absorbAmount = UnitGetTotalAbsorbs(uId)
			end
			if absorbAmount then
				local text
				if totalAbsorb then
					text = absorbAmount / totalAbsorb * 100
				else
					text = absorbAmount
				end
				lines[UnitName(uId)] = mfloor(text).."%"
			end
		end
	end
	if spellInput then
		for uId in DBM:GetGroupMembers() do
			local absorbAmount = select(16, DBM:UnitBuff(uId, spellInput)) or select(16, DBM:UnitDebuff(uId, spellInput))
			if absorbAmount then
				local text
				if totalAbsorb2 then
					text = absorbAmount / totalAbsorb2 * 100
				else
					text = absorbAmount
				end
				lines[UnitName(uId)] = mfloor(text).."%"
			end
		end
	end
	updateLines()
	updateIcons()
end

local function updatePlayerAbsorb()
	twipe(lines)
	local spellInput = value[1]
	local totalAbsorb = value[2]
	for uId in DBM:GetGroupMembers() do
		local absorbAmount = select(16, DBM:UnitBuff(uId, spellInput)) or select(16, DBM:UnitDebuff(uId, spellInput))
		if absorbAmount then
			local text
			if totalAbsorb then
				text = absorbAmount / totalAbsorb * 100
			else
				text = absorbAmount
			end
			lines[UnitName(uId)] = mfloor(text)
		end
	end
	updateLines()
	updateIcons()
end

--Buffs that are good to have, therefor bad not to have them.
local function updatePlayerBuffs()
	twipe(lines)
	local spellName = value[1]
	local tankIgnored = value[2]
	for uId in DBM:GetGroupMembers() do
		if tankIgnored and (UnitGroupRolesAssigned(uId) == "TANK" or GetPartyAssignment("MAINTANK", uId, 1)) then
		else
			if not DBM:UnitBuff(uId, spellName) and not UnitIsDeadOrGhost(uId) then
				lines[UnitName(uId)] = ""
			end
		end
	end
	updateLines()
	updateIcons()
end

--Debuffs that are good to have, therefor it's bad NOT to have them.
local function updateGoodPlayerDebuffs()
	twipe(lines)
	local spellInput = value[1]
	local tankIgnored = value[2]
	for uId in DBM:GetGroupMembers() do
		if tankIgnored and (UnitGroupRolesAssigned(uId) == "TANK" or GetPartyAssignment("MAINTANK", uId, 1)) then
		else
			if not DBM:UnitDebuff(uId, spellInput) and not UnitIsDeadOrGhost(uId) then
				lines[UnitName(uId)] = ""
			end
		end
	end
	updateLines()
	updateIcons()
end

--Debuffs that are bad to have, therefor it is bad to have them.
--Function will auto handle spellName or spellId via DBMs unit debuff handler and spellInput type
local function updateBadPlayerDebuffs()
	twipe(lines)
	local spellInput = value[1]
	local tankIgnored = value[2]
	for uId in DBM:GetGroupMembers() do
		if tankIgnored and (UnitGroupRolesAssigned(uId) == "TANK" or GetPartyAssignment("MAINTANK", uId, 1)) then
		else
			if DBM:UnitDebuff(uId, spellInput) and not UnitIsDeadOrGhost(uId) then
				lines[UnitName(uId)] = ""
			end
		end
	end
	updateLines()
	updateIcons()
end

--Debuffs with important durations that we track
local function updatePlayerDebuffRemaining()
	twipe(lines)
	local spellInput = value[1]
	for uId in DBM:GetGroupMembers() do
		local expires = select(6, DBM:UnitDebuff(uId, spellInput))
		if expires then
			if expires == 0 then
				lines[UnitName(uId)] = 9000--Force sorting the unknowns under the ones we do know.
			else
				local debuffTime = expires - GetTime()
				lines[UnitName(uId)] = mfloor(debuffTime)
			end
		end
	end
	updateLines()
	updateIcons()
end

--Buffs with important durations that we track
local function updatePlayerBuffRemaining()
	twipe(lines)
	local spellInput = value[1]
	for uId in DBM:GetGroupMembers() do
		local expires = select(6, DBM:UnitBuff(uId, spellInput))
		if expires then
			if expires == 0 then
				lines[UnitName(uId)] = 9000--Force sorting the unknowns under the ones we do know.
			else
				local debuffTime = expires - GetTime()
				lines[UnitName(uId)] = mfloor(debuffTime)
			end
		end
	end
	updateLines()
	updateIcons()
end

--Debuffs that are bad to have, but we want to show players who do NOT have them
--Function will auto handle spellName or spellId via DBMs unit debuff handler and spellInput type
local function updateReverseBadPlayerDebuffs()
	twipe(lines)
	local spellInput = value[1]
	local tankIgnored = value[2]
	for uId in DBM:GetGroupMembers() do
		if tankIgnored and (UnitGroupRolesAssigned(uId) == "TANK" or GetPartyAssignment("MAINTANK", uId, 1)) then
		else
			if not DBM:UnitDebuff(uId, spellInput) and not UnitIsDeadOrGhost(uId) and not DBM:UnitBuff(uId, 27827) then--27827 Spirit of Redemption. This particular info frame wants to ignore this
				lines[UnitName(uId)] = ""
			end
		end
	end
	updateLines()
	updateIcons()
end

local function updatePlayerBuffStacks()
	twipe(lines)
	local spellInput = value[1]
	for uId in DBM:GetGroupMembers() do
		local spellName, _, count = DBM:UnitBuff(uId, spellInput)
		if spellName and count then
			lines[UnitName(uId)] = count
		end
	end
	updateIcons()
	updateLines()
end

local function updatePlayerDebuffStacks()
	twipe(lines)
	local spellInput = value[1]
	for uId in DBM:GetGroupMembers() do
		local spellName, _, count = DBM:UnitDebuff(uId, spellInput)
		if spellName and count then
			lines[UnitName(uId)] = count
		end
	end
	updateIcons()
	updateLines()
end

local function updatePlayerAggro()
	twipe(lines)
	local aggroType = value[1]
	local tankIgnored = value[2]
	for uId in DBM:GetGroupMembers() do
		if tankIgnored and (UnitGroupRolesAssigned(uId) == "TANK" or GetPartyAssignment("MAINTANK", uId, 1)) then
		else
			local currentThreat = UnitThreatSituation(uId) or 0
			if currentThreat >= aggroType then
				lines[UnitName(uId)] = ""
			end
		end
	end
	updateLines()
	updateIcons()
end

local function updatePlayerTargets()
	twipe(lines)
	local cId = value[1]
	for uId, i in DBM:GetGroupMembers() do
		if DBM:GetUnitCreatureId(uId.."target") ~= cId and (UnitGroupRolesAssigned(uId) == "DAMAGER" or UnitGroupRolesAssigned(uId) == "NONE") then
			lines[UnitName(uId)] = ""
		end
	end
	updateLines()
	updateIcons()
end

local function updateByFunction()
	local func = value[1]
	local sortFunc = value[2]
	local useIcon = value[3]
	local presortedLines
	lines, presortedLines = func()
	if sortFunc then
		if type(sortFunc) == "function" then
			updateLinesCustomSort(sortFunc)
		else--Sort function is a bool/true
			updateLines()--regular update lines with regular sort code
		end
	else--Nil, or bool/false
		updateLines(presortedLines)--Update lines with sorting if provided by the custom function
	end
	if useIcon then
		updateIcons()
	end
end

--Unsorted table maintained by mod and just sent here.
--Never updated by onupdate method, requires manual updates when mod updates table
local function updateByTable(table)
	twipe(lines)
	--Copy table into lines
	if table then
		for i, v in pairs(table) do
			lines[i] = v
		end
	end
	--Pass to update lines for sort handling
	updateLines()
	updateIcons()
end

local function updateTest()
	twipe(lines)
	lines["Alpha"] = 1
	lines["Beta"] = 10
	lines["Gamma"] = 25
	lines["Delta"] = 50
	lines["Epsilon"] = 100
	updateLines()
end

local events = {
	["health"] = updateHealth,
	["playerpower"] = updatePlayerPower,
	["enemypower"] = updateEnemyPower,
	["enemyabsorb"] = updateEnemyAbsorb,
	["allabsorb"] = updateAllAbsorb,
	["playerabsorb"] = updatePlayerAbsorb,
	["playerbuff"] = updatePlayerBuffs,
	["playergooddebuff"] = updateGoodPlayerDebuffs,
	["playerbaddebuff"] = updateBadPlayerDebuffs,
	["playerdebuffremaining"] = updatePlayerDebuffRemaining,
	["playerbuffremaining"] = updatePlayerBuffRemaining,
	["reverseplayerbaddebuff"] = updateReverseBadPlayerDebuffs,
	["playeraggro"] = updatePlayerAggro,
	["playerbuffstacks"] = updatePlayerBuffStacks,
	["playerdebuffstacks"] = updatePlayerDebuffStacks,
	["playertargets"] = updatePlayerTargets,
	["function"] = updateByFunction,
	["table"] = updateByTable,
	["test"] = updateTest
}

----------------
--  OnUpdate  --
----------------
local friendlyEvents = {
	["health"] = true,
	["playerpower"] = true,
	["playerabsorb"] = true,
	["playerbuff"] = true,
	["playergooddebuff"] = true,
	["playerbaddebuff"] = true,
	["playerdebuffremaining"] = true,
	["playerbuffremaining"] = true,
	["reverseplayerbaddebuff"] = true,
	["playeraggro"] = true,
	["playerbuffstacks"] = true,
	["playerdebuffstacks"] = true,
	["playertargets"] = true
}

function onUpdate(frame, table)
	if events[currentEvent] then
		events[currentEvent](table)
	else
		if frame then
			frame:Hide()
			--error("DBM-InfoFrame: Unsupported event", 2)
		end
	end
	local color = NORMAL_FONT_COLOR
	frame:ClearLines()
	if headerText then
		frame:AddLine(headerText, 255, 255, 255, 0)
	end
	local linesShown = 0
	for i = 1, #sortedLines do
		if linesShown >= maxlines then
			break
		end
		local leftText = sortedLines[i]
		if not leftText then
			error("DBM InfoFrame: leftText cannot be nil, Notify DBM author. Infoframe force shutting down ", 2)
			frame:Hide()--Force close infoframe so it doesn't keep throwing 100s of errors onupdate. If leftText is broken the frame needs to be shut down
			return
		elseif leftText and type(leftText) ~= "string" then
			tostring(leftText)
			--error("DBM InfoFrame: leftText must be string, Notify DBM author. Infoframe force shutting down ", 2)
			--frame:Hide()--Force close infoframe so it doesn't keep throwing 100s of errors onupdate. If leftText is broken the frame needs to be shut down
			--return
		end
		local rightText = lines[leftText]
		local extra, extraName = string.split("|", leftText)--Find just unit name, if extra info had to be added to make unique
		local icon = icons[extraName or leftText] and icons[extraName or leftText]..leftText
		if friendlyEvents[currentEvent] then
			local unitId = DBM:GetRaidUnitId(DBM:GetUnitFullName(extraName or leftText)) or "player"--Prevent nil logical error
			if unitId and select(4, UnitPosition(unitId)) == currentMapId then
				local _, class = UnitClass(unitId)
				if class then
					color = RAID_CLASS_COLORS[class]
				else
					color = NORMAL_FONT_COLOR
				end
				linesShown = linesShown + 1
				if (extraName or leftText) == playerName then--It's player.
					if currentEvent == "health" or currentEvent == "playerpower" or currentEvent == "playerabsorb" or currentEvent == "playerbuff" or currentEvent == "playergooddebuff" or currentEvent == "playerbaddebuff" or currentEvent == "playerdebuffremaining" or currentEvent == "playerdebuffstacks" or currentEvent == "playerbuffremaining" or currentEvent == "playertargets" or currentEvent == "playeraggro" then--Red
						frame:AddDoubleLine(icon or leftText, rightText, 255, 0, 0, 255, 255, 255)-- (leftText, rightText, left.R, left.G, left.B, right.R, right.G, right.B)
					else--Green
						frame:AddDoubleLine(icon or leftText, rightText, 0, 255, 0, 255, 255, 255)
					end
				else--It's not player, do nothing special with it. Ordinary class colored text.
					if currentEvent == "playerdebuffremaining" or currentEvent == "playerbuffremaining" then
						local numberValue = tonumber(rightText)
						if numberValue < 6 then
							frame:AddDoubleLine(icon or leftText, rightText, color.r, color.g, color.b, 255, 0, 0)--Red
						elseif numberValue < 11 then
							frame:AddDoubleLine(icon or leftText, rightText, color.r, color.g, color.b, 255, 127.5, 0)--Orange
						else
							if numberValue == 9000 then--the out of range players
								frame:AddDoubleLine(icon or leftText, SPELL_FAILED_OUT_OF_RANGE, color.r, color.g, color.b, 255, 0, 0)--Red
							else
								frame:AddDoubleLine(icon or leftText, rightText, color.r, color.g, color.b, 255, 255, 255)--White
							end
						end
					else
						frame:AddDoubleLine(icon or leftText, rightText, color.r, color.g, color.b, 255, 255, 255)
					end
				end
			end
		else
			local color2 = NORMAL_FONT_COLOR--Only custom into frames will have chance of putting player names on right side
			local unitId = DBM:GetRaidUnitId(DBM:GetUnitFullName(extraName or leftText))
			local unitId2 = DBM:GetRaidUnitId(DBM:GetUnitFullName(rightText))
			--Class color names in custom functions too, IF unitID exists
			if unitId then--Check left text
				local _, class = UnitClass(unitId)
				if class then
					color = RAID_CLASS_COLORS[class]
				else
					color = NORMAL_FONT_COLOR
				end
			else
				color = NORMAL_FONT_COLOR
			end
			if unitId2 then--Check right text
				local _, class = UnitClass(unitId2)
				if class then
					color2 = RAID_CLASS_COLORS[class]
				else
					color2 = NORMAL_FONT_COLOR
				end
			else
				color2 = NORMAL_FONT_COLOR
			end
			linesShown = linesShown + 1
			frame:AddDoubleLine(icon or leftText, rightText, color.r, color.g, color.b, color2.r, color2.g, color2.b)
		end
	end
	frame:Show()
end

---------------
--  Methods  --
---------------
--Arg 1: spellName, health/powervalue, customfunction, table type. Arg 2: TankIgnore, Powertype, SortFunction, totalAbsorb, sortmethod (table/stacks). Arg 3: SpellFilter, UseIcon. Arg 4: disable onUpdate
function infoFrame:Show(maxLines, event, ...)
	currentMapId = select(4, UnitPosition("player"))
	if DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end
	modLines = maxLines
	if DBM.Options.InfoFrameLines and DBM.Options.InfoFrameLines ~= 0 then
		maxlines = DBM.Options.InfoFrameLines
	else
		maxlines = maxLines or 5
	end
	for i = 1, select("#", ...) do
		value[i] = select(i, ...)
	end
	frame = frame or createFrame()
	--Orders event to use spellID no matter what and not spell name
	if event:find("byspellid") then
		event = event:gsub("byspellid", "")--just strip off the byspellid, it served it's purpose, it simply told infoframe to not convert to spellName
		if type(value[1]) ~= "number" then
			error("DBM-InfoFrame: byspellid method must use spellId", 2)
			return
		end
	--If spellId is given as value one and it's not a byspellid event, convert to spellname
	--this also allows spell name to be given by mod, since value 1 verifies it's a number
	elseif type(value[1]) == "number" and event ~= "health" and event ~= "function" and event ~= "table" and event ~= "playertargets" and event ~= "playeraggro" and event ~= "playerpower" and event ~= "enemypower" and event ~= "test" then
		--Outside of "byspellid" functions, typical frames will still use spell NAME matching not spellID.
		--This just determines if we convert the spell input to a spell Name, if a spellId was provided for a non byspellid infoframe
		value[1] = DBM:GetSpellInfo(value[1])
	end
	currentEvent = event
	if event == "playerbuff" or event == "playerbaddebuff" or event == "playergooddebuff" then
		sortMethod = 3
	elseif event == "health" or event == "playerdebuffremaining" then
		sortMethod = 2	-- Sort lowest first
	elseif (event == "playerdebuffstacks" or event == "table") and value[2] then
		if type(value[2]) == "number" then
			sortMethod = value[2]
		end
	else
		sortMethod = 1
	end
	if events[currentEvent] then
		events[currentEvent](value[1])
	else
		error("DBM-InfoFrame: Unsupported event", 2)
		return
	end
	if not friendlyEvents[currentEvent] then
		twipe(icons)
	end
	frame:Show()
	frame:SetOwner(UIParent, "ANCHOR_PRESERVE")
	onUpdate(frame, value[1])
	if not frame.ticker and not value[4] and event ~= "table" then
		frame.ticker = C_Timer.NewTicker(0.5, function() onUpdate(frame) end)
	elseif frame.ticker and event == "table" then--Redundancy, in event calling a new table based infoframe show without a hide event to unschedule ticker based infoframe
		frame.ticker:Cancel()
		frame.ticker = nil
	end
end

function infoFrame:RegisterCallback(cb)
	updateCallbacks[#updateCallbacks + 1] = cb
end

function infoFrame:Update(time)
	frame = frame or createFrame()
	if frame:IsShown() then
		if time then
			C_Timer.After(time, function() onUpdate(frame) end)
		else
			onUpdate(frame)
		end
	end
end

function infoFrame:UpdateTable(table)
	frame = frame or createFrame()
	if frame:IsShown() and table then
		onUpdate(frame, table)
	end
end

function infoFrame:Hide()
	twipe(lines)
	twipe(icons)
	twipe(sortedLines)
	twipe(updateCallbacks)
	headerText = "DBM Info Frame"
	twipe(value)
	if frame then
		if frame.ticker then
			frame.ticker:Cancel()
			frame.ticker = nil
		end
		frame:Hide()
	end
	currentEvent = nil
	sortMethod = 1
end

function infoFrame:IsShown()
	return frame and frame:IsShown()
end

function infoFrame:SetHeader(text)
	if not text then return end
	headerText = text
end

function infoFrame:SetSortingAsc()
	sortMethod = 2
end

function infoFrame:SetSortingGroupId()
	sortMethod = 3
end
