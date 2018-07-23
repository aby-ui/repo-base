--[[
	timer.lua
		Displays countdowns on widgets
--]]

local OmniCC, GetTime = OmniCC, GetTime
local Timer = OmniCC:New('Timer')

local IconSize = 36
local Padding = 0

local L = OMNICC_LOCALS
local Day, Hour, Minute = 86400, 3600, 60
local Dayish, Hourish, Minuteish, Soonish = 3600 * 23.5, 60 * 59.5, 59.5, 5.5
local HalfDayish, HalfHourish, HalfMinuteish = Day/2 + 0.5, Hour/2 + 0.5, Minute/2 + 0.5

local floor, min, type = floor, min, type
local round = function(x) return floor(x + 0.5) end


--[[ Constructor ]]--

function Timer:New(cooldown)
	local timer = Timer:Bind(CreateFrame('Frame', nil, cooldown:GetParent()))
	timer:SetFrameLevel(cooldown:GetFrameLevel() + 5)
	timer:Hide()

	timer.text = timer:CreateFontString(nil, 'OVERLAY')
	timer.cooldown = cooldown

	timer:SetPoint('CENTER', cooldown)
	timer:UpdateFontSize(cooldown:GetSize())
	return timer
end


--[[ Controls ]]--

function Timer:Start(start, duration, charge)
	self.start, self.duration = start, duration
	self.controlled = self.cooldown.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL
	self.charging = not self.cooldown:GetDrawSwipe() --self.cooldown:GetDrawEdge()
	self.visible = self.cooldown:IsVisible()
	self.finish = start + duration
	self.textStyle = nil
	self.enabled = true

	-- hotfix for ChargeCooldowns
	local parent = self.cooldown:GetParent()
	local charge = parent and parent.chargeCooldown
	local chargeTimer = charge and charge.omnicc
	if chargeTimer and chargeTimer ~= self then
		chargeTimer:Stop()
	end

	self:UpdateShown()
end

function Timer:Stop()
	self.start, self.duration, self.enabled, self.visible, self.textStyle = nil
	self:CancelUpdate()
	self:Hide()
end


--[[ Update Schedules ]]--

function Timer:ScheduleUpdate(delay)
	local engine = OmniCC:GetUpdateEngine()
	local updater = engine:Get(self)

	updater:ScheduleUpdate(delay)
end

function Timer:CancelUpdate()
	local engine = OmniCC:GetUpdateEngine()
	local updater = engine:GetActive(self)

	if updater then
		updater:CancelUpdate()
	end
end


--[[ Redraw ]]--

function Timer:UpdateFontSize(width, height)
	self.abRatio = round(width) / IconSize

	self:SetSize(width, height)
	self:UpdateTextPosition()

	if self.enabled and self.visible then
		self:UpdateText(true)
	end
end

function Timer:UpdateText(forceStyleUpdate)
	if self.start and self.start > (GetTime() or 0) then
		return self:ScheduleUpdate(self.start - (GetTime() or 0))
	end

	local remain = self:GetRemain()
	if remain > 0 then
		local overallScale = self.abRatio * (self:GetEffectiveScale()/UIParent:GetScale())

		if overallScale < self:GetSettings().minSize then
			self.text:Hide()
			self:ScheduleUpdate(1)
		else
			local style = self:GetTextStyle(remain)
			if (style ~= self.textStyle) or forceStyleUpdate then
				self.textStyle = style
				self:UpdateTextStyle()
			end

			if self.text:GetFont() then
				self.text:SetFormattedText(self:GetTimeText(remain))
				self.text:Show()
			end

			self:ScheduleUpdate(self:GetNextUpdate(remain))
		end
	else
		if self.duration and self.duration >= self:GetSettings().minEffectDuration then
			OmniCC:TriggerEffect(self.cooldown)
		end

		self:Stop()
	end
end

function Timer:UpdateTextStyle()
	local sets = self:GetSettings()
	local font, size, outline = sets.fontFace, sets.fontSize, sets.fontOutline
	local style = sets.styles[self.textStyle]

	if sets.scaleText then
		size = size * style.scale * (self.abRatio or 1)
	else
		size = size * style.scale
	end

	if size > 0 then
		if not self.text:SetFont(font, size, outline) then
			self.text:SetFont(STANDARD_TEXT_FONT, size, outline)
		end
	end

	self.text:SetTextColor(style.r, style.g, style.b, style.a)
end

function Timer:UpdateTextPosition()
	local sets = self:GetSettings()
	local abRatio = self.abRatio or 1

	local text = self.text
	text:ClearAllPoints()
	text:SetPoint(sets.anchor, sets.xOff * abRatio, sets.yOff * abRatio)
end

function Timer:UpdateShown()
	if self:ShouldShow() then
		self:Show()
		self:UpdateText()
	else
		self:Hide()
	end
end


--[[ Accessors ]]--

function Timer:GetRemain()
	return self.finish - (GetTime() or 0)
end

function Timer:GetTextStyle(remain)
	if self.controlled then
		return 'controlled'
	elseif self.charging then
		return 'charging'
	elseif remain < Soonish then
		return 'soon'
	elseif remain < Minuteish then
		return 'seconds'
	elseif remain <  Hourish then
		return 'minutes'
	else
		return 'hours'
	end
end

function Timer:GetNextUpdate(remain)
	local sets = self:GetSettings()

	if remain < (sets.tenthsDuration + 0.5) then
		return 0.1

	elseif remain < Minuteish then
		return remain - round(remain) + 0.51

	elseif remain < sets.mmSSDuration then
		return remain - round(remain) + 0.51

	elseif remain < Hourish then
		local minutes = round(remain/Minute)
		if minutes > 1 then
			return remain - (minutes*Minute - HalfMinuteish)
		end
		return remain - Minuteish + 0.01

	elseif remain < Dayish then
		local hours = round(remain/Hour)
		if hours > 1 then
			return remain - (hours*Hour - HalfHourish)
		end
		return remain - Hourish + 0.01

	else
		local days = round(remain/Day)
		if days > 1 then
			return remain - (days*Day - HalfDayish)
		end
		return remain - Dayish + 0.01
	end
end

function Timer:GetTimeText(remain)
	local sets = self:GetSettings()

	if remain < sets.tenthsDuration then
		return L.TenthsFormat, remain
	elseif remain < Minuteish then
		local seconds = round(remain)
		return seconds ~= 0 and seconds or ''
	elseif remain < sets.mmSSDuration then
		local seconds = round(remain)
		return L.MMSSFormat, seconds/Minute, seconds%Minute
	elseif remain < Hourish then
		return L.MinuteFormat, round(remain/Minute)
	elseif remain < Dayish then
		return L.HourFormat, round(remain/Hour)
	else
		return L.DayFormat, round(remain/Day)
	end
end

function Timer:ShouldShow()
	if not (self.enabled and self.visible) or self.cooldown.noCooldownCount then
		return false
	end

	local sets = self:GetSettings()
	if self.duration < sets.minDuration then
		return false
	end

	return sets.enabled
end


--[[ Utilities ]]--

function Timer:ForAll(func, ...)
	func = self[func]

	for cooldown in pairs(OmniCC.Cache) do
		if cooldown.omnicc and cooldown.omnicc:IsShown() then
			func(cooldown.omnicc, ...)
		end
	end
end

function Timer:GetSettings()
	return OmniCC:GetGroupSettingsFor(self.cooldown)
end
