local MAJOR = "LibDropdown-1.0"
local MINOR = 1

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local assert = assert
local ipairs = ipairs
local math = math
local max = max
local min = min
local next = next
local pairs = pairs
local select = select
local table = table
local setmetatable = setmetatable
local tinsert = tinsert
local tostring = tostring
local tremove = tremove
local type 	= type
local wipe = wipe

local CreateFrame = CreateFrame
local PlaySound = PlaySound
local ShowUIPanel = ShowUIPanel
local GetMouseFocus = GetMouseFocus
local UISpecialFrames = UISpecialFrames

local ChatFrame1 = ChatFrame1
local ColorPickerFrame = ColorPickerFrame
local GameTooltip = GameTooltip

local GameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor

local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR

local framePool = lib.framePool or {}
lib.framePool = framePool

local buttonPool = lib.buttonPool or {}
lib.buttonPool = buttonPool

local inputPool = lib.inputPool or {}
lib.inputPool = inputPool

local frameHideQueue = lib.frameHideQueue or {}
lib.frameHideQueue = frameHideQueue

local sliderPool = lib.sliderPool or {}
lib.sliderPool = sliderPool

local AddButton, Refresh, GetRoot, SetChecked, HideRecursive, ShowGroup, HideGroup, SetGroup, NewDropdownFrame, NewDropdownButton, ReleaseFrame, AcquireButton, ReleaseButton, AcquireFrame
local UIParent = _G.UIParent

local openMenu

local noop = lib.noop or function() end
lib.noop = noop

local new, newHash, newSet, del
if not lib.new then
	local list = setmetatable({}, {__mode='k'})
	function new(...)
		local t = next(list)
		if t then
			list[t] = nil
			for i = 1, select('#', ...) do
				t[i] = select(i, ...)
			end
			return t
		else
			return {...}
		end
	end
	function del(t)
		setmetatable(t, nil)
		for k in pairs(t) do
			t[k] = nil
		end
		t[''] = true
		t[''] = nil
		list[t] = true
		return nil
	end
	lib.new, lib.del = new, del
end

-- Make the frame match the tooltip
local function InitializeFrame(frame)
	local backdrop = GameTooltip:GetBackdrop()
	
	frame:SetBackdrop(backdrop)
	
	if backdrop then
		frame:SetBackdropColor(GameTooltip:GetBackdropColor())
		frame:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
	end
	frame:SetScale(GameTooltip:GetScale())
end

local editBoxCount = 1
local function AcquireInput()
	local frame = tremove(inputPool)

	if frame then
		frame.released = false
		return frame
	end
	
	frame = CreateFrame("EditBox", "LibDropDownEditBox"..editBoxCount, UIParent, "InputBoxTemplate")
	frame:SetAutoFocus(false)
	editBoxCount = editBoxCount + 1
	frame:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		self:GetParent():GetRoot():Refresh()
	end)
	
	frame:SetScript("OnEnterPressed", function(self)
		if self.ValueChanged then
			self:ValueChanged(self:GetText())
		end
	end)
	frame.refresh = noop
	return frame
end

local function AcquireSlider()
	local frame = tremove(sliderPool)
	if frame then
		frame.released = false
		return frame
	end
	
	local frame = CreateFrame("Slider", nil, UIParent)
	frame:SetWidth(10)
	frame:SetHeight(150)
	frame:SetOrientation("VERTICAL")
	frame:SetBackdrop({
		bgFile = [[Interface\Buttons\UI-SliderBar-Background]],
		edgeFile = [[Interface\Buttons\UI-SliderBar-Border]],
		tile = true,
		tileSize = 8,
		edgeSize = 8,
		insets = {left = 3, right = 3, top = 6, bottom = 6}
	})
	frame:SetThumbTexture([[Interface\Buttons\UI-SliderBar-Button-Vertical]])
	frame:EnableMouseWheel()
	frame:Show()
	
	local text = frame:CreateFontString(nil, nil, "GameFontNormalSmall")
	text:SetPoint("TOP", frame, "BOTTOM")
	text:SetTextColor(1, 1, 1, 1)
	frame.text = text
	
	frame:SetScript("OnMouseWheel", function(self, direction, ...)
		if not direction then return end -- huh?
		local mn, mx = self:GetMinMaxValues()
		local nv = min(mx, max(mn, self:GetValue() + ((self.step or 1) * direction * -1)))
		self:SetValue(nv)
	end)

	frame:SetScript("OnValueChanged", function(self)
		local mn, mx = self:GetMinMaxValues()
		local nv = min(mx, max(mn, self:GetValue()))
		if nv ~= self:GetValue() then
			self:SetValue(nv)
			return
		end
		local n, x = self:GetMinMaxValues()
		local ev = x - nv
		frame.text:SetText(ev)

		if self.ValueChanged then
			self:ValueChanged(self:GetValue())
		end
	end)
	frame.refresh = noop
	return frame
end

local function ReleaseSlider(slider)
	if slider.released then return end
	slider.released = true
	slider:Hide()
	slider:SetParent(UIParent)
	tinsert(sliderPool, slider)
	return nil
end

local function ReleaseInput(input)
	if input.released then return end
	input.released = true
	input:Hide()
	input:SetParent(UIParent)
	tinsert(inputPool, input)
	return nil
end

local function MouseOver(frame)
	local f = GetMouseFocus()
	while f and f ~= UIParent do
		if f == frame then return true end
		f = f:GetParent()
	end
	return false
end

-- Frame methods
function AddButton(self, b)
	b:ClearAllPoints()
	b:SetParent(self)
	b:Show()
	if #self.buttons == 0 then
		b:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -4)
		b:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -4)
	else
		b:SetPoint("TOPLEFT", self.buttons[#self.buttons], "BOTTOMLEFT")
		b:SetPoint("TOPRIGHT", self.buttons[#self.buttons], "BOTTOMRIGHT")
	end
	tinsert(self.buttons, b)
	self:SetHeight(#self.buttons * b:GetHeight() + 8)
end

function Refresh(self)
	if not self:IsVisible() then return end
	local maxWidth = 1
	for i = 1, #self.buttons do
		self.buttons[i]:refresh()
		maxWidth = math.max(maxWidth, self.buttons[i].text:GetStringWidth() + 60)
	end
	self:SetWidth(maxWidth)
end

function GetRoot(self)
	local parent = self:GetParent()
	if parent and parent.GetRoot then
		return parent:GetRoot()
	else
		return self
	end
end

-- Button methods
function ShowGroup(self)
	if not self.enabled then return end
	if not self.groupFrame then
		self.groupFrame = self:AcquireFrame()
	end
	if not self.handled then
		self.handler(lib, self.group, self.groupFrame)
		self.handled = true
	end
	self.groupFrame:SetPoint("TOPLEFT", self, "TOPRIGHT", 0, 4)
	self.groupFrame:Show()
	self.groupFrame:Refresh()
	self:LockHighlight()
	self:enter()
	if self.groupFrame.Showing then
		self.groupFrame:Showing()
	end
end

function HideGroup(self)
	if not self then return end
	if MouseOver(self) then return end
	if self.groupFrame then
		self.groupFrame:Hide()
	end
	self:UnlockHighlight()
	self:leave()
	if self.groupFrame.Hiding then
		self.groupFrame:Hiding()
	end
end

function SetChecked(self, val)
	self.checked = val
	if val then
		self.check:Show()
		self.check:SetDesaturated(false)
	elseif val == false or not self.tristate then
		self.check:Hide()
	elseif val == nil then
		self.check:Show()
		self.check:SetDesaturated(true)
	end
end

function HideRecursive(self)
	HideGroup(self:GetParent())
end

function SetGroup(self, t, handler)
	if t then
		self.expand:Show()
		self:SetScript("OnEnter", ShowGroup)
		self:SetScript("OnLeave", HideGroup)
		self.group = t
		self.handler = handler
	else
		self.expand:Hide()
		self:SetScript("OnEnter", nil)
		self:SetScript("OnLeave", nil)
		self.group = nil
		self.handler = nil
	end
	self.clickable = t == nil
end

-- Pool methods
local frameCount = 0
function NewDropdownFrame()
	local frame = CreateFrame("Frame", "LibDropdownFrame" .. frameCount, UIParent)
	frameCount = frameCount + 1
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetWidth(10)
	frame:SetHeight(24)
	frame:EnableMouse(true)
	frame.AddButton = AddButton
	frame.Refresh = Refresh
	frame.GetRoot = GetRoot
	frame.isDropdownFrame = true
	frame.Release = ReleaseFrame
	frame.AcquireButton = AcquireButton
	-- make it close on escape
	tinsert(UISpecialFrames, frame:GetName())
	return frame
end

do
	local function enterButton(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.text:GetText())
		if self.desc then
			GameTooltip:AddLine("|cffffffff" .. self.desc .. "|r")
		end
		GameTooltip:Show()
	end
	
	local function leaveButton(self)
		GameTooltip:Hide()
		local p = self:GetParent()
		if p then
			local f = p:GetScript("OnLeave")
			if f then
				f(p)
			end
		end
	end

	local function pushText(self)
		if not self.clickable then return end
		self.text:SetPoint("TOP", self, "TOP", 0, -2)
		self.text:SetPoint("LEFT", self.check, "RIGHT", 6, 0)
	end

	local function unpushText(self)
		if not self.clickable then return end
		self.text:SetPoint("TOP", self, "TOP", 0, 0)
		self.text:SetPoint("LEFT", self.check, "RIGHT", 4, 0)
	end

	local function click(self)
		if self.OnClick and self.clickable then
			self.OnClick(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			self:GetParent():GetRoot():Refresh()
		end
	end
	
	local function settext(self, t)
		self.text:SetText(t)
	end
	
	local function disable(self)
		self.enabled = false
		self:SetScript("OnMouseDown", nil)
		self:SetScript("OnMouseUp", nil)
		self.text:SetTextColor(0.5, 0.5, 0.5, 1)
		self.check:SetDesaturated(true)
		self.expand:SetDesaturated(true)
		self:oldDisable()
	end
	
	local function enable(self)
		self.enabled = true
		self:SetScript("OnMouseDown", pushText)
		self:SetScript("OnMouseUp", unpushText)
		self.text:SetTextColor(1, 1, 1, 1)
		-- self.text:SetTextColor(self:GetTextColor()) -- Removed in 3.0
		self.check:SetDesaturated(false)
		self.expand:SetDesaturated(false)
		self:oldEnable()
	end
	
	local function revert()
		--ColorPickerFrame.previousValues.frame
	end
	
	local function setColor()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = ColorPickerFrame.opacity or 1
		local f = ColorPickerFrame.previousValues.frame
		f:GetNormalTexture():SetVertexColor(r, g, b, a)
		if f:GetParent().OnClick then
			f:GetParent():OnClick(r, g, b, a)
		end
	end
	
	local function revert()
		local p = ColorPickerFrame.previousValues
		ColorPickerFrame:SetColorRGB(p.r, p.g, p.b)
		ColorPickerFrame.opacity = p.opacity
		setColor()
	end
	
	local function openColorPicker(self)
		local p = self:GetParent()
		p.r, p.g, p.b, p.a = self:GetNormalTexture():GetVertexColor()

		ColorPickerFrame.hasOpacity = p.hasOpacity
		ColorPickerFrame.opacityFunc = p.opacityFunc
		ColorPickerFrame.opacity = p.a
		ColorPickerFrame:SetColorRGB(p.r, p.g, p.b)
		ColorPickerFrame.previousValues = ColorPickerFrame.previousValues or {}
		ColorPickerFrame.previousValues.r = p.r
		ColorPickerFrame.previousValues.g = p.g
		ColorPickerFrame.previousValues.b = p.b
		ColorPickerFrame.previousValues.opacity = p.a
		ColorPickerFrame.previousValues.frame = self
		ColorPickerFrame.cancelFunc = revert
		ColorPickerFrame.func = setColor

		ShowUIPanel(ColorPickerFrame)
	end

	local function highlightSwatch(self)
		self.tex:SetTexture(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

	local function unhighlightSwatch(self)
		self.tex:SetTexture(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end

	local function makeTitle(self, t)
		-- self.text:SetJustifyH("CENTER")
		self.text:ClearAllPoints()
		self.text:SetPoint("LEFT", self, "LEFT", 16, 0)
		self.text:SetPoint("RIGHT", self, "RIGHT", -16, 0)
		self.text:SetTextColor(1, 0.8, 0, 1)
		self.clickable = false
		if t then self.text:SetText(t) end
	end
	
	local function makeButton(self, t)
		local text, frame, check, expand = self.text, self, self.check, self.expand
		text:ClearAllPoints()
		text:SetPoint("TOP", frame, "TOP")
		text:SetPoint("LEFT", check, "RIGHT", 4, 0)
		text:SetPoint("BOTTOM", frame, "BOTTOM")
		text:SetPoint("RIGHT", expand, "LEFT", -4, 0)
		text:SetJustifyH("LEFT")
		self.text:SetTextColor(1, 1, 1, 1)
		self.clickable = true
		if t then text:SetText(t) end
	end

	function NewDropdownButton(f)
		local frame = f or CreateFrame("Button", nil, UIParent)
		frame:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
		frame:GetHighlightTexture():SetBlendMode("ADD")
		-- frame:SetDisabledTextColor(0.5, 0.5, 0.5, 1) -- Removed in 3.0
		frame:SetPushedTextOffset(3,-3)
		frame:SetHeight(18)
		
		local check = frame.check or frame:CreateTexture()
		check:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
		check:SetWidth(18)
		check:SetHeight(18)
		check:SetPoint("LEFT", frame, "LEFT", 4, 0)
		check:Hide()
		frame.check = check

		local expand = frame.expand or frame:CreateTexture()
		expand:SetTexture([[Interface\ChatFrame\ChatFrameExpandArrow]])
		expand:SetWidth(16)
		expand:SetHeight(16)
		expand:SetPoint("RIGHT", frame, "RIGHT", -4, 0)
		expand:Hide()
		frame.expand = expand

		local text = frame.text or frame:CreateFontString(nil, nil, "GameFontHighlightSmall")
		frame.text = text
		frame.SetText = settext
		frame.MakeButton = makeButton
		frame.MakeTitle = makeTitle
		frame:MakeButton("<not set>")

		local swatch = frame.swatch or CreateFrame("Button", nil, frame)
		swatch:SetWidth(18)
		swatch:SetHeight(18)
		swatch.tex = swatch.text or swatch:CreateTexture(nil, "BACKGROUND")
		swatch.tex:SetPoint("CENTER", swatch, "CENTER")
		swatch.tex:SetWidth(swatch:GetWidth()-2)
		swatch.tex:SetHeight(swatch:GetHeight()-2)
		-- swatch.tex:SetTexture([[Interface\ChatFrame\ChatFrameColorSwatch]])
		swatch:SetNormalTexture([[Interface\ChatFrame\ChatFrameColorSwatch]])
		swatch:SetPoint("RIGHT", frame, "RIGHT", -4, 0)
		swatch:SetScript("OnClick", openColorPicker)
		swatch:SetFrameLevel(frame:GetFrameLevel() + 100)
		swatch:SetScript("OnEnter", highlightSwatch)
		swatch:SetScript("OnLeave", unhighlightSwatch)
		swatch:Hide()
		frame.swatch = swatch
		unhighlightSwatch(swatch)

		frame:SetScript("OnEnter", enterButton)
		frame:SetScript("OnLeave", leaveButton)
		frame.enter, frame.leave = enterButton, leaveButton

		frame:SetScript("OnMouseDown", pushText)
		frame:SetScript("OnMouseUp", unpushText)
		frame:SetScript("OnClick", click)
		frame.SetGroup = SetGroup
		frame.SetChecked = SetChecked
		frame.AcquireFrame = AcquireFrame
		frame.GetRoot = GetRoot
		frame.oldDisable, frame.Disable = frame.Disable, disable
		frame.oldEnable, frame.Enable = frame.Enable, enable
		frame.Release = ReleaseButton

		frame.clickable = true
		frame.enabled = true
		frame:Enable()

		return frame
	end
end

function ReleaseFrame(f)
	if f.rootMenu then
		openMenu = nil
	end
	if f.released then return end
	f.released = true
	f.data = nil
	f.dataname = nil
	f.rootMenu = nil
	
	f:Hide()
	f:SetParent(UIParent)
	f:ClearAllPoints()
	
	tinsert(framePool, f)
	for i = 1, #f.buttons do
		local button = tremove(f.buttons)
		button:Release()
	end
	return nil
end

function AcquireButton(p)
	local b = NewDropdownButton(tremove(buttonPool))
	b.released = false
	b:EnableMouse(true)
	b:Show()
	p:AddButton(b)
	return b
end

function ReleaseButton(b)
	if b.released then return end
	tinsert(buttonPool, b)
	b.desc = nil
	b.released = true
	b.Enable = b.oldEnable
	b.Disable = b.oldDisable
	b.handled = false
	b:SetParent(UIParent)
	b:Hide()
	if b.slider then
		b.slider = ReleaseSlider(b.slider)
	end
	if b.input then
		b.input = ReleaseInput(b.input)
	end
	b:ClearAllPoints()
	b:MakeButton("(released)")
	if b.groupFrame then
		b.groupFrame.Showing = nil
		b.groupFrame = b.groupFrame:Release()
	end
	
end

local function frameReleaseOnHide(self)
	self:SetScript("OnHide", nil)
	self:Release()
end

function AcquireFrame(parent, toplevel)
	local f = tremove(framePool) or NewDropdownFrame()
	InitializeFrame(f) -- set the look of the frame
	f.released = false
	f.buttons = f.buttons or {}
	f:SetParent(parent or UIParent)
	if parent then
		f:SetScript("OnLeave", HideRecursive)
	else
		f:SetScript("OnLeave", nil)
	end
	if toplevel then
		f:SetScript("OnHide", frameReleaseOnHide)
	else
		f:SetScript("OnHide", nil)
	end
	f:ClearAllPoints()
	f:Show()
	return f
end

----------------------------------------------------------------------
----------------------------------------------------------------------
do
	local Ace3 = {}
	local grefresh
	local info = {}
	local options
	local currentOptionData
	local function setup(k, v, parent)
		local b = parent:AcquireButton()
		b.data = v
		b.option = v
		b.dataname = k
		b.refresh = grefresh
		return b
	end

	local function setInfoOptions()
		local option = options
		for _, key in ipairs(info) do
			if option.args and option.args[key] then
				option = option.args[key]
			else
				return
			end
		end
		info.option = option
		info.type = option.type
	end

	local function initInfo(type)
		info.options = options
		info.appName = options.name
		info.type = type
		info.uiType = "dropdown"
		info.uiName = "LibDropdown-1.0"
	end

	local function wipeInfo()
		local type = info.type
		wipe(info)
		initInfo(type)
	end

	local function runHandler(button, handler, ...)
		info.handler = handler
		info.option = button.data
		if not button.rootMenu then
			tinsert(info, 1, button.dataname)
		end
		local v = button.data
		if v and v[handler] then
			local ht = type(v[handler])
			if ht == "function" then
				setInfoOptions()
				local ret, r1, r2, r3 = v[handler](info, ...)
				wipeInfo()
				return ret, r1, r2, r3
			elseif ht == "table" then
				return v[handler]
			elseif ht == "string" then
				local t = runHandler(button, "handler", ...)
				if type(t) == "table" then
					setInfoOptions()
					local ret, r1, r2, r3 = t[v[handler]](t, info, ...)
					wipeInfo()
					return ret, r1, r2, r3
				end
			end
		elseif v and v[handler] == false then
			return nil -- Is this right?
		else
			if button.GetParent then
				local pp = button:GetParent() and button:GetParent():GetParent()
				if not pp or not pp.data then
					pp = button:GetParent()
				end
				if pp and pp.data then
					return runHandler(pp, handler, ...)
				end
			end
		end
		wipeInfo()
		return nil
	end

	function grefresh(self)
		local isDisabled = false
		self:SetText(self.data.name)
		self.desc = self.data.desc
		if type(self.data.disabled) == "function" then
			if self.data.disabled() then
				self:Disable()
				isDisabled = true
			else
				self:Enable()
			end
		elseif type(self.data.disabled) == "boolean" then
			if self.data.disabled then
				self:Disable()
				isDisabled = true
			else
				self:Enable()
			end
		end
		return isDisabled
	end

	-- group
	do
		local function refresh(self)
			grefresh(self)
			if not self.groupFrame or self.groupFrame == self:GetParent() then return end
			self.groupFrame:Refresh()
		end
		function Ace3.group(k, v, parent)
			local b = setup(k, v, parent)
			if v.inline then
				-- TODO: Add heading 
				local b2 = parent:AcquireButton()
				b:MakeTitle(k)
				b2.refresh = noop
				lib:OpenAce3Menu(v.args, parent)
			else
				b:SetGroup(v.args, lib.OpenAce3Menu)
			end
			b.refresh = refresh
		end
	end
	
	-- execute
	function Ace3.execute(k, v, parent)
		local b = setup(k, v, parent)
		b:SetText(v.name)
		b.desc = v.desc
		b.OnClick = function(self)
			initInfo('execute')
			runHandler(self, "func")
			self:GetRoot():Refresh()
		end
	end
	
	-- input
	do
		local function refresh(self)
			grefresh(self)
			self.input:SetText(runHandler(self, "get") or "")
		end
		
		local function inputValueChanged(self, val)
			initInfo('input')
			runHandler(self:GetParent():GetParent(), "set", val)
			self:GetParent():GetRoot():Refresh()
		end
		
		function Ace3.input(k, v, parent)
			local b = setup(k, v, parent)
			b:SetGroup(v, lib.Ace3InputShow)
			b.input = AcquireInput()
			b.refresh = refresh
		end
		
		local function showInput(frame)
			local data = frame.data
			local input = frame:GetParent().input
			input:SetParent(frame)
			input:ClearAllPoints()
			input:SetPoint("LEFT", frame, "LEFT", 10, 0)
			frame:SetWidth(185)
			input:SetWidth(170)
			input:SetHeight(34)
			frame:SetHeight(34)
			input.ValueChanged = inputValueChanged
			input:Show()
			refresh(frame:GetParent())
		end

		function lib:Ace3InputShow(t, parent)
			parent.data = t
			parent.Showing = showInput
		end
	end
	
	-- toggle
	do
		local function refresh(self)
			local disabled = grefresh(self)
			initInfo('toggle')
			local actual = runHandler(self, "get")
			if disabled then
				self:SetChecked(false)
			else
				self:SetChecked(actual)
			end
		end
		local function onClick(self)
			initInfo('toggle')
			if self.data.tristate then
				local val = runHandler(self, "get")
				local sv 
				if val == nil then sv = true
				elseif val == true then sv = false
				else sv = nil end
				runHandler(self, "set", sv)
			else
				local val = not runHandler(self, "get")
				runHandler(self, "set", val)
			end
			self:GetRoot():Refresh()
		end

		function Ace3.toggle(k, v, parent)
			local b = setup(k, v, parent)
			b.OnClick = onClick
			b.tristate = v.tristate
			b.refresh = refresh
		end
	end

	-- header
	do
		local function refresh(self)
			grefresh(self)
		end

		function Ace3.header(k, v, parent)
			local b = setup(k, v, parent)
			b:MakeTitle(k)
			b:EnableMouse(false)
			b.tristate = nil
			b.refresh = refresh
		end
	end

	-- color
	do
		local function refresh(self)
			grefresh(self)
			initInfo('color')
			self.swatch:GetNormalTexture():SetVertexColor(runHandler(self, "get"))
		end
		function Ace3.color(k, v, parent)
			local b = setup(k, v, parent)
			b.swatch:Show()
			b.clickable = false
			 b.refresh = refresh
			b.OnClick = function(self, r, g, b, a)
				runHandler(self, "set", r, g, b, a)
				self:GetRoot():Refresh()
			end
		end
	end

	-- select
	do
		local function refresh(self)
			grefresh(self)
			if self.groupFrame then
				self.groupFrame:Refresh()
			end
		end
		function Ace3.select(k, v, parent)
			local b = setup(k, v, parent)
			b.parentTree = v
			b:SetGroup(v.values, lib.Ace3MenuSelect)
			b.refresh = refresh
		end
		
		local function buttonRefresh(self)
			initInfo('select')
			self:SetChecked( runHandler(self:GetParent():GetParent(), "get") == self.value )
		end
		function lib:Ace3MenuSelect(t, parent)
			initInfo('select')
			if type(t) == "string" or type(t) == "function" then
				t = runHandler(parent, "values")
			end
			if type(t) == "table" then
				for k, v in pairs(t) do
					local b = parent:AcquireButton()
					b:SetText(v)
					b.value = k
					b.OnClick = function(self)
						initInfo('select')
						runHandler(self:GetParent():GetParent(), "set", self.value)
						self:GetParent():GetRoot():Refresh()
					end
					b.refresh = buttonRefresh
				end
			end
		end
	end

	-- range
	-- Some extra tricksery for mousewheel on the containing frame. A bit more user friendly.
	do
		local function refresh(self)
			grefresh(self)
			initInfo('range')
			self.slider:SetValue(runHandler(self, "get") or self.slider:GetMinMaxValues())
			initInfo('range')
			self.slider.text:SetText(runHandler(self, "get"))
		end

		function Ace3.range(k, v, parent)
			local b = setup(k, v, parent)
			b:SetGroup(v, lib.Ace3SliderShow)
			b.slider = AcquireSlider()
			b.refresh = refresh
		end

		local function onWheel(f)
			f:GetParent().slider:GetScript("OnMouseWheel")(f:GetParent().slider)
		end

		local function removeMousewheelFuncs(f)
			tremove(f.buttons)
			f:EnableMouseWheel(false)
			f:SetScript("OnMouseWheel", nil)
			f.Hiding = nil
		end

		local function sliderValueChanged(self, val)
			initInfo('range')
			runHandler(self:GetParent():GetParent(), "set", val)
			self:GetParent():GetRoot():Refresh()
		end
		
		local function showSlider(frame)
			local data = frame.data
			local slider = frame:GetParent().slider

			slider:SetParent(frame)
			slider:ClearAllPoints()
			slider:SetPoint("CENTER", frame, "CENTER")
			slider:SetPoint("TOP", frame, "TOP", 0, -8)
			slider:SetHeight(150)
			slider.text:ClearAllPoints()
			slider.text:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 8)
			slider.text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 8)

			slider.text:SetText(data.max)
			frame:SetWidth(max(60, slider.text:GetStringWidth() + 10))

			slider.step = data.bigStep
			slider:SetMinMaxValues(data.min or 0, data.max or 100)
			slider:SetValueStep(data.bigStep or data.step or 1)
			slider.ValueChanged = sliderValueChanged
			
			frame:EnableMouseWheel(true)
			frame:SetScript("OnMouseWheel", onWheel)
			frame.Hiding = removeMousewheelFuncs
			frame:SetHeight(180)
			
			slider:Show()
			refresh(frame:GetParent())
		end

		function lib:Ace3SliderShow(t, parent)
			parent.data = t
			parent.Showing = showSlider
		end
	end

	do
		local sortOptions = function(a, b)
		if (b.order or 100) > (a.order or 100) then return true
		elseif (b.order or 100) < (a.order or 100) then return false
		elseif b.name:lower() > a.name:lower() then return true
		else return false
		end
	end

		function lib:OpenAce3Menu(t, parent)
			assert(t and type(t) == "table", "Expected table, got "..type(t))
			if parent == nil and t.args then
				if openMenu then
					openMenu:Release()
				end
				options = t
				openMenu = AcquireFrame(nil, true)
				openMenu:Show()
				openMenu.data = t
				openMenu.dataname = "Root menu"
				openMenu.rootMenu = true
				openMenu:SetPoint("CENTER", UIParent, "CENTER")
				self:OpenAce3Menu(t.args, openMenu)
				openMenu:Refresh()
				openMenu:SetFrameStrata("TOOLTIP")
				return openMenu
			else
				local sortedOpts = new()
				local lookup = new()
				for i = 1, #sortedOpts do
					tremove(sortedOpts)
				end
				for k, v in pairs(t) do
					lookup[v] = k
					tinsert(sortedOpts, v)
				end
				table.sort(sortedOpts, sortOptions)
				for _, v in ipairs(sortedOpts) do
					if Ace3[v.type] and not v.dropdownHidden and not v.hidden then
						Ace3[v.type](lookup[v], v, parent)
					end
				end
				sortedOpts = del(sortedOpts)
				lookup = del(lookup)
			end
		end
	end
end

------------------------------------------------------
------------------------------------------------------

local toggled = true
local r, g, b, a = 1, 0, 1, 1
local options = {"foo", "bar", "foobar"}
local optIndex = 1
local rangeVal, rangeVal2 = 100, 10
local inherits = {["inherittoggle"] = true}

local t = {
	type = "group",
	name = "group",
	desc = "group",
	args = {
		foo = {
			type = "input",
			name = "text",
			desc = "text desc",
			get = function(info) return "texting!" end,
			set = function(info, v) end
		},
		inherit = {
			type = "group",
			name = "inheritance test",
			desc = "inheritance test",
			get = function(info) ChatFrame1:AddMessage(("Got getter, getting %s (%s)"):format(tostring(info[#info]), tostring(inherits[info[#info]]))) return inherits[info[#info]] end,
			set = function(info, v) ChatFrame1:AddMessage("Got setter:" .. tostring(v)) inherits[info[#info]] = v end,
			args = {
				inherittoggle = {
					type = "toggle",
					name = "inherit toggle",
					desc = "inherit toggle"
				},
			}
		},
		exec = {
			type = "execute",
			name = "Say hi",
			desc = "Execute, says hi",
			func = function() ChatFrame1:AddMessage("Hi!") end
		},
		range = {
			type = "range",
			name = "Range slider",
			desc = "Range slider",
			min = 0,
			max = 800,
			bigStep = 50,
			get = function(info) return rangeVal end,
			set = function(info, v) rangeVal = v end,
		},
		range2 = {
			type = "range",
			name = "Range slider 2",
			desc = "Range slider 2",
			min = 0,
			max = 80,
			bigStep = 5,
			get = function(info) return rangeVal2 end,
			set = function(info, v) rangeVal2 = v end,
		},
		toggle = {
			type = "toggle",
			name = "Toggle",
			desc = "Toggle",
			get = function() return toggled end,
			set = function(info, v) toggled = v end,
			disabled = function(info) return not toggled end
		},
		toggle3 = {
			type = "toggle",
			name = "Tristate Toggle Tristate Toggle Tristate Toggle",
			desc = "Tristate Toggle",
			tristate = true,
			get = function() return toggled end,
			set = function(info, v) toggled = v end
		},
		select = {
			type = "select",
			name = "select",
			desc = "select desc",
			values = options,
			get = function(info) return optIndex end,
			set = function(info, v) optIndex = v end
		},
		color = {
			type = "color",
			name = "color swatch",
			desc = "color swatch desc",
			get = function(info) return r, g, b, a end,
			set = function(info, _r, _g, _b, _a) r, g, b, a = _r, _g, _b, _a end
		},
		foo3 = {
			type = "group",
			name = "group!",
			desc = "group desc",
			args = {
				toggle3 = {
					type = "toggle",
					name = "Tristate Toggle Tristate Toggle Tristate Toggle",
					desc = "Tristate Toggle",
					tristate = true,
					get = function() return toggled end,
					set = function(info, v) toggled = v end
				},
			}
		},
		foo4 = {
			type = "group",
			name = "inline group!",
			desc = "inline group desc",
			inline = "true",
			args = {
				foo2 = {
					type = "input",
					name = "text3",
					desc = "text3 desc",
					get = function(info) return "texting!" end,
					set = function(info, v) end
				}
			},
			order = 500
		},
		close = {
			type = "execute",
			name = "Close",
			desc = "Close this menu",
			func = function(self) end,
			order = 1000
		}
	}
}

--[[function testlibdropdown()
	LibStub("LibDropdown-1.0"):OpenAce3Menu(t)
end]]

WorldFrame:HookScript("OnMouseDown", function()
	if openMenu then
		openMenu = openMenu:Release()
	end
end)
