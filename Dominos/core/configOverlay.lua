--[[
	configOverlay.lua
		The configuration overlay interface for dominos
--]]
local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)
local KEYBOARD_MOVEMENT_INCREMENT = 1


local round = function(x)
	if x > 0 then
		return math.floor(x + 0.5)
	end

	return math.ceil(x - 0.5)
end

local function rgbToHSL(r, g, b)
	local h, s, l

	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local c = max - min

	local hPrime
	if c == 0 then
		hPrime = 0
	elseif max == r then
		hPrime = ((g - b) / c) % 6
	elseif max == g then
		hPrime = ((b - r) / c) + 2
	elseif max == b then
		hPrime = ((r - g) / c) + 4
	end

	h = hPrime * 60
	l = (r + g + b) / 3

	if l == 1 or l == 0 then
		s = 0
	else
		s = c / (1 - math.abs(2 * l - 1))
	end

	return h, s, l
end

local function hslToRGB(h, s, l)
	local c =  (1 - math.abs(2*l - 1)) * s
	local hPrime = h / 60
	local x = c * (1 - math.abs(hPrime % 2 - 1))
	local r, g, b

	if hPrime <= 0 then
		return 0, 0, 0
	elseif hPrime <= 1 then
		r, g, b = c, x, 0
	elseif hPrime <= 2 then
		r, g, b = x, c, 0
	elseif hPrime <= 3 then
		r, g, b = 0, c, x
	elseif hPrime <= 4 then
		r, g, b = 0, x, c
	elseif hPrime <= 5 then
		r, g, b = x, 0, c
	elseif hPrime <= 6 then
		r, g, b = c, 0, x
	end

	local m = l - c/2
	return r + m, g + m, b + m
end

--[[
	Helper object for transitioning from one color to another
--]]

local function colorFader_OnUpdate(self)
	local p = self.animator:GetSmoothProgress()
	local r = self.sR + (self.dR * p)
	local g = self.sG + (self.dG * p)
	local b = self.sB + (self.dB * p)
	local a = self.sA + (self.dA * p)

	self:saveColor(r, g, b, a)
end

local function colorFader_SetColor(self, fR, fG, fB, fA)
	if self:IsPlaying() then self:Stop() end

	local animator = self.animator
	local r, g, b, a = self:loadColor()

	self.sR = r
	self.sG = g
	self.sB = b
	self.sA = a

	self.dR = (fR - r)
	self.dG = (fG - g)
	self.dB = (fB - b)
	self.dA = (fA - a)

	self.fR = fR
	self.fG = fG
	self.fB = fB
	self.fA = fA

	self:Play()
	return self
end

local function colorFader_Create(parent, saveColor, loadColor)
	local fader = parent:CreateAnimationGroup()
	fader:SetLooping('NONE')
	fader.saveColor = saveColor
	fader.loadColor = loadColor

	--start the animation as completely transparent
	local animator = fader:CreateAnimation('Animation')
	animator:SetDuration(0.2)
	fader.animator = animator

	fader.SetColor = colorFader_SetColor
	fader:SetScript('OnUpdate', colorFader_OnUpdate)
	fader:SetScript('OnStop', colorFader_OnStop)

	return fader
end


-- [[ overlay that goes on each bar for configuration ]]--

local FrameOverlay = Addon:CreateClass('Button')
do
	local FRAME_COLOR = { h = 213, s = 0.76, l = 0.27 }

	local OverlayBackdrop = {
		bgFile   = 	[[Interface\ChatFrame\ChatFrameBackground]],
		edgeFile = 	[[Interface\ChatFrame\ChatFrameBackground]],
		edgeSize = 	2,
		insets   = 	{ left = 2, right = 2, top = 2, bottom = 2 },
	}

	local nextName = Addon:CreateNameGenerator('Overlay')
	local active = {}
	local unused = {}

	--[[ constructor ]]--

	local function createOverlay(parent)
		local overlay = CreateFrame('Button', nextName(), parent)

		overlay:EnableMouseWheel(true)
		overlay:SetClampedToScreen(true)
		overlay:SetBackdrop(OverlayBackdrop)

		overlay:SetNormalFontObject('GameFontNormalLarge')
		overlay:RegisterForClicks('AnyUp')
		overlay:RegisterForDrag('LeftButton')
		overlay:EnableKeyboard(true)

		return overlay
	end

	function FrameOverlay:New(parent, owner)
		local overlay = table.remove(unused)

		if overlay then
			overlay:SetParent(parent)
		else
			overlay = self:Bind(createOverlay(parent))
			overlay:SetScript('OnMouseDown', self.StartMoving)
			overlay:SetScript('OnMouseUp', self.StopMoving)
			overlay:SetScript('OnMouseWheel', self.OnMouseWheel)
			overlay:SetScript('OnClick', self.OnClick)
			overlay:SetScript('OnEnter', self.OnEnter)
			overlay:SetScript('OnLeave', self.OnLeave)
			overlay:SetScript('OnKeyUp', self.OnKeyUp)
			overlay:SetScript('OnKeyDown', self.OnKeyDown)
		end

		overlay.owner = owner
		overlay:SetText(Dominos.OWNER_NAME and Dominos.OWNER_NAME[owner.id] or owner.id)
		overlay:SetAllPoints(owner)
		-- overlay:SetFrameLevel(owner:GetFrameLevel() + 5)
		overlay:UpdateColor(true)
		overlay:UpdateBorderColor(true)
		overlay:SetFrameStrata('DIALOG')
		overlay:Show()

		table.insert(active, overlay)
		return owner
	end

	function FrameOverlay:Free()
		self:ClearAllPoints()
		self:SetParent(nil)
		self:Hide()

		for i, overlay in pairs(active) do
			if overlay == self then
				table.remove(active, i)
				break
			end
		end

		table.insert(unused, self)
	end

	--[[ frame events ]]--

	function FrameOverlay:OnKeyDown(key)
		local handled = false

		if self.watchingKeyboardMovement then
			if key == 'UP' then
				self:NudgeFrame(0, KEYBOARD_MOVEMENT_INCREMENT)
				handled = true
			elseif key == 'DOWN' then
				self:NudgeFrame(0, -KEYBOARD_MOVEMENT_INCREMENT)
				handled = true
			elseif key == 'LEFT' then
				self:NudgeFrame(-KEYBOARD_MOVEMENT_INCREMENT, 0)
				handled = true
			elseif key == 'RIGHT' then
				self:NudgeFrame(KEYBOARD_MOVEMENT_INCREMENT, 0)
				handled = true
			end
		end

		self:SetPropagateKeyboardInput(not handled)
	end

	function FrameOverlay:OnEnter()
		if not self.isMouseOver then
			self.isMouseOver = true

			self:UpdateTooltip()
			self:UpdateBorderColor()
			self:EnableArrowKeyMovement()
		end
	end

	function FrameOverlay:OnLeave()
		if self.isMouseOver then
			self.isMouseOver = nil

			self:UpdateBorderColor()
			GameTooltip:Hide()
			self:DisableArrowKeyMovement()
		end
	end

	function FrameOverlay:StartMoving(button)
		if button == 'LeftButton' then
			self.isMoving = true
			self.owner:StartMoving()

			if GameTooltip:IsOwned(self) then
				GameTooltip:Hide()
			end
		end
	end

	function FrameOverlay:StopMoving()
		if self.isMoving then
			self.isMoving = nil
			self.owner:StopMovingOrSizing()
			self.owner:Stick()

			self:UpdateColor()
			self:UpdateTooltip()
		end
	end

	function FrameOverlay:OnMouseWheel(delta)
		if IsModifierKeyDown() then
			self:CycleFocus(delta)
		else
			self:IncrementOpacity(delta)
		end
	end

	function FrameOverlay:OnClick(button)
		if button == 'RightButton' then
			if IsModifierKeyDown() then
				self.owner:ToggleFrame()
			else
				self.owner:ShowMenu()
			end
		elseif button == 'MiddleButton' then
			self.owner:ToggleFrame()
		end

		self:UpdateTooltip()
		self:UpdateColor()
		self:UpdateBorderColor()
	end


	--[[ actions ]]--

	function FrameOverlay:EnableArrowKeyMovement()
		self.watchingKeyboardMovement = true
		self:EnableKeyboard(true)
	end

	function FrameOverlay:DisableArrowKeyMovement()
		self.watchingKeyboardMovement = nil
		self:EnableKeyboard(false)
	end

	function FrameOverlay:NudgeFrame(dx, dy)
		local point, x, y = self.owner:GetRelativeFramePosition()

		if self.owner:GetAnchor() then
			self.owner:ClearAnchor()
			self:UpdateColor()
		end

		self.owner:SetAndSaveFramePosition(point, round(x + dx), round(y + dy))
	end

	function FrameOverlay:UpdateTooltip()
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
		GameTooltip:SetText(self.owner:GetDisplayName(), 1, 1, 1)

		local tooltipText = self.owner:GetTooltipText()
		if tooltipText then
			GameTooltip:AddLine(tooltipText .. '\n', nil, nil, nil, nil, 1)
		end

		if self.owner.ShowMenu and Addon:IsConfigAddonEnabled() then
			GameTooltip:AddLine(L.ShowConfig)
		end

		if self.owner:IsShown() then
			GameTooltip:AddLine(L.HideBar)
		else
			GameTooltip:AddLine(L.ShowBar)
		end

		GameTooltip:AddLine(format(L.SetAlpha, ceil(self.owner:GetFrameAlpha()*100)))
		GameTooltip:Show()
	end

	do
		local overlaysUnderMouse = {}

		function FrameOverlay:CycleFocus(delta)
			table.wipe(overlaysUnderMouse)
			local currentIndex = 1
			local count = 0

			-- grab all frames under the mouse
			for i, overlay in ipairs(active) do
				if overlay:IsMouseOver() then
					count = count + 1

					if GetMouseFocus() == overlay then
						currentIndex = count
					end

					tinsert(overlaysUnderMouse, overlay)
				end
			end

			-- need at least two frames to cycle through
			if #overlaysUnderMouse < 2 then
				return
			end

			local nextIndex = currentIndex + delta

			if nextIndex > #overlaysUnderMouse then
				nextIndex = nextIndex % #overlaysUnderMouse
			elseif nextIndex <= 0 then
				nextIndex = #overlaysUnderMouse - nextIndex
			end

			overlaysUnderMouse[currentIndex]:SetFrameLevel(1)
			overlaysUnderMouse[nextIndex]:SetFrameLevel(100)
		end
	end

	function FrameOverlay:IncrementOpacity(delta)
		local oldAlpha = self.owner.sets and self.owner.sets.alpha or 1
		local newAlpha = min(max(oldAlpha + (delta * 0.1), 0), 1)

		-- round to fix floating point fun
		oldAlpha = math.floor(oldAlpha * 100 + 0.5) / 100
		newAlpha = math.floor(newAlpha * 100 + 0.5) / 100

		if newAlpha ~= oldAlpha then
			self.owner:SetFrameAlpha(newAlpha)

			self:UpdateTooltip()
		end
	end

	--[[ coloring ]]--

	function FrameOverlay:UpdateColor(isImmediate)
		local r, g, b, a = self:GetColor()

		if isImmediate then
			self:SetBackdropColor(r, g, b, a)
		else
			self:TransitionToColor(r, g, b, a)
		end
	end

	function FrameOverlay:UpdateBorderColor(isImmediate)
		local r, g, b, a = self:GetBorderColor()

		if isImmediate then
			self:SetBackdropBorderColor(r, g, b, a)
		else
			self:TransitionBorderToColor(r, g, b, a)
		end
	end

	function FrameOverlay:TransitionToColor(r, g, b, a)
		local pR, pG, pB, pA = self:GetBackdropColor()

		if not (r == pR and g == pG and b == pB and a == pA) then
			local fader = self.colorFader

			if not fader then
				fader = colorFader_Create(self); self.colorFader = fader

				fader.saveColor = function(self, r, g, b, a)
					return self:GetParent():SetBackdropColor(r, g, b, a)
				end

				fader.loadColor = function(self)
					return self:GetParent():GetBackdropColor()
				end
			end

			fader:SetColor(r, g, b, a)
		end
	end

	function FrameOverlay:TransitionBorderToColor(r, g, b, a)
		local pR, pG, pB, pA = self:GetBackdropBorderColor()

		if not (r == pR and g == pG and b == pB and a == pA) then
			local fader = self.borderFader

			if not fader then
				fader = colorFader_Create(self); self.borderFader = fader

				fader.saveColor = function(self, r, g, b, a)
					return self:GetParent():SetBackdropBorderColor(r, g, b, a)
				end

				fader.loadColor = function(self)
					return self:GetParent():GetBackdropBorderColor()
				end
			end

			fader:SetColor(r, g, b, a)
		end
	end

	function FrameOverlay:GetColor()
		local color = FRAME_COLOR
		local h, s, l, a = color.h, color.s, color.l, 0.5

		if not self.owner:FrameIsShown() then
			s = 0
			l = l * 0.5
		end

		if self.owner:GetAnchor() then
			l = math.max(l * 0.1, 0)
		end

		local r, g, b = hslToRGB(h, s, l)
		return r, g, b, a
	end

	function FrameOverlay:GetBorderColor()
		local color = FRAME_COLOR
		local h, s, l, a = color.h, color.s, color.l, 0.75

		h = (h - 45) % 360

		if not self.owner:FrameIsShown() then
			s = 0
		end

		if self.isMouseOver then
			l = math.min(l * 1.5, 1)
			a = 1
		end

		local r, g, b = hslToRGB(h, s, l)
		return r, g, b, a
	end


	--[[ overlays ]]--

	function FrameOverlay:FreeAll()
		while next(active) do
			active[#active]:Free()
		end
	end
end


-- [[ the main overlay frame controller ]]--

do
	local ConfigOverlay = Addon:NewModule('ConfigOverlay')

	function ConfigOverlay:OnInitialize()
		-- create overlay background
		local overlay = CreateFrame('Frame', nil, UIParent, 'SecureHandlerStateTemplate')

		overlay:SetFrameStrata('BACKGROUND')
		overlay:Hide()
		overlay:EnableMouse(false)
		overlay:SetAllPoints(overlay:GetParent())

		self.overlay = overlay

		--add a texture for the  background
		local overlayBG = overlay:CreateTexture(nil, 'BACKGROUND')
		overlayBG:SetColorTexture(0, 0, 0, 0.3)
		overlayBG:SetAllPoints(overlay)

		--add a fade effect for when showing
		local fadeInGroup = overlay:CreateAnimationGroup()

		local fadeIn = fadeInGroup:CreateAnimation('Alpha')
		fadeIn:SetFromAlpha(0)
		fadeIn:SetToAlpha(1)
		fadeIn:SetSmoothing('IN')
		fadeIn:SetDuration(0.2)

		overlay:SetScript('OnShow', function()
			if overlay.fadeOutGroup:IsPlaying() then
				overlay.fadeOutGroup:Stop()
			end

			fadeInGroup:Play()
		end)

		-- add a fade effect when hiding
		local fadeOutGroup = overlay:CreateAnimationGroup()

		local fadeOut = fadeOutGroup:CreateAnimation('Alpha')
		fadeOut:SetFromAlpha(1)
		fadeOut:SetToAlpha(0)
		fadeOut:SetSmoothing('OUT')
		fadeOut:SetDuration(0.2)

		fadeOutGroup:SetScript('OnFinished', function()
			overlay:Hide()
		end)

		overlay.fadeOutGroup = fadeOutGroup
	end

	function ConfigOverlay:Show()
		self:CreateFrameOverlays()

		self.overlay:Show()
	end

	function ConfigOverlay:Hide()
		self.overlay.fadeOutGroup:Play()

		FrameOverlay:FreeAll()
	end

	function ConfigOverlay:CreateFrameOverlays()
		if not self.helpDialog then
			self.helpDialog = self:CreateHelpDialog()
		end

		for _, frame in Addon.Frame:GetAll() do
			FrameOverlay:New(self.overlay, frame)
		end
	end

	function ConfigOverlay:CreateHelpDialog()
		local dialog = CreateFrame('Frame', AddonName .. 'ConfigHelperDialog', self.overlay)

		dialog:SetMovable(true)
		dialog:EnableMouse(true)
		dialog:SetClampedToScreen(true)
		dialog:SetSize(360, 120)
		dialog:SetFrameStrata('FULLSCREEN_DIALOG')
		dialog:RegisterForDrag('LeftButton')

		dialog:SetBackdrop{
			bgFile='Interface\\DialogFrame\\UI-DialogBox-Background',
			edgeFile='Interface\\DialogFrame\\UI-DialogBox-Border',
			tile = true,
			insets = {left = 11, right = 12, top = 12, bottom = 11},
			tileSize = 32,
			edgeSize = 32,
		}

		dialog:SetPoint('TOP', 0, -24)

		dialog:SetScript('OnDragStart', function() dialog:StartMoving() end)
		dialog:SetScript('OnDragStop', function() dialog:StopMovingOrSizing() end)

		local header = dialog:CreateTexture(nil, 'ARTWORK')
		header:SetTexture('Interface\\DialogFrame\\UI-DialogBox-Header')
		header:SetWidth(326); header:SetHeight(64)
		header:SetPoint('TOP', 0, 12)

		local title = dialog:CreateFontString('ARTWORK')
		title:SetFontObject('GameFontNormal')
		title:SetPoint('TOP', header, 'TOP', 0, -14)
		title:SetText(L.ConfigMode)

		local desc = dialog:CreateFontString('ARTWORK')
		desc:SetFontObject('GameFontHighlight')
		desc:SetJustifyV('TOP')
		desc:SetJustifyH('LEFT')
		desc:SetPoint('TOPLEFT', 18, -32)
		desc:SetPoint('BOTTOMRIGHT', -18, 48)
		desc:SetText(L.ConfigModeHelp)

		local exitConfig = CreateFrame('CheckButton', dialog:GetName() .. 'ExitConfig', dialog, 'OptionsButtonTemplate')
		_G[exitConfig:GetName() .. 'Text']:SetText(EXIT)

		exitConfig:SetScript('OnClick', function() Addon:SetLock(true)end)
		exitConfig:SetPoint('BOTTOMRIGHT', -14, 14)

		return dialog
	end
end
