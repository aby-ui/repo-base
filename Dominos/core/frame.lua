--[[
	frame.lua
		A dominos frame, a generic container object
--]]

local AddonName, Addon = ...
local Frame = Addon:CreateClass('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)
local FlyPaper = LibStub("LibFlyPaper-1.0")

local active = {}
local unused = {}

--constructor
function Frame:New(id, tooltipText)
	id = tonumber(id) or id

	local frame = self:Restore(id) or self:Create(id)
	frame:LoadSettings()
	frame:SetTooltipText(tooltipText)

	Addon.OverrideController:Add(frame.header)

	active[id] = frame

	frame:OnEnable()

	return frame
end

function Frame:OnEnable() end

function Frame:Create(id)
	local frameName = ('%sFrame%s'):format(AddonName, id)

	local frame = self:Bind(CreateFrame('Frame', frameName, _G['UIParent']))
	frame:SetClampedToScreen(true)
	frame:SetMovable(true)

	frame.id = id

	frame.header = CreateFrame('Frame', nil, frame, 'SecureHandlerStateTemplate')

	frame.header:SetAttribute('id', id)

	frame.header:SetAttribute('_onstate-overrideui', [[
		self:RunAttribute('updateShown')
	]])

	frame.header:SetAttribute('_onstate-showinoverrideui', [[
		self:RunAttribute('updateShown')
	]])

	frame.header:SetAttribute('_onstate-petbattleui', [[
		self:RunAttribute('updateShown')
	]])

	frame.header:SetAttribute('_onstate-showinpetbattleui', [[
		self:RunAttribute('updateShown')
	]])

	frame.header:SetAttribute('_onstate-display', [[
		self:RunAttribute('updateShown')
	]])

	frame.header:SetAttribute('updateShown', [[
		local isOverrideUIShown = self:GetAttribute('state-overrideui') and true or false
		local isPetBattleUIShown = self:GetAttribute('state-petbattleui') and true or false

		if isPetBattleUIShown and not self:GetAttribute('state-showinpetbattleui') then
			self:Hide()
			return
		end

		if isOverrideUIShown and not self:GetAttribute('state-showinoverrideui') then
			self:Hide()
			return
		end

		local displayState = self:GetAttribute('state-display')
		if displayState == 'hide' then
			if self:GetAttribute('state-alpha') then
				self:SetAttribute('state-alpha', nil)
			end
			self:Hide()
			return
		end

		local stateAlpha = tonumber(displayState)
		if self:GetAttribute('state-alpha') ~= stateAlpha then
			self:SetAttribute('state-alpha', stateAlpha)
		end
		self:Show()
	]])

	frame.header:SetAttribute('_onstate-alpha', [[
		self:CallMethod('Fade')
	]])

	frame.header.Fade = function() frame:Fade() end

	frame.header:SetAllPoints(frame)

	frame:OnCreate()

	return frame
end

function Frame:OnCreate() end

function Frame:Restore(id)
	local frame = unused[id]

	if frame then
		unused[id] = nil

		frame:OnRestore()

		return frame
	end
end

function Frame:OnRestore() end

--destructor
function Frame:Free(deleteSettings)
	active[self.id] = nil

	UnregisterStateDriver(self.header, 'display', 'show')
	Addon.MouseOverWatcher:Remove(self)
	Addon.OverrideController:Remove(self.header)

	self.docked = nil

	self:ClearAllPoints()
	self:SetUserPlaced(nil)
	self:Hide()

	self:OnFree(deleteSettings)

	unused[self.id] = self
end

function Frame:OnFree() end

function Frame:LoadSettings()
	--get defaults must be provided by anything implementing the Frame type
	self.sets = Addon:GetFrameSets(self.id) or Addon:SetFrameSets(self.id, self:GetDefaults())
	self:Reposition()

	if self.sets.hidden then
		self:HideFrame()
	else
		self:ShowFrame()
	end

	self:UpdateShowStates()

	self:ShowInOverrideUI(self:ShowingInOverrideUI())
	self:ShowInPetBattleUI(self:ShowingInPetBattleUI())

	self:OnLoadSettings()
end

function Frame:OnLoadSettings() end

function Frame:GetDisplayName()
	return L.BarDisplayName:format(tostring(self.id):gsub('^%l', string.upper))
end

--[[ Layout ]]--

function Frame:SetPadding(width, height)
	width = tonumber(width) or 0
	height = tonumber(height) or width

	self.sets.padW = width ~= 0 and width or nil
	self.sets.padH = height ~= 0 and height or nil

	self:Layout()
end

function Frame:GetPadding()
	local width = self.sets.padW or 0
	local height = self.sets.padH or width

	return width, height
end

function Frame:Layout()
	local width, height = 32, 32
	local paddingW, paddingH = self:GetPadding()

	self:TrySetSize(width + paddingW*2, height + paddingH*2)
end

function Frame:TrySetSize(width, height)
	if InCombatLockdown() then return end

	self:SetSize(width, height)
end


--[[ Scaling ]]--

hooksecurefunc(Frame, 'SetScale', function(self, scale)
	self:OnSetScale(scale)
end)

function Frame:OnSetScale(scale) end

function Frame:SetFrameScale(newScale, scaleAnchored)
	newScale = tonumber(newScale) or 1

	local oldScale = self:GetFrameScale()
	local ratio = oldScale / newScale

	self.sets.scale = newScale
	self:Rescale()

	if not self:GetAnchor() then
		local point, x, y = self:GetSavedFramePosition()

		self:SetAndSaveFramePosition(point, x * ratio, y * ratio)
	end

	if scaleAnchored then
		for _, f in self:GetAll() do
			if f:GetAnchor() == self then
				f:SetFrameScale(newScale, true)
			end
		end
	end
end

function Frame:Rescale()
	self:SetScale(self:GetFrameScale())
end

function Frame:GetFrameScale()
	return self.sets.scale or 1
end


--[[ Opacity ]]--

hooksecurefunc(Frame, 'SetAlpha', function(self, alpha)
	self:OnSetAlpha(alpha)
end)

-- empty hook
function Frame:OnSetAlpha(alpha) end

function Frame:SetFrameAlpha(alpha)
	if alpha == 1 then
		self.sets.alpha = nil
	else
		self.sets.alpha = alpha
	end

	self:UpdateAlpha()
end

function Frame:GetFrameAlpha()
	return self.sets.alpha or 1
end

--faded opacity (mouse not over the frame)
function Frame:SetFadeMultiplier(alpha)
	alpha = tonumber(alpha) or 1

	if alpha == 1 then
		self.sets.fadeAlpha = nil
	else
		self.sets.fadeAlpha = alpha
	end

	self:UpdateWatched()
	self:UpdateAlpha()
end

function Frame:GetFadeMultiplier()
	return self.sets.fadeAlpha or 1
end

function Frame:UpdateAlpha()
	self:SetAlpha(self:GetExpectedAlpha())

	if Addon:IsLinkedOpacityEnabled() then
		self:ForDocked('UpdateAlpha')
	end
end

--returns the opacity value we expect the frame to be at in its current state
function Frame:GetExpectedAlpha()
	--if this is a docked frame and linked opacity is enabled
	--then return the expected opacity of the parent frame
	if Addon:IsLinkedOpacityEnabled() then
		local anchor = (self:GetAnchor())
		if anchor and anchor:FrameIsShown() then
			return anchor:GetExpectedAlpha()
		end
	end

	--if there's a statealpha value for the frame, then use it
	local stateAlpha = self.header:GetAttribute('state-alpha')
	if stateAlpha then
		return stateAlpha / 100
	end

	--if the frame is moused over, then return the frame's normal opacity
	if self.focused then
		return self:GetFrameAlpha()
	end

	return self:GetFrameAlpha() * self:GetFadeMultiplier()
end


--[[ Mouseover Checking ]]--

local function isChildFocus(...)
	local focus = GetMouseFocus()
	for i = 1, select('#', ...) do
		if focus == select(i, ...) then
			return true
		end
	end

	for i = 1, select('#', ...) do
		local f = select(i, ...)
		if f:IsShown() and isChildFocus(f:GetChildren()) then
			return true
		end
	end

	return false
end

local function isDescendant(frame, ...)
	for i = 1, select('#', ...) do
		local f = select(i, ...)
		if frame == f then
			return true
		end
	end

	for i = 1, select('#', ...) do
		local f = select(i, ...)
		if isDescendant(frame, f:GetChildren()) then
			return true
		end
	end

	return false
end

--returns all frames docked to the given frame
function Frame:IsFocus()
	if self:IsMouseOver(1, -1, -1, 1) then
		return (GetMouseFocus() == WorldFrame) or isChildFocus(self:GetChildren())
	end

	if SpellFlyout and SpellFlyout:IsMouseOver(1, -1, -1, 1) and isDescendant(SpellFlyout:GetParent(), self) then
		return true
	end

	return Addon:IsLinkedOpacityEnabled() and self:IsDockedFocus()
end

function Frame:IsDockedFocus()
	local docked = self.docked
	if docked then
		for _,f in pairs(docked) do
			if f:IsFocus()  then
				return true
			end
		end
	end
	return false
end

--[[ Fading ]]--

--fades the frame from the current opacity setting
--to the expected setting
function Frame:Fade()
	if floor(abs(self:GetExpectedAlpha()*100 - self:GetAlpha()*100)) == 0 then
		return
	end

	if not self:FrameIsShown() then
		return
	end

	Addon:Fade(self, self:GetExpectedAlpha(), 0.1)

	if Addon:IsLinkedOpacityEnabled() then
		self:ForDocked('Fade')
	end
end

--[[ Visibility ]]--

function Frame:ShowFrame()
	self.sets.hidden = nil

	self:Show()
	self:UpdateWatched()
	self:UpdateAlpha()

	if Addon:IsLinkedOpacityEnabled() then
		self:ForDocked('ShowFrame')
	end
end

function Frame:HideFrame()
	self.sets.hidden = true

	self:Hide()
	self:UpdateWatched()
	self:UpdateAlpha()

	if Addon:IsLinkedOpacityEnabled() then
		self:ForDocked('HideFrame')
	end
end

function Frame:ToggleFrame()
	if self:FrameIsShown() then
		self:HideFrame()
	else
		self:ShowFrame()
	end
end

function Frame:FrameIsShown()
	return not self.sets.hidden
end


--[[ Perspectives Visibility ]] --

function Frame:ShowInOverrideUI(enable)
	self.sets.showInOverrideUI = enable and true or false

	self.header:SetAttribute('state-showinoverrideui', enable)
end

function Frame:ShowingInOverrideUI()
	return self.sets.showInOverrideUI
end

function Frame:ShowInPetBattleUI(enable)
	self.sets.showInPetBattleUI = enable and true or false
	self.header:SetAttribute('state-showinpetbattleui', enable)
end

function Frame:ShowingInPetBattleUI()
	return self.sets.showInPetBattleUI
end


--[[ Clickthrough ]]--

function Frame:SetClickThrough(enable)
	self.sets.clickThrough = enable and true or false
	self:UpdateClickThrough()
end

function Frame:GetClickThrough()
	return self.sets.clickThrough
end

function Frame:UpdateClickThrough() end


--[[ Show states ]]--

function Frame:SetShowStates(states)
	self.sets.showstates = states
	self:UpdateShowStates()
end

function Frame:GetShowStates()
	local states = self.sets.showstates

	--hack to convert [combat] into [combat]show;hide in case a user is using the old style of showstates
	if states then
		if states:sub(#states) == ']' then
			states = states .. 'show;hide'
			self.sets.showstates = states
		end
	end

	return states
end

function Frame:UpdateShowStates()
	local showstates = self:GetShowStates()

	if showstates and showstates ~= '' then
		RegisterStateDriver(self.header, 'display', showstates)
	else
		UnregisterStateDriver(self.header, 'display')

		if self.header:GetAttribute('state-display') then
			self.header:SetAttribute('state-display', nil)
		end
	end
end


--[[ Sticky Bars ]]--

Frame.stickyTolerance = 16

function Frame:StickToEdge()
	local point, x, y = self:GetRelativeFramePosition()
	local rTolerance = self.stickyTolerance / self:GetFrameScale()
	local changed = false

	if abs(x) <= rTolerance then
		x = 0
		changed = true
	end

	if abs(y) <= rTolerance then
		y = 0
		changed = true
	end

	--save this junk if we've done something
	if changed then
		self:SetAndSaveFramePosition(point, x, y)
	end
end

function Frame:Stick()
	local rTolerance = self.stickyTolerance / self:GetFrameScale()

	self:ClearAnchor()

	--only do sticky code if the alt key is not currently down
	if Addon:Sticky() and not IsAltKeyDown() then
		--try to stick to a bar, then try to stick to a screen edge
		for _, f in self:GetAll() do
			if f ~= self then
				local point = FlyPaper.Stick(self, f, rTolerance)
				if point then
					self:SetAnchor(f, point)
					break
				end
			end
		end

		if not self:GetAnchor() then
			self:StickToEdge()
		end
	end

	self:SaveRelativeFramePosition()
end

function Frame:Reanchor()
	local f, point = self:GetAnchor()

	if not(f and FlyPaper.StickToPoint(self, f, point)) then
		self:ClearAnchor()
		self:Reposition()
	else
		self:SetAnchor(f, point)
	end
end

function Frame:SetAnchor(anchor, point)
	self:ClearAnchor()

	if anchor.docked then
		local found = false
		for i,f in pairs(anchor.docked) do
			if f == self then
				found = i
				break
			end
		end
		if not found then
			tinsert(anchor.docked, self)
		end
	else
		anchor.docked = {self}
	end

	self.sets.anchor = anchor.id .. point
	self:UpdateWatched()
	self:UpdateAlpha()
end

function Frame:ClearAnchor()
	local anchor = self:GetAnchor()

	if anchor and anchor.docked then
		for i,f in pairs(anchor.docked) do
			if f == self then
				tremove(anchor.docked, i)
				break
			end
		end

		if not next(anchor.docked) then
			anchor.docked = nil
		end
	end

	self.sets.anchor = nil
	self:UpdateWatched()
	self:UpdateAlpha()
end

function Frame:GetAnchor()
	local anchorString = self.sets.anchor

	if anchorString then
		local pointStart = #anchorString - 1
		return self:Get(anchorString:sub(1, pointStart - 1)), anchorString:sub(pointStart)
	end
end


--[[ Positioning ]]--

function Frame:SetFramePosition(...)
	self:ClearAllPoints()
	self:SetPoint(...)
end

function Frame:SetAndSaveFramePosition(point, x, y)
	self:SetFramePosition(point, x, y)
	self:SaveFramePosition(point, x, y)
end



--[[ Relative Positioning ]]--

function Frame:SaveRelativeFramePosition()
	self:SaveFramePosition(self:GetRelativeFramePosition())
end

function Frame:GetRelativeFramePosition()
	local scale = self:GetScale() or 1
	local left = self:GetLeft() or 0
	local top = self:GetTop() or 0
	local right = self:GetRight() or 0
	local bottom = self:GetBottom() or 0

	local parent = self:GetParent() or _G['UIParent']
	local pwidth = parent:GetWidth() / scale
	local pheight = parent:GetHeight() / scale

	local x , y, point
	if left < (pwidth - right) and left < abs((left+right)/2 - pwidth/2) then
		x = left
		point = 'LEFT'
	elseif (pwidth - right) < abs((left + right)/2 - pwidth/2) then
		x = right - pwidth
		point = 'RIGHT'
	else
		x = (left+right)/2 - pwidth/2
		point = '';
	end

	if bottom < (pheight - top) and bottom < abs((bottom + top)/2 - pheight/2) then
		y = bottom
		point = 'BOTTOM' .. point
	elseif (pheight - top) < abs((bottom + top)/2 - pheight/2) then
		y = top - pheight
		point = 'TOP' .. point
	else
		y = (bottom + top)/2 - pheight/2
	end

	if point == '' then
		point = 'CENTER'
	end

	return point, x, y
end


--[[ Position Saving ]]--

local roundPoint = function(point)
	point = point or 0

	if point > 0 then
		point = floor(point + 0.5)
	else
		point = ceil(point - 0.5)
	end

	return point
end

function Frame:Reposition()
	self:Rescale()
	self:SetFramePosition(self:GetSavedFramePosition())
end

function Frame:SaveFramePosition(point, x, y)
	point = point or 'CENTER'
	x = roundPoint(x)
	y = roundPoint(y)

	local sets = self.sets
	sets.point = point ~= 'CENTER' and point or nil
	sets.x = x ~= 0 and x or nil
	sets.y = y ~= 0 and y or nil

	self:SetUserPlaced(true)
end

function Frame:GetSavedFramePosition()
	local sets = self.sets
	local point = sets.point or 'CENTER'
	local x = sets.x or 0
	local y = sets.y or 0

	return point, x, y
end


--[[ Menus ]]--

function Frame:CreateMenu()
	self.menu = Addon:NewMenu(self.id)
	self.menu:AddLayoutPanel()
	self.menu:AddAdvancedPanel()
end

function Frame:ShowMenu()
	if not Addon:IsConfigAddonEnabled() then return end

	if not self.menu then
		self:CreateMenu()
	end

	local menu = self.menu
	if menu then
		menu:Hide()
		menu:SetOwner(self)
		menu:ShowPanel(LibStub('AceLocale-3.0'):GetLocale('Dominos-Config').Layout)
		menu:Show()
	end
end


--[[ Tooltip Text ]]--

function Frame:SetTooltipText(text)
	self.tooltipText = text
end

function Frame:GetTooltipText()
	return self.tooltipText
end


--[[ Mouseover Watching ]]--

function Frame:UpdateWatched()
	if self:FrameIsShown() and self:GetFadeMultiplier() < 1 and not(Addon:IsLinkedOpacityEnabled() and self:GetAnchor()) then
		Addon.MouseOverWatcher:Add(self)
	else
		Addon.MouseOverWatcher:Remove(self)
	end
end


--[[ Metafunctions ]]--

function Frame:Get(id)
	return active[tonumber(id) or id]
end

function Frame:GetAll()
	return pairs(active)
end

function Frame:ForAll(method, ...)
	for _,f in self:GetAll() do
		local action = f[method]
		if action then
			action(f, ...)
		end
	end
end

function Frame:ForDocked(method, ...)
	if self.docked then
		for _, f in pairs(self.docked) do
			local action = f[method]
			if action then
				action(f, ...)
			end
		end
	end
end

--takes a frameId, and performs the specified action on that frame
--this adds two special IDs, 'all' for all frames and '<number>-<number>' for a range of IDs
function Frame:ForFrame(id, method, ...)
	if id == 'all' then
		self:ForAll(method, ...)
	else
		local startID, endID = tostring(id):match('(%d+)-(%d+)')
		startID = tonumber(startID)
		endID = tonumber(endID)

		if startID and endID then
			if startID > endID then
				local t = startID
				startID = endID
				endID = t
			end

			for i = startID, endID do
				local f = self:Get(i)
				if f then
					local action = f[method]
					if action then
						action(f, ...)
					end
				end
			end
		else
			local f = self:Get(id)
			if f then
				local action = f[method]
				if action then
					action(f, ...)
				end
			end
		end
	end
end

--[[ exports ]]--

Addon.Frame = Frame
