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
local spell_sharedCDwTrinkets = E.spell_sharedCDwTrinkets
local spell_benevolentFaeMajorCD = E.spell_benevolentFaeMajorCD
local spell_symbolOfHopeMajorCD = E.spell_symbolOfHopeMajorCD
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
local merged_buff_fix = E.merged_buff_fix
local RemoveHighlight = P.RemoveHighlight
local userGUID = E.userGUID
local BOOKTYPE_CATEGORY = E.BOOKTYPE_CATEGORY
--local DEBUFF_HEARTSTOP_AURA = 214975 --> 9.0 Shadowland no longer in CLEU -> Patch 9.1 removed
local FORBEARANCE_DURATION = E.isPreBCC and 60 or 30
local SOULBIND_PODTENDER = 319217

local _
local isUserDisabled
local isHighlightEnabled

local totemGUIDS = {}
local petGUIDS = {}
local spellDestGUIDS = {}

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

	local rankValue = info.talentData[338345] -- Holy Oration (Conduit)
	if rankValue then
		reducedTime = reducedTime * rankValue
	end

	if info.auras.isApotheosisActive then -- Does not affect X'anshi, Return of Archbishop Benedictus (Runeforge)
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
				if id ~= 1856 then -- Vanish
					local icon = info.spellIcons[id]
					if icon and (BOOKTYPE_CATEGORY[icon.category] or icon.category == "COVENANT")then -- incl covenant sig ability
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
	local talent, duration, target, base, aura = t[1], t[2], t[3], t[4], t[5]
	if aura and not info.auras[aura] then
		return
	end

	if type(target) == "table" then
		local reducedTime = P:IsTalent(talent, guid) and P:GetValueByType(duration, guid)
		if reducedTime then
			for i = 1, #target do
				local k = target[i]
				local icon = info.spellIcons[k]
				if icon and icon.active and (k ~= 107574 or not info.talentData[k]) then -- Avatar for Prot
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

	if not E.Comms.syncGUIDS[guid] then
		local covenantID = covenant_abilities[spellID]
		if covenantID then
			P.loginsessionData[guid] = P.loginsessionData[guid] or {}

			local currentCovenantID = P.loginsessionData[guid].covenantID -- iss#316 inspect wipes info.shadowlandsData.covenantID
			if covenantID ~= currentCovenantID then
				if currentCovenantID then
					local currentCovenantSpellID = covenant_IDToSpellID[currentCovenantID]
					P.loginsessionData[guid][currentCovenantSpellID] = nil
					info.talentData[currentCovenantSpellID] = nil
					if currentCovenantID == 3 then
						P.loginsessionData[guid][SOULBIND_PODTENDER] = nil
						info.talentData[SOULBIND_PODTENDER] = nil
					end
				end

				local covenantSpellID = covenant_IDToSpellID[covenantID]
				P.loginsessionData[guid][covenantSpellID] = "C" -- uninspected
				P.loginsessionData[guid].covenantID = covenantID
				info.talentData[covenantSpellID] = "C"          -- inspected (IsTalent)
				info.shadowlandsData.covenantID = covenantID    -- internal

				if spellID == SOULBIND_PODTENDER then
					P.loginsessionData[guid][spellID] = 0
					info.talentData[spellID] = 0
				end

				P:UpdateUnitBar(guid)
			elseif spellID == SOULBIND_PODTENDER and not info.talentData[spellID] then
				P.loginsessionData[guid][spellID] = 0
				info.talentData[spellID] = 0

				P:UpdateUnitBar(guid)
			end
		end
	end

	local mergedID = spell_merged[spellID]

	local linked = spell_linked[mergedID or spellID]
	if linked then
		for i = 2, #linked do
			local k = linked[i]
			local icon = info.spellIcons[k]
			if icon then
				-- Fix mergedID highlighting (mainly for bcc rank spells)
				if E.db.highlight.glowBuffs and mergedID and k == mergedID then
					icon.buff = merged_buff_fix[spellID] or spellID
				end

				if E.isPreBCC then
					info.active[k] = {}
					info.active[k].castedLink = mergedID or spellID
				end
				P:StartCooldown(icon, k ~= spellID and k ~= mergedID and linked[1] or icon.duration)
			end
		end

		return
	end

	local mergedIcon = mergedID and info.spellIcons[mergedID]
	local icon = info.spellIcons[spellID] or mergedIcon
	if icon then
		-- Fix mergedID highlighting
		if E.db.highlight.glowBuffs and mergedIcon then
			icon.buff = merged_buff_fix[spellID] or spellID
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
				icon.icon:SetVertexColor(0.4, 0.4, 0.4) -- icon texture color (icon frame alpha reserved for options)
			end

--          if spellID == 5384 and (E.isBCC or not P.isInArena) then -- Patch 9.1 HSA removed
			if spellID == 5384 then -- Feign Death
				info.bar:RegisterUnitEvent("UNIT_AURA", info.unit)
			end

			return
		end

		local updateSpell = spell_updateOnCast[spellID]
		if updateSpell then
			local cd = updateSpell[1]
			-- Kindred Beasts Patch 9.1 new - TODO: TEST
			cd = mergedID == 272651 and info.talentData[356962] and cd/2 or cd
			icon.icon:SetTexture(updateSpell[2])
			P:StartCooldown(icon, cd)

			return
		end

		P:StartCooldown(icon, icon.duration)
	end

	local reset = cd_reset_cast[spellID]
	if reset then
		for i = 1, #reset do
			local k = reset[i]
			if i > 1 then
				if k == "*" then
					for id in pairs(info.active) do
						if id ~= spellID then
							local icon = info.spellIcons[id]
							if icon and icon.active and BOOKTYPE_CATEGORY[icon.category] then
								P:ResetCooldown(icon)
							end
						end
					end

					break
				end

				local icon = info.spellIcons[k]
				if icon and icon.active then
					if E.isPreBCC and info.active[k].castedLink then -- castedLink is the spellID that started all linked spellID's CD
						if k == info.active[k].castedLink then -- check if castedLink is Frost Ward (not Fire Ward)
							for i = 2, #spell_linked[k] do -- reset all linked spellIDs
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
			elseif k and not P:IsTalent(k, guid) then
				break
			end
		end

		return
	end

	if E.isPreBCC then return end

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

		local isPowerSync = not E.noPowerSync and (isUser or E.Comms.syncGUIDS[guid])
		if (not isPowerSync and not isIgnoredWithoutSync) or (isPowerSync and isForcedWithSync) then
			if type(spender[1]) == "table" then
				for i = 1, #spender do
					local t = spender[i]
					UpdateCdBySpender(info, guid, t, isTrueBearing)
				end
			else
				UpdateCdBySpender(info, guid, spender, isTrueBearing)
			end
		end

		-- Self reducing spell cast by user (POWER_ precedes SPELLCAST_ so sync doesn't work on self reducers)
		if isPowerSync and isUser and icon and icon.active then
			local reducedTime
			if spellID == 315341 then -- Between the Eyes
				reducedTime = E.Comms.spentPower
			end
			if reducedTime then
				P:UpdateCooldown(icon, isTrueBearing and reducedTime * 2 or reducedTime)
			end
		end
	end
end

-- Remove Highlights
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
	if not registeredEvents.SPELL_AURA_REMOVED[spellID] then -- prevent overwriting
		registeredEvents.SPELL_AURA_REMOVED[spellID] = RemoveHighlightByCLEU
	end
end

-- Track spender procs
local removeSpenderProc = function(srcGUID, spellID)
	local info = groupInfo[srcGUID]
	if info then
		local k = info.auras[spellID]
		if k then
			local duration = P:GetBuffDuration(info.unit, k) -- NOTE: check all timer buffs that can refresh itself before falling off
			if not duration then
				info.auras[spellID] = nil
			end
		end
	end
end

for k, v in pairs(aura_free_spender) do -- WoG will only consume Shining Force when Divine Purpose is also present
	local spellID = v[1]
	registeredEvents.SPELL_AURA_REMOVED[k] = function(info, srcGUID, spellID, destGUID)
		info.auras[spellID] = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
	registeredEvents.SPELL_AURA_APPLIED[k] = function(info, srcGUID)
		info.auras[spellID] = k
		E.TimerAfter(v[2], removeSpenderProc, srcGUID, spellID) -- NOTE: auras removed on spell cast, we can omit backup timer
	end
end

-- Start CD by aura removed (preactive spells)
local function StartCdOnAuraRemoved(info, srcGUID, spellID, destGUID)
	if srcGUID == destGUID then -- Misdirection src check to excl pet (pet has buff too)
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

-- Start CD by aura applied (dummy spells)
local function ProcessSpellOnAuraApplied(info, srcGUID, spellID)
	spellID = processSpell_aura_applied[spellID]
	-- skip spellIcons check on ProcessSpell (Adaptation has sharedCD and Podtender is add on cast)
	ProcessSpell(spellID, srcGUID)
end

for k in pairs(processSpell_aura_applied) do
	registeredEvents.SPELL_AURA_APPLIED[k] = ProcessSpellOnAuraApplied
end

-- Reduce CD by Damage/Crit
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
					active.numHits = (active.numHits or 0) + 1 -- fix active.numHits nil err (SPELL_HEAL 1st tick on user fires before SPELL_CAST_SUCCESS/UNIT_SPELLCAST_SUCCEEDED)
					if active.numHits > maxLimit then
						return
					end
				elseif minLimit then
					active.numHits = (active.numHits or 0) + 1
					if active.numHits ~= minLimit then
						return
					end
				end
				P:UpdateCooldown(icon, duration == 0 and isTalent or duration) -- 0 duration is Conduit(talent)
			end
		end
	end

	for k in pairs(cd_reduce_damage) do
		registeredEvents.SPELL_DAMAGE[k] = ReduceCdByDamage
	end
	registeredEvents.SPELL_HEAL[320751] = function(info, srcGUID, spellID, destGUID, _,_,_,_,_, criticalHeal) -- Chain Harvest (Covenant)
		ReduceCdByDamage(info, srcGUID, spellID, nil, criticalHeal)
	end

	-- Thunderlord (Runeforge) - reset numHits
	registeredEvents.SPELL_CAST_SUCCESS[6343] = function(info) -- Thunder Clap
		if info.talentData[335229] then
			local active = info.active[1160] -- Shield Wall
			if active then
				active.numHits = 0
			end
		end
	end

	-- Walk with the Ox (Conduit) - reset numHits
	registeredEvents.SPELL_CAST_SUCCESS[322729] = function(info) -- Spinning Crane Kick
		if info.talentData[337264] then
			local active = info.active[132578] -- Invoke Niuzao, the Black Ox
			if active then
				active.numHits = 0
			end
		end
	end
end

-- Reduce CD by Energize
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

-- Reduce CD by Interrupts
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

------------------------------------------------------------------------------------
-- DK

-- Blood Tap passive / Crimson Rune Weapon (Runeforge)
do
	local BLOOD_TAP = 221699
	local DANCING_RUNE_WEAPON = 49028

	registeredEvents.SPELL_AURA_APPLIED_DOSE[195181] = function(info, _,_,_,_,_,_, amount) -- Marrowrend
		if amount and (info.spellIcons[BLOOD_TAP] or info.spellIcons[DANCING_RUNE_WEAPON]) then -- returns nil for 1 (1st _DOSE). Event fires 3 times (+3 bone shield stacks)
			info.auras.numBoneShields = amount
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[219809] = function(info) -- Tombstone
		local numShields = info.auras.numBoneShields
		if not numShields or numShields == 1 then
			return
		end

		local consumed = math.min(5, numShields)

		local icon = info.spellIcons[BLOOD_TAP]
		if icon and icon.active then
			P:UpdateCooldown(icon, math.min(5, 2 * consumed)) -- TODO: Bug? 5s hidden limit? (is not 1s/stack)
		end

		if info.talentData[334525] then -- Crimson Rune Weapon (Runeforge)
			local icon = info.spellIcons[DANCING_RUNE_WEAPON]
			if icon and icon.active then
				P:UpdateCooldown(icon, 3 * consumed)
			end
		end
	end

	local function ReduceBloodTapDancingRuneWeaponCD(info, _,_,_,_,_,_, amount) -- overkill = amount in AURA_
		local numShields = info.auras.numBoneShields
		if not numShields then
			return
		end

		amount = amount or 0 -- returns nil for 0 on _REMOVED , ends at 1 for _DOSE
		info.auras.numBoneShields = amount

		local consumed = numShields - amount
		if consumed > 1 or consumed < 1 then -- natural decay drops all stacks and doesn't reduce cd
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
	registeredEvents.SPELL_AURA_REMOVED_DOSE[195181] = ReduceBloodTapDancingRuneWeaponCD -- Bone Shield consumed
	registeredEvents.SPELL_AURA_REMOVED[195181] = ReduceBloodTapDancingRuneWeaponCD
end

-- Grip of the Everlasting (Runeforge) -- TODO: Blizzard bug. CD doesn't start sometimes.
do
	registeredEvents.SPELL_AURA_APPLIED[334722] = function(info) -- Grip of the Everlasting aura
		local icon = info.spellIcons[49576] -- Death Grip
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

-- Convocatoin of the Dead (Conduit)
registeredEvents.SPELL_ENERGIZE[195757] = function(info) -- fires for each burst (optional: SPELL_DAMAGE[194311])
	local rankValue = info.talentData[338553]
	if rankValue then
		local icon = info.spellIcons[275699] -- Apocalypse
		if icon and icon.active then
			P:UpdateCooldown(icon, rankValue)
		end
	end
end

------------------------------------------------------------------------------------
-- DH

-- Desperate Instincts
registeredEvents.SPELL_AURA_APPLIED[212800] = function(info) -- Blur buff
	if info.talentData[205411] then
		local icon = info.spellIcons[198589] -- Blur
		if icon and not icon.active then -- if it isn't active then it was auto triggered by Desperate Instincts
			P:StartCooldown(icon, icon.duration/2) -- Patch 9.1 (+cd reduced by 50% on proc)
		end
	end
end

-- Feed the Demon (Talent) / Fiery Soul (Runeforge)
do
	registeredEvents.SPELL_HEAL[203794] = function(info) -- Soul fragment absorbed
		if info.isSoulCleave then
			info.isSoulCleave = false
		end

		if info.talentData[218612] then
			local icon = info.spellIcons[203720] -- Demon Spikes
			if icon and icon.active then
				P:UpdateCooldown(icon, 0.5) -- only the cd is affected by haste, not CDR
			end
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[228477] = function(info) -- Soul Cleave
		if info.talentData[337547] and info.spellIcons[204021] then
			info.isSoulCleave = true
		end
	end

	local function ReduceFieryBrandCD(info)
		if info.isSoulCleave then
			local icon = info.spellIcons[204021] -- Fiery Brand
			if icon and icon.active then
				P:UpdateCooldown(icon, 2)
			end
		end
	end
	registeredEvents.SPELL_AURA_REMOVED_DOSE[203981] = ReduceFieryBrandCD -- Soul Fragments
	registeredEvents.SPELL_AURA_REMOVED[203981] = ReduceFieryBrandCD
end

------------------------------------------------------------------------------------
-- Druid

-- Berserk
do
	local FRENZIED_REGEN = 22842

	local removeBerserk = function(info, srcGUID, spellID, destGUID)
		info = info or groupInfo[srcGUID]
		if info and info.auras.isBerserk then
			info.auras.isBerserk = nil
			local icon = info.spellIcons[FRENZIED_REGEN]
			if icon and icon.active then
				P:UpdateCooldown(icon, 0, nil, 4) -- 4 mult
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
	--> StartCooldown
end

------------------------------------------------------------------------------------
-- Hunter

-- Trueshot (TODO: Bugged? Rapid Fire being increased more than intended)
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
	--> StartCooldown
end

-- Ambuscade (Conduit)
local function ReduceDisengageCD(info, _, spellID)
	local icon = info.spellIcons[781]
	if icon and icon.active then
		local rankValue = info.talentData[346747]
		if rankValue then
			info.auras.time_ambuscade = info.auras.time_ambuscade or {} -- for ea trap
			local now = GetTime()
			if now > (info.auras.time_ambuscade[spellID] or 0) then -- only applied once for AOE traps
				P:UpdateCooldown(icon, rankValue)
				info.auras.time_ambuscade[spellID] = now + 1
			end
		end
	end
end
registeredEvents.SPELL_AURA_APPLIED[203337] = ReduceDisengageCD -- Freezing Trap (w/ Diamond Ice)
registeredEvents.SPELL_AURA_APPLIED[3355] = ReduceDisengageCD   -- Freezing Trap
registeredEvents.SPELL_AURA_APPLIED[135299] = ReduceDisengageCD -- Tar Trap
registeredEvents.SPELL_DAMAGE[236777] = ReduceDisengageCD       -- Hi-Explosive Trap

-- A Murder of Crows
registeredEvents.SPELL_CAST_SUCCESS[131894] = function(info, srcGUID, _, destGUID)
	if info.spellIcons[131894] then -- isTalent
		spellDestGUIDS[destGUID] = spellDestGUIDS[destGUID] or {}
		spellDestGUIDS[destGUID][srcGUID] = spellDestGUIDS[destGUID][srcGUID] or {}
		spellDestGUIDS[destGUID][srcGUID][131894] = true
	end

	C_Timer.After(15, function() -- doesn't fire _AURA events, use duration timer
		if spellDestGUIDS[destGUID] and spellDestGUIDS[destGUID][srcGUID] then
			spellDestGUIDS[destGUID][srcGUID][131894] = nil
		end
	end)
end

------------------------------------------------------------------------------------
-- Mage

-- Arcane Progidy (Conduit)
do
	local ARCANE_PRODIGY = 336873
	local ARCANE_POWER = 12042

	-- Sequential
	registeredEvents.SPELL_AURA_APPLIED[263725] = function(info) -- Clear Casting (no backup timer - removed on single cast)
		if info.spellIcons[ARCANE_POWER] and info.talentData[ARCANE_PRODIGY] then
			info.auras.isClearCasting = true
		end
	end

	registeredEvents.SPELL_CAST_SUCCESS[5143] = function(info, srcGUID) -- Arcane Missile
		if info.auras.isClearCasting then
			info.auras.isArcaneProdigy = true
		elseif info.auras.isArcaneProdigy then
			info.auras.isArcaneProdigy = nil
		end
	end

	-- Merged to Mirros of Torment
	--[[
--  registeredEvents.SPELL_AURA_REMOVED[263725] = function(info) -- Clear Casting
--      if info.auras.isClearCasting then
--          info.auras.isClearCasting = nil
--      end
--  end
	--]]

	registeredEvents.SPELL_DAMAGE[7268] = function(info) -- Arcane Missile (damage)
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

-- Icy Veins w/ Icy Propulsion (Conduit)
do
	local ICY_VEINS = 12472

	local removeIcyVeins = function(info, srcGUID, spellID, destGUID)
		info = info or groupInfo[srcGUID]
		if info and info.auras.isIcyPropulsion then
			info.auras.isIcyPropulsion = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[ICY_VEINS] = removeIcyVeins
	registeredEvents.SPELL_AURA_APPLIED[ICY_VEINS] = function(info, srcGUID, spellID, destGUID)
		if info.spellIcons[ICY_VEINS] and info.talentData[336522] then -- Icy Propulsion
			info.auras.isIcyPropulsion = true
			E.TimerAfter(info.talentData[155149] and 23.1 or 33.1, removeIcyVeins, nil, srcGUID, spellID, destGUID) -- Thermal Void
		end
	end
end

-- Shifting Power (Covenant) & Discipline of the Grove (Conduit)
registeredEvents.SPELL_CAST_SUCCESS[325130] = function(info) -- Shifting Power (Covenant - unique auto-cast ID)
	for id in pairs(info.active) do
		local icon = info.spellIcons[id]
		if icon then
			if BOOKTYPE_CATEGORY[icon.category] and id ~= 314791 and id ~= 342245 then -- Shifting Power, (Alter Time) -- TODO: Bug?
				local reducedTime = 2.5 -- auto casts x4 times
				local rankValue = info.talentData[336992]
				if rankValue then
					reducedTime = reducedTime + rankValue
				end
				P:UpdateCooldown(icon, reducedTime)
			end
		end
	end
end

-- Mirrors of Torment (Covenant)
do
	local MIRRORS_OF_TORMENT = 314793

	local function ReduceFireBlastCD(info)
		local icon = info.spellIcons[108853] -- Fire Mage unique ID
		if icon and icon.active then
			P:UpdateCooldown(icon, 6) -- Patch 9.1 ? 4>6s
		end
	end
	registeredEvents.SPELL_AURA_REMOVED_DOSE[MIRRORS_OF_TORMENT] = ReduceFireBlastCD
	registeredEvents.SPELL_AURA_REMOVED[MIRRORS_OF_TORMENT] = ReduceFireBlastCD

	-- Sinful Delight (Mage-Venthyr-Runeforge) Patch 9.1 new
	local function ProcConsumed(info)
		if info.talentData[354333] then
			local icon = info.spellIcons[MIRRORS_OF_TORMENT]
			if icon and icon.active then
				P:UpdateCooldown(icon, 3)
			end
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[190446] = ProcConsumed -- Brain Freeze
	registeredEvents.SPELL_CAST_SUCCESS[108853] = ProcConsumed -- Fire Blast (Fire mage unique id)
	registeredEvents.SPELL_AURA_REMOVED[263725] = function(info) -- Clearcasting
		if info.auras.isClearCasting then
			info.auras.isClearCasting = nil
		end
		ProcConsumed(info)
	end

	registeredHostileEvents.SPELL_DISPEL[MIRRORS_OF_TORMENT] = function(destInfo)
		if destInfo.talentData[354333] then
			local icon = destInfo.spellIcons[MIRRORS_OF_TORMENT]
			if icon and icon.active then
				P:UpdateCooldown(icon, 45)
			end
		end
	end
end

-- Master of Time (Arcane Talent) - CAVEAT: inadvertently resets when purged, stolen, or clicked off
registeredEvents.SPELL_AURA_REMOVED[342246] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[342249] then -- same tier as Shimmer
		local icon = info.spellIcons[1953] -- Blink
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

------------------------------------------------------------------------------------
-- Monk

-- Bone Marrow Hops (Conduit)
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
registeredEvents.SPELL_DAMAGE[325217] = ReduceBoneMarrowHopsCD -- Bonedust Brew
registeredEvents.SPELL_HEAL[325218] = ReduceBoneMarrowHopsCD

-- Rising Sun Revival (Conduit)
registeredEvents.SPELL_CAST_SUCCESS[107428] = function(info) -- Rising Sun Kick
	local rankValue = info.talentData[337099]
	if rankValue then
		local icon = info.spellIcons[115310] -- Revival
		if icon and icon.active then
			P:UpdateCooldown(icon, rankValue)
		end
	end
end

-- Blackout Combo (Talent)
-- TODO: aura on every blackout kick. check icon exists? (all brews + BoF)
registeredEvents.SPELL_AURA_APPLIED[228563] = function(info) info.auras.isBlackoutCombo = true end
registeredEvents.SPELL_AURA_REMOVED[228563] = function(info) info.auras.isBlackoutCombo = nil end

-- Weapons of Order (Covenant)
registeredEvents.SPELL_AURA_APPLIED[310454] = function(info) info.auras.isWeaponsOfOrder = true end -- no backup timer - removed on 1 cast
registeredEvents.SPELL_AURA_REMOVED[310454] = function(info, srcGUID, spellID, destGUID)
	info.auras.isWeaponsOfOrder = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

-- Eminence (pvp talent) Patch 9.1 new
do
	-- Stun data from DRList-1.0
	-- https://www.curseforge.com/wow/addons/drlist-1-0
	-- https://www.curseforge.com/wow/addons/diminish
	local stunDebuffs = {
		[210141]  = true,            -- Zombie Explosion
		[334693]  = true,            -- Absolute Zero (Breath of Sindragosa)
		[108194]  = true,            -- Asphyxiate (Unholy)
		[221562]  = true,            -- Asphyxiate (Blood)
		[91800]   = true,            -- Gnaw (Ghoul)
		[91797]   = true,            -- Monstrous Blow (Mutated Ghoul)
		[287254]  = true,            -- Dead of Winter
		[179057]  = true,            -- Chaos Nova
--      [213491]  = true,            -- Demonic Trample (Only DRs with itself once)
		[205630]  = true,            -- Illidan's Grasp (Primary effect)
		[208618]  = true,            -- Illidan's Grasp (Secondary effect)
		[211881]  = true,            -- Fel Eruption
		[200166]  = true,            -- Metamorphosis (PvE stun effect)
		[203123]  = true,            -- Maim
		[163505]  = true,            -- Rake (Prowl)
		[5211]    = true,            -- Mighty Bash
		[202244]  = true,            -- Overrun
		[325321]  = true,            -- Wild Hunt's Charge
		[24394]   = true,            -- Intimidation
		[119381]  = true,            -- Leg Sweep
		[202346]  = true,            -- Double Barrel
		[853]     = true,            -- Hammer of Justice
		[255941]  = true,            -- Wake of Ashes
		[64044]   = true,            -- Psychic Horror
		[200200]  = true,            -- Holy Word: Chastise Censure
		[1833]    = true,            -- Cheap Shot
		[408]     = true,            -- Kidney Shot
		[118905]  = true,            -- Static Charge (Capacitor Totem)
		[118345]  = true,            -- Pulverize (Primal Earth Elemental)
		[305485]  = true,            -- Lightning Lasso
		[89766]   = true,            -- Axe Toss
		[171017]  = true,            -- Meteor Strike (Infernal)
		[171018]  = true,            -- Meteor Strike (Abyssal)
--      [22703]   = true,            -- Infernal Awakening (doesn't seem to DR)
		[30283]   = true,            -- Shadowfury
		[46968]   = true,            -- Shockwave
		[132168]  = true,            -- Shockwave (Protection)
		[145047]  = true,            -- Shockwave (Proving Grounds PvE)
		[132169]  = true,            -- Storm Bolt
		[199085]  = true,            -- Warpath
--      [213688]  = true,            -- Fel Cleave (doesn't seem to DR)
		[20549]   = true,            -- War Stomp (Tauren)
		[255723]  = true,            -- Bull Rush (Highmountain Tauren)
		[287712]  = true,            -- Haymaker (Kul Tiran)
		[280061]  = true,            -- Brainsmasher Brew (Item)
		[245638]  = true,            -- Thick Shell (Item)
		[332423]  = true,            -- Sparkling Driftglobe Core
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
		if P.isPvP and info.talentData[353584] then
			local icon = info.spellIcons[TRANSCENDENCE_TRANSFER]
			if icon and (not info.auras.isStunned or info.auras.isStunned < 1) then
				P:UpdateCooldown(icon, 15)
			end
		end
	end
end

-- Sinister Teachings (Monk-Venthyr-Runeforge) Patch 9.1 new - TODO: TEST (internal cd)
do
	local removeFallenOrder = function(srcGUID, spellID, destGUID)
		local info = groupInfo[srcGUID]
		if info then
			info.auras.isFallenOrder = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[326860] = function(info, srcGUID, spellID, destGUID) -- Fallen Order (Covenant)
		if info.auras.isFallenOrder then
			E.TimerAfter(6, removeFallenOrder, srcGUID, spellID, destGUID)
		end
	end

	registeredEvents.SPELL_AURA_APPLIED[326860] = function(info, srcGUID, spellID, destGUID)
		if info.talentData[356818] and info.spellIcons[326860] then
			info.auras.isFallenOrder = true
			E.TimerAfter(30.1, removeFallenOrder, srcGUID, spellID, destGUID)
		end
	end
end

-- Pressure Points (PvP Talent)
registeredEvents.SPELL_DAMAGE[322109] = function(info, srcGUID, spellID, destGUID, critical, destFlags, amount, overkill) -- Touch of Death
	if overkill > -1 and P:IsTalent(345829, srcGUID) and band(destFlags, player) > 0 then -- use 'P:IsTalent' or 'P.isPvP and info.talentData(id)' for pvp status checks on pvp talents
		local icon = info.spellIcons[122470]
		if icon and icon.active then
			P:UpdateCooldown(icon, 60)
		end
	end
end

------------------------------------------------------------------------------------
-- Paladin

-- Healing Hands
registeredEvents.SPELL_HEAL[633] = function(info, _,_,_,_,_, amount, overhealing, destName) -- Lay on Hands
	if info.talentData[326734] then -- Healing Hands
		local icon = info.spellIcons[633]
		if icon then -- skip active check and use timer: _HEAL _AURA fires before _CAST
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

-- Resolute Defender (Conduit)
registeredEvents.SPELL_CAST_SUCCESS[53600] = function(info) -- Shield of the Righteous
	local rankValue = info.talentData[340023]
	if rankValue then
		local icon = info.spellIcons[31850]
		if icon and icon.active then
			P:UpdateCooldown(icon, rankValue)
		end
	end
end

-- Moment of Glory
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

	registeredEvents.SPELL_CAST_SUCCESS[31935] = function(info) -- Avenger's Shield
		local icon = info.spellIcons[31935]
		if icon and not info.auras.isMomentOfGlory then
			P:StartCooldown(icon, icon.duration)
		end
	end
end

-- Crusader's Might
registeredEvents.SPELL_CAST_SUCCESS[35395] = function(info) -- Crusader Strike
	local icon = info.spellIcons[20473] -- Holy Shock
	if icon and info.talentData[196926] then
		P:UpdateCooldown(icon, 1.0) -- Patch 9.1 1.5>1s
	end
end

-- Radiant Embers (Paladin-Venthyr-Runeforge) Patch 9.1 new - TODO: TEST
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
				local remainingTime = 47 - now + info.auras.ashenHollowST -- duration increased 50% from Radiant Embers, 2+sec since last tick
				if remainingTime > 0.25 then -- 0.25 reduce cd by 1s
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

------------------------------------------------------------------------------------
-- Priest

-- Apotheosis
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

-- Guardian Angel
do
	local GUARDIAN_SPIRIT = 47788

	local onGSRemoval = function(srcGUID, spellID, destGUID)
		local info = groupInfo[srcGUID]
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

	registeredEvents.SPELL_AURA_REMOVED[GUARDIAN_SPIRIT] = function(info, srcGUID, spellID, destGUID)
		E.TimerAfter(0.1, onGSRemoval, srcGUID, spellID, destGUID)
	end

	-- NOTE: check all spells casted to others (fires before/after SPELL_AURA_REMOVED for self/party)
	registeredEvents.SPELL_HEAL[48153] = function(info) -- Heal when GS procs = prevented death
		if info.spellIcons[GUARDIAN_SPIRIT] then
			info.auras.isSavedByGS = true
		end
	end
end

-- X'anshi, Return of Archbishop Benedictus (Runeforge)
registeredEvents.SPELL_AURA_APPLIED[211319] = function(info) -- Archbishop Benedictus' Restitution (don't need talentData check for unique auras)
	local icon = info.spellIcons[20711] -- Spirit of Redemption
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end

-- Power Unto Others (Conduit)
registeredEvents.SPELL_CAST_SUCCESS[10060] = function(info, srcGUID, _, destGUID)
	local rankValue = info.talentData[337762]
	if rankValue and srcGUID ~= destGUID then
		local icon = info.spellIcons[10060] -- Power Infusion
		if icon and icon.active then
			P:UpdateCooldown(icon, rankValue)
		end
	end
end

-- Thoughtsteal
-- cd resets if you're unable to find a spell to steal ? -> temp fix: 316262 added to dispels to exclude from UNIT_
do
	local THOUGHTSTEAL = 316262

	registeredEvents.SPELL_AURA_APPLIED[322431] = function(info) -- stolen Buff
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

	registeredEvents.SPELL_AURA_REMOVED[322431] = function(info) -- cd starts when stolen buff is removed from player (323716 stolen debuff on target)
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

-- Death and Madness (Talent) -- no exp, honor gain requirement on kills
do
	local function ResetShadowWordDeath(info)
		local icon = info.spellIcons[32379] -- Shadow Word: Death
		if icon and icon.active then
			P:ResetCooldown(icon)
		end
	end

	registeredEvents.SPELL_AURA_APPLIED[321973] = ResetShadowWordDeath -- Death and Madness (unique aura on kill, isTalent)
	registeredEvents.SPELL_AURA_REFRESH[321973] = ResetShadowWordDeath
end

-- Spheres' Harmony (Priest-Kyrian-Runeforge) Patch 9.1 new
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

------------------------------------------------------------------------------------
-- Rogue

-- Silhouette / Intent to Kill
do
	local VENDETTA = 79140
	local SHADOW_STEP = 36554

	local removeVendettaTarget = function(info, srcGUID) -- no buff on src = no highlight
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

	registeredEvents.SPELL_CAST_SUCCESS[SHADOW_STEP] = function(info, _, spellID, destGUID, _, destFlags) -- Shadowstep
		if not P.isPvP then -- instead of IsTalent
			return
		end

		local icon = info.spellIcons[spellID]
		if icon and icon.active then
			local active = info.active[spellID]
			if active then
				if info.talentData[197899] then -- Silhouette (Subtlety)
					if band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 then
						P:UpdateCooldown(icon, active.duration * 0.67 ) -- Patch 9.1 0.5>0.67
					end
				elseif info.talentData[197007] then -- Intent to Kill (Assassination)
					if info.auras.vendettaTargetGUID == destGUID then
						P:UpdateCooldown(icon, active.duration * 0.90 ) -- Patch 9.1 0.66>0.9
					end
				end
			end
		end
	end
end

-- True Bearing
do
	local TRUE_BEARING = 193359

	local removeTrueBearing = function(srcGUID)
		local info = groupInfo[srcGUID]
		if info and info.auras.isTrueBearing then
			local duration = P:GetBuffDuration(info.unit, TRUE_BEARING) -- check if buff can re-apply before falling off
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

-- Tricks of the Trade ( -- TODO: check if src == dest check is required.)
do
	local TRICKS_OT_TRADE = 57934

	registeredEvents.SPELL_AURA_REMOVED[TRICKS_OT_TRADE] = function(info, srcGUID, spellID, destGUID) -- Tricks doesn't go on CD if its not used after pre-activating
		local icon = info.spellIcons[TRICKS_OT_TRADE]
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
		local icon = info.spellIcons[TRICKS_OT_TRADE] -- merged Thick as Thieves
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

-- Sepsis
registeredEvents.SPELL_AURA_APPLIED[347037] = function(info) info.auras.isSepsis = true end -- free stealth proc 5s = target survived full duration
registeredEvents.SPELL_AURA_REMOVED[347037] = function(info) info.auras.isSepsis = nil end
registeredEvents.SPELL_AURA_REMOVED[328305] = function(info) -- target debuff (if target survived full duration then this fires after(equal GetTime) SPELL_AURA_APPLIED[347037])
	if not info.auras.isSepsis then -- ended before it's full duration
		local icon = info.spellIcons[328305]
		if icon and icon.active then
			P:UpdateCooldown(icon, 30)
		end
	end
end

-- Serrated Bone Spikes (Covenant)
do
	registeredEvents.SPELL_AURA_APPLIED[324073] = function(info, srcGUID, _, destGUID)
		if info.spellIcons[328547] then
			spellDestGUIDS[destGUID] = spellDestGUIDS[destGUID] or {}
			spellDestGUIDS[destGUID][srcGUID] = spellDestGUIDS[destGUID][srcGUID] or {}
			spellDestGUIDS[destGUID][srcGUID][328547] = true
		end
	end

	registeredEvents.SPELL_AURA_REMOVED[324073] = function(info, srcGUID, _, destGUID)
		if info.spellIcons[328547] then
			C_Timer.After(0.5, function() -- delay to run after UNIT_DIED
				if spellDestGUIDS[destGUID] and spellDestGUIDS[destGUID][srcGUID] then
					spellDestGUIDS[destGUID][srcGUID][328547] = nil
				end
			end)
		end
	end
end

-- Obedience (Rogue-Venthyr-Runeforge) Patch 9.1 new - TODO: TEST
do
	registeredEvents.SPELL_AURA_REMOVED[323654] = function(info, srcGUID, spellID, destGUID) -- haste buff 'Flagellation' 345569 is applied on _REMOVED
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

------------------------------------------------------------------------------------
-- Shaman

-- Reincarnation (no UNIT_)
registeredEvents.SPELL_CAST_SUCCESS[21169] = function(info) -- AURA_REMOVED 225082 fires on normal res
	local icon = info.spellIcons[20608]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end

-- Static Charge
registeredEvents.SPELL_SUMMON[192058] = function(info, srcGUID, spellID, destGUID)
	local icon = info.spellIcons[spellID]
	if icon and info.talentData[265046] then
		local capGUID = info.auras.capTotemGUID
		if capGUID then -- remove old. Pet/Guardians are assigned a new GUID on summon
			totemGUIDS[capGUID] = nil
		end
		totemGUIDS[destGUID] = srcGUID
		info.auras.capTotemGUID = destGUID
	end
end

-- Nature's Guardian
registeredEvents.SPELL_HEAL[31616] = function(info)
	local icon = info.spellIcons[30884] -- Nature's Guardian
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end

-- Surge of Power
registeredEvents.SPELL_AURA_REMOVED[285514] = function(info) info.auras.isSurgeOfPower = nil end
registeredEvents.SPELL_AURA_APPLIED[285514] = function(info)
	if info.spellIcons[198067] or info.spellIcons[192249] then
		info.auras.isSurgeOfPower = true -- removed after 1 lava burst cast
	end
end

-- Witch Doctor's Wolf Bones (Runeforge)
local function ReduceFeralSpiritCD(info)
	if info.talentData[335897] then
		local icon = info.spellIcons[51533] -- Feral Spirit
		if icon and icon.active then
			P:UpdateCooldown(icon, 2)
		end
	end
end
registeredEvents.SPELL_AURA_APPLIED[344179] = ReduceFeralSpiritCD -- Maelstrom Weapon
registeredEvents.SPELL_AURA_APPLIED_DOSE[344179] = ReduceFeralSpiritCD

-- Skybreaker's Fiery Demise (Runeforge)
registeredEvents.SPELL_PERIODIC_DAMAGE[188389] = function(info, srcGUID, spellID, destGUID, critical)
	if not critical then
		return
	end

	if info.talentData[336734] then
		local icon = info.spellIcons[198067] or info.spellIcons[192249] -- Fire Elemental, Storm Elemental
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
	end
end

-- Seeds of Rampant Growth (Shaman-Night Fae-Runeforge) Patch 9.1 new - TODO: TEST
registeredEvents.SPELL_DAMAGE[328928] = function(info, _,_, destGUID) -- Fae Transfusion damageID
	if info.talentData[356218] then
		local now = GetTime()
		if now > (info.auras.faeTransfusionLT or 0) then
			-- compatibility for OCDE
			local icon = info.spellIcons[198067] or info.spellIcons[192249] -- Fire/Storm Elemental
			if icon then
				if icon.active then
					P:UpdateCooldown(icon, 6)
				end
				return
			end
			icon = info.spellIcons[51533] -- Feral Spirit
			if icon then
				if icon.active then
					P:UpdateCooldown(icon, 7)
				end
				return
			end
			icon = info.spellIcons[108280] -- Healing Tide Totem
			if icon then
				if icon.active then
					P:UpdateCooldown(icon, 5)
				end
			end

			info.auras.faeTransfusionLT = now + 0.1 -- cdr is per pulse not ea. dmg
		end
	end
end

------------------------------------------------------------------------------------
-- Warlock

-- Scouring Tithe (Covenant)
do
	local SCOURING_TITHE = 312321

	registeredEvents.SPELL_ENERGIZE[312379] = function(info) -- Scouring Tithe (5 Soul Shard)
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

	registeredEvents.SPELL_AURA_REMOVED[SCOURING_TITHE] = function(info, srcGUID) -- doesn't fire sometimes when target dies (no matter)
		local icon = info.spellIcons[SCOURING_TITHE]
		if icon then
			E.TimerAfter(0.5, resetScouringTitheCD, srcGUID) -- energize can fire a lot later
		end
	end
end

-- Shadowburn
registeredEvents.SPELL_CAST_SUCCESS[17877] = function(info, srcGUID, _, destGUID) -- PARTY_KILL fires before SPELL_DAMAGE if it's killed instantly on cast
	if info.spellIcons[17877] then -- isTalent
		spellDestGUIDS[destGUID] = spellDestGUIDS[destGUID] or {}
		spellDestGUIDS[destGUID][srcGUID] = spellDestGUIDS[destGUID][srcGUID] or {}
		if spellDestGUIDS[destGUID][srcGUID][17877] then -- refresh timer, Shadowburn has 2 charges
			spellDestGUIDS[destGUID][srcGUID][17877]:Cancel()
		end
		spellDestGUIDS[destGUID][srcGUID][17877] = C_Timer.NewTicker(5, function()
			if spellDestGUIDS[destGUID] and spellDestGUIDS[destGUID][srcGUID] then
				spellDestGUIDS[destGUID][srcGUID][17877] = nil
			end
		end, 1)
	end
end

------------------------------------------------------------------------------------
-- Warrior


------------------------------------------------------------------------------------
-- MISC.

-- Consumables (CD starts OOC)
do
	local consumables = { --> added to cd_start_dispels to bypass UNIT_SPELLCAST_SUCCEEDED
		323436, -- Purify Soul
		6262,   -- Healthstone
		307192, -- Spiritual Healing Potion
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

	local function StartConsumablesCD(info, _, spellID)
		local icon = info.spellIcons[spellID]
		if icon then
			if spellID == 323436 then
				local stacks = icon.Count:GetText()
				stacks = (tonumber(stacks) or 3) - 1
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
				if statusBar then
					statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
				end
				info.preActiveIcons[spellID] = icon
				icon.icon:SetVertexColor(0.4, 0.4, 0.4)

				info.bar.timer_inCombatTicker = C_Timer.NewTicker(1, function() startCdOutOfCombat(icon.guid) end, 1000)
			else
				info.preActiveIcons[spellID] = nil
				icon.icon:SetVertexColor(1, 1, 1)

				P:StartCooldown(icon, icon.duration)
			end
		end
	end

	for i = 1, #consumables do
		local spellID = consumables[i]
		registeredEvents.SPELL_CAST_SUCCESS[spellID] = StartConsumablesCD -- 331609 Forgelite Filter (Soulbind) makes it auto proc (Conduit make it heal over time, fires SPELL_HEAL multiple times)
	end

	-- Purify Soul (Covenant Signature Ability)
	registeredEvents.SPELL_CAST_SUCCESS[324739] = function(info) -- Summon Steward (Reset stacks)
		local icon = info.spellIcons[323436]
		if icon then
			info.auras.purifySoulStacks = 3
			icon.Count:SetText(3)
		end
	end
end

-- Effusive Anima Accelerator (Soulbind Ability non-conduit) Patch 9.1 new
do
	local kyrianAbilityByClass = {
		WARRIOR = { 307865, 4   },  -- Spear of Bastion
		PALADIN = { 304971, 4   },  -- Divine Toll
		HUNTER  = { 308491, 4   },  -- Resonating Arrow
		ROGUE   = { 323547, 3   },  -- Echoing Reprimand
		PRIEST  = { 325013, 12  },  -- Boon of the Ascended
		DEATHKNIGHT = { 312202, 4   },  -- Shackle the Unworthy
		SHAMAN  = { 324386, 4   },  -- Versper Totem
		MAGE    = { 307443, 2   },  -- Radiant Spark
		WARLOCK = { 312321, 3   },  -- Scouring Tithe
		MONK    = { 310454, 8   },  -- Weapons of Order
		DRUID   = { 338142, 4   },  -- Lone Empowerment (Bal, Feral) - used inplace of Kindred Spirits
		DEMONHUNTER = { 306830, 4   },  -- Elysian Decree
	}

	registeredEvents.SPELL_AURA_APPLIED[353248] = function(info)
		--if info.talentData[352188] then -- aura isTalent
			local t = kyrianAbilityByClass[info.class]
			local target, rt = t[1], t[2]
			local icon = info.spellIcons[target]
			local active = icon and icon.active and info.active[target]
			if active then
				active.numHits = (active.numHits or 0) + 1 -- numHits reset on StartCooldown
				if active.numHits > 5 then -- max: rt *5
					return
				end
				P:UpdateCooldown(icon, rt)
			end
		--end
	end
end

-- Soul Igniter (SL Trinket)
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
	E.TimerAfter(0.05, startSoulIgniterCD, srcGUID, spellID, destGUID) -- CD starts when you cast it a second time, so delay event so UNIT_SPELLCAST_SUCCEEDED doesn't make it preactive again
end

-- Dispels
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

-- Forbearance
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
				if v == true then
					if not active then
						P:StartCooldown(icon, FORBEARANCE_DURATION, nil, true)
					elseif remainingTime < FORBEARANCE_DURATION then
						P:UpdateCooldown(icon, remainingTime - FORBEARANCE_DURATION)
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

-- CDRR
do
	local THUNDERCHARGE = 204366 -- Self applying. doesnt matter if UNIT_ fires after SELL_AURA_ since ModRate is applied in StartCooldown()
	-- Shadowlands...
	-- Multiplicative
	-- CDRR + IconRR TESTED, (Feral Charge: Thundercharge + Benevolent)
	-- IconRR + IconRR TESTED, (Fortifying Brew: Benevolent + Symbol of hope)
	local BLESSING_OF_AUTUMN = 328622
	local BENEVOLENT_FAERIE = 327710
	local BENEVOLENT_FAERIE_FERMATA = 345453
	local HAUNTED_MASK = 356968
	local SYMBOL_OF_HOPE = 265144 -- unique cdr buffID (not used for highlighting)
	local EMERALD_SLUMBER = 329042
	local INTIMIDATION_TACTICS = 353210 -- Patch 9.1 new

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
						if spellID == 300728 and info.auras.intimidation then -- Door of Shadows (Covenant Signature Ability)
							totRate = totRate * info.auras.intimidation
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
		end

		info.modRate = newRate
	end

--  P.UpdateCDRR = UpdateCDRR -- Patch 9.1 HSA removed

	local function UpdateIconRR(info, modType, modRate)
		local newRate = (info.auras[modType] or 1) * modRate
		local isRemoved = abs(1 - newRate) < 0.05
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

					if spellID == 115203 then -- Temp Fix: Fortyfying Brew(BM) is modulated by both symbol and benevolent
						icon.cooldown:SetCooldown(newTime, cd, (newRate * (info.auras[modType == "symbol" and "benevolent" or "symbol"] or 1)) * (info.modRate or 1))
					else
						icon.cooldown:SetCooldown(newTime, cd, newRate * (info.modRate or 1))
					end
					active.startTime = newTime
					active.duration = cd

					local statusBar = icon.statusBar
					if statusBar and isRemoved then
						P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and "UNIT_SPELLCAST_CHANNEL_UPDATE" or "UNIT_SPELLCAST_CAST_UPDATE")
					end

					break
				end
			end
		end

		info.auras[modType] = not isRemoved and newRate
	end

	local function RemoveModRate(info, srcGUID, spellID, destGUID)
		local destInfo = groupInfo[destGUID]
		if not destInfo then
			return
		end

		if spellID == INTIMIDATION_TACTICS then
			if destInfo.auras["intimidation"] then
				UpdateIconRR(destInfo, "intimidation", 3)
			end
		elseif spellID == BENEVOLENT_FAERIE then
			if destInfo.auras["benevolent"] then
				UpdateIconRR(destInfo, "benevolent", 2)
			end
		elseif spellID == BENEVOLENT_FAERIE_FERMATA then
			if destInfo.auras["benevolent"] then
				UpdateIconRR(destInfo, "benevolent", 1.8)
			end
		elseif spellID == HAUNTED_MASK then
			if destInfo.auras["benevolent"] and destInfo.auras.haunted then
				UpdateIconRR(destInfo, "benevolent", 1.5)
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
				UpdateCDRR(destInfo, 5, EMERALD_SLUMBER) -- not self reducing
				destInfo.auras[spellID] = nil
			end
			RemoveHighlightByCLEU(destInfo, srcGUID, spellID, destGUID)
		else
			if destInfo.auras[spellID] then
--              UpdateCDRR(info, spellID == DEBUFF_HEARTSTOP_AURA and 0.7 or 1.3)
				UpdateCDRR(destInfo, 1.3)
				destInfo.auras[spellID] = nil
			end
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
			UpdateIconRR(destInfo, "benevolent", 0.5)
		elseif spellID == BENEVOLENT_FAERIE_FERMATA then
			UpdateIconRR(destInfo, "benevolent", 1/1.8)
		-- 1. Requires Benevolent Fae buff to be active when mask is applied
		-- 2. Fae can be moved to others and mask will continue to apply CDR
		elseif spellID == HAUNTED_MASK then
			if destInfo.auras.benevolent then
				destInfo.auras.haunted = true
				UpdateIconRR(destInfo, "benevolent", 1/1.5)
			end
		elseif spellID == SYMBOL_OF_HOPE then -- 40yd range, no aura if OOR
			local _,_,_, startTimeMS, endTimeMS = UnitChannelInfo(info and info.unit or "player") -- iss#275 info is nil for registeredUserEvents
			if startTimeMS and endTimeMS then
				local channelTime = (endTimeMS - startTimeMS) / 1000
				UpdateIconRR(destInfo, "symbol", 1 / ((60 + channelTime) / channelTime))
			end
		elseif spellID == EMERALD_SLUMBER then
			destInfo.auras[spellID] = true
			UpdateCDRR(destInfo, 0.2, EMERALD_SLUMBER)
		elseif spellID ~= THUNDERCHARGE or srcGUID ~= destGUID then
			destInfo.auras[spellID] = true
--          UpdateCDRR(info, spellID == DEBUFF_HEARTSTOP_AURA and 1/0.7 or 1/1.3)
			UpdateCDRR(destInfo, 1/1.3)
		end
	end

	-- No backup
	registeredEvents.SPELL_AURA_REMOVED[THUNDERCHARGE] = RemoveModRate
	registeredEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE] = function(info, srcGUID, spellID, destGUID) -- TODO: Bug?. cast on self 70%, cast on party - self 30%
		if srcGUID == destGUID then -- never userevent
			info.auras.isThunderChargeSelfCast = true
			info.auras[spellID] = true
			UpdateCDRR(info, 1/1.7)
		else
			local destInfo = groupInfo[destGUID]
			if destInfo then
				destInfo.auras[spellID] = true
				UpdateCDRR(destInfo, 1/1.3)
			end
			if info then -- userevent srcInfo is nil
				info.auras[spellID] = true
				UpdateCDRR(info, 1/1.3)
			end
		end
	end
	registeredEvents.SPELL_AURA_APPLIED[BLESSING_OF_AUTUMN] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[BLESSING_OF_AUTUMN] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE] = UpdateModRate -- does not fire _REFRESH
	registeredEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE_FERMATA] = UpdateModRate -- don't need rankValue for this Conduit
	registeredEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE_FERMATA] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[HAUNTED_MASK] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[HAUNTED_MASK] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[SYMBOL_OF_HOPE] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[SYMBOL_OF_HOPE] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[EMERALD_SLUMBER] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[EMERALD_SLUMBER] = RemoveModRate
	registeredEvents.SPELL_AURA_APPLIED[INTIMIDATION_TACTICS] = UpdateModRate
	registeredEvents.SPELL_AURA_REMOVED[INTIMIDATION_TACTICS] = RemoveModRate

	registeredUserEvents.SPELL_AURA_REMOVED[THUNDERCHARGE] = RemoveModRate
	registeredUserEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE] = registeredEvents.SPELL_CAST_SUCCESS[THUNDERCHARGE]
	registeredUserEvents.SPELL_AURA_APPLIED[BLESSING_OF_AUTUMN] = UpdateModRate -- TODO: 30s duration. cache aura and add backup timer
	registeredUserEvents.SPELL_AURA_REMOVED[BLESSING_OF_AUTUMN] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[BENEVOLENT_FAERIE_FERMATA] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[BENEVOLENT_FAERIE_FERMATA] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[HAUNTED_MASK] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[HAUNTED_MASK] = RemoveModRate
	registeredUserEvents.SPELL_AURA_APPLIED[SYMBOL_OF_HOPE] = UpdateModRate
	registeredUserEvents.SPELL_AURA_REMOVED[SYMBOL_OF_HOPE] = RemoveModRate

	-- CDRR
--  registeredHostileEvents.SPELL_AURA_APPLIED[DEBUFF_HEARTSTOP_AURA] = UpdateModRate
--  registeredHostileEvents.SPELL_AURA_REMOVED[DEBUFF_HEARTSTOP_AURA] = RemoveModRate
end

-- Prepared for All (Conduit)
local function ReduceEvasionCD(destInfo, _,_, missType) -- missType = amount
	if missType ~= "DODGE" then -- TODO: does spell miss have dodge?
		return
	end

	local rankValue = destInfo.talentData[341535]
	if rankValue then
		local icon = destInfo.spellIcons[5277] -- Evasion
		if icon and icon.active then
			local now = GetTime()
			if now > (destInfo.auras.time_dodged or 0) then
				P:UpdateCooldown(icon, rankValue)
				destInfo.auras.time_dodged = now + 1 -- stealth nerfed
			end
		end
	end
end
registeredHostileEvents.SWING_MISSED.ROGUE = function(destInfo, _, spellID) ReduceEvasionCD(destInfo, nil, nil, spellID) end
registeredHostileEvents.RANGE_MISSED.ROGUE = ReduceEvasionCD
registeredHostileEvents.SPELL_MISSED.ROGUE = ReduceEvasionCD

-- Driven to Madness (PvP Talent)
do
	local removeVoidForm = function(srcGUID, spellID, destGUID)
		local info = groupInfo[srcGUID]
		if info and info.auras.isVoidForm then
			info.auras.isVoidForm = nil
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
	registeredEvents.SPELL_AURA_REMOVED[194249] = function(info, srcGUID, spellID, destGUID) -- Void Form
		info.auras.isVoidForm = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
	registeredEvents.SPELL_AURA_APPLIED[194249] = function(info, srcGUID, spellID, destGUID)
		if info.spellIcons[228260] then -- Void Eruption (Talent)
			info.auras.isVoidForm = true
			E.TimerAfter(15.1, removeVoidForm, srcGUID, spellID, destGUID)
		end
	end

	local function ReduceVoidEruptionCD(destInfo)
		if destInfo.spec ~= 258 then
			return
		end

		if not destInfo.auras.isVoidForm and P.isPvP and destInfo.talentData[199259] then
			local icon = destInfo.spellIcons[228260] -- Void Eruption (Talent)
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

-- Resolute Barrier (Conduit)
local function ReduceUnendingResolveCD(destInfo, destName, _, amount)
	local rankValue = destInfo.talentData[339272]
	if rankValue then
		local icon = destInfo.spellIcons[104773] -- Unending Resolve
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

-- Divine Call (Conduit)
local function ReduceDivineShieldCD(destInfo)
	local rankValue = destInfo.talentData[338741]
	if rankValue then
		local icon = destInfo.spellIcons[642] -- Divine Shield
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
	P:SetDisabledColorScheme(destInfo)
	destInfo.isDead = true
	destInfo.bar:RegisterUnitEvent("UNIT_HEALTH", destInfo.unit)
end

if E.isClassic then
	local spellNameToID = E.spellNameToID

	function CD:COMBAT_LOG_EVENT_UNFILTERED()
		local _, event, _, srcGUID, _, srcFlags, _, destGUID, _,_,_,_, spellName = CombatLogGetCurrentEventInfo()

		if band(srcFlags, friendly) == 0 then
			local destInfo = groupInfo[destGUID]
			if destInfo and event == "UNIT_DIED" then
				UpdateDeadStatus(destInfo)
			end

			return
		end

		if band(srcFlags, player) > 0 then
			local info = groupInfo[srcGUID]
			if not info then
				return
			end

			if event == "SPELL_AURA_REMOVED" then
				local spellID = spellNameToID[spellName]
				if spellID then
					StartCdOnAuraRemoved(info, srcGUID, spellID, destGUID)
				end
			end
		end
	end
elseif E.isBCC then
	function CD:COMBAT_LOG_EVENT_UNFILTERED()
		local _, event, _, srcGUID, srcName, srcFlags, _, destGUID, destName, destFlags, _, spellID, _,_, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()

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
			local icon = info.spellIcons[spell_merged[spellID] or spellID] -- simple merge
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
					statusBar.CastingBar.Text:SetText(statusBar.name .. mark)
				end
			end
		end
	end

	function CD:COMBAT_LOG_EVENT_UNFILTERED() -- Suffix for SWING_(prefix) starts at 10th parameter
		local _, event, _, srcGUID, srcName, srcFlags, _, destGUID, destName, destFlags, destRaidFlags, spellID, _,_, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()

		-- group member are flagged as hostile in duels
		if band(srcFlags, friendly) == 0 then -- incl NPC
			local destInfo = groupInfo[destGUID]
			if not destInfo then
				if event == "UNIT_DIED" then -- spellID = -1, srcGUID = "", srcName = nil
					if destGUID == userGUID then -- Callback when user dies w/ isUserDisabled
						E.Libs.CBH:Fire("OnDisabledUserDied")
						return
					end

					local watched = spellDestGUIDS[destGUID] -- A Murder of Crows, Serrated Bone Spike, Shadowburn (Dest specific cdr (spell casted on) - no pet spells)
					if watched then
						for guid, t in pairs(watched) do
							local info = groupInfo[guid]
							for id in pairs(t) do
								local icon = info.spellIcons[id]
								if icon and icon.active then
									P:ResetCooldown(icon)
								end
								spellDestGUIDS[destGUID][guid][id] = nil
							end
						end
					end
				end

				return
			end

			local func = registeredHostileEvents[event] and (registeredHostileEvents[event][spellID] or registeredHostileEvents[event][destInfo.class])
			if func then
				func(destInfo, destName, spellID, amount)
			elseif event == "UNIT_DIED" then
				UpdateDeadStatus(destInfo)
			end
		elseif band(srcFlags, player) > 0 then
			if band(srcFlags, mine) > 0 and isUserDisabled then -- apply effects e.a., Forbearance to others when user is disabled
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
						if info.talentData[342344] then -- From the Ashes (Talent)
							local icon = info.spellIcons[257541] -- Pheonix Flames
							if icon and icon.active then
								P:UpdateCooldown(icon, 1)
							end
						end
					elseif specID == 64 and info.auras.isIcyPropulsion then
						local rankValue = info.talentData[336522] -- Icy Propulsion (Conduit)
						if rankValue then
							local icon = info.spellIcons[12472] -- Icy Veins
							if icon and icon.active and spellID ~= 190357 then -- Blizzard doesnt count toward CDR. Bug or intended?
								P:UpdateCooldown(icon, rankValue)
							end
						end
					end
				elseif info.class == "MONK" then
					if info.auras.isFallenOrder then -- Sinister Teachings (Runeforge) Patch 9.1 new
						local icon = info.spellIcons[326860]-- Fallen Order (Covenant)
						if icon and icon.active then
							P:UpdateCooldown(icon, 3)
						end
					end
				end
			elseif event == "SPELL_HEAL" and critical then
				if info.class == "MONK" then
					if info.auras.isFallenOrder then
						local icon = info.spellIcons[326860]
						if icon and icon.active then
							P:UpdateCooldown(icon, 3)
						end
					end
				end
			elseif event == "SPELL_INTERRUPT" then -- amount, overkill = extraSpellId, extraSpellName
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
CD.spellDestGUIDS = spellDestGUIDS -- wipe on PEW
E.ProcessSpell = ProcessSpell
