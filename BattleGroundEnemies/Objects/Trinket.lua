local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L
local CreateFrame = CreateFrame
local GetTime = GetTime
local GetSpellTexture = GetSpellTexture
local GameTooltip = GameTooltip

local IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC

local defaultSettings = {
	Enabled = true,
	Parent = "Button",
	UseButtonHeightAsHeight = true,
	UseButtonHeightAsWidth = true,
	Cooldown = {
		ShowNumber = true,
		FontSize = 12,
		FontOutline = "OUTLINE",
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1},
	}
}

local options = function(location)
	return {
		CooldownTextSettings = {
			type = "group",
			name = L.Countdowntext,
			inline = true,
			order = 1,
			get = function(option)
				return Data.GetOption(location.Cooldown, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Cooldown, option, ...)
			end,
			args = Data.AddCooldownSettings(location.Cooldown)
		}
	}
end

local trinket = BattleGroundEnemies:NewButtonModule({
	moduleName = "Trinket",
	localizedModuleName = L.Trinket,
	defaultSettings = defaultSettings,
	options = options,
	events = {"ShouldQueryAuras", "CareAboutThisAura", "NewAura", "SPELL_CAST_SUCCESS"},
	enabledInThisExpansion = true
})

function trinket:AttachToPlayerButton(playerButton)

	local frame = CreateFrame("frame", nil, playerButton)
	-- trinket
	frame:HookScript("OnEnter", function(self)
		if self.spellId then
			BattleGroundEnemies:ShowTooltip(self, function()
				if IsClassic then return end
				GameTooltip:SetSpellByID(self.spellId)
			end)
		end
	end)

	frame:HookScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)


	frame.Icon = frame:CreateTexture()
	frame.Icon:SetAllPoints()
	frame:SetScript("OnSizeChanged", function(self, width, height)
		BattleGroundEnemies.CropImage(self.Icon, width, height)
	end)

	frame.Cooldown = BattleGroundEnemies.MyCreateCooldown(frame)


	function frame:TrinketCheck(spellId)
		if not Data.TrinketData[spellId] then return end
		self:DisplayTrinket(spellId, Data.TrinketData[spellId].itemID)
		if Data.TrinketData[spellId].cd then
			self:SetTrinketCooldown(GetTime(), Data.TrinketData[spellId].cd or 0)
		end
	end

	function frame:DisplayTrinket(spellId, itemID)
		local texture
		if(itemID and itemID ~= 0) then
			texture = GetItemIcon(itemID)
		else
			if spellId == 336139 then --adapted
				texture = GetSpellTexture(214027) --Adaptation
			else
				local spellTexture, spellTextureNoOverride = GetSpellTexture(spellId)
				texture = spellTextureNoOverride
			end
		end

		self.spellId = spellId
		self.Icon:SetTexture(texture)
	end

	function frame:SetTrinketCooldown(startTime, duration)
		if (startTime ~= 0 and duration ~= 0) then
			self.Cooldown:SetCooldown(startTime, duration)
		else
			self.Cooldown:Clear()
		end
	end

	function frame:ShouldQueryAuras(unitID, filter)
		return filter == "HARMFUL"
	end


	function frame:CareAboutThisAura(unitID, filter, aura)
		local spellId = aura.spellId
		if spellId == 336139 then return true end

		return not self.spellId and Data.cCdurationBySpellID[spellId]
	end


	function frame:NewAura(unitID, filter, aura)
		if filter == "HELPFUL" then return end

		local spellId = aura.spellId
		if spellId == 336139 then --adapted debuff > adaptation
			local currentTime = GetTime()
			self:DisplayTrinket(spellId)
			self:SetTrinketCooldown(currentTime, aura.expirationTime - currentTime)
			return -- we are done don't do relentless check
		end


		--BattleGroundEnemies:Debug(operation, spellId)
		local continue = not self.spellId and Data.cCdurationBySpellID[spellId]
		if not continue then return end

		local Racefaktor = 1
	--[[ 	if drCat == "stun" and playerButton.PlayerDetails.PlayerRace == "Orc" then
			--Racefaktor = 0.8	--Hardiness, but since september 5th hotfix hardiness no longer stacks with relentless so we have no way of determing if the player is running relentless or not
			return
		end ]]


		--local diminish = actualduraion/(Racefaktor * normalDuration * Trinketfaktor)
		--local trinketFaktor * diminish = duration/(Racefaktor * normalDuration)
		--trinketTimesDiminish = trinketFaktor * diminish
		--trinketTimesDiminish = without relentless : 1, 0.5, 0.25, with relentless: 0.8, 0.4, 0.2

		local trinketTimesDiminish = aura.duration/(Racefaktor * Data.cCdurationBySpellID[spellId])

		if trinketTimesDiminish == 0.8 or trinketTimesDiminish == 0.4 or trinketTimesDiminish == 0.2 then --Relentless
			self.spellId = 336128
			self.Icon:SetTexture(GetSpellTexture(196029))
		end
	end

	function frame:SPELL_CAST_SUCCESS(srcName, destName, spellId)
		self:TrinketCheck(spellId)
	end


	function frame:Reset()
		self.spellId = false
		self.Icon:SetTexture(nil)
		self.Cooldown:Clear()	--reset Trinket Cooldown
	end

	function frame:ApplyAllSettings()

		local moduleSettings = self.config
		self.Cooldown:ApplyCooldownSettings(moduleSettings.Cooldown, false, true, {0, 0, 0, 0.5})
	end
	playerButton.Trinket = frame
end