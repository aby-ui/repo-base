local AddonName = ...
local Grid = Grid
local GridFrame = Grid:GetModule("GridFrame")
local GridIndicatorsDynamic = Grid:GetModule(AddonName)
local Media = LibStub("LibSharedMedia-3.0")

local strsub = string.utf8sub or string.sub

local n2s, GetTime, pairs, floor = n2s or tostring, GetTime, pairs, floor
local activeFrames = {}  --all text indicator that starts duration
local INTERVAL, WARNING_TIME = 0.3, 5
local function update()
    for indicator, _ in pairs(activeFrames) do
        if(indicator._expire) then
            local timeLeft = indicator._expire - GetTime()
            if timeLeft >= 0 then
                indicator.text:SetText(timeLeft > 99 and "#" or n2s(floor(timeLeft)))
                if indicator._durationColor and timeLeft < WARNING_TIME then
                    indicator.text:SetTextColor(1, 0.2, 0.2, 1)
                end
            else
                indicator.text:SetText("")
                indicator._expire = nil
                activeFrames[indicator] = nil
            end
        end
    end
    --if not once then stopTimer end  --not really necessary
end

LibStub('AceTimer-3.0'):ScheduleRepeatingTimer(update, INTERVAL);

local function New(frame)
	local textFrame = CreateFrame("Frame", nil, frame)
	textFrame.text = textFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	textFrame.text:SetAllPoints()
	return textFrame
end

local function Reset(self)
	local profile = GridIndicatorsDynamic.db.profile[self.__id]
	if not profile then
		return
	end
	local font = Media:Fetch("font", profile.font) or STANDARD_TEXT_FONT

	local bar = self.__owner.indicators.bar

	self:SetParent(bar)
	self:SetFrameLevel(bar:GetFrameLevel() + profile.frameLevel)
	self.text:SetFont(font, profile.fontSize, profile.fontOutline)

	if profile.fontShadow then
		self.text:SetShadowOffset(1, -1)
	else
		self.text:SetShadowOffset(0, 0)
	end

	if profile.invertBarColor and profile.invertTextColor then
		self.text:SetShadowColor(1, 1, 1)
	else
		self.text:SetShadowColor(0, 0, 0)
	end

	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", 0, 0)
	self:SetPoint("BOTTOMRIGHT", self:GetParent(), "BOTTOMRIGHT", 0, 0)
	self.text:ClearAllPoints()
	self.text:SetPoint(profile.anchor, profile.offsetX, profile.offsetY)
end

local function SetStatus(self, color, text, value, maxValue, texture, texCoords, stack, start, duration)
	local profile = GridIndicatorsDynamic.db.profile[self.__id]

    activeFrames[self] = nil
    local c = text and text:byte(1) or 0
    if profile.forceDuration and start and duration and duration > 0 and (c < 48 or c > 57) then
        --if first character is not number, then start our timer. otherwise, use grid origin updater. -- and ( stack == nil or n2s(stack) ~= text ) then
        self._expire = start + duration
        activeFrames[self] = true
        local timeLeft = self._expire - GetTime()
        self.text:SetText(timeLeft > 99 and "#" or n2s(floor(timeLeft)))
        self._durationColor = profile.durationColor
    else
        if not text or text == "" then
            return self.text:SetText("")
        end

        self.text:SetText(strsub(text, 1, profile.textlength))
    end

	if color then
		if profile.invertBarColor and profile.invertTextColor then
			self.text:SetTextColor(color.r * 0.2, color.g * 0.2, color.b * 0.2, color.a or 1)
		else
			self.text:SetTextColor(color.r, color.g, color.b, color.a or 1)
		end
	end
end

local function Clear(self)
	self.text:SetText("")
    self._expire = nil
    activeFrames[self] = nil
end

function GridIndicatorsDynamic:Text_RegisterIndicator(id, name)
	GridFrame:RegisterIndicator(id, name,
		New,
		Reset,
		SetStatus,
		Clear
	)
end