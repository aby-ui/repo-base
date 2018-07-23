--[[
	Opening and closing the SpellBookFrame triggers MultiActionBar_ShowAllGrids and MultiActionBar_HideAllGrids
	This code works around this behavior
--]]

local AddonName, Addon = ...
local MultiActionBarGridFixer = Addon:CreateHiddenFrame('Frame', nil, nil, 'SecureHandlerStateTemplate')

function MultiActionBarGridFixer:Load()
	--[[ load buttons ]]--
	do
		self:Execute([[ MY_BUTTONS = table.new() ]])

		for i, barName in pairs{'MultiBarBottomLeft', 'MultiBarBottomRight', 'MultiBarLeft', 'MultiBarRight'} do
			for j = 1, _G['NUM_MULTIBAR_BUTTONS'] do
				local button = _G[string.format('%sButton%d', barName, j)]

				self:SetFrameRef('addButton', button)
				self:Execute([[ table.insert(MY_BUTTONS, self:GetFrameRef('addButton')) ]])
			end
		end
	end


	--[[ register events ]]--

	local setAttribute = function(attributeName, value)
		if not InCombatLockdown() then
			self:SetAttribute(attributeName, value)
		end
	end

	local forceUpdate = function()
		setAttribute('state-update', true)
	end

	self:SetScript('OnEvent', function(self, event)
		if event == 'ACTIONBAR_SHOWGRID' then
			setAttribute('state-showGrid', true)
		elseif event == 'ACTIONBAR_HIDEGRID' then
			setAttribute('state-showGrid', false)
		else
			forceUpdate()
		end
	end)

	self:RegisterEvent('ACTIONBAR_SHOWGRID')
	self:RegisterEvent('ACTIONBAR_HIDEGRID')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('PLAYER_REGEN_ENABLED')
	self:RegisterEvent('PLAYER_REGEN_DISABLED')

	hooksecurefunc('MultiActionBar_ShowAllGrids', forceUpdate)

	hooksecurefunc('MultiActionBar_HideAllGrids', forceUpdate)


	--[[ initialize states ]]--

	self:SetAttribute('state-alwaysShow', false)
	self:SetAttribute('state-showGrid', false)


	--[[ handle events ]]--

	self:SetAttribute('_onstate-update', [[ self:RunAttribute('updateGrid') ]])
	self:SetAttribute('_onstate-alwaysShow', [[ self:RunAttribute('updateGrid') ]])
	self:SetAttribute('_onstate-showGrid', [[ self:RunAttribute('updateGrid') ]])

	self:SetAttribute('updateGrid', [[
		local showgrid = (self:GetAttribute('state-alwaysShow') or self:GetAttribute('state-showGrid')) and 1 or 0

		for i, button in pairs(MY_BUTTONS) do
			button:SetAttribute('showgrid', showgrid)

			local actionId = button:GetAttribute('action')
			local hasAction = actionId and HasAction(actionId) or false
			local gridVisible = button:GetAttribute('showgrid') >= 1
			local isHidden = button:GetAttribute('statehidden')

			if (hasAction or gridVisible) and (not isHidden) then
				button:Show(true)
			else
				button:Hide(true)
			end
		end
	]])

	Addon.MultiActionBarGridFixer = self
end

function MultiActionBarGridFixer:SetShowGrid(enable)
	self:SetAttribute('state-alwaysShow', enable and true or false)
end

MultiActionBarGridFixer:Load()