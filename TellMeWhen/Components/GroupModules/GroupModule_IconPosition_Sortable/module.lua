-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local OnGCD = TMW.OnGCD

local IconPosition_Sortable = TMW:NewClass("GroupModule_IconPosition_Sortable", "GroupModule_IconPosition")


IconPosition_Sortable:RegisterGroupDefaults{
	LayoutDirection = 1,
	ShrinkGroup = false,
	
	SortPriorities = {
		[1] = {
			Method = "id",
			Order = 1,
		},
	},
}


TMW:RegisterCallback("TMW_DB_PRE_DEFAULT_UPGRADES", function() -- 74004
	-- Storing these defaults the way that they are in this table is horrible,
	-- because we can't add or remove anything without it butchering everyone's old
	-- settings. This salvages all existing settings so that we can move to a better way of
	-- saving these priorities.

	local oldPriorities = {
		{ Method = "id",			Order =	1,	},
		{ Method = "duration",		Order =	1,	},
		{ Method = "stacks",		Order =	-1,	},
		{ Method = "visiblealpha",	Order =	-1,	},
		{ Method = "visibleshown",	Order =	-1,	},
		{ Method = "alpha",			Order =	-1,	},
		{ Method = "shown",			Order =	-1,	},
	}
	
	local needFixing = {}
	if TellMeWhenDB.Version < 74004 then
		if TellMeWhenDB.profiles then
			for _, p in pairs(TellMeWhenDB.profiles) do
				if p.Groups then
					for _, gs in pairs(p.Groups) do
						tinsert(needFixing, gs.SortPriorities)
					end
				end
			end
		end

		if TellMeWhenDB.global and TellMeWhenDB.global.Groups then
			for _, gs in pairs(TellMeWhenDB.global.Groups) do
				tinsert(needFixing, gs.SortPriorities)
			end
		end

		for _, SortPriorities in pairs(needFixing) do
			for i = 1, #oldPriorities do
				if not SortPriorities[i] then
					SortPriorities[i] = CopyTable(oldPriorities[i])
				else
					SortPriorities[i].Method = SortPriorities[i].Method or oldPriorities[i].Method
					SortPriorities[i].Order = SortPriorities[i].Order or oldPriorities[i].Order
				end
			end
		end
	end
end)

TMW:RegisterUpgrade(74004, {
	group = function(self, gs)
		local deleteAlpha = false
		local deleteShown = false
		local foundID = false
		local remove = {}
		for i, data in pairs(gs.SortPriorities) do

			if data.Method == "id" then
				foundID = true

			elseif foundID then
				remove[i] = true

			elseif data.Method == "visiblealpha" or data.Method == "alpha" then
				if not deleteAlpha then
					deleteAlpha = true
					data.Method = "alpha"
				else
					remove[i] = true
				end

			elseif data.Method == "visibleshown" or data.Method == "shown" then
				if not deleteShown then
					deleteShown = true
					data.Method = "shown"
				else
					remove[i] = true
				end
			end
		end

		for i = #gs.SortPriorities, 1, -1 do
			if remove[i] then
				tremove(gs.SortPriorities, i)
			end
		end
	end,
})


IconPosition_Sortable:RegisterConfigPanel_XMLTemplate(20, "TellMeWhen_GM_IconPosition_Sortable")
IconPosition_Sortable:RegisterConfigPanel_XMLTemplate(21, "TellMeWhen_GM_IconPosition_Sortable_Dir")


IconPosition_Sortable.Presets = {}
function IconPosition_Sortable:RegisterIconSortPreset(name, settings)
	IconPosition_Sortable.Presets[name] = settings
end

IconPosition_Sortable.Sorters = {}
local sorters = IconPosition_Sortable.Sorters

function IconPosition_Sortable:RegisterIconSorter(identifier, data, func)
	self:AssertSelfIsClass()

	local sig = "IconPosition_Sortable:RegisterIconSorter(identifier, data, func)"
	TMW:ValidateType("identifier", sig, identifier, "string")
	TMW:ValidateType("data", sig, data, "table")
	TMW:ValidateType("func", sig, func, "function")

	TMW:ValidateType("data.DefaultOrder", sig, data.DefaultOrder, "number")
	TMW:ValidateType("data[1]", sig, data[1], "string")
	TMW:ValidateType("data[-1]", sig, data[-1], "string")

	if sorters[identifier] then
		error("An icon sorter with identifier " .. identifier .. " already exists")
	end

	sorters[identifier] = data
	data.func = func
end




IconPosition_Sortable:RegisterIconSorter("id", {
	DefaultOrder = 1,
	[1] = L["UIPANEL_GROUPSORT_id_1"],
	[-1] = L["UIPANEL_GROUPSORT_id_-1"],
}, function(iconA, iconB, attributesA, attributesB, order)
	return iconA.ID*order < iconB.ID*order
end)

IconPosition_Sortable:RegisterIconSortPreset(L["UIPANEL_GROUP_QUICKSORT_DEFAULT"], {
	{ Method = "id", Order = 1 }
})




function IconPosition_Sortable:OnNewInstance_IconPosition_Sortable()
	self.SortedIcons = {}
	self.SortedIconsManager = TMW.Classes.UpdateTableManager:New()
	self.SortedIconsManager:UpdateTable_Set(self.SortedIcons)
end

function IconPosition_Sortable:OnEnable()
	local group = self.group
	
	self.ShrinkGroup = group.ShrinkGroup
	if (self.ShrinkGroup or group.SortPriorities[1].Method ~= "id") and group.numIcons > 1 then
		TMW:RegisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_POST", self)
		TMW:RegisterCallback("TMW_ICON_UPDATED", self)
	end
	TMW:RegisterCallback("TMW_GROUP_SETUP_POST", self)
end
	
function IconPosition_Sortable:OnDisable()
	wipe(self.SortedIcons)
	
	TMW:UnregisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_POST", self)
	TMW:UnregisterCallback("TMW_ICON_UPDATED", self)
	TMW:UnregisterCallback("TMW_GROUP_SETUP_POST", self)
end
	
	
function IconPosition_Sortable:Icon_SetPoint(icon, positionID)
	self:AssertSelfIsInstance()
	--[[
		ABBR	DIR 1, DIR 2	VAL		VAL%4
		RD		RIGHT, DOWN 	1		1 (normal)
		LD		LEFT, DOWN		2		2
		LU		LEFT, UP		3		3
		RU		RIGHT, UP		4		0
		DR		DOWN, RIGHT		5		1
		DL		DOWN, LEFT		6		2
		UL		UP, LEFT		7		3
		UR		UP, RIGHT		8		0
	]]
	
	local group = self.group
	local gs = group:GetSettings()
	local gspv = group:GetSettingsPerView()
	local LayoutDirection = group.LayoutDirection
	
	local row, column
	
	if LayoutDirection >= 5 then
		local Rows = group.Rows
		
		row = (positionID - 1) % Rows + 1
		column = ceil(positionID / Rows)
	else
		local Columns = group.Columns
		
		row = ceil(positionID / Columns)
		column = (positionID - 1) % Columns + 1
	end
	
	local sizeX, sizeY = group.viewData:Icon_GetSize(icon)
	local x, y = (sizeX + gspv.SpacingX)*(column-1), (sizeY + gspv.SpacingY)*(row-1)
	
	
	local point
	if LayoutDirection % 4 == 1 then
		point = "TOPLEFT"
		x, y = x, -y
	elseif LayoutDirection % 4 == 2 then
		point = "TOPRIGHT"
		x, y = -x, -y
	elseif LayoutDirection % 4 == 3 then
		point = "BOTTOMRIGHT"
		x, y = -x, y
	elseif LayoutDirection % 4 == 0 then
		point = "BOTTOMLEFT"
		x, y = x, y
	end
	
	local position = icon.position
	position.relativeTo = group
	position.point, position.relativePoint = point, point
	position.x, position.y = x, y
	
	icon:ClearAllPoints()
	icon:SetPoint(point, group, point, x, y)

	return x, y
end

function IconPosition_Sortable.IconSorter(iconA, iconB)
	local SortPriorities = iconA.group.SortPriorities
	
	local attributesA = iconA.attributes
	local attributesB = iconB.attributes

	local Locked = TMW.Locked
	
	for p = 1, #SortPriorities do
		local settings = SortPriorities[p]
		local method = settings.Method
		local order = settings.Order

		if Locked or method == "id" then
			-- Force sorting by ID when unlocked.
			-- Don't force the first one to be "id" because it also depends on the order that the user has set.
			
			local data = sorters[method]
			if data then
				local ret = data.func(iconA, iconB, attributesA, attributesB, order)
				if ret ~= nil then
					return ret
				end
			else
				TMW:Warn("Missing icon sorter with identifier " .. method)
			end
		end
	end
end

function IconPosition_Sortable:PositionIcons()
	local SortedIcons = self.SortedIcons
	sort(SortedIcons, self.IconSorter)

	local maxX, maxY = 0, 0
	local ShrinkGroup = self.ShrinkGroup
	for positionID = 1, #SortedIcons do
		local icon = SortedIcons[positionID]
		local x, y = self:Icon_SetPoint(icon, positionID)
		local sizeX, sizeY = self.group.viewData:Icon_GetSize(icon)
		if ShrinkGroup and icon.attributes.shown and icon.attributes.realAlpha > 0 then
			maxX = max(maxX, abs(x) + sizeX)
			maxY = max(maxY, abs(y) + sizeY)
		end
	end

	if ShrinkGroup then
		-- Frames can't be anchored to other frames that have a size of 0.
		-- So, we put a minimum of 0.1 to get around this.
		-- See also: GitHub #1694
		self.group:SetSize(max(maxX, 0.1), max(maxY, 0.1))
	end
end

function IconPosition_Sortable:AdjustIconsForModNumRowsCols(deltaRows, deltaCols)
	-- do nothing for rows

	local group = self.group
	local LayoutDirection = group.LayoutDirection

	if not group.__iconPosClobbered then
		group.__iconPosClobbered = setmetatable({}, {__index = function(t, k)
            t[k] = {}
            return t[k]
		end})
	end

	if deltaRows ~= 0 and LayoutDirection >= 5 then

		local rows_old = group.Rows
		local rows_new = group.Rows + deltaRows

		
		local iconsCopy = TMW.shallowCopy(group:GetSettings().Icons)
		wipe(group:GetSettings().Icons)

		for iconID, ics in pairs(iconsCopy) do
			local row_old = (iconID - 1) % rows_old + 1
			local column_old = ceil(iconID / rows_old)

			local row_new = (iconID - 1) % rows_new + 1
			local column_new = ceil(iconID / rows_new)


			local newIconID = iconID + (column_old-1)*deltaRows


		    if row_old > rows_new then
		    	if self:ClobberCheck(ics) then
		    	    group.__iconPosClobbered[row_old][column_old] = ics
			    end
		    else
		    	group:GetSettings().Icons[newIconID] = ics

		    	if row_old == rows_old then
		    		for i = rows_old + 1, rows_new do
		    			local newIconID = newIconID + i - rows_old
		    			local column_new = ceil(newIconID / rows_new)

		    			group:GetSettings().Icons[newIconID] = group.__iconPosClobbered[i][column_new]
		    		end
		    	end
		    end
		end

		-- Causes a whole lot of warnings that are wrong if we don't do this.
		wipe(TMW.ValidityCheckQueue)

	elseif deltaCols ~= 0 and LayoutDirection <= 4 then
		local columns_old = group.Columns
		local columns_new = group.Columns + deltaCols

		
		local iconsCopy = TMW.shallowCopy(group:GetSettings().Icons)
		wipe(group:GetSettings().Icons)

		for iconID, ics in pairs(iconsCopy) do
			local row_old = ceil(iconID / columns_old)
			local column_old = (iconID - 1) % columns_old + 1

			local row_new = ceil(iconID / columns_new)
			local column_new = (iconID - 1) % columns_new + 1

			local newIconID = iconID + (row_old-1)*deltaCols


		    if column_old > columns_new then
		    	if self:ClobberCheck(ics) then
			        group.__iconPosClobbered[column_old][row_old] = ics
			    end
		    else
		    	group:GetSettings().Icons[newIconID] = ics

		    	if column_old == columns_old then
		    		for i = columns_old + 1, columns_new do
		    			local newIconID = newIconID + i - columns_old
		    			local row_new = ceil(newIconID / columns_new)

		    			group:GetSettings().Icons[newIconID] = group.__iconPosClobbered[i][row_new]
		    		end
		    	end
		    end
		end

		-- Causes a whole lot of warnings that are wrong if we don't do this.
		wipe(TMW.ValidityCheckQueue)
	end
end


function IconPosition_Sortable:TMW_ONUPDATE_TIMECONSTRAINED_POST(event, time, Locked)
	if self.iconSortNeeded then
		self:PositionIcons()
		self.iconSortNeeded = nil
	end
end

function IconPosition_Sortable:TMW_ICON_UPDATED(event, icon)
	if self.group == icon.group then
		self.iconSortNeeded = true
	end
end

function IconPosition_Sortable:TMW_GROUP_SETUP_POST(event, group)
	if self.group == group and group:ShouldUpdateIcons() then
	
		for iconID = 1, group.numIcons do
			local icon = group[iconID]
			if icon then
				self.SortedIconsManager:UpdateTable_Register(group[iconID])
			end
		end
	
		self:PositionIcons()
	end
end



