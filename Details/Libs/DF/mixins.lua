
local detailsFramework = _G["DetailsFramework"]
if (not detailsFramework or not DetailsFrameworkCanLoad) then
	return
end

local _

local getFrame = function(frame)
	return rawget(frame, "widget") or frame
end

detailsFramework.WidgetFunctions = {
	GetCapsule = function(self)
		return self.MyObject
	end,

	GetObject = function(self)
		return self.MyObject
	end,
}

detailsFramework.DefaultMetaFunctionsGet = {
	parent = function(object)
		return object:GetParent()
	end,

	shown = function(object)
		return object:IsShown()
	end,
}

detailsFramework.TooltipHandlerMixin = {
	SetTooltip = function(self, tooltip)
		if (tooltip) then
			if (detailsFramework.Language.IsLocTable(tooltip)) then
				--register the locTable as a tableKey
				local locTable = tooltip
				detailsFramework.Language.RegisterTableKeyWithLocTable(self, "have_tooltip", locTable)
			else
				self.have_tooltip = tooltip
			end
		else
			self.have_tooltip = nil
		end
	end,

	GetTooltip = function(self)
		return self.have_tooltip
	end,

	ShowTooltip = function(self)
		local tooltipText = self:GetTooltip()

		if (type(tooltipText) == "function") then
			local tooltipFunction = tooltipText
			local gotTooltip, tooltipString = xpcall(tooltipFunction, geterrorhandler())
			if (gotTooltip) then
				tooltipText = tooltipString
			end
		end

		if (tooltipText) then
			GameCooltip:Preset(2)
			GameCooltip:AddLine(tooltipText)
			GameCooltip:ShowCooltip(getFrame(self), "tooltip")
		end
	end,

	HideTooltip = function(self)
		local tooltipText = self:GetTooltip()
		if (tooltipText) then
			if (GameCooltip:IsOwner(getFrame(self))) then
				GameCooltip:Hide()
			end
		end
	end,
}

detailsFramework.DefaultMetaFunctionsSet = {
	parent = function(object, value)
		return object:SetParent(value)
	end,

	show = function(object, value)
		if (value) then
			return object:Show()
		else
			return object:Hide()
		end
	end,

	hide = function(object, value)
		if (value) then
			return object:Hide()
		else
			return object:Show()
		end
	end,
}

detailsFramework.DefaultMetaFunctionsSet.shown = detailsFramework.DefaultMetaFunctionsSet.show

detailsFramework.LayeredRegionMetaFunctionsSet = {
	drawlayer = function(object, value)
		object.image:SetDrawLayer(value)
	end,

	sublevel = function(object, value)
		local drawLayer = object:GetDrawLayer()
		object:SetDrawLayer(drawLayer, value)
	end,
}

detailsFramework.LayeredRegionMetaFunctionsGet = {
	drawlayer = function(object)
		return object.image:GetDrawLayer()
	end,

	sublevel = function(object)
		local _, subLevel = object.image:GetDrawLayer()
		return subLevel
	end,
}

detailsFramework.FrameMixin = {
	SetFrameStrata = function(self, strata)
		self = getFrame(self)
		if (type(strata) == "table" and strata.GetObjectType) then
			local UIObject = strata
			self:SetFrameStrata(UIObject:GetFrameStrata())
		else
			self:SetFrameStrata(strata)
		end
	end,

	SetFrameLevel = function(self, level, UIObject)
		self = getFrame(self)
		if (not UIObject) then
			self:SetFrameLevel(level)
		else
			local framelevel = UIObject:GetFrameLevel(UIObject) + level
			self:SetFrameLevel(framelevel)
		end
	end,

	SetSize = function(self, width, height)
		self = getFrame(self)
		if (width) then
			self:SetWidth(width)
		end
		if (height) then
			self:SetHeight(height)
		end
	end,

	SetBackdrop = function(self, ...)
		self = getFrame(self)
		self:SetBackdrop(...)
	end,

	SetBackdropColor = function(self, ...)
		self = getFrame(self)
		self:SetBackdropColor(...)
	end,

	SetBackdropBorderColor = function(self, ...)
		self = getFrame(self)
		getFrame(self):SetBackdropBorderColor(...)
	end,
}

local doublePoint = {
	["lefts"] = true,
	["rights"] = true,
	["tops"] = true,
	["bottoms"] = true,

	["left-left"] = true,
	["right-right"] = true,
	["top-top"] = true,
	["bottom-bottom"] = true,

	["bottom-top"] = true,
	["top-bottom"] = true,
	["right-left"] = true,
	["left-right"] = true,
}

detailsFramework.SetPointMixin = {
	SetPoint = function(object, anchorName1, anchorObject, anchorName2, xOffset, yOffset)
		if (doublePoint[anchorName1]) then
			object:ClearAllPoints()
			local anchorTo
			if (anchorObject and type(anchorObject) == "table") then
				xOffset, yOffset = anchorName2 or 0, xOffset or 0
				anchorTo = getFrame(anchorObject)
			else
				xOffset, yOffset = anchorObject or 0, anchorName2 or 0
				anchorTo = object:GetParent()
			end

			--offset always inset to inner
			if (anchorName1 == "lefts") then
				object:SetPoint("topleft", anchorTo, "topleft", xOffset, -yOffset)
				object:SetPoint("bottomleft", anchorTo, "bottomleft", xOffset, yOffset)

			elseif (anchorName1 == "rights") then
				object:SetPoint("topright", anchorTo, "topright", xOffset, -yOffset)
				object:SetPoint("bottomright", anchorTo, "bottomright", xOffset, yOffset)

			elseif (anchorName1 == "tops") then
				object:SetPoint("topleft", anchorTo, "topleft", xOffset, -yOffset)
				object:SetPoint("topright", anchorTo, "topright", -xOffset, -yOffset)

			elseif (anchorName1 == "bottoms") then
				object:SetPoint("bottomleft", anchorTo, "bottomleft", xOffset, yOffset)
				object:SetPoint("bottomright", anchorTo, "bottomright", -xOffset, yOffset)

			elseif (anchorName1 == "left-left") then
				object:SetPoint("left", anchorTo, "left", xOffset, yOffset)

			elseif (anchorName1 == "right-right") then
				object:SetPoint("right", anchorTo, "right", xOffset, yOffset)

			elseif (anchorName1 == "top-top") then
				object:SetPoint("top", anchorTo, "top", xOffset, yOffset)

			elseif (anchorName1 == "bottom-bottom") then
				object:SetPoint("bottom", anchorTo, "bottom", xOffset, yOffset)

			elseif (anchorName1 == "bottom-top") then
				object:SetPoint("bottomleft", anchorTo, "topleft", xOffset, yOffset)
				object:SetPoint("bottomright", anchorTo, "topright", -xOffset, yOffset)

			elseif (anchorName1 == "top-bottom") then
				object:SetPoint("topleft", anchorTo, "bottomleft", xOffset, -yOffset)
				object:SetPoint("topright", anchorTo, "bottomright", -xOffset, -yOffset)

			elseif (anchorName1 == "right-left") then
				object:SetPoint("topright", anchorTo, "topleft", xOffset, -yOffset)
				object:SetPoint("bottomright", anchorTo, "bottomleft", xOffset, yOffset)

			elseif (anchorName1 == "left-right") then
				object:SetPoint("topleft", anchorTo, "topright", xOffset, -yOffset)
				object:SetPoint("bottomleft", anchorTo, "bottomright", xOffset, yOffset)
			end

			return
		end

		xOffset = xOffset or 0
		yOffset = yOffset or 0

		anchorName1, anchorObject, anchorName2, xOffset, yOffset = detailsFramework:CheckPoints(anchorName1, anchorObject, anchorName2, xOffset, yOffset, object)
		if (not anchorName1) then
			error("SetPoint: Invalid parameter.")
			return
		end

		if (not object.widget) then
			local SetPoint = getmetatable(object).__index.SetPoint
			return SetPoint(object, anchorName1, anchorObject, anchorName2, xOffset, yOffset)
		else
			return object.widget:SetPoint(anchorName1, anchorObject, anchorName2, xOffset, yOffset)
		end
	end,
}

--mixin for options functions
detailsFramework.OptionsFunctions = {
	SetOption = function(self, optionName, optionValue)
		if (self.options) then
			self.options [optionName] = optionValue
		else
			self.options = {}
			self.options [optionName] = optionValue
		end

		if (self.OnOptionChanged) then
			detailsFramework:Dispatch (self.OnOptionChanged, self, optionName, optionValue)
		end
	end,

	GetOption = function(self, optionName)
		return self.options and self.options [optionName]
	end,

	GetAllOptions = function(self)
		if (self.options) then
			local optionsTable = {}
			for key, _ in pairs(self.options) do
				optionsTable [#optionsTable + 1] = key
			end
			return optionsTable
		else
			return {}
		end
	end,

	BuildOptionsTable = function(self, defaultOptions, userOptions)
		self.options = self.options or {}
		detailsFramework.table.deploy(self.options, userOptions or {})
		detailsFramework.table.deploy(self.options, defaultOptions or {})
	end
}

--payload mixin
detailsFramework.PayloadMixin = {
	ClearPayload = function(self)
		self.payload = {}
	end,

	SetPayload = function(self, ...)
		self.payload = {...}
		return self.payload
	end,

	AddPayload = function(self, ...)
		local currentPayload = self.payload or {}
		self.payload = currentPayload

		for i = 1, select("#", ...) do
			local value = select(i, ...)
			currentPayload[#currentPayload+1] = value
		end

		return self.payload
	end,

	GetPayload = function(self)
		return self.payload
	end,

	DumpPayload = function(self)
		return unpack(self.payload)
	end,

	--does not copy wow objects, just pass them to the new table, tables strings and numbers are copied entirely
	DuplicatePayload = function(self)
		local duplicatedPayload = detailsFramework.table.duplicate({}, self.payload)
		return duplicatedPayload
	end,
}

---mixin to use with DetailsFramework:Mixin(table, detailsFramework.ScriptHookMixin)
---
---@class DetailsFramework.ScriptHookMixin
detailsFramework.ScriptHookMixin = {
	RunHooksForWidget = function(self, event, ...)
		local hooks = self.HookList[event]

		if (not hooks) then
			print(self.widget:GetName(), "no hooks for", event)
			return
		end

		for i, func in ipairs(hooks) do
			local success, canInterrupt = xpcall(func, geterrorhandler(), ...)

			if (not success) then
				--error("Details! Framework: " .. event .. " hook for " .. self:GetName() .. ": " .. canInterrupt)
				return false

			elseif (canInterrupt) then
				return true
			end
		end
	end,

	SetHook = function(self, hookType, func)
		if (self.HookList[hookType]) then
			if (type(func) == "function") then
				local isRemoval = false
				for i = #self.HookList[hookType], 1, -1 do
					if (self.HookList[hookType][i] == func) then
						tremove(self.HookList[hookType], i)
						isRemoval = true
						break
					end
				end

				if (not isRemoval) then
					tinsert(self.HookList[hookType], func)
				end
			else
				if (detailsFramework.debug) then
					print(debugstack())
					error("Details! Framework: invalid function for widget " .. self.WidgetType .. ".")
				end
			end
		else
			if (detailsFramework.debug) then
				error("Details! Framework: unknown hook type for widget " .. self.WidgetType .. ": '" .. hookType .. "'.")
			end
		end
	end,

	HasHook = function(self, hookType, func)
		if (self.HookList[hookType]) then
			if (type(func) == "function") then
				for i = #self.HookList[hookType], 1, -1 do
					if (self.HookList[hookType][i] == func) then
						return true
					end
				end
			end
		end
	end,

	ClearHooks = function(self)
		for hookType, hookTable in pairs(self.HookList) do
			table.wipe(hookTable)
		end
	end,
}

---mixin to use with DetailsFramework:Mixin(table, detailsFramework.SortFunctions)
---add methods to be used on scrollframes
---@class DetailsFramework.ScrollBoxFunctions
detailsFramework.ScrollBoxFunctions = {
	---refresh the scrollbox by resetting all lines created with :CreateLine(), then calling the refresh_func which was set at :CreateScrollBox()
	---@param self table
	---@return table
	Refresh = function(self)
		--hide all frames and tag as not in use
		self._LinesInUse = 0
		for index, frame in ipairs(self.Frames) do
			frame:Hide()
			frame._InUse = nil
		end

		local offset = 0
		if (self.IsFauxScroll) then
			self:UpdateFaux(#self.data, self.LineAmount, self.LineHeight)
			offset = self:GetOffsetFaux()
		end

		--call the refresh function
		detailsFramework:CoreDispatch((self:GetName() or "ScrollBox") .. ":Refresh()", self.refresh_func, self, self.data, offset, self.LineAmount)

		--hide all frames that are not in use
		for index, frame in ipairs(self.Frames) do
			if (not frame._InUse) then
				frame:Hide()
			else
				frame:Show()
			end
		end

		self:Show()

		local frameName = self:GetName()
		if (frameName) then
			if (self.HideScrollBar) then
				local scrollBar = _G[frameName .. "ScrollBar"]
				if (scrollBar) then
					scrollBar:Hide()
				end
			else
				--[=[ --maybe in the future I visit this again
				local scrollBar = _G[frameName .. "ScrollBar"]
				local height = self:GetHeight()
				local totalLinesRequired = #self.data
				local linesShown = self._LinesInUse

				local percent = linesShown / totalLinesRequired
				local thumbHeight = height * percent
				scrollBar.ThumbTexture:SetSize(12, thumbHeight)
				print("thumbHeight:", thumbHeight)
				--]=]
			end
		end
		return self.Frames
	end,

	OnVerticalScroll = function(self, offset)
		self:OnVerticalScrollFaux(offset, self.LineHeight, self.Refresh)
		return true
	end,

	---create a line within the scrollbox
	---@param self table is the scrollbox
	---@param func function|nil function to create the line object, this function will receive the line index as argument and return a table with the line object
	---@return table line object (table)
	CreateLine = function(self, func)
		if (not func) then
			func = self.CreateLineFunc
		end

		local okay, newLine = pcall(func, self, #self.Frames+1)
		if (okay) then
			if (not newLine) then
				error("ScrollFrame:CreateLine() function did not returned a line, use: 'return line'")
			end
			tinsert(self.Frames, newLine)
			newLine.Index = #self.Frames
			return newLine
		else
			error("ScrollFrame:CreateLine() error on creating a line: " .. newLine)
		end
	end,

	CreateLines = function(self, callback, lineAmount)
		for i = 1, lineAmount do
			self:CreateLine(callback)
		end
	end,

	GetLine = function(self, lineIndex)
		local line = self.Frames[lineIndex]
		if (line) then
			line._InUse = true
		end

		self._LinesInUse = self._LinesInUse + 1
		return line
	end,

	SetData = function(self, data)
		self.data = data
	end,
	GetData = function(self)
		return self.data
	end,

	GetFrames = function(self)
		return self.Frames
	end,
	GetLines = function(self) --alias of GetFrames
		return self.Frames
	end,

	GetNumFramesCreated = function(self)
		return #self.Frames
	end,

	GetNumFramesShown = function(self)
		return self.LineAmount
	end,

	SetNumFramesShown = function(self, newAmount)
		--hide frames which won't be used
		if (newAmount < #self.Frames) then
			for i = newAmount+1, #self.Frames do
				self.Frames[i]:Hide()
			end
		end
		--set the new amount
		self.LineAmount = newAmount
	end,

	SetFramesHeight = function(self, height)
		self.LineHeight = height
		self:OnSizeChanged()
		self:Refresh()
	end,

	OnSizeChanged = function(self)
		if (self.ReajustNumFrames) then
			--how many lines the scroll can show
			local amountOfFramesToShow = floor(self:GetHeight() / self.LineHeight)

			--how many lines the scroll already have
			local totalFramesCreated = self:GetNumFramesCreated()

			--how many lines are current shown
			local totalFramesShown = self:GetNumFramesShown()

			--the amount of frames increased
			if (amountOfFramesToShow > totalFramesShown) then
				for i = totalFramesShown+1, amountOfFramesToShow do
					--check if need to create a new line
					if (i > totalFramesCreated) then
						self:CreateLine(self.CreateLineFunc)
					end
				end

			--the amount of frames decreased
			elseif (amountOfFramesToShow < totalFramesShown) then
				--hide all frames above the new amount to show
				for i = totalFramesCreated, amountOfFramesToShow, -1 do
					if (self.Frames[i]) then
						self.Frames[i]:Hide()
					end
				end
			end

			--set the new amount of frames
			self:SetNumFramesShown(amountOfFramesToShow)
			--refresh lines
			self:Refresh()
		end
	end,

	--moved functions from blizzard faux scroll that are called from insecure code environment
	--this reduces the amount of taints while using the faux scroll frame
	GetOffsetFaux = function(self)
		return self.offset or 0
	end,
	OnVerticalScrollFaux = function(self, value, itemHeight, updateFunction)
		local scrollbar = self:GetChildFramesFaux();
		scrollbar:SetValue(value);
		self.offset = math.floor((value / itemHeight) + 0.5);
		if (updateFunction) then
			updateFunction(self)
		end
	end,
	GetChildFramesFaux = function(frame)
		local frameName = frame:GetName();
		if frameName then
			return _G[ frameName.."ScrollBar" ], _G[ frameName.."ScrollChildFrame" ], _G[ frameName.."ScrollBarScrollUpButton" ], _G[ frameName.."ScrollBarScrollDownButton" ];
		else
			return frame.ScrollBar, frame.ScrollChildFrame, frame.ScrollBar.ScrollUpButton, frame.ScrollBar.ScrollDownButton;
		end
	end,
	UpdateFaux = function(frame, numItems, numToDisplay, buttonHeight, button, smallWidth, bigWidth, highlightFrame, smallHighlightWidth, bigHighlightWidth, alwaysShowScrollBar)
		local scrollBar, scrollChildFrame, scrollUpButton, scrollDownButton = frame:GetChildFramesFaux();
		-- If more than one screen full of items then show the scrollbar
		local showScrollBar;
		if ( numItems > numToDisplay or alwaysShowScrollBar ) then
			frame:Show();
			showScrollBar = 1;
		else
			scrollBar:SetValue(0);
			frame:Hide();
		end
		if ( frame:IsShown() ) then
			local scrollFrameHeight = 0;
			local scrollChildHeight = 0;

			if ( numItems > 0 ) then
				scrollFrameHeight = (numItems - numToDisplay) * buttonHeight;
				scrollChildHeight = numItems * buttonHeight;
				if ( scrollFrameHeight < 0 ) then
					scrollFrameHeight = 0;
				end
				scrollChildFrame:Show();
			else
				scrollChildFrame:Hide();
			end
			local maxRange = (numItems - numToDisplay) * buttonHeight;
			if (maxRange < 0) then
				maxRange = 0;
			end
			scrollBar:SetMinMaxValues(0, maxRange);
			scrollBar:SetValueStep(buttonHeight);
			scrollBar:SetStepsPerPage(numToDisplay-1);
			scrollChildFrame:SetHeight(scrollChildHeight);

			-- Arrow button handling
			if ( scrollBar:GetValue() == 0 ) then
				scrollUpButton:Disable();
			else
				scrollUpButton:Enable();
			end
			if ((scrollBar:GetValue() - scrollFrameHeight) == 0) then
				scrollDownButton:Disable();
			else
				scrollDownButton:Enable();
			end

			-- Shrink because scrollbar is shown
			if ( highlightFrame ) then
				highlightFrame:SetWidth(smallHighlightWidth);
			end
			if ( button ) then
				for i=1, numToDisplay do
					_G[button..i]:SetWidth(smallWidth);
				end
			end
		else
			-- Widen because scrollbar is hidden
			if ( highlightFrame ) then
				highlightFrame:SetWidth(bigHighlightWidth);
			end
			if ( button ) then
				for i=1, numToDisplay do
					_G[button..i]:SetWidth(bigWidth);
				end
			end
		end
		return showScrollBar;
	end,
}

local SortMember = ""
local SortByMember = function(t1, t2)
	return t1[SortMember] > t2[SortMember]
end
local SortByMemberReverse = function(t1, t2)
	return t1[SortMember] < t2[SortMember]
end

---mixin to use with DetailsFramework:Mixin(table, detailsFramework.SortFunctions)
---adds the method Sort() to a table, this method can be used to sort another table by a member, can't sort itself
---@class DetailsFramework.SortFunctions
detailsFramework.SortFunctions = {
	---sort a table by a member
	---@param self table
	---@param tThisTable table
	---@param sMemberName string
	---@param bIsReverse boolean
	Sort = function(self, tThisTable, sMemberName, bIsReverse)
		SortMember = sMemberName
		if (not bIsReverse) then
			table.sort(tThisTable, SortByMember)
		else
			table.sort(tThisTable, SortByMemberReverse)
		end
	end
}

---mixin to use with DetailsFramework:Mixin(table, detailsFramework.DataMixin)
---add 'data' to a table, this table can be used to store data for the object
---@class DetailsFramework.DataMixin
detailsFramework.DataMixin = {
	---initialize the data table
	---@param self table
	DataConstructor = function(self)
		self._dataInfo = {
			data = {},
			dataCurrentIndex = 1,
			callbacks = {},
		}
	end,

	---when data is changed, functions registered with this function will be called
	---@param self table
	---@param func function
	---@param ... unknown
	AddDataChangeCallback = function(self, func, ...)
		assert(type(func) == "function", "invalid function for AddDataChangeCallback.")
		local allCallbacks = self._dataInfo.callbacks
		allCallbacks[func] = {...}
	end,

	---remove a previous registered callback function
	---@param self table
	---@param func function
	RemoveDataChangeCallback = function(self, func)
		assert(type(func) == "function", "invalid function for RemoveDataChangeCallback.")
		local allCallbacks = self._dataInfo.callbacks
		allCallbacks[func] = nil
	end,

	---set the data table
	---@param self table
	---@param data table
	SetData = function(self, data)
		assert(type(data) == "table", "invalid table for SetData.")
		self._dataInfo.data = data
		self:ResetDataIndex()

		local allCallbacks = self._dataInfo.callbacks
		for	func, payload in pairs(allCallbacks) do
			xpcall(func, geterrorhandler(), data, unpack(payload))
		end
	end,

	---get the data table
	---@param self table
	GetData = function(self)
		return self._dataInfo.data
	end,

	---get the next value from the data table
	---@param self table
	---@return any
	GetDataNextValue = function(self)
		local currentValue = self._dataInfo.dataCurrentIndex
		local value = self:GetData()[currentValue]
		self._dataInfo.dataCurrentIndex = self._dataInfo.dataCurrentIndex + 1
		return value
	end,

	---reset the data index, making GetDataNextValue() return the first value again
	ResetDataIndex = function(self)
		self._dataInfo.dataCurrentIndex = 1
	end,

	---get the size of the data table
	---@param self table
	---@return number
	GetDataSize = function(self)
		return #self:GetData()
	end,

	---get the first value from the data table
	---@param self table
	---@return any
	GetDataFirstValue = function(self)
		return self:GetData()[1]
	end,

	---get the last value from the data table
	---@param self table
	---@return any
	GetDataLastValue = function(self)
		local data = self:GetData()
		return data[#data]
	end,

	---get the min and max values from the data table, if the value stored is number, return the min and max values
	---@param self table
	---@return number, number
	GetDataMinMaxValues = function(self)
		local minDataValue = 0
		local maxDataValue = 0

		local data = self:GetData()
		for i = 1, #data do
			local thisData = data[i]
			if (thisData > maxDataValue) then
				maxDataValue = thisData

			elseif (thisData < minDataValue) then
				minDataValue = thisData
			end
		end

		return minDataValue, maxDataValue
	end,

	---when data uses sub tables, get the min max values from a specific index or key, if the value stored is number, return the min and max values
	---@param self table
	---@param key string
	---@return number, number
	GetDataMinMaxValueFromSubTable = function(self, key)
		local minDataValue = 0
		local maxDataValue = 0

		local data = self:GetData()
		for i = 1, #data do
			local thisData = data[i]
			if (thisData[key] > maxDataValue) then
				maxDataValue = thisData[key]

			elseif (thisData[key] < minDataValue) then
				minDataValue = thisData[key]
			end
		end

		return minDataValue, maxDataValue
	end,
}

---mixin to use with DetailsFramework:Mixin(table, detailsFramework.ValueMixin)
---add support to min value and max value into a table or object
---@class DetailsFramework.ValueMixin
detailsFramework.ValueMixin = {
	ValueConstructor = function(self)
		self.minValue = 0
		self.maxValue = 1
	end,

	SetMinMaxValues = function(self, minValue, maxValue)
		self.minValue = minValue
		self.maxValue = maxValue
	end,

	GetMinMaxValues = function(self)
		return self.minValue, self.maxValue
	end,

	GetMinValue = function(self)
		return self.minValue
	end,

	GetMaxValue = function(self)
		return self.maxValue
	end,

	SetMinValue = function(self, minValue)
		self.minValue = minValue
	end,

	SetMinValueIfLower = function(self, ...)
		self.minValue = min(self.minValue, ...)
	end,

	SetMaxValue = function(self, maxValue)
		self.maxValue = maxValue
	end,

	SetMaxValueIfBigger = function(self, ...)
		self.maxValue = max(self.maxValue, ...)
	end,
}
