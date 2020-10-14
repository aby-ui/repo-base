--- **LibCandyBar-3.0** provides elegant timerbars with icons for use in addons.
-- It is based of the original ideas of the CandyBar and CandyBar-2.0 library.
-- In contrary to the earlier libraries LibCandyBar-3.0 provides you with a timerbar object with a simple API.
--
-- Creating a new timerbar using the ':New' function will return a new timerbar object. This timerbar object inherits all of the barPrototype functions listed here. \\
--
-- @usage
-- local candy = LibStub("LibCandyBar-3.0")
-- local texture = "Interface\\AddOns\\MyAddOn\\statusbar"
-- local mybar = candy:New(texture, 100, 16)
-- mybar:SetLabel("Yay!")
-- mybar:SetDuration(60)
-- mybar:Start()
-- @class file
-- @name LibCandyBar-3.0

local GetTime, floor, next, wipe = GetTime, floor, next, wipe
local CreateFrame, error, setmetatable, UIParent = CreateFrame, error, setmetatable, UIParent

if not LibStub then error("LibCandyBar-3.0 requires LibStub.") end
local cbh = LibStub:GetLibrary("CallbackHandler-1.0")
if not cbh then error("LibCandyBar-3.0 requires CallbackHandler-1.0") end
local lib = LibStub:NewLibrary("LibCandyBar-3.0", 97) -- Bump minor on changes
if not lib then return end
lib.callbacks = lib.callbacks or cbh:New(lib)
local cb = lib.callbacks
lib.dummyFrame = lib.dummyFrame or CreateFrame("Frame")
lib.barFrameMT = lib.barFrameMT or {__index = lib.dummyFrame}
lib.barPrototype = lib.barPrototype or setmetatable({}, lib.barFrameMT)
lib.barPrototype_mt = lib.barPrototype_mt or {__index = lib.barPrototype}
lib.barCache = lib.barCache or {}

local barPrototype = lib.barPrototype
local barPrototype_meta = lib.barPrototype_mt
local barCache = lib.barCache

local scripts = {
	"OnUpdate", "OnDragStart", "OnDragStop",
	"OnEnter", "OnLeave", "OnHide",
	"OnShow", "OnMouseDown", "OnMouseUp",
	"OnMouseWheel", "OnSizeChanged", "OnEvent"
}
local numScripts = #scripts
local GameFontHighlightSmallOutline = GameFontHighlightSmallOutline
local _fontName, _fontSize = GameFontHighlightSmallOutline:GetFont()
local _fontShadowX, _fontShadowY = GameFontHighlightSmallOutline:GetShadowOffset()
local _fontShadowR, _fontShadowG, _fontShadowB, _fontShadowA = GameFontHighlightSmallOutline:GetShadowColor()
local SetWidth, SetHeight, SetSize = lib.dummyFrame.SetWidth, lib.dummyFrame.SetHeight, lib.dummyFrame.SetSize

local function stopBar(bar)
	bar.updater:Stop()
	if bar.data then wipe(bar.data) end
	if bar.funcs then wipe(bar.funcs) end
	bar.running = nil
	bar.paused = nil
	bar:Hide()
	bar:SetParent(UIParent)
end

local tformat1 = "%d:%02d:%02d"
local tformat2 = "%d:%02d"
local tformat3 = "%.1f"
local tformat4 = "%.0f"
local function barUpdate(updater)
	local bar = updater.parent
	local t = GetTime()
	if t >= bar.exp then
		bar:Stop()
	else
		local time = bar.exp - t
		bar.remaining = time

		bar.candyBarBar:SetValue(bar.fill and (t-bar.start)+bar.gap or time)

		if time > 3599.9 then -- > 1 hour
			local h = floor(time/3600)
			local m = floor((time - (h*3600))/60)
			local s = (time - (m*60)) - (h*3600)
			bar.candyBarDuration:SetFormattedText(tformat1, h, m, s)
		elseif time > 59.9 then -- 1 minute to 1 hour
			local m = floor(time/60)
			local s = time - (m*60)
			bar.candyBarDuration:SetFormattedText(tformat2, m, s)
		elseif time < 10 then -- 0 to 10 seconds
			bar.candyBarDuration:SetFormattedText(tformat3, time)
		else -- 10 seconds to one minute
			bar.candyBarDuration:SetFormattedText(tformat4, time)
		end

		if bar.funcs then
			for i = 1, #bar.funcs do
				bar.funcs[i](bar)
			end
		end
	end
end

local atformat1 = "~%d:%02d:%02d"
local atformat2 = "~%d:%02d"
local atformat3 = "~%.1f"
local atformat4 = "~%.0f"
local function barUpdateApprox(updater)
	local bar = updater.parent
	local t = GetTime()
	if t >= bar.exp then
		bar:Stop()
	else
		local time = bar.exp - t
		bar.remaining = time

		bar.candyBarBar:SetValue(bar.fill and (t-bar.start)+bar.gap or time)

		if time > 3599.9 then -- > 1 hour
			local h = floor(time/3600)
			local m = floor((time - (h*3600))/60)
			local s = (time - (m*60)) - (h*3600)
			bar.candyBarDuration:SetFormattedText(atformat1, h, m, s)
		elseif time > 59.9 then -- 1 minute to 1 hour
			local m = floor(time/60)
			local s = time - (m*60)
			bar.candyBarDuration:SetFormattedText(atformat2, m, s)
		elseif time < 10 then -- 0 to 10 seconds
			bar.candyBarDuration:SetFormattedText(atformat3, time)
		else -- 10 seconds to one minute
			bar.candyBarDuration:SetFormattedText(atformat4, time)
		end

		if bar.funcs then
			for i = 1, #bar.funcs do
				bar.funcs[i](bar)
			end
		end
	end
end

-- ------------------------------------------------------------------------------
-- Bar functions
--

local function restyleBar(self)
	if not self.running then return end
	self.candyBarIconFrame:ClearAllPoints()
	self.candyBarBar:ClearAllPoints()
	-- In the past we used a :GetTexture check here, but as of WoW v5 it randomly returns nil, so use our own trustworthy variable.
	if self.candyBarIconFrame.icon then
		self.candyBarIconFrame:SetWidth(self.height)
		if self.iconPosition == "RIGHT" then
			self.candyBarIconFrame:SetPoint("TOPRIGHT", self)
			self.candyBarIconFrame:SetPoint("BOTTOMRIGHT", self)
			self.candyBarBar:SetPoint("TOPRIGHT", self.candyBarIconFrame, "TOPLEFT")
			self.candyBarBar:SetPoint("BOTTOMRIGHT", self.candyBarIconFrame, "BOTTOMLEFT")
			self.candyBarBar:SetPoint("TOPLEFT", self)
			self.candyBarBar:SetPoint("BOTTOMLEFT", self)
		else
			self.candyBarIconFrame:SetPoint("TOPLEFT")
			self.candyBarIconFrame:SetPoint("BOTTOMLEFT")
			self.candyBarBar:SetPoint("TOPLEFT", self.candyBarIconFrame, "TOPRIGHT")
			self.candyBarBar:SetPoint("BOTTOMLEFT", self.candyBarIconFrame, "BOTTOMRIGHT")
			self.candyBarBar:SetPoint("TOPRIGHT", self)
			self.candyBarBar:SetPoint("BOTTOMRIGHT", self)
		end
		self.candyBarIconFrame:Show()
	else
		self.candyBarBar:SetPoint("TOPLEFT", self)
		self.candyBarBar:SetPoint("BOTTOMRIGHT", self)
		self.candyBarIconFrame:Hide()
	end
	if self.showLabel and self.candyBarLabel.text then
		self.candyBarLabel:Show()
	else
		self.candyBarLabel:Hide()
	end
	if self.showTime then
		self.candyBarDuration:Show()
	else
		self.candyBarDuration:Hide()
	end
end

--- Set whether the bar should drain (default) or fill up.
-- @param fill Boolean true/false
function barPrototype:SetFill(fill)
	self.fill = fill
end
--- Adds a function to the timerbar. The function will run every update and will receive the bar as a parameter.
-- @param func Function to run every update.
-- @usage
-- -- The example below will print the time remaining to the chatframe every update. Yes, that's a whole lot of spam
-- mybar:AddUpdateFunction( function(bar) print(bar.remaining) end )
function barPrototype:AddUpdateFunction(func) if not self.funcs then self.funcs = {} end; self.funcs[#self.funcs+1] = func end
--- Sets user data in the timerbar object.
-- @param key Key to use for the data storage.
-- @param data Data to store.
function barPrototype:Set(key, data) if not self.data then self.data = {} end; self.data[key] = data end
--- Retrieves user data from the timerbar object.
-- @param key Key to retrieve
function barPrototype:Get(key) return self.data and self.data[key] end
--- Sets the color of the bar.
-- This is basically a wrapper to SetStatusBarColor.
-- @paramsig r, g, b, a
-- @param r Red component (0-1)
-- @param g Green component (0-1)
-- @param b Blue component (0-1)
-- @param a Alpha (0-1)
function barPrototype:SetColor(...) self.candyBarBar:SetStatusBarColor(...) end
--- Sets the color of the bar label and bar duration text.
-- @paramsig r, g, b, a
-- @param r Red component (0-1)
-- @param g Green component (0-1)
-- @param b Blue component (0-1)
-- @param a Alpha (0-1)
function barPrototype:SetTextColor(...)
	self.candyBarLabel:SetTextColor(...)
	self.candyBarDuration:SetTextColor(...)
end
--- Sets the shadow color of the bar label and bar duration text.
-- @paramsig r, g, b, a
-- @param r Red component (0-1)
-- @param g Green component (0-1)
-- @param b Blue component (0-1)
-- @param a Alpha (0-1)
function barPrototype:SetShadowColor(...)
	self.candyBarLabel:SetShadowColor(...)
	self.candyBarDuration:SetShadowColor(...)
end
--- Sets the texture of the bar.
-- This should only be needed on running bars that get changed on the fly.
-- @param texture Path to the bar texture.
function barPrototype:SetTexture(texture)
	self.candyBarBar:SetStatusBarTexture(texture)
	self.candyBarBackground:SetTexture(texture)
end
--- Sets the width of the bar.
-- This should only be needed on running bars that get changed on the fly.
-- @param width Width of the bar.
function barPrototype:SetWidth(width)
	self.width = width
	SetWidth(self, width)
end
--- Sets the height of the bar.
-- This should only be needed on running bars that get changed on the fly.
-- @param height Height of the bar.
function barPrototype:SetHeight(height)
	self.height = height
	SetHeight(self, height)
	restyleBar(self)
end
--- Sets the size of the bar.
-- This should only be needed on running bars that get changed on the fly.
-- @param width Width of the bar.
-- @param height Height of the bar.
function barPrototype:SetSize(width, height)
	self.width = width
	self.height = height
	SetSize(self, width, height)
	restyleBar(self)
end
--- Returns the label (text) currently set on the bar.
function barPrototype:GetLabel()
	return self.candyBarLabel.text
end
--- Sets the label on the bar.
-- @param text Label text.
function barPrototype:SetLabel(text)
	self.candyBarLabel.text = text
	self.candyBarLabel:SetText(text)
	if text then
		self.candyBarLabel:Show()
	else
		self.candyBarLabel:Hide()
	end
end
--- Returns the icon texture path currently set on the bar, if it has an icon set.
function barPrototype:GetIcon()
	return self.candyBarIconFrame.icon
end
--- Sets the icon next to the bar.
-- @param icon Path to the icon texture or nil to not display an icon.
-- @param ... Optional icon coordinates for texture trimming.
function barPrototype:SetIcon(icon, ...)
	self.candyBarIconFrame.icon = icon
	self.candyBarIconFrame:SetTexture(icon)
	if ... then
		self.candyBarIconFrame:SetTexCoord(...)
	else
		self.candyBarIconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	restyleBar(self)
end
--- Sets which side of the bar the icon should appear.
-- @param position Position of the icon according to the bar, either "LEFT" or "RIGHT" as a string. Set to "LEFT" by default.
function barPrototype:SetIconPosition(position)
	self.iconPosition = position
	restyleBar(self)
end
--- Sets wether or not the time indicator on the right of the bar should be shown.
-- Time is shown by default.
-- @param bool true to show the time, false/nil to hide the time.
function barPrototype:SetTimeVisibility(bool)
	self.showTime = bool
	if bool then
		self.candyBarDuration:Show()
	else
		self.candyBarDuration:Hide()
	end
end
--- Sets wether or not the label on the left of the bar should be shown.
-- label is shown by default.
-- @param bool true to show the label, false/nil to hide the label.
function barPrototype:SetLabelVisibility(bool)
	self.showLabel = bool
	if bool then
		self.candyBarLabel:Show()
	else
		self.candyBarLabel:Hide()
	end
end
--- Sets the duration of the bar.
-- This can also be used while the bar is running to adjust the time remaining, within the bounds of the original duration.
-- @param duration Duration of the bar in seconds.
-- @param isApprox Boolean. True if you wish the time display to be an approximate "~5" instead of "5"
function barPrototype:SetDuration(duration, isApprox) self.remaining = duration; self.isApproximate = isApprox end
--- Shows the bar and starts it.
-- @param maxValue Number. If you don't wish your bar to start full, you can set a max value. A maxValue of 10 on a bar with a duration of 5 would start it at 50%.
function barPrototype:Start(maxValue)
	self.running = true
	local time = self.remaining
	self.gap = maxValue and maxValue-time or 0
	restyleBar(self)
	self.start = GetTime()
	self.exp = self.start + time

	self.candyBarBar:SetMinMaxValues(0, maxValue or time)
	self.candyBarBar:SetValue(self.fill and 0 or time)

	if self.isApproximate then
		if time > 3599.9 then -- > 1 hour
			local h = floor(time/3600)
			local m = floor((time - (h*3600))/60)
			local s = (time - (m*60)) - (h*3600)
			self.candyBarDuration:SetFormattedText(atformat1, h, m, s)
		elseif time > 59.9 then -- 1 minute to 1 hour
			local m = floor(time/60)
			local s = time - (m*60)
			self.candyBarDuration:SetFormattedText(atformat2, m, s)
		elseif time < 10 then -- 0 to 10 seconds
			self.candyBarDuration:SetFormattedText(atformat3, time)
		else -- 10 seconds to one minute
			self.candyBarDuration:SetFormattedText(atformat4, time)
		end
		self.updater:SetScript("OnLoop", barUpdateApprox)
	else
		if time > 3599.9 then -- > 1 hour
			local h = floor(time/3600)
			local m = floor((time - (h*3600))/60)
			local s = (time - (m*60)) - (h*3600)
			self.candyBarDuration:SetFormattedText(tformat1, h, m, s)
		elseif time > 59.9 then -- 1 minute to 1 hour
			local m = floor(time/60)
			local s = time - (m*60)
			self.candyBarDuration:SetFormattedText(tformat2, m, s)
		elseif time < 10 then -- 0 to 10 seconds
			self.candyBarDuration:SetFormattedText(tformat3, time)
		else -- 10 seconds to one minute
			self.candyBarDuration:SetFormattedText(tformat4, time)
		end
		self.updater:SetScript("OnLoop", barUpdate)
	end
	self.updater:Play()
	self:Show()
end
--- Pauses a running bar
function barPrototype:Pause()
	if not self.paused then
		self.updater:Pause()
		self.paused = true
	end
end
--- Resumes a paused bar
function barPrototype:Resume()
	if self.paused then
		self.exp = GetTime() + self.remaining
		self.updater:Play()
		self.paused = nil
	end
end
--- Stops the bar.
-- This will stop the bar, fire the LibCandyBar_Stop callback, and recycle the bar into the candybar pool.
-- Note: make sure you remove all references to the bar in your addon upon receiving the LibCandyBar_Stop callback.
-- @usage
-- -- The example below shows the use of the LibCandyBar_Stop callback by printing the contents of the label in the chatframe
-- local function barstopped( callback, bar )
--   print( bar:GetLabel(), "stopped")
-- end
-- LibStub("LibCandyBar-3.0"):RegisterCallback(myaddonobject, "LibCandyBar_Stop", barstopped)
-- @param ... Optional args to pass across in the LibCandyBar_Stop callback.
function barPrototype:Stop(...)
	cb:Fire("LibCandyBar_Stop", self, ...)
	stopBar(self)
	barCache[self] = true
end

-- ------------------------------------------------------------------------------
-- Library functions
--

--- Creates a new timerbar object and returns it. Don't forget to set the duration, label and :Start the timer bar after you get a hold of it!
-- @paramsig texture, width, height
-- @param texture Path to the texture used for the bar.
-- @param width Width of the bar.
-- @param height Height of the bar.
-- @usage
-- mybar = LibStub("LibCandyBar-3.0"):New("Interface\\AddOns\\MyAddOn\\media\\statusbar", 100, 16)
function lib:New(texture, width, height)
	local bar = next(barCache)
	if not bar then
		local frame = CreateFrame("Frame", nil, UIParent)
		bar = setmetatable(frame, barPrototype_meta)

		local icon = bar:CreateTexture()
		icon:SetPoint("TOPLEFT")
		icon:SetPoint("BOTTOMLEFT")
		icon:Show()
		bar.candyBarIconFrame = icon

		local statusbar = CreateFrame("StatusBar", nil, bar)
		statusbar:SetPoint("TOPRIGHT")
		statusbar:SetPoint("BOTTOMRIGHT")
		bar.candyBarBar = statusbar

		local bg = statusbar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		bar.candyBarBackground = bg

		local backdrop = CreateFrame("Frame", nil, bar, BackdropTemplateMixin and "BackdropTemplate") -- Used by bar stylers for backdrops
		backdrop:SetFrameLevel(0)
		bar.candyBarBackdrop = backdrop

		local iconBackdrop = CreateFrame("Frame", nil, bar, BackdropTemplateMixin and "BackdropTemplate") -- Used by bar stylers for backdrops
		iconBackdrop:SetFrameLevel(0)
		bar.candyBarIconFrameBackdrop = iconBackdrop

		local duration = statusbar:CreateFontString(nil, "OVERLAY", GameFontHighlightSmallOutline)
		duration:SetPoint("TOPLEFT", statusbar, "TOPLEFT", 2, 0)
		duration:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", -2, 0)
		bar.candyBarDuration = duration

		local label = statusbar:CreateFontString(nil, "OVERLAY", GameFontHighlightSmallOutline)
		label:SetPoint("TOPLEFT", statusbar, "TOPLEFT", 2, 0)
		label:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", -2, 0)
		bar.candyBarLabel = label

		local updater = bar:CreateAnimationGroup()
		updater:SetLooping("REPEAT")
		updater.parent = bar
		local anim = updater:CreateAnimation()
		anim:SetDuration(0.04)
		bar.updater = updater
		bar.repeater = anim
	else
		barCache[bar] = nil
	end

	bar.candyBarBar:SetStatusBarTexture(texture)
	bar.candyBarBackground:SetTexture(texture)
	bar.width = width
	bar.height = height

	-- RESET ALL THE THINGS!
	bar.fill = nil
	bar.showTime = true
	bar.showLabel = true
	bar.iconPosition = nil
	for i = 1, numScripts do -- Update if scripts table is changed, faster than doing #scripts
		bar:SetScript(scripts[i], nil)
	end

	bar.candyBarBackground:SetVertexColor(0.5, 0.5, 0.5, 0.3)
	bar.candyBarBar:SetStatusBarColor(0.5, 0.5, 0.5, 1)
	bar:ClearAllPoints()
	SetWidth(bar, width)
	SetHeight(bar, height)
	bar:SetMovable(1)
	bar:SetScale(1)
	bar:SetAlpha(1)
	bar:SetClampedToScreen(false)
	bar:EnableMouse(false)

	bar.candyBarLabel:SetTextColor(1,1,1,1)
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar.candyBarLabel:SetJustifyV("MIDDLE")
	bar.candyBarLabel:SetFont(_fontName, _fontSize)
	bar.candyBarLabel:SetShadowOffset(_fontShadowX, _fontShadowY)
	bar.candyBarLabel:SetShadowColor(_fontShadowR, _fontShadowG, _fontShadowB, _fontShadowA)

	bar.candyBarDuration:SetTextColor(1,1,1,1)
	bar.candyBarDuration:SetJustifyH("RIGHT")
	bar.candyBarDuration:SetJustifyV("MIDDLE")
	bar.candyBarDuration:SetFont(_fontName, _fontSize)
	bar.candyBarDuration:SetShadowOffset(_fontShadowX, _fontShadowY)
	bar.candyBarDuration:SetShadowColor(_fontShadowR, _fontShadowG, _fontShadowB, _fontShadowA)


	bar:SetLabel()
	bar:SetIcon()
	bar:SetDuration()

	return bar
end

