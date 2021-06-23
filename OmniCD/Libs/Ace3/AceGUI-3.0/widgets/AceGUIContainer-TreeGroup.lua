---------------------------------------------------------------------------------

-- Customized for OmniCD by permission of the copyright owner.

-- Parameters to set a group as a line break:
-- disabled = true,
-- name = "```",

---------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
TreeGroup Container
Container that uses a tree control to switch between groups.
-------------------------------------------------------------------------------]]
local Type, Version = "TreeGroup-OmniCD", 45
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local next, pairs, ipairs, assert, type = next, pairs, ipairs, assert, type
local math_min, math_max, floor = math.min, math.max, floor
local select, tremove, unpack, tconcat = select, table.remove, unpack, table.concat

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: FONT_COLOR_CODE_CLOSE

-- Recycling functions
local new, del
do
	local pool = setmetatable({},{__mode='k'})
	function new()
		local t = next(pool)
		if t then
			pool[t] = nil
			return t
		else
			return {}
		end
	end
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end
		pool[t] = true
	end
end

local DEFAULT_TREE_WIDTH = 145
local DEFAULT_TREE_SIZABLE = false

local DEFAULT_ICON_SIZE = 18
local DEFAULT_TAB_HEIGHT = 24
local USE_ICON_BACKDROP = true

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
local function GetButtonUniqueValue(line)
	local parent = line.parent
	if parent and parent.value then
		return GetButtonUniqueValue(parent).."\001"..line.value
	else
		return line.value
	end
end

local function UpdateButton(button, treeline, selected, canExpand, isExpanded)
	local self = button.obj
	local toggle = button.toggle
	local text = treeline.text or ""
	local icon = treeline.icon
	local iconCoords = treeline.iconCoords
	local level = treeline.level
	local value = treeline.value
	local uniquevalue = treeline.uniquevalue
	local disabled = treeline.disabled

	button.treeline = treeline
	button.value = value
	button.uniquevalue = uniquevalue
	if selected then
		button:LockHighlight()
		button.bg:Show()
		button.selected = true
	else
		button:UnlockHighlight()
		button.bg:Hide()
		button.selected = false
	end
	button.level = level
	if ( level == 1 ) then
		button:SetNormalFontObject("GameFontNormal-OmniCD")
		button:SetHighlightFontObject("GameFontHighlight-OmniCD")
		button.text:SetPoint("LEFT", (icon and DEFAULT_ICON_SIZE + ((DEFAULT_TAB_HEIGHT - DEFAULT_ICON_SIZE)/2) or 0) + 8, 0)
	else
		button:SetNormalFontObject("GameFontHighlight-OmniCD")
		button:SetHighlightFontObject("GameFontHighlight-OmniCD")
		button.text:SetPoint("LEFT", (icon and DEFAULT_ICON_SIZE + ((DEFAULT_TAB_HEIGHT - DEFAULT_ICON_SIZE)/2) or 0) + 8, 0)
	end

	if disabled then
		button:EnableMouse(false)
		if text == "```" then
			button.text:SetText("")
			button:SetHeight(OmniCD[1].PixelMult)
			button.borderBottom:SetColorTexture(0.569, 0.275, 1.0)
		else
			button.text:SetText("|cff808080"..text..FONT_COLOR_CODE_CLOSE)
		end
	else
		button.text:SetText(text)
		button:EnableMouse(true)
		button:SetHeight(DEFAULT_TAB_HEIGHT)
		button.borderBottom:SetColorTexture(0, 0, 0)
	end

	if icon then
		if USE_ICON_BACKDROP then
			button.icon:Show()
			button.icon.Center:SetTexture(icon)
		else
			button.icon:SetTexture(icon)
		end
		button.icon:SetPoint("LEFT", (DEFAULT_TAB_HEIGHT - DEFAULT_ICON_SIZE)/2, 0)
	else
		if USE_ICON_BACKDROP then
			button.icon:Hide()
		else
			button.icon:SetTexture(nil)
		end
	end

	if iconCoords then
		if USE_ICON_BACKDROP then
			button.icon.Center:SetTexCoord(unpack(iconCoords))
		else
			button.icon:SetTexCoord(unpack(iconCoords))
		end
	else
		if USE_ICON_BACKDROP then
			button.icon.Center:SetTexCoord(0, 1, 0, 1)
		else
			button.icon:SetTexCoord(0, 1, 0, 1)
		end
	end

	if canExpand then
		if not isExpanded then
			button.toggle:SetNormalTexture([[Interface\AddOns\OmniCD\Media\omnicd-bg-gnav2-plus]])
			button.toggle:SetPushedTexture(nil)
		else
			button.toggle:SetNormalTexture([[Interface\AddOns\OmniCD\Media\omnicd-bg-gnav2-minus]])
			button.toggle:SetPushedTexture(nil)
		end
		toggle:Show()
	else
		toggle:Hide()
	end
end

local function ShouldDisplayLevel(tree)
	local result = false
	for k, v in ipairs(tree) do
		if v.children == nil and v.visible ~= false then
			result = true
		elseif v.children then
			result = result or ShouldDisplayLevel(v.children)
		end
		if result then return result end
	end
	return false
end

local function addLine(self, v, tree, level, parent)
	local line = new()
	line.value = v.value
	line.text = v.text
	line.icon = v.icon
	line.iconCoords = v.iconCoords
	line.disabled = v.disabled
	line.tree = tree
	line.level = level
	line.parent = parent
	line.visible = v.visible
	line.uniquevalue = GetButtonUniqueValue(line)
	if v.children then
		line.hasChildren = true
	else
		line.hasChildren = nil
	end
	self.lines[#self.lines+1] = line
	return line
end

--fire an update after one frame to catch the treeframes height
local function FirstFrameUpdate(frame)
	local self = frame.obj
	frame:SetScript("OnUpdate", nil)
	self:RefreshTree(nil, true)
end

local function BuildUniqueValue(...)
	local n = select('#', ...)
	if n == 1 then
		return ...
	else
		return (...).."\001"..BuildUniqueValue(select(2,...))
	end
end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Expand_OnClick(frame)
	local button = frame.button
	local self = button.obj
	local status = (self.status or self.localstatus).groups
	status[button.uniquevalue] = not status[button.uniquevalue]
	self:RefreshTree()
end

local function Button_OnClick(frame)
	local self = frame.obj
	self:Fire("OnClick", frame.uniquevalue, frame.selected)
	if not frame.selected then
		self:SetSelected(frame.uniquevalue)
		frame.selected = true
		frame:LockHighlight()
		frame.bg:Show()
		self:RefreshTree()
	end
	AceGUI:ClearFocus()
end

local function Button_OnDoubleClick(button)
	local self = button.obj
	local status = (self.status or self.localstatus).groups
	status[button.uniquevalue] = not status[button.uniquevalue]
	self:RefreshTree()
end

local function Button_OnEnter(frame)
	local self = frame.obj
	self:Fire("OnButtonEnter", frame.uniquevalue, frame)

	if self.enabletooltips then
		local tooltip = AceGUI.tooltip
		tooltip:SetOwner(frame, "ANCHOR_NONE")
		tooltip:ClearAllPoints()
		tooltip:SetPoint("LEFT",frame,"RIGHT")
		tooltip:SetText(frame.text:GetText() or "", 1, .82, 0, true)

		tooltip:Show()
	end

	if not frame.selected then
		local fadeOut = frame.fadeOut
		if fadeOut:IsPlaying() then
			fadeOut:Stop()
		end
		frame.fadeIn:Play()
	end
end

local function Button_OnLeave(frame)
	local self = frame.obj
	self:Fire("OnButtonLeave", frame.uniquevalue, frame)

	if self.enabletooltips then
		AceGUI.tooltip:Hide()
	end

	if not frame.selected then
		local fadeIn = frame.fadeIn
		if fadeIn:IsPlaying() then
			fadeIn:Stop()
		end
		frame.fadeOut:Play()
	end
end

local function OnScrollValueChanged(frame, value)
	if frame.obj.noupdate then return end
	local self = frame.obj
	local status = self.status or self.localstatus
	status.scrollvalue = floor(value + 0.5)
	self:RefreshTree()
	AceGUI:ClearFocus()
end

local function Tree_OnSizeChanged(frame)
	frame.obj:RefreshTree()
end

local function Tree_OnMouseWheel(frame, delta)
	local self = frame.obj
	if self.showscroll then
		local scrollbar = self.scrollbar
		local min, max = scrollbar:GetMinMaxValues()
		local value = scrollbar:GetValue()
		local newvalue = math_min(max,math_max(min,value - delta))
		if value ~= newvalue then
			scrollbar:SetValue(newvalue)
		end
	end
end

local function Dragger_OnLeave(frame)
	frame:SetBackdropColor(1, 1, 1, 0)
end

local function Dragger_OnEnter(frame)
	frame:SetBackdropColor(1, 1, 1, 0.8)
end

local function Dragger_OnMouseDown(frame)
	local treeframe = frame:GetParent()
	treeframe:StartSizing("RIGHT")
end

local function Dragger_OnMouseUp(frame)
	local treeframe = frame:GetParent()
	local self = treeframe.obj
	local treeframeParent = treeframe:GetParent()
	treeframe:StopMovingOrSizing()
	--treeframe:SetScript("OnUpdate", nil)
	treeframe:SetUserPlaced(false)
	--Without this :GetHeight will get stuck on the current height, causing the tree contents to not resize
	treeframe:SetHeight(0)
	treeframe:ClearAllPoints()
	treeframe:SetPoint("TOPLEFT", treeframeParent, "TOPLEFT",0,0)
	treeframe:SetPoint("BOTTOMLEFT", treeframeParent, "BOTTOMLEFT",0,0)

	local status = self.status or self.localstatus
	status.treewidth = treeframe:GetWidth()

	treeframe.obj:Fire("OnTreeResize",treeframe:GetWidth())
	-- recalculate the content width
	treeframe.obj:OnWidthSet(status.fullwidth)
	-- update the layout of the content
	treeframe.obj:DoLayout()
end

local function Thumb_OnEnter(frame)
	frame.ThumbTexture:SetColorTexture(0.5, 0.5, 0.5)
end
local function Thumb_OnLeave(frame)
	if not frame.isMouseDown then
		frame.ThumbTexture:SetColorTexture(0.3, 0.3, 0.3)
	end
end
local function Thumb_OnMouseDown(frame)
	frame.isMouseDown = true
end
local function Thumb_OnMouseUp(frame)
	if frame.isMouseDown then
		frame.isMouseDown = nil
		frame.ThumbTexture:SetColorTexture(0.3, 0.3, 0.3)
	end
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetTreeWidth(DEFAULT_TREE_WIDTH, DEFAULT_TREE_SIZABLE)
		self:EnableButtonTooltips(true)
		self.frame:SetScript("OnUpdate", FirstFrameUpdate)
	end,

	["OnRelease"] = function(self)
		self.status = nil
		self.tree = nil
		self.frame:SetScript("OnUpdate", nil)
		for k, v in pairs(self.localstatus) do
			if k == "groups" then
				for k2 in pairs(v) do
					v[k2] = nil
				end
			else
				self.localstatus[k] = nil
			end
		end
		self.localstatus.scrollvalue = 0
		self.localstatus.treewidth = DEFAULT_TREE_WIDTH
		self.localstatus.treesizable = DEFAULT_TREE_SIZABLE
	end,

	["EnableButtonTooltips"] = function(self, enable)
		self.enabletooltips = enable
	end,

	["CreateButton"] = function(self)
		local num = AceGUI:GetNextWidgetNum("TreeGroupButton-OmniCD")
		local button = CreateFrame("Button", ("AceGUI30TreeButton%d-OmniCD"):format(num), self.treeframe, "OptionsListButtonTemplate")
		button.obj = self

		button:SetWidth(150)
		button:SetHeight(DEFAULT_TAB_HEIGHT)
		button:SetHighlightTexture("")

		button.borderBottom = button:CreateTexture(nil, "BACKGROUND") -- line break texture instead of backdrop -- BDR (tree nav button)
		OmniCD[1].DisablePixelSnap(button.borderBottom) -- works w/o ?
		button.borderBottom:SetPoint("BOTTOMLEFT")
		button.borderBottom:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, OmniCD[1].PixelMult)
		button.borderBottom:SetColorTexture(0, 0, 0)

		button.bg = button:CreateTexture(nil, "BORDER")
		OmniCD[1].DisablePixelSnap(button.bg) -- works w/o ?
		button.bg:SetPoint("TOPLEFT", OmniCD[1].PixelMult, 0)
		button.bg:SetPoint("BOTTOMRIGHT", button.borderBottom, "TOPRIGHT", -OmniCD[1].PixelMult, 0)
		button.bg:SetColorTexture(0.412, 0.0, 0.043)
		button.bg:Hide()

		button.fadeIn = button.bg:CreateAnimationGroup()
		button.fadeIn:SetScript("OnPlay", function() button.bg:Show() end)
		local fadeIn = button.fadeIn:CreateAnimation("Alpha")
		fadeIn:SetFromAlpha(0)
		fadeIn:SetToAlpha(1)
		fadeIn:SetDuration(0.4)
		fadeIn:SetSmoothing("OUT")

		button.fadeOut = button.bg:CreateAnimationGroup()
		button.fadeOut:SetScript("OnFinished", function() button.bg:Hide() end)
		local fadeOut = button.fadeOut:CreateAnimation("Alpha")
		fadeOut:SetFromAlpha(1)
		fadeOut:SetToAlpha(0)
		fadeOut:SetDuration(0.3)
		fadeOut:SetSmoothing("OUT")

		local icon
		if USE_ICON_BACKDROP then
			icon = CreateFrame("Frame", nil, button, "BackdropTemplate")
			icon:SetHeight(DEFAULT_ICON_SIZE)
			icon:SetWidth(DEFAULT_ICON_SIZE)
			OmniCD[1].BackdropTemplate(icon)
			icon:SetBackdropBorderColor(0.5, 0.5, 0.5)
		else
			icon = button:CreateTexture(nil, "ARTWORK")
			icon:SetHeight(DEFAULT_ICON_SIZE)
			icon:SetWidth(DEFAULT_ICON_SIZE)
		end
		button.icon = icon

		button:SetScript("OnClick",Button_OnClick)
		button:SetScript("OnDoubleClick", Button_OnDoubleClick)
		button:SetScript("OnEnter",Button_OnEnter)
		button:SetScript("OnLeave",Button_OnLeave)

		button.toggle.button = button
		button.toggle:SetScript("OnClick",Expand_OnClick)

		button.text:SetHeight(DEFAULT_ICON_SIZE) -- Prevents text wrapping

		return button
	end,

	["SetStatusTable"] = function(self, status)
		assert(type(status) == "table")
		self.status = status
		if not status.groups then
			status.groups = {}
		end
		if not status.scrollvalue then
			status.scrollvalue = 0
		end
		if not status.treewidth then
			status.treewidth = DEFAULT_TREE_WIDTH
		end
		if status.treesizable == nil then
			status.treesizable = DEFAULT_TREE_SIZABLE
		end
		self:SetTreeWidth(status.treewidth,status.treesizable)
		self:RefreshTree()
	end,

	--sets the tree to be displayed
	["SetTree"] = function(self, tree, filter)
		self.filter = filter
		if tree then
			assert(type(tree) == "table")
		end
		self.tree = tree
		self:RefreshTree()
	end,

	["BuildLevel"] = function(self, tree, level, parent)
		local groups = (self.status or self.localstatus).groups

		for i, v in ipairs(tree) do
			if v.children then
				if not self.filter or ShouldDisplayLevel(v.children) then
					local line = addLine(self, v, tree, level, parent)
					if groups[line.uniquevalue] then
						self:BuildLevel(v.children, level+1, line)
					end
				end
			elseif v.visible ~= false or not self.filter then
				addLine(self, v, tree, level, parent)
			end
		end
	end,

	["RefreshTree"] = function(self,scrollToSelection,fromOnUpdate)
		local buttons = self.buttons
		local lines = self.lines

		for i, v in ipairs(buttons) do
			v:Hide()
		end
		while lines[1] do
			local t = tremove(lines)
			for k in pairs(t) do
				t[k] = nil
			end
			del(t)
		end

		if not self.tree then return end
		--Build the list of visible entries from the tree and status tables
		local status = self.status or self.localstatus
		local groupstatus = status.groups
		local tree = self.tree

		local treeframe = self.treeframe

		status.scrollToSelection = status.scrollToSelection or scrollToSelection    -- needs to be cached in case the control hasn't been drawn yet (code bails out below)

		self:BuildLevel(tree, 1)

		local numlines = #lines

		local numDisabled = 0
		for i,line in ipairs(lines) do
			if line.disabled then
				if line.text == "```" then
					numDisabled = numDisabled + 1
				end
			end
		end
		local height = self.treeframe:GetHeight() or 0
		local maxlines = floor(  (height - 9 + (numDisabled*(DEFAULT_TAB_HEIGHT-OmniCD[1].PixelMult))) / DEFAULT_TAB_HEIGHT  )

		if maxlines <= 0 then return end

		if self.frame:GetParent() == UIParent and not fromOnUpdate then
			self.frame:SetScript("OnUpdate", FirstFrameUpdate)
			return
		end

		local first, last

		scrollToSelection = status.scrollToSelection
		status.scrollToSelection = nil

		if numlines <= maxlines then
			--the whole tree fits in the frame
			status.scrollvalue = 0
			self:ShowScroll(false)
			first, last = 1, numlines
		else
			local viewheight = DEFAULT_TAB_HEIGHT * numlines
			if height > 0 then
				local thumbHeight = min( height*0.5, (height^2) / viewheight )
				self.scrollbar.ThumbTexture:SetHeight(thumbHeight)
			end

			self:ShowScroll(true)
			--scrolling will be needed
			self.noupdate = true
			self.scrollbar:SetMinMaxValues(0, numlines - maxlines)
			--check if we are scrolled down too far
			if numlines - status.scrollvalue < maxlines then
				status.scrollvalue = numlines - maxlines
			end
			self.noupdate = nil
			first, last = status.scrollvalue+1, status.scrollvalue + maxlines
			--show selection?
			if scrollToSelection and status.selected then
				local show
				for i,line in ipairs(lines) do  -- find the line number
					if line.uniquevalue==status.selected then
						show=i
					end
				end
				if not show then
					-- selection was deleted or something?
				elseif show>=first and show<=last then
					-- all good
				else
					-- scrolling needed!
					if show<first then
						status.scrollvalue = show-1
					else
						status.scrollvalue = show-maxlines
					end
					first, last = status.scrollvalue+1, status.scrollvalue + maxlines
				end
			end
			if self.scrollbar:GetValue() ~= status.scrollvalue then
				self.scrollbar:SetValue(status.scrollvalue)
			end
		end

		local buttonnum = 1
		for i = first, last do
			local line = lines[i]
			local button = buttons[buttonnum]
			if not button then
				button = self:CreateButton()

				buttons[buttonnum] = button
				button:SetParent(treeframe)
				button:SetFrameLevel(treeframe:GetFrameLevel()+1)
				button:ClearAllPoints()
				if buttonnum == 1 then
					if self.showscroll then
						button:SetPoint("TOPRIGHT", -26, -10)
						button:SetPoint("TOPLEFT", 0, -10)
					else
						button:SetPoint("TOPRIGHT", 0, -10)
						button:SetPoint("TOPLEFT", 0, -10)
					end
				else
					button:SetPoint("TOPRIGHT", buttons[buttonnum-1], "BOTTOMRIGHT")
					button:SetPoint("TOPLEFT", buttons[buttonnum-1], "BOTTOMLEFT")
				end
			end

			UpdateButton(button, line, status.selected == line.uniquevalue, line.hasChildren, groupstatus[line.uniquevalue] )
			button:Show()
			buttonnum = buttonnum + 1
		end

	end,

	["SetSelected"] = function(self, value)
		local status = self.status or self.localstatus
		if status.selected ~= value then
			status.selected = value
			self:Fire("OnGroupSelected", value)
		end
	end,

	["Select"] = function(self, uniquevalue, ...)
		self.filter = false
		local status = self.status or self.localstatus
		local groups = status.groups
		local path = {...}
		for i = 1, #path do
			groups[tconcat(path, "\001", 1, i)] = true
		end
		status.selected = uniquevalue
		self:RefreshTree(true)
		self:Fire("OnGroupSelected", uniquevalue)
	end,

	["SelectByPath"] = function(self, ...)
		self:Select(BuildUniqueValue(...), ...)
	end,

	["SelectByValue"] = function(self, uniquevalue)
		self:Select(uniquevalue, ("\001"):split(uniquevalue))
	end,

	["ShowScroll"] = function(self, show)
		self.showscroll = show
		if show then
			self.scrollbar:Show()
			if self.buttons[1] then
				self.buttons[1]:SetPoint("TOPRIGHT", self.treeframe,"TOPRIGHT",-26,-10)
			end
		else
			self.scrollbar:Hide()
			if self.buttons[1] then
				self.buttons[1]:SetPoint("TOPRIGHT", self.treeframe,"TOPRIGHT",0,-10)
			end
		end
	end,

	["OnWidthSet"] = function(self, width)
		local content = self.content
		local treeframe = self.treeframe
		local status = self.status or self.localstatus
		status.fullwidth = width

		local contentwidth = width - status.treewidth - 20
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth

		local maxtreewidth = math_max( DEFAULT_TREE_WIDTH, math_min(400, width - 50))

		if maxtreewidth > 100 and status.treewidth > maxtreewidth then
			self:SetTreeWidth(maxtreewidth, status.treesizable)
		end
		treeframe:SetMaxResize(maxtreewidth, 1600)
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		local contentheight = height - 20
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end,

	["SetTreeWidth"] = function(self, treewidth, resizable)
		if not resizable then
			if type(treewidth) == 'number' then
				resizable = false
			elseif type(treewidth) == 'boolean' then
				resizable = treewidth
				treewidth = DEFAULT_TREE_WIDTH
			else
				resizable = false
				treewidth = DEFAULT_TREE_WIDTH
			end
		end
		self.treeframe:SetWidth(treewidth)
		self.dragger:EnableMouse(false)

		local status = self.status or self.localstatus
		status.treewidth = treewidth
		status.treesizable = resizable

		-- recalculate the content width
		if status.fullwidth then
			self:OnWidthSet(status.fullwidth)
		end
	end,

	["GetTreeWidth"] = function(self)
		local status = self.status or self.localstatus
		return status.treewidth or DEFAULT_TREE_WIDTH
	end,

	["LayoutFinished"] = function(self, width, height)
		if self.noAutoHeight then return end
		self:SetHeight((height or 0) + 20)
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]

local DraggerBackdrop  = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = nil,
	tile = true, tileSize = 16, edgeSize = 1,
	insets = { left = 4, right = 3, top = 7, bottom = 7 }
}

local function Constructor()
	local num = AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame", nil, UIParent)

	local treeframe = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	treeframe:SetPoint("TOPLEFT")
	treeframe:SetPoint("BOTTOMLEFT")
	treeframe:SetWidth(DEFAULT_TREE_WIDTH)
	treeframe:EnableMouseWheel(true)
	OmniCD[1].BackdropTemplate(treeframe)
	treeframe:SetBackdropColor(0.05, 0.05, 0.05, 0.75)
	treeframe:SetBackdropBorderColor(0, 0, 0)
	treeframe:SetResizable(false)
	treeframe:SetMinResize(100, 1)
	treeframe:SetMaxResize(400, 1600)
	treeframe:SetScript("OnUpdate", FirstFrameUpdate)
	treeframe:SetScript("OnSizeChanged", Tree_OnSizeChanged)
	treeframe:SetScript("OnMouseWheel", Tree_OnMouseWheel)

	local dragger = CreateFrame("Frame", nil, treeframe, BackdropTemplateMixin and "BackdropTemplate" or nil)
	dragger:SetWidth(8)
	dragger:SetPoint("TOP", treeframe, "TOPRIGHT")
	dragger:SetPoint("BOTTOM", treeframe, "BOTTOMRIGHT")
	dragger:SetBackdrop(DraggerBackdrop)
	dragger:SetBackdropColor(1, 1, 1, 0)
	dragger:SetScript("OnEnter", Dragger_OnEnter)
	dragger:SetScript("OnLeave", Dragger_OnLeave)
	dragger:SetScript("OnMouseDown", Dragger_OnMouseDown)
	dragger:SetScript("OnMouseUp", Dragger_OnMouseUp)

	local scrollbar = CreateFrame("Slider", ("AceConfigDialogTreeGroup%dScrollBar-OmniCD"):format(num), treeframe, "UIPanelScrollBarTemplate")
	scrollbar:SetScript("OnValueChanged", nil)
	scrollbar:SetPoint("TOPRIGHT", -10, -10)
	scrollbar:SetPoint("BOTTOMRIGHT", -10, 10)
	scrollbar:SetMinMaxValues(0,0)
	scrollbar:SetValueStep(1)
	scrollbar:SetValue(0)
	scrollbar:SetWidth(16)
	scrollbar:SetScript("OnValueChanged", OnScrollValueChanged)

	scrollbar.ScrollUpButton:Hide()
	scrollbar.ScrollDownButton:Hide()
	scrollbar.ThumbTexture:SetTexture([[Interface\BUTTONS\White8x8]])
	scrollbar.ThumbTexture:SetSize(16, 32)
	scrollbar.ThumbTexture:SetColorTexture(0.3, 0.3, 0.3)
	scrollbar:SetScript("OnEnter", Thumb_OnEnter)
	scrollbar:SetScript("OnLeave", Thumb_OnLeave)
	scrollbar:SetScript("OnMouseDown", Thumb_OnMouseDown)
	scrollbar:SetScript("OnMouseUp", Thumb_OnMouseUp)

	local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND")
	scrollbg:SetAllPoints(scrollbar)
	scrollbg:SetColorTexture(0,0,0,0.4)

	local border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	border:SetPoint("TOPLEFT", treeframe, "TOPRIGHT")
	border:SetPoint("BOTTOMRIGHT")
	OmniCD[1].BackdropTemplate(border)
	border:SetBackdropColor(0.05, 0.05, 0.05, 0.75)
	border:SetBackdropBorderColor(0, 0, 0)

	--Container Support
	local content = CreateFrame("Frame", nil, border)
	content:SetPoint("TOPLEFT", 10, -10)
	content:SetPoint("BOTTOMRIGHT", -10, 10)

	local widget = {
		frame        = frame,
		lines        = {},
		levels       = {},
		buttons      = {},
		hasChildren  = {},
		localstatus  = { groups = {}, scrollvalue = 0 },
		filter       = false,
		treeframe    = treeframe,
		dragger      = dragger,
		scrollbar    = scrollbar,
		border       = border,
		content      = content,
		type         = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	treeframe.obj, dragger.obj, scrollbar.obj = widget, widget, widget

	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
