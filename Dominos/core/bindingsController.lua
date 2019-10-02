--[[
	bindingsController.lua
		A bindable button manager

		Used for (hopefully) efficiently handling binding events,
		and also handling onkeypress buttons
--]]


--[[ globals ]]--

local _, Addon = ...
local Timer_After = _G.C_Timer.After


--[[
	surrogate button:
		a button that clicks another button.  used to implement cast on key press functionality
		when we aren't able to use a standard blizzard button.
--]]

local SurrogateButton = Addon:CreateClass('Button')

SurrogateButton.unused = {}

function SurrogateButton:GetOrCreate()
	return self:Get() or self:Create()
end

function SurrogateButton:Get()
	return SurrogateButton.unused and table.remove(SurrogateButton.unused)
end

do
	local nextName = Addon:CreateNameGenerator('VirtualButton')

	function SurrogateButton:Create()
		local button = self:Bind(CreateFrame('Button', nextName(), nil, 'SecureActionButtonTemplate'))

		button:Hide()
		button:SetAttribute('type', 'click')
		button:SetScript('OnMouseUp', button.OnMouseUp)
		button:SetScript('OnMouseDown', button.OnMouseDown)

		return button
	end
end

function SurrogateButton:Free()
	self:SetOwner('owner', nil)
	self:SetParent(nil)

	if SurrogateButton.unused then
		table.insert(SurrogateButton.unused, self)
	else
		SurrogateButton.unused = { self }
	end
end

function SurrogateButton:SetOwner(owner)
	if owner then
		local ownerName = owner:GetName()

		if not ownerName then
			error(2, 'owner must have a name')
		end

		self:SetAttribute('owner', ownerName)
		self:SetAttribute('clickbutton', owner)
	else
		self:SetAttribute('owner', nil)
		self:SetAttribute('clickbutton', nil)
	end
end

function SurrogateButton:OnMouseUp()
	local target = self:GetAttribute('clickbutton')

	if target then
		target:SetButtonState('NORMAL')
	end
end

function SurrogateButton:OnMouseDown()
	local target = self:GetAttribute('clickbutton')

	if target then
		target:SetButtonState('PUSHED')
	end
end

function SurrogateButton:SetCastOnKeyPress(enable)
	self:RegisterForClicks(enable and 'anyDown' or 'anyUp')
end


--[[ controller ]]--

local BindingsController = Addon:CreateHiddenFrame('Frame', nil, UIParent, 'SecureHandlerStateTemplate')

function BindingsController:Load()
	self.frames = {}
	self.surrogates = {}

	self:SetupAttributeMethods()
	self:HookBindingMethods()
	self:RegisterEvents()
end

function BindingsController:SetupAttributeMethods()
	self:Execute([[
		myFrames = table.new()
	]])

	--[[ usage: LoadBindings() ]]--
	self:SetAttribute('LoadBindings', [[
		self:ClearBindings()

		for i, frame in ipairs(myFrames) do
			self:RunAttribute('LoadFrameBindings', i)
		end
	]])

	--[[ usage: LoadFrameBindings(frameID) ]]--
	self:SetAttribute('LoadFrameBindings', [[
		local frame = myFrames[...]
		local frameName = frame:GetName()
		local targetName = frame:GetAttribute('owner')

		self:RunAttribute('SetBindings', frameName, self:RunAttribute('GetBindings', targetName))
		self:RunAttribute('SetBindings', frameName, self:RunAttribute('GetClickBindings', targetName))
	]])

	--[[ usage: SetBindings(frameName, [binding1, binding2, ...]) ]]--
	self:SetAttribute('SetBindings', [[
		local frameName = (...)

		for i = 2, select('#', ...) do
			local key = (select(i, ...))

			self:SetBindingClick(false, key, frameName)
		end
	]])

	--[[ usage: GetBindings(frameName) ]]--
	self:SetAttribute('GetBindings', [[
		local frameName = (...)

		return GetBindingKey(frameName)
	]])

	--[[ usage: GetClickBindings(frameName) ]]--
	self:SetAttribute('GetClickBindings', [[
		local frameName = (...)

		return GetBindingKey(format('CLICK %s:LeftButton', frameName))
	]])

	--[[ usage: ClearOverrideBindings([key1, key2, ...]) ]]--
	self:SetAttribute('ClearOverrideBindings', [[
		for i = 1, select('#', ...) do
			local key = (select(i, ...))

			self:ClearBinding(key)
		end
	]])
end

function BindingsController:HookBindingMethods()
	local updateBindings = function() self:RequestUpdateBindings() end

	hooksecurefunc('SetBinding', updateBindings)
	hooksecurefunc('SetBindingClick', updateBindings)
	hooksecurefunc('SetBindingItem', updateBindings)
	hooksecurefunc('SetBindingMacro', updateBindings)
	hooksecurefunc('SetBindingSpell', updateBindings)
	hooksecurefunc('LoadBindings', updateBindings)
end

function BindingsController:RegisterEvents()
	self:SetScript('OnEvent', self.OnEvent)

	self:RegisterEvent('PLAYER_REGEN_ENABLED')
	self:RegisterEvent('UPDATE_BINDINGS')
	self:RegisterEvent('PLAYER_LOGIN')
	self:RegisterEvent('CVAR_UPDATE')
	self:RegisterEvent("ACTIONBAR_UPDATE_STATE")
end

function BindingsController:OnEvent(event, ...)
	self[event](self, event, ...)
end

function BindingsController:UPDATE_BINDINGS(event)
	self:UnregisterEvent(event)
end

function BindingsController:PLAYER_REGEN_ENABLED()
	if self.__NeedsBindingUpdate then
		self:RequestUpdateBindings()
	end
end

function BindingsController:PLAYER_LOGIN()
	self:UpdateCastOnKeyPress()
	self:RequestUpdateBindings()
end

function BindingsController:CVAR_UPDATE(event, variableName)
	if variableName == 'ACTION_BUTTON_USE_KEY_DOWN' then
		self:UpdateCastOnKeyPress()
		self:RequestUpdateBindings()
	end
end

function BindingsController:ACTIONBAR_UPDATE_STATE()
	for button in pairs(self.surrogates) do
		if not button:GetChecked() then
			button:SetButtonState('NORMAL')
		end
	end
end

function BindingsController:Register(button, createSurrogate)
	if self.frames[button] then
		return
	end

	button:UnregisterEvent('UPDATE_BINDINGS')
	button:UpdateHotkey()

	if createSurrogate then
		self:CreateSurrogate(button)
	end

	self.frames[button] = true
end

function BindingsController:Unregister(button)
	if not self.frames[button] then
		return
	end

	local surrogate = self:HasSurrogate(button)

	if surrogate then
		self:FreeSurrogate(surrogate)
	end

	self.frames[button] = nil
end

function BindingsController:CreateSurrogate(button)
	if self.surrogates[button] then
		return
	end

	local surrogate = SurrogateButton:GetOrCreate()

	surrogate:SetParent(self)
	surrogate:SetOwner(button)
	surrogate:SetCastOnKeyPress(self:CastingOnKeyPress())

	self:SetFrameRef('frameToAdd', surrogate)

	self:Execute([[
		local frameToAdd = self:GetFrameRef('frameToAdd')

		for i, frame in pairs(myFrames) do
			if frame == frameToAdd then
				return
			end
		end

		table.insert(myFrames, frameToAdd)

		self:RunAttribute('LoadFrameBindings', #myFrames)
	]])

	self.surrogates[button] = surrogate

	return surrogate;
end

function BindingsController:FreeSurrogate(button)
	local surrogate = self.surrogates[button]

	if surrogate then
		self:SetFrameRef('frameToRemove', surrogate)

		self:Execute([[
			local frameToRemove = self:GetFrameRef('frameToRemove')

			for i, frame in ipairs(myFrames) do
				if frame == frameToRemove then
					local targetName = frameToRemove:GetAttribute('owner')

					self:RunAttribute('ClearOverrideBindings', self:RunAttribute('GetBindings', targetName))
					self:RunAttribute('ClearOverrideBindings', self:RunAttribute('GetClickBindings', targetName))

					table.remove(myFrames, i)
					return
				end
			end
		]])

		surrogate:Free()

		self.surrogates[button] = nil
	end
end

function BindingsController:HasSurrogate(button)
	return self.surrogates[button]
end

function BindingsController:RequestUpdateBindings()
	if not self.__UpdateBindings then
		self.__UpdateBindings = function()
			self.__WaitingToUpdateBindings = false
			self:UpdateBindings()
		end
	end

	if not self.__WaitingToUpdateBindings then
		self.__WaitingToUpdateBindings = true

		Timer_After(0.2, self.__UpdateBindings)
	end
end

function BindingsController:UpdateBindings()
	if InCombatLockdown() then
		self.__NeedsBindingUpdate = true
		return
	end

	self.__NeedsBindingUpdate = nil

	for button in pairs(self.frames) do
		button:UpdateHotkey()

		if self:HasSurrogate(button) then
			self:Execute([[ self:RunAttribute('LoadBindings') ]])
		end
	end
end

function BindingsController:UpdateCastOnKeyPress()
	local castingOnKeyPress = self:CastingOnKeyPress()

	for _, surrogate in pairs(self.surrogates) do
		surrogate:SetCastOnKeyPress(castingOnKeyPress)
	end
end

function BindingsController:CastingOnKeyPress()
	return GetCVarBool('ActionButtonUseKeyDown')
end

BindingsController:Load()


--[[ exports ]]--

Addon.BindingsController = BindingsController