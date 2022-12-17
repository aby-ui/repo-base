
local detailsFramework = _G ["DetailsFramework"]
if (not detailsFramework or not DetailsFrameworkCanLoad) then
	return
end

local _
--lua locals
local rawset = rawset --lua local
local rawget = rawget --lua local
local setmetatable = setmetatable --lua local
local unpack = table.unpack or unpack --lua local
local type = type --lua local
local floor = math.floor --lua local
local loadstring = loadstring --lua local

local IS_WOW_PROJECT_MAINLINE = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local IS_WOW_PROJECT_NOT_MAINLINE = WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE
local IS_WOW_PROJECT_CLASSIC_ERA = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC

local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

if IS_WOW_PROJECT_CLASSIC_ERA then
    UnitCastingInfo = CastingInfo
    UnitChannelInfo = ChannelInfo
end

local PixelUtil = PixelUtil or DFPixelUtil

local UnitGroupRolesAssigned = detailsFramework.UnitGroupRolesAssigned

local cleanfunction = function() end
local APIFrameFunctions

do
	local metaPrototype = {
		WidgetType = "panel",
		dversion = detailsFramework.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[detailsFramework.GlobalWidgetControlNames["panel"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[detailsFramework.GlobalWidgetControlNames ["panel"]]
		--check if is older
		if ( (not oldMetaPrototype.dversion) or (oldMetaPrototype.dversion < detailsFramework.dversion) ) then
			--the version is older them the currently loading one
			--copy the new values into the old metatable
			for funcName, _ in pairs(metaPrototype) do
				oldMetaPrototype[funcName] = metaPrototype[funcName]
			end
		end
	else
		--first time loading the framework
		_G[detailsFramework.GlobalWidgetControlNames["panel"]] = metaPrototype
	end
end

local PanelMetaFunctions = _G[detailsFramework.GlobalWidgetControlNames["panel"]]
detailsFramework:Mixin(PanelMetaFunctions, detailsFramework.ScriptHookMixin)

--default options for the frame layout
local default_framelayout_options = {
	amount_per_line = 4,
	start_x = 2,
	start_y = -2,
	is_vertical = false,
	grow_right = true, --on vertical (if not grow next line left)
	grow_down = true, --on horizontal (if not grow next line up)
	anchor_to_child = false, --if true set the point to the previous frame instead of coordinate
	anchor_point = "topleft",
	anchor_relative = "topleft",
	offset_x = 100,
	offset_y = 20,
	width = 0, --if bigger than 0, it will set the value
	height = 0,
	break_if_hidden = true, --stop if encounters a hidden frame
}

--mixin for frame layout
detailsFramework.LayoutFrame = {
	AnchorTo = function(self, anchor, point, x, y)
		if (point == "top") then
			self:ClearAllPoints()
			self:SetPoint("bottom", anchor, "top", x or 0, y or 0)

		elseif (point == "bottom") then
			self:ClearAllPoints()
			self:SetPoint("top", anchor, "bottom", x or 0, y or 0)

		elseif (point == "left") then
			self:ClearAllPoints()
			self:SetPoint("right", anchor, "left", x or 0, y or 0)

		elseif (point == "right") then
			self:ClearAllPoints()
			self:SetPoint("left", anchor, "right", x or 0, y or 0)
		end
	end,

	ArrangeFrames = function(self, frameList, options)
		if (not frameList) then
			frameList = {self:GetChildren()}
		end

		options = options or {}
		detailsFramework.table.deploy(options, default_framelayout_options)

		local breakLine = options.amount_per_line + 1
		local currentX, currentY = options.start_x, options.start_y
		local offsetX, offsetY = options.offset_x, options.offset_y
		local anchorPoint = options.anchor_point
		local anchorAt = options.anchor_relative
		local latestFrame = self
		local firstRowFrame = frameList[1]

		if (options.is_vertical) then
			for i = 1, #frameList do
				local thisFrame =  frameList[i]
				if (options.break_if_hidden and not thisFrame:IsShown()) then
					break
				end
				thisFrame:ClearAllPoints()

				if (options.anchor_to_child) then
					if (i == breakLine) then
						if (options.grow_right) then
							thisFrame:SetPoint("topleft", firstRowFrame, "topright", offsetX, 0)
						else
							thisFrame:SetPoint("topright", firstRowFrame, "topleft", -offsetX, 0)
						end
						firstRowFrame = thisFrame
						latestFrame = thisFrame
						breakLine = breakLine + options.amount_per_line
					else
						thisFrame:SetPoint(anchorPoint, latestFrame, i == 1 and "topleft" or anchorAt, offsetX, i == 1 and 0 or offsetY)
						latestFrame = thisFrame
					end
				else
					if (i == breakLine) then
						if (options.grow_right) then
							currentX = currentX + offsetX
						else
							currentX = currentX - offsetX
						end
						currentY = options.start_y

						firstRowFrame = thisFrame
						breakLine = breakLine + options.amount_per_line
					end

					thisFrame:SetPoint(anchorPoint, self, anchorAt, currentX, currentY)
					currentY = currentY - offsetY
				end
			end

		else
			for i = 1, #frameList do
				local thisFrame =  frameList [i]
				if (options.break_if_hidden and not thisFrame:IsShown()) then
					break
				end
				thisFrame:ClearAllPoints()

				if (options.anchor_to_child) then
					if (i == breakLine) then
						if (options.grow_down) then
							thisFrame:SetPoint("topleft", firstRowFrame, "bottomleft", 0, -offsetY)
						else
							thisFrame:SetPoint("bottomleft", firstRowFrame, "topleft", 0, offsetY)
						end
						firstRowFrame = thisFrame
						latestFrame = thisFrame
						breakLine = breakLine + options.amount_per_line
					else
						thisFrame:SetPoint(anchorPoint, latestFrame, i == 1 and "topleft" or anchorAt, i == 1 and 0 or offsetX, offsetY)
						latestFrame = thisFrame
					end
				else
					if (i == breakLine) then
						if (options.grow_down) then
							currentY = currentY - offsetY
						else
							currentY = currentY + offsetY
						end
						currentX = options.start_x

						firstRowFrame = thisFrame
						breakLine = breakLine + options.amount_per_line
					end

					thisFrame:SetPoint(anchorPoint, self, anchorAt, currentX, currentY)
					currentX = currentX + offsetX
				end
			end
		end
	end
}


------------------------------------------------------------------------------------------------------------
--metatables
	PanelMetaFunctions.__call = function(_table, value)
		--nothing to do
		return true
	end

------------------------------------------------------------------------------------------------------------
--members
	--tooltip
	local gmember_tooltip = function(_object)
		return _object:GetTooltip()
	end
	--shown
	local gmember_shown = function(_object)
		return _object:IsShown()
	end
	--backdrop color
	local gmember_color = function(_object)
		return _object.frame:GetBackdropColor()
	end
	--backdrop table
	local gmember_backdrop = function(_object)
		return _object.frame:GetBackdrop()
	end
	--frame width
	local gmember_width = function(_object)
		return _object.frame:GetWidth()
	end
	--frame height
	local gmember_height = function(_object)
		return _object.frame:GetHeight()
	end
	--locked
	local gmember_locked = function(_object)
		return rawget(_object, "is_locked")
	end

	PanelMetaFunctions.GetMembers = PanelMetaFunctions.GetMembers or {}
	PanelMetaFunctions.GetMembers ["tooltip"] = gmember_tooltip
	PanelMetaFunctions.GetMembers ["shown"] = gmember_shown
	PanelMetaFunctions.GetMembers ["color"] = gmember_color
	PanelMetaFunctions.GetMembers ["backdrop"] = gmember_backdrop
	PanelMetaFunctions.GetMembers ["width"] = gmember_width
	PanelMetaFunctions.GetMembers ["height"] = gmember_height
	PanelMetaFunctions.GetMembers ["locked"] = gmember_locked

	PanelMetaFunctions.__index = function(object, key)
		local func = PanelMetaFunctions.GetMembers[key]
		if (func) then
			return func(object, key)
		end

		local fromMe = rawget(object, key)
		if (fromMe) then
			return fromMe
		end

		return PanelMetaFunctions[key]
	end

	--tooltip
	local smember_tooltip = function(_object, _value)
		return _object:SetTooltip (_value)
	end
	--show
	local smember_show = function(_object, _value)
		if (_value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--hide
	local smember_hide = function(_object, _value)
		if (not _value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--backdrop color
	local smember_color = function(_object, _value)
		local _value1, _value2, _value3, _value4 = detailsFramework:ParseColors(_value)
		return _object:SetBackdropColor(_value1, _value2, _value3, _value4)
	end
	--frame width
	local smember_width = function(_object, _value)
		return _object.frame:SetWidth(_value)
	end
	--frame height
	local smember_height = function(_object, _value)
		return _object.frame:SetHeight(_value)
	end

	--locked
	local smember_locked = function(_object, _value)
		if (_value) then
			_object.frame:SetMovable(false)
			return rawset(_object, "is_locked", true)
		else
			_object.frame:SetMovable(true)
			rawset(_object, "is_locked", false)
			return
		end
	end

	--backdrop
	local smember_backdrop = function(_object, _value)
		return _object.frame:SetBackdrop(_value)
	end

	--close with right button
	local smember_right_close = function(_object, _value)
		return rawset(_object, "rightButtonClose", _value)
	end

	PanelMetaFunctions.SetMembers = PanelMetaFunctions.SetMembers or {}
	PanelMetaFunctions.SetMembers["tooltip"] = smember_tooltip
	PanelMetaFunctions.SetMembers["show"] = smember_show
	PanelMetaFunctions.SetMembers["hide"] = smember_hide
	PanelMetaFunctions.SetMembers["color"] = smember_color
	PanelMetaFunctions.SetMembers["backdrop"] = smember_backdrop
	PanelMetaFunctions.SetMembers["width"] = smember_width
	PanelMetaFunctions.SetMembers["height"] = smember_height
	PanelMetaFunctions.SetMembers["locked"] = smember_locked
	PanelMetaFunctions.SetMembers["close_with_right"] = smember_right_close

	PanelMetaFunctions.__newindex = function(_table, _key, _value)
		local func = PanelMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return rawset(_table, _key, _value)
		end
	end

------------------------------------------------------------------------------------------------------------
--methods

--right click to close
	function PanelMetaFunctions:CreateRightClickLabel(textType, width, height, showCloseText)
		local text
		width = width or 20
		height = height or 20

		if (showCloseText) then
			text = showCloseText
		else
			if (textType) then
				textType = string.lower(textType)
				if (textType == "short") then
					text = "close window"

				elseif (textType == "medium") then
					text = "close window"

				elseif (textType == "large") then
					text = "close window"
				end
			else
				text = "close window"
			end
		end

		return detailsFramework:NewLabel(self, _, "$parentRightMouseToClose", nil, "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:" .. width .. ":" .. height .. ":0:1:512:512:8:70:328:409|t " .. text)
	end

--show & hide
	function PanelMetaFunctions:Show()
		self.frame:Show()
	end

	function PanelMetaFunctions:Hide()
		self.frame:Hide()
	end

-- setpoint
	function PanelMetaFunctions:SetPoint(v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = detailsFramework:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			print("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint(v1, v2, v3, v4, v5)
	end

-- sizes
	function PanelMetaFunctions:SetSize(w, h)
		if (w) then
			self.frame:SetWidth(w)
		end
		if (h) then
			self.frame:SetHeight(h)
		end
	end

-- clear
	function PanelMetaFunctions:HideWidgets()
		for widgetName, widgetSelf in pairs(self) do
			if (type(widgetSelf) == "table" and widgetSelf.dframework) then
				widgetSelf:Hide()
			end
		end
	end

-- backdrop
	function PanelMetaFunctions:SetBackdrop(background, edge, tilesize, edgesize, tile, left, right, top, bottom)

		if (type(background) == "boolean" and not background) then
			return self.frame:SetBackdrop(nil)

		elseif (type(background) == "table") then
			self.frame:SetBackdrop(background)

		else
			local currentBackdrop = self.frame:GetBackdrop() or {edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", tile=true, tileSize=16, edgeSize=16, insets={left=1, right=0, top=0, bottom=0}}
			currentBackdrop.bgFile = background or currentBackdrop.bgFile
			currentBackdrop.edgeFile = edgeFile or currentBackdrop.edgeFile
			currentBackdrop.tileSize = tilesize or currentBackdrop.tileSize
			currentBackdrop.edgeSize = edgesize or currentBackdrop.edgeSize
			currentBackdrop.tile = tile or currentBackdrop.tile
			currentBackdrop.insets.left = left or currentBackdrop.insets.left
			currentBackdrop.insets.right = left or currentBackdrop.insets.right
			currentBackdrop.insets.top = left or currentBackdrop.insets.top
			currentBackdrop.insets.bottom = left or currentBackdrop.insets.bottom
			self.frame:SetBackdrop(currentBackdrop)
		end
	end

-- backdropcolor
	function PanelMetaFunctions:SetBackdropColor(color, arg2, arg3, arg4)
		if (arg2) then
			self.frame:SetBackdropColor(color, arg2, arg3, arg4 or 1)
		else
			local _value1, _value2, _value3, _value4 = detailsFramework:ParseColors(color)
			self.frame:SetBackdropColor(_value1, _value2, _value3, _value4)
		end
	end

-- border color
	function PanelMetaFunctions:SetBackdropBorderColor(color, arg2, arg3, arg4)
		if (arg2) then
			return self.frame:SetBackdropBorderColor(color, arg2, arg3, arg4)
		end
		local _value1, _value2, _value3, _value4 = detailsFramework:ParseColors(color)
		self.frame:SetBackdropBorderColor(_value1, _value2, _value3, _value4)
	end

-- tooltip
	function PanelMetaFunctions:SetTooltip (tooltip)
		if (tooltip) then
			return rawset(self, "have_tooltip", tooltip)
		else
			return rawset(self, "have_tooltip", nil)
		end
	end
	function PanelMetaFunctions:GetTooltip()
		return rawget(self, "have_tooltip")
	end

-- frame levels
	function PanelMetaFunctions:GetFrameLevel()
		return self.widget:GetFrameLevel()
	end
	function PanelMetaFunctions:SetFrameLevel(level, frame)
		if (not frame) then
			return self.widget:SetFrameLevel(level)
		else
			local framelevel = frame:GetFrameLevel (frame) + level
			return self.widget:SetFrameLevel(framelevel)
		end
	end

-- frame stratas
	function PanelMetaFunctions:SetFrameStrata()
		return self.widget:GetFrameStrata()
	end
	function PanelMetaFunctions:SetFrameStrata(strata)
		if (type(strata) == "table") then
			self.widget:SetFrameStrata(strata:GetFrameStrata())
		else
			self.widget:SetFrameStrata(strata)
		end
	end

------------------------------------------------------------------------------------------------------------
--scripts

	local OnEnter = function(frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget("OnEnter", frame, capsule)
		if (kill) then
			return
		end

		if (frame.MyObject.have_tooltip) then
			GameCooltip2:Reset()
			GameCooltip2:SetType ("tooltip")
			GameCooltip2:SetColor ("main", "transparent")
			GameCooltip2:AddLine(frame.MyObject.have_tooltip)
			GameCooltip2:SetOwner(frame)
			GameCooltip2:ShowCooltip()
		end
	end

	local OnLeave = function(frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget("OnLeave", frame, capsule)
		if (kill) then
			return
		end

		if (frame.MyObject.have_tooltip) then
			GameCooltip2:ShowMe(false)
		end

	end

	local OnHide = function(frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget("OnHide", frame, capsule)
		if (kill) then
			return
		end
	end

	local OnShow = function(frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget("OnShow", frame, capsule)
		if (kill) then
			return
		end
	end

	local OnMouseDown = function(frame, button)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget("OnMouseDown", frame, button, capsule)
		if (kill) then
			return
		end

		if (frame.MyObject.container == UIParent) then
			if (not frame.isLocked and frame:IsMovable()) then
				frame.isMoving = true
				frame:StartMoving()
			end

		elseif (not frame.MyObject.container.isLocked and frame.MyObject.container:IsMovable()) then
			if (not frame.isLocked and frame:IsMovable()) then
				frame.MyObject.container.isMoving = true
				frame.MyObject.container:StartMoving()
			end
		end


	end

	local OnMouseUp = function(frame, button)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget("OnMouseUp", frame, button, capsule)
		if (kill) then
			return
		end

		if (button == "RightButton" and frame.MyObject.rightButtonClose) then
			frame.MyObject:Hide()
		end

		if (frame.MyObject.container == UIParent) then
			if (frame.isMoving) then
				frame:StopMovingOrSizing()
				frame.isMoving = false
			end
		else
			if (frame.MyObject.container.isMoving) then
				frame.MyObject.container:StopMovingOrSizing()
				frame.MyObject.container.isMoving = false
			end
		end
	end

------------------------------------------------------------------------------------------------------------
--object constructor
function detailsFramework:CreatePanel (parent, w, h, backdrop, backdropcolor, bordercolor, member, name)
	return detailsFramework:NewPanel(parent, parent, name, member, w, h, backdrop, backdropcolor, bordercolor)
end

function detailsFramework:NewPanel(parent, container, name, member, w, h, backdrop, backdropcolor, bordercolor)

	if (not name) then
		name = "DetailsFrameworkPanelNumber" .. detailsFramework.PanelCounter
		detailsFramework.PanelCounter = detailsFramework.PanelCounter + 1

	elseif (not parent) then
		parent = UIParent
	end
	if (not container) then
		container = parent
	end

	if (name:find("$parent")) then
		name = name:gsub("$parent", parent:GetName())
	end

	local PanelObject = {type = "panel", dframework = true}

	if (member) then
		parent [member] = PanelObject
	end

	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end

	--default members:
		--misc
		PanelObject.is_locked = true
		PanelObject.container = container
		PanelObject.rightButtonClose = false

	PanelObject.frame = CreateFrame("frame", name, parent,"BackdropTemplate")
	PanelObject.frame:SetSize(100, 100)
	PanelObject.frame.Gradient = {
					["OnEnter"] = {0.3, 0.3, 0.3, 0.5},
					["OnLeave"] = {0.9, 0.7, 0.7, 1}
	}
	PanelObject.frame:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]], edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 10, tileSize = 64, tile = true})

	PanelObject.widget = PanelObject.frame

	if (not APIFrameFunctions) then
		APIFrameFunctions = {}
		local idx = getmetatable(PanelObject.frame).__index
		for funcName, funcAddress in pairs(idx) do
			if (not PanelMetaFunctions [funcName]) then
				PanelMetaFunctions [funcName] = function(object, ...)
					local x = loadstring ( "return _G['"..object.frame:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end

	PanelObject.frame:SetWidth(w or 100)
	PanelObject.frame:SetHeight(h or 100)

	PanelObject.frame.MyObject = PanelObject

	PanelObject.HookList = {
		OnEnter = {},
		OnLeave = {},
		OnHide = {},
		OnShow = {},
		OnMouseDown = {},
		OnMouseUp = {},
	}

	--hooks
		PanelObject.frame:SetScript("OnEnter", OnEnter)
		PanelObject.frame:SetScript("OnLeave", OnLeave)
		PanelObject.frame:SetScript("OnHide", OnHide)
		PanelObject.frame:SetScript("OnShow", OnShow)
		PanelObject.frame:SetScript("OnMouseDown", OnMouseDown)
		PanelObject.frame:SetScript("OnMouseUp", OnMouseUp)

	setmetatable(PanelObject, PanelMetaFunctions)

	if (backdrop) then
		PanelObject:SetBackdrop(backdrop)
	elseif (type(backdrop) == "boolean") then
		PanelObject.frame:SetBackdrop(nil)
	end

	if (backdropcolor) then
		PanelObject:SetBackdropColor(backdropcolor)
	end

	if (bordercolor) then
		PanelObject:SetBackdropBorderColor(bordercolor)
	end

	return PanelObject
end

------------fill panel

local button_on_enter = function(self)
	self.MyObject._icon:SetBlendMode("ADD")
	if (self.MyObject.onenter_func) then
		pcall(self.MyObject.onenter_func, self.MyObject)
	end
end
local button_on_leave = function(self)
	self.MyObject._icon:SetBlendMode("BLEND")
	if (self.MyObject.onleave_func) then
		pcall(self.MyObject.onleave_func, self.MyObject)
	end
end

local add_row = function(self, t, need_update)
	local index = #self.rows+1

	local thisrow = detailsFramework:NewPanel(self, self, "$parentHeader_" .. self._name .. index, nil, 1, 20)
	thisrow.backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]]}
	thisrow.color = {.3, .3, .3, .9}
	thisrow.type = t.type
	thisrow.func = t.func
	thisrow.name = t.name
	thisrow.notext = t.notext
	thisrow.icon = t.icon
	thisrow.iconalign = t.iconalign

	thisrow.hidden = t.hidden or false

	thisrow.onenter = t.onenter
	thisrow.onleave = t.onleave

	local text = detailsFramework:NewLabel(thisrow, nil, self._name .. "$parentLabel" .. index, "text")
	text:SetPoint("left", thisrow, "left", 2, 0)
	text:SetText(t.name)

	tinsert(self._raw_rows, t)
	tinsert(self.rows, thisrow)

	if (need_update) then
		self:AlignRows()
	end
end

local align_rows = function(self)

	local rows_shown = 0
	for index, row in ipairs(self.rows) do
		if (not row.hidden) then
			rows_shown = rows_shown + 1
		end
	end

	local cur_width = 1
	local row_width = self._width / max(rows_shown, 0.0001)


	local sindex = 1

	wipe (self._anchors)

	for index, row in ipairs(self.rows) do
		if (not row.hidden) then
			if (self._autowidth) then
				if (self._raw_rows [index].width) then
					row.width = self._raw_rows [index].width
				else
					row.width = row_width
				end
				row:SetPoint("topleft", self, "topleft", cur_width, -1)
				tinsert(self._anchors, cur_width)
				cur_width = cur_width + row_width + 1
			else
				row:SetPoint("topleft", self, "topleft", cur_width, -1)
				row.width = self._raw_rows [index].width
				tinsert(self._anchors, cur_width)
				cur_width = cur_width + self._raw_rows [index].width + 1
			end

			row:Show()

			local rowType = row.type

			if (rowType == "text") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local text = tremove(line.text_available)
					if (not text) then
						self:CreateRowText (line)
						text = tremove(line.text_available)
					end
					tinsert(line.text_inuse, text)
					text:SetPoint("left", line, "left", self._anchors [#self._anchors], 0)
					text:SetWidth(row.width)

					detailsFramework:SetFontSize(text, row.textsize or 10)
					text:SetJustifyH(row.textalign or "left")
				end
			elseif (rowType == "entry") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local entry = tremove(line.entry_available)
					if (not entry) then
						self:CreateRowEntry (line)
						entry = tremove(line.entry_available)
					end
					tinsert(line.entry_inuse, entry)
					entry:SetPoint("left", line, "left", self._anchors [#self._anchors], 0)
					if (sindex == rows_shown) then
						entry:SetWidth(row.width - 25)
					else
						entry:SetWidth(row.width)
					end
					entry.func = row.func

					entry.onenter_func = nil
					entry.onleave_func = nil

					if (row.onenter) then
						entry.onenter_func = row.onenter
					end
					if (row.onleave) then
						entry.onleave_func = row.onleave
					end
				end

			elseif (rowType == "checkbox") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local checkbox = tremove(line.checkbox_available)
					if (not checkbox) then
						self:CreateCheckbox (line)
						checkbox = tremove(line.checkbox_available)
					end

					tinsert(line.checkbox_inuse, checkbox)

					checkbox:SetPoint("left", line, "left", self._anchors [#self._anchors] + ((row.width - 20) / 2), 0)
					if (sindex == rows_shown) then
						checkbox:SetWidth(20)
						--checkbox:SetWidth(row.width - 25)
					else
						checkbox:SetWidth(20)
					end

					checkbox.onenter_func = nil
					checkbox.onleave_func = nil
				end

			elseif (rowType == "button") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local button = tremove(line.button_available)
					if (not button) then
						self:CreateRowButton (line)
						button = tremove(line.button_available)
					end
					tinsert(line.button_inuse, button)
					button:SetPoint("left", line, "left", self._anchors [#self._anchors], 0)
					if (sindex == rows_shown) then
						button:SetWidth(row.width - 25)
					else
						button:SetWidth(row.width)
					end

					if (row.icon) then
						button._icon.texture = row.icon
						button._icon:ClearAllPoints()
						if (row.iconalign) then
							if (row.iconalign == "center") then
								button._icon:SetPoint("center", button, "center")
							elseif (row.iconalign == "right") then
								button._icon:SetPoint("right", button, "right")
							end
						else
							button._icon:SetPoint("left", button, "left")
						end
					end

					if (row.name and not row.notext) then
						button._text:SetPoint("left", button._icon, "right", 2, 0)
						button._text.text = row.name
					end

					button.onenter_func = nil
					button.onleave_func = nil

					if (row.onenter) then
						button.onenter_func = row.onenter
					end
					if (row.onleave) then
						button.onleave_func = row.onleave
					end

				end
			elseif (rowType == "icon") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local icon = tremove(line.icon_available)
					if (not icon) then
						self:CreateRowIcon (line)
						icon = tremove(line.icon_available)
					end
					tinsert(line.icon_inuse, icon)
					icon:SetPoint("left", line, "left", self._anchors [#self._anchors] + ( ((row.width or 22) - 22) / 2), 0)
					icon.func = row.func
				end

			elseif (rowType == "texture") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local texture = tremove(line.texture_available)
					if (not texture) then
						self:CreateRowTexture (line)
						texture = tremove(line.texture_available)
					end
					tinsert(line.texture_inuse, texture)
					texture:SetPoint("left", line, "left", self._anchors [#self._anchors] + ( ((row.width or 22) - 22) / 2), 0)
				end

			end

			sindex = sindex + 1
		else
			row:Hide()
		end
	end

	if (#self.rows > 0) then
		if (self._autowidth) then
			self.rows [#self.rows]:SetWidth(row_width - rows_shown + 1)
		else
			self.rows [#self.rows]:SetWidth(self._raw_rows [rows_shown].width - rows_shown + 1)
		end
	end

	self.showing_amt = rows_shown
end

local update_rows = function(self, updated_rows)

	for i = 1, #updated_rows do
		local t = updated_rows [i]
		local raw = self._raw_rows [i]

		if (not raw) then
			self:AddRow (t)
		else
			raw.name = t.name
			raw.hidden = t.hidden or false
			raw.textsize = t.textsize
			raw.textalign = t.textalign

			local widget = self.rows [i]
			widget.name = t.name
			widget.textsize = t.textsize
			widget.textalign = t.textalign
			widget.hidden = t.hidden or false

			--
			widget.onenter = t.onenter
			widget.onleave = t.onleave
			--

			widget.text:SetText(t.name)
			detailsFramework:SetFontSize(widget.text, raw.textsize or 10)
			widget.text:SetJustifyH(raw.textalign or "left")
		end
	end

	for i = #updated_rows+1, #self._raw_rows do
		local raw = self._raw_rows [i]
		local widget = self.rows [i]
		raw.hidden = true
		widget.hidden = true
	end

	for index, row in ipairs(self.scrollframe.lines) do
		for i = #row.text_inuse, 1, -1 do
			tinsert(row.text_available, tremove(row.text_inuse, i))
		end
		for i = 1, #row.text_available do
			row.text_available[i]:Hide()
		end

		for i = #row.entry_inuse, 1, -1 do
			tinsert(row.entry_available, tremove(row.entry_inuse, i))
		end
		for i = 1, #row.entry_available do
			row.entry_available[i]:Hide()
		end

		for i = #row.button_inuse, 1, -1 do
			tinsert(row.button_available, tremove(row.button_inuse, i))
		end
		for i = 1, #row.button_available do
			row.button_available[i]:Hide()
		end

		for i = #row.checkbox_inuse, 1, -1 do
			tinsert(row.checkbox_available, tremove(row.checkbox_inuse, i))
		end
		for i = 1, #row.checkbox_available do
			row.checkbox_available[i]:Hide()
		end

		for i = #row.icon_inuse, 1, -1 do
			tinsert(row.icon_available, tremove(row.icon_inuse, i))
		end
		for i = 1, #row.icon_available do
			row.icon_available[i]:Hide()
		end

		for i = #row.texture_inuse, 1, -1 do
			tinsert(row.texture_available, tremove(row.texture_inuse, i))
		end
		for i = 1, #row.texture_available do
			row.texture_available[i]:Hide()
		end
	end

	self.current_header = updated_rows

	self:AlignRows()

end

local create_panel_text = function(self, row)
	row.text_total = row.text_total + 1
	local text = detailsFramework:NewLabel(row, nil, self._name .. "$parentLabel" .. row.text_total, "text" .. row.text_total)
	tinsert(row.text_available, text)
end

local create_panel_entry = function(self, row)
	row.entry_total = row.entry_total + 1
	local editbox = detailsFramework:NewTextEntry(row, nil, "$parentEntry" .. row.entry_total, "entry", 120, 20)
	editbox.align = "left"

	editbox:SetHook("OnEnterPressed", function()
		editbox.widget.focuslost = true
		editbox:ClearFocus()
		editbox.func (editbox.index, editbox.text)
		return true
	end)

	editbox:SetHook("OnEnter", function()
		if (editbox.onenter_func) then
			pcall(editbox.onenter_func, editbox)
		end
	end)
	editbox:SetHook("OnLeave", function()
		if (editbox.onleave_func) then
			pcall(editbox.onleave_func, editbox)
		end
	end)

	editbox.editbox.current_bordercolor = {1, 1, 1, 0.1}

	editbox:SetTemplate(detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	editbox:SetBackdropColor(.2, .2, .2, 0.7)

	tinsert(row.entry_available, editbox)
end

local create_panel_checkbox = function(self, row)
	--row.checkbox_available
	row.checkbox_total = row.checkbox_total + 1

	local switch = detailsFramework:NewSwitch (row, nil, "$parentCheckBox" .. row.checkbox_total, nil, 20, 20, nil, nil, false)
	switch:SetAsCheckBox()
	switch:SetTemplate(detailsFramework:GetTemplate("switch", "OPTIONS_CHECKBOX_TEMPLATE"))

	tinsert(row.checkbox_available, switch)
end

local create_panel_button = function(self, row)
	row.button_total = row.button_total + 1
	local button = detailsFramework:NewButton(row, nil, "$parentButton" .. row.button_total, "button" .. row.button_total, 120, 20)

	--create icon and the text
	local icon = detailsFramework:NewImage(button, nil, 20, 20)
	local text = detailsFramework:NewLabel(button)

	button._icon = icon
	button._text = text

	button:SetHook("OnEnter", button_on_enter)
	button:SetHook("OnLeave", button_on_leave)

	tinsert(row.button_available, button)
end

local icon_onclick = function(texture, iconbutton)
	iconbutton._icon.texture = texture
	iconbutton.func (iconbutton.index, texture)
end

local create_panel_icon = function(self, row)
	row.icon_total = row.icon_total + 1
	local iconbutton = detailsFramework:NewButton(row, nil, "$parentIconButton" .. row.icon_total, "iconbutton", 22, 20)

	iconbutton:SetHook("OnEnter", button_on_enter)
	iconbutton:SetHook("OnLeave", button_on_leave)

	iconbutton:SetHook("OnMouseUp", function()
		detailsFramework:IconPick (icon_onclick, true, iconbutton)
		return true
	end)

	local icon = detailsFramework:NewImage(iconbutton, nil, 20, 20, "artwork", nil, "_icon", "$parentIcon" .. row.icon_total)
	iconbutton._icon = icon

	icon:SetPoint("center", iconbutton, "center", 0, 0)

	tinsert(row.icon_available, iconbutton)
end

local create_panel_texture = function(self, row)
	row.texture_total = row.texture_total + 1
	local texture = detailsFramework:NewImage(row, nil, 20, 20, "artwork", nil, "_icon" .. row.texture_total, "$parentIcon" .. row.texture_total)
	tinsert(row.texture_available, texture)
end

local set_fill_function = function(self, func)
	self._fillfunc = func
end
local set_total_function = function(self, func)
	self._totalfunc = func
end
local drop_header_function = function(self)
	wipe (self.rows)
end

local fillpanel_update_size = function(self, elapsed)
	local panel = self.MyObject

	panel._width = panel:GetWidth()
	panel._height = panel:GetHeight()

	panel:UpdateRowAmount()
	if (panel.current_header) then
		update_rows (panel, panel.current_header)
	end
	panel:Refresh()

	self:SetScript("OnUpdate", nil)
end

 -- ~fillpanel
  --alias
function detailsFramework:CreateFillPanel(parent, rows, w, h, total_lines, fill_row, autowidth, options, member, name)
	return detailsFramework:NewFillPanel(parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
end

function detailsFramework:NewFillPanel(parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
	local panel = detailsFramework:NewPanel(parent, parent, name, member, w, h)
	panel.backdrop = nil

	options = options or {rowheight = 20}
	panel.rows = {}

	panel.AddRow = add_row
	panel.AlignRows = align_rows
	panel.UpdateRows = update_rows
	panel.CreateRowText = create_panel_text
	panel.CreateRowEntry = create_panel_entry
	panel.CreateRowButton = create_panel_button
	panel.CreateCheckbox = create_panel_checkbox
	panel.CreateRowIcon = create_panel_icon
	panel.CreateRowTexture = create_panel_texture
	panel.SetFillFunction = set_fill_function
	panel.SetTotalFunction = set_total_function
	panel.DropHeader = drop_header_function

	panel._name = name
	panel._width = w
	panel._height = h
	panel._raw_rows = {}
	panel._anchors = {}
	panel._fillfunc = fill_row
	panel._totalfunc = total_lines
	panel._autowidth = autowidth

	panel:SetScript("OnSizeChanged", function()
		panel:SetScript("OnUpdate", fillpanel_update_size)
	end)

	for index, t in ipairs(rows) do
		panel.AddRow(panel, t)
	end

	local refresh_fillbox = function(self)
		local offset = FauxScrollFrame_GetOffset(self)
		local filled_lines = panel._totalfunc(panel)

		for index = 1, #self.lines do
			local row = self.lines [index]
			if (index <= filled_lines) then

				local real_index = index + offset
				local results = panel._fillfunc (real_index, panel)

				if (results and results [1]) then
					row:Show()

					local text, entry, button, icon, texture, checkbox = 1, 1, 1, 1, 1, 1

					for index, t in ipairs(panel.rows) do
						if (not t.hidden) then
							if (t.type == "text") then
								local fontstring = row.text_inuse [text]
								text = text + 1
								fontstring:SetText(results [index])
								fontstring.index = real_index
								fontstring:Show()

							elseif (t.type == "entry") then
								local entrywidget = row.entry_inuse [entry]
								entry = entry + 1
								entrywidget.index = real_index

								if (type(results [index]) == "table") then
									entrywidget:SetText(results [index].text)
									entrywidget.id = results [index].id
									entrywidget.data1 = results [index].data1
									entrywidget.data2 = results [index].data2
								else
									entrywidget:SetText(results [index])
								end

								entrywidget:SetCursorPosition(0)

								entrywidget:Show()

							elseif (t.type == "checkbox") then
								local checkboxwidget = row.checkbox_inuse [button]
								checkbox = checkbox + 1
								checkboxwidget.index = real_index
								checkboxwidget:SetValue(results [index])

								local func = function()
									t.func (real_index, index)
									panel:Refresh()
								end
								checkboxwidget.OnSwitch = func

							elseif (t.type == "button") then
								local buttonwidget = row.button_inuse [button]
								button = button + 1
								buttonwidget.index = real_index

								if (type(results [index]) == "table") then
									if (results [index].text) then
										buttonwidget:SetText(results [index].text)
									end

									if (results [index].icon) then
										buttonwidget._icon:SetTexture(results [index].icon)
									end

									if (results [index].func) then
										local func = function()
											t.func (real_index, results [index].value)
											panel:Refresh()
										end
										buttonwidget:SetClickFunction(func)
									else
										local func = function()
											t.func (real_index, index)
											panel:Refresh()
										end
										buttonwidget:SetClickFunction(func)
									end

									buttonwidget.id = results [index].id
									buttonwidget.data1 = results [index].data1
									buttonwidget.data2 = results [index].data2

								else
									local func = function()
										t.func (real_index, index)
										panel:Refresh()
									end
									buttonwidget:SetClickFunction(func)
									buttonwidget:SetText(results [index])
								end

								buttonwidget:Show()

							elseif (t.type == "icon") then
								local iconwidget = row.icon_inuse [icon]
								icon = icon + 1

								iconwidget.line = index
								iconwidget.index = real_index

								if (type(results [index]) == "string") then
									local result = results [index]:gsub(".-%\\", "")
									iconwidget._icon.texture = results [index]
									iconwidget._icon:SetTexCoord(0.1, .9, 0.1, .9)

								elseif (type(results [index]) == "table") then
									iconwidget._icon:SetTexture(results [index].texture)

									local textCoord = results [index].texcoord
									if (textCoord) then
										iconwidget._icon:SetTexCoord(unpack(textCoord))
									else
										iconwidget._icon:SetTexCoord(0.1, .9, 0.1, .9)
									end

									local color = results [index].color
									if (color) then
										local r, g, b, a = detailsFramework:ParseColors(color)
										iconwidget._icon:SetVertexColor(r, g, b, a)
									else
										iconwidget._icon:SetVertexColor(1, 1, 1, 1)
									end
								else
									iconwidget._icon:SetTexture(results [index])
									iconwidget._icon:SetTexCoord(0.1, .9, 0.1, .9)
								end

								iconwidget:Show()

							elseif (t.type == "texture") then
								local texturewidget = row.texture_inuse [texture]
								texture = texture + 1

								texturewidget.line = index
								texturewidget.index = real_index

								if (type(results [index]) == "string") then
									local result = results [index]:gsub(".-%\\", "")
									texturewidget.texture = results [index]

								elseif (type(results [index]) == "table") then
									texturewidget:SetTexture(results [index].texture)

									local textCoord = results [index].texcoord
									if (textCoord) then
										texturewidget:SetTexCoord(unpack(textCoord))
									else
										texturewidget:SetTexCoord(0, 1, 0, 1)
									end

									local color = results [index].color
									if (color) then
										local r, g, b, a = detailsFramework:ParseColors(color)
										texturewidget:SetVertexColor(r, g, b, a)
									else
										texturewidget:SetVertexColor(1, 1, 1, 1)
									end

								else
									texturewidget:SetTexture(results [index])
								end

								texturewidget:Show()
							end
						end
					end

				else
					row:Hide()
				end
			else
				row:Hide()
			end
		end
	end

	function panel:Refresh()
		if (type(panel._totalfunc) == "boolean") then
			--not yet initialized
			return
		end
		local filled_lines = panel._totalfunc (panel)
		local scroll_total_lines = #panel.scrollframe.lines
		local line_height = options.rowheight
		refresh_fillbox (panel.scrollframe)
		FauxScrollFrame_Update (panel.scrollframe, filled_lines, scroll_total_lines, line_height)
		panel.scrollframe:Show()
	end

	local scrollframe = CreateFrame("scrollframe", name .. "Scroll", panel.widget, "FauxScrollFrameTemplate", "BackdropTemplate")
	scrollframe:SetScript("OnVerticalScroll", function(self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 20, panel.Refresh) end)
	scrollframe:SetPoint("topleft", panel.widget, "topleft", 0, -21)
	scrollframe:SetPoint("topright", panel.widget, "topright", -23, -21)
	scrollframe:SetPoint("bottomleft", panel.widget, "bottomleft")
	scrollframe:SetPoint("bottomright", panel.widget, "bottomright", -23, 0)
	scrollframe:SetSize(w, h)
	panel.scrollframe = scrollframe
	scrollframe.lines = {}

	detailsFramework:ReskinSlider(scrollframe)

	--create lines
	function panel:UpdateRowAmount()
		local size = options.rowheight
		local amount = math.floor(((panel._height-21) / size))

		for i = #scrollframe.lines+1, amount do
			local row = CreateFrame("frame", panel:GetName() .. "Row_" .. i, panel.widget,"BackdropTemplate")
			row:SetSize(1, size)
			row.color = {1, 1, 1, .2}

			row:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]]})

			if (i%2 == 0) then
				row:SetBackdropColor(.5, .5, .5, 0.2)
			else
				row:SetBackdropColor(1, 1, 1, 0.00)
			end

			row:SetPoint("topleft", scrollframe, "topleft", 0, (i-1) * size * -1)
			row:SetPoint("topright", scrollframe, "topright", 0, (i-1) * size * -1)
			tinsert(scrollframe.lines, row)

			row.text_available = {}
			row.text_inuse = {}
			row.text_total = 0

			row.entry_available = {}
			row.entry_inuse = {}
			row.entry_total = 0

			row.button_available = {}
			row.button_inuse = {}
			row.button_total = 0

			row.checkbox_available = {}
			row.checkbox_inuse = {}
			row.checkbox_total = 0

			row.icon_available = {}
			row.icon_inuse = {}
			row.icon_total = 0

			row.texture_available = {}
			row.texture_inuse = {}
			row.texture_total = 0
		end
	end
	panel:UpdateRowAmount()

	panel.AlignRows (panel)

	return panel
end


------------color pick
local color_pick_func = function()
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local a = OpacitySliderFrame:GetValue()
	ColorPickerFrame:dcallback (r, g, b, a, ColorPickerFrame.dframe)
end
local color_pick_func_cancel = function()
	ColorPickerFrame:SetColorRGB (unpack(ColorPickerFrame.previousValues))
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local a = OpacitySliderFrame:GetValue()
	ColorPickerFrame:dcallback (r, g, b, a, ColorPickerFrame.dframe)
end

function detailsFramework:ColorPick (frame, r, g, b, alpha, callback)

	ColorPickerFrame:ClearAllPoints()
	ColorPickerFrame:SetPoint("bottomleft", frame, "topright", 0, 0)

	ColorPickerFrame.dcallback = callback
	ColorPickerFrame.dframe = frame

	ColorPickerFrame.func = color_pick_func
	ColorPickerFrame.opacityFunc = color_pick_func
	ColorPickerFrame.cancelFunc = color_pick_func_cancel

	ColorPickerFrame.opacity = alpha
	ColorPickerFrame.hasOpacity = alpha and true

	ColorPickerFrame.previousValues = {r, g, b}
	ColorPickerFrame:SetParent(UIParent)
	ColorPickerFrame:SetFrameStrata("tooltip")
	ColorPickerFrame:SetColorRGB (r, g, b)
	ColorPickerFrame:Show()

end

------------icon pick
function detailsFramework:IconPick (callback, close_when_select, param1, param2)

	if (not detailsFramework.IconPickFrame) then

		local string_lower = string.lower

		detailsFramework.IconPickFrame = CreateFrame("frame", "DetailsFrameworkIconPickFrame", UIParent, "BackdropTemplate")
		tinsert(UISpecialFrames, "DetailsFrameworkIconPickFrame")
		detailsFramework.IconPickFrame:SetFrameStrata("FULLSCREEN")

		detailsFramework.IconPickFrame:SetPoint("center", UIParent, "center")
		detailsFramework.IconPickFrame:SetWidth(416)
		detailsFramework.IconPickFrame:SetHeight(350)
		detailsFramework.IconPickFrame:EnableMouse(true)
		detailsFramework.IconPickFrame:SetMovable(true)

		detailsFramework:CreateTitleBar (detailsFramework.IconPickFrame, "Details! Framework Icon Picker")

		detailsFramework.IconPickFrame:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		detailsFramework.IconPickFrame:SetBackdropBorderColor(0, 0, 0)
		detailsFramework.IconPickFrame:SetBackdropColor(24/255, 24/255, 24/255, .8)
		detailsFramework.IconPickFrame:SetFrameLevel(5000)

		detailsFramework.IconPickFrame:SetScript("OnMouseDown", function(self)
			if (not self.isMoving) then
				detailsFramework.IconPickFrame:StartMoving()
				self.isMoving = true
			end
		end)

		detailsFramework.IconPickFrame:SetScript("OnMouseUp", function(self)
			if (self.isMoving) then
				detailsFramework.IconPickFrame:StopMovingOrSizing()
				self.isMoving = nil
			end
		end)

		detailsFramework.IconPickFrame.emptyFunction = function() end
		detailsFramework.IconPickFrame.callback = detailsFramework.IconPickFrame.emptyFunction

		detailsFramework.IconPickFrame.preview =  CreateFrame("frame", nil, UIParent, "BackdropTemplate")
		detailsFramework.IconPickFrame.preview:SetFrameStrata("tooltip")
		detailsFramework.IconPickFrame.preview:SetFrameLevel(6001)
		detailsFramework.IconPickFrame.preview:SetSize(76, 76)

		local preview_image_bg = detailsFramework:NewImage(detailsFramework.IconPickFrame.preview, nil, 76, 76)
		preview_image_bg:SetDrawLayer("background", 0)
		preview_image_bg:SetAllPoints(detailsFramework.IconPickFrame.preview)
		preview_image_bg:SetColorTexture(0, 0, 0)

		local preview_image = detailsFramework:NewImage(detailsFramework.IconPickFrame.preview, nil, 76, 76)
		preview_image:SetAllPoints(detailsFramework.IconPickFrame.preview)

		detailsFramework.IconPickFrame.preview.icon = preview_image
		detailsFramework.IconPickFrame.preview:Hide()

		--serach
		detailsFramework.IconPickFrame.searchLabel =  detailsFramework:NewLabel(detailsFramework.IconPickFrame, nil, "$parentSearchBoxLabel", nil, "Search:")
		detailsFramework.IconPickFrame.searchLabel:SetPoint("topleft", detailsFramework.IconPickFrame, "topleft", 12, -36)
		detailsFramework.IconPickFrame.searchLabel:SetTemplate(detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
		detailsFramework.IconPickFrame.searchLabel.fontsize = 12

		detailsFramework.IconPickFrame.search = detailsFramework:NewTextEntry(detailsFramework.IconPickFrame, nil, "$parentSearchBox", nil, 140, 20)
		detailsFramework.IconPickFrame.search:SetPoint("left", detailsFramework.IconPickFrame.searchLabel, "right", 2, 0)
		detailsFramework.IconPickFrame.search:SetTemplate(detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

		detailsFramework.IconPickFrame.search:SetHook("OnTextChanged", function()
			detailsFramework.IconPickFrame.searching = detailsFramework.IconPickFrame.search:GetText()
			if (detailsFramework.IconPickFrame.searching == "") then
				detailsFramework.IconPickFrameScroll:Show()
				detailsFramework.IconPickFrame.searching = nil
				detailsFramework.IconPickFrameScroll.RefreshIcons()
			else
				detailsFramework.IconPickFrameScroll:Hide()
				FauxScrollFrame_SetOffset (detailsFramework.IconPickFrame, 1)
				detailsFramework.IconPickFrame.last_filter_index = 1
				detailsFramework.IconPickFrameScroll.RefreshIcons()
			end
		end)

		--manually enter the icon path
		detailsFramework.IconPickFrame.customIcon = detailsFramework:CreateLabel(detailsFramework.IconPickFrame, "Icon Path:", detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
		detailsFramework.IconPickFrame.customIcon:SetPoint("bottomleft", detailsFramework.IconPickFrame, "bottomleft", 12, 16)
		detailsFramework.IconPickFrame.customIcon.fontsize = 12

		detailsFramework.IconPickFrame.customIconEntry = detailsFramework:CreateTextEntry(detailsFramework.IconPickFrame, function()end, 200, 20, "CustomIconEntry", _, _, detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
		detailsFramework.IconPickFrame.customIconEntry:SetPoint("left", detailsFramework.IconPickFrame.customIcon, "right", 2, 0)

		detailsFramework.IconPickFrame.customIconEntry:SetHook("OnTextChanged", function()
			detailsFramework.IconPickFrame.preview:SetPoint("bottom", detailsFramework.IconPickFrame.customIconEntry.widget, "top", 0, 2)
			detailsFramework.IconPickFrame.preview.icon:SetTexture(detailsFramework.IconPickFrame.customIconEntry:GetText())
			detailsFramework.IconPickFrame.preview:Show()
		end)

		detailsFramework.IconPickFrame.customIconEntry:SetHook("OnEnter", function()
			detailsFramework.IconPickFrame.preview:SetPoint("bottom", detailsFramework.IconPickFrame.customIconEntry.widget, "top", 0, 2)
			detailsFramework.IconPickFrame.preview.icon:SetTexture(detailsFramework.IconPickFrame.customIconEntry:GetText())
			detailsFramework.IconPickFrame.preview:Show()
		end)

		--close button
		local close_button = CreateFrame("button", nil, detailsFramework.IconPickFrame, "UIPanelCloseButton", "BackdropTemplate")
		close_button:SetWidth(32)
		close_button:SetHeight(32)
		close_button:SetPoint("TOPRIGHT", detailsFramework.IconPickFrame, "TOPRIGHT", -8, -7)
		close_button:SetFrameLevel(close_button:GetFrameLevel()+2)
		close_button:SetAlpha(0) --just hide, it is used below

		--accept custom icon button
		local accept_custom_icon = function()
			local path = detailsFramework.IconPickFrame.customIconEntry:GetText()

			detailsFramework:QuickDispatch(detailsFramework.IconPickFrame.callback, path, detailsFramework.IconPickFrame.param1, detailsFramework.IconPickFrame.param2)

			if (detailsFramework.IconPickFrame.click_close) then
				close_button:Click()
			end
		end

		detailsFramework.IconPickFrame.customIconAccept = detailsFramework:CreateButton(detailsFramework.IconPickFrame, accept_custom_icon, 82, 20, "Accept", nil, nil, nil, nil, nil, nil, detailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"), detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
		detailsFramework.IconPickFrame.customIconAccept:SetPoint("left", detailsFramework.IconPickFrame.customIconEntry, "right", 2, 0)

		--fill with icons
		local MACRO_ICON_FILENAMES = {}
		local SPELLNAMES_CACHE = {}

		detailsFramework.IconPickFrame:SetScript("OnShow", function()
			MACRO_ICON_FILENAMES[1] = "INV_MISC_QUESTIONMARK"
			local index = 2

			for i = 1, GetNumSpellTabs() do
				local tab, tabTex, offset, numSpells, _ = GetSpellTabInfo(i)
				offset = offset + 1
				local tabEnd = offset + numSpells

				for j = offset, tabEnd - 1 do
					--to get spell info by slot, you have to pass in a pet argument
					local spellType, ID = GetSpellBookItemInfo(j, "player")
					if (spellType ~= "FLYOUT") then
						MACRO_ICON_FILENAMES [index] = GetSpellBookItemTexture(j, "player") or 0
						SPELLNAMES_CACHE [index] = GetSpellInfo(ID)
						index = index + 1

					elseif (spellType == "FLYOUT") then
						local _, _, numSlots, isKnown = GetFlyoutInfo(ID)
						if (isKnown and numSlots > 0) then
							for k = 1, numSlots do
								local spellID, overrideSpellID, isKnown = GetFlyoutSlotInfo(ID, k)
								if (isKnown) then
									MACRO_ICON_FILENAMES [index] = GetSpellTexture(spellID) or 0
									SPELLNAMES_CACHE [index] = GetSpellInfo(spellID)
									index = index + 1
								end
							end
						end
					end
				end
			end

			GetLooseMacroItemIcons(MACRO_ICON_FILENAMES)
			GetLooseMacroIcons(MACRO_ICON_FILENAMES)
			GetMacroIcons(MACRO_ICON_FILENAMES)
			GetMacroItemIcons(MACRO_ICON_FILENAMES)

			--reset the custom icon text entry
			detailsFramework.IconPickFrame.customIconEntry:SetText("")
			--reset the search text entry
			detailsFramework.IconPickFrame.search:SetText("")
		end)

		detailsFramework.IconPickFrame:SetScript("OnHide", function()
			wipe(MACRO_ICON_FILENAMES)
			wipe(SPELLNAMES_CACHE)
			detailsFramework.IconPickFrame.preview:Hide()
			collectgarbage()
		end)

		detailsFramework.IconPickFrame.buttons = {}

		local onClickFunction = function(self)

			detailsFramework:QuickDispatch(detailsFramework.IconPickFrame.callback, self.icon:GetTexture(), detailsFramework.IconPickFrame.param1, detailsFramework.IconPickFrame.param2)

			if (detailsFramework.IconPickFrame.click_close) then
				close_button:Click()
			end
		end

		local onEnter = function(self)
			detailsFramework.IconPickFrame.preview:SetPoint("bottom", self, "top", 0, 2)
			detailsFramework.IconPickFrame.preview.icon:SetTexture(self.icon:GetTexture())
			detailsFramework.IconPickFrame.preview:Show()
			self.icon:SetBlendMode("ADD")
		end
		local onLeave = function(self)
			detailsFramework.IconPickFrame.preview:Hide()
			self.icon:SetBlendMode("BLEND")
		end

		local backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tile = true, tileSize = 16,
		insets = {left = 0, right = 0, top = 0, bottom = 0}, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1}

		for _, button in ipairs(detailsFramework.IconPickFrame.buttons) do
			button:SetBackdropBorderColor(0, 0, 0, 1)
		end

		local width = 412
		local height = 248
		local linesAmount = 6
		local lineHeight = 40

		local updateIconScroll = function(self, data, offset, totalLines)
            for i = 1, totalLines do
                local index = i + offset
                local iconsInThisLine = data[index]
				if (iconsInThisLine) then
					local line = self:GetLine(i)
                    for o = 1, #iconsInThisLine do
						local _, _, texture = GetSpellInfo(iconsInThisLine[o])
						if (texture) then
							line.buttons[o].icon:SetTexture(texture)
							line.buttons[o].texture = texture
						else
							line.buttons[o].icon:SetTexture(iconsInThisLine[o])
							line.buttons[o].texture = iconsInThisLine[o]
						end
					end
				end
			end
		end

		local lower = string.lower

		local scroll = detailsFramework:CreateScrollBox(detailsFramework.IconPickFrame, "DetailsFrameworkIconPickFrameScroll", updateIconScroll, {}, width, height, linesAmount, lineHeight)
		detailsFramework:ReskinSlider(scroll)
		scroll:SetPoint("topleft", detailsFramework.IconPickFrame, "topleft", 2, -58)

		function scroll.RefreshIcons()
			--build icon list
			local iconList = {}
			local numMacroIcons = #MACRO_ICON_FILENAMES

			local filter
			if (detailsFramework.IconPickFrame.searching) then
				filter = lower(detailsFramework.IconPickFrame.searching)
			end

			if (filter and filter ~= "") then
				local index
				local currentTable
				for i = 1, #SPELLNAMES_CACHE do
					if (SPELLNAMES_CACHE[i] and SPELLNAMES_CACHE[i]:lower():find(filter)) then
						if (not index) then
							index = 1
							local t = {}
							iconList[#iconList+1] = t
							currentTable = t
						end

						currentTable[index] = SPELLNAMES_CACHE[i]

						index = index + 1
						if (index == 11) then
							index = nil
						end
					end

				end
			else
				for i = 1, #SPELLNAMES_CACHE, 10 do
					local t = {}
					iconList[#iconList+1] = t
					for o = i, i+9 do
						if (SPELLNAMES_CACHE[o]) then
							t[#t+1] = SPELLNAMES_CACHE[o]
						end
					end
				end

				for i = 1, #MACRO_ICON_FILENAMES, 10 do
					local t = {}
					iconList[#iconList+1] = t
					for o = i, i+9 do
						if (MACRO_ICON_FILENAMES[o]) then
							t[#t+1] = MACRO_ICON_FILENAMES[o]
						end
					end
				end
			end

			--set data and refresh
			scroll:SetData(iconList)
			scroll:Refresh()
		end

		--create the lines and button of the scroll box
		for i = 1, linesAmount do
			scroll:CreateLine(function(self, index)
				local line = CreateFrame("button", "$parentLine" .. index, self, "BackdropTemplate")
				line:SetPoint("topleft", self, "topleft", 1, -((index-1)*(lineHeight+1)) - 1)
				line:SetSize(width - 2, lineHeight)
				line:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				line:SetBackdropColor(.2, .2, .2, .5)
				line.buttons = {}

				local lastButton

				for o = 1, 10 do
					local button = CreateFrame("button", "$parentIcon" .. o, line)
					if (not lastButton) then
						button:SetPoint("left", line, "left", 0, 0)
					else
						button:SetPoint("left", lastButton, "right", 1, 0)
					end
					button:SetSize(lineHeight, lineHeight)
					button.icon = button:CreateTexture("$parentIcon", "overlay")
					button.icon:SetAllPoints()
					button.icon:SetTexCoord(.1, .9, .1, .9)
					line.buttons[o] = button

					button:SetScript("OnEnter", onEnter)
					button:SetScript("OnLeave", onLeave)
					button:SetScript("OnClick", onClickFunction)

					lastButton = button
				end

				return line
			end)
		end

		detailsFramework.IconPickFrameScroll = scroll
		detailsFramework.IconPickFrame:Hide()
	end

	detailsFramework.IconPickFrame.param1, detailsFramework.IconPickFrame.param2 = param1, param2
	detailsFramework.IconPickFrame:Show()
	detailsFramework.IconPickFrame.callback = callback or detailsFramework.IconPickFrame.emptyFunction
	detailsFramework.IconPickFrame.click_close = close_when_select
	detailsFramework.IconPickFrameScroll.RefreshIcons()

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function detailsFramework:ShowPanicWarning (text)
	if (not detailsFramework.PanicWarningWindow) then
		detailsFramework.PanicWarningWindow = CreateFrame("frame", "DetailsFrameworkPanicWarningWindow", UIParent, "BackdropTemplate")
		detailsFramework.PanicWarningWindow:SetHeight(80)
		detailsFramework.PanicWarningWindow:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		detailsFramework.PanicWarningWindow:SetBackdropColor(1, 0, 0, 0.2)
		detailsFramework.PanicWarningWindow:SetPoint("topleft", UIParent, "topleft", 0, -250)
		detailsFramework.PanicWarningWindow:SetPoint("topright", UIParent, "topright", 0, -250)

		detailsFramework.PanicWarningWindow.text = detailsFramework.PanicWarningWindow:CreateFontString(nil, "overlay", "GameFontNormal")
		detailsFramework.PanicWarningWindow.text:SetPoint("center", detailsFramework.PanicWarningWindow, "center")
		detailsFramework.PanicWarningWindow.text:SetTextColor(1, 0.6, 0)
	end

	detailsFramework.PanicWarningWindow.text:SetText(text)
	detailsFramework.PanicWarningWindow:Show()
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local simple_panel_mouse_down = function(self, button)
	if (button == "RightButton") then
		if (self.IsMoving) then
			self.IsMoving = false
			self:StopMovingOrSizing()
			if (self.db and self.db.position) then
				detailsFramework:SavePositionOnScreen (self)
			end
		end
		if (not self.DontRightClickClose) then
			self:Hide()
		end
		return
	end
	if (not self.IsMoving and not self.IsLocked) then
		self.IsMoving = true
		self:StartMoving()
	end
end
local simple_panel_mouse_up = function(self, button)
	if (self.IsMoving) then
		self.IsMoving = false
		self:StopMovingOrSizing()
		if (self.db and self.db.position) then
			detailsFramework:SavePositionOnScreen (self)
		end
	end
end
local simple_panel_settitle = function(self, title)
	self.Title:SetText(title)
end

local simple_panel_close_click = function(self)
	self:GetParent():GetParent():Hide()
end

local SimplePanel_frame_backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true}
local SimplePanel_frame_backdrop_color = {0, 0, 0, 0.9}
local SimplePanel_frame_backdrop_border_color = {0, 0, 0, 1}

--with_label was making the frame stay in place while its parent moves
--the slider was anchoring to with_label and here here were anchoring the slider again
function detailsFramework:CreateScaleBar(frame, config) --~scale
	local scaleBar, text = detailsFramework:CreateSlider(frame, 120, 14, 0.6, 1.6, 0.1, config.scale, true, "ScaleBar", nil, "Scale:", detailsFramework:GetTemplate("slider", "OPTIONS_SLIDER_TEMPLATE"), detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
	scaleBar.thumb:SetWidth(24)
	scaleBar:SetValueStep(0.1)
	scaleBar:SetObeyStepOnDrag(true)
	scaleBar.mouseDown = false
	rawset(scaleBar, "lockdown", true)

	--create a custom editbox to enter the scale from text
	local editbox = CreateFrame("editbox", nil, scaleBar.widget, "BackdropTemplate")
	editbox:SetSize(40, 20)
	editbox:SetJustifyH("center")
	editbox:SetBackdrop({bgFile = [[Interface\ACHIEVEMENTFRAME\UI-GuildAchievement-Parchment-Horizontal-Desaturated]],
	edgeFile = [[Interface\Buttons\WHITE8X8]],
	tile = true, edgeSize = 1, tileSize = 64})
	editbox:SetFontObject("GameFontHighlightSmall")
	editbox:SetBackdropColor(0, 0, 0, 1)

	editbox:SetScript("OnEditFocusGained", function()
	end)

	editbox:SetScript("OnEnterPressed", function()
		editbox:ClearFocus()
		editbox:Hide()
		local text = editbox:GetText()
		local newScale = detailsFramework.TextToFloor(text)

		if (newScale) then
			config.scale = newScale
			scaleBar:SetValue(newScale)
			frame:SetScale(newScale)
			editbox.defaultValue = newScale
		end
	end)

	editbox:SetScript("OnEscapePressed", function()
		editbox:ClearFocus()
		editbox:Hide()
		editbox:SetText(editbox.defaultValue)
	end)

	scaleBar:SetScript("OnMouseDown", function(_, mouseButton)
		if (mouseButton == "RightButton") then
			editbox:Show()
			editbox:SetAllPoints()
			editbox:SetText(config.scale)
			editbox:SetFocus(true)
			editbox.defaultValue = config.scale

		elseif (mouseButton == "LeftButton") then
			scaleBar.mouseDown  = true
		end
	end)

	scaleBar:SetScript("OnMouseUp", function(_, mouseButton)
		if (mouseButton == "LeftButton") then
			scaleBar.mouseDown  = false
			frame:SetScale(config.scale)
			editbox.defaultValue = config.scale
		end
	end)

	text:SetPoint("topleft", frame, "topleft", 12, -7)
	scaleBar:SetFrameLevel(detailsFramework.FRAMELEVEL_OVERLAY)
	scaleBar.OnValueChanged = function(_, _, value)
		if (scaleBar.mouseDown) then
			config.scale = value
		end
	end

	scaleBar:SetAlpha(0.70)
	editbox.defaultValue = config.scale
	editbox:SetFocus(false)
	editbox:SetAutoFocus(false)
	editbox:ClearFocus()

	C_Timer.After(1, function()
		editbox:SetFocus(false)
		editbox:SetAutoFocus(false)
		editbox:ClearFocus()
	end)

	return scaleBar
end

local no_options = {}
--[=[
	options available to panel_options:
	NoScripts = false, --if true, won't set OnMouseDown and OnMouseUp (won't be movable)
	NoTUISpecialFrame = false, --if true, won't add the frame to 'UISpecialFrames'
	DontRightClickClose = false, --if true, won't make the frame close when clicked with the right mouse button
	UseScaleBar = false, --if true, will create a scale bar in the top left corner (require a table on 'db' to save the scale)
	UseStatusBar = false, --if true, creates a status bar at the bottom of the frame (frame.StatusBar)
	NoCloseButton = false, --if true, won't show the close button
	NoTitleBar = false, --if true, don't create the title bar
]=]
function detailsFramework:CreateSimplePanel(parent, width, height, title, frameName, panelOptions, savedVariableTable)
	if (savedVariableTable and frameName and not savedVariableTable[frameName]) then
		savedVariableTable[frameName] = {
			scale = 1
		}
	end

	if (not frameName) then
		frameName = "DetailsFrameworkSimplePanel" .. detailsFramework.SimplePanelCounter
		detailsFramework.SimplePanelCounter = detailsFramework.SimplePanelCounter + 1
	end
	if (not parent) then
		parent = UIParent
	end

	panelOptions = panelOptions or no_options

	local simplePanel = CreateFrame("frame", frameName, UIParent,"BackdropTemplate")
	simplePanel:SetSize(width or 400, height or 250)
	simplePanel:SetPoint("center", UIParent, "center", 0, 0)
	simplePanel:SetFrameStrata("FULLSCREEN")
	simplePanel:EnableMouse()
	simplePanel:SetMovable(true)
	simplePanel:SetBackdrop(SimplePanel_frame_backdrop)
	simplePanel:SetBackdropColor(unpack(SimplePanel_frame_backdrop_color))
	simplePanel:SetBackdropBorderColor(unpack(SimplePanel_frame_backdrop_border_color))

	simplePanel.DontRightClickClose = panelOptions.DontRightClickClose

	if (not panelOptions.NoTUISpecialFrame) then
		tinsert(UISpecialFrames, frameName)
	end

	if (panelOptions.UseStatusBar) then
		local statusBar = detailsFramework:CreateStatusBar(simplePanel)
		simplePanel.StatusBar = statusBar
	end

	local titleBar = CreateFrame("frame", frameName .. "TitleBar", simplePanel,"BackdropTemplate")
	titleBar:SetPoint("topleft", simplePanel, "topleft", 2, -3)
	titleBar:SetPoint("topright", simplePanel, "topright", -2, -3)
	titleBar:SetHeight(20)
	titleBar:SetBackdrop(SimplePanel_frame_backdrop)
	titleBar:SetBackdropColor(.2, .2, .2, 1)
	titleBar:SetBackdropBorderColor(0, 0, 0, 1)
	simplePanel.TitleBar = titleBar

	local close = CreateFrame("button", frameName and frameName .. "CloseButton", titleBar)
	close:SetFrameLevel(detailsFramework.FRAMELEVEL_OVERLAY)
	close:SetSize(16, 16)

	close:SetNormalTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	close:SetHighlightTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	close:SetPushedTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	close:GetNormalTexture():SetDesaturated(true)
	close:GetHighlightTexture():SetDesaturated(true)
	close:GetPushedTexture():SetDesaturated(true)

	close:SetAlpha(0.7)
	close:SetScript("OnClick", simple_panel_close_click)
	simplePanel.Close = close

	local titleText = titleBar:CreateFontString(frameName and frameName .. "Title", "overlay", "GameFontNormal")
	titleText:SetTextColor(.8, .8, .8, 1)
	titleText:SetText(title or "")
	simplePanel.Title = titleText

	if (panelOptions.UseScaleBar and savedVariableTable [frameName]) then
		detailsFramework:CreateScaleBar (simplePanel, savedVariableTable [frameName])
		simplePanel:SetScale(savedVariableTable [frameName].scale)
	end

	simplePanel.Title:SetPoint("center", titleBar, "center")
	simplePanel.Close:SetPoint("right", titleBar, "right", -2, 0)

	if (panelOptions.NoCloseButton) then
		simplePanel.Close:Hide()
	end

	if (panelOptions.NoTitleBar) then
		simplePanel.TitleBar:Hide()
	end

	if (not panelOptions.NoScripts) then
		simplePanel:SetScript("OnMouseDown", simple_panel_mouse_down)
		simplePanel:SetScript("OnMouseUp", simple_panel_mouse_up)
	end

	simplePanel.SetTitle = simple_panel_settitle

	return simplePanel
end

local Panel1PxBackdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 64,
edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, insets = {left = 2, right = 2, top = 3, bottom = 3}}

local Panel1PxOnClickClose = function(self)
	self:GetParent():Hide()
end
local Panel1PxOnToggleLock = function(self)
	if (self.IsLocked) then
		self.IsLocked = false
		self:SetMovable(true)
		self:EnableMouse(true)
		self.Lock:GetNormalTexture():SetTexCoord(16/64, 32/64, 0, 1)
		self.Lock:GetHighlightTexture():SetTexCoord(16/32, 32/64, 0, 1)
		self.Lock:GetPushedTexture():SetTexCoord(16/64, 32/64, 0, 1)
		if (self.OnUnlock) then
			self:OnUnlock()
		end
		if (self.db) then
			self.db.IsLocked = self.IsLocked
		end
	else
		self.IsLocked = true
		self:SetMovable(false)
		self:EnableMouse(false)
		self.Lock:GetNormalTexture():SetTexCoord(0/64, 16/64, 0, 1)
		self.Lock:GetHighlightTexture():SetTexCoord(0/64, 16/64, 0, 1)
		self.Lock:GetPushedTexture():SetTexCoord(0/64, 16/64, 0, 1)
		if (self.OnLock) then
			self:OnLock()
		end
		if (self.db) then
			self.db.IsLocked = self.IsLocked
		end
	end
end
local Panel1PxOnClickLock = function(self)
	local f = self:GetParent()
	Panel1PxOnToggleLock (f)
end
local Panel1PxSetTitle = function(self, text)
	self.Title:SetText(text or "")
end

local Panel1PxSetLocked= function(self, lock_state)
	if (type(lock_state) ~= "boolean") then
		return
	end
	if (lock_state) then
		-- lock it
		self.IsLocked = false
		Panel1PxOnClickLock (self.Lock)
	else
		-- unlockit
		self.IsLocked = true
		Panel1PxOnClickLock (self.Lock)
	end
end

local Panel1PxReadConfig = function(self)
	local db = self.db
	if (db) then
		db.IsLocked = db.IsLocked or false
		self.IsLocked = db.IsLocked
		db.position = db.position or {x = 0, y = 0}
		db.position.x = db.position.x or 0
		db.position.y = db.position.y or 0
		detailsFramework:RestoreFramePosition (self)
	end
end

function detailsFramework:SavePositionOnScreen (frame)
	if (frame.db and frame.db.position) then
		local x, y = detailsFramework:GetPositionOnScreen (frame)
		--print("saving...", x, y, frame:GetName())
		if (x and y) then
			frame.db.position.x, frame.db.position.y = x, y
		end
	end
end

function detailsFramework:GetPositionOnScreen (frame)
	local xOfs, yOfs = frame:GetCenter()
	if (not xOfs) then
		return
	end
	local scale = frame:GetEffectiveScale()
	local UIscale = UIParent:GetScale()
	xOfs = xOfs*scale - GetScreenWidth()*UIscale/2
	yOfs = yOfs*scale - GetScreenHeight()*UIscale/2
	return xOfs/UIscale, yOfs/UIscale
end

function detailsFramework:RestoreFramePosition (frame)
	if (frame.db and frame.db.position) then
		local scale, UIscale = frame:GetEffectiveScale(), UIParent:GetScale()
		frame:ClearAllPoints()
		frame.db.position.x = frame.db.position.x or 0
		frame.db.position.y = frame.db.position.y or 0
		frame:SetPoint("center", UIParent, "center", frame.db.position.x * UIscale / scale, frame.db.position.y * UIscale / scale)
	end
end

local Panel1PxSavePosition= function(self)
	detailsFramework:SavePositionOnScreen (self)
end

local Panel1PxHasPosition = function(self)
	local db = self.db
	if (db) then
		if (db.position and db.position.x and (db.position.x ~= 0 or db.position.y ~= 0)) then
			return true
		end
	end
end

function detailsFramework:Create1PxPanel(parent, width, height, title, name, config, titleAnchor, noSpecialFrame)
	local newFrame = CreateFrame("frame", name, parent or UIParent, "BackdropTemplate")
	newFrame:SetSize(width or 100, height or 75)
	newFrame:SetPoint("center", UIParent, "center", 0, 0)

	if (name and not noSpecialFrame) then
		tinsert(UISpecialFrames, name)
	end

	newFrame:SetScript("OnMouseDown", simple_panel_mouse_down)
	newFrame:SetScript("OnMouseUp", simple_panel_mouse_up)

	newFrame:SetBackdrop(Panel1PxBackdrop)
	newFrame:SetBackdropColor(0, 0, 0, 0.5)

	newFrame.IsLocked = (config and config.IsLocked ~= nil and config.IsLocked) or false
	newFrame:SetMovable(true)
	newFrame:EnableMouse(true)
	newFrame:SetUserPlaced (true)

	newFrame.db = config
	Panel1PxReadConfig(newFrame)

	local closeButton = CreateFrame("button", name and name .. "CloseButton", newFrame, "BackdropTemplate")
	closeButton:SetSize(16, 16)
	closeButton:SetNormalTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	closeButton:SetHighlightTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	closeButton:SetPushedTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	closeButton:GetNormalTexture():SetDesaturated(true)
	closeButton:GetHighlightTexture():SetDesaturated(true)
	closeButton:GetPushedTexture():SetDesaturated(true)
	closeButton:SetAlpha(0.7)

	local lockButton = CreateFrame("button", name and name .. "LockButton", newFrame, "BackdropTemplate")
	lockButton:SetSize(16, 16)
	lockButton:SetNormalTexture([[Interface\GLUES\CharacterSelect\Glues-AddOn-Icons]])
	lockButton:SetHighlightTexture([[Interface\GLUES\CharacterSelect\Glues-AddOn-Icons]])
	lockButton:SetPushedTexture([[Interface\GLUES\CharacterSelect\Glues-AddOn-Icons]])
	lockButton:GetNormalTexture():SetDesaturated(true)
	lockButton:GetHighlightTexture():SetDesaturated(true)
	lockButton:GetPushedTexture():SetDesaturated(true)
	lockButton:SetAlpha(0.7)

	closeButton:SetPoint("topright", newFrame, "topright", -3, -3)
	lockButton:SetPoint("right", closeButton, "left", 3, 0)

	closeButton:SetScript("OnClick", Panel1PxOnClickClose)
	lockButton:SetScript("OnClick", Panel1PxOnClickLock)

	local titleString = newFrame:CreateFontString(name and name .. "Title", "overlay", "GameFontNormal")
	titleString:SetPoint("topleft", newFrame, "topleft", 5, -5)

	detailsFramework.Language.SetTextIfLocTableOrDefault(titleString, title or "")

	if (titleAnchor) then
		if (titleAnchor == "top") then
			titleString:ClearAllPoints()
			titleString:SetPoint("bottomleft", newFrame, "topleft", 0, 0)

			closeButton:ClearAllPoints()
			closeButton:SetPoint("bottomright", newFrame, "topright", 0, 0)
		end
		newFrame.title_anchor = titleAnchor
	end

	newFrame.SetTitle = Panel1PxSetTitle
	newFrame.Title = titleString
	newFrame.Lock = lockButton
	newFrame.Close = closeButton
	newFrame.HasPosition = Panel1PxHasPosition
	newFrame.SavePosition = Panel1PxSavePosition

	newFrame.IsLocked = not newFrame.IsLocked
	newFrame.SetLocked = Panel1PxSetLocked
	Panel1PxOnToggleLock(newFrame)

	return newFrame
end

------------------------------------------------------------------------------------------------------------------------------------------------
-- ~prompt
--@dontOverride: won't show another prompt if theres already a shown prompt
function detailsFramework:ShowPromptPanel(message, trueCallback, falseCallback, dontOverride, width)
	if (not DetailsFrameworkPromptSimple) then
		local promptFrame = CreateFrame("frame", "DetailsFrameworkPromptSimple", UIParent, "BackdropTemplate")
		promptFrame:SetSize(400, 80)
		promptFrame:SetFrameStrata("DIALOG")
		promptFrame:SetPoint("center", UIParent, "center", 0, 300)
		detailsFramework:ApplyStandardBackdrop(promptFrame)
		tinsert(UISpecialFrames, "DetailsFrameworkPromptSimple")

		detailsFramework:CreateTitleBar(promptFrame, "Prompt!")
		detailsFramework:ApplyStandardBackdrop(promptFrame)

		local prompt = promptFrame:CreateFontString(nil, "overlay", "GameFontNormal")
		prompt:SetPoint("top", promptFrame, "top", 0, -28)
		prompt:SetJustifyH("center")
		promptFrame.prompt = prompt

		local button_text_template = detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
		local options_dropdown_template = detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")

		local buttonTrue = detailsFramework:CreateButton(promptFrame, nil, 60, 20, "Yes", nil, nil, nil, nil, nil, nil, options_dropdown_template)
		buttonTrue:SetPoint("bottomright", promptFrame, "bottomright", -5, 5)
		promptFrame.button_true = buttonTrue

		local buttonFalse = detailsFramework:CreateButton(promptFrame, nil, 60, 20, "No", nil, nil, nil, nil, nil, nil, options_dropdown_template)
		buttonFalse:SetPoint("bottomleft", promptFrame, "bottomleft", 5, 5)
		promptFrame.button_false = buttonFalse

		buttonTrue:SetClickFunction(function()
			local my_func = buttonTrue.true_function
			if (my_func) then
				local okey, errormessage = pcall(my_func, true)
				if (not okey) then
					print("error:", errormessage)
				end
				promptFrame:Hide()
			end
		end)

		buttonFalse:SetClickFunction(function()
			local my_func = buttonFalse.false_function
			if (my_func) then
				local okey, errormessage = pcall(my_func, true)
				if (not okey) then
					print("error:", errormessage)
				end
				promptFrame:Hide()
			end
		end)

		promptFrame.ShowAnimation = detailsFramework:CreateAnimationHub(promptFrame, function()
			promptFrame:SetBackdropBorderColor(0, 0, 0, 0)
			promptFrame.TitleBar:SetBackdropBorderColor(0, 0, 0, 0)
		end,
		function()
			promptFrame:SetBackdropBorderColor(0, 0, 0, 1)
			promptFrame.TitleBar:SetBackdropBorderColor(0, 0, 0, 1)
		end)

		detailsFramework:CreateAnimation(promptFrame.ShowAnimation, "scale", 1, .075, .2, .2, 1.1, 1.1, "center", 0, 0)
		detailsFramework:CreateAnimation(promptFrame.ShowAnimation, "scale", 2, .075, 1, 1, .90, .90, "center", 0, 0)

		promptFrame.FlashTexture = promptFrame:CreateTexture(nil, "overlay")
		promptFrame.FlashTexture:SetColorTexture(1, 1, 1, 1)
		promptFrame.FlashTexture:SetAllPoints()

		promptFrame.FlashAnimation = detailsFramework:CreateAnimationHub(promptFrame.FlashTexture, function() promptFrame.FlashTexture:Show() end, function() promptFrame.FlashTexture:Hide() end)
		detailsFramework:CreateAnimation(promptFrame.FlashAnimation, "alpha", 1, .075, 0, .25)
		detailsFramework:CreateAnimation(promptFrame.FlashAnimation, "alpha", 2, .075, .35, 0)

		promptFrame:Hide()
		detailsFramework.promtp_panel = promptFrame
	end

	assert(type(trueCallback) == "function" and type(falseCallback) == "function", "ShowPromptPanel expects two functions.")

	if (dontOverride) then
		if (detailsFramework.promtp_panel:IsShown()) then
			return
		end
	end

	if (width) then
		detailsFramework.promtp_panel:SetWidth(width)
	else
		detailsFramework.promtp_panel:SetWidth(400)
	end

	detailsFramework.promtp_panel.prompt:SetText(message)
	detailsFramework.promtp_panel.button_true.true_function = trueCallback
	detailsFramework.promtp_panel.button_false.false_function = falseCallback

	detailsFramework.promtp_panel:Show()

	detailsFramework.promtp_panel.ShowAnimation:Play()
	detailsFramework.promtp_panel.FlashAnimation:Play()
end


function detailsFramework:ShowTextPromptPanel(message, callback)
	if (not detailsFramework.text_prompt_panel) then
		local promptFrame = CreateFrame("frame", "DetailsFrameworkPrompt", UIParent, "BackdropTemplate")
		promptFrame:SetSize(400, 120)
		promptFrame:SetFrameStrata("FULLSCREEN")
		promptFrame:SetPoint("center", UIParent, "center", 0, 100)
		promptFrame:EnableMouse(true)
		promptFrame:SetMovable(true)
		promptFrame:RegisterForDrag ("LeftButton")
		promptFrame:SetScript("OnDragStart", function() promptFrame:StartMoving() end)
		promptFrame:SetScript("OnDragStop", function() promptFrame:StopMovingOrSizing() end)
		promptFrame:SetScript("OnMouseDown", function(self, button) if (button == "RightButton") then promptFrame.EntryBox:ClearFocus() promptFrame:Hide() end end)
		tinsert(UISpecialFrames, "DetailsFrameworkPrompt")

		detailsFramework:CreateTitleBar (promptFrame, "Prompt!")
		detailsFramework:ApplyStandardBackdrop(promptFrame)

		local prompt = promptFrame:CreateFontString(nil, "overlay", "GameFontNormal")
		prompt:SetPoint("top", promptFrame, "top", 0, -25)
		prompt:SetJustifyH("center")
		prompt:SetSize(360, 36)
		promptFrame.prompt = prompt

		local button_text_template = detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
		local options_dropdown_template = detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")

		local textbox = detailsFramework:CreateTextEntry(promptFrame, function()end, 380, 20, "textbox", nil, nil, options_dropdown_template)
		textbox:SetPoint("topleft", promptFrame, "topleft", 10, -60)
		promptFrame.EntryBox = textbox

		local buttonTrue = detailsFramework:CreateButton(promptFrame, nil, 60, 20, "Okey", nil, nil, nil, nil, nil, nil, options_dropdown_template)
		buttonTrue:SetPoint("bottomright", promptFrame, "bottomright", -10, 5)
		promptFrame.button_true = buttonTrue

		local buttonFalse = detailsFramework:CreateButton(promptFrame, function() promptFrame.textbox:ClearFocus() promptFrame:Hide() end, 60, 20, "Cancel", nil, nil, nil, nil, nil, nil, options_dropdown_template)
		buttonFalse:SetPoint("bottomleft", promptFrame, "bottomleft", 10, 5)
		promptFrame.button_false = buttonFalse

		local executeCallback = function()
			local my_func = buttonTrue.true_function
			if (my_func) then
				local okey, errormessage = pcall(my_func, textbox:GetText())
				textbox:ClearFocus()
				if (not okey) then
					print("error:", errormessage)
				end
				promptFrame:Hide()
			end
		end

		buttonTrue:SetClickFunction(function()
			executeCallback()
		end)

		textbox:SetHook("OnEnterPressed", function()
			executeCallback()
		end)

		promptFrame:Hide()
		detailsFramework.text_prompt_panel = promptFrame
	end

	detailsFramework.text_prompt_panel:Show()
	DetailsFrameworkPrompt.EntryBox:SetText("")
	detailsFramework.text_prompt_panel.prompt:SetText(message)
	detailsFramework.text_prompt_panel.button_true.true_function = callback
	detailsFramework.text_prompt_panel.textbox:SetFocus(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------
--chart panel -- ~chart

local chart_panel_backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 32, insets = {left = 5, right = 5, top = 5, bottom = 5}}

local chart_panel_align_timelabels = function(self, elapsed_time)
	self.TimeScale = elapsed_time

	local linha = self.TimeLabels[17]
	local minutes, seconds = math.floor(elapsed_time / 60), math.floor(elapsed_time % 60)
	if (seconds < 10) then
		seconds = "0" .. seconds
	end

	if (minutes > 0) then
		if (minutes < 10) then
			minutes = "0" .. minutes
		end
		linha:SetText(minutes .. ":" .. seconds)
	else
		linha:SetText("00:" .. seconds)
	end

	local time_div = elapsed_time / 16 --786 -- 49.125

	for i = 2, 16 do
		local linha = self.TimeLabels [i]
		local this_time = time_div * (i-1)
		local minutes, seconds = math.floor(this_time / 60), math.floor(this_time % 60)

		if (seconds < 10) then
			seconds = "0" .. seconds
		end

		if (minutes > 0) then
			if (minutes < 10) then
				minutes = "0" .. minutes
			end
			linha:SetText(minutes .. ":" .. seconds)
		else
			linha:SetText("00:" .. seconds)
		end
	end
end

local chart_panel_set_scale = function(self, amt, func, text)
	if (type(amt) ~= "number") then
		return
	end

	--each line amount, then multiply the line index by this number
	local piece = amt / 8

	for i = 1, 8 do
		if (func) then
			self ["dpsamt" .. math.abs(i-9)]:SetText(func (piece*i))
		else
			if (piece*i > 1) then
				self ["dpsamt" .. math.abs(i-9)]:SetText(detailsFramework.FormatNumber (piece*i))
			else
				self ["dpsamt" .. math.abs(i-9)]:SetText(format("%.3f", piece*i))
			end
		end
	end
end

local chart_panel_can_move = function(self, can)
	self.can_move = can
end

local chart_panel_overlay_reset = function(self)
	self.OverlaysAmount = 1
	for index, pack in ipairs(self.Overlays) do
		for index2, texture in ipairs(pack) do
			texture:Hide()
		end
	end
end

local chart_panel_reset = function(self)
	self.Graphic:ResetData()
	self.Graphic.max_value = 0

	self.TimeScale = nil
	self.BoxLabelsAmount = 1
	table.wipe(self.GData)
	table.wipe(self.OData)

	for index, box in ipairs(self.BoxLabels) do
		box.check:Hide()
		box.button:Hide()
		box.box:Hide()
		box.text:Hide()
		box.border:Hide()
		box.showing = false
	end

	chart_panel_overlay_reset (self)
end

local chart_panel_enable_line = function(f, thisbox)
	local index = thisbox.index
	local boxType = thisbox.type

	if (thisbox.enabled) then
		--disable
		thisbox.check:Hide()
		thisbox.enabled = false
	else
		--enable
		thisbox.check:Show()
		thisbox.enabled = true
	end

	if (boxType == "graphic") then
		f.Graphic:ResetData()
		f.Graphic.max_value = 0

		local max = 0
		local max_time = 0

		for index, box in ipairs(f.BoxLabels) do
			if (box.type == boxType and box.showing and box.enabled) then
				local data = f.GData[index]

				f.Graphic:AddDataSeries(data[1], data[2], nil, data[3])

				if (data[4] > max) then
					max = data[4]
				end
				if (data [5] > max_time) then
					max_time = data [5]
				end
			end
		end

		f:SetScale(max)
		f:SetTime (max_time)

	elseif (boxType == "overlay") then
		chart_panel_overlay_reset (f)

		for index, box in ipairs(f.BoxLabels) do
			if (box.type == boxType and box.showing and box.enabled) then
				f:AddOverlay(box.index)
			end
		end
	end
end

local create_box = function(self, next_box)
	local thisbox = {}
	self.BoxLabels [next_box] = thisbox

	local box = detailsFramework:NewImage(self.Graphic, nil, 16, 16, "border")
	local text = detailsFramework:NewLabel(self.Graphic)

	local border = detailsFramework:NewImage(self.Graphic, [[Interface\DialogFrame\UI-DialogBox-Gold-Corner]], 30, 30, "artwork")
	border:SetPoint("center", box, "center", -3, -4)
	border:SetTexture([[Interface\DialogFrame\UI-DialogBox-Gold-Corner]])

	local checktexture = detailsFramework:NewImage(self.Graphic, [[Interface\Buttons\UI-CheckBox-Check]], 18, 18, "overlay")
	checktexture:SetPoint("center", box, "center", 0, -1)
	checktexture:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])

	thisbox.box = box
	thisbox.text = text
	thisbox.border = border
	thisbox.check = checktexture
	thisbox.enabled = true

	local button = CreateFrame("button", nil, self.Graphic, "BackdropTemplate")
	button:SetSize(20, 20)
	button:SetScript("OnClick", function()
		chart_panel_enable_line (self, thisbox)
	end)
	button:SetPoint("topleft", box.widget or box, "topleft", 0, 0)
	button:SetPoint("bottomright", box.widget or box, "bottomright", 0, 0)

	button:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	button:SetBackdropColor(0, 0, 0, 0.0)
	button:SetBackdropBorderColor(0, 0, 0, 1)

	thisbox.button = button

	thisbox.box:SetPoint("right", text, "left", -4, 0)

	if (next_box == 1) then
		thisbox.text:SetPoint("topright", self, "topright", -35, -16)
	else
		thisbox.text:SetPoint("right", self.BoxLabels [next_box-1].box, "left", -17, 0)
	end

	return thisbox

end

local realign_labels = function(self)
	if (not self.ShowHeader) then
		for _, box in ipairs(self.BoxLabels) do
			box.check:Hide()
			box.button:Hide()
			box.border:Hide()
			box.box:Hide()
			box.text:Hide()
		end
		return
	end

	local width = self:GetWidth() - 108

	local first_box = self.BoxLabels [1]
	first_box.text:SetPoint("topright", self, "topright", -35, -16)

	local line_width = first_box.text:GetStringWidth() + 26

	for i = 2, #self.BoxLabels do

		local box = self.BoxLabels [i]

		if (box.box:IsShown()) then

			line_width = line_width + box.text:GetStringWidth() + 26

			if (line_width > width) then
				line_width = box.text:GetStringWidth() + 26
				box.text:SetPoint("topright", self, "topright", -35, -40)
			else
				box.text:SetPoint("right", self.BoxLabels [i-1].box, "left", -27, 0)
			end
		else
			break
		end
	end

	if (self.HeaderOnlyIndicator) then
		for _, box in ipairs(self.BoxLabels) do
				box.check:Hide()
			box.button:Hide()
		end
		return
	end
end

local chart_panel_add_label = function(self, color, name, type, number)
	local next_box = self.BoxLabelsAmount
	local thisbox = self.BoxLabels [next_box]

	if (not thisbox) then
		thisbox = create_box (self, next_box)
	end

	self.BoxLabelsAmount = self.BoxLabelsAmount + 1

	thisbox.type = type
	thisbox.index = number

	thisbox.box:SetColorTexture(unpack(color))
	thisbox.text:SetText(name)

	thisbox.check:Show()
	thisbox.button:Show()
	thisbox.border:Hide()
	thisbox.box:Show()
	thisbox.text:Show()

	thisbox.showing = true
	thisbox.enabled = true

	realign_labels(self)
end

local line_default_color = {1, 1, 1}
local draw_overlay = function(self, this_overlay, overlayData, color)

	local pixel = self.Graphic:GetWidth() / self.TimeScale
	local index = 1
	local r, g, b, a = unpack(color or line_default_color)

	for i = 1, #overlayData, 2 do
		local aura_start = overlayData [i]
		local aura_end = overlayData [i+1]

		local this_block = this_overlay [index]
		if (not this_block) then
			this_block = self.Graphic:CreateTexture(nil, "border")
			tinsert(this_overlay, this_block)
		end
		this_block:SetHeight(self.Graphic:GetHeight())

		this_block:SetPoint("left", self.Graphic, "left", pixel * aura_start, 0)
		if (aura_end) then
			this_block:SetWidth((aura_end-aura_start)*pixel)
		else
			--malformed table
			this_block:SetWidth(pixel*5)
		end

		this_block:SetColorTexture(r, g, b, a or 0.25)
		this_block:Show()

		index = index + 1
	end
end

local chart_panel_add_overlay = function(self, overlayData, color, name, icon)
	if (not self.TimeScale) then
		error("Use SetTime (time) before adding an overlay.")
	end

	if (type(overlayData) == "number") then
		local overlay_index = overlayData
		draw_overlay (self, self.Overlays [self.OverlaysAmount], self.OData [overlay_index][1], self.OData [overlay_index][2])
	else
		local this_overlay = self.Overlays [self.OverlaysAmount]
		if (not this_overlay) then
			this_overlay = {}
			tinsert(self.Overlays, this_overlay)
		end

		draw_overlay (self, this_overlay, overlayData, color)

		tinsert(self.OData, {overlayData, color or line_default_color})
		if (name and self.HeaderShowOverlays) then
			self:AddLabel (color or line_default_color, name, "overlay", #self.OData)
		end
	end

	self.OverlaysAmount = self.OverlaysAmount + 1
end

-- Define the tricube weight function
function calc_cubeweight (i, j, d)
    local w = ( 1 - math.abs((j-i)/d)^3)^3
    if w < 0 then
        w = 0
    end
    return w
end

local calc_lowess_smoothing = function(self, data, bandwidth)
	local length = #data
	local newData = {}

	for i = 1, length do
		local A = 0
		local B = 0
		local C = 0
		local D = 0
		local E = 0

		-- Calculate span of values to be included in the regression
		local jmin = floor(i-bandwidth/2)
		local jmax = ceil (i+bandwidth/2)
		if jmin < 1 then
			jmin = 1
		end
		if jmax > length then
			jmax = length
		end

		-- For all the values in the span, compute the weight and then the linear fit

		for j = jmin, jmax do
			w = calc_cubeweight (i, j, bandwidth/2)
			x = j
			y = data [j]

			A = A + w*x
			B = B + w*y
			C = C + w*x^2
			D = D + w*x*y
			E = E + w
		end

		-- Calculate a (slope) and b (offset) for the linear fit
		local a = (A*B-D*E)/(A^2 - C*E)
		local b = (A*D-B*C)/(A^2 - C*E)

		-- Calculate the smoothed value by the formula y=a*x+b (x <- i)
		newData [i] = a*i+b
	end
	return newData
end

local calc_stddev = function(self, data)
	local total = 0
	for i = 1, #data do
		total = total + data[i]
	end
	local mean = total / #data

	local totalDistance = 0
	for i = 1, #data do
		totalDistance = totalDistance + ((data[i] - mean) ^ 2)
	end

	local deviation = math.sqrt (totalDistance / #data)
	return deviation
end

local SMA_table = {}
local SMA_max = 0
local reset_SMA = function()
	table.wipe(SMA_table)
	SMA_max = 0
end

local calc_SMA
calc_SMA = function(a, b, ...)
	if (b) then
		return calc_SMA (a + b, ...)
	else
		return a
	end
end

local do_SMA = function(value, max_value)
	if (#SMA_table == 10) then
		tremove(SMA_table, 1)
	end

	SMA_table [#SMA_table + 1] = value

	local new_value = calc_SMA (unpack(SMA_table)) / #SMA_table

	if (new_value > SMA_max) then
		SMA_max = new_value
		return new_value, SMA_max
	else
		return new_value
	end
end

local chart_panel_onresize = function(self)
	local width, height = self:GetSize()
	local spacement = width - 78 - 60
	spacement = spacement / 16

	for i = 1, 17 do
		local label = self.TimeLabels [i]
		label:SetPoint("bottomleft", self, "bottomleft", 78 + ((i-1)*spacement), self.TimeLabelsHeight)
		label.line:SetHeight(height - 45)
	end

	local spacement = (self.Graphic:GetHeight()) / 8
	for i = 1, 8 do
		self ["dpsamt"..i]:SetPoint("TOPLEFT", self, "TOPLEFT", 27, -25 + (-(spacement* (i-1))) )
		self ["dpsamt"..i].line:SetWidth(width-20)
	end

	self.Graphic:SetSize(width - 135, height - 67)
	self.Graphic:SetPoint("topleft", self, "topleft", 108, -35)
end

local chart_panel_add_data = function(self, graphicData, color, name, elapsedTime, lineTexture, smoothLevel, firstIndex)
	local chartPanel = self --chartPanel from the framework CreateChartPanel
	local LibGraphChartFrame = self.Graphic

	local builtData = {}
	local maxValue = graphicData.max_value
	local scaleWidth = 1 / LibGraphChartFrame:GetWidth()
	local content = graphicData

	--smooth the start and end of the chart
	tinsert(content, 1, 0)
	tinsert(content, 1, 0)
	tinsert(content, #content+1, 0)
	tinsert(content, #content+1, 0)

	local index = 3
	local graphMaxDps = math.max(LibGraphChartFrame.max_value, maxValue)

	--do smoothness progress
	if (not smoothLevel) then
		while (index <= #content-2) do
			local value = (content[index-2] + content[index-1] + content[index] + content[index+1] + content[index+2]) / 5 --normalize
			builtData[#builtData+1] = {scaleWidth * (index-2), value / graphMaxDps} -- x and y coords
			index = index + 1
		end

	elseif (smoothLevel == "SHORT") then
		while (index <= #content-2) do
			local value = (content[index] + content[index+1]) / 2
			builtData [#builtData+1] = {scaleWidth*(index-2), value}
			builtData [#builtData+1] = {scaleWidth*(index-2), value}
			index = index + 2
		end

	elseif (smoothLevel == "SMA") then
		reset_SMA()
		while (index <= #content-2) do
			local value, is_new_max_value = do_SMA(content[index], maxValue)
			if (is_new_max_value) then
				maxValue = is_new_max_value
			end
			builtData [#builtData+1] = {scaleWidth * (index-2), value} -- x and y coords
			index = index + 1
		end

	elseif (smoothLevel == -1) then
		while (index <= #content-2) do
			local current = content[index]

			local minus_2 = content[index-2] * 0.6
			local minus_1 = content[index-1] * 0.8
			local plus_1 = content[index+1] * 0.8
			local plus_2 = content[index+2] * 0.6

			local value = (current + minus_2 + minus_1 + plus_1 + plus_2) / 5 --normalize
			builtData [#builtData+1] = {scaleWidth * (index-2), value / graphMaxDps} -- x and y coords
			index = index + 1
		end

	elseif (smoothLevel == 1) then
		index = 2
		while (index <= #content-1) do
			local value = (content[index-1]+content[index]+content[index+1])/3 --normalize
			builtData [#builtData+1] = {scaleWidth*(index-1), value/graphMaxDps} -- x and y coords
			index = index + 1
		end

	elseif (smoothLevel == 2) then
		index = 1
		while (index <= #content) do
			local value = content[index] --do not normalize
			builtData [#builtData+1] = {scaleWidth*(index), value/graphMaxDps} -- x and y coords
			index = index + 1
		end
	end

	tremove(content, 1)
	tremove(content, 1)
	tremove(content, #graphicData)
	tremove(content, #graphicData)

	if (maxValue > LibGraphChartFrame.max_value) then
		--normalize previous data
		if (LibGraphChartFrame.max_value > 0) then
			local normalizePercent = LibGraphChartFrame.max_value / maxValue
			for dataIndex, Data in ipairs(LibGraphChartFrame.Data) do
				local Points = Data.Points
				for i = 1, #Points do
					Points[i][2] = Points[i][2] * normalizePercent
				end
			end
		end

		LibGraphChartFrame.max_value = maxValue
		chartPanel:SetScale(maxValue)
	end

	tinsert(chartPanel.GData, {builtData, color or line_default_color, lineTexture, maxValue, elapsedTime})
	if (name) then
		chartPanel:AddLabel(color or line_default_color, name, "graphic", #chartPanel.GData)
	end

	local newLineTexture = "Interface\\AddOns\\Details\\Libs\\LibGraph-2.0\\line"

	if (firstIndex) then
		table.insert(LibGraphChartFrame.Data, 1, {Points = builtData, Color = color or line_default_color, lineTexture = newLineTexture, ElapsedTime = elapsedTime})
		LibGraphChartFrame.NeedsUpdate = true
	else
		LibGraphChartFrame:AddDataSeries(builtData, color or line_default_color, nil, newLineTexture)
		LibGraphChartFrame.Data[#LibGraphChartFrame.Data].ElapsedTime = elapsedTime
	end

	local maxTime = 0
	for _, data in ipairs(LibGraphChartFrame.Data) do
		if (data.ElapsedTime > maxTime) then
			maxTime = data.ElapsedTime
		end
	end

	chartPanel:SetTime(maxTime)
	chart_panel_onresize(chartPanel)
end


local chart_panel_vlines_on = function(self)
	for i = 1, 17 do
		local label = self.TimeLabels[i]
		label.line:Show()
	end
end

local chart_panel_vlines_off = function(self)
	for i = 1, 17 do
		local label = self.TimeLabels[i]
		label.line:Hide()
	end
end

local chart_panel_set_title = function(self, title)
	self.chart_title.text = title
end

local chart_panel_mousedown = function(self, button)
	if (button == "LeftButton" and self.can_move) then
		if (not self.isMoving) then
			self:StartMoving()
			self.isMoving = true
		end
	elseif (button == "RightButton" and not self.no_right_click_close) then
		if (not self.isMoving) then
			self:Hide()
		end
	end
end

local chart_panel_mouseup = function(self, button)
	if (button == "LeftButton" and self.isMoving) then
		self:StopMovingOrSizing()
		self.isMoving = nil
	end
end

local chart_panel_hide_close_button = function(self)
	self.CloseButton:Hide()
end

local chart_panel_right_click_close = function(self, value)
	if (type(value) == "boolean") then
		if (value) then
			self.no_right_click_close = nil
		else
			self.no_right_click_close = true
		end
	end
end

function detailsFramework:CreateChartPanel(parent, width, height, name)
	if (not name) then
		name = "DFPanel" .. detailsFramework.PanelCounter
		detailsFramework.PanelCounter = detailsFramework.PanelCounter + 1
	end

	parent = parent or UIParent
	width = width or 800
	height = height or 500

	local chartFrame = CreateFrame("frame", name, parent, "BackdropTemplate")
	chartFrame:SetSize(width or 500, height or 400)
	chartFrame:EnableMouse(true)
	chartFrame:SetMovable(true)

	chartFrame:SetScript("OnMouseDown", chart_panel_mousedown)
	chartFrame:SetScript("OnMouseUp", chart_panel_mouseup)

	chartFrame:SetBackdrop(chart_panel_backdrop)
	chartFrame:SetBackdropColor(.3, .3, .3, .3)

	local closeButton = CreateFrame("Button", nil, chartFrame, "UIPanelCloseButton", "BackdropTemplate")
	closeButton:SetWidth(32)
	closeButton:SetHeight(32)
	closeButton:SetPoint("TOPRIGHT",  chartFrame, "TOPRIGHT", -3, -7)
	closeButton:SetFrameLevel(chartFrame:GetFrameLevel()+1)
	closeButton:SetAlpha(0.9)
	chartFrame.CloseButton = closeButton

	local title = detailsFramework:NewLabel(chartFrame, nil, "$parentTitle", "chart_title", "Chart!", nil, 20, {1, 1, 0})
	title:SetPoint("topleft", chartFrame, "topleft", 110, -13)

	chartFrame.Overlays = {}
	chartFrame.OverlaysAmount = 1

	chartFrame.BoxLabels = {}
	chartFrame.BoxLabelsAmount = 1

	chartFrame.ShowHeader = true
	chartFrame.HeaderOnlyIndicator = false
	chartFrame.HeaderShowOverlays = true

	--graphic
		local g = LibStub:GetLibrary("LibGraph-2.0"):CreateGraphLine (name .. "Graphic", chartFrame, "topleft","topleft", 108, -35, width - 120, height - 67)
		g:SetXAxis (-1,1)
		g:SetYAxis (-1,1)
		g:SetGridSpacing (false, false)
		g:SetGridColor ({0.5,0.5,0.5,0.3})
		g:SetAxisDrawing (false,false)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetAutoScale (true)
		g:SetLineTexture ("smallline")
		g:SetBorderSize ("right", 0.001)
		g:SetBorderSize ("left", 0.000)
		g:SetBorderSize ("top", 0.002)
		g:SetBorderSize ("bottom", 0.001)
		g.VerticalLines = {}
		g.max_value = 0

		g:SetLineTexture ("line")

		chartFrame.Graphic = g
		chartFrame.GData = {}
		chartFrame.OData = {}
		chartFrame.ChartFrames = {}

	--div lines
		for i = 1, 8, 1 do
			local line = g:CreateTexture(nil, "overlay")
			line:SetColorTexture(1, 1, 1, .05)
			line:SetWidth(670)
			line:SetHeight(1.1)

			local s = chartFrame:CreateFontString(nil, "overlay", "GameFontHighlightSmall")
			chartFrame ["dpsamt"..i] = s
			s:SetText("100k")
			s:SetPoint("topleft", chartFrame, "topleft", 27, -61 + (-(24.6*i)))

			line:SetPoint("topleft", s, "bottom", -27, 0)
			line:SetPoint("topright", g, "right", 0, 0)
			s.line = line
		end

	--create time labels and the bottom texture to use as a background to these labels
		chartFrame.TimeLabels = {}
		chartFrame.TimeLabelsHeight = 16

		for i = 1, 17 do
			local timeString = chartFrame:CreateFontString(nil, "overlay", "GameFontHighlightSmall")
			timeString:SetText("00:00")
			timeString:SetPoint("bottomleft", chartFrame, "bottomleft", 78 + ((i-1)*36), chartFrame.TimeLabelsHeight)
			chartFrame.TimeLabels [i] = timeString

			local line = chartFrame:CreateTexture(nil, "border")
			line:SetSize(1, height-45)
			line:SetColorTexture(1, 1, 1, .1)
			line:SetPoint("bottomleft", timeString, "topright", 0, -10)
			line:Hide()
			timeString.line = line
		end

		local bottom_texture = detailsFramework:NewImage(chartFrame, nil, 702, 25, "background", nil, nil, "$parentBottomTexture")
		bottom_texture:SetColorTexture(.1, .1, .1, .7)
		bottom_texture:SetPoint("topright", g, "bottomright", 0, 0)
		bottom_texture:SetPoint("bottomleft", chartFrame, "bottomleft", 8, 12)



	chartFrame.SetTime = chart_panel_align_timelabels
	chartFrame.EnableVerticalLines = chart_panel_vlines_on
	chartFrame.DisableVerticalLines = chart_panel_vlines_off
	chartFrame.SetTitle = chart_panel_set_title
	chartFrame.SetScale = chart_panel_set_scale
	chartFrame.Reset = chart_panel_reset
	chartFrame.AddLine = chart_panel_add_data
	chartFrame.CanMove = chart_panel_can_move
	chartFrame.AddLabel = chart_panel_add_label
	chartFrame.AddOverlay = chart_panel_add_overlay
	chartFrame.HideCloseButton = chart_panel_hide_close_button
	chartFrame.RightClickClose = chart_panel_right_click_close
	chartFrame.CalcStdDev = calc_stddev
	chartFrame.CalcLowessSmoothing = calc_lowess_smoothing

	chartFrame:SetScript("OnSizeChanged", chart_panel_onresize)
	chart_panel_onresize(chartFrame)

	return chartFrame
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~gframe
local gframe_on_enter_line = function(self)
	self:SetBackdropColor(0, 0, 0, 0)

	local parent = self:GetParent()
	local ball = self.ball
	ball:SetBlendMode("ADD")

	local on_enter = parent._onenter_line
	if (on_enter) then
		return on_enter (self, parent)
	end
end

local gframe_on_leave_line = function(self)
	self:SetBackdropColor(0, 0, 0, .6)

	local parent = self:GetParent()
	local ball = self.ball
	ball:SetBlendMode("BLEND")

	local on_leave = parent._onleave_line
	if (on_leave) then
		return on_leave (self, parent)
	end
end

local gframe_create_line = function(self)
	local index = #self._lines+1

	local f = CreateFrame("frame", nil, self, "BackdropTemplate")
	self._lines [index] = f
	f.id = index
	f:SetScript("OnEnter", gframe_on_enter_line)
	f:SetScript("OnLeave", gframe_on_leave_line)

	f:SetWidth(self._linewidth)

	if (index == 1) then
		f:SetPoint("topleft", self, "topleft")
		f:SetPoint("bottomleft", self, "bottomleft")
	else
		local previous_line = self._lines [index-1]
		f:SetPoint("topleft", previous_line, "topright")
		f:SetPoint("bottomleft", previous_line, "bottomright")
	end

	local t = f:CreateTexture(nil, "background")
	t:SetWidth(1)
	t:SetPoint("topright", f, "topright")
	t:SetPoint("bottomright", f, "bottomright")
	t:SetColorTexture(1, 1, 1, .1)
	f.grid = t

	local b = f:CreateTexture(nil, "overlay")
	b:SetTexture([[Interface\COMMON\Indicator-Yellow]])
	b:SetSize(16, 16)
	f.ball = b
	local anchor = CreateFrame("frame", nil, f, "BackdropTemplate")
	anchor:SetAllPoints(b)
	b.tooltip_anchor = anchor

	local spellicon = f:CreateTexture(nil, "artwork")
	spellicon:SetPoint("bottom", b, "bottom", 0, 10)
	spellicon:SetSize(16, 16)
	f.spellicon = spellicon

	local text = f:CreateFontString(nil, "overlay", "GameFontNormal")
	local textBackground = f:CreateTexture(nil, "artwork")
	textBackground:SetSize(30, 16)
	textBackground:SetColorTexture(0, 0, 0, 0.5)
	textBackground:SetPoint("bottom", f.ball, "top", 0, -6)
	text:SetPoint("center", textBackground, "center")
	detailsFramework:SetFontSize(text, 10)
	f.text = text
	f.textBackground = textBackground

	local timeline = f:CreateFontString(nil, "overlay", "GameFontNormal")
	timeline:SetPoint("bottomright", f, "bottomright", -2, 0)
	detailsFramework:SetFontSize(timeline, 8)
	f.timeline = timeline

	return f
end

local gframe_getline = function(self, index)
	local line = self._lines [index]
	if (not line) then
		line = gframe_create_line (self)
	end
	return line
end

local gframe_reset = function(self)
	for i, line in ipairs(self._lines) do
		line:Hide()
	end
	if (self.GraphLib_Lines_Used) then
		for i = #self.GraphLib_Lines_Used, 1, -1 do
			local line = tremove(self.GraphLib_Lines_Used)
			tinsert(self.GraphLib_Lines, line)
			line:Hide()
		end
	end
end

local gframe_update = function(self, lines)
	local g = LibStub:GetLibrary ("LibGraph-2.0")
	local h = self:GetHeight()/100
	local amtlines = #lines
	local linewidth = self._linewidth

	local max_value = 0
	for i = 1, amtlines do
		if (lines [i].value > max_value) then
			max_value = lines [i].value
		end
	end

	self.MaxValue = max_value

	local o = 1
	local lastvalue = self:GetHeight()/2
	max_value = math.max(max_value, 0.0000001)

	for i = 1, min (amtlines, self._maxlines) do

		local data = lines [i]

		local pvalue = data.value / max_value * 100
		if (pvalue > 98) then
			pvalue = 98
		end
		pvalue = pvalue * h

		g:DrawLine (self, (o-1)*linewidth, lastvalue, o*linewidth, pvalue, linewidth, {1, 1, 1, 1}, "overlay")
		lastvalue = pvalue

		local line = self:GetLine (i)
		line:Show()
		line.ball:Show()

		line.ball:SetPoint("bottomleft", self, "bottomleft", (o*linewidth)-8, pvalue-8)
		line.spellicon:SetTexture(nil)
		line.timeline:SetText(data.text)
		line.timeline:Show()

		if (data.utext) then
			line.text:Show()
			line.textBackground:Show()
			line.text:SetText(data.utext)
		else
			line.text:Hide()
			line.textBackground:Hide()
		end

		line.data = data

		o = o + 1
	end
end

function detailsFramework:CreateGFrame(parent, width, height, lineWidth, onEnter, onLeave, member, name)
	local newGraphicFrame = CreateFrame("frame", name, parent, "BackdropTemplate")
	newGraphicFrame:SetSize(width or 450, height or 150)

	if (member) then
		parent[member] = newGraphicFrame
	end

	newGraphicFrame.CreateLine = gframe_create_line
	newGraphicFrame.GetLine = gframe_getline
	newGraphicFrame.Reset = gframe_reset
	newGraphicFrame.UpdateLines = gframe_update

	newGraphicFrame.MaxValue = 0

	newGraphicFrame._lines = {}

	newGraphicFrame._onenter_line = onEnter
	newGraphicFrame._onleave_line = onLeave

	newGraphicFrame._linewidth = lineWidth or 50
	newGraphicFrame._maxlines = floor(newGraphicFrame:GetWidth() / newGraphicFrame._linewidth)

	return newGraphicFrame
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--options tabs and buttons -dot

function detailsFramework:FindHighestParent(self)
	local highestParent
	if (self:GetParent() == UIParent) then
		highestParent = self
	end

	if (not highestParent) then
		highestParent = self
		for i = 1, 6 do
			local parent = highestParent:GetParent()
			if (parent == UIParent) then
				break
			else
				highestParent = parent
			end
		end
	end

	return highestParent
end

detailsFramework.TabContainerFunctions = {}

local button_tab_template = detailsFramework.table.copy({}, detailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"))
button_tab_template.backdropbordercolor = nil

detailsFramework.TabContainerFunctions.CreateUnderlineGlow = function(button)
	local selectedGlow = button:CreateTexture(nil, "background", nil, -4)
	selectedGlow:SetPoint("topleft", button.widget, "bottomleft", -7, 0)
	selectedGlow:SetPoint("topright", button.widget, "bottomright", 7, 0)
	selectedGlow:SetTexture([[Interface\BUTTONS\UI-Panel-Button-Glow]])
	selectedGlow:SetTexCoord(0, 95/128, 30/64, 38/64)
	selectedGlow:SetBlendMode("ADD")
	selectedGlow:SetHeight(8)
	selectedGlow:SetAlpha(.75)
	selectedGlow:Hide()
	button.selectedUnderlineGlow = selectedGlow
end

detailsFramework.TabContainerFunctions.OnMouseDown = function(self, button)
	--search for UIParent
	local f = detailsFramework:FindHighestParent (self)
	local container = self:GetParent()

	if (button == "LeftButton") then
		if (not f.IsMoving and f:IsMovable()) then
			f:StartMoving()
			f.IsMoving = true
		end
	elseif (button == "RightButton") then
		if (not f.IsMoving and container.IsContainer) then
			if (self.IsFrontPage) then
				if (container.CanCloseWithRightClick) then
					if (f.CloseFunction) then
						f:CloseFunction()
					else
						f:Hide()
					end
				end
			else
				--goes back to front page
				detailsFramework.TabContainerFunctions.SelectIndex (self, _, 1)
			end
		end
	end
end

detailsFramework.TabContainerFunctions.OnMouseUp = function(self, button)
	local f = detailsFramework:FindHighestParent (self)
	if (f.IsMoving) then
		f:StopMovingOrSizing()
		f.IsMoving = false
	end
end

detailsFramework.TabContainerFunctions.SelectIndex = function(self, fixedParam, menuIndex)
	local mainFrame = self.AllFrames and self or self.mainFrame or self:GetParent()

	for i = 1, #mainFrame.AllFrames do
		mainFrame.AllFrames[i]:Hide()
		if (mainFrame.ButtonNotSelectedBorderColor) then
			mainFrame.AllButtons[i]:SetBackdropBorderColor(unpack(mainFrame.ButtonNotSelectedBorderColor))
		end
		if (mainFrame.AllButtons[i].selectedUnderlineGlow) then
			mainFrame.AllButtons[i].selectedUnderlineGlow:Hide()
		end
	end

	mainFrame.AllFrames[menuIndex]:Show()
	if mainFrame.AllFrames[menuIndex].RefreshOptions then
		mainFrame.AllFrames[menuIndex]:RefreshOptions()
	end
	if (mainFrame.ButtonSelectedBorderColor) then
		mainFrame.AllButtons[menuIndex]:SetBackdropBorderColor(unpack(mainFrame.ButtonSelectedBorderColor))
	end
	if (mainFrame.AllButtons[menuIndex].selectedUnderlineGlow) then
		mainFrame.AllButtons[menuIndex].selectedUnderlineGlow:Show()
	end
	mainFrame.CurrentIndex = menuIndex

	if (mainFrame.hookList.OnSelectIndex) then
		detailsFramework:QuickDispatch(mainFrame.hookList.OnSelectIndex, mainFrame, mainFrame.AllButtons[menuIndex])
	end
end

detailsFramework.TabContainerFunctions.SetIndex = function(self, index)
	self.CurrentIndex = index
end

local tab_container_on_show = function(self)
	local index = self.CurrentIndex
	self.SelectIndex (self.AllButtons[index], nil, index)
end

function detailsFramework:CreateTabContainer (parent, title, frame_name, frameList, options_table, hookList)
	local options_text_template = detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = detailsFramework:GetTemplate("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = detailsFramework:GetTemplate("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = detailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")

	options_table = options_table or {}
	local parentFrameWidth = parent:GetWidth()
	local y_offset = options_table.y_offset or 0
	local buttonWidth = options_table.button_width or 160
	local buttonHeight = options_table.button_height or 20
	local buttonAnchorX = options_table.button_x or 230
	local buttonAnchorY = options_table.button_y or -32
	local button_text_size = options_table.button_text_size or 10
	local containerWidthOffset = options_table.container_width_offset or 0

	local mainFrame = CreateFrame("frame", frame_name, parent.widget or parent, "BackdropTemplate")
	mainFrame:SetAllPoints()
	detailsFramework:Mixin(mainFrame, detailsFramework.TabContainerFunctions)
	mainFrame.hookList = hookList or {}

	local mainTitle = detailsFramework:CreateLabel(mainFrame, title, 24, "white")
	mainTitle:SetPoint("topleft", mainFrame, "topleft", 10, -30 + y_offset)

	mainFrame:SetFrameLevel(200)

	mainFrame.AllFrames = {}
	mainFrame.AllButtons = {}
	mainFrame.CurrentIndex = 1
	mainFrame.IsContainer = true
	mainFrame.ButtonSelectedBorderColor = options_table.button_selected_border_color or {1, 1, 0, 1}
	mainFrame.ButtonNotSelectedBorderColor = options_table.button_border_color or {0, 0, 0, 0}

	if (options_table.right_click_interact ~= nil) then
		mainFrame.CanCloseWithRightClick = options_table.right_click_interact
	else
		mainFrame.CanCloseWithRightClick = true
	end

	for i, frame in ipairs(frameList) do
		local f = CreateFrame("frame", "$parent" .. frame.name, mainFrame, "BackdropTemplate")
		f:SetAllPoints()
		f:SetFrameLevel(210)
		f:Hide()

		local title = detailsFramework:CreateLabel(f, frame.title, 16, "silver")
		title:SetPoint("topleft", mainTitle, "bottomleft", 0, 0)
		f.titleText = title

		local tabButton = detailsFramework:CreateButton(mainFrame, detailsFramework.TabContainerFunctions.SelectIndex, buttonWidth, buttonHeight, frame.title, i, nil, nil, nil, "$parentTabButton" .. frame.name, false, button_tab_template)
		PixelUtil.SetSize(tabButton, buttonWidth, buttonHeight)
		tabButton:SetFrameLevel(220)
		tabButton.textsize = button_text_size
		tabButton.mainFrame = mainFrame
		detailsFramework.TabContainerFunctions.CreateUnderlineGlow (tabButton)

		local right_click_to_back
		if (i == 1 or options_table.rightbutton_always_close) then
			right_click_to_back = detailsFramework:CreateLabel(f, "right click to close", 10, "gray")
			right_click_to_back:SetPoint("bottomright", f, "bottomright", -1, options_table.right_click_y or 0)
			if (options_table.close_text_alpha) then
				right_click_to_back:SetAlpha(options_table.close_text_alpha)
			end
			f.IsFrontPage = true
		else
			right_click_to_back = detailsFramework:CreateLabel(f, "right click to go back to main menu", 10, "gray")
			right_click_to_back:SetPoint("bottomright", f, "bottomright", -1, options_table.right_click_y or 0)
			if (options_table.close_text_alpha) then
				right_click_to_back:SetAlpha(options_table.close_text_alpha)
			end
		end

		if (options_table.hide_click_label) then
			right_click_to_back:Hide()
		end

		f:SetScript("OnMouseDown", detailsFramework.TabContainerFunctions.OnMouseDown)
		f:SetScript("OnMouseUp", detailsFramework.TabContainerFunctions.OnMouseUp)

		tinsert(mainFrame.AllFrames, f)
		tinsert(mainFrame.AllButtons, tabButton)
	end

	--order buttons
	local x = buttonAnchorX
	local y = buttonAnchorY
	local spaceBetweenButtons = 3

	local allocatedSpaceForButtons = parentFrameWidth - ((#frameList - 2) * spaceBetweenButtons) - buttonAnchorX + containerWidthOffset
	local amountButtonsPerRow = floor(allocatedSpaceForButtons / buttonWidth)

	mainFrame.AllButtons[1]:SetPoint("topleft", mainTitle, "topleft", x, y)
	x = x + buttonWidth + 2

	for i = 2, #mainFrame.AllButtons do
		local button = mainFrame.AllButtons[i]
		PixelUtil.SetPoint(button, "topleft", mainTitle, "topleft", x, y)
		x = x + buttonWidth + 2

		if (i % amountButtonsPerRow == 0) then
			x = buttonAnchorX
			y = y - buttonHeight - 1
		end
	end

	--when show the frame, reset to the current internal index
	mainFrame:SetScript("OnShow", tab_container_on_show)
	--select the first frame
	mainFrame.SelectIndex (mainFrame.AllButtons[1], nil, 1)

	return mainFrame
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~right ~click to ~close

function detailsFramework:CreateRightClickToClose(parent, xOffset, yOffset, color, fontSize)
	--default values
	xOffset = xOffset or 0
	yOffset = yOffset or 0
	color = color or "white"
	fontSize = fontSize or 10

	local label = detailsFramework:CreateLabel(parent, "right click to close", fontSize, color)
	label:SetPoint("bottomright", parent, "bottomright", -4 + xOffset, 5 + yOffset)

	return label
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~listbox

local simple_list_box_ResetWidgets = function(self)
	for _, widget in ipairs(self.widgets) do
		widget:Hide()
	end
	self.nextWidget = 1
end

local simple_list_box_onenter = function(self, capsule)
	self:GetParent().options.onenter (self, capsule, capsule.value)
end

local simple_list_box_onleave = function(self, capsule)
	self:GetParent().options.onleave (self, capsule, capsule.value)
	GameTooltip:Hide()
end

local simple_list_box_GetOrCreateWidget = function(self)
	local index = self.nextWidget
	local widget = self.widgets [index]
	if (not widget) then
		widget = detailsFramework:CreateButton(self, function()end, self.options.width, self.options.row_height, "", nil, nil, nil, nil, nil, nil, detailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"))
		widget:SetHook("OnEnter", simple_list_box_onenter)
		widget:SetHook("OnLeave", simple_list_box_onleave)
		widget.textcolor = self.options.textcolor
		widget.textsize = self.options.text_size
		widget.onleave_backdrop = self.options.backdrop_color

		widget.XButton = detailsFramework:CreateButton(widget, function()end, 16, 16)
		widget.XButton:SetPoint("topright", widget.widget, "topright")
		widget.XButton:SetIcon ([[Interface\BUTTONS\UI-Panel-MinimizeButton-Up]], 16, 16, "overlay", nil, nil, 0, -4, 0, false)
		widget.XButton.icon:SetDesaturated(true)

		if (not self.options.show_x_button) then
			widget.XButton:Hide()
		end

		tinsert(self.widgets, widget)
	end
	self.nextWidget = self.nextWidget + 1
	return widget
end

local simple_list_box_RefreshWidgets = function(self)
	self:ResetWidgets()
	local amt = 0
	for value, _ in pairs(self.list_table) do
		local widget = self:GetOrCreateWidget()
		widget:SetPoint("topleft", self, "topleft", 1, -self.options.row_height * (self.nextWidget-2) - 4)
		widget:SetPoint("topright", self, "topright", -1, -self.options.row_height * (self.nextWidget-2) - 4)

		widget:SetClickFunction(self.func, value)

		if (self.options.show_x_button) then
			widget.XButton:SetClickFunction(self.options.x_button_func, value)
			widget.XButton.value = value
			widget.XButton:Show()
		else
			widget.XButton:Hide()
		end

		widget.value = value

		if (self.options.icon) then
			if (type(self.options.icon) == "string" or type(self.options.icon) == "number") then
				local coords = type(self.options.iconcoords) == "table" and self.options.iconcoords or {0, 1, 0, 1}
				widget:SetIcon (self.options.icon, self.options.row_height - 2, self.options.row_height - 2, "overlay", coords)

			elseif (type(self.options.icon) == "function") then
				local icon = self.options.icon (value)
				if (icon) then
					local coords = type(self.options.iconcoords) == "table" and self.options.iconcoords or {0, 1, 0, 1}
					widget:SetIcon (icon, self.options.row_height - 2, self.options.row_height - 2, "overlay", coords)
				end
			end
		else
			widget:SetIcon ("", self.options.row_height, self.options.row_height)
		end

		if (self.options.text) then
			if (type(self.options.text) == "function") then
				local text = self.options.text (value)
				if (text) then
					widget:SetText(text)
				else
					widget:SetText("")
				end
			else
				widget:SetText(self.options.text or "")
			end
		else
			widget:SetText("")
		end

		widget.value = value

		local r, g, b, a = detailsFramework:ParseColors(self.options.backdrop_color)
		widget:SetBackdropColor(r, g, b, a)

		widget:Show()
		amt = amt + 1
	end
	if (amt == 0) then
		self.EmptyLabel:Show()
	else
		self.EmptyLabel:Hide()
	end
end

local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1}
local default_options = {
	height = 400,
	row_height = 16,
	width = 230,
	icon = false,
	text = "",
	text_size = 10,
	textcolor = "wheat",

	backdrop_color = {1, 1, 1, .5},
	panel_border_color = {0, 0, 0, 0.5},

	onenter = function(self, capsule)
		if (capsule) then
			capsule.textcolor = "white"
		end
	end,
	onleave = function(self, capsule)
		if (capsule) then
			capsule.textcolor = self:GetParent().options.textcolor
		end
		GameTooltip:Hide()
	end,
}

local simple_list_box_SetData = function(self, t)
	self.list_table = t
end

function detailsFramework:CreateSimpleListBox (parent, name, title, empty_text, list_table, onclick, options)
	local f = CreateFrame("frame", name, parent, "BackdropTemplate")

	f.ResetWidgets = simple_list_box_ResetWidgets
	f.GetOrCreateWidget = simple_list_box_GetOrCreateWidget
	f.Refresh = simple_list_box_RefreshWidgets
	f.SetData = simple_list_box_SetData
	f.nextWidget = 1
	f.list_table = list_table
	f.func = function(self, button, value)
		--onclick (value)
		detailsFramework:QuickDispatch(onclick, value)
		f:Refresh()
	end
	f.widgets = {}

	detailsFramework:ApplyStandardBackdrop(f)

	f.options = options or {}
	self.table.deploy(f.options, default_options)

	if (f.options.x_button_func) then
		local original_X_function = f.options.x_button_func
		f.options.x_button_func = function(self, button, value)
			detailsFramework:QuickDispatch(original_X_function, value)
			f:Refresh()
		end
	end

	f:SetBackdropBorderColor(unpack(f.options.panel_border_color))

	f:SetSize(f.options.width + 2, f.options.height)

	local name = detailsFramework:CreateLabel(f, title, 12, "silver")
	name:SetTemplate(detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE"))
	name:SetPoint("bottomleft", f, "topleft", 0, 2)
	f.Title = name

	local emptyLabel = detailsFramework:CreateLabel(f, empty_text, 12, "gray")
	emptyLabel:SetAlpha(.6)
	emptyLabel:SetSize(f.options.width-10, f.options.height)
	emptyLabel:SetPoint("center", 0, 0)
	emptyLabel:Hide()
	emptyLabel.align = "center"
	f.EmptyLabel = emptyLabel

	return f
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~scrollbox

function detailsFramework:CreateScrollBox (parent, name, refreshFunc, data, width, height, lineAmount, lineHeight, createLineFunc, autoAmount, noScroll)
	local scroll = CreateFrame("scrollframe", name, parent, "FauxScrollFrameTemplate, BackdropTemplate")

	detailsFramework:ApplyStandardBackdrop(scroll)

	scroll:SetSize(width, height)
	scroll.LineAmount = lineAmount
	scroll.LineHeight = lineHeight
	scroll.IsFauxScroll = true
	scroll.HideScrollBar = noScroll
	scroll.Frames = {}
	scroll.ReajustNumFrames = autoAmount
	scroll.CreateLineFunc = createLineFunc

	detailsFramework:Mixin(scroll, detailsFramework.SortFunctions)
	detailsFramework:Mixin(scroll, detailsFramework.ScrollBoxFunctions)

	scroll.refresh_func = refreshFunc
	scroll.data = data

	scroll:SetScript("OnVerticalScroll", scroll.OnVerticalScroll)
	scroll:SetScript("OnSizeChanged", detailsFramework.ScrollBoxFunctions.OnSizeChanged)

	return scroll
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~resizers

function detailsFramework:CreateResizeGrips (parent)
	if (parent) then
		local parentName = parent:GetName()

		local leftResizer = CreateFrame("button", parentName and parentName .. "LeftResizer" or nil, parent, "BackdropTemplate")
		local rightResizer = CreateFrame("button", parentName and parentName .. "RightResizer" or nil, parent, "BackdropTemplate")

		leftResizer:SetPoint("bottomleft", parent, "bottomleft")
		rightResizer:SetPoint("bottomright", parent, "bottomright")
		leftResizer:SetSize(16, 16)
		rightResizer:SetSize(16, 16)

		rightResizer:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]])
		rightResizer:SetHighlightTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]])
		rightResizer:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]])
		leftResizer:SetNormalTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]])
		leftResizer:SetHighlightTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]])
		leftResizer:SetPushedTexture([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]])

		leftResizer:GetNormalTexture():SetTexCoord(1, 0, 0, 1)
		leftResizer:GetHighlightTexture():SetTexCoord(1, 0, 0, 1)
		leftResizer:GetPushedTexture():SetTexCoord(1, 0, 0, 1)

		return leftResizer, rightResizer
	end
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~keybind


--------------------------------
--keybind frame ~key


local ignoredKeys = {
	["LSHIFT"] = true,
	["RSHIFT"] = true,
	["LCTRL"] = true,
	["RCTRL"] = true,
	["LALT"] = true,
	["RALT"] = true,
	["UNKNOWN"] = true,
}

local mouseKeys = {
	["LeftButton"] = "type1",
	["RightButton"] = "type2",
	["MiddleButton"] = "type3",
	["Button4"] = "type4",
	["Button5"] = "type5",
	["Button6"] = "type6",
	["Button7"] = "type7",
	["Button8"] = "type8",
	["Button9"] = "type9",
	["Button10"] = "type10",
	["Button11"] = "type11",
	["Button12"] = "type12",
	["Button13"] = "type13",
	["Button14"] = "type14",
	["Button15"] = "type15",
	["Button16"] = "type16",
}

local keysToMouse = {
	["type1"] = "LeftButton",
	["type2"] = "RightButton",
	["type3"] = "MiddleButton",
	["type4"] = "Button4",
	["type5"] = "Button5",
	["type6"] = "Button6",
	["type7"] = "Button7",
	["type8"] = "Button8",
	["type9"] = "Button9",
	["type10"] = "Button10",
	["type11"] = "Button11",
	["type12"] = "Button12",
	["type13"] = "Button13",
	["type14"] = "Button14",
	["type15"] = "Button15",
	["type16"] = "Button16",
}

local keybind_set_data = function(self, new_data_table)
	self.Data = new_data_table
	self.keybindScroll:UpdateScroll()
end

function detailsFramework:CreateKeybindBox (parent, name, data, callback, width, height, line_amount, line_height)

	local options_text_template = detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = detailsFramework:GetTemplate("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = detailsFramework:GetTemplate("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = detailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")

	local SCROLL_ROLL_AMOUNT = line_amount

	--keybind set frame
	local new_keybind_frame = CreateFrame("frame", name, parent, "BackdropTemplate")
	new_keybind_frame:SetSize(width, height)

	-- keybind scrollframe
	local keybindScroll = CreateFrame("scrollframe", "$parentScrollFrame", new_keybind_frame, "FauxScrollFrameTemplate, BackdropTemplate")
	keybindScroll:SetSize(1019, 348)
	keybindScroll.Frames = {}
	new_keybind_frame.keybindScroll = keybindScroll

	--waiting the player to press a key
	new_keybind_frame.IsListening = false

	--check for valid data table
	if (type(data) ~= "table") then
		print("error: data must be a table. DF > CreateKeybindBox()")
		return
	end

	if (not next (data)) then
		--build data table for the character class
		local _, unitClass = UnitClass("player")
		if (unitClass) then
			local specIds = detailsFramework:GetClassSpecIDs(unitClass)
			if (specIds) then
				for _, specId in ipairs(specIds) do
					data [specId] = {}
				end
			end
		end
	end

	new_keybind_frame.Data = data
	new_keybind_frame.SetData = keybind_set_data

	new_keybind_frame.EditingSpec = detailsFramework:GetCurrentSpec()
	new_keybind_frame.CurrentKeybindEditingSet = new_keybind_frame.Data [new_keybind_frame.EditingSpec]

	local allSpecButtons = {}
	local switch_spec = function(self, button, specID)
		new_keybind_frame.EditingSpec = specID
		new_keybind_frame.CurrentKeybindEditingSet = new_keybind_frame.Data [specID]

		for _, button in ipairs(allSpecButtons) do
			button.selectedTexture:Hide()
		end
		self.MyObject.selectedTexture:Show()

		--feedback ao jogador uma vez que as keybinds podem ter o mesmo valor
		C_Timer.After(.04, function() new_keybind_frame:Hide() end)
		C_Timer.After(.06, function() new_keybind_frame:Show() end)

		--atualiza a scroll
		keybindScroll:UpdateScroll()
	end

	--choose which spec to use
	local spec1 = detailsFramework:CreateButton(new_keybind_frame, switch_spec, 160, 20, "Spec1 Placeholder Text", 1, _, _, "SpecButton1", _, 0, options_button_template, options_text_template)
	local spec2 = detailsFramework:CreateButton(new_keybind_frame, switch_spec, 160, 20, "Spec2 Placeholder Text", 1, _, _, "SpecButton2", _, 0, options_button_template, options_text_template)
	local spec3 = detailsFramework:CreateButton(new_keybind_frame, switch_spec, 160, 20, "Spec3 Placeholder Text", 1, _, _, "SpecButton3", _, 0, options_button_template, options_text_template)
	local spec4 = detailsFramework:CreateButton(new_keybind_frame, switch_spec, 160, 20, "Spec4 Placeholder Text", 1, _, _, "SpecButton4", _, 0, options_button_template, options_text_template)

	--format the button label and icon with the spec information
	local className, class = UnitClass("player")
	local i = 1
	local specIds = detailsFramework:GetClassSpecIDs(class)

	for index, specId in ipairs(specIds) do
		local button = new_keybind_frame ["SpecButton" .. index]
		local spec_id, spec_name, spec_description, spec_icon, spec_background, spec_role, spec_class = DetailsFramework.GetSpecializationInfoByID (specId)
		button.text = spec_name
		button:SetClickFunction(switch_spec, specId)
		button:SetIcon (spec_icon)
		button.specID = specId

		local selectedTexture = button:CreateTexture(nil, "background")
		selectedTexture:SetAllPoints()
		selectedTexture:SetColorTexture(1, 1, 1, 0.5)
		if (specId ~= new_keybind_frame.EditingSpec) then
			selectedTexture:Hide()
		end
		button.selectedTexture = selectedTexture

		tinsert(allSpecButtons, button)
		i = i + 1
	end

	local specsTitle = detailsFramework:CreateLabel(new_keybind_frame, "Config keys for spec:", 12, "silver")
	specsTitle:SetPoint("topleft", new_keybind_frame, "topleft", 10, mainStartY)

	keybindScroll:SetPoint("topleft", specsTitle.widget, "bottomleft", 0, -120)

	spec1:SetPoint("topleft", specsTitle, "bottomleft", 0, -10)
	spec2:SetPoint("topleft", specsTitle, "bottomleft", 0, -30)
	spec3:SetPoint("topleft", specsTitle, "bottomleft", 0, -50)
	if (class == "DRUID") then
		spec4:SetPoint("topleft", specsTitle, "bottomleft", 0, -70)
	end

	local enter_the_key = CreateFrame("frame", nil, new_keybind_frame, "BackdropTemplate")
	enter_the_key:SetFrameStrata("tooltip")
	enter_the_key:SetSize(200, 60)
	enter_the_key:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
	enter_the_key:SetBackdropColor(0, 0, 0, 1)
	enter_the_key:SetBackdropBorderColor(1, 1, 1, 1)
	enter_the_key.text = detailsFramework:CreateLabel(enter_the_key, "- Press a keyboard key to bind.\n- Click to bind a mouse button.\n- Press escape to cancel.", 11, "orange")
	enter_the_key.text:SetPoint("center", enter_the_key, "center")
	enter_the_key:Hide()

	local registerKeybind = function(self, key)
		if (ignoredKeys [key]) then
			return
		end
		if (key == "ESCAPE") then
			enter_the_key:Hide()
			new_keybind_frame.IsListening = false
			new_keybind_frame:SetScript("OnKeyDown", nil)
			return
		end

		local bind = (IsShiftKeyDown() and "SHIFT-" or "") .. (IsControlKeyDown() and "CTRL-" or "") .. (IsAltKeyDown() and "ALT-" or "")
		bind = bind .. key

		--adiciona para a tabela de keybinds
		local keybind = new_keybind_frame.CurrentKeybindEditingSet [self.keybindIndex]
		keybind.key = bind

		new_keybind_frame.IsListening = false
		new_keybind_frame:SetScript("OnKeyDown", nil)

		enter_the_key:Hide()
		new_keybind_frame.keybindScroll:UpdateScroll()

		detailsFramework:QuickDispatch(callback)
	end

	local set_keybind_key = function(self, button, keybindIndex)
		if (new_keybind_frame.IsListening) then
			key = mouseKeys [button] or button
			return registerKeybind (new_keybind_frame, key)
		end
		new_keybind_frame.IsListening = true
		new_keybind_frame.keybindIndex = keybindIndex
		new_keybind_frame:SetScript("OnKeyDown", registerKeybind)

		enter_the_key:Show()
		enter_the_key:SetPoint("bottom", self, "top")
	end

	local new_key_bind = function(self, button, specID)
		tinsert(new_keybind_frame.CurrentKeybindEditingSet, {key = "-none-", action = "_target", actiontext = ""})
		FauxScrollFrame_SetOffset (new_keybind_frame.keybindScroll, max(#new_keybind_frame.CurrentKeybindEditingSet-SCROLL_ROLL_AMOUNT, 0))
		new_keybind_frame.keybindScroll:UpdateScroll()
	end

	local set_action_text = function(keybindIndex, _, text)
		local keybind = new_keybind_frame.CurrentKeybindEditingSet [keybindIndex]
		keybind.actiontext = text
		detailsFramework:QuickDispatch(callback)
	end

	local set_action_on_espace_press = function(textentry, capsule)
		capsule = capsule or textentry.MyObject
		local keybind = new_keybind_frame.CurrentKeybindEditingSet [capsule.CurIndex]
		textentry:SetText(keybind.actiontext)
		detailsFramework:QuickDispatch(callback)
	end

	local lock_textentry = {
		["_target"] = true,
		["_taunt"] = true,
		["_interrupt"] = true,
		["_dispel"] = true,
		["_spell"] = false,
		["_macro"] = false,
	}

	local change_key_action = function(self, keybindIndex, value)
		local keybind = new_keybind_frame.CurrentKeybindEditingSet [keybindIndex]
		keybind.action = value
		new_keybind_frame.keybindScroll:UpdateScroll()
		detailsFramework:QuickDispatch(callback)
	end
	local fill_action_dropdown = function()

		local locClass, class = UnitClass("player")

		local taunt = ""
		local interrupt = ""
		local dispel = ""

		if (type(dispel) == "table") then
			local dispelString = "\n"
			for specID, spellid in pairs(dispel) do
				local specid, specName = DetailsFramework.GetSpecializationInfoByID (specID)
				local spellName = GetSpellInfo(spellid)
				dispelString = dispelString .. "|cFFE5E5E5" .. (specName or "") .. "|r: |cFFFFFFFF" .. spellName .. "\n"
			end
			dispel = dispelString
		else
			dispel = ""
		end

		return {
			--{value = "_target", label = "Target", onclick = change_key_action, desc = "Target the unit"},
			--{value = "_taunt", label = "Taunt", onclick = change_key_action, desc = "Cast the taunt spell for your class\n\n|cFFFFFFFFSpell: " .. taunt},
			--{value = "_interrupt", label = "Interrupt", onclick = change_key_action, desc = "Cast the interrupt spell for your class\n\n|cFFFFFFFFSpell: " .. interrupt},
			--{value = "_dispel", label = "Dispel", onclick = change_key_action, desc = "Cast the interrupt spell for your class\n\n|cFFFFFFFFSpell: " .. dispel},
			{value = "_spell", label = "Cast Spell", onclick = change_key_action, desc = "Type the spell name in the text box"},
			{value = "_macro", label = "Run Macro", onclick = change_key_action, desc = "Type your macro in the text box"},
		}
	end

	local copy_keybind = function(self, button, keybindIndex)
		local keybind = new_keybind_frame.CurrentKeybindEditingSet [keybindIndex]
		for specID, t in pairs(new_keybind_frame.Data) do
			if (specID ~= new_keybind_frame.EditingSpec) then
				local key = CopyTable (keybind)
				local specid, specName = DetailsFramework.GetSpecializationInfoByID (specID)
				tinsert(new_keybind_frame.Data [specID], key)
				detailsFramework:Msg("Keybind copied to " .. (specName or ""))
			end
		end
		detailsFramework:QuickDispatch(callback)
	end

	local delete_keybind = function(self, button, keybindIndex)
		tremove(new_keybind_frame.CurrentKeybindEditingSet, keybindIndex)
		new_keybind_frame.keybindScroll:UpdateScroll()
		detailsFramework:QuickDispatch(callback)
	end

	local newTitle = detailsFramework:CreateLabel(new_keybind_frame, "Create a new Keybind:", 12, "silver")
	newTitle:SetPoint("topleft", new_keybind_frame, "topleft", 200, mainStartY)
	local createNewKeybind = detailsFramework:CreateButton(new_keybind_frame, new_key_bind, 160, 20, "New Key Bind", 1, _, _, "NewKeybindButton", _, 0, options_button_template, options_text_template)
	createNewKeybind:SetPoint("topleft", newTitle, "bottomleft", 0, -10)
	--createNewKeybind:SetIcon ([[Interface\Buttons\UI-GuildButton-PublicNote-Up]])

	local update_keybind_list = function(self)

		local keybinds = new_keybind_frame.CurrentKeybindEditingSet
		FauxScrollFrame_Update (self, #keybinds, SCROLL_ROLL_AMOUNT, 21)
		local offset = FauxScrollFrame_GetOffset (self)

		for i = 1, SCROLL_ROLL_AMOUNT do
			local index = i + offset
			local f = self.Frames [i]
			local data = keybinds [index]

			if (data) then
				--index
				f.Index.text = index
				--keybind
				local keyBindText = keysToMouse [data.key] or data.key

				keyBindText = keyBindText:gsub("type1", "LeftButton")
				keyBindText = keyBindText:gsub("type2", "RightButton")
				keyBindText = keyBindText:gsub("type3", "MiddleButton")

				f.KeyBind.text = keyBindText
				f.KeyBind:SetClickFunction(set_keybind_key, index, nil, "left")
				f.KeyBind:SetClickFunction(set_keybind_key, index, nil, "right")
				--action
				f.ActionDrop:SetFixedParameter(index)
				f.ActionDrop:Select(data.action)
				--action text
				f.ActionText.text = data.actiontext
				f.ActionText:SetEnterFunction (set_action_text, index)
				f.ActionText.CurIndex = index

				if (lock_textentry [data.action]) then
					f.ActionText:Disable()
				else
					f.ActionText:Enable()
				end

				--copy
				f.Copy:SetClickFunction(copy_keybind, index)
				--delete
				f.Delete:SetClickFunction(delete_keybind, index)

				f:Show()
			else
				f:Hide()
			end
		end

		self:Show()
	end



	keybindScroll:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll (self, offset, 21, update_keybind_list)
	end)
	keybindScroll.UpdateScroll = update_keybind_list

	local backdropColor = {.3, .3, .3, .3}
	local backdropColorOnEnter = {.6, .6, .6, .6}
	local on_enter = function(self)
		self:SetBackdropColor(unpack(backdropColorOnEnter))
	end
	local on_leave = function(self)
		self:SetBackdropColor(unpack(backdropColor))
	end

	local font = "GameFontHighlightSmall"

	for i = 1, SCROLL_ROLL_AMOUNT do
		local f = CreateFrame("frame", "$KeyBindFrame" .. i, keybindScroll, "BackdropTemplate")
		f:SetSize(1009, 20)
		f:SetPoint("topleft", keybindScroll, "topleft", 0, -(i-1)*29)
		f:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		f:SetBackdropColor(unpack(backdropColor))
		f:SetScript("OnEnter", on_enter)
		f:SetScript("OnLeave", on_leave)
		tinsert(keybindScroll.Frames, f)

		f.Index = detailsFramework:CreateLabel(f, "1")
		f.KeyBind = detailsFramework:CreateButton(f, set_key_bind, 100, 20, "", _, _, _, "SetNewKeybindButton", _, 0, options_button_template, options_text_template)
		f.ActionDrop = detailsFramework:CreateDropDown (f, fill_action_dropdown, 0, 120, 20, "ActionDropdown", _, options_dropdown_template)
		f.ActionText = detailsFramework:CreateTextEntry(f, function()end, 660, 20, "TextBox", _, _, options_dropdown_template)
		f.Copy = detailsFramework:CreateButton(f, copy_keybind, 20, 20, "", _, _, _, "CopyKeybindButton", _, 0, options_button_template, options_text_template)
		f.Delete = detailsFramework:CreateButton(f, delete_keybind, 16, 20, "", _, _, _, "DeleteKeybindButton", _, 2, options_button_template, options_text_template)

		f.Index:SetPoint("left", f, "left", 10, 0)
		f.KeyBind:SetPoint("left", f, "left", 43, 0)
		f.ActionDrop:SetPoint("left", f, "left", 150, 0)
		f.ActionText:SetPoint("left", f, "left", 276, 0)
		f.Copy:SetPoint("left", f, "left", 950, 0)
		f.Delete:SetPoint("left", f, "left", 990, 0)

		f.Copy:SetIcon ([[Interface\Buttons\UI-GuildButton-PublicNote-Up]], nil, nil, nil, nil, nil, nil, 4)
		f.Delete:SetIcon ([[Interface\Buttons\UI-StopButton]], nil, nil, nil, nil, nil, nil, 4)

		f.Copy.tooltip = "copy this keybind to other specs"
		f.Delete.tooltip = "erase this keybind"

		--editbox
		f.ActionText:SetJustifyH("left")
		f.ActionText:SetHook("OnEscapePressed", set_action_on_espace_press)
		f.ActionText:SetHook("OnEditFocusGained", function()
			local playerSpells = {}
			local tab, tabTex, offset, numSpells = GetSpellTabInfo (2)
			for i = 1, numSpells do
				local index = offset + i
				local spellType, spellId = GetSpellBookItemInfo (index, "player")
				if (spellType == "SPELL") then
					local spellName = GetSpellInfo(spellId)
					tinsert(playerSpells, spellName)
				end
			end
			f.ActionText.WordList = playerSpells
		end)

		f.ActionText:SetAsAutoComplete ("WordList")
	end

	local header = CreateFrame("frame", "$parentOptionsPanelFrameHeader", keybindScroll, "BackdropTemplate")
	header:SetPoint("bottomleft", keybindScroll, "topleft", 0, 2)
	header:SetPoint("bottomright", keybindScroll, "topright", 0, 2)
	header:SetHeight(16)

	header.Index = detailsFramework:CreateLabel  (header, "Index", detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE"))
	header.Key = detailsFramework:CreateLabel  (header, "Key", detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE"))
	header.Action = detailsFramework:CreateLabel  (header, "Action", detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE"))
	header.Macro = detailsFramework:CreateLabel  (header, "Spell Name / Macro", detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE"))
	header.Copy = detailsFramework:CreateLabel  (header, "Copy", detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE"))
	header.Delete = detailsFramework:CreateLabel  (header, "Delete", detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE"))

	header.Index:SetPoint("left", header, "left", 10, 0)
	header.Key:SetPoint("left", header, "left", 43, 0)
	header.Action:SetPoint("left", header, "left", 150, 0)
	header.Macro:SetPoint("left", header, "left", 276, 0)
	header.Copy:SetPoint("left", header, "left", 950, 0)
	header.Delete:SetPoint("left", header, "left", 990, 0)

	new_keybind_frame:SetScript("OnShow", function()

		--new_keybind_frame.EditingSpec = EnemyGrid.CurrentSpec
		--new_keybind_frame.CurrentKeybindEditingSet = EnemyGrid.CurrentKeybindSet

		for _, button in ipairs(allSpecButtons) do
			if (new_keybind_frame.EditingSpec ~= button.specID) then
				button.selectedTexture:Hide()
			else
				button.selectedTexture:Show()
			end
		end

		keybindScroll:UpdateScroll()
	end)

	new_keybind_frame:SetScript("OnHide", function()
		if (new_keybind_frame.IsListening) then
			new_keybind_frame.IsListening = false
			new_keybind_frame:SetScript("OnKeyDown", nil)
		end
	end)

	return new_keybind_frame
end

function detailsFramework:BuildKeybindFunctions (data, prefix)

	--~keybind
	local classLoc, class = UnitClass("player")
	local bindingList = data

	local bindString = "self:ClearBindings()"
	local bindKeyBindTypeFunc = [[local unitFrame = ...]]
	local bindMacroTextFunc = [[local unitFrame = ...]]
	local isMouseBinding

	for i = 1, #bindingList do
		local bind = bindingList [i]
		local bindType

		--which button to press
		if (bind.key:find("type")) then
			local keyNumber = tonumber(bind.key:match ("%d"))
			bindType = keyNumber
			isMouseBinding = true
		else
			bindType = prefix .. "" .. i
			bindString = bindString .. "self:SetBindingClick (0, '" .. bind.key .. "', self:GetName(), '" .. bindType .. "')"
			bindType = "-" .. prefix .. "" .. i
			isMouseBinding = nil
		end

		--keybind type
		local shift, alt, ctrl = bind.key:match ("SHIFT"), bind.key:match ("ALT"), bind.key:match ("CTRL")
		local CommandKeys = alt and alt .. "-" or ""
		CommandKeys = ctrl and CommandKeys .. ctrl .. "-" or CommandKeys
		CommandKeys = shift and CommandKeys .. shift .. "-" or CommandKeys

		local keyBindType
		if (isMouseBinding) then
			keyBindType = [[unitFrame:SetAttribute ("@COMMANDtype@BINDTYPE", "macro")]]
		else
			keyBindType = [[unitFrame:SetAttribute ("type@BINDTYPE", "macro")]]
		end

		keyBindType = keyBindType:gsub("@BINDTYPE", bindType)
		keyBindType = keyBindType:gsub("@COMMAND", CommandKeys)
		bindKeyBindTypeFunc = bindKeyBindTypeFunc .. keyBindType

		--spell or macro
		if (bind.action == "_spell") then
			local macroTextLine
			if (isMouseBinding) then
				macroTextLine = [[unitFrame:SetAttribute ("@COMMANDmacrotext@BINDTYPE", "/cast [@mouseover] @SPELL")]]
			else
				macroTextLine = [[unitFrame:SetAttribute ("macrotext@BINDTYPE", "/cast [@mouseover] @SPELL")]]
			end
			macroTextLine = macroTextLine:gsub("@BINDTYPE", bindType)
			macroTextLine = macroTextLine:gsub("@SPELL", bind.actiontext)
			macroTextLine = macroTextLine:gsub("@COMMAND", CommandKeys)
			bindMacroTextFunc = bindMacroTextFunc .. macroTextLine

		elseif (bind.action == "_macro") then
			local macroTextLine
			if (isMouseBinding) then
				macroTextLine = [[unitFrame:SetAttribute ("@COMMANDmacrotext@BINDTYPE", "@MACRO")]]
			else
				macroTextLine = [[unitFrame:SetAttribute ("macrotext@BINDTYPE", "@MACRO")]]
			end
			macroTextLine = macroTextLine:gsub("@BINDTYPE", bindType)
			macroTextLine = macroTextLine:gsub("@MACRO", bind.actiontext)
			macroTextLine = macroTextLine:gsub("@COMMAND", CommandKeys)
			bindMacroTextFunc = bindMacroTextFunc .. macroTextLine

		end
	end

	--~key
	local bindTypeFuncLoaded = loadstring (bindKeyBindTypeFunc)
	local bindMacroFuncLoaded = loadstring (bindMacroTextFunc)

	if (not bindMacroFuncLoaded or not bindTypeFuncLoaded) then
		return
	end

	return bindString, bindTypeFuncLoaded, bindMacroFuncLoaded
end


function detailsFramework:SetKeybindsOnProtectedFrame (frame, bind_string, bind_type_func, bind_macro_func)

	bind_type_func (frame)
	bind_macro_func (frame)
	frame:SetAttribute ("_onenter", bind_string)

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~standard backdrop

function detailsFramework:ApplyStandardBackdrop(frame, solidColor, alphaScale)
	alphaScale = alphaScale or 0.95

	if (not frame.SetBackdrop)then
		--print(debugstack(1,2,1))
		Mixin(frame, BackdropTemplateMixin)
	end

	local red, green, blue, alpha = detailsFramework:GetDefaultBackdropColor()

	if (solidColor) then
		local colorDeviation = 0.05
		frame:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Buttons\WHITE8X8]], tileSize = 32, tile = true})
		frame:SetBackdropColor(red, green, blue, 0.872)
		frame:SetBackdropBorderColor(0, 0, 0, 0.95)

	else
		frame:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		frame:SetBackdropColor(red, green, blue, alpha * alphaScale)
		frame:SetBackdropBorderColor(0, 0, 0, 0.95)
	end

	if (not frame.__background) then
		frame.__background = frame:CreateTexture(nil, "background")
		frame.__background:SetColorTexture(red, green, blue)
		frame.__background:SetAllPoints()
	end

	frame.__background:SetAlpha(alpha * alphaScale)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~title bar

detailsFramework.TitleFunctions = {

	SetTitle = function(self, titleText, titleColor, font, size)
		self.TitleLabel:SetText(titleText or self.TitleLabel:GetText())

		if (titleColor) then
			local r, g, b, a = detailsFramework:ParseColors(titleColor)
			self.TitleLabel:SetTextColor(r, g, b, a)
		end

		if (font) then
			detailsFramework:SetFontFace (self.TitleLabel, font)
		end

		if (size) then
			detailsFramework:SetFontSize(self.TitleLabel, size)
		end
	end


}

function detailsFramework:CreateTitleBar (f, titleText)

	local titleBar = CreateFrame("frame", f:GetName() and f:GetName() .. "TitleBar" or nil, f,"BackdropTemplate")
	titleBar:SetPoint("topleft", f, "topleft", 2, -3)
	titleBar:SetPoint("topright", f, "topright", -2, -3)
	titleBar:SetHeight(20)
	titleBar:SetBackdrop(SimplePanel_frame_backdrop) --it's an upload from this file
	titleBar:SetBackdropColor(.2, .2, .2, 1)
	titleBar:SetBackdropBorderColor(0, 0, 0, 1)

	local closeButton = CreateFrame("button", titleBar:GetName() and titleBar:GetName() .. "CloseButton" or nil, titleBar, "BackdropTemplate")
	closeButton:SetSize(16, 16)

	closeButton:SetNormalTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	closeButton:SetHighlightTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	closeButton:SetPushedTexture([[Interface\GLUES\LOGIN\Glues-CheckBox-Check]])
	closeButton:GetNormalTexture():SetDesaturated(true)
	closeButton:GetHighlightTexture():SetDesaturated(true)
	closeButton:GetPushedTexture():SetDesaturated(true)

	closeButton:SetAlpha(0.7)
	closeButton:SetScript("OnClick", simple_panel_close_click) --upvalue from this file

	local titleLabel = titleBar:CreateFontString(titleBar:GetName() and titleBar:GetName() .. "TitleText" or nil, "overlay", "GameFontNormal")
	titleLabel:SetTextColor(.8, .8, .8, 1)
	titleLabel:SetText(titleText or "")

	--anchors
	closeButton:SetPoint("right", titleBar, "right", -2, 0)
	titleLabel:SetPoint("center", titleBar, "center")

	--members
	f.TitleBar = titleBar
	f.CloseButton = closeButton
	f.TitleLabel = titleLabel

	titleBar.CloseButton = closeButton
	titleBar.Text = titleLabel

	detailsFramework:Mixin(f, detailsFramework.TitleFunctions)

	return titleBar
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~icon row

detailsFramework.IconRowFunctions = {

	GetIcon = function(self)
		local iconFrame = self.IconPool [self.NextIcon]

		if (not iconFrame) then
			local newIconFrame = CreateFrame("frame", "$parentIcon" .. self.NextIcon, self, "BackdropTemplate")
			newIconFrame.parentIconRow = self

			newIconFrame.Texture = newIconFrame:CreateTexture(nil, "artwork")
			PixelUtil.SetPoint(newIconFrame.Texture, "topleft", newIconFrame, "topleft", 1, -1)
			PixelUtil.SetPoint(newIconFrame.Texture, "bottomright", newIconFrame, "bottomright", -1, 1)

			newIconFrame.Border = newIconFrame:CreateTexture(nil, "background")
			newIconFrame.Border:SetAllPoints()
			newIconFrame.Border:SetColorTexture(0, 0, 0)

			newIconFrame:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
			newIconFrame:SetBackdropBorderColor(0, 0, 0, 0)
			newIconFrame:EnableMouse(false)

			local cooldownFrame = CreateFrame("cooldown", "$parentIconCooldown" .. self.NextIcon, newIconFrame, "CooldownFrameTemplate, BackdropTemplate")
			cooldownFrame:SetAllPoints()
			cooldownFrame:EnableMouse(false)
			cooldownFrame:SetFrameLevel(newIconFrame:GetFrameLevel()+1)
			cooldownFrame:SetHideCountdownNumbers (self.options.surpress_blizzard_cd_timer)
			cooldownFrame.noCooldownCount = self.options.surpress_tulla_omni_cc

			newIconFrame.CountdownText = cooldownFrame:CreateFontString(nil, "overlay", "GameFontNormal")
			--newIconFrame.CountdownText:SetPoint("center")
			newIconFrame.CountdownText:SetPoint(self.options.text_anchor or "center", newIconFrame, self.options.text_rel_anchor or "center", self.options.text_x_offset or 0, self.options.text_y_offset or 0)
			newIconFrame.CountdownText:Hide()

			newIconFrame.StackText = newIconFrame:CreateFontString(nil, "overlay", "GameFontNormal")
			--newIconFrame.StackText:SetPoint("bottomright")
			newIconFrame.StackText:SetPoint(self.options.stack_text_anchor or "center", newIconFrame, self.options.stack_text_rel_anchor or "bottomright", self.options.stack_text_x_offset or 0, self.options.stack_text_y_offset or 0)
			newIconFrame.StackText:Hide()

			newIconFrame.Desc = newIconFrame:CreateFontString(nil, "overlay", "GameFontNormal")
			--newIconFrame.Desc:SetPoint("bottom", newIconFrame, "top", 0, 2)
			newIconFrame.Desc:SetPoint(self.options.desc_text_anchor or "bottom", newIconFrame, self.options.desc_text_rel_anchor or "top", self.options.desc_text_x_offset or 0, self.options.desc_text_y_offset or 2)
			newIconFrame.Desc:Hide()

			newIconFrame.Cooldown = cooldownFrame

			self.IconPool [self.NextIcon] = newIconFrame
			iconFrame = newIconFrame
		end

		iconFrame:ClearAllPoints()

		local anchor = self.options.anchor
		local anchorTo = self.NextIcon == 1 and self or self.IconPool [self.NextIcon - 1]
		local xPadding = self.NextIcon == 1 and self.options.left_padding or self.options.icon_padding or 1
		local growDirection = self.options.grow_direction

		if (growDirection == 1) then --grow to right
			if (self.NextIcon == 1) then
				PixelUtil.SetPoint(iconFrame, "left", anchorTo, "left", xPadding, 0)
			else
				PixelUtil.SetPoint(iconFrame, "left", anchorTo, "right", xPadding, 0)
			end

		elseif (growDirection == 2) then --grow to left
			if (self.NextIcon == 1) then
				PixelUtil.SetPoint(iconFrame, "right", anchorTo, "right", xPadding, 0)
			else
				PixelUtil.SetPoint(iconFrame, "right", anchorTo, "left", xPadding, 0)
			end

		end

		detailsFramework:SetFontColor(iconFrame.CountdownText, self.options.text_color)

		self.NextIcon = self.NextIcon + 1
		return iconFrame
	end,

	--adds only if not existing already in the cache
	AddSpecificIcon = function(self, identifierKey, spellId, borderColor, startTime, duration, forceTexture, descText, count, debuffType, caster, canStealOrPurge, spellName, isBuff)
		if not identifierKey or identifierKey == "" then
			return
		end

		if not self.AuraCache[identifierKey] then
			local icon = self:SetIcon (spellId, borderColor, startTime, duration, forceTexture, descText, count, debuffType, caster, canStealOrPurge, spellName, isBuff or false)
			icon.identifierKey = identifierKey
			self.AuraCache[identifierKey] = true
		end
	end,

	SetIcon = function(self, spellId, borderColor, startTime, duration, forceTexture, descText, count, debuffType, caster, canStealOrPurge, spellName, isBuff, modRate)

		local actualSpellName, _, spellIcon = GetSpellInfo(spellId)

		if forceTexture then
			spellIcon = forceTexture
		end

		spellName = spellName or actualSpellName or "unknown_aura"
		modRate = modRate or 1

		if (spellIcon) then
			local iconFrame = self:GetIcon()
			iconFrame.Texture:SetTexture(spellIcon)
			iconFrame.Texture:SetTexCoord(unpack(self.options.texcoord))

			if (borderColor) then
				iconFrame:SetBackdropBorderColor(Plater:ParseColors(borderColor))
			else
				iconFrame:SetBackdropBorderColor(0, 0, 0 ,0)
			end

			if (startTime) then
				CooldownFrame_Set (iconFrame.Cooldown, startTime, duration, true, true, modRate)

				if (self.options.show_text) then
					iconFrame.CountdownText:Show()

					local now = GetTime()

					iconFrame.timeRemaining = (startTime + duration - now) / modRate
					iconFrame.expirationTime = startTime + duration

					local formattedTime = (iconFrame.timeRemaining > 0) and self.options.decimal_timer and iconFrame.parentIconRow.FormatCooldownTimeDecimal(iconFrame.timeRemaining) or iconFrame.parentIconRow.FormatCooldownTime(iconFrame.timeRemaining) or ""
					iconFrame.CountdownText:SetText(formattedTime)

					iconFrame.CountdownText:SetPoint(self.options.text_anchor or "center", iconFrame, self.options.text_rel_anchor or "center", self.options.text_x_offset or 0, self.options.text_y_offset or 0)
					detailsFramework:SetFontSize(iconFrame.CountdownText, self.options.text_size)
					detailsFramework:SetFontFace (iconFrame.CountdownText, self.options.text_font)
					detailsFramework:SetFontOutline (iconFrame.CountdownText, self.options.text_outline)

					if self.options.on_tick_cooldown_update then
						iconFrame.lastUpdateCooldown = now
						iconFrame:SetScript("OnUpdate", self.OnIconTick)
					else
						iconFrame:SetScript("OnUpdate", nil)
					end

				else
					iconFrame:SetScript("OnUpdate", nil)
					iconFrame.CountdownText:Hide()
				end

				iconFrame.Cooldown:SetReverse (self.options.cooldown_reverse)
				iconFrame.Cooldown:SetDrawSwipe (self.options.cooldown_swipe_enabled)
				iconFrame.Cooldown:SetEdgeTexture (self.options.cooldown_edge_texture)
				iconFrame.Cooldown:SetHideCountdownNumbers (self.options.surpress_blizzard_cd_timer)
			else
				iconFrame.timeRemaining = nil
				iconFrame.expirationTime = nil
				iconFrame:SetScript("OnUpdate", nil)
				iconFrame.CountdownText:Hide()
			end

			if (descText and self.options.desc_text) then
				iconFrame.Desc:Show()
				iconFrame.Desc:SetText(descText.text)
				iconFrame.Desc:SetTextColor(detailsFramework:ParseColors(descText.text_color or self.options.desc_text_color))
				iconFrame.Desc:SetPoint(self.options.desc_text_anchor or "bottom", iconFrame, self.options.desc_text_rel_anchor or "top", self.options.desc_text_x_offset or 0, self.options.desc_text_y_offset or 2)
				detailsFramework:SetFontSize(iconFrame.Desc, descText.text_size or self.options.desc_text_size)
				detailsFramework:SetFontFace (iconFrame.Desc, self.options.desc_text_font)
				detailsFramework:SetFontOutline (iconFrame.Desc, self.options.desc_text_outline)
			else
				iconFrame.Desc:Hide()
			end

			if (count and count > 1 and self.options.stack_text) then
				iconFrame.StackText:Show()
				iconFrame.StackText:SetText(count)
				iconFrame.StackText:SetTextColor(detailsFramework:ParseColors(self.options.desc_text_color))
				iconFrame.StackText:SetPoint(self.options.stack_text_anchor or "center", iconFrame, self.options.stack_text_rel_anchor or "bottomright", self.options.stack_text_x_offset or 0, self.options.stack_text_y_offset or 0)
				detailsFramework:SetFontSize(iconFrame.StackText, self.options.stack_text_size)
				detailsFramework:SetFontFace (iconFrame.StackText, self.options.stack_text_font)
				detailsFramework:SetFontOutline (iconFrame.StackText, self.options.stack_text_outline)
			else
				iconFrame.StackText:Hide()
			end

			PixelUtil.SetSize(iconFrame, self.options.icon_width, self.options.icon_height)
			iconFrame:Show()

			--update the size of the frame
			self:SetWidth((self.options.left_padding * 2) + (self.options.icon_padding * (self.NextIcon-2)) + (self.options.icon_width * (self.NextIcon - 1)))
			self:SetHeight(self.options.icon_height + (self.options.top_padding * 2))

			--make information available
			iconFrame.spellId = spellId
			iconFrame.startTime = startTime
			iconFrame.duration = duration
			iconFrame.count = count
			iconFrame.debuffType = debuffType
			iconFrame.caster = caster
			iconFrame.canStealOrPurge = canStealOrPurge
			iconFrame.isBuff = isBuff
			iconFrame.spellName = spellName

			iconFrame.identifierKey = nil -- only used for "specific" add/remove

			--add the spell into the cache
			self.AuraCache [spellId or -1] = true
			self.AuraCache [spellName] = true
			self.AuraCache.canStealOrPurge = self.AuraCache.canStealOrPurge or canStealOrPurge
			self.AuraCache.hasEnrage = self.AuraCache.hasEnrage or debuffType == "" --yes, enrages are empty-string...

			--show the frame
			self:Show()

			return iconFrame
		end
	end,

	OnIconTick = function(self, deltaTime)
		local now = GetTime()
		if (self.lastUpdateCooldown + 0.05) <= now then
			self.timeRemaining = self.expirationTime - now
			if self.timeRemaining > 0 then
				if self.parentIconRow.options.decimal_timer then
					self.CountdownText:SetText(self.parentIconRow.FormatCooldownTimeDecimal(self.timeRemaining))
				else
					self.CountdownText:SetText(self.parentIconRow.FormatCooldownTime(self.timeRemaining))
				end
			else
				self.CountdownText:SetText("")
			end
			self.lastUpdateCooldown = now
		end
	end,

	FormatCooldownTime = function(formattedTime)
		if (formattedTime >= 3600) then
			formattedTime = floor(formattedTime / 3600) .. "h"

		elseif (formattedTime >= 60) then
			formattedTime = floor(formattedTime / 60) .. "m"

		else
			formattedTime = floor(formattedTime)
		end
		return formattedTime
	end,

	FormatCooldownTimeDecimal = function(formattedTime)
        if formattedTime < 10 then
            return ("%.1f"):format(formattedTime)
        elseif formattedTime < 60 then
            return ("%d"):format(formattedTime)
        elseif formattedTime < 3600 then
            return ("%d:%02d"):format(formattedTime/60%60, formattedTime%60)
        elseif formattedTime < 86400 then
            return ("%dh %02dm"):format(formattedTime/(3600), formattedTime/60%60)
        else
            return ("%dd %02dh"):format(formattedTime/86400, (formattedTime/3600) - (floor(formattedTime/86400) * 24))
        end
	end,

	RemoveSpecificIcon = function(self, identifierKey)
		if not identifierKey or identifierKey == "" then
			return
		end

		table.wipe(self.AuraCache)

		local iconPool = self.IconPool
		local countStillShown = 0
		for i = 1, self.NextIcon -1 do
			local iconFrame = iconPool[i]
			if iconFrame.identifierKey and iconFrame.identifierKey == identifierKey then
				iconFrame:Hide()
				iconFrame:ClearAllPoints()
				iconFrame.identifierKey = nil
			else
				self.AuraCache [iconFrame.spellId] = true
				self.AuraCache [iconFrame.spellName] = true
				self.AuraCache.canStealOrPurge = self.AuraCache.canStealOrPurge or iconFrame.canStealOrPurge
				self.AuraCache.hasEnrage = self.AuraCache.hasEnrage or iconFrame.debuffType == "" --yes, enrages are empty-string...
				countStillShown = countStillShown + 1
			end
		end

		self:AlignAuraIcons()

	end,

	ClearIcons = function(self, resetBuffs, resetDebuffs)
		resetBuffs = resetBuffs ~= false
		resetDebuffs = resetDebuffs ~= false
		table.wipe(self.AuraCache)

		local iconPool = self.IconPool
		for i = 1, self.NextIcon -1 do
			local iconFrame = iconPool[i]
			if iconFrame.isBuff == nil then
				iconFrame:Hide()
				iconFrame:ClearAllPoints()
			elseif resetBuffs and iconFrame.isBuff then
				iconFrame:Hide()
				iconFrame:ClearAllPoints()
			elseif resetDebuffs and not iconFrame.isBuff then
				iconFrame:Hide()
				iconFrame:ClearAllPoints()
			else
				self.AuraCache [iconFrame.spellId] = true
				self.AuraCache [iconFrame.spellName] = true
				self.AuraCache.canStealOrPurge = self.AuraCache.canStealOrPurge or iconFrame.canStealOrPurge
				self.AuraCache.hasEnrage = self.AuraCache.hasEnrage or iconFrame.debuffType == "" --yes, enrages are empty-string...
			end
		end

		self:AlignAuraIcons()

	end,

	AlignAuraIcons = function(self)

		local iconPool = self.IconPool
		local iconAmount = #iconPool
		local countStillShown = 0

		table.sort (iconPool, function(i1, i2) return i1:IsShown() and not i2:IsShown() end)

		if iconAmount == 0 then
			self:Hide()
		else
			-- re-anchor not hidden
			for i = 1, iconAmount do
				local iconFrame = iconPool[i]
				local anchor = self.options.anchor
				local anchorTo = i == 1 and self or self.IconPool [i - 1]
				local xPadding = i == 1 and self.options.left_padding or self.options.icon_padding or 1
				local growDirection = self.options.grow_direction

				countStillShown = countStillShown + (iconFrame:IsShown() and 1 or 0)

				iconFrame:ClearAllPoints()
				if (growDirection == 1) then --grow to right
					if (i == 1) then
						PixelUtil.SetPoint(iconFrame, "left", anchorTo, "left", xPadding, 0)
					else
						PixelUtil.SetPoint(iconFrame, "left", anchorTo, "right", xPadding, 0)
					end

				elseif (growDirection == 2) then --grow to left
					if (i == 1) then
						PixelUtil.SetPoint(iconFrame, "right", anchorTo, "right", xPadding, 0)
					else
						PixelUtil.SetPoint(iconFrame, "right", anchorTo, "left", xPadding, 0)
					end

				end
			end
		end

		self.NextIcon = countStillShown + 1

	end,

	GetIconGrowDirection = function(self)
		local side = self.options.anchor.side

		if (side == 1) then
			return 1
		elseif (side == 2) then
			return 2
		elseif (side == 3) then
			return 1
		elseif (side == 4) then
			return 1
		elseif (side == 5) then
			return 2
		elseif (side == 6) then
			return 1
		elseif (side == 7) then
			return 2
		elseif (side == 8) then
			return 1
		elseif (side == 9) then
			return 1
		elseif (side == 10) then
			return 1
		elseif (side == 11) then
			return 2
		elseif (side == 12) then
			return 1
		elseif (side == 13) then
			return 1
		end
	end,

	OnOptionChanged = function(self, optionName)
		self:SetBackdropColor(unpack(self.options.backdrop_color))
		self:SetBackdropBorderColor(unpack(self.options.backdrop_border_color))
	end,
}

local default_icon_row_options = {
	icon_width = 20,
	icon_height = 20,
	texcoord = {.1, .9, .1, .9},
	show_text = true,
	text_color = {1, 1, 1, 1},
	text_size = 12,
	text_font = "Arial Narrow",
	text_outline = "NONE",
	text_anchor = "center",
	text_rel_anchor = "center",
	text_x_offset = 0,
	text_y_offset = 0,
	desc_text = true,
	desc_text_color = {1, 1, 1, 1},
	desc_text_size = 7,
	desc_text_font = "Arial Narrow",
	desc_text_outline = "NONE",
	desc_text_anchor = "bottom",
	desc_text_rel_anchor = "top",
	desc_text_x_offset = 0,
	desc_text_y_offset = 2,
	stack_text = true,
	stack_text_color = {1, 1, 1, 1},
	stack_text_size = 10,
	stack_text_font = "Arial Narrow",
	stack_text_outline = "NONE",
	stack_text_anchor = "center",
	stack_text_rel_anchor = "bottomright",
	stack_text_x_offset = 0,
	stack_text_y_offset = 0,
	left_padding = 1, --distance between right and left
	top_padding = 1, --distance between top and bottom
	icon_padding = 1, --distance between each icon
	backdrop = {},
	backdrop_color = {0, 0, 0, 0.5},
	backdrop_border_color = {0, 0, 0, 1},
	anchor = {side = 6, x = 2, y = 0},
	grow_direction = 1, --1 = to right 2 = to left
	surpress_blizzard_cd_timer = false,
	surpress_tulla_omni_cc = false,
	on_tick_cooldown_update = true,
	decimal_timer = false,
	cooldown_reverse = false,
	cooldown_swipe_enabled = true,
	cooldown_edge_texture = "Interface\\Cooldown\\edge",
}

function detailsFramework:CreateIconRow (parent, name, options)
	local f = CreateFrame("frame", name, parent, "BackdropTemplate")
	f.IconPool = {}
	f.NextIcon = 1
	f.AuraCache = {}

	detailsFramework:Mixin(f, detailsFramework.IconRowFunctions)
	detailsFramework:Mixin(f, detailsFramework.OptionsFunctions)

	f:BuildOptionsTable (default_icon_row_options, options)

	f:SetSize(f.options.icon_width, f.options.icon_height + (f.options.top_padding * 2))

	f:SetBackdrop(f.options.backdrop)
	f:SetBackdropColor(unpack(f.options.backdrop_color))
	f:SetBackdropBorderColor(unpack(f.options.backdrop_border_color))

	return f
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--~header

--mixed functions
detailsFramework.HeaderFunctions = {
	AddFrameToHeaderAlignment = function(self, frame)
		self.FramesToAlign = self.FramesToAlign or {}
		tinsert(self.FramesToAlign, frame)
	end,

	GetFramesFromHeaderAlignment = function(self, frame)
		return self.FramesToAlign or {}
	end,

	--@self: an object like a line
	--@headerFrame: the main header frame
	--@anchor: which side the columnHeaders are attach
	AlignWithHeader = function(self, headerFrame, anchor)
		local columnHeaderFrames = headerFrame.columnHeadersCreated
		anchor = anchor or "topleft"

		for i = 1, #self.FramesToAlign do
			local frame = self.FramesToAlign[i]
			frame:ClearAllPoints()

			local columnHeader = columnHeaderFrames[i]
			local offset = 0

			if (columnHeader.columnAlign == "right") then
				offset = columnHeader:GetWidth()
				if (frame:GetObjectType() == "FontString") then
					frame:SetJustifyH("right")
				end
			end

			frame:SetPoint(columnHeader.columnAlign, self, anchor, columnHeader.XPosition + columnHeader.columnOffset + offset, 0)
		end
	end,

	--@self: column header button
	OnClick = function(self, buttonClicked)

		--get the header main frame
		local headerFrame = self:GetParent()

		--if this header does not have a clickable header, just ignore
		if (not headerFrame.columnSelected) then
			return
		end

		--get the latest column header selected
		local previousColumnHeader = headerFrame.columnHeadersCreated[headerFrame.columnSelected]
		previousColumnHeader.Arrow:Hide()
		headerFrame:ResetColumnHeaderBackdrop(previousColumnHeader)
		headerFrame:SetBackdropColorForSelectedColumnHeader(self)

		if (headerFrame.columnSelected == self.columnIndex) then
			self.order = self.order ~= "ASC" and "ASC" or "DESC"
		end
		headerFrame.columnOrder = self.order

		--set the new column header selected
		headerFrame.columnSelected = self.columnIndex

		headerFrame:UpdateSortArrow(self)

		if (headerFrame.options.header_click_callback) then
			--callback with the main header frame, column header, column index and column order as payload
			local okay, errortext = pcall(headerFrame.options.header_click_callback, headerFrame, self, self.columnIndex, self.order)
			if (not okay) then
				print("DF: Header onClick callback error:", errortext)
			end
		end
	end,
}

detailsFramework.HeaderCoreFunctions = {
	GetColumnWidth = function(self, columnId)
		return self.HeaderTable[columnId].width
	end,

	SetHeaderTable = function(self, newTable)
		self.columnHeadersCreated = self.columnHeadersCreated or {}
		self.HeaderTable = newTable
		self.NextHeader = 1
		self.HeaderWidth = 0
		self.HeaderHeight = 0
		self:Refresh()
	end,

	--return which header is current selected and the the order ASC DESC
	GetSelectedColumn = function(self)
		return self.columnSelected, self.columnHeadersCreated[self.columnSelected or 1].order
	end,

	--clean up and rebuild the header following the header options
	--@self: main header frame
	Refresh = function(self)
		--refresh background frame
		self:SetBackdrop(self.options.backdrop)
		self:SetBackdropColor(unpack(self.options.backdrop_color))
		self:SetBackdropBorderColor(unpack(self.options.backdrop_border_color))

		--reset all header frames
		for i = 1, #self.columnHeadersCreated do
			local columnHeader = self.columnHeadersCreated[i]
			columnHeader.InUse = false
			columnHeader:Hide()
		end

		local previousColumnHeader
		local growDirection = string.lower(self.options.grow_direction)

		--update header frames
		local headerSize = #self.HeaderTable
		for i = 1, headerSize do
			--get the header button, a new one is created if it doesn't exists yet
			local columnHeader = self:GetNextHeader()
			self:UpdateColumnHeader(columnHeader, i)

			--grow direction
			if (not previousColumnHeader) then
				columnHeader:SetPoint("topleft", self, "topleft", 0, 0)

				if (growDirection == "right") then
					if (self.options.use_line_separators) then
						columnHeader.Separator:Show()
						columnHeader.Separator:SetWidth(self.options.line_separator_width)
						columnHeader.Separator:SetColorTexture(unpack(self.options.line_separator_color))

						columnHeader.Separator:ClearAllPoints()
						if (self.options.line_separator_gap_align) then
							columnHeader.Separator:SetPoint("topleft", columnHeader, "topright", 0, 0)
						else
							columnHeader.Separator:SetPoint("topright", columnHeader, "topright", 0, 0)
						end
						columnHeader.Separator:SetHeight(self.options.line_separator_height)
					end
				end
			else
				if (growDirection == "right") then
					columnHeader:SetPoint("topleft", previousColumnHeader, "topright", self.options.padding, 0)

					if (self.options.use_line_separators) then
						columnHeader.Separator:Show()
						columnHeader.Separator:SetWidth(self.options.line_separator_width)
						columnHeader.Separator:SetColorTexture(unpack(self.options.line_separator_color))

						columnHeader.Separator:ClearAllPoints()
						if (self.options.line_separator_gap_align) then
							columnHeader.Separator:SetPoint("topleft", columnHeader, "topright", 0, 0)
						else
							columnHeader.Separator:SetPoint("topleft", columnHeader, "topright", 0, 0)
						end
						columnHeader.Separator:SetHeight(self.options.line_separator_height)

						if (headerSize == i) then
							columnHeader.Separator:Hide()
						end
					end

				elseif (growDirection == "left") then
					columnHeader:SetPoint("topright", previousColumnHeader, "topleft", -self.options.padding, 0)

				elseif (growDirection == "bottom") then
					columnHeader:SetPoint("topleft", previousColumnHeader, "bottomleft", 0, -self.options.padding)

				elseif (growDirection == "top") then
					columnHeader:SetPoint("bottomleft", previousColumnHeader, "topleft", 0, self.options.padding)
				end
			end

			previousColumnHeader = columnHeader
		end

		self:SetSize(self.HeaderWidth, self.HeaderHeight)
	end,

	--@self: main header frame
	UpdateSortArrow = function(self, columnHeader, defaultShown, defaultOrder)
		local options = self.options
		local order = defaultOrder or columnHeader.order
		local arrowIcon = columnHeader.Arrow

		if (type(defaultShown) ~= "boolean") then
			arrowIcon:Show()
		else
			arrowIcon:SetShown(defaultShown)
			if (defaultShown) then
				self:SetBackdropColorForSelectedColumnHeader(columnHeader)
			end
		end

		arrowIcon:SetAlpha(options.arrow_alpha)

		if (order == "ASC") then
			arrowIcon:SetTexture(options.arrow_up_texture)
			arrowIcon:SetTexCoord(unpack(options.arrow_up_texture_coords))
			arrowIcon:SetSize(unpack(options.arrow_up_size))

		elseif (order == "DESC") then
			arrowIcon:SetTexture(options.arrow_down_texture)
			arrowIcon:SetTexCoord(unpack(options.arrow_down_texture_coords))
			arrowIcon:SetSize(unpack(options.arrow_down_size))
		end
	end,

	--@self: main header frame
	UpdateColumnHeader = function(self, columnHeader, headerIndex)
		local headerData = self.HeaderTable[headerIndex]

		if (headerData.icon) then
			columnHeader.Icon:SetTexture(headerData.icon)

			if (headerData.texcoord) then
				columnHeader.Icon:SetTexCoord(unpack(headerData.texcoord))
			else
				columnHeader.Icon:SetTexCoord(0, 1, 0, 1)
			end

			columnHeader.Icon:SetPoint("left", columnHeader, "left", self.options.padding, 0)
			columnHeader.Icon:Show()
		end

		if (headerData.text) then
			columnHeader.Text:SetText(headerData.text)

			--text options
			detailsFramework:SetFontColor(columnHeader.Text, self.options.text_color)
			detailsFramework:SetFontSize(columnHeader.Text, self.options.text_size)
			detailsFramework:SetFontOutline(columnHeader.Text, self.options.text_shadow)

			--point
			if (not headerData.icon) then
				columnHeader.Text:SetPoint("left", columnHeader, "left", self.options.padding, 0)
			else
				columnHeader.Text:SetPoint("left", columnHeader.Icon, "right", self.options.padding, 0)
			end

			columnHeader.Text:Show()
		end

		--column header index
		columnHeader.columnIndex = headerIndex

		if (headerData.canSort) then
			columnHeader.order = "DESC"
			columnHeader.Arrow:SetTexture(self.options.arrow_up_texture)
		else
			columnHeader.Arrow:Hide()
		end

		if (headerData.selected) then
			columnHeader.Arrow:Show()
			columnHeader.Arrow:SetAlpha(.843)
			self:UpdateSortArrow(columnHeader, true, columnHeader.order)
			self.columnSelected = headerIndex
		else
			if (headerData.canSort) then
				self:UpdateSortArrow(columnHeader, false, columnHeader.order)
			end
		end

		--size
		if (headerData.width) then
			columnHeader:SetWidth(headerData.width)
		end
		if (headerData.height) then
			columnHeader:SetHeight(headerData.height)
		end

		columnHeader.XPosition = self.HeaderWidth -- + self.options.padding
		columnHeader.YPosition = self.HeaderHeight -- + self.options.padding

		columnHeader.columnAlign = headerData.align or "left"
		columnHeader.columnOffset = headerData.offset or 0

		--add the header piece size to the total header size
		local growDirection = string.lower(self.options.grow_direction)

		if (growDirection == "right" or growDirection == "left") then
			self.HeaderWidth = self.HeaderWidth + columnHeader:GetWidth() + self.options.padding
			self.HeaderHeight = math.max(self.HeaderHeight, columnHeader:GetHeight())

		elseif (growDirection == "top" or growDirection == "bottom") then
			self.HeaderWidth =  math.max(self.HeaderWidth, columnHeader:GetWidth())
			self.HeaderHeight = self.HeaderHeight + columnHeader:GetHeight() + self.options.padding
		end

		columnHeader:Show()
		columnHeader.InUse = true
	end,

	--reset column header backdrop
	--@self: main header frame
	ResetColumnHeaderBackdrop = function(self, columnHeader)
		columnHeader:SetBackdrop(self.options.header_backdrop)
		columnHeader:SetBackdropColor(unpack(self.options.header_backdrop_color))
		columnHeader:SetBackdropBorderColor(unpack(self.options.header_backdrop_border_color))
	end,

	--@self: main header frame
	SetBackdropColorForSelectedColumnHeader = function(self, columnHeader)
		columnHeader:SetBackdropColor(unpack(self.options.header_backdrop_color_selected))
	end,

	--clear the column header
	--@self: main header frame
	ClearColumnHeader = function(self, columnHeader)
		columnHeader:SetSize(self.options.header_width, self.options.header_height)
		self:ResetColumnHeaderBackdrop(columnHeader)

		columnHeader:ClearAllPoints()

		columnHeader.Icon:SetTexture("")
		columnHeader.Icon:Hide()
		columnHeader.Text:SetText("")
		columnHeader.Text:Hide()
	end,

	--get the next column header, create one if doesn't exists
	--@self: main header frame
	GetNextHeader = function(self)
		local nextHeader = self.NextHeader
		local columnHeader = self.columnHeadersCreated[nextHeader]

		if (not columnHeader) then
			--create a new column header
			local newHeader = CreateFrame("button", "$parentHeaderIndex" .. nextHeader, self, "BackdropTemplate")
			newHeader:SetScript("OnClick", detailsFramework.HeaderFunctions.OnClick)

			--header icon
			detailsFramework:CreateImage(newHeader, "", self.options.header_height, self.options.header_height, "ARTWORK", nil, "Icon", "$parentIcon")
			--header separator
			detailsFramework:CreateImage(newHeader, "", 1, 1, "ARTWORK", nil, "Separator", "$parentSeparator")
			--header name text
			detailsFramework:CreateLabel(newHeader, "", self.options.text_size, self.options.text_color, "GameFontNormal", "Text", "$parentText", "ARTWORK")
			--header selected and order icon
			detailsFramework:CreateImage(newHeader, self.options.arrow_up_texture, 12, 12, "ARTWORK", nil, "Arrow", "$parentArrow")

			newHeader.Arrow:SetPoint("right", newHeader, "right", -1, 0)

			newHeader.Separator:Hide()
			newHeader.Arrow:Hide()

			self:UpdateSortArrow(newHeader, false, "DESC")

			tinsert(self.columnHeadersCreated, newHeader)
			columnHeader = newHeader
		end

		self:ClearColumnHeader(columnHeader)
		self.NextHeader = self.NextHeader + 1
		return columnHeader
	end,

	NextHeader = 1,
	HeaderWidth = 0,
	HeaderHeight = 0,
}

local default_header_options = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdrop_color = {0, 0, 0, 0.2},
	backdrop_border_color = {0.1, 0.1, 0.1, .2},

	text_color = {1, 1, 1, 1},
	text_size = 10,
	text_shadow = false,
	grow_direction = "RIGHT",
	padding = 2,

	--each piece of the header
	header_backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	header_backdrop_color = {0, 0, 0, 0.5},
	header_backdrop_color_selected = {0.3, 0.3, 0.3, 0.5},
	header_backdrop_border_color = {0, 0, 0, 0},
	header_width = 120,
	header_height = 20,

	arrow_up_texture = [[Interface\Buttons\Arrow-Up-Down]],
	arrow_up_texture_coords = {0, 1, 6/16, 1},
	arrow_up_size = {12, 11},
	arrow_down_texture = [[Interface\Buttons\Arrow-Down-Down]],
	arrow_down_texture_coords = {0, 1, 0, 11/16},
	arrow_down_size = {12, 11},
	arrow_alpha = 0.659,

	use_line_separators = false,
	line_separator_color = {.1, .1, .1, .6},
	line_separator_width = 1,
	line_separator_height = 200,
	line_separator_gap_align = false,
}

function detailsFramework:CreateHeader(parent, headerTable, options, frameName)
	local newHeader = CreateFrame("frame", frameName or "$parentHeaderLine", parent, "BackdropTemplate")

	detailsFramework:Mixin(newHeader, detailsFramework.OptionsFunctions)
	detailsFramework:Mixin(newHeader, detailsFramework.HeaderCoreFunctions)

	newHeader:BuildOptionsTable(default_header_options, options)

	newHeader:SetBackdrop(newHeader.options.backdrop)
	newHeader:SetBackdropColor(unpack(newHeader.options.backdrop_color))
	newHeader:SetBackdropBorderColor(unpack(newHeader.options.backdrop_border_color))

	newHeader:SetHeaderTable(headerTable)

	return newHeader
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--radio group

local default_radiogroup_options = {
	width = 1,
	height = 1,
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdrop_color = {0, 0, 0, 0.2},
	backdrop_border_color = {0.1, 0.1, 0.1, .2},
	is_radio = false,
}

detailsFramework.RadioGroupCoreFunctions = {
	Disable = function(self)
		local frameList = self:GetAllCheckboxes()
		for _, checkbox in ipairs(frameList) do
			checkbox = checkbox.GetCapsule and checkbox:GetCapsule() or checkbox
			checkbox:Disable()
		end
	end,

	Enable = function(self)
		local frameList = self:GetAllCheckboxes()
		for _, checkbox in ipairs(frameList) do
			checkbox = checkbox.GetCapsule and checkbox:GetCapsule() or checkbox
			checkbox:Enable()
		end
	end,

	DeselectAll = function(self)
		local frameList = self:GetAllCheckboxes()
		for _, checkbox in ipairs(frameList) do
			checkbox = checkbox.GetCapsule and checkbox:GetCapsule() or checkbox
			checkbox:SetValue(false)
		end
	end,

	FadeIn = function(self)
		local frameList = self:GetAllCheckboxes()
		for _, checkbox in ipairs(frameList) do
			checkbox:SetAlpha(1)
		end
	end,

	FadeOut = function(self)
		local frameList = self:GetAllCheckboxes()
		for _, checkbox in ipairs(frameList) do
			checkbox:SetAlpha(.7)
		end
	end,

	SetFadeState = function(self, state)
		if (state) then
			self:FadeIn()
		else
			self:FadeOut()
		end
	end,

	GetAllCheckboxes = function(self)
		return {self:GetChildren()}
	end,

	GetCheckbox = function(self, checkboxId)
		local allCheckboxes = self:GetAllCheckboxes()
		local checkbox = allCheckboxes[checkboxId]
		if (not checkbox) then
			checkbox = self:CreateCheckbox()
		end
		return checkbox
	end,

	CreateCheckbox = function(self)
		local checkbox = detailsFramework:CreateSwitch(self, function()end, false, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, detailsFramework:GetTemplate("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
		checkbox:SetAsCheckBox()
		checkbox.Icon = detailsFramework:CreateImage(checkbox, "", 16, 16)
		checkbox.Label = detailsFramework:CreateLabel(checkbox, "")

		return checkbox
	end,

	ResetAllCheckboxes = function(self)
		local radioCheckboxes = self:GetAllCheckboxes()
		for i = 1, #radioCheckboxes do
			local checkBox = radioCheckboxes[i]
			checkBox:Hide()
		end
	end,

	--if the list of checkboxes are a radio group
	RadioOnClick = function(checkbox, fixedParam, value)
		--turn off all checkboxes
		checkbox:GetParent():DeselectAll()

		--turn on the clicked checkbox
		checkbox:SetValue(true)

		--callback
		if (checkbox._callback) then
			detailsFramework:QuickDispatch(checkbox._callback, fixedParam, checkbox._optionid)
		end
	end,

	RefreshCheckbox = function(self, checkbox, optionTable, optionId)
		checkbox = checkbox.GetCapsule and checkbox:GetCapsule() or checkbox

		local setFunc = self.options.is_radio and self.RadioOnClick or optionTable.set
		checkbox:SetSwitchFunction(setFunc)
		checkbox._callback = optionTable.callback
		checkbox._set = self.options.is_radio and optionTable.callback or optionTable.set
		checkbox._optionid = optionId
		checkbox:SetFixedParameter(optionTable.param or optionId)

		local isChecked = type(optionTable.get) == "function" and detailsFramework:Dispatch(optionTable.get) or false
		checkbox:SetValue(isChecked)

		checkbox.Label:SetText(optionTable.name)

		if (optionTable.texture) then
			checkbox.Icon:SetTexture(optionTable.texture)
			checkbox.Icon:SetPoint("left", checkbox, "right", 2, 0)
			checkbox.Label:SetPoint("left", checkbox.Icon, "right", 2, 0)

			if (optionTable.texcoord) then
				checkbox.Icon:SetTexCoord(unpack(optionTable.texcoord))
			else
				checkbox.Icon:SetTexCoord(0, 1, 0, 1)
			end
		else
			checkbox.Icon:SetTexture("")
			checkbox.Label:SetPoint("left", checkbox, "right", 2, 0)
		end
	end,

	Refresh = function(self)
		self:ResetAllCheckboxes()
		local radioOptions = self:GetOptions()
		local radioCheckboxes = self:GetAllCheckboxes()

		for optionId, optionsTable in ipairs(radioOptions) do
			local checkbox = self:GetCheckbox(optionId)
			checkbox.OptionID = optionId
			checkbox:Show()
			self:RefreshCheckbox(checkbox, optionsTable, optionId)
		end

		--sending false to automatically use the radio group children
		self:ArrangeFrames(false, self.AnchorOptions)
	end,

	SetOptions = function(self, radioOptions)
		self.RadioOptionsTable = radioOptions
		self:Refresh()
	end,

	GetOptions = function(self)
		return self.RadioOptionsTable
	end,
}

--[=[
	radionOptions: an index table with options for the radio group {name = "", set = func (self, param, value), param = value, get = func, texture = "", texcoord = {}}
		set function receives as self the checkbox, use :GetParent() to get the radion group frame
		if get function return nil or false the checkbox isn't checked
	name: the name of the frame
	options: override options for default_radiogroup_options table
	anchorOptions: override options for default_framelayout_options table
--]=]
function detailsFramework:CreateCheckboxGroup(parent, radioOptions, name, options, anchorOptions)
	local f = CreateFrame("frame", name, parent, "BackdropTemplate")

	detailsFramework:Mixin(f, detailsFramework.OptionsFunctions)
	detailsFramework:Mixin(f, detailsFramework.RadioGroupCoreFunctions)
	detailsFramework:Mixin(f, detailsFramework.LayoutFrame)

	f:BuildOptionsTable (default_radiogroup_options, options)

	f:SetSize(f.options.width, f.options.height)
	f:SetBackdrop(f.options.backdrop)
	f:SetBackdropColor(unpack(f.options.backdrop_color))
	f:SetBackdropBorderColor(unpack(f.options.backdrop_border_color))

	f.AnchorOptions = anchorOptions or {}

	if (f.options.title) then
		local titleLabel = detailsFramework:CreateLabel(f, f.options.title, detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
		titleLabel:SetPoint("bottomleft", f, "topleft", 0, 2)
		f.Title = titleLabel
	end

	f:SetOptions (radioOptions)

	return f
end

function detailsFramework:CreateRadionGroup(parent, radioOptions, name, options, anchorOptions) --alias for miss spelled old function
	return detailsFramework:CreateRadioGroup(parent, radioOptions, name, options, anchorOptions)
end

function detailsFramework:CreateRadioGroup(parent, radioOptions, name, options, anchorOptions)
	options = options or {}
	options.is_radio = true
	return detailsFramework:CreateCheckboxGroup(parent, radioOptions, name, options, anchorOptions)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--load conditions panel

--this is the table prototype to hold load conditions settings
local default_load_conditions = {
	class = {},
	spec = {},
	race = {},
	talent = {},
	pvptalent = {},
	group = {},
	role = {},
	affix = {},
	encounter_ids = {},
	map_ids = {},
}

local default_load_conditions_frame_options = {
	title = "Details! Framework: Load Conditions",
	name = "Object",
}

function detailsFramework:CreateLoadFilterParser (callback)
	local f = CreateFrame("frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	if IS_WOW_PROJECT_MAINLINE then
		f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		f:RegisterEvent("PLAYER_TALENT_UPDATE")
	end
	f:RegisterEvent("PLAYER_ROLES_ASSIGNED")
	f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if IS_WOW_PROJECT_MAINLINE then
		f:RegisterEvent("CHALLENGE_MODE_START")
	end
	f:RegisterEvent("ENCOUNTER_START")
	f:RegisterEvent("PLAYER_REGEN_ENABLED")

	f:SetScript("OnEvent", function(self, event, ...)
		if (event == "ENCOUNTER_START") then
			local encounterID = ...
			f.EncounterIDCached = encounterID

		elseif (event == "ENCOUNTER_END") then
			f.EncounterIDCached = nil

		elseif (event == "PLAYER_REGEN_ENABLED") then
			--f.EncounterIDCached = nil
			--when the player dies during an encounter, the game is triggering regen enabled

		elseif (event == "PLAYER_SPECIALIZATION_CHANGED") then
			if (DetailsFrameworkLoadConditionsPanel and DetailsFrameworkLoadConditionsPanel:IsShown()) then
				DetailsFrameworkLoadConditionsPanel:Refresh()
			end

			local unit = ...
			if (not unit or not UnitIsUnit("player", unit)) then
				return
			end

		elseif (event == "PLAYER_ROLES_ASSIGNED") then
			local assignedRole = UnitGroupRolesAssigned("player")
			if (assignedRole == "NONE") then
				local spec = DetailsFramework.GetSpecialization()
				if (spec) then
					assignedRole = DetailsFramework.GetSpecializationRole (spec)
				end
			end

			if (detailsFramework.CurrentPlayerRole == assignedRole) then
				return
			end

			detailsFramework.CurrentPlayerRole = assignedRole
		end

		--print("Plater Script Update:", event, ...)

		detailsFramework:QuickDispatch(callback, f.EncounterIDCached)
	end)
end

function detailsFramework:PassLoadFilters(loadTable, encounterID)
	--class
	local passLoadClass
	if (loadTable.class.Enabled) then
		local _, classFileName = UnitClass("player")
		if (not loadTable.class[classFileName]) then
			return false
		else
			passLoadClass = true
		end
	end

	--spec
	if (IS_WOW_PROJECT_MAINLINE and loadTable.spec.Enabled) then
		local canCheckTalents = true

		if (passLoadClass) then
			--if is allowed to load on this class, check if the talents isn't from another class
			local _, classFileName = UnitClass("player")
			local specsForThisClass = detailsFramework:GetClassSpecIDs(classFileName)

			canCheckTalents = false

			for _, specID in ipairs(specsForThisClass) do
				if (loadTable.spec[specID] or loadTable.spec[specID..""]) then
					--theres a talent for this class
					canCheckTalents = true
					break
				end
			end
		end

		if (canCheckTalents) then
			local specIndex = DetailsFramework.GetSpecialization()
			if (specIndex) then
				local specID = DetailsFramework.GetSpecializationInfo(specIndex)
				if not specID or (not loadTable.spec[specID] and not loadTable.spec[specID .. ""]) then
					return false
				end
			else
				return false
			end
		end
	end

	--race
	if (loadTable.race.Enabled) then
		local raceName, raceFileName, raceID = UnitRace ("player")
		if (not loadTable.race [raceFileName]) then
			return false
		end
	end

	--talents
	if (IS_WOW_PROJECT_MAINLINE and loadTable.talent.Enabled) then
		local talentsInUse = detailsFramework:GetCharacterTalents (false, true)
		local hasTalent
		for talentID, _ in pairs(talentsInUse) do
			if talentID and (loadTable.talent [talentID] or loadTable.talent [talentID .. ""]) then
				hasTalent =  true
				break
			end
		end
		if (not hasTalent) then
			return false
		end
	end

	--pvptalent
	if (IS_WOW_PROJECT_MAINLINE and loadTable.pvptalent.Enabled) then
		local talentsInUse = detailsFramework:GetCharacterPvPTalents (false, true)
		local hasTalent
		for talentID, _ in pairs(talentsInUse) do
			if talentID and (loadTable.pvptalent [talentID] or loadTable.pvptalent [talentID .. ""]) then
				hasTalent =  true
				break
			end
		end
		if (not hasTalent) then
			return false
		end
	end

	--group
	if (loadTable.group.Enabled) then
		local _, zoneType = GetInstanceInfo()
		if (not loadTable.group [zoneType]) then
			return
		end
	end

	--role
	if (loadTable.role.Enabled) then
		local assignedRole = UnitGroupRolesAssigned("player")
		if (assignedRole == "NONE") then
			local spec = DetailsFramework.GetSpecialization()
			if (spec) then
				assignedRole = DetailsFramework.GetSpecializationRole (spec)
			end
		end
		if (not loadTable.role [assignedRole]) then
			return false
		end
	end

	--affix
	if (IS_WOW_PROJECT_MAINLINE and loadTable.affix.Enabled) then
		local isInMythicDungeon = C_ChallengeMode.IsChallengeModeActive()
		if (not isInMythicDungeon) then
			return false
		end

		local level, affixes, wasEnergized = C_ChallengeMode.GetActiveKeystoneInfo()
		local hasAffix = false
		for _, affixID in ipairs(affixes) do
			if affixID and (loadTable.affix [affixID] or loadTable.affix [affixID .. ""]) then
				hasAffix = true
				break
			end
		end

		if (not hasAffix) then
			return false
		end
	end

	--encounter id
	if (loadTable.encounter_ids.Enabled) then
		if (not encounterID) then
			return
		end
		local hasEncounter
		for _, ID in pairs(loadTable.encounter_ids) do
			if (ID == encounterID) then
				hasEncounter = true
				break
			end
			if (not hasEncounter) then
				return false
			end
		end
	end

	--map id
	if (loadTable.map_ids.Enabled) then
		local _, _, _, _, _, _, _, zoneMapID = GetInstanceInfo()
		local uiMapID = C_Map.GetBestMapForUnit ("player")

		local hasMapID
		for _, ID in pairs(loadTable.map_ids) do
			if (ID == zoneMapID or ID == uiMapID) then
				hasMapID = true
				break
			end
			if (not hasMapID) then
				return false
			end
		end
	end

	return true
end

--this func will deploy the default values from the prototype into the config table
function detailsFramework:UpdateLoadConditionsTable(configTable)
	configTable = configTable or {}
	detailsFramework.table.deploy(configTable, default_load_conditions)
	return configTable
end

--/run Plater.OpenOptionsPanel()PlaterOptionsPanelContainer:SelectIndex (Plater, 14)

function detailsFramework:OpenLoadConditionsPanel(optionsTable, callback, frameOptions)
	frameOptions = frameOptions or {}
	detailsFramework.table.deploy(frameOptions, default_load_conditions_frame_options)

	detailsFramework:UpdateLoadConditionsTable(optionsTable)

	if (not DetailsFrameworkLoadConditionsPanel) then
		local loadConditionsFrame = detailsFramework:CreateSimplePanel(UIParent, 970, 505, "Load Conditions", "DetailsFrameworkLoadConditionsPanel")
		loadConditionsFrame:SetBackdropColor(0, 0, 0, 1)
		loadConditionsFrame.AllRadioGroups = {}
		loadConditionsFrame.AllTextEntries = {}
		loadConditionsFrame.OptionsTable = optionsTable

		detailsFramework:ApplyStandardBackdrop(loadConditionsFrame, false, 1.1)

		local xStartAt = 10
		local x2StartAt = 500
		local anchorPositions = {
			class = {xStartAt, -70},
			spec = {xStartAt, -170},
			race = {xStartAt, -210},
			role = {xStartAt, -310},
			talent = {xStartAt, -350},
			pvptalent = {x2StartAt, -70},
			group = {x2StartAt, -210},
			affix = {x2StartAt, -270},
			encounter_ids = {x2StartAt, -420},
			map_ids = {x2StartAt, -460},
		}

		local editingLabel = detailsFramework:CreateLabel(loadConditionsFrame, "Load Conditions For:")
		local editingWhatLabel = detailsFramework:CreateLabel(loadConditionsFrame, "")
		editingLabel:SetPoint("topleft", loadConditionsFrame, "topleft", 10, -35)
		editingWhatLabel:SetPoint("left", editingLabel, "right", 2, 0)

		--this label store the name of what is being edited
		loadConditionsFrame.EditingLabel = editingWhatLabel

		--when the user click on an option, run the callback
			loadConditionsFrame.RunCallback = function()
				detailsFramework:Dispatch (loadConditionsFrame.CallbackFunc)
			end

		--when the user click on an option or when the panel is opened
		--check if there's an option enabled and fadein all options, fadeout otherwise
			loadConditionsFrame.OnRadioStateChanged = function(radioGroup, subConfigTable)
				subConfigTable.Enabled = nil
				subConfigTable.Enabled = next (subConfigTable) and true or nil
				radioGroup:SetFadeState (subConfigTable.Enabled)
			end

		--create the radio group for character class
			loadConditionsFrame.OnRadioCheckboxClick = function(self, key, value)
				--hierarchy: DBKey ["class"] key ["HUNTER"] value TRUE
				local DBKey = self:GetParent().DBKey
				loadConditionsFrame.OptionsTable [DBKey] [key and key .. ""] = value and true or nil
				if not value then -- cleanup "number" type values
					loadConditionsFrame.OptionsTable [DBKey] [key] = nil
				end
				loadConditionsFrame.OnRadioStateChanged (self:GetParent(), loadConditionsFrame.OptionsTable [DBKey])
				loadConditionsFrame.RunCallback()
			end

		--create the radio group for classes
			local classes = {}
			for _, classTable in pairs(detailsFramework:GetClassList()) do
				tinsert(classes, {
					name = classTable.Name,
					set = loadConditionsFrame.OnRadioCheckboxClick,
					param = classTable.FileString,
					get = function() return loadConditionsFrame.OptionsTable.class[classTable.FileString] end,
					texture = classTable.Texture,
					texcoord = classTable.TexCoord,
				})
			end

			local classGroup = detailsFramework:CreateCheckboxGroup (loadConditionsFrame, classes, name, {width = 200, height = 200, title = "Character Class"}, {offset_x = 130, amount_per_line = 3})
			classGroup:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.class[1], anchorPositions.class[2])
			classGroup.DBKey = "class"
			tinsert(loadConditionsFrame.AllRadioGroups, classGroup)

		--create the radio group for character spec
			if IS_WOW_PROJECT_MAINLINE then
				local specs = {}
				for _, specID in ipairs(detailsFramework:GetClassSpecIDs(select(2, UnitClass("player")))) do
					local specID, specName, specDescription, specIcon, specBackground, specRole, specClass = DetailsFramework.GetSpecializationInfoByID (specID)
					tinsert(specs, {
						name = specName,
						set = loadConditionsFrame.OnRadioCheckboxClick,
						param = specID,
						get = function() return loadConditionsFrame.OptionsTable.spec[specID] or loadConditionsFrame.OptionsTable.spec[specID..""] end,
						texture = specIcon,
					})
				end
				local specGroup = detailsFramework:CreateCheckboxGroup (loadConditionsFrame, specs, name, {width = 200, height = 200, title = "Character Spec"}, {offset_x = 130, amount_per_line = 4})
				specGroup:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.spec[1], anchorPositions.spec[2])
				specGroup.DBKey = "spec"
				tinsert(loadConditionsFrame.AllRadioGroups, specGroup)
			end

		--create radio group for character races
			local raceList = {}
			for _, raceTable in ipairs(detailsFramework:GetCharacterRaceList()) do
				tinsert(raceList, {
					name = raceTable.Name,
					set = loadConditionsFrame.OnRadioCheckboxClick,
					param = raceTable.FileString,
					get = function() return loadConditionsFrame.OptionsTable.race [raceTable.FileString] end,
				})
			end
			local raceGroup = detailsFramework:CreateCheckboxGroup (loadConditionsFrame, raceList, name, {width = 200, height = 200, title = "Character Race"})
			raceGroup:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.race [1], anchorPositions.race [2])
			raceGroup.DBKey = "race"
			tinsert(loadConditionsFrame.AllRadioGroups, raceGroup)

		--create radio group for talents
			if IS_WOW_PROJECT_MAINLINE then
				local talentList = {}
				for _, talentTable in ipairs(detailsFramework:GetCharacterTalents()) do
					if talentTable.ID then
						tinsert(talentList, {
							name = talentTable.Name,
							set = loadConditionsFrame.OnRadioCheckboxClick,
							param = talentTable.ID,
							get = function() return loadConditionsFrame.OptionsTable.talent [talentTable.ID] or loadConditionsFrame.OptionsTable.talent [talentTable.ID .. ""] end,
							texture = talentTable.Texture,
						})
					end
				end
				local talentGroup = detailsFramework:CreateCheckboxGroup (loadConditionsFrame, talentList, name, {width = 200, height = 200, title = "Characer Talents"}, {offset_x = 150, amount_per_line = 3})
				talentGroup:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.talent [1], anchorPositions.talent [2])
				talentGroup.DBKey = "talent"
				tinsert(loadConditionsFrame.AllRadioGroups, talentGroup)
				loadConditionsFrame.TalentGroup = talentGroup

				do
					--create a frame to show talents selected in other specs or characters
					local otherTalents = CreateFrame("frame", nil, loadConditionsFrame, "BackdropTemplate")
					otherTalents:SetSize(26, 26)
					otherTalents:SetPoint("left", talentGroup.Title.widget, "right", 10, -2)
					otherTalents.Texture = detailsFramework:CreateImage(otherTalents, [[Interface\BUTTONS\AdventureGuideMicrobuttonAlert]], 24, 24)
					otherTalents.Texture:SetAllPoints()

					local removeTalent = function(_, _, talentID)
						loadConditionsFrame.OptionsTable.talent [talentID] = nil
						GameCooltip2:Hide()
						loadConditionsFrame.OnRadioStateChanged (talentGroup, loadConditionsFrame.OptionsTable [talentGroup.DBKey])
						loadConditionsFrame.CanShowTalentWarning()
					end

					local buildTalentMenu = function()
						local playerTalents = detailsFramework:GetCharacterTalents()
						local indexedTalents = {}
						for _, talentTable in ipairs(playerTalents) do
							tinsert(indexedTalents, talentTable.ID)
						end

						--talents selected to load
						GameCooltip2:AddLine("select a talent to remove it (added from a different spec or character)", "", 1, "orange", "orange", 9)
						GameCooltip2:AddLine("$div", nil, nil, -1, -1)

						for talentID, _ in pairs(loadConditionsFrame.OptionsTable.talent) do
							if (type(talentID) == "number" and not detailsFramework.table.find (indexedTalents, talentID)) then
								local talentID, name, texture, selected, available = GetTalentInfoByID (talentID)
								if (name) then
									GameCooltip2:AddLine(name)
									GameCooltip2:AddIcon (texture, 1, 1, 16, 16, .1, .9, .1, .9)
									GameCooltip2:AddMenu (1, removeTalent, talentID)
								end
							end
						end
					end

					otherTalents.CoolTip = {
						Type = "menu",
						BuildFunc = buildTalentMenu,
						OnEnterFunc = function(self) end,
						OnLeaveFunc = function(self) end,
						FixedValue = "none",
						ShowSpeed = 0.05,
						Options = function()
							GameCooltip2:SetOption("TextFont", "Friz Quadrata TT")
							GameCooltip2:SetOption("TextColor", "orange")
							GameCooltip2:SetOption("TextSize", 12)
							GameCooltip2:SetOption("FixedWidth", 220)
							GameCooltip2:SetOption("ButtonsYMod", -4)
							GameCooltip2:SetOption("YSpacingMod", -4)
							GameCooltip2:SetOption("IgnoreButtonAutoHeight", true)

							GameCooltip2:SetColor (1, 0.5, 0.5, 0.5, 0)

							local preset2_backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], edgeFile = [[Interface\Buttons\WHITE8X8]], tile = true, edgeSize = 1, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}}
							local gray_table = {0.37, 0.37, 0.37, 0.95}
							local black_table = {0.2, 0.2, 0.2, 1}
							GameCooltip2:SetBackdrop(1, preset2_backdrop, gray_table, black_table)
							GameCooltip2:SetBackdrop(2, preset2_backdrop, gray_table, black_table)
						end,
					}
					GameCooltip2:CoolTipInject (otherTalents)

					function loadConditionsFrame.CanShowTalentWarning()
						local playerTalents = detailsFramework:GetCharacterTalents()
						local indexedTalents = {}
						for _, talentTable in ipairs(playerTalents) do
							tinsert(indexedTalents, talentTable.ID)
						end
						for talentID, _ in pairs(loadConditionsFrame.OptionsTable.talent) do
							if (type(talentID) == "number" and not detailsFramework.table.find (indexedTalents, talentID)) then
								otherTalents:Show()
								return
							end
						end
						otherTalents:Hide()
					end
				end
			end

		--create radio group for pvp talents
			if IS_WOW_PROJECT_MAINLINE then
				local pvpTalentList = {}
				for _, talentTable in ipairs(detailsFramework:GetCharacterPvPTalents()) do
					tinsert(pvpTalentList, {
						name = talentTable.Name,
						set = loadConditionsFrame.OnRadioCheckboxClick,
						param = talentTable.ID,
						get = function() return loadConditionsFrame.OptionsTable.pvptalent [talentTable.ID] or loadConditionsFrame.OptionsTable.pvptalent [talentTable.ID .. ""] end,
						texture = talentTable.Texture,
					})
				end
				local pvpTalentGroup = detailsFramework:CreateCheckboxGroup (loadConditionsFrame, pvpTalentList, name, {width = 200, height = 200, title = "Characer PvP Talents"}, {offset_x = 150, amount_per_line = 3})
				pvpTalentGroup:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.pvptalent [1], anchorPositions.pvptalent [2])
				pvpTalentGroup.DBKey = "pvptalent"
				tinsert(loadConditionsFrame.AllRadioGroups, pvpTalentGroup)
				loadConditionsFrame.PvPTalentGroup = pvpTalentGroup

				do
					--create a frame to show talents selected in other specs or characters
					local otherTalents = CreateFrame("frame", nil, loadConditionsFrame, "BackdropTemplate")
					otherTalents:SetSize(26, 26)
					otherTalents:SetPoint("left", pvpTalentGroup.Title.widget, "right", 10, -2)
					otherTalents.Texture = detailsFramework:CreateImage(otherTalents, [[Interface\BUTTONS\AdventureGuideMicrobuttonAlert]], 24, 24)
					otherTalents.Texture:SetAllPoints()

					local removeTalent = function(_, _, talentID)
						loadConditionsFrame.OptionsTable.pvptalent [talentID] = nil
						GameCooltip2:Hide()
						loadConditionsFrame.OnRadioStateChanged (pvpTalentGroup, loadConditionsFrame.OptionsTable [pvpTalentGroup.DBKey])
						loadConditionsFrame.CanShowPvPTalentWarning()
					end

					local buildTalentMenu = function()
						local playerTalents = detailsFramework:GetCharacterPvPTalents()
						local indexedTalents = {}
						for _, talentTable in ipairs(playerTalents) do
							tinsert(indexedTalents, talentTable.ID)
						end

						--talents selected to load
						GameCooltip2:AddLine("select a talent to remove it (added from a different spec or character)", "", 1, "orange", "orange", 9)
						GameCooltip2:AddLine("$div", nil, nil, -1, -1)

						for talentID, _ in pairs(loadConditionsFrame.OptionsTable.pvptalent) do
							if (type(talentID) == "number" and not detailsFramework.table.find (indexedTalents, talentID)) then
								local _, name, texture = GetPvpTalentInfoByID (talentID)
								if (name) then
									GameCooltip2:AddLine(name)
									GameCooltip2:AddIcon (texture, 1, 1, 16, 16, .1, .9, .1, .9)
									GameCooltip2:AddMenu (1, removeTalent, talentID)
								end
							end
						end
					end

					otherTalents.CoolTip = {
						Type = "menu",
						BuildFunc = buildTalentMenu,
						OnEnterFunc = function(self) end,
						OnLeaveFunc = function(self) end,
						FixedValue = "none",
						ShowSpeed = 0.05,
						Options = function()
							GameCooltip2:SetOption("TextFont", "Friz Quadrata TT")
							GameCooltip2:SetOption("TextColor", "orange")
							GameCooltip2:SetOption("TextSize", 12)
							GameCooltip2:SetOption("FixedWidth", 220)
							GameCooltip2:SetOption("ButtonsYMod", -4)
							GameCooltip2:SetOption("YSpacingMod", -4)
							GameCooltip2:SetOption("IgnoreButtonAutoHeight", true)

							GameCooltip2:SetColor (1, 0.5, 0.5, 0.5, 0)

							local preset2_backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeFile = [[Interface\Buttons\WHITE8X8]], tile = true, edgeSize = 1, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}}
							local gray_table = {0.37, 0.37, 0.37, 0.95}
							local black_table = {0.2, 0.2, 0.2, 1}
							GameCooltip2:SetBackdrop(1, preset2_backdrop, gray_table, black_table)
							GameCooltip2:SetBackdrop(2, preset2_backdrop, gray_table, black_table)
						end,
					}
					GameCooltip2:CoolTipInject (otherTalents)

					function loadConditionsFrame.CanShowPvPTalentWarning()
						local playerTalents = detailsFramework:GetCharacterPvPTalents()
						local indexedTalents = {}
						for _, talentTable in ipairs(playerTalents) do
							tinsert(indexedTalents, talentTable.ID)
						end
						for talentID, _ in pairs(loadConditionsFrame.OptionsTable.pvptalent) do
							if (type(talentID) == "number" and not detailsFramework.table.find (indexedTalents, talentID)) then
								otherTalents:Show()
								return
							end
						end
						otherTalents:Hide()
					end
				end
			end

		--create radio for group types
			local groupTypes = {}
			for _, groupTable in ipairs(detailsFramework:GetGroupTypes()) do
				tinsert(groupTypes, {
					name = groupTable.Name,
					set = loadConditionsFrame.OnRadioCheckboxClick,
					param = groupTable.ID,
					get = function() return loadConditionsFrame.OptionsTable.group [groupTable.ID] or loadConditionsFrame.OptionsTable.group [groupTable.ID .. ""] end,
				})
			end
			local groupTypesGroup = detailsFramework:CreateCheckboxGroup (loadConditionsFrame, groupTypes, name, {width = 200, height = 200, title = "Group Types"})
			groupTypesGroup:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.group [1], anchorPositions.group [2])
			groupTypesGroup.DBKey = "group"
			tinsert(loadConditionsFrame.AllRadioGroups, groupTypesGroup)

		--create radio for character roles
			local roleTypes = {}
			for _, roleTable in ipairs(detailsFramework:GetRoleTypes()) do
				tinsert(roleTypes, {
					name = roleTable.Texture .. " " .. roleTable.Name,
					set = loadConditionsFrame.OnRadioCheckboxClick,
					param = roleTable.ID,
					get = function() return loadConditionsFrame.OptionsTable.role [roleTable.ID] or loadConditionsFrame.OptionsTable.role [roleTable.ID .. ""] end,
				})
			end
			local roleTypesGroup = detailsFramework:CreateCheckboxGroup (loadConditionsFrame, roleTypes, name, {width = 200, height = 200, title = "Role Types"})
			roleTypesGroup:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.role [1], anchorPositions.role [2])
			roleTypesGroup.DBKey = "role"
			tinsert(loadConditionsFrame.AllRadioGroups, roleTypesGroup)

		--create radio group for mythic+ affixes
			if IS_WOW_PROJECT_MAINLINE then
				local affixes = {}
				for i = 2, 1000 do
					local affixName, desc, texture = C_ChallengeMode.GetAffixInfo (i)
					if (affixName) then
						tinsert(affixes, {
							name = affixName,
							set = loadConditionsFrame.OnRadioCheckboxClick,
							param = i,
							get = function() return loadConditionsFrame.OptionsTable.affix [i] or loadConditionsFrame.OptionsTable.affix [i .. ""] end,
							texture = texture,
						})
					end
				end
				local affixTypesGroup = detailsFramework:CreateCheckboxGroup (loadConditionsFrame, affixes, name, {width = 200, height = 200, title = "M+ Affixes"})
				affixTypesGroup:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.affix [1], anchorPositions.affix [2])
				affixTypesGroup.DBKey = "affix"
				tinsert(loadConditionsFrame.AllRadioGroups, affixTypesGroup)
			end

		--text entries functions
			local textEntryRefresh = function(self)
				local idList = loadConditionsFrame.OptionsTable [self.DBKey]
				self:SetText("")
				for _, id in pairs(idList) do
					if tonumber(id) then
						self:SetText(self:GetText() .. " " .. id)
					end
				end
				self:SetText(self:GetText():gsub("^ ", ""))
			end

			local textEntryOnEnterPressed = function(_, self)
				wipe (loadConditionsFrame.OptionsTable [self.DBKey])
				local text = self:GetText()

				for _, ID in ipairs({strsplit(" ", text)}) do
					ID = detailsFramework:trim (ID)
					ID = tonumber(ID)
					if (ID) then
						tinsert(loadConditionsFrame.OptionsTable [self.DBKey], ID)
						loadConditionsFrame.OptionsTable [self.DBKey].Enabled = true
					end
				end
			end

		--create the text entry to type the encounter ID
			local encounterIDLabel = detailsFramework:CreateLabel(loadConditionsFrame, "Encounter ID", detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
			local encounterIDEditbox = detailsFramework:CreateTextEntry(loadConditionsFrame, function()end, 200, 20, "EncounterEditbox", _, _, detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			encounterIDLabel:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.encounter_ids [1], anchorPositions.encounter_ids [2])
			encounterIDEditbox:SetPoint("topleft", encounterIDLabel, "bottomleft", 0, -2)
			encounterIDEditbox.DBKey = "encounter_ids"
			encounterIDEditbox.Refresh = textEntryRefresh
			encounterIDEditbox.tooltip = "Enter multiple IDs separating with a whitespace.\nExample: 35 45 95\n\nSanctum of Domination:\n"
			for _, encounterTable in ipairs(detailsFramework:GetCLEncounterIDs()) do
				encounterIDEditbox.tooltip = encounterIDEditbox.tooltip .. encounterTable.ID .. " - " .. encounterTable.Name .. "\n"
			end
			encounterIDEditbox:SetHook("OnEnterPressed", textEntryOnEnterPressed)
			tinsert(loadConditionsFrame.AllTextEntries, encounterIDEditbox)

		--create the text entry for map ID
			local mapIDLabel = detailsFramework:CreateLabel(loadConditionsFrame, "Map ID", detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
			local mapIDEditbox = detailsFramework:CreateTextEntry(loadConditionsFrame, function()end, 200, 20, "MapEditbox", _, _, detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			mapIDLabel:SetPoint("topleft", loadConditionsFrame, "topleft", anchorPositions.map_ids [1], anchorPositions.map_ids [2])
			mapIDEditbox:SetPoint("topleft", mapIDLabel, "bottomleft", 0, -2)
			mapIDEditbox.DBKey = "map_ids"
			mapIDEditbox.Refresh = textEntryRefresh
			mapIDEditbox.tooltip = "Enter multiple IDs separating with a whitespace\nExample: 35 45 95"
			mapIDEditbox:SetHook("OnEnterPressed", textEntryOnEnterPressed)
			tinsert(loadConditionsFrame.AllTextEntries, mapIDEditbox)

		function loadConditionsFrame.Refresh (self)
			if IS_WOW_PROJECT_MAINLINE then
				--update the talents (might have changed if the player changed its specialization)
				local talentList = {}
				for _, talentTable in ipairs(detailsFramework:GetCharacterTalents()) do
					if talentTable.ID then
						tinsert(talentList, {
							name = talentTable.Name,
							set = DetailsFrameworkLoadConditionsPanel.OnRadioCheckboxClick,
							param = talentTable.ID,
							get = function() return DetailsFrameworkLoadConditionsPanel.OptionsTable.talent [talentTable.ID] or DetailsFrameworkLoadConditionsPanel.OptionsTable.talent [talentTable.ID .. ""] end,
							texture = talentTable.Texture,
						})
					end
				end
				DetailsFrameworkLoadConditionsPanel.TalentGroup:SetOptions (talentList)
			end

			if IS_WOW_PROJECT_MAINLINE then
				local pvpTalentList = {}
				for _, talentTable in ipairs(detailsFramework:GetCharacterPvPTalents()) do
					tinsert(pvpTalentList, {
						name = talentTable.Name,
						set = DetailsFrameworkLoadConditionsPanel.OnRadioCheckboxClick,
						param = talentTable.ID,
						get = function() return DetailsFrameworkLoadConditionsPanel.OptionsTable.pvptalent [talentTable.ID] or DetailsFrameworkLoadConditionsPanel.OptionsTable.pvptalent [talentTable.ID .. ""] end,
						texture = talentTable.Texture,
					})
				end
				DetailsFrameworkLoadConditionsPanel.PvPTalentGroup:SetOptions (pvpTalentList)
			end

			--refresh the radio group
			for _, radioGroup in ipairs(DetailsFrameworkLoadConditionsPanel.AllRadioGroups) do
				radioGroup:Refresh()
				DetailsFrameworkLoadConditionsPanel.OnRadioStateChanged (radioGroup, DetailsFrameworkLoadConditionsPanel.OptionsTable [radioGroup.DBKey])
			end

			--refresh text entries
			for _, textEntry in ipairs(DetailsFrameworkLoadConditionsPanel.AllTextEntries) do
				textEntry:Refresh()
			end

			if IS_WOW_PROJECT_MAINLINE then
				DetailsFrameworkLoadConditionsPanel.CanShowTalentWarning()
				DetailsFrameworkLoadConditionsPanel.CanShowPvPTalentWarning()
			end
		end

	end

	--set the options table
	DetailsFrameworkLoadConditionsPanel.OptionsTable = optionsTable

	--set the callback func
	DetailsFrameworkLoadConditionsPanel.CallbackFunc = callback
	DetailsFrameworkLoadConditionsPanel.OptionsTable = optionsTable

	--set title
	DetailsFrameworkLoadConditionsPanel.EditingLabel:SetText(frameOptions.name)
	DetailsFrameworkLoadConditionsPanel.Title:SetText(frameOptions.title)

	--show the panel to the user
	DetailsFrameworkLoadConditionsPanel:Show()

	DetailsFrameworkLoadConditionsPanel:Refresh()
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--simple data scroll

detailsFramework.DataScrollFunctions = {
	RefreshScroll = function(self, data, offset, totalLines)
		local filter = self.Filter
		local currentData = {}
		if (type(filter) == "string" and filter ~= "") then
			for i = 1, #data do
				for o = 1, #data[i] do
					if (data[i][o]:find(filter)) then
						tinsert(currentData, data[i])
						break
					end
				end
			end
		else
			currentData = data
		end

		if (self.SortAlphabetical) then
			table.sort (currentData, function(t1, t2) return t1[1] < t2[1] end)
		end

		--update the scroll
		for i = 1, totalLines do
			local index = i + offset
			local thisData = currentData [index]
			if (thisData) then
				local line = self:GetLine (i)
				line:Update (index, thisData)
			end
		end
	end,

	CreateLine = function(self, index)
		--create a new line
		local line = CreateFrame("button", "$parentLine" .. index, self, "BackdropTemplate")
		line.Update = self.options.update_line_func

		--set its parameters
		line:SetPoint("topleft", self, "topleft", 1, -((index-1) * (self.options.line_height+1)) - 1)
		line:SetSize(self.options.width - 2, self.options.line_height)
		line:RegisterForClicks ("LeftButtonDown", "RightButtonDown")

		line:SetScript("OnEnter",	self.options.on_enter)
		line:SetScript("OnLeave",	self.options.on_leave)
		line:SetScript("OnClick",	self.options.on_click)

		line:SetBackdrop(self.options.backdrop)
		line:SetBackdropColor(unpack(self.options.backdrop_color))
		line:SetBackdropBorderColor(unpack(self.options.backdrop_border_color))

		local title = detailsFramework:CreateLabel(line, "", detailsFramework:GetTemplate("font", self.options.title_template))
		local date = detailsFramework:CreateLabel(line, "", detailsFramework:GetTemplate("font", self.options.title_template))
		local text = detailsFramework:CreateLabel(line, "", detailsFramework:GetTemplate("font", self.options.text_tempate))

		title.textsize = 14
		date.textsize = 14
		text:SetSize(self.options.width - 20, self.options.line_height)
		text:SetJustifyV ("top")

		--setup anchors
		if (self.options.show_title) then
			title:SetPoint("topleft", line, "topleft", 2, 0)
			date:SetPoint("topright", line, "topright", -2, 0)
			text:SetPoint("topleft", title, "bottomleft", 0, -4)
		else
			text:SetPoint("topleft", line, "topleft", 2, 0)
		end

		line.Title = title
		line.Date = date
		line.Text = text

		line.backdrop_color = self.options.backdrop_color or {.1, .1, .1, .3}
		line.backdrop_color_highlight = self.options.backdrop_color_highlight or {.3, .3, .3, .5}

		return line
	end,

	LineOnEnter = function(self)
		self:SetBackdropColor(unpack(self.backdrop_color_highlight))
	end,
	LineOnLeave = function(self)
		self:SetBackdropColor(unpack(self.backdrop_color))
	end,

	OnClick = function(self)

	end,

	UpdateLine = function(line, lineIndex, data)
		local parent = line:GetParent()

		if (parent.options.show_title) then
			line.Title.text = data [2] or ""
			line.Date.text = data [3] or ""
			line.Text.text = data [4] or ""
		else
			line.Text.text = data [2] or ""
		end

		if (line:GetParent().OnUpdateLineHook) then
			detailsFramework:CoreDispatch((line:GetName() or "ScrollBoxDataScrollUpdateLineHook") .. ":UpdateLineHook()", line:GetParent().OnUpdateLineHook, line, lineIndex, data)
		end
	end,
}

local default_datascroll_options = {
	width = 400,
	height = 700,
	line_amount = 10,
	line_height = 20,

	show_title = true,

	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdrop_color = {0, 0, 0, 0.2},
	backdrop_color_highlight = {.2, .2, .2, 0.4},
	backdrop_border_color = {0.1, 0.1, 0.1, .2},

	title_template = "ORANGE_FONT_TEMPLATE",
	text_tempate = "OPTIONS_FONT_TEMPLATE",

	create_line_func = detailsFramework.DataScrollFunctions.CreateLine,
	update_line_func = detailsFramework.DataScrollFunctions.UpdateLine,
	refresh_func = detailsFramework.DataScrollFunctions.RefreshScroll,
	on_enter = detailsFramework.DataScrollFunctions.LineOnEnter,
	on_leave = detailsFramework.DataScrollFunctions.LineOnLeave,
	on_click =  detailsFramework.DataScrollFunctions.OnClick,

	data = {},
}

--[=[
	Create a scroll frame to show text in an organized way
	Functions in the options table can be overritten to customize the layout
	@parent = the parent of the frame
	@name = the frame name to use in the CreateFrame call
	@options = options table to override default values from the table above
--]=]
function detailsFramework:CreateDataScrollFrame (parent, name, options)
	--call the mixin with a dummy table to built the default options before the frame creation
	--this is done because CreateScrollBox needs parameters at creation time
	local optionsTable = {}
	detailsFramework.OptionsFunctions.BuildOptionsTable (optionsTable, default_datascroll_options, options)
	optionsTable = optionsTable.options

	--scroll frame
	local newScroll = detailsFramework:CreateScrollBox (parent, name, optionsTable.refresh_func, optionsTable.data, optionsTable.width, optionsTable.height, optionsTable.line_amount, optionsTable.line_height)
	detailsFramework:ReskinSlider(newScroll)

	detailsFramework:Mixin(newScroll, detailsFramework.OptionsFunctions)
	detailsFramework:Mixin(newScroll, detailsFramework.LayoutFrame)

	newScroll:BuildOptionsTable (default_datascroll_options, options)

	--create the scrollbox lines
	for i = 1, newScroll.options.line_amount do
		newScroll:CreateLine (newScroll.options.create_line_func)
	end

	newScroll:Refresh()

	return newScroll
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--"WHAT's NEW" window

local default_newsframe_options = {
	width = 400,
	height = 700,

	line_amount = 16,
	line_height = 40,

	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdrop_color = {0, 0, 0, 0.2},
	backdrop_border_color = {0.1, 0.1, 0.1, .2},

	title = "What's New?",
	show_title = true,
}

detailsFramework.NewsFrameFunctions = {

}

--[=[
	Get the amount of news that the player didn't see yet
	@newsTable = an indexed table of tables
	@lastNewsTime = last time the player opened the news window
--]=]
function detailsFramework:GetNumNews (newsTable, lastNewsTime)
	local now = time()
	local nonReadNews = 0

	for _, news in ipairs(newsTable) do
		if (news[1] > lastNewsTime) then
			nonReadNews = nonReadNews + 1
		end
	end

	return nonReadNews
end

--[=[
	Creates a panel with a scroll to show texts organized in separated lines
	@parent =  the parent of the frame
	@name = the frame name to use in the CreateFrame call
	@options = options table to override default values from the table above
	@newsTable = an indexed table of tables
	@db = (optional) an empty table from the addon database to store the position of the frame between game sessions
--]=]
function detailsFramework:CreateNewsFrame (parent, name, options, newsTable, db)

	local f = detailsFramework:CreateSimplePanel(parent, 400, 700, options and options.title or default_newsframe_options.title, name, {UseScaleBar = db and true}, db)
	f:SetFrameStrata("MEDIUM")
	detailsFramework:ApplyStandardBackdrop(f)

	detailsFramework:Mixin(f, detailsFramework.OptionsFunctions)
	detailsFramework:Mixin(f, detailsFramework.LayoutFrame)

	f:BuildOptionsTable (default_newsframe_options, options)

	f:SetSize(f.options.width, f.options.height)
	f:SetBackdrop(f.options.backdrop)
	f:SetBackdropColor(unpack(f.options.backdrop_color))
	f:SetBackdropBorderColor(unpack(f.options.backdrop_border_color))

	local scrollOptions = {
		data = newsTable,
		width = f.options.width - 32, --frame distance from walls and scroll bar space
		height = f.options.height - 40 + (not f.options.show_title and 20 or 0),
		line_amount = f.options.line_amount,
		line_height = f.options.line_height,
	}
	local newsScroll = detailsFramework:CreateDataScrollFrame (f, "$parentScroll", scrollOptions)

	if (not f.options.show_title) then
		f.TitleBar:Hide()
		newsScroll:SetPoint("topleft", f, "topleft", 5, -10)
	else
		newsScroll:SetPoint("topleft", f, "topleft", 5, -30)
	end

	f.NewsScroll = newsScroll

	return f
end



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--statusbar info

--[[
	authorTable = {
		{
			authorName = "author name 1",
			link = "twitter.com/author1Handle",
		}
	}
]]

function detailsFramework:BuildStatusbarAuthorInfo(f, addonBy, authorsNameString)
	local authorName = detailsFramework:CreateLabel(f, "" .. (addonBy or "An addon by ") .. "|cFFFFFFFF" .. (authorsNameString or "Terciob") .. "|r")
	authorName.textcolor = "silver"
	local discordLabel = detailsFramework:CreateLabel(f, "Discord: ")
	discordLabel.textcolor = "silver"

	local options_dropdown_template = detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local discordTextEntry = detailsFramework:CreateTextEntry(f, function()end, 200, 18, "DiscordTextBox", _, _, options_dropdown_template)
	discordTextEntry:SetText("https://discord.gg/AGSzAZX")
	discordTextEntry:SetFrameLevel(5000)

	authorName:SetPoint("left", f, "left", 2, 0)
	discordLabel:SetPoint("left", authorName, "right", 20, 0)
	discordTextEntry:SetPoint("left", discordLabel, "right", 2, 0)

	--format
	authorName:SetAlpha(.6)
	discordLabel:SetAlpha(.6)
	discordTextEntry:SetAlpha(.6)
	discordTextEntry:SetBackdropBorderColor(1, 1, 1, 0)

	discordTextEntry:SetHook("OnEditFocusGained", function()
		discordTextEntry:HighlightText()
	end)

	f.authorName = authorName
	f.discordLabel = discordLabel
	f.discordTextEntry = discordTextEntry
end

local statusbar_default_options = {
	attach = "bottom", --bottomleft from statusbar attach to bottomleft of the frame | other option is "top": topleft attach to bottomleft
}

function detailsFramework:CreateStatusBar(f, options)
	local statusBar = CreateFrame("frame", nil, f, "BackdropTemplate")

	detailsFramework:Mixin(statusBar, detailsFramework.OptionsFunctions)
	detailsFramework:Mixin(statusBar, detailsFramework.LayoutFrame)

	statusBar:BuildOptionsTable (statusbar_default_options, options)

	if (statusBar.options.attach == "bottom") then
		statusBar:SetPoint("bottomleft", f, "bottomleft")
		statusBar:SetPoint("bottomright", f, "bottomright")

	else
		statusBar:SetPoint("topleft", f, "bottomleft")
		statusBar:SetPoint("topright", f, "bottomright")
	end

	statusBar:SetHeight(20)
	detailsFramework:ApplyStandardBackdrop(statusBar)
	statusBar:SetAlpha(0.8)

	return statusBar
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--statusbar mixin

--[=[
	collection of functions to embed into a statusbar
	statusBar:GetTexture()
	statusBar:SetTexture(texture)
	statusBar:SetColor (unparsed color)
	statusBar:GetColor()
	statusBar:
	statusBar:

--]=]

detailsFramework.StatusBarFunctions = {
	SetTexture = function(self, texture, isTemporary)
		self.barTexture:SetTexture(texture)
		if (not isTemporary) then
			self.barTexture.currentTexture = texture
		end
	end,

	ResetTexture = function(self)
		self.barTexture:SetTexture(self.barTexture.currentTexture)
	end,

	GetTexture = function(self)
		return self.barTexture:GetTexture()
	end,

	SetAtlas = function(self, atlasName)
		self.barTexture:SetAtlas(atlasName)
	end,

	GetAtlas = function(self)
		self.barTexture:GetAtlas()
	end,

	SetTexCoord = function(self, ...)
		return self.barTexture:SetTexCoord(...)
	end,

	GetTexCoord = function(self)
		return self.barTexture:GetTexCoord()
	end,

	SetColor = function(self, r, g, b, a)
		r, g, b, a = detailsFramework:ParseColors(r, g, b, a)
		self:SetStatusBarColor(r, g, b, a)
	end,

	GetColor = function(self)
		return self:GetStatusBarColor()
	end,

	SetMaskTexture = function(self, ...)
		if (not self:HasTextureMask()) then
			return
		end
		self.barTextureMask:SetTexture(...)
	end,

	GetMaskTexture = function(self)
		if (not self:HasTextureMask()) then
			return
		end
		self.barTextureMask:GetTexture()
	end,

	--SetMaskTexCoord = function(self, ...) --MaskTexture doesn't not support texcoord
	--	if (not self:HasTextureMask()) then
	--		return
	--	end
	--	self.barTextureMask:SetTexCoord(...)
	--end,

	--GetMaskTexCoord = function(self, ...)
	--	if (not self:HasTextureMask()) then
	--		return
	--	end
	--	self.barTextureMask:GetTexCoord()
	--end,

	SetMaskAtlas = function(self, atlasName)
		if (not self:HasTextureMask()) then
			return
		end
		self.barTextureMask:SetAtlas(atlasName)
	end,

	GetMaskAtlas = function(self)
		if (not self:HasTextureMask()) then
			return
		end
		self.barTextureMask:GetAtlas()
	end,

	AddMaskTexture = function(self, object)
		if (not self:HasTextureMask()) then
			return
		end
		if (object.GetObjectType and object:GetObjectType() == "Texture") then
			object:AddMaskTexture(self.barTextureMask)
		else
			detailsFramework:Msg("Invalid 'Texture' to object:AddMaskTexture(Texture)", debugstack())
		end
	end,

	CreateTextureMask = function(self)
		local barTexture = self:GetStatusBarTexture() or self.barTexture
		if (not barTexture) then
			detailsFramework:Msg("Object doesn't not have a statubar texture, create one and object:SetStatusBarTexture(textureObject)", debugstack())
			return
		end

		if (self.barTextureMask) then
			return self.barTextureMask
		end

		--statusbar texture mask
		self.barTextureMask = self:CreateMaskTexture(nil, "artwork")
		self.barTextureMask:SetAllPoints()
		self.barTextureMask:SetTexture([[Interface\CHATFRAME\CHATFRAMEBACKGROUND]])

		--border texture
		self.barBorderTextureForMask = self:CreateTexture(nil, "artwork", nil, 7)
		self.barBorderTextureForMask:SetAllPoints()
		self.barBorderTextureForMask:Hide()

		barTexture:AddMaskTexture(self.barTextureMask)

		return self.barTextureMask
	end,

	HasTextureMask = function(self)
		if (not self.barTextureMask) then
			detailsFramework:Msg("Object doesn't not have a texture mask, create one using object:CreateTextureMask()", debugstack())
			return false
		end
		return true
	end,

	SetBorderTexture = function(self, texture)
		if (not self:HasTextureMask()) then
			return
		end

		texture = texture or ""

		self.barBorderTextureForMask:SetTexture(texture)

		if (texture == "") then
			self.barBorderTextureForMask:Hide()
		else
			self.barBorderTextureForMask:Show()
		end
	end,

	GetBorderTexture = function(self)
		if (not self:HasTextureMask()) then
			return
		end
		return self.barBorderTextureForMask:GetTexture()
	end,

	SetBorderColor = function(self, r, g, b, a)
		r, g, b, a = detailsFramework:ParseColors(r, g, b, a)

		if (self.barBorderTextureForMask and self.barBorderTextureForMask:IsShown()) then
			self.barBorderTextureForMask:SetVertexColor(r, g, b, a)

			--if there's a square border on the widget, remove its color
			if (self.border and self.border.UpdateSizes and self.border.SetVertexColor) then
				self.border:SetVertexColor(0, 0, 0, 0)
			end

			return
		end

		if (self.border and self.border.UpdateSizes and self.border.SetVertexColor) then
			self.border:SetVertexColor(r, g, b, a)

			--adjust the mask border texture ask well in case the user set the mask color texture before setting a texture on it
			if (self.barBorderTextureForMask) then
				self.barBorderTextureForMask:SetVertexColor(r, g, b, a)
			end
			return
		end
	end,

	GetBorderColor = function(self)
		if (self.barBorderTextureForMask and self.barBorderTextureForMask:IsShown()) then
			return self.barBorderTextureForMask:GetVertexColor()
		end

		if (self.border and self.border.UpdateSizes and self.border.GetVertexColor) then
			return self.border:GetVertexColor()
		end
	end,
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--health bar frame

--[=[
	DF:CreateHealthBar (parent, name, settingsOverride)
	creates a health bar to show an unit health
	@parent = frame to pass for the CreateFrame function
	@name = absolute name of the frame, if omitted it uses the parent's name .. "HealthBar"
	@settingsOverride = table with keys and values to replace the defaults from the framework

	methods:
	healthbar:SetUnit(unit)
	healthBar:GetTexture()
	healthBar:SetTexture(texture)
--]=]

--debug performance isn't placed anywhere
--how to use debug performance: I don't remember

	--Details:Dump (debugPerformance)

	local debugPerformance = {
		eventCall = {},
		unitCall = {},
		functionCall = {},
		CPUUsageByFunction = {},
	}

	local function CalcPerformance (type, data)
		if (type == "event") then
			debugPerformance.eventCall [data] = (debugPerformance.eventCall [data] or 0) + 1

		elseif (type == "unit") then
			debugPerformance.unitCall [data] = (debugPerformance.unitCall [data] or 0) + 1

		elseif (type == "call") then
			debugPerformance.functionCall [data] = (debugPerformance.functionCall [data] or 0) + 1

		end
	end

	function DF_CalcCpuUsage (name)
		local cpu = debugPerformance.CPUUsageByFunction [name] or {usage = 0, last = 0, active = false}
		debugPerformance.CPUUsageByFunction [name] = cpu

		if (cpu.active) then
			cpu.active = false
			local diff = debugprofilestop() - cpu.last
			cpu.usage = cpu.usage + diff
		else
			cpu.active = true
			cpu.last = debugprofilestop()
		end
	end

	function UnitFrameStats()
		for functionName, functionTable in pairs(debugPerformance.CPUUsageByFunction) do
			debugPerformance.CPUUsageByFunction [functionName] = floor(functionTable.usage)
		end

		for functionName, functionTable in pairs(debugPerformance.CPUUsageByFunction) do
			debugPerformance.CPUUsageByFunction [functionName] = {usage = 0, last = 0, active = false}
		end
	end
--end of performance calcs

--healthBar meta prototype
	local healthBarMetaPrototype = {
		WidgetType = "healthBar",
		dversion = detailsFramework.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[detailsFramework.GlobalWidgetControlNames["healthBar"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[detailsFramework.GlobalWidgetControlNames ["healthBar"]]
		--check if is older
		if ( (not oldMetaPrototype.dversion) or (oldMetaPrototype.dversion < detailsFramework.dversion) ) then
			--the version is older them the currently loading one
			--copy the new values into the old metatable
			for funcName, _ in pairs(healthBarMetaPrototype) do
				oldMetaPrototype[funcName] = healthBarMetaPrototype[funcName]
			end
		end
	else
		--first time loading the framework
		_G[detailsFramework.GlobalWidgetControlNames["healthBar"]] = healthBarMetaPrototype
	end

	local healthBarMetaFunctions = _G[detailsFramework.GlobalWidgetControlNames["healthBar"]]
	detailsFramework:Mixin(healthBarMetaFunctions, detailsFramework.ScriptHookMixin)

--hook list
	local defaultHooksForHealthBar = {
		OnHide = {},
		OnShow = {},
		OnHealthChange = {},
		OnHealthMaxChange = {},
	}

	--use the hook already existing
	healthBarMetaFunctions.HookList = healthBarMetaFunctions.HookList or defaultHooksForHealthBar
	--copy the non existing values from a new version to the already existing hook table
	detailsFramework.table.deploy(healthBarMetaFunctions.HookList, defaultHooksForHealthBar)

--Health Bar Meta Functions

	--health bar settings
	healthBarMetaFunctions.Settings = {
		CanTick = false, --if true calls the method 'OnTick' every tick, the function needs to be overloaded, it receives self and deltaTime as parameters
		ShowHealingPrediction = true, --when casting a healing pass, show the amount of health that spell will heal
		ShowShields = true, --indicator of the amount of damage absortion the unit has

		--appearance
		BackgroundColor = detailsFramework:CreateColorTable (.2, .2, .2, .8),
		Texture = [[Interface\RaidFrame\Raid-Bar-Hp-Fill]],
		ShieldIndicatorTexture = [[Interface\RaidFrame\Shield-Fill]],
		ShieldGlowTexture = [[Interface\RaidFrame\Shield-Overshield]],
		ShieldGlowWidth = 16,

		--default size
		Width = 100,
		Height = 20,
	}

	healthBarMetaFunctions.HealthBarEvents = {
		{"PLAYER_ENTERING_WORLD"},
		{"UNIT_HEALTH", true},
		{"UNIT_MAXHEALTH", true},
		{(IS_WOW_PROJECT_NOT_MAINLINE) and "UNIT_HEALTH_FREQUENT", true}, -- this one is classic-only...
		{"UNIT_HEAL_PREDICTION", true},
		{(IS_WOW_PROJECT_MAINLINE) and "UNIT_ABSORB_AMOUNT_CHANGED", true},
		{(IS_WOW_PROJECT_MAINLINE) and "UNIT_HEAL_ABSORB_AMOUNT_CHANGED", true},
	}

	--setup the castbar to be used by another unit
	healthBarMetaFunctions.SetUnit = function(self, unit, displayedUnit)
		if (self.unit ~= unit or self.displayedUnit ~= displayedUnit or unit == nil) then

			self.unit = unit
			self.displayedUnit = displayedUnit or unit

			--register events
			if (unit) then
				self.currentHealth = UnitHealth (unit) or 0
				self.currentHealthMax = UnitHealthMax (unit) or 0

				for _, eventTable in ipairs(self.HealthBarEvents) do
					local event = eventTable [1]
					local isUnitEvent = eventTable [2]
					if event then
						if (isUnitEvent) then
							self:RegisterUnitEvent (event, self.displayedUnit, self.unit)
						else
							self:RegisterEvent(event)
						end
					end
				end

				--check for settings and update some events
				if (not self.Settings.ShowHealingPrediction) then
					self:UnregisterEvent ("UNIT_HEAL_PREDICTION")
					if IS_WOW_PROJECT_MAINLINE then
						self:UnregisterEvent ("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
					end
					self.incomingHealIndicator:Hide()
					self.healAbsorbIndicator:Hide()
				end
				if (not self.Settings.ShowShields) then
					if IS_WOW_PROJECT_MAINLINE then
						self:UnregisterEvent ("UNIT_ABSORB_AMOUNT_CHANGED")
					end
					self.shieldAbsorbIndicator:Hide()
					self.shieldAbsorbGlow:Hide()
				end

				--set scripts
				self:SetScript("OnEvent", self.OnEvent)

				if (self.Settings.CanTick) then
					self:SetScript("OnUpdate", self.OnTick)
				end

				self:PLAYER_ENTERING_WORLD (self.unit, self.displayedUnit)
			else
				--remove all registered events
				for _, eventTable in ipairs(self.HealthBarEvents) do
					local event = eventTable [1]
					if event then
						self:UnregisterEvent (event)
					end
				end

				--remove scripts
				self:SetScript("OnEvent", nil)
				self:SetScript("OnUpdate", nil)
				self:Hide()
			end
		end
	end

	healthBarMetaFunctions.Initialize = function(self)
		PixelUtil.SetWidth (self, self.Settings.Width, 1)
		PixelUtil.SetHeight(self, self.Settings.Height, 1)

		self:SetTexture(self.Settings.Texture)

		self.background:SetAllPoints()
		self.background:SetColorTexture(self.Settings.BackgroundColor:GetColor())

		--setpoint of these widgets are set inside the function that updates the incoming heal
		self.incomingHealIndicator:SetTexture(self:GetTexture())
		self.healAbsorbIndicator:SetTexture(self:GetTexture())
		self.healAbsorbIndicator:SetVertexColor(.1, .8, .8)
		self.shieldAbsorbIndicator:SetTexture(self.Settings.ShieldIndicatorTexture, true, true)

		self.shieldAbsorbGlow:SetWidth(self.Settings.ShieldGlowWidth)
		self.shieldAbsorbGlow:SetTexture(self.Settings.ShieldGlowTexture)
		self.shieldAbsorbGlow:SetBlendMode("ADD")
		self.shieldAbsorbGlow:SetPoint("topright", self, "topright", 8, 0)
		self.shieldAbsorbGlow:SetPoint("bottomright", self, "bottomright", 8, 0)
		self.shieldAbsorbGlow:Hide()

		self:SetUnit(nil)
	end

	--call every tick
	healthBarMetaFunctions.OnTick = function(self, deltaTime) end --if overrided, set 'CanTick' to true on the settings table

	--when an event happen for this unit, send it to the apropriate function
	healthBarMetaFunctions.OnEvent = function(self, event, ...)
		local eventFunc = self [event]
		if (eventFunc) then
			--the function doesn't receive which event was, only 'self' and the parameters
			eventFunc (self, ...)
		end
	end

	--when the unit max health is changed
	healthBarMetaFunctions.UpdateMaxHealth = function(self)
		local maxHealth = UnitHealthMax (self.displayedUnit)
		self:SetMinMaxValues(0, maxHealth)
		self.currentHealthMax = maxHealth

		self:RunHooksForWidget("OnHealthMaxChange", self, self.displayedUnit)
	end

	healthBarMetaFunctions.UpdateHealth = function(self)
		-- update max health regardless to avoid weird wrong values on UpdateMaxHealth sometimes
		-- local maxHealth = UnitHealthMax (self.displayedUnit)
		-- self:SetMinMaxValues(0, maxHealth)
		-- self.currentHealthMax = maxHealth

		self.oldHealth = self.currentHealth
		local health = UnitHealth(self.displayedUnit)
		self.currentHealth = health
		PixelUtil.SetStatusBarValue(self, health)

		self:RunHooksForWidget("OnHealthChange", self, self.displayedUnit)
	end

	--health and absorbs prediction
	healthBarMetaFunctions.UpdateHealPrediction = function(self)
		local currentHealth = self.currentHealth
		local currentHealthMax = self.currentHealthMax
		local healthPercent = currentHealth / currentHealthMax

		if (not currentHealthMax or currentHealthMax <= 0) then
			return
		end

		--order is: the health of the unit > damage absorb > heal absorb > incoming heal
		local width = self:GetWidth()

		if (self.Settings.ShowHealingPrediction) then
			--incoming heal on the unit from all sources
			local unitHealIncoming = self.displayedUnit and UnitGetIncomingHeals (self.displayedUnit) or 0
			--heal absorbs
			local unitHealAbsorb = IS_WOW_PROJECT_MAINLINE and self.displayedUnit and UnitGetTotalHealAbsorbs (self.displayedUnit) or 0

			if (unitHealIncoming > 0) then
				--calculate what is the percent of health incoming based on the max health the player has
				local incomingPercent = unitHealIncoming / currentHealthMax
				self.incomingHealIndicator:Show()
				self.incomingHealIndicator:SetWidth(max(1, min (width * incomingPercent, abs(healthPercent - 1) * width)))
				self.incomingHealIndicator:SetPoint("topleft", self, "topleft", width * healthPercent, 0)
				self.incomingHealIndicator:SetPoint("bottomleft", self, "bottomleft", width * healthPercent, 0)
			else
				self.incomingHealIndicator:Hide()
			end

			if (unitHealAbsorb > 0) then
				local healAbsorbPercent = unitHealAbsorb / currentHealthMax
				self.healAbsorbIndicator:Show()
				self.healAbsorbIndicator:SetWidth(max(1, min (width * healAbsorbPercent, abs(healthPercent - 1) * width)))
				self.healAbsorbIndicator:SetPoint("topleft", self, "topleft", width * healthPercent, 0)
				self.healAbsorbIndicator:SetPoint("bottomleft", self, "bottomleft", width * healthPercent, 0)
			else
				self.healAbsorbIndicator:Hide()
			end
		end

		if (self.Settings.ShowShields and IS_WOW_PROJECT_MAINLINE) then
			--damage absorbs
			local unitDamageAbsorb = self.displayedUnit and UnitGetTotalAbsorbs (self.displayedUnit) or 0

			if (unitDamageAbsorb > 0) then
				local damageAbsorbPercent = unitDamageAbsorb / currentHealthMax
				self.shieldAbsorbIndicator:Show()
				--set the width where the max width size is what is lower: the absorb size or the missing amount of health in the health bar
				--/dump NamePlate1PlaterUnitFrameHealthBar.shieldAbsorbIndicator:GetSize()
				self.shieldAbsorbIndicator:SetWidth(max(1, min (width * damageAbsorbPercent, abs(healthPercent - 1) * width)))
				self.shieldAbsorbIndicator:SetPoint("topleft", self, "topleft", width * healthPercent, 0)
				self.shieldAbsorbIndicator:SetPoint("bottomleft", self, "bottomleft", width * healthPercent, 0)

				--if the absorb percent pass 100%, show the glow
				if ((healthPercent + damageAbsorbPercent) > 1) then
					self.shieldAbsorbGlow:Show()
				else
					self.shieldAbsorbGlow:Hide()
				end
			else
				self.shieldAbsorbIndicator:Hide()
				self.shieldAbsorbGlow:Hide()
			end
		else
			self.shieldAbsorbIndicator:Hide()
			self.shieldAbsorbGlow:Hide()
		end
	end

	--Health Events
		healthBarMetaFunctions.PLAYER_ENTERING_WORLD = function(self, ...)
			self:UpdateMaxHealth()
			self:UpdateHealth()
			self:UpdateHealPrediction()
		end

		healthBarMetaFunctions.UNIT_HEALTH = function(self, ...)
			self:UpdateHealth()
			self:UpdateHealPrediction()
		end

		healthBarMetaFunctions.UNIT_HEALTH_FREQUENT = function(self, ...)
			self:UpdateHealth()
			self:UpdateHealPrediction()
		end

		healthBarMetaFunctions.UNIT_MAXHEALTH = function(self, ...)
			self:UpdateMaxHealth()
			self:UpdateHealth()
			self:UpdateHealPrediction()
		end


		healthBarMetaFunctions.UNIT_HEAL_PREDICTION = function(self, ...)
			self:UpdateMaxHealth()
			self:UpdateHealth()
			self:UpdateHealPrediction()
		end

		healthBarMetaFunctions.UNIT_ABSORB_AMOUNT_CHANGED = function(self, ...)
			self:UpdateMaxHealth()
			self:UpdateHealth()
			self:UpdateHealPrediction()
		end

		healthBarMetaFunctions.UNIT_HEAL_ABSORB_AMOUNT_CHANGED = function(self, ...)
			self:UpdateMaxHealth()
			self:UpdateHealth()
			self:UpdateHealPrediction()
		end


-- ~healthbar
function detailsFramework:CreateHealthBar (parent, name, settingsOverride)

	assert(name or parent:GetName(), "DetailsFramework:CreateHealthBar parameter 'name' omitted and parent has no name.")

	local healthBar = CreateFrame("StatusBar", name or (parent:GetName() .. "HealthBar"), parent, "BackdropTemplate")
		do --layers
			--background
			healthBar.background = healthBar:CreateTexture(nil, "background")
			healthBar.background:SetDrawLayer("background", -6)

			--artwork
			--healing incoming
			healthBar.incomingHealIndicator = healthBar:CreateTexture(nil, "artwork")
			healthBar.incomingHealIndicator:SetDrawLayer("artwork", 4)
			--current shields on the unit
			healthBar.shieldAbsorbIndicator =  healthBar:CreateTexture(nil, "artwork")
			healthBar.shieldAbsorbIndicator:SetDrawLayer("artwork", 5)
			--debuff absorbing heal
			healthBar.healAbsorbIndicator = healthBar:CreateTexture(nil, "artwork")
			healthBar.healAbsorbIndicator:SetDrawLayer("artwork", 6)
			--the shield fills all the bar, show that cool glow
			healthBar.shieldAbsorbGlow = healthBar:CreateTexture(nil, "artwork")
			healthBar.shieldAbsorbGlow:SetDrawLayer("artwork", 7)
			--statusbar texture
			healthBar.barTexture = healthBar:CreateTexture(nil, "artwork")
			healthBar:SetStatusBarTexture(healthBar.barTexture)
		end

	--mixins
	detailsFramework:Mixin(healthBar, healthBarMetaFunctions)
	detailsFramework:Mixin(healthBar, detailsFramework.StatusBarFunctions)

	healthBar:CreateTextureMask()
	healthBar:SetTexture([[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]])

	--settings and hooks
	local settings = detailsFramework.table.copy({}, healthBarMetaFunctions.Settings)
	if (settingsOverride) then
		detailsFramework.table.copy(settings, settingsOverride)
	end
	healthBar.Settings = settings

	--hook list
	healthBar.HookList = detailsFramework.table.copy({}, healthBarMetaFunctions.HookList)

	--initialize the cast bar
	healthBar:Initialize()

	return healthBar
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--power bar frame

--[=[
	DF:CreatePowerBar (parent, name, settingsOverride)
	creates statusbar frame to show the unit power bar
	@parent = frame to pass for the CreateFrame function
	@name = absolute name of the frame, if omitted it uses the parent's name .. "PPowerBar"
	@settingsOverride = table with keys and values to replace the defaults from the framework
--]=]

detailsFramework.PowerFrameFunctions = {
	WidgetType = "powerBar",

	HookList = {
		OnHide = {},
		OnShow = {},
	},

	Settings = {
		--misc
		ShowAlternatePower = true, --if true it'll show alternate power over the regular power the unit uses
		ShowPercentText = true, --if true show a text with the current energy percent
		HideIfNoPower = true, --if true and the UnitMaxPower returns zero, it'll hide the power bar with self:Hide()
		CanTick = false, --if it calls the OnTick function every tick

		--appearance
		BackgroundColor = detailsFramework:CreateColorTable (.2, .2, .2, .8),
		Texture = [[Interface\RaidFrame\Raid-Bar-Resource-Fill]],

		--default size
		Width = 100,
		Height = 20,
	},

	PowerBarEvents = {
		{"PLAYER_ENTERING_WORLD"},
		{"UNIT_DISPLAYPOWER", true},
		{"UNIT_POWER_BAR_SHOW", true},
		{"UNIT_POWER_BAR_HIDE", true},
		{"UNIT_MAXPOWER", true},
		{"UNIT_POWER_UPDATE", true},
		{"UNIT_POWER_FREQUENT", true},
	},

	--setup the castbar to be used by another unit
	SetUnit = function(self, unit, displayedUnit)
		if (self.unit ~= unit or self.displayedUnit ~= displayedUnit or unit == nil) then
			self.unit = unit
			self.displayedUnit = displayedUnit or unit

			--register events
			if (unit) then
				for _, eventTable in ipairs(self.PowerBarEvents) do
					local event = eventTable [1]
					local isUnitEvent = eventTable [2]

					if (isUnitEvent) then
						self:RegisterUnitEvent (event, self.displayedUnit)
					else
						self:RegisterEvent(event)
					end
				end

				--set scripts
				self:SetScript("OnEvent", self.OnEvent)

				if (self.Settings.CanTick) then
					self:SetScript("OnUpdate", self.OnTick)
				end

				self:Show()
				self:UpdatePowerBar()
			else
				--remove all registered events
				for _, eventTable in ipairs(self.PowerBarEvents) do
					local event = eventTable [1]
					self:UnregisterEvent (event)
				end

				--remove scripts
				self:SetScript("OnEvent", nil)
				self:SetScript("OnUpdate", nil)
				self:Hide()
			end
		end
	end,

	Initialize = function(self)
		PixelUtil.SetWidth (self, self.Settings.Width)
		PixelUtil.SetHeight(self, self.Settings.Height)

		self:SetTexture(self.Settings.Texture)

		self.background:SetAllPoints()
		self.background:SetColorTexture(self.Settings.BackgroundColor:GetColor())

		if (self.Settings.ShowPercentText) then
			self.percentText:Show()
			PixelUtil.SetPoint(self.percentText, "center", self, "center", 0, 0)

			detailsFramework:SetFontSize(self.percentText, 9)
			detailsFramework:SetFontColor(self.percentText, "white")
			detailsFramework:SetFontOutline (self.percentText, "OUTLINE")
		else
			self.percentText:Hide()
		end

		self:SetUnit(nil)
	end,

	--call every tick
	OnTick = function(self, deltaTime) end, --if overrided, set 'CanTick' to true on the settings table

	--when an event happen for this unit, send it to the apropriate function
	OnEvent = function(self, event, ...)
		local eventFunc = self [event]
		if (eventFunc) then
			--the function doesn't receive which event was, only 'self' and the parameters
			eventFunc (self, ...)
		end
	end,

	UpdatePowerBar = function(self)
		self:UpdatePowerInfo()
		self:UpdateMaxPower()
		self:UpdatePower()
		self:UpdatePowerColor()
	end,

	--power update
	UpdateMaxPower = function(self)
		self.currentPowerMax = UnitPowerMax (self.displayedUnit, self.powerType)
		self:SetMinMaxValues(self.minPower, self.currentPowerMax)

		if (self.currentPowerMax == 0 and self.Settings.HideIfNoPower) then
			self:Hide()
		end
	end,
	UpdatePower = function(self)
		self.currentPower = UnitPower (self.displayedUnit, self.powerType)
		PixelUtil.SetStatusBarValue (self, self.currentPower)

		if (self.Settings.ShowPercentText) then
			self.percentText:SetText(floor(self.currentPower / self.currentPowerMax * 100) .. "%")
		end
	end,

	--when a event different from unit_power_update is triggered, update which type of power the unit should show
	UpdatePowerInfo = function(self)
		if (IS_WOW_PROJECT_MAINLINE and self.Settings.ShowAlternatePower) then -- not available in classic
			local barID = UnitPowerBarID(self.displayedUnit)
			local barInfo = GetUnitPowerBarInfoByID(barID)
			--local name, tooltip, cost = GetUnitPowerBarStringsByID(barID);
			--barInfo.barType,barInfo.minPower, barInfo.startInset, barInfo.endInset, barInfo.smooth, barInfo.hideFromOthers, barInfo.showOnRaid, barInfo.opaqueSpark, barInfo.opaqueFlash, barInfo.anchorTop, name, tooltip, cost, barInfo.ID, barInfo.forcePercentage, barInfo.sparkUnderFrame;
			if (barInfo and barInfo.showOnRaid and IsInGroup()) then
				self.powerType = ALTERNATE_POWER_INDEX
				self.minPower = barInfo.minPower
				return
			end
		end

		self.powerType = UnitPowerType (self.displayedUnit)
		self.minPower = 0
	end,

	--tint the bar with the color of the power, e.g. blue for a mana bar
	UpdatePowerColor = function(self)
		if (not UnitIsConnected (self.unit)) then
			self:SetStatusBarColor(.5, .5, .5)
			return
		end

		if (self.powerType == ALTERNATE_POWER_INDEX) then
			--don't change this, keep the same color as the game tints on CompactUnitFrame.lua
			self:SetStatusBarColor(0.7, 0.7, 0.6)
			return
		end

		local powerColor = PowerBarColor [self.powerType] --don't appear to be, but PowerBarColor is a global table with all power colors /run Details:Dump (PowerBarColor)
		if (powerColor) then
			self:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
			return
		end

		local _, _, r, g, b = UnitPowerType (self.displayedUnit)
		if (r) then
			self:SetStatusBarColor(r, g, b)
			return
		end

		--if everything else fails, tint as rogue energy
		powerColor = PowerBarColor ["ENERGY"]
		self:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
	end,

	--events
	PLAYER_ENTERING_WORLD = function(self, ...)
		self:UpdatePowerBar()
	end,
	UNIT_DISPLAYPOWER  = function(self, ...)
		self:UpdatePowerBar()
	end,
	UNIT_POWER_BAR_SHOW = function(self, ...)
		self:UpdatePowerBar()
	end,
	UNIT_POWER_BAR_HIDE = function(self, ...)
		self:UpdatePowerBar()
	end,

	UNIT_MAXPOWER = function(self, ...)
		self:UpdateMaxPower()
		self:UpdatePower()
	end,
	UNIT_POWER_UPDATE = function(self, ...)
		self:UpdatePower()
	end,
	UNIT_POWER_FREQUENT = function(self, ...)
		self:UpdatePower()
	end,
}

detailsFramework:Mixin(detailsFramework.PowerFrameFunctions, detailsFramework.ScriptHookMixin)

-- ~powerbar
function detailsFramework:CreatePowerBar(parent, name, settingsOverride)
	assert(name or parent:GetName(), "DetailsFramework:CreatePowerBar parameter 'name' omitted and parent has no name.")

	local powerBar = CreateFrame("StatusBar", name or (parent:GetName() .. "PowerBar"), parent, "BackdropTemplate")
		do --layers
			--background
			powerBar.background = powerBar:CreateTexture(nil, "background")
			powerBar.background:SetDrawLayer("background", -6)

			--artwork
			powerBar.barTexture = powerBar:CreateTexture(nil, "artwork")
			powerBar:SetStatusBarTexture(powerBar.barTexture)

			--overlay
			powerBar.percentText = powerBar:CreateFontString(nil, "overlay", "GameFontNormal")
		end

	--mixins
	detailsFramework:Mixin(powerBar, detailsFramework.PowerFrameFunctions)
	detailsFramework:Mixin(powerBar, detailsFramework.StatusBarFunctions)

	powerBar:CreateTextureMask()
	powerBar:SetTexture([[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]])

	--settings and hooks
	local settings = detailsFramework.table.copy({}, detailsFramework.PowerFrameFunctions.Settings)
	if (settingsOverride) then
		detailsFramework.table.copy(settings, settingsOverride)
	end
	powerBar.Settings = settings

	local hookList = detailsFramework.table.copy({}, detailsFramework.PowerFrameFunctions.HookList)
	powerBar.HookList = hookList

	--initialize the cast bar
	powerBar:Initialize()

	return powerBar
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--cast bar frame

--[=[
	DF:CreateCastBar (parent, name, settingsOverride)
	creates a cast bar to show an unit cast
	@parent = frame to pass for the CreateFrame function
	@name = absolute name of the frame, if omitted it uses the parent's name .. "CastBar"
	@settingsOverride = table with keys and values to replace the defaults from the framework
--]=]

detailsFramework.CastFrameFunctions = {
	WidgetType = "castBar",

	HookList = {
		OnHide = {},
		OnShow = {},

		--can be regular cast or channel
		OnCastStart = {},
	},

	CastBarEvents = {
		{"UNIT_SPELLCAST_INTERRUPTED"},
		{"UNIT_SPELLCAST_DELAYED"},
		{"UNIT_SPELLCAST_CHANNEL_START"},
		{"UNIT_SPELLCAST_CHANNEL_UPDATE"},
		{"UNIT_SPELLCAST_CHANNEL_STOP"},
		{(IS_WOW_PROJECT_MAINLINE) and "UNIT_SPELLCAST_EMPOWER_START"},
		{(IS_WOW_PROJECT_MAINLINE) and "UNIT_SPELLCAST_EMPOWER_UPDATE"},
		{(IS_WOW_PROJECT_MAINLINE) and "UNIT_SPELLCAST_EMPOWER_STOP"},
		{(IS_WOW_PROJECT_MAINLINE) and "UNIT_SPELLCAST_INTERRUPTIBLE"},
		{(IS_WOW_PROJECT_MAINLINE) and "UNIT_SPELLCAST_NOT_INTERRUPTIBLE"},
		{"PLAYER_ENTERING_WORLD"},
		{"UNIT_SPELLCAST_START", true},
		{"UNIT_SPELLCAST_STOP", true},
		{"UNIT_SPELLCAST_FAILED", true},
	},

	Settings = {
		NoFadeEffects = false, --if true it won't play fade effects when a cast if finished
		ShowTradeSkills = false, --if true, it shows cast for trade skills, e.g. creating an icon with blacksmith
		ShowShield = true, --if true, shows the shield above the spell icon for non interruptible casts
		CanTick = true, --if true it will run its OnTick function every tick.
		ShowCastTime = true, --if true, show the remaining time to finish the cast, lazy tick must be enabled
		FadeInTime = 0.1, --amount of time in seconds to go from zero to 100% alpha when starting to cast
		FadeOutTime = 0.5, --amount of time in seconds to go from 100% to zero alpha when the cast finishes
		CanLazyTick = true, --if true, it'll execute the lazy tick function, it ticks in a much slower pace comparece with the regular tick
		LazyUpdateCooldown = 0.2, --amount of time to wait for the next lazy update, this updates non critical things like the cast timer

		ShowEmpoweredDuration = true, --full hold time for empowered spells

		FillOnInterrupt = true,
		HideSparkOnInterrupt = true,

		--default size
		Width = 100,
		Height = 20,

		--colour the castbar statusbar by the type of the cast
		Colors = {
			Casting = detailsFramework:CreateColorTable (1, 0.73, .1, 1),
			Channeling = detailsFramework:CreateColorTable (1, 0.73, .1, 1),
			Finished = detailsFramework:CreateColorTable (0, 1, 0, 1),
			NonInterruptible = detailsFramework:CreateColorTable (.7, .7, .7, 1),
			Failed = detailsFramework:CreateColorTable (.4, .4, .4, 1),
			Interrupted = detailsFramework:CreateColorTable (.965, .754, .154, 1),
		},

		--appearance
		BackgroundColor = detailsFramework:CreateColorTable (.2, .2, .2, .8),
		Texture = [[Interface\TargetingFrame\UI-StatusBar]],
		BorderShieldWidth = 10,
		BorderShieldHeight = 12,
		BorderShieldCoords = {0.26171875, 0.31640625, 0.53125, 0.65625},
		BorderShieldTexture = 1300837,
		SpellIconWidth = 10,
		SpellIconHeight = 10,
		ShieldIndicatorTexture = [[Interface\RaidFrame\Shield-Fill]],
		ShieldGlowTexture = [[Interface\RaidFrame\Shield-Overshield]],
		SparkTexture = [[Interface\CastingBar\UI-CastingBar-Spark]],
		SparkWidth = 16,
		SparkHeight = 16,
		SparkOffset = 0,
	},

	Initialize = function(self)
		self.unit = "unutilized unit"
		self.lazyUpdateCooldown = self.Settings.LazyUpdateCooldown
		self.Colors = self.Settings.Colors

		self:SetUnit(nil)
		PixelUtil.SetWidth (self, self.Settings.Width)
		PixelUtil.SetHeight(self, self.Settings.Height)

		self.background:SetColorTexture(self.Settings.BackgroundColor:GetColor())
		self.background:SetAllPoints()
		self.extraBackground:SetColorTexture(0, 0, 0, 1)
		self.extraBackground:SetVertexColor(self.Settings.BackgroundColor:GetColor())
		self.extraBackground:SetAllPoints()

		self:SetTexture(self.Settings.Texture)

		self.BorderShield:SetPoint("center", self, "left", 0, 0)
		self.BorderShield:SetTexture(self.Settings.BorderShieldTexture)
		self.BorderShield:SetTexCoord(unpack(self.Settings.BorderShieldCoords))
		self.BorderShield:SetSize(self.Settings.BorderShieldWidth, self.Settings.BorderShieldHeight)

		self.Icon:SetPoint("center", self, "left", 2, 0)
		self.Icon:SetSize(self.Settings.SpellIconWidth, self.Settings.SpellIconHeight)

		self.Spark:SetTexture(self.Settings.SparkTexture)
		self.Spark:SetSize(self.Settings.SparkWidth, self.Settings.SparkHeight)

		self.percentText:SetPoint("right", self, "right", -2, 0)
		self.percentText:SetJustifyH("right")

		self.fadeOutAnimation.alpha1:SetDuration(self.Settings.FadeOutTime)
		self.fadeInAnimation.alpha1:SetDuration(self.Settings.FadeInTime)
	end,

	SetDefaultColor = function(self, colorType, r, g, b, a)
		assert(type(colorType) == "string", "DetailsFramework: CastBar:SetDefaultColor require a string in the first argument.")
		self.Colors [colorType]:SetColor (r, g, b, a)
	end,

	--this get a color suggestion based on the type of cast being shown in the cast bar
	GetCastColor = function(self)
		if (not self.canInterrupt) then
			return self.Colors.NonInterruptible

		elseif (self.channeling) then
			return self.Colors.Channeling

		elseif (self.failed) then
			return self.Colors.Failed

		elseif (self.interrupted) then
			return self.Colors.Interrupted

		elseif (self.finished) then
			return self.Colors.Finished

		else
			return self.Colors.Casting
		end
	end,

	--update all colors of the cast bar
	UpdateCastColor = function(self)
		local castColor = self:GetCastColor()
		self:SetColor (castColor) --SetColor handles with ParseColors()
	end,

	--initial checks to know if this is a valid cast and should show the cast bar, if this fails the cast bar won't show
	IsValid = function(self, unit, castName, isTradeSkill, ignoreVisibility)
		if (not ignoreVisibility and not self:IsShown()) then
			return false
		end

		if (not self.Settings.ShowTradeSkills) then
			if (isTradeSkill) then
				return false
			end
		end

		if (not castName) then
			return false
		end

		return true
	end,

	--handle the interrupt state of the cast
	--this does not change the cast bar color because this function is called inside the start cast where is already handles the cast color
	UpdateInterruptState = function(self)
		if (self.Settings.ShowShield and not self.canInterrupt) then
			self.BorderShield:Show()
		else
			self.BorderShield:Hide()
		end
	end,

	--this check if the cast did reach 100% in the statusbar, mostly called from OnTick
	CheckCastIsDone = function(self, event, isFinished)

		--check max value
		if (not isFinished and not self.finished) then
			if (self.casting) then
				if (self.value >= self.maxValue) then
					isFinished = true
				end

			elseif (self.channeling) then
				if (self.value > self.maxValue or self.value <= 0) then
					isFinished = true
				end
			end

			--check if passed an event (not begin used at the moment)
			if (event) then
				if (event == UNIT_SPELLCAST_STOP or event == UNIT_SPELLCAST_CHANNEL_STOP) then
					isFinished = true
				end
			end
		end

		--the cast is finished
		if (isFinished) then
			if (self.casting) then
				self.UNIT_SPELLCAST_STOP (self, self.unit, self.unit, self.castID, self.spellID)

			elseif (self.channeling) then
				self.UNIT_SPELLCAST_CHANNEL_STOP (self, self.unit, self.unit, self.castID, self.spellID)
			end

			return true
		end
	end,

	--setup the castbar to be used by another unit
	SetUnit = function(self, unit, displayedUnit)
		if (self.unit ~= unit or self.displayedUnit ~= displayedUnit or unit == nil) then
			self.unit = unit
			self.displayedUnit = displayedUnit or unit

			--reset the cast bar
			self.casting = nil
			self.channeling = nil
			self.caninterrupt = nil

			--register events
			if (unit) then
				for _, eventTable in ipairs(self.CastBarEvents) do
					local event = eventTable [1]
					local isUnitEvent = eventTable [2]

					if event then
						if (isUnitEvent) then
							self:RegisterUnitEvent (event, unit)
						else
							self:RegisterEvent(event)
						end
					end
				end

				--set scripts
				self:SetScript("OnEvent", self.OnEvent)
				self:SetScript("OnShow", self.OnShow)
				self:SetScript("OnHide", self.OnHide)

				if (self.Settings.CanTick) then
					self:SetScript("OnUpdate", self.OnTick)
				end

				--check is can show the cast time text
				if (self.Settings.ShowCastTime and self.Settings.CanLazyTick) then
					self.percentText:Show()
				else
					self.percentText:Hide()
				end

				--setup animtions
				self:CancelScheduleToHide()

				--self:PLAYER_ENTERING_WORLD (unit, unit)
				self:OnEvent ("PLAYER_ENTERING_WORLD", unit, unit)

			else
				for _, eventTable in ipairs(self.CastBarEvents) do
					local event = eventTable [1]
					if event then
						self:UnregisterEvent (event)
					end
				end

				--register main events
				self:SetScript("OnUpdate", nil)
				self:SetScript("OnEvent", nil)
				self:SetScript("OnShow", nil)
				self:SetScript("OnHide", nil)

				self:Hide()
			end
		end
	end,

	--executed after a scheduled to hide timer is done
	DoScheduledHide = function(timerObject)
		timerObject.castBar.scheduledHideTime = nil

		--just to make sure it isn't casting
		if (not timerObject.castBar.casting and not timerObject.castBar.channeling) then
			if (not timerObject.castBar.Settings.NoFadeEffects) then
				timerObject.castBar:Animation_FadeOut()
			else
				timerObject.castBar:Hide()
			end
		end
	end,

	HasScheduledHide = function(self)
		return self.scheduledHideTime and not self.scheduledHideTime:IsCancelled()
	end,

	CancelScheduleToHide = function(self)
		if (self:HasScheduledHide()) then
			self.scheduledHideTime:Cancel()
		end
	end,

	--after an interrupt, do not immediately hide the cast bar, let it up for short amount of time to give feedback to the player
	ScheduleToHide = function(self, delay)
		if (not delay) then
			if (self.scheduledHideTime and not self.scheduledHideTime:IsCancelled()) then
				self.scheduledHideTime:Cancel()
			end

			self.scheduledHideTime = nil
			return
		end

		--already have a scheduled timer?
		if (self.scheduledHideTime and not self.scheduledHideTime:IsCancelled()) then
			self.scheduledHideTime:Cancel()
		end

		self.scheduledHideTime = C_Timer.NewTimer(delay, self.DoScheduledHide)
		self.scheduledHideTime.castBar = self
	end,

	OnHide = function(self)
		--just in case some other effects made it have a different alpha since SetUnit won't load if the unit is the same.
		self:SetAlpha(1)
		--cancel any timer to hide scheduled
		self:CancelScheduleToHide()
	end,

	--just update the current value if a spell is being cast since it wasn't running its tick function during the hide state
	--everything else should be in the correct state
	OnShow = function(self)
		self.flashTexture:Hide()

		if (self.unit) then
			if (self.casting) then
				local name, text, texture, startTime = UnitCastingInfo (self.unit)
				if (name) then
					--[[if not self.spellStartTime then
						self:UpdateCastingInfo(self.unit)
					end]]--
					self.value = GetTime() - self.spellStartTime
				end

				self:RunHooksForWidget("OnShow", self, self.unit)

			elseif (self.channeling) then
				local name, text, texture, endTime = UnitChannelInfo (self.unit)
				if (name) then
					--[[if not self.spellEndTime then
						self:UpdateChannelInfo(self.unit)
					end]]--
					self.value = self.empowered and (GetTime() - self.spellStartTime) or (self.spellEndTime - GetTime())
				end

				self:RunHooksForWidget("OnShow", self, self.unit)
			end
		end
	end,

	--it's triggering several events since it's not registered for the unit with RegisterUnitEvent
	OnEvent = function(self, event, ...)
		local arg1 = ...
		local unit = self.unit

		if (event == "PLAYER_ENTERING_WORLD") then
			local newEvent = self.PLAYER_ENTERING_WORLD (self, unit, ...)
			if (newEvent) then
				self.OnEvent (self, newEvent, unit)
				return
			end

		elseif (arg1 ~= unit) then
			return
		end

		local eventFunc = self [event]
		if (eventFunc) then
			eventFunc (self, unit, ...)
		end
	end,

	OnTick_LazyTick = function(self)
		--run the lazy tick if allowed
		if (self.Settings.CanLazyTick) then
			--update the cast time
			if (self.Settings.ShowCastTime) then
				if (self.casting) then
					self.percentText:SetText(format("%.1f", abs(self.value - self.maxValue)))

				elseif (self.channeling) then
					local remainingTime = self.empowered and abs(self.value - self.maxValue) or abs(self.value)
					if (remainingTime > 999) then
						self.percentText:SetText("")
					else
						self.percentText:SetText(format("%.1f", remainingTime))
					end
				else
					self.percentText:SetText("")
				end
			end

			return true
		else
			return false
		end
	end,

	--tick function for regular casts
	OnTick_Casting = function(self, deltaTime)
		self.value = self.value + deltaTime

		if (self:CheckCastIsDone()) then
			return
		else
			self:SetValue(self.value)
		end

		--update spark position
		local sparkPosition = self.value / self.maxValue * self:GetWidth()
		self.Spark:SetPoint("center", self, "left", sparkPosition + self.Settings.SparkOffset, 0)
		

		--in order to allow the lazy tick run, it must return true, it tell that the cast didn't finished
		return true
	end,

	--tick function for channeling casts
	OnTick_Channeling = function(self, deltaTime)
		self.value = self.empowered and self.value + deltaTime or self.value - deltaTime

		if (self:CheckCastIsDone()) then
			return
		else
			self:SetValue(self.value)
		end

		--update spark position
		local sparkPosition = self.value / self.maxValue * self:GetWidth()
		self.Spark:SetPoint("center", self, "left", sparkPosition + self.Settings.SparkOffset, 0)
		
		self:CreateOrUpdateEmpoweredPips()

		return true
	end,

	OnTick = function(self, deltaTime)
		if (self.casting) then
			if (not self:OnTick_Casting (deltaTime)) then
				return
			end

			--lazy tick
			self.lazyUpdateCooldown = self.lazyUpdateCooldown - deltaTime
			if (self.lazyUpdateCooldown < 0) then
				self:OnTick_LazyTick()
				self.lazyUpdateCooldown = self.Settings.LazyUpdateCooldown
			end

		elseif (self.channeling) then
			if (not self:OnTick_Channeling (deltaTime)) then
				return
			end

			--lazy tick
			self.lazyUpdateCooldown = self.lazyUpdateCooldown - deltaTime
			if (self.lazyUpdateCooldown < 0) then
				self:OnTick_LazyTick()
				self.lazyUpdateCooldown = self.Settings.LazyUpdateCooldown
			end
		end
	end,

	--animation start script
	Animation_FadeOutStarted = function(self)

	end,

	--animation finished script
	Animation_FadeOutFinished = function(self)
		local castBar = self:GetParent()
		castBar:SetAlpha(1)
		castBar:Hide()
	end,

	--animation start script
	Animation_FadeInStarted = function(self)

	end,

	--animation finished script
	Animation_FadeInFinished = function(self)
		local castBar = self:GetParent()
		castBar:Show()
		castBar:SetAlpha(1)
	end,

	--animation calls
	Animation_FadeOut = function(self)
		self:ScheduleToHide (false)

		if (self.fadeInAnimation:IsPlaying()) then
			self.fadeInAnimation:Stop()
		end

		if (not self.fadeOutAnimation:IsPlaying()) then
			self.fadeOutAnimation:Play()
		end
	end,

	Animation_FadeIn = function(self)
		self:ScheduleToHide (false)

		if (self.fadeOutAnimation:IsPlaying()) then
			self.fadeOutAnimation:Stop()
		end

		if (not self.fadeInAnimation:IsPlaying()) then
			self.fadeInAnimation:Play()
		end
	end,

	Animation_Flash = function(self)
		if (not self.flashAnimation:IsPlaying()) then
			self.flashAnimation:Play()
		end
	end,

	Animation_StopAllAnimations = function(self)
		if (self.flashAnimation:IsPlaying()) then
			self.flashAnimation:Stop()
		end

		if (self.fadeOutAnimation:IsPlaying()) then
			self.fadeOutAnimation:Stop()
		end

		if (self.fadeInAnimation:IsPlaying()) then
			self.fadeInAnimation:Stop()
		end
	end,

	PLAYER_ENTERING_WORLD = function(self, unit, arg1)
		local isChannel = UnitChannelInfo (unit)
		local isRegularCast = UnitCastingInfo (unit)

		if (isChannel) then
			self.channeling = true
			self:UpdateChannelInfo(unit)
			return self.unit == arg1 and "UNIT_SPELLCAST_CHANNEL_START"

		elseif (isRegularCast) then
			self.casting = true
			self:UpdateCastingInfo(unit)
			return self.unit == arg1 and "UNIT_SPELLCAST_START"

		else
			self.casting = nil
			self.channeling = nil
			self.failed = nil
			self.finished = nil
			self.interrupted = nil
			self.Spark:Hide()
			self:Hide()
		end
	end,

	UpdateCastingInfo = function(self, unit)
		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo (unit)

		--is valid?
		if (not self:IsValid (unit, name, isTradeSkill, true)) then
			return
		end
		
		--empowered? no!
			self.holdAtMaxTime = nil
			self.empowered = false
			self.curStage = nil
			self.numStages = nil
			self.empStages = nil
			self:CreateOrUpdateEmpoweredPips()

		--setup cast
			self.casting = true
			self.channeling = nil
			self.interrupted = nil
			self.failed = nil
			self.finished = nil
			self.canInterrupt = not notInterruptible
			self.spellID = spellID
			self.castID = castID
			self.spellName = name
			self.spellTexture = texture
			self.spellStartTime = startTime / 1000
			self.spellEndTime = endTime / 1000
			self.value = GetTime() - self.spellStartTime
			self.maxValue = self.spellEndTime - self.spellStartTime

			self:SetMinMaxValues(0, self.maxValue)
			self:SetValue(self.value)
			self:SetAlpha(1)
			self.Icon:SetTexture(texture)
			self.Icon:Show()
			self.Text:SetText(text or name)

			if (self.Settings.ShowCastTime and self.Settings.CanLazyTick) then
				self.percentText:Show()
			end

			self.flashTexture:Hide()
			self:Animation_StopAllAnimations()

			self:SetAlpha(1)

			--set the statusbar color
			self:UpdateCastColor()

			if (not self:IsShown()) then
				self:Animation_FadeIn()
			end

			self.Spark:Show()
			self:Show()

		--update the interrupt cast border
		self:UpdateInterruptState()

	end,

	UNIT_SPELLCAST_START = function(self, unit)

		self:UpdateCastingInfo(unit)

		self:RunHooksForWidget("OnCastStart", self, self.unit, "UNIT_SPELLCAST_START")
	end,
	
	CreateOrUpdateEmpoweredPips = function(self, unit, numStages, startTime, endTime)
		unit = unit or self.unit
		numStages = numStages or self.numStages
		startTime = startTime or ((self.spellStartTime or 0) * 1000)
		endTime = endTime or ((self.spellEndTime or 0) * 1000)
		
		if not self.empStages or not numStages or numStages <= 0 then
			self.stagePips = self.stagePips or {}
			for i, stagePip in pairs(self.stagePips) do
				stagePip:Hide()
			end
			return
		end
		
		local width = self:GetWidth()
		local height = self:GetHeight()
		for i = 1, numStages, 1 do
			local curStartTime = self.empStages[i] and self.empStages[i].start
			local curEndTime = self.empStages[i] and self.empStages[i].finish
			local curDuration = curEndTime - curStartTime
			local offset = width * curEndTime / (endTime - startTime) * 1000
			if curDuration > -1 then
				
				stagePip = self.stagePips[i]
				if not stagePip then
					stagePip = self:CreateTexture(nil, "overlay", nil, 2)
					stagePip:SetBlendMode("ADD")
					stagePip:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
					stagePip:SetTexCoord(11/32,18/32,9/32,23/32)
					stagePip:SetSize(2, height)
					--stagePip = CreateFrame("FRAME", nil, self, "CastingBarFrameStagePipTemplate")
					self.stagePips[i] = stagePip
				end
				
				stagePip:ClearAllPoints()
				--stagePip:SetPoint("TOP", self, "TOPLEFT", offset, -1)
				--stagePip:SetPoint("BOTTOM", self, "BOTTOMLEFT", offset, 1)
				--stagePip.BasePip:SetVertexColor(1, 1, 1, 1)
				stagePip:SetPoint("CENTER", self, "LEFT", offset, 0)
				stagePip:SetVertexColor(1, 1, 1, 1)
				stagePip:Show()
			end
		end
	end,

	UpdateChannelInfo = function(self, unit, ...)
		local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID, _, numStages = UnitChannelInfo (unit)

		--is valid?
		if (not self:IsValid (unit, name, isTradeSkill, true)) then
			return
		end
		
		--empowered?
			self.empStages = {}
			self.stagePips = self.stagePips or {}
			for i, stagePip in pairs(self.stagePips) do
				stagePip:Hide()
			end
			
			if numStages and numStages > 0 then
				self.holdAtMaxTime = GetUnitEmpowerHoldAtMaxTime(self.unit)
				self.empowered = true
				self.numStages = numStages
				

				local lastStageEndTime = 0
				for i = 1, numStages do
					self.empStages[i] = {
						start = lastStageEndTime,
						finish = lastStageEndTime + GetUnitEmpowerStageDuration(unit, i - 1) / 1000,
					}
					lastStageEndTime = self.empStages[i].finish
					
					if startTime / 1000 + lastStageEndTime <= GetTime() then
						self.curStage = i
					end
				end
				
				if (self.Settings.ShowEmpoweredDuration) then
					endTime = endTime + self.holdAtMaxTime
				end
				
				--create/update pips
				self:CreateOrUpdateEmpoweredPips(unit, numStages, startTime, endTime)
			else
				self.holdAtMaxTime = nil
				self.empowered = false
				self.curStage = nil
				self.numStages = nil
			end

		--setup cast
			self.casting = nil
			self.channeling = true
			self.interrupted = nil
			self.failed = nil
			self.finished = nil
			self.canInterrupt = not notInterruptible
			self.spellID = spellID
			self.castID = castID
			self.spellName = name
			self.spellTexture = texture
			self.spellStartTime = startTime / 1000
			self.spellEndTime = endTime / 1000
			self.value = self.empowered and (GetTime() - self.spellStartTime) or (self.spellEndTime - GetTime())
			self.maxValue = self.spellEndTime - self.spellStartTime
			self.reverseChanneling = self.empowered

			self:SetMinMaxValues(0, self.maxValue)
			self:SetValue(self.value)

			self:SetAlpha(1)
			self.Icon:SetTexture(texture)
			self.Icon:Show()
			self.Text:SetText(text)

			if (self.Settings.ShowCastTime and self.Settings.CanLazyTick) then
				self.percentText:Show()
			end

			self.flashTexture:Hide()
			self:Animation_StopAllAnimations()

			self:SetAlpha(1)

			--set the statusbar color
			self:UpdateCastColor()

			if (not self:IsShown()) then
				self:Animation_FadeIn()
			end

			self.Spark:Show()
			self:Show()

		--update the interrupt cast border
		self:UpdateInterruptState()

	end,

	UNIT_SPELLCAST_CHANNEL_START = function(self, unit, ...)

		self:UpdateChannelInfo(unit, ...)

		self:RunHooksForWidget("OnCastStart", self, self.unit, "UNIT_SPELLCAST_CHANNEL_START")
	end,

	UNIT_SPELLCAST_STOP = function(self, unit, ...)
		local unitID, castID, spellID = ...
		if (self.castID == castID) then
			if (self.interrupted) then
				if (self.Settings.HideSparkOnInterrupt) then
					self.Spark:Hide()
				end
			else
				self.Spark:Hide()
			end

			self.percentText:Hide()

			local value = self:GetValue()
			local _, maxValue = self:GetMinMaxValues()

			if (self.interrupted) then
				if (self.Settings.FillOnInterrupt) then
					self:SetValue(self.maxValue or maxValue or 1)
				end
			else
				self:SetValue(self.maxValue or maxValue or 1)
			end

			self.casting = nil
			self.finished = true

			if (not self:HasScheduledHide()) then
				--check if settings has no fade option or if its parents are not visible
				if (not self:IsVisible()) then
					self:Hide()

				elseif (self.Settings.NoFadeEffects) then
					self:ScheduleToHide (0.3)

				else
					self:Animation_Flash()
					self:Animation_FadeOut()
				end
			end

			self:UpdateCastColor()
		end
	end,

	UNIT_SPELLCAST_CHANNEL_STOP = function(self, unit, ...)
		local unitID, castID, spellID = ...

		if (self.channeling and castID == self.castID) then
			self.Spark:Hide()
			self.percentText:Hide()

			local value = self:GetValue()
			local _, maxValue = self:GetMinMaxValues()
			self:SetValue(self.maxValue or maxValue or 1)

			self.channeling = nil
			self.finished = true

			if (not self:HasScheduledHide()) then
				--check if settings has no fade option or if its parents are not visible
				if (not self:IsVisible()) then
					self:Hide()

				elseif (self.Settings.NoFadeEffects) then
					self:ScheduleToHide (0.3)

				else
					self:Animation_Flash()
					self:Animation_FadeOut()
				end
			end

			self:UpdateCastColor()
		end
	end,
	
	UNIT_SPELLCAST_EMPOWER_START = function(self, unit, ...)
		self:UNIT_SPELLCAST_CHANNEL_START(unit, ...)
	end,
	
	UNIT_SPELLCAST_EMPOWER_UPDATE = function(self, unit, ...)
		self:UNIT_SPELLCAST_CHANNEL_UPDATE(unit, ...)
	end,
	
	UNIT_SPELLCAST_EMPOWER_STOP = function(self, unit, ...)
		self:UNIT_SPELLCAST_CHANNEL_STOP(unit, ...)
	end,

	UNIT_SPELLCAST_FAILED = function(self, unit, ...)
		local unitID, castID, spellID = ...

		if ((self.casting or self.channeling) and castID == self.castID and not self.fadeOut) then
			self.casting = nil
			self.channeling = nil
			self.failed = true
			self.finished = true
			self:SetValue(self.maxValue or select(2, self:GetMinMaxValues()) or 1)

			--set the statusbar color
			self:UpdateCastColor()

			self.Spark:Hide()
			self.percentText:Hide()
			self.Text:SetText(FAILED) --auto locale within the global namespace

			self:ScheduleToHide (1)
		end
	end,

	UNIT_SPELLCAST_INTERRUPTED = function(self, unit, ...)
		local unitID, castID, spellID = ...

		if ((self.casting or self.channeling) and castID == self.castID and not self.fadeOut) then
			self.casting = nil
			self.channeling = nil
			self.interrupted = true
			self.finished = true

			if (self.Settings.FillOnInterrupt) then
				self:SetValue(self.maxValue or select(2, self:GetMinMaxValues()) or 1)
			end

			if (self.Settings.HideSparkOnInterrupt) then
				self.Spark:Hide()
			end

			local castColor = self:GetCastColor()
			self:SetColor (castColor) --SetColor handles with ParseColors()

			self.percentText:Hide()
			self.Text:SetText(INTERRUPTED) --auto locale within the global namespace

			self:ScheduleToHide (1)
		end
	end,

	UNIT_SPELLCAST_DELAYED = function(self, unit, ...)
		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo (unit)

		if (not self:IsValid (unit, name, isTradeSkill)) then
			return
		end

		--update the cast time
		self.spellStartTime = startTime / 1000
		self.spellEndTime = endTime / 1000
		self.value = GetTime() - self.spellStartTime
		self.maxValue = self.spellEndTime - self.spellStartTime
		self:SetMinMaxValues(0, self.maxValue)
	end,

	UNIT_SPELLCAST_CHANNEL_UPDATE = function(self, unit, ...)
		local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID, _, numStages = UnitChannelInfo (unit)

		if (not self:IsValid (unit, name, isTradeSkill)) then
			return
		end

		--update the cast time
		self.spellStartTime = startTime / 1000
		self.spellEndTime = endTime / 1000
		self.value = self.empowered and (GetTime() - self.spellStartTime) or (self.spellEndTime - GetTime())
		self.maxValue = self.spellEndTime - self.spellStartTime

		if (self.value < 0 or self.value >= self.maxValue) then
			self.value = 0
		end

		self:SetMinMaxValues(0, self.maxValue)
		self:SetValue(self.value)
	end,

	--cast changed its state to interruptable
	UNIT_SPELLCAST_INTERRUPTIBLE = function(self, unit, ...)
		self.canInterrupt = true
		self:UpdateCastColor()
		self:UpdateInterruptState()
	end,

	--cast changed its state to non interruptable
	UNIT_SPELLCAST_NOT_INTERRUPTIBLE = function(self, unit, ...)
		self.canInterrupt = false
		self:UpdateCastColor()
		self:UpdateInterruptState()
	end,

}

detailsFramework:Mixin(detailsFramework.CastFrameFunctions, detailsFramework.ScriptHookMixin)

-- for classic era use LibClassicCasterino:
local LibCC = LibStub("LibClassicCasterino", true)
if IS_WOW_PROJECT_CLASSIC_ERA and LibCC then
	local fCast = CreateFrame("frame")

	local getCastBar = function(unitId)
		local plateFrame = C_NamePlate.GetNamePlateForUnit (unitId)
		if (not plateFrame) then
			return
		end

		local castBar = plateFrame.unitFrame and plateFrame.unitFrame.castBar
		if (not castBar) then
			return
		end

		return castBar
	end

	local triggerCastEvent = function(castBar, event, unitId, ...)
		if (castBar and castBar.OnEvent) then
			castBar.OnEvent (castBar, event, unitId)
		end
	end

	local funcCast = function(event, unitId, ...)
		local castBar = getCastBar (unitId)
		if (castBar) then
			triggerCastEvent (castBar, event, unitId)
		end
	end

	fCast.UNIT_SPELLCAST_START = function(self, event, unitId, ...)
		triggerCastEvent (getCastBar (unitId), event, unitId)
	end

	fCast.UNIT_SPELLCAST_STOP = function(self, event, unitId, ...)
		triggerCastEvent (getCastBar (unitId), event, unitId)
	end

	fCast.UNIT_SPELLCAST_DELAYED = function(self, event, unitId, ...)
		triggerCastEvent (getCastBar (unitId), event, unitId)
	end

	fCast.UNIT_SPELLCAST_FAILED = function(self, event, unitId, ...)
		triggerCastEvent (getCastBar (unitId), event, unitId)
	end

	fCast.UNIT_SPELLCAST_INTERRUPTED = function(self, event, unitId, ...)
		triggerCastEvent (getCastBar (unitId), event, unitId)
	end

	fCast.UNIT_SPELLCAST_CHANNEL_START = function(self, event, unitId, ...)
		triggerCastEvent (getCastBar (unitId), event, unitId)
	end

	fCast.UNIT_SPELLCAST_CHANNEL_UPDATE = function(self, event, unitId, ...)
		triggerCastEvent (getCastBar (unitId), event, unitId)
	end

	fCast.UNIT_SPELLCAST_CHANNEL_STOP = function(self, event, unitId, ...)
		triggerCastEvent (getCastBar (unitId), event, unitId)
	end

	if LibCC then
		LibCC.RegisterCallback(fCast,"UNIT_SPELLCAST_START", funcCast)
		LibCC.RegisterCallback(fCast,"UNIT_SPELLCAST_DELAYED", funcCast) -- only for player
		LibCC.RegisterCallback(fCast,"UNIT_SPELLCAST_STOP", funcCast)
		LibCC.RegisterCallback(fCast,"UNIT_SPELLCAST_FAILED", funcCast)
		LibCC.RegisterCallback(fCast,"UNIT_SPELLCAST_INTERRUPTED", funcCast)
		LibCC.RegisterCallback(fCast,"UNIT_SPELLCAST_CHANNEL_START", funcCast)
		LibCC.RegisterCallback(fCast,"UNIT_SPELLCAST_CHANNEL_UPDATE", funcCast) -- only for player
		LibCC.RegisterCallback(fCast,"UNIT_SPELLCAST_CHANNEL_STOP", funcCast)

		UnitCastingInfo = function(unit)
			return LibCC:UnitCastingInfo (unit)
		end

		UnitChannelInfo = function(unit)
			return LibCC:UnitChannelInfo (unit)
		end
	end
end -- end classic era

-- ~castbar

function detailsFramework:CreateCastBar(parent, name, settingsOverride)
	assert(name or parent:GetName(), "DetailsFramework:CreateCastBar parameter 'name' omitted and parent has no name.")

	local castBar = CreateFrame("StatusBar", name or (parent:GetName() .. "CastBar"), parent, "BackdropTemplate")

		do --layers

			--these widgets was been made with back compatibility in mind
			--they are using the same names as the retail game uses on the nameplate castbar
			--this should make Plater core and Plater scripts made by users compatible with the new unit frame made on the framework

			--background
			castBar.background = castBar:CreateTexture(nil, "background", nil, -6)
			castBar.extraBackground = castBar:CreateTexture(nil, "background", nil, -5)

			--overlay
			castBar.Text = castBar:CreateFontString(nil, "overlay", "SystemFont_Shadow_Small")
			castBar.Text:SetDrawLayer("overlay", 1)
			castBar.Text:SetPoint("center", 0, 0)

			castBar.BorderShield = castBar:CreateTexture(nil, "overlay", nil, 5)
			castBar.BorderShield:Hide()

			castBar.Icon = castBar:CreateTexture(nil, "overlay", nil, 4)
			castBar.Icon:Hide()

			castBar.Spark = castBar:CreateTexture(nil, "overlay", nil, 3)
			castBar.Spark:SetBlendMode("ADD")

			--time left on the cast
			castBar.percentText = castBar:CreateFontString(nil, "overlay", "SystemFont_Shadow_Small")
			castBar.percentText:SetDrawLayer("overlay", 7)

			--statusbar texture
			castBar.barTexture = castBar:CreateTexture(nil, "artwork", nil, -6)
			castBar:SetStatusBarTexture(castBar.barTexture)

			--animations fade in and out
			local fadeOutAnimationHub = detailsFramework:CreateAnimationHub (castBar, detailsFramework.CastFrameFunctions.Animation_FadeOutStarted, detailsFramework.CastFrameFunctions.Animation_FadeOutFinished)
			fadeOutAnimationHub.alpha1 = detailsFramework:CreateAnimation(fadeOutAnimationHub, "ALPHA", 1, 1, 1, 0)
			castBar.fadeOutAnimation = fadeOutAnimationHub

			local fadeInAnimationHub = detailsFramework:CreateAnimationHub (castBar, detailsFramework.CastFrameFunctions.Animation_FadeInStarted, detailsFramework.CastFrameFunctions.Animation_FadeInFinished)
			fadeInAnimationHub.alpha1 = detailsFramework:CreateAnimation(fadeInAnimationHub, "ALPHA", 1, 0.150, 0, 1)
			castBar.fadeInAnimation = fadeInAnimationHub

			--animatios flash
			local flashTexture = castBar:CreateTexture(nil, "overlay", nil, 7)
			flashTexture:SetColorTexture(1, 1, 1, 1)
			flashTexture:SetAllPoints()
			flashTexture:SetAlpha(0)
			flashTexture:Hide()
			flashTexture:SetBlendMode("ADD")
			castBar.flashTexture = flashTexture

			local flashAnimationHub = detailsFramework:CreateAnimationHub (flashTexture, function() flashTexture:Show() end, function() flashTexture:Hide() end)
			detailsFramework:CreateAnimation(flashAnimationHub, "ALPHA", 1, 0.2, 0, 0.8)
			detailsFramework:CreateAnimation(flashAnimationHub, "ALPHA", 2, 0.2, 1, 0)
			castBar.flashAnimation = flashAnimationHub
		end

	--mixins
	detailsFramework:Mixin(castBar, detailsFramework.CastFrameFunctions)
	detailsFramework:Mixin(castBar, detailsFramework.StatusBarFunctions)

	castBar:CreateTextureMask()
	castBar:AddMaskTexture(castBar.flashTexture)
	castBar:AddMaskTexture(castBar.background)
	castBar:AddMaskTexture(castBar.extraBackground)

	castBar:SetTexture([[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]])

	--settings and hooks
	local settings = detailsFramework.table.copy({}, detailsFramework.CastFrameFunctions.Settings)
	if (settingsOverride) then
		detailsFramework.table.copy(settings, settingsOverride)
	end
	castBar.Settings = settings

	local hookList = detailsFramework.table.copy({}, detailsFramework.CastFrameFunctions.HookList)
	castBar.HookList = hookList

	--initialize the cast bar
	castBar:Initialize()

	return castBar
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--border frame

--[=[
	DF:CreateBorderFrame (parent, name)
	creates a frame with 4 child textures attached to each one of the 4 sides of a frame
	@parent = parent frame to pass to CreateFrame function
	@name = name of the frame, if omitted a random name is created
--]=]

detailsFramework.BorderFunctions = {
	SetBorderColor = function(self, r, g, b, a)
		r, g, b, a = detailsFramework:ParseColors(r, g, b, a)
		for _, texture in ipairs(self.allTextures) do
			texture:SetVertexColor(r, g, b, a)
		end
	end,

	SetBorderThickness = function(self, newThickness)
		PixelUtil.SetWidth (self.leftBorder, newThickness, newThickness)
		PixelUtil.SetWidth (self.rightBorder, newThickness, newThickness)
		PixelUtil.SetHeight(self.topBorder, newThickness, newThickness)
		PixelUtil.SetHeight(self.bottomBorder, newThickness, newThickness)
	end,

	WidgetType = "border",
}

-- ~borderframe
function detailsFramework:CreateBorderFrame (parent, name)
	local parentName = name or "DetailsFrameworkBorderFrame" .. tostring(math.random(1, 100000000))

	local f = CreateFrame("frame", parentName, parent, "BackdropTemplate")
	f:SetFrameLevel(f:GetFrameLevel()+1)
	f:SetAllPoints()

	detailsFramework:Mixin(f, detailsFramework.BorderFunctions)

	f.allTextures = {}

	--create left border
		local leftBorder = f:CreateTexture(nil, "overlay")
		leftBorder:SetDrawLayer("overlay", 7)
		leftBorder:SetColorTexture(1, 1, 1, 1)
		tinsert(f.allTextures, leftBorder)
		f.leftBorder = leftBorder
		PixelUtil.SetPoint(leftBorder, "topright", f, "topleft", 0, 1, 0, 1)
		PixelUtil.SetPoint(leftBorder, "bottomright", f, "bottomleft", 0, -1, 0, -1)
		PixelUtil.SetWidth (leftBorder, 1, 1)

	--create right border
		local rightBorder = f:CreateTexture(nil, "overlay")
		rightBorder:SetDrawLayer("overlay", 7)
		rightBorder:SetColorTexture(1, 1, 1, 1)
		tinsert(f.allTextures, rightBorder)
		f.rightBorder = rightBorder
		PixelUtil.SetPoint(rightBorder, "topleft", f, "topright", 0, 1, 0, 1)
		PixelUtil.SetPoint(rightBorder, "bottomleft", f, "bottomright", 0, -1, 0, -1)
		PixelUtil.SetWidth (rightBorder, 1, 1)

	--create top border
		local topBorder = f:CreateTexture(nil, "overlay")
		topBorder:SetDrawLayer("overlay", 7)
		topBorder:SetColorTexture(1, 1, 1, 1)
		tinsert(f.allTextures, topBorder)
		f.topBorder = topBorder
		PixelUtil.SetPoint(topBorder, "bottomleft", f, "topleft", 0, 0, 0, 0)
		PixelUtil.SetPoint(topBorder, "bottomright", f, "topright", 0, 0, 0, 0)
		PixelUtil.SetHeight(topBorder, 1, 1)

	--create  border
		local bottomBorder = f:CreateTexture(nil, "overlay")
		bottomBorder:SetDrawLayer("overlay", 7)
		bottomBorder:SetColorTexture(1, 1, 1, 1)
		tinsert(f.allTextures, bottomBorder)
		f.bottomBorder = bottomBorder
		PixelUtil.SetPoint(bottomBorder, "topleft", f, "bottomleft", 0, 0, 0, 0)
		PixelUtil.SetPoint(bottomBorder, "topright", f, "bottomright", 0, 0, 0, 0)
		PixelUtil.SetHeight(bottomBorder, 1, 1)

	return f
end



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--unit frame

--[=[
	DF:CreateUnitFrame(parent, name, settingsOverride)
	creates a very basic unit frame with a healthbar, castbar and power bar
	each unit frame has a .Settings table which isn't shared among other unit frames created with this method
	all members names are the same as the unit frame from the retail game

	@parent = frame to pass for the CreateFrame function
	@name = absolute name of the frame, if omitted a random name is created
	@settingsOverride = table with keys and values to replace the defaults from the framework

--]=]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--unit frame

	--return true if the unit has been claimed by another player (health bar is gray)
	local isUnitTapDenied = function(unit)
		return unit and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)
	end

	detailsFramework.UnitFrameFunctions = {
		WidgetType = "unitFrame",

		Settings = {
			--unit frames
			ClearUnitOnHide = true, --if tue it'll set the unit to nil when the unit frame is set to hide
			ShowCastBar = true, --if this is false, the cast bar for the unit won't be shown
			ShowPowerBar = true, --if true it'll show the power bar for the unit, e.g. the mana bar
			ShowUnitName = true, --if false, the unit name won't show
			ShowBorder = true, --if false won't show the border frame

			--health bar color
			CanModifyHealhBarColor = true, --if false it won't change the color of the health bar
			ColorByAggro = false, --if true it'll color the healthbar with red color when the unit has aggro on player
			FixedHealthColor = false, --color override with a table {r=1, g=1, b=1}
			UseFriendlyClassColor = true, --make the healthbar class color for friendly players
			UseEnemyClassColor = true, --make the healthbar class color for enemy players

			--misc
			ShowTargetOverlay = true, --shows a highlighht for the player current target
			BorderColor = detailsFramework:CreateColorTable (0, 0, 0, 1), --border color, set to alpha zero for no border
			CanTick = false, --if true it'll run the OnTick event

			--size
			Width = 100,
			Height = 20,
			PowerBarHeight = 4,
			CastBarHeight = 8,
		},

		UnitFrameEvents = {
			--run for all units
			{"PLAYER_ENTERING_WORLD"},
			{"PARTY_MEMBER_DISABLE"},
			{"PARTY_MEMBER_ENABLE"},
			{"PLAYER_TARGET_CHANGED"},

			--run for one unit
			{"UNIT_NAME_UPDATE", true},
			{"UNIT_CONNECTION", true},
			{"UNIT_ENTERED_VEHICLE", true},
			{"UNIT_EXITED_VEHICLE", true},
			{"UNIT_PET", true},
			{"UNIT_THREAT_LIST_UPDATE", true},
		},

		--used when a event is triggered to quickly check if is a unit event
		IsUnitEvent = {
			["UNIT_NAME_UPDATE"] = true,
			["UNIT_CONNECTION"] = true,
			["UNIT_ENTERED_VEHICLE"] = true,
			["UNIT_EXITED_VEHICLE"] = true,
			["UNIT_PET"] = true,
			["UNIT_THREAT_LIST_UPDATE"] = true,
		},

		Initialize = function(self)
			self.border:SetBorderColor (self.Settings.BorderColor)

			PixelUtil.SetWidth (self, self.Settings.Width, 1)
			PixelUtil.SetHeight(self, self.Settings.Height, 1)

			PixelUtil.SetPoint(self.powerBar, "bottomleft", self, "bottomleft", 0, 0, 1, 1)
			PixelUtil.SetPoint(self.powerBar, "bottomright", self, "bottomright", 0, 0, 1, 1)
			PixelUtil.SetHeight(self.powerBar, self.Settings.PowerBarHeight, 1)

			--make the castbar overlap the powerbar
			PixelUtil.SetPoint(self.castBar, "bottomleft", self, "bottomleft", 0, 0, 1, 1)
			PixelUtil.SetPoint(self.castBar, "bottomright", self, "bottomright", 0, 0, 1, 1)
			PixelUtil.SetHeight(self.castBar, self.Settings.CastBarHeight, 1)
		end,

		SetHealthBarColor = function(self, r, g, b, a)
			self.healthBar:SetColor (r, g, b, a)
		end,

		--register all events which will be used by the unit frame
		RegisterEvents = function(self)
			--register events
			for index, eventTable in ipairs(self.UnitFrameEvents) do
				local event, isUnitEvent = unpack(eventTable)
				if (not isUnitEvent) then
					self:RegisterEvent(event)
				else
					self:RegisterUnitEvent (event, self.unit, self.displayedUnit ~= unit and self.displayedUnit or nil)
				end
			end

			--check settings and unregister events for disabled features
			if (not self.Settings.ColorByAggro) then
				self:UnregisterEvent ("UNIT_THREAT_LIST_UPDATE")
			end

			--set scripts
			self:SetScript("OnEvent", self.OnEvent)
			self:SetScript("OnHide", self.OnHide)

			if (self.Settings.CanTick) then
				self:SetScript("OnUpdate", self.OnTick)
			end
		end,

		--unregister events, called when this unit frame losses its unit
		UnregisterEvents = function(self)
			for index, eventTable in ipairs(self.UnitFrameEvents) do
				local event, firstUnit, secondUnit = unpack(eventTable)
				self:UnregisterEvent (event)
			end

			self:SetScript("OnEvent", nil)
			self:SetScript("OnUpdate", nil)
			self:SetScript("OnHide", nil)
		end,

		--call every tick
		OnTick = function(self, deltaTime) end, --if overrided, set 'CanTick' to true on the settings table

		--when an event happen for this unit, send it to the apropriate function
		OnEvent = function(self, event, ...)
			--run the function for this event
			local eventFunc = self [event]
			if (eventFunc) then
				--is this event an unit event?
				if (self.IsUnitEvent [event]) then
					local unit = ...
					--check if is for this unit (even if the event is registered only for the unit)
					if (unit == self.unit or unit == self.displayedUnit) then
						eventFunc (self, ...)
					end
				else
					eventFunc (self, ...)
				end
			end
		end,

		OnHide = function(self)
			if (self.Settings.ClearUnitOnHide) then
				self:SetUnit(nil)
			end
		end,

		--run if the unit currently shown is different than the new one
		SetUnit = function(self, unit)
			if (unit ~= self.unit or unit == nil) then
				self.unit = unit --absolute unit
				self.displayedUnit = unit --~todo rename to 'displayedUnit' for back compatibility with older scripts in Plater
				self.unitInVehicle = nil --true when the unit is in a vehicle

				if (unit) then
					self:RegisterEvents()

					self.healthBar:SetUnit(unit, self.displayedUnit)

					--is using castbars?
					if (self.Settings.ShowCastBar) then
						self.castBar:SetUnit(unit, self.displayedUnit)
					else
						self.castBar:SetUnit(nil)
					end

					--is using powerbars?
					if (self.Settings.ShowPowerBar) then
						self.powerBar:SetUnit(unit, self.displayedUnit)
					else
						self.powerBar:SetUnit(nil)
					end

					--is using the border?
					if (self.Settings.ShowBorder) then
						self.border:Show()
					else
						self.border:Hide()
					end

					if (not self.Settings.ShowUnitName) then
						self.unitName:Hide()
					end
				else
					self:UnregisterEvents()
					self.healthBar:SetUnit(nil)
					self.castBar:SetUnit(nil)
					self.powerBar:SetUnit(nil)
				end

				self:UpdateUnitFrame()
			end
		end,

		--if the unit is controlling a vehicle, need to show the vehicle instead
		--.unit and .displayedUnit is always the same execept when the unit is controlling a vehicle, then .displayedUnit is the unitID for the vehicle
		--todo: see what 'UnitTargetsVehicleInRaidUI' is, there's a call for this in the CompactUnitFrame.lua but zero documentation
		CheckVehiclePossession = function(self)
			--this unit is possessing a vehicle?
			local unitPossessVehicle = (IS_WOW_PROJECT_MAINLINE) and UnitHasVehicleUI(self.unit)	or false
			if (unitPossessVehicle) then
				if (not self.unitInVehicle) then
					if (UnitIsUnit("player", self.unit)) then
						self.displayedUnit = "vehicle"
						self.unitInVehicle = true
						self:RegisterEvents()
						self:UpdateAllWidgets()
						return true
					end

					local prefix, id, suffix = string.match(self.unit, "([^%d]+)([%d]*)(.*)") --CompactUnitFrame.lua
					local vehicleUnitID = prefix .. "pet" .. id .. suffix
					if (UnitExists(vehicleUnitID)) then
						self.displayedUnit = vehicleUnitID
						self.unitInVehicle = true
						self:RegisterEvents()
						self:UpdateAllWidgets()
						return true
					end
				end
			end

			if (self.unitInVehicle) then
				self.displayedUnit = self.unit
				self.unitInVehicle = nil
				self:RegisterEvents()
				self:UpdateAllWidgets()
			end
		end,

		--find a color for the health bar, if a color has been passed in the arguments use it instead, 'CanModifyHealhBarColor' must be true for this function run
		UpdateHealthColor = function(self, r, g, b)
			--check if color changes is disabled
			if (not self.Settings.CanModifyHealhBarColor) then
				return
			end

			local unit = self.displayedUnit

			--check if a color has been passed within the parameters
			if (r) then
				--check if passed a special color
				if (type(r) ~= "number") then
					r, g, b = detailsFramework:ParseColors(r)
				end

				self:SetHealthBarColor (r, g, b)
				return
			end

			--check if there is a color override in the settings
			if (self.Settings.FixedHealthColor) then
				local FixedHealthColor = self.Settings.FixedHealthColor
				r, g, b = FixedHealthColor.r, FixedHealthColor.g, FixedHealthColor.b
				self:SetHealthBarColor (r, g, b)
				return
			end

			--check if the unit is a player
			if (UnitIsPlayer (unit)) then
				--check if the unit is disconnected (in case it is a player
				if (not UnitIsConnected (unit)) then
					self:SetHealthBarColor (.5, .5, .5)
					return
				end

				--is a friendly or enemy player?
				if (UnitIsFriend ("player", unit)) then
					if (self.Settings.UseFriendlyClassColor) then
						local _, className = UnitClass(unit)
						if (className) then
							local classColor = RAID_CLASS_COLORS [className]
							if (classColor) then
								self:SetHealthBarColor (classColor.r, classColor.g, classColor.b)
								return
							end
						end
					else
						self:SetHealthBarColor (0, 1, 0)
						return
					end
				else
					if (self.Settings.UseEnemyClassColor) then
						local _, className = UnitClass(unit)
						if (className) then
							local classColor = RAID_CLASS_COLORS [className]
							if (classColor) then
								self:SetHealthBarColor (classColor.r, classColor.g, classColor.b)
								return
							end
						end
					else
						self:SetHealthBarColor (1, 0, 0)
						return
					end
				end
			end

			--is tapped?
			if (isUnitTapDenied (unit)) then
				self:SetHealthBarColor (.6, .6, .6)
				return
			end

			--is this is a npc attacking the player?
			if (self.Settings.ColorByAggro) then
				local _, threatStatus = UnitDetailedThreatSituation ("player", unit)
				if (threatStatus) then
					self:SetHealthBarColor (1, 0, 0)
					return
				end
			end

			-- get the regular color by selection
			r, g, b = UnitSelectionColor (unit)
			self:SetHealthBarColor (r, g, b)
		end,

		--misc
		UpdateName = function(self)
			if (not self.Settings.ShowUnitName) then
				return
			end

			--unit name without realm names by default
			local name = UnitName (self.unit)
			self.unitName:SetText(name)
			self.unitName:Show()
		end,

		--this runs when the player it self changes its target, need to update the current target overlay
		--todo: add focus overlay
		UpdateTargetOverlay = function(self)
			if (not self.Settings.ShowTargetOverlay) then
				self.targetOverlay:Hide()
				return
			end

			if (UnitIsUnit(self.displayedUnit, "target")) then
				self.targetOverlay:Show()
			else
				self.targetOverlay:Hide()
			end
		end,

		UpdateAllWidgets = function(self)
			if (UnitExists(self.displayedUnit)) then
				local unit = self.unit
				local displayedUnit = self.displayedUnit

				self:SetUnit(unit, displayedUnit)

				--is using castbars?
				if (self.Settings.ShowCastBar) then
					self.castBar:SetUnit(unit, displayedUnit)
				end

				--is using powerbars?
				if (self.Settings.ShowPowerBar) then
					self.powerBar:SetUnit(unit, displayedUnit)
				end

				self:UpdateName()
				self:UpdateTargetOverlay()
				self:UpdateHealthColor()
			end
		end,

		--update the unit frame and its widgets
		UpdateUnitFrame = function(self)
			local unitInVehicle = self:CheckVehiclePossession()

			--if the unit is inside a vehicle, the vehicle possession function will call an update on all widgets
			if (not unitInVehicle) then
				self:UpdateAllWidgets()
			end
		end,

		--event handles
		PLAYER_ENTERING_WORLD = function(self, ...)
			self:UpdateUnitFrame()
		end,

		--update overlays when the player changes its target
		PLAYER_TARGET_CHANGED = function(self, ...)
			self:UpdateTargetOverlay()
		end,

		--unit received a name update
		UNIT_NAME_UPDATE = function(self, ...)
			self:UpdateName()
		end,

		--this is registered only if .settings.ColorByAggro is true
		UNIT_THREAT_LIST_UPDATE = function(self, ...)
			if (self.Settings.ColorByAggro) then
				self:UpdateHealthColor()
			end
		end,

		--vehicle
		UNIT_ENTERED_VEHICLE = function(self, ...)
			self:UpdateUnitFrame()
		end,
		UNIT_EXITED_VEHICLE = function(self, ...)
			self:UpdateUnitFrame()
		end,

		--pet
		UNIT_PET = function(self, ...)
			self:UpdateUnitFrame()
		end,

		--player connection
		UNIT_CONNECTION = function(self, ...)
			if (UnitIsConnected (self.unit)) then
				self:UpdateUnitFrame()
			end
		end,
		PARTY_MEMBER_ENABLE = function(self, ...)
			if (UnitIsConnected (self.unit)) then
				self:UpdateName()
			end
		end,
	}

-- ~unitframe
local globalBaseFrameLevel = 1 -- to be increased + used across each new plate
function detailsFramework:CreateUnitFrame(parent, name, unitFrameSettingsOverride, healthBarSettingsOverride, castBarSettingsOverride, powerBarSettingsOverride)
	local parentName = name or ("DetailsFrameworkUnitFrame" .. tostring(math.random(1, 100000000)))

	--create the main unit frame
	local mewUnitFrame = CreateFrame("button", parentName, parent, "BackdropTemplate")

	--base level
	--local baseFrameLevel = f:GetFrameLevel()
	local baseFrameLevel = globalBaseFrameLevel
	globalBaseFrameLevel = globalBaseFrameLevel + 50

	mewUnitFrame:SetFrameLevel(baseFrameLevel)

	--create the healthBar
	local healthBar = detailsFramework:CreateHealthBar(mewUnitFrame, false, healthBarSettingsOverride)
	healthBar:SetFrameLevel(baseFrameLevel + 1)
	mewUnitFrame.healthBar = healthBar

	--create the power bar
	local powerBar = detailsFramework:CreatePowerBar(mewUnitFrame, false, powerBarSettingsOverride)
	powerBar:SetFrameLevel(baseFrameLevel + 2)
	mewUnitFrame.powerBar = powerBar

	--create the castBar
	local castBar = detailsFramework:CreateCastBar(mewUnitFrame, false, castBarSettingsOverride)
	castBar:SetFrameLevel(baseFrameLevel + 3)
	mewUnitFrame.castBar = castBar

	--border frame
	local borderFrame = detailsFramework:CreateBorderFrame(mewUnitFrame, mewUnitFrame:GetName() .. "Border")
	borderFrame:SetFrameLevel(mewUnitFrame:GetFrameLevel() + 5)
	mewUnitFrame.border = borderFrame

	--overlay frame (widgets that need to stay above the unit frame)
	local overlayFrame = CreateFrame("frame", "$parentOverlayFrame", mewUnitFrame, "BackdropTemplate")
	overlayFrame:SetFrameLevel(mewUnitFrame:GetFrameLevel() + 6)
	mewUnitFrame.overlayFrame = overlayFrame

	--unit frame layers
		do
			--artwork
			mewUnitFrame.unitName = mewUnitFrame:CreateFontString(nil, "artwork", "GameFontHighlightSmall")
			PixelUtil.SetPoint(mewUnitFrame.unitName, "topleft", healthBar, "topleft", 2, -2, 1, 1)

			--target overlay - it's parented in the healthbar so other widgets won't get the overlay
			mewUnitFrame.targetOverlay = overlayFrame:CreateTexture(nil, "artwork")
			mewUnitFrame.targetOverlay:SetTexture(healthBar:GetTexture())
			mewUnitFrame.targetOverlay:SetBlendMode("ADD")
			mewUnitFrame.targetOverlay:SetAlpha(.5)
			mewUnitFrame.targetOverlay:SetAllPoints(healthBar)
		end

	--mixins
		--inject mixins
		detailsFramework:Mixin(mewUnitFrame, detailsFramework.UnitFrameFunctions)

		--create the settings table and copy the overrides into it, the table is set into the frame after the mixin
		local unitFrameSettings = detailsFramework.table.copy({}, detailsFramework.UnitFrameFunctions.Settings)
		if (unitFrameSettingsOverride) then
			unitFrameSettings = detailsFramework.table.copy(unitFrameSettings, unitFrameSettingsOverride)
		end
		mewUnitFrame.Settings = unitFrameSettings

	--initialize scripts
		--unitframe
		mewUnitFrame:Initialize()

	return mewUnitFrame
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--horizontal scroll frame

local timeline_options = {
	width = 400,
	height = 700,
	line_height = 20,
	line_padding = 1,

	show_elapsed_timeline = true,
	elapsed_timeline_height = 20,

	--space to put the player/spell name and icons
	header_width = 150,

	--how many pixels will be use to represent 1 second
	pixels_per_second = 20,

	scale_min = 0.15,
	scale_max = 1,

	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdrop_color = {0, 0, 0, 0.2},
	backdrop_color_highlight = {.2, .2, .2, 0.4},
	backdrop_border_color = {0.1, 0.1, 0.1, .2},

	slider_backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	slider_backdrop_color = {0, 0, 0, 0.2},
	slider_backdrop_border_color = {0.1, 0.1, 0.1, .2},

	title_template = "ORANGE_FONT_TEMPLATE",
	text_tempate = "OPTIONS_FONT_TEMPLATE",

	on_enter = function(self)
		self:SetBackdropColor(unpack(self.backdrop_color_highlight))
	end,
	on_leave = function(self)
		self:SetBackdropColor(unpack(self.backdrop_color))
	end,

	block_on_enter = function(self)

	end,
	block_on_leave = function(self)

	end,
}

local elapsedtime_frame_options = {
	backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdrop_color = {.3, .3, .3, .7},

	text_color = {1, 1, 1, 1},
	text_size = 12,
	text_font = "Arial Narrow",
	text_outline = "NONE",

	height = 20,

	distance = 200, --distance in pixels between each label informing the time
	distance_min = 50, --minimum distance in pixels
	draw_line = true, --if true it'll draw a vertical line to represent a segment
	draw_line_color = {1, 1, 1, 0.2},
	draw_line_thickness = 1,
}

detailsFramework.TimeLineElapsedTimeFunctions = {
	--get a label and update its appearance
	GetLabel = function(self, index)
		local label = self.labels [index]

		if (not label) then
			label = self:CreateFontString(nil, "artwork", "GameFontNormal")
			label.line = self:CreateTexture(nil, "artwork")
			label.line:SetColorTexture(1, 1, 1)
			label.line:SetPoint("topleft", label, "bottomleft", 0, -2)
			self.labels [index] = label
		end

		detailsFramework:SetFontColor(label, self.options.text_color)
		detailsFramework:SetFontSize(label, self.options.text_size)
		detailsFramework:SetFontFace (label, self.options.text_font)
		detailsFramework:SetFontOutline (label, self.options.text_outline)

		if (self.options.draw_line) then
			label.line:SetVertexColor(unpack(self.options.draw_line_color))
			label.line:SetWidth(self.options.draw_line_thickness)
			label.line:Show()
		else
			label.line:Hide()
		end

		return label
	end,

	Reset = function(self)
		for i = 1, #self.labels do
			self.labels [i]:Hide()
		end
	end,

	Refresh = function(self, elapsedTime, scale)
		local parent = self:GetParent()

		self:SetHeight(self.options.height)
		local effectiveArea = self:GetWidth() --already scaled down width
		local pixelPerSecond = elapsedTime / effectiveArea --how much 1 pixels correlate to time

		local distance = self.options.distance --pixels between each segment
		local minDistance = self.options.distance_min --min pixels between each segment

		--scale the distance between each label showing the time with the parent's scale
		distance = distance * scale
		distance = max(distance, minDistance)

		local amountSegments = ceil (effectiveArea / distance)

		for i = 1, amountSegments do
			local label = self:GetLabel (i)
			local xOffset = distance * (i - 1)
			label:SetPoint("left", self, "left", xOffset, 0)

			local secondsOfTime = pixelPerSecond * xOffset

			label:SetText(detailsFramework:IntegerToTimer(floor(secondsOfTime)))

			if (label.line:IsShown()) then
				label.line:SetHeight(parent:GetParent():GetHeight())
			end

			label:Show()
		end
	end,
}

--creates a frame to show the elapsed time in a row
function detailsFramework:CreateElapsedTimeFrame(parent, name, options)
	local elapsedTimeFrame = CreateFrame("frame", name, parent, "BackdropTemplate")

	detailsFramework:Mixin(elapsedTimeFrame, detailsFramework.OptionsFunctions)
	detailsFramework:Mixin(elapsedTimeFrame, detailsFramework.LayoutFrame)
	detailsFramework:Mixin(elapsedTimeFrame, detailsFramework.TimeLineElapsedTimeFunctions)

	elapsedTimeFrame:BuildOptionsTable(elapsedtime_frame_options, options)

	elapsedTimeFrame:SetBackdrop(elapsedTimeFrame.options.backdrop)
	elapsedTimeFrame:SetBackdropColor(unpack(elapsedTimeFrame.options.backdrop_color))

	elapsedTimeFrame.labels = {}

	return elapsedTimeFrame
end


detailsFramework.TimeLineBlockFunctions = {
	--self is the line
	SetBlock = function(self, index, blockInfo)
		--get the block information
		--see what is the current scale
		--adjust the block position

		local block = self:GetBlock (index)

		--need:
			--the total time of the timeline
			--the current scale of the timeline
			--the elapsed time of this block
			--icon of the block
			--text
			--background color

	end,

	SetBlocksFromData = function(self)
		local parent = self:GetParent():GetParent()
		local data = parent.data
		local defaultColor = parent.defaultColor --guarantee to have a value

		self:Show()

		--none of these values are scaled, need to calculate
		local pixelPerSecond = parent.pixelPerSecond
		local totalLength = parent.totalLength
		local scale = parent.currentScale

		pixelPerSecond = pixelPerSecond * scale

		local headerWidth = parent.headerWidth

		--dataIndex stores which line index from the data this line will use
		--lineData store members: .text .icon .timeline
		local lineData = data.lines[self.dataIndex]

		self.spellId = lineData.spellId

		--if there's an icon, anchor the text at the right side of the icon
		--this is the title and icon of the title
		if (lineData.icon) then
			self.icon:SetTexture(lineData.icon)
			if (lineData.coords) then
				self.icon:SetTexCoord(unpack(lineData.coords))
			else
				self.icon:SetTexCoord(.1, .9, .1, .9)
			end
			self.text:SetText(lineData.text or "")
			self.text:SetPoint("left", self.icon.widget, "right", 2, 0)
		else
			self.icon:SetTexture(nil)
			self.text:SetText(lineData.text or "")
			self.text:SetPoint("left", self, "left", 2, 0)
		end

		if (self.dataIndex % 2 == 1) then
			self:SetBackdropColor(0, 0, 0, 0)
		else
			local r, g, b, a = unpack(self.backdrop_color)
			self:SetBackdropColor(r, g, b, a)
		end

		self:SetWidth(5000)

		local timelineData = lineData.timeline
		local spellId = lineData.spellId
		local useIconOnBlock = data.useIconOnBlocks

		local baseFrameLevel = parent:GetFrameLevel() + 10

		for i = 1, #timelineData do
			local blockInfo = timelineData[i]

			local timeInSeconds = blockInfo[1]
			local length = blockInfo[2]
			local isAura = blockInfo[3]
			local auraDuration = blockInfo[4]
			local blockSpellId = blockInfo[5]

			local payload = blockInfo.payload

			local xOffset = pixelPerSecond * timeInSeconds
			local width = pixelPerSecond * length

			if (timeInSeconds < -0.2) then
				xOffset = xOffset / 2.5
			end

			local block = self:GetBlock(i)
			block:Show()
			block:SetFrameLevel(baseFrameLevel + i)

			PixelUtil.SetPoint(block, "left", self, "left", xOffset + headerWidth, 0)

			block.info.spellId = blockSpellId or spellId
			block.info.time = timeInSeconds
			block.info.duration = auraDuration
			block.info.payload = payload

			if (useIconOnBlock) then
				local iconTexture = lineData.icon
				if (blockSpellId) then
					iconTexture = GetSpellTexture(blockSpellId)
				end

				block.icon:SetTexture(iconTexture)
				block.icon:SetTexCoord(.1, .9, .1, .9)
				block.icon:SetAlpha(.834)
				block.icon:SetSize(self:GetHeight(), self:GetHeight())

				if (timeInSeconds < -0.2) then
					block.icon:SetDesaturated(true)
				else
					block.icon:SetDesaturated(false)
				end

				PixelUtil.SetSize(block, self:GetHeight(), self:GetHeight())

				if (isAura) then
					block.auraLength:Show()
					block.auraLength:SetWidth(pixelPerSecond * isAura)
					block:SetWidth(max(pixelPerSecond * isAura, 16))
				else
					block.auraLength:Hide()
				end

				block.background:SetVertexColor(0, 0, 0, 0)
			else
				block.background:SetVertexColor(0, 0, 0, 0)
				PixelUtil.SetSize(block, max(width, 16), self:GetHeight())
				block.auraLength:Hide()
			end
		end
	end,

	GetBlock = function(self, index)
		local block = self.blocks [index]
		if (not block) then
			block = CreateFrame("frame", nil, self, "BackdropTemplate")
			self.blocks [index] = block

			local background = block:CreateTexture(nil, "background")
			background:SetColorTexture(1, 1, 1, 1)
			local icon = block:CreateTexture(nil, "artwork")
			local text = block:CreateFontString(nil, "artwork")
			local auraLength = block:CreateTexture(nil, "border")

			background:SetAllPoints()
			icon:SetPoint("left")
			text:SetPoint("left", icon, "left", 2, 0)
			auraLength:SetPoint("topleft", icon, "topleft", 0, 0)
			auraLength:SetPoint("bottomleft", icon, "bottomleft", 0, 0)
			auraLength:SetColorTexture(1, 1, 1, 1)
			auraLength:SetVertexColor(1, 1, 1, 0.1)

			block.icon = icon
			block.text = text
			block.background = background
			block.auraLength = auraLength

			block:SetScript("OnEnter", self:GetParent():GetParent().options.block_on_enter)
			block:SetScript("OnLeave", self:GetParent():GetParent().options.block_on_leave)

			block:SetMouseClickEnabled(false)
			block.info = {}
		end

		return block
	end,

	Reset = function(self)
		--attention, it doesn't reset icon texture, text and background color
		for i = 1, #self.blocks do
			self.blocks [i]:Hide()
		end
		self:Hide()
	end,
}

detailsFramework.TimeLineFunctions = {
	GetLine = function(self, index)
		local line = self.lines [index]
		if (not line) then
			--create a new line
			line = CreateFrame("frame", "$parentLine" .. index, self.body, "BackdropTemplate")
			detailsFramework:Mixin(line, detailsFramework.TimeLineBlockFunctions)
			self.lines [index] = line

			local lineHeader = CreateFrame("frame", nil, line, "BackdropTemplate")
			lineHeader:SetPoint("topleft", line, "topleft", 0, 0)
			lineHeader:SetPoint("bottomleft", line, "bottomleft", 0, 0)
			lineHeader:SetScript("OnEnter", self.options.header_on_enter)
			lineHeader:SetScript("OnLeave", self.options.header_on_leave)

			line.lineHeader = lineHeader

			--store the individual textures that shows the timeline information
			line.blocks = {}
			line.SetBlock = detailsFramework.TimeLineBlockFunctions.SetBlock
			line.GetBlock = detailsFramework.TimeLineBlockFunctions.GetBlock

			--set its parameters

			if (self.options.show_elapsed_timeline) then
				line:SetPoint("topleft", self.body, "topleft", 1, -((index-1) * (self.options.line_height + 1)) - 2 - self.options.elapsed_timeline_height)
			else
				line:SetPoint("topleft", self.body, "topleft", 1, -((index-1) * (self.options.line_height + 1)) - 1)
			end
			line:SetSize(1, self.options.line_height) --width is set when updating the frame

			line:SetScript("OnEnter", self.options.on_enter)
			line:SetScript("OnLeave", self.options.on_leave)
			line:SetMouseClickEnabled(false)

			line:SetBackdrop(self.options.backdrop)
			line:SetBackdropColor(unpack(self.options.backdrop_color))
			line:SetBackdropBorderColor(unpack(self.options.backdrop_border_color))

			local icon = detailsFramework:CreateImage(line, "", self.options.line_height, self.options.line_height)
			icon:SetPoint("left", line, "left", 2, 0)
			line.icon = icon

			local text = detailsFramework:CreateLabel(line, "", detailsFramework:GetTemplate("font", self.options.title_template))
			text:SetPoint("left", icon.widget, "right", 2, 0)
			line.text = text

			line.backdrop_color = self.options.backdrop_color or {.1, .1, .1, .3}
			line.backdrop_color_highlight = self.options.backdrop_color_highlight or {.3, .3, .3, .5}
		end

		return line
	end,

	ResetAllLines = function(self)
		for i = 1, #self.lines do
			self.lines[i]:Reset()
		end
	end,

	AdjustScale = function(self, index)

	end,

	--todo
	--make the on enter and leave tooltips
	--set icons and texts
	--skin the sliders

	RefreshTimeLine = function(self)
		--debug
		--self.currentScale = 1

		--calculate the total width
		local pixelPerSecond = self.options.pixels_per_second
		local totalLength = self.data.length or 1
		local currentScale = self.currentScale

		self.scaleSlider:Enable()

		--how many pixels represent 1 second
		local bodyWidth = totalLength * pixelPerSecond * currentScale
		self.body:SetWidth(bodyWidth + self.options.header_width)
		self.body.effectiveWidth = bodyWidth

		--reduce the default canvas size from the body with and don't allow the max value be negative
		local newMaxValue = max(bodyWidth - (self:GetWidth() - self.options.header_width), 0)

		--adjust the scale slider range
		local oldMin, oldMax = self.horizontalSlider:GetMinMaxValues()
		self.horizontalSlider:SetMinMaxValues(0, newMaxValue)
		self.horizontalSlider:SetValue(detailsFramework:MapRangeClamped(oldMin, oldMax, 0, newMaxValue, self.horizontalSlider:GetValue()))

		local defaultColor = self.data.defaultColor or {1, 1, 1, 1}

		--cache values
		self.pixelPerSecond = pixelPerSecond
		self.totalLength = totalLength
		self.defaultColor = defaultColor
		self.headerWidth = self.options.header_width

		--calculate the total height
		local lineHeight = self.options.line_height
		local linePadding = self.options.line_padding

		local bodyHeight = (lineHeight + linePadding) * #self.data.lines
		self.body:SetHeight(bodyHeight)
		self.verticalSlider:SetMinMaxValues(0, max(bodyHeight - self:GetHeight(), 0))
		self.verticalSlider:SetValue(0)

		--refresh lines
		self:ResetAllLines()
		for i = 1, #self.data.lines do
			local line = self:GetLine(i)
			line.dataIndex = i --this index is used inside the line update function to know which data to get
			line.lineHeader:SetWidth(self.options.header_width)
			line:SetBlocksFromData() --the function to update runs within the line object
		end

		--refresh elapsed time frame
		--the elapsed frame must have a width before the refresh function is called
		self.elapsedTimeFrame:ClearAllPoints()
		self.elapsedTimeFrame:SetPoint("topleft", self.body, "topleft", self.options.header_width, 0)
		self.elapsedTimeFrame:SetPoint("topright", self.body, "topright", 0, 0)
		self.elapsedTimeFrame:Reset()

		self.elapsedTimeFrame:Refresh(self.data.length, self.currentScale)
	end,

	SetData = function(self, data)
		self.data = data
		self:RefreshTimeLine()
	end,
}

--creates a regular scroll in horizontal position
function detailsFramework:CreateTimeLineFrame(parent, name, options, timelineOptions)
	local width = options and options.width or timeline_options.width
	local height = options and options.height or timeline_options.height
	local scrollWidth = 800 --placeholder until the timeline receives data
	local scrollHeight = 800 --placeholder until the timeline receives data

	local frameCanvas = CreateFrame("scrollframe", name, parent, "BackdropTemplate")

	detailsFramework:Mixin(frameCanvas, detailsFramework.TimeLineFunctions)
	detailsFramework:Mixin(frameCanvas, detailsFramework.OptionsFunctions)
	detailsFramework:Mixin(frameCanvas, detailsFramework.LayoutFrame)

	frameCanvas.data = {}
	frameCanvas.lines = {}
	frameCanvas.currentScale = 0.5
	frameCanvas:SetSize(width, height)

	detailsFramework:ApplyStandardBackdrop(frameCanvas)

	local frameBody = CreateFrame("frame", nil, frameCanvas, "BackdropTemplate")
	frameBody:SetSize(scrollWidth, scrollHeight)

	frameCanvas:SetScrollChild(frameBody)
	frameCanvas.body = frameBody

	frameCanvas:BuildOptionsTable(timeline_options, options)

	--create elapsed time frame
	frameCanvas.elapsedTimeFrame = detailsFramework:CreateElapsedTimeFrame(frameBody, frameCanvas:GetName() and frameCanvas:GetName() .. "ElapsedTimeFrame", timelineOptions)

	--create horizontal slider
		local horizontalSlider = CreateFrame("slider", frameCanvas:GetName() .. "HorizontalSlider", parent, "BackdropTemplate")
		horizontalSlider.bg = horizontalSlider:CreateTexture(nil, "background")
		horizontalSlider.bg:SetAllPoints(true)
		horizontalSlider.bg:SetTexture(0, 0, 0, 0.5)
		frameCanvas.horizontalSlider = horizontalSlider

		horizontalSlider:SetBackdrop(frameCanvas.options.slider_backdrop)
		horizontalSlider:SetBackdropColor(unpack(frameCanvas.options.slider_backdrop_color))
		horizontalSlider:SetBackdropBorderColor(unpack(frameCanvas.options.slider_backdrop_border_color))

		horizontalSlider.thumb = horizontalSlider:CreateTexture(nil, "OVERLAY")
		horizontalSlider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		horizontalSlider.thumb:SetSize(24, 24)
		horizontalSlider.thumb:SetVertexColor(0.6, 0.6, 0.6, 0.95)
		horizontalSlider:SetThumbTexture(horizontalSlider.thumb)

		horizontalSlider:SetOrientation("horizontal")
		horizontalSlider:SetSize(width + 20, 20)
		horizontalSlider:SetPoint("topleft", frameCanvas, "bottomleft")
		horizontalSlider:SetMinMaxValues(0, scrollWidth)
		horizontalSlider:SetValue(0)
		horizontalSlider:SetScript("OnValueChanged", function(self)
			local _, maxValue = horizontalSlider:GetMinMaxValues()
			local stepValue = ceil(ceil(self:GetValue() * maxValue) / max(maxValue, SMALL_FLOAT))
			if (stepValue ~= horizontalSlider.currentValue) then
				horizontalSlider.currentValue = stepValue
				frameCanvas:SetHorizontalScroll(stepValue)
			end
		end)

	--create scale slider
		local scaleSlider = CreateFrame("slider", frameCanvas:GetName() .. "ScaleSlider", parent, "BackdropTemplate")
		scaleSlider.bg = scaleSlider:CreateTexture(nil, "background")
		scaleSlider.bg:SetAllPoints(true)
		scaleSlider.bg:SetTexture(0, 0, 0, 0.5)
		scaleSlider:Disable()
		frameCanvas.scaleSlider = scaleSlider

		scaleSlider:SetBackdrop(frameCanvas.options.slider_backdrop)
		scaleSlider:SetBackdropColor(unpack(frameCanvas.options.slider_backdrop_color))
		scaleSlider:SetBackdropBorderColor(unpack(frameCanvas.options.slider_backdrop_border_color))

		scaleSlider.thumb = scaleSlider:CreateTexture(nil, "OVERLAY")
		scaleSlider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		scaleSlider.thumb:SetSize(24, 24)
		scaleSlider.thumb:SetVertexColor(0.6, 0.6, 0.6, 0.95)
		scaleSlider:SetThumbTexture(scaleSlider.thumb)

		scaleSlider:SetOrientation("horizontal")
		scaleSlider:SetSize(width + 20, 20)
		scaleSlider:SetPoint("topleft", horizontalSlider, "bottomleft", 0, -2)
		scaleSlider:SetMinMaxValues(frameCanvas.options.scale_min, frameCanvas.options.scale_max)
		scaleSlider:SetValue(detailsFramework:GetRangeValue(frameCanvas.options.scale_min, frameCanvas.options.scale_max, 0.5))

		scaleSlider:SetScript("OnValueChanged", function(self)
			local stepValue = ceil(self:GetValue() * 100) / 100
			if (stepValue ~= frameCanvas.currentScale) then
				local current = stepValue
				frameCanvas.currentScale = stepValue
				frameCanvas:RefreshTimeLine()
			end
		end)

	--create vertical slider
		local verticalSlider = CreateFrame("slider", frameCanvas:GetName() .. "VerticalSlider", parent, "BackdropTemplate")
		verticalSlider.bg = verticalSlider:CreateTexture(nil, "background")
		verticalSlider.bg:SetAllPoints(true)
		verticalSlider.bg:SetTexture(0, 0, 0, 0.5)
		frameCanvas.verticalSlider = verticalSlider

		verticalSlider:SetBackdrop(frameCanvas.options.slider_backdrop)
		verticalSlider:SetBackdropColor(unpack(frameCanvas.options.slider_backdrop_color))
		verticalSlider:SetBackdropBorderColor(unpack(frameCanvas.options.slider_backdrop_border_color))

		verticalSlider.thumb = verticalSlider:CreateTexture(nil, "OVERLAY")
		verticalSlider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		verticalSlider.thumb:SetSize(24, 24)
		verticalSlider.thumb:SetVertexColor(0.6, 0.6, 0.6, 0.95)
		verticalSlider:SetThumbTexture(verticalSlider.thumb)

		verticalSlider:SetOrientation("vertical")
		verticalSlider:SetSize(20, height - 2)
		verticalSlider:SetPoint("topleft", frameCanvas, "topright", 0, 0)
		verticalSlider:SetMinMaxValues(0, scrollHeight)
		verticalSlider:SetValue(0)
		verticalSlider:SetScript("OnValueChanged", function(self)
		    frameCanvas:SetVerticalScroll(self:GetValue())
		end)

	--mouse scroll
		frameCanvas:EnableMouseWheel(true)
		frameCanvas:SetScript("OnMouseWheel", function(self, delta)
			local minValue, maxValue = horizontalSlider:GetMinMaxValues()
			local currentHorizontal = horizontalSlider:GetValue()

			if (IsShiftKeyDown() and delta < 0) then
				local amountToScroll = frameBody:GetHeight() / 20
				verticalSlider:SetValue(verticalSlider:GetValue() + amountToScroll)

			elseif (IsShiftKeyDown() and delta > 0) then
				local amountToScroll = frameBody:GetHeight() / 20
				verticalSlider:SetValue(verticalSlider:GetValue() - amountToScroll)

			elseif (IsControlKeyDown() and delta > 0) then
				scaleSlider:SetValue(min(scaleSlider:GetValue() + 0.1, 1))

			elseif (IsControlKeyDown() and delta < 0) then
				scaleSlider:SetValue(max(scaleSlider:GetValue() - 0.1, 0.15))

			elseif (delta < 0 and currentHorizontal < maxValue) then
				local amountToScroll = frameBody:GetWidth() / 20
				horizontalSlider:SetValue(currentHorizontal + amountToScroll)

			elseif (delta > 0 and maxValue > 1) then
				local amountToScroll = frameBody:GetWidth() / 20
				horizontalSlider:SetValue(currentHorizontal - amountToScroll)

			end
		end)

	--mouse drag
	frameBody:SetScript("OnMouseDown", function(self, button)
		local x = GetCursorPosition()
		self.MouseX = x

		frameBody:SetScript("OnUpdate", function(self, deltaTime)
			local x = GetCursorPosition()
			local deltaX = self.MouseX - x
			local current = horizontalSlider:GetValue()
			horizontalSlider:SetValue(current +(deltaX * 1.2) *((IsShiftKeyDown() and 2) or(IsAltKeyDown() and 0.5) or 1))
			self.MouseX = x
		end)
	end)

	frameBody:SetScript("OnMouseUp", function(self, button)
		frameBody:SetScript("OnUpdate", nil)
	end)

	return frameCanvas
end


--[=[
local f = CreateFrame("frame", "TestFrame", UIParent)
f:SetPoint("center")
f:SetSize(900, 420)
f:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,	insets = {left = 1, right = 1, top = 0, bottom = 1}})

local scroll = DF:CreateTimeLineFrame (f, "$parentTimeLine", {width = 880, height = 400})
scroll:SetPoint("topleft", f, "topleft", 0, 0)

--need fake data to test fills
scroll:SetData ({
	length = 360,
	defaultColor = {1, 1, 1, 1},
	lines = {
			{text = "player 1", icon = "", timeline = {
				--each table here is a block shown in the line
				--is an indexed table with: [1] time [2] length [3] color (if false, use the default) [4] text [5] icon [6] tooltip: if number = spellID tooltip, if table is text lines
				{1, 10}, {13, 11}, {25, 7}, {36, 5}, {55, 18}, {76, 30}, {105, 20}, {130, 11}, {155, 11}, {169, 7}, {199, 16}, {220, 18}, {260, 10}, {290, 23}, {310, 30}, {350, 10}
			}
		}, --end of line 1
	},
})


f:Hide()

--scroll.body:SetScale(0.5)

--]=]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--error message box

function detailsFramework:ShowErrorMessage (errorMessage, titleText)

	if (not detailsFramework.ErrorMessagePanel) then
		local f = CreateFrame("frame", "DetailsFrameworkErrorMessagePanel", UIParent, "BackdropTemplate")
		f:SetSize(400, 120)
		f:SetFrameStrata("FULLSCREEN")
		f:SetPoint("center", UIParent, "center", 0, 100)
		f:EnableMouse(true)
		f:SetMovable(true)
		f:RegisterForDrag ("LeftButton")
		f:SetScript("OnDragStart", function() f:StartMoving() end)
		f:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
		f:SetScript("OnMouseDown", function(self, button) if (button == "RightButton") then f:Hide() end end)
		tinsert(UISpecialFrames, "DetailsFrameworkErrorMessagePanel")
		detailsFramework.ErrorMessagePanel = f

		detailsFramework:CreateTitleBar (f, "Details! Framework Error!")
		detailsFramework:ApplyStandardBackdrop(f)

		local errorLabel = f:CreateFontString(nil, "overlay", "GameFontNormal")
		errorLabel:SetPoint("top", f, "top", 0, -25)
		errorLabel:SetJustifyH("center")
		errorLabel:SetSize(360, 66)
		f.errorLabel = errorLabel

		local button_text_template = detailsFramework:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
		local options_dropdown_template = detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")

		local closeButton = detailsFramework:CreateButton(f, nil, 60, 20, "close", nil, nil, nil, nil, nil, nil, options_dropdown_template)
		closeButton:SetPoint("bottom", f, "bottom", 0, 5)
		f.closeButton = closeButton

		closeButton:SetClickFunction(function()
			f:Hide()
		end)

		f.ShowAnimation = detailsFramework:CreateAnimationHub (f, function()
			f:SetBackdropBorderColor(0, 0, 0, 0)
			f.TitleBar:SetBackdropBorderColor(0, 0, 0, 0)
		end, function()
			f:SetBackdropBorderColor(0, 0, 0, 1)
			f.TitleBar:SetBackdropBorderColor(0, 0, 0, 1)
		end)
		detailsFramework:CreateAnimation(f.ShowAnimation, "scale", 1, .075, .2, .2, 1.1, 1.1, "center", 0, 0)
		detailsFramework:CreateAnimation(f.ShowAnimation, "scale", 2, .075, 1, 1, .90, .90, "center", 0, 0)

		f.FlashTexture = f:CreateTexture(nil, "overlay")
		f.FlashTexture:SetColorTexture(1, 1, 1, 1)
		f.FlashTexture:SetAllPoints()

		f.FlashAnimation = detailsFramework:CreateAnimationHub (f.FlashTexture, function() f.FlashTexture:Show() end, function() f.FlashTexture:Hide() end)
		detailsFramework:CreateAnimation(f.FlashAnimation, "alpha", 1, .075, 0, .05)
		detailsFramework:CreateAnimation(f.FlashAnimation, "alpha", 2, .075, .1, 0)

		f:Hide()
	end

	detailsFramework.ErrorMessagePanel:Show()
	detailsFramework.ErrorMessagePanel.errorLabel:SetText(errorMessage)
	detailsFramework.ErrorMessagePanel.TitleLabel:SetText(titleText)
	detailsFramework.ErrorMessagePanel.ShowAnimation:Play()
	detailsFramework.ErrorMessagePanel.FlashAnimation:Play()
end

--[[
	DF:SetPointOffsets(frame, xOffset, yOffset)

	Set an offset into the already existing offset of the frame
	If passed xOffset:1 and yOffset:1 and the frame has 1 -1,  the new offset will be 2 -2
	This function is great to create a 1 knob for distance

	@frame: a frame to have the offsets changed
	@xOffset: the amount to apply into the x offset
	@yOffset: the amount to apply into the y offset
--]]
function detailsFramework:SetPointOffsets(frame, xOffset, yOffset)
	for i = 1, frame:GetNumPoints() do
		local anchor1, anchorTo, anchor2, x, y = frame:GetPoint(i)
		x = x or 0
		y = y or 0

		if (x >= 0) then
			xOffset = x + xOffset

		elseif (x < 0) then
			xOffset = x - xOffset
		end

		if (y >= 0) then
			yOffset = y + yOffset

		elseif (y < 0) then
			yOffset = y - yOffset
		end

		frame:SetPoint(anchor1, anchorTo, anchor2, xOffset, yOffset)
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--list box

detailsFramework.ListboxFunctions = {
	scrollRefresh = function(self, data, offset, totalLines)
		for i = 1, totalLines do
			local index = i + offset
			local lineData = data[index] --what is shown in the textentries, array

			if (lineData) then
				local line = self:GetLine(i)
				line.dataIndex = index
				line.deleteButton:SetClickFunction(detailsFramework.ListboxFunctions.deleteEntry, data, index)
				line.indexText:SetText(index)

				local amountEntries = #lineData
				for o = 1, amountEntries do
					--data
					local textEntry = line.widgets[o]
					textEntry.dataTable = lineData
					textEntry.dataTableIndex = o
					local text = lineData[o]
					textEntry:SetText(text)
				end
			end
		end
	end,

	addEntry = function(self)
		local frameCanvas = self:GetParent()
		local data = frameCanvas.data
		local newEntry = {}
		for i = 1, frameCanvas.headerLength do
			tinsert(newEntry, "")
		end
		tinsert(data, newEntry)
		frameCanvas.scrollBox:Refresh()
	end,

	deleteEntry = function(self, button, data, index)
		tremove(data, index)
		--get the line, get the scrollframe
		self:GetParent():GetParent():Refresh()
	end,

	createScrollLine = function(self, index)
		local listBox = self:GetParent()
		local line = CreateFrame("frame", self:GetName().. "line_" .. index, self, "BackdropTemplate")

		line:SetPoint("topleft", self, "topleft", 1, -((index-1)*(self.lineHeight+1)) - 1)
		line:SetSize(self:GetWidth() - 28, self.lineHeight) -- -28 space for the scrollbar

		local options = listBox.options
		line:SetBackdrop(options.line_backdrop)
		line:SetBackdropColor(unpack(options.line_backdrop_color))
		line:SetBackdropBorderColor(unpack(options.line_backdrop_border_color))

		detailsFramework:Mixin(line, detailsFramework.HeaderFunctions)

		line.widgets = {}

		for i = 1, (listBox.headerLength+2) do --+2 to add the delete button and index
			local headerColumn = listBox.headerTable[i]

			if (headerColumn.isDelete) then
				local deleteButton = detailsFramework:CreateButton(line, detailsFramework.ListboxFunctions.deleteEntry, 20, self.lineHeight, "X", listBox.data, index, nil, nil, nil, nil, detailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"), detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
				line.deleteButton = deleteButton
				line:AddFrameToHeaderAlignment(deleteButton)

			elseif (headerColumn.isIndex) then
				local indexText = detailsFramework:CreateLabel(line)
				line.indexText = indexText
				line:AddFrameToHeaderAlignment(indexText)

			elseif (headerColumn.text) then
				local template = detailsFramework.table.copy({}, detailsFramework:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
				template.backdropcolor = {.1, .1, .1, .7}
				template.backdropbordercolor = {.2, .2, .2, .6}

				local textEntry = detailsFramework:CreateTextEntry(line, function()end, headerColumn.width, self.lineHeight, nil, nil, nil, template)
				textEntry:SetHook("OnEditFocusGained", function() textEntry:HighlightText(0) end)
				textEntry:SetHook("OnEditFocusLost", function()
					textEntry:HighlightText(0, 0)
					local text = textEntry.text
					local dataTable = textEntry.dataTable
					dataTable[textEntry.dataTableIndex] = text
				end)
				tinsert(line.widgets, textEntry)
				line:AddFrameToHeaderAlignment(textEntry)
			end
		end

		line:AlignWithHeader(listBox.header, "left")
		return line
	end,

	SetData = function(frameCanvas, newData)
		if (type(newData) ~= "table") then
			error("ListBox:SetData received an invalid newData on parameter 2.")
			return
		end

		frameCanvas.data = newData
		frameCanvas.scrollBox:SetData(newData)
		frameCanvas.scrollBox:Refresh()
	end,
}

local listbox_options = {
	width = 800,
	height = 600,
	auto_width = true,
	line_height = 16,
	line_backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	line_backdrop_color = {.1, .1, .1, .6},
	line_backdrop_border_color = {0, 0, 0, .5},
}

--@parent: parent frame
--@name: name of the frame to be created
--@data: table with current data to fill the column, this table are also used for values changed or added
--@options: table with options to overwrite the default setting from 'listbox_options'
--@header: a table to create a header widget
--@header_options: a table with options to overwrite the default header options
function detailsFramework:CreateListBox(parent, name, data, options, headerTable, headerOptions)

	options = options or {}
	name = name or "ListboxUnamed_" .. (math.random(100000, 1000000))

	--canvas
	local frameCanvas = CreateFrame("scrollframe", name, parent, "BackdropTemplate")
	detailsFramework:Mixin(frameCanvas, detailsFramework.ListboxFunctions)
	detailsFramework:Mixin(frameCanvas, detailsFramework.OptionsFunctions)
	detailsFramework:Mixin(frameCanvas, detailsFramework.LayoutFrame)
	frameCanvas.headerTable = headerTable

	if (not data or type(data) ~= "table") then
		error("CreateListBox() parameter 3 'data' must be a table.")
	end

	frameCanvas.data = data
	frameCanvas.lines = {}
	detailsFramework:ApplyStandardBackdrop(frameCanvas)
	frameCanvas:BuildOptionsTable(listbox_options, options)

	--header
		--check for default values in the header
		headerTable = headerTable or {
			{text = "Spell Id", width = 70},
			{text = "Spell Name", width = 70},
		}
		headerOptions = headerOptions or {
			padding = 2,
		}

		--each header is an entry in the data, if the header has 4 indexes the data has sub tables with 4 indexes as well
		frameCanvas.headerLength = #headerTable

		--add the detele line column into the header frame
		tinsert(headerTable, 1, {text = "#", width = 20, isIndex = true}) --isDelete signals the createScrollLine() to make the delete button for the line
		tinsert(headerTable, {text = "Delete", width = 50, isDelete = true}) --isDelete signals the createScrollLine() to make the delete button for the line

		local header = detailsFramework:CreateHeader(frameCanvas, headerTable, headerOptions)
		--set the header point
		header:SetPoint("topleft", frameCanvas, "topleft", 5, -5)
		frameCanvas.header = header

	--auto size
		if (frameCanvas.options.auto_width) then
			local width = 10 --padding 5 on each side
			width = width + 20 --scrollbar reserved space
			local headerPadding = headerOptions.padding or 0

			for _, header in pairs(headerTable) do
				if (header.width) then
					width = width + header.width + headerPadding
				end
			end

			frameCanvas.options.width = width
			frameCanvas:SetWidth(width)
		end

		local width = frameCanvas.options.width
		local height = frameCanvas.options.height

		frameCanvas:SetSize(frameCanvas.options.width, height)

	--scroll frame
		local lineHeight = frameCanvas.options.line_height
		--calc the size of the space occupied by the add button, header etc
		local lineAmount = floor((height - 60) / lineHeight)

		-- -12 is padding: 5 on top, 7 bottom, 2 header scrollbar blank space | -24 to leave space to the add button
		local scrollBox = detailsFramework:CreateScrollBox(frameCanvas, "$parentScrollbox", frameCanvas.scrollRefresh, data, width-4, height - header:GetHeight() - 12 - 24, lineAmount, lineHeight)
		scrollBox:SetPoint("topleft", header, "bottomleft", 0, -2)
		scrollBox:SetPoint("topright", header, "bottomright", 0, -2) -- -20 for the scrollbar
		detailsFramework:ReskinSlider(scrollBox)
		scrollBox.lineHeight = lineHeight
		scrollBox.lineAmount = lineAmount
		frameCanvas.scrollBox = scrollBox

		for i = 1, lineAmount do
			scrollBox:CreateLine(frameCanvas.createScrollLine)
		end

		scrollBox:Refresh()

	--add line button
		local addLineButton = detailsFramework:CreateButton(frameCanvas, detailsFramework.ListboxFunctions.addEntry, 80, 20, "Add", nil, nil, nil, nil, nil, nil, detailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"), detailsFramework:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
		addLineButton:SetPoint("topleft", scrollBox, "bottomleft", 0, -4)

	return frameCanvas
end

--[=[ -- test case

    local pframe = ListBoxTest or CreateFrame("frame", "ListBoxTest", UIParent)
    pframe:SetSize(900, 700)
    pframe:SetPoint("left")

    local data = {{254154, "spell name 1", 45}, {299154, "spell name 2", 05}, {354154, "spell name 3", 99}}
    local headerTable = {
        {text = "spell id", width = 120},
        {text = "spell name", width = 180},
        {text = "number", width = 90},
    }

    local listbox = DetailsFramework:CreateListBox(pframe, "$parentlistbox", data, nil, headerTable, nil)
    listbox:SetPoint("topleft", pframe, "topleft", 10, -10)

--]=]

