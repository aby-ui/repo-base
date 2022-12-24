local E = select(2, ...):unpack()
local P, CM, CD = E.Party, E.Comm, E.Cooldowns

local pairs, type, tostring, tonumber, unpack, tinsert, wipe, strmatch, format, min, max, abs = pairs, type, tostring, tonumber, unpack, table.insert, table.wipe, string.match, string.format, math.min, math.max, math.abs
local GetTime, GetSpellTexture, UnitBuff, UniDebuff, UnitTokenFromGUID, UnitHealth, UnitHealthMax, UnitLevel, UnitChannelInfo, UnitAffectingCombat = GetTime, GetSpellTexture, UnitBuff, UniDebuff, UnitTokenFromGUID, UnitHealth, UnitHealthMax, UnitLevel, UnitChannelInfo, UnitAffectingCombat
local C_Timer_After, C_Timer_NewTicker = C_Timer.After, C_Timer.NewTicker
local band = bit.band
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local COMBATLOG_OBJECT_TYPE_GUARDIAN = COMBATLOG_OBJECT_TYPE_GUARDIAN
local COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
local COMBATLOG_OBJECT_TYPE_PET = COMBATLOG_OBJECT_TYPE_PET

local BOOKTYPE_CATEGORY = E.BOOKTYPE_CATEGORY
local groupInfo = P.groupInfo
local userGUID = E.userGUID

local isUserDisabled
local isHighlightEnabled

local totemGUIDS = {}
local petGUIDS = {}
local diedHostileGUIDS = {}
local dispelledHostileGUIDS = {}

function CD:Enable()
	if self.enabled then
		return
	end
	self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	self:RegisterEvent('UNIT_PET')
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)

	self.enabled = true
end

function CD:Disable()
	if not self.enabled then
		return
	end
	self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	self:UnregisterEvent('UNIT_PET')

	wipe(totemGUIDS)
	wipe(petGUIDS)
	wipe(diedHostileGUIDS)
	wipe(dispelledHostileGUIDS)
	self.enabled = false
end

function CD:UpdateCombatLogVar()
	isUserDisabled = P.isUserDisabled
	isHighlightEnabled = E.db.highlight.glowBuffs
end


local function GetHolyWordReducedTime(info, reducedTime)

	local conduitValue = P.isInShadowlands and info.talentData[338345]
	if conduitValue then
		reducedTime = reducedTime * conduitValue
	end

	local naaruRank = info.talentData[196985]
	if naaruRank then
		reducedTime = reducedTime + reducedTime * (E.isDF and 0.1 * naaruRank or .33)
	end

	if info.auras.isApotheosisActive then
		reducedTime = reducedTime * 4
	end

	if info.auras.isDivineConversation then
		reducedTime = reducedTime + (P.isPvP and 10 or 15)
	end

	return reducedTime
end

local priestHolyWordSpells = {
	[88625] = true,
	[34861] = true,
	[2050] = true,
	[265202] = true,
}

local function UpdateCdByReducer(info, t, isHolyPriest)
	local talent, duration, target, base, aura, notalent = t[1], t[2], t[3], t[4], t[5], t[6]
	if (aura and not info.auras[aura]) or (notalent and info.talentData[notalent]) then
		return
	end

	local talentRank = P:IsSpecOrTalentForPvpStatus(talent, info, true)
	if type(target) == "table" then
		if talentRank then
			for targetID, reducedTime in pairs(target) do
				local icon = info.spellIcons[targetID]
				if icon and icon.active then
					reducedTime = type(reducedTime) == "table" and (reducedTime[talentRank] or reducedTime[1]) or reducedTime
					P:UpdateCooldown(icon, isHolyPriest and priestHolyWordSpells[targetID] and GetHolyWordReducedTime(info, reducedTime) or reducedTime)
				end
			end
		end
	elseif target then
		local icon = info.spellIcons[target]
		if icon and icon.active then
			duration = talentRank and (type(duration) == "table" and (duration[talentRank] or duration[1]) or duration) or base
			if duration then
				P:UpdateCooldown(icon, isHolyPriest and priestHolyWordSpells[target] and GetHolyWordReducedTime(info, duration) or duration)
			end
		end
	else
		if talentRank then
			duration = type(duration) == "table" and (duration[talentRank] or duration[1]) or duration
			for spellID, icon in pairs(info.spellIcons) do
				if icon.active and spellID ~= 1856 and (BOOKTYPE_CATEGORY[icon.category] or icon.category == "COVENANT") then
					P:UpdateCooldown(icon, E.isSL and P.isPvP and 10 or duration)
				end
			end
		end
	end
end

local function UpdateCdBySpender(info, guid, t, isTrueBearing)
	local talent, duration, target, base, aura, noaura = t[1], t[2], t[3], t[4], t[5], t[6]
	if (aura and not info.auras[aura]) or (noaura and info.auras[noaura]) then
		return
	end

	local reducedTime = P:IsTalentForPvpStatus(talent, info) and P:GetValueByType(duration, guid) or base
	if reducedTime then
		if type(target) == "table" then
			for _, targetID in pairs(target) do
				local icon = info.spellIcons[targetID]
				if icon and icon.active and (targetID ~= 107574 or not info.talentData[targetID]) then
					P:UpdateCooldown(icon, isTrueBearing and reducedTime * 2 or reducedTime)
				end
			end
		else
			local icon = info.spellIcons[target]
			if icon and icon.active then
				P:UpdateCooldown(icon, isTrueBearing and reducedTime * 2 or reducedTime)
			end
		end
	end
end

local function ResetCdByCast(info, reset, spellID)
	for i = 1, #reset do
		local resetID = reset[i]
		if i > 1 then
			if type(resetID) == "table" then
				ResetCdByCast(info, resetID, spellID)
			elseif resetID == "*" then
				for id, icon in pairs(info.spellIcons) do
					if icon.active and BOOKTYPE_CATEGORY[icon.category]
						and id ~= spellID and id ~= 19574 then
						P:ResetCooldown(icon)
					end
				end
			else
				if resetID == 6143 and resetID == info.active[resetID].castedLink then
					local linkedIcon = info.spellIcons[543]
					if linkedIcon and linkedIcon.active then
						P:ResetCooldown(linkedIcon)
					end
				end
				local icon = info.spellIcons[resetID]
				if icon and icon.active then
					P:ResetCooldown(icon)
				end
			end
		elseif resetID and not P:IsTalentForPvpStatus(resetID, info) then
			return
		end
	end
end

local function ProcessSpell(spellID, guid)
	if E.spell_dispel_cdstart[spellID] then
		return
	end

	local info = groupInfo[guid]
	if not info then
		return
	end

	if P.isInShadowlands and guid ~= userGUID and not CM.syncedGroupMembers[guid] then
		local covenantID = E.covenant_abilities[spellID]
		if covenantID then
			P.loginsessionData[guid] = P.loginsessionData[guid] or {}
			local currID = P.loginsessionData[guid].covenantID
			if covenantID ~= currID then
				if currID then
					local currSpellID = E.covenant_to_spellid[currID]
					P.loginsessionData[guid][currSpellID] = nil
					info.talentData[currSpellID] = nil
					if currID == 3 then
						info.talentData[319217] = nil
					end
				end

				local covenantSpellID = E.covenant_to_spellid[covenantID]
				P.loginsessionData[guid][covenantSpellID] = "C"
				P.loginsessionData[guid].covenantID = covenantID
				info.talentData[covenantSpellID] = "C"
				info.shadowlandsData.covenantID = covenantID
				if spellID == 319217 then
					info.talentData[spellID] = 0
				end
				P:UpdateUnitBar(guid)
			else
				if spellID == 319217 and not info.talentData[spellID] then
					info.talentData[spellID] = 0
					P:UpdateUnitBar(guid)
				end
			end
		end
	end

	local mergedID = E.spell_merged[spellID]

	local linked = E.spell_linked[mergedID or spellID]
	if linked then
		for _, linkedID in pairs(linked) do
			local icon = info.spellIcons[linkedID]
			if icon then

				if isHighlightEnabled and mergedID and linkedID == mergedID then
					icon.buff = spellID
				end

				P:StartCooldown(icon, icon.duration)

				if E.preCata then
					info.active[linkedID].castedLink = mergedID or spellID
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

		if E.spell_auraremoved_cdstart_preactive[spellID] then
			local statusBar = icon.statusBar
			if icon.active then
				if statusBar then
					P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, 'UNIT_SPELLCAST_STOP')
				end
				icon.cooldown:Clear()
			end

			if statusBar then
				statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
			else
				icon:SetAlpha(E.db.icons.activeAlpha)
			end
			info.preactiveIcons[spellID] = icon

			if not P:HighlightIcon(icon) then
				icon.icon:SetVertexColor(0.4, 0.4, 0.4)
			end

			if spellID == 5384 and (not E.isBFA or not P.isInArena) then
				info.bar:RegisterUnitEvent('UNIT_AURA', info.unit)
			end

			return
		end

		local updateSpell = E.spell_merged_updateoncast[spellID]
		if updateSpell then
			local cd = updateSpell[1]

			if mergedID == 272651 and P.isPvP and info.talentData[356962] then
				cd = cd / 2
			end
			icon.icon:SetTexture(updateSpell[2])
			P:StartCooldown(icon, cd)
			return
		end

		P:StartCooldown(icon, icon.duration)
	end

	local shared = E.spellcast_shared_cdstart[spellID]
	if shared then
		local now = GetTime()
		for i = 1, #shared, 2 do
			local sharedID = shared[i]
			local sharedCD = shared[i+1]
			local sharedIcon = info.spellIcons[sharedID]
			if sharedIcon then
				local active = sharedIcon.active and info.active[sharedID]
				if not active or (active.startTime + active.duration - now < sharedCD) then
					P:StartCooldown(sharedIcon, sharedCD)
				end
				if not E.preCata then
					break
				end
			end
		end
		return
	end

	local reset = E.spellcast_cdreset[spellID]
	if reset then
		ResetCdByCast(info, reset, spellID)
		if spellID ~= 217200 and spellID ~= 121253 then
			return
		end
	end

	if E.preCata then return end

	local reducer = E.spellcast_cdr[spellID]
	if reducer then
		local isHolyPriest = info.class == "PRIEST"
		if type(reducer[1]) == "table" then
			for i = 1, #reducer do
				local t = reducer[i]
				UpdateCdByReducer(info, t, isHolyPriest)
			end
		else
			UpdateCdByReducer(info, reducer, isHolyPriest)
		end
	end

	local spender = E.spellcast_cdr_powerspender[spellID]
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

	if not E.isBFA then return end

	local azerite = E.spellcast_cdr_azerite[spellID]
	if azerite and info.talentData[azerite.azerite] then
		for k, reducedTime in pairs(azerite.target) do
			local targetIcon = info.spellIcons[k]
			if targetIcon then
				if targetIcon.active then
					P:UpdateCooldown(targetIcon, reducedTime)
				end
				break
			end
		end
	end
end


local _t = {}

local mt = {
	__index = function(t, k)
		local e = {}
		t[k] = e
		setmetatable(e, {
			__index = function(t, k)
				return _t[t][k]
			end,
			__newindex = function(t, k, v)
				local f = _t[t][k]
				if f then
					_t[t][k] = function(...)
						v(...)
						f(...)
					end
					print("XXX", _t[t].event, k)
				else
					_t[t][k] = v
				end
			end
		})
		_t[e] = { event = k }
		return e
	end
}

local mt = {
	__index = function(t, k)
		t[k] = {}
		return t[k]
	end
}

local registeredEvents = setmetatable({}, mt)
local registeredHostileEvents = setmetatable({}, mt)
local registeredUserEvents = setmetatable({}, mt)


local function RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	if isHighlightEnabled and destGUID == srcGUID then
		local icon = info.glowIcons[spellID]
		if icon then
			P:RemoveHighlight(icon)
		end
	end
end

for k in pairs(E.spell_highlighted) do
	registeredEvents['SPELL_AURA_REMOVED'][k] = RemoveHighlightByCLEU
end

function CD:RegisterRemoveHighlightByCLEU(spellID)
	local func = registeredEvents['SPELL_AURA_REMOVED'][spellID]
	registeredEvents['SPELL_AURA_REMOVED'][spellID] = func and function(...)
		func(...)
		RemoveHighlightByCLEU(...)
	end or RemoveHighlightByCLEU
end


for k, v in pairs(E.spell_aura_freespender) do
	registeredEvents['SPELL_AURA_REMOVED'][k] = E.spell_highlighted[k] and function(info, srcGUID, spellID, destGUID)
		info.auras[v] = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end or function(info)
		info.auras[v] = nil
	end
	registeredEvents['SPELL_AURA_APPLIED'][k] = function(info)
		info.auras[v] = k
	end
end


for id in pairs(E.sync_periodic) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = function(_, srcGUID)
		if srcGUID == userGUID and CM.cooldownSyncIDs[id] then CM:ForceSyncCooldowns() end
	end
	registeredUserEvents['SPELL_CAST_SUCCESS'][id] = function()
		if CM.cooldownSyncIDs[id] then CM:ForceSyncCooldowns() end
	end
end


local function AppendInterruptExtras(info, srcGUID, spellID, _,_,_, extraSpellId, extraSpellName, _,_, destRaidFlags)
	local db = E.db.extraBars.raidBar0
	if db.enabled then
		local icon = info.spellIcons[E.spell_merged[spellID] or spellID]
		local statusBar = icon and icon.type == "interrupt" and icon.statusBar
		if statusBar then
			local extraSpellTexture = db.showInterruptedSpell and GetSpellTexture(extraSpellId)
			if extraSpellTexture then
				icon.icon:SetTexture(extraSpellTexture)
				icon.tooltipID = extraSpellId
				if not E.db.icons.showTooltip then
					icon:EnableMouse(true)
				end
			end

			local mark = db.showRaidTargetMark and E.RAID_TARGET_MARKERS[destRaidFlags]
			if mark then
				statusBar.CastingBar.Text:SetText(format("%s %s", statusBar.name, mark))
			end
		end
	end
end

local interrupts = {
	47528,
	47482,
	183752,
	106839,
	78675,
	351338,
	147362,
	187707,
	2139,
	116705,
	96231,
	31935,
	15487,
	1766,
	57994,
	119898,
	212619,
	6552,
	386071,
}

for _, id in pairs(interrupts) do
	registeredEvents['SPELL_INTERRUPT'][id] = AppendInterruptExtras
end


local function StartCdOnAuraRemoved(info, srcGUID, spellID, destGUID)
	if srcGUID == destGUID then
		spellID = E.spell_auraremoved_cdstart_preactive[spellID]
		local icon = info.spellIcons[spellID]
		if icon then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preactiveIcons[spellID] = nil
			icon.icon:SetVertexColor(1, 1, 1)

			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)

			P:StartCooldown(icon, icon.duration)
		end
	end
end

for k, v in pairs(E.spell_auraremoved_cdstart_preactive) do
	if v > 0 then
		registeredEvents['SPELL_AURA_REMOVED'][k] = StartCdOnAuraRemoved
	end
end


local function ProcessSpellOnAuraApplied(_, srcGUID, spellID)
	spellID = E.spell_auraapplied_processspell[spellID]
	ProcessSpell(spellID, srcGUID)
end

for k in pairs(E.spell_auraapplied_processspell) do
	registeredEvents['SPELL_AURA_APPLIED'][k] = ProcessSpellOnAuraApplied
end


for id, iconID in pairs(E.spell_dispel_cdstart) do
	iconID = iconID == true and id or iconID
	registeredEvents['SPELL_DISPEL'][id] = function(info)
		local icon = info.spellIcons[iconID]
		if icon then
			P:StartCooldown(icon, icon.duration)
		end
	end
end


local function ReduceCdByDamage(info, srcGUID, spellID, destGUID, critical, _,_,_,_,_,_, timestamp)
	info = info or groupInfo[srcGUID]
	local t = E.spell_damage_cdr[spellID]
	for i = 1, #t, 7 do
		local talent, duration, target, maxLimit, minLimit, crit, internalCD = unpack(t, i, i + 6)
		if crit and (not critical or (spellID == 257542 and info.auras.phoenixFlameTargetGUID ~= destGUID)) then
			return
		end
		local talentRank = P:IsSpecAndTalentForPvpStatus(talent, info)
		if talentRank then
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
					if timestamp <= (active.nextTick or 0) then
						return
					end
					active.nextTick = timestamp + internalCD
				end
				P:UpdateCooldown(icon, duration == 0 and talentRank or type(duration) == "table" and (duration[talentRank] or duration[1]) or duration)
			end
		end
	end
end

for k in pairs(E.spell_damage_cdr) do
	registeredEvents['SPELL_DAMAGE'][k] = ReduceCdByDamage
end


local function ReduceCdByEnergize(info, _, spellID)
	local t = E.spell_energize_cdr[spellID]
	local talent, duration, target, mult = t[1], t[2], t[3], t[4]
	local talentRank = P:IsTalentForPvpStatus(talent, info)
	if talentRank then
		local icon = info.spellIcons[target]
		if icon and icon.active then
			P:UpdateCooldown(icon, duration == 0 and (mult and talentRank * mult or talentRank) or type(duration) == "table" and (duration[talentRank] or duration[1]) or duration)
		end
	end
end

for k in pairs(E.spell_energize_cdr) do
	registeredEvents['SPELL_ENERGIZE'][k] = ReduceCdByEnergize
end


local function ReduceCdByInterrupt(info, _, spellID, _,_,_, extraSpellId, extraSpellName, _,_, destRaidFlags)
	local t = E.spell_interrupt_cdr[spellID]
	local talent, duration, target, mult = t[1], t[2], t[3], t[4]
	local talentRank = P:IsTalentForPvpStatus(talent, info)
	if talentRank then
		if type(target) == "table" then for targetID, reducedTime in pairs(target) do
			local icon = info.spellIcons[targetID]
			if icon and icon.active then
				P:UpdateCooldown(icon, reducedTime == 0 and (mult and talentRank * mult or talentRank) or type(reducedTime) == "table" and (reducedTime[talentRank] or reducedTime[1]) or reducedTime)
			end
			end
		else
			local icon = info.spellIcons[target]
			if icon and icon.active then
				P:UpdateCooldown(icon, duration == 0 and (mult and talentRank * mult or talentRank) or type(duration) == "table" and (duration[talentRank] or duration[1]) or duration)
			end
		end
	end
	AppendInterruptExtras(info, nil, spellID, nil,nil,nil, extraSpellId, extraSpellName, nil,nil, destRaidFlags)
end

for k in pairs(E.spell_interrupt_cdr) do
	registeredEvents['SPELL_INTERRUPT'][k] = ReduceCdByInterrupt
end






registeredEvents['SPELL_ENERGIZE'][378849] = function(info)
	local icon = info.spellIcons[47528]
	if icon and icon.active then
		P:UpdateCooldown(icon, 3)
	end
end


registeredEvents['SPELL_CAST_SUCCESS'][219809] = function(info)
	local numShields = info.auras.numBoneShields
	if not numShields or numShields == 1 then
		return
	end

	local consumed = min(5, numShields)

	local icon = info.spellIcons[221699]
	if icon and icon.active then
		P:UpdateCooldown(icon, 2 * consumed)
	end

	if info.talentData[377637] then
		local icon = info.spellIcons[49028]
		if icon and icon.active then
			P:UpdateCooldown(icon, 5 * consumed)
		end

	elseif P.isInShadowlands and info.talentData[334525] then
		local icon = info.spellIcons[49028]
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
	if consumed ~= 1 then
		return
	end

	local icon = info.spellIcons[221699]
	if icon and icon.active then
		P:UpdateCooldown(icon, 2)
	end

	if info.talentData[377637] then
		local icon = info.spellIcons[49028]
		if icon and icon.active then
			P:UpdateCooldown(icon, 5)
		end

	elseif P.isInShadowlands and info.talentData[334525] then
		local icon = info.spellIcons[49028]
		if icon and icon.active then
			P:UpdateCooldown(icon, 5)
		end
	end
end

registeredEvents['SPELL_AURA_REMOVED_DOSE'][195181] = ReduceBloodTapDancingRuneWeaponCD
registeredEvents['SPELL_AURA_REMOVED'][195181] = ReduceBloodTapDancingRuneWeaponCD

registeredEvents['SPELL_AURA_APPLIED_DOSE'][195181] = function(info, _,_,_,_,_,_, amount)
	if amount and (info.spellIcons[221699] or info.spellIcons[49028]) then
		info.auras.numBoneShields = amount
	end
end


registeredEvents['SPELL_AURA_APPLIED'][334722] = function(info)
	local icon = info.spellIcons[49576]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end

registeredEvents['SPELL_AURA_REMOVED'][334722] = function(info)
	local icon = info.spellIcons[49576]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents['SPELL_ENERGIZE'][195757] = function(info)
	local conduitValue = P.isInShadowlands and info.talentData[338553]
	if conduitValue then
		local icon = info.spellIcons[275699]
		if icon and icon.active then
			P:UpdateCooldown(icon, conduitValue)
		end
	end
end


registeredEvents['SPELL_AURA_APPLIED'][81141] = function(info)
	local icon = info.spellIcons[43265]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


local runicPowerSpenders = {
	[194844] = 100,
	[49998] = 40,
	[47541] = 30,
	[61999] = 30,
	[327574] = 20,
}

registeredEvents['SPELL_AURA_APPLIED'][194844] = function(info)
	local unit = info.unit
	for i = 1, 40 do
		local _,_,_,_, duration, _,_,_,_, id = UnitBuff(unit, i)
		if not id then return end
		if id == 194844 and duration > 0 then
			info.auras.bonestormConsumedRP = duration * 10
		end
	end
end

local function ReduceVampiricBloodCD(info, _, spellID)
	local talentRank = info.talentData[205723]
	if talentRank then
		local icon = info.spellIcons[55233]
		if icon and icon.active then
			local usedRP = spellID == 194844 and info.auras.bonestormConsumedRP or runicPowerSpenders[spellID]
			if spellID == 49998 and info.auras["hasOssuary"] then
				usedRP = usedRP - 5
			end
			P:UpdateCooldown(icon, usedRP/10 * talentRank)
		end
	end
end

for id in pairs(runicPowerSpenders) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = ReduceVampiricBloodCD
end


local function ReduceRedThirstCD(info, _,_,_, critical, _,_,_,_,_,_, timestamp)
	if critical and info.talentData[207126] then
		local icon = info.spellIcons[51271]
		if icon and icon.active then
			if timestamp > (info.auras.time_icecap or 0) then
				P:UpdateCooldown(icon, 2)
				info.auras.time_icecap = timestamp + .5
			end
		end
	end
end

registeredEvents['SPELL_DAMAGE'][325464] = ReduceRedThirstCD
registeredEvents['SPELL_DAMAGE'][325461] = ReduceRedThirstCD
registeredEvents['SPELL_DAMAGE'][222026] = ReduceRedThirstCD
registeredEvents['SPELL_DAMAGE'][222024] = ReduceRedThirstCD
registeredEvents['SPELL_DAMAGE'][207230] = ReduceRedThirstCD






registeredEvents['SPELL_AURA_APPLIED'][212800] = function(info)
	if info.talentData[205411] then
		local icon = info.spellIcons[198589]
		if icon and ( not icon.active ) then
			P:StartCooldown(icon, icon.duration/2)
		end
	end
end



registeredEvents['SPELL_HEAL'][203794] = function(info, _,_,_,_,_,_,_,_,_,_, timestamp)
	local talentRank = info.talentData[218612]
	if talentRank and not info.auras.isSoulBarrier then
		local icon = info.spellIcons[203720]
		if icon and icon.active then
			if timestamp > (info.auras.time_consumedsoulfragment or 0) then
				P:UpdateCooldown(icon, talentRank == 2 and .5 or .25)
				info.auras.time_consumedsoulfragment = timestamp + 1
			end
		end
	end
	info.auras.isSoulCleave = false
end

registeredEvents['SPELL_AURA_REMOVED'][263648] = function(info, srcGUID, spellID, destGUID)
	info.auras.isSoulBarrier = false
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][263648] = function(info)
	info.auras.isSoulBarrier = true
end


registeredEvents['SPELL_CAST_SUCCESS'][228477] = function(info)
	if P.isInShadowlands and info.talentData[337547] and info.spellIcons[204021] then
		info.auras.isSoulCleave = true
	end
end

local function ReduceFieryBrandCD(info)
	if info.auras.isSoulCleave then
		local icon = info.spellIcons[204021]
		if icon and icon.active then
			P:UpdateCooldown(icon, 2)
		end
	end
end

registeredEvents['SPELL_AURA_REMOVED_DOSE'][203981] = ReduceFieryBrandCD
registeredEvents['SPELL_AURA_REMOVED'][203981] = ReduceFieryBrandCD


local ClearSrcTheHunt_OnDelayEnd = function(srcGUID, destGUID)
	if diedHostileGUIDS[destGUID] and diedHostileGUIDS[destGUID][srcGUID] and diedHostileGUIDS[destGUID][srcGUID][370965] then
		diedHostileGUIDS[destGUID][srcGUID][370965] = nil
	end
end

registeredEvents['SPELL_AURA_REMOVED'][370969] = function(_, srcGUID, _, destGUID)
	if diedHostileGUIDS[destGUID] and diedHostileGUIDS[destGUID][srcGUID] and diedHostileGUIDS[destGUID][srcGUID][370965] then
		diedHostileGUIDS[destGUID][srcGUID][370965]:Cancel()
		diedHostileGUIDS[destGUID][srcGUID][370965] = E.TimerAfter(0.5, ClearSrcTheHunt_OnDelayEnd, srcGUID, destGUID)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][370969] = function(info, srcGUID, _, destGUID)
	if info.talentData[389819] and info.spellIcons[370965] then
		diedHostileGUIDS[destGUID] = diedHostileGUIDS[destGUID] or {}
		diedHostileGUIDS[destGUID][srcGUID] = diedHostileGUIDS[destGUID][srcGUID] or {}
		diedHostileGUIDS[destGUID][srcGUID][370965] = E.TimerAfter(6.5, ClearSrcTheHunt_OnDelayEnd, srcGUID, destGUID)
	end
end


registeredEvents['SPELL_AURA_REMOVED'][162264] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[390142] then
		local icon = info.spellIcons[195072]
		if icon and icon.active then
			P:ResetCooldown(icon)
		end
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end



registeredEvents['SPELL_ENERGIZE'][391345] = function(info, _,_,_,_,_, amount)
	local icon = info.spellIcons[212084]
	if icon and icon.active then
		P:UpdateCooldown(icon, icon.duration * amount/100)
	end
end


local demonHunterSigils = {
	[204596] = 204598,
	[207684] = 207685,
	[202137] = 204490,
	[202138] = 204843,
}

local function ReduceSigilsCD(info, _,_,_,_,_,_,_,_,_,_, timestamp)
	if info.talentData[389718] then
		if timestamp > (info.auras.time_cycleofbinding or 0) then
			for castID in pairs(demonHunterSigils) do
				local icon = info.spellIcons[castID]
				if icon and icon.active then
					P:UpdateCooldown(icon, 3)
				end
			end
			info.auras.time_cycleofbinding = timestamp + 0.1
		end
	end
end

for _, auraID in pairs(demonHunterSigils) do
	registeredEvents['SPELL_AURA_APPLIED'][auraID] = ReduceSigilsCD
end






registeredEvents['SPELL_AURA_REMOVED'][50334] = function(info, srcGUID, spellID, destGUID)
	info.auras["isBerserkRavage"] = nil
	info.auras["isBerserkPersistence"] = nil
	info.auras["isBerserkUnchecdAggression"] = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][50334] = function(info)

	if info.talentData[343240] then
		info.auras["isBerserkRavage"] = true
	end

	if info.talentData[377779] then
		local icon = info.spellIcons[22842]
		if icon and icon.active then
			for i = 1, (icon.maxcharges or 1) do
				P:ResetCooldown(icon)
			end
		end
		info.auras["isBerserkPersistence"] = true
	end

	if info.talentData[377623] then
		info.auras["isBerserkUnchecdAggression"] = true
	end
end


registeredEvents['SPELL_CAST_SUCCESS'][157982] = function(info)
	if info.talentData[392162] then
		for _, icon in pairs(info.spellIcons) do
			if icon and icon.active and E.BOOKTYPE_CATEGORY[icon.category] then
				P:UpdateCooldown(icon, 3)
			end
		end
	end
end


registeredEvents['SPELL_INTERRUPT'][97547] = function(info, _, spellID, _,_,_, extraSpellId, extraSpellName, _,_, destRaidFlags)
	if info.talentData[202918] then
		local icon = info.spellIcons[78675]
		if icon and icon.active then
			P:UpdateCooldown(icon, 15)
		end
	end
	AppendInterruptExtras(info, nil, spellID, nil,nil,nil, extraSpellId, extraSpellName, nil,nil, destRaidFlags)
end


local savageMomentumIDs = {
	5217,
	61336,
	1850,
	252216,
}

registeredEvents['SPELL_INTERRUPT'][93985] = function(info, _, spellID, _,_,_, extraSpellId, extraSpellName, _,_, destRaidFlags)
	if P.isPvP and info.talentData[205673] then
		for i = 1, 4 do
			local id = savageMomentumIDs[i]
			local icon = info.spellIcons[id]
			if icon and icon.active then
				P:UpdateCooldown(icon, 10)
			end
		end
	end
	AppendInterruptExtras(info, nil, spellID, nil,nil,nil, extraSpellId, extraSpellName, nil,nil, destRaidFlags)
end


registeredEvents['SPELL_AURA_REMOVED'][319454] = function(info, srcGUID, spellID, destGUID)
	if info.auras.isHeartOfTheWild then
		local icon = info.spellIcons[22842]
		if icon then
			local active = icon.active and info.active[22842]
			if active and active.charges then
				if active.charges ~= 0 then
					P:ResetCooldown(icon)
				end
				active.charges = nil
				P:SetCooldownElements(icon, nil)
			end
			icon.maxcharges = nil
			icon.count:SetText("")
		end
		info.auras.isHeartOfTheWild = nil
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][319454] = function(info)
	if info.spec ~= 104 then
		local icon = info.spellIcons[22842]
		if icon then
			local active = icon.active and info.active[22842]
			if active then
				active.charges = 1
				icon.count:SetText(1)
				P:SetCooldownElements(icon, 1)
			else
				icon.count:SetText(2)
			end
			icon.maxcharges = 2
		end
		info.auras.isHeartOfTheWild = true
	end
end


registeredEvents['SPELL_PERIODIC_HEAL'][33763] = function(info, srcGUID, _, destGUID, _,_,_,_,_, criticalHeal, _, timestamp)
	if criticalHeal and srcGUID == destGUID and info.talentData[393641] then
		local icon = info.spellIcons[132158]
		if icon and icon.active then
			if timestamp > (info.auras.time_druid4pccdr or 0) then
				P:UpdateCooldown(icon, 2)
				info.auras.time_druid4pccdr = timestamp + 1.5
			end
		end
	end
end



registeredEvents['SPELL_HEAL'][33778] = function(info, srcGUID, _, destGUID, _,_,_,_,_, criticalHeal, _, timestamp)
	if info.talentData[393371] then
		local icon = info.spellIcons[33891]
		if icon then
			P:UpdateCooldown(icon, 2)
		end
	end

	if criticalHeal and srcGUID == destGUID and info.talentData[393641] then
		local icon = info.spellIcons[132158]
		if icon and icon.active then
			if timestamp > (info.auras.time_druid4pccdr or 0) then
				P:UpdateCooldown(icon, 2)
				info.auras.time_druid4pccdr = timestamp + 1.5
			end
		end
	end
end

registeredEvents['SPELL_HEAL'][8936] = function(info, _,_,_,_,_,_,_,_, criticalHeal)
	if criticalHeal then
		local icon = info.spellIcons[33891]
		if icon then
			P:UpdateCooldown(icon, 1)
		end
	end
end


local guardianRageSpenders = {
	[22842] = 10,
	[192081] = 40,
	[20484] = 30,
	[6807] = 40,
}

local function ReduceGuardianIncarnationCD(info, srcGUID, spellID)
	if info.talentData[393414] then
		local icon = info.spellIcons[102558]
		if icon and icon.active then
			local rCD = guardianRageSpenders[spellID] / 20
			if spellID == 6807 then
				if info.auras["ToothandClaw"] then
					return
				end
				if info.auras["isBerserkUnchecdAggression"] then
					rCD = rCD * .5
				end
			elseif spellID == 192081 then
				if info.auras["isBerserkPersistence"] then
					rCD = rCD * .5
				end
				if info.auras["GoryFur"] then
					rCD = rCD * .75
				end
			end
			P:UpdateCooldown(icon, rCD)
		end
	end
	if spellID == 22842 and srcGUID == userGUID and CM.cooldownSyncIDs[spellID] then
		CM:ForceSyncCooldowns()
	end
end

for id in pairs(guardianRageSpenders) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = ReduceGuardianIncarnationCD
end


local feralComboPointSpenders = {
	22568,
	22570,
	1079,
	285381,
}

local function ReduceFeralBerserkCD(info)
	if info.talentData[391174] then
		local icon = info.spellIcons[106951] or info.spellIcons[102543]
		if icon and icon.active then
			P:UpdateCooldown(icon, 2.5)
		end
	end
end

for _, id in pairs(feralComboPointSpenders) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = ReduceFeralBerserkCD
end


registeredEvents['SPELL_AURA_APPLIED'][117679] = function(info)
	local icon = info.spellIcons[33891]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end






local majorMovementAbilities = {
	["DEATHKNIGHT"] = 48265,
	["DEMONHUNTER"] = { 195072, 189110 },
	["DRUID"] = { 1850, 252216 },
	["EVOKER"] = 358267,
	["HUNTER"] = 186257,
	["MAGE"] = { 1953, 212653 },
	["MONK"] = { 109132, 115008 },
	["PALADIN"] = 190784,
	["PRIEST"] = 73325,
	["ROGUE"] = 2983,
	["SHAMAN"] = 79206,
	["WARLOCK"] = 48020,
	["WARRIOR"] = 6544,
}

registeredEvents['SPELL_AURA_REMOVED'][381748] = function(info)
	local id = majorMovementAbilities[info.class]
	local icon = type(id) == "table" and (info.spellIcons[ id[1] ] or info.spellIcons[ id[2] ]) or info.spellIcons[id]
	if icon and icon.active then
		P:UpdateCooldown(icon, 0, 1/0.85)
	end
	info.auras["isBlessingOfTheBronze"] = nil
end

registeredEvents['SPELL_AURA_APPLIED'][381748] = function(info)
	local id = majorMovementAbilities[info.class]
	local icon = type(id) == "table" and (info.spellIcons[ id[1] ] or info.spellIcons[ id[2] ]) or info.spellIcons[id]
	if icon and icon.active then
		P:UpdateCooldown(icon, 0, 0.85)
	end
	info.auras["isBlessingOfTheBronze"] = true
end


registeredEvents['SPELL_AURA_REMOVED'][375234] = function(info, srcGUID, spellID, destGUID)
	info.auras["isTimeSpiral"] = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][375234] = function(info)
	info.auras["isTimeSpiral"] = true
end


local function ReduceFireBreathCD(info)
	if info.talentData[369846] then
		local icon = info.spellIcons[382266]
		if icon and icon.active then
			P:UpdateCooldown(icon, 2)
		end
	end
end

registeredEvents['SPELL_AURA_REMOVED'][359618] = ReduceFireBreathCD
registeredEvents['SPELL_AURA_REMOVED_DOSE'][359618] = ReduceFireBreathCD


registeredEvents['SPELL_SUMMON'][368415] = function(info)
	local icon = info.spellIcons[368412]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents['SPELL_AURA_APPLIED'][370818] = function(info)
	local icon = info.spellIcons[368847]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


registeredEvents['SPELL_DISPEL'][372048] = function(info, _, spellID)
	local icon = info.spellIcons[spellID]
	if icon and icon.active then
		P:UpdateCooldown(icon, 20)
	end
end






local function ReduceDisengageCD(info, _, spellID,_,_,_,_,_,_,_,_, timestamp)
	local conduitValue = P.isInShadowlands and info.talentData[346747]
	if conduitValue then
		local icon = info.spellIcons[781]
		if icon and icon.active then
			info.auras.time_ambuscade = info.auras.time_ambuscade or {}
			if timestamp > (info.auras.time_ambuscade[spellID] or 0) then
				P:UpdateCooldown(icon, conduitValue)
				info.auras.time_ambuscade[spellID] = timestamp + 1
			end
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][203337] = ReduceDisengageCD
registeredEvents['SPELL_AURA_APPLIED'][3355] = ReduceDisengageCD
registeredEvents['SPELL_AURA_APPLIED'][135299] = ReduceDisengageCD
registeredEvents['SPELL_DAMAGE'][236777] = ReduceDisengageCD


--[[ CDTS
registeredEvents['SPELL_CAST_SUCCESS'][19574] = function(info)
	local icon = info.spellIcons[217200]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end
]]


registeredEvents['SPELL_AURA_APPLIED'][385646] = function(info)
	local icon = info.spellIcons[186387]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


local function ResetWildfireBombCD(info)
	if info.talentData[389880] then
		local icon = info.spellIcons[259495]
		if icon and icon.active then
			for i = 1, (icon.maxcharges or 1) do
				P:ResetCooldown(icon)
			end
		end
	end
end

registeredEvents['SPELL_AURA_REMOVED'][360952] = function(info, srcGUID, spellID, destGUID)
	info.auras["coordinatedKillAuraMult"] = nil
	ResetWildfireBombCD(info)
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][360952] = function(info)
	local talentRank = info.talentData[385739]
	if talentRank then
		info.auras["coordinatedKillAuraMult"] = talentRank == 2 and .5 or .75
	end
	ResetWildfireBombCD(info)
end


local focusSpenders = {
	[34026] = 30,
	[320976] = 10,
	[53351] = 10,
	[2643] = 40,
	[257620] = 20,
	[1513] = 25,
	[19434] = 35,
	[195645] = 20,
	[193455] = 35,
	[212431] = 20,
	[271788] = 10,
	[186270] = 30,
	[259387] = 30,
	[187708] = 35,
	[212436] = 30,
	[342049] = 40,
	[186387] = 10,
	[392060] = 15,
	[131894] = 30,
	[203155] = 40,
	[208652] = 30,
	[205691] = 60,
	[982] = { [255]=10,["d"]=35 },
	[185358] = { [254]=20,["d"]=40 },
	[120360] = { [254]=30,["d"]=60 },
}

local function ReduceNaturalMendingCD(info, _, spellID)
	local naturalMendingIcon = info.spellIcons[109304]
	local trueShotIcon = info.spellIcons[288613]
	local naturalMendingRank = naturalMendingIcon and naturalMendingIcon.active and info.talentData[270581]
	local isTrueShotActive	= info.talentData[260404] and trueShotIcon and trueShotIcon.active
	if naturalMendingRank or isTrueShotActive then
		local rCD = focusSpenders[spellID]
		if type(rCD) == "table" then
			rCD = rCD[info.spec] or rCD.d
		end
		if info.spec == 253 then
			if spellID == 34026 then
				if info.auras["CobraSting"] then
					return
				end
				if info.auras["DirePack"] then
					rCD = rCD / 2
				end
			elseif spellID == 193455 then
				if info.auras["AspectoftheWild"] then
					rCD = rCD - 10
				end
			end
		elseif info.spec == 254 then
			local isArcaneChimaera = spellID == 185358 or spellID == 342049
			if isArcaneChimaera or spellID == 257620 or spellID == 19434 then
				if isArcaneChimaera then
					if info.talentData[321293] then
						rCD = rCD - 20
					end
				end
				local mult = info.talentData[389449]
				mult = mult and (mult == 2 and .75 or .88)
				if mult then
					rCD = rCD * mult
				end
			end
			if  isTrueShotActive then
				rCD = rCD * 0.03
				P:UpdateCooldown(trueShotIcon, rCD)
			end
		end
		if naturalMendingRank then
			rCD = naturalMendingRank == 2 and rCD/12 or rCD/25
			P:UpdateCooldown(naturalMendingIcon, rCD)
		end
	end
end

for id, _ in pairs(focusSpenders) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = ReduceNaturalMendingCD
end


local svCdrByDamageIDs = {
	259495,
	269751,
}

registeredEvents['SPELL_DAMAGE'][203413] = function(info, _,_,_, critical, _,_,_,_,_,_, timestamp)
	if critical then
		local talentRank = info.talentData[385718]
		if talentRank then
			if timestamp > (info.auras.time_ruthlessmarauder or 0) then
				local reducedTime
				for i = 1, 2 do
					local id = svCdrByDamageIDs[i]
					local icon = info.spellIcons[id]
					if icon and icon.active then
						reducedTime = reducedTime or (0.5 * talentRank)
						P:UpdateCooldown(icon, reducedTime)
					end
				end
				if reducedTime then
					info.auras.time_ruthlessmarauder = timestamp + 0.1
				end
			end
		end
	end
end


registeredEvents['SPELL_DAMAGE'][187708] = function(info)
	if info.talentData[294029] then
		info.auras.numhits_carveorbutchery = (info.auras.numhits_carveorbutchery or 0) + 1
		if info.auras.numhits_carveorbutchery <= 5 then
			for i = 1, 2 do
				local id = svCdrByDamageIDs[i]
				local icon = info.spellIcons[id]
				if icon and icon.active then
					P:UpdateCooldown(icon, 1)
				end
			end
		end
	end
end
registeredEvents['SPELL_DAMAGE'][212436] = registeredEvents['SPELL_DAMAGE'][187708]

registeredEvents['SPELL_CAST_SUCCESS'][187708] = function(info, _, spellID)
	if info.talentData[294029] then
		info.auras.numhits_carveorbutchery = 0
	end
	ReduceNaturalMendingCD(info, nil, spellID)
end
registeredEvents['SPELL_CAST_SUCCESS'][212436] = registeredEvents['SPELL_CAST_SUCCESS'][187708]


local function ClearSrcAMurderOfCrows_OnDurationEnd(srcGUID, spellID, destGUID)
	if diedHostileGUIDS[destGUID] and diedHostileGUIDS[destGUID][srcGUID] and diedHostileGUIDS[destGUID][srcGUID][spellID] then
		diedHostileGUIDS[destGUID][srcGUID][spellID] = nil
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][131894] = function(info, srcGUID, spellID, destGUID)
	if info.spellIcons[spellID] then
		diedHostileGUIDS[destGUID] = diedHostileGUIDS[destGUID] or {}
		diedHostileGUIDS[destGUID][srcGUID] = diedHostileGUIDS[destGUID][srcGUID] or {}
		diedHostileGUIDS[destGUID][srcGUID][spellID] = E.TimerAfter(15, ClearSrcAMurderOfCrows_OnDurationEnd, srcGUID, spellID, destGUID)
	end
	ReduceNaturalMendingCD(info, nil, spellID)
end






local function ReduceFireBlastCD(info)
	local icon = info.spellIcons[108853]
	if icon and icon.active then
		P:UpdateCooldown(icon, 6)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][320035] = ReduceFireBlastCD
registeredEvents['SPELL_AURA_APPLIED_DOSE'][320035] = ReduceFireBlastCD
registeredEvents['SPELL_AURA_APPLIED'][317589] = ReduceFireBlastCD


local mageLossOfControlAbilities = {
	[122] = true,
	[120] = true,
	[157997] = true,
	[113724] = true,
	[31661] = true,
	[383121] = true,

}

local function ConsumedProcCharge(info, consumedFingerOfFrost)
	local talentRank = info.talentData[387807]
	if talentRank then
		for id in pairs(mageLossOfControlAbilities) do
			local icon = info.spellIcons[id]
			if icon and icon.active and (id ~= 120 or info.talentData[386763]) then
				P:UpdateCooldown(icon, talentRank)
			end
		end
	end

	if not consumedFingerOfFrost and info.talentData[354333] then
		local icon = info.spellIcons[314793]
		if icon and icon.active then
			P:UpdateCooldown(icon, 4)
		end
	end
end




registeredEvents['SPELL_CAST_SUCCESS'][108853] = function(info)

	local talentRank = info.talentData[387807]
	if talentRank then
		for i = 1, 40 do
			local _,_,_,_,_,_,_,_,_, id = UnitDebuff(info.unit, i)
			if not id then break end
			if mageLossOfControlAbilities[id] then
				for k in pairs(mageLossOfControlAbilities) do
					local icon = info.spellIcons[k]
					if icon and icon.active and (k ~= 120 or info.talentData[386763]) then
						P:UpdateCooldown(icon, talentRank)
					end
				end
				break
			end
		end
	end

	if info.talentData[354333] then
		local icon = info.spellIcons[314793]
		if icon and icon.active then
			P:UpdateCooldown(icon, 4)
		end
	end
end

local function OnFireBlastCCBreak(info, _,_,_,_,_, extraSpellId)
	if extraSpellId == 108853 then
		local talentRank = info.talentData[387807]
		if talentRank then
			for id in pairs(mageLossOfControlAbilities) do
				local icon = info.spellIcons[id]
				if icon and icon.active and (id ~= 120 or info.talentData[386763]) then
					P:UpdateCooldown(icon, talentRank)
				end
			end
		end
	end
end

for k in pairs(mageLossOfControlAbilities) do
	registeredEvents['SPELL_AURA_BROKEN_SPELL'][k] = OnFireBlastCCBreak
end


registeredEvents['SPELL_AURA_REMOVED'][44544] = function(info)
	info.auras.hasFingerOfFrost = nil
end

registeredEvents['SPELL_AURA_APPLIED'][44544] = function(info)
	info.auras.hasFingerOfFrost = true
end

local frozenDebuffs = {
	[122] = true,
	[386770] = true,
	[157997] = true,
	[82691] = true,
	[228358] = true,
	[228600] = true,
	[33395] = true,
}

registeredEvents['SPELL_CAST_SUCCESS'][30455] = function(info, _,_, destGUID)
	if info.talentData[387807] then
		if info.auras.hasFingerOfFrost then
			ConsumedProcCharge(info, true)
		else
			local unit = UnitTokenFromGUID(destGUID)
			if unit then
				for i = 1, 40 do
					local _,_,_,_,_,_,_,_,_, id = UnitDebuff(unit, i)
					if not id then return end
					if frozenDebuffs[id] then
						return ConsumedProcCharge(info, true)
					end
				end
			end
		end
	end
end



registeredEvents['SPELL_AURA_REMOVED'][263725] = function(info)
	info.auras.isClearcasting = nil
end

registeredEvents['SPELL_AURA_APPLIED'][263725] = function(info)
	info.auras.isClearcasting = true
end

registeredEvents['SPELL_CAST_SUCCESS'][5143] = function(info)
	if info.auras.isClearcasting then
		if info.talentData[384858] then
			local icon = info.spellIcons[153626]
			if icon and icon.active then
				P:UpdateCooldown(icon, 2)
			end
		end
		ConsumedProcCharge(info)
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][1449] = function(info)
	if info.auras.isClearcasting then
		if info.talentData[384858] then
			local icon = info.spellIcons[153626]
			if icon and icon.active then
				P:UpdateCooldown(icon, 2)
			end
		end
	end
end


registeredEvents['SPELL_AURA_REMOVED'][190446] = function(info)
	if info.talentData[354333] then
		local icon = info.spellIcons[314793]
		if icon and icon.active then
			P:UpdateCooldown(icon, 4)
		end
	end
end


local ClearDispelledSrcGUID_OnDelayEnd = function(srcGUID, spellID, destGUID)
	if dispelledHostileGUIDS[destGUID] and dispelledHostileGUIDS[destGUID][spellID] and dispelledHostileGUIDS[destGUID][spellID][srcGUID] then
		wipe(dispelledHostileGUIDS[destGUID][spellID])
	end
end

registeredEvents['SPELL_AURA_REMOVED'][314793] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[354333] and info.spellIcons[spellID] then
		dispelledHostileGUIDS[destGUID] = dispelledHostileGUIDS[destGUID] or {}
		dispelledHostileGUIDS[destGUID][spellID] = dispelledHostileGUIDS[destGUID][spellID] or {}
		dispelledHostileGUIDS[destGUID][spellID][srcGUID] = E.TimerAfter(0.1, ClearDispelledSrcGUID_OnDelayEnd, srcGUID, spellID, destGUID)
	end
end


local fireMageDirectDamage = {
	108853,
	133,
	11366,
	2948,

}

local function ReduceDirectDamageCD(info, _, spellID, _, critical, _,_,_,_,_,_, timestamp)
	if not critical then return end
	if info.talentData[155148] and spellID ~= 2948 then
		local icon = info.spellIcons[190319]
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
	end
	if info.talentData[342344] then
		local icon = info.spellIcons[257541]
		if icon and icon.active then
			if timestamp > (info.auras.time_phoenixflames or 0) then
				P:UpdateCooldown(icon, 1)
				info.auras.time_phoenixflames = timestamp + 0.1
			end
		end
	end
end

for _, id in pairs(fireMageDirectDamage) do
	registeredEvents['SPELL_DAMAGE'][id] = ReduceDirectDamageCD
end

registeredEvents['SPELL_CAST_SUCCESS'][257541] = function(info, _,_, destGUID)
	info.auras.phoenixFlameTargetGUID = destGUID
end

registeredEvents['SPELL_DAMAGE'][257542] = function(info, _,_, destGUID, critical)
	if critical and destGUID == info.auras.phoenixFlameTargetGUID then
		if info.talentData[155148] then
			local icon = info.spellIcons[190319]
			if icon and icon.active then
				P:UpdateCooldown(icon, 1)
			end
		end
	end
end








local frostMageSingleTargetDamage = {
	228597,
	228598,
	228354,
	148022,
	228600,

	319836,

}

for _, id in pairs(frostMageSingleTargetDamage) do
	local reducedTime = id == 228600 and 6 or 1
	registeredEvents['SPELL_DAMAGE'][id] = function(info, _,_,_, critical)
		if critical then
			if info.talentData[378433] then
				local icon = info.spellIcons[12472]
				if icon and icon.active then
					P:UpdateCooldown(icon, reducedTime)
				end
				return
			end
			local conduitValue = info.auras.isSLIcyPropulsion
			if conduitValue then
				local icon = info.spellIcons[12472]
				if icon and icon.active then
					P:UpdateCooldown(icon, conduitValue)
				end
			end
		end
	end
end


registeredEvents['SPELL_AURA_REMOVED'][12472] = function(info, srcGUID, spellID, destGUID)
	info.auras.isSLIcyPropulsion = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][12472] = function(info)
	local conduitValue = P.isInShadowlands and info.talentData[336522]
	if conduitValue then
		info.auras.isSLIcyPropulsion = conduitValue
	end
end

local moreFrostMageDamage = {
	157997,
	122,
	120,
	153596,
	84721,
	325130,
	2577538,
	390614,

}

for _, id in pairs(moreFrostMageDamage) do
	registeredEvents['SPELL_DAMAGE'][id] = function(info, _,_,_, critical)
		if not critical or info.talentData[378433] then return end
		local conduitValue = info.auras.isSLIcyPropulsion
		if conduitValue then
			local icon = info.spellIcons[12472]
			if icon and icon.active then
				P:UpdateCooldown(icon, conduitValue)
			end
		end
	end
end


registeredEvents['SPELL_CAST_SUCCESS'][382445] = function(info)
	for id in pairs(info.active) do
		local icon = info.spellIcons[id]
		if icon and icon.active and BOOKTYPE_CATEGORY[icon.category] and id ~= 382440 then
			P:UpdateCooldown(icon, 3)
		end
	end
end


registeredEvents['SPELL_CAST_SUCCESS'][325130] = function(info)
	for id in pairs(info.active) do
		local icon = info.spellIcons[id]
		if icon and icon.active and BOOKTYPE_CATEGORY[icon.category] and id ~= 382440 then
			local conduitValue = info.talentData[336992]
			P:UpdateCooldown(icon, (conduitValue and 2.5 + conduitValue) or 2.5)
		end
	end
end




registeredEvents['SPELL_AURA_REMOVED'][342246] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[342249] then
		local icon = info.spellIcons[1953] or info.spellIcons[212653]
		if icon and icon.active then
			P:ResetCooldown(icon)
		end
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end


registeredEvents['SPELL_AURA_REMOVED_DOSE'][55342] = function(info, _, spellID)
	if info.talentData[382569] then
		local icon = info.spellIcons[spellID]
		if icon and icon.active then
			P:UpdateCooldown(icon, 10)
		end
	end
end




registeredEvents['SPELL_INTERRUPT'][2139] = function(info, _, spellID, _,_,_, extraSpellId, extraSpellName, _,_, destRaidFlags)
	if info.talentData[382297] then
		local icon = info.spellIcons[spellID]
		if icon and icon.active then
			P:UpdateCooldown(icon, 4)
		end
	elseif P.isInShadowlands then
		local conduitValue = info.talentData[336777]
		if conduitValue then
			local icon = info.spellIcons[spellID]
			if icon and icon.active then
				P:UpdateCooldown(icon, conduitValue)
			end
		end
	end
	AppendInterruptExtras(info, nil, spellID, nil,nil,nil, extraSpellId, extraSpellName, nil,nil, destRaidFlags)
end


registeredEvents['SPELL_DAMAGE'][383479] = function(info, _,_,_,_,_,_,_,_,_,_, timestamp)
	if info.talentData[383476] then
		local icon = info.spellIcons[257541]
		if icon and icon.active then
			if timestamp > (info.auras.time_phoenixreborn or 0) then
				P:UpdateCooldown(icon, 10)
				info.auras.time_phoenixreborn =	 timestamp + 5
			end
		end
	end
end


registeredEvents['SPELL_DAMAGE'][190357] = function(info)
	if info.talentData[236662] then
		local icon = info.spellIcons[84714]
		if icon and icon.active then
			P:UpdateCooldown(icon, .5)
		end
	end
end






registeredEvents['SPELL_AURA_APPLIED'][386276] = function(info, _,_, destGUID)
	if info.spec == 268 and info.spellIcons[386276] then
		info.auras.bonedustTargetGUID = info.auras.bonedustTargetGUID or {}
		info.auras.bonedustTargetGUID[destGUID] = true
	end
end

registeredEvents['SPELL_AURA_REMOVED'][386276] = function(info, _,_, destGUID)
	if info.auras.bonedustTargetGUID and info.auras.bonedustTargetGUID[destGUID] then
		info.auras.bonedustTargetGUID[destGUID] = nil
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][386276] = function(info)
	if info.auras.bonedustTargetGUID then
		wipe(info.auras.bonedustTargetGUID)
	end
end

local function ReduceBonedustBrewCD(info, _,_, destGUID)
	if info.auras.bonedustTargetGUID and info.auras.bonedustTargetGUID[destGUID] then
		local icon = info.spellIcons[386276]
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][100780] = ReduceBonedustBrewCD
registeredEvents['SPELL_CAST_SUCCESS'][121253] = ReduceBonedustBrewCD



local function ReduceBoneMarrowHopsCD(info)
	if info.talentData[386941] then
		local icon = info.spellIcons[386276]
		if icon and icon.active then
			local active = info.active[386276]
			if active then
				active.numHits = (active.numHits or 0) + 1
				if active.numHits <= 10 then
					P:UpdateCooldown(icon, 0.5)
				end
			end
		end
		return
	end
	local conduitValue = P.isInShadowlands and info.talentData[337295]
	if conduitValue then
		local icon = info.spellIcons[325216]
		if icon and icon.active then
			local now = GetTime()
			if now > (info.auras.time_bonemarrowhops or 0) then
				P:UpdateCooldown(icon, conduitValue)
				info.auras.time_bonemarrowhops = now + 1
			end
		end
	end
end

registeredEvents['SPELL_DAMAGE'][325217] = ReduceBoneMarrowHopsCD
registeredEvents['SPELL_HEAL'][325218] = ReduceBoneMarrowHopsCD


registeredEvents['SPELL_AURA_APPLIED'][228563] = function(info)
	info.auras.isBlackoutCombo = true
end

registeredEvents['SPELL_AURA_REMOVED'][228563] = function(info)
	info.auras.isBlackoutCombo = nil
end


registeredEvents['SPELL_AURA_REMOVED'][387184] = function(info, srcGUID, _, destGUID)
	info.auras["isWeaponsOfOrder"] = nil
	RemoveHighlightByCLEU(info, srcGUID, 387184, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][387184] = function(info)
	info.auras["isWeaponsOfOrder"] = true
end


registeredEvents['SPELL_AURA_REMOVED'][310454] = registeredEvents['SPELL_AURA_REMOVED'][387184]
registeredEvents['SPELL_AURA_APPLIED'][310454] = registeredEvents['SPELL_AURA_APPLIED'][387184]


registeredEvents['SPELL_AURA_APPLIED'][393786] = function(info)
	local active = info.active[387184]
	if active then
		active.numHits = (active.numHits or 0) + 1
		if active.numHits <= 4 then
			local icon = info.spellIcons[387184]
			if icon and icon.active then
				P:UpdateCooldown(icon, 4)
			end
		end
	end
end


local stunDebuffs = {
	[210141]  = true,
	[334693]  = true,
	[108194]  = true,
	[221562]  = true,
	[91800]	  = true,
	[91797]	  = true,
	[287254]  = true,
	[179057]  = true,
	[213491]  = true,
	[205630]  = true,
	[208618]  = true,
	[211881]  = true,
	[200166]  = true,
	[203123]  = true,
	[163505]  = true,
	[5211]	  = true,
	[202244]  = true,
	[325321]  = true,
	[357021]  = true,
	[24394]	  = true,
	[119381]  = true,
	[202346]  = true,
	[853]	  = true,
	[255941]  = true,
	[64044]	  = true,
	[200200]  = true,
	[1833]	  = true,
	[408]	  = true,
	[118905]  = true,
	[118345]  = true,
	[305485]  = true,
	[89766]	  = true,
	[171017]  = true,
	[171018]  = true,
	[22703]	  = true,
	[30283]	  = true,
	[46968]	  = true,
	[132168]  = true,
	[132169]  = true,
	[199085]  = true,
	[385954]  = true,
	[213688]  = true,
	[20549]	  = true,
	[255723]  = true,
	[287712]  = true,
	[332423]  = true,
}

local TRANSCENDENCE_TRANSFER = 119996

for id in pairs(stunDebuffs) do
	registeredHostileEvents['SPELL_AURA_APPLIED'][id] = function(destInfo)
		if P.isPvP and destInfo.talentData[353584] and destInfo.spellIcons[TRANSCENDENCE_TRANSFER] then
			local c = destInfo.auras.isStunned
			c = c and c + 1 or 1
			destInfo.auras.isStunned = c
		end
	end
	registeredHostileEvents['SPELL_AURA_REMOVED'][id] = function(destInfo)
		local c = destInfo.auras.isStunned
		if c then
			destInfo.auras.isStunned = max(c - 1, 0)
		end
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][TRANSCENDENCE_TRANSFER] = function(info, _, spellID)
	local icon = info.spellIcons[spellID]
	if icon and not info.auras.isEscapeFromReality then
		P:StartCooldown(icon, P.isPvP and info.talentData[353584] and (not info.auras.isStunned or info.auras.isStunned < 1) and icon.duration - 15 or icon.duration )
	end
end





registeredEvents['SPELL_AURA_REMOVED'][394112] = function(info)
	if info and info.auras.isEscapeFromReality then
		info.auras.isEscapeFromReality = nil
		local icon = info.spellIcons[TRANSCENDENCE_TRANSFER]
		if icon and not icon.active then
			P:StartCooldown(icon, 35)
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][394112] = function(info)
	if info.spellIcons[TRANSCENDENCE_TRANSFER] then
		info.auras.isEscapeFromReality = true
	end
end


registeredEvents['SPELL_HEAL'][191894] = function(info)
	if info.talentData[388031] then
		local icon = info.spellIcons[322118] or info.spellIcons[325197]
		if icon and icon.active then
			P:UpdateCooldown(icon, .3)
		end
	end
end


registeredEvents['SPELL_AURA_REMOVED'][393099] = function(info)
	info.auras.isForbiddenTechnique = nil
	local icon = info.spellIcons[322109]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][393099] = function(info)
	info.auras.isForbiddenTechnique = true
end

registeredEvents['SPELL_CAST_SUCCESS'][322109] = function(info)
	local icon = info.spellIcons[322109]
	if icon and not info.auras.isForbiddenTechnique then
		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents['SPELL_DAMAGE'][322109] = function(info, _,_,_,_, destFlags, _, overkill)
	if overkill > -1 and P:IsTalentForPvpStatus(345829, info) and band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
		local icon = info.spellIcons[122470]
		if icon and icon.active then
			P:UpdateCooldown(icon, 60)
		end
	end
end


local monkBrews = {
	386276,
	115203,
	322507,
	119582,
	115399,
}

local function ReduceBrewCD(destInfo, _,_,_,_,_, timestamp)
	local talentRank = destInfo.talentData[386937]
	if talentRank then
		local lastDodge = destInfo.auras.time_dodged or 0
		if timestamp > lastDodge then
			local talentValue = talentRank == 2 and 1 or .5
			for i = 1, 5 do
				local id = monkBrews[i]
				local icon = destInfo.spellIcons[id]
				if icon and icon.active then
					P:UpdateCooldown(icon, talentValue)
				end
			end
			destInfo.auras.time_dodged = timestamp + 3
		end
	end
end

registeredHostileEvents['SWING_MISSED']['MONK'] = ReduceBrewCD
registeredHostileEvents['RANGE_MISSED']['MONK'] = ReduceBrewCD
registeredHostileEvents['SPELL_MISSED']['MONK'] = ReduceBrewCD
registeredHostileEvents['SPELL_PERIODIC_MISSED']['MONK'] = ReduceBrewCD


local function ReduceTouchOfDeathOrInvokeXuenCD(info)
	if info.talentData[391330] then
		local icon = info.spellIcons[322109]
		if icon and icon.active then
			P:UpdateCooldown(icon, .35)
		end
	end
	if info.talentData[392986] then
		local icon = info.spellIcons[123904]
		if icon and icon.active then
			P:UpdateCooldown(icon, .1)
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][196741] = ReduceTouchOfDeathOrInvokeXuenCD
registeredEvents['SPELL_AURA_APPLIED_DOSE'][196741] = ReduceTouchOfDeathOrInvokeXuenCD
registeredEvents['SPELL_AURA_REFRESH'][196741] = ReduceTouchOfDeathOrInvokeXuenCD


registeredEvents['SPELL_AURA_APPLIED'][388203] = function(info)
	local icon = info.spellIcons[388193]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


local wwChiSpenders = {
	[113656] = 3,
	[392983] = 2,
	[116847] = 1,
	[107428] = 2,
	[100784] = 1,
	[101546] = 2,
}

local function ReduceSEFSerenityCD(info, _, spellID)
	if info.talentData[280197] then
		local serenityIcon = info.spellIcons[152173]
		local icon = info.spellIcons[137639] or serenityIcon
		if icon and icon.active and not info.auras.isSerenity then
			local c = wwChiSpenders[spellID]
			P:UpdateCooldown(icon, c * (serenityIcon and .15 or .5))
		end
	end
end

for id in pairs(wwChiSpenders) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = ReduceSEFSerenityCD
end


--[[ CDTS
registeredEvents['SPELL_AURA_REMOVED'][116680] = function(info, srcGUID, spellID, destGUID))
	info.auras.isThunderFocusTea = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	StartCdOnAuraRemoved(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][116680] = function(info)
	info.auras.isThunderFocusTea = true
end

registeredEvents['SPELL_CAST_SUCCESS'][107428] = function(info, _, spellID)
	if info.auras.isThunderFocusTea then
		local icon = info.spellIcons[107428]
		P:UpdateCooldown(icon, 9)
	end
	ReduceSEFSerenityCD(info, nil, spellID)
end
]]


registeredEvents['SPELL_HEAL'][116670] = function(info, _,_,_,_,_,_,_,_, criticalHeal)
	if info.talentData[388551] and criticalHeal then
		local icon = info.spellIcons[115310] or info.spellIcons[388615]
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
	end
end

registeredEvents['SPELL_DAMAGE'][185099] = function(info, _,_,_, critical)
	if info.talentData[388551] then
		local icon = info.spellIcons[115310] or info.spellIcons[388615]
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
	elseif P.isInShadowlands then
		local conduitValue = info.talentData[337099]
		if conduitValue then
			local icon = info.spellIcons[115310]
			if icon and icon.active then
				P:UpdateCooldown(icon, conduitValue)
			end
		end
	end
	if critical then
		if info.talentData[392993] then
			local icon = info.spellIcons[113656]
			if icon and icon.active then
				P:UpdateCooldown(icon, 4)
			end
		elseif P.isInShadowlands and info.talentData[337481] then
			local icon = info.spellIcons[113656]
			if icon and icon.active then
				P:UpdateCooldown(icon, 5)
			end
		end
	end
end



registeredEvents['SPELL_DAMAGE'][121253] = function(info, _,_,_,_,_,_,_,_,_,_, timestamp)
	local talentRank = info.talentData[387219]
	if talentRank then
		local icon = info.spellIcons[132578]
		if icon and icon.active then
			if timestamp > (info.auras.time_shuffle or 0) then
				P:UpdateCooldown(icon, .25 * talentRank)
				info.auras.time_shuffle = timestamp + .1
			end
		end
		return
	end
	local conduitValue = P.isInShadowlands and info.talentData[337264]
	if conduitValue then
		local icon = info.spellIcons[132578]
		if icon and icon.active then
			if timestamp > (info.auras.time_shuffle or 0) then
				P:UpdateCooldown(icon,conduitValue)
				info.auras.time_shuffle = timestamp + .1
			end
		end
	end
end

registeredEvents['SPELL_DAMAGE'][107270] = registeredEvents['SPELL_DAMAGE'][121253]
registeredEvents['SPELL_DAMAGE'][205523] = registeredEvents['SPELL_DAMAGE'][121253]


registeredEvents['SPELL_AURA_REMOVED'][326860] = function(info, srcGUID, spellID, destGUID)
	info.auras.isFallenOrder = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][326860] = function(info)
	if info.talentData[356818] and info.spellIcons[326860] then
		info.auras.isFallenOrder = true
	end
end

registeredEvents['SPELL_DAMAGE']['MONK'] = function(info, _, spellID, _, critical)
	if critical and info.auras.isFallenOrder and spellID ~= 185099 then
		local icon = info.spellIcons[326860]
		if icon and icon.active then
			local now = GetTime()
			if now > (info.auras.time_sinisterteachings or 0) then
				P:UpdateCooldown(icon, info.spec == 270 and 2.5 or 5)
				info.auras.time_sinisterteachings = now + 0.75
			end
		end
	end
end

registeredEvents['SPELL_HEAL']['MONK'] = function(info, _, spellID, _, _, _, _, _, _, resisted)
	if resisted and info.auras.isFallenOrder and spellID ~= 191894 and spellID ~= 191840 then
		local icon = info.spellIcons[326860]
		if icon and icon.active then
			local now = GetTime()
			if now > (info.auras.time_sinisterteachings or 0) then
				P:UpdateCooldown(icon, info.spec == 270 and 2.5 or 5)
				info.auras.time_sinisterteachings = now + 0.75
			end
		end
	end
end

registeredEvents['SPELL_PERIODIC_HEAL']['MONK'] = function(info, _, _, _, _, _, _, _, _, resisted)
	if resisted and info.auras.isFallenOrder then
		local icon = info.spellIcons[326860]
		if icon and icon.active then
			local now = GetTime()
			if now > (info.auras.time_sinisterteachings or 0) then
				P:UpdateCooldown(icon, info.spec == 270 and 2.5 or 5)
				info.auras.time_sinisterteachings = now + 0.75
			end
		end
	end
end






registeredEvents['SPELL_HEAL'][633] = function(info, _,_, destGUID, _,_, amount, overhealing)
	if info.talentData[326734] then
		local icon = info.spellIcons[633]
		if icon then
			P:StartCooldown(icon, icon.duration)

			local unit = UnitTokenFromGUID(destGUID)
			if unit then
				local maxHP = UnitHealthMax(unit)
				if maxHP > 0 then
					local actualhealing = amount - overhealing
					local reducedMult = min(actualhealing / maxHP * 6/7, 0.6)
					if reducedMult > 0 then
						if icon.active then
							P:UpdateCooldown(icon, icon.duration * reducedMult)
						end
					end
				end
			end
		end
	end
end


registeredEvents['SPELL_AURA_REMOVED'][327193] = function(info, srcGUID, spellID, destGUID)
	if info.auras["isMomentOfGlory"] then
		info.auras["isMomentOfGlory"] = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][327193] = function(info)
	local icon = info.spellIcons[31935]
	if icon then
		info.auras["isMomentOfGlory"] = true
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][31935] = function(info)
	local icon = info.spellIcons[31935]
	if icon and not info.auras["isMomentOfGlory"] then
		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents['SPELL_AURA_APPLIED'][383329] = function(info)
	local icon = info.spellIcons[24275]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


registeredEvents['SPELL_AURA_APPLIED'][337228] = function(info)
	local icon = info.spellIcons[24275]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


registeredEvents['SPELL_AURA_APPLIED'][383283] = function(info)
	local icon = info.spellIcons[255937]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


registeredEvents['SPELL_AURA_APPLIED'][85416] = function(info)
	local icon = info.spellIcons[31935]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


local function RemoveHandOfHindrance_OnDurationEnd(srcGUID)
	local info = groupInfo[srcGUID]
	if info and info.callbackTimers[183218] then
		info.callbackTimers[183218] = nil
	end
end

registeredEvents['SPELL_AURA_REMOVED'][183218] = function(info, srcGUID, spellID)
	if info.callbackTimers[spellID] then
		local icon = info.spellIcons[spellID]
		if icon and icon.active then
			P:UpdateCooldown(icon, 15)
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][183218] = function(info, srcGUID, spellID)
	if P.isPvP then
		info.callbackTimers[spellID] = E.TimerAfter(9.95, RemoveHandOfHindrance_OnDurationEnd, srcGUID)
	end
end


local FORBEARANCE_DURATION = E.preCata and (E.isWOTLKC and 120 or 60) or 30

local forbearanceIDs = {
	[1022] = 0,
	[204018] = 0,
	[642] = 30,
	[633] = 0,

}

registeredEvents['SPELL_AURA_REMOVED'][25771] = function(_,_, spellID, destGUID)
	local destInfo = groupInfo[destGUID]
	if not destInfo or not destInfo.auras.isForbearanceOnUsableShown then
		return
	end
	for id in pairs(forbearanceIDs) do
		local icon = destInfo.preactiveIcons[id]
		if icon then
			icon.icon:SetVertexColor(1, 1, 1)
			destInfo.preactiveIcons[id] = nil
		end
	end
	destInfo.auras.isForbearanceOnUsableShown = nil
end

registeredEvents['SPELL_AURA_APPLIED'][25771] = function(_,_, spellID, destGUID)
	if not E.db.icons.showForbearanceCounter then
		return
	end
	local destInfo = groupInfo[destGUID]
	if not destInfo then
		return
	end

	local now = GetTime()
	for id, fcd in pairs(forbearanceIDs) do
		local icon = destInfo.spellIcons[id]
		if icon then
			local active = icon.active and destInfo.active[id]
			local remainingTime = active and (active.duration - now + active.startTime)
			if fcd > 0 then
				if not active then
					P:StartCooldown(icon, fcd, nil, true)
				elseif remainingTime < fcd then
					P:UpdateCooldown(icon, remainingTime - fcd)
				end
			else
				local charges = active and active.charges
				if not active or ( icon.maxcharges and charges and charges > 0 or remainingTime < FORBEARANCE_DURATION ) then
					destInfo.preactiveIcons[id] = icon
					if not icon.isHighlighted then
						icon.icon:SetVertexColor(0.4, 0.4, 0.4)
					end
					destInfo.auras.isForbearanceOnUsableShown = true
				end
			end
		end
	end
end

registeredUserEvents['SPELL_AURA_APPLIED'][25771] = registeredEvents['SPELL_AURA_APPLIED'][25771]
registeredUserEvents['SPELL_AURA_REMOVED'][25771] = registeredEvents['SPELL_AURA_REMOVED'][25771]




















local holyPowerSpenders = {
	--[[
	[85673] = {
		234299, nil, 3.0, 853, { "BastionofLight", 0, "DivinePurpose", 0, "ShiningLight", 0, "FireofJustice", -1, "SealofClarity", -1 },
		392928, nil, 3.0, 633, { "DivinePurpose", 0, "SealofClarity", -1 },
		385422, nil, 1.0, { 31850, 642 }, nil, { "BastionofLight", 0, "DivinePurpose", 0, "ShiningLight", 0 "SealofClarity", -0.33 },
		204074, nil, 1.5, { 31884, 216331, 231895, 389539, 86659, 228049 }, { "BastionofLight", 0, "DivinePurpose", 0, "ShiningLight", 0, "SealofClarity", -0.5 },
	},
	[53600] = {
		234299, nil, 3.0, 853, { "BastionofLight", 0, "DivinePurpose", 0, "FireofJustice", -1, "SealofClarity", -1 },
		392928, nil, 3.0, 633, { "DivinePurpose", 0, "SealofClarity", -1 },
		385422, nil, 1.0, { 31850, 642 }, nil, { "BastionofLight", 0, "DivinePurpose", 0, "SealofClarity", -0.33 },
		204074, nil, 1.5, { 31884, 216331, 231895, 389539, 86659, 228049 }, { "BastionofLight", 0, "DivinePurpose", 0, "SealofClarity", -0.5 },
	},
	[152262] = {
		234299, nil, 3.0, 853, { "DivinePurpose", 0, "FireofJustice", -1 },
		392928, nil, 3.0, 633, { "DivinePurpose", 0 },
		385422, nil, 1.0, { 31850, 642 }, nil, { "DivinePurpose", 0 },
		204074, nil, 1.5, { 31884, 216331, 231895, 389539, 86659, 228049 }, { "DivinePurpose", 0 },
	},
	[391054] = {
		234299, 66,  3.0, 853, { "DivinePurpose", 0 },
		385422, 66,  1.0, { 31850, 642 }, nil, { "DivinePurpose", 0 },
		204074, 66,  1.5, { 31884, 216331, 231895, 389539, 86659, 228049 }, { "DivinePurpose", 0 },
	},
	[85256] = {
		234299, nil, 3.0, 853, { "DivinePurpose", 0, "FireofJustice", -1 },
	},
	[53385] = {
		234299, nil, 3.0, 853, { "EmpyreanPower", 0, "DivinePurpose", 0, "FireofJustice", -1 },
	},
	[343527] = {
		234299, nil, 3.0, 853, { "DivinePurpose", 0, "FireofJustice", -1 },
	},
	[215661] = {
		234299, nil, 3.0, 853, { "DivinePurpose", 0, "FireofJustice", -1 },
	},
	[383328] = {
		234299, nil, 3.0, 853, { "DivinePurpose", 0, "FireofJustice", -1 },
	},
	[384052] = {
		234299, nil, 3.0, 853, { "DivinePurpose", 0, "FireofJustice", -1 },
	},
	[85222] = {
		234299, nil, 3.0, 853, { "DivinePurpose", 0, "SealofClarity", -1 },
		392928, nil, 3.0, 633, { "DivinePurpose", 0, "SealofClarity", -1 },
	},
	]]
	[85673] = {
		234299, nil, 3.0, 853, { "BastionofLight", 0, "DivinePurpose", -2.7, "ShiningLight", -2.7, "SealofClarity", -1 },
		392928, nil, 3.0, 633, { "DivinePurpose", -2.7 },
		385422, nil, 1.0, { 31850, 642 }, nil,
		204074, nil, 1.5, { 31884, 216331, 231895, 389539, 86659, 228049 }, { "BastionofLight", {"DivinePurpose", "ShiningLight"}, "DivinePurpose", .01, "ShiningLight", .01, "SealofClarity", -0.5  },
	},
	[53600] = {
		234299, nil, 3.0, 853, { "BastionofLight", 0, "DivinePurpose", -2.7, "SealofClarity", -1 },
		392928, nil, 3.0, 633, { "DivinePurpose", -2.7 },
		385422, nil, 1.0, { 31850, 642 }, nil,
		204074, nil, 1.5, { 31884, 216331, 231895, 389539, 86659, 228049 }, { "BastionofLight", {"DivinePurpose"}, "DivinePurpose", .01, "SealofClarity", -0.5 },
	},
	[152262] = {
		234299, nil, 3.0, 853, { "DivinePurpose", -2.7 },
		392928, nil, 3.0, 633, { "DivinePurpose", -2.7 },
		385422, nil, 1.0, { 31850, 642 }, nil,
		204074, nil, 1.5, { 31884, 216331, 231895, 389539, 86659, 228049 }, "nil",
	},
	[391054] = {
		234299, 66,  3.0, 853, { "DivinePurpose", 0 },
		385422, 66,  1.0, { 31850, 642 }, nil,
		204074, 66,  1.5, { 31884, 216331, 231895, 389539, 86659, 228049 }, "nil",
	},
	[85256] = {
		234299, nil, 3.0, 853, { "DivinePurpose", -2.7 },
	},
	[53385] = {
		234299, nil, 3.0, 853, { "EmpyreanPower", -2.7, "DivinePurpose", -2.7 },
	},
	[343527] = {
		234299, nil, 3.0, 853, { "DivinePurpose", -2.7 },
	},
	[215661] = {
		234299, nil, 3.0, 853, { "DivinePurpose", -2.7 },
	},
	[383328] = {
		234299, nil, 3.0, 853, { "DivinePurpose", -2.7 },
	},
	[384052] = {
		234299, nil, 3.0, 853, { "DivinePurpose", -2.7 },
	},
	[85222] = {
		234299, nil, 3.0, 853, { "DivinePurpose", -2.7, "SealofClarity", -1 },
		392928, nil, 3.0, 633, { "DivinePurpose", -2.7, "SealofClarity", -1 },
	},
}


for id, t in pairs(holyPowerSpenders) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = function(info, _,_,_,_,_,_,_,_,_,_, timestamp)
		for i= 1,#t,5 do
			local talent, spec, rCD, target, aura = t[i], t[i+1], t[i+2], t[i+3], t[i+4]
			local talentRank = info.talentData[talent]
			if talentRank and (not spec or spec == info.spec) then
				if talent ~= 234299 or timestamp > (info.auras.time_lastfistofjustice or 0) then
					if aura then
						for j=1,#aura,2 do
							local key, rrCD = aura[j], aura[j+1]
							if info.auras[key] then
								if rrCD == 0 then
									rCD = 0
									break
								elseif type(rrCD) == "table" then
									local cancelBastion
									for _, str in pairs(rrCD) do
										if info.auras[str] then
											cancelBastion = true
											break
										end
									end
									if not cancelBastion then
										rCD = 0
										break
									end
									rrCD = 0
								end
								rCD = rCD + rrCD
								if key ~= "SealofClarity" then
									break
								end
							end
						end
					end
					if rCD > 0 then
						rCD = talentRank == 2 and 2*rCD or rCD
						if type(target) == "table" then
							for _, spellID in pairs(target) do
								local icon = info.spellIcons[spellID]
								if icon and icon.active then
									P:UpdateCooldown(icon, rCD)
								end
							end
						else
							local icon = info.spellIcons[target]
							if icon and icon.active then
								P:UpdateCooldown(icon, rCD)
							end
						end
						if talent == 234299 then
							info.auras.time_lastfistofjustice = timestamp + 1
						end
					end
				end

			elseif id == 53600 and talent == 385422 then
				local conduitValue = P.isInShadowlands and info.talentData[340023]
				if conduitValue then
					local icon = info.spellIcons[31850]
					if icon and icon.active then
						P:UpdateCooldown(icon, conduitValue)
					end
				end
			end
		end
	end
end


--[[ CDTS
local function ReduceHammerOfWrathCD(info, _,_,_,_,_,_,_,_, criticalHeal)
	if criticalHeal and info.talentData[392938] then
		local icon = info.spellIcons[24275]
		if icon and active then
			P:ResetCooldown(icon)
		end
	end
end

registeredEvents['SPELL_HEAL'][19750] = ReduceHammerOfWrathCD
registeredEvents['SPELL_HEAL'][82326] = ReduceHammerOfWrathCD
]]


registeredEvents['SPELL_DAMAGE'][31935] = function(info)
	local talentRank = info.talentData[378279]
	if talentRank then
		local icon = info.spellIcons[86659]
		if icon and icon.active then
			P:UpdateCooldown(icon, 0.5 * talentRank)
		end
	end
end



local function upateLastTick(info)
	if info.auras.time_ashenhallow then
		info.auras.time_ashenhallow = GetTime()
	end
end
registeredEvents['SPELL_DAMAGE'][317221] = upateLastTick
registeredEvents['SPELL_HEAL'][317223] = upateLastTick

registeredEvents['SPELL_CAST_SUCCESS'][316958] = function(info, _, spellID)
	if info.talentData[355447] then
		local icon = info.spellIcons[spellID]
		if icon then
			local startTime = GetTime()
			if info.callbackTimers.ashenHallowTicker then
				info.callbackTimers.ashenHallowTicker:Cancel()
			end
			info.auras.time_ashenhallowcast = startTime
			info.auras.time_ashenhallow = startTime
			local callback = function()
				local now = GetTime()
				if now - info.auras.time_ashenhallow > 2 then
					local remainingTime = 47 - (now - info.auras.time_ashenhallowcast)
					if remainingTime > 0.25 then
						if icon and icon.active then
							P:UpdateCooldown(icon, (remainingTime / 45) * 0.5 * icon.duration)
						end
					end
					info.auras.time_ashenhallowcast = nil
					info.auras.time_ashenhallow = nil
					info.callbackTimers.ashenHallowTicker:Cancel()
					info.callbackTimers.ashenHallowTicker = nil
				end
			end
			info.callbackTimers.ashenHallowTicker = C_Timer_NewTicker(2, callback, 23)
		end
	end
end


local onADRemoval = function(srcGUID, spellID, destGUID)
	local info = groupInfo[srcGUID]
	if info then
		local icon = info and info.spellIcons[spellID]
		if icon then
			if info.auras.isSavedByAD then
				info.auras.isSavedByAD = nil
			elseif P.isInShadowlands and info.talentData[337838] then
				local active = info.active[spellID]
				if active then
					local reducedTime = (icon.duration - (GetTime() - active.startTime)) * 0.4
					P:UpdateCooldown(icon, reducedTime)
				end
			end
			RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
		end
	end
end

registeredEvents['SPELL_AURA_REMOVED'][31850] = function(info, srcGUID, spellID, destGUID)
	if P.isInShadowlands then
		E.TimerAfter(0.1, onADRemoval, srcGUID, spellID, destGUID)
	else
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
end

registeredEvents['SPELL_HEAL'][66235] = function(info)
	if P.isInShadowlands and info.talentData[337838] and info.spellIcons[31850] then
		info.auras.isSavedByAD = true
	end
end


local function ReduceDivineShieldCD(destInfo, _,_,_,_,_, timestamp)
	local conduitValue = P.isInShadowlands and destInfo.talentData[338741]
	if conduitValue then
		local icon = destInfo.spellIcons[642]
		if icon and icon.active then
			if timestamp > (destInfo.auras.time_divinecall or 0) then
				P:UpdateCooldown(icon, 5)
				destInfo.auras.time_divinecall = timestamp + conduitValue
			end
		end
	end
end

registeredHostileEvents['SWING_DAMAGE']['PALADIN'] = ReduceDivineShieldCD
registeredHostileEvents['RANGE_DAMAGE']['PALADIN'] = ReduceDivineShieldCD
registeredHostileEvents['SPELL_DAMAGE']['PALADIN'] = ReduceDivineShieldCD
registeredHostileEvents['SPELL_ABSORBED']['PALADIN'] = ReduceDivineShieldCD






registeredEvents['SPELL_AURA_REMOVED'][200183] = function(info, srcGUID, spellID, destGUID)
	info.auras.isApotheosisActive = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][200183] = function(info, srcGUID, spellID, destGUID)
	info.auras.isApotheosisActive = true
end


registeredEvents['SPELL_HEAL'][373481] = function(info, _,_, destGUID, _,_, amount, overhealing)
	local icon = info.spellIcons[373481]
	if icon then
		P:StartCooldown(icon, icon.duration)

		local unit = UnitTokenFromGUID(destGUID)
		if unit then
			local maxHP = UnitHealthMax(unit)
			if maxHP > 0 then
				local currHP = UnitHealth(unit) - (amount - overhealing)
				if currHP / maxHP < .35 then
					if icon.active then
						P:UpdateCooldown(icon, 20)
					end
				end
			end
		end
	end
end


registeredEvents['SPELL_CAST_SUCCESS'][32379] = function(info, _,_, destGUID, _,_,_,_,_,_,_, timestamp)
	if info.talentData[321291] and info.spellIcons[32379] then
		if timestamp > (info.auras.time_shadowworddeath_reset or 0) then
			local unit = UnitTokenFromGUID(destGUID)
			if unit then
				local maxHP = UnitHealthMax(unit)
				if maxHP > 0 then
					info.auras.isDeathTargetUnder20 = UnitHealth(unit) /  maxHP <= .2
				end
			end
		end
	end
end

registeredEvents['SPELL_DAMAGE'][32379] = function(info, _,_,_,_,_,_, overkill, _,_,_, timestamp)
	if info.talentData[321291] then
		if overkill == -1 and info.auras.isDeathTargetUnder20 then
			local icon = info.spellIcons[32379]
			if icon and icon.active then
				P:ResetCooldown(icon)
			end
			info.auras.time_shadowworddeath_reset = timestamp + 20
		end
		info.auras.isDeathTargetUnder20 = nil
	end
end


registeredEvents['SPELL_AURA_APPLIED'][392511] = function(info)
	local icon = info.spellIcons[32379]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


local onGSRemoval = function(srcGUID, spellID, destGUID)
	local info = groupInfo[srcGUID]
	if info then
		if info.auras.isSavedByGS then
			info.auras.isSavedByGS = nil
		else
			local icon = info.spellIcons[47788]
			if icon and info.talentData[200209] or info.talentData[63231] then
				P:StartCooldown(icon, 60)
			end
		end
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
end

registeredEvents['SPELL_AURA_REMOVED'][47788] = function(info, srcGUID, spellID, destGUID)
	local icon = info.spellIcons[47788]
	if icon then
		E.TimerAfter(0.05, onGSRemoval, srcGUID, spellID, destGUID)
	end
end

registeredEvents['SPELL_HEAL'][48153] = function(info)
	if info.spellIcons[47788] then
		info.auras.isSavedByGS = true
	end
end


registeredEvents['SPELL_AURA_REMOVED'][194249] = function(info, srcGUID, spellID, destGUID)
	if info.callbackTimers.isVoidForm then
		if srcGUID ~= userGUID then
			info.callbackTimers.isVoidForm:Cancel()
		end
		info.callbackTimers.isVoidForm = nil
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end
registeredEvents['SPELL_AURA_REMOVED'][391109] = registeredEvents['SPELL_AURA_REMOVED'][194249]

local removeVoidForm
removeVoidForm = function(srcGUID, spellID, destGUID)
	local info = groupInfo[srcGUID]
	if info and info.callbackTimers.isVoidForm then
		local duration = P:GetBuffDuration(info.unit, spellID)
		if duration then
			info.callbackTimers.isVoidForm = E.TimerAfter(duration + 1, removeVoidForm, srcGUID, spellID, destGUID)
			return
		end
		info.callbackTimers.isVoidForm = nil
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
end
registeredEvents['SPELL_AURA_APPLIED'][194249] = function(info, srcGUID, spellID, destGUID)
	if P.isPvP and info.talentData[199259] and info.spellIcons[228260] then
		info.auras.isPvpAndDrivenToMadness = true
		info.callbackTimers.isVoidForm = srcGUID == userGUID or E.TimerAfter(20.1, removeVoidForm, srcGUID, spellID, destGUID)
	else
		info.auras.isPvpAndDrivenToMadness = nil
	end
end
registeredEvents['SPELL_AURA_APPLIED'][391109] = function(info, srcGUID, spellID, destGUID)
	if P.isPvP and info.talentData[199259] and info.spellIcons[391109] then
		info.auras.isPvpAndDrivenToMadness = true
		info.callbackTimers.isVoidForm = srcGUID == userGUID or E.TimerAfter(20.1, removeVoidForm, srcGUID, spellID, destGUID)
	else
		info.auras.isPvpAndDrivenToMadness = nil
	end
end

local function ReduceVoidEruptionCD(destInfo, _,_,_,_,_, timestamp)
	if destInfo.auras.isPvpAndDrivenToMadness and not destInfo.callbackTimers.isVoidForm then
		local icon = destInfo.spellIcons[228260] or destInfo.spellIcons[391109]
		if icon and icon.active then
			if timestamp > (destInfo.auras.time_driventomadness or 0) then
				P:UpdateCooldown(icon, 3)
				destInfo.auras.time_driventomadness = timestamp + 1
			end
		end
	end
end
local function ReduceDesperatePrayerCD(destInfo, _,_, amount, overkill)
	if destInfo.talentData[238100] then
		local icon = destInfo.spellIcons[19236]
		if icon and icon.active then
			local maxHP = UnitHealthMax(destInfo.unit)
			if maxHP > 0 then
				local actualDamage = amount - (overkill or 0)
				local reducedTime = actualDamage / maxHP * 33
				P:UpdateCooldown(icon, reducedTime)
			end
		end
	end
end
local function ReduceVoidEruptionDesperatePrayerCD(destInfo, _,_, amount, overkill, _, timestamp)
	ReduceVoidEruptionCD(destInfo, nil,nil,nil,nil,nil, timestamp)
	ReduceDesperatePrayerCD(destInfo, nil, nil, amount, overkill)
end

registeredHostileEvents['SWING_DAMAGE']['PRIEST'] = function(destInfo, _, spellID, _,_,_, timestamp) ReduceVoidEruptionDesperatePrayerCD(destInfo,nil,nil,spellID,nil,nil,timestamp) end
registeredHostileEvents['RANGE_DAMAGE']['PRIEST'] = ReduceVoidEruptionDesperatePrayerCD
registeredHostileEvents['SPELL_DAMAGE']['PRIEST'] = ReduceVoidEruptionDesperatePrayerCD
registeredHostileEvents['SPELL_ABSORBED']['PRIEST'] = ReduceVoidEruptionCD
registeredHostileEvents['SPELL_PERIODIC_DAMAGE']['PRIEST'] = ReduceDesperatePrayerCD


registeredEvents['SPELL_AURA_APPLIED'][322431] = function(info)
	local icon = info.spellIcons[316262]
	if icon then
		local statusBar = icon.statusBar
		if icon.active then
			if statusBar then
				P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, 'UNIT_SPELLCAST_STOP')
			end
			icon.cooldown:Clear()
		end
		if statusBar then
			statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
		end
		info.preactiveIcons[316262] = icon
		if not icon.isHighlighted then
			icon.icon:SetVertexColor(0.4, 0.4, 0.4)
		end
	end
end

registeredEvents['SPELL_AURA_REMOVED'][322431] = function(info)
	local icon = info.spellIcons[316262]
	if icon then
		local statusBar = icon.statusBar
		if statusBar then
			P:SetExStatusBarColor(icon, statusBar.key)
		end
		info.preactiveIcons[316262] = nil
		icon.icon:SetVertexColor(1, 1, 1)

		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents['SPELL_AURA_REMOVED'][394729] = function(info)
	info.auras["isPrayerFocus2PC"] = nil
end

registeredEvents['SPELL_AURA_APPLIED'][394729] = function(info)
	info.auras["isPrayerFocus2PC"] = true
end


--[[ Exact duplicate of Restitution (DF talent)
registeredEvents['SPELL_AURA_APPLIED'][211319] = function(info)
	local icon = info.spellIcons[20711]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end
]]


registeredEvents['SPELL_CAST_SUCCESS'][10060] = function(info, srcGUID, _, destGUID)
	local conduitValue = P.isInShadowlands and info.talentData[337762]
	if conduitValue and srcGUID ~= destGUID then
		local icon = info.spellIcons[10060]
		if icon and icon.active then
			P:UpdateCooldown(icon, conduitValue)
		end
	end
end


registeredEvents['SPELL_AURA_APPLIED_DOSE'][325013] = function(info, _,_,_,_,_,_, amount)
	if info.auras.numBoonOfTheAscended then
		info.auras.numBoonOfTheAscended = amount
	end
end

registeredEvents['SPELL_AURA_REMOVED'][325013] = function(info, srcGUID, spellID, destGUID)
	local consumed = info.auras.numBoonOfTheAscended
	if consumed then
		local icon = info.spellIcons[325013]
		if icon and icon.active then
			P:UpdateCooldown(icon, min(consumed * 3, 60))
		end
		info.auras.numBoonOfTheAscended = nil
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_CAST_SUCCESS'][325013] = function(info)
	if info.talentData[356395] and info.spellIcons[325013] then
		info.auras.numBoonOfTheAscended = 0
	end
end






registeredEvents['SPELL_CAST_SUCCESS'][36554] = function(info, _, spellID, destGUID, _, destFlags)
	local icon = info.spellIcons[spellID]
	if icon and icon.active then
		if info.talentData[197899] then
			if P.isPvP and band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 then
				P:UpdateCooldown(icon, icon.duration * .67)
			end
		elseif info.talentData[381630] then
			local unit = UnitTokenFromGUID(destGUID)
			if unit then
				local hasGarroteDebuff = P:IsDebuffActive(unit, 703)
				if hasGarroteDebuff then
					P:UpdateCooldown(icon, icon.duration * .33)
				end
			end
		end
	end
end




registeredEvents['SPELL_AURA_REMOVED'][57934] = function(info, srcGUID, spellID, destGUID)
	local icon = info.spellIcons[spellID] or info.spellIcons[221622]
	if icon then
		local statusBar = icon.statusBar
		if statusBar then
			P:SetExStatusBarColor(icon, statusBar.key)
		end
		info.preactiveIcons[spellID] = nil
		icon.icon:SetVertexColor(1, 1, 1)
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
end

local function StartTricksCD(info, srcGUID, spellID, destGUID)
	local icon = info.spellIcons[57934]
	if icon and srcGUID == destGUID then
		local statusBar = icon.statusBar
		if statusBar then
			P:SetExStatusBarColor(icon, statusBar.key)
		end
		info.preactiveIcons[57934] = nil
		icon.icon:SetVertexColor(1, 1, 1)
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)

		P:StartCooldown(icon, icon.duration)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][59628] = StartTricksCD
registeredEvents['SPELL_AURA_APPLIED'][221630] = StartTricksCD


registeredEvents['SPELL_AURA_APPLIED'][375939] = function(info)
	info.auras.targetLastedSepsisFullDuration = true
end

registeredEvents['SPELL_AURA_REMOVED'][385408] = function(info)
	if not info.auras.targetLastedSepsisFullDuration then
		local icon = info.spellIcons[385408]
		if icon and icon.active then
			P:UpdateCooldown(icon, 30)
		end
	end
	info.auras.targetLastedSepsisFullDuration = nil
end


local ClearSerratedBoneSpikeTarget_OnDelayEnd = function(srcGUID, destGUID)
	if diedHostileGUIDS[destGUID] and diedHostileGUIDS[destGUID][srcGUID] and diedHostileGUIDS[destGUID][srcGUID][385424] then
		diedHostileGUIDS[destGUID][srcGUID][385424] = nil
	end
end

registeredEvents['SPELL_AURA_REMOVED'][394036] = function(info, srcGUID, _, destGUID)
	if info.spellIcons[385424] then
		local unit = UnitTokenFromGUID(destGUID)
		if abs(info.level - UnitLevel(unit)) >= 8 then
			diedHostileGUIDS[destGUID] = diedHostileGUIDS[destGUID] or {}
			diedHostileGUIDS[destGUID][srcGUID] = diedHostileGUIDS[destGUID][srcGUID] or {}
			diedHostileGUIDS[destGUID][srcGUID][385424] = true
			E.TimerAfter(0.05, ClearSerratedBoneSpikeTarget_OnDelayEnd, srcGUID, destGUID)
		end
	end
end


registeredEvents['SPELL_AURA_APPLIED'][392401] = function(info)
	info.auras["isImprovedGarrote"] = true
end

registeredEvents['SPELL_AURA_REMOVED'][392401] = function(info)
	info.auras["isImprovedGarrote"] = nil
end


local outlawRestlessBladesIDs = {
	13750,
	315341,
	13877,
	271877,
	343142,
	196937,
	195457,
	381989,
	51690,
	137619,
	315508,
	2983,
	1856,


	5277,
	1966,
}
local numOutlawRestlessBladesIDs = #outlawRestlessBladesIDs

local subtletyDeepeningShadowsIDs = {
	185313, 0.7,
	280719, 1.0,
}

local function ConsumedComboPoints(info, _, spellID)
	local numCP
	local animacharge = info.auras.consumedAnimacharge
	local isKidnyShot = spellID == 408
	if isKidnyShot then
		numCP = 5
	elseif animacharge then
		numCP = 7
	else
		numCP = info.talentData[193531] and 6 or 5
	end
	if info.spec == 260 then
		if not isKidnyShot and not animacharge and info.talentData[394321] then
			numCP = numCP + 1
		end
		if info.auras.isTrueBearing then
			numCP = numCP * 1.5
		end
		local n = info.talentData[354897] and numOutlawRestlessBladesIDs or numOutlawRestlessBladesIDs - 2
		for i = 1, n do
			local id = outlawRestlessBladesIDs[i]
			local icon = info.spellIcons[id]
			if icon and icon.active then
				P:UpdateCooldown(icon, numCP)
			end
		end
	else
		if not isKidnyShot and not animacharge and info.talentData[394320] then
			numCP = numCP + 1
		end
		for i = 1, 4, 2 do
			local id = subtletyDeepeningShadowsIDs[i]
			local reducedTime = subtletyDeepeningShadowsIDs[i + 1] * numCP
			local icon = info.spellIcons[id]
			if icon and icon.active and (spellID ~= 280719 or spellID ~= id) then
				P:UpdateCooldown(icon, reducedTime)
			end
		end
	end
end

local comboPointSpenders = {

	315496,
	408,
	315341,
	2098,
	319175,
	196819,
	1943,
	280719,
}

for _, id in pairs(comboPointSpenders) do
	if id == 196819 or id == 2098 then
		registeredEvents['SPELL_DAMAGE'][id] = ConsumedComboPoints
	else
		registeredEvents['SPELL_CAST_SUCCESS'][id] = ConsumedComboPoints
	end
end


local RemoveEchoingRepromand_OnDelayEnd = function(srcGUID)
	local info = groupInfo[srcGUID]
	if info then
		info.auras.consumedAnimacharge = nil
	end
end

local function RemoveEchoingRepromand(info, srcGUID)
	info.auras.consumedAnimacharge = true
	E.TimerAfter(0.05, RemoveEchoingRepromand_OnDelayEnd, srcGUID)
end

registeredEvents['SPELL_AURA_REMOVED'][323558] = RemoveEchoingRepromand
registeredEvents['SPELL_AURA_REMOVED'][323559] = RemoveEchoingRepromand
registeredEvents['SPELL_AURA_REMOVED'][323560] = RemoveEchoingRepromand
registeredEvents['SPELL_AURA_REMOVED'][354838] = RemoveEchoingRepromand


registeredEvents['SPELL_AURA_REMOVED'][193359] = function(info)
	info.auras.isTrueBearing = nil
end

registeredEvents['SPELL_AURA_APPLIED'][193359] = function(info)
	info.auras.isTrueBearing = true
end


registeredEvents['SPELL_ENERGIZE'][196911] = function(info)
	if info.talentData[382509] then
		local icon = info.spellIcons[121471]
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
		return
	end
	local conduitValue = P.isInShadowlands and info.talentData[341559]
	if conduitValue then
		local icon = info.spellIcons[121471]
		if icon and icon.active then
			P:UpdateCooldown(icon, conduitValue * 0.5)
		end
	end
end


registeredEvents['SPELL_INTERRUPT'][1766] = function(info, _, spellID, _,_,_, extraSpellId, extraSpellName, _,_, destRaidFlags)
	local conduitValue = P.isInShadowlands and info.talentData[341535]
	if conduitValue then
		local icon = info.spellIcons[spellID]
		if icon and icon.active then
			P:UpdateCooldown(icon, conduitValue)
		end
	end
	AppendInterruptExtras(info, nil, spellID, nil,nil,nil, extraSpellId, extraSpellName, nil,nil, destRaidFlags)
end

local function ReduceEvasionCD(destInfo, _,_, missType, _,_, timestamp)
	if P.isInShadowlands and missType == "DODGE" then
		local conduitValue = destInfo.talentData[341535]
		if conduitValue then
			local icon = destInfo.spellIcons[5277]
			if icon and icon.active then
				if timestamp > (destInfo.auras.time_dodged or 0) then
					P:UpdateCooldown(icon, conduitValue)
					destInfo.auras.time_dodged = timestamp + 1
				end
			end
		end
	end
end

registeredHostileEvents['SWING_MISSED'].ROGUE = function(destInfo, _, spellID, _,_,_, timestamp) ReduceEvasionCD(destInfo,nil,nil,spellID,nil,nil,timestamp) end
registeredHostileEvents['RANGE_MISSED'].ROGUE = ReduceEvasionCD
registeredHostileEvents['SPELL_MISSED'].ROGUE = ReduceEvasionCD


registeredEvents['SPELL_AURA_REMOVED'][384631] = function(info, srcGUID, spellID, destGUID)
	if info.auras.isFlagellation then
		info.auras.isFlagellation = nil
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][384631] = function(info)
	if P.isInShadowlands and info.talentData[354703] and info.spellIcons[384631] then
		info.auras.isFlagellation = true
	end
end










registeredEvents['SPELL_CAST_SUCCESS'][21169] = function(info)
	local icon = info.spellIcons[20608]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end


registeredEvents['SPELL_SUMMON'][192058] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[265046] then
		local icon = info.spellIcons[spellID]
		if icon then
			local capGUID = info.auras.capTotemGUID
			if capGUID then
				totemGUIDS[capGUID] = nil
			end
			totemGUIDS[destGUID] = srcGUID
			info.auras.capTotemGUID = destGUID
		end
	end
end



registeredEvents['SPELL_HEAL'][31616] = function(info)
	local icon = info.spellIcons[30884]
	if icon then
		P:StartCooldown(icon, icon.duration)
	end
end



local FERAL_SPIRIT, WITCH_DOCTORS_ANCESTRY = 51533, 384447

local function ReduceFeralSpiritCD(info, count)
	local talentRank = info.talentData[WITCH_DOCTORS_ANCESTRY]
	if talentRank then
		local icon = info.spellIcons[FERAL_SPIRIT]
		if icon and icon.active then
			P:UpdateCooldown(icon, count and count * talentRank or talentRank)
		end
	elseif P.isInShadowlands and info.talentData[335897] then
		local icon = info.spellIcons[FERAL_SPIRIT]
		if icon and icon.active then
			P:UpdateCooldown(icon, count and count * 2 or 2)
		end
	end
end

registeredEvents['SPELL_AURA_REMOVED_DOSE'][344179] = function(info, _,_,_,_,_,_, amount)
	if info.auras.trackMaelstrom then
		info.auras.maelstromWeaponStacks = amount
	end
end

registeredEvents['SPELL_AURA_REMOVED'][344179] = function(info)
	if info.auras.trackMaelstrom then
		info.auras.maelstromWeaponStacks = 0
	end
end

registeredEvents['SPELL_AURA_APPLIED_DOSE'][344179] = function(info, _,_,_,_,_,_, amount)
	if info.auras.trackMaelstrom then
		local prevAmount = info.auras.maelstromWeaponStacks or amount - 1
		local count = prevAmount > amount and amount - 1 or amount - prevAmount
		ReduceFeralSpiritCD(info, count)
		info.auras.maelstromWeaponStacks = amount
	end
end

registeredEvents['SPELL_AURA_APPLIED'][344179] = function(info)
	if info.auras.trackMaelstrom then
		info.auras.maelstromWeaponStacks = 1
		ReduceFeralSpiritCD(info)
	end
end

registeredEvents['SPELL_AURA_REFRESH'][344179] = function(info)
	if info.auras.trackMaelstrom then
		if info.auras.maelstromWeaponStacks == 10 then
			info.auras.maelstromWeaponStacks = 11
		elseif info.auras.maelstromWeaponStacks == 11 then
			ReduceFeralSpiritCD(info)
		end
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][FERAL_SPIRIT] = function(info)
	if (info.talentData[WITCH_DOCTORS_ANCESTRY] or info.talentData[335897]) and info.spellIcons[FERAL_SPIRIT] then
		info.auras.trackMaelstrom = true
	end
end


local FLAME_SHOCK = 188389
local SKYBREAKERS_FIERY_DEMISE = 378310
local FIRE_ELEMENTAL, STORM_ELEMENTAL = 198067, 192249

registeredEvents['SPELL_PERIODIC_DAMAGE'][FLAME_SHOCK] = function(info, _,_,_, critical)
	if critical then
		if info.talentData[SKYBREAKERS_FIERY_DEMISE] then
			local icon = info.spellIcons[FIRE_ELEMENTAL] or info.spellIcons[STORM_ELEMENTAL]
			if icon and icon.active then
				P:UpdateCooldown(icon, 1)
			end
		elseif P.isInShadowlands and info.talentData[336734] then
			local icon = info.spellIcons[FIRE_ELEMENTAL] or info.spellIcons[STORM_ELEMENTAL]
			if icon and icon.active then
				P:UpdateCooldown(icon, 1)
			end
		end
		if info.talentData[356250] then
			local icon = info.spellIcons[320674]
			if icon and icon.active then
				P:UpdateCooldown(icon, 1)
			end
		end
	end
end


registeredEvents['SPELL_DAMAGE'][FLAME_SHOCK] = function(info, _,_,_, critical)
	if critical and info.talentData[356250] then
		local icon = info.spellIcons[320674]
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
	end
end


local function ReducedChainHarvestCD(info, _,_,_, critical)
	if critical then
		local icon = info.spellIcons[320674]
		if icon then
			if icon.active then
				P:UpdateCooldown(icon, 5)
			else
				C_Timer_After(.05, function() P:UpdateCooldown(icon, 5) end)
			end
		end
	end
end

registeredEvents['SPELL_DAMAGE'][320752] = ReducedChainHarvestCD
registeredEvents['SPELL_HEAL'][320751] = ReducedChainHarvestCD


local RemoveSurgeOfPower_OnDelayEnd = function(srcGUID)
	local info = groupInfo[srcGUID]
	if info then
		info.auras.isSurgeOfPower = nil
	end
end

registeredEvents['SPELL_AURA_REMOVED'][285514] = function(info, srcGUID)
	if info.spellIcons[FIRE_ELEMENTAL] or info.spellIcons[STORM_ELEMENTAL] then
		E.TimerAfter(0.05, RemoveSurgeOfPower_OnDelayEnd, srcGUID)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][285514] = function(info)
	if info.spellIcons[FIRE_ELEMENTAL] or info.spellIcons[STORM_ELEMENTAL] then
		info.auras.isSurgeOfPower = true
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][51505] = function(info)
	if info.auras.isSurgeOfPower then
		local icon = info.spellIcons[FIRE_ELEMENTAL] or info.spellIcons[STORM_ELEMENTAL]
		if icon and icon.active then
			P:UpdateCooldown(icon, 6)
		end
		info.auras.isSurgeOfPower = nil
	end
end


local function ReducePrimordialWaveCD(info)
	local talentRank = info.talentData[386443]
	if talentRank then
		local icon = info.spellIcons[375982]
		if icon and icon.active then
			P:UpdateCooldown(icon, talentRank == 2 and 1 or .5)
		end
	end
end

registeredEvents['SPELL_DAMAGE'][285452] = ReducePrimordialWaveCD
registeredEvents['SPELL_DAMAGE'][285466] = ReducePrimordialWaveCD


registeredEvents['SPELL_AURA_APPLIED'][382041] = function(info)
	local icon = info.spellIcons[375982]
	if icon and icon.active then
		P:ResetCooldown(icon)
	end
end


local elementalShamanNatureAbilities = {
	5394,
	383013,
	383017,
	383019,
	192077,
	192058,
	355580,
	204331,
	204336,
	2484,
	8143,
	57994,
	191634,
	51490,
	108271,
	2825,
	51514,
	356736,
	79206,
	378773,
	305483,
	108281,
	198103,
	192063,
	108287,
	108285,
}
local numElementalShamanNatureAbilities = #elementalShamanNatureAbilities

local function ReduceNatureAbilitiesCD(info)
	if info.talentData[381936] then
		for i = 1, numElementalShamanNatureAbilities do
			local id = elementalShamanNatureAbilities[i]
			local icon = info.spellIcons[id]
			if icon and icon.active then
				P:UpdateCooldown(icon, 1)
			end
		end
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][188196] = ReduceNatureAbilitiesCD
registeredEvents['SPELL_CAST_SUCCESS'][188443] = ReduceNatureAbilitiesCD



local shamanTotems = {
	5394,
	383013,
	383017,
	383019,
	204330,
	192222,
	157153,
	198838,
	51485,
	192077,
	192058,
	355580,
	204331,
	204336,
	2484,
	8143,
	--[[

	16191,
	108280,
	98008,

	207399,

	8512,
	]]

}

local function CacheLastTotemUsed(info, _, spellID)
	if info.talentData[108285] then
		info.auras.lastTotemUsed = info.auras.lastTotemUsed or {}
		if info.auras.lastTotemUsed[1] ~= spellID then
			tinsert(info.auras.lastTotemUsed, 1, spellID)
			for i = 3, #info.auras.lastTotemUsed do
				info.auras.lastTotemUsed[i] = nil
			end
		end
	end
end

for _, id in pairs(shamanTotems) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = CacheLastTotemUsed
end

registeredEvents['SPELL_CAST_SUCCESS'][108285] = function(info)
	local lastTotemUsed = info.auras.lastTotemUsed
	if lastTotemUsed then
		for i = 1, info.talentData[383012] and 2 or 1 do
			local id = lastTotemUsed[i]
			local icon = info.spellIcons[id]
			if icon and icon.active then
				P:ResetCooldown(icon)
			end
		end
	end
end



registeredEvents['SPELL_AURA_APPLIED'][53390] = function(info)
	if info.talentData[382030] then
		info.auras.isTidalWave = true
	end
end

registeredEvents['SPELL_AURA_REMOVED'][53390] = function(info)
	info.auras.isTidalWave = nil
end

local tidalWavesTotems = {
	383013,
	157153,
	5394,
	16191,
	108280,
	381930,
}

local function ReduceTidalWaveTotemCD(info)
	if info.auras.isTidalWave then
		for i = 1, 6 do
			local id = tidalWavesTotems[i]
			local icon = info.spellIcons[id]
			if icon and icon.active then
				P:UpdateCooldown(icon, .5)
			end
		end
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][77472] = ReduceTidalWaveTotemCD
registeredEvents['SPELL_CAST_SUCCESS'][1064] = ReduceTidalWaveTotemCD
registeredEvents['SPELL_CAST_SUCCESS'][8004] = ReduceTidalWaveTotemCD


registeredEvents['SPELL_AURA_APPLIED'][358945] = function(info)
	if info.spec == 262 then
		local icon = info.spellIcons[198067] or info.spellIcons[192249]
		if icon and icon.active then
			P:UpdateCooldown(icon, 6)
		end
	elseif info.spec == 263 then
		local icon = info.spellIcons[51533]
		if icon and icon.active then
			P:UpdateCooldown(icon, 9)
		end
	elseif info.spec == 264 then
		local icon = info.spellIcons[108280]
		if icon and icon.active then
			P:UpdateCooldown(icon, 5)
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED_DOSE'][358945] = registeredEvents['SPELL_AURA_APPLIED'][358945]






local function ReduceUnendingResolveCD(destInfo, destName, _, amount, _,_, timestamp)
	local talentRank = destInfo.talentData[389359]
	if talentRank then
		local icon = destInfo.spellIcons[104773]
		if icon and icon.active then
			if timestamp > (destInfo.auras.time_resolutebarrier or 0) then
				local maxHP = UnitHealthMax(destName)
				if maxHP > 0 and (amount / maxHP) > 0.05 then
					P:UpdateCooldown(icon, 10)
					destInfo.auras.time_resolutebarrier = timestamp + 30 - (5 * talentRank)
				end
			end
		end
		return
	end
	local conduitValue = P.isInShadowlands and destInfo.talentData[339272]
	if conduitValue then
		local icon = destInfo.spellIcons[104773]
		if icon and icon.active then
			if timestamp > (destInfo.auras.time_resolutebarrier or 0) then
				local maxHP = UnitHealthMax(destName)
				if maxHP > 0 and (amount / maxHP) > 0.05 then
					P:UpdateCooldown(icon, 10)
					destInfo.auras.time_resolutebarrier = timestamp + 30 - conduitValue
				end
			end
		end
	end
end

registeredHostileEvents['SWING_DAMAGE'].WARLOCK = function(destInfo, destName, spellID, _,_,_, timestamp) ReduceUnendingResolveCD(destInfo,destName,nil,spellID,nil,nil,timestamp) end
registeredHostileEvents['RANGE_DAMAGE'].WARLOCK = ReduceUnendingResolveCD
registeredHostileEvents['SPELL_DAMAGE'].WARLOCK = ReduceUnendingResolveCD


local function ReduceSoulRotCD(info)
	local talentRank = info.talentData[389630]
	if talentRank then
		local icon = info.spellIcons[386997]
		if icon and icon.active then
			P:UpdateCooldown(icon, .5 * talentRank)
		end
	end
end

registeredEvents['SPELL_PERIODIC_DAMAGE'][316099] = ReduceSoulRotCD
registeredEvents['SPELL_PERIODIC_DAMAGE'][342938] = ReduceSoulRotCD


local function ReduceSoulFireCD(info, _,_, destGUID)
	if info.talentData[387176] then
		local icon = info.spellIcons[6353]
		if icon and icon.active then
			local unit = UnitTokenFromGUID(destGUID)
			if unit then
				local currHP = UnitHealth(unit)
				if currHP > 0 and currHP /  UnitHealthMax(unit) <= .5 then
					P:UpdateCooldown(icon, 5)
				end
			end
		end
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][29722] = ReduceSoulFireCD
registeredEvents['SPELL_CAST_SUCCESS'][17962] = ReduceSoulFireCD


local soulShardSpenders = {

	[385899] = 1,
	[688] = 1,
	[697] = 1,
	[691] = 1,
	[712] = 1,
	[324536] = 1,
	[27243] = 1,
	[278350] = 1,
	[386951] = 1,
	[264106] = 3,
	[344566] = 3,
	[30146] = 1,
	[104316] = 2,
	[111898] = 1,
	[105174] = 3,
	[267217] = 1,
	[264119] = 1,
	[267211] = 2,
	[212459] = 2,
	[5740] = 3,
	[116858] = 2,
	[17877] = 1,
}

local function ReduceWarlockMajorCD(info, _, spellID)
	if not info.talentData[387084] then return end
	local isRitualOfRuinID = spellID == 5740 or spellID == 116858
	if isRitualOfRuinID and info.auras["RitualOfRuin"] then return end
	if spellID == 324536 and info.auras["TormentedCrescendo"] then return end
	local targetID, rCD
	if info.spec == 265 then
		targetID, rCD = 205180, 1
	elseif info.spec == 266 then
		targetID, rCD = 265187, .6
	else
		targetID, rCD = 1122, 1.5
	end
	local icon = info.spellIcons[targetID]
	if icon and icon.active then
		local usedShards = soulShardSpenders[spellID]
		if isRitualOfRuinID or spellID == 17877 then
			if info.auras["CrashingChaos"] then
				usedShards = usedShards - 1
			end
		end
		if usedShards > 0 then
			P:UpdateCooldown(icon, usedShards * rCD)
		end
	end
end

for id in pairs(soulShardSpenders) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = ReduceWarlockMajorCD
end


--[[ CDTS
local function ClearSrcShadowBurn_OnDurationEnd(srcGUID, spellID, destGUID)
	if diedHostileGUIDS[destGUID] and diedHostileGUIDS[destGUID][srcGUID] and diedHostileGUIDS[destGUID][srcGUID][spellID] then
		diedHostileGUIDS[destGUID][srcGUID][spellID] = nil
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][17877] = function(info, srcGUID, spellID, destGUID)
	if info.spellIcons[spellID] then
		local unit = UnitTokenFromGUID(destGUID)
		if abs(info.level - UnitLevel(unit)) >= 8 then
			diedHostileGUIDS[destGUID] = diedHostileGUIDS[destGUID] or {}
			diedHostileGUIDS[destGUID][srcGUID] = diedHostileGUIDS[destGUID][srcGUID] or {}
			if diedHostileGUIDS[destGUID][srcGUID][spellID] then
				diedHostileGUIDS[destGUID][srcGUID][spellID]:Cancel()
			end
			diedHostileGUIDS[destGUID][srcGUID][spellID] = E.TimerAfter(5, ClearSrcShadowBurn_OnDurationEnd, srcGUID, spellID, destGUID)
		end
	end
	ReduceWarlockMajorCD(info, nil, spellID))
end
]]


registeredEvents['SPELL_ENERGIZE'][312379] = function(info)
	info.auras.isScouringTitheKilled = true
end

local ResetScouringTitheCD_OnDelayEnd = function(srcGUID, spellID)
	local info = groupInfo[srcGUID]
	if info then
		if info.auras.isScouringTitheKilled then
			info.auras.isScouringTitheKilled = nil
		else
			local icon = info.spellIcons[spellID]
			if icon and icon.active then
				P:ResetCooldown(icon)
			end
		end
	end
end


registeredEvents['SPELL_AURA_REMOVED'][312321] = function(info, srcGUID, spellID)
	local icon = info.spellIcons[spellID]
	if icon then
		E.TimerAfter(0.5, ResetScouringTitheCD_OnDelayEnd, srcGUID, spellID)
	end
end






registeredEvents['SPELL_AURA_REMOVED'][107574] = function(info, srcGUID, spellID, destGUID)
	info.auras["isAvatar"] = nil
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][107574] = function(info)
	local icon = info.spellIcons[6343]
	if icon then
		info.auras["isAvatar"] = true
	end
end


registeredEvents['SPELL_AURA_APPLIED'][32216] = function(info)
	local icon = info.spellIcons[202168]
	if icon and icon.active then
		P:ResetCooldown(icon)
		info.auras["hasVictorious"] = true
	end
end














local rageSpenders = {
	[184367] = { 4.0, { 1719 } },

	[280735] = { 2.0, { 1719 }, { 316402, 0 } },
	[12294]	 = { 1.5, { 262161, 167105, 227847 }, nil, { "hasBattlelord", -0.5} },
	[845]	 = { 1.0, { 262161, 167105, 227847 }, nil, { "hasBattlelord", -0.5} },
	[772]	 = { 1.5, { 262161, 167105, 227847 }  },
	[396719] = { 1.5, { 262161, 167105, 227847, 1719 }, { 384277, .5} },
	[394062] = { 3.0, { 107574, 871 } },
	[190456] = { 3.5, { 107574, 871 } },
	[6572]	 = { 2.0, { 107574, 871}, { 390675, 1 }, { "hasRevenge", 0 } },
	[1680]	 = { { [73]=3, ["d"]=2.0 }, { 262161, 167105, 227847, 107574, 871 }, { 385512, 1.5, 383082, .001 }	},
	[163201] = { { [73]=4, ["d"]=2.0 }, { 262161, 167105, 227847, 107574, 871 }, nil, { "SuddenDeath", 0 } },
	[281000] = { { [73]=4, ["d"]=2.0 }, { 262161, 167105, 227847, 107574, 871 }, nil, { "SuddenDeath", 0 } },
	[1464]	 = { { [73]=2, ["d"]=1.0 }, { 262161, 167105, 227847, 107574, 871, 1719 }, { 383082, .5 } },
	[2565]	 = { { [73]=3, ["d"]=1.5 }, { 262161, 167105, 227847, 107574, 871, 1719 } },
	[202168] = { { [73]=1, ["d"]=0.5 }, { 262161, 167105, 227847, 107574, 871, 1719 }, nil, { "hasVictorious", 0 } },
	[1715]	 = { { [73]=1, ["d"]=0.5 }, { 262161, 167105, 227847, 107574, 871, 1719 } },
}

for id, t in pairs(rageSpenders) do
	registeredEvents['SPELL_CAST_SUCCESS'][id] = function(info)
		if not info.talentData[152278] then return end
		local duration, target, modif, aura = t[1], t[2], t[3], t[4]
		local rCD = aura and info.auras[ aura[1] ] and aura[2]
		if rCD == 0 then return end
		rCD = (type(duration) == "table" and (duration[info.spec] or duration.d) or duration) + (rCD or 0)
		if modif then
			for i = 1, #modif, 2 do
				local tal, rrCD = modif[i], modif[i+1]
				if info.talentData[tal] then
					if rrCD == 0 then return end
					rCD = rCD + rrCD
				end
			end
		end
		for _, spellID in pairs(target) do
			if spellID ~= 107574 or info.spec == 73 then
				local icon = info.spellIcons[spellID]
				if icon and icon.active then
					P:UpdateCooldown(icon, rCD)
				end
			end
		end
	end
end


registeredEvents['SPELL_DAMAGE'][46968] = function(info)
	if info.talentData[275339] then
		local active = info.active[46968]
		if active then
			active.numHits = (active.numHits or 0) + 1
			if active.numHits == 3 then
				local icon = info.spellIcons[46968]
				if icon and icon.active then
					P:UpdateCooldown(icon, 15)
				end
			end
		end
	end
end


registeredEvents['SPELL_DAMAGE'][6343] = function(info)
	if info.talentData[385840] then
		local active = info.active[1160]
		if active then
			active.numHits = (active.numHits or 0) + 1
			if active.numHits <= 3 then
				local icon = info.spellIcons[1160]
				if icon and icon.active then
					P:UpdateCooldown(icon, 1)
				end
			end
		end
	elseif P.isInShadowlands and info.talentData[335229] then
		local active = info.active[1160]
		if active then
			active.numHits = (active.numHits or 0) + 1
			if active.numHits <= 3 then
				local icon = info.spellIcons[1160]
				if icon and icon.active then
					P:UpdateCooldown(icon, 1.5)
				end
			end
		end
	end
end

registeredEvents['SPELL_CAST_SUCCESS'][6343] = function(info)
	if info.talentData[385840] then
		local active = info.active[1160]
		if active then
			active.numHits = 0
		end
	end
end











local function UpdateCDRR(info, modRate, excludeID, forceTbl)
	local newRate = (info.modRate or 1) * modRate
	local now = GetTime()
	for spellID, active in pairs(info.active) do
		local icon = info.spellIcons[spellID]
		if icon and icon.active and (BOOKTYPE_CATEGORY[icon.category] and spellID ~= excludeID or (forceTbl and forceTbl[spellID])) then
			local elapsed = (now - active.startTime) * modRate
			local newTime = now - elapsed
			local newCd = (active.duration * modRate)
			local iconModRate
			local rr = info.spellModRates[spellID]
			if rr then
				iconModRate = newRate * rr
			else
				iconModRate = newRate
			end
			icon.cooldown:SetCooldown(newTime, newCd, iconModRate)
			active.startTime = newTime
			active.duration = newCd
			active.iconModRate = abs(1 - iconModRate) >= 0.05 and iconModRate or nil
			local statusBar = icon.statusBar
			if statusBar then
				P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and 'UNIT_SPELLCAST_CHANNEL_UPDATE' or 'UNIT_SPELLCAST_CAST_UPDATE')
			end
		end
	end
	info.modRate = newRate
end
P.UpdateCDRR = UpdateCDRR

local function UpdateSpellRR(info, modulatedID, modRate)
	local icon = info.spellIcons[modulatedID]
	if icon then
		local newRate = (info.spellModRates[modulatedID] or 1) * modRate
		local active = icon.active and info.active[modulatedID]
		if active then
			local iconModRate = newRate * (info.modRate or 1)
			iconModRate = abs(1 - iconModRate) >= 0.05 and iconModRate or nil
			local now = GetTime()
			local elapsed = (now - active.startTime) * modRate
			local newTime = now - elapsed
			local newCd = active.duration * modRate
			icon.cooldown:SetCooldown(newTime, newCd, iconModRate)
			active.startTime = newTime
			active.duration = newCd
			active.iconModRate = iconModRate
			local statusBar = icon.statusBar
			if statusBar then
				P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, E.db.extraBars[statusBar.key].reverseFill and 'UNIT_SPELLCAST_CHANNEL_UPDATE' or 'UNIT_SPELLCAST_CAST_UPDATE')
			end
		end
		info.spellModRates[modulatedID] = newRate
	end
end







registeredEvents['SPELL_AURA_REMOVED'][329042] = function(info, srcGUID, spellID, destGUID)
	if info.callbackTimers[spellID] then
		UpdateCDRR(info, 5, spellID)
		info.callbackTimers[spellID] = nil
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][329042] = function(info, srcGUID, spellID, destGUID)
	if srcGUID == destGUID then


		local icon = info.spellIcons[spellID]
		if icon then
			P:StartCooldown(icon, icon.duration)
		end
		info.callbackTimers[spellID] = true
		UpdateCDRR(info, 0.2, spellID)
	end
end



local spaghettiFix = { [368970]=true, [357214]=true, }
E.spaghettiFix = spaghettiFix

local OnFlowStateTimerEnd
OnFlowStateTimerEnd = function(srcGUID, spellID)
	local info = groupInfo[srcGUID]
	if info and info.callbackTimers[spellID] then
		local duration = P:GetBuffDuration(info.unit, spellID)
		if duration then
			info.callbackTimers[spellID] = E.TimerAfter(duration + 0.1, OnFlowStateTimerEnd, srcGUID, spellID)
			return
		end
		UpdateCDRR(info, info.auras.flowStateRankValue, 370960, spaghettiFix)
		info.auras.flowStateRankValue = nil
		info.callbackTimers[spellID] = nil
	end
end

registeredEvents['SPELL_AURA_REMOVED'][390148] = function(info, srcGUID, spellID)
	if info.callbackTimers[spellID] then
		if srcGUID ~= userGUID then
			info.callbackTimers[spellID]:Cancel()
		end
		UpdateCDRR(info, info.auras.flowStateRankValue, 370960, spaghettiFix)
		info.callbackTimers[spellID] = nil
		info.auras.flowStateRankValue = nil
	end
end

registeredEvents['SPELL_AURA_REFRESH'][390148] = function(info, srcGUID, spellID)
	if info.callbackTimers[spellID] and srcGUID ~= userGUID then
		info.callbackTimers[spellID]:Cancel()
		info.callbackTimers[spellID] = E.TimerAfter(10.1, OnFlowStateTimerEnd, srcGUID, spellID)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][390148] = function(info, srcGUID, spellID)
	if not info.auras.flowStateRankValue then
		local talentValue = info.talentData[385696] == 2 and 1.1 or 1.05
		info.auras.flowStateRankValue = talentValue
		info.callbackTimers[spellID] = srcGUID == userGUID or E.TimerAfter(10.1, OnFlowStateTimerEnd, srcGUID, spellID)
		UpdateCDRR(info, 1/talentValue, 370960, spaghettiFix)
	end
end


registeredEvents['SPELL_AURA_REMOVED'][378441] = function(_, srcGUID, spellID, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		if destInfo.callbackTimers[spellID] then
			if destGUID ~= userGUID then
				destInfo.callbackTimers[spellID]:Cancel()
			end
			destInfo.callbackTimers[spellID] = nil
			UpdateCDRR(destInfo, .01, spellID, spaghettiFix)
		end
		RemoveHighlightByCLEU(destInfo, srcGUID, spellID, destGUID)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][378441] = function(_, srcGUID, spellID, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		if srcGUID == destGUID then
			local icon = destInfo.spellIcons[spellID]
			if icon then
				P:StartCooldown(icon, icon.duration)
			end
		end
		destInfo.callbackTimers[spellID] = destGUID == userGUID or E.TimerAfter(4.1, registeredEvents['SPELL_AURA_REMOVED'][spellID], nil, srcGUID, spellID, destGUID)
		UpdateCDRR(destInfo, 100, spellID, spaghettiFix)
	end
end

registeredUserEvents['SPELL_AURA_REMOVED'][378441] = registeredEvents['SPELL_AURA_REMOVED'][378441]
registeredUserEvents['SPELL_AURA_APPLIED'][378441] = registeredEvents['SPELL_AURA_APPLIED'][378441]


registeredEvents['SPELL_AURA_REMOVED'][388010] = function(_, srcGUID, spellID, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		if destInfo.callbackTimers[spellID] then
			if destGUID ~= userGUID then
				destInfo.callbackTimers[spellID]:Cancel()
			end
			destInfo.callbackTimers[spellID] = nil
			UpdateCDRR(destInfo, 1.3)
		end
		RemoveHighlightByCLEU(destInfo, srcGUID, spellID, destGUID)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][388010] = function(_, srcGUID, spellID, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		destInfo.callbackTimers[spellID] = destGUID == userGUID or E.TimerAfter(30.5, registeredEvents['SPELL_AURA_REMOVED'][388010], nil, srcGUID, spellID, destGUID)
		UpdateCDRR(destInfo, 1/1.3)
	end
end

registeredUserEvents['SPELL_AURA_REMOVED'][388010] = registeredEvents['SPELL_AURA_REMOVED'][388010]
registeredUserEvents['SPELL_AURA_APPLIED'][388010] = registeredEvents['SPELL_AURA_APPLIED'][388010]


registeredEvents['SPELL_AURA_REMOVED'][355567] = function(_,_, spellID, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo and destInfo.callbackTimers[spellID] then
		if destGUID ~= userGUID then
			destInfo.callbackTimers[spellID]:Cancel()
		end
		UpdateCDRR(destInfo, 1/1.3)
		destInfo.callbackTimers[spellID] = nil
	end
end

registeredEvents['SPELL_AURA_APPLIED'][355567] = function(_,_, spellID, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo and destInfo.callbackTimers[388010] then
		UpdateCDRR(destInfo, 1/1.3)
		destInfo.callbackTimers[spellID] = destGUID == userGUID or E.TimerAfter(10.1, registeredEvents['SPELL_AURA_REMOVED'][355567], nil, nil, spellID, destGUID)
	end
end

registeredUserEvents['SPELL_AURA_REMOVED'][355567] = registeredEvents['SPELL_AURA_REMOVED'][355567]
registeredUserEvents['SPELL_AURA_APPLIED'][355567] = registeredEvents['SPELL_AURA_APPLIED'][355567]


registeredEvents['SPELL_AURA_REMOVED'][204366] = function(_, srcGUID, spellID, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		if destInfo.callbackTimers[spellID] then
			if type(destInfo.callbackTimers[spellID]) == "table" then
				destInfo.callbackTimers[spellID]:Cancel()
			end
			destInfo.callbackTimers[spellID] = nil
			UpdateCDRR(destInfo, destInfo.auras.isThunderChargeCastedOnSelf and 1.69 or 1.3)
		end
		RemoveHighlightByCLEU(destInfo, srcGUID, spellID, destGUID)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][204366] = function(info, srcGUID, spellID, destGUID)
	if srcGUID == destGUID then
		info.auras.isThunderChargeCastedOnSelf = true
		info.callbackTimers[spellID] = destGUID == userGUID or E.TimerAfter(10.5, registeredEvents['SPELL_AURA_REMOVED'][204366], nil, srcGUID, spellID, destGUID)
		UpdateCDRR(info, 1/1.69)
	else
		local destInfo = groupInfo[destGUID]
		if destInfo then
			destInfo.callbackTimers[spellID] = E.TimerAfter(10.5, registeredEvents['SPELL_AURA_REMOVED'][204366], nil, srcGUID, spellID, destGUID)
			UpdateCDRR(destInfo, 1/1.3)
		end
		if info then
			info.callbackTimers[spellID] = destGUID == userGUID or E.TimerAfter(10.5, registeredEvents['SPELL_AURA_REMOVED'][204366], nil, srcGUID, spellID, destGUID)
			UpdateCDRR(info, 1/1.3)
		end
		info.auras.isThunderChargeCastedOnSelf = nil
	end
end

registeredUserEvents['SPELL_AURA_REMOVED'][204366] = registeredEvents['SPELL_AURA_REMOVED'][204366]
registeredUserEvents['SPELL_AURA_APPLIED'][204366] = registeredEvents['SPELL_AURA_APPLIED'][204366]


registeredEvents['SPELL_AURA_REMOVED'][368937] = function(info, srcGUID, spellID, destGUID)
	info = info or groupInfo[srcGUID]
	if info.callbackTimers[spellID] then
		if destGUID ~= userGUID then
			info.callbackTimers[spellID]:Cancel()
		end
		UpdateCDRR(info, 1.05, spellID)
		info.callbackTimers[spellID] = nil
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][368937] = function(info, srcGUID, spellID, destGUID)
	info.callbackTimers[spellID] = destGUID == userGUID or E.TimerAfter(30.5, registeredEvents['SPELL_AURA_REMOVED'][368937], nil, srcGUID, spellID, destGUID)
	UpdateCDRR(info, 1/1.05, spellID)
end



local function OnUrhTimerEnd(destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo and destInfo.callbackTimers[368239] then
		local duration = P:GetDebuffDuration(destInfo.unit, 368239)
		if duration then
			destInfo.callbackTimers[368239] = E.TimerAfter(duration + 0.5, destGUID)
			return
		end
		UpdateCDRR(destInfo, 3)
		destInfo.callbackTimers[368239] = nil
	end
end

registeredHostileEvents['SPELL_AURA_REMOVED'][368239] = function(destInfo, _,_,_,_, destGUID)
	if destInfo and destInfo.callbackTimers[368239] then
		if destGUID ~= userGUID then
			destInfo.callbackTimers[368239]:Cancel()
		end
		UpdateCDRR(destInfo, 3)
		destInfo.callbackTimers[368239] = nil
	end
end

registeredHostileEvents['SPELL_AURA_APPLIED'][368239] = function(destInfo, _,_,_,_, destGUID)
	if not destInfo.callbackTimers[368239] then
		destInfo.callbackTimers[368239] = destGUID == userGUID or E.TimerAfter(10.5, OnUrhTimerEnd, destGUID)
		UpdateCDRR(destInfo, 1/3)
	end
end






--[[
local movementEnhancers = {}
registeredEvents['SPELL_AURA_REMOVED'][233397] = function(info) end
registeredEvents['SPELL_AURA_APPLIED'][233397] = function(info) end
]]


local serenityTargetIDs = {
	113656,
	392983,

}

registeredEvents['SPELL_AURA_REMOVED'][152173] = function(info, srcGUID, spellID, destGUID)
	for i = 1, 2 do
		local id = serenityTargetIDs[i]
		local rr = info.spellModRates[id]
		if rr then
			UpdateSpellRR(info, id, 2)
		end
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	info.auras.isSerenity = nil
end

registeredEvents['SPELL_AURA_APPLIED'][152173] = function(info)
	for i = 1, 2 do
		local id = serenityTargetIDs[i]
		UpdateSpellRR(info, id, .5)
	end
	info.auras.isSerenity = true
end


local mageBarriers = {
	11426,
	235450,
	235313,
}

for _, id in pairs(mageBarriers) do
	registeredEvents['SPELL_AURA_REMOVED'][id] = function(info, srcGUID, spellID, destGUID)
		local rr = info.spellModRates[spellID]
		if rr then
			UpdateSpellRR(info, spellID, 1/rr)
		end
		RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
	end
	registeredEvents['SPELL_AURA_APPLIED'][id] = function(info, _, spellID)
		local talentRank = info.talentData[382800]
		if talentRank then
			local talentValue = talentRank == 2 and 1.2 or 1.1
			info.auras.isMageBarrier = talentValue
			UpdateSpellRR(info, spellID, 1/talentValue)
		end
	end
end


local fieryRushIDs = {
	108853,
	257541,
}

registeredEvents['SPELL_AURA_REMOVED'][190319] = function(info, srcGUID, spellID, destGUID)
	for i = 1, 2 do
		local id = fieryRushIDs[i]
		local rr = info.spellModRates[id]
		if rr then
			UpdateSpellRR(info, id, 1.5)
		end
	end
	RemoveHighlightByCLEU(info, srcGUID, spellID, destGUID)
end

registeredEvents['SPELL_AURA_APPLIED'][190319] = function(info)
	if not info.talentData[383634] then
		return
	end
	for i = 1, 2 do
		local id = fieryRushIDs[i]
		UpdateSpellRR(info, id, 1/1.5)
	end
end


--[[ CDTS
local holyPowerGenerators = {
	35395,
	24275,
	20271,
	184575,
}

registeredEvents['SPELL_AURA_REMOVED'][385126] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[385129] then
		for i = 1, 4 do
			local id = holyPowerGenerators[i]
			local rr = info.spellModRates[id]
			if rr then
				UpdateSpellRR(info, id, 1.1)
			end
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][385126] = function(info, srcGUID, spellID, destGUID)
	if info.talentData[385129] then
		for i = 1, 4 do
			local id = holyPowerGenerators[i]
			UpdateSpellRR(info, id, 1/1.1)
		end
	end
end
]]


local symbolOfHopeIDs = {
	[71]=118038,	[72]=184364,	[73]=871,
	[65]=498,	[66]=31850,	[70]=184662,
	[253]=109304,	[254]=109304,	[255]=109304,
	[259]=185311,	[260]=185311,	[261]=185311,
	[256]=19236,	[257]=19236,	[258]=19236,
	[250]=48792,	[251]=48792,	[252]=48792,
	[262]=108271,	[263]=108271,	[264]=108271,
	[62]=55342,	[63]=55342,	[64]=55342,
	[265]=104773,	[266]=104773,	[267]=104773,
	[268]=115203,	[269]=243435,	[270]=243435,
	[102]=22812,	[103]=22812,	[104]=22812,	[105]=22812,
	[577]=198589,	[581]=204021,
	[1467]=363916,	[1468]=363916,
}

if E.isDF then
	symbolOfHopeIDs[269]=115203
	symbolOfHopeIDs[270]=115203
end

registeredEvents['SPELL_AURA_REMOVED'][265144] = function(_,_,_, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local id = symbolOfHopeIDs[destInfo.spec]
		if id then
			local rr = destInfo.spellModRates[id] and destInfo.auras.symbolOfHopeModRate
			if rr then
				UpdateSpellRR(destInfo, id, 1/rr)
				destInfo.auras.symbolOfHopeModRate = nil
			end
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][265144] = function(info, _,_, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local id = symbolOfHopeIDs[destInfo.spec]
		if id then
			local _,_,_, startTimeMS, endTimeMS = UnitChannelInfo(info and info.unit or "player")
			if startTimeMS and endTimeMS then
				local channelTime = (endTimeMS - startTimeMS) / 1000
				local rr = 1 / ((60 + channelTime) / channelTime)
				UpdateSpellRR(destInfo, id, rr)
				destInfo.auras.symbolOfHopeModRate = rr
			end
		end
	end
end

registeredUserEvents['SPELL_AURA_REMOVED'][265144] = registeredEvents['SPELL_AURA_REMOVED'][265144]
registeredUserEvents['SPELL_AURA_APPLIED'][265144] = registeredEvents['SPELL_AURA_APPLIED'][265144]


registeredEvents['SPELL_AURA_REMOVED'][381684] = function(info)
	local rr = info.spellModRates[20608]
	if rr then
		UpdateSpellRR(info, 20608, 1/rr)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][381684] = function(info)
	local icon = info.spellIcons[20608]
	if icon and icon.active then
		UpdateSpellRR(info, 20608, 1/1.75)
	end
end


registeredEvents['SPELL_AURA_REMOVED'][353210] = function(info)
	local rr = info.spellModRates[300728]
	if rr then
		UpdateSpellRR(info, 300728, 1/rr)
	end
end

registeredEvents['SPELL_AURA_APPLIED'][353210] = function(info)
	UpdateSpellRR(info, 300728, 1/3)
end


local benevolentFaerieMajorCD = {
	[71]={227847,152277},	[72]=1719,		[73]=107574,
	[65]={31884,216331},	[66]=31884,		[70]={31884,231895},
	[253]=193530,		[254]=288613,		[255]=266779,
	[259]=79140,		[260]=13750,		[261]=121471,
	[258]={228260,391109},	[256]=47536,		[257]=64843,
	[250]=55233,		[251]=47568,		[252]=275699,
	[262]={198067,192249},	[263]=51533,		[264]=108280,
	[62]=12042,		[63]=190319,		[64]=12472,
	[265]= 205180,		[266]= 265187,		[267]=1122,
	[268]=115203,		[269]={137639,152173},	[270]=115310,
	[102]={194223,102560},	[103]={106951,102543},	[104]={50334,102558},	[105]=740,
	[577]=191427,		[581]=187827,
	[1467]=375087,		[1468]=nil,
}

registeredEvents['SPELL_AURA_REMOVED'][327710] = function(_,_,_, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local majorCD = destInfo.auras.isBenevolent
		if majorCD then
			if destInfo.spellModRates[majorCD] then
				if destInfo.auras.isHauntedCDR then
					UpdateSpellRR(destInfo, majorCD, 3)
					destInfo.auras.isHauntedCDR = nil
				else
					UpdateSpellRR(destInfo, majorCD, 2)
				end
			end
			destInfo.auras.isBenevolent = nil
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][327710] = function(_,_,_, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local majorCD = benevolentFaerieMajorCD[destInfo.spec]
		majorCD = type(majorCD) == "table" and (destInfo.talentData[ majorCD[2] ] and majorCD[2] or majorCD[1]) or majorCD
		if majorCD then
			if destInfo.auras.isHauntedMask and not destInfo.auras.isHauntedCDR then
				destInfo.auras.isHauntedCDR = true
				UpdateSpellRR(destInfo, majorCD, 1/3)
			else
				UpdateSpellRR(destInfo, majorCD, 0.5)
			end
			destInfo.auras.isBenevolent = majorCD
		end
	end
end

registeredUserEvents['SPELL_AURA_REMOVED'][327710] = registeredEvents['SPELL_AURA_REMOVED'][327710]
registeredUserEvents['SPELL_AURA_APPLIED'][327710] = registeredEvents['SPELL_AURA_APPLIED'][327710]


registeredEvents['SPELL_AURA_REMOVED'][356968] = function(_, srcGUID, _, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local majorCD = destInfo.auras.isBenevolent
		if majorCD and destInfo.auras.isHauntedMask == srcGUID then
			if destInfo.spellModRates[majorCD] and destInfo.auras.isHauntedCDR then
				UpdateSpellRR(destInfo, majorCD, 1.5)
				destInfo.auras.isHauntedCDR = nil
			end
			destInfo.auras.isHauntedMask = nil
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][356968] = function(_, srcGUID, _, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local majorCD = destInfo.auras.isBenevolent
		if majorCD and not destInfo.auras.isHauntedMask then
			if destInfo.spellModRates[majorCD] and not destInfo.auras.isHauntedCDR then
				destInfo.auras.isHauntedCDR = true
				UpdateSpellRR(destInfo, majorCD, 1/1.5)
			end
			destInfo.auras.isHauntedMask = srcGUID
		end
	end
end

registeredUserEvents['SPELL_AURA_REMOVED'][356968] = registeredEvents['SPELL_AURA_REMOVED'][356968]
registeredUserEvents['SPELL_AURA_APPLIED'][356968] = registeredEvents['SPELL_AURA_APPLIED'][356968]





registeredEvents['SPELL_CAST_SUCCESS'][17] = function(_, srcGUID, _, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local majorCD = destInfo.auras.isBenevolent
		if majorCD and destInfo.spellModRates[majorCD] and destInfo.auras.isHauntedMask == srcGUID and destInfo.auras.isHauntedCDR then
			UpdateSpellRR(destInfo, majorCD, 1.5)
			destInfo.auras.isHauntedCDR = nil
		end
	end
end
registeredEvents['SPELL_CAST_SUCCESS'][186263] = function(_, srcGUID, _, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local majorCD = destInfo.auras.isBenevolent
		if majorCD and destInfo.spellModRates[majorCD] and destInfo.auras.isHauntedMask == srcGUID and not destInfo.auras.isHauntedCDR then
			destInfo.auras.isHauntedCDR = true
			UpdateSpellRR(destInfo, majorCD, 1/1.5)
		end
	end
end
registeredEvents['SPELL_CAST_SUCCESS'][2061] = registeredEvents['SPELL_CAST_SUCCESS'][186263]

registeredUserEvents['SPELL_CAST_SUCCESS'][17] = registeredEvents['SPELL_CAST_SUCCESS'][17]
registeredUserEvents['SPELL_CAST_SUCCESS'][186263] = registeredEvents['SPELL_CAST_SUCCESS'][186263]
registeredUserEvents['SPELL_CAST_SUCCESS'][2061] = registeredEvents['SPELL_CAST_SUCCESS'][186263]


registeredEvents['SPELL_AURA_REMOVED'][345453] = function(_,_,_, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local majorCD = benevolentFaerieMajorCD[destInfo.spec]
		if majorCD and destInfo.auras.isFermata and destInfo.spellModRates[majorCD] then
			UpdateSpellRR(destInfo, majorCD, 1.8)
			destInfo.auras.isFermata = nil
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][345453] = function(_,_,_, destGUID)
	local destInfo = groupInfo[destGUID]
	if destInfo then
		local majorCD = benevolentFaerieMajorCD[destInfo.spec]
		if majorCD and not destInfo.auras.isFermata then
			destInfo.auras.isFermata = true
			UpdateSpellRR(destInfo, majorCD, 1/1.8)
		end
	end
end

registeredUserEvents['SPELL_AURA_REMOVED'][345453] = registeredEvents['SPELL_AURA_REMOVED'][345453]
registeredUserEvents['SPELL_AURA_APPLIED'][345453] = registeredEvents['SPELL_AURA_APPLIED'][345453]






registeredEvents['SPELL_HEAL'][214200] = function(info, _,_,_,_,_,_,_,_,_,_, timestamp)
	local icon = info.spellIcons[214198]
	if icon then
		if timestamp > (info.auras.time_expellight or 0) then
			P:StartCooldown(icon, icon.duration)
			info.auras.time_expellight = timestamp + 10
		end
	end
end









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
		local icon = info.preactiveIcons[spellID]
		if icon then
			local statusBar = icon.statusBar
			if statusBar then
				P:SetExStatusBarColor(icon, statusBar.key)
			end
			info.preactiveIcons[spellID] = nil
			icon.icon:SetVertexColor(1, 1, 1)

			P:StartCooldown(icon, icon.duration)
		end
	end
	info.callbackTimers.inCombatTicker:Cancel()
	info.callbackTimers.inCombatTicker = nil
end

local function StartConsumablesCD(info, srcGUID, spellID)
	local icon = info.spellIcons[spellID]
	if icon then
		if spellID == 323436 then
			local stacks = icon.count:GetText()
			stacks = tonumber(stacks)
			stacks = (stacks and stacks > 0 and stacks or 3) - 1
			icon.count:SetText(stacks)
			info.auras.purifySoulStacks = stacks
		end

		if info.callbackTimers.inCombatTicker then
			info.callbackTimers.inCombatTicker:Cancel()
			info.callbackTimers.inCombatTicker = nil
		end
		if UnitAffectingCombat(info.unit) then
			local statusBar = icon.statusBar
			if icon.active then
				if statusBar then
					P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, 'UNIT_SPELLCAST_STOP')
				end
				icon.cooldown:Clear()
			end
			if not info.preactiveIcons[spellID] then
				if statusBar then
					statusBar.BG:SetVertexColor(0.7, 0.7, 0.7)
				end
				info.preactiveIcons[spellID] = icon
				icon.icon:SetVertexColor(0.4, 0.4, 0.4)
			end
			info.callbackTimers.inCombatTicker = C_Timer_NewTicker(5, function() startCdOutOfCombat(icon.guid) end, 200)
		else
			info.preactiveIcons[spellID] = nil
			icon.icon:SetVertexColor(1, 1, 1)
			P:StartCooldown(icon, icon.duration)
		end
	end
end

for i = 1, #consumables do
	local spellID = consumables[i]
	if spellID == 323436 then
		registeredEvents['SPELL_HEAL'][spellID] = function(info, srcGUID)
			if not info.auras.ignorePurifySoul then
				info.auras.ignorePurifySoul = true
				C_Timer_After(0.1, function() info.auras.ignorePurifySoul = false end)
				StartConsumablesCD(info, srcGUID, spellID)
			end
		end
		registeredEvents['SPELL_CAST_SUCCESS'][spellID] = registeredEvents['SPELL_HEAL'][spellID]
	else
		registeredEvents['SPELL_CAST_SUCCESS'][spellID] = StartConsumablesCD
	end
end


registeredEvents['SPELL_CAST_SUCCESS'][324739] = function(info)
	local icon = info.spellIcons[323436]
	if icon then
		info.auras.purifySoulStacks = 3
		icon.count:SetText(3)
	end
end


local kyrianAbilityByClass = {
	WARRIOR = { 307865, 4	},
	PALADIN = { 304971, 4	},
	HUNTER	= { 308491, 4	},
	ROGUE	= { 323547, 3	},
	PRIEST	= { 325013, 12	},
	DEATHKNIGHT = { 312202, 4	},
	SHAMAN	= { 324386, 4	},
	MAGE	= { 307443, 2	},
	WARLOCK = { 312321, 3	},
	MONK	= { 310454, 8	},
	DRUID	= { 338142, 4	},
	DEMONHUNTER = { 306830, 4	},
	EVOKER	= { 387168, 8	},
}

registeredEvents['SPELL_AURA_APPLIED'][353248] = function(info)
	local t = kyrianAbilityByClass[info.class]
	local target, rt = t[1], t[2]
	target = E.spell_merged[target] or target
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






local function ReduceCdByAzeriteDamage(info, _, spellID)
	local t = E.spell_damage_cdr_azerite[spellID]
	local target = t.target
	if type(target) == "table" then for _, targetID in pairs(target) do
		local icon = info.spellIcons[targetID]
		if icon and icon.active then
			P:UpdateCooldown(icon, t.duration)
		end
		end
	else
		local icon = info.spellIcons[target]
		if icon and icon.active then
			P:UpdateCooldown(icon, t.duration)
		end
	end
end

for k in pairs(E.spell_damage_cdr_azerite) do
	registeredEvents['SPELL_DAMAGE'][k] = ReduceCdByAzeriteDamage
end


local function ReduceEssMajorCdByUnifiedStrength(_,_,_, destGUID)
	local info = P.groupInfo[destGUID]
	local majorRank1 = info.talentData["essMajorRank1"]
	if majorRank1 then
		local icon = info.spellIcons[majorRank1]
		if icon and icon.active then
			P:UpdateCooldown(icon, 1)
		end
	end
end

registeredEvents['SPELL_AURA_APPLIED'][313643] = ReduceEssMajorCdByUnifiedStrength
registeredEvents['SPELL_AURA_REFRESH'][313643] = ReduceEssMajorCdByUnifiedStrength



local function GetHealthPercentageByInfoUnit(unit, srcGUID, destGUID)
	if not destGUID then return end
	local unitID = UnitTokenFromGUID(destGUID)
	if unitID then
		local currHP = UnitHealth(unitID)
		if currHP > 0 then
			return currHP / UnitHealthMax(unitID) * 100
		end
	end
end


registeredEvents['SPELL_DAMAGE'][310690] = function(info, srcGUID, spellID, destGUID)
	local icon = info.spellIcons[spellID]
	if icon and icon.active then
		if info.active[spellID] and GetTime() - info.active[spellID].startTime < 30 then
			local healthPercentage = GetHealthPercentageByInfoUnit(info.unit, srcGUID, destGUID)
			if healthPercentage and healthPercentage < 20  then
				P:UpdateCooldown(icon, 30)
			end
		end
	end
end


registeredEvents['SPELL_CAST_SUCCESS'][310690] = function(info, srcGUID, spellID, destGUID)
	local icon = info.spellIcons[spellID]
	if icon and icon.active then
		local healthPercentage = GetHealthPercentageByInfoUnit(info.unit, srcGUID, destGUID)
		if healthPercentage and (healthPercentage < 20 or (healthPercentage > 80 and E:IsEssenceRankUpgraded(info.talentData["essMajorID"]))) then
			P:UpdateCooldown(icon, 30)
		end
	end
end


registeredEvents['SPELL_AURA_APPLIED'][311202] = function(info)
	local icon = info.spellIcons[310690]
	if icon then
		P:StartCooldown(icon, 5, nil, true)
	end
end


local UnitAuraTooltip = CreateFrame("GameTooltip", "OmniCDUnitAuraTooltip", UIParent, "GameTooltipTemplate")
UnitAuraTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function GetBuffTooltipText(unit, spellID)
	for i = 1, 40 do
		local _,_,_,_,_,_,_,_,_, id = UnitBuff(unit, i)
		if not id then return end
		if id == spellID then
			UnitAuraTooltip:SetUnitBuff(unit, i)
			return OmniCDUnitAuraTooltipTextLeft2:GetText()
		end
	end
end

registeredEvents['SPELL_AURA_REMOVED'][316801] = function(info, srcGUID, spellID)
	info = info or groupInfo[srcGUID]
	if info then
		local modRate = info.auras.ineffableTruthModRate
		if modRate then
			local duration = P:GetBuffDuration(info.unit, spellID)
			if not duration then
				UpdateCDRR(info, 1 / modRate)
				if info.callbackTimers[spellID] then
					if srcGUID ~= userGUID then
						info.callbackTimers[spellID]:Cancel()
					end
				end
				info.callbackTimers[spellID] = nil
				info.auras.ineffableTruthModRate = nil
			end
		end
	end
end

local function SetCDRRByIneffableTruth(srcGUID, spellID)
	local info = groupInfo[srcGUID]
	if info then
		if not info.auras.ineffableTruthModRate then
			local tt = GetBuffTooltipText(info.unit, spellID)
			local modRate = tt and strmatch(tt, "%d+")
			modRate = tonumber(modRate)
			if not modRate or modRate < 30 then
				return
			end
			modRate = 100 / (100 + modRate)
			info.auras.ineffableTruthModRate = modRate
			UpdateCDRR(info, modRate)
		end
		if info.callbackTimers[spellID] then
			if srcGUID ~= userGUID then
				info.callbackTimers[spellID]:Cancel()
			end
		end
		info.callbackTimers[spellID] = srcGUID == userGUID or E.TimerAfter(10.1, registeredEvents['SPELL_AURA_REMOVED'][316801], nil, srcGUID, spellID)
	end
end

registeredEvents['SPELL_AURA_REFRESH'][316801] = SetCDRRByIneffableTruth

registeredEvents['SPELL_AURA_APPLIED'][316801] = function(info, srcGUID, spellID)

	GetBuffTooltipText(info.unit, spellID)

	E.TimerAfter(0.5, SetCDRRByIneffableTruth, srcGUID, spellID)
end


registeredEvents['SPELL_AURA_REMOVED'][315573] = function(info)
	info.glimpseOfClarity = nil
end

registeredEvents['SPELL_AURA_APPLIED'][315573] = function(info)
	info.glimpseOfClarity = true
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
	if E.preCata and UnitHealth(destInfo.unit) > 1 then
		return
	end
	P:SetDisabledColorScheme(destInfo)
	destInfo.isDead = true
	destInfo.bar:RegisterUnitEvent('UNIT_HEALTH', destInfo.unit)
	--[[
	if P.extraBars.raidBar0.shouldRearrangeInterrupts then
		P:SetExIconLayout("raidBar0", true, true)
	end
	]]
end

if E.isClassic then
	local spellNameToID = E.spellNameToID
	local spell_enabled = P.spell_enabled
	local spell_modifiers = E.spell_modifiers

	function CD:COMBAT_LOG_EVENT_UNFILTERED()
		local _, event, _, srcGUID, _, srcFlags, _, destGUID, destName, destFlags, _,_, spellName, _, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()

		if band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
			local destInfo = groupInfo[destGUID]
			if destInfo and event == 'UNIT_DIED' then
				UpdateDeadStatus(destInfo)
			end
			return
		end


		local spellID = spellNameToID[spellName]
		if not spellID then
			return
		end

		srcGUID = petGUIDS[srcGUID] or srcGUID
		local info = groupInfo[srcGUID]
		if not info then
			return
		end

		if spellID == 17116 or spellID == 16188 then
			spellID = info.class == "DRUID" and 17116 or 16188
		end

		if event == 'SPELL_CAST_SUCCESS' then
			if spell_enabled[spellID] or spell_modifiers[spellID] then
				ProcessSpell(spellID, srcGUID)
			end
		end

		local func = registeredEvents[event] and registeredEvents[event][spellID]
		if func then
			func(info, srcGUID, spellID, destGUID, critical, destFlags, amount, overkill, destName, resisted)
		end
	end
elseif E.preCata then
	function CD:COMBAT_LOG_EVENT_UNFILTERED()
		local _, event, _, srcGUID, _, srcFlags, _, destGUID, destName, destFlags, _, spellID, _,_, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()

		if band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
			local destInfo = groupInfo[destGUID]
			if destInfo and event == 'UNIT_DIED' then
				UpdateDeadStatus(destInfo)
			end
			return
		end

		if band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
			if band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 and isUserDisabled then
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
	function CD:COMBAT_LOG_EVENT_UNFILTERED()
		local timestamp, event, _, srcGUID, _, srcFlags, _, destGUID, destName, destFlags, destRaidFlags, spellID, _,_, amount, overkill, _, resisted, _,_, critical = CombatLogGetCurrentEventInfo()


		if band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
			local destInfo = groupInfo[destGUID]
			if destInfo then
				local func = registeredHostileEvents[event] and (registeredHostileEvents[event][spellID] or registeredHostileEvents[event][destInfo.class])
				if func then
					func(destInfo, destName, spellID, amount, overkill, destGUID, timestamp)
				elseif event == 'UNIT_DIED' then
					UpdateDeadStatus(destInfo)
				end
			elseif event == 'UNIT_DIED' then

				if destGUID == userGUID then
					E.Libs.CBH:Fire("OnDisabledUserDied")
					return
				end

				local watched = diedHostileGUIDS[destGUID]
				if watched then
					for guid, t in pairs(watched) do
						local info = groupInfo[guid]
						if info then
							for id in pairs(t) do
								local icon = info.spellIcons[id]
								if icon and icon.active then
									if id == 370965 then
										P:UpdateCooldown(icon, 12)
									else
										P:ResetCooldown(icon)
									end
								end
							end
						end
					end
					diedHostileGUIDS[destGUID] = nil
				end
			elseif event == 'SPELL_DISPEL' then
				local watched = dispelledHostileGUIDS[destGUID] and dispelledHostileGUIDS[destGUID][amount]
				if watched then
					for guid, callbacktTmer in pairs(watched) do
						local info = groupInfo[guid]
						if info then
							local icon = info.spellIcons[amount]
							if icon and icon.active then
								P:UpdateCooldown(icon, 45)
							end
						end
						callbacktTmer:Cancel()
					end
					wipe(dispelledHostileGUIDS[destGUID][amount])
				end
			end
		elseif band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 and isUserDisabled then
			local func = registeredUserEvents[event] and registeredUserEvents[event][spellID]
			if func and destGUID ~= userGUID then
				func(nil, srcGUID, spellID, destGUID, critical, destFlags, amount, overkill, destName, resisted, destRaidFlags, timestamp)
			end
		elseif band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
			local info = groupInfo[srcGUID]
			if not info then
				return
			end

			local func = registeredEvents[event] and (registeredEvents[event][spellID] or registeredEvents[event][info.class])
			if func then
				func(info, srcGUID, spellID, destGUID, critical, destFlags, amount, overkill, destName, resisted, destRaidFlags, timestamp)
			end
		elseif band(srcFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) > 0 then
			local ownerGUID = totemGUIDS[srcGUID]
			local info = groupInfo[ownerGUID]
			if not info then
				return
			end
			if event == 'SPELL_AURA_APPLIED' and spellID == 118905 then
				local icon = info.spellIcons[192058]
				local active = icon and icon.active and info.active[192058]
				if active then
					active.numHits = (active.numHits or 0) + 1
					if active.numHits > 4 then
						return
					end
					P:UpdateCooldown(icon, 5)
				end
			end
		elseif band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) > 0 then
			local ownerGUID = petGUIDS[srcGUID]
			local info = groupInfo[ownerGUID]
			if not info then
				return
			end
			if event == 'SPELL_INTERRUPT' then
				AppendInterruptExtras(info, spellID, amount, overkill, destRaidFlags)
			elseif event == 'SPELL_DAMAGE' then
				if critical and P.isInShadowlands and spellID == 83381 then
					local conduitValue = info.talentData[339704]
					if conduitValue then
						local icon = info.spellIcons[193530]
						if icon and icon.active then
							P:UpdateCooldown(icon, conduitValue)
						end
					end
				end
			end
		end
	end
end

function CD:UNIT_PET(unit)
	local unitPet = E.UNIT_TO_PET[unit]
	if not unitPet then
		return
	end

	local guid = UnitGUID(unit)
	local info = E.Party.groupInfo[guid]
	if info and (info.class == "WARLOCK" or info.spec == 253) then
		local petGUID = info.petGUID
		if petGUID then
			self.petGUIDS[petGUID] = nil
		end
		petGUID = UnitGUID(unitPet)
		if petGUID then
			info.petGUID = petGUID
			self.petGUIDS[petGUID] = guid
		end
	end
end

E.ProcessSpell = ProcessSpell
CD.totemGUIDS = totemGUIDS
CD.petGUIDS = petGUIDS
CD.diedHostileGUIDS = diedHostileGUIDS
CD.dispelledHostileGUIDS = dispelledHostileGUIDS
