local _, Addon = ...
if not Addon:IsBuild('retail', 'wrath') then
    return
end

local OverrideController = Addon:CreateHiddenFrame('Frame', nil, UIParent, 'SecureHandlerStateTemplate')

local overrideBarStates = {
	form = '[form]1;0',
	overridebar = '[overridebar]1;0',
	possessbar = '[possessbar]1;0',
	sstemp = '[shapeshift]1;0',
	vehicle = '[@vehicle,exists]1;0',
	vehicleui = '[vehicleui]1;0'
}

function OverrideController:OnLoad()
	-- Override UI Detection
	local watcher = CreateFrame('Frame', nil, OverrideActionBar, 'SecureHandlerShowHideTemplate')

	watcher:SetFrameRef('controller', self)

	watcher:SetAttribute('_onshow', [[
		self:GetFrameRef('controller'):SetAttribute('state-isoverrideuishown', true)
	]])

	watcher:SetAttribute('_onhide', [[
		self:GetFrameRef('controller'):SetAttribute('state-isoverrideuishown', false)
	]])

	self.overrideUIWatcher = watcher

	self:SetAttribute('_onstate-isoverrideuishown', [[
		self:RunAttribute('updateOverrideUI')
	]])

	self:SetAttribute('_onstate-useoverrideui', [[
		self:RunAttribute('updateOverrideUI')
	]])

	self:SetAttribute('_onstate-overrideui', [[
		for i, frame in pairs(myFrames) do
			frame:SetAttribute('state-overrideui', newstate)
		end
	]])

	self:SetAttribute('updateOverrideUI', [[
		local isOverrideUIVisible = self:GetAttribute('state-useoverrideui') and self:GetAttribute('state-isoverrideuishown')

		self:SetAttribute('state-overrideui', isOverrideUIVisible)
	]])

	--[[
		Pet Battle UI Detection
	--]]

	self:SetAttribute('_onstate-petbattleui', [[
		local hasPetBattleUI = newstate == 1

		for i, frame in pairs(myFrames) do
			frame:SetAttribute('state-petbattleui', hasPetBattleUI)
		end
	]])

	--[[
		Override Page State Detection
	--]]

	self:SetAttribute('_onstate-overridepage', [[
		local overridePage = newstate or 0

		for i, frame in pairs(myFrames) do
			frame:SetAttribute('state-overridepage', overridePage)
		end
	]])

	for state in pairs(overrideBarStates) do
		self:SetAttribute('_onstate-' .. state, [[
			self:RunAttribute('updateOverridePage')
		]])
	end

	self:SetAttribute('updateOverridePage', [[
		local newPage

		if HasVehicleActionBar and HasVehicleActionBar() then
			newPage = GetVehicleBarIndex() or 0
		elseif HasOverrideActionBar and HasOverrideActionBar() then
			newPage = GetOverrideBarIndex() or 0
		elseif HasTempShapeshiftActionBar and HasTempShapeshiftActionBar() then
			newPage = GetTempShapeshiftBarIndex() or 0
		else
			newPage = 0
		end

		self:SetAttribute('state-overridepage', newPage)
	]])

	--[[
		Initialization
	--]]

	self:Execute([[ myFrames = table.new() ]])

	self:SetAttribute('state-isoverrideuishown', self.overrideUIWatcher:IsVisible() and true)

	RegisterStateDriver(self, 'petbattleui', '[petbattle]1;0')

	for state, values in pairs(overrideBarStates) do
		RegisterStateDriver(self, state, values)
	end

	self.OnLoad = nil
end

function OverrideController:Add(frame)
	self:SetFrameRef('FrameToRegister', frame)

	self:Execute([[
		local frame = self:GetFrameRef('FrameToRegister')

		table.insert(myFrames, frame)
	]])

	-- OnLoad states
	frame:SetAttribute('state-overrideui', self:GetAttribute('state-overrideui'))
	frame:SetAttribute('state-petbattleui', tonumber(self:GetAttribute('state-petbattleui')) == 1)
	frame:SetAttribute('state-overridepage', self:GetAttribute('state-overridepage') or 0)
end

function OverrideController:Remove(frame)
	self:SetFrameRef('FrameToUnregister', frame)

	self:Execute([[
		local frameToUnregister = self:GetFrameRef('FrameToUnregister')
		for i, frame in pairs(myFrames) do
			if frame == frameToUnregister then
				table.remove(myFrames, i)
				break
			end
		end
	]])
end

-- returns true if the player is in a state where they should be using actions
-- normally found on the override bar
function OverrideController:OverrideBarActive()
	return (self:GetAttribute('state-overridepage') or 0) > 10
end

OverrideController:OnLoad()

-- exports
Addon.OverrideController = OverrideController
