-----------------------------------------------------------
-- VirtualScrollList-1.0.lua
-----------------------------------------------------------
-- A virtual scroll list is a scroll list frame that is capable of displaying infinite
-- amount of user data with a fixed number of list buttons. Blizzard's FauxScrollFrame
-- does basically the same thing, though this one is far more powerful and convenient to use.
--
-- Abin (2010-1-27)

-----------------------------------------------------------
-- API Documentation:
-----------------------------------------------------------

-- frame = UICreateVirtualScrollList("name", parent, maxButtons [, selectable [, "buttonTemplate"]) -- Create a virtual scroll list frame

-- frame:GetScrollOffset() -- Return current scroll offset (0-N)
-- frame:SetScrollOffset(offset) -- Scroll the list
-- frame:CheckVisible([position]) -- Check whether a position is visible in the list (nil-invalid, 0-visible, other-invisible), "position" defaults to current selection
-- frame:EnsureVisible([position]) -- Ensure a position being visible, scroll the list if needed, "position" defaults to current selection
-- frame:RefreshContents() -- Refresh the entire list, call only when necessary!

-- frame:SetSelection(position) -- Select a data
-- frame:GetSelection() -- Get current selection

-- frame:GetDataCount() -- Return number of data in the list
-- frame:GetData(position) -- Retrieve a particular data
-- frame:SetData(position, data) -- Modify an existing data
-- frame:FindData(data [, compareFunc]) == Search for the first match of a particular data
-- frame:InsertData(data [, position]) -- Insert a new data to the list, by default the data is inserted at the end of list
-- frame:RemoveData(position) -- Remove an existing data, by default it removes the last data from the list
-- frame:ShiftData(position1, position2) -- Shift a data from position1 to position2
-- frame:SwapData(position1, position2) -- Swap 2 data in the list
-- frame:UpdateData(position) -- Call frame:OnButtonUpdate(button, data) if the list button reflects to position is visible at the moment
-- frame:Clear() -- Clear the list, all data are deleted

-----------------------------------------------------------
-- Callback Methods:
-----------------------------------------------------------

-- frame:OnButtonCreated(button) -- Called when a new list button is created
-- frame:OnButtonUpdate(button, data) -- Called when a list button needs to be re-painted
-- frame:OnButtonTooltip(button, data) -- Called when the mouse hovers a list button, you only need to populate texts into GameTooltip
-- frame:OnButtonEnter(button, data, motion) -- Called when the mouse hovers a list button
-- frame:OnButtonLeave(button, data, motion) -- Called when the mouse leaves a list button
-- frame:OnButtonClick(button, data, flag, down) -- Called when a list button is clicked
-- frame:OnSelectionChanged(position, data) -- Called when the selection changed

-----------------------------------------------------------

local MAJOR_VERSION = 1
local MINOR_VERSION = 10

-- To prevent older libraries from over-riding newer ones...
if type(UICreateVirtualScrollList_IsNewerVersion) == "function" and not UICreateVirtualScrollList_IsNewerVersion(MAJOR_VERSION, MINOR_VERSION) then return end

local NIL = "!2BFF-1B787839!"

local function EncodeData(data)
	return (data == nil) and NIL or data -- Must be nil, not false
end

local function DecodeData(data)
	return (data ~= NIL) and data or nil
end

local function SafeCall(func, ...)
	if type(func) == "function" then
		return func(...)
	end
end

-- Update slider buttons stats: enable/disable according to scroll range and offset
local function Slider_UpdateSliderButtons(self)
	local low, high = self:GetMinMaxValues()
	local value = self:GetValue()
	local up = self:GetParent().Up
	local down = self:GetParent().Down

	if low and high and value then
		if value <= low then
			up:Disable()
		else
			up:Enable()
		end

		if value >= high then
			down:Disable()
		else
			down:Enable()
		end
	end
end

local function ScrollBar_Button_OnClick(self)
	local slider = self:GetParent().slider
	slider:SetValue(slider:GetValue() + self.value)
end

-- Create slider button: Up/Down
local function ScrollBar_CreateScrollButton(self, value)
	local button = CreateFrame("Button", self:GetName()..value.."Button", self, "UIPanelScroll"..value.."ButtonTemplate")
	button.value = value == "Up" and -1 or 1
	self[value] = button
	button:SetWidth(16)
	button:SetHeight(14)
	button:SetPoint(value == "Up" and "TOP" or "BOTTOM")
	button:Disable()
	button:SetScript("OnClick", ScrollBar_Button_OnClick)
end

-- Apply or remove a texture(highlight/checked) to/from a particular list button
local function Frame_TextureButton(self, textureName, button)
	local texture = self[textureName]
	if texture then
		if button then
			if texture.button ~= button then
				texture.button = button
				texture:SetParent(button)
				texture:ClearAllPoints()
				texture:SetAllPoints(button)
				texture:Show()
			end
		else
			texture.button = nil
			texture:Hide()
		end
	end
end

-- Schedule a frame refresh
local function Frame_ScheduleRefresh(self)
	self.needRefresh = 1
end

local function Frame_GetScrollOffset(self)
	return self.slider:GetValue()
end

local function Frame_SetScrollOffset(self, offset)
	if type(offset) == "number" then
		self.slider:SetValue(offset)
		return Frame_GetScrollOffset(self)
	end
end

local function ListButton_OnEnter(self, motion)
	local parent = self:GetParent()
	Frame_TextureButton(parent, "highlightTexture", self)
	SafeCall(parent.OnButtonEnter, parent, self, self.data, motion)
	if type(parent.OnButtonTooltip) == "function" then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:ClearLines()
		parent:OnButtonTooltip(self, self.data)
		GameTooltip:Show()
	end
end

local function ListButton_OnLeave(self, motion)
	local parent = self:GetParent()
	Frame_TextureButton(parent, "highlightTexture")
	if parent.OnButtonTooltip then
		GameTooltip:Hide()
	end
	SafeCall(parent.OnButtonLeave, parent, self, self.data, motion)
end

local function ListButton_OnClick(self, flag, down)
	local parent = self:GetParent()
	if flag == "LeftButton" and parent.selectable then
		local dataIndex = self:GetID() + Frame_GetScrollOffset(parent)
		if parent.selection ~= dataIndex then
			Frame_TextureButton(self:GetParent(), "checkedTexture", self)
			parent.selection = dataIndex
			SafeCall(parent.OnSelectionChanged, parent, dataIndex, self.data)
		end
	end
	SafeCall(parent.OnButtonClick, parent, self, self.data, flag, down)
end

-- Get the list button which is currently displaying the given data
local function Frame_PositionToButton(self, position)
	return self.listButtons[position - Frame_GetScrollOffset(self)]
end

local function Frame_UpdateButtonData(self, position)
	local button = Frame_PositionToButton(self, position)
	if button then
		button.data = DecodeData(self.listData[position])
		SafeCall(self.OnButtonUpdate, self, button, button.data)
	end
end

-- Create a list button
local function Frame_CreateListButton(self, id)
	local button = CreateFrame("Button", self:GetName().."Button"..id, self, self.buttonTemplate)
	button:SetID(id)

	if button:GetHeight() == 0 then
		button:SetHeight(20)
	end

	local prev = self.listButtons[id - 1]
	if prev then
		button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT")
		button:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT")
	else
		button:SetPoint("TOPLEFT")
		button:SetPoint("TOPRIGHT", self.scrollBar, "TOPLEFT")
	end

	tinsert(self.listButtons, button)
	SafeCall(self.OnButtonCreated, self, button, id)

	button:HookScript("OnEnter", ListButton_OnEnter)
	button:HookScript("OnLeave", ListButton_OnLeave)
	button:HookScript("OnClick", ListButton_OnClick)

	return button
end

local function Frame_CheckVisible(self, position)
	if not position then
		position = self.selection
	end

	if type(position) ~= "number" or not self.listData[position] then
		return
	end

	local low = Frame_GetScrollOffset(self) + 1
	local high = low + self.maxButtons - 1

	if position < low then
		return position - low
	elseif position > high then
		return position - high
	else
		return 0
	end
end

local function Frame_EnsureVisible(self, position)
	local visible = Frame_CheckVisible(self, position)
	if visible then
		if visible ~= 0 then
			Frame_SetScrollOffset(self, Frame_GetScrollOffset(self) + visible)
		end
		return 1
	end
end

-- Update list buttons' contents, gives the user a chance to re-paint buttons
local function Frame_UpdateList(self)
	local offset = self.slider:GetValue()
	local i, checkedButton
	for i = 1, self.maxButtons do
		local button = self.listButtons[i]
		local dataIndex = i + offset
		local data = self.listData[dataIndex]
		if data ~= nil then
			if not button then
				button = Frame_CreateListButton(self, i)
			end

			if not checkedButton and self.selection == dataIndex then
				checkedButton = button
			end

			button.data = DecodeData(data)
			SafeCall(self.OnButtonUpdate, self, button, button.data)
			button:Hide()
			button:Show()
		elseif button then
			button.data = nil
			button:Hide()
		end
	end
	Frame_TextureButton(self, "checkedTexture", checkedButton)
end

-- Refresh list contents including scroll bar stats after the list frame is resized or data are inserted/removed
local function Frame_RefreshContents(self)
	self.needRefresh = nil
	local scrollBar = self.scrollBar
	local slider = self.slider
	local maxButtons = self.maxButtons
	local dataCount = #(self.listData)
	local range = max(0, dataCount - maxButtons)

	if range > 0 then
		slider.thumb:SetHeight(max(6, slider:GetHeight() * (maxButtons / dataCount)))
		scrollBar:SetWidth(14)
		scrollBar:Show()
	else
		scrollBar:Hide()
		scrollBar:SetWidth(1)
	end

	slider:SetMinMaxValues(0, range)
	if slider:GetValue() > range then
		slider:SetValue(range)
	else
		Frame_UpdateList(self)
	end
end

local function Slider_OnValueChanged(self, value)
	Frame_UpdateList(self.listFrame)
end

local function Frame_GetDataCount(self)
	return #(self.listData)
end

local function Frame_FindData(self, data, compareFunc)
	compareFunc = type(compareFunc) == "function" and compareFunc
	local i, stored
	for i, stored in ipairs(self.listData) do
		local d = DecodeData(stored)
		if compareFunc then
			if compareFunc(d, data) then
				return i
			end
		else
			if d == data then
				return i
			end
		end
	end
end

local function Frame_GetData(self, position)
	return DecodeData(self.listData[position])
end

local function Frame_SetData(self, position, data)
	if self.listData[position] then
		self.listData[position] = EncodeData(data)
		Frame_UpdateButtonData(self, position)
		return 1
	end
end

local function Frame_InsertData(self, data, position)
	local limit = #(self.listData) + 1
	position = type(position) == "number" and min(limit, max(1, floor(position))) or limit
	tinsert(self.listData, position, EncodeData(data))

	if self.selection and self.selection >= position then
		self.selection = self.selection + 1
		SafeCall(self.OnSelectionChanged, self, self.selection, Frame_GetData(self, self.selection))
	end

	Frame_ScheduleRefresh(self)
	return position
end

local function Frame_RemoveData(self, position)
	local data
	if type(position) == "number" then
		data = tremove(self.listData, position)
	else
		position = #(self.listData)
		data = tremove(self.listData)
	end

	if not data then
		return
	end

	if self.selection and self.selection >= position then
		if self.selection == position then
			self.selection = nil
		else
			self.selection = self.selection - 1
		end
		SafeCall(self.OnSelectionChanged, self, self.selection, Frame_GetData(self, self.selection))
	end

	Frame_ScheduleRefresh(self)
	return DecodeData(data)
end

local function Frame_ShiftData(self, position1, position2)
	if type(position1) ~= "number" or type(position2) ~= "number" or position1 == position2 then
		return
	end

	if not self.listData[position1] or not self.listData[position2] then
		return
	end

	tinsert(self.listData, position2, tremove(self.listData, position1))

	if self.selection then
		local selection = self.selection
		if selection == position1 then
			selection = position2
		elseif position1 < position2 then
			if selection > position1 and selection <= position2 then
				selection = selection - 1
			end
		elseif position1 > position2 then
			if selection >= position2 and selection < position1 then
				selection = selection + 1
			end
		end

		if self.selection ~= selection then
			self.selection = selection
			SafeCall(self.OnSelectionChanged, self, selection, Frame_GetData(self, selection))
		end
	end

	Frame_UpdateList(self)
	return 1
end

local function Frame_SwapData(self, position1, position2)
	if type(position1) ~= "number" or type(position2) ~= "number" or position1 == position2 then
		return
	end

	local data1 = self.listData[position1]
	local data2 = self.listData[position2]
	if data1 and data2 then
		self.listData[position1] = data2
		self.listData[position2] = data1

		Frame_UpdateButtonData(self, position1)
		Frame_UpdateButtonData(self, position2)

		if self.selection == position1 then
			Frame_SetSelection(self, position2)
		elseif self.selection == position2 then
			Frame_SetSelection(self, position1)
		end

		return 1
	end
end

local function Frame_UpdateData(self, position)
	if type(self.OnButtonUpdate) ~= "function" then
		return
	end

	local data = self.listData[position]
	if not data then
		return
	end

	local low = Frame_GetScrollOffset(self) + 1
	local high = low + self.maxButtons - 1
	if position < low or position > high then
		return
	end

	local button = Frame_PositionToButton(self, position)
	if button then
		self:OnButtonUpdate(button, DecodeData(data))
		return 1
	end
end

local function Frame_Clear(self)
	wipe(self.listData)
	Frame_SetScrollOffset(self, 0)
	if self.selection then
		self.selection = nil
		SafeCall(self.OnSelectionChanged, self)
	end
	Frame_RefreshContents(self)
end

local function Frame_GetSelection(self)
	if self.selection then
		local data = self.listData[self.selection]
		return self.selection, DecodeData(data)
	end
end

local function Frame_SetSelection(self, position)
	if not self.selectable or type(position) ~= "number" or not self.listData[position] then
		return
	end

	if self.selection ~= position then
		self.selection = position
		Frame_TextureButton(self, "checkedTexture", Frame_PositionToButton(self, position))
		SafeCall(self.OnSelectionChanged, self, position, Frame_GetData(self, position))
	end
	return 1
end

local function Frame_OnMouseWheel(self, value)
	local slider = self.slider
	local _, range = slider:GetMinMaxValues()
	if range > 0 then
		slider:SetValue(slider:GetValue() - max(1, range / 10) * value)
	end
end

local function Frame_OnUpdate(self)
	if self.needRefresh then
		Frame_RefreshContents(self)
	end
end

-- Create the scroll list frame
function UICreateVirtualScrollList(name, parent, maxButtons, selectable, buttonTemplate)
	if type(name) ~= "string" then
		error(format("bad argument #1 to 'UICreateVirtualScrollList' (string expected, got %s)", type(name)))
		return
	end

	local frame = CreateFrame("Frame", name, parent)
	if not frame then
		error("'UICreateVirtualScrollList' frame creation failed, check name and parent")
		return
	end

	frame:EnableMouseWheel(true)
	frame.maxButtons = type(maxButtons) == "number" and max(1, floor(maxButtons)) or 1
	frame.selectable = selectable
	frame.buttonTemplate = type(buttonTemplate) == "string" and buttonTemplate or nil
	frame.listButtons = {}
	frame.listData = {}

	local scrollBar = CreateFrame("Frame", name.."ScrollBar", frame)
	frame.scrollBar = scrollBar
	scrollBar:Hide()
	scrollBar:SetWidth(1)
	scrollBar:SetPoint("TOPRIGHT")
	scrollBar:SetPoint("BOTTOMRIGHT")
	ScrollBar_CreateScrollButton(scrollBar, "Up")
	ScrollBar_CreateScrollButton(scrollBar, "Down")

	local slider = CreateFrame("Slider", scrollBar:GetName().."Slider", scrollBar)
	frame.slider = slider
	scrollBar.slider = slider
	slider.listFrame = frame
	slider:SetValueStep(1)
	slider:SetWidth(14)
	slider:SetPoint("TOP", scrollBar.Up, "BOTTOM", 0, -1)
	slider:SetPoint("BOTTOM", scrollBar.Down, "TOP", 0, 1)
	slider:SetMinMaxValues(0, 0)
	slider:SetValue(0)
	hooksecurefunc(slider, "SetMinMaxValues", Slider_UpdateSliderButtons)
	hooksecurefunc(slider, "SetValue", Slider_UpdateSliderButtons)

	local thumb = slider:CreateTexture(name.."SliderThumbTexture", "OVERLAY")
	slider.thumb = thumb
	thumb:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	thumb:SetWidth(slider:GetWidth())
	thumb:SetGradientAlpha("HORIZONTAL", 0.5, 0.5, 0.5, 0.75, 0.15, 0.15, 0.15, 1)
	slider:SetThumbTexture(thumb)

	slider:SetScript("OnValueChanged", Slider_OnValueChanged)

	frame.highlightTexture = frame:CreateTexture(name.."HighlightTexture", "BORDER")
	frame.highlightTexture:Hide()
	frame.highlightTexture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	frame.highlightTexture:SetBlendMode("ADD")
	frame.highlightTexture:SetVertexColor(1, 1, 1, 0.7)

	if selectable then
		frame.checkedTexture = frame:CreateTexture(name.."CheckedTexture", "BORDER")
		frame.checkedTexture:Hide()
		frame.checkedTexture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		frame.checkedTexture:SetBlendMode("ADD")
		frame.checkedTexture:SetVertexColor(1, 1, 1, 0.7)
	end

	frame:SetScript("OnShow", Frame_RefreshContents)
	frame:SetScript("OnSizeChanged", Frame_RefreshContents)
	frame:SetScript("OnMouseWheel", Frame_OnMouseWheel)
	frame:SetScript("OnUpdate", Frame_OnUpdate)
	frame.needRefresh = 1

	-- Public API
	frame.GetSelection = Frame_GetSelection
	frame.SetSelection = Frame_SetSelection
	frame.GetScrollOffset = Frame_GetScrollOffset
	frame.SetScrollOffset = Frame_SetScrollOffset
	frame.CheckVisible = Frame_CheckVisible
	frame.EnsureVisible = Frame_EnsureVisible
	frame.GetDataCount = Frame_GetDataCount
	frame.GetData = Frame_GetData
	frame.SetData = Frame_SetData
	frame.FindData = Frame_FindData
	frame.InsertData = Frame_InsertData
	frame.RemoveData = Frame_RemoveData
	frame.ShiftData = Frame_ShiftData
	frame.SwapData = Frame_SwapData
	frame.UpdateData = Frame_UpdateData
	frame.Clear = Frame_Clear
	frame.RefreshContents = Frame_RefreshContents
	return frame
end

-- Provides version check
function UICreateVirtualScrollList_IsNewerVersion(major, minor)
	if type(major) ~= "number" or type(minor) ~= "number" then
		return false
	end

	if major > MAJOR_VERSION then
		return true
	elseif major < MAJOR_VERSION then
		return false
	else -- major equal, check minor
		return minor > MINOR_VERSION
	end
end