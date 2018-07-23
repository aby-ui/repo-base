------------------------------------------------------------
-- Visual.lua
--
-- Abin
-- 2012/3/19
------------------------------------------------------------

local GetTime = GetTime
local CreateFrame = CreateFrame
local DebuffTypeColor = DebuffTypeColor

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local function RaidDebuffFrame_OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.2 then
		self.elapsed = 0
		local timeLeft = (self.expires or 0) - GetTime()
		if timeLeft > 0 and timeLeft < 15 then
			self.timeText:SetFormattedText("%d", timeLeft)
		else
			self.timeText:SetText()
		end
	end
end

local function RaidDebuffFrame_UpdateDebuff(self)
	local level, icon, count, dispelType, expires

	if module.GetOverrideDebuff then
		icon, count, dispelType, expires = module:GetOverrideDebuff(self.guid)
	end

	if icon then
		level = 5
	else
		level, icon, count, dispelType, expires = module:FindTopDebuff(self.unit) -- only check debuffs if not overridden
	end

	if not level then
		self:SetAlpha(0)
		self:SetScript("OnUpdate", nil)
		return
	end

	local color
	if dispelType and dispelType ~= "none" then
		color = DebuffTypeColor[dispelType]
	end

	if color then
		self.bkgnd:SetVertexColor(color.r, color.g, color.b, 1)
	else
		self.bkgnd:SetVertexColor(0, 0, 0, 0.75)
	end

	self.icon:SetTexture(icon)
	if count and count > 1 then
		self.countText:SetFormattedText("%d", count)
	else
		self.countText:SetText()
	end

	self.expires = expires
	if expires and expires > 0 then
		self:SetScript("OnUpdate", RaidDebuffFrame_OnUpdate)
		RaidDebuffFrame_OnUpdate(self, 1)
	else
		self.timeText:SetText()
		self:SetScript("OnUpdate", nil)
	end

	self:SetAlpha(1)
end

local function Frame_OnEvent(self, event, unit)
	if unit and unit == self.unit then
		RaidDebuffFrame_UpdateDebuff(self)
	end
end

local function Frame_OnShow(self)
	self:RegisterEvent("UNIT_AURA")
	RaidDebuffFrame_UpdateDebuff(self)
end

local function Frame_OnHide(self)
	self:UnregisterAllEvents()
end

function module:OnCreateVisual(visual, unitFrame, dynamic)
	visual:SetSize(20, 20)
	visual:SetScale(module.db.scale / 100)
	visual:SetPoint("CENTER", module.db.xoffset, module.db.yoffset)

	visual.bkgnd = visual:CreateTexture(nil, "BORDER")
	visual.bkgnd:SetAllPoints(visual)
	visual.bkgnd:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")

	visual.icon = visual:CreateTexture(nil, "ARTWORK")
	visual.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	visual.icon:SetPoint("TOPLEFT", 1, -1)
	visual.icon:SetPoint("BOTTOMRIGHT", -1, 1)

	visual.countText = visual:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
	visual.countText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	visual.countText:SetPoint("BOTTOMRIGHT", 0, 1)

	visual.timeText = visual:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
	visual.timeText:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
	visual.timeText:SetPoint("TOP", visual, "BOTTOM")

	visual:SetScript("OnEvent", Frame_OnEvent)
	visual:SetScript("OnShow", Frame_OnShow)
	visual:SetScript("OnHide", Frame_OnHide)

	visual.UpdateDebuff = RaidDebuffFrame_UpdateDebuff

	if self:GetActiveDebuffs() then
		visual:Show()
	end
end
