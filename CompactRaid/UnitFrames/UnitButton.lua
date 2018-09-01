------------------------------------------------------------
-- UnitButton.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local _G = _G
local type = type
local ipairs = ipairs
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsPlayer = UnitIsPlayer
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local select = select
local UnitClass = UnitClass
local UnitPlayerControlled = UnitPlayerControlled
local UnitCanAttack = UnitCanAttack
local UnitReaction = UnitReaction
local DebuffTypeColor = DebuffTypeColor
local UnitBuff = Pre80API.UnitBuff
local UnitDebuff = Pre80API.UnitDebuff
local UnitAura = Pre80API.UnitAura
local wipe = wipe
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitHasVehicleUI = UnitHasVehicleUI
local strmatch = strmatch
local UnitPowerType = UnitPowerType
local PowerBarColor = PowerBarColor
local UnitPowerMax = UnitPowerMax
local UnitName = UnitName
local UnitIsUnit = UnitIsUnit
local UnitThreatSituation = UnitThreatSituation
local GetThreatStatusColor = GetThreatStatusColor
local GetReadyCheckStatus = GetReadyCheckStatus
local GetTime = GetTime
local GetRaidTargetIndex = GetRaidTargetIndex
local SetRaidTargetIconTexture = SetRaidTargetIconTexture
local UnitHasIncomingResurrection = UnitHasIncomingResurrection
local UnitInRange = UnitInRange
local UnitIsVisible = UnitIsVisible
local InCombatLockdown = InCombatLockdown
local GameTooltip = GameTooltip
local CreateFrame = CreateFrame
local tinsert = tinsert
local RegisterStateDriver = RegisterStateDriver
local RegisterUnitWatch = RegisterUnitWatch
local strlen = string.utf8len or strlen
local strsub = string.utf8sub or strsub
local GetTexCoordsForRoleSmallCircle = GetTexCoordsForRoleSmallCircle
local GetNumTalents = GetNumTalents
local GetTalentInfo = GetTalentInfo
local UnitGUID = UnitGUID
local tonumber = tonumber
local GetRaidRosterInfo = GetRaidRosterInfo
local UnitIsGroupLeader = UnitIsGroupLeader
local GetLootMethod = GetLootMethod
local UnitIsTapDenied = UnitIsTapDenied
local max = max
local min = min

local _, addon = ...

local outrangeOpacity = 0.4
local healthBarColor = { r = 0, g = 1, b = 0 }
local nameTextColor = { r = 1, g = 1, b = 1 }
local powerBarColor = { r = 0, g = 0, b = 1 }
local bkgndColor = { r = 0, g = 0, b = 0 }

local unitFrames = {} -- Stores all unit frames that were created by this addon

function addon:NumButtons()
	return #unitFrames
end

function addon:GetButton(index)
	return unitFrames[index]
end

function addon:FindUnitFrame(unit, byGuid)
	if type(unit) ~= "string" then
		return
	end

	local i
	for i = 1, #unitFrames do
		local button = unitFrames[i]
		local displayedUnit = button.displayedUnit
		if displayedUnit and button:IsVisible() then
			if byGuid then
				if UnitGUID(displayedUnit) == unit then
					return button
				end
			else
				if UnitIsUnit(unit, displayedUnit) then
					return button
				end
			end
		end
	end
end

local function BroadcastUnitNotify(frame, event, ...)
	if addon:Initialized() then
		addon:BroadcastEvent("OnUnitNotify", frame, event, ...)
	end
end

-- Enumerate all created unit frames
----------------------------------------------------------------
-- The way how this function works depends on arguments list you pass:

-- Arguments			-- Results
----------------------------------------------------------------
-- func, ...			-- func(frame, ...)		-- func is a valid function
-- object, "method", ...	-- object:method(frame, ...)	-- object is a table, "method" is a member function name of object
-- "method", ...		-- frame:method(...)		-- "method" is a member function name of the frame, such as "SetScale", "Show", "Hide", etc
----------------------------------------------------------------

function addon:EnumUnitFrames(object, func, ...)
	return addon._EnumFrames(unitFrames, object, func, ...)
end

local function GetUnitColor(unit, isName)
	if not unit then
		return 1, 1, 1
	end

	if not isName and not UnitIsConnected(unit) then
		return 0.5, 0.5, 0.5
	end

	local dead = UnitIsDead(unit)
	if UnitIsPlayer(unit) then
		local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
		if color then
			return color.r, color.g, color.b
		else
			return 1, 1, 1
		end
	elseif not isName and (dead or UnitIsTapDenied(unit)) then
		return 0.5, 0.5, 0.5
	elseif UnitPlayerControlled(unit) then
		if UnitCanAttack(unit, "player") then
			return 1, 0, 0
		elseif UnitCanAttack("player", unit) then
			return 1, 1, 0
		else
			return 0.5, 0.5, 1 -- friendly pet
		end
	else
		local reaction = UnitReaction(unit, "player")
		if not reaction then
			return 0.5, 0.5, 1
		elseif reaction < 4 then
			return 1, 0, 0
		elseif reaction > 4 then
			return 0, 1, 0
		else
			return 1, 1, 0
		end
	end
end

local function UpdateAuras(self, name, icon, count, duration, expires, dispelType)
	if name then
		self.icon:SetTexture(icon)
		if count and count > 1 then
			self.count:SetText(count)
			self.count:Show()
		else
			self.count:Hide()
		end
		if expires and expires ~= 0 then
			self.cooldown:SetCooldown(expires - duration, duration)
			self.cooldown:Show()
		else
			self.cooldown:Hide()
		end

		if dispelType then
			local color = DebuffTypeColor[dispelType] or DebuffTypeColor["none"]
			self.border:SetVertexColor(color.r, color.g, color.b)
		end

		self:Show()
	else
		self:Hide()
	end
end

local function UnitFrame_UpdateBuffs(self)
	if not addon.db.showBuffs then
		return
	end

	local unit = self.displayedUnit
	if not unit then return end
	local i
	for i = 1, 3 do
		local frame = self.buffFrames[i]
		local name, icon, count, _, duration, expires = UnitBuff(unit, i, "RAID|PLAYER")
		UpdateAuras(frame, name, icon, count, duration, expires)
	end
end

local function UnitFrame_UpdateDebuffs(self)
	if not addon.db.showDebuffs then
		return
	end

	local unit = self.displayedUnit
	if not unit then return end

	local filter = addon.db.onlyDispellable and "RAID" or ""
	local index = 0
	local i
	for i = 1, 40 do
		if index >= 3 then
			break
		end

		local name, icon, count, dispelType, duration, expires = UnitDebuff(unit, i, filter)
		if not name then
			break
		end

		if duration and duration < 600 then
			index = index + 1
			UpdateAuras(self.debuffFrames[index], name, icon, count, duration, expires, dispelType or "none")
		end
	end

	for i = index + 1, 3 do
		self.debuffFrames[i]:Hide()
	end
end

--[[
-------------------------------------------------------
-- Make sure dispel magic icon only appear when such healing class has spent
-- points on their own magical cleansing talents, excepts for priests who are
-- always able to dispel magic regardless of talents.
-------------------------------------------------------

local DISPELABLES = { Magic = 1, Curse = 1, Disease = 1, Poison = 1 }
local DISPELABLE_CLASSES = { PALADIN = { tree = 1, spell = 53551 }, DRUID = { tree = 3, spell = 88423 }, SHAMAN = { tree = 3, spell = 77130 } }
local dispelSpellData = DISPELABLE_CLASSES[select(2, UnitClass("player"))]

if dispelSpellData then
	dispelSpellData.spell = GetSpellInfo(dispelSpellData.spell)
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_ALIVE")
	frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	frame:SetScript("OnEvent", function(self)
		DISPELABLES.Magic = nil
		local tab, spell = dispelSpellData.tree, dispelSpellData.spell
		local i
		for i = 1, GetNumTalents(tab) do
			local talent, _, _, _, points = GetTalentInfo(tab, i)
			if talent == spell then
				DISPELABLES.Magic = points > 0
				return
			end
		end
	end)
end
--]]

local function UnitFrame_UpdateDispels(self)
	if not addon.db.showDispels then
		return
	end

	local unit = self.displayedUnit
	if not unit then return end
	wipe(self.dispelable)
	local i
	for i = 1, 3 do
		local frame = self.dispelFrames[i]
		local name, _, _, dispelType = UnitDebuff(unit, i, "RAID")
		if name and --[[DISPELABLES[dispelType]--]] dispelType and not self.dispelable[dispelType] then
			self.dispelable[dispelType] = i
			frame.icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff"..dispelType)
			frame:Show()
		else
			frame:Hide()
		end
	end
end

local function UnitFrame_UpdateAuras(self)
	local unit = self.displayedUnit
	if not unit then return end

	UnitFrame_UpdateBuffs(self)
	UnitFrame_UpdateDebuffs(self)
	UnitFrame_UpdateDispels(self)

	BroadcastUnitNotify(self, "OnAurasChange", unit, self.unit, self.inVehicle, self.unitClass)
end

local function UnitFrame_UpdateRole(self)
	local unit = self.unit
	if not unit then return end
	local icon = self.roleIcon
	local status
	if addon.db.showRoleIcon then
		if self.inVehicle then
			icon:SetTexture("Interface\\Vehicles\\UI-Vehicles-Raid-Icon")
			icon:SetTexCoord(0, 1, 0, 1)
			status = "VEHICLE"
		else
			status = UnitGroupRolesAssigned(unit)
			if status == "TANK" or status == "HEALER" or status == "DAMAGER" then
				icon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
				icon:SetTexCoord(GetTexCoordsForRoleSmallCircle(status))
			else
				status = nil
			end
		end
	end

	if status then
		icon:Show()
	else
		icon:Hide()
	end

	if self.roleIconStatus ~= status then
		self.roleIconStatus = status
		BroadcastUnitNotify(self, "OnRoleIconChange", status)
	end
end

local UNIT_PREDICTION_THRESHOLD = 0.02

local function UnitFrame_UpdatePredictionBar(self, func, bar)
	local unit = self.displayedUnit
	if not unit or self.unitFlag then
		bar:Hide()
		return 0, 0, 0
	end

	local width = 0
	local healthBar = self.healthBar
	local health = healthBar:GetValue()
	local _, maxHealth = healthBar:GetMinMaxValues()
	local value = func(unit) or 0
	if value / maxHealth < UNIT_PREDICTION_THRESHOLD then
		value = 0
	end

	local lacks = maxHealth - health
	if lacks > 1 and value > 1 then
		width = min(value, lacks) / maxHealth * healthBar:GetWidth()
	end

	if width > 1 then
		bar:SetWidth(width)
		bar:Show()
	else
		bar:Hide()
	end

	return value, health, maxHealth
end

local function UnitFrame_UpdateHealthPrediction(self)
	UnitFrame_UpdatePredictionBar(self, UnitGetIncomingHeals, self.incomingHeal)
end

local function UnitFrame_UpdateShieldAbsorbs(self)
	local value, health, maxHealth = UnitFrame_UpdatePredictionBar(self, UnitGetTotalAbsorbs, self.shieldBar)
	if value > 1 and value + health >= maxHealth then
		self.overShieldGlow:Show()
	else
		self.overShieldGlow:Hide()
	end
end

local function UnitFrame_UpdateHealthAbsorbs(self)
	local absorbsBar = self.absorbsBar
	local unit = self.displayedUnit
	if not unit or self.unitFlag then
		absorbsBar:Hide()
		return
	end

	local _, healthMax = absorbsBar:GetMinMaxValues()
	local absorbs = UnitGetTotalHealAbsorbs(unit) or 0
	if absorbs > healthMax then
		absorbs = healthMax
	end

	if absorbs / healthMax > UNIT_PREDICTION_THRESHOLD then
		absorbsBar:SetValue(absorbs)
		absorbsBar:Show()
	else
		absorbsBar:Hide()
	end
end

local function UnitFrame_UpdateVehicleStatus(self)
	local unit = self.unit
	if not unit then return end
	if UnitHasVehicleUI(unit) then
		self.inVehicle = 1
		if unit == "player" then
			self.displayedUnit = "vehicle"
		else
			local prefix, id, suffix = strmatch(unit, "([^%d]+)([%d]*)(.*)")
			self.displayedUnit = prefix.."pet"..id..suffix
		end
	else
		self.inVehicle = nil
		self.displayedUnit = unit
	end
end

local function UnitFrame_UpdateHealthMax(self)
	local unit = self.displayedUnit
	if not unit then return end

	local healthMax = UnitHealthMax(unit)
	self.healthBar:SetMinMaxValues(0, healthMax)
	self.absorbsBar:SetMinMaxValues(0, healthMax)
end

local function UnitFrame_UpdateHealth(self)
	local unit = self.displayedUnit
	if not unit then return end
	self.healthBar:SetValue(UnitHealth(unit))
end

local function UnitFrame_UpdateHealthColor(self)
	local unit = self.unit
	if not unit then return end
	local r, g, b
	if not UnitIsConnected(unit) then
		r, g, b = 0.5, 0.5, 0.5
	elseif addon.db.forceHealthColor then
		r, g, b = healthBarColor.r, healthBarColor.g, healthBarColor.b
	elseif self.inVehicle then
		r, g, b = 0, 1, 0
	else
		r, g, b = GetUnitColor(unit)
	end

	self.incomingHeal:SetVertexColor(r * 0.5, g * 0.5, b * 0.5)
	self.shieldBar:SetVertexColor(r * 0.5, g * 0.5, b * 0.5)

	local dr, dg, db = r * 0.25, g * 0.25, b * 0.25
	if addon.db.invertColor then
		self.healthBarBackground:SetVertexColor(dr, dg, db)
		self.healthBar:SetStatusBarColor(r, g, b)
	else
		self.healthBarBackground:SetVertexColor(r, g, b)
		self.healthBar:SetStatusBarColor(dr, dg, db)
	end
end

local function UnitFrame_UpdatePowerType(self)
	local unit = self.displayedUnit
	if not unit then return end
	local r, g, b
	if not UnitIsConnected(unit) then
		r, g, b = 0.5, 0.5, 0.5
	elseif addon.db.forcePowerColor then
		r, g, b = powerBarColor.r, powerBarColor.g, powerBarColor.b
	else
		local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
		local prefix = _G[powerToken]
		local info = PowerBarColor[powerToken]
		if info then
			r, g, b = info.r, info.g, info.b
		else
			if not altR then
				info = PowerBarColor[powerType] or PowerBarColor["MANA"]
				r, g, b = info.r, info.g, info.b
			else
				r, g, b = altR, altG, altB
			end
		end
	end
	local dr, dg, db = r * 0.25, g * 0.25, b * 0.25
	if addon.db.invertColor then
		self.powerBarBackground:SetVertexColor(dr, dg, db)
		self.powerBar:SetStatusBarColor(r, g, b)
	else
		self.powerBarBackground:SetVertexColor(r, g, b)
		self.powerBar:SetStatusBarColor(dr, dg, db)
	end
end

local function UnitFrame_UpdatePowerMax(self)
	local unit = self.displayedUnit
	if not unit then return end
	local value = UnitPowerMax(unit)
	if value > 0 then
		self.powerBar:SetMinMaxValues(0, value)
		self.powerBar:Show()
		self.powerBarBackground:Show()
	else
		self.powerBar:Hide()
		self.powerBarBackground:Hide()
	end
end

local function UnitFrame_UpdatePower(self)
	local unit = self.displayedUnit
	if not unit then return end
	self.powerBar:SetValue(UnitPower(unit))
end

local function UnitFrame_UpdateNameColor(self)
	local unit = self.unit
	if not unit then return end
	if addon.db.forceNameColor then
		self.nameText:SetTextColor(nameTextColor.r, nameTextColor.g, nameTextColor.b)
	else
		local r, g, b = GetUnitColor(unit, 1)
		self.nameText:SetTextColor(r, g, b)
	end
end

local function UnitFrame_UpdateNameSize(self)
	local unit = self.unit
	if not unit then return end

	local text = UnitName(unit)
	local name = self.nameText
	if not text then
		name:SetText()
		return
	end

	local buttonWidth = self:GetWidth()
	if buttonWidth < 1 then
		return
	end

	local widthLimit = addon.db.nameWidthLimit
	if type(widthLimit) == "number" then
		widthLimit = widthLimit / 100
	else
		widthLimit = 0.75
	end

	local i
	for i = strlen(text), 0, -1 do
		name:SetText(strsub(text, 1, i))
		if name:GetWidth() / buttonWidth <= widthLimit then
			break
		end
	end
end

local function UnitFrame_UpdateName(self)
	UnitFrame_UpdateNameSize(self)
	UnitFrame_UpdateNameColor(self)
	self.unitClass = self.unit and select(2, UnitClass(self.unit))
	BroadcastUnitNotify(self, "OnUnitChange", self.displayedUnit, self.unit, self.inVehicle, self.unitClass)
end

local function UnitFrame_UpdateHealthText(self)
	local unit = self.displayedUnit
	if not unit then return end

	local mode = addon.db.healthtextmode
	local text
	if mode == 3 then -- health percentage
		local healthMax = UnitHealthMax(unit)
		if healthMax > 0 then
			local health = UnitHealth(unit)
			if health < healthMax then
				text = format("%d%%", health / healthMax * 100)
			end
		end
	elseif mode == 2 then -- health lost
		local lost = UnitHealthMax(unit) - UnitHealth(unit)
		if lost > 0 then
			text = format("-%d", lost)
		end
	elseif mode == 1 then -- health remain
		text = format("%d", UnitHealth(unit))
	end
	self.healthText:SetText(text)
end

local function UnitFrame_UpdateTarget(self)
	local unit = self.displayedUnit
	if not unit then return end
	if UnitIsUnit(unit, "target") then
		self.selectionHighlight:Show()
	else
		self.selectionHighlight:Hide()
	end
end

local function UnitFrame_UpdateThreat(self)
	local unit = self.displayedUnit
	if not unit or not UnitExists(unit) then return end
	local status = UnitThreatSituation(unit)
	if status and status >= 2 then
		self.aggroHighlight:SetVertexColor(GetThreatStatusColor(status))
		self.aggroHighlight:Show()
	else
		self.aggroHighlight:Hide()
	end
end

local READYCHECK_STATUS = { ready = READY_CHECK_READY_TEXTURE, notready = READY_CHECK_NOT_READY_TEXTURE, waiting = READY_CHECK_WAITING_TEXTURE }

local function UnitFrame_UpdateReadyCheck(self)
	local unit = self.unit
	if not unit then return end
	local status = GetReadyCheckStatus(unit)
	self.readyCheckStatus = status
	local texture = READYCHECK_STATUS[status]
	if texture then
		self.readyCheckIcon:SetTexture(texture)
		self.readyCheckIcon:Show()
	else
		self.readyCheckIcon:Hide()
	end
end

local function UnitFrame_FinishReadyCheck(self)
	if self.readyCheckStatus == "waiting" then
		self.readyCheckIcon:SetTexture(READYCHECK_STATUS.notready)
	end
	self.readyCheckHideTime = GetTime() + 6
end

local function UnitFrame_DelayHideReadyCheck(self)
	local hideTime = self.readyCheckHideTime
	if hideTime and GetTime() > hideTime then
		self.readyCheckHideTime = nil
		self.readyCheckIcon:Hide()
	end
end

local function UnitFrame_UpdateRaidIcon(self)
	local unit = self.displayedUnit
	if not unit then return end
	local icon = self.raidIcon

	local index
	if addon.db.showRaidIcon then
		index = GetRaidTargetIndex(unit)
	end

	if index then
		SetRaidTargetIconTexture(icon, index)
		icon:Show()
	else
		icon:Hide()
	end

	if self.raidIconStatus ~= index then
		self.raidIconStatus = index
		BroadcastUnitNotify(self, "OnRaidIconChange", index)
	end
end

local function UnitFrame_UpdateResurrect(self)
	local unit = self.unit
	if not unit then return end
	if UnitIsDeadOrGhost(unit) and UnitHasIncomingResurrection(unit) then
		self.resIcon:Show()
		self.flagIcon:SetAlpha(0)
	else
		self.resIcon:Hide()
		self.flagIcon:SetAlpha(1)
	end
end

local function UnitFrame_UpdatePrivilege(self)
	local privFrame = self.privFrame
	if not addon.db.showPrivIcons then
		privFrame:Hide()
		return
	end

	local raidIndex, partyIndex = self.raidIndex, self.partyIndex
	local rank, loot, _

	if raidIndex then
		_, rank, _, _, _, _, _, _, _, _, loot = GetRaidRosterInfo(raidIndex)
	elseif partyIndex then
		if UnitIsGroupLeader(self.unit or "") then
			rank = 2
		end

		local lootMethod, lootMaster = GetLootMethod()
		if lootMethod == "master" and partyIndex == lootMaster then
			loot = 1
		end
	end

	local leaderIcon, lootIcon = self.leaderIcon, self.lootIcon
	local iconCount = 0

	if rank == 2 then
		iconCount = iconCount + 1
		leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
		leaderIcon:Show()
	elseif rank == 1 then
		iconCount = iconCount + 1
		leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon")
		leaderIcon:Show()
	else
		rank = nil
		leaderIcon:Hide()
	end

	if loot then
		iconCount = iconCount + 1
		loot = 1
		lootIcon:Show()
	else
		loot = nil
		lootIcon:Hide()
	end

	if iconCount > 0 then
		privFrame:SetWidth(iconCount * privFrame:GetHeight())
	end

	privFrame:Show()

	if self.privilegeLeader ~= rank or self.privilegeLoot ~= loot then
		self.privilegeLeader, self.privilegeLoot = rank, loot
		BroadcastUnitNotify(self, "OnPrivilegeChange", rank, loot)
	end
end

local GHOST_AURA, _, GHOST_TEXTURE = GetSpellInfo(8326)
local DEATH_TEXTURE = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull"
local SPIRIT_OF_REDEMPTION = GetSpellInfo(27827)
local SPIRIT_TEXTURE = "Interface\\Icons\\Spell_Holy_GuardianSpirit"
local CAUTERIZE_AURA, _, CAUTERIZE_TEXTURE = GetSpellInfo(87023) -- mage
local PURGATORY_AURA, _, PURGATORY_TEXTURE = GetSpellInfo(116888) -- death knight
local CHEATING_DEATH_AURA, _, CHEATING_DEATH_TEXTURE = GetSpellInfo(45182) -- rogue

local function UnitFrame_UpdateFlags(self)
	local unit = self.unit
	if not unit then return end

	local texture, flag, text

	if not UnitIsConnected(unit) then
		flag = "offline"
		text = PLAYER_OFFLINE
	elseif UnitIsDead(unit) then
		flag = "dead"
		texture = DEATH_TEXTURE
		text = DEAD
	elseif UnitDebuff(unit, GHOST_AURA) then
		flag = "ghost"
		texture = GHOST_TEXTURE
		text = DEAD
	elseif self.unitClass == "PRIEST" and UnitDebuff(unit, SPIRIT_OF_REDEMPTION) then
		flag = "spirit"
		texture = SPIRIT_TEXTURE
		text = DEAD
	elseif self.unitClass == "MAGE" and select(10, UnitDebuff(unit, CAUTERIZE_AURA)) == 87023 then
		flag = "dying"
		texture = CAUTERIZE_TEXTURE
		text = CAUTERIZE_AURA
	elseif self.unitClass == "DEATHKNIGHT" and UnitDebuff(unit, PURGATORY_AURA) then
		flag = "dying"
		texture = PURGATORY_TEXTURE
		text = PURGATORY_AURA
	elseif self.unitClass == "ROGUE" and UnitDebuff(unit, CHEATING_DEATH_AURA) then
		flag = "dying"
		texture = CHEATING_DEATH_TEXTURE
		text = CHEATING_DEATH_AURA
	end

	self.flagIcon:SetTexture(texture)
	self.statusText:SetText(text)
	if text then
		self.healthText:Hide()
	else
		self.healthText:Show()
	end

	UnitFrame_UpdateResurrect(self)

	if flag ~= self.unitFlag then
		self.unitFlag = flag
		BroadcastUnitNotify(self, "OnUnitFlagChange", flag)
	end
end

local function UnitFrame_UpdateInRange(self)
	local unit = self.displayedUnit
	if not unit then return end
	local inRange, checked = UnitInRange(unit)
	if not checked then
		inRange = UnitIsVisible(unit)
	end

	inRange = inRange and 1 or nil
	self.artFrame:SetAlpha(inRange and 1 or outrangeOpacity)
	if inRange ~= self.inRange then
		self.inRange = inRange
		BroadcastUnitNotify(self, "OnRangeChange", inRange)
	end
end

local function UnitFrame_UpdateFont(self)
	local font = addon:GetMedia("font")
	self.nameText:SetFont(font, addon.db.nameHeight, addon.db.nameFontOutline and "OUTLINE" or nil)
	self.statusText:SetFont(font, addon.db.nameHeight * 0.84)
	UnitFrame_UpdateNameSize(self)
end

local function UnitFrame_UpdateStatusBarTexture(self)
	local texture = addon:GetMedia("statusbar")
	self.healthBar:SetStatusBarTexture(texture)
	self.healthBarBackground:SetTexture(texture)
	self.powerBar:SetStatusBarTexture(texture)
	self.powerBarBackground:SetTexture(texture)
	self.absorbsBar:SetStatusBarTexture(texture)
	self.incomingHeal:SetTexture(texture)
	self.shieldBar:SetTexture(texture)
end

local function UnitFrame_UpdateBkgndColor(self)
	self.background:SetVertexColor(bkgndColor.r, bkgndColor.g, bkgndColor.b, 1)
end

local function UnitFrame_UpdateAll(self)
	if not self:IsVisible() then
		return
	end

	self.inRange = 0
	UnitFrame_UpdateVehicleStatus(self)
	UnitFrame_UpdateResurrect(self)
	UnitFrame_UpdateFlags(self)
	UnitFrame_UpdateHealthText(self)
	UnitFrame_UpdateAuras(self)
	UnitFrame_UpdateRole(self)
	UnitFrame_UpdateHealthColor(self)
	UnitFrame_UpdateHealthMax(self)
	UnitFrame_UpdateHealth(self)
	UnitFrame_UpdateHealthPrediction(self)
	UnitFrame_UpdateShieldAbsorbs(self)
	UnitFrame_UpdateHealthAbsorbs(self)
	UnitFrame_UpdatePowerType(self)
	UnitFrame_UpdatePowerMax(self)
	UnitFrame_UpdatePower(self)
	UnitFrame_UpdateName(self)
	UnitFrame_UpdateTarget(self)
	UnitFrame_UpdateThreat(self)
	UnitFrame_UpdateReadyCheck(self)
	UnitFrame_UpdateInRange(self)
	UnitFrame_UpdateRaidIcon(self)
	UnitFrame_UpdatePrivilege(self)
end

local function UnitFrame_RegisterEvents(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	--self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_MAXHEALTH")
	self:RegisterEvent("UNIT_POWER_UPDATE")
	self:RegisterEvent("UNIT_MAXPOWER")
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	self:RegisterEvent("UNIT_POWER_BAR_SHOW")
	self:RegisterEvent("UNIT_POWER_BAR_HIDE")
	self:RegisterEvent("UNIT_NAME_UPDATE")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
	self:RegisterEvent("UNIT_CONNECTION")
	self:RegisterEvent("UNIT_HEAL_PREDICTION")
	self:RegisterEvent("PLAYER_ROLES_ASSIGNED")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE")
	self:RegisterEvent("UNIT_EXITED_VEHICLE")
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("READY_CHECK_FINISHED")
	self:RegisterEvent("READY_CHECK_CONFIRM")
	self:RegisterEvent("PARTY_MEMBER_DISABLE")
	self:RegisterEvent("PARTY_MEMBER_ENABLE")
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	self:RegisterEvent("INCOMING_RESURRECT_CHANGED")
	self:RegisterEvent("RAID_TARGET_UPDATE")
	self:RegisterEvent("UNIT_FLAGS")
	self:RegisterEvent("UNIT_OTHER_PARTY_CHANGED")
	self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
	self:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
	UnitFrame_UpdateAll(self)
end

local function UnitFrame_UnregisterEvents(self)
	self:UnregisterAllEvents()
end

local function UnitFrame_OnShow(self)
	self.needUpdate = 1
	UnitFrame_RegisterEvents(self)
	addon:UpdateContainerSize()
end

local function UnitFrame_OnHide(self)
	UnitFrame_UnregisterEvents(self)
	addon:UpdateContainerSize()
end

local function UnitFrame_OnEnter(self)
	local unit = self.displayedUnit
	if not unit then return end
	self.needUpdate = 1
	self.highlight:Show()

	if not (addon.db.showtooltip == 0 or (addon.db.showtooltip == 1 and InCombatLockdown())) then
		if addon.db.tooltipPosition == 0 then
			GameTooltip_SetDefaultAnchor(GameTooltip, self)
		else
			local right = self:GetLeft() < 300
			local bottom = GetScreenHeight() - self:GetTop() < 360

			local pointX = right and "LEFT" or "RIGHT"
			local pointY = bottom and "TOP" or "BOTTOM"
			local relPointX = right and "RIGHT" or "LEFT"
			local relPointY = bottom and "BOTTOM" or "TOP"

			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(pointY..pointX, self, relPointY..relPointX, right and 4 or -4, bottom and -4 or 4)
		end
		GameTooltip:SetUnit(unit)
	end
end

local function UnitFrame_OnLeave(self)
	GameTooltip:Hide()
	self.highlight:Hide()
end

local function UnitFrame_OnTick(self)
	local e = (self.__tickCount or 0) + 1
	if e >= 5 then
		e = 0
		local guid = UnitGUID(self.displayedUnit or "")
		if guid ~= self.__origGuid then
			self.__origGuid = guid
			self.needUpdate = 1
		end
	end
	self.__tickCount = e

	UnitFrame_UpdateInRange(self)
	UnitFrame_DelayHideReadyCheck(self)

	if self.needUpdate then
		self.needUpdate = nil
		UnitFrame_UpdateAll(self)
	elseif self.flagChanged then
		self.flagChanged = nil
		UnitFrame_UpdateFlags(self)
	end
end

local function UnitFrame_OnUpdate(self, elapsed)
	local e = (self.__updateElapsed or 0) + elapsed
	if e > 0.2 then
		UnitFrame_OnTick(self)
		e = 0
	end
	self.__updateElapsed = e
end

local function UnitFrame_OnAttributeChanged(self, name, value)
	if name == "unit" then
		self.unit, self.displayedUnit, self.raidIndex, self.partyIndex = nil
		if type(value) == "string" then
			self.unit = value
			self.displayedUnit = value

			if value == "player" then
				self.partyIndex = 0
			else
				local _, _, index = strfind(value, "^raid(%d+)$")
				if index then
					self.raidIndex = tonumber(index)
				else
					_, _, index = strfind(value, "^party(%d+)$")
					if index then
						self.partyIndex = tonumber(index)
					end
				end
			end
		end
	end
end

local function UnitFrame_OnEvent(self, event, unit)
	if event == "PLAYER_ENTERING_WORLD" or event == "PARTY_MEMBERS_CHANGED" or event == "GROUP_ROSTER_UPDATE" then
		self.needUpdate = 1
	elseif event == "PLAYER_TARGET_CHANGED" then
		UnitFrame_UpdateTarget(self)
	elseif event == "PLAYER_ROLES_ASSIGNED" then
		UnitFrame_UpdateRole(self)
	elseif event == "RAID_TARGET_UPDATE" then
		UnitFrame_UpdateRaidIcon(self)
	elseif event == "READY_CHECK" then
		UnitFrame_UpdateReadyCheck(self)
	elseif event == "READY_CHECK_FINISHED" then
		UnitFrame_FinishReadyCheck(self)
	elseif event == "PARTY_MEMBER_DISABLE" or event == "PARTY_MEMBER_ENABLE" then
		UnitFrame_UpdatePowerMax(self)
		UnitFrame_UpdatePower(self)
		UnitFrame_UpdatePowerType(self)
	elseif unit and (self.displayedUnit == unit or self.unit == unit) then
		if event == "UNIT_NAME_UPDATE" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_CONNECTION" or event == "UNIT_OTHER_PARTY_CHANGED" then
			self.needUpdate = 1
		elseif event == "UNIT_MAXHEALTH" then
			UnitFrame_UpdateHealthMax(self)
			UnitFrame_UpdateHealth(self)
			UnitFrame_UpdateHealthPrediction(self)
			UnitFrame_UpdateShieldAbsorbs(self)
			UnitFrame_UpdateHealthAbsorbs(self)
			UnitFrame_UpdateHealthText(self)
		elseif event == "UNIT_HEALTH" or event == "UNIT_HEALTH_FREQUENT" then
			UnitFrame_UpdateHealth(self)
			UnitFrame_UpdateHealthPrediction(self)
			UnitFrame_UpdateShieldAbsorbs(self)
			UnitFrame_UpdateHealthText(self)
		elseif event == "UNIT_HEAL_PREDICTION" then
			UnitFrame_UpdateHealthPrediction(self)
		elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" then
			UnitFrame_UpdateShieldAbsorbs(self)
		elseif event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" then
			UnitFrame_UpdateHealthAbsorbs(self)
		elseif event == "UNIT_MAXPOWER" then
			UnitFrame_UpdatePowerMax(self)
			UnitFrame_UpdatePower(self)
		elseif event == "UNIT_POWER_UPDATE" then
			UnitFrame_UpdatePower(self)
		elseif event == "UNIT_DISPLAYPOWER" or event == "UNIT_POWER_BAR_SHOW" or event == "UNIT_POWER_BAR_HIDE" then
			UnitFrame_UpdatePowerMax(self)
			UnitFrame_UpdatePower(self)
			UnitFrame_UpdatePowerType(self)
		elseif event == "UNIT_AURA" or event == "UNIT_FLAGS" then
			UnitFrame_UpdateAuras(self)
			self.flagChanged = 1
		elseif event == "UNIT_THREAT_SITUATION_UPDATE" then
			UnitFrame_UpdateThreat(self)
		elseif event == "READY_CHECK_CONFIRM" then
			UnitFrame_UpdateReadyCheck(self)
		elseif event == "INCOMING_RESURRECT_CHANGED" then
			UnitFrame_UpdateResurrect(self)
		end
	end
end

local function CreateAuraFrame(key, name, parent, list)
	local frame = CreateFrame("Button", name, parent, "CompactAuraTemplate")
	frame:EnableMouse(false)
	frame:Hide()
	frame:SetSize(11, 11)
	frame.key = key
	if key == "debuff" then
		local border = frame:CreateTexture(name.."Border", "OVERLAY")
		frame.border = border
		border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
		border:SetAllPoints(frame)
	elseif key == "dispel" then
		frame.icon:SetTexCoord(0.125, 0.875, 0.125, 0.875)
	end
	tinsert(list, frame)
	return frame
end

local function UnitFrame_GetUnitInfo(self)
	return self.displayedUnit, self.unit, self.inVehicle, self.unitClass
end

local function UnitFrame_GetUnitFlag(self)
	return self.unitFlag
end

local function UnitFrame_IsInRange(self)
	return self.inRange
end

local function UnitFrame_GetRoleIconStatus(self)
	return self.roleIconStatus
end

local function UnitFrame_GetRaidIconStatus(self)
	return self.raidIconStatus
end

local function UnitFrame_GetPrivilege(self)
	return self.privilegeLeader, self.privilegeLoot
end

local optionTable = {

	width = function(frame, value)
		frame:SetWidth(value)
	end,

	height = function(frame, value)
		frame:SetHeight(value)
	end,

	outrangeAlpha = function(frame, value)
		outrangeOpacity = value / 100
	end,

	powerBarHeight = function(frame, value)
		local healthBar = frame.healthBar
		healthBar:ClearAllPoints()
		healthBar:SetPoint("TOPLEFT", 1, -1)
		healthBar:SetPoint("BOTTOMRIGHT", -1, value + 2)
	end,

	nameWidthLimit = function(frame, value)
		UnitFrame_UpdateNameSize(frame)
	end,

	nameHeight = function(frame, value)
		UnitFrame_UpdateFont(frame)
	end,

	showbarbkgnd = function(frame, value)
		if value then
			frame.healthBarBackground:Show()
			frame.powerBarBackground:Show()
		else
			frame.healthBarBackground:Hide()
			frame.powerBarBackground:Hide()
		end
	end,

	healthtextmode = function(frame, value)
		UnitFrame_UpdateHealthText(frame)
	end,

	forceHealthColor = function(frame, value)
		UnitFrame_UpdateHealthColor(frame)
	end,

	healthColor = function(frame, r, g, b)
		healthBarColor.r, healthBarColor.g, healthBarColor.b = r, g, b
		UnitFrame_UpdateHealthColor(frame)
	end,

	forcePowerColor = function(frame, value)
		UnitFrame_UpdatePowerType(frame)
	end,

	powerColor = function(frame, r, g, b)
		powerBarColor.r, powerBarColor.g, powerBarColor.b = r, g, b
		UnitFrame_UpdatePowerType(frame)
	end,

	forceNameColor = function(frame, value)
		UnitFrame_UpdateNameColor(frame)
	end,

	nameColor = function(frame, r, g, b)
		nameTextColor.r, nameTextColor.g, nameTextColor.b = r, g, b
		UnitFrame_UpdateNameColor(frame)
	end,

	nameFontOutline = function(frame, value)
		frame.nameText:SetFont(addon:GetMedia("font"), addon.db.nameHeight, value and "OUTLINE" or nil)
	end,

	nameXOffset = function(frame, value)
		local name = frame.nameText
		name:ClearAllPoints()
		name:SetPoint("CENTER", frame.healthBar, "CENTER", addon.db.nameXOffset, addon.db.nameYOffset)
	end,

	invertColor = function(frame, value)
		UnitFrame_UpdateHealthColor(frame)
		UnitFrame_UpdatePowerType(frame)
	end,

	showBuffs = function(frame, value)
		if value then
			frame.buffParent:Show()
			UnitFrame_UpdateBuffs(frame)
		else
			frame.buffParent:Hide()
		end
	end,

	showDebuffs = function(frame, value)
		if value then
			frame.debuffParent:Show()
			UnitFrame_UpdateDebuffs(frame)
		else
			frame.debuffParent:Hide()
		end
	end,

	onlyDispellable = function(frame, value)
		UnitFrame_UpdateDebuffs(frame)
	end,

	showDispels = function(frame, value)
		if value then
			frame.dispelParent:Show()
			UnitFrame_UpdateDispels(frame)
		else
			frame.dispelParent:Hide()
		end
	end,

	clickDownMode = function(frame, value)
		frame:RegisterForClicks(value and "AnyDown" or "AnyUp")
	end,

	unitBkColor = function(frame, r, g, b)
		bkgndColor.r, bkgndColor.g, bkgndColor.b = r, g, b
		UnitFrame_UpdateBkgndColor(frame)
	end,

	showRoleIcon = function(frame, value)
		UnitFrame_UpdateRole(frame)
	end,

	showRaidIcon = function(frame, value)
		UnitFrame_UpdateRaidIcon(frame)
	end,

	showPrivIcons = function(frame, value)
		UnitFrame_UpdatePrivilege(frame)
	end,
}

optionTable.nameYOffset = optionTable.nameXOffset

local function OptionProc(func, ...)
	local frame
	for _, frame in ipairs(unitFrames) do
		func(frame, ...)
	end
end

do
	local option, func
	for option, func in pairs(optionTable) do
		addon:RegisterOptionCallback(option, OptionProc, func)
	end
end

-- Options applied to dynamic buttons
local DYNAMIC_OPTIONS = { "powerBarHeight", "nameHeight", "showbarbkgnd", "nameXOffset", "nameYOffset", "showBuffs", "showDebuffs", "showDispels" }

local function CheckAndApplyDynamicOptions(frame)
	local option
	for _, option in ipairs(DYNAMIC_OPTIONS) do
		local func = optionTable[option]
		local value = addon.db[option]
		if func and value then
			func(frame, value)
		end
	end
end

function addon._UnitButton_OnLoad(frame)
	frame:RegisterForClicks(addon.db and addon.db.clickDownMode and "AnyDown" or "AnyUp")
	local name = frame:GetName()

	-- Art frame
	local artFrame = CreateFrame("Frame", name.."ArtFrame", frame)
	frame.artFrame = artFrame
	artFrame:SetAllPoints(frame)

	-- Background (black)
	local background = artFrame:CreateTexture(name.."Background", "BACKGROUND")
	frame.background = background
	background:SetAllPoints(artFrame)
	background:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
	background:SetVertexColor(bkgndColor.r, bkgndColor.g, bkgndColor.b, 1)

	-- Health bar
	local healthBar = CreateFrame("StatusBar", name.."HealthBar", artFrame)
	frame.healthBar = healthBar
	healthBar:SetPoint("TOPLEFT", 1, -1)
	healthBar:SetPoint("BOTTOMRIGHT", -1, 2)
	healthBar:SetStatusBarTexture(addon:GetMedia("statusbar"))
	background = artFrame:CreateTexture(name.."HealthBarBackground", "BORDER")
	frame.healthBarBackground = background
	background:SetTexture(addon:GetMedia("statusbar"))
	background:SetAllPoints(healthBar)

	-- Power bar
	local powerBar = CreateFrame("StatusBar", name.."PowerBar", artFrame)
	frame.powerBar = powerBar
	powerBar:SetPoint("TOPLEFT", healthBar, "BOTTOMLEFT", 0, -1)
	powerBar:SetPoint("BOTTOMRIGHT", -1, 1)
	powerBar:SetStatusBarTexture(addon:GetMedia("statusbar"))
	background = artFrame:CreateTexture(name.."PowerBarBackground", "BORDER")
	frame.powerBarBackground = background
	background:SetTexture(addon:GetMedia("statusbar"))
	background:SetAllPoints(powerBar)

	-- Absorbs bar
	local absorbsBar = CreateFrame("StatusBar", name.."AbsorbsBar", healthBar)
	frame.absorbsBar = absorbsBar
	absorbsBar:SetPoint("BOTTOMLEFT")
	absorbsBar:SetPoint("BOTTOMRIGHT")
	absorbsBar:SetHeight(4)
	absorbsBar:SetStatusBarTexture(addon:GetMedia("statusbar"))
	absorbsBar:SetStatusBarColor(1, 0, 0)

	-- Shield bar
	local shieldBar = healthBar:CreateTexture(name.."ShieldBar", "ARTWORK")
	frame.shieldBar = shieldBar
	shieldBar:SetPoint("TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
	shieldBar:SetPoint("BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
	shieldBar:SetTexture(addon:GetMedia("statusbar"))
	shieldBar:SetAlpha(0.5)
	shieldBar:Hide()

	-- Incoming healing bar
	local incomingHeal = healthBar:CreateTexture(name.."IncomingHealBar", "ARTWORK")
	frame.incomingHeal = incomingHeal
	incomingHeal:SetPoint("TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
	incomingHeal:SetPoint("BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
	incomingHeal:SetTexture(addon:GetMedia("statusbar"))
	incomingHeal:Hide()

	-- Layer frame
	local layerFrame = CreateFrame("Frame", name.."LayerFrame", artFrame)
	frame.layerFrame = layerFrame
	layerFrame:SetAllPoints(artFrame)
	layerFrame:SetFrameLevel(50)

	-- Over-shield glow
	local overShieldGlow = layerFrame:CreateTexture(name.."overShieldGlow", "ARTWORK")
	frame.overShieldGlow = overShieldGlow
	overShieldGlow:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
	overShieldGlow:SetBlendMode("ADD")
	overShieldGlow:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMRIGHT", -4, 0)
	overShieldGlow:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", -4, 0)
	overShieldGlow:SetWidth(8)
	overShieldGlow:Hide()

	-- Highlight texture
	local highlight = layerFrame:CreateTexture(name.."Highlight", "BACKGROUND")
	frame.highlight = highlight
	highlight:SetAllPoints(frame)
	highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlight:SetBlendMode("ADD")
	highlight:SetVertexColor(1, 1, 1, 0.4)
	highlight:Hide()

	-- Name text
	local nameText = layerFrame:CreateFontString(name.."NameText", "BORDER", "GameFontHighlightSmall")
	frame.nameText = nameText
	nameText:SetPoint("CENTER", healthBar, "CENTER")
	nameText:SetFont(addon:GetMedia("font"), 12)

	-- Status text
	local statusText = layerFrame:CreateFontString(name.."StatusText", "OVERLAY", "GameFontDisableSmall")
	frame.statusText = statusText
	statusText:SetPoint("TOP", nameText, "BOTTOM", 0, 1)
	statusText:SetFont(addon:GetMedia("font"), 10)

	local healthText = layerFrame:CreateFontString(name.."StatusText", "OVERLAY", "GameFontDisableSmall")
	frame.healthText = healthText
	healthText:SetPoint("TOP", nameText, "BOTTOM", 0, 1)
	healthText:SetFont(addon:GetMedia("font"), 10)

	-- Role icon
	local roleIcon = layerFrame:CreateTexture(name.."RoleIcon", "ARTWORK")
	frame.roleIcon = roleIcon
	roleIcon:SetPoint("TOPLEFT")
	roleIcon:SetSize(12, 12)

	-- Flag icon (dead/ghost/spirit)
	local flagIcon = layerFrame:CreateTexture(name.."FlagIcon", "ARTWORK")
	frame.flagIcon = flagIcon
	flagIcon:SetSize(18, 18)
	flagIcon:SetPoint("CENTER")
	flagIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	-- Resurrect icon
	local resIcon = layerFrame:CreateTexture(name.."ResIcon", "ARTWORK")
	frame.resIcon = resIcon
	resIcon:SetSize(18, 18)
	resIcon:SetPoint("CENTER")
	resIcon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Rez")
	resIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	resIcon:Hide()

	-- Raid icon
	local raidIcon = layerFrame:CreateTexture(name.."RaidIcon", "OVERLAY")
	frame.raidIcon = raidIcon
	raidIcon:SetSize(14, 14)
	raidIcon:SetPoint("TOP", 0, 3)
	raidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	raidIcon:Hide()

	-- Ready check icon
	local readyCheckIcon = layerFrame:CreateTexture(name.."ReadyCheckIcon", "OVERLAY")
	frame.readyCheckIcon = readyCheckIcon
	readyCheckIcon:SetSize(16, 16)
	readyCheckIcon:SetPoint("CENTER", healthBar, "CENTER")
	readyCheckIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	readyCheckIcon:Hide()

	-- Container of privilege icons
	local privFrame = CreateFrame("Frame", name.."PrivilegeFrame", layerFrame)
	frame.privFrame = privFrame
	privFrame:SetPoint("BOTTOM", healthBar, "BOTTOM", 0, -1)
	privFrame:SetSize(11, 11)

	local leaderIcon = privFrame:CreateTexture(name.."LeaderIcon", "OVERLAY")
	frame.leaderIcon = leaderIcon
	leaderIcon:SetPoint("LEFT")
	leaderIcon:SetSize(11, 11)
	leaderIcon:Hide()

	local lootIcon = privFrame:CreateTexture(name.."LootIcon", "OVERLAY")
	frame.lootIcon = lootIcon
	lootIcon:SetPoint("RIGHT")
	lootIcon:SetSize(11, 11)
	lootIcon:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter")
	lootIcon:Hide()

	-- Aggro highlight
	local aggroHighlight = layerFrame:CreateTexture(name.."AggroHighlight", "BACKGROUND")
	frame.aggroHighlight = aggroHighlight
	aggroHighlight:SetAllPoints(frame)
	aggroHighlight:SetTexture("Interface\\RaidFrame\\Raid-FrameHighlights")
	aggroHighlight:SetTexCoord(0.00781250, 0.55468750, 0.00781250, 0.27343750)
	aggroHighlight:Hide()

	-- Selection highlight
	local selectionHighlight = layerFrame:CreateTexture(name.."SelectionHighlight", "BORDER")
	frame.selectionHighlight = selectionHighlight
	selectionHighlight:SetAllPoints(frame)
	selectionHighlight:SetTexture("Interface\\RaidFrame\\Raid-FrameHighlights")
	selectionHighlight:SetTexCoord(0.00781250, 0.55468750, 0.28906250, 0.55468750)
	selectionHighlight:Hide()

	-- Aura frames
	local buffParent = CreateFrame("Frame", name.."BuffParent", layerFrame)
	local debuffParent = CreateFrame("Frame", name.."DeBuffParent", layerFrame)
	local dispelParent = CreateFrame("Frame", name.."DispelParent", layerFrame)
	frame.buffParent = buffParent
	frame.debuffParent = debuffParent
	frame.dispelParent = dispelParent
	frame.buffFrames = {}
	frame.debuffFrames = {}
	frame.dispelFrames = {}
	frame.dispelable = {}
	local i
	for i = 1, 3 do
		local buff = CreateAuraFrame("buff", name.."Buff"..i, buffParent, frame.buffFrames)
		if i == 1 then
			buff:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", -2, 1)
		else
			buff:SetPoint("RIGHT", frame.buffFrames[i - 1], "LEFT")
		end

		local debuff = CreateAuraFrame("debuff", name.."Debuff"..i, debuffParent, frame.debuffFrames)
		if i == 1 then
			debuff:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT", 2, 1)
		else
			debuff:SetPoint("LEFT", frame.debuffFrames[i - 1], "RIGHT")
		end

		local dispel = CreateAuraFrame("dispel", name.."Dispel"..i, dispelParent, frame.dispelFrames)
		if i == 1 then
			dispel:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT", -2, -1)
		else
			dispel:SetPoint("RIGHT", frame.dispelFrames[i - 1], "LEFT")
		end
	end

	-- Visual parent frame
	local visualParent = CreateFrame("Frame", name.."VisualParent", layerFrame)
	frame.visualParent = visualParent
	visualParent:SetAllPoints(layerFrame)
	visualParent:SetFrameLevel(100)

	-- Basic scripts
	frame:SetScript("OnAttributeChanged", UnitFrame_OnAttributeChanged)
	frame:SetScript("OnShow", UnitFrame_OnShow)
	frame:SetScript("OnHide", UnitFrame_OnHide)
	frame:SetScript("OnUpdate", UnitFrame_OnUpdate)
	frame:SetScript("OnEvent", UnitFrame_OnEvent)

	-- OnEnter/OnLeave already used by SecureHandlerEnterLeaveTemplate so we take HookScript instead
	frame:HookScript("OnEnter", UnitFrame_OnEnter)
	frame:HookScript("OnLeave", UnitFrame_OnLeave)

	frame.UpdateBuffs = UnitFrame_UpdateBuffs
	frame.UpdateDebuffs = UnitFrame_UpdateDebuffs
	frame.UpdateDispels = UnitFrame_UpdateDispels
	frame.UpdateRole = UnitFrame_UpdateRole
	frame.UpdateHealthPrediction = UnitFrame_UpdateHealthPrediction
	frame.UpdateShieldAbsorbs = UnitFrame_UpdateShieldAbsorbs
	frame.UpdateHealthAbsorbs = UnitFrame_UpdateHealthAbsorbs
	frame.UpdateVehicleStatus = UnitFrame_UpdateVehicleStatus
	frame.UpdateHealthMax = UnitFrame_UpdateHealthMax
	frame.UpdateHealth = UnitFrame_UpdateHealth
	frame.UpdateHealthColor = UnitFrame_UpdateHealthColor
	frame.UpdatePowerType = UnitFrame_UpdatePowerType
	frame.UpdatePowerMax = UnitFrame_UpdatePowerMax
	frame.UpdatePower = UnitFrame_UpdatePower
	frame.UpdateNameColor = UnitFrame_UpdateNameColor
	frame.UpdateName = UnitFrame_UpdateName
	frame.UpdateHealthText = UnitFrame_UpdateHealthText
	frame.UpdateTarget = UnitFrame_UpdateTarget
	frame.UpdateThreat = UnitFrame_UpdateThreat
	frame.UpdateReadyCheck = UnitFrame_UpdateReadyCheck
	frame.UpdateRaidIcon = UnitFrame_UpdateRaidIcon
	frame.UpdateResurrect = UnitFrame_UpdateResurrect
	frame.UpdateFlags = UnitFrame_UpdateFlags
	frame.UpdateNameSize = UnitFrame_UpdateNameSize
	frame.UpdateAuras = UnitFrame_UpdateAuras
	frame.UpdateAll = UnitFrame_UpdateAll
	frame.GetUnitInfo = UnitFrame_GetUnitInfo
	frame.GetUnitFlag = UnitFrame_GetUnitFlag
	frame.IsInRange = UnitFrame_IsInRange
	frame.GetRoleIconStatus = UnitFrame_GetRoleIconStatus
	frame.GetRaidIconStatus = UnitFrame_GetRaidIconStatus
	frame.GetPrivilege = UnitFrame_GetPrivilege

	tinsert(unitFrames, frame)
	CheckAndApplyDynamicOptions(frame)
	addon:BroadcastEvent("UnitButtonCreated", frame)
end

-----------------------------------------------------
-- Unit frame artwork
-----------------------------------------------------

addon:RegisterEventCallback("OnMediaChange", function(category, media)
	if category == "statusbar" or category == "font" then
		local frame
		for _, frame in ipairs(unitFrames) do
			if category == "statusbar" then
				UnitFrame_UpdateStatusBarTexture(frame)
			else
				UnitFrame_UpdateFont(frame)
			end
		end
	end
end)
