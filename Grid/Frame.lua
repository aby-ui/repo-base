--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
----------------------------------------------------------------------]]

local GRID, Grid = ...
local L = Grid.L
local format, gsub, pairs, tonumber, type = format, gsub, pairs, tonumber, type
local GridStatus, GridStatusRange

local Media = LibStub("LibSharedMedia-3.0")
Media:Register("statusbar", "Gradient", "Interface\\Addons\\Grid\\Media\\gradient32x32")

local GridFrame = Grid:NewModule("GridFrame", "AceBucket-3.0", "AceTimer-3.0")
GridFrame.indicators = {}
GridFrame.prototype = {}

------------------------------------------------------------------------

local defaultOrder = {
	border = 1,
	bar = 2,
	barcolor = 3,
	healingBar = 4,
	text = 5,
	text2 = 6,
	icon = 7,
	corner3 = 8,
	corner4 = 9,
	corner1 = 10,
	corner2 = 11,
	frameAlpha = 12,
}

local defaultNew = function() return {} end
local defaultReset = function() end

function GridFrame:RegisterIndicator(id, name, newFunc, resetFunc, setFunc, clearFunc)
	assert(type(id) == "string", "GridFrame:RegisterIndicator - id must be a string")
	assert(not self.indicators[id], "GridFrame:RegisterIndicator - id must be unique")
	assert(type(setFunc) == "function", "GridFrame:RegisterIndicator - setFunc must be a function")
	assert(type(clearFunc) == "function", "GridFrame:RegisterIndicator - clearFunc must be a function")

	self.indicators[id] = {
		id = id,
		name = type(name) == "string" and name or id,
		New = type(newFunc) == "function" and newFunc or defaultNew,
		Reset = type(resetFunc) == "function" and resetFunc or defaultReset,
		SetStatus = setFunc,
		Clear = clearFunc,
	}

	if not self.registeredFrames then return end -- not initialized yet

	for _, frame in pairs(self.registeredFrames) do
		frame:AddIndicator(id)
		frame:ResetIndicator(id)
		self:UpdateIndicators(frame)
	end
end

function GridFrame.prototype:AddIndicator(id)
	local prototype = GridFrame.indicators[id]
	local indicator = prototype.New(self)
	if not indicator then
		return GridFrame:Debug("AddIndicator: creation failed for id", id, type(prototype), type(prototype.New))
	end
	indicator.__id = id
	indicator.__owner = self
	indicator.Reset = prototype.Reset
	indicator.SetStatus = prototype.SetStatus
	indicator.Clear = prototype.Clear
	self.indicators[id] = indicator
end

function GridFrame.prototype:ResetIndicator(id)
	local indicator = self.indicators[id]
	if indicator then
		indicator:Reset()
	else
		GridFrame:Debug("ResetIndicator:", id, "does not exist")
	end
end

function GridFrame.prototype:ResetAllIndicators()
	-- Reset default indicators first:
	for id, indicator in pairs(self.indicators) do
		if defaultOrder[id] then
			indicator:Reset()
		end
	end
	-- Then custom ones:
	for id, indicator in pairs(self.indicators) do
		if not defaultOrder[id] then
			indicator:Reset()
		end
	end
end

------------------------------------------------------------------------

local initialConfigSnippet = [[
   self:SetWidth(%d)
   self:SetHeight(%d)
   self:SetAttribute("initial-width", %d)
   self:SetAttribute("initial-height", %d)
   local attr = self:GetAttribute("*type2")
   if attr == "togglemenu" or attr == nil then
      self:SetAttribute("*type2", %s)
   end
]]

function GridFrame:GetInitialConfigSnippet()
	return format(initialConfigSnippet,
		self.db.profile.frameWidth, self.db.profile.frameHeight,
		self.db.profile.frameWidth, self.db.profile.frameHeight,
		self.db.profile.rightClickMenu and '"togglemenu"' or 'nil'
	)
end

function GridFrame:InitializeFrame(frame)
	self:Debug("InitializeFrame", frame:GetName())

	for k, v in pairs(self.prototype) do
		frame[k] = v
	end

	frame:SetNormalTexture("")
	frame:SetHighlightTexture("")

	frame:RegisterForClicks("AnyUp")

	frame:HookScript("OnEnter", frame.OnEnter)
	frame:HookScript("OnLeave", frame.OnLeave)
	frame:HookScript("OnShow",  frame.OnShow)
	frame:HookScript("OnAttributeChanged", frame.OnAttributeChanged)

	frame.indicators = {}
	for id in pairs(self.indicators) do
		frame:AddIndicator(id)
	end
	frame:ResetAllIndicators()

	return frame
end

------------------------------------------------------------------------

-- shows the default unit tooltip
function GridFrame.prototype:OnEnter()
	local unit = self.unit
	local showTooltip = GridFrame.db.profile.showTooltip
	if unit and UnitExists(unit) and (showTooltip == "Always" or (showTooltip == "OOC" and (not InCombatLockdown() or UnitIsDeadOrGhost(unit)))) then
		UnitFrame_OnEnter(self)
	end
end

function GridFrame.prototype:OnLeave()
	UnitFrame_OnLeave(self)
end

function GridFrame.prototype:OnShow()
	GridFrame:SendMessage("UpdateFrameUnits")
	GridFrame:SendMessage("Grid_UpdateLayoutSize")
end

function GridFrame.prototype:OnAttributeChanged(name, value)
	if name == "unit" then
		return GridFrame:SendMessage("UpdateFrameUnits")
	elseif self:CanChangeAttribute() then
		if name == "type1" then
			if not value or value == "" then
				self:SetAttribute("type1", "target")
			end
		elseif name == "*type2" then
			local wantmenu = GridFrame.db.profile.rightClickMenu
			--print(self.unit, "OnAttributeChanged", name, value, wantmenu)
			if wantmenu and (not value or value == "") then
				self:SetAttribute("*type2", "togglemenu")
			elseif value == "togglemenu" and not wantmenu then
				self:SetAttribute("*type2", nil)
			end
		end
	end
end

------------------------------------------------------------------------

local COLOR_WHITE = { r = 1, g = 1, b = 1, a = 1 }
local COORDS_FULL = { left = 0, right = 1, top = 0, bottom = 1 }

function GridFrame.prototype:SetIndicator(id, color, text, value, maxValue, texture, start, duration, count, texCoords)
	local profile = GridFrame.db.profile

	if not color then
		color = COLOR_WHITE
	end
	if value and not maxValue then
		maxValue = 100
	end
	if texture and not texCoords then
		texCoords = COORDS_FULL
	end

	local indicator = self.indicators[id]
	if indicator then
		indicator:SetStatus(color, text, value, maxValue, texture, texCoords, count, start, duration)
	else
		GridFrame:Debug("SetIndicator:", id, "does not exist")
	end

	--[[ TODO: Why does this exist?
	elseif indicator == "frameAlpha" and type(color) == "table" and type(color.a) == "number" then
		for i = 1, 4 do
			local corner = "corner" .. i
			if self[corner] then
				self[corner]:SetAlpha(color.a)
			end
		end
	]]
end

function GridFrame.prototype:ClearIndicator(id)
	local indicator = self.indicators[id]
	if indicator then
		indicator:Clear()
	else
		GridFrame:Debug("ClearIndicator:", id, "does not exist")
	end

	--[[ TODO: Why does this exist?
	elseif indicator == "frameAlpha" then
		for i = 1, 4 do
			local corner = "corner" .. i
			if self[corner] then
				self[corner]:SetAlpha(1)
			end
		end
	]]
end

------------------------------------------------------------------------

GridFrame.defaultDB = {
	frameWidth = 36,
	frameHeight = 36,
	borderSize = 1,
	cornerSize = 6,
	showTooltip = "OOC",
	rightClickMenu = true,
	orientation = "VERTICAL",
	textorientation = "VERTICAL",
	throttleUpdates = false,
	texture = "Gradient",
	enableBarColor = false,
	invertBarColor = false,
	invertTextColor = false,
	healingBar_intensity = 0.5,
	healingBar_useStatusColor = false,
	iconSize = 16,
	iconBorderSize = 1,
	enableIconCooldown = true,
	enableIconStackText = true,
	font = "Friz Quadrata TT",
	fontSize = 12,
	fontOutline = "NONE",
	fontShadow = true,
	textlength = 4,
	enableText2 = false,
	statusmap = {
		text = {
			alert_death = true,
			alert_feignDeath = true,
			alert_heals = true,
			alert_offline = true,
			debuff_Ghost = true,
			unit_healthDeficit = true,
			unit_name = true,
		},
		text2 = {
			alert_death = true,
			alert_feignDeath = true,
			alert_offline = true,
			debuff_Ghost = true,
		},
		border = {
			alert_aggro = true,
			alert_lowHealth = true,
			alert_lowMana = true,
			player_target = true,
		},
		corner4 = { -- Top Right
			leader = true,
			assistant = true,
			master_looter = true,
		},
		corner3 = { -- Top Left
			role = true,
		},
		corner1 = { -- Bottom Left
			alert_aggro = true,
		},
		corner2 = { -- Bottom Right
			dispel_curse = true,
			dispel_disease = true,
			dispel_magic = true,
			dispel_poison = true,
		},
		frameAlpha = {
			alert_death = true,
			alert_offline = true,
			alert_range = true,
		},
		bar = {
			alert_death = true,
			alert_offline = true,
			debuff_Ghost = true,
			unit_health = true,
		},
		barcolor = {
			alert_death = true,
			alert_offline = true,
			debuff_Ghost = true,
			unit_health = true,
		},
		healingBar = {
			alert_heals = true,
			alert_absorbs = true,
		},
		icon = {
			raid_icon = true,
			ready_check = true,
		}
	},
}

------------------------------------------------------------------------

local reloadHandle

function GridFrame:Grid_ReloadLayout()
	if reloadHandle then
		self:CancelTimer(reloadHandle) reloadHandle = nil --163ui returns true
	end
	self:SendMessage("Grid_ReloadLayout")
end

GridFrame.options = {
	name = L["Frame"],
	desc = L["Options for GridFrame."],
	order = 2,
	type = "group",
	childGroups = "tab",
	disabled = InCombatLockdown,
	get = function(info)
		local k = info[#info]
		return GridFrame.db.profile[k]
	end,
	set = function(info, v)
		local k = info[#info]
		GridFrame.db.profile[k] = v
		GridFrame:UpdateAllFrames()
	end,
	args = {
		general = {
			name = L["General"],
			order = 1,
			type = "group",
			args = {
				frameWidth = {
					name = L["Frame Width"],
					desc = L["Adjust the width of each unit's frame."],
					order = 1, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					set = function(info, v)
						GridFrame.db.profile.frameWidth = v
						GridFrame:ResizeAllFrames()
					end,
				},
				frameHeight = {
					name = L["Frame Height"],
					desc = L["Adjust the height of each unit's frame."],
					order = 2, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					set = function(info, v)
						GridFrame.db.profile.frameHeight = v
						GridFrame:ResizeAllFrames()
					end,
				},
				borderSize = {
					name = L["Border Size"],
					desc = L["Adjust the size of the border indicators."],
					order = 3, width = "double",
					type = "range", min = 1, max = 9, step = 1,
				},
				cornerSize = {
					name = L["Corner Size"],
					desc = L["Adjust the size of the corner indicators."],
					order = 4, width = "double",
					type = "range", min = 1, max = 20, step = 1,
				},
				showTooltip = {
					name = L["Show Tooltip"],
					desc = L["Show unit tooltip.  Choose 'Always', 'Never', or 'OOC'."],
					order = 5, width = "double",
					type = "select",
					values = { Always = L["Always"], Never = L["Never"], OOC = L["OOC"] },
					set = function(info, v)
						GridFrame.db.profile.showTooltip = v
					end,
				},
				rightClickMenu = {
					name = L["Enable right-click menu"],
					desc = L["Show the standard unit menu when right-clicking on a frame."],
					order = 6, width = "double",
					type = "toggle",
					set = function(info, v)
						GridFrame.db.profile.rightClickMenu = v
						for _, frame in pairs(GridFrame.registeredFrames) do
							local attrib = frame:GetAttribute("*type2") or ""
							if attrib == "togglemenu" and not v then
								frame:SetAttribute("*type2", nil)
							elseif v and attrib == "" then
								frame:SetAttribute("*type2", "togglemenu")
							end
						end
					end,
				},
				orientation = {
					name = L["Orientation of Frame"],
					desc = L["Set frame orientation."],
					order = 7, width = "double",
					type = "select",
					values = {
						VERTICAL = L["Vertical"],
						HORIZONTAL = L["Horizontal"]
					},
				},
				textorientation = {
					name = L["Orientation of Text"],
					desc = L["Set frame text orientation."],
					order = 8, width = "double",
					type = "select",
					values = {
						VERTICAL = L["Vertical"],
						HORIZONTAL = L["Horizontal"]
					},
				},
				throttleUpdates = {
					name = L["Throttle Updates"],
					desc = L["Throttle updates on group changes. This option may cause delays in updating frames, so you should only enable it if you're experiencing temporary freezes or lockups when people join or leave your group."],
					type = "toggle",
					order = 9, width = "double",
					set = function(info, v)
						GridFrame.db.profile.throttleUpdates = v
						if v then
							GridFrame:UnregisterMessage("UpdateFrameUnits")
							GridFrame.bucket_UpdateFrameUnits = GridFrame:RegisterBucketMessage("UpdateFrameUnits", 0.1)
						else
							GridFrame:UnregisterBucket(GridFrame.bucket_UpdateFrameUnits, true)
							GridFrame:RegisterMessage("UpdateFrameUnits")
							GridFrame.bucket_UpdateFrameUnits = nil
						end
						GridFrame:UpdateFrameUnits()
					end,
				},
			},
		},
		bar = {
			name = L["Bar Options"],
			desc = L["Options related to bar indicators."],
			order = 2,
			type = "group",
			args = {
				texture = {
					name = L["Frame Texture"],
					desc = L["Adjust the texture of each unit's frame."],
					order = 1, width = "double",
					type = "select",
					values = Media:HashTable("statusbar"),
					dialogControl = "LSM30_Statusbar",
				},
				enableBarColor = {
					name = format(L["Enable %s indicator"], L["Health Bar Color"]),
					desc = format(L["Toggle the %s indicator."], L["Health Bar Color"]),
					order = 2, width = "double",
					type = "toggle",
					set = function(info, v)
						GridFrame.db.profile.enableBarColor = v
						GridFrame:UpdateOptionsMenu()
						GridFrame:UpdateAllFrames()
					end,
				},
				invertBarColor = {
					name = L["Invert Bar Color"],
					desc = L["Swap foreground/background colors on bars."],
					order = 3, width = "double",
					type = "toggle",
				},
				invertTextColor = {
					name = L["Invert Text Color"],
					desc = L["Darken the text color to match the inverted bar."],
					order = 4, width = "double",
					type = "toggle",
					disabled = function()
						return not GridFrame.db.profile.invertBarColor
					end,
				},
				healingBar_intensity = {
					name = L["Healing Bar Opacity"],
					desc = L["Sets the opacity of the healing bar."],
					order = 5, width = "double",
					type = "range", min = 0, max = 1, step = 0.01, bigStep = 0.05,
				},
				healingBar_useStatusColor = {
					name = L["Healing Bar Uses Status Color"],
					desc = L["Make the healing bar use the status color instead of the health bar color."],
					order = 6, width = "double",
					type = "toggle",
				},
			},
		},
		icon = {
			name = L["Icon Options"],
			desc = L["Options related to icon indicators."],
			order = 3,
			type = "group",
			args = {
				iconSize = {
					name = L["Icon Size"],
					desc = L["Adjust the size of the center icon."],
					order = 1, width = "double",
					type = "range", min = 5, max = 50, step = 1,
				},
				iconBorderSize = {
					name = L["Icon Border Size"],
					desc = L["Adjust the size of the center icon's border."],
					order = 2, width = "double",
					type = "range", min = 0, max = 9, step = 1,
				},
				enableIconCooldown = {
					name = format(L["Enable %s"], L["Icon Cooldown Frame"]),
					desc = L["Toggle center icon's cooldown frame."],
					order = 3, width = "double",
					type = "toggle",
				},
				enableIconStackText = {
					name = format(L["Enable %s"], L["Icon Stack Text"]),
					desc = L["Toggle center icon's stack count text."],
					order = 4, width = "double",
					type = "toggle",
				},
			},
		},
		text = {
			name = L["Text Options"],
			desc = L["Options related to text indicators."],
			order = 4,
			type = "group",
			args = {
				font = {
					name = L["Font"],
					desc = L["Adjust the font settings"],
					order = 1, width = "double",
					type = "select",
					values = Media:HashTable("font"),
					dialogControl = "LSM30_Font",
				},
				fontSize = {
					name = L["Font Size"],
					desc = L["Adjust the font size."],
					order = 2, width = "double",
					type = "range", min = 6, max = 24, step = 1,
				},
				fontOutline = {
					name = L["Font Outline"],
					desc = L["Adjust the font outline."],
					order = 3, width = "double",
					type = "select",
					values = {
						NONE = L["None"],
						OUTLINE = L["Thin"],
						THICKOUTLINE = L["Thick"] ,
					},
				},
				fontShadow = {
					name = L["Font Shadow"],
					desc = L["Toggle the font drop shadow effect."],
					order = 4, width = "double",
					type = "toggle",
				},
				textlength = {
					name = L["Center Text Length"],
					desc = L["Number of characters to show on Center Text indicator."],
					order = 5, width = "double",
					type = "range", min = 1, max = 12, step = 1,
				},
				enableText2 = {
					name = format(L["Enable %s indicator"], L["Center Text 2"]),
					desc = format(L["Toggle the %s indicator."], L["Center Text 2"]),
					order = 6, width = "double",
					type = "toggle",
					set = function(info, v)
						GridFrame.db.profile.enableText2 = v
						GridFrame:UpdateAllFrames()
						GridFrame:UpdateOptionsMenu()
					end,
				},
			},
		},
	},
}

Grid.options.args.GridIndicator = {
	name = L["Indicators"],
	desc = L["Options for assigning statuses to indicators."],
	order = 3,
	type = "group",
	childGroups = "tree",
	args = {}
}

------------------------------------------------------------------------

function GridFrame:PostInitialize()
	GridStatus = Grid:GetModule("GridStatus")
	GridStatusRange = GridStatus:GetModule("GridStatusRange", true)

	self.frames = {}
	self.registeredFrames = {}
end

function GridFrame:OnEnable()
	self:RegisterMessage("Grid_StatusGained")
	self:RegisterMessage("Grid_StatusLost")

    --slow when turn on taintLog
	self:RegisterBucketMessage("Grid_StatusRegistered", 0.2, "UpdateOptionsMenu")
	self:RegisterBucketMessage("Grid_StatusUnregistered", 0.2, "UpdateOptionsMenu")

	self:RegisterMessage("Grid_ColorsChanged", "UpdateAllFrames")

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateFrameUnits")

	self:RegisterEvent("UNIT_ENTERED_VEHICLE", "SendMessage_UpdateFrameUnits")
	self:RegisterEvent("UNIT_EXITED_VEHICLE", "SendMessage_UpdateFrameUnits")
	self:RegisterMessage("Grid_RosterUpdated", "SendMessage_UpdateFrameUnits")

	if self.db.profile.throttleUpdates then
		self.bucket_UpdateFrameUnits = self:RegisterBucketMessage("UpdateFrameUnits", 0.1)
	else
		self:RegisterMessage("UpdateFrameUnits")
	end

	Media.RegisterCallback(self, "LibSharedMedia_Registered", "LibSharedMedia_Update")
	Media.RegisterCallback(self, "LibSharedMedia_SetGlobal", "LibSharedMedia_Update")

	self:Reset()
end

function GridFrame:SendMessage_UpdateFrameUnits()
	self:SendMessage("UpdateFrameUnits")
end

function GridFrame:LibSharedMedia_Update(callback, type, handle)
 	if type == "font" or type == "statusbar" then
		self:UpdateAllFrames()
	end
end

function GridFrame:OnDisable()
	self:Debug("OnDisable")
	-- should probably disable and hide all of our frames here
end

function GridFrame:PostReset()
	self:Debug("PostReset")

	self:UpdateOptionsMenu()

	self:ResetAllFrames()
	self:UpdateFrameUnits()
	self:UpdateAllFrames()

	-- different fix for ticket #556, maybe fixes #603 too
	self:ResizeAllFrames()
end

------------------------------------------------------------------------

function GridFrame:RegisterFrame(frame)
	self:Debug("RegisterFrame", frame:GetName())

	self.registeredFrameCount = (self.registeredFrameCount or 0) + 1
	self.registeredFrames[frame:GetName()] = self:InitializeFrame(frame)
	self:UpdateFrameUnits()
end

function GridFrame:WithAllFrames(func, ...)
	for _, frame in pairs(self.registeredFrames) do
		if type(frame[func]) == "function" then
			frame[func](frame, ...)
		end
	end
end

function GridFrame:ResetAllFrames()
	self:WithAllFrames("Reset")
	self:SendMessage("Grid_UpdateLayoutSize")
end

function GridFrame:ResizeAllFrames()
	if InCombatLockdown() then return end -- TODO: some kind of alert
	self:WithAllFrames("SetWidth", self.db.profile.frameWidth)
	self:WithAllFrames("SetHeight", self.db.profile.frameHeight)
	self:ResetAllFrames()
	if not reloadHandle then
		reloadHandle = GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.1)
	end
end

function GridFrame:UpdateAllFrames()
	for _, frame in pairs(self.registeredFrames) do
		self:UpdateIndicators(frame)
	end
end

------------------------------------------------------------------------

local SecureButton_GetModifiedUnit = SecureButton_GetModifiedUnit -- it's so slow

function GridFrame:UpdateFrameUnits()
	for frame_name, frame in pairs(self.registeredFrames) do
		if frame:IsVisible() then
			local old_unit = frame.unit
			local old_guid = frame.unitGUID
			local unitid = SecureButton_GetModifiedUnit(frame)
				  unitid = unitid and gsub(unitid, "petpet", "pet") -- http://forums.wowace.com/showpost.php?p=307619&postcount=3174
			local guid = unitid and UnitGUID(unitid) or nil

			if old_unit ~= unitid or old_guid ~= guid then
				self:Debug("Updating", frame_name, "to", unitid, guid, "was", old_unit, old_guid)

				if unitid then
					frame.unit = unitid
					frame.unitGUID = guid

					if guid then
						self:UpdateIndicators(frame)
					end
				else
					frame.unit = nil
					frame.unitGUID = nil

					self:ClearIndicators(frame)
				end
			end
		end
	end
end

function GridFrame:UpdateIndicators(frame)
	local unitid = frame.unit
	if not unitid then return end

	-- statusmap[indicator][status]
	frame:ResetAllIndicators()
	for indicator in pairs(self.db.profile.statusmap) do
		self:UpdateIndicator(frame, indicator)
	end
end

function GridFrame:ClearIndicators(frame)
	for indicator in pairs(self.db.profile.statusmap) do
		frame:ClearIndicator(indicator)
	end
end

function GridFrame:UpdateIndicatorsForStatus(frame, status)
	local unitid = frame.unit
	if not unitid then return end

	-- self.statusmap[indicator][status]
	local statusmap = self.db.profile.statusmap
	for indicator, map_for_indicator in pairs(statusmap) do
		if map_for_indicator[status] then
			self:UpdateIndicator(frame, indicator)
		end
	end
end

function GridFrame:UpdateIndicator(frame, indicator)
	local status = self:StatusForIndicator(frame.unit, frame.unitGUID, indicator)
	if status then
		self:Debug("Showing status", status.text, "for", UnitName(frame.unit), "on", indicator)
		frame:SetIndicator(indicator,
			status.color,
			status.text,
			status.value,
			status.maxValue,
			status.texture,
			status.start,
			status.duration,
			status.count,
			status.texCoords)
	else
		self:Debug("Clearing indicator", indicator, "for", (UnitName(frame.unit)))
		frame:ClearIndicator(indicator)
	end
end

function GridFrame:StatusForIndicator(unitid, guid, indicator)
	local topPriority = 0
	local topStatus
	local statusmap = self.db.profile.statusmap[indicator]

	-- self.statusmap[indicator][status]
	for statusName, enabled in pairs(statusmap) do
		local status = enabled and GridStatus:GetCachedStatus(guid, statusName)
		if status then
			local valid = true

			-- make sure the status can be displayed
			if (indicator == "text" or indicator == "text2") and not status.text then
				self:Debug("unable to display", statusName, "on", indicator, ": no text")
				valid = false
			end
			if indicator == "icon" and not status.texture then
				self:Debug("unable to display", statusName, "on", indicator, ": no texture")
				valid = false
			end

			if status.priority and type(status.priority) ~= "number" then
				self:Debug("priority not number for", statusName)
				valid = false
			end

			-- only check range for valid statuses
			if valid then
		-- #DELETE
		--		local inRange = not status.range or self:UnitInRange(unitid)
		--		if inRange and ((status.priority or 99) > topPriority) then
				if (status.priority or 99) > topPriority then
					topStatus = status
					topPriority = topStatus.priority
				end
			end
		end
	end

	return topStatus
end

function GridFrame:UnitInRange(unit)
	if not unit or not UnitExists(unit) then return false end

	if UnitIsUnit(unit, "player") then
		return true
	end

	if GridStatusRange then
		return GridStatusRange:UnitInRange(unit)
	end

	return UnitInRange(unit)
end

------------------------------------------------------------------------

function GridFrame:Grid_StatusGained(event, guid, status, priority, range, color, text, value, maxValue, texture, start, duration, count)
	for _, frame in pairs(self.registeredFrames) do
		if frame.unitGUID == guid then
			self:UpdateIndicatorsForStatus(frame, status)
		end
	end
end

function GridFrame:Grid_StatusLost(event, guid, status)
	for _, frame in pairs(self.registeredFrames) do
		if frame.unitGUID == guid then
			self:UpdateIndicatorsForStatus(frame, status)
		end
	end
end

------------------------------------------------------------------------
-- TODO: move indicator specific options into indicators, add API

function GridFrame:UpdateOptionsMenu()
	self:Debug("UpdateOptionsMenu()")

	for id, info in pairs(self.indicators) do
		self:UpdateOptionsForIndicator(id, info.name, defaultOrder[id])
	end
end

function GridFrame:UpdateOptionsForIndicator(indicator, name, order)
	local menu = Grid.options.args.GridIndicator.args
	local GridStatus = Grid:GetModule("GridStatus")

	if indicator == "bar" then
		menu[indicator] = nil
		return
	end

	if indicator == "text2" and not self.db.profile.enableText2 then
		self:Debug("indicator text2 is disabled")
		menu[indicator] = nil
		return
	end

	if indicator == "barcolor" and not self.db.profile.enableBarColor then
		self:Debug("indicator barcolor is disabled")
		menu[indicator] = nil
		return
	end

	-- ensure statusmap entry exists for indicator
	local statusmap = self.db.profile.statusmap
	if not statusmap[indicator] then
		statusmap[indicator] = {}
	end

	-- create menu for indicator
	if not menu[indicator] then
		menu[indicator] = {
			name = name,
			order = order and (order + 1) or nil,
			type = "group",
			args = {
				StatusesHeader = {
					type = "header",
					name = L["Statuses"],
					order = 1,
				},
			},
		}
		if indicator == "text2" then
			menu[indicator].disabled = function() return not GridFrame.db.profile.enableText2 end
		end
	end

	local indicatorMenu = menu[indicator].args

	-- remove statuses that are not registered
	for status, _ in pairs(indicatorMenu) do
		if status ~= "StatusesHeader" and not GridStatus:IsStatusRegistered(status) then
			indicatorMenu[status] = nil
			self:Debug("Removed", indicator, status)
		end
	end

	-- create entry for each registered status
	for status, _, descr in GridStatus:RegisteredStatusIterator() do
		-- needs to be local for the get/set closures
		local indicatorType = indicator
		local statusKey = status

		self:Debug(indicator.type, status)

		if not indicatorMenu[status] then
			indicatorMenu[status] = {
				name = descr,
				desc = L["Toggle status display."],
				width = "double",
				type = "toggle",
				get = function()
					return GridFrame.db.profile.statusmap[indicatorType][statusKey]
				end,
				set = function(info, v)
					GridFrame.db.profile.statusmap[indicatorType][statusKey] = v
					GridFrame:UpdateAllFrames()
				end,
			}
			self:Debug("Added", indicator.type, status)
		end
	end
end

------------------------------------------------------------------------

function GridFrame:ListRegisteredFrames()
	self:Debug("--[ BEGIN Registered Frame List ]--")
	self:Debug("FrameName", "UnitId", "UnitName", "Status")
	for frameName, frame in pairs(self.registeredFrames) do
		local frameStatus = "|cff00ff00"

		if frame:IsVisible() then
			frameStatus = frameStatus .. "visible"
		elseif frame:IsShown() then
			frameStatus = frameStatus .. "shown"
		else
			frameStatus = "|cffff0000"
			frameStatus = frameStatus .. "hidden"
		end

		frameStatus = frameStatus .. "|r"

		self:Debug(
			frameName == frame:GetName() and "|cff00ff00"..frameName.."|r" or "|cffff0000"..frameName.."|r",
			frame.unit == frame:GetAttribute("unit") and "|cff00ff00"..(frame.unit or "nil").."|r" or "|cffff0000"..(frame.unit or "nil").."|r",
			frame.unit and frame.unitGUID == UnitGUID(frame.unit) and "|cff00ff00"..(frame.unitName or "nil").."|r" or "|cffff0000"..(frame.unitName or "nil").."|r",
			frame:GetAttribute("type1"),
			frame:GetAttribute("*type1"),
			frameStatus)
	end
	GridFrame:Debug("--[ END Registered Frame List ]--")
end
