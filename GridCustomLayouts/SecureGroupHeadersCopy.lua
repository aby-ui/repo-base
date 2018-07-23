--This file is copied from Blizzard SecureGroupHeaders.lua (SecureTemplates.lua before 4.0)
--The goal is copy the method SecureGroupHeader_Update to return a sortingTable
--So all relating local functions should be copied 
-- and change SecureGroupHeader_Update to SecureGroupHeader_UpdateCopy
-- and make SecureGroupHeader_UpdateCopy return the sortingTable

local pairs, ipairs, strtrim = pairs, ipairs, string.trim;

local function GetGroupHeaderType(self)
	local kind, start, stop;

	local nRaid = GetNumGroupMembers();
	local nParty = GetNumSubgroupMembers();
	if ( IsInRaid() and self:GetAttribute("showRaid") ) then
		kind = "RAID";
	elseif ( IsInGroup() and self:GetAttribute("showParty") ) then
		kind = "PARTY";
	elseif ( self:GetAttribute("showSolo") ) then
		kind = "SOLO";
	end
	if ( kind ) then
		if ( kind == "RAID" ) then
			start = 1;
			stop = nRaid;
		else
			if ( kind == "SOLO" or self:GetAttribute("showPlayer") ) then
				start = 0;
			else
				start = 1;
			end
			stop = nParty;
		end
	end
	return kind, start, stop;
end

local function GetGroupRosterInfo(kind, index)
	local _, unit, name, subgroup, className, role, server, assignedRole;
	if ( kind == "RAID" ) then
		unit = "raid"..index;
		name, _, subgroup, _, _, className, _, _, _, role, _, assignedRole = GetRaidRosterInfo(index);
	else
		if ( index > 0 ) then
			unit = "party"..index;
		else
			unit = "player";
		end
		if ( UnitExists(unit) ) then
			name, server = UnitName(unit);
			if (server and server ~= "") then
				name = name.."-"..server
			end
			_, className = UnitClass(unit);
			if ( GetPartyAssignment("MAINTANK", unit) ) then
				role = "MAINTANK";
			elseif ( GetPartyAssignment("MAINASSIST", unit) ) then
				role = "MAINASSIST";
			end
			assignedRole = UnitGroupRolesAssigned(unit)
		end
		subgroup = 1;
	end
	return unit, name, subgroup, className, role, assignedRole;
end

-- empties tbl and assigns the value true to each key passed as part of ...
local function fillTable( tbl, ... )
	for i = 1, select("#", ...), 1 do
		local key = select(i, ...);
		key = tonumber(key) or strtrim(key);
		tbl[key] = i;
	end
end

-- same as fillTable() except that each key is also stored in
-- the array portion of the table in order
local function doubleFillTable( tbl, ... )
	fillTable(tbl, ...);
	for i = 1, select("#", ...), 1 do
		local key = select(i, ...)
		tbl[i] = strtrim(key)
	end
end

--working tables
local tokenTable = {};
local sortingTable = {};
local groupingTable = {};
local tempTable = {};

local function sortOnGroupWithNames(a, b)
	local order1 = tokenTable[ groupingTable[a] ];
	local order2 = tokenTable[ groupingTable[b] ];
	if ( order1 ) then
		if ( not order2 ) then
			return true;
		else
			if ( order1 == order2 ) then
				return sortingTable[a] < sortingTable[b];
			else
				return order1 < order2;
			end
		end
	else
		if ( order2 ) then
			return false;
		else
			return sortingTable[a] < sortingTable[b];
		end
	end
end

local function sortOnGroupWithIDs(a, b)
	local order1 = tokenTable[ groupingTable[a] ];
	local order2 = tokenTable[ groupingTable[b] ];
	if ( order1 ) then
		if ( not order2 ) then
			return true;
		else
			if ( order1 == order2 ) then
				return tonumber(a:match("%d+") or -1) < tonumber(b:match("%d+") or -1);
			else
				return order1 < order2;
			end
		end
	else
		if ( order2 ) then
			return false;
		else
			return tonumber(a:match("%d+") or -1) < tonumber(b:match("%d+") or -1);
		end
	end
end

local function sortOnNames(a, b)
	return sortingTable[a] < sortingTable[b];
end

local function sortOnNameList(a, b)
	return tokenTable[ sortingTable[a] ] < tokenTable[ sortingTable[b] ];
end

function SecureGroupHeader_UpdateCopy(self)
	local nameList = self:GetAttribute("nameList");
	local groupFilter = self:GetAttribute("groupFilter");
	local roleFilter = self:GetAttribute("roleFilter");
	local sortMethod = self:GetAttribute("sortMethod");
	local groupBy = self:GetAttribute("groupBy");

	wipe(sortingTable);

	-- See if this header should be shown
	local kind, start, stop = GetGroupHeaderType(self);
	if ( not kind ) then
        ChatFrame1:AddMessage(table.concat({"Wrong group header filters", self:GetAttribute("showRaid"), self:GetAttribute("showParty"), self:GetAttribute("showSolo"), self:GetAttribute("showPlayer")}, ", "), 1, 0, 0)
		--configureChildren(self, sortingTable);
		return {};
	end

	if ( not groupFilter and not roleFilter and not nameList ) then
		groupFilter = "1,2,3,4,5,6,7,8";
	end

	if ( groupFilter or roleFilter ) then
		local strictFiltering = self:GetAttribute("strictFiltering"); -- non-strict by default
		wipe(tokenTable)
		if ( groupFilter and not roleFilter ) then
			-- filtering by a list of group numbers and/or classes
			fillTable(tokenTable, strsplit(",", groupFilter));
			if ( strictFiltering ) then
				fillTable(tokenTable, "MAINTANK", "MAINASSIST", "TANK", "HEALER", "DAMAGER", "NONE")
			end
		
		elseif ( roleFilter and not groupFilter ) then
			-- filtering by role (of either type)
			fillTable(tokenTable, strsplit(",", roleFilter));
			if ( strictFiltering ) then
				fillTable(tokenTable, 1, 2, 3, 4, 5, 6, 7, 8, unpack(CLASS_SORT_ORDER))
			end
		
		else
			-- filtering by group, class and/or role
			fillTable(tokenTable, strsplit(",", groupFilter));
			fillTable(tokenTable, strsplit(",", roleFilter));
		
		end

		for i = start, stop, 1 do
			local unit, name, subgroup, className, role, assignedRole = GetGroupRosterInfo(kind, i);
			
			if ( name and
				((not strictFiltering) and
					( tokenTable[subgroup] or tokenTable[className] or (role and tokenTable[role]) or tokenTable[assignedRole] ) -- non-strict filtering
				) or
					( tokenTable[subgroup] and tokenTable[className] and ((role and tokenTable[role]) or tokenTable[assignedRole]) ) -- strict filtering
			) then
				tinsert(sortingTable, unit);
				sortingTable[unit] = name;
				if ( groupBy == "GROUP" ) then
					groupingTable[unit] = subgroup;

				elseif ( groupBy == "CLASS" ) then
					groupingTable[unit] = className;

				elseif ( groupBy == "ROLE" ) then
					groupingTable[unit] = role;
				
				elseif ( groupBy == "ASSIGNEDROLE" ) then
					groupingTable[unit] = assignedRole;
				
				end
			end
		end

		if ( groupBy ) then
			local groupingOrder = self:GetAttribute("groupingOrder");
			doubleFillTable(wipe(tokenTable), strsplit(",", groupingOrder:gsub("%s+", "")));
			if ( sortMethod == "NAME" ) then
				table.sort(sortingTable, sortOnGroupWithNames);
			else
				table.sort(sortingTable, sortOnGroupWithIDs);
			end
		elseif ( sortMethod == "NAME" ) then -- sort by ID by default
			table.sort(sortingTable, sortOnNames);
		end

	else
		-- filtering via a list of names
		doubleFillTable(wipe(tokenTable), strsplit(",", nameList));
		for i = start, stop, 1 do
			local unit, name = GetGroupRosterInfo(kind, i);
			if ( tokenTable[name] ) then
				tinsert(sortingTable, unit);
				sortingTable[unit] = name;
			end
		end
		if ( sortMethod == "NAME" ) then
			table.sort(sortingTable, sortOnNames);
		elseif ( sortMethod == "NAMELIST" ) then
			table.sort(sortingTable, sortOnNameList)
		end

	end

	return sortingTable; --configureChildren(self, sortingTable);

end