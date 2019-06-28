local _, Addon = ...

--[[
	This code works around empty action buttons appearing on the multi action
	buttons either because the user has set to always show blizzard slots, or
	because the user has opened the spellbook

	We do this via clearing specific showgrid reasons on all the buttons on
	each MultiActionBar whenever the showgrid value changes
--]]

local MultiBarFixer = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
MultiBarFixer:Hide()

if Addon:IsBuild("classic") then
	local bars = {
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"MultiBarLeft",
		"MultiBarRight"
	}

	SpellBookFrame:HookScript("OnShow", function() MultiBarFixer:UpdateGrid() end)
	SpellBookFrame:HookScript("OnHide", function() MultiBarFixer:UpdateGrid() end)

	MultiBarFixer:SetScript("OnEvent", function(self, event, ...)
		self[event](self, event, ...)
	end)

	MultiBarFixer:RegisterEvent("PLAYER_ENTERING_WORLD")
	MultiBarFixer:RegisterEvent("CVAR_UPDATE")
	MultiBarFixer:RegisterEvent("ACTIONBAR_SHOWGRID")
	MultiBarFixer:RegisterEvent("ACTIONBAR_HIDEGRID")
	MultiBarFixer.showgrid = 0

	function MultiBarFixer:CVAR_UPDATE(event, key, value)
		if key == "LOCK_ACTIONBAR_TEXT" then
			self:UpdateGrid()
		end
	end

	function MultiBarFixer:PLAYER_ENTERING_WORLD()
		self:UpdateGrid()
	end

	function MultiBarFixer:ACTIONBAR_SHOWGRID()
		self.showgrid = self.showgrid + 1
		self:UpdateGrid()
	end

	function MultiBarFixer:ACTIONBAR_HIDEGRID()
		self.showgrid = self.showgrid - 1
		self:UpdateGrid()
	end

	function MultiBarFixer:UpdateGrid()
		if InCombatLockdown() then return end

		local showgrid = self:GetShowgridState()

		for _, barName in pairs(bars) do
			for i = 1, 12 do
				local buttonName = ("%sButton%d"):format(barName, i)
				local button = _G[buttonName]
				if button then
					button:SetAttribute("showgrid", showgrid)
					Addon.ActionButton.UpdateGrid(button)
				end
			end
		end
	end

	function MultiBarFixer:GetShowgridState()
		local result = self.showgrid or 0

		if Addon:ShowGrid() then
			result = result + 1
		end

		if Addon:IsBindingModeEnabled() then
			result = result + 1
		end

		return result
	end
else
	-- adapted from http://lua-users.org/wiki/BitUtils
	MultiBarFixer:SetAttribute("ClearFlags", [[
		local set = ...

		for i = 2, select("#", ...) do
			local flag = select(i, ...)

			if set % (2 * flag) >= flag then
				set = set - flag
			end
		end

		return set
	]])

	-- clears the given show grid reasons
	local OnAttributeChanged = ([[
		if name == "showgrid" and value > 0 then
			value = control:RunAttribute("ClearFlags", value, %d, %d)

			if self:GetAttribute("showgrid") ~= value then
				self:SetAttribute("showgrid", value)
			end
		end
	]]):format(
		ACTION_BUTTON_SHOW_GRID_REASON_CVAR,
		ACTION_BUTTON_SHOW_GRID_REASON_SPELLBOOK
	)

	-- apply to every multi bar action button
	for _, barName in pairs{"MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarLeft", "MultiBarRight"} do
		for i = 1, NUM_MULTIBAR_BUTTONS do
			local buttonName = ("%sButton%d"):format(barName, i)
			local button = _G[buttonName]

			MultiBarFixer:WrapScript(button, "OnAttributeChanged", OnAttributeChanged)
		end
	end
end
