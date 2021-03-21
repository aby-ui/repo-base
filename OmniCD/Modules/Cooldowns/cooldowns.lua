local E, L, C = select(2, ...):unpack()

local _G = _G
local pairs, type = pairs, type
local strmatch = string.match
local abs = math.abs
local GetTime = GetTime
local band = bit.band
local mine = COMBATLOG_OBJECT_AFFILIATION_MINE
local player = COMBATLOG_OBJECT_TYPE_PLAYER
local guardianTotem = COMBATLOG_OBJECT_TYPE_GUARDIAN
local pet = COMBATLOG_OBJECT_TYPE_PET
local hostile = COMBATLOG_OBJECT_REACTION_HOSTILE
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
local spell_sharedCDwTrinkets = E.spell_sharedCDwTrinkets
local spell_benevolentFaeMajorCD = E.spell_benevolentFaeMajorCD
local aura_free_spender = E.aura_free_spender
local cd_start_aura_removed = E.cd_start_aura_removed
local cd_start_aura_applied = E.cd_start_aura_applied
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
local RemoveHighlight = P.RemoveHighlight
local userGUID = E.userGUID
local BOOKTYPE_CATEGORY = E.BOOKTYPE_CATEGORY
local SPELL_AVATAR = 107574
local SPELL_FEIGN_DEATH = 5384
--local DEBUFF_HEARTSTOP_AURA = 214975 -- Blizzard changed this and no longer fires any CLEU

local _
local isUserDisabled -- [82]
local isHighlightEnabled

local totemGUIDS = {}
local petGUIDS = {}

local registeredEvents = setmetatable({}, {
	__index = function(t, k)
		t[k] = {}
		return t[k]
	end
})

local registeredUserEvents = setmetatable({}, {
	__index = function(t, k)
		t[k] = {}
		return t[k]
	end
})

local registeredHostileEvents = setmetatable({}, {
	__index = function(t, k)
		t[k] = {}
		return t[k]
	end
})

function CD:UpdateCombatLogVar()
	isUserDisabled = P.isUserDisabled -- [82]
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

	return reducedTime
end

local function UpdateCdByReducer(info, guid, t, isHolyPriest)
	local talent, duration, target, base, aura = t[1], t[2], t[3], t[4], t[5]
	if aura and not info.auras[aura] then
		return
	end

	local isTalent = P:IsTalent(talent, guid)
	if not target then
		if isTalent then
			for id in pairs(info.active) do
				if id ~= 1856 then
					local icon = info.spellIcons[id]
					if icon and (BOOKTYPE_CATEGORY[icon.category] or icon.categaory == "COVENANT")then
						P:UpdateCooldown(icon, duration)
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
	local talent, duration, target, base = t[1], t[2], t[3], t[4]
	if type(target) == "table" then
		local reducedTime = P:IsTalent(talent, guid) and P:GetValueByType(duration, guid)
		if reducedTime then
			for i = 1, #target do
				local k = target[i]
				local icon = info.spellIcons[k]
				if icon and icon.active and (k ~= SPELL_AVATAR or not info.talentData[k]) then
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

	local linked = spell_linked[spellID]
	if linked then
		for i = 1, #linked do
			local k = linked[i]
			local icon = info.spellIcons[k]
			if icon then
				P:StartCooldown(icon, icon.duration)
			end
		end
		return
	end

	local merged = spell_merged[spellID]
	local icon = info.spellIcons[spellID] or info.spellIcons[merged]
	if icon then
		if spell_preactive[spellID] then
			local activeIcon = icon.active
			local statusBar = icon.statusBar
			if activeIcon then
				if statusBar then
					P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_STOP")
				end
				icon.cooldown:Clear()
			end
			if statusBar then
				statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
			end
			info.preActiveIcons[spellID] = icon
			icon.icon:SetVertexColor(0.4, 0.4, 0.4)

			if spellID == SPELL_FEIGN_DEATH and not P.isInArena then
				info.bar:RegisterUnitEvent("UNIT_AURA", info.unit)
			end
			return
		end

		local updateSpell = spell_updateOnCast[spellID]
		if updateSpell then
			icon.icon:SetTexture(updateSpell[2])
			P:StartCooldown(icon, updateSpell[1])
			return
		end

		P:StartCooldown(icon, icon.duration)
	end

	local shared = spell_sharedCDwTrinkets[spellID]
	if shared then
		local now = GetTime()
		for i = 1, #shared do
			local k = shared[i]
			local icon = info.spellIcons[k]
			if icon then
				local active = icon.active and info.active[k]
				local sharedCD = (spellID == 59752 or k == 59752) and 90 or 30
				if not active or (active.startTime + active.duration - now < sharedCD) then
					P:StartCooldown(icon, sharedCD)
				end
				break
			end
		end
		return
	end

	local reset = cd_reset_cast[spellID]
	if reset then
		for i = 1, #reset do
			local k = reset[i]
			if i > 1 then
				local icon = info.spellIcons[k]
				if icon and icon.active then
					P:ResetCooldown(icon)
				end
			elseif k and not P:IsTalent(k, guid) then
				return
			end
		end
		return
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
		local isUser = guid == userGUID
		local isIgnoredWithoutSync
		local isForcedWithSync

		local procID = info.auras[spellID] or info.auras.all
		if procID then
			local t = aura_free_spender[procID]
			if t[3] then
				isForcedWithSync = t[1] == "all" or t[1] == spellID
			else
				isIgnoredWithoutSync = t[1] == spellID
			end
		end

		local isSync = E.profile.Party.sync and (isUser or E.Comms.syncGUIDS[guid])
		if (not isSync and not isIgnoredWithoutSync) or (isSync and isForcedWithSync) then
			if type(spender[1]) == "table" then
				for i = 1, #spender do
					local t = spender[i]
					UpdateCdBySpender(info, guid, t, isTrueBearing)
				end
			else
				UpdateCdBySpender(info, guid, spender, isTrueBearing)
			end
		end

		if isSync and isUser and spellID == 315341 and icon and icon.active then
			local reducedTime = E.Comms.spentPower
			if reducedTime then
				P:UpdateCooldown(icon, isTrueBearing and reducedTime * 2 or reducedTime)
			end
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


local removeSpenderProc = function(srcGUID, spellID)
	local info = groupInfo[srcGUID]
	if info then
		local k = info.auras[spellID]
		if k then
			local duration = P:GetBuffDuration(info.unit, k)
			if not duration then
				info.auras[spellID] = nil
			end
		end
	end
end

for k, v in pairs(aura_free_spender) do
	local spellID = v[1]
	registeredEvents.SPELL_AURA_REMOVED[k] = function(info) info.auras[spellID] = nil end
	registeredEvents.SPELL_AURA_APPLIED[k] = function(info, srcGUID)
		info.auras[spellID] = k
		E.TimerAfter(v[2], removeSpenderProc, srcGUID, spellID)
	end
end


local function StartCdOnAuraRemoved(info, srcGUID, spellID, destGUID)
	spellID = cd_start_aura_removed[spellID]
	local icon = info.spellIcons[spellID]
	if icon and srcGUID == destGUID then
		local statusBar = icon.statusBar
		if statusBar then
			P:SetExStatusBarColor(icon, statusBar.key)
		end
		info.preActiveIcons[spellID] = nil
		icon.icon:SetVertexColor(1, 1, 1)

		P:StartCooldown(icon, icon.duration)
	end
end

for k, v in pairs(cd_start_aura_removed) do
	registeredEvents.SPELL_AURA_REMOVED[k] = StartCdOnAuraRemoved
end


local function StartCdOnAuraApplied(info, srcGUID, spellID)
	spellID = cd_start_aura_applied[spellID]
	if info.spellIcons[spellID] then
		ProcessSpell(spellID, srcGUID)
	end
end

for k in pairs(cd_start_aura_applied) do
	registeredEvents.SPELL_AURA_APPLIED[k] = StartCdOnAuraApplied
end


do
	local function ReduceCdByDamage(info, srcGUID, spellID, destGUID, critical)
		local t = cd_reduce_damage[spellID]
		local talent, duration, target, maxLimit, minLimit, crit = t[1], t[2], t[3], t[4], t[5], t[6]
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
					active.numHits = active.numHits + 1
					if active.numHits > maxLimit then
						return
					end
				elseif minLimit then
					active.numHits = active.numHits + 1
					if active.numHits ~= minLimit then
						return
					end
				end
				P:UpdateCooldown(icon, duration == 0 and isTalent or duration)
			end
		end
	end

	for k in pairs(cd_reduce_damage) do
		registeredEvents.SPELL_DAMAGE[k] = ReduceCdByDamage
	end

	registeredEvents.SPELL_HEAL[320751] = function(info, srcGUID, spellID, destGUID, _,_,_,_,_, criticalHeal)
		ReduceCdByDamage(info, srcGUID, spellID, nil, criticalHeal)
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
			P:UpdateCooldown(icon, math.min(5, 2 * consumed))
		end

		if info.talentData[334525] then
			local icon = info.spellIcons[DANCING_RUNE_WEAPON]
			if icon and icon.active then
				P:UpdateCooldown(icon, 3 * consumed)
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
				P:UpdateCooldown(icon, 3)
			end
		end
	end
	registeredEvents.SPELL_AURA_REMOVED_DOSE[195181] = ReduceBloodTapDancingRuneWeaponCD
	registeredEvents.SPELL_AURA_REMOVED[195181] = ReduceBloodTapDancingRuneWeaponCD
end



do
	registeredEvents.SPELL_AURA_APPLIED[334722] = function(info)
		local icon = info.spellIcons[49576]
		if icon then
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
			P:StartCooldown(icon, icon.duration)
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
		if info and info.auras.isBerserk then
			info.auras.isBerserk = nil
			local icon = info.spellIcons[FRENZIED_REGEN]
			if icon and icon.active then
				P:UpdateCooldown(icon, 0, nil, 4)
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
			E.TimerAfter(15.1, removeBerserk, nil, srcGUID, spellID, destGUID)
		end
	end

end







do
	local RAPID_FIRE = 257044

	local removeTrueShot = function(info, srcGUID, spellID, destGUID)
		info = info or groupInfo[srcGUID]
		if info and info.auras.isTrueShot then
			info.auras.isTrueShot = nil
			local icon = info.spellIcons[RAPID_FIRE]
			if icon and icon.active then
				P:UpdateCooldown(icon, 0, nil, 2.5)
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

	registeredEvents.SPELL_AURA_REMOVED[263725] = function(info)
		if info.auras.isClearCasting then
			info.auras.isClearCasting = nil
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
		info = groupInfo[srcGUID]
		if info and info.auras.isIcyPropulsion then
			info.auras.isIcyPropulsion = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[ICY_VEINS] = function(info, srcGUID, spellID, destGUID)
		info.auras.isIcyPropulsion = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
	registeredEvents.SPELL_AURA_APPLIED[ICY_VEINS] = function(info, srcGUID, spellID, destGUID)
		if info.spellIcons[ICY_VEINS] and info.talentData[336522] then
			info.auras.isIcyPropulsion = true
			E.TimerAfter(20.1, removeIcyVeins, nil, srcGUID, spellID, destGUID)
		end
	end
end


registeredEvents.SPELL_CAST_SUCCESS[325130] = function(info)
	for id in pairs(info.active) do
		local icon = info.spellIcons[id]
		if icon then
			if BOOKTYPE_CATEGORY[icon.category] and id ~= 314791 and id ~= 342245 then
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


local function ReduceFireBlastCD(info)
	local icon = info.spellIcons[108853]
	if icon and icon.active then
		P:UpdateCooldown(icon, 4)
	end
end
registeredEvents.SPELL_AURA_REMOVED_DOSE[314793] = ReduceFireBlastCD
registeredEvents.SPELL_AURA_REMOVED[314793] = ReduceFireBlastCD


registeredEvents.SPELL_AURA_REMOVED[342246] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[342249] then
		local icon = info.spellIcons[1953]
		if icon and icon.active then
			P:ResetCooldown(icon)
		end
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

-- Cache Phoenix Flame main target
registeredEvents.SPELL_CAST_SUCCESS[257541] = function(info, _,_, destGUID)
	info.auras.phoenixFlameTargetGUID = destGUID
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

	registeredEvents.SPELL_AURA_REMOVED[GUARDIAN_SPIRIT] = function(info, srcGUID, spellID, destGUID)
		local icon = info.spellIcons[GUARDIAN_SPIRIT]
		if icon then
			if info.auras.isSavedByGS then
				info.auras.isSavedByGS = nil
			elseif info.talentData[200209] then
				P:StartCooldown(icon, 60)
			end
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
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
			local activeIcon = icon.active
			local statusBar = icon.statusBar
			if activeIcon then
				if statusBar then
					P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_STOP")
				end
				icon.cooldown:Clear()
			end
			if statusBar then
				statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
			end
			info.preActiveIcons[THOUGHTSTEAL] = icon
			icon.icon:SetVertexColor(0.4, 0.4, 0.4)
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
						P:UpdateCooldown(icon, active.duration / 2 )
					end
				elseif info.talentData[197007] then
					if info.auras.vendettaTargetGUID == destGUID then
						P:UpdateCooldown(icon, active.duration * 0.66 )
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

	registeredEvents.SPELL_AURA_REMOVED[TRICKS_OT_TRADE] = function(info)
		local icon = info.spellIcons[TRICKS_OT_TRADE]
		if icon then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preActiveIcons[TRICKS_OT_TRADE] = nil
			icon.icon:SetVertexColor(1, 1, 1)
		end
	end

	local function StartTricksCD(info, srcGUID, spellID, destGUID)
		local icon = info.spellIcons[TRICKS_OT_TRADE]
		if icon and srcGUID == destGUID then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preActiveIcons[TRICKS_OT_TRADE] = nil
			icon.icon:SetVertexColor(1, 1, 1)

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


local function ReduceFeralSpiritCD(info)
	if info.talentData[335897] then
		local icon = info.spellIcons[51533]
		if icon and icon.active then
			P:UpdateCooldown(icon, 2)
		end
	end
end
registeredEvents.SPELL_AURA_APPLIED[344179] = ReduceFeralSpiritCD
registeredEvents.SPELL_AURA_APPLIED_DOSE[344179] = ReduceFeralSpiritCD


registeredEvents.SPELL_PERIODIC_DAMAGE[188389] = function(info, srcGUID, spellID, destGUID, critical)
	if not critical then
		return
	end

	if info.talentData[336734] then
		local icon = info.spellIcons[198067] or info.spellIcons[192249]
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
	end
end






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
				if icon then
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










do
	local PURIFY_SOUL = 323436

	registeredEvents.SPELL_CAST_SUCCESS[324739] = function(info)
		local icon = info.spellIcons[PURIFY_SOUL]
		if icon then
			info.auras.purifySoulStacks = 3
			icon.Count:SetText(3)
		end
	end

	local startCdOutofCombat = function(guid)
		local info = groupInfo[guid]
		if not info or UnitAffectingCombat(info.unit) then
			return
		end

		local icon = info.spellIcons[PURIFY_SOUL]
		if icon then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preActiveIcons[PURIFY_SOUL] = nil
			icon.icon:SetVertexColor(1, 1, 1)

			P:StartCooldown(icon, icon.duration)
		end
		info.bar.timer_inCombatTicker:Cancel()
	end

	registeredEvents.SPELL_CAST_SUCCESS[PURIFY_SOUL] = function(info)
		local icon = info.spellIcons[PURIFY_SOUL]
		if not icon then
			return
		end

		local stacks = icon.Count:GetText()
		stacks = (tonumber(stacks) or 3) - 1
		icon.Count:SetText(stacks)
		info.auras.purifySoulStacks = stacks

		if info.bar.timer_inCombatTicker then
			info.bar.timer_inCombatTicker:Cancel()
		end

		if not UnitAffectingCombat(info.unit) then
			info.preActiveIcons[PURIFY_SOUL] = nil
			icon.icon:SetVertexColor(1, 1, 1)

			P:StartCooldown(icon, icon.duration)
			return
		end

		local activeIcon = icon.active
		local statusBar = icon.statusBar
		if activeIcon then
			if statusBar then
				P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, "UNIT_SPELLCAST_STOP")
			end
			icon.cooldown:Clear()
		end
		if statusBar then
			statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
		end
		info.preActiveIcons[PURIFY_SOUL] = icon
		icon.icon:SetVertexColor(0.4, 0.4, 0.4)

		info.bar.timer_inCombatTicker = C_Timer.NewTicker(1, function() startCdOutofCombat(icon.guid) end, 1200)
	end
end


local startSoulIgniterCD = function(srcGUID)
	local info = groupInfo[srcGUID]
	if info then
		local icon = info.spellIcons[345251]
		if icon then
			P:StartCooldown(icon, icon.duration)
		end
	end
end
registeredEvents.SPELL_AURA_REMOVED[345211] = function(_, srcGUID)
	E.TimerAfter(0.05, startSoulIgniterCD, srcGUID)
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
		for k in pairs(t) do
			local icon = info.spellIcons[k]
			if icon then
				local active = icon.active and info.active[k]
				local remainingTime = active and (active.duration - now + active.startTime)
				if k == 642 or k == 633 then
					if not active then
						P:StartCooldown(icon, 30, nil, true)
					elseif remainingTime < 30 then
						P:UpdateCooldown(icon, remainingTime - 30)
					end
				else
					local charges = active and active.charges
					if not active or ( icon.maxcharges and charges and charges > 0 or remainingTime < 30 ) then
						info.preActiveIcons[k] = icon
						if not icon.isHighlighted then
							icon.icon:SetVertexColor(0.4, 0.4, 0.4)
						end
						E.TimerAfter(30.1, removeForbearance, destGUID, k)
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
	local BENEVOLENT_FAERIE = 327710

	local function UpdateCDRR(info, modRate)
		local newRate = (info.modRate or 1) * modRate
		local now = GetTime()

		for spellID, active in pairs(info.active) do
			local icon = info.spellIcons[spellID]
			if icon and icon.active then
				if BOOKTYPE_CATEGORY[icon.category] then
					local elapsed = (now - active.startTime) * modRate
					local newTime = now - elapsed
					local cd = (active.duration * modRate)

					local totRate
					local majorCD = spell_benevolentFaeMajorCD[spellID]
					if majorCD and (majorCD == true or majorCD == info.spec) then
						totRate = newRate * (info.auras.benevolent or 1)
					else
						totRate = newRate
					end
					icon.cooldown:SetCooldown(newTime, cd, totRate)
					active.startTime = newTime
					active.duration = cd

					local statusBar = icon.statusBar
					if statusBar and abs(1 - totRate) < 0.05 then
						P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and "UNIT_SPELLCAST_CHANNEL_UPDATE" or "UNIT_SPELLCAST_CAST_UPDATE")
					end
				end
			end
		end

		info.modRate = newRate
	end

	P.UpdateCDRR = UpdateCDRR

	local function UpdateIconRR(info, modRate)
		local newRate = (info.auras.benevolent or 1) * modRate
		local now = GetTime()

		for spellID, active in pairs(info.active) do
			local majorCD = spell_benevolentFaeMajorCD[spellID]
			if majorCD and (majorCD == true or majorCD == info.spec) then
				local icon = info.spellIcons[spellID]
				if icon and icon.active then
					local elapsed = (now - active.startTime) * modRate
					local newTime = now - elapsed
					local cd = (active.duration * modRate)

					icon.cooldown:SetCooldown(newTime, cd, newRate * (info.modRate or 1))
					active.startTime = newTime
					active.duration = cd

					local statusBar = icon.statusBar
					if statusBar and abs(1 - newRate) < 0.05 then
						P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and "UNIT_SPELLCAST_CHANNEL_UPDATE" or "UNIT_SPELLCAST_CAST_UPDATE")
					end

					break
				end
			end
		end

		info.auras.benevolent = newRate
	end

	local function RemoveModRate(_, srcGUID, spellID, destGUID)
		local info = groupInfo[destGUID]
		if not info then
			return
		end

		if spellID == BENEVOLENT_FAERIE then
			UpdateIconRR(info, 2)
		elseif spellID == THUNDERCHARGE then
			UpdateCDRR(info, info.auras.isThunderChargeSelfCast and 1.7 or 1.3)

			info.auras.isThunderChargeSelfCast = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		else
			--UpdateCDRR(info, spellID == DEBUFF_HEARTSTOP_AURA and 0.7 or 1.3)
			UpdateCDRR(info, 1.3)
		end
	end

	local function UpdateModRate(_, srcGUID, spellID, destGUID)
		local spellname = GetSpellInfo(spellID)

		local info = groupInfo[destGUID]
		if not info then
			return
		end

		if spellID == BENEVOLENT_FAERIE then
			UpdateIconRR(info, 0.5)
		elseif spellID ~= THUNDERCHARGE or srcGUID ~= destGUID then
			--UpdateCDRR(info, spellID == DEBUFF_HEARTSTOP_AURA and 1/0.7 or 1/1.3)
			UpdateCDRR(info, 1/1.3)
		end
	end


	registeredEvents.SPELL_AURA_APPLIED[BLESSING_OF_AUTUMN] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[BLESSING_OF_AUTUMN] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE] = RemoveModRate
	registeredEvents.SPELL_AURA_REMOVED[THUNDERCHARGE] = RemoveModRate
	registeredEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE] = function(info, srcGUID, spellID, destGUID)
		if srcGUID == destGUID then -- never userevent
			info.auras.isThunderChargeSelfCast = true
			UpdateCDRR(info, 1/1.7)
		else
			local destInfo = groupInfo[destGUID]
			if destInfo then
				UpdateCDRR(destInfo, 1/1.3)
			end
			if info then -- userevent srcInfo is nil
				UpdateCDRR(info, 1/1.3)
			end
		end
	end

	registeredUserEvents.SPELL_AURA_APPLIED[BLESSING_OF_AUTUMN] = UpdateModRate -- TODO: 30s duration. cache aura and add backup timer
	registeredUserEvents.SPELL_AURA_REMOVED[BLESSING_OF_AUTUMN] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE] = RemoveModRate
	registeredUserEvents.SPELL_AURA_REMOVED[THUNDERCHARGE] = RemoveModRate
	registeredUserEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE] = registeredEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE]


	--registeredHostileEvents.SPELL_AURA_APPLIED[DEBUFF_HEARTSTOP_AURA] = UpdateModRate
	--registeredHostileEvents.SPELL_AURA_REMOVED[DEBUFF_HEARTSTOP_AURA] = RemoveModRate
end


local function ReduceEvasionCD(destInfo, _, spellID, _,_, missType)
	if missType ~= "DODGE" and spellID ~= "DODGE" then
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
registeredHostileEvents.SWING_MISSED.ROGUE = ReduceEvasionCD
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
	registeredEvents.SPELL_AURA_APPLIED[194249] = function(info)
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


local function ReduceUnendingResolveCD(destInfo, _, spellID, _, destName, amount)
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
registeredHostileEvents.SWING_DAMAGE.WARLOCK = function(destInfo, _, spellID, _, destName) ReduceUnendingResolveCD(destInfo, destName, spellID) end
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

setmetatable(registeredEvents, nil)
setmetatable(registeredUserEvents, nil)
setmetatable(registeredHostileEvents, nil)

function CD:COMBAT_LOG_EVENT_UNFILTERED()
	local _, event, _, srcGUID, srcName, srcFlags, _, destGUID, destName, destFlags, _, spellID, _,_, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()

	if band(srcFlags, friendly) == 0 then
		local destInfo = groupInfo[destGUID]
		if not destInfo then
			return
		end

		local func = registeredHostileEvents[event] and (registeredHostileEvents[event][spellID] or registeredHostileEvents[event][destInfo.class])
		if func then
			func(destInfo, srcGUID, spellID, destGUID, destName, amount)
		end
	elseif band(srcFlags, player) > 0 then
		if band(srcFlags, mine) > 0 and isUserDisabled then -- [82]
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

		if info.class == "MAGE" and event == "SPELL_DAMAGE" and critical then
			local specID = info.spec
			if specID == 63 then
				if info.talentData[342344] then
					local icon = info.spellIcons[257541]
					if icon and icon.active then
						P:UpdateCooldown(icon, 1)
					end
				end
			elseif specID == 64 and info.auras.isIcyPropulsion then
				local rankValue = info.talentData[336522]
				if rankValue then
					local icon = info.spellIcons[12472]
					if icon and icon.active and spellID ~= 190357 then -- [84]
						P:UpdateCooldown(icon, rankValue)
					end
				end
			end
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
			active.numHits = active.numHits + 1
			if active.numHits > t[4] then
				return
			end
			P:UpdateCooldown(icon, t[2])
		end
	elseif band(srcFlags, pet) > 0 then
		if event ~= "SPELL_DAMAGE" or not critical then
			return
		end

		local t = cd_reduce_damage_pet[spellID]
		if not t then
			return
		end

		srcGUID = petGUIDS[srcGUID]
		local info = groupInfo[srcGUID]
		if not info then
			return
		end

		local icon = info.spellIcons[t[3]]
		if icon and icon.active then
			local rankVal = info.talentData[t[1]]
			if rankVal then
				P:UpdateCooldown(icon, rankVal)
			end
		end
	end
end

CD.totemGUIDS = totemGUIDS
CD.petGUIDS = petGUIDS
E.ProcessSpell = ProcessSpell
