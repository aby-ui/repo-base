--[[
	modules.lua
		manages the plugable features
--]]


--[[ Effects ]]--

function OmniCC:TriggerEffect(cooldown)
	local id = self:GetGroupSettingsFor(cooldown).effect
	self:GetEffect(id):Run(cooldown)
end

function OmniCC:SetupEffect(cooldown)
	local id = self:GetGroupSettingsFor(cooldown).effect
	self:GetEffect(id):Setup(cooldown)
end

function OmniCC:RegisterEffect(effect)
	self.effects[effect.id] = effect
	return effect
end

function OmniCC:GetEffect(id)
	return self.effects[id]
end


--[[ Utilities ]]--

function OmniCC:GetButtonIcon(frame)
	if frame then
		local icon = frame.icon
		if type(icon) == 'table' and icon.GetTexture then
			return icon
		end

		local name = frame:GetName()
		if name then
			local icon = _G[name .. 'Icon'] or _G[name .. 'IconTexture']
			if type(icon) == 'table' and icon.GetTexture then
				return icon
			end
		end
	end
end

function OmniCC:GetUpdateEngine()
	return self[self.sets.engine]
end
