local Ellipsis	= _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis')
local LSM		= LibStub('LibSharedMedia-3.0')
local Aura		= CreateFrame('Frame')

local auraPool		= Ellipsis.auraPool
local activeAuras	= Ellipsis.activeAuras
local auraID		= 1 -- unique ID for each aura object created

local TIME_ABRV_HOUR 	= '%dhr'
local TIME_ABRV_MINS 	= '%dm'
local TIME_ABRV_SECS 	= '%ds'
local TIME_ABRV_TENS	= '%.1fs'

local TIME_FULL_HOUR 	= '%d:%02d:%02d'
local TIME_FULL_MINS 	= '%d:%02d'
local TIME_FULL_SECS 	= '%.0f'
local TIME_FULL_TENS 	= '%.1f'

local FORMAT_UNIT_AURA	= '%s: %s'

local floor, ceil = math.floor, math.ceil
local tinsert, tremove = table.insert, table.remove
local unpack, pairs = unpack, pairs

local auraDB

-- variables configured by user options
local highR, highG, highB, medR, medG, medB, lowR, lowG, lowB
local pointBarTop, pointBarBot, pointIconTop, pointIconBot
local unitWidth, sendAlerts, ghostingEnabled, ghostDuration
local tickRate = 1 -- set to initial value to delay OnUpdate until options are configured
local FormatRemainingTime -- function ref, set by user options

Ellipsis.Aura = Aura


-- ------------------------
-- AURA DISPLAY HELPERS
-- ------------------------
local function ColourizeRemainingTime(time)
	if (time > 10) then				-- high (> 10s)
		return highR, highG, highB
	else
		local colourMod, colourInv

		if (time > 5) then			-- med (5 - 10s)
			colourMod = (time / 5) - 1
			colourInv = 1 - colourMod

			return (medR * colourInv + highR * colourMod), (medG * colourInv + highG * colourMod), (medB * colourInv + highB * colourMod)
		else						-- low (<= 5s)
			colourMod = (time / 5)
			colourInv = 1 - colourMod

			return (lowR * colourInv + medR * colourMod), (lowG * colourInv + medG * colourMod), (lowB * colourInv + medB * colourMod)
		end
	end
end

local function SecondsToTime_Abrv(time)
	if (time < 10) then
		return TIME_ABRV_TENS, time					-- tenths of a second
	elseif (time < 61) then
		return TIME_ABRV_SECS, time					-- seconds
	elseif (time < 3601) then
		return TIME_ABRV_MINS, ceil(time / 60)		-- minutes
	else
		return TIME_ABRV_HOUR, ceil(time / 3600)	-- hours
	end
end

local function SecondsToTime_Trun(time)
	if (time < 10) then
		return TIME_FULL_TENS, time					-- tenths of a second
	elseif (time < 61) then
		return TIME_FULL_SECS, time					-- seconds
	elseif (time < 3601) then
		local mins = floor(time / 60)				-- minutes
		return TIME_FULL_MINS, mins, time - (mins * 60)
	else
		return TIME_ABRV_HOUR, ceil(time / 3600)	-- hours
	end
end

local function SecondsToTime_Full(time)
	if (time < 10) then
		return TIME_FULL_TENS, time					-- tenths of a second
	elseif (time < 61) then
		return TIME_FULL_SECS, time					-- seconds
	elseif (time < 3601) then
		local mins = floor(time / 60)				-- minutes
		return TIME_FULL_MINS, mins, time - (mins * 60)
	else
		local hours = floor(time / 3600)			-- hours
		local mins = floor((time - (hours * 3600)) / 60)
		return TIME_FULL_HOUR, hours, mins, time - (hours * 3600) - (mins * 60)
	end
end


-- ------------------------
-- ONUPDATE SCRIPT HANDLER
do ------------------------
	local GetTime	= GetTime
	local throttle	= 0

	local function OnUpdate(self, elapsed)
		throttle = throttle + elapsed

		if (throttle >= tickRate) then
			local currentTime = GetTime()
			local remaining

			for _, aura in pairs(activeAuras) do
				if (aura.expireTime > 0) then -- we only care about updating the data of non-passive auras
					remaining = aura.expireTime - currentTime

					if (remaining > 12) then -- active, and doesn't need to be colourized
						aura.bar:SetValue(remaining / aura.duration)

						aura.time:SetFormattedText(FormatRemainingTime(remaining))
					elseif (remaining > 0) then -- active, and needs to be colourized
						aura.border:SetVertexColor(ColourizeRemainingTime(remaining))

						aura.bar:SetValue(remaining / aura.duration)
						aura.bar:SetStatusBarColor(ColourizeRemainingTime(remaining))

						aura.time:SetFormattedText(FormatRemainingTime(remaining))
					elseif (remaining <= ghostDuration) then -- ghost timer has expired, remove aura
						aura:Release()
					elseif (not aura.expired) then -- aura hasn't been set as expired (but is), set expired state
						aura:SetExpired(currentTime)
					end
				end
			end

			throttle = throttle - tickRate
		end
	end

	Aura:SetScript('OnUpdate', OnUpdate)
end


-- ------------------------
-- AURA SCRIPT HANDLERS
-- ------------------------
local function OnClick(self, button)
	if (button == 'LeftButton') then
        if IsControlKeyDown() and IsAltKeyDown() then
            if Ellipsis.db.profile.locked then Ellipsis:UnlockInterface() else Ellipsis:LockInterface() end --163ui
        else
		    Ellipsis:Announce(self)
        end
	elseif (button == 'RightButton') then
		if (IsShiftKeyDown()) then
			if (self.spellID > 0) then -- only allow (un)blocking of actual spellIDs and not 'faked' ones
				Ellipsis:FilterAura(self.spellID)
			end
		else
			self:Release()
		end
	end
end

local function OnEnter(self)
	if (not self.isMouseOver) then
		self.isMouseOver = true

		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')

		if (auraDB.tooltips == 'FULL' and self.spellID > 0) then
			GameTooltip:SetSpellByID(self.spellID)
		else
			GameTooltip:SetText(self.spellName, 1, 1, 1)
		end

		GameTooltip:AddLine(self.spellID > 0 and L.AuraTooltip or L.AuraTooltipNoBlock)
		GameTooltip:Show()
	end
end

local function OnLeave(self)
	if (self.isMouseOver) then
		self.isMouseOver = false

		GameTooltip:Hide()
	end
end


-- ------------------------
-- AURA CREATION
-- ------------------------
local function CreateAura(parentUnit)
	local new = CreateFrame('Button', nil, parentUnit)
	local widget

	-- main gui widgets
	widget = new:CreateTexture(nil, 'BORDER')
	widget:SetPoint(pointIconTop, new, pointIconTop)
	widget:SetPoint(pointIconBot, new, pointIconBot)
	widget:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	new.icon = widget

	widget = new:CreateTexture(nil, 'ARTWORK')
	widget:SetPoint('TOPLEFT', new.icon, 'TOPLEFT')
	widget:SetPoint('BOTTOMRIGHT', new.icon, 'BOTTOMRIGHT')
	widget:SetTexCoord(0.03125, 0.96875, 0.03125, 0.96875)
	widget:SetTexture('Interface\\AddOns\\Ellipsis\\IconBorder')
	new.border = widget

	widget = CreateFrame('StatusBar', nil, new)
	widget:SetPoint(pointBarTop, new, pointBarTop)
	widget:SetPoint(pointBarBot, new, pointBarBot)
	widget:SetFrameLevel(widget:GetFrameLevel() - 1) -- ensure bar is behind the base frame (where text is anchored)
	widget:SetMinMaxValues(0, 1)
	new.bar = widget

	widget = new.bar:CreateTexture(nil, 'BACKGROUND')
	widget:SetAllPoints()
	new.barBG = widget

	-- fontStrings
	widget = new:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
	widget:SetPoint('BOTTOMRIGHT', new.icon, 'BOTTOMRIGHT', 0.5, 0)
	widget:SetJustifyH('RIGHT')
	widget:SetJustifyV('BOTTOM')
	new.stacks = widget

	widget = new:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	new.time = widget

	widget = new:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	widget:SetJustifyH('LEFT')
	widget:SetJustifyV('MIDDLE')
	new.name = widget

	new.parentUnit	= parentUnit
	new.auraID		= auraID
	auraID			= auraID + 1

	new['Release']			= Aura.Release
	new['Configure']		= Aura.Configure
	new['SetExpired']		= Aura.SetExpired
	new['Update']			= Aura.Update


	return new
end

function Aura:New(currentTime, parentUnit, spellID, spellName, spellIcon, duration, expireTime, stackCount)
	local new = tremove(auraPool, 1) -- grab an aura from the inactive pool (if any)

	if (not new) then -- no inactive auras, create new
		new = CreateAura(parentUnit)
		new:Configure()
	else -- existing object, set physical parent as well as parent lookup
		new:SetParent(parentUnit)
		new.parentUnit = parentUnit
	end

	new.created		= currentTime
	new.updated		= currentTime
	new.expired		= false			-- new aura, cannot be expired

	new.spellID		= spellID
	new.spellName	= spellName
	new.duration	= duration
	new.expireTime	= expireTime
	new.stackCount	= stackCount

	new.icon:SetTexture(spellIcon)
	new.icon:SetDesaturated(false)

	new.stacks:SetText(stackCount > 1 and stackCount or '')

	if (auraDB.textFormat == 'AURA') then
		new.name:SetText(spellName)
	elseif (auraDB.textFormat == 'UNIT') then
		new.name:SetText(new.parentUnit.unitName)
	else
		new.name:SetFormattedText(FORMAT_UNIT_AURA, new.parentUnit.unitName, spellName)
	end

	if (duration == 0) then -- passive effect
		new.border:SetVertexColor(unpack(auraDB.colourHigh))
		new.bar:SetValue(1)
		new.bar:SetStatusBarColor(unpack(auraDB.colourHigh))
		new.time:SetText(L.Aura_Passive)
	else
		local remaining = expireTime - currentTime

		new.border:SetVertexColor(ColourizeRemainingTime(remaining))
		new.bar:SetValue(remaining / duration)
		new.bar:SetStatusBarColor(ColourizeRemainingTime(remaining))
		new.time:SetFormattedText(FormatRemainingTime(remaining))
	end

	new:Show()

	activeAuras[new.auraID] = new -- add new aura to primary aura lookup

	return new
end

-- ------------------------
-- AURA FUNCTIONS
-- ------------------------
function Aura:Release(flagBurst)
	self:Hide()

	activeAuras[self.auraID] = nil	-- remove self from aura lookup

	if (not flagBurst) then	-- tell parent Unit to remove ourselves, but only if this isn't a burst removal (eg, Unit death)
		self.parentUnit:RemoveAura(self.spellID)
	end

	tinsert(auraPool, self)	-- add self back into the auraPool (do last so we can't be used again before our Unit lets us go)
end

function Aura:Configure()
	-- common configuration between styles
	if (auraDB.interactive) then
		self:EnableMouse(true)
		self:SetScript('OnClick', OnClick)
		self:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

		if (auraDB.tooltips ~= 'OFF') then
			self:SetScript('OnEnter', OnEnter)
			self:SetScript('OnLeave', OnLeave)
		else
			self:SetScript('OnEnter', nil)
			self:SetScript('OnLeave', nil)
		end
	else
		self:EnableMouse(false) -- non-interactive, disable all mouse capture
	end

	self.stacks:SetFont(LSM:Fetch('font', auraDB.stacksFont), auraDB.stacksFontSize, 'OUTLINE')
	self.stacks:SetTextColor(unpack(auraDB.colourStacks))

	self.time:SetFont(LSM:Fetch('font', auraDB.textFont), auraDB.textFontSize)
	self.time:SetTextColor(unpack(auraDB.colourText))
	self.time:ClearAllPoints()

	self.name:ClearAllPoints()

	if (auraDB.style == 'BAR') then
		self:SetWidth(unitWidth)
		self:SetHeight(auraDB.barSize)

		self.icon:SetWidth(auraDB.barSize)

		self.bar:SetWidth(unitWidth - auraDB.barSize) -- bar is the full width of the aura object minus the width of the icon
		self.bar:SetStatusBarTexture(LSM:Fetch('statusbar', auraDB.barTexture))
		self.bar:Show()

		self.barBG:SetTexture(LSM:Fetch('statusbar', auraDB.barTexture))
		self.barBG:SetVertexColor(unpack(auraDB.colourBarBackground))

		self.time:SetPoint('RIGHT', self.bar, 'RIGHT', -3, 0)
		self.time:SetJustifyH('RIGHT')
		self.time:SetJustifyV('MIDDLE')

		self.name:SetHeight(auraDB.barSize)
		self.name:SetPoint('LEFT', self.bar, 'LEFT', 3, 0)
		self.name:SetPoint('RIGHT', self.time, 'LEFT', -4, 0)
		self.name:SetFont(LSM:Fetch('font', auraDB.textFont), auraDB.textFontSize)
		self.name:SetTextColor(unpack(auraDB.colourText))
		self.name:Show()
	else -- auraDB.style == 'ICON'
		self:SetWidth(auraDB.iconSize)
		self:SetHeight(auraDB.iconSize)

		self.icon:SetWidth(auraDB.iconSize)

		self.bar:Hide()

		self.time:SetPoint('TOP', self, 'BOTTOM', 0, -1)
		self.time:SetJustifyH('CENTER')
		self.time:SetJustifyV('TOP')

		self.name:Hide()
	end
end

function Aura:SetExpired(currentTime)
	if (self.expired) then return end -- already set as expired

	currentTime = currentTime or GetTime() -- we need a time value, make sure we have one

	local broken = (currentTime + 0.5) < self.expireTime -- check if aura expired early (with a bit of slush time)

	if (sendAlerts) then
		Ellipsis:AlertAura(broken, self) -- send appropriate alert if watching for alerts
	end

	if (not ghostingEnabled) then -- not using the ghosting system, aura is gone
		self:Release()
	else
		self.expired		= true
		self.expireTime		= currentTime	-- make sure to update expiration for proper ghost duration
		self.stackCount		= 0				-- if ghosting, then aura has faded, thus stacks have too

		self.icon:SetDesaturated(true)
		self.border:SetVertexColor(unpack(auraDB.colourGhosting))

		self.bar:SetValue(1)
		self.bar:SetStatusBarColor(unpack(auraDB.colourGhosting))

		self.stacks:SetText('')
		self.time:SetText('')

		if (broken) then
			self.parentUnit:UpdateDisplay(true) -- parent Unit needs to update display due to an early break
		end
	end
end

function Aura:Update(currentTime, duration, expireTime, stackCount)
	if (self.expired) then -- a verified, active aura obviously isnt expired anymore, undo ghosting if active
		self.expired = false
		self.icon:SetDesaturated(false)
	end

	self.updated	= currentTime
	self.duration	= duration
	self.expireTime	= expireTime

	if (duration == 0) then -- passive effect
		self.border:SetVertexColor(unpack(auraDB.colourHigh))
		self.bar:SetValue(1)
		self.bar:SetStatusBarColor(unpack(auraDB.colourHigh))
		self.time:SetText(L.Aura_Passive)
	else
		local remaining = expireTime - currentTime

		self.border:SetVertexColor(ColourizeRemainingTime(remaining))
		self.bar:SetValue(remaining / duration)
		self.bar:SetStatusBarColor(ColourizeRemainingTime(remaining))
		self.time:SetFormattedText(FormatRemainingTime(remaining))
	end

	if (stackCount ~= self.stackCount) then -- stack change
		self.stackCount = stackCount
		self.stacks:SetText((stackCount > 1) and stackCount or '')
	end
end


-- ------------------------
-- AURA OBJECT FUNCTIONS
-- ------------------------
function Ellipsis:InitializeAuras()
	auraDB = self.db.profile.auras

	self:ConfigureAuras()
end

function Ellipsis:ConfigureAuras()
	unitWidth		= self.db.profile.units.width
	tickRate		= self.db.profile.advanced.tickRate

	if (auraDB.flipIcon) then
		pointBarTop		= 'TOPLEFT'
		pointBarBot		= 'BOTTOMLEFT'
		pointIconTop	= 'TOPRIGHT'
		pointIconBot	= 'BOTTOMRIGHT'
	else
		pointBarTop		= 'TOPRIGHT'
		pointBarBot		= 'BOTTOMRIGHT'
		pointIconTop	= 'TOPLEFT'
		pointIconBot	= 'BOTTOMLEFT'
	end

	ghostingEnabled	= auraDB.ghosting
	ghostDuration	= auraDB.ghostDuration * -1

	sendAlerts = (self.db.profile.notify.auraBrokenAlerts or self.db.profile.notify.auraExpiredAlerts)

	highR, highG, highB	= unpack(auraDB.colourHigh)
	medR, medG, medB	= unpack(auraDB.colourMed)
	lowR, lowG, lowB	= unpack(auraDB.colourLow)

	if (auraDB.timeFormat == 'ABRV') then
		FormatRemainingTime = SecondsToTime_Abrv
	elseif (auraDB.timeFormat == 'FULL') then
		FormatRemainingTime = SecondsToTime_Full
	else -- auraDB.timeFormat == 'TRUN'
		FormatRemainingTime = SecondsToTime_Trun
	end
end

function Ellipsis:UpdateExistingAuras()
	for _, aura in pairs(auraPool) do
		aura:Configure()
	end

	for _, aura in pairs(activeAuras) do
		aura:Configure()

		if (aura.expired) then -- expired aura
			aura.border:SetVertexColor(unpack(auraDB.colourGhosting))
			aura.bar:SetStatusBarColor(unpack(auraDB.colourGhosting))
		else -- actively timed aura, set to 'high' colour (if its <12s OnUpdate will correct this, bit lazy but lot less hassle to code)
			aura.border:SetVertexColor(unpack(auraDB.colourHigh))
			aura.bar:SetStatusBarColor(unpack(auraDB.colourHigh))
		end

		if (auraDB.textFormat == 'AURA') then
			aura.name:SetText(aura.spellName)
		elseif (auraDB.textFormat == 'UNIT') then
			aura.name:SetText(aura.parentUnit.unitName)
		else
			aura.name:SetFormattedText(FORMAT_UNIT_AURA, aura.parentUnit.unitName, aura.spellName)
		end

		aura.icon:ClearAllPoints()
		aura.icon:SetPoint(pointIconTop, aura, pointIconTop)
		aura.icon:SetPoint(pointIconBot, aura, pointIconBot)

		aura.bar:ClearAllPoints()
		aura.bar:SetPoint(pointBarTop, aura, pointBarTop)
		aura.bar:SetPoint(pointBarBot, aura, pointBarBot)
	end
end
