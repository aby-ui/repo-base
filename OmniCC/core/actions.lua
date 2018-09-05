--[[
	actions.lua
		Handles action buttons specific behaviour
--]]

local Actions = OmniCC:New('Actions', {visible = {}})
local Cooldown = OmniCC.Cooldown


--[[ API ]]--

function Actions:AddDefaults()
	for i, button in pairs(ActionBarButtonEventsFrame.frames) do
		self:Add(button.action, button.cooldown)
	end
end

function Actions:Add(action, cooldown)
	cooldown.omniccAction = action
	
	if not cooldown.omnicc then
		cooldown:HookScript('OnShow', Actions.OnShow)
		cooldown:HookScript('OnHide', Actions.OnHide)
		Cooldown.Setup(cooldown)
	end
end

function Actions:Update()
	for cooldown in pairs(self.visible) do
        local start, duration = GetActionCooldown(cooldown.omniccAction)
		local charges = GetActionCharges(cooldown.omniccAction)

        Cooldown.Start(cooldown, start, duration, charges)
    end
end


--[[ Events ]]--

function Actions:OnShow()
	Actions.visible[self] = true
end

function Actions:OnHide()
	Actions.visible[self] = nil
end