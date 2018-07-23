local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Cast Bar"))
end
local L = Gladius.L
local LSM

-- global functions
local pairs = pairs
local select = select
local strfind = string.find

local AceGUIWidgetLSMlists = AceGUIWidgetLSMlists
local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local CastBar = Gladius:NewModule("CastBar", true, true, {
	castBarAttachTo = "ClassIcon",
	castBarDetached = false,
	castBarHeight = 12,
	castBarAdjustWidth = true,
	castBarWidth = 150,
	castBarOffsetX = 0,
	castBarOffsetY = 0,
	castBarAnchor = "TOPLEFT",
	castBarRelativePoint = "BOTTOMLEFT",
	castBarInverse = false,
	castBarColor = {r = 1, g = 1, b = 0, a = 1},
	castBarColorUninterruptible = {r = 1, g = 0, b = 0, a = 1},
	castBarBackgroundColor = {r = 1, g = 1, b = 1, a = 0.3},
	castBarTexture = "Minimalist",
	castBarTextureUninterruptible = "Bars",
	castIcon = true,
	castIconPosition = "LEFT",
	castText = true,
	castTextSize = 11,
	castTextColor = {r = 2.55, g = 2.55, b = 2.55, a = 1},
	castTextAlign = "LEFT",
	castTextOffsetX = 0,
	castTextOffsetY = 0,
	castTimeText = true,
	castTimeTextSize = 11,
	castTimeTextColor = {r = 2.55, g = 2.55, b = 2.55, a = 1},
	castTimeTextAlign = "RIGHT",
	castTimeTextOffsetX = 0,
	castTimeTextOffsetY = 0,
})

function CastBar:OnEnable()
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "UNIT_SPELLCAST_DELAYED")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	self:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
	LSM = Gladius.LSM
	-- set frame type
	--[[if (Gladius.db.castBarAttachTo == "Frame" or Gladius:GetModule(Gladius.db.castBarAttachTo).isBar) then
		self.isBar = true
	else
		self.isBar = false
	end]]
	self.isBar = true
	if not self.frame then
		self.frame = { }
	end
end

function CastBar:OnDisable()
	self:UnregisterAllEvents()
	for unit in pairs(self.frame) do
		self.frame[unit]:SetAlpha(0)
	end
end

function CastBar:GetAttachTo()
	return Gladius.db.castBarAttachTo
end

function CastBar:IsDetached()
	return Gladius.db.castBarDetached
end

function CastBar:GetFrame(unit)
	if Gladius.db.castIcon and Gladius.db.castIconPosition == "LEFT" then
		return self.frame[unit].icon
	else
		return self.frame[unit]
	end
end

function CastBar:GetIndicatorHeight()
	return Gladius.db.castBarHeight
end

function CastBar:UNIT_SPELLCAST_START(event, unit)
	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	if self.frame[unit] == nil then
		return
	end
	local spell, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
	if spell then
		self.frame[unit].isCasting = true
		if Gladius.db.castBarInverse then
			self.frame[unit].value = (endTime - startTime) / 1000
		else
			self.frame[unit].value = (GetTime() - (startTime / 1000))
		end
		self.frame[unit].maxValue = (endTime - startTime) / 1000
		self.frame[unit]:SetMinMaxValues(0, self.frame[unit].maxValue)
		self.frame[unit]:SetValue(self.frame[unit].value)
		self.frame[unit].timeText:SetText(self.frame[unit].maxValue)
		self.frame[unit].icon:SetTexture(icon)
		if notInterruptible then
			local color = Gladius.db.castBarColorUninterruptible
			self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
			self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTextureUninterruptible))
		else
			local color = Gladius.db.castBarColor
			self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
			self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTexture))
		end
		self.frame[unit].castText:SetText(spell)
	end
end

function CastBar:UNIT_SPELLCAST_INTERRUPTIBLE(event, unit)
	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	if self.frame[unit] == nil then
		return
	end
	if self.frame[unit].isChanneling or self.frame[unit].isCasting then
		local color = Gladius.db.castBarColor
		self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
		self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTexture))
	end
end

function CastBar:UNIT_SPELLCAST_NOT_INTERRUPTIBLE(event, unit)
	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	if self.frame[unit] == nil then
		return
	end
	if self.frame[unit].isChanneling or self.frame[unit].isCasting then
		local color = Gladius.db.castBarColorUninterruptible
		self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
		self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTextureUninterruptible))
	end
end

function CastBar:UNIT_SPELLCAST_CHANNEL_START(event, unit)
	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	if self.frame[unit] == nil then
		return
	end
	local spell, displayName, icon, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo(unit)
	if spell then
		self.frame[unit].isChanneling = true
		--self.frame[unit].value = ((endTime / 1000) - GetTime())
		if Gladius.db.castBarInverse then
			self.frame[unit].value = (GetTime() - (startTime / 1000))
		else
			self.frame[unit].value = (endTime - startTime) / 1000
		end
		self.frame[unit].maxValue = (endTime - startTime) / 1000
		self.frame[unit]:SetMinMaxValues(0, self.frame[unit].maxValue)
		self.frame[unit]:SetValue(self.frame[unit].value)
		self.frame[unit].timeText:SetText(self.frame[unit].maxValue)
		self.frame[unit].icon:SetTexture(icon)
		if notInterruptible then
			local color = Gladius.db.castBarColorUninterruptible
			self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
			self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTextureUninterruptible))
		else
			local color = Gladius.db.castBarColor
			self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
			self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTexture))
		end
		self.frame[unit].castText:SetText(spell)
	end
end

function CastBar:UNIT_SPELLCAST_STOP(event, unit)
	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	self:CastEnd(self.frame[unit])
end

function CastBar:UNIT_SPELLCAST_DELAYED(event, unit)
	if not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	if self.frame[unit] == nil then
		return
	end
	local spell, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible
	if event == "UNIT_SPELLCAST_DELAYED" then
		spell, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
	else
		spell, displayName, icon, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo(unit)
	end
	if startTime == nil then
		return
	end
	if Gladius.db.castBarInverse then
		if self.isCasting then
			self.frame[unit].value = (endTime - startTime) / 1000
		elseif self.isChanneling then
			self.frame[unit].value = (GetTime() - (startTime / 1000))
		end
	else
		if self.isCasting then
			self.frame[unit].value = (GetTime() - (startTime / 1000))
		elseif self.isChanneling then
			self.frame[unit].value = (endTime - startTime) / 1000
		end
	end
	self.frame[unit].maxValue = (endTime - startTime) / 1000
	self.frame[unit]:SetMinMaxValues(0, self.frame[unit].maxValue)
end

function CastBar:CastEnd(bar)
	if bar then
		bar.isCasting = nil
		bar.isChanneling = nil
		bar.timeText:SetText("")
		bar.castText:SetText("")
		bar.icon:SetTexture("")
		bar:SetValue(0)
	end
end

function CastBar:CreateBar(unit)
	local button = Gladius.buttons[unit]
	if not button then
		return
	end
	-- create bar + text
	self.frame[unit] = CreateFrame("StatusBar", "Gladius"..self.name..unit, button)
	self.frame[unit].background = self.frame[unit]:CreateTexture("Gladius"..self.name..unit.."Background", "BACKGROUND")
	self.frame[unit].highlight = self.frame[unit]:CreateTexture("Gladius"..self.name.."Highlight"..unit, "OVERLAY")
	self.frame[unit].castText = self.frame[unit]:CreateFontString("Gladius"..self.name.."CastText"..unit, "OVERLAY")
	self.frame[unit].timeText = self.frame[unit]:CreateFontString("Gladius"..self.name.."TimeText"..unit, "OVERLAY")
	self.frame[unit].icon = self.frame[unit]:CreateTexture("Gladius"..self.name.."IconFrame"..unit, "ARTWORK")
	self.frame[unit].icon.bg = self.frame[unit]:CreateTexture("Gladius"..self.name.."IconFrameBackground"..unit, "BACKGROUND")
end

local function CastUpdate(self, elapsed)
	if Gladius.test then
		return
	end
	if (self.isCasting and not Gladius.db.castBarInverse) or (self.isChanneling and Gladius.db.castBarInverse) then
		if self.value >= self.maxValue then
			self:SetValue(self.maxValue)
			CastBar:CastEnd(self)
			return
		end
		self.value = self.value + elapsed
		self:SetValue(self.value)
		self.timeText:SetFormattedText("%.1f", self.maxValue - self.value)
	elseif (self.isCasting and Gladius.db.castBarInverse) or (self.isChanneling and not Gladius.db.castBarInverse) then
		if self.value <= 0 then
			self:SetValue(0)
			CastBar:CastEnd(self)
			return
		end
		self.value = self.value - elapsed
		self:SetValue(self.value)
		self.timeText:SetFormattedText("%.1f", self.value)
	end
end

function CastBar:UpdateColors(unit)
	if not Gladius.test then
		local _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
		local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo(unit)
		if notInterruptible or notInterruptibleChannel then
			local color = Gladius.db.castBarColorUninterruptible
			self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
			self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTextureUninterruptible))
		else
			local color = Gladius.db.castBarColor
			self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
			self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTexture))
		end
	else
		if unit == "arena2" then
			local color = Gladius.db.castBarColorUninterruptible
			self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
			self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTextureUninterruptible))
		else
			local color = Gladius.db.castBarColor
			self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
			self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTexture))
		end
	end
	local color = Gladius.db.castTextColor
	self.frame[unit].castText:SetTextColor(color.r, color.g, color.b, color.a)
	local color = Gladius.db.castTimeTextColor
	self.frame[unit].timeText:SetTextColor(color.r, color.g, color.b, color.a)
	self.frame[unit].icon.bg:SetVertexColor(Gladius.db.castBarBackgroundColor.r, Gladius.db.castBarBackgroundColor.g, Gladius.db.castBarBackgroundColor.b, Gladius.db.castIcon and Gladius.db.castBarBackgroundColor.a or 0)
	self.frame[unit].background:SetVertexColor(Gladius.db.castBarBackgroundColor.r, Gladius.db.castBarBackgroundColor.g, Gladius.db.castBarBackgroundColor.b, Gladius.db.castBarBackgroundColor.a)
end

function CastBar:Update(unit)
	-- check parent module
	if not Gladius:GetModule(Gladius.db.castBarAttachTo) then
		if self.frame[unit] then
			self.frame[unit]:Hide()
		end
		return
	end
	local testing = Gladius.test
	-- create power bar
	if not self.frame[unit] then
		self:CreateBar(unit)
	end
	-- set bar type
	local parent = Gladius:GetParent(unit, Gladius.db.castBarAttachTo)
	--[[if (Gladius.db.castBarAttachTo == "Frame" or Gladius:GetModule(Gladius.db.castBarAttachTo).isBar) then
		self.isBar = true
	else
		self.isBar = false
	end]]
	-- update power bar
	self.frame[unit]:ClearAllPoints()
	local width = Gladius.db.castBarAdjustWidth and Gladius.db.barWidth or Gladius.db.castBarWidth
	if Gladius.db.castIcon then
		width = width - Gladius.db.castBarHeight
	end
	-- add width of the widget if attached to an widget
	if Gladius.db.castBarAttachTo ~= "Frame" and not Gladius:GetModule(Gladius.db.castBarAttachTo).isBar and Gladius.db.castBarAdjustWidth then
		if not Gladius:GetModule(Gladius.db.castBarAttachTo).frame or not Gladius:GetModule(Gladius.db.castBarAttachTo).frame[unit] then
			Gladius:GetModule(Gladius.db.castBarAttachTo):Update(unit)
		end
		if Gladius.db.castBarAttachTo == "ClassIcon" then
			width = width + Gladius:GetModule(Gladius.db.castBarAttachTo).frame[unit]:GetWidth() - Gladius.db.classIconOffsetX
		else
			width = width + Gladius:GetModule(Gladius.db.castBarAttachTo).frame[unit]:GetWidth()
		end
	end
	self.frame[unit]:SetHeight(Gladius.db.castBarHeight)
	self.frame[unit]:SetWidth(width)
	local offsetX
	if not strfind(Gladius.db.castBarAnchor, "RIGHT") and strfind(Gladius.db.castBarRelativePoint, "RIGHT") then
		offsetX = Gladius.db.castIcon and Gladius.db.castIconPosition == "LEFT" and self.frame[unit]:GetHeight() or 0
	elseif not strfind(Gladius.db.castBarAnchor, "LEFT") and strfind(Gladius.db.castBarRelativePoint, "LEFT") then
		offsetX = Gladius.db.castIcon and Gladius.db.castIconPosition == "RIGHT" and -self.frame[unit]:GetHeight() or 0
	elseif strfind(Gladius.db.castBarAnchor, "LEFT") and strfind(Gladius.db.castBarRelativePoint, "LEFT") then
		offsetX = Gladius.db.castIcon and Gladius.db.castIconPosition == "LEFT" and self.frame[unit]:GetHeight() or 0
	elseif strfind(Gladius.db.castBarAnchor, "RIGHT") and strfind(Gladius.db.castBarRelativePoint, "RIGHT") then
		offsetX = Gladius.db.castIcon and Gladius.db.castIconPosition == "RIGHT" and -self.frame[unit]:GetHeight() or 0
	end
	self.frame[unit]:SetPoint(Gladius.db.castBarAnchor, parent, Gladius.db.castBarRelativePoint, Gladius.db.castBarOffsetX + (offsetX or 0), Gladius.db.castBarOffsetY)
	self.frame[unit]:SetMinMaxValues(0, 100)
	self.frame[unit]:SetValue(0)
	self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTexture))
	-- updating
	self.frame[unit]:SetScript("OnUpdate", CastUpdate)
	-- disable tileing
	self.frame[unit]:GetStatusBarTexture():SetHorizTile(false)
	self.frame[unit]:GetStatusBarTexture():SetVertTile(false)
	-- set color
	local color = Gladius.db.castBarColor
	self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
	-- update cast text
	self.frame[unit].castText:SetFont(LSM:Fetch(LSM.MediaType.FONT, Gladius.db.globalFont), Gladius.db.castTextSize)
	local color = Gladius.db.castTextColor
	self.frame[unit].castText:SetTextColor(color.r, color.g, color.b, color.a)
	self.frame[unit].castText:SetShadowOffset(1, - 1)
	self.frame[unit].castText:SetShadowColor(0, 0, 0, 1)
	self.frame[unit].castText:SetJustifyH(Gladius.db.castTextAlign)
	self.frame[unit].castText:SetPoint(Gladius.db.castTextAlign, Gladius.db.castTextOffsetX, Gladius.db.castTextOffsetY)
	-- update cast time text
	self.frame[unit].timeText:SetFont(LSM:Fetch(LSM.MediaType.FONT, Gladius.db.globalFont), Gladius.db.castTimeTextSize)
	local color = Gladius.db.castTimeTextColor
	self.frame[unit].timeText:SetTextColor(color.r, color.g, color.b, color.a)
	self.frame[unit].timeText:SetShadowOffset(1, - 1)
	self.frame[unit].timeText:SetShadowColor(0, 0, 0, 1)
	self.frame[unit].timeText:SetJustifyH(Gladius.db.castTimeTextAlign)
	self.frame[unit].timeText:SetPoint(Gladius.db.castTimeTextAlign, Gladius.db.castTimeTextOffsetX, Gladius.db.castTimeTextOffsetY)
	-- update icon
	self.frame[unit].icon:ClearAllPoints()
	self.frame[unit].icon:SetPoint(Gladius.db.castIconPosition == "LEFT" and "RIGHT" or "LEFT", self.frame[unit], Gladius.db.castIconPosition)
	self.frame[unit].icon:SetWidth(self.frame[unit]:GetHeight())
	self.frame[unit].icon:SetHeight(self.frame[unit]:GetHeight())
	self.frame[unit].icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	self.frame[unit].icon.bg:ClearAllPoints()
	self.frame[unit].icon.bg:SetAllPoints(self.frame[unit].icon)
	self.frame[unit].icon.bg:SetTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTexture))
	self.frame[unit].icon.bg:SetVertexColor(Gladius.db.castBarBackgroundColor.r, Gladius.db.castBarBackgroundColor.g, Gladius.db.castBarBackgroundColor.b, Gladius.db.castBarBackgroundColor.a)
	if not Gladius.db.castIcon then
		self.frame[unit].icon:SetAlpha(0)
	else
		self.frame[unit].icon:SetAlpha(1)
	end
	-- update cast bar background
	self.frame[unit].background:ClearAllPoints()
	self.frame[unit].background:SetAllPoints(self.frame[unit])
	-- Maybe it looks better if the background covers the whole castbar
	--[[if (Gladius.db.castIcon) then
		self.frame[unit].background:SetWidth(self.frame[unit]:GetWidth() + self.frame[unit].icon:GetWidth())
	else
		self.frame[unit].background:SetWidth(self.frame[unit]:GetWidth())
	end]]
	self.frame[unit].background:SetHeight(self.frame[unit]:GetHeight())
	self.frame[unit].background:SetTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTexture))
	self.frame[unit].background:SetVertexColor(Gladius.db.castBarBackgroundColor.r, Gladius.db.castBarBackgroundColor.g, Gladius.db.castBarBackgroundColor.b, Gladius.db.castBarBackgroundColor.a)
	-- disable tileing
	self.frame[unit].background:SetHorizTile(false)
	self.frame[unit].background:SetVertTile(false)
	-- update highlight texture
	self.frame[unit].highlight:SetAllPoints(self.frame[unit])
	self.frame[unit].highlight:SetTexture([=[Interface\QuestFrame\UI-QuestTitleHighlight]=])
	self.frame[unit].highlight:SetBlendMode("ADD")
	self.frame[unit].highlight:SetVertexColor(1.0, 1.0, 1.0, 1.0)
	self.frame[unit].highlight:SetAlpha(0)
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function CastBar:Show(unit)
	-- show frame
	self.frame[unit]:SetAlpha(1)
end

function CastBar:Reset(unit)
	-- reset bar
	self.frame[unit]:SetMinMaxValues(0, 1)
	self.frame[unit]:SetValue(0)
	-- reset text
	if self.frame[unit].castText:GetFont() then
		self.frame[unit].castText:SetText("")
	end
	if self.frame[unit].timeText:GetFont() then
		self.frame[unit].timeText:SetText("")
	end
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function CastBar:Test(unit)
	if unit == "arena1" then
		self.frame[unit].isCasting = true
		self.frame[unit].value = Gladius.db.castBarInverse and 0 or 1
		self.frame[unit].maxValue = 1
		self.frame[unit]:SetMinMaxValues(0, self.frame[unit].maxValue)
		self.frame[unit]:SetValue(self.frame[unit].value)
		if Gladius.db.castTimeText then
			self.frame[unit].timeText:SetFormattedText("%.1f", self.frame[unit].maxValue - self.frame[unit].value)
		else
			self.frame[unit].timeText:SetText("")
		end
		local texture = select(3, GetSpellInfo(1))
		self.frame[unit].icon:SetTexture(texture)
		if Gladius.db.castText then
			self.frame[unit].castText:SetText(L["Example Spell Name"])
		else
			self.frame[unit].castText:SetText("")
		end
	elseif unit == "arena2" then
		self.frame[unit].isCasting = true
		self.frame[unit].value = Gladius.db.castBarInverse and 0 or 1
		self.frame[unit].maxValue = 1
		self.frame[unit]:SetMinMaxValues(0, self.frame[unit].maxValue)
		self.frame[unit]:SetValue(self.frame[unit].value)
		local color = Gladius.db.castBarColorUninterruptible
		self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
		self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.castBarTextureUninterruptible))
		if Gladius.db.castTimeText then
			self.frame[unit].timeText:SetFormattedText("%.1f", self.frame[unit].maxValue - self.frame[unit].value)
		else
			self.frame[unit].timeText:SetText("")
		end
		local texture = select(3, GetSpellInfo(1))
		self.frame[unit].icon:SetTexture(texture)
		if Gladius.db.castText then
			self.frame[unit].castText:SetText(L["Uninterruptible Spell"])
		else
			self.frame[unit].castText:SetText("")
		end
	end
end

function CastBar:GetOptions()
	return {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				bar = {
					type = "group",
					name = L["Bar"],
					desc = L["Bar settings"],
					inline = true,
					order = 1,
					args = {
						castBarColor = {
							type = "color",
							name = L["Cast Bar Color"],
							desc = L["Color of the cast bar"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						castBarBackgroundColor = {
							type = "color",
							name = L["Cast Bar Background Color"],
							desc = L["Color of the cast bar background"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 10,
						},
						castBarColorUninterruptible = {
							type = "color",
							name = L["Uninterruptible Cast Bar Color"],
							desc = L["Color of the cast bar"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 11,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 13,
						},
						castBarInverse = {
							type = "toggle",
							name = L["Cast Bar Inverse"],
							desc = L["Inverse the cast bar"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 15,
						},
						castBarTexture = {
							type = "select",
							name = L["Cast Bar Texture"],
							desc = L["Texture of the cast bar"],
							dialogControl = "LSM30_Statusbar",
							values = AceGUIWidgetLSMlists.statusbar,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 20,
						},
						castBarTextureUninterruptible = {
							type = "select",
							name = L["Uninterruptible Cast Bar Texture"],
							desc = L["Texture of the uninterruptible cast bar"],
							dialogControl = "LSM30_Statusbar",
							values = AceGUIWidgetLSMlists.statusbar,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 22,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 23,
						},
						castIcon = {
							type = "toggle",
							name = L["Cast Bar Icon"],
							desc = L["Toggle the cast icon"],
							disabled = function()
								for unit, _ in pairs(Gladius.buttons) do
									self:UpdateColors(unit)
								end
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 25,
						},
						castIconPosition = {
							type = "select",
							name = L["Cast Bar Icon Position"],
							desc = L["Position of the cast bar icon"],
							values={ ["LEFT"] = L["LEFT"], ["RIGHT"] = L["RIGHT"] },
							disabled = function()
								return not Gladius.dbi.profile.castIcon or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 30,
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
						castBarAdjustWidth = {
							type = "toggle",
							name = L["Cast Bar Adjust Width"],
							desc = L["Adjust cast bar width to the frame width"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 13,
						},
						castBarWidth = {
							type = "range",
							name = L["Cast Bar Width"],
							desc = L["Width of the cast bar"],
							min = 10,
							max = 500,
							step = 1,
							disabled = function()
								return Gladius.dbi.profile.castBarAdjustWidth or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 15,
						},
						castBarHeight = {
							type = "range",
							name = L["Cast Bar Height"],
							desc = L["Height of the cast bar"],
							min = 10,
							max = 200,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
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
						castBarAttachTo = {
							type = "select",
							name = L["Cast Bar Attach To"],
							desc = L["Attach cast bar to the given frame"],
							values = function()
								return Gladius:GetModules(self.name)
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								--[[if (Gladius.db.castBarAttachTo == "Frame" or Gladius:GetModule(Gladius.db.castBarAttachTo).isBar) then
									self.isBar = true
								else
									self.isBar = false
								end]]
								Gladius.dbi.profile[key] = value
								Gladius:UpdateFrame()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							width = "double",
							order = 5,
						},
						castBarDetached = {
							type = "toggle",
							name = L["Detached from frame"],
							desc = L["Detach the module from the frame itself"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 6,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 8,
						},
						castBarAnchor = {
							type = "select",
							name = L["Cast Bar Anchor"],
							desc = L["Anchor of the cast bar"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
						castBarRelativePoint = {
							type = "select",
							name = L["Cast Bar Relative Point"],
							desc = L["Relative point of the cast bar"],
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
						castBarOffsetX = {
							type = "range",
							name = L["Cast Bar Offset X"],
							desc = L["X offset of the cast bar"],
							min = - 100,
							max = 100,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 20,
						},
						castBarOffsetY = {
							type = "range",
							name = L["Cast Bar Offset Y"],
							desc = L["Y offset of the castbar"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = - 100,
							max = 100,
							step = 1,
							order = 25,
						},
					},
				},
			},
		},
		castText = {
			type = "group",
			name = L["Cast Text"],
			order = 2,
			args = {
				text = {
					type = "group",
					name = L["Text"],
					desc = L["Text settings"],
					inline = true,
					order = 1,
					args = {
						castText = {
							type = "toggle",
							name = L["Cast Text"],
							desc = L["Toggle cast text"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						castTextColor = {
							type = "color",
							name = L["Cast Text Color"],
							desc = L["Text color of the cast text"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.castText or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
						castTextSize = {
							type = "range",
							name = L["Cast Text Size"],
							desc = L["Text size of the cast text"],
							min = 1,
							max = 20,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.castText or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 15,
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
					order = 2,
					args = {
						castTextAlign = {
							type = "select",
							name = L["Cast Text Align"],
							desc = L["Text align of the cast text"],
							values={ ["LEFT"] = L["LEFT"], ["CENTER"] = L["CENTER"], ["RIGHT"] = L["RIGHT"] },
							disabled = function()
								return not Gladius.dbi.profile.castText or not Gladius.dbi.profile.modules[self.name]
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
						castTextOffsetX = {
							type = "range",
							name = L["Cast Text Offset X"],
							desc = L["X offset of the cast text"],
							min = - 100,
							max = 100,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.castText or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
						castTextOffsetY = {
							type = "range",
							name = L["Cast Text Offset Y"],
							desc = L["Y offset of the cast text"],
							disabled = function()
								return not Gladius.dbi.profile.castText or not Gladius.dbi.profile.modules[self.name]
							end,
							min = - 100,
							max = 100,
							step = 1,
							order = 15,
						},
					},
				},
			},
		},
		castTimeText = {
			type = "group",
			name = L["Cast Time Text"],
			order = 3,
			args = {
				text = {
					type = "group",
					name = L["Text"],
					desc = L["Text settings"],
					inline = true,
					order = 1,
					args = {
						castTimeText = {
							type = "toggle",
							name = L["Cast Time Text"],
							desc = L["Toggle cast time text"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						castTimeTextColor = {
							type = "color",
							name = L["Cast Time Text Color"],
							desc = L["Text color of the cast time text"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.castTimeText or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
						castTimeTextSize = {
							type = "range",
							name = L["Cast Time Text Size"],
							desc = L["Text size of the cast time text"],
							min = 1,
							max = 20,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.castTimeText or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 15,
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
					order = 2,
					args = {
						castTimeTextAlign = {
							type = "select",
							name = L["Cast Time Text Align"],
							desc = L["Text align of the cast time text"],
							values = {["LEFT"] = L["LEFT"], ["CENTER"] = L["CENTER"], ["RIGHT"] = L["RIGHT"]},
							disabled = function()
								return not Gladius.dbi.profile.castTimeText or not Gladius.dbi.profile.modules[self.name]
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
						castTimeTextOffsetX = {
							type = "range",
							name = L["Cast Time Offset X"],
							desc = L["X Offset of the cast time text"],
							min = - 100,
							max = 100,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.castTimeText or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
						castTimeTextOffsetY = {
							type = "range",
							name = L["Cast Time Offset Y"],
							desc = L["Y Offset of the cast time text"],
							disabled = function()
								return not Gladius.dbi.profile.castTimeText or not Gladius.dbi.profile.modules[self.name]
							end,
							min = - 100,
							max = 100,
							step = 1,
							order = 15,
						},
					},
				},
			},
		},
	}
end
