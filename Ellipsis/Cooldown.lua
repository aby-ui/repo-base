local Ellipsis		= _G['Ellipsis']
local L				= LibStub('AceLocale-3.0'):GetLocale('Ellipsis')
local LSM			= LibStub('LibSharedMedia-3.0')
local Cooldown		= CreateFrame('Frame', nil, UIParent)
local CooldownTimer	= {}

local timerPool			= {}
local activeTimers		= {}
local activeTimersCount = 0

local tagDataBase		= {0, 10, 60, 300, 900, 1800, 3600}
local tagDataDetail		= {0, 2, 10, 30, 60, 120, 300, 600, 900, 1200, 1500, 1800, 2700, 3600}

local math_pow, math_min = math.pow, math.min
local tinsert, tremove = table.insert, table.remove
local unpack, ipairs, pairs = unpack, ipairs, pairs

local GetInventoryItemCooldown, GetInventoryItemID, GetItemInfo = GetInventoryItemCooldown, GetInventoryItemID, GetItemInfo
local GetContainerItemCooldown, GetContainerItemID, GetContainerNumSlots = GetContainerItemCooldown, GetContainerItemID, GetContainerNumSlots
local GetSpellBookItemInfo, GetSpellCooldown, GetSpellInfo = GetSpellBookItemInfo, GetSpellCooldown, GetSpellInfo
local BOOKTYPE_PET, BOOKTYPE_SPELL = BOOKTYPE_PET, BOOKTYPE_SPELL

local GetTime = GetTime

local anchorData, cooldownDB

-- variables configured by user options
local blacklistITEM, blacklistSPELL, durationMin, durationMax
local horizontal, length, thickness
local onlyWhenTracking, sendAlerts
local tickRate = 1 -- set to initial value to delay OnUpdate until options are configured

-- pre calculated variables (based on user config)
local maxTime, endPadding, workLength

Ellipsis.Cooldown = Cooldown
Ellipsis.CooldownTimer = CooldownTimer
Ellipsis.Cooldown.activeTimers = activeTimers


local function EventRegistration(event, register)
	if (register) then
		Cooldown:RegisterEvent(event)
		Cooldown[event](Cooldown)
	else
		Cooldown:UnregisterEvent(event)
	end
end


-- ------------------------
-- COOLDOWN INIT
-- ------------------------
function Ellipsis:InitializeCooldowns()
	-- unlike for all the aura handling, cooldowns are entirely self-contained (and only fully init'd if enabled)
	anchorData		= self.db.profile.anchorData.CD
	cooldownDB		= self.db.profile.cooldowns
	blacklistITEM	= cooldownDB.blacklist.ITEM
	blacklistSPELL	= cooldownDB.blacklist.SPELL

	Cooldown:SetMovable(true)
	Cooldown:SetClampedToScreen(true)
	Cooldown.anchorID = 'CD' -- used to allow us to easily attach an overlay frame

	Cooldown:Configure()
end


-- ------------------------
-- ONUPDATE SCRIPT HANDLER
-- ------------------------
local throttle = 0

local function OnUpdate(self, elapsed)
	throttle = throttle + elapsed

	if (throttle >= tickRate) then
		local currentTime = GetTime()
		local remaining, pos

		for _, timer in pairs(activeTimers) do
			remaining = timer.expireTime - currentTime

			if (timer.expired) then -- cooldown complete, either pulse or release
				if (remaining <= -0.6) then -- pulse is over, release
					timer:Release()
				else
					timer:SetWidth(thickness * (1 + (4.2 * remaining * -1)))
					timer:SetHeight(thickness * (1 + (4.2 * remaining * -1)))
					timer:SetAlpha(1 + (2.1 * remaining))
				end
			else
				pos = math_pow(remaining / maxTime, 0.4) * workLength
				if (pos < 0) then pos = 0 elseif (pos > workLength) then pos = workLength end

				if (horizontal) then
					timer:SetPoint('CENTER', self.bar, 'LEFT', endPadding + pos, timer.offset)
				else
					timer:SetPoint('CENTER', self.bar, 'BOTTOM', timer.offset, endPadding + pos)
				end

				if (remaining <= 0) then
					timer:SetExpired(currentTime)
				end
			end
		end

		throttle = throttle - tickRate
	end
end


-- ------------------------
-- EVENT HANDLERS
-- ------------------------
local bagUpdateLimiter = 0 -- this event gets called repeatedly, block those that happen in the same timestamp

function Cooldown:BAG_UPDATE_COOLDOWN()
	local currentTime = GetTime()

	if (currentTime == bagUpdateLimiter) then return end

	local start, duration
	local name, icon, itemID
	local timer

	local index			= 1

	for slot = 1, 19 do
		start, duration = GetInventoryItemCooldown('player', slot)

		if (duration > durationMin and duration < durationMax) then
			itemID = GetInventoryItemID('player', slot)

			if (not blacklistITEM[itemID]) then
				name, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)

				timer = activeTimers['ITEM' .. itemID]

				if (timer) then
					if (start ~= timer.startTime) then
						timer:Update(start, duration)
					end

					timer.updated = currentTime
				else
					CooldownTimer:New(currentTime, 'ITEM', itemID, name, icon, start, duration)
				end
			end
		end
	end

	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			start, duration = GetContainerItemCooldown(bag, slot)

			if (duration > durationMin and duration < durationMax) then
				itemID = GetContainerItemID(bag, slot)

				if (not blacklistITEM[itemID]) then
					name, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)

					timer = activeTimers['ITEM' .. itemID]

					if (timer) then
						if (start ~= timer.startTime) then
							timer:Update(start, duration)
						end

						timer.updated = currentTime
					else
						CooldownTimer:New(currentTime, 'ITEM', itemID, name, icon, start, duration)
					end
				end
			end
		end
	end

	bagUpdateLimiter = currentTime
end

function Cooldown:PLAYER_EQUIPMENT_CHANGED()
	self:BAG_UPDATE_COOLDOWN()
end

function Cooldown:PET_BAR_UPDATE_COOLDOWN()
	local start, duration
	local name, icon, spellID
	local timer

	local currentTime	= GetTime()
	local index			= 1

	start, duration = GetSpellCooldown(1, BOOKTYPE_PET)

	while(start) do
		if (duration > durationMin and duration < durationMax)then
			_, spellID = GetSpellBookItemInfo(index, BOOKTYPE_PET)

			if (not blacklistSPELL[spellID]) then
				name , _, icon = GetSpellInfo(spellID)

				timer = activeTimers['PET' .. spellID]

				if (timer) then
					if (start ~= timer.startTime) then -- check if cooldown has been altered (also fires when mid expiration)
						timer:Update(start, duration)
					end

					timer.updated = currentTime
				else -- make timer
					CooldownTimer:New(currentTime, 'PET', spellID, name, icon, start, duration)
				end
			end
		end

		index = index + 1
		start, duration = GetSpellCooldown(index, BOOKTYPE_PET)

	end
end

function Cooldown:SPELL_UPDATE_COOLDOWN()
	local start, duration
	local name, icon, spellID
	local timer

	local currentTime	= GetTime()
	local index			= 1

	start, duration = GetSpellCooldown(1, BOOKTYPE_SPELL)

	while(start) do
		if (duration > durationMin and duration < durationMax) then
			_, spellID = GetSpellBookItemInfo(index, BOOKTYPE_SPELL)

			if (not blacklistSPELL[spellID]) then
				name , _, icon = GetSpellInfo(spellID)

				timer = activeTimers['SPELL' .. spellID]

				if (timer) then
					if (start ~= timer.startTime) then -- check if cooldown has been altered (also fires when mid expiration)
						timer:Update(start, duration)
					end

					timer.updated = currentTime
				else -- make timer
					CooldownTimer:New(currentTime, 'SPELL', spellID, name, icon, start, duration)
				end
			end
		end

		index = index + 1
		start, duration = GetSpellCooldown(index, BOOKTYPE_SPELL)

	end

	for _, timer in pairs(activeTimers) do
		if (not timer.expired and timer.group == 'SPELL' and timer.updated < currentTime) then
			timer:SetExpired()
		end
	end
end


-- ------------------------
-- COOLDOWN CONFIGURATION
-- ------------------------
function Cooldown:Configure()
	horizontal	= cooldownDB.horizontal
	length		= cooldownDB.length
	thickness	= cooldownDB.thickness

	-- base config, done regardless of whether cooldowns are enabled (fairly lightweight and sets up anchor for overlay attachment)
	self:SetHeight((horizontal and thickness or length) + 4)
	self:SetWidth((horizontal and length or thickness) + 4)
	self:SetAlpha(anchorData.alpha)
	self:SetScale(anchorData.scale)

	self:ClearAllPoints()
	self:SetPoint(anchorData.point, UIParent, anchorData.point, anchorData.x / anchorData.scale, anchorData.y / anchorData.scale)

	if (not cooldownDB.enabled) then
		self:UnregisterEvent('BAG_UPDATE_COOLDOWN')
		self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
		self:UnregisterEvent('PET_BAR_UPDATE_COOLDOWN')
		self:UnregisterEvent('SPELL_UPDATE_COOLDOWN')

		for _, timer in pairs(activeTimers) do
			timer:Release() -- clean out any active cooldown timers
		end

		Cooldown:Hide() -- hide display (and stop OnUpdate from firing)

		return -- drop out quickly
	end

	-- cooldowns enabled, setup (and first time init if needed)
	tickRate			= Ellipsis.db.profile.advanced.tickRate

	onlyWhenTracking	= cooldownDB.onlyWhenTracking
	sendAlerts			= (Ellipsis.db.profile.notify.coolPrematureAlerts or Ellipsis.db.profile.notify.coolCompleteAlerts)

	maxTime				= cooldownDB.timeDisplayMax
	endPadding			= thickness / 2
	workLength			= length - thickness

	if (not self.bar) then -- first time init
		self:SetBackdrop({
			bgFile		= 'Interface/Tooltips/UI-Tooltip-Background',
			edgeFile	= 'Interface/Tooltips/UI-Tooltip-Border',
			tile		= true,
			tileSize	= 16,
			edgeSize	= 6,
			insets		= {left = 1, right = 1, top = 1, bottom = 1}
		})

		self.bar = self:CreateTexture(nil, 'BORDER')
		self.bar:SetPoint('TOPLEFT', 2, -2)
		self.bar:SetPoint('BOTTOMRIGHT', -2, 2)

		self.tagFrame = CreateFrame('Frame', nil, self) -- all timeTags are attached to this frame to keep frame levels easier to handle
		self.tagFrame:SetFrameLevel(self.tagFrame:GetFrameLevel() + 1)
		self.tagFrame:SetAllPoints(self)

		self.tags	= {}	-- holds 'time tag' widgets

		-- setup script and event handlers
		self:SetScript('OnUpdate', OnUpdate)
		self:SetScript('OnEvent', function(self, event, ...)
			self[event](self, ...)
		end)
	end

	if (horizontal) then
		self.bar:SetTexCoord(0, 1, 0, 1)
	else
		self.bar:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
	end

	self.bar:SetTexture(LSM:Fetch('statusbar', cooldownDB.texture))
	self.bar:SetVertexColor(unpack(cooldownDB.colourBar))

	self:SetBackdropColor(unpack(cooldownDB.colourBackdrop))
	self:SetBackdropBorderColor(unpack(cooldownDB.colourBorder))

	-- more variables needed for setting up time tags
	local tagData	= cooldownDB.timeDetailed and tagDataDetail or tagDataBase
	local tags		= self.tags
	local tag, pos

	for x = 1, #tags do tags[x]:Hide() end -- hide all existing timeTags

	for i, time in ipairs(tagData) do
		if (time <= maxTime) then
			tag = tags[i]

			if (not tag) then -- new tag needed
				tag = self.tagFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
				tags[i] = tag
			end

			tag:SetFont(LSM:Fetch('font', cooldownDB.timeFont), cooldownDB.timeFontSize)
			tag:SetTextColor(unpack(cooldownDB.colourText))

			tag:ClearAllPoints()

			pos = (math_pow(time / maxTime, 0.4) * workLength)

			if (pos == workLength) then -- special case if a tag entry is buffered at the 'end' of the bar
				tag:SetPoint(horizontal and 'RIGHT' or 'TOP', self.bar, horizontal and 'RIGHT' or 'TOP', horizontal and -1 or 0, horizontal and 0 or -1)
				tag:SetFormattedText('> %d', time)
			else
				tag:SetPoint('CENTER', self.bar, horizontal and 'LEFT' or 'BOTTOM', horizontal and (pos + endPadding) or 0, horizontal and 0 or (pos + endPadding))
				tag:SetText(time)
			end

			tag:Show() -- show (or reshow) tag if set for appropriate time
		end
	end

	-- configure control
	durationMin	= cooldownDB.timeMinValue -- always a minimum time set to avoid the GCD
	durationMax = (cooldownDB.timeMaxLimit) and cooldownDB.timeMaxValue or 2764800 -- 32 days, longer cooldown than that isn't going to be an issue...

	EventRegistration('BAG_UPDATE_COOLDOWN',		cooldownDB.trackItem)
	EventRegistration('PLAYER_EQUIPMENT_CHANGED',	cooldownDB.trackItem)
	EventRegistration('PET_BAR_UPDATE_COOLDOWN',	cooldownDB.trackPet)
	EventRegistration('SPELL_UPDATE_COOLDOWN',		cooldownDB.trackSpell)

	if (onlyWhenTracking) then
		if (activeTimersCount > 0) then
			self:Show()
		else
			self:Hide()
		end
	else
		self:Show()
	end
end

function Cooldown:UpdateExistingTimers()
	for _, timer in pairs(timerPool) do
		timer:Configure()
	end

	local currentTime = GetTime()
	local pos

	for _, timer in pairs(activeTimers) do
		timer:Configure()

		if (not timer.expired) then -- don't bother with expiring timers, will be gone in <1s
			if (timer.group == 'SPELL') then
				timer.offset = (cooldownDB.offsetTags) and cooldownDB.offsetSpell or 0
				timer.offsetTag:SetColorTexture(unpack(cooldownDB.colourSpell))
				timer.border:SetVertexColor(unpack(cooldownDB.colourSpell))
			elseif(timer.group == 'ITEM') then
				timer.offset = (cooldownDB.offsetTags) and cooldownDB.offsetItem or 0
				timer.offsetTag:SetColorTexture(unpack(cooldownDB.colourItem))
				timer.border:SetVertexColor(unpack(cooldownDB.colourItem))
			else -- group == 'PET'
				timer.offset = (cooldownDB.offsetTags) and cooldownDB.offsetPet or 0
				timer.offsetTag:SetColorTexture(unpack(cooldownDB.colourPet))
				timer.border:SetVertexColor(unpack(cooldownDB.colourPet))
			end

			timer:SetWidth(thickness)
			timer:SetHeight(thickness)

			if (timer.offset ~= 0) then -- offset is enabled for this cooldown group
				timer.offsetTag:ClearAllPoints()

				if (horizontal) then
					timer.offsetTag:SetPoint('TOP', timer, 'CENTER', 0, (timer.offset < 0) and (timer.offset * -1) or 0)
					timer.offsetTag:SetPoint('BOTTOM', timer, 'CENTER', 0, (timer.offset > 0) and -(timer.offset) or 0)
				else
					timer.offsetTag:SetPoint('LEFT', timer, 'CENTER', (timer.offset > 0) and (timer.offset * -1) or 0, 0)
					timer.offsetTag:SetPoint('RIGHT', timer, 'CENTER', (timer.offset < 0) and (timer.offset * -1) or 0, 0)
				end

				timer.offsetTag:Show()
			else
				timer.offsetTag:Hide()
			end

			pos = math_pow((timer.expireTime - currentTime) / maxTime, 0.4) * workLength

			timer:ClearAllPoints() -- just to make sure our attachment point is clear before OnUpdate moves us

			if (horizontal) then
				timer:SetPoint('CENTER', Cooldown.bar, 'LEFT', endPadding + math_min(pos, workLength), timer.offset)
			else
				timer:SetPoint('CENTER', Cooldown.bar, 'BOTTOM', timer.offset, endPadding + math_min(pos, workLength))
			end
		end
	end
end

function Cooldown:ApplyOptionsTimerRestrictions()
	for _, timer in pairs(activeTimers) do
		if (timer.duration <= durationMin or timer.duration >= durationMax) then
			timer:Release()
		else
			if (timer.group == 'ITEM' and not cooldownDB.trackItem) then
				timer:Release()
			elseif (timer.group == 'PET' and not cooldownDB.trackPet) then
				timer:Release()
			elseif (timer.group == 'SPELL' and not cooldownDB.trackSpell) then
				timer:Release()
			end
		end
	end
end


-- ------------------------
-- COOLDOWN TIMER SCRIPT HANDLERS
-- ------------------------
local function OnClick(self, button)
	if (button == 'LeftButton') then
		Ellipsis:Announce(self)
	elseif (button == 'RightButton') then
		if (IsShiftKeyDown()) then
			Ellipsis:BlacklistCooldownAdd((self.group == 'ITEM') and 'ITEM' or 'SPELL', self.timerID)
		else
			self:Release()
		end
	end
end

local function OnEnter(self)
	if (not self.isMouseOver) then
		self.isMouseOver = true

		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')

		if (cooldownDB.tooltips == 'FULL' and self.timerID > 0) then
			if (self.group == 'ITEM') then
				GameTooltip:SetItemByID(self.timerID)
			else
				GameTooltip:SetSpellByID(self.timerID)
			end
		else
			GameTooltip:SetText(self.timerName, 1, 1, 1)
		end

		GameTooltip:AddLine(self.timerID > 0 and L.CooldownTimerTooltip or L.CooldownTimerTooltipNoBlock)
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
-- COOLDOWN TIMER CREATION
-- ------------------------
local function CreateTimer()
	local new = CreateFrame('Button', nil, Cooldown)
	local widget

	-- main gui widgets
	widget = new:CreateTexture(nil, 'BORDER')
	widget:SetAllPoints(new)
	widget:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	new.icon = widget

	widget = new:CreateTexture(nil, 'ARTWORK')
	widget:SetAllPoints(new.icon)
	widget:SetTexCoord(0.03125, 0.96875, 0.03125, 0.96875)
	widget:SetTexture('Interface\\AddOns\\Ellipsis\\IconBorder')
	new.border = widget

	widget = new:CreateTexture(nil, 'BACKGROUND')
	widget:SetWidth(1)
	widget:SetHeight(1)
	new.offsetTag = widget

	new['Release']		= CooldownTimer.Release
	new['Configure']	= CooldownTimer.Configure
	new['SetExpired']	= CooldownTimer.SetExpired
	new['Update']		= CooldownTimer.Update

	return new
end

function CooldownTimer:New(currentTime, group, timerID, timerName, timerIcon, startTime, duration)
	if (not timerName) then return end -- catch to abort if creating an invalid timer

	local new = tremove(timerPool, 1) -- grab an timer from the inactive pool (if any)

	if (not new) then -- no inactive timers, create new
		new = CreateTimer()
		new:Configure()
	end

	new.updated		= currentTime
	new.expired		= false			-- new timer, cannot be expired

	new.startTime	= startTime
	new.duration	= duration
	new.expireTime	= startTime + duration

	new.group		= group
	new.timerID		= timerID
	new.timerName	= timerName

	if (group == 'SPELL') then
		new.offset = (cooldownDB.offsetTags) and cooldownDB.offsetSpell or 0
		new.offsetTag:SetColorTexture(unpack(cooldownDB.colourSpell))
		new.border:SetVertexColor(unpack(cooldownDB.colourSpell))
	elseif(group == 'ITEM') then
		new.offset = (cooldownDB.offsetTags) and cooldownDB.offsetItem or 0
		new.offsetTag:SetColorTexture(unpack(cooldownDB.colourItem))
		new.border:SetVertexColor(unpack(cooldownDB.colourItem))
	else -- group == 'PET'
		new.offset = (cooldownDB.offsetTags) and cooldownDB.offsetPet or 0
		new.offsetTag:SetColorTexture(unpack(cooldownDB.colourPet))
		new.border:SetVertexColor(unpack(cooldownDB.colourPet))
	end

	new:SetWidth(thickness)
	new:SetHeight(thickness)
	new:SetAlpha(1)

	new.icon:SetTexture(timerIcon)

	if (new.offset ~= 0) then -- offset is enabled for this cooldown group
		new.offsetTag:ClearAllPoints()

		if (horizontal) then
			new.offsetTag:SetPoint('TOP', new, 'CENTER', 0, (new.offset < 0) and (new.offset * -1) or 0)
			new.offsetTag:SetPoint('BOTTOM', new, 'CENTER', 0, (new.offset > 0) and -(new.offset) or 0)
		else
			new.offsetTag:SetPoint('LEFT', new, 'CENTER', (new.offset > 0) and (new.offset * -1) or 0, 0)
			new.offsetTag:SetPoint('RIGHT', new, 'CENTER', (new.offset < 0) and (new.offset * -1) or 0, 0)
		end

		new.offsetTag:Show()
	else
		new.offsetTag:Hide()
	end

	local pos = math.pow((new.expireTime - currentTime) / maxTime, 0.4) * workLength

	new:ClearAllPoints() -- just to make sure our attachment point is clear before OnUpdate moves us

	if (horizontal) then
		new:SetPoint('CENTER', Cooldown.bar, 'LEFT', endPadding + math_min(pos, workLength), new.offset)
	else
		new:SetPoint('CENTER', Cooldown.bar, 'BOTTOM', new.offset, endPadding + math_min(pos, workLength))
	end

	new:Show()

	activeTimers[group .. timerID] = new		-- add new timer to timer lookup
	activeTimersCount = activeTimersCount + 1

	if (onlyWhenTracking and activeTimersCount == 1) then -- first cooldown in a while, show bar
		Cooldown:Show()
	end
end


-- ------------------------
-- COOLDOWN TIMER FUNCTIONS
-- ------------------------
function CooldownTimer:Release()
	self:Hide()

	activeTimers[self.group .. self.timerID] = nil	-- remove self from timer lookup

	activeTimersCount = activeTimersCount - 1		-- decrement timer count

	if (onlyWhenTracking and activeTimersCount == 0) then
		Cooldown:Hide()
	end

	tinsert(timerPool, self) -- add self back into the timerPool (do last so we can't be used again before we're fully Released)
end

function CooldownTimer:Configure()
	if (cooldownDB.interactive) then
		self:EnableMouse(true)
		self:SetScript('OnClick', OnClick)
		self:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

		if (cooldownDB.tooltips ~= 'OFF') then
			self:SetScript('OnEnter', OnEnter)
			self:SetScript('OnLeave', OnLeave)
		else
			self:SetScript('OnEnter', nil)
			self:SetScript('OnLeave', nil)
		end
	else
		self:EnableMouse(false) -- non-interactive, disable all mouse capture
	end
end

function CooldownTimer:SetExpired(currentTime)
	if (self.expired) then return end -- already set as expired

	currentTime = currentTime or GetTime() -- we need a time value, make sure we have one

	if (sendAlerts) then
		local premature = (currentTime + 0.5) < self.expireTime -- check to see if cooldown completed early (with a bit of slush time)

		Ellipsis:AlertCooldown(premature, self) -- send alert if watching for alerts
	end

	self.expired	= true
	self.expireTime	= currentTime -- make sure to update expiration for proper pulse duration
end

function CooldownTimer:Update(startTime, duration)
	if (self.expired) then	-- still playing the expiration pulse, back on cooldown, reset to active status
		self:SetWidth(thickness)
		self:SetHeight(thickness)
		self:SetAlpha(1)

		self.expired = false
	end

	self.startTime	= startTime
	self.duration	= duration
	self.expireTime	= startTime + duration
end
