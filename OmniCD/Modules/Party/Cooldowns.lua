local E = select(2, ...):unpack()
local P = E.Party

local MIN_RESET_DURATION = E.TocVersion > 90100 and 120 or 180

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
	local currCharges = active.charges
	local statusBar = icon.statusBar
	if maxcharges and currCharges and currCharges + 1 < maxcharges then
		currCharges = currCharges + 1
		icon.count:SetText(currCharges)
		active.charges = currCharges
		P:SetCooldownElements(icon, currCharges)

		local castingBar = statusBar and not E.db.extraBars[statusBar.key].nameBar and currCharges == 1 and statusBar.castingBar
		if castingBar then
			local rechargeColor, rechargeBGColor, rechargeTextColor = self.CastingBarFrame_GetEffectiveStartColor(castingBar, true)
			castingBar:SetStatusBarColor(rechargeColor:GetRGBA())
			castingBar.BG:SetVertexColor(rechargeBGColor:GetRGBA())
			castingBar.Text:SetTextColor(rechargeTextColor:GetRGB())
		end
	else
		icon.cooldown:Clear()
		if statusBar then
			self.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, 'UNIT_SPELLCAST_FAILED')
		end
	end
end

function P:UpdateCooldown(icon, reducedTime, auraMult, isDFSpaghetti)
	local info = self.groupInfo[icon.guid]
	if not info then
		return
	end

	local active = info.active[icon.spellID]
	if not active then
		return
	end

	local startTime = active.startTime
	local duration = active.duration
	local modRate = active.iconModRate or 1






	if not E.isBFA and not isDFSpaghetti then
		reducedTime = reducedTime * modRate
	end

	local now = GetTime()
	if auraMult then
		local elapsed = (now - startTime) * auraMult
		startTime = now - elapsed
		duration = duration * auraMult
		reducedTime = reducedTime * auraMult
	end

	startTime = startTime - reducedTime

	if active.charges then
		local queuedCdrOnRecharge = now - startTime - duration
		if queuedCdrOnRecharge > 0 and active.charges + 1 < icon.maxcharges then
			active.queuedCdrOnRecharge = queuedCdrOnRecharge
		end
	end

	icon.cooldown:SetCooldown(startTime, duration, modRate)
	active.startTime = startTime
	active.duration = duration
	local statusBar = icon.statusBar
	if statusBar then
		self.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and 'UNIT_SPELLCAST_CHANNEL_UPDATE' or 'UNIT_SPELLCAST_CAST_UPDATE')
	end
end

function P:SetCooldownElements(icon, charges)
	local noSwipe = icon.isHighlighted or (icon.statusBar and not E.db.extraBars[icon.statusBar.key].nameBar) or (charges and charges > 0)
	local noCount = noSwipe or not E.db.icons.showCounter
	icon.cooldown:SetDrawEdge(charges and true)
	icon.cooldown:SetDrawSwipe(not noSwipe)
	icon.cooldown:SetHideCountdownNumbers(noCount)
	if E.OmniCC then
		icon.cooldown.noCooldownCount = noCount
	elseif icon.cooldown.timer then
		icon.cooldown.timer:SetShown(not noCount)
		icon.cooldown.timer.forceDisabled = noCount
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

function P:StartCooldown(icon, cd, isRecharge, noGlow)
	local info = self.groupInfo[icon.guid]
	if not info then
		return
	end

	local spellID = icon.spellID
	info.active[spellID] = info.active[spellID] or {}

	local active = info.active[spellID]
	local currCharges = active.charges or icon.maxcharges
	local now = GetTime()

	if info.auras.isGlimpseOfClarity then
		cd = cd - 3
	end

	local modRate = (E.BOOKTYPE_CATEGORY[icon.category] or E.spaghettiFix[spellID]) and info.modRate or 1

	local spellModRate = info.spellModRates[spellID]
	if spellModRate then
		modRate = modRate * spellModRate
	end


	cd = cd * modRate

	local auraMult = E.spell_cdmod_by_aura_mult[spellID]
	if auraMult then
		for i = 1, #auraMult, 2 do
			local auraKeyOrID = auraMult[i + 1]
			if info.auras[auraKeyOrID] then
				local mult = auraMult[i]
				if mult == 0 then
					return
				end
				mult = mult or info.auras[auraKeyOrID]
				cd = cd * mult
			end
		end
	end

	if currCharges then
		if isRecharge then
			local queuedCdr = active.queuedCdrOnRecharge
			if queuedCdr then
				now = now - queuedCdr
				active.queuedCdrOnRecharge = nil
			end
			currCharges = currCharges + 1
			SetActiveIcon(icon, now, cd, currCharges, modRate)
		elseif currCharges == icon.maxcharges then
			currCharges = currCharges - 1
			SetActiveIcon(icon, now, cd, currCharges, modRate)
		elseif currCharges == 0 then
			SetActiveIcon(icon, now, cd, currCharges, modRate)
		else
			currCharges = currCharges - 1
			now = active.startTime
			if E.OmniCC and currCharges == 0 or auraMult then
				SetActiveIcon(icon, now, cd, currCharges, modRate)
			end
		end
		icon.count:SetText(currCharges)
		active.charges = currCharges
	else
		SetActiveIcon(icon, now, cd, currCharges, modRate)
	end

	active.startTime = now
	active.duration = cd
	active.iconModRate = modRate ~= 1 and modRate or nil
	if E.selfLimitedMinMaxReducer[spellID] then
		active.numHits = 0
	end

	icon.active = true

	local frame = icon:GetParent():GetParent()
	local key = frame.key
	if type(key) == "number" then
		icon:SetAlpha(E.db.icons.activeAlpha)
		if not self.displayInactive then
			self:SetIconLayout(frame)
		end
	else
		local statusBar = icon.statusBar
		if statusBar then
			self:SetExStatusBarColor(icon, statusBar.key)
			self.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[key].reverseFill and 'UNIT_SPELLCAST_CHANNEL_START' or 'UNIT_SPELLCAST_START')
		else
			icon:SetAlpha(E.db.icons.activeAlpha)
		end
		if frame.shouldRearrangeInterrupts then
			self:SetExIconLayout(key, true, true)
		end
	end

	if E.OmniCC and not icon.isHighlighted or (not E.OmniCC and not self:HighlightIcon(icon)) then
		if not isRecharge and not noGlow and E.db.highlight.glow then
			self:SetGlow(icon)
		end
		if not E.OmniCC then
			self:SetCooldownElements(icon, currCharges)
		end
		if not info.isDeadOrOffline then
			icon.icon:SetDesaturated(E.db.icons.desaturateActive and (not currCharges or currCharges == 0))
		end
	end

	if E.isBFA and icon.guid == E.userGUID and self.isInPvPInstance and spellID == info.talentData["essStrivedPvpID"] then
		E.TimerAfter(2, E.Comm.SendStrivePvpTalentCD, spellID)
	end
end


function P:ResetAllIcons(reason)
	for guid, info in pairs(self.groupInfo) do
		for spellID, icon in pairs(info.spellIcons) do
			if reason ~= "encounterEnd" or (not E.spell_noreset_onencounterend[spellID] and icon.duration >= MIN_RESET_DURATION) then
				local statusBar = icon.statusBar
				if icon.active then

					info.active[spellID] = nil
					icon.active = nil

					local maxcharges = icon.maxcharges
					if maxcharges then
						icon.count:SetText(maxcharges)
					end
					if not info.isDeadOrOffline then
						icon.icon:SetDesaturated(false)
					end

					icon.cooldown:Clear()
					if statusBar then
						self.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, 'UNIT_SPELLCAST_FAILED')
					else
						icon:SetAlpha(E.db.icons.inactiveAlpha)
					end
				elseif info.preactiveIcons[spellID] then
					info.preactiveIcons[spellID] = nil
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
					icon.count:SetText("")
				end
			end
		end

		for _, timer in pairs(info.callbackTimers) do
			if type(timer) == "table" then
				timer:Cancel()
			end
		end
		self.groupInfo[guid].callbackTimers = {}

		if not self.displayInactive then
			self:SetIconLayout(info.bar)
		end
	end

	if self.extraBars.raidBar0.shouldRearrangeInterrupts then
		self:SetExIconLayout("raidBar0", true, true)
	end
end
