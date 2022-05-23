local _, private = ...

local isRetail = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)
local GetTime = GetTime
local tinsert, tsort = table.insert, table.sort
local UnitIsUnit, UnitExists, UnitIsVisible, SetRaidTarget, GetRaidTargetIndex =
	UnitIsUnit, UnitExists, UnitIsVisible, SetRaidTarget, GetRaidTargetIndex

local playerName = UnitName("player")

--These still need to exist in private since they are heavily intertwined with DBM-Core
--Do not move these to local/OnModuleEnd
private.canSetIcons = {}
private.enableIcons = true -- Set to false when a raid leader or a promoted player has a newer version of DBM

--Common variables
local eventsRegistered = false
local scansActive = 0
--Mob Scanning Variables
local scanExpires = {}
local addsIcon = {}
local addsIconSet = {}
local addsGUIDs = {}
local iconVariables = {}
--Player setting variables
local iconSortTable = {}
local iconSet = {}

local module = private:NewModule("Icons")

function module:OnModuleEnd()
	table.wipe(addsGUIDs)
end

--Utility functions used by multiple player methods
local function clearSortTable(scanId)
	iconSortTable[scanId] = nil
	iconSet[scanId] = nil
end

--Primary icon methods
function module:SetIcon(mod, target, icon, timer)
	if not target then return end--Fix a rare bug where target becomes nil at last second (end combat fires and clears targets)
	if DBM.Options.DontSetIcons or not private.enableIcons or DBM:GetRaidRank(playerName) == 0 then
		return
	end
	mod:UnscheduleMethod("SetIcon", target)
	if type(icon) ~= "number" or type(target) ~= "string" then--icon/target probably backwards.
		DBM:Debug("|cffff0000SetIcon is being used impropperly. Check icon/target order|r")
		return--Fail silently instead of spamming icon lua errors if we screw up
	end
	if not icon or icon > 8 or icon < 0 then
		DBM:Debug("|cffff0000SetIcon is being used impropperly. Icon value must be between 0 and 8 (16 if extended)|r")
		return
	end
	local uId = DBM:GetRaidUnitId(target) or UnitExists(target) and target
	if uId and UnitIsUnit(uId, "player") and DBM:GetNumRealGroupMembers() < 2 then return end--Solo raid, no reason to put icon on yourself.
	if uId then--target accepts uid, unitname both.
		uId = uId or target
		--save previous icon into a table.
		local oldIcon = self:GetIcon(uId) or 0
		if not mod.iconRestore[uId] then
			mod.iconRestore[uId] = oldIcon
		end
		--set icon
		if oldIcon ~= icon then--Don't set icon if it's already set to what we're setting it to
			SetRaidTarget(uId, mod.iconRestore[uId] and icon == 0 and mod.iconRestore[uId] or icon)
		end
		--schedule restoring old icon if timer enabled.
		if timer then
			mod:ScheduleMethod(timer, "SetIcon", target, 0)
		end
	end
end

function module:GetIcon(uIdOrTarget)
	local uId = DBM:GetRaidUnitId(uIdOrTarget) or uIdOrTarget
	return UnitExists(uId) and GetRaidTargetIndex(uId)
end

function module:RemoveIcon(mod, target)
	return self:SetIcon(mod, target, 0)
end

function module:ClearIcons()
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			if UnitExists("raid" .. i) and GetRaidTargetIndex("raid" .. i) then
				SetRaidTarget("raid" .. i, 0)
			end
		end
	else
		for i = 1, GetNumSubgroupMembers() do
			if UnitExists("party" .. i) and GetRaidTargetIndex("party" .. i) then
				SetRaidTarget("party" .. i, 0)
			end
		end
	end
end

function module:CanSetIcon(optionName)
	return private.canSetIcons[optionName] or false
end

--Special Icon Methods
do
	local function SortByGroup(v1, v2)
		return DBM:GetGroupId(DBM:GetUnitFullName(v1), true) < DBM:GetGroupId(DBM:GetUnitFullName(v2), true)
	end
	local function SortByMeleeAlpha(v1, v2)
		--if both are melee, the return values are equal and we use alpha sort
		--if both are ranged, the return values are equal and we use alpha sort
		if DBM:IsMelee(v1) == DBM:IsMelee(v2) then
			return DBM:GetUnitFullName(v1) < DBM:GetUnitFullName(v2)
		--if one is melee and one is ranged, they are not equal so it goes to the below elseifs that prio melee
		elseif DBM:IsMelee(v1) and not DBM:IsMelee(v2) then
			return true
		elseif DBM:IsMelee(v2) and not DBM:IsMelee(v1) then
			return false
		end
	end
	local function SortByMeleeRoster(v1, v2)
		--if both are melee, the return values are equal and we use raid roster index sort
		--if both are ranged, the return values are equal and we use raid roster index sort
		if DBM:IsMelee(v1) == DBM:IsMelee(v2) then
			return DBM:GetGroupId(DBM:GetUnitFullName(v1), true) < DBM:GetGroupId(DBM:GetUnitFullName(v2), true)
		--if one is melee and one is ranged, they are not equal so it goes to the below elseifs that prio melee
		elseif DBM:IsMelee(v1) and not DBM:IsMelee(v2) then
			return true
		elseif DBM:IsMelee(v2) and not DBM:IsMelee(v1) then
			return false
		end
	end
	local function SortByRangedAlpha(v1, v2)
		--if both are melee, the return values are equal and we use alpha sort
		--if both are ranged, the return values are equal and we use alpha sort
		if DBM:IsRanged(v1) == DBM:IsRanged(v2) then
			return DBM:GetUnitFullName(v1) < DBM:GetUnitFullName(v2)
		--if one is melee and one is ranged, they are not equal so it goes to the below elseifs that prio melee
		elseif DBM:IsRanged(v1) and not DBM:IsRanged(v2) then
			return true
		elseif DBM:IsRanged(v2) and not DBM:IsRanged(v1) then
			return false
		end
	end
	local function SortByRangedRoster(v1, v2)
		--if both are melee, the return values are equal and we use raid roster index sort
		--if both are ranged, the return values are equal and we use raid roster index sort
		if DBM:IsRanged(v1) == DBM:IsRanged(v2) then
			return DBM:GetGroupId(DBM:GetUnitFullName(v1), true) < DBM:GetGroupId(DBM:GetUnitFullName(v2), true)
		--if one is melee and one is ranged, they are not equal so it goes to the below elseifs that prio melee
		elseif DBM:IsRanged(v1) and not DBM:IsRanged(v2) then
			return true
		elseif DBM:IsRanged(v2) and not DBM:IsRanged(v1) then
			return false
		end
	end
	local function SetIconBySortedTable(mod, sortType, startIcon, descendingIcon, returnFunc, scanId)
		if sortType == "meleealpha" then
			tsort(iconSortTable[scanId], SortByMeleeAlpha)
		elseif sortType == "meleeroster" then
			tsort(iconSortTable[scanId], SortByMeleeRoster)
		elseif sortType == "rangedalpha" then
			tsort(iconSortTable[scanId], SortByRangedAlpha)
		elseif sortType == "rangedroster" then
			tsort(iconSortTable[scanId], SortByRangedRoster)
		elseif sortType == "roster" then
			tsort(iconSortTable[scanId], SortByGroup)
		else--Just generic "alpha" sort
			tsort(iconSortTable[scanId])
		end
		local icon, CustomIcons
		if startIcon and type(startIcon) == "table" then--Specific gapped icons
			CustomIcons = true
			icon = 1
		else
			icon = startIcon or 1
		end
		for _, v in ipairs(iconSortTable[scanId]) do
			if not mod.iconRestore[v] then
				mod.iconRestore[v] = module:GetIcon(v) or 0
			end
			if CustomIcons then
				SetRaidTarget(v, startIcon[icon])--do not use SetIcon function again. It already checked in SetSortedIcon function.
				icon = icon + 1
				if returnFunc then
					mod[returnFunc](mod, v, startIcon[icon])--Send icon and target to returnFunc. (Generally used by announce icon targets to raid chat feature)
				end
			else
				SetRaidTarget(v, icon)--do not use SetIcon function again. It already checked in SetSortedIcon function.
				if descendingIcon then
					icon = icon - 1
				else
					icon = icon + 1
				end
				if returnFunc then
					mod[returnFunc](mod, v, icon)--Send unitId and icon to returnFunc. (Generally used by announce icon targets to raid chat feature)
				end
			end
		end
		mod:Schedule(1.5, clearSortTable, scanId)--Table wipe delay so if icons go out too early do to low fps or bad latency, when they get new target on table, resort and reapplying should auto correct teh icon within .2-.4 seconds at most.
	end

	function module:SetSortedIcon(mod, sortType, delay, target, startIcon, maxIcon, descendingIcon, returnFunc, scanId)
		if type(sortType) ~= "string" then
			DBM:AddMsg("SetSortedIcon tried to call invalid type, please update your encounter modules for this zone. If error persists, report this issue")
			return
		end
		if not target then return end
		if DBM.Options.DontSetIcons or not private.enableIcons or DBM:GetRaidRank(playerName) == 0 then
			return
		end
		scanId = scanId or 1
		if not startIcon then startIcon = 1 end
		local uId = DBM:GetRaidUnitId(target)
		if uId or UnitExists(target) then--target accepts uid, unitname both.
			uId = uId or target
			if not iconSortTable[scanId] then iconSortTable[scanId] = {} end
			if not iconSet[scanId] then iconSet[scanId] = 0 end
			local foundDuplicate = false
			for i = #iconSortTable[scanId], 1, -1 do
				if iconSortTable[scanId][i] == uId then
					foundDuplicate = true
					break
				end
			end
			if not foundDuplicate then
				iconSet[scanId] = iconSet[scanId] + 1
				tinsert(iconSortTable[scanId], uId)
			end
			mod:Unschedule(SetIconBySortedTable)
			if maxIcon and iconSet[scanId] == maxIcon then
				SetIconBySortedTable(mod, sortType, startIcon, descendingIcon, returnFunc, scanId)
			elseif mod:LatencyCheck() then--lag can fail the icons so we check it before allowing.
				mod:Schedule(delay or 0.5, SetIconBySortedTable, mod, sortType, startIcon, descendingIcon, returnFunc, scanId)
			end
		end
	end
end

do
	local function expireScan(scanId)
		--clear variables
		scanExpires[scanId] = nil
		addsIcon[scanId] = nil
		addsIconSet[scanId] = nil
		iconVariables[scanId] = nil
		scansActive = scansActive - 1
		--Do not wipe adds GUID table here, it's wiped by :Stop() which is called by EndCombat
		if eventsRegistered and scansActive == 0 then--No remaining icon scans
			eventsRegistered = false
			module:UnregisterShortTermEvents()
			DBM:Debug("Target events Unregistered", 2)
		end
	end

	local function executeMarking(scanId, unitId)
		if not iconVariables[scanId] then
			--Scan already expired
			return
		end
		local guid = UnitGUID(unitId)
		local cid = DBM:GetCIDFromGUID(guid)
		local isFriend = UnitIsFriend("player", unitId)
		local isFiltered = false
		local success = false
		if (not iconVariables[scanId].allowFriendly and isFriend) or (iconVariables[scanId].skipMarked and GetRaidTargetIndex(unitId)) then
			isFiltered = true
			DBM:Debug(unitId.." was skipped because it's a filtered mob. Friend Flag: "..(isFriend and "true" or "false"), 3)
		end
		if not isFiltered then
			--Table based scanning, used if applying to multiple creature Ids in a single scan
			--Can be used in both ascending/descending icon assignment or even specific icons per Id
			if guid and iconVariables[scanId].scanTable and type(iconVariables[scanId].scanTable) == "table" and iconVariables[scanId].scanTable[cid] and not addsGUIDs[guid] then
				DBM:Debug("Match found in mobUids, SHOULD be setting table icon on "..unitId, 1)
				if type(iconVariables[scanId].scanTable[cid]) == "number" then--CID in table is assigned a specific icon number
					SetRaidTarget(unitId, iconVariables[scanId].scanTable[cid])
					DBM:Debug("DBM called SetRaidTarget on "..unitId.." with icon value of "..iconVariables[scanId].scanTable[cid], 2)
					success = true
				else--Incremental Icon method (ie the table value for the cid was true not a number)
					SetRaidTarget(unitId, addsIcon[scanId])
					DBM:Debug("DBM called SetRaidTarget on "..unitId.." with icon value of "..addsIcon[scanId], 2)
					success = true
					if iconVariables[scanId].iconSetMethod == 1 then
						addsIcon[scanId] = addsIcon[scanId] + 1
					else
						addsIcon[scanId] = addsIcon[scanId] - 1
					end
				end
			elseif guid and (guid == scanId or cid == scanId) and not addsGUIDs[guid] then
				DBM:Debug("Match found in mobUids, SHOULD be setting icon on "..unitId, 1)
				if iconVariables[scanId].iconSetMethod == 2 then--Fixed Icon
					SetRaidTarget(unitId, addsIcon[scanId])
					DBM:Debug("DBM called SetRaidTarget on "..unitId.." with icon value of "..addsIcon[scanId], 2)
					success = true
				else--Incremental Icon method
					SetRaidTarget(unitId, addsIcon[scanId])
					DBM:Debug("DBM called SetRaidTarget on "..unitId.." with icon value of "..addsIcon[scanId], 2)
					success = true
					if iconVariables[scanId].iconSetMethod == 1 then--Asscending
						addsIcon[scanId] = addsIcon[scanId] + 1
					else--Descending
						addsIcon[scanId] = addsIcon[scanId] - 1
					end
				end
			end
		end
		if success then
			addsGUIDs[guid] = true
			addsIconSet[scanId] = addsIconSet[scanId] + 1
			DBM:Debug("SetRaidTarget succeeded. Total set "..(addsIconSet[scanId] or "unknown").." of "..(iconVariables[scanId].maxIcon or "unknown"), 2)
			if addsIconSet[scanId] >= iconVariables[scanId].maxIcon then--stop scan immediately to save cpu
				DBM:Unschedule(expireScan, scanId)
				DBM:Debug("Stopping Successful ScanForMobs for: "..(scanId or "nil"), 2)
				expireScan(scanId)
				return
			end
		end
		if GetTime() > scanExpires[scanId] then--scan for limited time.
			DBM:Unschedule(expireScan, scanId)
			DBM:Debug("Stopping Expired ScanForMobs for: "..(scanId or "nil"), 2)
			expireScan(scanId)
		end
	end

	function module:UPDATE_MOUSEOVER_UNIT()
		for scanId, _ in pairs(scanExpires) do
			executeMarking(scanId, "mouseover")
			--executeMarking(scanId, "mouseovertarget")
		end
	end

	function module:NAME_PLATE_UNIT_ADDED(unitId)
		for scanId, _ in pairs(scanExpires) do
			executeMarking(scanId, unitId)
		end
	end

	function module:FORBIDDEN_NAME_PLATE_UNIT_ADDED(unitId)
		for scanId, _ in pairs(scanExpires) do
			executeMarking(scanId, unitId)
		end
	end

	function module:UNIT_TARGET_UNFILTERED(unitId)
		for scanId, _ in pairs(scanExpires) do
			executeMarking(scanId, unitId.."target")
		end
	end

	--If this continues to throw errors because SetRaidTarget fails even after IEEU has fired for a unit, then this will be scrapped
	function module:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		for i = 1, 10 do
			local unitId = "boss"..i
			if UnitExists(unitId) and UnitIsVisible(unitId) then--Hopefully enough failsafe against icons failing
				for _, scanId in ipairs(scanExpires) do
					executeMarking(scanId, unitId)
				end
			end
		end
	end

	--Initial scan Ids. These exclude boss unit Ids because them existing doessn't mean they are valid yet. They are not valid until they are added to boss health frame
	--Attempting to SetRaidTarget on a non visible valid boss id actually just silently fails
	local mobUids = {
		"nameplate1", "nameplate2", "nameplate3", "nameplate4", "nameplate5", "nameplate6", "nameplate7", "nameplate8", "nameplate9", "nameplate10",
		"nameplate11", "nameplate12", "nameplate13", "nameplate14", "nameplate15", "nameplate16", "nameplate17", "nameplate18", "nameplate19", "nameplate20",
		"nameplate21", "nameplate22", "nameplate23", "nameplate24", "nameplate25", "nameplate26", "nameplate27", "nameplate28", "nameplate29", "nameplate30",
		"nameplate31", "nameplate32", "nameplate33", "nameplate34", "nameplate35", "nameplate36", "nameplate37", "nameplate38", "nameplate39", "nameplate40",
		"raid1target", "raid2target", "raid3target", "raid4target", "raid5target", "raid6target", "raid7target", "raid8target", "raid9target", "raid10target",
		"raid11target", "raid12target", "raid13target", "raid14target", "raid15target", "raid16target", "raid17target", "raid18target", "raid19target", "raid20target",
		"raid21target", "raid22target", "raid23target", "raid24target", "raid25target", "raid26target", "raid27target", "raid28target", "raid29target", "raid30target",
		"raid31target", "raid32target", "raid33target", "raid34target", "raid35target", "raid36target", "raid37target", "raid38target", "raid39target", "raid40target",
		"party1target", "party2target", "party3target", "party4target",
		"mouseover", "target", "focus", "targettarget", "mouseovertarget"
	}

	function module:ScanForMobs(mod, scanId, iconSetMethod, mobIcon, maxIcon, scanTable, scanningTime, optionName, allowFriendly, skipMarked, allAllowed)
		if not optionName then optionName = mod.findFastestComputer[1] end
		if private.canSetIcons[optionName] or (allAllowed and not DBM.Options.DontSetIcons) then
			--Declare variables.
			DBM:Debug("canSetIcons or allAllowed true for "..(optionName or "nil"), 2)
			if not scanId then--Accepts cid and guid
				error("DBM:ScanForMobs calld without scanId")
				return
			end
			--Initialize icon method variables for event handlers
			scansActive = scansActive + 1
			if not addsIcon[scanId] then addsIcon[scanId] = mobIcon or 8 end
			if not addsIconSet[scanId] then addsIconSet[scanId] = 0 end
			if not iconVariables[scanId] then iconVariables[scanId] = {} end
			iconVariables[scanId].iconSetMethod = iconSetMethod or 0--Set IconSetMethod -- 0: Descending / 1:Ascending / 2: Force Set / 9:Force Stop
			iconVariables[scanId].maxIcon = maxIcon or 8 --We only have 8 icons.
			iconVariables[scanId].allowFriendly = allowFriendly and true or false
			iconVariables[scanId].skipMarked = skipMarked and true or false
			if not scanExpires[scanId] then
				scanExpires[scanId] = GetTime() + (scanningTime or 8)
				DBM:Schedule((scanningTime or 8)+1, expireScan, scanId)
			end
			if scanTable and type(scanTable) == "table" then
				iconVariables[scanId].scanTable = scanTable
			end
			if (iconSetMethod or 0) == 9 then--Force stop scanning
				DBM:Unschedule(expireScan, scanId)
				expireScan(scanId)
				return
			end
			--Do initial scan now to see if unit we're scaning for already exists (ie they wouldn't fire nameplate added or IEEU for example.
			--Caveat, if all expected units are found before it finishes going over mobUids table, it'll still finish goingg through table
			for _, unitId in ipairs(mobUids) do
				executeMarking(scanId, unitId)
			end
			--Hopefully we found all units with initial scan and scanExpires has already been emptied in the executeMarking calls
			--But if not, we Register listeners to watch for the units we seek to appear
			if not eventsRegistered and scansActive > 0 then
				eventsRegistered = true
				if isRetail then
					self:RegisterShortTermEvents("UPDATE_MOUSEOVER_UNIT", "UNIT_TARGET_UNFILTERED", "NAME_PLATE_UNIT_ADDED", "FORBIDDEN_NAME_PLATE_UNIT_ADDED", "INSTANCE_ENCOUNTER_ENGAGE_UNIT")
				else
					self:RegisterShortTermEvents("UPDATE_MOUSEOVER_UNIT", "UNIT_TARGET_UNFILTERED", "NAME_PLATE_UNIT_ADDED", "FORBIDDEN_NAME_PLATE_UNIT_ADDED")
				end
				DBM:Debug("Target events Registered", 2)
			end
		else
			DBM:Debug("Not elected to set icons for "..(optionName or "nil"), 2)
		end
	end
end
