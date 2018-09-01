------------------------------------------------------------
-- Visual.lua
--
-- Abin
-- 2012/3/19
------------------------------------------------------------

local ipairs = ipairs
local GetTime = GetTime
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local type = type
local pairs = pairs
local CreateFrame = CreateFrame
local strfind = strfind
local tinsert = tinsert
local UnitBuff = Pre80API.UnitBuff
local UnitDebuff = Pre80API.UnitDebuff

local module = CompactRaid:GetModule("CornerIndicators")
if not module then return end

module.indicators = {}

local auraGroups = _G["LibBuffGroups-1.0"]

local function FindAura(unit, aura, selfcast, lacks, similar)
	local filter = selfcast and "PLAYER" or ""
	local name, _, icon, count, dispelType, duration, expires, caster, harmful

	if similar then
		name, icon, count, dispelType, duration, expires, caster, harmful = auraGroups:UnitAura(unit, aura)
	else
		name, icon, count, _, duration, expires = UnitBuff(unit, aura, nil, filter)
		if not name then
			harmful = 1
			name, icon, count, _, duration, expires = UnitDebuff(unit, aura, nil, filter)
		end
	end

	if lacks then
		if not name then
			return "", nil, 1, 0, 0, 1 -- Lacks treated as harmful, displays in red always
		end
	else
		if name then
			return name, icon, count or 1, duration or 0, expires or 0, harmful
		end
	end

end

local function Indicator_UpdateStatus(self)
	local db = self.db
	if not db then
		return
	end

	local count, duration, expires = self.count, self.duration, self.expires
	if not count or not duration or not expires then
		return
	end

	local timeLeft
	if duration > 0 and expires > 0 then
		timeLeft = expires - GetTime()
		if timeLeft < 0 then
			timeLeft = 0
		end
	end

	local r, g, b
	if self.harmful then
		r, g, b = 1, 0, 0 -- debuff or lacks color, red always
	else
		r, g, b = db.r1, db.g1, db.b1
		if timeLeft then
			-- Temproray aura
			if db.threshold3 and timeLeft < db.threshold3 then
				r, g, b = db.r3, db.g3, db.b3
			elseif db.threshold2 and timeLeft / duration * 100 < db.threshold2 then
				r, g, b = db.r2, db.g2, db.b2
			end
		end
	end

	local text = self.text
	self.icon:SetVertexColor(r, g, b)
	text:SetTextColor(r, g, b)

	if timeLeft then
		if count > 1 then
			text:SetFormattedText("%d-%d", count, timeLeft)
		else
			text:SetFormattedText("%d", timeLeft)
		end
	else
		text:SetText("N")
	end
end

local function Indicator_OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.2 then
		return
	end
	self.elapsed = 0
	Indicator_UpdateStatus(self)
end

local function Indicator_UpdateAura(self)
	self:Hide()
	local db = self.db
	if not db or not db.aura or db.style == 3 then
		return
	end

	local parent = self:GetParent()
	local unit = parent.unit
	if not unit or not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
		return
	end

	if (db.ignorePhysical and parent.category == 1) or (db.ignoreMagical and parent.category == 2) or (db.ignoreVehicle and parent.inVehicle) or (db.ignoreOutRanged and not parent.inRange) then
		return
	end

	local name, icon, count, duration, expires, harmful = FindAura(unit, db.aura, db.selfcast, db.showlacks, db.checkSimilar)
	if not name then
		return
	end

	self.count, self.duration, self.expires, self.harmful = count, duration, expires, harmful
	self.cooldown:Hide()
	self.countText:Hide()
	if db.style == 0 then
		self:SetScript("OnUpdate", nil)
		self.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
		self.icon:SetVertexColor(1, 1, 1)

		if count > 1 then
			self.countText:SetText(count)
			self.countText:Show()
		end

		if duration > 0 and expires > 0 then
			self.cooldown:Clear()
			self.cooldown:SetCooldown(expires - duration, duration)
			self.cooldown:Show()
		end
	else
		self.icon:SetVertexColor(1, 1, 1)
		self:SetScript("OnUpdate", Indicator_OnUpdate)
		Indicator_UpdateStatus(self)
	end

	self:Show()
end

local function Indicator_SetStyle(self)
	local db = self.db
	if not db then
		return
	end

	if db.style == 3 then
		self:Hide() -- Hidden
	else
		if db.style == 2 then
			-- Numeric
			self.bkgnd:Hide()
			self.icon:Hide()
			self.text:Show()
		else
			if db.style == 1 then
				-- Cube
				self:SetSize(8, 8)
				self.icon:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
			else
				-- icon
				self:SetSize(12, 12)
			end

			self.bkgnd:Show()
			self.icon:Show()
			self.text:Hide()
		end

		self:Show()
		Indicator_UpdateAura(self)
	end
end

local function Indicator_UpdateScale(self)
	local db = self.db
	if not db then
		return
	end

	local scale = db.scale
	if type(scale) ~= "number" or scale < 10 or scale > 300 then
		scale = 100
	end
	self:SetScale(scale / 100)
end

local function Indicator_UpdateOffset(self)
	local db = self.db
	if not db then
		return
	end

	local xoffset, yoffset = db.xoffset, db.yoffset
	if type(xoffset) ~= "number" or  type(yoffset) ~= "number" then
		xoffset, yoffset = 0, 0
	end

	self:ClearAllPoints()
	self:SetPoint(self.key, xoffset + (self.leftSpacing or 0), yoffset)
end

local function Frame_UpdateAura(self)
	local _, indicator
	for _, indicator in pairs(self.cornerIndicators) do
		Indicator_UpdateAura(indicator)
	end
end

local function Frame_OnEvent(self, event, unit)
	if unit and unit == self.unit then
		Frame_UpdateAura(self)
	end
end

local function Frame_OnShow(self)
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_FLAGS")
	self:RegisterEvent("UNIT_CONNECTION")
	Frame_UpdateAura(self)
end

local function Frame_OnHide(self)
	self:UnregisterAllEvents()
end

-- Update the topleft indicator position when role icon shows/hides
function module:OnRoleIconChange(frame, status)
	local indicator = module:GetVisual(frame).cornerIndicators.TOPLEFT
	if indicator then
		indicator.leftSpacing = status and 12 or nil
		indicator:UpdateOffset()
	end
end

function module:OnCreateVisual(visual, unitFrame, dynamic)
	visual:SetAllPoints(unitFrame)
	visual.cornerIndicators = {}
	local _, key
	for _, key in ipairs(module.INDICATOR_KEYS) do
		local indicator = module:CreateIndicator(visual, key)
		visual.cornerIndicators[key] = indicator
		if dynamic then
			indicator.db = module.optionData[key]
			self:UpdateIndicator(indicator, 1, 1, 1, 1)
		end
	end

	visual:SetScript("OnEvent", Frame_OnEvent)
	visual:SetScript("OnShow", Frame_OnShow)
	visual:SetScript("OnHide", Frame_OnHide)
	visual.UpdateAura = Frame_UpdateAura
	visual:Show()
end

function module:CreateIndicator(parent, key)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(8, 8)
	frame:SetPoint(key)
	frame.key = key

	frame.bkgnd = frame:CreateTexture(nil, "BACKGROUND")
	frame.bkgnd:SetAllPoints(frame)
	frame.bkgnd:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
	frame.bkgnd:SetVertexColor(0, 0, 0, 1)

	frame.icon = frame:CreateTexture(nil, "BORDER")
	frame.icon:SetPoint("TOPLEFT", frame.bkgnd, "TOPLEFT", 1, -1)
	frame.icon:SetPoint("BOTTOMRIGHT", frame.bkgnd, "BOTTOMRIGHT", -1, 1)
	frame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	frame.icon:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")

	frame.countText = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	frame.countText:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
	frame.countText:SetJustifyH("RIGHT")
	frame.countText:SetJustifyV("BOTTOM")
	frame.countText:SetPoint("CENTER", 2, -1)

	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	frame.text:SetFont(STANDARD_TEXT_FONT, 9)
	frame.text:SetPoint(key, frame.icon, key)

	frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	frame.cooldown:Raise()
	frame.cooldown:SetReverse(true)

	if strfind(key, "TOP") then
		frame.text:SetJustifyV("TOP")
	elseif strfind(key, "BOTTOM") then
		frame.text:SetJustifyV("BOTTOM")
	end

	if strfind(key, "LEFT") then
		frame.text:SetJustifyH("LEFT")
	elseif strfind(key, "RIGHT") then
		frame.text:SetJustifyH("RIGHT")
	end

	frame.SetStyle = Indicator_SetStyle
	frame.UpdateScale = Indicator_UpdateScale
	frame.UpdateOffset = Indicator_UpdateOffset
	frame.UpdateAura = Indicator_UpdateAura

	tinsert(self.indicators, frame)
	return frame
end

function module:UpdateIndicator(indicator, style, aura, scale, offset)
	if style then
		Indicator_SetStyle(indicator)
		aura = nil
	end

	if aura then
		Indicator_UpdateAura(indicator)
	end

	if scale then
		Indicator_UpdateScale(indicator)
	end

	if offset then
		Indicator_UpdateOffset(indicator)
	end
end

function module:UpdateAllIndicators(key, style, aura, scale, offset)
	local _, indicator
	for _, indicator in ipairs(self.indicators) do
		if not key or indicator.key == key then
			self:UpdateIndicator(indicator, style, aura, scale, offset)
		end
	end
end
