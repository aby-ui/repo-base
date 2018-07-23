local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Auras"))
end
local L = Gladius.L
local LSM

-- global functions
local _G = _G
local ceil = math.ceil
local pairs = pairs
local rawget = rawget
local setmetatable = setmetatable
local strfind = string.find

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture
local UnitAura = UnitAura

local Auras = Gladius:NewModule("Auras", false, true, {
	aurasBuffsAttachTo = "CastBar",
	aurasBuffsAnchor = "TOPLEFT",
	aurasBuffsRelativePoint = "BOTTOMLEFT",
	aurasBuffs = false,
	aurasBuffsGrow = "DOWNRIGHT",
	aurasBuffsSpacingX = 0,
	aurasBuffsSpacingY = 0,
	aurasBuffsPerColumn = 10,
	aurasBuffsMax = 10,
	aurasBuffsHeight = 16,
	aurasBuffsWidth = 16,
	aurasBuffsOffsetX = 0,
	aurasBuffsOffsetY = 0,
	aurasBuffsGloss = false,
	aurasBuffsGlossColor = {r = 1, g = 1, b = 1, a = 0.4},
	aurasBuffsTrackerCooldown = true,
	aurasBuffsTrackerCooldownReverse = true,
	aurasBuffsHideTimer = true,
	aurasDebuffsAttachTo = "ClassIcon",
	aurasDebuffsAnchor = "BOTTOMLEFT",
	aurasDebuffsRelativePoint = "TOPLEFT",
	aurasDebuffs = false,
	aurasDebuffsGrow = "UPRIGHT",
	aurasDebuffsSpacingX = 0,
	aurasDebuffsSpacingY = 0,
	aurasDebuffsPerColumn = 10,
	aurasDebuffsMax = 10,
	aurasDebuffsHeight = 16,
	aurasDebuffsWidth = 16,
	aurasDebuffsOffsetX = 0,
	aurasDebuffsOffsetY = 0,
	aurasDebuffsGloss = false,
	aurasDebuffsGlossColor = {r = 1, g = 1, b = 1, a = 0.4},
	aurasDebuffsTrackerCooldown = true,
	aurasDebuffsTrackerCooldownReverse = true,
	aurasDebuffsHideTimer = true,
},
{
	"Bottom Single Row"
})

function Auras:OnEnable()
	self:RegisterEvent("UNIT_AURA")
	LSM = Gladius.LSM
	self.buffFrame = self.buffFrame or { }
	self.debuffFrame = self.debuffFrame or { }
end

function Auras:OnDisable()
	self:UnregisterAllEvents()
	for unit in pairs(self.buffFrame) do
		self.buffFrame[unit]:Hide()
		for i = 1, 40 do
			self.buffFrame[unit][i]:Hide()
			self.buffFrame[unit][i].tooltip:Hide()
		end
	end
	for unit in pairs(self.debuffFrame) do
		self.debuffFrame[unit]:Hide()
		for i = 1, 40 do
			self.debuffFrame[unit][i]:Hide()
			self.debuffFrame[unit][i].tooltip:Hide()
		end
	end
end

--[[function Auras:SetTemplate(template)
	if template == 1 then
		Gladius.db.aurasBuffsGrow = "DOWNRIGHT"
		Gladius.db.aurasBuffsAttachTo = "CastBar"
		Gladius.db.aurasBuffsRelativePoint = "BOTTOMLEFT"
		Gladius.db.aurasBuffsAnchor = "TOPLEFT"
		Gladius.db.aurasBuffsSpacingX = 1
		Gladius.db.aurasBuffsHeight = 17
		Gladius.db.aurasBuffsMax = Gladius.db.modules.Trinket and 8 or 6
		Gladius.db.aurasBuffsOffsetY = - 1
		Gladius.db.aurasDebuffsGrow = "DOWNLEFT"
		Gladius.db.aurasDebuffsAttachTo = "Trinket"
		Gladius.db.aurasDebuffsRelativePoint = "BOTTOMRIGHT"
		Gladius.db.aurasDebuffsAnchor = "TOPRIGHT"
		Gladius.db.aurasDebuffsSpacingX = 1
		Gladius.db.aurasDebuffsHeight = 17
		Gladius.db.aurasDebuffsMax = Gladius.db.modules.Trinket and 8 or 6
		Gladius.db.aurasDebuffsOffsetY = - 1
	end
end]]

function Auras:GetAttachTo()
	return Gladius.db.aurasAttachTo
end

function Auras:GetFrame(unit)
	return self.buffFrame[unit]
end

function Auras:GetIndicatorHeight()
	local height = 0
	if Gladius.db.aurasBuffs then
		height = height + Gladius.db.aurasBuffsHeight * ceil(Gladius.db.aurasBuffsMax / Gladius.db.aurasBuffsPerColumn)
	end
	if Gladius.db.aurasDebuffs then
		height = height + Gladius.db.aurasDebuffsHeight * ceil(Gladius.db.aurasDebuffsMax / Gladius.db.aurasDebuffsPerColumn)
	end
	return height
end

function Auras:UNIT_AURA(event, unit)
	if unit == nil then
		return
	end
	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	-- buff frame
	if Gladius.db.aurasBuffs then
		for i = 1, Gladius.db.aurasBuffsMax do
			local name, icon, count, dispelType, duration, expires, caster, isStealable = UnitAura(unit, i, "HELPFUL")
			if not self.buffFrame[unit] or not self.buffFrame[unit][i] then
				break
			end
			if name then
				self.buffFrame[unit][i].texture:SetTexture(icon)
				Gladius:Call(Gladius.modules.Timer, "SetTimer", self.buffFrame[unit][i], duration)
				self.buffFrame[unit][i]:Show()
			else
				self.buffFrame[unit][i]:Hide()
			end
		end
	end
	-- debuff frame
	if Gladius.db.aurasDebuffs then
		for i = 1, Gladius.db.aurasDebuffsMax do
			local name, icon, count, dispelType, duration, expires, caster, isStealable = UnitAura(unit, i, "HARMFUL")
			if not self.debuffFrame[unit] or not self.debuffFrame[unit][i] then
				break
			end
			if name then
				self.debuffFrame[unit][i].texture:SetTexture(icon)
				Gladius:Call(Gladius.modules.Timer, "SetTimer", self.debuffFrame[unit][i], duration)
				self.debuffFrame[unit][i]:Show()
			else
				self.debuffFrame[unit][i]:Hide()
			end
		end
	end
end

local function updateTooltip(f, unit, index, filter)
	if GameTooltip:IsOwned(f) then
		GameTooltip:SetUnitAura(unit, index, filter)
	end
end

function Auras:UpdateColors(unit)
	if Gladius.db.aurasBuffs then
		for i = 1, Gladius.db.aurasBuffsMax do
			self.buffFrame[unit][i].normalTexture:SetVertexColor(Gladius.db.aurasBuffsGlossColor.r, Gladius.db.aurasBuffsGlossColor.g, Gladius.db.aurasBuffsGlossColor.b, Gladius.db.aurasBuffsGloss and Gladius.db.aurasBuffsGlossColor.a or 0)
		end
	end
	if Gladius.db.aurasDebuffs then
		for i = 1, Gladius.db.aurasDebuffsMax do
			self.debuffFrame[unit][i].normalTexture:SetVertexColor(Gladius.db.aurasDebuffsGlossColor.r, Gladius.db.aurasDebuffsGlossColor.g, Gladius.db.aurasDebuffsGlossColor.b, Gladius.db.aurasDebuffsGloss and Gladius.db.aurasDebuffsGlossColor.a or 0)
		end
	end
end

function Auras:CreateFrame(unit)
	local button = Gladius.buttons[unit]
	if not button then
		return
	end
	-- create buff frame
	if not self.buffFrame[unit] and Gladius.db.aurasBuffs then
		self.buffFrame[unit] = CreateFrame("Frame", "Gladius"..self.name.."BuffFrame"..unit, button)
		self.buffFrame[unit]:EnableMouse(false)
		for i = 1, 40 do
			self.buffFrame[unit][i] = CreateFrame("Button", "Gladius"..self.name.."BuffFrameIcon"..i..unit, button, "ActionButtonTemplate")
			self.buffFrame[unit][i].tooltip = CreateFrame("Frame", nil, self.buffFrame[unit][i])
			self.buffFrame[unit][i].tooltip:SetAllPoints(self.buffFrame[unit][i])
			self.buffFrame[unit][i].tooltip:SetScript("OnEnter", function(f)
				GameTooltip:SetOwner(self.buffFrame[unit][i], "ANCHOR_RIGHT")
				if Gladius.test then
					GameTooltip:SetSpellByID(21562)
				else
					GameTooltip:SetUnitAura(unit, i, "HELPFUL")
					f:SetScript("OnUpdate", function(f)
						updateTooltip(f, unit, i, "HELPFUL")
					end)
				end
			end)
			self.buffFrame[unit][i].tooltip:SetScript("OnLeave", function(f)
				f:SetScript("OnUpdate", nil)
				GameTooltip:Hide()
			end)
			self.buffFrame[unit][i]:EnableMouse(false)
			self.buffFrame[unit][i]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
			self.buffFrame[unit][i].texture = _G[self.buffFrame[unit][i]:GetName().."Icon"]
			self.buffFrame[unit][i].normalTexture = _G[self.buffFrame[unit][i]:GetName().."NormalTexture"]
			self.buffFrame[unit][i].cooldown = _G[self.buffFrame[unit][i]:GetName().."Cooldown"]
			self.buffFrame[unit][i].cooldown:SetReverse(Gladius.db.aurasBuffsTrackerCooldownReverse)
			Gladius:Call(Gladius.modules.Timer, "RegisterTimer", self.buffFrame[unit][i], Gladius.db.aurasBuffsTrackerCooldown, Gladius.db.aurasBuffsHideTimer)
		end
	end
	-- create debuff frame
	if not self.debuffFrame[unit] and Gladius.db.aurasDebuffs then
		self.debuffFrame[unit] = CreateFrame("Frame", "Gladius"..self.name.."DebuffFrame"..unit, button)
		self.debuffFrame[unit]:EnableMouse(false)
		for i = 1, 40 do
			self.debuffFrame[unit][i] = CreateFrame("Button", "Gladius"..self.name.."DebuffFrameIcon"..i..unit, button, "ActionButtonTemplate")
			self.debuffFrame[unit][i].tooltip = CreateFrame("Frame", nil, self.debuffFrame[unit][i])
			self.debuffFrame[unit][i].tooltip:SetAllPoints(self.debuffFrame[unit][i])
			self.debuffFrame[unit][i].tooltip:SetScript("OnEnter", function(f)
				GameTooltip:SetOwner(self.debuffFrame[unit][i], "ANCHOR_RIGHT")
				if Gladius.test then
					GameTooltip:SetSpellByID(589)
				else
					GameTooltip:SetUnitAura(unit, i, "HARMFUL")
					f:SetScript("OnUpdate", function(f)
						updateTooltip(f, unit, i, "HARMFUL")
					end)
				end
			end)
			self.debuffFrame[unit][i].tooltip:SetScript("OnLeave", function(f)
				f:SetScript("OnUpdate", nil)
				GameTooltip:Hide()
			end)
			self.debuffFrame[unit][i]:EnableMouse(false)
			self.debuffFrame[unit][i]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
			self.debuffFrame[unit][i].texture = _G[self.debuffFrame[unit][i]:GetName().."Icon"]
			self.debuffFrame[unit][i].normalTexture = _G[self.debuffFrame[unit][i]:GetName().."NormalTexture"]
			self.debuffFrame[unit][i].cooldown = _G[self.debuffFrame[unit][i]:GetName().."Cooldown"]
			self.debuffFrame[unit][i].cooldown:SetReverse(Gladius.db.aurasDebuffsTrackerCooldownReverse)
			Gladius:Call(Gladius.modules.Timer, "RegisterTimer", self.debuffFrame[unit][i], Gladius.db.aurasDebuffsTrackerCooldown, Gladius.db.aurasDebuffsHideTimer)
		end
	end
	if not Gladius.test then
		self:UNIT_AURA(nil, unit)
	end
end

function Auras:Update(unit)
	-- create frame
	if not self.buffFrame[unit] or not self.debuffFrame[unit] then
		self:CreateFrame(unit)
	end
	-- update buff frame
	if Gladius.db.aurasBuffs then
		self.buffFrame[unit]:ClearAllPoints()
		-- anchor point
		local parent = Gladius:GetParent(unit, Gladius.db.aurasBuffsAttachTo)
		self.buffFrame[unit]:SetPoint(Gladius.db.aurasBuffsAnchor, parent, Gladius.db.aurasBuffsRelativePoint, Gladius.db.aurasBuffsOffsetX, Gladius.db.aurasBuffsOffsetY)
		-- size
		self.buffFrame[unit]:SetWidth(Gladius.db.aurasBuffsWidth * Gladius.db.aurasBuffsPerColumn + Gladius.db.aurasBuffsSpacingX * Gladius.db.aurasBuffsPerColumn)
		self.buffFrame[unit]:SetHeight(Gladius.db.aurasBuffsHeight * ceil(Gladius.db.aurasBuffsMax / Gladius.db.aurasBuffsPerColumn) + (Gladius.db.aurasBuffsSpacingY * (ceil(Gladius.db.aurasBuffsMax / Gladius.db.aurasBuffsPerColumn) + 1)))
		-- icon points
		local anchor, parent, relativePoint, offsetX, offsetY
		local start, startAnchor = 1, self.buffFrame[unit]
		-- grow anchor
		local grow1, grow2, grow3, startRelPoint
		if Gladius.db.aurasBuffsGrow == "DOWNRIGHT" then
			grow1, grow2, grow3, startRelPoint = "TOPLEFT", "BOTTOMLEFT", "TOPRIGHT", "TOPLEFT"
		elseif Gladius.db.aurasBuffsGrow == "DOWNLEFT" then
			grow1, grow2, grow3, startRelPoint = "TOPRIGHT", "BOTTOMRIGHT", "TOPLEFT", "TOPRIGHT"
		elseif Gladius.db.aurasBuffsGrow == "UPRIGHT" then
			grow1, grow2, grow3, startRelPoint = "BOTTOMLEFT", "TOPLEFT", "BOTTOMRIGHT", "BOTTOMLEFT"
		elseif Gladius.db.aurasBuffsGrow == "UPLEFT" then
			grow1, grow2, grow3, startRelPoint = "BOTTOMRIGHT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"
		end
		for i = 1, Gladius.db.aurasBuffsMax do
			self.buffFrame[unit][i]:ClearAllPoints()
			if Gladius.db.aurasBuffsMax >= i then
				if start == 1 then
					anchor, parent, relativePoint, offsetX, offsetY = grow1, startAnchor, startRelPoint, 0, strfind(Gladius.db.aurasBuffsGrow, "DOWN") and - Gladius.db.aurasBuffsSpacingY or Gladius.db.aurasBuffsSpacingY
				else
					anchor, parent, relativePoint, offsetX, offsetY = grow1, self.buffFrame[unit][i - 1], grow3, strfind(Gladius.db.aurasBuffsGrow, "LEFT") and - Gladius.db.aurasBuffsSpacingX or Gladius.db.aurasBuffsSpacingX, 0
					if start == Gladius.db.aurasBuffsPerColumn then
						start = 0
						startAnchor = self.buffFrame[unit][i - Gladius.db.aurasBuffsPerColumn + 1]
						startRelPoint = grow2
					end
				end
				start = start + 1
			end
			self.buffFrame[unit][i]:SetPoint(anchor, parent, relativePoint, offsetX, offsetY)
			self.buffFrame[unit][i]:SetWidth(Gladius.db.aurasBuffsWidth)
			self.buffFrame[unit][i]:SetHeight(Gladius.db.aurasBuffsHeight)
			-- style action button
			self.buffFrame[unit][i].normalTexture:SetHeight(self.buffFrame[unit][i]:GetHeight() + self.buffFrame[unit][i]:GetHeight() * 0.4)
			self.buffFrame[unit][i].normalTexture:SetWidth(self.buffFrame[unit][i]:GetWidth() + self.buffFrame[unit][i]:GetWidth() * 0.4)
			self.buffFrame[unit][i].normalTexture:ClearAllPoints()
			self.buffFrame[unit][i].normalTexture:SetPoint("CENTER", 0, 0)
			self.buffFrame[unit][i]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
			self.buffFrame[unit][i].texture:ClearAllPoints()
			self.buffFrame[unit][i].texture:SetPoint("TOPLEFT", self.buffFrame[unit][i], "TOPLEFT")
			self.buffFrame[unit][i].texture:SetPoint("BOTTOMRIGHT", self.buffFrame[unit][i], "BOTTOMRIGHT")
			self.buffFrame[unit][i].normalTexture:SetVertexColor(Gladius.db.aurasBuffsGlossColor.r, Gladius.db.aurasBuffsGlossColor.g, Gladius.db.aurasBuffsGlossColor.b, Gladius.db.aurasBuffsGloss and Gladius.db.aurasBuffsGlossColor.a or 0)
		end
		-- hide
		self.buffFrame[unit]:Hide()
	end
	-- update debuff frame
	if Gladius.db.aurasDebuffs then
		self.debuffFrame[unit]:ClearAllPoints()
		-- anchor point
		local parent = Gladius:GetParent(unit, Gladius.db.aurasDebuffsAttachTo)
		self.debuffFrame[unit]:SetPoint(Gladius.db.aurasDebuffsAnchor, parent, Gladius.db.aurasDebuffsRelativePoint, Gladius.db.aurasDebuffsOffsetX, Gladius.db.aurasDebuffsOffsetY)
		-- size
		self.debuffFrame[unit]:SetWidth(Gladius.db.aurasDebuffsWidth * Gladius.db.aurasDebuffsPerColumn + Gladius.db.aurasDebuffsSpacingX * Gladius.db.aurasDebuffsPerColumn)
		self.debuffFrame[unit]:SetHeight(Gladius.db.aurasDebuffsHeight * ceil(Gladius.db.aurasDebuffsMax / Gladius.db.aurasDebuffsPerColumn) + (Gladius.db.aurasDebuffsSpacingY * (ceil(Gladius.db.aurasDebuffsMax / Gladius.db.aurasDebuffsPerColumn) + 1)))
		-- icon points
		local anchor, parent, relativePoint, offsetX, offsetY
		local start, startAnchor = 1, self.debuffFrame[unit]
		-- grow anchor
		local grow1, grow2, grow3, startRelPoint
		if Gladius.db.aurasDebuffsGrow == "DOWNRIGHT" then
			grow1, grow2, grow3, startRelPoint = "TOPLEFT", "BOTTOMLEFT", "TOPRIGHT", "TOPLEFT"
		elseif Gladius.db.aurasDebuffsGrow == "DOWNLEFT" then
			grow1, grow2, grow3, startRelPoint = "TOPRIGHT", "BOTTOMRIGHT", "TOPLEFT", "TOPRIGHT"
		elseif Gladius.db.aurasDebuffsGrow == "UPRIGHT" then
			grow1, grow2, grow3, startRelPoint = "BOTTOMLEFT", "TOPLEFT", "BOTTOMRIGHT", "BOTTOMLEFT"
		elseif Gladius.db.aurasDebuffsGrow == "UPLEFT" then
			grow1, grow2, grow3, startRelPoint = "BOTTOMRIGHT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"
		end
		for i = 1, Gladius.db.aurasDebuffsMax do
			self.debuffFrame[unit][i]:ClearAllPoints()
			if Gladius.db.aurasDebuffsMax >= i then
				if start == 1 then
					anchor, parent, relativePoint, offsetX, offsetY = grow1, startAnchor, startRelPoint, 0, strfind(Gladius.db.aurasDebuffsGrow, "DOWN") and - Gladius.db.aurasDebuffsSpacingY or Gladius.db.aurasDebuffsSpacingY
				else
					anchor, parent, relativePoint, offsetX, offsetY = grow1, self.debuffFrame[unit][i - 1], grow3, strfind(Gladius.db.aurasDebuffsGrow, "LEFT") and - Gladius.db.aurasDebuffsSpacingX or Gladius.db.aurasDebuffsSpacingX, 0
					if start == Gladius.db.aurasDebuffsPerColumn then
						start = 0
						startAnchor = self.debuffFrame[unit][i - Gladius.db.aurasDebuffsPerColumn + 1]
						startRelPoint = grow2
					end
				end
				start = start + 1
			end
			self.debuffFrame[unit][i]:SetPoint(anchor, parent, relativePoint, offsetX, offsetY)
			self.debuffFrame[unit][i]:SetWidth(Gladius.db.aurasDebuffsWidth)
			self.debuffFrame[unit][i]:SetHeight(Gladius.db.aurasDebuffsHeight)
			-- style action button
			self.debuffFrame[unit][i].normalTexture:SetHeight(self.debuffFrame[unit][i]:GetHeight() + self.debuffFrame[unit][i]:GetHeight() * 0.4)
			self.debuffFrame[unit][i].normalTexture:SetWidth(self.debuffFrame[unit][i]:GetWidth() + self.debuffFrame[unit][i]:GetWidth() * 0.4)
			self.debuffFrame[unit][i].normalTexture:ClearAllPoints()
			self.debuffFrame[unit][i].normalTexture:SetPoint("CENTER", 0, 0)
			self.debuffFrame[unit][i]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
			self.debuffFrame[unit][i].texture:ClearAllPoints()
			self.debuffFrame[unit][i].texture:SetPoint("TOPLEFT", self.debuffFrame[unit][i], "TOPLEFT")
			self.debuffFrame[unit][i].texture:SetPoint("BOTTOMRIGHT", self.debuffFrame[unit][i], "BOTTOMRIGHT")
			self.debuffFrame[unit][i].normalTexture:SetVertexColor(Gladius.db.aurasDebuffsGlossColor.r, Gladius.db.aurasDebuffsGlossColor.g, Gladius.db.aurasDebuffsGlossColor.b, Gladius.db.aurasDebuffsGloss and Gladius.db.aurasDebuffsGlossColor.a or 0)
		end
		-- hide
		self.debuffFrame[unit]:Hide()
	end
	-- event
	if not Gladius.db.aurasDebuffs and not Gladius.db.aurasBuffs then
		self:UnregisterAllEvents()
	else
		self:RegisterEvent("UNIT_AURA")
	end
end

function Auras:Show(unit)
	-- show/hide buff frame
	if Gladius.db.aurasBuffs then
		if self.buffFrame[unit] then
			self.buffFrame[unit]:Show()
			for i = 1, Gladius.db.aurasBuffsMax do
				self.buffFrame[unit][i]:Show()
			end
			for i = Gladius.db.aurasBuffsMax + 1, 40 do
				self.buffFrame[unit][i]:Hide()
			end
		end
	else
		if self.buffFrame[unit] then
			self.buffFrame[unit]:Hide()
			for i = 1, 40 do
				self.buffFrame[unit][i]:Hide()
			end
		end
	end
	-- show/hide debuff frame
	if Gladius.db.aurasDebuffs then
		if self.debuffFrame[unit] then
			self.debuffFrame[unit]:Show()
			for i = 1, Gladius.db.aurasDebuffsMax do
				self.debuffFrame[unit][i]:Show()
			end
			for i = Gladius.db.aurasDebuffsMax + 1, 40 do
				self.debuffFrame[unit][i]:Hide()
			end
		end
	else
		if self.debuffFrame[unit] then
			self.debuffFrame[unit]:Hide()
			for i = 1, 40 do
				self.debuffFrame[unit][i]:Hide()
			end
		end
	end
end

function Auras:Reset(unit)
	if self.buffFrame[unit] then
		-- hide buff frame
		self.buffFrame[unit]:Hide()
		for i = 1, 40 do
			self.buffFrame[unit][i].texture:SetTexture("")
			self.buffFrame[unit][i]:Hide()
		end
	end
	if self.debuffFrame[unit] then
		-- hide debuff frame
		self.debuffFrame[unit]:Hide()
		for i = 1, 40 do
			self.debuffFrame[unit][i].texture:SetTexture("")
			self.debuffFrame[unit][i]:Hide()
		end
	end
end

function Auras:Test(unit)
	-- test buff frame
	local testBuff = GetSpellTexture(21562)
	if self.buffFrame[unit] then
		for i = 1, Gladius.db.aurasBuffsMax do
			self.buffFrame[unit][i].texture:SetTexture(testBuff)
			self.buffFrame[unit][i].cooldown:SetReverse(Gladius.db.aurasBuffsTrackerCooldownReverse)
			Gladius:Call(Gladius.modules.Timer, "RegisterTimer", self.buffFrame[unit][i], Gladius.db.aurasBuffsTrackerCooldown, Gladius.db.aurasBuffsHideTimer)
			Gladius:Call(Gladius.modules.Timer, "SetTimer", self.buffFrame[unit][i], 10)
		end
	end
	-- test debuff frame
	local testDebuff = GetSpellTexture(589)
	if self.debuffFrame[unit] then
		for i = 1, Gladius.db.aurasDebuffsMax do
			self.debuffFrame[unit][i].texture:SetTexture(testDebuff)
			self.debuffFrame[unit][i].cooldown:SetReverse(Gladius.db.aurasDebuffsTrackerCooldownReverse)
			Gladius:Call(Gladius.modules.Timer, "RegisterTimer", self.debuffFrame[unit][i], Gladius.db.aurasDebuffsTrackerCooldown, Gladius.db.aurasDebuffsHideTimer)
			Gladius:Call(Gladius.modules.Timer, "SetTimer", self.debuffFrame[unit][i], 10)
		end
	end
end

function Auras:GetOptions()
	local options = {
		buffs = {
			type = "group",
			name = L["Buffs"],
			childGroups = "tab",
			order = 1,
			args = {
				general = {
					type = "group",
					name = L["General"],
					order = 1,
					args = {
						widget = {
							type = "group",
							name = L["Widget"],
							desc = L["Widget settings"],
							inline = true,
							order = 1,
							args = {
								aurasBuffs = {
									type = "toggle",
									name = L["Auras Buffs"],
									desc = L["Toggle aura buffs"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 5,
								},
								aurasBuffsGrow = {
									type = "select",
									name = L["Auras Column Grow"],
									desc = L["Grow direction of the auras"],
									values = function()
										return {
											["UPLEFT"] = L["Up Left"],
											["UPRIGHT"] = L["Up Right"],
											["DOWNLEFT"] = L["Down Left"],
											["DOWNRIGHT"] = L["Down Right"],
										}
									end,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 10,
								},
								sep = {
									type = "description",
									name = "",
									width = "full",
									order = 13,
								},
								aurasBuffsPerColumn = {
									type = "range",
									name = L["Aura Icons Per Column"],
									desc = L["Number of aura icons per column"],
									min = 1,
									max = 50,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 15,
								},
								aurasBuffsMax = {
									type = "range",
									name = L["Aura Icons Max"],
									desc = L["Number of max buffs"],
									min = 1,
									max = 40,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 20,
								},
								sep2 = {
									type = "description",
									name = "",
									width = "full",
									order = 23,
								},
								aurasBuffsGloss = {
									type = "toggle",
									name = L["Auras Gloss"],
									desc = L["Toggle gloss on the auras icon"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 25,
								},
								aurasBuffsGlossColor = {
									type = "color",
									name = L["Auras Gloss Color"],
									desc = L["Color of the auras icon gloss"],
									get = function(info)
										return Gladius:GetColorOption(info)
									end,
									set = function(info, r, g, b, a)
										return Gladius:SetColorOption(info, r, g, b, a)
									end,
									hasAlpha = true,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 30,
								},
								sep3 = {
									type = "description",
									name = "",
									width = "full",
									order = 32,
								},
								aurasBuffsTrackerCooldown = {
									type = "toggle",
									name = L["Buffs Cooldown Spiral"],
									desc = L["Display the cooldown spiral for buffs"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 35,
								},
								aurasBuffsTrackerCooldownReverse = {
									type = "toggle",
									name = L["Buffs Cooldown Reverse"],
									desc = L["Invert the dark/bright part of the cooldown spiral"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 40,
								},
								aurasBuffsHideTimer = {
									type = "toggle",
									name = L["Hide Buff Timers"],
									desc = L["Hides the default timer on the buff frames."],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 45,
								},
							},
						},
						size = {
							type = "group",
							name = L["Size"],
							desc = L["Size settings"],
							inline = true,
							order = 2,
							args = {
								aurasBuffsWidth = {
									type = "range",
									name = L["Aura Icon Width"],
									desc = L["Width of the aura icons"],
									min = 10,
									max = 100,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 5,
								},
								aurasBuffsHeight = {
									type = "range",
									name = L["Aura Icon Height"],
									desc = L["Height of the aura icon"],
									min = 10,
									max = 100,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 10,
								},
								sep = {
									type = "description",
									name = "",
									width = "full",
									order = 13,
								},
								aurasBuffsSpacingY = {
									type = "range",
									name = L["Auras Spacing Vertical"],
									desc = L["Vertical spacing of the auras"],
									min = 0,
									max = 30,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 15,
								},
								aurasBuffsSpacingX = {
									type = "range",
									name = L["Auras Spacing Horizontal"],
									desc = L["Horizontal spacing of the auras"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									min = 0,
									max = 30,
									step = 1,
									order = 20,
								},
							},
						},
						position = {
							type = "group",
							name = L["Position"],
							desc = L["Position settings"],
							inline = true,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 3,
							args = {
								aurasBuffsAttachTo = {
									type = "select",
									name = L["Auras Attach To"],
									desc = L["Attach auras to the given frame"],
									values = function()
										return Gladius:GetModules(self.name)
									end,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									width = "double",
									order = 5,
								},
								sep = {
									type = "description",
									name = "",
									width = "full",
									order = 7,
								},
								aurasBuffsAnchor = {
									type = "select",
									name = L["Auras Anchor"],
									desc = L["Anchor of the auras"],
									values = function()
										return Gladius:GetPositions()
									end,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 10,
								},
								aurasBuffsRelativePoint = {
									type = "select",
									name = L["Auras Relative Point"],
									desc = L["Relative point of the auras"],
									values = function()
										return Gladius:GetPositions()
									end,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 15,
								},
								sep2 = {
									type = "description",
									name = "",
									width = "full",
									order = 17,
								},
								aurasBuffsOffsetX = {
									type = "range",
									name = L["Auras Offset X"],
									desc = L["X offset of the auras"],
									min = - 100,
									max = 100,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 20,
								},
								aurasBuffsOffsetY = {
									type = "range",
									name = L["Auras Offset Y"],
									desc = L["Y offset of the auras"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									min = - 50,
									max = 50,
									step = 1,
									order = 25,
								},
							},
						},
					},
				},
				--[[filter = {
					type = "group",
					name = L["Filter"],
					childGroups = "tree",
					hidden = function()
						return not Gladius.db.advancedOptions
					end,
					order = 2,
					args = {
						whitelist = {
							type = "group",
							name = L["Whitelist"],
							order = 1,
							args = {
							},
						},
						blacklist = {
							type = "group",
							name = L["Blacklist"],
							order = 2,
							args = {
							},
						},
						filterFunction = {
							type = "group",
							name = L["Filter Function"],
							order = 3,
							args = {
							},
						},
					},
				},]]
			},
		},
		debuffs = {
			type = "group",
			name = L["Debuffs"],
			childGroups = "tab",
			order = 2,
			args = {
				general = {
					type = "group",
					name = L["General"],
					order = 1,
					args = {
						widget = {
							type = "group",
							name = L["Widget"],
							desc = L["Widget settings"],
							inline = true,
							order = 1,
							args = {
								aurasDebuffs = {
									type = "toggle",
									name = L["Auras Debuffs"],
									desc = L["Toggle aura debuffs"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 5,
								},
								aurasDebuffsGrow = {
									type = "select",
									name = L["Auras Column Grow"],
									desc = L["Grow direction of the auras"],
									values = function()
										return {
											["UPLEFT"] = L["Up Left"],
											["UPRIGHT"] = L["Up Right"],
											["DOWNLEFT"] = L["Down Left"],
											["DOWNRIGHT"] = L["Down Right"],
										}
									end,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 10,
								},
								sep = {
									type = "description",
									name = "",
									width = "full",
									order = 13,
								},
								aurasDebuffsPerColumn = {
									type = "range",
									name = L["Aura Icons Per Column"],
									desc = L["Number of aura icons per column"],
									min = 1,
									max = 50,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 15,
								},
								aurasDebuffsMax = {
									type = "range",
									name = L["Aura Icons Max"],
									desc = L["Number of max Debuffs"],
									min = 1,
									max = 40,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 20,
								},
								sep2 = {
									type = "description",
									name = "",
									width = "full",
									order = 23,
								},
								aurasDebuffsGloss = {
									type = "toggle",
									name = L["Auras Gloss"],
									desc = L["Toggle gloss on the auras icon"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 25,
								},
								aurasDebuffsGlossColor = {
									type = "color",
									name = L["Auras Gloss Color"],
									desc = L["Color of the auras icon gloss"],
									get = function(info)
										return Gladius:GetColorOption(info)
									end,
									set = function(info, r, g, b, a)
										return Gladius:SetColorOption(info, r, g, b, a)
									end,
									hasAlpha = true,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 30,
								},
								sep3 = {
									type = "description",
									name = "",
									width = "full",
									order = 32,
								},
								aurasDebuffsTrackerCooldown = {
									type = "toggle",
									name = L["Debuffs Cooldown Spiral"],
									desc = L["Display the cooldown spiral for debuffs"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 35,
								},
								aurasDebuffsTrackerCooldownReverse = {
									type = "toggle",
									name = L["Debuffs Cooldown Reverse"],
									desc = L["Invert the dark/bright part of the cooldown spiral"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 40,
								},
								aurasDebuffsHideTimer = {
									type = "toggle",
									name = L["Hide Debuff Timers"],
									desc = L["Hides the default timer on the debuff frames."],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									hidden = function()
										return not Gladius.db.advancedOptions
									end,
									order = 45,
								},
							},
						},
						size = {
							type = "group",
							name = L["Size"],
							desc = L["Size settings"],
							inline = true,
							order = 2,
							args = {
								aurasDebuffsWidth = {
									type = "range",
									name = L["Aura Icon Width"],
									desc = L["Width of the aura icons"],
									min = 10,
									max = 100,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 5,
								},
								aurasDebuffsHeight = {
									type = "range",
									name = L["Aura Icon Height"],
									desc = L["Height of the aura icon"],
									min = 10,
									max = 100,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 10,
								},
								sep = {
									type = "description",
									name = "",
									width = "full",
									order = 13,
								},
								aurasDebuffsSpacingY = {
									type = "range",
									name = L["Auras Spacing Vertical"],
									desc = L["Vertical spacing of the auras"],
									min = 0,
									max = 30,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 15,
								},
								aurasDebuffsSpacingX = {
									type = "range",
									name = L["Auras Spacing Horizontal"],
									desc = L["Horizontal spacing of the auras"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									min = 0,
									max = 30,
									step = 1,
									order = 20,
								},
							},
						},
						position = {
							type = "group",
							name = L["Position"],
							desc = L["Position settings"],
							inline = true,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 3,
							args = {
								aurasDebuffsAttachTo = {
									type = "select",
									name = L["Auras Attach To"],
									desc = L["Attach auras to the given frame"],
									values = function()
										return Gladius:GetModules(self.name)
									end,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									width = "double",
									order = 5,
								},
								sep = {
									type = "description",
									name = "",
									width = "full",
									order = 7,
								},
								aurasDebuffsAnchor = {
									type = "select",
									name = L["Auras Anchor"],
									desc = L["Anchor of the auras"],
									values = function()
										return Gladius:GetPositions()
									end,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 10,
								},
								aurasDebuffsRelativePoint = {
									type = "select",
									name = L["Auras Relative Point"],
									desc = L["Relative point of the auras"],
									values = function()
										return Gladius:GetPositions()
									end,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 15,
								},
								sep2 = {
									type = "description",
									name = "",
									width = "full",
									order = 17,
								},
								aurasDebuffsOffsetX = {
									type = "range",
									name = L["Auras Offset X"],
									desc = L["X offset of the auras"],
									min = -100,
									max = 100,
									step = 1,
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									order = 20,
								},
								aurasDebuffsOffsetY = {
									type = "range",
									name = L["Auras Offset Y"],
									desc = L["Y offset of the auras"],
									disabled = function()
										return not Gladius.dbi.profile.modules[self.name]
									end,
									min = -50,
									max = 50,
									step = 1,
									order = 25,
								},
							},
						},
					},
				},
				--[[filter = {
					type = "group",
					name = L["Filter"],
					childGroups = "tree",
					hidden = function()
						return not Gladius.db.advancedOptions
					end,
					order = 2,
					args = {
						whitelist = {
							type = "group",
							name = L["Whitelist"],
							order = 1,
							args = {
							},
						},
						blacklist = {
							type = "group",
							name = L["Blacklist"],
							order = 2,
							args = {
							},
						},
						filterFunction = {
							type = "group",
							name = L["Filter Function"],
							order = 3,
							args = {
							},
						},
					},
				},]]
			},
		},
	}
	return options
end