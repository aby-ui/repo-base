local E, L, C = select(2, ...):unpack()

local P = E["Party"]
local spell_cdmod_aura_temp = E.spell_cdmod_aura_temp
local selfLimitedMinMaxReducer = E.selfLimitedMinMaxReducer
local spell_benevolentFaeMajorCD = E.spell_benevolentFaeMajorCD
local spell_symbolOfHopeMajorCD = E.spell_symbolOfHopeMajorCD
local BOOKTYPE_CATEGORY = E.BOOKTYPE_CATEGORY

function OmniCD_CooldownOnHide(self)
	if self:GetCooldownTimes() > 0 then
		return
	end

	local icon = self:GetParent()
	local spellID = icon.spellID

	local info = P.groupInfo[icon.guid]
	if not info then
		return
	end

	local active = info.active[spellID]
	if not active then
		return
	end



	local maxcharges = icon.maxcharges
	local charges = active.charges
	if maxcharges and charges then
		if charges + 1 < maxcharges then
			P:StartCooldown(icon, icon.duration, true)
			return
		else
			icon.Count:SetText(maxcharges)
		end
	end

	info.active[spellID] = nil
	icon.active = nil
	if not info.isDeadOrOffline then
		icon.icon:SetDesaturated(false)
	end

	local bar = icon:GetParent():GetParent()
	local key = bar.key
	if type(key) == "number" then
		icon:SetAlpha(E.db.icons.inactiveAlpha)

		if not P.displayInactive then
			P:SetIconLayout(bar)
		end
	else
		local statusBar = icon.statusBar
		if statusBar then
			icon:SetAlpha(E.db.extraBars[key].useIconAlpha and E.db.icons.inactiveAlpha or 1.0)
			P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_STOP")
		else
			icon:SetAlpha(E.db.icons.inactiveAlpha)
		end

		if key == "interruptBar" and P.rearrangeInterrupts then
			P:SetExIconLayout(key, true, true)
		end
	end
end

function P:ResetCooldown(icon)
	local info = self.groupInfo[icon.guid]
	if not info then
		return
	end

	local spellID = icon.spellID
	local active = info.active[spellID]
	if not active then
		return
	end

	if spellID == 45438 and E.db.icons.showForbearanceCounter then
		local timeLeft = self:GetDebuffDuration(info.unit, 41425)
		if timeLeft then
			self:StartCooldown(icon, timeLeft, nil, true)
			return
		end
	end

	local maxcharges = icon.maxcharges
	local charges = active.charges
	local statusBar = icon.statusBar
	if maxcharges and charges and charges + 1 < maxcharges then
		charges = charges + 1
		icon.Count:SetText(charges)
		icon.cooldown:SetDrawSwipe(false)
		icon.cooldown:SetHideCountdownNumbers(true)
		active.charges = charges
		if charges == 1 and statusBar and not E.db.extraBars[statusBar.key].hideBar then
			local castingBar = statusBar.CastingBar
			local startColor, startBGColor, startTextColor = P.CastingBarFrame_GetEffectiveStartColor(castingBar, true);
			castingBar:SetStatusBarColor(startColor:GetRGBA())
			castingBar.BG:SetVertexColor(startBGColor:GetRGBA())
			castingBar.Text:SetTextColor(startTextColor:GetRGB())
		end
	else
		icon.cooldown:Clear()
		if statusBar then
			self.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_FAILED")
		end
	end
end



local minDuration = E.TocVersion > 90100 and 120 or 180
function P:ResetAllIcons(reason)
	for _, info in pairs(self.groupInfo) do
		for spellID, icon in pairs(info.spellIcons) do
			if reason ~= "encounterEnd" or (not E.spell_noReset[spellID] and icon.duration >= minDuration) then
				local statusBar = icon.statusBar
				if icon.active then
					local maxcharges = icon.maxcharges
					if maxcharges then
						icon.Count:SetText(maxcharges)
					end

					info.active[spellID] = nil
					icon.active = nil
					if not info.isDeadOrOffline then
						icon.icon:SetDesaturated(false)
					end
					icon.cooldown:Clear()

					local bar = icon:GetParent():GetParent()
					local key = bar.key
					if statusBar then
						icon:SetAlpha(E.db.extraBars[key].useIconAlpha and E.db.icons.inactiveAlpha or 1.0)
						self.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_FAILED")
					else
						icon:SetAlpha(E.db.icons.inactiveAlpha)
					end
				end

				if info.preActiveIcons[spellID] then
					info.preActiveIcons[spellID] = nil
					if statusBar then
						self:SetExStatusBarColor(icon, statusBar.key)
					end
					icon.icon:SetVertexColor(1, 1, 1)
				end

				if icon.isHighlighted then
					self:RemoveHighlight(icon)
				end

				if reason == "joinedPvP" and spellID == 323436 then
					info.auras.purifySoulStacks = nil
					icon.Count:SetText("")
				end
			end
		end

		local f = info.bar
		if f.timer_inCombatTicker then
			f.timer_inCombatTicker:Cancel()
			f.timer_inCombatTicker = nil
		end
		if f.timer_ashenHallowTicker then
			f.timer_ashenHallowTicker:Cancel()
			f.timer_ashenHallowTicker = nil
		end

		if not self.displayInactive then
			self:SetIconLayout(info.bar)
		end
	end

	if E.db.extraBars.interruptBar.enabled and self.rearrangeInterrupts then
		self:SetExIconLayout("interruptBar", true, true)
	end
end

function P:SetCooldownElements(icon, charges, highlight)
	local hideBar = icon.statusBar and E.db.extraBars[icon.statusBar.key].hideBar
	local noCount = (icon.statusBar and not hideBar and true) or (charges and charges > 0) or highlight or not E.db.icons.showCounter
	icon.cooldown:SetDrawEdge(charges and charges > -1 or false)
	icon.cooldown:SetDrawSwipe( (not icon.statusBar or hideBar) and not highlight and (not charges or charges < 1) )
	icon.cooldown:SetHideCountdownNumbers(noCount)
	if E.OmniCC then
		icon.cooldown.noCooldownCount = noCount
	end
end

local function SetActiveIcon(icon, startTime, duration, charges, modRate)
	if E.OmniCC then
		if not P:HighlightIcon(icon) then
			P:SetCooldownElements(icon, charges)
		end
	end

	icon.cooldown:SetCooldown(startTime, duration, modRate)
end

function P:UpdateCooldown(icon, reducedTime, updateUnitBarCharges, auraMult)
	local info = self.groupInfo[icon.guid]
	if not info then
		return
	end

	local spellID = icon.spellID
	local active = info.active[spellID]
	if not active then
		return
	end

	local startTime = active.startTime
	local duration = active.duration


	local modRate = info.modRate or 1
	if BOOKTYPE_CATEGORY[icon.category] then
		if spellID == 329042 then
			if info.auras[spellID] then
				modRate = modRate * 5
			end
		else
			local majorCD = spell_symbolOfHopeMajorCD[spellID]
			if majorCD and (majorCD == true or majorCD == info.spec) and info.auras.symbol then
				modRate = modRate * info.auras.symbol
			end
			majorCD = spell_benevolentFaeMajorCD[spellID]
			if majorCD and (majorCD == true or majorCD == info.spec) and info.auras.benevolent then
				modRate = modRate * info.auras.benevolent
			end
		end
	elseif spellID == 300728 and info.auras.intimidation then
		modRate = 1/3
	end

	local statusBar = icon.statusBar

	if updateUnitBarCharges then
		if not self:HighlightIcon(icon, true) then
			self:SetCooldownElements(icon, updateUnitBarCharges)
		end
		if not statusBar or E.db.extraBars[statusBar.key].useIconAlpha then
			icon:SetAlpha(E.db.icons.activeAlpha)
		end

		icon.cooldown:SetCooldown(startTime, duration, modRate)
		icon.active = true

		return
	end




	reducedTime = reducedTime * modRate



	if auraMult then
		local now = GetTime()
		startTime = now - (now - startTime) * auraMult
		duration = duration * auraMult
		reducedTime = reducedTime * auraMult
	end

	startTime = startTime - reducedTime

	if active.charges then
		local overTime = GetTime() - startTime - duration
		if overTime > 0 and active.charges + 1 < icon.maxcharges then
			active.overTime = overTime
		end
	end

	icon.cooldown:SetCooldown(startTime, duration, modRate)
	active.startTime = startTime
	active.duration = duration
	active.totRate = modRate ~= 1 and modRate

	if statusBar then
		self.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and "UNIT_SPELLCAST_CHANNEL_UPDATE" or "UNIT_SPELLCAST_CAST_UPDATE")
	end
end

function P:StartCooldown(icon, cd, recharge, noGlow)
	local info = self.groupInfo[icon.guid]
	if not info then
		return
	end

	local spellID = icon.spellID

	info.active[spellID] = info.active[spellID] or {}

	local active = info.active[spellID]
	local charges = active.charges or icon.maxcharges
	local now = GetTime()


	local modRate = info.modRate or 1
	if BOOKTYPE_CATEGORY[icon.category] then

		if spellID == 329042 then
			if info.auras[spellID] then
				modRate = modRate * 5
			end
		else
			local majorCD = spell_symbolOfHopeMajorCD[spellID]
			if majorCD and (majorCD == true or majorCD == info.spec) and info.auras.symbol then
				modRate = modRate * info.auras.symbol
			end
			majorCD = spell_benevolentFaeMajorCD[spellID]
			if majorCD and (majorCD == true or majorCD == info.spec) and info.auras.benevolent then
				modRate = modRate * info.auras.benevolent
			end
		end

	elseif spellID == 300728 and info.auras.intimidation then
		modRate = 1/3
	end
	cd = cd * modRate


	local auraMult = spell_cdmod_aura_temp[spellID]
	if auraMult and info.auras[auraMult[3]] then
		cd = cd * auraMult[2]
	end

	if charges then
		if recharge then
			local overTime = active.overTime
			if overTime then
				now = now - overTime
			end
			active.overTime = nil

			charges = charges + 1
			SetActiveIcon(icon, now, cd, charges, modRate)
		elseif charges == icon.maxcharges then
			charges = charges - 1
			SetActiveIcon(icon, now, cd, charges, modRate)
		elseif charges == 0 then
			SetActiveIcon(icon, now, cd, charges, modRate)
		else
			charges = charges - 1
			now = active.startTime
			if E.OmniCC and charges == 0 or auraMult then
				SetActiveIcon(icon, now, cd, charges, modRate)
			end
		end

		icon.Count:SetText(charges)
		active.charges = charges
	else
		SetActiveIcon(icon, now, cd, charges, modRate)
	end

	active.startTime = now
	active.duration = cd
	active.totRate = modRate ~= 1 and modRate

	if selfLimitedMinMaxReducer[spellID] then
		active.numHits = 0
	end

	icon.active = true

	local bar = icon:GetParent():GetParent()
	local key = bar.key
	if type(key) == "number" then
		icon:SetAlpha(E.db.icons.activeAlpha)
		if not self.displayInactive then
			self:SetIconLayout(bar)
		end
	else
		local statusBar = icon.statusBar
		if statusBar then
			self:SetExStatusBarColor(icon, statusBar.key)
			self.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[key].reverseFill and "UNIT_SPELLCAST_CHANNEL_START" or "UNIT_SPELLCAST_START")
			if E.db.extraBars[key].useIconAlpha then
				icon:SetAlpha(E.db.icons.activeAlpha)
			end
		else
			icon:SetAlpha(E.db.icons.activeAlpha)
		end

		if key == "interruptBar" and self.rearrangeInterrupts then
			self:SetExIconLayout(key, true, true)
		end
	end

	if E.OmniCC and not icon.isHighlighted or (not E.OmniCC and not self:HighlightIcon(icon)) then
		if not recharge and not noGlow and E.db.highlight.glow then
			self:SetGlow(icon)
		end

		if not E.OmniCC then
			self:SetCooldownElements(icon, charges)
		end

		if not info.isDeadOrOffline then
			icon.icon:SetDesaturated(E.db.icons.desaturateActive and (not charges or charges == 0))
		end
	end
end
