--[[
	script.lua
		Fires timers using the OnUpdate script
--]]

local ScriptUpdater = OmniCC:New('ScriptUpdater')
ScriptUpdater.updaters = {}


--[[ Constructor ]]--

function ScriptUpdater:Get(frame)
	return self:GetActive(frame) or self:New(frame)
end

function ScriptUpdater:GetActive(frame)
	return self.updaters[frame]
end

function ScriptUpdater:New(frame)
	local updater = self:Bind(CreateFrame('Frame', nil))
	updater:Hide()
	updater:SetScript('OnUpdate', updater.OnUpdate)
	updater.frame = frame

	self.updaters[frame] = updater
	return updater
end


--[[ Events ]]--

function ScriptUpdater:OnUpdate(elapsed)
	local delay = self.delay and (self.delay - elapsed) or 0
	if delay > 0 then
		self.delay = delay
	else
		self:OnFinished()
	end
end

function ScriptUpdater:OnFinished()
	self:Cleanup()
	self.frame:UpdateText()
end


--[[ Controls ]]--

function ScriptUpdater:ScheduleUpdate(delay)
	if delay > 0 then
		self.delay = delay
		self:Show()
	else
		self:OnFinished()
	end
end

function ScriptUpdater:CancelUpdate()
	self:Cleanup()
end

function ScriptUpdater:Cleanup()
	self:Hide()
	self.delay = nil
end