local E = select(2, ...):unpack()
local P = E.Party

local format, ceil, floor, min, GetTime = string.format, math.ceil, math.floor, math.min, GetTime
local tremove, tinsert, tonumber, gsub, utf8sub = tremove, tinsert, tonumber, string.gsub, string.utf8sub
local RESET = NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON or "Reset"

local unusedStatusBars = {}
local numStatusBars = 0

local CASTING_BAR_ALPHA_STEP = 0.05;
local CASTING_BAR_FLASH_STEP = 0.2;
local CASTING_BAR_HOLD_TIME = 1;
local SECONDS_PER_MIN = 60

local function CastingBarFrame_SetStartCastColor(self, r, g, b, a)
	self.startCastColor = CreateColor(r, g, b, a);
end

local function CastingBarFrame_SetStartChannelColor(self, r, g, b, a)
	self.startChannelColor = CreateColor(r, g, b, a);
end

local function CastingBarFrame_SetStartRechargeColor(self, r, g, b, a)
	self.startRechargeColor = CreateColor(r, g, b, a);
end

local function CastingBarFrame_SetFinishedCastColor(self, r, g, b)
	self.finishedCastColor = CreateColor(r, g, b);
end

local function CastingBarFrame_SetFailedCastColor(self, r, g, b)
	self.failedCastColor = CreateColor(r, g, b);
end

local function CastingBarFrame_SetNonInterruptibleCastColor(self, r, g, b)
	self.nonInterruptibleColor = CreateColor(r, g, b);
end

local function CastingBarFrame_SetUseStartColorForFinished(self, finishedColorSameAsStart)
	self.finishedColorSameAsStart = finishedColorSameAsStart;
end

local function CastingBarFrame_SetUseStartColorForFlash(self, flashColorSameAsStart)
	self.flashColorSameAsStart = flashColorSameAsStart;
end

local function CastingBarFrame_SetStartCastBGColor(self, r, g, b, a)
	self.startCastBGColor = CreateColor(r, g, b, a);
end

local function CastingBarFrame_SetStartChannelBGColor(self, r, g, b, a)
	self.startChannelBGColor = CreateColor(r, g, b, a);
end

local function CastingBarFrame_SetStartRechargeBGColor(self, r, g, b, a)
	self.startRechargeBGColor = CreateColor(r, g, b, a);
end

local function CastingBarFrame_SetStartCastTextColor(self, r, g, b)
	self.startCastTextColor = CreateColor(r, g, b);
end

local function CastingBarFrame_SetStartChannelTextColor(self, r, g, b)
	self.startChannelTextColor = CreateColor(r, g, b);
end

local function CastingBarFrame_SetStartRechargeTextColor(self, r, g, b)
	self.startRechargeTextColor = CreateColor(r, g, b);
end

local function CastingBarFrame_SetUnit(self, icon)
	self.name = self.statusBar.name
	self.unit = icon.guid
	self.spellID = icon.spellID

	self.casting = nil;
	self.channeling = nil;
	self.holdTime = 0;
	self.fadeOut = nil;

	self:Hide()
end

local function CastingBarFrame_OnLoad(self, db, icon)
	local active, recharge
	local c = RAID_CLASS_COLORS[icon.class]

	local db_bg = db.bgColors
	active, recharge = db_bg.useClassColor.active and c or db_bg.activeColor, db_bg.useClassColor.recharge and c or db_bg.rechargeColor
	CastingBarFrame_SetStartCastBGColor(self, active.r, active.g, active.b, db_bg.activeColor.a);
	CastingBarFrame_SetStartChannelBGColor(self, active.r, active.g, active.b, db_bg.activeColor.a);
	CastingBarFrame_SetStartRechargeBGColor(self, recharge.r, recharge.g, recharge.b, db_bg.rechargeColor.a);

	local db_text = db.textColors
	active, recharge = db_text.useClassColor.active and c or db_text.activeColor, db_text.useClassColor.recharge and c or db_text.rechargeColor
	CastingBarFrame_SetStartCastTextColor(self, active.r, active.g, active.b);
	CastingBarFrame_SetStartChannelTextColor(self, active.r, active.g, active.b);
	CastingBarFrame_SetStartRechargeTextColor(self, recharge.r, recharge.g, recharge.b);

	local db_bar = db.barColors
	active, recharge = db_bar.useClassColor.active and c or db_bar.activeColor, db_bar.useClassColor.recharge and c or db_bar.rechargeColor
	CastingBarFrame_SetStartRechargeColor(self, recharge.r, recharge.g, recharge.b, db_bar.rechargeColor.a);
	CastingBarFrame_SetStartCastColor(self, active.r, active.g, active.b, db_bar.activeColor.a);
	CastingBarFrame_SetStartChannelColor(self, active.r, active.g, active.b, db_bar.activeColor.a);
	CastingBarFrame_SetFinishedCastColor(self, 0.0, 1.0, 0.0);
	CastingBarFrame_SetNonInterruptibleCastColor(self, 0.7, 0.7, 0.7);
	CastingBarFrame_SetFailedCastColor(self, .55, .27, 1.0);

	CastingBarFrame_SetUseStartColorForFinished(self, true);
	CastingBarFrame_SetUseStartColorForFlash(self, true);

	CastingBarFrame_SetUnit(self, icon);

	self.showCastbar = true;

	local point, _,_,_, offsetY = self.Spark:GetPoint();
	if ( point == "CENTER" ) then
		self.Spark.offsetY = offsetY;
	end


	self.isSparkEnabled = not db.hideSpark
	self.Spark:SetShown(self.isSparkEnabled)
	self.nextTextUpdate = 0

	if P.groupInfo[icon.guid].active[icon.spellID] then
		P.OmniCDCastingBarFrame_OnEvent(self, db.reverseFill and  'UNIT_SPELLCAST_CHANNEL_START' or 'UNIT_SPELLCAST_START')
	end
end

local OmniCDCastingBarFrame_OnUpdate
local OmniCDCastingBarFrame_OnShow

function P:GetStatusBar(icon, key)
	local statusBar = tremove(unusedStatusBars)
	if not statusBar then
		numStatusBars = numStatusBars + 1
		statusBar = CreateFrame("Frame", "OmniCDStatusBar" .. numStatusBars, UIParent, "OmniCDStatusBar")
		statusBar.CastingBar.statusBar = statusBar
		statusBar.CastingBar:SetScript("OnUpdate", OmniCDCastingBarFrame_OnUpdate)
		statusBar.CastingBar:SetScript("OnShow", OmniCDCastingBarFrame_OnShow)

		statusBar.Text:SetFontObject(E.StatusBarFont)
		statusBar.CastingBar.Text:SetFontObject(E.StatusBarFont)
		statusBar.CastingBar.Timer:SetFontObject(E.StatusBarFont)

		local texture = E.Libs.LSM:Fetch("statusbar", E.profile.General.textures.statusBar.bar)
		statusBar.BG:SetTexture(texture)
		statusBar.CastingBar:SetStatusBarTexture(texture)
		statusBar.CastingBar.BG:SetTexture(E.Libs.LSM:Fetch("statusbar", E.profile.General.textures.statusBar.BG))
	end

	local db = E.db.extraBars[key]
	local name = gsub(self.groupInfo[icon.guid].name, "%-(.*)", "")
	local numChar = db.truncateStatusBarName
	if numChar > 0 then
		name = utf8sub(name, 1, numChar)
	end
	statusBar.name = name
	statusBar.Text:SetText(name)
	statusBar.key = key
	statusBar.icon = icon

	CastingBarFrame_OnLoad(statusBar.CastingBar, db, icon)

	statusBar:SetParent(icon)
	statusBar:ClearAllPoints()
	statusBar:SetPoint("TOPLEFT", icon, "TOPRIGHT")
	statusBar:Show()
	statusBar.BG:Show()
	statusBar.Text:Show()

	icon.statusBar = statusBar

	return statusBar
end

function P:RemoveStatusBar(statusBar)
	statusBar:Hide()
	tinsert(unusedStatusBars, statusBar)
end

local function CastingBarFrame_FinishSpell(self)
	if not self.finishedColorSameAsStart then
		self:SetStatusBarColor(self.finishedCastColor:GetRGB());
	end
	if ( self.isSparkEnabled ) then
		self.Spark:Hide();
	end
	--[[
	if ( self.Flash ) then
		self.Flash:SetAlpha(0.0);
		self.Flash:Show();
	end
	self.flash = true;
	]]
	if self.statusBar.key ~= "raidBar0" or not P.extraBars.raidBar0.shouldRearrangeInterrupts then
		self.fadeOut = true;
	end
	self.casting = nil;
	self.channeling = nil;
end

local function FindStartEndTime(self, now)
	local info = P.groupInfo[self.unit]
	local active = info and info.active[self.spellID]
	if active then

		local modRate = active.iconModRate
		self.modRate = modRate
		if modRate then
			now = now or GetTime()
			local newTime = now - (now - active.startTime) / modRate
			return newTime , newTime + active.duration / modRate
		end
		return active.startTime, active.startTime + active.duration
	end
end

OmniCDCastingBarFrame_OnShow = function(self)
	if ( self.unit ) then
		--[[
		if ( self.casting ) then
			local startTime = FindStartEndTime(self)
			if ( startTime ) then
				self.value = (GetTime() - startTime);
			end
		else
			local _, endTime = FindStartEndTime(self)
			if ( endTime ) then
				self.value = (endTime - GetTime())
			end
		end
		]]
		if ( self.casting or self.channeling ) then
			local statusBar = self.statusBar
			statusBar.Text:Hide()
			statusBar.BG:Hide()
		end
	end
end

local function CastingBarFrame_ApplyAlpha(self, alpha)
	self:SetAlpha(alpha);
	--[[
	if self.additionalFadeWidgets then
		for widget in pairs(self.additionalFadeWidgets) do
			widget:SetAlpha(alpha);
		end
	end
	]]
end

local function TimeFormat(value)
	if value > SECONDS_PER_MIN then
		if value <= P.mmss then
			local secRemaining = value%SECONDS_PER_MIN
			local sec = ceil(secRemaining)
			if sec == SECONDS_PER_MIN then
				return format("%d:%02d", floor(value/SECONDS_PER_MIN) + 1, 0), secRemaining%1
			else
				return format("%d:%02d", floor(value/SECONDS_PER_MIN), sec), secRemaining%1
			end
		else
			return format("%dm", ceil(value/SECONDS_PER_MIN)), min(value%SECONDS_PER_MIN, value - P.mmss)
		end
	else
		return ceil(value), value%1
	end
end

local function OmniCDCastingBarFrame_OnHide(self)
	local statusBar = self.statusBar
	statusBar.Text:Show()
	statusBar.BG:Show()


	local icon = statusBar.icon
	if icon.tooltipID then
		local iconTexture = GetSpellTexture(self.spellID)
		statusBar.icon.icon:SetTexture(iconTexture)
		icon.tooltipID = nil
		if not E.db.icons.showTooltip then
			icon:EnableMouse(false)
		end
	end
end

OmniCDCastingBarFrame_OnUpdate = function(self, elapsed)
	if ( self.casting ) then
		local modRate = self.modRate
		if modRate then
			elapsed = elapsed / modRate
		end
		self.value = self.value + elapsed;
		if ( self.value >= self.maxValue ) then
			self:SetValue(self.maxValue);
			CastingBarFrame_FinishSpell(self);
			return;
		end
		self:SetValue(self.value);
		--[[
		if ( self.Flash ) then
			self.Flash:Hide();
		end
		]]
		if ( self.isSparkEnabled ) then
			local sparkPosition = (self.value / self.maxValue) * self:GetWidth();
			self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, self.Spark.offsetY or 2);
		end

		if self.nextTextUpdate and self.nextTextUpdate > 0 then
			self.nextTextUpdate = self.nextTextUpdate - elapsed
			return
		end
		local counter, nextTextUpdate = TimeFormat(self.maxValue - self.value)
		self.nextTextUpdate = nextTextUpdate
		self.Timer:SetText(counter)
	elseif ( self.channeling ) then
		local modRate = self.modRate
		if modRate then
			elapsed = elapsed / modRate
		end
		self.value = self.value - elapsed;
		if ( self.value <= 0 ) then
			CastingBarFrame_FinishSpell(self);
			return;
		end
		self:SetValue(self.value);
		--[[
		if ( self.Flash ) then
			self.Flash:Hide();
		end
		]]
		if ( self.isSparkEnabled ) then
			local sparkPosition = (self.value / self.maxValue) * self:GetWidth();
			self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, self.Spark.offsetY or 2);
		end

		if self.nextTextUpdate and self.nextTextUpdate > 0 then
			self.nextTextUpdate = self.nextTextUpdate - elapsed
			return
		end
		local counter, nextTextUpdate = TimeFormat(self.value)
		self.nextTextUpdate = nextTextUpdate
		self.Timer:SetText(counter)
	elseif ( GetTime() < self.holdTime ) then
		return;
	--[[
	elseif ( self.flash ) then
		local alpha = 0;
		if ( self.Flash ) then
			alpha = self.Flash:GetAlpha() + CASTING_BAR_FLASH_STEP;
		end
		if ( alpha < 1 ) then
			if ( self.Flash ) then
				self.Flash:SetAlpha(alpha);
			end
		else
			if ( self.Flash ) then
				self.Flash:SetAlpha(1.0);
			end
			self.flash = nil;
		end
	]]
	elseif ( self.fadeOut ) then
		local alpha = self:GetAlpha() - CASTING_BAR_ALPHA_STEP;
		if ( alpha > 0 ) then
			CastingBarFrame_ApplyAlpha(self, alpha);
		else
			self.fadeOut = nil;
			self:Hide();

			OmniCDCastingBarFrame_OnHide(self)
		end
	else
		self:Hide();

		OmniCDCastingBarFrame_OnHide(self)
	end
end

local function CastingBarFrame_GetEffectiveStartColor(self, isChannel, notInterruptible)
	if self.nonInterruptibleColor and notInterruptible then
		return self.nonInterruptibleColor;
	end

	local icon = self.statusBar.icon
	local charges = icon.maxcharges and tonumber(icon.count:GetText())
	if charges and charges > 0 then
		return self.startRechargeColor, self.startRechargeBGColor, self.startRechargeTextColor
	elseif isChannel then
		return self.startChannelColor, self.startChannelBGColor, self.startChannelTextColor
	else
		return self.startCastColor, self.startCastBGColor, self.startCastTextColor
	end
end

local function CastingBarFrame_UpdateInterruptibleState(self, notInterruptible)
	if ( self.casting or self.channeling ) then
		local startColor = CastingBarFrame_GetEffectiveStartColor(self, self.channeling, notInterruptible);
		self:SetStatusBarColor(startColor:GetRGB());
		--[[
		if self.flashColorSameAsStart then
			self.Flash:SetVertexColor(startColor:GetRGB());
		end

		if ( self.BorderShield ) then
			if ( self.showShield and notInterruptible ) then
				self.BorderShield:Show();
				if ( self.BarBorder ) then
					self.BarBorder:Hide();
				end
			else
				self.BorderShield:Hide();
				if ( self.BarBorder ) then
					self.BarBorder:Show();
				end
			end
		end

		if ( self.Icon and self.iconWhenNoninterruptible ) then
			self.Icon:SetShown(not notInterruptible);
		end
		]]
	end
end

function P.OmniCDCastingBarFrame_OnEvent(self, event)
	local info = P.groupInfo[self.unit]
	if not info then
		return
	end

	local statusBar = self.statusBar
	if E.db.extraBars[statusBar.key].nameBar then
		local isChannel = event == 'UNIT_SPELLCAST_CHANNEL_START' or event == 'UNIT_SPELLCAST_CHANNEL_UPDATE'
		local _,_, startTextColor = CastingBarFrame_GetEffectiveStartColor(self, isChannel, notInterruptible);
		if ( isChannel or event == 'UNIT_SPELLCAST_START' or event == 'UNIT_SPELLCAST_CAST_UPDATE' ) then
			if info.isDeadOrOffline then
				statusBar.Text:SetTextColor(0.3, 0.3, 0.3)
			else
				statusBar.Text:SetTextColor(startTextColor:GetRGB())
			end
		elseif ( event == 'UNIT_SPELLCAST_STOP' or event == 'UNIT_SPELLCAST_CHANNEL_STOP' or event == 'UNIT_SPELLCAST_FAILED' ) then
			P:SetExStatusBarColor(statusBar:GetParent(), statusBar.key)
		end

		return
	end

	if ( event == 'UNIT_SPELLCAST_START' ) then
		local text, texture, notInterruptible = self.name
		local now = GetTime()
		local startTime, endTime = FindStartEndTime(self, now)
		if ( not startTime ) then
			self:Hide();
			return;
		end

		if info.isDeadOrOffline then
			self:SetStatusBarColor(0.3, 0.3, 0.3)
			self.BG:SetVertexColor(0.3, 0.3, 0.3)
			self.Text:SetTextColor(0.3, 0.3, 0.3)
		else
			local startColor, startBGColor, startTextColor = CastingBarFrame_GetEffectiveStartColor(self, false, notInterruptible);
			self:SetStatusBarColor(startColor:GetRGBA());
			self.BG:SetVertexColor(startBGColor:GetRGBA())
			self.Text:SetTextColor(startTextColor:GetRGB())
		end
		--[[
		if self.flashColorSameAsStart then
			self.Flash:SetVertexColor(startColor:GetRGB());
		else
			self.Flash:SetVertexColor(1, 1, 1);
		end
		]]
		if ( self.isSparkEnabled ) then
			self.Spark:Show();
		end
		self.value = (now - startTime);
		self.maxValue = (endTime - startTime);
		self:SetMinMaxValues(0, self.maxValue);
		self:SetValue(self.value);
		self.nextTextUpdate = 0
		if ( self.Text ) then
			self.Text:SetText(text);
		end
		--[[
		if ( self.Icon and texture) then
			self.Icon:SetTexture(texture);
			if ( self.iconWhenNoninterruptible ) then
				self.Icon:SetShown(not notInterruptible);
			end
		end
		]]
		CastingBarFrame_ApplyAlpha(self, 1.0);
		self.holdTime = 0;
		self.casting = true;

		self.channeling = nil;
		self.fadeOut = nil;
		--[[
		if ( self.BorderShield ) then
			if ( self.showShield and notInterruptible ) then
				self.BorderShield:Show();
				if ( self.BarBorder ) then
					self.BarBorder:Hide();
				end
			else
				self.BorderShield:Hide();
				if ( self.BarBorder ) then
					self.BarBorder:Show();
				end
			end
		end
		]]
		if ( self.showCastbar ) then
			self:Show();
		end
	elseif ( event == 'UNIT_SPELLCAST_STOP' or event == 'UNIT_SPELLCAST_CHANNEL_STOP' ) then
		if ( not self:IsVisible() ) then
			self:Hide();
		end
		if ( self.casting and event == 'UNIT_SPELLCAST_STOP' ) or ( self.channeling and event == 'UNIT_SPELLCAST_CHANNEL_STOP' ) then
			if self.holdTime > 0 then
				return
			end

			if ( self.isSparkEnabled ) then
				self.Spark:Hide();
			end
			--[[
			if ( self.Flash ) then
				self.Flash:SetAlpha(0.0);
				self.Flash:Show();
			end
			]]
			self:SetValue(self.maxValue);
			if ( event == 'UNIT_SPELLCAST_STOP' ) then
				self.casting = nil;
				if not self.finishedColorSameAsStart then
					self:SetStatusBarColor(self.finishedCastColor:GetRGB());
				end
			else
				self.channeling = nil;
			end

			self.fadeOut = true;
			self.holdTime = 0;
			self.nextTextUpdate = 0
		end
	elseif ( event == 'UNIT_SPELLCAST_FAILED' or event == 'UNIT_SPELLCAST_INTERRUPTED' ) then
		if ( self:IsShown() and (self.casting or self.channeling) and not self.fadeOut ) then
			self:SetValue(self.maxValue);
			self:SetStatusBarColor(self.failedCastColor:GetRGB());
			if ( self.isSparkEnabled ) then
				self.Spark:Hide();
			end
			if ( self.Text ) then
				--[[
				if ( event == 'UNIT_SPELLCAST_FAILED' ) then
					self.Text:SetText(FAILED);
				else
					self.Text:SetText(INTERRUPTED);
				end
				]]
				self.Text:SetText(RESET)
			end
			self.casting = nil;
			self.channeling = nil;
			self.fadeOut = true;
			self.holdTime = GetTime() + CASTING_BAR_HOLD_TIME;
			self.nextTextUpdate = 0
		end
	elseif ( event == 'UNIT_SPELLCAST_DELAYED' ) then
		if ( self:IsShown() ) then
			local notInterruptible
			local now = GetTime()
			local startTime, endTime = FindStartEndTime(self, now)
			if ( not startTime ) then
				self:Hide();
				return;
			end
			self.value = (now - startTime);
			self.maxValue = (endTime - startTime);
			self:SetMinMaxValues(0, self.maxValue);
			self.nextTextUpdate = 0
			if ( not self.casting ) then
				self:SetStatusBarColor(CastingBarFrame_GetEffectiveStartColor(self, false, notInterruptible):GetRGB());
				if ( self.isSparkEnabled ) then
					self.Spark:Show();
				end
				--[[
				if ( self.Flash ) then
					self.Flash:SetAlpha(0.0);
					self.Flash:Hide();
				end
				]]
				self.casting = true;
				self.channeling = nil;

				self.fadeOut = nil;
			end
		end
	elseif ( event == 'UNIT_SPELLCAST_CAST_UPDATE' ) then
		if ( self:IsShown() ) then
			local now = GetTime()
			local startTime, endTime = FindStartEndTime(self, now)
			if ( not startTime ) then
				self:Hide();
				return;
			end
			self.value = (now - startTime)
			self.maxValue = (endTime - startTime)
			self:SetMinMaxValues(0, self.maxValue);
			self:SetValue(self.value);
			self.nextTextUpdate = 0
		end
	elseif ( event == 'UNIT_SPELLCAST_CHANNEL_START' ) then
		local text, texture, notInterruptible = self.name
		local now = GetTime()
		local startTime, endTime = FindStartEndTime(self, now)
		if ( not startTime ) then
			self:Hide();
			return;
		end

		if info.isDeadOrOffline then
			self:SetStatusBarColor(0.3, 0.3, 0.3)
			self.BG:SetVertexColor(0.3, 0.3, 0.3)
			self.Text:SetTextColor(0.3, 0.3, 0.3)
		else
			local startColor, startBGColor, startTextColor = CastingBarFrame_GetEffectiveStartColor(self, true, notInterruptible);
			--[[
			if self.flashColorSameAsStart then
				self.Flash:SetVertexColor(startColor:GetRGB());
			else
				self.Flash:SetVertexColor(1, 1, 1);
			end
			]]
			self:SetStatusBarColor(startColor:GetRGBA());
			self.BG:SetVertexColor(startBGColor:GetRGBA())
			self.Text:SetTextColor(startTextColor:GetRGB())
		end

		self.value = endTime - now;
		self.maxValue = endTime - startTime;
		self:SetMinMaxValues(0, self.maxValue);
		self:SetValue(self.value);
		self.nextTextUpdate = 0
		if ( self.Text ) then
			self.Text:SetText(text);
		end
		--[[
		if ( self.Icon ) then
			self.Icon:SetTexture(texture);
		end
		]]
		if ( self.isSparkEnabled ) then
			self.Spark:Show();
		end
		CastingBarFrame_ApplyAlpha(self, 1.0);
		self.holdTime = 0;
		self.casting = nil;
		self.channeling = true;
		self.fadeOut = nil;
		--[[
		if ( self.BorderShield ) then
			if ( self.showShield and notInterruptible ) then
				self.BorderShield:Show();
				if ( self.BarBorder ) then
					self.BarBorder:Hide();
				end
			else
				self.BorderShield:Hide();
				if ( self.BarBorder ) then
					self.BarBorder:Show();
				end
			end
		end
		]]
		if ( self.showCastbar ) then
			self:Show();
		end
	elseif ( event == 'UNIT_SPELLCAST_CHANNEL_UPDATE' ) then
		if ( self:IsShown() ) then
			local now = GetTime()
			local startTime, endTime = FindStartEndTime(self, now)
			if ( not startTime ) then
				self:Hide();
				return;
			end
			self.value = (endTime - now)
			self.maxValue = endTime - startTime
			self:SetMinMaxValues(0, self.maxValue);
			self:SetValue(self.value);
			self.nextTextUpdate = 0
		end
	elseif ( event == 'UNIT_SPELLCAST_INTERRUPTIBLE' or event == 'UNIT_SPELLCAST_NOT_INTERRUPTIBLE' ) then
		CastingBarFrame_UpdateInterruptibleState(self, event == 'UNIT_SPELLCAST_NOT_INTERRUPTIBLE');
	end
end

P.unusedStatusBars = unusedStatusBars
P.CastingBarFrame_OnLoad = CastingBarFrame_OnLoad
P.CastingBarFrame_GetEffectiveStartColor = CastingBarFrame_GetEffectiveStartColor
