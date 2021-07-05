local E, L, C = select(2, ...):unpack()

local P = CreateFrame("Frame")
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local runeforge_specID = E.runeforge_specID

P.spell_enabled = {}

function P:Enable()
	if self.enabled then
		return
	end

	self:RegisterEvent("UI_SCALE_CHANGED")
	self:RegisterEvent("CVAR_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("GROUP_JOINED")
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)

	self.enabled = true

	E.Comms:InspectPlayer() -- [58]

	self:SetHooks()
	self:CreateExBars()
	self:Refresh(true)
end

function P:Disable()
	if not self.enabled then
		return
	end

	if self.test then
		self:Test()
	end
	self.disabledzone = true
	self:UnregisterAllEvents()
	self:ResetModule(true)

	self.enabled = false
end

function P:HideAllBars()
	self:HideBars()
	self:HideExBars()
end

function P:ResetModule(isModuleDisabled)
	if not isModuleDisabled then
		E.UnregisterEvents(self, self.zoneEvents.all)
	end
	E.Comms:Disable()
	E.Cooldowns:Disable()

	wipe(self.groupInfo)

	self.disabled = true
	self:HideAllBars()
end

function P:Refresh(full)
	if not self.enabled then
		return
	end

	local instanceType = self.zone or select(2, IsInInstance()) -- [59]
	local key = self.test and self.testZone or instanceType
	key = key == "none" and E.profile.Party.noneZoneSetting or (key == "scenario" and E.profile.Party.scenarioZoneSetting) or key
	E.db = E.profile.Party[key]
	P.profile = E.profile.Party -- TODO: migrate
	P.db = E.db

	if full then
		--self:UpdateFonts() -- TODO: shared frames still needs to be updated on every call
		self:UpdateTextures()
		self:UpateTimerFormat()
		self:PLAYER_ENTERING_WORLD(nil, nil, true)
	else
		E:SetActiveUnitFrameData()
		self:UpdatePositionValues()
		self:UpdateExPositionValues()
		self:UpdateRaidPriority()
		self:UpdateBars()
		self:UpdatePosition()
		self:UpdateExPosition()
	end
end

function P:UpdateTextures()
	local texture = E.Libs.LSM:Fetch("statusbar", E.profile.General.textures.statusBar.bar)
	self:ConfigTextures()

	for i = 1, #self.unusedStatusBars do
		local statusBar = self.unusedStatusBars[i]
		statusBar.BG:SetTexture(texture)
		statusBar.CastingBar:SetStatusBarTexture(texture)
		statusBar.CastingBar.BG:SetTexture(E.Libs.LSM:Fetch("statusbar", E.profile.General.textures.statusBar.BG))
	end
end

function P:UpateTimerFormat()
	local db = E.profile.General.cooldownText.statusBar
	self.mmss = db.mmss
	self.ss = db.ss
	self.mmssColor = db.mmssColor
	self.ssColor = db.ssColor
end

function P:UpdateEnabledSpells()
	wipe(self.spell_enabled) -- wipe upvalue

	for _, v in pairs(E.spell_db) do
		local n = #v
		for i = 1, n do
			local t = v[i]
			local id = t.spellID
			if self.IsEnabledSpell(id) then
				self.spell_enabled[id] = true
			end
		end
	end
end

function P:UpdatePositionValues()
	local db = E.db.position

	self.point = db.anchor
	self.relativePoint = db.attach

	local growLeft = string.find(self.point, "RIGHT")
	local growX = growLeft and -1 or 1

	self.anchorPoint = growLeft and "BOTTOMLEFT" or "BOTTOMRIGHT"
	self.containerOfsX = db.offsetX * growX
	self.containerOfsY = -db.offsetY
	self.columns = db.columns
	self.multiline = db.layout ~= "vertical" and db.layout ~= "horizontal"
	self.tripleline = db.layout == "tripleRow" or db.layout == "tripleColumn"
	self.breakPoint = E.db.priority[db.breakPoint]
	self.breakPoint2 = E.db.priority[db.breakPoint2]
	self.displayInactive = db.displayInactive

	local growUpward = db.growUpward
	local growY = growUpward and 1 or -1
	local px = E.PixelMult / E.db.icons.scale
	if db.layout == "vertical" or  db.layout == "doubleColumn" or db.layout == "tripleColumn" then
		self.point2 = growUpward and "BOTTOMRIGHT" or "TOPRIGHT"
		self.relativePoint2 = growUpward and "TOPRIGHT" or "BOTTOMRIGHT"
		self.ofsX = growX * (E.BASE_ICON_SIZE + db.paddingX  * px)
		self.ofsY = 0
		self.ofsX2 = 0
		self.ofsY2 = growY * db.paddingY * px
	else
		self.point2 = growLeft and "TOPRIGHT" or "TOPLEFT"
		self.relativePoint2 = growLeft and "TOPLEFT" or "TOPRIGHT"
		self.ofsX = 0
		self.ofsY = growY * (E.BASE_ICON_SIZE + db.paddingY * px)
		self.ofsX2 = growX * db.paddingX * px
		self.ofsY2 = 0
	end
end

function P:GetBuffDuration(unit, spellID)
	for i = 1, 40 do
		local _,_,_,_, duration, expTime,_,_,_, id = UnitBuff(unit, i)
		if not id then return end
		if id == spellID then
			return duration > 0 and expTime - GetTime()
		end
	end
end

function P:GetDebuffDuration(unit, spellID)
	for i = 1, 40 do
		local _,_,_,_, duration, expTime,_,_,_, id = UnitDebuff(unit, i)
		if not id then return end
		if id == spellID then
			return duration > 0 and expTime - GetTime()
		end
	end
end

function P:GetEffectiveNumGroupMembers()
	local size = GetNumGroupMembers()
	return size == 0 and self.test and 1 or size
end

function P:GetValueByType(v, guid, item2)
	if v then
		if type(v) == "table" then
			if item2 then
				return self.groupInfo[guid].invSlotData[item2] and v[item2] or v.default
			end
			return v[self.groupInfo[guid].spec] or v.default
		else
			return v
		end
	end
end

function P:IsTalent(talentID, guid)
	if not talentID then
		return true
	end

	local talent = self.groupInfo[guid].talentData[talentID]
	if not talent then
		return false
	end

	-- TODO: move to inspect? (warmode)
	if talent == "PVP" then
		return self.isPvP
	elseif talent == "R" then
		local spec = runeforge_specID[talentID]
		return not spec and true or spec == self.groupInfo[guid].spec
	else
		return talent -- [60]
	end
end

function P:IsEquipped(item, guid, item2)
	if not item then
		return true
	end

	local invSlotData = self.groupInfo[guid].invSlotData
	if invSlotData[item] then
		return true
	end
	return invSlotData[item2]
end

function P.IsEnabledSpell(id, key)
	local db = key and E.profile.Party[key] or E.db
	id = tostring(id)
	return db.spells[id]
end

function P:IsDeBuffActive(unit, spellID)
	for i = 1, 40 do
		local _,_,_,_, duration, expTime,_,_,_, id = UnitDebuff(unit, i)
		if not id then return end
		if id == spellID then
			return true
		end
	end
end

function P:UI_SCALE_CHANGED() -- [61]
	E:SetPixelMult()
	self:ConfigSize(nil, true)
	for key in pairs(self.extraBars) do
		self:ConfigExSize(key, true)
	end
	--E.UpdateBackdrops() -- TODO: doesn't fix ace
end

E["Party"] = P
