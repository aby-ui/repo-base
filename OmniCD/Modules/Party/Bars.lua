local E = select(2, ...):unpack()
local P, CM = E.Party, E.Comm

local pairs, ipairs, type, tonumber, tinsert, tremove, wipe, floor = pairs, ipairs, type, tonumber, table.insert, table.remove, table.wipe, math.floor
local UnitHealth, UnitIsConnected, UnitIsDeadOrGhost = UnitHealth, UnitIsConnected, UnitIsDeadOrGhost
local GetSpellLevelLearned = GetSpellLevelLearned
if E.spell_requiredLevel then
	GetSpellLevelLearned = function(id) return not P.isInTestMode and E.spell_requiredLevel[id] or 0 end
elseif E.preCata then
	GetSpellLevelLearned = function() return 0 end
end

local ACD_Tooltip = E.Libs.ACD.tooltip
local FEIGN_DEATH = 5384
local TOUCH_OF_KARMA = 125174
local DEBUFF_HEARTSTOP_AURA = 214975

local unitBars = {}
local unusedBars = {}
local numBars = 0

local unusedIcons = {}
local numIcons = 0

local UNIT_TO_PET = {
	["raid1"]="raidpet1", ["raid2"]="raidpet2", ["raid3"]="raidpet3", ["raid4"]="raidpet4", ["raid5"]="raidpet5",
	["raid6"]="raidpet6", ["raid7"]="raidpet7", ["raid8"]="raidpet8", ["raid9"]="raidpet9", ["raid10"]="raidpet10",
	["raid11"]="raidpet11", ["raid12"]="raidpet12", ["raid13"]="raidpet13", ["raid14"]="raidpet14", ["raid15"]="raidpet15",
	["raid16"]="raidpet16", ["raid17"]="raidpet17", ["raid18"]="raidpet18", ["raid19"]="raidpet19", ["raid20"]="raidpet20",
	["raid21"]="raidpet21", ["raid22"]="raidpet22", ["raid23"]="raidpet23", ["raid24"]="raidpet24", ["raid25"]="raidpet25",
	["raid26"]="raidpet26", ["raid27"]="raidpet27", ["raid28"]="raidpet28", ["raid29"]="raidpet29", ["raid30"]="raidpet30",
	["raid31"]="raidpet31", ["raid32"]="raidpet32", ["raid33"]="raidpet33", ["raid34"]="raidpet34", ["raid35"]="raidpet35",
	["raid36"]="raidpet36", ["raid37"]="raidpet37", ["raid38"]="raidpet38", ["raid39"]="raidpet39", ["raid40"]="raidpet40",
	["party1"]="partypet1", ["party2"]="partypet2", ["party3"]="partypet3", ["party4"]="partypet4", ["player"]="pet"
}
E.UNIT_TO_PET = UNIT_TO_PET

function P:SetEnabledColorScheme(info)
	if not info.isDeadOrOffline then
		return
	end
	info.isDeadOrOffline = nil

	for _, icon in pairs(info.spellIcons) do
		local statusBar = icon.statusBar
		if statusBar then
			if icon.active then
				local castingBar = statusBar.CastingBar
				local startColor, startBGColor, startTextColor = self.CastingBarFrame_GetEffectiveStartColor(castingBar, true)
				castingBar:SetStatusBarColor(startColor:GetRGBA())
				castingBar.BG:SetVertexColor(startBGColor:GetRGBA())
				castingBar.Text:SetTextColor(startTextColor:GetRGB())
			end
			self:SetExStatusBarColor(icon, statusBar.key)
		end
		icon.icon:SetVertexColor(1, 1, 1)
		local charges = icon.maxcharges and tonumber(icon.count:GetText())
		icon.icon:SetDesaturated(E.db.icons.desaturateActive and icon.active and not icon.isHighlighted and (not charges or charges == 0))
	end
end

local function CooldownBarFrame_OnEvent(self, event, ...)
	local guid = self.guid
	local info = P.groupInfo[guid]
	if not info then
		return
	end

	if event == 'UNIT_SPELLCAST_SUCCEEDED' then


		local unit, _, spellID = ...
		if unit ~= info.unit and unit ~= UNIT_TO_PET[info.unit] then
			return
		end

		if spellID == 384255 and not CM.syncedGroupMembers[guid] then
			CM:EnqueueInspect(nil, guid)
		elseif P.spell_enabled[spellID] or E.spell_modifiers[spellID] then
			E.ProcessSpell(spellID, guid)
		end
	elseif event == 'UNIT_HEALTH' then
		local unit = ...
		if unit ~= info.unit then
			return
		end








		if not UnitIsDeadOrGhost(unit) then
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			if E.preCata then
				local icon = info.spellIcons[20608]
				if icon then
					local mult = info.talentData[16184] and 0.3 or (info.talentData[16209] and 0.4) or 0.2
					if currentHealth == floor(maxHealth * mult) then
						P:StartCooldown(icon, icon.duration)
					end
				end
			else
				local percHealth = currentHealth / maxHealth
				if percHealth > 0.5 and percHealth < 0.7 or percHealth > 0.9 then
					E.Libs.CBH:Fire("OnBattleRezed")
				end
			end

			P:SetEnabledColorScheme(info)
			info.isDead = nil
			--[[
			if P.extraBars.raidBar0.shouldRearrangeInterrupts then
				P:SetExIconLayout("raidBar0", true, true)
			end
			]]
			self:UnregisterEvent(event)
		end
	elseif event == 'UNIT_AURA' then
		local unit = ...
		if unit ~= info.unit then
			return
		end

		--[[ Patch 9.0 HSA no longer fires CLEU -> Patch 9.1 removed
		if E.isBFA and P.isInArena then
			if P:IsDebuffActive(unit, DEBUFF_HEARTSTOP_AURA) then
				if not info.auras.isHeartStopped then
					P.UpdateCDRR(info, 1/0.7)
					info.auras.isHeartStopped = true
				end
			else
				if info.auras.isHeartStopped then
					P.UpdateCDRR(info, 0.7)
					info.auras.isHeartStopped = nil
				end
			end
		end
		]]

		if info.glowIcons[TOUCH_OF_KARMA] then
			if not P:GetBuffDuration(unit, TOUCH_OF_KARMA) then
				local icon = info.glowIcons[TOUCH_OF_KARMA]
				if icon then
					P:RemoveHighlight(icon)
				end
				if E.isBFA and not P.isInArena then
					self:UnregisterEvent(event)
				end
				self:UnregisterEvent(event)
			end
		elseif info.preactiveIcons[FEIGN_DEATH] then
			if not P:GetBuffDuration(unit, FEIGN_DEATH) then
				local icon = info.preactiveIcons[FEIGN_DEATH]
				if icon then
					P:RemoveHighlight(icon)
					info.preactiveIcons[FEIGN_DEATH] = nil
					icon.icon:SetVertexColor(1, 1, 1)
					P:StartCooldown(icon, icon.duration)
				end
				if E.isBFA and not P.isInArena then
					self:UnregisterEvent(event)
				end
				self:UnregisterEvent(event)
			end
		elseif not E.isBFA or not P.isInArena then
			self:UnregisterEvent(event)
		end
	elseif event == 'PLAYER_SPECIALIZATION_CHANGED' then
		local unit = ...
		if unit ~= info.unit then
			return
		end

		if UnitIsConnected(unit) then
			CM:EnqueueInspect(nil, guid)
		end
	elseif event == 'UNIT_CONNECTION' then
		local unit, isConnected = ...
		if unit == info.unit then
			if isConnected then
				P:SetEnabledColorScheme(info)
			else
				P:SetDisabledColorScheme(info)
			end
		end
	end
end

local function OmniCDBar_OnHide(self)
	local guid = self.guid
	if P.groupInfo[guid] then
		return
	end

	if guid == E.userGUID then
		P.userInfo.bar = nil
	end

	for i = #unitBars, 1, -1 do
		local frame = unitBars[i]
		if frame == self then
			tremove(unitBars, i)
			break
		end
	end
	tinsert(unusedBars, self)

	P:RemoveUnusedIcons(self, 1)
	self.numIcons = 0

	for key, frame in pairs(P.extraBars) do
		local icons = frame.icons
		local n = 0
		for j = frame.numIcons, 1, -1 do
			local icon = icons[j]
			local iconGUID = icon.guid
			if guid == iconGUID then
				P:RemoveIcon(icon)
				tremove(icons, j)
				n = n + 1
			end
		end
		frame.numIcons = frame.numIcons - n

		P:SetExIconLayout(key)
	end

	self:UnregisterAllEvents()
end

local function OmniCDCooldown_OnHide(self)
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
		end
		icon.count:SetText(maxcharges)
	end

	info.active[spellID] = nil
	icon.active = nil
	if not info.isDeadOrOffline then
		icon.icon:SetDesaturated(false)
	end

	local frame = icon:GetParent():GetParent()
	local key = frame.key
	if type(key) == "number" then
		icon:SetAlpha(E.db.icons.inactiveAlpha)

		if not P.displayInactive then
			P:SetIconLayout(frame)
		end
	else
		local statusBar = icon.statusBar
		if statusBar then
			P.OmniCDCastingBarFrame_OnEvent(statusBar.CastingBar, 'UNIT_SPELLCAST_STOP')
		else
			icon:SetAlpha(E.db.icons.inactiveAlpha)
		end

		if frame.shouldRearrangeInterrupts then
			P:SetExIconLayout(key, true, true)
		end
	end
end

local function OmniCDIcon_OnEnter(self)
	ACD_Tooltip:SetOwner(self, "ANCHOR_RIGHT")
	ACD_Tooltip:SetSpellByID(self.tooltipID or self.spellID)
end

local function OmniCDIcon_OnLeave()
	ACD_Tooltip:Hide()
end

local function GetUnitBarFrame()
	local frame = tremove(unusedBars)
	if not frame then
		numBars = numBars + 1
		frame = CreateFrame("Frame", "OmniCDBar" .. numBars, UIParent, "OmniCDTemplate")
		frame.icons = {}
		frame.numIcons = 0
		frame.anchor:Hide()
		frame.anchor.text:SetFontObject(E.AnchorFont)
		frame.anchor:SetScript("OnMouseUp", E.OmniCDAnchor_OnMouseUp)
		frame.anchor:SetScript("OnMouseDown", E.OmniCDAnchor_OnMouseDown)
		frame:SetScript("OnHide", OmniCDBar_OnHide)
		frame:SetScript("OnEvent", CooldownBarFrame_OnEvent)
	end

	unitBars[#unitBars + 1] = frame
	return frame
end

function P:HideBars()
	for i = #unitBars, 1, -1 do
		local frame = unitBars[i]
		frame:Hide()
	end
end

local textureUVs = {
	"borderTop",
	"borderBottom",
	"borderRight",
	"borderLeft",
}

local function GetIcon(barFrame, iconIndex)
	local icon = tremove(unusedIcons)
	if not icon then
		numIcons = numIcons + 1
		icon = CreateFrame("Button", "OmniCDIcon" .. numIcons, UIParent, "OmniCDButtonTemplate")
		icon.counter = icon.cooldown:GetRegions()
		for _, pieceName in ipairs(textureUVs) do
			local region = icon[pieceName]
			if region then
				E.DisablePixelSnap(region)
			end
		end
		E.DisablePixelSnap(icon.icon)

		icon.name:SetFontObject(E.IconFont)
		if E.RegisterCooldown then
			E.RegisterCooldown(ElvUI[1], icon.cooldown, "OmniCD")
		end
		icon.cooldown:SetScript("OnHide", OmniCDCooldown_OnHide)
		icon:SetScript("OnEnter", OmniCDIcon_OnEnter)
		icon:SetScript("OnLeave", OmniCDIcon_OnLeave)
	end

	icon:SetParent(barFrame.container)

	barFrame.icons[iconIndex] = icon
	return icon
end

function P:RemoveIcon(icon)
	local statusBar = icon.statusBar
	if statusBar then
		self:RemoveStatusBar(statusBar)
		icon.statusBar = nil
	end

	self:HideOverlayGlow(icon)
	icon:Hide()
	tinsert(unusedIcons, icon)
end

function P:RemoveUnusedIcons(barFrame, n)
	for i = #barFrame.icons, n, -1 do
		local icon = barFrame.icons[i]
		self:RemoveIcon(icon)
		barFrame.icons[i] = nil
	end
end

function P:SetBarBackdrop(barFrame)
	local icons = barFrame.icons
	for i = 1, barFrame.numIcons do
		local icon = icons[i]
		self:SetBorder(icon)
	end
end

function P:UpdateUnitBar(guid, isUpdateBarsOrGRU)
	local info = self.groupInfo[guid]
	local class = info.class
	local raceID = info.raceID
	local index = info.index
	local unit = info.unit
	local notUser = guid ~= E.userGUID

	wipe(info.spellIcons)


	if not info.bar then
		info.bar = GetUnitBarFrame()
	end

	local frame = info.bar
	frame.key = index
	frame.guid = guid
	frame.class = class
	frame.raceID = raceID
	frame.unit = unit
	frame.anchor.text:SetText(index)

	frame:UnregisterAllEvents()

	if info.isAdminObsForMDI then
		frame.numIcons = 0
		self:RemoveUnusedIcons(frame, 1)
		return
	end

	if not E.preCata and notUser then
		frame:RegisterUnitEvent('PLAYER_SPECIALIZATION_CHANGED', unit)
	end
	if E.isBFA then
		if self.isInArena then
			frame:RegisterUnitEvent('UNIT_AURA', unit)
		end
	else
		if info.glowIcons[TOUCH_OF_KARMA] or info.preactiveIcons[FEIGN_DEATH] then
			frame:RegisterUnitEvent('UNIT_AURA', unit)
		end
	end
	if info.isDead then
		frame:RegisterUnitEvent('UNIT_HEALTH', unit)
	end
	if not E.isClassic then
		frame:RegisterUnitEvent('UNIT_SPELLCAST_SUCCEEDED', unit, UNIT_TO_PET[unit])
	end
	frame:RegisterUnitEvent('UNIT_CONNECTION', unit)

	local isInspectedUnit = info.spec
	local lvl = info.level
	local iconIndex = 0
	local loginsessionData = self.loginsessionData[guid]

	if not CM.syncedGroupMembers[guid] and not info.shadowlandsData.covenantID and isInspectedUnit and loginsessionData then
		for k, v in pairs(loginsessionData) do
			if k == "covenantID" then
				info.shadowlandsData.covenantID = v
			else
				info.talentData[k] = v
			end
		end
	end

	for i = 1, 7 do
		local spells = (i == 1 and E.spell_db.PVPTRINKET)
			or (i == 2 and E.spell_db.RACIAL)
			or (i == 3 and E.spell_db.TRINKET)
			or (i == 4 and E.spell_db.ESSENCES)
			or (i == 5 and E.spell_db.COVENANT)
			or (i == 6 and E.spell_db[class])

		if spells then
			local n = #spells
			for j = 1, n do
				local spell = spells[j]
				local spellID, spellType, spec, race, item, item2, talent = spell.spellID, spell.type, spell.spec, spell.race, spell.item, spell.item2, spell.talent

				local isValidSpell
				local enabledSpell = self.spell_enabled[spellID]
				local extraBarKey, extraBarFrame
				if type(enabledSpell) == "number" then
					extraBarKey = "raidBar" .. enabledSpell
					extraBarFrame = E.db.extraBars[extraBarKey].enabled and self.extraBars[extraBarKey]
				end
				if enabledSpell and (notUser or (not self.isUserHidden or extraBarFrame)) then
					if i == 2 then
						if type(race) == "table" then
							for k = 1, #race do
								local id = race[k]
								if id == raceID then
									isValidSpell = true
								end
							end
						elseif race == raceID then
							isValidSpell = true
						end
					elseif i == 7 then
						isValidSpell = true
					elseif isInspectedUnit then
						if i == 6 then
							isValidSpell = (not E.postBFA or not E.covenant_abilities[spellID] or self.isInShadowlands)
								and self:IsSpecOrTalentForPvpStatus(spec==true and spellID or spec, info, lvl >= GetSpellLevelLearned(spellID))
								and (not talent or not self:IsSpecOrTalentForPvpStatus(talent, info, true))
						elseif i == 5 then
							isValidSpell = self.isInShadowlands and self:IsSpecOrTalentForPvpStatus(spec==true and spellID or spec, info, true)
						elseif i == 4 then
							isValidSpell = info.talentData[spec]
						else
							isValidSpell = self:IsEquipped(item, guid, item2)
						end
					else
						if i == 6 then
							isValidSpell = lvl >= GetSpellLevelLearned(spellID) and (not spec or (loginsessionData and loginsessionData[spec])) and not talent
						elseif i == 5 then
							isValidSpell = self.isInShadowlands and loginsessionData and loginsessionData[spec]
						elseif i == 3 then
							isValidSpell = not item
						end
					end
				end

				if isValidSpell then
					local cd = self:GetValueByType(spell.duration, guid, item2)
					if not E.preCata or not self.isInArena or cd < 900 then
						local category, buffID, iconTexture = spell.class, spell.buff, spell.icon
						local ch = self:GetValueByType(spell.charges, guid) or 1
						if isInspectedUnit then
							if i == 6 then
								local modData = E.spell_cdmod_talents[spellID]
								if modData then
									for j = 1, #modData, 2 do
										local tal = modData[j]
										local rank = self:IsSpecAndTalentForPvpStatus(tal, info)
										if rank then
											local rt = modData[j+1]
											rt = type(rt) == "table" and (rt[rank] or rt[1]) or rt
											cd = cd - rt
										end
									end
								end

								modData = E.spell_cxmod_azerite[spellID]
								if modData and info.talentData[modData.azerite] then
									if modData.duration then
										cd = cd - modData.duration
									elseif modData.charges then
										ch = ch + modData.charges
									end
								end

								modData = E.spell_cdmod_conduits[spellID]
								if modData and self.isInShadowlands then
									local rankValue = info.talentData[modData]
									if rankValue then
										--[[ Dec 23, 2020 Hotfixed
										if spellID == 212653 then
											rankValue = rankValue / 2
										end
										]]
										if self.isPvP and modData == 336636 then
											rankValue = rankValue / 2
										end
										cd = cd - rankValue
									end
								end

								modData = E.spell_cdmod_by_haste[spellID]
								if modData == true or modData == info.spec then
									if E.preCata then
										cd = cd + (info.rangedWeaponSpeed or 0)
									else
										local spellHasteMult = info.spellHasteMult or 1/(1 + UnitSpellHaste("player")/100)
										cd = cd * spellHasteMult
									end
								end

								modData = E.spell_cdmod_talents_mult[spellID]
								if modData then
									for j = 1, #modData, 2 do
										local tal = modData[j]
										local rank = info.talentData[tal]
										if rank then
											local mult = modData[j+1]
											mult = type(mult) == "table" and (mult[rank] or mult[1]) or mult
											cd = cd * mult
										end
									end
								end

								modData = E.spell_cdmod_conduits_mult[spellID]
								if modData and self.isInShadowlands then
									local rankValue = info.talentData[modData]
									if rankValue then
										cd = cd * rankValue
									end
								end

								modData = info.talentData["essStriveMult"]
								if modData then
									local spec = E.spell_cdmod_ess_strive_mult[spellID]
									if spec == true or spec == info.spec then
										local pvpCD = self.isPvP and self.loginsessionData[guid] and self.loginsessionData[guid]["strivedPvpCD"]
										cd = pvpCD or cd * modData
										info.talentData["essStrivedPvpID"] = spellID
									elseif spellID == 107574 and info.spec == 71 then
										cd = cd - 5
									end
								end

								modData = E.spell_chmod_talents[spellID]
								if modData then
									for j = 1, #modData, 2 do
										local tal = modData[j]
										local rank = self:IsSpecAndTalentForPvpStatus(tal, info)
										if rank then
											local charges = modData[j + 1]
											charges = type(charges) == "table" and (charges[rank] or charges[1]) or charges
											ch = ch + charges
										end
									end
								end


								if E.majorMovementAbilitiesByIDs[spellID] then
									if self:GetBuffDuration(unit, 381748) then
										info.auras["isBlessingOfTheBronze"] = true
									end
								end
							elseif i == 5 then
								local covData = E.covenant_cdmod_conduits[spellID]
								if covData and info.talentData[ covData[1] ] then
									cd = cd - covData[2]
								end

								covData = E.covenant_cdmod_items_mult[spellID]
								if covData and info.itemData[ covData[1] ] then
									cd = cd * covData[2]
								end

								covData = E.covenant_chmod_conduits[spellID]
								if covData and info.talentData[ covData[1] ] then
									ch = ch + covData[2]
								end
							elseif i == 4 then
								local essData = E.spell_cdmod_essrank23 [spellID]
								if essData then
									if E:IsEssenceRankUpgraded(info.talentData["essMajorID"]) then
										cd = cd - essData
									end
								end

								essData = E.spell_chargemod_essrank3 [spellID]
								if essData then
									if essData[1] == info.talentData["essMajorID"] then
										ch = ch + essData[2]
									end
								end
							end
						end
						ch = ch > 1 and ch




						local icon
						if extraBarFrame then
							extraBarFrame.numIcons = extraBarFrame.numIcons + 1
							icon = GetIcon(extraBarFrame, extraBarFrame.numIcons)
						else
							iconIndex = iconIndex + 1
							icon = frame.icons[iconIndex] or GetIcon(frame, iconIndex)
						end
						icon.name:Hide()
						icon.guid = guid
						icon.spellID = spellID
						icon.class = class
						icon.type = spellType
						icon.category = category
						icon.buff = buffID
						icon.duration = cd
						icon.maxcharges = ch
						icon.count:SetText(ch or (spellID == 323436 and info.auras.purifySoulStacks) or "")
						icon.icon:SetTexture(iconTexture)
						icon.active = nil
						icon.tooltipID = nil

						self:HideOverlayGlow(icon)

						local active = info.active[spellID]
						if active then
							local charges
							if icon.maxcharges then
								if not active.charges then
									charges = icon.maxcharges - 1
									active.charges = charges
								else
									charges = active.charges
								end
								icon.count:SetText(charges)
							else
								active.charges = nil
								charges = -1
							end
							self:HighlightIcon(icon, true)

							icon.cooldown:SetCooldown(active.startTime, active.duration, active.iconModRate)
							icon.active = true
						else
							icon.cooldown:Clear()
						end

						if info.preactiveIcons[spellID] then
							info.preactiveIcons[spellID] = icon
							self:HighlightIcon(icon, true)
						end


						if extraBarFrame then
							local statusBar = icon.statusBar
							if statusBar then
								if not extraBarFrame.shouldShowProgressBar then
									self:RemoveStatusBar(statusBar)
									icon.statusBar = nil
								end
							else
								if extraBarFrame.shouldShowProgressBar then
									self:GetStatusBar(icon, extraBarKey)
								end
							end
						end

						info.spellIcons[spellID] = icon

						if i == 2 and spellID ~= 312916 and spellID ~= 368970 and spellID ~= 357214 then
							break
						end
					end
				end
			end
		end
	end
	frame.numIcons = iconIndex

	self:RemoveUnusedIcons(frame, iconIndex + 1)


	if not self.effectivePixelMult and E.db.general.showRange and not E.db.position.detached then
		local relFrame = self:FindRelativeFrame(guid)
		if relFrame then
			self.effectivePixelMult = E.uiUnitFactor / relFrame:GetEffectiveScale()
			self:UpdatePositionValues()
		end
	end

	if notUser or not self.isUserHidden then
		self:ApplySettings(frame)
		self:SetIconLayout(frame, true)
	end
	if not isUpdateBarsOrGRU then
		self:UpdateExBars()
	end
end

function P:UpdateBars()
	for guid in pairs(self.groupInfo) do
		self:UpdateUnitBar(guid, true)
	end
end

P.unusedBars = unusedBars
P.unusedIcons = unusedIcons
