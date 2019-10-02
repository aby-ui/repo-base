--[[
Name: LibKeyBound-1.0
Revision: $Rev: 115 $
Author(s): Gello, Maul, Toadkiller, Tuller
Website: http://www.wowace.com/wiki/LibKeyBound-1.0
Documentation: http://www.wowace.com/wiki/LibKeyBound-1.0
SVN: http://svn.wowace.com/wowace/trunk/LibKeyBound-1.0
Description: An intuitive keybindings system: mouseover frame, click keys or buttons.
Dependencies: CallbackHandler-1.0
--]]

local MAJOR = 'LibKeyBound-1.0'
local MINOR = 100000 + 1

--[[
	LibKeyBound-1.0
		ClickBinder by Gello and TrinityBinder by Maul -> keyBound by Tuller -> LibKeyBound library by Toadkiller

		Functions needed to implement
			button:GetHotkey() - returns the current hotkey assigned to the given button

		Functions to implement if using a custom keybindings system:
			button:SetKey(key) - binds the given key to the given button
			button:FreeKey(key) - unbinds the given key from all other buttons
			button:ClearBindings() - removes all keys bound to the given button
			button:GetBindings() - returns a string listing all bindings of the given button
			button:GetActionName() - what we're binding to, used for printing
--]]

local LibKeyBound, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not LibKeyBound then return end -- no upgrade needed

local _G = _G
local NUM_MOUSE_BUTTONS = 31

-- CallbackHandler
LibKeyBound.events = LibKeyBound.events or _G.LibStub('CallbackHandler-1.0'):New(LibKeyBound)

local L = LibKeyBoundLocale10
LibKeyBound.L = L
-- ToDo delete global LibKeyBoundLocale10 at some point
LibKeyBound.Binder = LibKeyBound.Binder or {}

local SaveBindings = SaveBindings or AttemptToSaveBindings

-- #NODOC
function LibKeyBound:Initialize()
	do
		local f = CreateFrame('Frame', 'KeyboundDialog', UIParent)
		f:SetFrameStrata('DIALOG')
		f:SetToplevel(true)
		f:EnableMouse(true)
		f:SetMovable(true)
		f:SetClampedToScreen(true)
		f:SetWidth(360)
		f:SetHeight(140)
		f:SetBackdrop{
			bgFile='Interface\\DialogFrame\\UI-DialogBox-Background' ,
			edgeFile='Interface\\DialogFrame\\UI-DialogBox-Border',
			tile = true,
			insets = {left = 11, right = 12, top = 12, bottom = 11},
			tileSize = 32,
			edgeSize = 32,
		}
		f:SetPoint('TOP', 0, -24)
		f:Hide()
		f:SetScript('OnShow', function() PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION or 'igMainMenuOption') end)
		f:SetScript('OnHide', function() PlaySound(SOUNDKIT and SOUNDKIT.GS_TITLE_OPTION_EXIT or 'gsTitleOptionExit') end)

		f:RegisterForDrag('LeftButton')
		f:SetScript('OnDragStart', function(f) f:StartMoving() end) 
		f:SetScript('OnDragStop', function(f) f:StopMovingOrSizing() end)

		local header = f:CreateTexture(nil, 'ARTWORK')
		header:SetTexture('Interface\\DialogFrame\\UI-DialogBox-Header')
		header:SetWidth(256); header:SetHeight(64)
		header:SetPoint('TOP', 0, 12)

		local title = f:CreateFontString('ARTWORK')
		title:SetFontObject('GameFontNormal')
		title:SetPoint('TOP', header, 'TOP', 0, -14)
		title:SetText(L.BindingMode)

		local desc = f:CreateFontString('ARTWORK')
		desc:SetFontObject('GameFontHighlight')
		desc:SetJustifyV('TOP')
		desc:SetJustifyH('LEFT')
		desc:SetPoint('TOPLEFT', 18, -32)
		desc:SetPoint('BOTTOMRIGHT', -18, 48)
		desc:SetText(format(L.BindingsHelp, GetBindingText('ESCAPE')))

		-- Per character bindings checkbox
		local perChar = CreateFrame('CheckButton', 'KeyboundDialogCheck', f, 'OptionsCheckButtonTemplate')
		_G[perChar:GetName() .. 'Text']:SetText(CHARACTER_SPECIFIC_KEYBINDINGS)

		perChar:SetScript('OnShow', function(self)
			self:SetChecked(GetCurrentBindingSet() == 2)
		end)

		local current
		perChar:SetScript('OnClick', function(self)
			current = (perChar:GetChecked() and 2) or 1
			LoadBindings(current)
		end)

		-- Okay bindings checkbox
		local okayBindings = CreateFrame('CheckButton', 'KeyboundDialogOkay', f, 'OptionsButtonTemplate')
		getglobal(okayBindings:GetName() .. 'Text'):SetText(OKAY)

		okayBindings:SetScript('OnClick', function(self)
			current = (perChar:GetChecked() and 2) or 1
			if InCombatLockdown() then
				self:RegisterEvent('PLAYER_REGEN_ENABLED')
			else
				SaveBindings(current)
				LibKeyBound:Deactivate()
			end
		end)

		okayBindings:SetScript('OnHide', function(self)
			current = (perChar:GetChecked() and 2) or 1
			if InCombatLockdown() then
				self:RegisterEvent('PLAYER_REGEN_ENABLED')
			else
				SaveBindings(current)
			end
		end)

		okayBindings:SetScript('OnEvent', function(self, event)
			SaveBindings(current)
			self:UnregisterEvent(event)
			LibKeyBound:Deactivate()
		end)

		-- Cancel bindings checkbox
		local cancelBindings = CreateFrame('CheckButton', 'KeyboundDialogCancel', f, 'OptionsButtonTemplate')
		getglobal(cancelBindings:GetName() .. 'Text'):SetText(CANCEL)

		cancelBindings:SetScript('OnClick', function(self)
			if InCombatLockdown() then
				self:RegisterEvent('PLAYER_REGEN_ENABLED')
			else
				LoadBindings(GetCurrentBindingSet())
				LibKeyBound:Deactivate()
			end
		end)

		cancelBindings:SetScript('OnEvent', function(self, event)
			LoadBindings(GetCurrentBindingSet())
			self:UnregisterEvent(event)
			LibKeyBound:Deactivate()
		end)

		--position buttons
		perChar:SetPoint('BOTTOMLEFT', 14, 32)
		cancelBindings:SetPoint('BOTTOMRIGHT', -14, 14)
		okayBindings:SetPoint('RIGHT', cancelBindings, 'LEFT')

		self.dialog = f
	end

	SlashCmdList['LibKeyBoundSlashCOMMAND'] = function() self:Toggle() end
	SLASH_LibKeyBoundSlashCOMMAND1 = '/libkeybound'
	SLASH_LibKeyBoundSlashCOMMAND2 = '/kb'
	SLASH_LibKeyBoundSlashCOMMAND3 = '/lkb'

	LibKeyBound.initialized = true
end


-- Default color to indicate bindable frames in your mod.
LibKeyBound.colorKeyBoundMode = LibKeyBound.colorKeyBoundMode or { 0, 1, 1, 0.5 }

--[[
LibKeyBound:SetColorKeyBoundMode([r][, g][, b][, a])
--]]
--[[
Arguments:
	number - red, default 0
	number - green, default 0
	number - blue, default 0
	number - alpha, default 1

Example:
	if (MyMod.keyBoundMode) then
		overlayFrame:SetBackdropColor(LibKeyBound:GetColorKeyBoundMode())
	end
	...
	local r, g, b, a = LibKeyBound:GetColorKeyBoundMode()

Notes:
	* Returns the color to use on your participating buttons during KeyBound Mode
	* Values are unpacked and ready to use as color arguments
--]]
function LibKeyBound:SetColorKeyBoundMode(r, g, b, a)
	r, g, b, a = r or 0, g or 0, b or 0, a or 1
	LibKeyBound.colorKeyBoundMode[1] = r
	LibKeyBound.colorKeyBoundMode[2] = g
	LibKeyBound.colorKeyBoundMode[3] = b
	LibKeyBound.colorKeyBoundMode[4] = a
	LibKeyBound.events:Fire('LIBKEYBOUND_MODE_COLOR_CHANGED')
end

--[[
Returns:
	* number - red
	* number - green
	* number - blue
	* number - alpha

Example:
	if (MyMod.keyBoundMode) then
		overlayFrame:SetBackdropColor(LibKeyBound:GetColorKeyBoundMode())
	end
	...
	local r, g, b, a = LibKeyBound:GetColorKeyBoundMode()

Notes:
	* Returns the color to use on your participating buttons during KeyBound Mode
	* Values are unpacked and ready to use as color arguments
--]]
function LibKeyBound:GetColorKeyBoundMode()
	return unpack(LibKeyBound.colorKeyBoundMode)
end


function LibKeyBound:PLAYER_REGEN_ENABLED()
	if self.enabled then
		UIErrorsFrame:AddMessage(L.CombatBindingsEnabled, 1, 0.3, 0.3, 1, UIERRORS_HOLD_TIME)
		self.dialog:Hide()
	end
end

function LibKeyBound:PLAYER_REGEN_DISABLED()
	if self.enabled then
		self:Set(nil)
		UIErrorsFrame:AddMessage(L.CombatBindingsDisabled, 1, 0.3, 0.3, 1, UIERRORS_HOLD_TIME)
		self.dialog:Show()
	end
end


--[[
Notes:
	* Switches KeyBound Mode between on and off

Example:
	local LibKeyBound = LibStub('LibKeyBound-1.0')
 	LibKeyBound:Toggle()
--]]
function LibKeyBound:Toggle()
	if (LibKeyBound:IsShown()) then
		LibKeyBound:Deactivate()
	else
		LibKeyBound:Activate()
	end
end


--[[
Notes:
	* Switches KeyBound Mode to on

Example:
	local LibKeyBound = LibStub('LibKeyBound-1.0')
 	LibKeyBound:Activate()
--]]
function LibKeyBound:Activate()
	if not self:IsShown() then
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(L.CannotBindInCombat, 1, 0.3, 0.3, 1, UIERRORS_HOLD_TIME)
		else
			self.enabled = true
			if not self.frame then
				self.frame = LibKeyBound.Binder:Create()
			end
			self:Set(nil)
			self.dialog:Show()
			self.events:Fire('LIBKEYBOUND_ENABLED')
		end
	end
end


--[[
Notes:
	* Switches KeyBound Mode to off

Example:
	local LibKeyBound = LibStub('LibKeyBound-1.0')
 	LibKeyBound:Deactivate()
--]]
function LibKeyBound:Deactivate()
	if self:IsShown() then
		self.enabled = nil
		self:Set(nil)
		self.dialog:Hide()

		self.events:Fire('LIBKEYBOUND_DISABLED')
	end
end


--[[
Returns:
	boolean - true if KeyBound Mode is currently on

Example:
	local LibKeyBound = LibStub('LibKeyBound-1.0')
 	local isKeyBoundMode = LibKeyBound:IsShown()
 	if (isKeyBoundMode) then
 		-- Do something
 	else
 		-- Do another thing
 	end

Notes:
	* Is KeyBound Mode currently on
--]]
function LibKeyBound:IsShown()
	return self.enabled
end


--[[
Arguments:
	table - the button frame

Example:
		local button = this
		LibKeyBound:Set(button)

Notes:
	 * Sets up button for keybinding
	 * Call this in your OnEnter script for the button
	 * Current bindings are shown in the tooltip
	 * Primary binding is shown in green in the button text
--]]
function LibKeyBound:Set(button)
	local bindFrame = self.frame

	if button and self:IsShown() and not InCombatLockdown() then
		bindFrame.button = button
		bindFrame:SetAllPoints(button)

		bindFrame.text:SetFontObject('GameFontNormalLarge')
		bindFrame.text:SetText(button:GetHotkey())
		if bindFrame.text:GetStringWidth() > bindFrame:GetWidth() then
			bindFrame.text:SetFontObject('GameFontNormal')
		end
		bindFrame:Show()
		bindFrame:OnEnter()
	elseif bindFrame then
		bindFrame.button = nil
		bindFrame:ClearAllPoints()
		bindFrame:Hide()
	end
end


--[[
Arguments:
	string - the keyString to shorten

Returns:
	string - the shortened displayString

Example:
	local key1 = GetBindingKey(button:GetName())
	local displayKey = LibKeyBound:ToShortKey(key1)
	return displayKey

Notes:
	* Shortens the key text (returned from GetBindingKey etc.)
	* Result is suitable for display on a button
	* Can be used for your button:GetHotkey() return value
--]]
function LibKeyBound:ToShortKey(key)
	if key then
		key = key:upper()
		key = key:gsub(' ', '')
		key = key:gsub('ALT%-', L['Alt'])
		key = key:gsub('CTRL%-', L['Ctrl'])
		key = key:gsub('SHIFT%-', L['Shift'])
		key = key:gsub('NUMPAD', L['NumPad'])

		key = key:gsub('PLUS', '%+')
		key = key:gsub('MINUS', '%-')
		key = key:gsub('MULTIPLY', '%*')
		key = key:gsub('DIVIDE', '%/')

		key = key:gsub('BACKSPACE', L['Backspace'])

		for i = 1, NUM_MOUSE_BUTTONS do
			key = key:gsub('BUTTON' .. i, L['Button' .. i])
		end

		key = key:gsub('CAPSLOCK', L['Capslock'])
		key = key:gsub('CLEAR', L['Clear'])
		key = key:gsub('DELETE', L['Delete'])
		key = key:gsub('END', L['End'])
		key = key:gsub('HOME', L['Home'])
		key = key:gsub('INSERT', L['Insert'])
		key = key:gsub('MOUSEWHEELDOWN', L['Mouse Wheel Down'])
		key = key:gsub('MOUSEWHEELUP', L['Mouse Wheel Up'])
		key = key:gsub('NUMLOCK', L['Num Lock'])
		key = key:gsub('PAGEDOWN', L['Page Down'])
		key = key:gsub('PAGEUP', L['Page Up'])
		key = key:gsub('SCROLLLOCK', L['Scroll Lock'])
		key = key:gsub('SPACEBAR', L['Spacebar'])
		key = key:gsub('SPACE', L['Spacebar'])
		key = key:gsub('TAB', L['Tab'])

		key = key:gsub('DOWNARROW', L['Down Arrow'])
		key = key:gsub('LEFTARROW', L['Left Arrow'])
		key = key:gsub('RIGHTARROW', L['Right Arrow'])
		key = key:gsub('UPARROW', L['Up Arrow'])

		return key
	end
end


--[[ Binder Widget ]]--

function LibKeyBound.Binder:Create()
	local binder = CreateFrame('Button')
	binder:RegisterForClicks('anyUp')
	binder:SetFrameStrata('DIALOG')
	binder:EnableKeyboard(true)
	binder:EnableMouseWheel(true)

	for k,v in pairs(self) do
		binder[k] = v
	end

	local bg = binder:CreateTexture()
	bg:SetColorTexture(0, 0, 0, 0.5)
	bg:SetAllPoints(binder)

	local text = binder:CreateFontString('OVERLAY')
	text:SetFontObject('GameFontNormalLarge')
	text:SetTextColor(0, 1, 0)
	text:SetAllPoints(binder)
	binder.text = text

	binder:SetScript('OnClick', self.OnKeyDown)
	binder:SetScript('OnKeyDown', self.OnKeyDown)
	binder:SetScript('OnMouseWheel', self.OnMouseWheel)
	binder:SetScript('OnEnter', self.OnEnter)
	binder:SetScript('OnLeave', self.OnLeave)
	binder:SetScript('OnHide', self.OnHide)
	binder:Hide()

	return binder
end

function LibKeyBound.Binder:OnHide()
	LibKeyBound:Set(nil)
end

function LibKeyBound.Binder:OnKeyDown(key)
	local button = self.button
	if not button or not button:IsMouseOver()then return end

	if (key == 'UNKNOWN' or key == 'LSHIFT' or key == 'RSHIFT' or
		key == 'LCTRL' or key == 'RCTRL' or key == 'LALT' or key == 'RALT') then
		return
	end

	local screenshotKey = GetBindingKey('SCREENSHOT')
	if screenshotKey and key == screenshotKey then
		Screenshot()
		return
	end

	local openChatKey = GetBindingKey('OPENCHAT')
	if openChatKey and key == openChatKey then
		ChatFrame_OpenChat("")
		return
	end

	if key == 'ESCAPE' then
		self:ClearBindings(button)
		LibKeyBound:Set(button)
		return
	end

	-- dont bind unmodified left or right button
	if (key == 'LeftButton' or key == 'RightButton') and not IsModifierKeyDown() then
		return
	end

	--handle mouse button substitutions
	if key == 'LeftButton' then
		key = 'BUTTON1'
	elseif key == 'RightButton' then
		key = 'BUTTON2'
	elseif key == 'MiddleButton' then
		key = 'BUTTON3'
	elseif key:match('^Button%d+$') then
		key = key:upper()
	end

	--apply modifiers
	if IsModifierKeyDown() then
		if IsShiftKeyDown() then
			key = 'SHIFT-' .. key
		end
		if IsControlKeyDown() then
			key = 'CTRL-' .. key
		end
		if IsAltKeyDown() then
			key = 'ALT-' .. key
		end
	end

	self:SetKey(button, key)
	LibKeyBound:Set(button)
end

function LibKeyBound.Binder:OnMouseWheel(arg1)
	if arg1 > 0 then
		self:OnKeyDown('MOUSEWHEELUP')
	else
		self:OnKeyDown('MOUSEWHEELDOWN')
	end
end

function LibKeyBound.Binder:OnEnter()
	local button = self.button
	if button and not InCombatLockdown() then
		if self:GetRight() >= (GetScreenWidth() / 2) then
			GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		else
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		end

		if button.GetActionName then
			GameTooltip:SetText(button:GetActionName(), 1, 1, 1)
		else
			GameTooltip:SetText(button:GetName(), 1, 1, 1)
		end

		local bindings = self:GetBindings(button)
		if bindings and bindings ~= "" then
			GameTooltip:AddLine(bindings, 0, 1, 0)
			GameTooltip:AddLine(L.ClearTip)
		else
			GameTooltip:AddLine(L.NoKeysBoundTip, 0, 1, 0)
		end
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end
end

function LibKeyBound.Binder:OnLeave()
	LibKeyBound:Set(nil)
	GameTooltip:Hide()
end


--[[ Update Functions ]]--

function LibKeyBound.Binder:ToBinding(button)
	return format('CLICK %s:LeftButton', button:GetName())
end

function LibKeyBound.Binder:FreeKey(button, key)
	local msg
	if button.FreeKey then
		local action = button:FreeKey(key)
		if button:FreeKey(key) then
			msg = format(L.UnboundKey, GetBindingText(key), action)
		end
	else
		local action = GetBindingAction(key)
		if action and action ~= '' and action ~= self:ToBinding(button) then
			msg = format(L.UnboundKey, GetBindingText(key), action)
		end
	end

	if msg then
		UIErrorsFrame:AddMessage(msg, 1, 0.82, 0, 1, UIERRORS_HOLD_TIME)
	end
end

function LibKeyBound.Binder:SetKey(button, key)
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(L.CannotBindInCombat, 1, 0.3, 0.3, 1, UIERRORS_HOLD_TIME)
	else
		self:FreeKey(button, key)

		if button.SetKey then
			button:SetKey(key)
		else
			SetBindingClick(key, button:GetName(), 'LeftButton')
		end

		local msg
		if button.GetActionName then
			msg = format(L.BoundKey, GetBindingText(key), button:GetActionName())
		else
			msg = format(L.BoundKey, GetBindingText(key), button:GetName())
		end
		UIErrorsFrame:AddMessage(msg, 1, 1, 1, 1, UIERRORS_HOLD_TIME)
	end
end

function LibKeyBound.Binder:ClearBindings(button)
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(L.CannotBindInCombat, 1, 0.3, 0.3, 1, UIERRORS_HOLD_TIME)
	else
		if button.ClearBindings then
			button:ClearBindings()
		else
			local binding = self:ToBinding(button)
			while (GetBindingKey(binding)) do
				SetBinding(GetBindingKey(binding), nil)
			end
		end

		local msg
		if button.GetActionName then
			msg = format(L.ClearedBindings, button:GetActionName())
		else
			msg = format(L.ClearedBindings, button:GetName())
		end
		UIErrorsFrame:AddMessage(msg, 1, 1, 1, 1, UIERRORS_HOLD_TIME)
	end
end

function LibKeyBound.Binder:GetBindings(button)
	if button.GetBindings then
		return button:GetBindings()
	end

	local keys
	local binding = self:ToBinding(button)
	for i = 1, select('#', GetBindingKey(binding)) do
		local hotKey = select(i, GetBindingKey(binding))
		if keys then
			keys = keys .. ', ' .. GetBindingText(hotKey)
		else
			keys = GetBindingText(hotKey)
		end
	end

	return keys
end

LibKeyBound.EventButton = LibKeyBound.EventButton or CreateFrame('Frame')
do
	local EventButton = LibKeyBound.EventButton
	EventButton:UnregisterAllEvents()
	EventButton:SetScript('OnEvent', function(self, event, addon)
		if (event == 'PLAYER_REGEN_DISABLED') then
			LibKeyBound:PLAYER_REGEN_DISABLED()
		elseif (event == 'PLAYER_REGEN_ENABLED') then
			LibKeyBound:PLAYER_REGEN_ENABLED()
		elseif (event == 'PLAYER_LOGIN' and not LibKeyBound.initialized) then
			LibKeyBound:Initialize()
			EventButton:UnregisterEvent('PLAYER_LOGIN')
		end
	end)

	if IsLoggedIn() and not LibKeyBound.initialized then
		LibKeyBound:Initialize()
	elseif not LibKeyBound.initialized then
		EventButton:RegisterEvent('PLAYER_LOGIN')
	end
	EventButton:RegisterEvent('PLAYER_REGEN_ENABLED')
	EventButton:RegisterEvent('PLAYER_REGEN_DISABLED')
end
