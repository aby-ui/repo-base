local AddonName, Data = ...
local L = Data.L

local defaultSettings = {
	Enabled = true,
	Parent = "Button",
	Cooldown = {
		ShowNumber = true,
		FontSize = 12,
		FontOutline = "OUTLINE",
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1},
	},
	ActivePoints = 2,
	Points = {
		{
			Point = "TOPLEFT",
			RelativeFrame = "Spec",
			RelativePoint = "TOPLEFT",
		},
		{
			Point = "BOTTOMRIGHT",
			RelativeFrame = "Spec",
			RelativePoint = "BOTTOMRIGHT",
		}
	},
}

local options = function(location)
	return {
		CooldownTextSettings = {
			type = "group",
			name = L.Countdowntext,
			inline = true,
			order = 1,
			args = Data.AddCooldownSettings(location.Cooldown)
		}
	}
end

local spec_HighestActivePriority = BattleGroundEnemies:NewButtonModule({
	moduleName = "HighestPriorityAura",
	localizedModuleName = L.HighestPriorityAura,
	defaultSettings = defaultSettings,
	options = options,
	events = {"ShouldQueryAuras", "CareAboutThisAura", "BeforeFullAuraUpdate", "NewAura", "AfterFullAuraUpdate", "GotInterrupted", "UnitDied"},
	enabledInThisExpansion = true
})


function spec_HighestActivePriority:AttachToPlayerButton(playerButton)
	local frame = CreateFrame("frame", nil, playerButton)

	frame.PriorityAuras = {}
	frame.ActiveInterrupt = false
	frame.Icon = frame:CreateTexture(nil, 'BACKGROUND')
	frame.Icon:SetAllPoints()
	frame.Cooldown = BattleGroundEnemies.MyCreateCooldown(frame)
	frame.Cooldown:SetScript("OnCooldownDone", function(self)
		frame:Update()
	end)
	frame:HookScript("OnEnter", function(self)
		BattleGroundEnemies:ShowTooltip(self, function()
			BattleGroundEnemies:ShowAuraTooltip(playerButton, frame.DisplayedAura)
		end)
	end)

	frame:HookScript("OnLeave", function(self)
		if GameTooltip:IsOwned(frame) then
			GameTooltip:Hide()
		end
	end)

	frame:SetScript("OnSizeChanged", function(self, width, height)
		BattleGroundEnemies.CropImage(self.Icon, width, height)
	end)

	frame:Hide()

	function frame:MakeSureWeAreOnTop()
		local numPoints = self:GetNumPoints()
		local highestLevel = 0
		for i = 1, numPoints do
			local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(i)
			if relativeTo then
				local level = relativeTo:GetFrameLevel()
				if level and level > highestLevel then
					highestLevel = level
				end
			end
		end
		self:SetFrameLevel(highestLevel + 1)
	end

	function frame:Update()
		self:MakeSureWeAreOnTop()
		local highestPrioritySpell
		local currentTime = GetTime()

		local priorityAuras = self.PriorityAuras
		for i = 1, #priorityAuras do

			local priorityAura = priorityAuras[i]
			if not highestPrioritySpell or (priorityAura.Priority > highestPrioritySpell.Priority) then
				highestPrioritySpell = priorityAura
			end
		end
		if frame.ActiveInterrupt then
			if frame.ActiveInterrupt.expirationTime < currentTime then
				frame.ActiveInterrupt = false
			else
				if not highestPrioritySpell or (frame.ActiveInterrupt.Priority > highestPrioritySpell.Priority) then
					highestPrioritySpell = frame.ActiveInterrupt
				end
			end
		end

		if highestPrioritySpell then
			frame.DisplayedAura = highestPrioritySpell
			frame:Show()
			frame.Icon:SetTexture(highestPrioritySpell.icon)
			frame.Cooldown:SetCooldown(highestPrioritySpell.expirationTime - highestPrioritySpell.duration, highestPrioritySpell.duration)
		else
			frame.DisplayedAura = false
			frame:Hide()
		end
	end

	function frame:ApplyAllSettings()
		local moduleSettings = self.config
		self.Cooldown:ApplyCooldownSettings(moduleSettings.Cooldown, true, true, {0, 0, 0, 0.5})
		self:MakeSureWeAreOnTop()
	end

	function frame:Reset()
		self.ActiveInterrupt = false
		wipe(self.PriorityAuras)
		self:Update()
	end


	function frame:GotInterrupted(spellId, interruptDuration)
		self.ActiveInterrupt = {
			spellId = spellId,
			icon = GetSpellTexture(spellId),
			expirationTime = GetTime() + interruptDuration,
			duration = interruptDuration,
			Priority = BattleGroundEnemies:GetSpellPriority(spellId) or 4
		}
		self:Update()
	end

	function frame:CareAboutThisAura(unitID, filter, aura)
		return aura.Priority
	end

	function frame:ShouldQueryAuras(unitID, filter)
		return true -- we care about all auras
	end

	function frame:BeforeFullAuraUpdate(filter)
		--only wipe before the auras for the first filter come in, otherwise we wipe our buffs away ...
		if filter == "HELPFUL" then
			wipe(self.PriorityAuras)
		end
	end

	function frame:NewAura(unitID, filter, aura)
		if not aura.Priority then return end

		local ID = #self.PriorityAuras + 1

		aura.ID = ID
		self.PriorityAuras[ID] = aura
	end

	function frame:AfterFullAuraUpdate(filter)
		-- only update after the last filter is done
		if filter == "HARMFUL" then
			self:Update()
		end
	end

	function frame:UnitDied()
		self:Reset()
	end
	playerButton.HighestPriorityAura = frame
end

