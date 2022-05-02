local E, L, C = select(2, ...):unpack()

local tinsert = table.insert
local tremove = table.remove
local wipe = table.wipe
local GetSpellLevelLearned = GetSpellLevelLearned
if E.isPreBCC then
	GetSpellLevelLearned = function() return 0 end
end
local UnitHealth = UnitHealth
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitSpellHaste = UnitSpellHaste
local P = E["Party"]
local unitToPetId = E.unitToPetId
local spell_db = E.spell_db
local spell_cdmod_haste = E.spell_cdmod_haste
local spell_cdmod_talents = E.spell_cdmod_talents
local spell_chmod_talents = E.spell_chmod_talents
local spell_cdmod_talents_mult = E.spell_cdmod_talents_mult
local spell_cdmod_conduits = E.spell_cdmod_conduits
local spell_cdmod_conduits_mult = E.spell_cdmod_conduits_mult
local covenant_cdmod_conduits = E.covenant_cdmod_conduits
local covenant_chmod_conduits = E.covenant_chmod_conduits
local covenant_cdmod_items_mult = E.covenant_cdmod_items_mult
local spell_enabled = P.spell_enabled
local spell_modifiers = E.spell_modifiers
local cd_start_dispels = E.cd_start_dispels
local FEIGN_DEATH = 5384
local TOUCH_OF_KARMA = 125174


local bars = {}
local unusedBars = {}
local numBars = 0

local unusedIcons = {}
local numIcons = 0

function OmniCD_BarOnHide(self)
	local guid = self.guid
	if P.groupInfo[guid] then
		return
	end

	if guid == E.userGUID then
		P.userData.bar = nil
	end

	for i = #bars, 1, -1 do
		local f = bars[i]
		if f == self then
			if f.timer_inCombatTicker then
				f.timer_inCombatTicker:Cancel()
				f.timer_inCombatTicker = nil
			end
			if f.timer_ashenHallowTicker then
				f.timer_ashenHallowTicker:Cancel()
				f.timer_ashenHallowTicker = nil
			end
			tremove(bars, i)
			break
		end
	end
	tinsert(unusedBars, self)

	P:RemoveUnusedIcons(self, 1)
	self.numIcons = 0

	for key, f in pairs(P.extraBars) do
		local icons = f.icons
		local n = 0
		for j = f.numIcons, 1, -1 do
			local icon = icons[j]
			local iconGUID = icon.guid
			if guid == iconGUID then
				P:RemoveIcon(icon)
				tremove(icons, j)
				n = n + 1
			end
		end
		f.numIcons = f.numIcons - n

		P:SetExIconLayout(key)
	end










	self:UnregisterAllEvents()
end

function P:SetEnabledColorScheme(info)
	if not info.isDeadOrOffline then
		return
	end
	info.isDeadOrOffline = nil

	for id, icon in pairs(info.spellIcons) do
		local statusBar = icon.statusBar
		if statusBar then
			if icon.active then
				local castingBar = statusBar.CastingBar
				local startColor, startBGColor, startTextColor = P.CastingBarFrame_GetEffectiveStartColor(castingBar, true);
				castingBar:SetStatusBarColor(startColor:GetRGBA())
				castingBar.BG:SetVertexColor(startBGColor:GetRGBA())
				castingBar.Text:SetTextColor(startTextColor:GetRGB())
			end
			P:SetExStatusBarColor(icon, statusBar.key)
		end
		icon.icon:SetVertexColor(1, 1, 1)
		local charges = icon.maxcharges and tonumber(icon.Count:GetText())
		icon.icon:SetDesaturated(E.db.icons.desaturateActive and icon.active and not icon.isHighlighted and (not charges or charges == 0));
	end
end

local function CooldownBarFrame_OnEvent(self, event, ...)
	local guid = self.guid
	local info = P.groupInfo[guid]
	if not info then
		return
	end


	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit,_, spellID = ...
		if unit ~= info.unit and unit ~= unitToPetId[info.unit] then
			return
		end

		if (spell_enabled[spellID] or spell_modifiers[spellID]) and not cd_start_dispels[spellID] then
			E.ProcessSpell(spellID, guid)
		end
	elseif event == "UNIT_HEALTH" then
		local unit = ...
		if unit ~= info.unit then
			return
		end

		if not UnitIsDeadOrGhost(unit) then
			local currentHealth = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)
			if E.isPreBCC then
				local icon = info.spellIcons[20608]
				if icon then





					local mult = info.talentData[16184] and 0.3 or (info.talentData[16209] and 0.4) or 0.2
					if currentHealth == math.floor(maxHealth * mult) then
						P:StartCooldown(icon, icon.duration)
					end
				end
			else
				local percHealth = currentHealth / maxHealth
				if (percHealth > 0.5 and percHealth < 0.7) or percHealth > 0.9 then
					E.Libs.CBH:Fire("OnBattleRezed")
				end
			end

			P:SetEnabledColorScheme(info)
			info.isDead = nil
			self:UnregisterEvent(event)
		end
	elseif event == "UNIT_AURA" then
		local unit = ...
		if unit ~= info.unit then
			return
		end
















		if info.glowIcons[TOUCH_OF_KARMA] then
			if not P:GetBuffDuration(unit, TOUCH_OF_KARMA) then
				local icon = info.glowIcons[TOUCH_OF_KARMA]
				if icon then
					P:RemoveHighlight(icon)
				end




				self:UnregisterEvent(event)
			end
		elseif info.preActiveIcons[FEIGN_DEATH] then
			if not P:GetBuffDuration(unit, FEIGN_DEATH) then
				local icon = info.preActiveIcons[FEIGN_DEATH]
				if icon then
					P:RemoveHighlight(icon)
					info.preActiveIcons[FEIGN_DEATH] = nil
					icon.icon:SetVertexColor(1, 1, 1)
					P:StartCooldown(icon, icon.duration)
				end




				self:UnregisterEvent(event)
			end

		else
			self:UnregisterEvent(event)
		end
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		local unit = ...
		if unit ~= info.unit then
			return
		end

		if ( UnitIsConnected(unit) ) then
			E.Comms:EnqueueInspect(nil, guid)
		end
	elseif ( event == "UNIT_CONNECTION" ) then
		local unit, isConnected = ...;
		if ( unit == info.unit ) then
			if ( isConnected ) then
				P:SetEnabledColorScheme(info)
			else
				P:SetDisabledColorScheme(info)
			end
		end
	end
end

local function GetBar()
	local f = tremove(unusedBars)
	if not f then
		numBars = numBars + 1
		f = CreateFrame("Frame", "OmniCD" .. numBars, UIParent, "OmniCDTemplate")
		f.icons = {}
		f.numIcons = 0
		f.anchor:Hide()
		f.anchor.text:SetFontObject(E.AnchorFont)
		f:SetScript("OnEvent", CooldownBarFrame_OnEvent)
	end

	bars[#bars + 1] = f
	return f
end

function P:HideBars()
	for i = #bars, 1, -1 do
		local f = bars[i]
		f:Hide()
	end
end

local textureUVs = {
	"borderTop",
	"borderBottom",
	"borderRight",
	"borderLeft",
}

local function GetIcon(f, iconIndex)
	local icon = tremove(unusedIcons)
	if not icon then
		numIcons = numIcons + 1
		icon = CreateFrame("Button", "OmniCDIcon" .. numIcons, UIParent, "OmniCDButtonTemplate")
		icon.counter = icon.cooldown:GetRegions()
		for _, pieceName in ipairs(textureUVs) do
			local region = icon[pieceName];
			if region then
				E.DisablePixelSnap(region)
			end
		end
		E.DisablePixelSnap(icon.icon)

		icon.Name:SetFontObject(E.IconFont)
	end

	icon:SetParent(f.container)
	icon.Name:Hide()

	f.icons[iconIndex] = icon
	return icon
end

function P:RemoveIcon(icon)
	local statusBar = icon.statusBar
	if statusBar then
		self.RemoveStatusBar(statusBar)
		icon.statusBar = nil
	end









	self:HideOverlayGlow(icon)
	icon:Hide()
	tinsert(unusedIcons, icon)
end

function P:RemoveUnusedIcons(f, n)
	for i = #f.icons, n, -1 do
		local icon = f.icons[i]
		self:RemoveIcon(icon)
		f.icons[i] = nil
	end
end

function P:SetBarBackdrop(f)
	local icons = f.icons
	for i = 1, f.numIcons do
		local icon = icons[i]
		self:SetBorder(icon)
	end
end

local function IsSpellSpecTalent(guid, spec, spellID)
	local info = P.groupInfo[guid]
	local specID = info.spec
	if specID then

		if type(spec) == "table" then
			for _, id in pairs(spec) do
				if id < 599 then
					if id == specID then return true end
				else
					if P:IsTalent(id, guid) then return true end
				end
			end
		elseif type(spec) == "number" then
			return P:IsTalent(spec, guid)
		else
			return P:IsTalent(spellID, guid)
		end
	end
end

function P:UpdateUnitBar(guid, isGRU)
	local info = self.groupInfo[guid]
	local class = info.class
	local raceID = info.raceID
	local index = info.index
	local unit = info.unit
	local isntUser = guid ~= E.userGUID

	wipe(info.spellIcons)

	if not info.bar then
		info.bar = GetBar()
	end

	local f = info.bar
	f.key = index
	f.guid = guid
	f.class = class
	f.raceID = raceID
	f.unit = unit
	f.anchor.text:SetText(index)









	f:UnregisterAllEvents()
	if not E.isPreBCC and isntUser then
		f:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", unit)
	end
	if info.isDead then
		f:RegisterUnitEvent("UNIT_HEALTH", unit)
	end
	f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit, unitToPetId[unit])
	f:RegisterUnitEvent("UNIT_CONNECTION", unit)

	local isInspectedUnit = info.spec
	local lvl = info.level
	local iconIndex = 0
	local loginsessionData = self.loginsessionData[guid]

	if not E.Comms.syncGUIDS[guid] and not info.shadowlandsData.covenantID and isInspectedUnit and loginsessionData then
		for k, v in pairs(loginsessionData) do
			if k == "covenantID" then
				info.shadowlandsData.covenantID = v
			else
				info.talentData[k] = v
			end
		end
	end


	for i = 1, 5 do
		local spells = (i == 1 and spell_db.PVPTRINKET) or
			(i == 2 and spell_db.RACIAL) or
			(i == 3 and spell_db.TRINKET) or
			(i == 4 and spell_db.COVENANT) or
			(i == 5 and spell_db[class])

		if spells then
			local n = #spells
			for j = 1, n do
				local spell = spells[j]
				local spellID, spellType, spec, race, item, item2, talent, pve = spell.spellID, spell.type, spell.spec, spell.race, spell.item, spell.item2, spell.talent, spell.pve

				local isValidSpell
				if spell_enabled[spellID] and (isntUser or (not self.isUserHidden or (E.db.extraBars.interruptBar.enabled and spellType == "interrupt") or (E.db.extraBars.raidCDBar.enabled and E.db.raidCDS[tostring(spellID)]))) then
					if i == 2 then
						if type(race) == "table" then
							for i = 1, #race do
								local id = race[i]
								if id == raceID then
									isValidSpell = true
								end
							end
						elseif race == raceID then
							isValidSpell = true
						end






					elseif isInspectedUnit then
						if i == 5 then
							isValidSpell = lvl >= GetSpellLevelLearned(spellID) and (not spec or IsSpellSpecTalent(guid, spec, spellID)) and (not talent or not IsSpellSpecTalent(guid, talent, spellID)) and (not pve or not self.isInPvPInstance)
						elseif i == 4 then
							isValidSpell = IsSpellSpecTalent(guid, spec, spellID)
						elseif i == 3 or i == 1 then
							isValidSpell = self:IsEquipped(item, guid, item2)
						end
					else
						if i == 5 then
							isValidSpell = lvl >= GetSpellLevelLearned(spellID) and (not spec or (loginsessionData and loginsessionData[spec])) and not talent
						elseif i == 4 then
							isValidSpell = loginsessionData and loginsessionData[spec]
						elseif i == 3 then
							isValidSpell = not item
						end
					end
				end

				if isValidSpell then
					local cd = self:GetValueByType(spell.duration, guid, item2)
					if not E.isPreBCC or not self.isInArena or cd < 900 then
						local category, buffID, iconTexture = spell.class, spell.buff, spell.icon
						local ch = self:GetValueByType(spell.charges, guid) or 1
						if isInspectedUnit then
							if i == 5 then
								local cdData = spell_cdmod_talents[spellID]
								if cdData then
									if type(cdData[1]) == "table" then
										for i = 1, #cdData do
											local t = cdData[i]
											if self:IsTalent(t[1], guid) then
												cd = cd - t[2]
											end
										end
									else
										if self:IsTalent(cdData[1], guid) then
											cd = cd - cdData[2]
										end
									end
								end

								local conduitData = spell_cdmod_conduits[spellID]
								if conduitData then
									local rankValue = info.talentData[conduitData]
									if rankValue then



										cd = cd - rankValue
									end
								end

								if spell_cdmod_haste[spellID] then
									if E.isPreBCC then
										cd = cd + (info.RAS or 0)
									else
										local haste = UnitSpellHaste(unit) or 0
										cd = cd * (1 - haste/100)
									end
								end

								local cdMult = spell_cdmod_talents_mult[spellID]
								if cdMult then
									if type(cdMult[1]) == "table" then
										for i = 1, #cdMult do
											local t = cdMult[i]
											if self:IsTalent(t[1], guid) then
												cd = cd * t[2]
											end
										end
									else
										if self:IsTalent(cdMult[1], guid) then
											cd = cd * cdMult[2]
										end
									end
								end

								local conduitMult = spell_cdmod_conduits_mult[spellID]
								if conduitMult then
									local rankValue = info.talentData[conduitMult]
									if rankValue then
										cd = cd * rankValue
									end
								end

								local chData = spell_chmod_talents[spellID]
								if chData and self:IsTalent(chData[1], guid) then
									ch = ch + chData[2]
								end
							elseif i == 4 then
								local cdData = covenant_cdmod_conduits[spellID]
								if cdData and info.talentData[cdData[1]] then
									cd = cd - cdData[2]
								end

								local cdMult = covenant_cdmod_items_mult[spellID]
								if cdMult and self:IsEquipped(cdMult[1], guid) then
									cd = cd * cdMult[2]
								end

								local chData = covenant_chmod_conduits[spellID]
								if chData and info.talentData[chData[1]] then
									ch = ch + chData[2]
								end
							end
						end
						ch = ch > 1 and ch

						iconIndex = iconIndex + 1

						local icon = f.icons[iconIndex] or GetIcon(f, iconIndex)
						icon:Hide()
						icon.guid = guid
						icon.spellID = spellID
						icon.class = class
						icon.type = spellType
						icon.category = category
						icon.buff = buffID
						icon.duration = cd
						icon.maxcharges = ch
						icon.Count:SetText(ch or (spellID == 323436 and info.auras.purifySoulStacks) or "")
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
								icon.Count:SetText(charges)
							else
								active.charges = nil
								charges = -1
							end

							self:UpdateCooldown(icon, 0, charges)
						else
							icon.cooldown:Clear()
						end

						if info.preActiveIcons[spellID] then
							info.preActiveIcons[spellID] = icon
							self:HighlightIcon(icon, true)
						end

						info.spellIcons[spellID] = icon

						if i == 2 and race ~= 37 then
							break
						end
					end
				end
			end
		end
	end
	f.numIcons = iconIndex

	self:RemoveUnusedIcons(f, iconIndex + 1)

	self:UpdateExBar(f, isGRU)

	if isntUser or not self.isUserHidden then
		self:ApplySettings(f)
		self:SetIconLayout(f, true)
	end
end

function P:UpdateBars()
	self:HideExBars(true)

	for guid in pairs(self.groupInfo) do
		self:UpdateUnitBar(guid, true)
	end
end

P.bars = bars
P.unusedBars = unusedBars
P.unusedIcons = unusedIcons
