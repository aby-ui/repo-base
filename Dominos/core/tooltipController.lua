--------------------------------------------------------------------------------
-- This manual handles securely overriding tooltips
--------------------------------------------------------------------------------

local _, Addon = ...
local TooltipsModule = Addon:NewModule('Tooltips')

-- converts a truthy value to true/false
local function tobool(value)
	if value then
		return true
	end
	return false
end

local frame_OnEnter = [[
	if control:GetAttribute('keybound-enabled') then
		return true
	end

	if control:GetAttribute('tooltips-enabled') then
		return control:GetAttribute('tooltips-enabled-combat')
			or (not control:GetAttribute('state-combat'))
	end

	return false
]]

function TooltipsModule:OnInitialize()
    self.header = Addon:CreateHiddenFrame('Frame', nil, nil, 'SecureHandlerStateTemplate')

    RegisterStateDriver(self.header, 'combat', '[combat]1;nil')

    -- keybound support
    local kb = LibStub('LibKeyBound-1.0')

    kb.RegisterCallback(
        self,
        'LIBKEYBOUND_ENABLED',
        function()
            self.header:SetAttribute('keybound-enabled', true)
        end
    )

    kb.RegisterCallback(
        self,
        'LIBKEYBOUND_DISABLED',
        function()
            self.header:SetAttribute('keybound-enabled', false)
        end
    )
end

function TooltipsModule:OnEnable()
    self:SetShowTooltips(Addon:ShowTooltips())
    self:SetShowTooltipsInCombat(Addon:ShowCombatTooltips())
end

function TooltipsModule:Register(frame)
    -- track and reapply the IsMouseEnabled on the frame
    -- for some reason, wrapping the OnEnter handler of the frame causes
    -- the frame to have mouse support enabled (at least as of 9.0.1)
    local mouseEnabled = frame:IsMouseEnabled()

    self.header:WrapScript(frame, 'OnEnter', frame_OnEnter)

    frame:EnableMouse(mouseEnabled)
end

function TooltipsModule:Unregister(frame)
    local mouseEnabled = frame:IsMouseEnabled()

    self.header:UnwrapScript(frame, 'OnEnter')

    frame:EnableMouse(mouseEnabled)
end

function TooltipsModule:SetShowTooltips(enable)
    self.header:SetAttribute('tooltips-enabled', tobool(enable))
end

function TooltipsModule:SetShowTooltipsInCombat(enable)
    self.header:SetAttribute('tooltips-enabled-combat', tobool(enable))
end
