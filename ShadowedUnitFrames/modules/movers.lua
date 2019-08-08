-- I am undecided if this is a brilliant idea or an insane one
local L = ShadowUF.L
local Movers = {}
local originalEnvs = {}
local unitConfig = {}
local attributeBlacklist = {["showplayer"] = true, ["showraid"] = true, ["showparty"] = true, ["showsolo"] = true, ["initial-unitwatch"] = true}
local playerClass = select(2, UnitClass("player"))
local noop = function() end
local OnDragStop, OnDragStart, configEnv
ShadowUF:RegisterModule(Movers, "movers")

-- This is the fun part, the env to fake units and make them show up as examples
local function getValue(func, unit, value)
	unit = string.gsub(unit, "(%d+)", "")
	if( unitConfig[func .. unit] == nil ) then unitConfig[func .. unit] = value end
	return unitConfig[func .. unit]
end

local function createConfigEnv()
	if( configEnv ) then return end
	configEnv = setmetatable({
		GetRaidTargetIndex = function(unit) return getValue("GetRaidTargetIndex", unit, math.random(1, 8)) end,
		GetLootMethod = function(unit) return "master", 0, 0 end,
		GetComboPoints = function() return MAX_COMBO_POINTS end,
		UnitInRaid = function() return true end,
		UnitInParty = function() return true end,
		UnitIsUnit = function(unitA, unitB) return unitB == "player" and true or false end,
		UnitIsDeadOrGhost = function(unit) return false end,
		UnitIsConnected = function(unit) return true end,
		UnitLevel = function(unit) return MAX_PLAYER_LEVEL end,
		UnitIsPlayer = function(unit) return unit ~= "boss" and unit ~= "pet" and not string.match(unit, "(%w+)pet") end,
		UnitHealth = function(unit) return getValue("UnitHealth", unit, math.random(20000, 50000)) end,
		UnitIsQuestBoss = function(unit) return unit == "target" or unit == "focus" end,
		UnitIsWildBattlePet = function(unit) return unit == "target" or unit == "focus" end,
		UnitBattlePetType = function(unit)
			if( unit == "target" or unit == "focus" ) then
				return getValue("UnitBattlePetType", unit, math.random(#(PET_TYPE_SUFFIX)))
			end
		end,
		GetArenaOpponentSpec = function(unitID)
			return getValue("GetArenaOpponentSpec", unitID, math.random(250, 270))
		end,
		UnitHealthMax = function(unit) return 50000 end,
		UnitPower = function(unit, powerType)
			if( powerType == Enum.PowerType.HolyPower or powerType == Enum.PowerType.SoulShards ) then
				return 3
			elseif( powerType == Enum.PowerType.Chi) then
				return 4
			end

			return getValue("UnitPower", unit, math.random(20000, 50000))
		end,
		UnitGetTotalHealAbsorbs = function(unit)
			return getValue("UnitGetTotalHealAbsorbs", unit, math.random(5000, 10000))
		end,
		UnitGetIncomingHeals = function(unit)
			return getValue("UnitGetIncomingHeals", unit, math.random(10000, 15000))
		end,
		UnitGetTotalAbsorbs = function(unit)
			return getValue("UnitGetTotalAbsorbs", unit, math.random(2500, 5000))
		end,
		UnitPowerMax = function(unit, powerType)
			if( powerType == Enum.PowerType.Rage or powerType == Enum.PowerType.Energy or powerType == Enum.PowerType.RunicPower
			 or powerType == Enum.PowerType.LunarPower or powerType == Enum.PowerType.Maelstrom or powerType == Enum.PowerType.Insanity
			 or powerType == Enum.PowerType.Fury or powerType == Enum.PowerType.Pain ) then
				return 100
			elseif( powerType == Enum.PowerType.Focus ) then
				return 120
			elseif( powerType == Enum.PowerType.ComboPoints or powerType == Enum.PowerType.SoulShards or powerType == Enum.PowerType.HolyPower
			     or powerType == Enum.PowerType.Chi ) then
				return 5
			elseif( powerType == Enum.PowerType.Runes ) then
				return 6
			elseif( powerType == Enum.PowerType.ArcaneCharges ) then
				return 4
			end

			return 50000
		end,
		UnitHasIncomingResurrection = function(unit) return true end,
		UnitInOtherParty = function(unit) return getValue("UnitInOtherParty", unit, math.random(0, 1) == 1) end,
		UnitInPhase = function(unit) return false end,
		UnitExists = function(unit) return true end,
		UnitIsGroupLeader = function() return true end,
		UnitIsPVP = function(unit) return true end,
		UnitIsDND = function(unit) return false end,
		UnitIsAFK = function(unit) return false end,
		UnitFactionGroup = function(unit) return _G.UnitFactionGroup("player") end,
		UnitAffectingCombat = function() return true end,
		UnitThreatSituation = function() return 0 end,
		UnitDetailedThreatSituation = function() return nil end,
		UnitCastingInfo = function(unit)
			-- 1 -> 10: spell, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID
			local data = unitConfig["UnitCastingInfo" .. unit] or {}
			if( not data[5] or GetTime() < data[5] ) then
				data[1] = L["Test spell"]
				data[2] = L["Test spell"]
				data[3] = "Interface\\Icons\\Spell_Nature_Rejuvenation"
				data[4] = GetTime() * 1000
				data[5] = data[4] + 60000
				data[6] = false
				data[7] = math.floor(GetTime())
				data[8] = math.random(0, 100) < 25
				data[9] = 1000
				unitConfig["UnitCastingInfo" .. unit] = data
			end

			return unpack(data)
		end,
		UnitIsFriend = function(unit) return unit ~= "target" and unit ~= ShadowUF.fakeUnits[unit] and unit ~= "arena" end,
		GetReadyCheckStatus = function(unit)
			local status = getValue("GetReadyCheckStatus", unit, math.random(1, 3))
			return status == 1 and "ready" or status == 2 and "notready" or "waiting"
		end,
		GetPartyAssignment = function(type, unit)
			local assignment = getValue("GetPartyAssignment", unit, math.random(1, 2) == 1 and "MAINTANK" or "MAINASSIST")
			return assignment == type
		end,
		UnitGroupRolesAssigned = function(unit)
			local role = getValue("UnitGroupRolesAssigned", unit, math.random(1, 3))
			return role == 1 and "TANK" or (role == 2 and "HEALER" or (role == 3 and "DAMAGER"))
		end,
		UnitPowerType = function(unit)
			local powerType = math.random(0, 4)
			powerType = getValue("UnitPowerType", unit, powerType == 4 and 6 or powerType)

			return powerType, powerType == 0 and "MANA" or powerType == 1 and "RAGE" or powerType == 2 and "FOCUS" or powerType == 3 and "ENERGY" or powerType == 6 and "RUNIC_POWER"
		end,
		UnitStagger = function(unit)
			if( unit ~= "player" ) then return nil end
			return getValue("UnitStagger", math.random(2000, 10000))
		end,
		UnitAura = function(unit, id, filter)
			if( type(id) ~= "number" or id > 40 ) then return end

			local texture = filter == "HELPFUL" and "Interface\\Icons\\Spell_Nature_Rejuvenation" or "Interface\\Icons\\Ability_DualWield"
			local mod = id % 5
			local auraType = mod == 0 and "Magic" or mod == 1 and "Curse" or mod == 2 and "Poison" or mod == 3 and "Disease" or "none"
			return L["Test Aura"], texture, id, auraType, 0, 0, "player", id % 6 == 0
		end,
		UnitName = function(unit)
			local unitID = string.match(unit, "(%d+)")
			if( unitID ) then
				return string.format("%s #%d", L.units[string.gsub(unit, "(%d+)", "")] or unit, unitID)
			end

			return L.units[unit]
		end,
		UnitClass = function(unit)
			local classToken = getValue("UnitClass", unit, CLASS_SORT_ORDER[math.random(1, #(CLASS_SORT_ORDER))])
			return LOCALIZED_CLASS_NAMES_MALE[classToken], classToken
		end,
	}, {
		__index = _G,
		__newindex = function(tbl, key, value) _G[key] = value end,
	})
end

-- Child units have to manually be added to the list to make sure they function properly
local function prepareChildUnits(header, ...)
	for i=1, select("#", ...) do
		local frame = select(i, ...)
		if( frame.unitType and not frame.configUnitID ) then
			ShadowUF.Units.frameList[frame] = true
			frame.configUnitID = header.groupID and (header.groupID * 5) - 5 + i or i
			frame:SetAttribute("unit", ShadowUF[header.unitMappedType .. "Units"][frame.configUnitID])
		end
	end
end

local function OnEnter(self)
	local tooltip = self.tooltipText or self.unitID and string.format("%s #%d", L.units[self.unitType], self.unitID) or L.units[self.unit] or self.unit
	local additionalText = ShadowUF.Units.childUnits[self.unitType] and L["Child units cannot be dragged, you will have to reposition them through /shadowuf."]

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	GameTooltip:SetText(tooltip, 1, 0.81, 0, 1, true)
	if( additionalText ) then GameTooltip:AddLine(additionalText, 0.90, 0.90, 0.90, 1) end
	GameTooltip:Show()
end

local function OnLeave(self)
	GameTooltip:Hide()
end

local function setupUnits(childrenOnly)
	for frame in pairs(ShadowUF.Units.frameList) do
		if( frame.configMode ) then
			-- Units visible, but it's not supposed to be
			if( frame:IsVisible() and not ShadowUF.db.profile.units[frame.unitType].enabled ) then
				RegisterUnitWatch(frame, frame.hasStateWatch)
				if( not UnitExists(frame.unit) ) then frame:Hide() end

			-- Unit's not visible and it's enabled so it should
			elseif( not frame:IsVisible() and ShadowUF.db.profile.units[frame.unitType].enabled ) then
				UnregisterUnitWatch(frame)

				frame:SetAttribute("state-unitexists", true)
				frame:FullUpdate()
				frame:Show()
			end
		elseif( not frame.configMode and ShadowUF.db.profile.units[frame.unitType].enabled ) then
			frame.originalUnit = frame:GetAttribute("unit")
			frame.originalOnEnter = frame.OnEnter
			frame.originalOnLeave = frame.OnLeave
			frame.originalOnUpdate = frame:GetScript("OnUpdate")
			frame:SetMovable(not ShadowUF.Units.childUnits[frame.unitType])
			frame:SetScript("OnDragStop", OnDragStop)
			frame:SetScript("OnDragStart", OnDragStart)
			frame.OnEnter = OnEnter
			frame.OnLeave = OnLeave
			frame:SetScript("OnEvent", nil)
			frame:SetScript("OnUpdate", nil)
			frame:RegisterForDrag("LeftButton")
			frame.configMode = true
			frame.unitOwner = nil
			frame.originalMenu = frame.menu
			frame.menu = nil

			local unit
			if( frame.isChildUnit ) then
				local unitFormat = string.gsub(string.gsub(frame.unitType, "target$", "%%dtarget"), "pet$", "pet%%d")
				unit = string.format(unitFormat, frame.parent.configUnitID or "")
			else
				unit = frame.unitType .. (frame.configUnitID or "")
			end

			ShadowUF.Units.OnAttributeChanged(frame, "unit", unit)

			if( frame.healthBar ) then frame.healthBar:SetScript("OnUpdate", nil) end
			if( frame.powerBar ) then frame.powerBar:SetScript("OnUpdate", nil) end
			if( frame.indicators ) then frame.indicators:SetScript("OnUpdate", nil) end

			UnregisterUnitWatch(frame)
			frame:FullUpdate()
			frame:Show()
		end
	end
end

function Movers:Enable()
	createConfigEnv()

	-- Force create zone headers
	for type, zone in pairs(ShadowUF.Units.zoneUnits) do
		if( ShadowUF.db.profile.units[type].enabled ) then
			ShadowUF.Units:InitializeFrame(type)
		end
	end

	-- Setup the headers
	for _, header in pairs(ShadowUF.Units.headerFrames) do
		for key in pairs(attributeBlacklist) do
			header:SetAttribute(key, nil)
		end

		local config = ShadowUF.db.profile.units[header.unitType]
		if( config.frameSplit ) then
			header:SetAttribute("startingIndex", -4)
		elseif( config.maxColumns ) then
			local maxUnits = MAX_RAID_MEMBERS
			if( config.filters ) then
				for _, enabled in pairs(config.filters) do
					if( not enabled ) then
						maxUnits = maxUnits - 5
					end
				end
			end

			header:SetAttribute("startingIndex", -math.min(config.maxColumns * config.unitsPerColumn, maxUnits) + 1)
		elseif( ShadowUF[header.unitType .. "Units"] ) then
			header:SetAttribute("startingIndex", -#(ShadowUF[header.unitType .. "Units"]) + 1)
		end

		header.startingIndex = header:GetAttribute("startingIndex")
		header:SetMovable(true)
		prepareChildUnits(header, header:GetChildren())
	end

	-- Setup the test env
	if( not self.isEnabled ) then
		for _, func in pairs(ShadowUF.tagFunc) do
			if( type(func) == "function" ) then
				originalEnvs[func] = getfenv(func)
				setfenv(func, configEnv)
			end
		end

		for _, module in pairs(ShadowUF.modules) do
			if( module.moduleName ) then
				for key, func in pairs(module) do
					if( type(func) == "function" ) then
						originalEnvs[module[key]] = getfenv(module[key])
						setfenv(module[key], configEnv)
					end
				end
			end
		end
	end

	-- Why is this called twice you ask? Child units are created on the OnAttributeChanged call
	-- so the first call gets all the parent units, the second call gets the child units
	setupUnits()
	setupUnits(true)

	for unitType in pairs(ShadowUF.Units.zoneUnits) do
		local header = ShadowUF.Units.headerFrames[unitType]
		if( ShadowUF.db.profile.units[unitType].enabled and header ) then
			header:SetAttribute("childChanged", 1)
		end
	end


	-- Don't show the dialog if the configuration is opened through the configmode spec
	if( not self.isConfigModeSpec ) then
		self:CreateInfoFrame()
		self.infoFrame:Show()
	elseif( self.infoFrame ) then
		self.infoFrame:Hide()
	end

	self.isEnabled = true
end

function Movers:Disable()
	if( not self.isEnabled ) then return nil end

	for func, env in pairs(originalEnvs) do
		setfenv(func, env)
		originalEnvs[func] = nil
	end

	for frame in pairs(ShadowUF.Units.frameList) do
		if( frame.configMode ) then
			if( frame.isMoving ) then
				frame:GetScript("OnDragStop")(frame)
			end

			frame.configMode = nil
			frame.unitOwner = nil
			frame.unit = nil
			frame.configUnitID = nil
			frame.menu = frame.originalMenu
			frame.originalMenu = nil
			frame.Hide = frame.originalHide
			frame:SetAttribute("unit", frame.originalUnit)
			frame:SetScript("OnDragStop", nil)
			frame:SetScript("OnDragStart", nil)
			frame:SetScript("OnEvent", frame:IsVisible() and ShadowUF.Units.OnEvent or nil)
			frame:SetScript("OnUpdate", frame.originalOnUpdate)
			frame.OnEnter = frame.originalOnEnter
			frame.OnLeave = frame.originalOnLeave
			frame:SetMovable(false)
			frame:RegisterForDrag()

			if( frame.isChildUnit ) then
				ShadowUF.Units.OnAttributeChanged(frame, "unit", SecureButton_GetModifiedUnit(frame))
			end


			RegisterUnitWatch(frame, frame.hasStateWatch)
			if( not UnitExists(frame.unit) ) then frame:Hide() end
		end
	end

	for type, header in pairs(ShadowUF.Units.headerFrames) do
		header:SetMovable(false)
		header:SetAttribute("startingIndex", 1)
		header:SetAttribute("initial-unitWatch", true)

		if( header.unitType == type or type == "raidParent" ) then
			ShadowUF.Units:ReloadHeader(header.unitType)
		end
	end

	ShadowUF.Units:CheckPlayerZone(true)
	ShadowUF.Layout:Reload()

	-- Don't store these so everything can be GCed
	unitConfig = {}

	if( self.infoFrame ) then
		self.infoFrame:Hide()
	end

	self.isConfigModeSpec = nil
	self.isEnabled = nil
end

OnDragStart = function(self)
	if( not self:IsMovable() ) then return end

	if( self.unitType == "raid" and ShadowUF.Units.headerFrames.raidParent and ShadowUF.Units.headerFrames.raidParent:IsVisible() ) then
		self = ShadowUF.Units.headerFrames.raidParent
	else
		self = ShadowUF.Units.headerFrames[self.unitType] or ShadowUF.Units.unitFrames[self.unitType]
	end

	self.isMoving = true
	self:StartMoving()
end

OnDragStop = function(self)
	if( not self:IsMovable() ) then return end
	if( self.unitType == "raid" and ShadowUF.Units.headerFrames.raidParent and ShadowUF.Units.headerFrames.raidParent:IsVisible() ) then
		self = ShadowUF.Units.headerFrames.raidParent
	else
		self = ShadowUF.Units.headerFrames[self.unitType] or ShadowUF.Units.unitFrames[self.unitType]
	end

	self.isMoving = nil
	self:StopMovingOrSizing()

	-- When dragging the frame around, Blizzard changes the anchoring based on the closet portion of the screen
	-- When a widget is near the top left it uses top left, near the left it uses left and so on, which messes up positioning for header frames
	local scale = (self:GetScale() * UIParent:GetScale()) or 1
	local position = ShadowUF.db.profile.positions[self.unitType]
	local point, _, relativePoint, x, y = self:GetPoint()

	-- Figure out the horizontal anchor
	if( self.isHeaderFrame ) then
		if( ShadowUF.db.profile.units[self.unitType].attribAnchorPoint == "RIGHT" ) then
			x = self:GetRight()
			point = "RIGHT"
		else
			x = self:GetLeft()
			point = "LEFT"
		end

		if( ShadowUF.db.profile.units[self.unitType].attribPoint == "BOTTOM" ) then
			y = self:GetBottom()
			point = "BOTTOM" .. point
		else
			y = self:GetTop()
			point = "TOP" .. point
		end

		relativePoint = "BOTTOMLEFT"
		position.bottom = self:GetBottom() * scale
		position.top = self:GetTop() * scale
	end

	position.anchorTo = "UIParent"
	position.movedAnchor = nil
	position.anchorPoint = ""
	position.point = point
	position.relativePoint = relativePoint
	position.x = x * scale
	position.y = y * scale

	ShadowUF.Layout:AnchorFrame(UIParent, self, ShadowUF.db.profile.positions[self.unitType])

	-- Unlock the parent frame from the mover now too
	if( self.parent ) then
		ShadowUF.Layout:AnchorFrame(UIParent, self.parent, ShadowUF.db.profile.positions[self.parent.unitType])
	end

	-- Notify the configuration it can update itself now
	local ACR = LibStub("AceConfigRegistry-3.0", true)
	if( ACR ) then
		ACR:NotifyChange("ShadowedUF")
	end
end

function Movers:Update()
	if( not ShadowUF.db.profile.locked ) then
		self:Enable()
	elseif( ShadowUF.db.profile.locked ) then
		self:Disable()
	end
end

function Movers:CreateInfoFrame()
	if( self.infoFrame ) then return end

	-- Show an info frame that users can lock the frames through
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetClampedToScreen(true)
	frame:SetWidth(300)
	frame:SetHeight(115)
	frame:RegisterForDrag("LeftButton")
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:SetScript("OnEvent", function(f)
		if( not ShadowUF.db.profile.locked and f:IsVisible() ) then
			ShadowUF.db.profile.locked = true
			Movers:Disable()

			DEFAULT_CHAT_FRAME:AddMessage(L["You have entered combat, unit frames have been locked. Once you leave combat you will need to unlock them again through /shadowuf."])
		end
	end)
	frame:SetScript("OnDragStart", function(f)
		f:StartMoving()
	end)
	frame:SetScript("OnDragStop", function(f)
		f:StopMovingOrSizing()
	end)
	frame:SetBackdrop({
		  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		  edgeSize = 26,
		  insets = {left = 9, right = 9, top = 9, bottom = 9},
	})
	frame:SetBackdropColor(0, 0, 0, 0.85)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 225)

	frame.titleBar = frame:CreateTexture(nil, "ARTWORK")
	frame.titleBar:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	frame.titleBar:SetPoint("TOP", 0, 8)
	frame.titleBar:SetWidth(350)
	frame.titleBar:SetHeight(45)

	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.title:SetPoint("TOP", 0, 0)
	frame.title:SetText("Shadowed Unit Frames")

	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	frame.text:SetText(L["The unit frames you see are examples, they are not perfect and do not show all the data they normally would.|n|nYou can hide them by locking them through /shadowuf or clicking the button below."])
	frame.text:SetPoint("TOPLEFT", 12, -22)
	frame.text:SetWidth(frame:GetWidth() - 20)
	frame.text:SetJustifyH("LEFT")

	frame.lock = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.lock:SetText(L["Lock frames"])
	frame.lock:SetHeight(20)
	frame.lock:SetWidth(100)
	frame.lock:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 8)
	frame.lock:SetScript("OnEnter", OnEnter)
	frame.lock:SetScript("OnLeave", OnLeave)
	frame.lock.tooltipText = L["Locks the unit frame positionings hiding the mover boxes."]
	frame.lock:SetScript("OnClick", function()
		ShadowUF.db.profile.locked = true
		Movers:Update()
	end)

	frame.unlink = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.unlink:SetText(L["Unlink frames"])
	frame.unlink:SetHeight(20)
	frame.unlink:SetWidth(100)
	frame.unlink:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
	frame.unlink:SetScript("OnEnter", OnEnter)
	frame.unlink:SetScript("OnLeave", OnLeave)
	frame.unlink.tooltipText = L["WARNING: This will unlink all frames from each other so you can move them without another frame moving with it."]
	frame.unlink:SetScript("OnClick", function()
		for f in pairs(ShadowUF.Units.frameList) do
			if( not ShadowUF.Units.childUnits[f.unitType] and f:GetScript("OnDragStart") and f:GetScript("OnDragStop") ) then
				f:GetScript("OnDragStart")(f)
				f:GetScript("OnDragStop")(f)
			end
		end

		Movers:Update()
	end)

	self.infoFrame = frame
end
