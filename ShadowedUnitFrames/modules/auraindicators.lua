local Indicators = {}
ShadowUF:RegisterModule(Indicators, "auraIndicators", ShadowUF.L["Aura indicators"])

Indicators.auraFilters = {"boss", "curable"}

Indicators.auraConfig = setmetatable({}, {
	__index = function(tbl, index)
		local aura = ShadowUF.db.profile.auraIndicators.auras[tostring(index)]
		if( not aura ) then
			tbl[index] = false
		else
			local func, msg = loadstring("return " .. aura)
			if( func ) then
				func = func()
			elseif( msg ) then
				error(msg, 3)
			end

			tbl[index] = func
			if( not tbl[index].group ) then tbl[index].group = "Miscellaneous" end
		end

		return tbl[index]
end})

local playerUnits = {player = true, vehicle = true, pet = true}
local backdropTbl = {bgFile = "Interface\\Addons\\ShadowedUnitFrames\\mediabackdrop", edgeFile = "Interface\\Addons\\ShadowedUnitFrames\\media\\backdrop", tile = true, tileSize = 1, edgeSize = 1}

function Indicators:OnEnable(frame)
	-- Not going to create the indicators we want here, will do that when we do the layout stuff
	frame.auraIndicators = frame.auraIndicators or CreateFrame("Frame", nil, frame)
	frame.auraIndicators:SetFrameLevel(4)
	frame.auraIndicators:Show()

	-- Of course, watch for auras
	frame:RegisterUnitEvent("UNIT_AURA", self, "UpdateAuras")
	frame:RegisterUpdateFunc(self, "UpdateAuras")
end

function Indicators:OnDisable(frame)
	frame:UnregisterAll(self)
	frame.auraIndicators:Hide()
end

function Indicators:OnLayoutApplied(frame)
	if( not frame.auraIndicators ) then return end

	-- Create indicators
	local id = 1
	for key, indicatorConfig in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		-- Create indicator as needed
		local indicator = frame.auraIndicators["indicator-" .. id]
		if( not indicator ) then
			indicator = CreateFrame("Frame", nil, frame.auraIndicators, BackdropTemplateMixin and "BackdropTemplate" or nil)
			indicator:SetFrameLevel(frame.topFrameLevel + 2)
			indicator.texture = indicator:CreateTexture(nil, "OVERLAY")
			indicator.texture:SetPoint("CENTER", indicator)
			indicator:SetAlpha(indicatorConfig.alpha)
			indicator:SetBackdrop(backdropTbl)
			indicator:SetBackdropColor(0, 0, 0, 1)
			indicator:SetBackdropBorderColor(0, 0, 0, 0)

			indicator.cooldown = CreateFrame("Cooldown", nil, indicator, "CooldownFrameTemplate")
			indicator.cooldown:SetReverse(true)
			indicator.cooldown:SetPoint("CENTER", 0, -1)
			indicator.cooldown:SetHideCountdownNumbers(true)

			indicator.stack = indicator:CreateFontString(nil, "OVERLAY")
			indicator.stack:SetFont("Interface\\AddOns\\ShadowedUnitFrames\\media\\fonts\\Myriad Condensed Web.ttf", 12, "OUTLINE")
			indicator.stack:SetShadowColor(0, 0, 0, 1.0)
			indicator.stack:SetShadowOffset(0.8, -0.8)
			indicator.stack:SetPoint("BOTTOMRIGHT", indicator, "BOTTOMRIGHT", 1, 0)
			indicator.stack:SetWidth(18)
			indicator.stack:SetHeight(10)
			indicator.stack:SetJustifyH("RIGHT")

			frame.auraIndicators["indicator-" .. id] = indicator
		end

		-- Quick access
		indicator.filters = ShadowUF.db.profile.auraIndicators.filters[key]
		indicator.config = ShadowUF.db.profile.units[frame.unitType].auraIndicators

		-- Set up the sizing options
		indicator:SetHeight(indicatorConfig.height)
		indicator.texture:SetWidth(indicatorConfig.width - 1)
		indicator:SetWidth(indicatorConfig.width)
		indicator.texture:SetHeight(indicatorConfig.height - 1)

		ShadowUF.Layout:AnchorFrame(frame, indicator, indicatorConfig)

		-- Let the auras module quickly access indicators without having to use index
		frame.auraIndicators[key] = indicator

		id = id + 1
	end
end

local playerClass = select(2, UnitClass("player"))
local filterMap = {}
local canCure = ShadowUF.Units.canCure
for _, key in pairs(Indicators.auraFilters) do filterMap[key] = "filter-" .. key end

local function checkFilterAura(frame, type, isFriendly, name, texture, count, auraType, duration, endTime, caster, isRemovable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff)
	local category
	if( isFriendly and canCure[auraType] and type == "debuffs" ) then
		category = "curable"
	elseif( isBossDebuff ) then
		category = "boss"
	else
		return
	end

	local applied = false

	for key, config in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		local indicator = frame.auraIndicators[key]
		if( indicator and indicator.config.enabled and indicator.filters[category].enabled and not ShadowUF.db.profile.units[frame.unitType].auraIndicators[filterMap[category]] ) then
			indicator.showStack = config.showStack
			indicator.priority = indicator.filters[category].priority
			indicator.showIcon = true
			indicator.showDuration = indicator.filters[category].duration
			indicator.spellDuration = duration
			indicator.spellEnd = endTime
			indicator.spellIcon = texture
			indicator.spellName = name
			indicator.spellStack = count
			indicator.colorR = nil
			indicator.colorG = nil
			indicator.colorB = nil

			applied = true
		end
	end

	return applied
end

local function checkSpecificAura(frame, type, name, texture, count, auraType, duration, endTime, caster, isRemovable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff)
	-- Not relevant
	if( not ShadowUF.db.profile.auraIndicators.auras[name] and not ShadowUF.db.profile.auraIndicators.auras[tostring(spellID)] ) then return end

	local auraConfig = Indicators.auraConfig[name] or Indicators.auraConfig[spellID]

	-- Only player auras
	if( auraConfig.player and not playerUnits[caster] ) then return end

	local indicator = auraConfig and frame.auraIndicators[auraConfig.indicator]

	-- No indicator or not enabled
	if( not indicator or not indicator.enabled ) then return end
	-- Missing aura only
	if( auraConfig.missing ) then return end

	-- Disabled on a class level
	if( ShadowUF.db.profile.auraIndicators.disabled[playerClass][name] ) then return end
	-- Disabled aura group by unit
	if( ShadowUF.db.profile.units[frame.unitType].auraIndicators[auraConfig.group] ) then return end


	-- If the indicator is not restricted to the player only, then will give the player a slightly higher priority
	local priority = auraConfig.priority
	local color = auraConfig
	if( not auraConfig.player and playerUnits[caster] ) then
		priority = priority + 0.1
		color = auraConfig.selfColor or auraConfig
	end

	if( priority <= indicator.priority ) then return end

	indicator.showStack = ShadowUF.db.profile.auraIndicators.indicators[auraConfig.indicator].showStack
	indicator.priority = priority
	indicator.showIcon = auraConfig.icon
	indicator.showDuration = auraConfig.duration
	indicator.spellDuration = duration
	indicator.spellEnd = endTime
	indicator.spellIcon = texture
	indicator.spellName = name
	indicator.spellStack = count
	indicator.colorR = color.r
	indicator.colorG = color.g
	indicator.colorB = color.b

	return true
end

local auraList = {}
local function scanAuras(frame, filter, type)
	local isFriendly = not UnitIsEnemy(frame.unit, "player")

	local index = 0
	while( true ) do
		index = index + 1
		local name, texture, count, auraType, duration, endTime, caster, isRemovable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff = UnitAura(frame.unit, index, filter)
		if( not name ) then return end

		local result = checkFilterAura(frame, type, isFriendly, name, texture, count, auraType, duration, endTime, caster, isRemovable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff)
		if( not result ) then
			checkSpecificAura(frame, type, name, texture, count, auraType, duration, endTime, caster, isRemovable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff)
		end

		auraList[name] = true
	end
end

function Indicators:UpdateIndicators(frame)
	for key, indicatorConfig in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		local indicator = frame.auraIndicators[key]
		if( indicator and indicator.enabled and indicator.priority and indicator.priority > -1 ) then
			-- Show a cooldown ring
			if( indicator.showDuration and indicator.spellDuration > 0 and indicator.spellEnd > 0 ) then
				indicator.cooldown:SetCooldown(indicator.spellEnd - indicator.spellDuration, indicator.spellDuration)
			else
				indicator.cooldown:Hide()
			end

			-- Show either the icon, or a solid color
			if( indicator.showIcon and indicator.spellIcon ) then
				indicator.texture:SetTexture(indicator.spellIcon)
				indicator:SetBackdropColor(0, 0, 0, 0)
			else
				indicator.texture:SetColorTexture(indicator.colorR, indicator.colorG, indicator.colorB)
				indicator:SetBackdropColor(0, 0, 0, 1)
			end

			-- Show aura stack
			if( indicator.showStack and indicator.spellStack > 1 ) then
				indicator.stack:SetText(indicator.spellStack)
				indicator.stack:Show()
			else
				indicator.stack:Hide()
			end

			indicator:Show()
		else
			indicator:Hide()
		end
	end
end

function Indicators:UpdateAuras(frame)
	for k in pairs(auraList) do auraList[k] = nil end
	for key, config in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		local indicator = frame.auraIndicators[key]
		if( indicator ) then
			indicator.priority = -1

			if( UnitIsEnemy(frame.unit, "player") ) then
				indicator.enabled = config.hostile
			else
				indicator.enabled = config.friendly
			end
		end
	end

	-- If they are dead, don't bother showing any indicators yet
	if( UnitIsDeadOrGhost(frame.unit) or not UnitIsConnected(frame.unit) ) then
		self:UpdateIndicators(frame)
		return
	end

	-- Scan auras
	scanAuras(frame, "HELPFUL", "buffs")
	scanAuras(frame, "HARMFUL", "debuffs")

	-- Check for any indicators that are triggered due to something missing
	for name in pairs(ShadowUF.db.profile.auraIndicators.missing) do
		if( not auraList[name] and self.auraConfig[name] ) then
			local aura = self.auraConfig[name]
			local indicator = frame.auraIndicators[aura.indicator]
			if( indicator and indicator.enabled and aura.priority > indicator.priority and not ShadowUF.db.profile.auraIndicators.disabled[playerClass][name] ) then
				indicator.priority = aura.priority or -1
				indicator.showIcon = aura.icon
				indicator.showDuration = aura.duration
				indicator.spellDuration = 0
				indicator.spellEnd = 0
				indicator.spellIcon = aura.iconTexture or select(3, GetSpellInfo(name))
				indicator.colorR = aura.r
				indicator.colorG = aura.g
				indicator.colorB = aura.b
			end
		end
	end

	-- Now force the indicators to update
	self:UpdateIndicators(frame)
end
