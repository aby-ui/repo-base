local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Timer"))
end
local L = Gladius.L
local LSM

-- Global Functions
local _G = _G
local floor = math.floor
local pairs = pairs
local strformat = string.format
local type = type

local CreateFrame = CreateFrame
local GetTime = GetTime
local IsInInstance = IsInInstance

local COOLDOWN_TYPE_NORMAL = COOLDOWN_TYPE_NORMAL

local Timer = Gladius:NewModule("Timer", false, false, {
	timerSoonFontSize = 18,
	timerSoonFontColor = {r = 1, g = 0, b = 0, a = 1},
	timerSecondsFontSize = 16,
	timerSecondsFontColor = {r = 1, g = 1, b = 0, a = 1},
	timerMinutesFontSize = 14,
	timerMinutesFontColor = {r = 0, g = 1, b = 0, a = 1},
	timerOmniCC = false,
})

function Timer:OnEnable()
	LSM = Gladius.LSM
	-- cooldown frames
	self.frames = self.frames or {}
end

function Timer:OnDisable()
	self:UnregisterAllEvents()
	self:Reset()
end

function Timer:Reset()
	-- It used to be left to each individual module to call
	-- HideTimer, however I feel that makes little sense and
	-- is very error prone.
	for frameName in pairs(self.frames) do
		self:HideTimer(_G[frameName])
	end
end

function Timer:GetAttachTo()
	return ""
end

function Timer:GetFrame(unit)
	return ""
end

function Timer:SetFormattedNumber(frame, number)
	local minutes = floor(number / 60)
	if minutes > 0 then
		local seconds = number - minutes * 60
		frame:SetFont(LSM:Fetch(LSM.MediaType.FONT, Gladius.db.globalFont), Gladius.db.timerMinutesFontSize, "OUTLINE")
		frame:SetTextColor(Gladius.db.timerMinutesFontColor.r, Gladius.db.timerMinutesFontColor.g, Gladius.db.timerMinutesFontColor.b, Gladius.db.timerMinutesFontColor.a)
		frame:SetText(strformat("%sm %.0f", minutes, seconds))
	else
		if number > 5 then
			frame:SetFont(LSM:Fetch(LSM.MediaType.FONT, Gladius.db.globalFont), Gladius.db.timerSecondsFontSize, "OUTLINE")
			frame:SetTextColor(Gladius.db.timerSecondsFontColor.r, Gladius.db.timerSecondsFontColor.g, Gladius.db.timerSecondsFontColor.b, Gladius.db.timerSecondsFontColor.a)
			frame:SetText(strformat("%.0f", number))
		else
			frame:SetFont(LSM:Fetch(LSM.MediaType.FONT, Gladius.db.globalFont), Gladius.db.timerSoonFontSize, "OUTLINE")
			frame:SetTextColor(Gladius.db.timerSoonFontColor.r, Gladius.db.timerSoonFontColor.g, Gladius.db.timerSoonFontColor.b, Gladius.db.timerSoonFontColor.a)
			if number == 0 then
				frame:SetText("")
			else
				frame:SetText(strformat("%.1f", number))
			end
		end
	end
end

function Timer:SetTimer(frame, duration, start, callback)
	if not self.frames or frame == nil then
		return
	end
	local start = start or GetTime()
	local frameName = frame:GetName()
	if not self.frames[frameName] then
		self:RegisterTimer(frame)
	end
	self:SetFormattedNumber(self.frames[frameName].text, duration)
	self.frames[frameName].duration = duration - (GetTime() - start)
	self.frames[frameName].text:SetAlpha(1)

	local cooldown = _G[frameName.."Cooldown"]
	cooldown:SetAlpha(self.frames[frameName].showSpiral and 1 or 0)
	cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")
	cooldown:SetSwipeColor(0, 0, 0)
	cooldown:SetDrawEdge(false)
	cooldown:SetDrawBling(false)
	--cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL

	if not cooldown.isDisabled then
		cooldown:SetCooldown(start, duration)
	end

	if duration > 0 and not Gladius.db.timerOmniCC and not self.frames[frameName].hideTimer then
		self.frames[frameName]:SetScript("OnUpdate", function(f, elapsed)
			f.duration = f.duration - elapsed
			if f.duration <= 0 then
				f.text:SetAlpha(0)
				f:SetScript("OnUpdate", nil)

				-- Call the callback if one was supplied.
				if type(callback) == 'function' then
					callback()
				end
			else
				self:SetFormattedNumber(f.text, f.duration)
			end
		end)
	end
end

function Timer:HideTimer(frame)
	if not self.frames then
		return
	end
	local frameName = frame:GetName()
	--_G[frameName.."Cooldown"]:SetCooldown(0, 0)
	_G[frameName.."Cooldown"]:Clear()

	if _G[frameName.."Cooldown"]:IsShown() then
		_G[frameName.."Cooldown"]:SetAlpha(0)
	end
	if self.frames[frameName] then
		self.frames[frameName]:SetScript("OnUpdate", nil)
		self.frames[frameName].text:SetAlpha(0)
	end
end

function Timer:RegisterTimer(frame, showSpiral, hideTimer)
	if not self.frames then
		return
	end
	local frameName = frame:GetName()
	if not self.frames[frameName] then
		self.frames[frameName] = CreateFrame("Frame", "Gladius"..self.name..frameName, frame)
		self.frames[frameName].name = frameName
		self.frames[frameName].text = self.frames[frameName]:CreateFontString("Gladius"..self.name..frameName.."Text", "OVERLAY")
	end
	self.frames[frameName].showSpiral = showSpiral or false
	self.frames[frameName].hideTimer = hideTimer or false
	if not Gladius.db.timerOmniCC and not hideTimer then
		_G[frameName.."Cooldown"].noCooldownCount = true
		self.frames[frameName].text:Show()
	else
		_G[frameName.."Cooldown"].noCooldownCount = false
		self.frames[frameName].text:Hide()
	end


	-- update frame
	self.frames[frameName]:SetAllPoints(frame)
	self.frames[frameName]:SetFrameStrata("HIGH")
	self.frames[frameName]:SetFrameLevel(100)
	self.frames[frameName].text:ClearAllPoints()
	self.frames[frameName].text:SetPoint("CENTER", self.frames[frameName])
	self.frames[frameName].text:SetShadowOffset(1, -1)
	self.frames[frameName].text:SetShadowColor(0, 0, 0, 1)
	-- hide
	self.frames[frameName].text:SetAlpha(0)
end

function Timer:GetOptions()
	return {
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
						timerOmniCC = {
							type = "toggle",
							name = L["Timer Use OmniCC"],
							desc = L["The timer module will use OmniCC for text display"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 2,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 4,
						},
						timerSoonFontColor = {
							type = "color",
							name = L["Timer Soon Color"],
							desc = L["Color of the timer when timeleft is less than 5 seconds."],
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b)
								return Gladius:SetColorOption(info, r, g, b, 1)
							end,
							hasAlpha = false,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						timerSoonFontSize = {
							type = "range",
							name = L["Timer Soon Size"],
							desc = L["Text size of the timer when timeleft is less than 5 seconds."],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = 1,
							max = 20,
							step = 1,
							order = 10,
						},
						sep1 = {
							type = "description",
							name = "",
							width = "full",
							order = 13,
						},
						timerSecondsFontColor = {
							type = "color",
							name = L["Timer Seconds Color"],
							desc = L["Color of the timer when timeleft is less than 60 seconds."],
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b)
								return Gladius:SetColorOption(info, r, g, b, 1)
							end,
							hasAlpha = false,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 15,
						},
						timerSecondsFontSize = {
							type = "range",
							name = L["Timer Seconds Size"],
							desc = L["Text size of the timer when timeleft is less than 60 seconds."],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = 1,
							max = 20,
							step = 1,
							order = 20,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 23,
						},
						timerMinutesFontColor = {
							type = "color",
							name = L["Timer Minutes Color"],
							desc = L["Color of the timer when timeleft is greater than 60 seconds."],
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b)
								return Gladius:SetColorOption(info, r, g, b, 1)
							end,
							hasAlpha = false,
							disabled = function() return not Gladius.dbi.profile.modules[self.name] end,
							order = 25,
						},
						timerMinutesFontSize = {
							type = "range",
							name = L["Timer Minutes Size"],
							desc = L["Text size of the timer when timeleft is greater than 60 seconds."],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = 1,
							max = 20,
							step = 1,
							order = 30,
						},
					},
				},
			},
		},
	}
end