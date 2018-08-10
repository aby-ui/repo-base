-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local date = _G.date
local error = _G.error
local type = _G.type

-- Libraries
local table = _G.table

-----------------------------------------------------------------------
-- Library namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local MAJOR = "LibTextDump-1.0"

_G.assert(LibStub, MAJOR .. " requires LibStub")

local MINOR = 3 -- Should be manually increased
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then
	return
end -- No upgrade needed

-----------------------------------------------------------------------
-- Migrations.
-----------------------------------------------------------------------
lib.prototype = lib.prototype or {}
lib.metatable = lib.metatable or { __index = lib.prototype }

lib.buffers = lib.buffers or {}
lib.frames = lib.frames or {}

lib.num_frames = lib.num_frames or 0

-----------------------------------------------------------------------
-- Constants and upvalues.
-----------------------------------------------------------------------
local prototype = lib.prototype
local metatable = lib.metatable

local buffers = lib.buffers
local frames = lib.frames

local METHOD_USAGE_FORMAT = MAJOR .. ":%s() - %s."

local DEFAULT_FRAME_WIDTH = 750
local DEFAULT_FRAME_HEIGHT = 600

-----------------------------------------------------------------------
-- Helper functions.
-----------------------------------------------------------------------
local function round(number, places)
	local mult = 10 ^ (places or 0)
	return _G.floor(number * mult + 0.5) / mult
end

local function NewInstance(width, height, useFauxScroll)
	lib.num_frames = lib.num_frames + 1

	local frameName = ("%s_CopyFrame%d"):format(MAJOR, lib.num_frames)
	local copyFrame = _G.CreateFrame("Frame", frameName, _G.UIParent, "ButtonFrameTemplate")
	copyFrame:SetSize(width, height)
	copyFrame:SetPoint("CENTER", _G.UIParent, "CENTER")
	copyFrame:SetFrameStrata("DIALOG")
	copyFrame:EnableMouse(true)
	copyFrame:SetMovable(true)
	copyFrame:SetToplevel(true)

	_G.ButtonFrameTemplate_HidePortrait(copyFrame)
	_G.ButtonFrameTemplate_HideAttic(copyFrame)
	_G.ButtonFrameTemplate_HideButtonBar(copyFrame)

	table.insert(_G.UISpecialFrames, frameName)
	_G.HideUIPanel(copyFrame)

	copyFrame.title = copyFrame.TitleText

	local titleBackground = _G[frameName .. "TitleBg"]
	local dragFrame = _G.CreateFrame("Frame", nil, copyFrame)
	dragFrame:SetPoint("TOPLEFT", titleBackground, 16, 0)
	dragFrame:SetPoint("BOTTOMRIGHT", titleBackground)
	dragFrame:EnableMouse(true)

	dragFrame:SetScript("OnMouseDown", function(self, button)
		copyFrame:StartMoving()
	end)

	dragFrame:SetScript("OnMouseUp", function(self, button)
		copyFrame:StopMovingOrSizing()
	end)

	local scrollArea

	if useFauxScroll then
		scrollArea = _G.CreateFrame("ScrollFrame", ("%sScroll"):format(frameName), copyFrame, "FauxScrollFrameTemplate")

		function scrollArea:Update(start, wrappedLines, maxDisplayLines, lineHeight)
			local lineIndex = start - 1
			local linesToDisplay = 0

			repeat
				lineIndex = lineIndex + 1
				linesToDisplay = linesToDisplay + (wrappedLines[lineIndex] or 0)
			until linesToDisplay > maxDisplayLines or not wrappedLines[lineIndex]

			local stop = lineIndex - 1

			self:Show()

			local name = self:GetName()
			local scrollBar = _G[name .. "ScrollBar"]

			scrollBar:SetStepsPerPage(linesToDisplay - 1)

			-- This block should only be run when the buffer is changed.
			-- Possible variations in linesToDisplay from scroll to scroll will affect the height of the scroll frame.
			-- This will then result in inconsistent scrolling behaviour.
			if lineHeight then
				local scrollChildFrame = _G[name .. "ScrollChildFrame"]

				local scrollFrameHeight = (wrappedLines.all - linesToDisplay) * lineHeight
				local scrollChildHeight = wrappedLines.all * lineHeight

				if scrollFrameHeight < 0 then
					scrollFrameHeight = 0
				end

				self.height = scrollFrameHeight

				scrollChildFrame:Show()
				scrollChildFrame:SetHeight(scrollChildHeight)

				scrollBar:SetMinMaxValues(0, scrollFrameHeight)
				scrollBar:SetValueStep(lineHeight)
			end

			-- Arrow button handling
			local scrollUpButton = _G[name .. "ScrollBarScrollUpButton"]
			local scrollDownButton = _G[name .. "ScrollBarScrollDownButton"]

			if scrollBar:GetValue() == 0 then
				scrollUpButton:Disable()
			else
				scrollUpButton:Enable()
			end

			if scrollBar:GetValue() - self.height == 0 then
				scrollDownButton:Disable()
			else
				scrollDownButton:Enable()
			end

			return start, stop
		end

		-- lineDummy is used to get the height of a line *after* word wrap to calculate the proper scroll position of the FauxScrollFrame.
		local lineDummy = copyFrame:CreateFontString()
		lineDummy:SetJustifyH("LEFT")
		lineDummy:SetNonSpaceWrap(true)
		lineDummy:SetFontObject("ChatFontNormal")
		lineDummy:SetPoint("TOPLEFT", 5, 100)
		lineDummy:SetPoint("BOTTOMRIGHT", copyFrame, "TOPRIGHT", -28, 0)
		lineDummy:Hide()

		copyFrame.lineDummy = lineDummy
	else
		scrollArea = _G.CreateFrame("ScrollFrame", ("%sScroll"):format(frameName), copyFrame, "UIPanelScrollFrameTemplate")

		scrollArea:SetScript("OnMouseWheel", function(self, delta)
			_G.ScrollFrameTemplate_OnMouseWheel(self, delta, self.ScrollBar)
		end)

		scrollArea.ScrollBar:SetScript("OnMouseWheel", function(self, delta)
			_G.ScrollFrameTemplate_OnMouseWheel(self, delta, self)
		end)
	end

	scrollArea:SetPoint("TOPLEFT", copyFrame.Inset, 5, -5)
	scrollArea:SetPoint("BOTTOMRIGHT", copyFrame.Inset, -27, 6)

	copyFrame.scrollArea = scrollArea


	local editBox = _G.CreateFrame("EditBox", nil, copyFrame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(0)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject("ChatFontNormal")

	editBox:SetScript("OnEscapePressed", function()
		_G.HideUIPanel(copyFrame)
	end)

	copyFrame.edit_box = editBox

	-- While using a standard scroll frame, editBox will be positioned automatcialy when set as its scrollChild.
	-- With the faux scroll, we have to position it ourself.
	if useFauxScroll then
		editBox:SetAllPoints(scrollArea)
	else
		editBox:SetSize(scrollArea:GetSize())
		scrollArea:SetScrollChild(editBox)
	end

	local highlightButton = _G.CreateFrame("Button", nil, copyFrame)
	highlightButton:SetSize(16, 16)
	highlightButton:SetPoint("TOPLEFT", titleBackground)

	highlightButton:SetScript("OnMouseUp", function(self, button)
		self.texture:ClearAllPoints()
		self.texture:SetAllPoints(self)

		editBox:HighlightText(0)
		editBox:SetFocus()

		copyFrame:RegisterEvent("PLAYER_LOGOUT")
	end)

	highlightButton:SetScript("OnMouseDown", function(self, button)
		self.texture:ClearAllPoints()
		self.texture:SetPoint("RIGHT", self, "RIGHT", 1, -1)
	end)

	highlightButton:SetScript("OnEnter", function(self)
		self.texture:SetVertexColor(0.75, 0.75, 0.75)
	end)

	highlightButton:SetScript("OnLeave", function(self)
		self.texture:SetVertexColor(1, 1, 1)
	end)

	local highlightIcon = highlightButton:CreateTexture()
	highlightIcon:SetAllPoints()
	highlightIcon:SetTexture([[Interface\BUTTONS\UI-GuildButton-PublicNote-Up]])
	highlightButton.texture = highlightIcon

	local instance = _G.setmetatable({}, metatable)
	frames[instance] = copyFrame
	buffers[instance] = {
		wrappedLines = {}
	}

	return instance
end


-----------------------------------------------------------------------
-- Library methods.
-----------------------------------------------------------------------
--- Create a new dump frame.
-- @param frameTitle The title text of the frame.
-- @param width (optional) The width of the frame.
-- @param height (optional) The height of the frame.
-- @param save (optional) A function that will be called when the copy button is clicked.
-- @return A handle for the dump frame.
function lib:New(frameTitle, width, height, save)
	local titleType = type(frameTitle)
	if titleType ~= "nil" and titleType ~= "string" then
		error(METHOD_USAGE_FORMAT:format("New", "frame title must be nil or a string."), 2)
	end

	local widthType = type(width)
	if widthType ~= "nil" and widthType ~= "number" then
		error(METHOD_USAGE_FORMAT:format("New", "frame width must be nil or a number."))
	end

	local heightType = type(height)
	if heightType ~= "nil" and heightType ~= "number" then
		error(METHOD_USAGE_FORMAT:format("New", "frame height must be nil or a number."))
	end

	local saveType = type(save)
	if saveType ~= "nil" and saveType ~= "function" then
		error(METHOD_USAGE_FORMAT:format("New", "save must be nil or a function."))
	end

	local instance = NewInstance(width or DEFAULT_FRAME_WIDTH, height or DEFAULT_FRAME_HEIGHT, not not save)
	local frame = frames[instance]
	frame.TitleText:SetText(frameTitle)

	if save then
		frame:SetScript("OnEvent", function(event, ...)
			buffers[instance].wrappedLines = nil
			save(buffers[instance])
		end)
	end

	return instance
end


-----------------------------------------------------------------------
-- Instance methods.
-----------------------------------------------------------------------
function prototype:AddLine(text, dateFormat)
	self:InsertLine(#buffers[self] + 1, text, dateFormat)

	if lib.frames[self]:IsVisible() then
		self:Display()
	end
end

function prototype:Clear()
	table.wipe(buffers[self])
	buffers[self].wrappedLines = {}
end

function prototype:Display(separator)
	local frame = frames[self]

	if frame.UpdateText then
		frame:UpdateText("Display")
	else
		local displayText = self:String(separator)

		if displayText == "" then
			error(METHOD_USAGE_FORMAT:format("Display", "buffer must be non-empty"), 2)
		end

		frame.edit_box:SetText(displayText)
		frame.edit_box:SetCursorPosition(0)
	end

	_G.ShowUIPanel(frame)
end

function prototype:InsertLine(position, text, dateFormat)
	if type(position) ~= "number" then
		error(METHOD_USAGE_FORMAT:format("InsertLine", "position must be a number."))
	end

	if type(text) ~= "string" or text == "" then
		error(METHOD_USAGE_FORMAT:format("InsertLine", "text must be a non-empty string."), 2)
	end

	local buffer = buffers[self]

	if dateFormat and dateFormat ~= "" then
		table.insert(buffer, position, ("[%s] %s"):format(date(dateFormat), text))
	else
		table.insert(buffer, position, text)
	end

	local lineDummy = frames[self].lineDummy

	if lineDummy then
		lineDummy:SetText(buffer[position])
		table.insert(buffer.wrappedLines, position, lineDummy:GetNumLines())
		buffer.wrappedLines.all = (buffer.wrappedLines.all or 0) + buffer.wrappedLines[position]
	end
end

function prototype:Lines()
	return #buffers[self]
end

function prototype:String(separator)
	local separatorType = type(separator)

	if separatorType ~= "nil" and separatorType ~= "string" then
		error(METHOD_USAGE_FORMAT:format("String", "separator must be nil or a string."), 2)
	end

	separator = separator or "\n"

	local buffer = buffers[self]
	local frame = frames[self]
	local lineDummy = frame.lineDummy

	if lineDummy then
		local _, lineHeight = lineDummy:GetFont()
		local maxDisplayLines = round(frame.edit_box:GetHeight() / lineHeight)
		local allWrappedLines = buffer.wrappedLines.all
		local offset = 1
		local start, stop = frame.scrollArea:Update(offset, buffer.wrappedLines, maxDisplayLines, lineHeight)

		function frame:UpdateText()
			local newWrappedLines = buffer.wrappedLines.all

			if newWrappedLines > allWrappedLines then
				allWrappedLines = newWrappedLines
				start, stop = frame.scrollArea:Update(offset, buffer.wrappedLines, maxDisplayLines, lineHeight)
			else
				start, stop = frame.scrollArea:Update(offset, buffer.wrappedLines, maxDisplayLines)
			end

			frame.edit_box:SetText(table.concat(buffer, separator, start, stop))
		end

		frame.scrollArea:SetScript("OnVerticalScroll", function(scrollArea, value)
			local scrollbar = scrollArea.ScrollBar
			local _, scrollMax = scrollbar:GetMinMaxValues()
			local scrollPer = round(value / scrollMax, 2)
			offset = round((1 - scrollPer) * 1 + scrollPer * #buffer)

			frame:UpdateText()
		end)

		return table.concat(buffer, separator, start, stop)
	else
		return table.concat(buffer, separator)
	end
end
