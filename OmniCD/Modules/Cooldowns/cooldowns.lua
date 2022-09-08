

local E, L, C = select(2, ...):unpack()

local _G = _G
local pairs, type = pairs, type
local abs = math.abs
local GetTime = GetTime
local band = bit.band
local mine = COMBATLOG_OBJECT_AFFILIATION_MINE
local player = COMBATLOG_OBJECT_TYPE_PLAYER
local guardianTotem = COMBATLOG_OBJECT_TYPE_GUARDIAN
local pet = COMBATLOG_OBJECT_TYPE_PET
local friendly = COMBATLOG_OBJECT_REACTION_FRIENDLY
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local UnitHealthMax = UnitHealthMax
local CD = E["Cooldowns"]
local P = E["Party"]
local groupInfo = P.groupInfo
local spell_highlighted = E.spell_highlighted
local spell_linked = E.spell_linked
local spell_merged = E.spell_merged
local spell_preactive = E.spell_preactive
local spell_updateOnCast = E.spell_updateOnCast
local spell_shared_cds = E.spell_shared_cds
local spell_benevolentFaeMajorCD = E.spell_benevolentFaeMajorCD
local spell_symbolOfHopeMajorCD = E.spell_symbolOfHopeMajorCD
local spell_cdmod_aura_temp = E.spell_cdmod_aura_temp
local spell_majorCD = E.spell_majorCD
local aura_free_spender = E.aura_free_spender
local cd_start_aura_removed = E.cd_start_aura_removed
local processSpell_aura_applied = E.processSpell_aura_applied
local cd_start_dispels = E.cd_start_dispels
local cd_reset_cast = E.cd_reset_cast
local cd_reduce_cast = E.cd_reduce_cast
local cd_reduce_powerSpenders = E.cd_reduce_powerSpenders
local cd_reduce_damage = E.cd_reduce_damage
local cd_reduce_damage_totem = E.cd_reduce_damage_totem
local cd_reduce_damage_pet = E.cd_reduce_damage_pet
local cd_reduce_energize = E.cd_reduce_energize
local cd_reduce_interrupts = E.cd_reduce_interrupts
local cd_disable_aura_applied = E.cd_disable_aura_applied
local covenant_abilities = E.covenant_abilities
local covenant_IDToSpellID = E.covenant_IDToSpellID
local RemoveHighlight = P.RemoveHighlight
local userGUID = E.userGUID
local BOOKTYPE_CATEGORY = E.BOOKTYPE_CATEGORY
local FORBEARANCE_DURATION = E.isPreWOTLKC and (E.isWOTLKC and 120 or 60) or 30
local SOULBIND_PODTENDER = 319217

local _
local isUserDisabled
local isHighlightEnabled

local totemGUIDS = {}
local petGUIDS = {}
local diedDestGUIDS = {}
local dispelledDestGUIDS = {}

local registeredEvents = setmetatable({}, {__index = function(t, k)
	t[k] = {}
	return t[k]
end})

local registeredUserEvents = setmetatable({}, {__index = function(t, k)
	t[k] = {}
	return t[k]
end})

local registeredHostileEvents = setmetatable({}, {__index = function(t, k)
	t[k] = {}
	return t[k]
end})

function CD:UpdateCombatLogVar()
	isUserDisabled = P.isUserDisabled
	isHighlightEnabled = E.db.highlight.glowBuffs
end

local function GetHolyWordRT(info, guid, reducedTime)
	if type(reducedTime) == "table" then
		reducedTime = P:IsTalent(reducedTime[1], guid) and reducedTime[2] or reducedTime[3]
	end

	local rankValue = info.talentData[338345]
	if rankValue then
		reducedTime = reducedTime * rankValue
	end

	if info.auras.isApotheosisActive then
		reducedTime = reducedTime * 4
	end


	if info.auras.isDivineConversation then
		reducedTime = reducedTime + (P.isPvP and 10 or 15)
	end

	return reducedTime
end

local function UpdateCdByReducer(info, guid, t, isHolyPriest)
	local talent, duration, target, base, aura, notalent = t[1], t[2], t[3], t[4], t[5], t[6]
	if (aura and not info.auras[aura]) or (notalent and info.talentData[notalent]) then
		return
	end

	local isTalent = P:IsTalent(talent, guid) or talent == info.spec
	if not target then
		if isTalent then
			for id in pairs(info.active) do
				if id ~= 1856 then
					local icon = info.spellIcons[id]
					if icon and (BOOKTYPE_CATEGORY[icon.category] or icon.category == "COVENANT")then
						P:UpdateCooldown(icon, P.isPvP and 10 or duration)
					end
				end
			end
		end
	elseif type(target) == "table" then
		if isTalent then
			for k, reducedTime in pairs(target) do
				local icon = info.spellIcons[k]
				if icon and icon.active then
					P:UpdateCooldown(icon, isHolyPriest and GetHolyWordRT(info, guid, reducedTime) or reducedTime)
				end
			end
		end
	else
		local icon = info.spellIcons[target]
		if icon and icon.active then
			local reducedTime = isTalent and duration or base
			if reducedTime then
				P:UpdateCooldown(icon, isHolyPriest and GetHolyWordRT(info, guid, reducedTime) or reducedTime)
			end
		end
	end
end

local function UpdateCdBySpender(info, guid, t, isTrueBearing)
	local talent, duration, target, base, aura, noaura = t[1], t[2], t[3], t[4], t[5], t[6]
	if (aura and not info.auras[aura]) or (noaura and info.auras[noaura]) then
		return
	end

	if type(target) == "table" then
		local reducedTime = P:IsTalent(talent, guid) and P:GetValueByType(duration, guid)
		if reducedTime then
			for i = 1, #target do
				local k = target[i]
				local icon = info.spellIcons[k]
				if icon and icon.active and (k ~= 107574 or not info.talentData[k]) then
					P:UpdateCooldown(icon, isTrueBearing and reducedTime * 2 or reducedTime)
				end
			end
		end
	else
		local icon = info.spellIcons[target]
		if icon and icon.active then
			local reducedTime = P:IsTalent(talent, guid) and P:GetValueByType(duration, guid) or base
			if reducedTime then
				P:UpdateCooldown(icon, isTrueBearing and reducedTime * 2 or reducedTime)
			end
		end
	end
end

local function ProcessSpell(spellID, guid)
	local info = groupInfo[guid]
	if not info then
		return
	end

	if guid ~= userGUID and not E.Comms.syncGUIDS[guid] then
		local covenantID = covenant_abilities[spellID]
		if covenantID then
			P.loginsessionData[guid] = P.loginsessionData[guid] or {}

			local currentCovenantID = P.loginsessionData[guid].covenantID
			if covenantID ~= currentCovenantID then
				if currentCovenantID then
					local currentCovenantSpellID = covenant_IDToSpellID[currentCovenantID]
					P.loginsessionData[guid][currentCovenantSpellID] = nil
					info.talentData[currentCovenantSpellID] = nil
					if currentCovenantID == 3 then

						info.talentData[SOULBIND_PODTENDER] = nil
					end
				end

				local covenantSpellID = covenant_IDToSpellID[covenantID]
				P.loginsessionData[guid][covenantSpellID] = "C"
				P.loginsessionData[guid].covenantID = covenantID
				info.talentData[covenantSpellID] = "C"
				info.shadowlandsData.covenantID = covenantID

				if spellID == SOULBIND_PODTENDER then

					info.talentData[spellID] = 0
				end

				P:UpdateUnitBar(guid)
			elseif spellID == SOULBIND_PODTENDER and not info.talentData[spellID] then

				info.talentData[spellID] = 0

				P:UpdateUnitBar(guid)
			end
		end
	end

	local mergedID = spell_merged[spellID]

	local linked = spell_linked[mergedID or spellID]
	if linked then
		for i = 1, #linked do
			local k = linked[i]
			local icon = info.spellIcons[k]
			if icon then

				if isHighlightEnabled and mergedID and k == mergedID then
					icon.buff = spellID
				end

				P:StartCooldown(icon, icon.duration)

				if E.isPreWOTLKC then
					info.active[k].castedLink = mergedID or spellID
				end
			end
		end

		return
	end

	local mergedIcon = mergedID and info.spellIcons[mergedID]
	local icon = info.spellIcons[spellID] or mergedIcon
	if icon then

		if isHighlightEnabled and mergedIcon then
			icon.buff = spellID
		end

		if spell_preactive[spellID] then
			local statusBar = icon.statusBar
			if icon.active then
				if statusBar then
					P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_STOP")
				end
				icon.cooldown:Clear()
			end

			if statusBar then
				if E.db.extraBars[statusBar.key].useIconAlpha then
					icon:SetAlpha(E.db.icons.activeAlpha)
				end
				statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
			else
				icon:SetAlpha(E.db.icons.activeAlpha)
			end
			info.preActiveIcons[spellID] = icon

			if not P:HighlightIcon(icon) then
				icon.icon:SetVertexColor(0.4, 0.4, 0.4)
			end


			if spellID == 5384 then
				info.bar:RegisterUnitEvent("UNIT_AURA", info.unit)
			end

			return
		end

		local updateSpell = spell_updateOnCast[spellID]
		if updateSpell then
			local cd = updateSpell[1]

			cd = mergedID == 272651 and info.talentData[356962] and cd/2 or cd
			icon.icon:SetTexture(updateSpell[2])
			P:StartCooldown(icon, cd)

			return
		end

		P:StartCooldown(icon, icon.duration)
	end

	local shared = spell_shared_cds[spellID]
	if shared then
		local now = GetTime()
		for i = 1, #shared, 2 do
			local id = shared[i]
			local sharedCD = shared[i+1]
			local icon = info.spellIcons[id]
			if icon then
				local active = icon.active and info.active[id]
				if not active or (active.startTime + active.duration - now < sharedCD) then
					P:StartCooldown(icon, sharedCD)
				end

				if not E.isPreWOTLKC then
					return
				end
			end
		end

		return
	end

	local reset = cd_reset_cast[spellID]
	if reset then
		for i = 1, #reset do
			local k = reset[i]
			if i > 1 then
				if k == "*" then
					for id in pairs(info.active) do
						if id ~= spellID and (not E.isWOTLKC or id ~= 19574) then
							local icon = info.spellIcons[id]
							if icon and icon.active and BOOKTYPE_CATEGORY[icon.category] then
								P:ResetCooldown(icon)
							end
						end
					end

					break
				end

				if type(k) == "table" then
					if P:IsTalent(k[1], guid) then
						for j = 2, #k do
							local id = k[j]
							local icon = info.spellIcons[id]
							if icon and icon.active then
								P:ResetCooldown(icon)
							end
						end
					end
				else
					local icon = info.spellIcons[k]
					if icon and icon.active then
						if E.isPreWOTLKC and info.active[k].castedLink then
							if k == info.active[k].castedLink then
								for i = 1, #spell_linked[k] do
									local id = spell_linked[k][i]
									local icon = info.spellIcons[id]
									if icon and icon.active then
										P:ResetCooldown(icon)
									end
								end
							end
						else
							P:ResetCooldown(icon)
						end
					end
				end
			elseif k and not P:IsTalent(k, guid) then
				break
			end
		end

	end


	local reducer = cd_reduce_cast[spellID]
	if reducer then
		local isHolyPriest = info.class == "PRIEST"
		if type(reducer[1]) == "table" then
			for i = 1, #reducer do
				local t = reducer[i]
				UpdateCdByReducer(info, guid, t, isHolyPriest)
			end
		else
			UpdateCdByReducer(info, guid, reducer, isHolyPriest)
		end
	end


	local spender = cd_reduce_powerSpenders[spellID]
	if spender then
		local isTrueBearing = info.auras.isTrueBearing
		if type(spender[1]) == "table" then
			for i = 1, #spender do
				local v = spender[i]
				UpdateCdBySpender(info, guid, v, isTrueBearing)
			end
		else
			UpdateCdBySpender(info, guid, spender, isTrueBearing)
		end
	end
end


local function RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	if isHighlightEnabled and destGUID == srcGUID then
		local icon = info.glowIcons[spellID]
		if icon then
			RemoveHighlight(P, icon)
		end
	end
end

for k in pairs(spell_highlighted) do
	registeredEvents.SPELL_AURA_REMOVED[k] = RemoveHighlightByCLEU
end

function CD:RegisterRemoveHighlightByCLEU(spellID)
	if not registeredEvents.SPELL_AURA_REMOVED[spellID] then
		registeredEvents.SPELL_AURA_REMOVED[spellID] = RemoveHighlightByCLEU
	end
end


for k, v in pairs(aura_free_spender) do
	registeredEvents.SPELL_AURA_REMOVED[k] = function(info, srcGUID, spellID, destGUID)
		info.auras[v] = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
	registeredEvents.SPELL_AURA_APPLIED[k] = function(info, srcGUID)
		info.auras[v] = k

	end
end


local function StartCdOnAuraRemoved(info, srcGUID, spellID, destGUID)
	if srcGUID == destGUID then
		spellID = cd_start_aura_removed[spellID]
		local icon = info.spellIcons[spellID]
		if icon then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preActiveIcons[spellID] = nil
			icon.icon:SetVertexColor(1, 1, 1)

			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)

			P:StartCooldown(icon, icon.duration)
		end
	end
end

for k, v in pairs(cd_start_aura_removed) do
	registeredEvents.SPELL_AURA_REMOVED[k] = StartCdOnAuraRemoved
end


local function ProcessSpellOnAuraApplied(info, srcGUID, spellID)
	spellID = processSpell_aura_applied[spellID]

	ProcessSpell(spellID, srcGUID)
end

for k in pairs(processSpell_aura_applied) do
	registeredEvents.SPELL_AURA_APPLIED[k] = ProcessSpellOnAuraApplied
end


do
	local function ReduceCdByDamage(info, srcGUID, spellID, destGUID, critical)
		local t = cd_reduce_damage[spellID]
		local talent, duration, target, maxLimit, minLimit, crit, internalCD = t[1], t[2], t[3], t[4], t[5], t[6], t[7]
		if crit then
			if not critical then
				return
			elseif spellID == 257542 and info.auras.phoenixFlameTargetGUID ~= destGUID then
				return
			end
		end

		local isTalent = P:IsTalent(talent, srcGUID)
		if isTalent then
			local icon = info.spellIcons[target]
			local active = icon and icon.active and info.active[target]
			if active then
				if maxLimit then
					active.numHits = (active.numHits or 0) + 1
					if active.numHits > maxLimit then
						return
					end
				elseif minLimit then
					active.numHits = (active.numHits or 0) + 1
					if active.numHits ~= minLimit then
						return
					end
				elseif internalCD then
					local now = GetTime()
					if now <= (active.nextTick or 0) then
						return
					end
					active.nextTick = now + internalCD
				end
				P:UpdateCooldown(icon, duration == 0 and isTalent or duration)
			end
		end
	end

	for k in pairs(cd_reduce_damage) do
		registeredEvents.SPELL_DAMAGE[k] = ReduceCdByDamage
	end


	registeredEvents.SPELL_DAMAGE[320752] = function(info, srcGUID, spellID, destGUID, critical)
		E.TimerAfter(0.05, ReduceCdByDamage, info, srcGUID, spellID, destGUID, critical)
	end

	registeredEvents.SPELL_HEAL[320751] = function(info, srcGUID, spellID, destGUID, _,_,_,_,_, criticalHeal)
		E.TimerAfter(0.05, ReduceCdByDamage, info, srcGUID, spellID, destGUID, criticalHeal)
	end



	registeredEvents.SPELL_CAST_SUCCESS[6343] = function(info)
		if info.talentData[335229] then
			local active = info.active[1160]
			if active then
				active.numHits = 0
			end
		end
	end


	registeredEvents.SPELL_CAST_SUCCESS[322729] = function(info)
		if info.talentData[337264] then
			local active = info.active[132578]
			if active then
				active.numHits = 0
			end
		end
	end
end


local function ReduceCdByEnergize(info, srcGUID, spellID)
	local t = cd_reduce_energize[spellID]
	local talent, duration, target, mult = t[1], t[2], t[3], t[4]
	local isTalent = P:IsTalent(talent, srcGUID)
	if isTalent then
		local icon = info.spellIcons[target]
		if icon and icon.active then
			P:UpdateCooldown(icon, duration == 0 and (mult and isTalent * mult or isTalent) or duration)
		end
	end
end

for k in pairs(cd_reduce_energize) do
	registeredEvents.SPELL_ENERGIZE[k] = ReduceCdByEnergize
end


local function ReduceCdByInterrupt(info, srcGUID, spellID)
	local t = cd_reduce_interrupts[spellID]
	local talent, duration, target, mult = t[1], t[2], t[3], t[4]
	local isTalent = P:IsTalent(talent, srcGUID)
	if isTalent then
		if type(target) == "table" then
			for k, reducedTime in pairs(target) do
				local icon = info.spellIcons[k]
				if icon and icon.active then
					P:UpdateCooldown(icon, reducedTime)
				end
			end
		else
			local icon = info.spellIcons[target]
			if icon and icon.active then
				P:UpdateCooldown(icon, duration == 0 and (mult and isTalent * mult or isTalent) or duration)
			end
		end
	end
end

for k in pairs(cd_reduce_interrupts) do
	registeredEvents.SPELL_INTERRUPT[k] = ReduceCdByInterrupt
end





do
	local BLOOD_TAP = 221699
	local DANCING_RUNE_WEAPON = 49028

	registeredEvents.SPELL_AURA_APPLIED_DOSE[195181] = function(info, _,_,_,_,_,_, amount)
		if amount and (info.spellIcons[BLOOD_TAP] or info.spellIcons[DANCING_RUNE_WEAPON]) then
			info.auras.numBoneShields = amount
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[219809] = function(info)
		local numShields = info.auras.numBoneShields
		if not numShields or numShields == 1 then
			return
		end

		local consumed = math.min(5, numShields)

		local icon = info.spellIcons[BLOOD_TAP]
		if icon and icon.active then
			P:UpdateCooldown(icon, 2 * consumed)
		end

		if info.talentData[334525] then
			local icon = info.spellIcons[DANCING_RUNE_WEAPON]
			if icon and icon.active then
				P:UpdateCooldown(icon, 5 * consumed)
			end
		end
	end

	local function ReduceBloodTapDancingRuneWeaponCD(info, _,_,_,_,_,_, amount)
		local numShields = info.auras.numBoneShields
		if not numShields then
			return
		end

		amount = amount or 0
		info.auras.numBoneShields = amount

		local consumed = numShields - amount
		if consumed > 1 or consumed < 1 then
			return
		end

		local icon = info.spellIcons[BLOOD_TAP]
		if icon and icon.active then
			P:UpdateCooldown(icon, 2)
		end

		if info.talentData[334525] then
			local icon = info.spellIcons[DANCING_RUNE_WEAPON]
			if icon and icon.active then
				P:UpdateCooldown(icon, 5)
			end
		end
	end
	registeredEvents.SPELL_AURA_REMOVED_DOSE[195181] = ReduceBloodTapDancingRuneWeaponCD
	registeredEvents.SPELL_AURA_REMOVED[195181] = ReduceBloodTapDancingRuneWeaponCD
end


do
	registeredEvents.SPELL_AURA_APPLIED[334722] = function(info)
		local icon = info.spellIcons[49576]
		if icon and icon.active then
			P:ResetCooldown(icon)
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[334722] = function(info)
		local icon = info.spellIcons[49576]
		if icon then
			P:StartCooldown(icon, icon.duration)
		end
	end
end


registeredEvents.SPELL_ENERGIZE[195757] = function(info)
	local rankValue = info.talentData[338553]
	if rankValue then
		local icon = info.spellIcons[275699]
		if icon and icon.active then
			P:UpdateCooldown(icon, rankValue)
		end
	end
end





registeredEvents.SPELL_AURA_APPLIED[212800] = function(info)
	if info.talentData[205411] then
		local icon = info.spellIcons[198589]
		if icon and not icon.active then
			P:StartCooldown(icon, icon.duration/2)
		end
	end
end


do
	registeredEvents.SPELL_HEAL[203794] = function(info)
		if info.isSoulCleave then
			info.isSoulCleave = false
		end

		if info.talentData[218612] then
			local icon = info.spellIcons[203720]
			if icon and icon.active then
				P:UpdateCooldown(icon, 0.5)
			end
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[228477] = function(info)
		if info.talentData[337547] and info.spellIcons[204021] then
			info.isSoulCleave = true
		end
	end

	local function ReduceFieryBrandCD(info)
		if info.isSoulCleave then
			local icon = info.spellIcons[204021]
			if icon and icon.active then
				P:UpdateCooldown(icon, 2)
			end
		end
	end
	registeredEvents.SPELL_AURA_REMOVED_DOSE[203981] = ReduceFieryBrandCD
	registeredEvents.SPELL_AURA_REMOVED[203981] = ReduceFieryBrandCD
end





do
	local FRENZIED_REGEN = 22842

	local removeBerserk = function(info, srcGUID, spellID, destGUID)
		info = info or groupInfo[srcGUID]
		if info then
			if info.auras.isBerserk then
				info.auras.isBerserk = nil
				local icon = info.spellIcons[FRENZIED_REGEN]
				if icon and icon.active then
					P:UpdateCooldown(icon, 0, nil, 4)
				end
			end
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[50334] = removeBerserk
	registeredEvents.SPELL_AURA_APPLIED[50334] = function(info, srcGUID, spellID, destGUID)
		local icon = info.spellIcons[FRENZIED_REGEN]
		if icon then
			info.auras.isBerserk = true
			if icon.active then
				P:UpdateCooldown(icon, 0, nil, 0.25)
			end
			E.TimerAfter(spellID == 50334 and 15.1 or 30.1, removeBerserk, nil, srcGUID, spellID, destGUID)

		end
	end
	registeredEvents.SPELL_AURA_REMOVED[102558] = registeredEvents.SPELL_AURA_REMOVED[50334]
	registeredEvents.SPELL_AURA_APPLIED[102558] = registeredEvents.SPELL_AURA_APPLIED[50334]

end





do
	local RAPID_FIRE = 257044

	local removeTrueShot = function(info, srcGUID, spellID, destGUID)
		info = info or groupInfo[srcGUID]
		if info then
			if info.auras.isTrueShot then
				info.auras.isTrueShot = nil
				local icon = info.spellIcons[RAPID_FIRE]
				if icon and icon.active then
					P:UpdateCooldown(icon, 0, nil, 2.5)
				end
			end
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[288613] = removeTrueShot
	registeredEvents.SPELL_AURA_APPLIED[288613] = function(info, srcGUID, spellID, destGUID)
		local icon = info.spellIcons[RAPID_FIRE]
		if icon then
			info.auras.isTrueShot = true
			if icon and icon.active then
				P:UpdateCooldown(icon, 0, nil, 0.4)
			end
			E.TimerAfter(20.1, removeTrueShot, nil, srcGUID, spellID, destGUID)
		end
	end

end


local function ReduceDisengageCD(info, _, spellID)
	local icon = info.spellIcons[781]
	if icon and icon.active then
		local rankValue = info.talentData[346747]
		if rankValue then
			info.auras.time_ambuscade = info.auras.time_ambuscade or {}
			local now = GetTime()
			if now > (info.auras.time_ambuscade[spellID] or 0) then
				P:UpdateCooldown(icon, rankValue)
				info.auras.time_ambuscade[spellID] = now + 1
			end
		end
	end
end
registeredEvents.SPELL_AURA_APPLIED[203337] = ReduceDisengageCD
registeredEvents.SPELL_AURA_APPLIED[3355] = ReduceDisengageCD
registeredEvents.SPELL_AURA_APPLIED[135299] = ReduceDisengageCD
registeredEvents.SPELL_DAMAGE[236777] = ReduceDisengageCD


registeredEvents.SPELL_CAST_SUCCESS[131894] = function(info, srcGUID, _, destGUID)
	if info.spellIcons[131894] then
		diedDestGUIDS[destGUID] = diedDestGUIDS[destGUID] or {}
		diedDestGUIDS[destGUID][srcGUID] = diedDestGUIDS[destGUID][srcGUID] or {}
		diedDestGUIDS[destGUID][srcGUID][131894] = true
	end

	C_Timer.After(15, function()
		if diedDestGUIDS[destGUID] and diedDestGUIDS[destGUID][srcGUID] then
			diedDestGUIDS[destGUID][srcGUID][131894] = nil
		end
	end)
end





do
	local ARCANE_PRODIGY = 336873
	local ARCANE_POWER = 12042


	registeredEvents.SPELL_AURA_APPLIED[263725] = function(info)
		if info.spellIcons[ARCANE_POWER] and info.talentData[ARCANE_PRODIGY] then
			info.auras.isClearCasting = true
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[5143] = function(info, srcGUID)
		if info.auras.isClearCasting then
			info.auras.isArcaneProdigy = true
		elseif info.auras.isArcaneProdigy then
			info.auras.isArcaneProdigy = nil
		end
	end








	registeredEvents.SPELL_DAMAGE[7268] = function(info)
		if info.auras.isArcaneProdigy then
			local rankValue = info.talentData[ARCANE_PRODIGY]
			if rankValue then
				local icon = info.spellIcons[ARCANE_POWER]
				if icon and icon.active then
					P:UpdateCooldown(icon, rankValue)
				end
			end
		end
	end
end


do
	local ICY_VEINS = 12472

	local removeIcyVeins = function(info, srcGUID, spellID, destGUID)
		info = info or groupInfo[srcGUID]
		if info then
			info.auras.isIcyPropulsion = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[ICY_VEINS] = removeIcyVeins
	registeredEvents.SPELL_AURA_APPLIED[ICY_VEINS] = function(info, srcGUID, spellID, destGUID)
		if info.spellIcons[ICY_VEINS] and info.talentData[336522] then
			info.auras.isIcyPropulsion = true

			if not info.talentData[155149] then
				E.TimerAfter(23.1, removeIcyVeins, nil, srcGUID, spellID, destGUID)
			end
		end
	end
end


registeredEvents.SPELL_CAST_SUCCESS[325130] = function(info)
	for id in pairs(info.active) do
		local icon = info.spellIcons[id]
		if icon then
			if BOOKTYPE_CATEGORY[icon.category] and id ~= 314791 then
				local reducedTime = 2.5
				local rankValue = info.talentData[336992]
				if rankValue then
					reducedTime = reducedTime + rankValue
				end
				P:UpdateCooldown(icon, reducedTime)
			end
		end
	end
end


do
	local MIRRORS_OF_TORMENT = 314793

	local function ReduceFireBlastCD(info)
		local icon = info.spellIcons[108853]
		if icon and icon.active then
			P:UpdateCooldown(icon, 6)
		end
	end
	registeredEvents.SPELL_AURA_APPLIED_DOSE[320035] = ReduceFireBlastCD
	registeredEvents.SPELL_AURA_APPLIED[320035] = ReduceFireBlastCD
	registeredEvents.SPELL_AURA_APPLIED[317589] = ReduceFireBlastCD


	local function ProcConsumed(info)
		if info.talentData[354333] then
			local icon = info.spellIcons[MIRRORS_OF_TORMENT]
			if icon and icon.active then
				P:UpdateCooldown(icon, 4)
			end
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[190446] = ProcConsumed
	registeredEvents.SPELL_CAST_SUCCESS[108853] = ProcConsumed
	registeredEvents.SPELL_AURA_REMOVED[263725] = function(info)
		if info.auras.isClearCasting then
			info.auras.isClearCasting = nil
		end
		ProcConsumed(info)
	end


	registeredEvents.SPELL_CAST_SUCCESS[MIRRORS_OF_TORMENT] = function(info, srcGUID, spellID, destGUID)
		if info.spellIcons[MIRRORS_OF_TORMENT] then
			dispelledDestGUIDS[destGUID] = dispelledDestGUIDS[destGUID] or {}
			dispelledDestGUIDS[destGUID][MIRRORS_OF_TORMENT] = dispelledDestGUIDS[destGUID][MIRRORS_OF_TORMENT] or {}
			dispelledDestGUIDS[destGUID][MIRRORS_OF_TORMENT][srcGUID] = true

			C_Timer.After(25.1, function()
				if dispelledDestGUIDS[destGUID] and dispelledDestGUIDS[destGUID][MIRRORS_OF_TORMENT] then
					dispelledDestGUIDS[destGUID][MIRRORS_OF_TORMENT][srcGUID] = nil
				end
			end)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[MIRRORS_OF_TORMENT] = function(info, srcGUID, spellID, destGUID)
		C_Timer.After(0.1, function()
			if dispelledDestGUIDS[destGUID] and dispelledDestGUIDS[destGUID][MIRRORS_OF_TORMENT] then
				dispelledDestGUIDS[destGUID][MIRRORS_OF_TORMENT][srcGUID] = nil
			end
		end)
	end
end


registeredEvents.SPELL_AURA_REMOVED[342246] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[342249] then
		local icon = info.spellIcons[1953]
		if icon and icon.active then
			P:ResetCooldown(icon)
		end
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end


registeredEvents.SPELL_CAST_SUCCESS[257541] = function(info, _,_, destGUID)
	info.auras.phoenixFlameTargetGUID = destGUID
end





do
	registeredEvents.SPELL_AURA_APPLIED[325216] = function(info, _,_, destGUID)
		if info.spec == 268 and info.spellIcons[325216] then
			info.auras.bonedustTargetGUID = info.auras.bonedustTargetGUID or {}
			info.auras.bonedustTargetGUID[destGUID] = true
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[325216] = function(info, _,_, destGUID)
		if info.auras.bonedustTargetGUID and info.auras.bonedustTargetGUID[destGUID] then
			info.auras.bonedustTargetGUID[destGUID] = nil
		end
	end
	registeredEvents.SPELL_CAST_SUCCESS[325216]  = function(info)
		if info.auras.bonedustTargetGUID then
			wipe(info.auras.bonedustTargetGUID)
		end
	end

	local function ReduceBonedustBrewCD(info, _,_, destGUID)
		if info.auras.bonedustTargetGUID and info.auras.bonedustTargetGUID[destGUID] then
			local icon = info.spellIcons[325216]
			if icon and icon.active then
				P:UpdateCooldown(icon, 1)
			end
		end
	end
	registeredEvents.SPELL_CAST_SUCCESS[100780] = ReduceBonedustBrewCD
	registeredEvents.SPELL_CAST_SUCCESS[121253] = ReduceBonedustBrewCD
end



local function ReduceBoneMarrowHopsCD(info)
	local rankValue = info.talentData[337295]
	if rankValue then
		local icon = info.spellIcons[325216]
		if icon and icon.active then
			local now = GetTime()
			if now > (info.auras.time_boneMarrowHops or 0) then
				P:UpdateCooldown(icon, rankValue)
				info.auras.time_boneMarrowHops = now + 1
			end
		end
	end
end
registeredEvents.SPELL_DAMAGE[325217] = ReduceBoneMarrowHopsCD
registeredEvents.SPELL_HEAL[325218] = ReduceBoneMarrowHopsCD


registeredEvents.SPELL_CAST_SUCCESS[107428] = function(info)
	local rankValue = info.talentData[337099]
	if rankValue then
		local icon = info.spellIcons[115310]
		if icon and icon.active then
			P:UpdateCooldown(icon, rankValue)
		end
	end
end



registeredEvents.SPELL_AURA_APPLIED[228563] = function(info) info.auras.isBlackoutCombo = true end
registeredEvents.SPELL_AURA_REMOVED[228563] = function(info) info.auras.isBlackoutCombo = nil end


registeredEvents.SPELL_AURA_APPLIED[310454] = function(info) info.auras.isWeaponsOfOrder = true end
registeredEvents.SPELL_AURA_REMOVED[310454] = function(info, srcGUID, spellID, destGUID)
	info.auras.isWeaponsOfOrder = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end


do



	local stunDebuffs = {
		[210141]  = true,
		[334693]  = true,
		[108194]  = true,
		[221562]  = true,
		[91800]   = true,
		[91797]   = true,
		[287254]  = true,
		[179057]  = true,

		[205630]  = true,
		[208618]  = true,
		[211881]  = true,
		[200166]  = true,
		[203123]  = true,
		[163505]  = true,
		[5211]    = true,
		[202244]  = true,
		[325321]  = true,
		[24394]   = true,
		[119381]  = true,
		[202346]  = true,
		[853]     = true,
		[255941]  = true,
		[64044]   = true,
		[200200]  = true,
		[1833]    = true,
		[408]     = true,
		[118905]  = true,
		[118345]  = true,
		[305485]  = true,
		[89766]   = true,
		[171017]  = true,
		[171018]  = true,

		[30283]   = true,
		[46968]   = true,
		[132168]  = true,
		[145047]  = true,
		[132169]  = true,
		[199085]  = true,

		[20549]   = true,
		[255723]  = true,
		[287712]  = true,
		[280061]  = true,
		[245638]  = true,
		[332423]  = true,
	}

	local TRANSCENDENCE_TRANSFER = 119996

	for id in pairs(stunDebuffs) do
		registeredHostileEvents.SPELL_AURA_APPLIED[id] = function(destInfo)
			if P.isPvP and destInfo.talentData[353584] and destInfo.spellIcons[TRANSCENDENCE_TRANSFER] then
				local c = destInfo.auras.isStunned
				c = c and c + 1 or 1
				destInfo.auras.isStunned = c
			end
		end
		registeredHostileEvents.SPELL_AURA_REMOVED[id] = function(destInfo)
			local c = destInfo.auras.isStunned
			if c then
				destInfo.auras.isStunned = math.max(c - 1, 0)
			end
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[TRANSCENDENCE_TRANSFER] = function(info, srcGUID, spellID, destGUID)
		local icon = info.spellIcons[TRANSCENDENCE_TRANSFER]
		if icon then
			if not info.auras.isEscapeFromReality then
				P:StartCooldown(icon, P.isPvP and info.talentData[353584] and (not info.auras.isStunned or info.auras.isStunned < 1) and icon.duration - 15 or icon.duration )
			end
		end
	end




	local removeEscapeFromReality = function(info, srcGUID, spellID, destGUID)
		info = info or groupInfo[srcGUID]
		if info and info.auras.isEscapeFromReality then
			local icon = info.spellIcons[TRANSCENDENCE_TRANSFER]
			if icon and not icon.active then



				P:StartCooldown(icon, 35)
			end
			info.auras.isEscapeFromReality = nil
		end
	end


	registeredEvents.SPELL_AURA_REMOVED[343249] = removeEscapeFromReality
	registeredEvents.SPELL_AURA_APPLIED[343249] = function(info, srcGUID, spellID, destGUID)
		if info.spellIcons[TRANSCENDENCE_TRANSFER] then

			info.auras.isEscapeFromReality = true

			E.TimerAfter(10, removeEscapeFromReality, nil, srcGUID, spellID, destGUID)
		end
	end
end


do





















	local removeFallenOrder = function(info, srcGUID, spellID, destGUID)
		info = info or groupInfo[srcGUID]
		if info then
			info.auras.isFallenOrder = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[326860] = removeFallenOrder
	registeredEvents.SPELL_AURA_APPLIED[326860] = function(info, srcGUID, spellID, destGUID)
		if info.talentData[356818] and info.spellIcons[326860] then
			info.auras.isFallenOrder = true
			E.TimerAfter(24.1, removeFallenOrder, nil, srcGUID, spellID, destGUID)
		end
	end
end


registeredEvents.SPELL_DAMAGE[322109] = function(info, srcGUID, spellID, destGUID, critical, destFlags, amount, overkill)
	if overkill > -1 and P:IsTalent(345829, srcGUID) and band(destFlags, player) > 0 then
		local icon = info.spellIcons[122470]
		if icon and icon.active then
			P:UpdateCooldown(icon, 60)
		end
	end
end





registeredEvents.SPELL_HEAL[633] = function(info, _,_,_,_,_, amount, overhealing, destName)
	if info.talentData[326734] then
		local icon = info.spellIcons[633]
		if icon then
			local maxHP = UnitHealthMax(destName)
			if maxHP ~= 0 then
				local reducedMult = math.min((amount - overhealing) / maxHP, 0.6)
				if reducedMult > 0 then
					C_Timer.After(0, function() P:UpdateCooldown(icon, icon.duration * reducedMult) end)
				end
			end
		end
	end
end


registeredEvents.SPELL_CAST_SUCCESS[53600] = function(info)
	local rankValue = info.talentData[340023]
	if rankValue then
		local icon = info.spellIcons[31850]
		if icon and icon.active then
			P:UpdateCooldown(icon, rankValue)
		end
	end
end


do

	local removeMomentOfGlory = function(srcGUID, spellID, destGUID)
		local info = groupInfo[srcGUID]
		if info and info.auras.isMomentOfGlory then
			info.auras.isMomentOfGlory = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[327193] = function(info, srcGUID, spellID, destGUID)
		info.auras.isMomentOfGlory = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
	registeredEvents.SPELL_AURA_APPLIED[327193] = function(info, srcGUID, spellID, destGUID)
		local icon = info.spellIcons[31935]
		if icon then
			info.auras.isMomentOfGlory = true
			E.TimerAfter(15.1, removeMomentOfGlory, srcGUID, spellID, destGUID)
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[31935] = function(info)
		local icon = info.spellIcons[31935]
		if icon and not info.auras.isMomentOfGlory then
			P:StartCooldown(icon, icon.duration)
		end
	end
end


registeredEvents.SPELL_CAST_SUCCESS[35395] = function(info)
	local icon = info.spellIcons[20473]
	if icon and info.talentData[196926] then
		P:UpdateCooldown(icon, 1.0)
	end
end



do
	local ASHEN_HALLOW = 316958

	local function upateLastTick(info)
		if info.auras.ashenHollowLT then
			info.auras.ashenHollowLT = GetTime()
		end
	end
	registeredEvents.SPELL_DAMAGE[317221] = upateLastTick
	registeredEvents.SPELL_HEAL[317223] = upateLastTick

	local updateAshenHollow = function(srcGUID)
		local info = groupInfo[srcGUID]
		if info and info.auras.ashenHollowLT then
			local now = GetTime()
			if now - info.auras.ashenHollowLT > 2 then
				local remainingTime = 47 - now + info.auras.ashenHollowST
				if remainingTime > 0.25 then
					local icon = info.spellIcons[ASHEN_HALLOW]
					if icon and icon.active then
						P:UpdateCooldown(icon, (remainingTime / 45) * 0.5 * icon.duration)
					end
				end
				info.auras.ashenHollowST = nil
				info.auras.ashenHollowLT = nil
				info.bar.timer_ashenHallowTicker:Cancel()
				info.bar.timer_ashenHallowTicker = nil
			end
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[ASHEN_HALLOW] = function(info, srcGUID)
		if ( srcGUID ~= userGUID and not E.Comms.syncGUIDS[srcGUID] ) then
			if not info.spellIcons[ASHEN_HALLOW] or not info.talentData[355447] then
				return
			end

			local now = GetTime()
			if info.bar.timer_ashenHallowTicker then
				info.bar.timer_ashenHallowTicker:Cancel()
			end
			info.auras.ashenHollowST = now
			info.auras.ashenHollowLT = now
			info.bar.timer_ashenHallowTicker = C_Timer.NewTicker(2, function() updateAshenHollow(srcGUID) end, 23)
		end
	end
end


registeredEvents.SPELL_AURA_APPLIED[337228] = function(info, srcGUID, spellID, destGUID)
	local icon = info.spellIcons[24275]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


do
	local ARDENT_DEFENDER = 31850

	local onADRemoval = function(srcGUID, spellID, destGUID)
		local info = groupInfo[srcGUID]
		local icon = info.spellIcons[ARDENT_DEFENDER]
		if icon then
			if info.auras.isSavedByAD then
				info.auras.isSavedByAD = nil
			elseif info.talentData[337838] then
				P:UpdateCooldown(icon, 44.8)
			end
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[ARDENT_DEFENDER] = function(info, srcGUID, spellID, destGUID)
		E.TimerAfter(0.1, onADRemoval, srcGUID, spellID, destGUID)
	end


	registeredEvents.SPELL_HEAL[66235] = function(info)
		if info.spellIcons[ARDENT_DEFENDER] and info.talentData[337838] then
			info.auras.isSavedByAD = true
		end
	end
end





do
	local APOTHEOSIS = 200183

	local removeApotheosis = function(srcGUID, spellID, destGUID)
		local info = groupInfo[srcGUID]
		if info and info.auras.isApotheosisActive then
			info.auras.isApotheosisActive = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[APOTHEOSIS] = function(info, srcGUID, spellID, destGUID)
		info.auras.isApotheosisActive = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
	registeredEvents.SPELL_AURA_APPLIED[APOTHEOSIS] = function(info, srcGUID, spellID, destGUID)
		info.auras.isApotheosisActive = true
		E.TimerAfter(20.1, removeApotheosis, srcGUID, spellID, destGUID)
	end
end


do
	local GUARDIAN_SPIRIT = 47788

	local onGSRemoval = function(srcGUID, spellID, destGUID)
		local info = groupInfo[srcGUID]
		local icon = info.spellIcons[GUARDIAN_SPIRIT]
		if icon then
			if info.auras.isSavedByGS then
				info.auras.isSavedByGS = nil
			elseif info.talentData[200209] or info.talentData[63231] then
				P:StartCooldown(icon, 60)
			end
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[GUARDIAN_SPIRIT] = function(info, srcGUID, spellID, destGUID)
		E.TimerAfter(0.1, onGSRemoval, srcGUID, spellID, destGUID)
	end


	registeredEvents.SPELL_HEAL[48153] = function(info)
		if info.spellIcons[GUARDIAN_SPIRIT] then
			info.auras.isSavedByGS = true
		end
	end
end


registeredEvents.SPELL_AURA_APPLIED[211319] = function(info)
	local icon = info.spellIcons[20711]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents.SPELL_CAST_SUCCESS[10060] = function(info, srcGUID, _, destGUID)
	local rankValue = info.talentData[337762]
	if rankValue and srcGUID ~= destGUID then
		local icon = info.spellIcons[10060]
		if icon and icon.active then
			P:UpdateCooldown(icon, rankValue)
		end
	end
end



do
	local THOUGHTSTEAL = 316262

	registeredEvents.SPELL_AURA_APPLIED[322431] = function(info)
		local icon = info.spellIcons[THOUGHTSTEAL]
		if icon then
			local statusBar = icon.statusBar
			if icon.active then
				if statusBar then
					P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_STOP")
				end
				icon.cooldown:Clear()
			end
			if statusBar then
				statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
			end
			info.preActiveIcons[THOUGHTSTEAL] = icon
			if not icon.isHighlighted then
				icon.icon:SetVertexColor(0.4, 0.4, 0.4)
			end
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[322431] = function(info)
		local icon = info.spellIcons[THOUGHTSTEAL]
		if icon then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preActiveIcons[THOUGHTSTEAL] = nil
			icon.icon:SetVertexColor(1, 1, 1)

			P:StartCooldown(icon, icon.duration)
		end
	end
end


do
	local function ResetShadowWordDeath(info)
		local icon = info.spellIcons[32379]
		if icon and icon.active then
			P:ResetCooldown(icon)
		end
	end

	registeredEvents.SPELL_AURA_APPLIED[321973] = ResetShadowWordDeath
	registeredEvents.SPELL_AURA_REFRESH[321973] = ResetShadowWordDeath
end


do
	local BOON_OFTHE_ASCENDED = 325013

	registeredEvents.SPELL_AURA_APPLIED_DOSE[BOON_OFTHE_ASCENDED] = function(info, _,_,_,_,_,_, amount)
		if info.auras.numBoonOfTheAscended then
			info.auras.numBoonOfTheAscended = amount
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[BOON_OFTHE_ASCENDED] = function(info, srcGUID, spellID, destGUID)
		local consumed = info.auras.numBoonOfTheAscended
		if consumed then
			local icon = info.spellIcons[BOON_OFTHE_ASCENDED]
			if icon and icon.active then
				P:UpdateCooldown(icon, math.min(consumed * 3 ,60))
			end
			info.auras.numBoonOfTheAscended = nil
		end
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end

	registeredEvents.SPELL_CAST_SUCCESS[BOON_OFTHE_ASCENDED] = function(info)
		if info.talentData[356395] and info.spellIcons[BOON_OFTHE_ASCENDED] then
			info.auras.numBoonOfTheAscended = 0
		end
	end
end


do
	registeredEvents.SPELL_AURA_REMOVED[363727] = function(info)
		info.auras.isDivineConversation = nil
	end
	registeredEvents.SPELL_AURA_APPLIED[363727] = function(info)
		info.auras.isDivineConversation = true
	end
end





do
	local VENDETTA = 79140
	local SHADOW_STEP = 36554

	local removeVendettaTarget = function(info, srcGUID)
		info = info or groupInfo[srcGUID]
		if info and info.auras.vendettaTargetGUID then
			info.auras.vendettaTargetGUID = nil
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[VENDETTA] = removeVendettaTarget
	registeredEvents.SPELL_AURA_APPLIED[VENDETTA] = function(info, srcGUID, _, destGUID)
		if info.spellIcons[SHADOW_STEP] then
			info.auras.vendettaTargetGUID = destGUID
			E.TimerAfter(20.1, removeVendettaTarget, nil, srcGUID)
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[SHADOW_STEP] = function(info, _, spellID, destGUID, _, destFlags)
		if not P.isPvP then
			return
		end

		local icon = info.spellIcons[spellID]
		if icon and icon.active then
			local active = info.active[spellID]
			if active then
				if info.talentData[197899] then
					if band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 then
						P:UpdateCooldown(icon, active.duration * 0.67 )
					end
				elseif info.talentData[197007] then
					if info.auras.vendettaTargetGUID == destGUID then
						P:UpdateCooldown(icon, active.duration * 0.90 )
					end
				end
			end
		end
	end
end


do
	local TRUE_BEARING = 193359

	local removeTrueBearing = function(srcGUID)
		local info = groupInfo[srcGUID]
		if info and info.auras.isTrueBearing then
			local duration = P:GetBuffDuration(info.unit, TRUE_BEARING)
			if not duration then
				info.auras.isTrueBearing = nil
			end
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[TRUE_BEARING] = function(info) info.auras.isTrueBearing = nil end
	registeredEvents.SPELL_AURA_APPLIED[TRUE_BEARING] = function(info, srcGUID)
		info.auras.isTrueBearing = true
		E.TimerAfter(46.1, removeTrueBearing, srcGUID)
	end
end


do
	local TRICKS_OT_TRADE = 57934





	registeredEvents.SPELL_AURA_REMOVED[TRICKS_OT_TRADE] = function(info, srcGUID, spellID, destGUID)
		local icon = info.spellIcons[TRICKS_OT_TRADE] or info.spellIcons[221622]
		if icon then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preActiveIcons[TRICKS_OT_TRADE] = nil
			icon.icon:SetVertexColor(1, 1, 1)
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end

	local function StartTricksCD(info, srcGUID, spellID, destGUID)
		local icon = info.spellIcons[TRICKS_OT_TRADE] or info.spellIcons[221622]
		if icon and srcGUID == destGUID then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preActiveIcons[TRICKS_OT_TRADE] = nil
			icon.icon:SetVertexColor(1, 1, 1)
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)

			P:StartCooldown(icon, icon.duration)
		end
	end
	registeredEvents.SPELL_AURA_APPLIED[59628] = StartTricksCD
	registeredEvents.SPELL_AURA_APPLIED[221630] = StartTricksCD
end


registeredEvents.SPELL_AURA_APPLIED[347037] = function(info) info.auras.isSepsis = true end
registeredEvents.SPELL_AURA_REMOVED[347037] = function(info) info.auras.isSepsis = nil end
registeredEvents.SPELL_AURA_REMOVED[328305] = function(info)
	if not info.auras.isSepsis then
		local icon = info.spellIcons[328305]
		if icon and icon.active then
			P:UpdateCooldown(icon, 30)
		end
	end
end


do
	registeredEvents.SPELL_AURA_APPLIED[324073] = function(info, srcGUID, _, destGUID)
		if info.spellIcons[328547] then
			diedDestGUIDS[destGUID] = diedDestGUIDS[destGUID] or {}
			diedDestGUIDS[destGUID][srcGUID] = diedDestGUIDS[destGUID][srcGUID] or {}
			diedDestGUIDS[destGUID][srcGUID][328547] = true
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[324073] = function(info, srcGUID, _, destGUID)
		if info.spellIcons[328547] then
			C_Timer.After(0.5, function()
				if diedDestGUIDS[destGUID] and diedDestGUIDS[destGUID][srcGUID] then
					diedDestGUIDS[destGUID][srcGUID][328547] = nil
				end
			end)
		end
	end
end


do
	registeredEvents.SPELL_AURA_REMOVED[323654] = function(info, srcGUID, spellID, destGUID)
		if info.auras.isFlagellation then
			info.auras.isFlagellation = nil
		end
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end

	registeredEvents.SPELL_AURA_APPLIED[323654] = function(info)
		if info.talentData[354703] and info.spellIcons[323654] then
			info.auras.isFlagellation = true
		end
	end
end







registeredEvents.SPELL_CAST_SUCCESS[21169] = function(info)
	local icon = info.spellIcons[20608]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents.SPELL_SUMMON[192058] = function(info, srcGUID, spellID, destGUID)
	local icon = info.spellIcons[spellID]
	if icon and info.talentData[265046] then
		local capGUID = info.auras.capTotemGUID
		if capGUID then
			totemGUIDS[capGUID] = nil
		end
		totemGUIDS[destGUID] = srcGUID
		info.auras.capTotemGUID = destGUID
	end
end


registeredEvents.SPELL_HEAL[31616] = function(info)
	local icon = info.spellIcons[30884]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents.SPELL_AURA_REMOVED[285514] = function(info) info.auras.isSurgeOfPower = nil end
registeredEvents.SPELL_AURA_APPLIED[285514] = function(info)
	if info.spellIcons[198067] or info.spellIcons[192249] then
		info.auras.isSurgeOfPower = true
	end
end


do
	local function ReduceFeralSpiritCD(info)
		if info.talentData[335897] then
			local icon = info.spellIcons[51533]
			if icon and icon.active then
				P:UpdateCooldown(icon, 2)
			end
		end
	end
	registeredEvents.SPELL_AURA_APPLIED[344179] = function(info)
		info.auras.numMaelstrom = 1;
		ReduceFeralSpiritCD(info);
	end
	registeredEvents.SPELL_AURA_APPLIED_DOSE[344179] = function(info, _,_,_,_,_,_, amount)
		if ( info.auras.numMaelstrom ) then
			info.auras.numMaelstrom = amount;
			ReduceFeralSpiritCD(info);
		end
	end
	registeredEvents.SPELL_AURA_REMOVED_DOSE[344179] = function(info, _,_,_,_,_,_, amount)
		if ( info.auras.numMaelstrom ) then
			info.auras.numMaelstrom = amount;
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[344179] = function(info)
		info.auras.numMaelstrom = nil;
	end

	registeredEvents.SPELL_AURA_REFRESH[344179] = function(info)
		if ( info.auras.numMaelstrom ) then
			if ( info.auras.numMaelstrom == 10 ) then
				info.auras.numMaelstrom = 11;
			elseif ( info.auras.numMaelstrom == 11 ) then
				ReduceFeralSpiritCD(info);
			end
		end
	end
end


registeredEvents.SPELL_PERIODIC_DAMAGE[188389] = function(info, srcGUID, spellID, destGUID, critical)
	if ( critical ) then
		if ( info.talentData[336734] ) then
			local icon = info.spellIcons[198067] or info.spellIcons[192249];
			if ( icon and icon.active ) then
				P:UpdateCooldown(icon, 1);
			end
		end

		if ( info.talentData[356250] ) then
			local icon = info.spellIcons[320674];
			if ( icon and icon.active ) then
				P:UpdateCooldown(icon, 1);
			end
		end
	end
end


registeredEvents.SPELL_AURA_APPLIED[358945] = function(info)
	if ( info.spec == 262 ) then
		local icon = info.spellIcons[198067] or info.spellIcons[192249];
		if ( icon and icon.active ) then
			P:UpdateCooldown(icon, 6);
		end
	elseif ( info.spec == 263 ) then
		local icon = info.spellIcons[51533];
		if ( icon and icon.active ) then
			P:UpdateCooldown(icon, 9);
		end
	elseif ( info.spec == 264 ) then
		local icon = info.spellIcons[108280];
		if ( icon and icon.active ) then
			P:UpdateCooldown(icon, 5);
		end
	end
end
registeredEvents.SPELL_AURA_APPLIED_DOSE[358945] = registeredEvents.SPELL_AURA_APPLIED[358945]





do
	local SCOURING_TITHE = 312321

	registeredEvents.SPELL_ENERGIZE[312379] = function(info)
		info.auras.isScouringTitheKilled = true
	end

	local resetScouringTitheCD = function(srcGUID)
		local info = groupInfo[srcGUID]
		if info then
			if info.auras.isScouringTitheKilled then
				info.auras.isScouringTitheKilled = nil
			else
				local icon = info.spellIcons[SCOURING_TITHE]
				if icon and icon.active then
					P:ResetCooldown(icon)
				end
			end
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[SCOURING_TITHE] = function(info, srcGUID)
		local icon = info.spellIcons[SCOURING_TITHE]
		if icon then
			E.TimerAfter(0.5, resetScouringTitheCD, srcGUID)
		end
	end
end


registeredEvents.SPELL_CAST_SUCCESS[17877] = function(info, srcGUID, _, destGUID)
	if info.spellIcons[17877] then
		diedDestGUIDS[destGUID] = diedDestGUIDS[destGUID] or {}
		diedDestGUIDS[destGUID][srcGUID] = diedDestGUIDS[destGUID][srcGUID] or {}
		if diedDestGUIDS[destGUID][srcGUID][17877] then
			diedDestGUIDS[destGUID][srcGUID][17877]:Cancel()
		end
		diedDestGUIDS[destGUID][srcGUID][17877] = C_Timer.NewTicker(5, function()
			if diedDestGUIDS[destGUID] and diedDestGUIDS[destGUID][srcGUID] then
				diedDestGUIDS[destGUID][srcGUID][17877] = nil
			end
		end, 1)
	end
end










do
	local consumables = {
		323436,
		6262,

	}

	local startCdOutOfCombat = function(guid)
		local info = groupInfo[guid]
		if not info or UnitAffectingCombat(info.unit) then
			return
		end

		for i = 1, #consumables do
			local spellID = consumables[i]
			local icon = info.preActiveIcons[spellID]
			if icon then
				local statusBar = icon.statusBar
				if statusBar then
					P:SetExStatusBarColor(icon, statusBar.key)
				end
				info.preActiveIcons[spellID] = nil
				icon.icon:SetVertexColor(1, 1, 1)

				P:StartCooldown(icon, icon.duration)
			end
		end
		info.bar.timer_inCombatTicker:Cancel()
		info.bar.timer_inCombatTicker = nil
	end

	local function StartConsumablesCD(info, srcGUID, spellID)
		local icon = info.spellIcons[spellID]
		if icon then
			if spellID == 323436 then
				local stacks = icon.Count:GetText()
				stacks = tonumber(stacks)
				stacks = (stacks and stacks > 0 and stacks or 3) - 1
				icon.Count:SetText(stacks)
				info.auras.purifySoulStacks = stacks
			end

			if info.bar.timer_inCombatTicker then
				info.bar.timer_inCombatTicker:Cancel()
				info.bar.timer_inCombatTicker = nil
			end

			if UnitAffectingCombat(info.unit) then
				local statusBar = icon.statusBar
				if icon.active then
					if statusBar then
						P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_STOP")
					end
					icon.cooldown:Clear()
				end

				if not info.preActiveIcons[spellID] then
					if statusBar then
						statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
					end
					info.preActiveIcons[spellID] = icon
					icon.icon:SetVertexColor(0.4, 0.4, 0.4)
				end

					info.bar.timer_inCombatTicker = C_Timer.NewTicker(5, function() startCdOutOfCombat(icon.guid) end, 200)

			else
				info.preActiveIcons[spellID] = nil
				icon.icon:SetVertexColor(1, 1, 1)

				P:StartCooldown(icon, icon.duration)
			end
		end
	end

	for i = 1, #consumables do
		local spellID = consumables[i]

		if spellID == 323436 then
			registeredEvents["SPELL_HEAL"][spellID] = function(info, srcGUID, spellID)
				if not info.auras.igonrePurifySoul then
					info.auras.igonrePurifySoul = true
					C_Timer.After(0.1, function() info.auras.igonrePurifySoul = false end)
					StartConsumablesCD(info, srcGUID, spellID)
				end
			end
			registeredEvents["SPELL_CAST_SUCCESS"][spellID] = registeredEvents["SPELL_HEAL"][spellID]

		else
			registeredEvents["SPELL_CAST_SUCCESS"][spellID] = StartConsumablesCD
		end
	end


	registeredEvents.SPELL_CAST_SUCCESS[324739] = function(info)
		local icon = info.spellIcons[323436]
		if icon then
			info.auras.purifySoulStacks = 3
			icon.Count:SetText(3)
		end
	end
end


do
	local kyrianAbilityByClass = {
		WARRIOR = { 307865, 4   },
		PALADIN = { 304971, 4   },
		HUNTER  = { 308491, 4   },
		ROGUE   = { 323547, 3   },
		PRIEST  = { 325013, 12  },
		DEATHKNIGHT = { 312202, 4   },
		SHAMAN  = { 324386, 4   },
		MAGE    = { 307443, 2   },
		WARLOCK = { 312321, 3   },
		MONK    = { 310454, 8   },
		DRUID   = { 338142, 4   },
		DEMONHUNTER = { 306830, 4   },
	}

	registeredEvents.SPELL_AURA_APPLIED[353248] = function(info)
		local t = kyrianAbilityByClass[info.class]
		local target, rt = t[1], t[2]
		local icon = info.spellIcons[target]
		local active = icon and icon.active and info.active[target]
		if active then
			active.numHits = (active.numHits or 0) + 1
			if active.numHits > 5 then
				return
			end
			P:UpdateCooldown(icon, rt)
		end
	end
end


local startSoulIgniterCD = function(srcGUID, spellID, destGUID)
	local info = groupInfo[srcGUID]
	if info then
		local icon = info.spellIcons[345251]
		if icon then
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
			P:StartCooldown(icon, icon.duration)
		end
	end
end
registeredEvents.SPELL_AURA_REMOVED[345211] = function(info, srcGUID, spellID, destGUID)
	E.TimerAfter(0.05, startSoulIgniterCD, srcGUID, spellID, destGUID)
end


do
	local function StartDispelCD(info, _, spellID)
		local icon = info.spellIcons[spellID]
		if icon then
			P:StartCooldown(icon, icon.duration)
		end
	end

	for k in pairs(cd_start_dispels) do
		registeredEvents.SPELL_DISPEL[k] = StartDispelCD
	end
end


do
	local function RemoveAllForbearance(_,_, spellID, destGUID)
		if not E.db.icons.showForbearanceCounter then
			return
		end

		local info = groupInfo[destGUID]
		if not info then
			return
		end

		local t = cd_disable_aura_applied[spellID]
		for k in pairs(t) do
			local icon = info.preActiveIcons[k]
			if icon then
				icon.icon:SetVertexColor(1, 1, 1)
				info.preActiveIcons[k] = nil
			end
		end
	end

	local removeForbearance = function(destGUID, k)
		local info = groupInfo[destGUID]
		if info then
			local icon = info.preActiveIcons[k]
			if icon then
				icon.icon:SetVertexColor(1, 1, 1)
				info.preActiveIcons[k] = nil
			end
		end
	end

	local function ApplyForbearance(_,_, spellID, destGUID)
		if not E.db.icons.showForbearanceCounter then
			return
		end

		local info = groupInfo[destGUID]
		if not info then
			return
		end

		local t = cd_disable_aura_applied[spellID]
		local now = GetTime()
		for k, v in pairs(t) do
			local icon = info.spellIcons[k]
			if icon then
				local active = icon.active and info.active[k]
				local remainingTime = active and (active.duration - now + active.startTime)
				if v > 0 then
					if not active then
						P:StartCooldown(icon, v, nil, true)
					elseif remainingTime < v then
						P:UpdateCooldown(icon, remainingTime - v)
					end
				else
					local charges = active and active.charges
					if not active or ( icon.maxcharges and charges and charges > 0 or remainingTime < FORBEARANCE_DURATION ) then
						info.preActiveIcons[k] = icon
						if not icon.isHighlighted then
							icon.icon:SetVertexColor(0.4, 0.4, 0.4)
						end
						E.TimerAfter(FORBEARANCE_DURATION + 0.1, removeForbearance, destGUID, k)
					end
				end
			end
		end
	end

	for k in pairs(cd_disable_aura_applied) do
		registeredEvents.SPELL_AURA_APPLIED[k] = ApplyForbearance
		registeredEvents.SPELL_AURA_REMOVED[k] = RemoveAllForbearance

		registeredUserEvents.SPELL_AURA_APPLIED[k] = ApplyForbearance
		registeredUserEvents.SPELL_AURA_REMOVED[k] = RemoveAllForbearance
	end
end


do
	local THUNDERCHARGE = 204366

	local BLESSING_OF_AUTUMN = 328622
	local EQUINOX = 355567
	local BENEVOLENT_FAERIE = 327710
	local BENEVOLENT_FAERIE_FERMATA = 345453
	local HAUNTED_MASK = 356968
	local SYMBOL_OF_HOPE = 265144
	local EMERALD_SLUMBER = 329042

	local INTIMIDATION_TACTICS = 353210
	local DECRYPTED_URH_CYPHER = 368239
	local ARCHITECTS_INGENUITY = 368937

	local function UpdateCDRR(info, modRate, excludeID)
		local newRate = (info.modRate or 1) * modRate
		local now = GetTime()

		for spellID, active in pairs(info.active) do
			if spellID ~= excludeID then
				local icon = info.spellIcons[spellID]
				if icon and icon.active then
					if BOOKTYPE_CATEGORY[icon.category] then
						local elapsed = (now - active.startTime) * modRate
						local newTime = now - elapsed
						local cd = (active.duration * modRate)

						local totRate = newRate
						local majorCD = spell_symbolOfHopeMajorCD[spellID]
						if majorCD and (majorCD == true or majorCD == info.spec) and info.auras.symbol then
							totRate = totRate * info.auras.symbol
						end
						majorCD = spell_benevolentFaeMajorCD[spellID]
						if majorCD and (majorCD == true or majorCD == info.spec) and info.auras.benevolent then
							totRate = totRate * info.auras.benevolent
						end

						icon.cooldown:SetCooldown(newTime, cd, totRate)
						active.startTime = newTime
						active.duration = cd
						active.totRate = abs(1 - totRate) >= 0.05 and totRate

						local statusBar = icon.statusBar
						if statusBar then
							P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and "UNIT_SPELLCAST_CHANNEL_UPDATE" or "UNIT_SPELLCAST_CAST_UPDATE")
						end
					end
				end
			end
		end

		info.modRate = newRate
	end


	local function UpdateIconRR(info, modType, modRate)
		local newRate = (info.auras[modType] or 1) * modRate
		local tbl = spell_majorCD[modType]
		local now = GetTime()

		for spellID, active in pairs(info.active) do
			local majorCD = tbl[spellID]
			if majorCD and (majorCD == true or majorCD == info.spec) then
				local icon = info.spellIcons[spellID]
				if icon and icon.active then
					local elapsed = (now - active.startTime) * modRate
					local newTime = now - elapsed
					local cd = (active.duration * modRate)

					local totRate
					if spellID == 115203 then
						totRate = (newRate * (info.auras[modType == "symbol" and "benevolent" or "symbol"] or 1)) * (info.modRate or 1)
						icon.cooldown:SetCooldown(newTime, cd, totRate)
					elseif spellID == 300728 then
						totRate = newRate
						icon.cooldown:SetCooldown(newTime, cd, totRate)
					else
						totRate = newRate * (info.modRate or 1)
						icon.cooldown:SetCooldown(newTime, cd, totRate)
					end
					active.startTime = newTime
					active.duration = cd
					active.totRate = abs(1 - totRate) >= 0.05 and totRate

					local statusBar = icon.statusBar
					if statusBar then
						P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and "UNIT_SPELLCAST_CHANNEL_UPDATE" or "UNIT_SPELLCAST_CAST_UPDATE")
					end

					break
				end
			end
		end

		info.auras[modType] = abs(1 - newRate) >= 0.05 and newRate
	end

	local function RemoveModRate(_, srcGUID, spellID, destGUID)
		local destInfo = groupInfo[destGUID]
		if not destInfo then
			return
		end

		if spellID == INTIMIDATION_TACTICS then
			if destInfo.auras["intimidation"] then
				UpdateIconRR(destInfo, "intimidation", 3)
			end
		elseif spellID == BENEVOLENT_FAERIE then
			if destInfo.auras.isBenevolent then
				if destInfo.auras.isHauntedCDR then
					UpdateIconRR(destInfo, "benevolent", 3)
					destInfo.auras.isHauntedCDR = nil
				else
					UpdateIconRR(destInfo, "benevolent", 2)
				end
				destInfo.auras.isBenevolent = nil
			end
		elseif spellID == BENEVOLENT_FAERIE_FERMATA then
			if destInfo.auras.isFermata then
				UpdateIconRR(destInfo, "benevolent", 1.8)
				destInfo.auras.isFermata = nil
			end
		elseif spellID == HAUNTED_MASK then
			if destInfo.auras.isHauntedMask == srcGUID then
				if destInfo.auras.isHauntedCDR then
					UpdateIconRR(destInfo, "benevolent", 1.5)
					destInfo.auras.isHauntedCDR = nil
				end
				destInfo.auras.isHauntedMask = nil
			end
		elseif spellID == SYMBOL_OF_HOPE then
			if destInfo.auras["symbol"] then
				UpdateIconRR(destInfo, "symbol", 1/destInfo.auras["symbol"])
			end
		elseif spellID == THUNDERCHARGE then
			if destInfo.auras[spellID] then
				UpdateCDRR(destInfo, destInfo.auras.isThunderChargeSelfCast and 1.7 or 1.3)
				destInfo.auras[spellID] = nil
				destInfo.auras.isThunderChargeSelfCast = nil
			end
			RemoveHighlightByCLEU(destInfo, srcGUID, spellID, destGUID)
		elseif spellID == EMERALD_SLUMBER then
			if destInfo.auras[spellID] then
				UpdateCDRR(destInfo, 5, spellID)
				destInfo.auras[spellID] = nil
			end
			RemoveHighlightByCLEU(destInfo, srcGUID, spellID, destGUID)
		elseif spellID == BLESSING_OF_AUTUMN then
			if destInfo.auras[spellID] then
				UpdateCDRR(destInfo, 1.3)
				destInfo.auras[spellID] = nil
			end
		elseif ( spellID == EQUINOX ) then
			if ( destInfo.auras[BLESSING_OF_AUTUMN] and destInfo.auras[spellID] ) then
				UpdateCDRR(destInfo, 1.6/1.3);
				destInfo.auras[spellID] = nil;
			end
		elseif spellID == ARCHITECTS_INGENUITY then
			if destInfo.auras[spellID] then
				UpdateCDRR(destInfo, 1.05)
				destInfo.auras[spellID] = nil
			end
		end
	end

	local function OnTimerEnd(_, srcGUID, spellID, destGUID)
		local destInfo = groupInfo[destGUID];
		if ( destInfo and destInfo.auras[spellID] ) then
			RemoveModRate(nil, srcGUID, spellID, destGUID)
		end
	end

	local function UpdateModRate(info, srcGUID, spellID, destGUID)
		local destInfo = groupInfo[destGUID]
		if not destInfo then
			return
		end

		if spellID == INTIMIDATION_TACTICS then
			UpdateIconRR(destInfo, "intimidation", 1/3)
		elseif spellID == BENEVOLENT_FAERIE then
			if destInfo.auras.isHauntedMask and not destInfo.auras.isHauntedCDR then
				destInfo.auras.isHauntedCDR = true
				UpdateIconRR(destInfo, "benevolent", 1/3)
			else
				UpdateIconRR(destInfo, "benevolent", 0.5)
			end
			destInfo.auras.isBenevolent = true
		elseif spellID == BENEVOLENT_FAERIE_FERMATA then
			UpdateIconRR(destInfo, "benevolent", 1/1.8)
			destInfo.auras.isFermata = true
		elseif spellID == HAUNTED_MASK then
			if destInfo.auras.isBenevolent and not destInfo.auras.isHauntedMask and not destInfo.auras.isHauntedCDR then
				destInfo.auras.isHauntedCDR = true
				UpdateIconRR(destInfo, "benevolent", 1/1.5)
			end
			destInfo.auras.isHauntedMask = srcGUID
		elseif spellID == SYMBOL_OF_HOPE then
			local _,_,_, startTimeMS, endTimeMS = UnitChannelInfo(info and info.unit or "player")
			if startTimeMS and endTimeMS then
				local channelTime = (endTimeMS - startTimeMS) / 1000
				UpdateIconRR(destInfo, "symbol", 1 / ((60 + channelTime) / channelTime))
			end
		elseif spellID == EMERALD_SLUMBER then
			if srcGUID == destGUID then
				destInfo.auras[spellID] = true
				UpdateCDRR(destInfo, 0.2, EMERALD_SLUMBER)
			end
		elseif spellID == BLESSING_OF_AUTUMN then
			destInfo.auras[spellID] = true
			UpdateCDRR(destInfo, 1/1.3)
			E.TimerAfter(30.5, OnTimerEnd, nil, srcGUID, spellID, destGUID);
		elseif ( spellID == EQUINOX ) then
			if ( destInfo.auras[BLESSING_OF_AUTUMN] ) then
				destInfo.auras[spellID] = true;
				UpdateCDRR(destInfo, 1.3/1.6);
				E.TimerAfter(10.5, OnTimerEnd, nil, srcGUID, spellID, destGUID);
			end
		elseif spellID == ARCHITECTS_INGENUITY then
			destInfo.auras[spellID] = true
			UpdateCDRR(destInfo, 1/1.05)
			E.TimerAfter(30.5, OnTimerEnd, nil, srcGUID, spellID, destGUID);
		end
	end


	registeredEvents.SPELL_AURA_REMOVED[THUNDERCHARGE] = RemoveModRate
	registeredEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE] = function(info, srcGUID, spellID, destGUID)
		if srcGUID == destGUID then
			info.auras.isThunderChargeSelfCast = true
			info.auras[spellID] = true
			UpdateCDRR(info, 1/1.7)
			E.TimerAfter(10.5, OnTimerEnd, nil, srcGUID, spellID, destGUID);
		else
			local destInfo = groupInfo[destGUID]
			if destInfo then
				destInfo.auras[spellID] = true
				UpdateCDRR(destInfo, 1/1.3)
				E.TimerAfter(10.5, OnTimerEnd, nil, srcGUID, spellID, destGUID);
			end
			if info then
				info.auras[spellID] = true
				UpdateCDRR(info, 1/1.3)
				E.TimerAfter(10.5, OnTimerEnd, nil, srcGUID, spellID, srcGUID);
			end
		end
	end
	registeredEvents.SPELL_AURA_APPLIED[BLESSING_OF_AUTUMN] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[BLESSING_OF_AUTUMN] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[EQUINOX] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[EQUINOX] = RemoveModRate
	registeredEvents.SPELL_CAST_SUCCESS[BENEVOLENT_FAERIE] = function(info, srcGUID, spellID, destGUID)
		local destInfo = groupInfo[destGUID]
		if destInfo then
			destInfo.auras.benevolentSRC = destGUID
		end
	end
	registeredEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE_FERMATA] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE_FERMATA] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[HAUNTED_MASK] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[HAUNTED_MASK] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[SYMBOL_OF_HOPE] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[SYMBOL_OF_HOPE] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[EMERALD_SLUMBER] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[EMERALD_SLUMBER] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[INTIMIDATION_TACTICS] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[INTIMIDATION_TACTICS] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[ARCHITECTS_INGENUITY] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[ARCHITECTS_INGENUITY] = RemoveModRate

	registeredUserEvents.SPELL_AURA_REMOVED[THUNDERCHARGE] = RemoveModRate
	registeredUserEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE] = registeredEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE]
	registeredUserEvents.SPELL_AURA_APPLIED[BLESSING_OF_AUTUMN] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[BLESSING_OF_AUTUMN] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[EQUINOX] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[EQUINOX] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE_FERMATA] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE_FERMATA] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[HAUNTED_MASK] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[HAUNTED_MASK] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[SYMBOL_OF_HOPE] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[SYMBOL_OF_HOPE] = RemoveModRate


	registeredEvents.SPELL_CAST_SUCCESS[17] = function(_, srcGUID, _, destGUID)
		local destInfo = groupInfo[destGUID];
		if ( destInfo ) then
			if ( destInfo.auras.isHauntedMask == srcGUID and destInfo.auras.isHauntedCDR ) then
				UpdateIconRR(destInfo, "benevolent", 1.5);
				destInfo.auras.isHauntedCDR = nil;
			end
		end
	end
	registeredEvents.SPELL_CAST_SUCCESS[186263] = function(_, srcGUID, _, destGUID)
		local destInfo = groupInfo[destGUID];
		if ( destInfo and destInfo.auras.isBenevolent ) then
			if ( destInfo.auras.isHauntedMask == srcGUID and not destInfo.auras.isHauntedCDR ) then
				UpdateIconRR(destInfo, "benevolent", 1/1.5);
				destInfo.auras.isHauntedCDR = true;
			end
		end
	end
	registeredEvents.SPELL_CAST_SUCCESS[2061] = registeredEvents.SPELL_CAST_SUCCESS[186263]

	registeredUserEvents.SPELL_CAST_SUCCESS[17] = registeredEvents.SPELL_CAST_SUCCESS[17]
	registeredUserEvents.SPELL_CAST_SUCCESS[186263] = registeredEvents.SPELL_CAST_SUCCESS[186263]
	registeredUserEvents.SPELL_CAST_SUCCESS[2061] = registeredEvents.SPELL_CAST_SUCCESS[186263]


	local RemoveUrh = function(destInfo, _,_,_, destGUID)
		destInfo = destInfo or groupInfo[destGUID];
		if ( destInfo and destInfo.auras[DECRYPTED_URH_CYPHER] ) then
			UpdateCDRR(destInfo, 3);
			destInfo.auras[DECRYPTED_URH_CYPHER] = nil;
		end
	end
	local function OnUrhTimerEnd(destGUID)
		local destInfo = groupInfo[destGUID];
		if ( destInfo and destInfo.auras[DECRYPTED_URH_CYPHER] ) then
			local timeLeft = P:GetDebuffDuration(destInfo.unit, DECRYPTED_URH_CYPHER);
			if ( timeLeft ) then
				E.TimerAfter(timeLeft + 0.5, RemoveUrh, nil, nil, nil, nil, destGUID);
			else
				RemoveUrh(nil, nil, nil, nil, destGUID);
			end
		end
	end
	registeredHostileEvents.SPELL_AURA_REMOVED[DECRYPTED_URH_CYPHER] = RemoveUrh;
	registeredHostileEvents.SPELL_AURA_APPLIED[DECRYPTED_URH_CYPHER] = function(destInfo, _,_,_, destGUID)
		if ( not destInfo.auras[DECRYPTED_URH_CYPHER] ) then
			destInfo.auras[DECRYPTED_URH_CYPHER] = true;
			UpdateCDRR(destInfo, 1/3);
			E.TimerAfter(10.5, OnUrhTimerEnd, destGUID);
		end
	end
end


local function ReduceEvasionCD(destInfo, _,_, missType)
	if missType ~= "DODGE" then
		return
	end

	local rankValue = destInfo.talentData[341535]
	if rankValue then
		local icon = destInfo.spellIcons[5277]
		if icon and icon.active then
			local now = GetTime()
			if now > (destInfo.auras.time_dodged or 0) then
				P:UpdateCooldown(icon, rankValue)
				destInfo.auras.time_dodged = now + 1
			end
		end
	end
end
registeredHostileEvents.SWING_MISSED.ROGUE = function(destInfo, _, spellID) ReduceEvasionCD(destInfo, nil, nil, spellID) end
registeredHostileEvents.RANGE_MISSED.ROGUE = ReduceEvasionCD
registeredHostileEvents.SPELL_MISSED.ROGUE = ReduceEvasionCD


do
	local removeVoidForm = function(srcGUID, spellID, destGUID)
		local info = groupInfo[srcGUID]
		if info and info.auras.isVoidForm then
			info.auras.isVoidForm = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[194249] = function(info, srcGUID, spellID, destGUID)
		info.auras.isVoidForm = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
	registeredEvents.SPELL_AURA_APPLIED[194249] = function(info, srcGUID, spellID, destGUID)
		if info.spellIcons[228260] then
			info.auras.isVoidForm = true
			E.TimerAfter(15.1, removeVoidForm, srcGUID, spellID, destGUID)
		end
	end

	local function ReduceVoidEruptionCD(destInfo)
		if destInfo.spec ~= 258 then
			return
		end

		if not destInfo.auras.isVoidForm and P.isPvP and destInfo.talentData[199259] then
			local icon = destInfo.spellIcons[228260]
			if icon and icon.active then
				local now = GetTime()
				if now > (destInfo.auras.time_drivenToMadness or 0) then
					P:UpdateCooldown(icon, 3)
					destInfo.auras.time_drivenToMadness = now + 1
				end
			end
		end
	end
	registeredHostileEvents.SWING_DAMAGE.PRIEST = ReduceVoidEruptionCD
	registeredHostileEvents.RANGE_DAMAGE.PRIEST = ReduceVoidEruptionCD
	registeredHostileEvents.SPELL_DAMAGE.PRIEST = ReduceVoidEruptionCD
	registeredHostileEvents.SPELL_ABSORBED.PRIEST = ReduceVoidEruptionCD
end


local function ReduceUnendingResolveCD(destInfo, destName, _, amount)
	local rankValue = destInfo.talentData[339272]
	if rankValue then
		local icon = destInfo.spellIcons[104773]
		if icon and icon.active then
			local now = GetTime()
			if now > (destInfo.auras.time_resoluteBarrier or 0) then
				local maxHP = UnitHealthMax(destName)
				if maxHP ~= 0 and (amount / maxHP) > 0.05 then
					P:UpdateCooldown(icon, 10)
					destInfo.auras.time_resoluteBarrier = now + 30 - rankValue
				end
			end
		end
	end
end
registeredHostileEvents.SWING_DAMAGE.WARLOCK = function(destInfo, destName, spellID) ReduceUnendingResolveCD(destInfo, destName, nil, spellID) end
registeredHostileEvents.RANGE_DAMAGE.WARLOCK = ReduceUnendingResolveCD
registeredHostileEvents.SPELL_DAMAGE.WARLOCK = ReduceUnendingResolveCD


local function ReduceDivineShieldCD(destInfo)
	local rankValue = destInfo.talentData[338741]
	if rankValue then
		local icon = destInfo.spellIcons[642]
		if icon and icon.active then
			local now = GetTime()
			if now > (destInfo.auras.time_divineCall or 0) then
				P:UpdateCooldown(icon, 5)
				destInfo.auras.time_divineCall = now + rankValue
			end
		end
	end
end
registeredHostileEvents.SWING_DAMAGE.PALADIN = ReduceDivineShieldCD
registeredHostileEvents.RANGE_DAMAGE.PALADIN = ReduceDivineShieldCD
registeredHostileEvents.SPELL_DAMAGE.PALADIN = ReduceDivineShieldCD
registeredHostileEvents.SPELL_ABSORBED.PALADIN = ReduceDivineShieldCD


























if ( not E.isPreWOTLKC ) then
	for k in pairs(E.sync_periodic) do
		if ( registeredEvents.SPELL_CAST_SUCCESS[k] ) then
			local func = registeredEvents.SPELL_CAST_SUCCESS[k]
			registeredEvents.SPELL_CAST_SUCCESS[k] = function(info, srcGUID, spellID, destGUID)
				func(info, srcGUID, spellID, destGUID)
				E.Comms.ForceSync()
			end
		else
			registeredEvents.SPELL_CAST_SUCCESS[k] = E.Comms.ForceSync
		end
	end
end

setmetatable(registeredEvents, nil)
setmetatable(registeredUserEvents, nil)
setmetatable(registeredHostileEvents, nil)

function P:SetDisabledColorScheme(destInfo)
	if destInfo.isDeadOrOffline then
		return
	end
	destInfo.isDeadOrOffline = true

	for _, icon in pairs(destInfo.spellIcons) do
		local statusBar = icon.statusBar
		if statusBar then
			if icon.active then
				local castingBar = statusBar.CastingBar
				castingBar:SetStatusBarColor(0.3, 0.3, 0.3)
				castingBar.BG:SetVertexColor(0.3, 0.3, 0.3)
				castingBar.Text:SetVertexColor(0.3, 0.3, 0.3)
			end
			statusBar.BG:SetVertexColor(0.3, 0.3, 0.3)
			statusBar.Text:SetTextColor(0.3, 0.3, 0.3)
		end

		icon.icon:SetDesaturated(true)
		icon.icon:SetVertexColor(0.3, 0.3, 0.3)
	end
end

local function UpdateDeadStatus(destInfo)
	if ( E.isPreWOTLKC and UnitHealth(destInfo.unit) > 1 ) then
		return;
	end
	P:SetDisabledColorScheme(destInfo)
	destInfo.isDead = true
	destInfo.bar:RegisterUnitEvent("UNIT_HEALTH", destInfo.unit)
end

if E.isClassic then
	local spellNameToID = E.spellNameToID

	function CD:COMBAT_LOG_EVENT_UNFILTERED()

		local _, event, _, srcGUID, _, srcFlags, _, destGUID, destName, destFlags, _,_, spellName, _, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()


		if band(srcFlags, friendly) == 0 then
			local destInfo = groupInfo[destGUID]
			if destInfo and event == "UNIT_DIED" then
				UpdateDeadStatus(destInfo)
			end
			return
		end


		local spellID = spellNameToID[spellName]
		if (not spellID) then
			return
		end


		srcGUID = E.Cooldowns.petGUIDS[srcGUID] or srcGUID
		local info = groupInfo[srcGUID]
		if (not info) then
			return
		end


		if (spellID == 17116 or spellID == 16188) then
			spellID = (info.class == "DRUID" and 17116) or 16188
		end

		local func = registeredEvents[event] and registeredEvents[event][spellID]
		if func then
			func(info, srcGUID, spellID, destGUID, critical, destFlags, amount, overkill, destName, resisted)
		end


		if (event == "SPELL_CAST_SUCCESS") then
			if (P.spell_enabled[spellID] or E.spell_modifiers[spellID]) then
				ProcessSpell(spellID, srcGUID)
			end
		end
	end
elseif E.isPreWOTLKC then
	function CD:COMBAT_LOG_EVENT_UNFILTERED()
		local _, event, _, srcGUID, _, srcFlags, _, destGUID, destName, destFlags, _, spellID, _,_, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()

		if band(srcFlags, friendly) == 0 then
			local destInfo = groupInfo[destGUID]
			if destInfo and event == "UNIT_DIED" then
				UpdateDeadStatus(destInfo)
			end
			return
		end

		if band(srcFlags, player) > 0 then
			if band(srcFlags, mine) > 0 and isUserDisabled then
				local func = registeredUserEvents[event] and registeredUserEvents[event][spellID]
				if func and destGUID ~= userGUID then
					func(nil, srcGUID, spellID, destGUID)
				end
				return
			end

			local info = groupInfo[srcGUID]
			if not info then
				return
			end

			local func = registeredEvents[event] and registeredEvents[event][spellID]
			if func then
				func(info, srcGUID, spellID, destGUID, critical, destFlags, amount, overkill, destName, resisted)
			end
		end
	end
else
	local RAID_TARGET_MARKERS = E.RAID_TARGET_MARKERS

	local function AppendInterruptExtras(info, destRaidFlags, spellID, extraSpellId, extraSpellName)
		if E.db.extraBars.interruptBar.enabled then
			local icon = info.spellIcons[spell_merged[spellID] or spellID]
			local statusBar = icon and icon.type == "interrupt" and icon.statusBar
			if statusBar then
				local extraSpellTexture = E.db.extraBars.interruptBar.showInterruptedSpell and GetSpellTexture(extraSpellId)
				if extraSpellTexture then
					icon.icon:SetTexture(extraSpellTexture)
					icon.tooltipID = extraSpellId
					if not E.db.icons.showTooltip then
						icon:EnableMouse(true)
					end
				end

				local mark = E.db.extraBars.interruptBar.showRaidTargetMark and RAID_TARGET_MARKERS[destRaidFlags]
				if mark then
					statusBar.CastingBar.Text:SetText(format("%s %s", statusBar.name, mark))
				end
			end
		end
	end

	function CD:COMBAT_LOG_EVENT_UNFILTERED()
		local _, event, _, srcGUID, _, srcFlags, _, destGUID, destName, destFlags, destRaidFlags, spellID, _,_, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()


		if band(srcFlags, friendly) == 0 then
			local destInfo = groupInfo[destGUID]
			if not destInfo then
				if event == "UNIT_DIED" then
					if destGUID == userGUID then
						E.Libs.CBH:Fire("OnDisabledUserDied")
						return
					end

					local watched = diedDestGUIDS[destGUID]
					if watched then
						for guid, t in pairs(watched) do
							local info = groupInfo[guid]
							if info then
								for id in pairs(t) do
									local icon = info.spellIcons[id]
									if icon and icon.active then
										P:ResetCooldown(icon)
									end
								end
							end
						end
						diedDestGUIDS[destGUID] = nil
					end
				elseif event == "SPELL_DISPEL" then
					local watched = dispelledDestGUIDS[destGUID] and dispelledDestGUIDS[destGUID][amount]
					if watched then
						for guid in pairs(watched) do
							local info = groupInfo[guid]
							if info then
								local icon = info.spellIcons[amount]
								if icon and icon.active then
									P:UpdateCooldown(icon, 45)
								end
							end
						end
						dispelledDestGUIDS[destGUID][amount] = nil
					end
				end

				return
			end

			local func = registeredHostileEvents[event] and (registeredHostileEvents[event][spellID] or registeredHostileEvents[event][destInfo.class])
			if func then
				func(destInfo, destName, spellID, amount, destGUID)
			elseif event == "UNIT_DIED" then
				UpdateDeadStatus(destInfo)
			end
		elseif band(srcFlags, player) > 0 then
			if band(srcFlags, mine) > 0 and isUserDisabled then
				local func = registeredUserEvents[event] and registeredUserEvents[event][spellID]
				if func and destGUID ~= userGUID then
					func(nil, srcGUID, spellID, destGUID)
				end
				return
			end

			local info = groupInfo[srcGUID]
			if not info then
				return
			end





			local func = registeredEvents[event] and registeredEvents[event][spellID]
			if func then
				func(info, srcGUID, spellID, destGUID, critical, destFlags, amount, overkill, destName, resisted)
			end

			if event == "SPELL_DAMAGE" and critical then
				if info.class == "MAGE" then
					local specID = info.spec
					if specID == 63 then
						if info.talentData[342344] then
							local icon = info.spellIcons[257541]
							if icon and icon.active then
								local now = GetTime()
								if now > (info.auras.time_pheonixflame or 0) then
									P:UpdateCooldown(icon, 1)
									info.auras.time_pheonixflame = now + 0.1
								end
							end
						end
					elseif specID == 64 and info.auras.isIcyPropulsion then
						local rankValue = info.talentData[336522]
						if rankValue then
							local icon = info.spellIcons[12472]
							if icon and icon.active and spellID ~= 190357 then
								P:UpdateCooldown(icon, rankValue)
							end
						end
					end
				elseif info.class == "MONK" then
					if spellID ~= 185099 and info.auras.isFallenOrder then
						local icon = info.spellIcons[326860]
						if icon and icon.active then
							local now = GetTime()
							if now > (info.auras.time_sinisterTeachings or 0) then
								P:UpdateCooldown(icon, info.spec == 270 and 2.5 or 5)
								info.auras.time_sinisterTeachings = now + 0.75
							end
						end
					end
				end
			elseif (event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" ) and resisted then
				if info.class == "MONK" then
					if spellID ~= 191894 and (spellID ~= 191840 or event == "SPELL_PERIODIC_HEAL") and info.auras.isFallenOrder then
						local icon = info.spellIcons[326860]
						if icon and icon.active then
							local now = GetTime()
							if now > (info.auras.time_sinisterTeachings or 0) then
								P:UpdateCooldown(icon, info.spec == 270 and 2.5 or 5)
								info.auras.time_sinisterTeachings = now + 0.75
							end
						end
					end
				end
			elseif event == "SPELL_INTERRUPT" then
				AppendInterruptExtras(info, destRaidFlags, spellID, amount, overkill)
			end
		elseif band(srcFlags, guardianTotem) > 0 then
			if event ~= "SPELL_AURA_APPLIED" then
				return
			end

			local t = cd_reduce_damage_totem[spellID]
			if not t then
				return
			end

			local guid = totemGUIDS[srcGUID]
			local info = groupInfo[guid]
			if not info then
				return
			end

			local target = t[3]
			local icon = info.spellIcons[target]
			local active = icon and icon.active and info.active[target]
			if active then
				active.numHits = (active.numHits or 0) + 1
				if active.numHits > t[4] then
					return
				end
				P:UpdateCooldown(icon, t[2])
			end
		elseif band(srcFlags, pet) > 0 then
			srcGUID = petGUIDS[srcGUID]
			local info = groupInfo[srcGUID]
			if not info then
				return
			end

			if event == "SPELL_INTERRUPT" then
				AppendInterruptExtras(info, destRaidFlags, spellID, amount, overkill)
			elseif event == "SPELL_DAMAGE" and critical then
				local t = cd_reduce_damage_pet[spellID]
				if t then
					local icon = info.spellIcons[t[3]]
					if icon and icon.active then
						local rankVal = info.talentData[t[1]]
						if rankVal then
							P:UpdateCooldown(icon, rankVal)
						end
					end
				end
			end
		end
	end
end

CD.totemGUIDS = totemGUIDS
CD.petGUIDS = petGUIDS
CD.diedDestGUIDS = diedDestGUIDS
CD.dispelledDestGUIDS = dispelledDestGUIDS
E.ProcessSpell = ProcessSpell
