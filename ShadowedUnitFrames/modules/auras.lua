local Auras = {}
local playerUnits = {player = true, vehicle = true, pet = true}
local mainHand, offHand, tempEnchantScan = {time = 0}, {time = 0}
local canCure = ShadowUF.Units.canCure
ShadowUF:RegisterModule(Auras, "auras", ShadowUF.L["Auras"])

function Auras:OnEnable(frame)
	frame.auras = frame.auras or {}

	frame:RegisterNormalEvent("PLAYER_ENTERING_WORLD", self, "Update")
	frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
	frame:RegisterUpdateFunc(self, "Update")

	self:UpdateFilter(frame)
end

function Auras:OnDisable(frame)
	frame:UnregisterAll(self)
end

-- Aura positioning code
-- Definitely some of the more unusual code I've done, not sure I really like this method
-- but it does allow more flexibility with how things are anchored without me having to hardcode the 10 different growth methods
local function load(text)
	local result, err = loadstring(text)
	if( err ) then
		error(err, 3)
		return nil
	end

	return result()
end

local positionData = setmetatable({}, {
	__index = function(tbl, index)
		local data = {}
		local columnGrowth = ShadowUF.Layout:GetColumnGrowth(index)
		local auraGrowth = ShadowUF.Layout:GetAuraGrowth(index)
		data.xMod = (columnGrowth == "RIGHT" or auraGrowth == "RIGHT") and 1 or -1
		data.yMod = (columnGrowth ~= "TOP" and auraGrowth ~= "TOP") and -1 or 1

		local auraX, colX, auraY, colY, xOffset, yOffset, initialXOffset, initialYOffset = 0, 0, 0, 0, "", "", "", ""
		if( columnGrowth == "LEFT" or columnGrowth == "RIGHT" ) then
			colX = 1
			xOffset = " + offset"
			initialXOffset = string.format(" + (%d * offset)", data.xMod)
			auraY = 3
			data.isSideGrowth = true
		elseif( columnGrowth == "TOP" or columnGrowth == "BOTTOM" ) then
			colY = 2
			yOffset = " + offset"
			initialYOffset = string.format(" + (%d * offset)", data.yMod)
			auraX = 2
		end

		data.initialAnchor = load(string.format([[return function(button, offset)
			button:ClearAllPoints()
			button:SetPoint(button.point, button.anchorTo, button.relativePoint, button.xOffset%s, button.yOffset%s)
			button.anchorOffset = offset
		end]], initialXOffset, initialYOffset))
		data.column = load(string.format([[return function(button, positionTo, offset)
			button:ClearAllPoints()
			button:SetPoint("%s", positionTo, "%s", %d * (%d%s), %d * (%d%s)) end
		]], ShadowUF.Layout:ReverseDirection(columnGrowth), columnGrowth, data.xMod, colX, xOffset, data.yMod, colY, yOffset))
		data.aura = load(string.format([[return function(button, positionTo)
			button:ClearAllPoints()
			button:SetPoint("%s", positionTo, "%s", %d, %d) end
		]], ShadowUF.Layout:ReverseDirection(auraGrowth), auraGrowth, data.xMod * auraX, data.yMod * auraY))

		tbl[index] = data
		return tbl[index]
	end,
})

local function positionButton(id,  group, config)
	local position = positionData[group.forcedAnchorPoint or config.anchorPoint]
	local button = group.buttons[id]
	button.isAuraAnchor = nil

	-- Alright, in order to find out where an aura group is going to be anchored to certain buttons need
	-- to be flagged as suitable anchors visually, this speeds it up because this data is cached and doesn't
	-- have to be recalculated unless auras are specifically changed
	if( id > 1 ) then
		if( position.isSideGrowth and id <= config.perRow ) then
			button.isAuraAnchor = true
		end

		if( id % config.perRow == 1 or config.perRow == 1 ) then
			position.column(button, group.buttons[id - config.perRow], 0)

			if( not position.isSideGrowth ) then
				button.isAuraAnchor = true
			end
		else
			position.aura(button, group.buttons[id - 1])
		end
	else
		button.isAuraAnchor = true
		button.point = ShadowUF.Layout:GetPoint(config.anchorPoint)
		button.relativePoint = ShadowUF.Layout:GetRelative(config.anchorPoint)
		button.xOffset = config.x + (position.xMod * ShadowUF.db.profile.backdrop.inset)
		button.yOffset = config.y + (position.yMod * ShadowUF.db.profile.backdrop.inset)
		button.anchorTo = group.anchorTo

		position.initialAnchor(button, 0)
	end
end


local columnsHaveScale = {}
local function positionAllButtons(group, config)
	local position = positionData[group.forcedAnchorPoint or config.anchorPoint]

	-- Figure out which columns have scaling so we can work out positioning
	local columnID = 0
	for id, button in pairs(group.buttons) do
		if( id % config.perRow == 1 or config.perRow == 1 ) then
			columnID = columnID + 1
			columnsHaveScale[columnID] = nil
		end

		if( not columnsHaveScale[columnID] and button.isSelfScaled ) then
			local size = math.ceil(button:GetSize() * button:GetScale())
			columnsHaveScale[columnID] = columnsHaveScale[columnID] and math.max(size, columnsHaveScale[columnID]) or size
		end
	end

	columnID = 1
	for id, button in pairs(group.buttons) do
		if( id > 1 ) then
			if( id % config.perRow == 1 or config.perRow == 1 ) then
				columnID = columnID + 1

				local anchorButton = group.buttons[id - config.perRow]
				local previousScale, currentScale = columnsHaveScale[columnID - 1], columnsHaveScale[columnID]
				local offset = 0
				-- Previous column has a scaled aura, and the button we are anchoring to is not scaled
				if( previousScale and not anchorButton.isSelfScaled ) then
					offset = (previousScale / 4)
				end

				-- Current column has a scaled aura, and the button isn't scaled
				if( currentScale and not button.isSelfScaled ) then
					offset = offset + (currentScale / 4)
				end

				-- Current anchor is scaled, previous is not
				if( button.isSelfScaled and not anchorButton.isSelfScaled ) then
					offset = offset - (currentScale / 6)
				end

				-- At least one of them is scaled
				if( ( not button.isSelfScaled or not anchorButton.isSelfScaled ) and offset > 0 ) then
					offset = offset + 1
				end

				position.column(button, anchorButton, math.ceil(offset))
			else
				position.aura(button, group.buttons[id - 1])
			end
		else
			-- If the initial column is self scaled, but the initial anchor isn't, will have to reposition it
			local offset = 0
			if( columnsHaveScale[columnID] ) then
				offset = math.ceil(columnsHaveScale[columnID] / 8)
				if( button.isSelfScaled ) then
					offset = -(offset / 2)
				else
					offset = offset + 2
				end

				offset = offset
			end

			if( offset ~= button.anchorOffset ) then
				position.initialAnchor(button, offset)
			end
		end
	end
end

-- Aura button functions
-- Updates the X seconds left on aura tooltip while it's shown
local function updateTooltip(self)
	if( not GameTooltip:IsForbidden() and GameTooltip:IsOwned(self) ) then
		GameTooltip:SetUnitAura(self.unit, self.auraID, self.filter)
	end
end

local function showTooltip(self)
	if( not ShadowUF.db.profile.locked ) then return end
	if( GameTooltip:IsForbidden() ) then return end

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	if( self.filter == "TEMP" ) then
		GameTooltip:SetInventoryItem("player", self.auraID)
		self:SetScript("OnUpdate", nil)
	else
		GameTooltip:SetUnitAura(self.unit, self.auraID, self.filter)
		self:SetScript("OnUpdate", updateTooltip)
	end
end

local function hideTooltip(self)
	self:SetScript("OnUpdate", nil)
	if not GameTooltip:IsForbidden() then
		GameTooltip:Hide()
	end
end

local function cancelAura(self, mouse)
	if( mouse ~= "RightButton" or ( not UnitIsUnit(self.parent.unit, "player") and not UnitIsUnit(self.parent.unit, "vehicle") ) or InCombatLockdown() or self.filter == "TEMP" ) then
		return
	end

	CancelUnitBuff(self.parent.unit, self.auraID, self.filter)
end

local function updateButton(id, group, config)
	local button = group.buttons[id]
	if( not button ) then
		group.buttons[id] = CreateFrame("Button", nil, group)

		button = group.buttons[id]
		button:SetScript("OnEnter", showTooltip)
		button:SetScript("OnLeave", hideTooltip)
		button:RegisterForClicks("RightButtonUp")

		button.cooldown = CreateFrame("Cooldown", group.parent:GetName() .. "Aura" .. group.type .. id .. "Cooldown", button, "CooldownFrameTemplate")
		button.cooldown:SetAllPoints(button)
		button.cooldown:SetReverse(true)
		button.cooldown:SetDrawEdge(false)
		button.cooldown:SetDrawSwipe(true)
		button.cooldown:SetSwipeColor(0, 0, 0, 0.8)
		button.cooldown:Hide()

		button.stack = button:CreateFontString(nil, "OVERLAY")
		button.stack:SetFont("Interface\\AddOns\\ShadowedUnitFrames\\media\\fonts\\Myriad Condensed Web.ttf", 10, "OUTLINE")
		button.stack:SetShadowColor(0, 0, 0, 1.0)
		button.stack:SetShadowOffset(0.50, -0.50)
		button.stack:SetHeight(1)
		button.stack:SetWidth(1)
		button.stack:SetAllPoints(button)
		button.stack:SetJustifyV("BOTTOM")
		button.stack:SetJustifyH("RIGHT")

		button.border = button:CreateTexture(nil, "OVERLAY")
		button.border:SetPoint("CENTER", button)

		button.icon = button:CreateTexture(nil, "BACKGROUND")
		button.icon:SetAllPoints(button)
		button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end

	if( ShadowUF.db.profile.auras.borderType == "" ) then
		button.border:Hide()
	elseif( ShadowUF.db.profile.auras.borderType == "blizzard" ) then
		button.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		button.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
		button.border:Show()
	else
		button.border:SetTexture("Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\border-" .. ShadowUF.db.profile.auras.borderType)
		button.border:SetTexCoord(0, 1, 0, 1)
		button.border:Show()
	end

	-- Set the button sizing
	button.cooldown.noCooldownCount = ShadowUF.db.profile.omnicc
	button.cooldown:SetHideCountdownNumbers(ShadowUF.db.profile.blizzardcc)
	button:SetHeight(config.size)
	button:SetWidth(config.size)
	button.border:SetHeight(config.size + 1)
	button.border:SetWidth(config.size + 1)
	button.stack:SetFont("Interface\\AddOns\\ShadowedUnitFrames\\media\\fonts\\Myriad Condensed Web.ttf", math.floor((config.size * 0.60) + 0.5), "OUTLINE")

	button:SetScript("OnClick", cancelAura)
	button.parent = group.parent
	button:ClearAllPoints()
	button:Hide()

	-- Position the button quickly
	positionButton(id, group, config)
end

-- Let the mover access this for creating aura things
Auras.updateButton = updateButton

-- Create an aura anchor as well as the buttons to contain it
local function updateGroup(self, type, config, reverseConfig)
	self.auras[type] = self.auras[type] or CreateFrame("Frame", nil, self.highFrame)

	local group = self.auras[type]
	group.buttons = group.buttons or {}

	group.maxAuras = config.perRow * config.maxRows
	group.totalAuras = 0
	group.temporaryEnchants = 0
	group.type = type
	group.parent = self
	group.anchorTo = self
	group:SetFrameLevel(self.highFrame:GetFrameLevel() + 1)
	group:Show()

	-- If debuffs are anchored to buffs, debuffs need to grow however buffs do
	if( config.anchorOn and reverseConfig.enabled ) then
		group.forcedAnchorPoint = reverseConfig.anchorPoint
	end

	if( self.unit == "player" ) then
		mainHand.time = 0
		offHand.time = 0

		group:SetScript("OnUpdate", config.temporary and tempEnchantScan or nil)
	else
		group:SetScript("OnUpdate", nil)
	end

	-- Update filters used for the anchor
	group.filter = group.type == "buffs" and "HELPFUL" or group.type == "debuffs" and "HARMFUL" or ""

	for id, button in pairs(group.buttons) do
		updateButton(id, group, config)
	end
end

-- Update aura positions based off of configuration
function Auras:OnLayoutApplied(frame, config)
	if( frame.auras ) then
		if( frame.auras.buffs ) then
			for _, button in pairs(frame.auras.buffs.buttons) do
				button:Hide()
			end
		end
		if( frame.auras.debuffs ) then
			for _, button in pairs(frame.auras.debuffs.buttons) do
				button:Hide()
			end
		end
	end

	if( not frame.visibility.auras ) then return end

	if( config.auras.buffs.enabled ) then
		updateGroup(frame, "buffs", config.auras.buffs, config.auras.debuffs)
	end

	if( config.auras.debuffs.enabled ) then
		updateGroup(frame, "debuffs", config.auras.debuffs, config.auras.buffs)
	end

	-- Anchor an aura group to another aura group
	frame.auras.anchorAurasOn = nil
	if( config.auras.buffs.enabled and config.auras.debuffs.enabled ) then
		if( config.auras.buffs.anchorOn ) then
			frame.auras.anchorAurasOn = frame.auras.debuffs
			frame.auras.anchorAurasChild = frame.auras.buffs
		elseif( config.auras.debuffs.anchorOn ) then
			frame.auras.anchorAurasOn = frame.auras.buffs
			frame.auras.anchorAurasChild = frame.auras.debuffs
		end
	end

	-- Check if either auras are anchored to each other
	if( config.auras.buffs.anchorPoint == config.auras.debuffs.anchorPoint and config.auras.buffs.enabled and config.auras.debuffs.enabled and not config.auras.buffs.anchorOn and not config.auras.debuffs.anchorOn ) then
		frame.auras.anchor = frame.auras[config.auras.buffs.prioritize and "buffs" or "debuffs"]
		frame.auras.primary = config.auras.buffs.prioritize and "buffs" or "debuffs"
		frame.auras.secondary = frame.auras.primary == "buffs" and "debuffs" or "buffs"
	else
		frame.auras.anchor = nil
	end

	self:UpdateFilter(frame)
end

-- Temporary enchant support
local timeElapsed = 0
local function updateTemporaryEnchant(frame, slot, tempData, hasEnchant, enchantId, timeLeft, charges)
	-- If there's less than a 750 millisecond differences in the times, we don't need to bother updating.
	-- Any sort of enchant takes more than 0.750 seconds to cast so it's impossible for the user to have two
	-- temporary enchants with that little difference, as totems don't really give pulsing auras anymore.
	charges = charges or 0
	if( tempData.has and tempData.enchantId == enchantId and ( timeLeft < tempData.time and ( tempData.time - timeLeft ) < 750 ) ) then return false end

	-- Some trickys magic, we can't get the start time of temporary enchants easily.
	-- So will save the first time we find when a new enchant is added
	if( timeLeft > tempData.time or not tempData.has ) then
		tempData.startTime = GetTime()
	end

	tempData.has = hasEnchant
	tempData.time = timeLeft
	tempData.charges = charges
	tempData.enchantId = enchantId

	local config = ShadowUF.db.profile.units[frame.parent.unitType].auras[frame.type]

	-- Create any buttons we need
	if( #(frame.buttons) < frame.temporaryEnchants ) then
		updateButton(frame.temporaryEnchants, frame, config)
	end

	local button = frame.buttons[frame.temporaryEnchants]

	-- Purple border
	button.border:SetVertexColor(0.50, 0, 0.50)

	-- Show the cooldown ring
	if( not ShadowUF.db.profile.auras.disableCooldown ) then
		button.cooldown:SetCooldown(tempData.startTime, timeLeft / 1000)
		button.cooldown:Show()
	end

	-- Enlarge our own auras
	if( config.enlarge.SELF ) then
		button.isSelfScaled = true
		button:SetScale(config.selfScale)
	else
		button.isSelfScaled = nil
		button:SetScale(1)
	end

	-- Size it
	button:SetHeight(config.size)
	button:SetWidth(config.size)
	button.border:SetHeight(config.size + 1)
	button.border:SetWidth(config.size + 1)

	-- Stack + icon + show! Never understood why, auras sometimes return 1 for stack even if they don't stack
	button.auraID = slot
	button.filter = "TEMP"
	button.unit = nil
	button.columnHasScaled = nil
	button.previousHasScale = nil
	button.icon:SetTexture(GetInventoryItemTexture("player", slot))
	button.stack:SetText(charges > 1 and charges or "")
	button:Show()
end

-- Unfortunately, temporary enchants have basically no support beyond hacks. So we will hack!
tempEnchantScan = function(self, elapsed)
	if( self.parent.unit == self.parent.vehicleUnit and self.lastTemporary > 0 ) then
		mainHand.has = false
		offHand.has = false

		self.temporaryEnchants = 0
		self.lastTemporary = 0

		Auras:Update(self.parent)
		return
	end

	timeElapsed = timeElapsed + elapsed
	if( timeElapsed < 0.50 ) then return end
	timeElapsed = timeElapsed - 0.50


	local hasMain, mainTimeLeft, mainCharges, mainEnchantId, hasOff, offTimeLeft, offCharges, offEnchantId = GetWeaponEnchantInfo()
	self.temporaryEnchants = 0

	if( hasMain ) then
		self.temporaryEnchants = self.temporaryEnchants + 1
		updateTemporaryEnchant(self, 16, mainHand, hasMain, mainEnchantId, mainTimeLeft or 0, mainCharges)
		mainHand.time = mainTimeLeft or 0
	end

	mainHand.has = hasMain

	if( hasOff and self.temporaryEnchants < self.maxAuras ) then
		self.temporaryEnchants = self.temporaryEnchants + 1
		updateTemporaryEnchant(self, 17, offHand, hasOff, offEnchantId, offTimeLeft or 0, offCharges)
		offHand.time = offTimeLeft or 0
	end

	offHand.has = hasOff

	-- Update if totals changed
	if( self.lastTemporary ~= self.temporaryEnchants ) then
		self.lastTemporary = self.temporaryEnchants
		Auras:Update(self.parent)
	end
end

-- Nice and simple, don't need to do a full update because either this is called in an OnEnable or
-- the zone monitor will handle it all cleanly. The fun part of this code is aura filtering itself takes 10 seconds
-- but making the configuration clean takes two weeks and another 2-3 days of implementing
-- This isn't actually filled with data, it's just to stop any errors from triggering if no filter is added
local filterDefault = {}
function Auras:UpdateFilter(frame)
	local zone = select(2, IsInInstance()) or "none"
	if( zone == "scenario" ) then zone = "party" end

	local id = zone .. frame.unitType

	local white = ShadowUF.db.profile.filters.zonewhite[zone .. frame.unitType]
	local black = ShadowUF.db.profile.filters.zoneblack[zone .. frame.unitType]
	local override = ShadowUF.db.profile.filters.zoneoverride[zone .. frame.unitType]
	frame.auras.whitelist = white and ShadowUF.db.profile.filters.whitelists[white] or filterDefault
	frame.auras.blacklist = black and ShadowUF.db.profile.filters.blacklists[black] or filterDefault
	frame.auras.overridelist = override and ShadowUF.db.profile.filters.overridelists[override] or filterDefault
end

local function categorizeAura(type, curable, auraType, caster, isRemovable, canApplyAura, isBossDebuff)
	-- Player casted it
	if( playerUnits[caster] ) then
		return "player"
	-- Boss aura
	elseif( isBossDebuff ) then
		return "boss"
	-- Can dispell, curable checks type already
	elseif( curable and canCure[auraType] ) then
		return "raid"
	-- Can apply it ourselves
	elseif( type == "buffs" and canApplyAura ) then
		return "raid"
	-- Can be stolen/purged (dispellable)
	elseif( type == "debuffs" and isRemovable ) then
		return "raid"
	else
		return "misc"
	end
end

local function renderAura(parent, frame, type, config, displayConfig, index, filter, isFriendly, curable, name, texture, count, auraType, duration, endTime, caster, isRemovable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff)
	-- aura filters are all saved as strings, so need to override here
	spellID = tostring(spellID)
	-- Do our initial list check to see if we can quick filter it out
	if( parent.whitelist[type] and not parent.whitelist[name] and not parent.whitelist[spellID] ) then return end
	if( parent.blacklist[type] and ( parent.blacklist[name] or parent.blacklist[spellID] ) ) then return end

	-- Now do our type filter
	local category = categorizeAura(type, curable, auraType, caster, isRemovable, canApplyAura, isBossDebuff)
	-- check override and type filters
	if( not ( parent.overridelist[type] and ( parent.overridelist[name] or parent.overridelist[spellID] ) ) and not config.show[category] and (not config.show.relevant or (type == "debuffs") ~= isFriendly) ) then return end

	-- Create any buttons we need
	frame.totalAuras = frame.totalAuras + 1
	if( #(frame.buttons) < frame.totalAuras ) then
		updateButton(frame.totalAuras, frame, ShadowUF.db.profile.units[frame.parent.unitType].auras[frame.type])
	end

	-- Show debuff border, or a special colored border if it's stealable
	local button = frame.buttons[frame.totalAuras]
	if( isRemovable and not isFriendly and not ShadowUF.db.profile.auras.disableColor ) then
		button.border:SetVertexColor(ShadowUF.db.profile.auraColors.removable.r, ShadowUF.db.profile.auraColors.removable.g, ShadowUF.db.profile.auraColors.removable.b)
	elseif( ( not isFriendly or type == "debuffs" ) and not ShadowUF.db.profile.auras.disableColor ) then
		local color = auraType and DebuffTypeColor[auraType] or DebuffTypeColor.none
		button.border:SetVertexColor(color.r, color.g, color.b)
	else
		button.border:SetVertexColor(0.60, 0.60, 0.60)
	end

	-- Show the cooldown ring
	if( not ShadowUF.db.profile.auras.disableCooldown and duration > 0 and endTime > 0 and ( config.timers.ALL or ( category == "player" and config.timers.SELF ) or ( category == "boss" and config.timers.BOSS ) ) ) then
		button.cooldown:SetCooldown(endTime - duration, duration)
		button.cooldown:Show()
	else
		button.cooldown:Hide()
	end

	-- Enlarge auras
	if( ( category == "player" and config.enlarge.SELF ) or ( category == "boss" and config.enlarge.BOSS ) or ( config.enlarge.REMOVABLE and ( ( isRemovable and not isFriendly ) or ( curable and canCure[auraType]) ) ) ) then
		button.isSelfScaled = true
		button:SetScale(config.selfScale)
	else
		button.isSelfScaled = nil
		button:SetScale(1)
	end

	-- Size it
	button:SetHeight(config.size)
	button:SetWidth(config.size)
	button.border:SetHeight(config.size + 1)
	button.border:SetWidth(config.size + 1)

	-- Stack + icon + show! Never understood why, auras sometimes return 1 for stack even if they don't stack
	button.auraID = index
	button.filter = filter
	button.unit = frame.parent.unit
	button.columnHasScaled = nil
	button.previousHasScale = nil
	button.icon:SetTexture(texture)
	button.stack:SetText(count > 1 and count or "")
	button:Show()
end


-- Scan for auras
local function scan(parent, frame, type, config, displayConfig, filter)
	if( frame.totalAuras >= frame.maxAuras or not config.enabled ) then return end

	-- UnitIsFriend returns true during a duel, which breaks stealable/curable detection
	local isFriendly = not UnitIsEnemy(frame.parent.unit, "player")
	local curable = (isFriendly and type == "debuffs")
	local index = 0
	while( true ) do
		index = index + 1
		local name, texture, count, auraType, duration, endTime, caster, isRemovable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff = UnitAura(frame.parent.unit, index, filter)
		if( not name ) then break end

		renderAura(parent, frame, type, config, displayConfig, index, filter, isFriendly, curable, name, texture, count, auraType, duration, endTime, caster, isRemovable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff)

		-- Too many auras shown, break out
		-- Get down
		if( frame.totalAuras >= frame.maxAuras ) then break end
	end

	for i=frame.totalAuras + 1, #(frame.buttons) do frame.buttons[i]:Hide() end

	-- The default 1.30 scale doesn't need special handling, after that it does
	if( config.selfScale > 1.30 ) then
		positionAllButtons(frame, displayConfig)
	end
end

Auras.scan = scan

local function anchorGroupToGroup(frame, config, group, childConfig, childGroup)
	-- Child group has nothing in it yet, so don't care
	if( not childGroup.buttons[1] ) then return end

	-- Group we want to anchor to has nothing in it, takeover the postion
	if( group.totalAuras == 0 ) then
		local position = positionData[config.anchorPoint]
		childGroup.buttons[1]:ClearAllPoints()
		childGroup.buttons[1]:SetPoint(ShadowUF.Layout:GetPoint(config.anchorPoint), group.anchorTo, ShadowUF.Layout:GetRelative(config.anchorPoint), config.x + (position.xMod * ShadowUF.db.profile.backdrop.inset), config.y + (position.yMod * ShadowUF.db.profile.backdrop.inset))
		return
	end

	local anchorTo
	for i=#(group.buttons), 1, -1 do
		local button = group.buttons[i]
		if( button.isAuraAnchor and button:IsVisible() ) then
			anchorTo = button
			break
		end
	end

	local position = positionData[childGroup.forcedAnchorPoint or childConfig.anchorPoint]
	if( position.isSideGrowth ) then
		position.aura(childGroup.buttons[1], anchorTo)
	else
		position.column(childGroup.buttons[1], anchorTo, 2)
	end
end

Auras.anchorGroupToGroup = anchorGroupToGroup

-- Do an update and figure out what we need to scan
function Auras:Update(frame)
	local config = ShadowUF.db.profile.units[frame.unitType].auras
	if( frame.auras.anchor ) then
		frame.auras.anchor.totalAuras = frame.auras.anchor.temporaryEnchants

		scan(frame.auras, frame.auras.anchor, frame.auras.primary, config[frame.auras.primary], config[frame.auras.primary], frame.auras[frame.auras.primary].filter)
		scan(frame.auras, frame.auras.anchor, frame.auras.secondary, config[frame.auras.secondary], config[frame.auras.primary], frame.auras[frame.auras.secondary].filter)
	else
		if( config.buffs.enabled ) then
			frame.auras.buffs.totalAuras = frame.auras.buffs.temporaryEnchants
			scan(frame.auras, frame.auras.buffs, "buffs", config.buffs, config.buffs, frame.auras.buffs.filter)
		end

		if( config.debuffs.enabled ) then
			frame.auras.debuffs.totalAuras = 0
			scan(frame.auras, frame.auras.debuffs, "debuffs", config.debuffs, config.debuffs, frame.auras.debuffs.filter)
		end

		if( frame.auras.anchorAurasOn ) then
			anchorGroupToGroup(frame, config[frame.auras.anchorAurasOn.type], frame.auras.anchorAurasOn, config[frame.auras.anchorAurasChild.type], frame.auras.anchorAurasChild)
		end
	end
end
