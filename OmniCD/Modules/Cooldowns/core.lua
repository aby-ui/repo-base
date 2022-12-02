local E = select(2, ...):unpack()
local CD = E.Cooldowns

function CD:Enable()
	if self.enabled then
		return
	end

	self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)

	self.enabled = true
end

function CD:Disable()
	if not self.enabled then
		return
	end

	self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')

	wipe(self.totemGUIDS)
	wipe(self.petGUIDS)
	wipe(self.diedHostileGUIDS)
	wipe(self.dispelledHostileGUIDS)

	self.enabled = false
end
