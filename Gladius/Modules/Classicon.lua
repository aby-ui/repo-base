local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Class Icon"))
end
local L = Gladius.L
local LSM

-- Global Functions
local _G = _G
local pairs = pairs
local select = select
local strfind = string.find
local tonumber = tonumber
local tostring = tostring
local unpack = unpack

local CreateFrame = CreateFrame
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitAura = UnitAura
local UnitClass = UnitClass

local CLASS_BUTTONS = CLASS_ICON_TCOORDS

local function GetDefaultAuraList()
	local auraTable = {
		-- Higher Number is More Priority
		-- Priority List by P0rkz
		-- Unpurgable long lasting buffs
		--[GetSpellInfo(108292)]	= 0,	-- Heart of the Wild
		-- Mobility Auras (0)
		[GetSpellInfo(108843)]	= 0,	-- Blazing Speed
		[GetSpellInfo(65081)]	= 0,	-- Body and Soul
		[GetSpellInfo(108212)]	= 0,	-- Burst of Speed
		[GetSpellInfo(68992)]	= 0,	-- Darkflight
		[GetSpellInfo(1850)]	= 0,	-- Dash
		[GetSpellInfo(137452)]	= 0,	-- Displacer Beast
		[GetSpellInfo(114239)]	= 0,	-- Phantasm
		[GetSpellInfo(118922)]	= 0,	-- Posthaste
		[GetSpellInfo(85499)]	= 0,	-- Speed of Light
		[GetSpellInfo(2983)]	= 0,	-- Sprint
		[GetSpellInfo(06898)]	= 0,	-- Stampeding Roar
		[GetSpellInfo(116841)]	= 0, 	-- Tiger's Lust
		-- Movement Reduction Auras (1)
		[GetSpellInfo(5116)]	= 1,	-- Concussive Shot
		[GetSpellInfo(120)]		= 1,	-- Cone of Cold
		[GetSpellInfo(13809)]	= 1,	-- Frost Trap
		-- Purgable Buffs (2)
		--[GetSpellInfo(16188)]	= 2,	-- Ancestral Swiftness
		--[GetSpellInfo(31842)]	= 2,	-- Divine Favor
		--[GetSpellInfo(6346)]	= 2,	-- Fear Ward
		[GetSpellInfo(112965)]	= 2,	-- Fingers of Frost
		[GetSpellInfo(1044)]	= 2,	-- Hand of Freedom
		[GetSpellInfo(1022)]	= 2,	-- Hand of Protection
		--[GetSpellInfo(114039)]	= 2,	-- Hand of Purity
		[GetSpellInfo(6940)]	= 2,	-- Hand of Sacrifice
		[GetSpellInfo(11426)]	= 2,	-- Ice Barrier
		[GetSpellInfo(53271)]	= 2,	-- Master's Call
		--[GetSpellInfo(132158)]	= 2,	-- Nature's Swiftness
		--[GetSpellInfo(12043)]	= 2,	-- Presence of Mind
		[GetSpellInfo(48108)]	= 2,	-- Pyroblast!
		-- Defensive - Damage Redution Auras (3)
		--[GetSpellInfo(108978)]	= 3,	-- Alter Time
		[GetSpellInfo(108271)]	= 3,	-- Astral Shift
		[GetSpellInfo(22812)]	= 3,	-- Barkskin
		[GetSpellInfo(18499)]	= 3,	-- Berserker Rage
		--[GetSpellInfo(111397)]	= 3,	-- Blood Horror
		[GetSpellInfo(74001)]	= 3,	-- Combat Readiness
		[GetSpellInfo(31224)]	= 3,	-- Cloak of Shadows
		[GetSpellInfo(108359)]	= 3,	-- Dark Regeneration
		[GetSpellInfo(118038)]	= 3,	-- Die by the Sword
		[GetSpellInfo(498)]		= 3,	-- Divine Protection
		[GetSpellInfo(5277)]	= 3,	-- Evasion
		[GetSpellInfo(47788)]	= 3,	-- Guardian Spirit
		[GetSpellInfo(48792)]	= 3,	-- Icebound Fortitude
		[GetSpellInfo(66)]		= 3,	-- Invisibility
		[GetSpellInfo(102342)]	= 3,	-- Ironbark
		[GetSpellInfo(12975)]	= 3,	-- Last Stand
		--[GetSpellInfo(49039)]	= 3,	-- Lichborne
		[GetSpellInfo(116849)]	= 3,	-- Life Cocoon
		--[GetSpellInfo(114028)]	= 3,	-- Mass Spell Reflection
		--[GetSpellInfo(30884)]	= 3,	-- Nature's Guardian
		[GetSpellInfo(124974)]	= 3,	-- Nature's Vigil
		--[GetSpellInfo(137562)]	= 3,	-- Nimble Brew
		[GetSpellInfo(33206)]	= 3,	-- Pain Suppression
		[GetSpellInfo(53480)]	= 3,	-- Roar of Sacrifice
		--[GetSpellInfo(30823)]	= 3,	-- Shamanistic Rage
		[GetSpellInfo(871)]		= 3,	-- Shield Wall
		[GetSpellInfo(112833)]	= 3,	-- Spectral Guise
		[GetSpellInfo(23920)]	= 3,	-- Spell Reflection
		[GetSpellInfo(122470)]	= 3,	-- Touch of Karma
		[GetSpellInfo(61336)]	= 3,	-- Survival Instincts
		-- Offensive - Melee Auras (4)
		[GetSpellInfo(13750)]	= 4,	-- Adrenaline Rush
		[GetSpellInfo(152151)]	= 4,	-- Shadow Reflection
		[GetSpellInfo(107574)]	= 4,	-- Avatar
		--[GetSpellInfo(106952)]	= 4,	-- Berserk
		[GetSpellInfo(12292)]	= 4,	-- Bloodbath
		[GetSpellInfo(51271)]	= 4,	-- Pillar of Frost
		[GetSpellInfo(1719)]	= 4,	-- Recklessness
		--[GetSpellInfo(51713)]	= 4,	-- Shadow Dance
		-- Roots (5)
		[GetSpellInfo(91807)]	= 5,	-- Shambling Rush (Ghoul)
		["96294"]				= 5,	-- Chains of Ice (Chilblains)
		[GetSpellInfo(61685)]	= 5,	-- Charge (Various)
		[GetSpellInfo(116706)]	= 5,	-- Disable
		--[GetSpellInfo(87194)]	= 5,	-- Mind Blast (Glyphed)
		[GetSpellInfo(114404)]	= 5,	-- Void Tendrils
		[GetSpellInfo(64695)]	= 5,	-- Earthgrab
		[GetSpellInfo(64803)]	= 5,	-- Entrapment
		--[GetSpellInfo(63685)]	= 5,	-- Freeze (Frozen Power)
		--[GetSpellInfo(111340)]	= 5,	-- Ice Ward
		--[GetSpellInfo(107566)]	= 5,	-- Staggering Shout
		[GetSpellInfo(339)]		= 5,	-- Entangling Roots
		--[GetSpellInfo(113770)]	= 5,	-- Entangling Roots (Force of Nature)
		[GetSpellInfo(33395)]	= 5,	-- Freeze (Water Elemental)
		[GetSpellInfo(122)]		= 5,	-- Frost Nova
		--[GetSpellInfo(102051)]	= 5,	-- Frostjaw
		[GetSpellInfo(102359)]	= 5,	-- Mass Entanglement
		[GetSpellInfo(136634)]	= 5,	-- Narrow Escape
		[GetSpellInfo(105771)]	= 5,	-- Warbringer
		-- Offensive - Ranged / Spell Auras (6)
		[GetSpellInfo(12042)]	= 6,	-- Arcane Power
		[GetSpellInfo(114049)]	= 6,	-- Ascendance
		[GetSpellInfo(31884)]	= 6,	-- Avenging Wrath
		--[GetSpellInfo(113858)]	= 6,	-- Dark Soul: Instability
		--[GetSpellInfo(113861)]	= 6,	-- Dark Soul: Knowledge
		--[GetSpellInfo(113860)]	= 6,	-- Dark Soul: Misery
		[GetSpellInfo(16166)]	= 6,	-- Elemental Mastery
		[GetSpellInfo(12472)]	= 6,	-- Icy Veins
		[GetSpellInfo(33891)]	= 6,	-- Incarnation: Tree of Life
		[GetSpellInfo(102560)]	= 6,	-- Incarnation: Chosen of Elune
		[GetSpellInfo(102543)]	= 6,	-- Incarnation: King of the Jungle
		[GetSpellInfo(102558)]	= 6,	-- Incarnation: Son of Ursoc
		[GetSpellInfo(10060)]	= 6,	-- Power Infusion
		--[GetSpellInfo(3045)]	= 6,	-- Rapid Fire
		--[GetSpellInfo(48505)]	= 6,	-- Starfall
		-- Silence and Spell Immunities Auras (7)
		[GetSpellInfo(31821)]	= 7,	-- Devotion Aura
		--[GetSpellInfo(115723)]	= 7,	-- Glyph of Ice Block
		[GetSpellInfo(8178)]	= 7,	-- Grounding Totem Effect
		[GetSpellInfo(131558)]	= 7,	-- Spiritwalker's Aegis
		[GetSpellInfo(104773)]	= 7,	-- Unending Resolve
		[GetSpellInfo(124488)]	= 7,	-- Zen Focus
		--[GetSpellInfo(159630)]  = 7,    -- Shadow Magic
		-- Silence Auras (8)
		[GetSpellInfo(1330)]	= 8,	-- Garrote (Silence)
		[GetSpellInfo(15487)]	= 8,	-- Silence
		[GetSpellInfo(47476)]	= 8,	-- Strangulate
		[GetSpellInfo(31935)]	= 8,	-- Avenger's Shield
		--[GetSpellInfo(137460)]	= 8,	-- Ring of Peace
		[GetSpellInfo(28730)]	= 8,	-- Arcane Torrent (Mana version)
		[GetSpellInfo(80483)]	= 8,	-- Arcane Torrent (Focus version)
		[GetSpellInfo(25046)]	= 8,	-- Arcane Torrent (Energy version)
		[GetSpellInfo(50613)]	= 8,	-- Arcane Torrent (Runic Power version)
		[GetSpellInfo(69179)]	= 8,	-- Arcane Torrent (Rage version)
		-- Disorients & Stuns Auras (9)
		[GetSpellInfo(108194)]	= 9,	-- Asphyxiate
		[GetSpellInfo(91800)]	= 9,	-- Gnaw (Ghoul)
		[GetSpellInfo(91797)]	= 9,	-- Monstrous Blow (Dark Transformation Ghoul)
		[GetSpellInfo(89766)]	= 9,	-- Axe Toss (Felguard)
		[GetSpellInfo(117526)]	= 9,	-- Binding Shot
		[GetSpellInfo(224729)]	= 9,	-- Bursting Shot
		[GetSpellInfo(213691)]	= 9,	-- Scatter Shot
		[GetSpellInfo(24394)]	= 9,	-- Intimidation
		[GetSpellInfo(105421)]	= 9,	-- Blinding Light
		[GetSpellInfo(7922)]	= 9,	-- Charge Stun
		--[GetSpellInfo(119392)]	= 9,	-- Charging Ox Wave
		[GetSpellInfo(1833)]	= 9,	-- Cheap Shot
		--[GetSpellInfo(118895)]	= 9,	-- Dragon Roar
		[GetSpellInfo(77505)]	= 9,	-- Earthquake
		[GetSpellInfo(120086)]	= 9,	-- Fist of Fury
		--[GetSpellInfo(44572)]	= 9,	-- Deep Freeze
		[GetSpellInfo(99)]		= 9,	-- Disorienting Roar
		[GetSpellInfo(31661)]	= 9,	-- Dragon's Breath
		--[GetSpellInfo(123393)]	= 9,	-- Breath of Fire (Glyphed)
		--[GetSpellInfo(105593)]	= 9,	-- Fist of Justice
		[GetSpellInfo(47481)]	= 9,	-- Gnaw
		[GetSpellInfo(1776)]	= 9,	-- Gouge
		[GetSpellInfo(853)]		= 9,	-- Hammer of Justice
		--[GetSpellInfo(119072)]	= 9,	-- Holy Wrath
		[GetSpellInfo(88625)]	= 9,	-- Holy Word: Chastise
		[GetSpellInfo(19577)]	= 9,	-- Intimidation
		[GetSpellInfo(408)]		= 9,	-- Kidney Shot
		[GetSpellInfo(119381)]	= 9,	-- Leg Sweep
		[GetSpellInfo(22570)]	= 9,	-- Maim
		[GetSpellInfo(5211)]	= 9,	-- Mighty Bash
		--[GetSpellInfo(113801)]	= 9,	-- Bash (Treants)
		[GetSpellInfo(118345)]	= 9,	-- Pulverize (Primal Earth Elemental)
		--[GetSpellInfo(115001)]	= 9,	-- Remorseless Winter
		[GetSpellInfo(30283)]	= 9,	-- Shadowfury
		[GetSpellInfo(22703)]	= 9,	-- Summon Infernal
		[GetSpellInfo(46968)]	= 9,	-- Shockwave
		[GetSpellInfo(118905)]	= 9,	-- Static Charge (Capacitor Totem Stun)
		[GetSpellInfo(132169)]	= 9,	-- Storm Bolt
		[GetSpellInfo(20549)]	= 9,	-- War Stomp
		[GetSpellInfo(16979)]	= 9,	-- Wild Charge
		[GetSpellInfo(117526)]  = 9,    -- Binding Shot
		["163505"]              = 9,    -- Rake
		-- Crowd Controls Auras (10)
		[GetSpellInfo(710)]		= 10,	-- Banish
		[GetSpellInfo(2094)]	= 10,	-- Blind
		--[GetSpellInfo(137143)]	= 10,	-- Blood Horror
		[GetSpellInfo(33786)]	= 10,	-- Cyclone
		[GetSpellInfo(605)]		= 10,	-- Dominate Mind
		[GetSpellInfo(118699)]	= 10,	-- Fear
		[GetSpellInfo(3355)]	= 10,	-- Freezing Trap
		[GetSpellInfo(51514)]	= 10,	-- Hex
		[GetSpellInfo(5484)]	= 10,	-- Howl of Terror
		[GetSpellInfo(5246)]	= 10,	-- Intimidating Shout
		[GetSpellInfo(115268)]	= 10,	-- Mesmerize (Shivarra)
		[GetSpellInfo(6789)]	= 10,	-- Mortal Coil
		[GetSpellInfo(115078)]	= 10,	-- Paralysis
		[GetSpellInfo(118)]		= 10,	-- Polymorph
		[GetSpellInfo(8122)]	= 10,	-- Psychic Scream
		[GetSpellInfo(64044)]	= 10,	-- Psychic Horror
		[GetSpellInfo(20066)]	= 10,	-- Repentance
		[GetSpellInfo(82691)]	= 10,	-- Ring of Frost
		[GetSpellInfo(6770)]	= 10,	-- Sap
		[GetSpellInfo(107079)]	= 10,	-- Quaking Palm
		[GetSpellInfo(6358)]	= 10,	-- Seduction (Succubus)
		[GetSpellInfo(9484)]	= 10,	-- Shackle Undead
		--[GetSpellInfo(10326)]	= 10,	-- Turn Evil
		[GetSpellInfo(19386)]	= 10,	-- Wyvern Sting
		-- Immunity Auras (11)
		[GetSpellInfo(48707)]	= 11,	-- Anti-Magic Shell
		[GetSpellInfo(46924)]	= 11,	-- Bladestorm
		--[GetSpellInfo(110913)]	= 11,	-- Dark Bargain
		[GetSpellInfo(19263)]	= 11,	-- Deterrence
		[GetSpellInfo(47585)]	= 11,	-- Dispersion
		[GetSpellInfo(642)]		= 11,	-- Divine Shield
		[GetSpellInfo(45438)]	= 11,	-- Ice Block
		-- Drink (12)
		[GetSpellInfo(118358)]	= 12,	-- Drink
	}
	return auraTable
end

local ClassIcon = Gladius:NewModule("ClassIcon", false, true, {
	classIconAttachTo = "Frame",
	classIconAnchor = "TOPRIGHT",
	classIconRelativePoint = "TOPLEFT",
	classIconAdjustSize = false,
	classIconSize = 40,
	classIconOffsetX = -1,
	classIconOffsetY = 0,
	classIconFrameLevel = 1,
	classIconGloss = true,
	classIconGlossColor = {r = 1, g = 1, b = 1, a = 0.4},
	classIconImportantAuras = true,
	classIconCrop = false,
	classIconCooldown = false,
	classIconCooldownReverse = false,
	classIconShowSpec = false,
	classIconDetached = false,
	classIconAuras = GetDefaultAuraList(),
})

function ClassIcon:OnEnable()
	self:RegisterEvent("UNIT_AURA")
	self.version = 1
	LSM = Gladius.LSM
	if not self.frame then
		self.frame = { }
	end
	Gladius.db.auraVersion = self.version
end

function ClassIcon:OnDisable()
	self:UnregisterAllEvents()
	for unit in pairs(self.frame) do
		self.frame[unit]:SetAlpha(0)
	end
end

function ClassIcon:GetAttachTo()
	return Gladius.db.classIconAttachTo
end

function ClassIcon:IsDetached()
	return Gladius.db.classIconDetached
end

function ClassIcon:GetFrame(unit)
	return self.frame[unit]
end

function ClassIcon:UNIT_AURA(event, unit)
	if not Gladius:IsValidUnit(unit) then
		return
	end

	-- important auras
	self:UpdateAura(unit)
end

function ClassIcon:UpdateColors(unit)
	self.frame[unit].normalTexture:SetVertexColor(Gladius.db.classIconGlossColor.r, Gladius.db.classIconGlossColor.g, Gladius.db.classIconGlossColor.b, Gladius.db.classIconGloss and Gladius.db.classIconGlossColor.a or 0)
end

function ClassIcon:UpdateAura(unit)
	local unitFrame = self.frame[unit]

	if not unitFrame then
		return
	end

	if not Gladius.db.classIconAuras then
		return
	end

	local aura

	for _, auraType in pairs({'HELPFUL', 'HARMFUL'}) do
		for i = 1, 40 do
			local name, icon, _, _, duration, expires, _, _, _, spellid = UnitAura(unit, i, auraType)

			if not name then
				break
			end
			local auraList = Gladius.db.classIconAuras
			local priority = auraList[name] or auraList[tostring(spellid)]

			if priority and (not aura or aura.priority < priority)  then
				aura = {
					name = name,
					icon = icon,
					duration = duration,
					expires = expires,
					spellid = spellid,
					priority = priority
				}
			end
		end
	end

	if aura and (not unitFrame.aura or (unitFrame.aura.id ~= aura or unitFrame.aura.expires ~= aura.expires)) then
		self:ShowAura(unit, aura)
	elseif not aura then
		self.frame[unit].aura = nil
		self:SetClassIcon(unit)
	end
end

function ClassIcon:ShowAura(unit, aura)
	local unitFrame = self.frame[unit]
	unitFrame.aura = aura

	-- display aura
	unitFrame.texture:SetTexture(aura.icon)
	if Gladius.db.classIconCrop then
		unitFrame.texture:SetTexCoord(0.075, 0.925, 0.075, 0.925)
	else
		unitFrame.texture:SetTexCoord(0, 1, 0, 1)
	end

	local start

	if aura.expires then
		local timeLeft = aura.expires > 0 and aura.expires - GetTime() or 0
		start = GetTime() - (aura.duration - timeLeft)
	end

	Gladius:Call(Gladius.modules.Timer, "SetTimer", unitFrame, aura.duration, start)
end

function ClassIcon:SetClassIcon(unit)
	if not self.frame[unit] then
		return
	end
	Gladius:Call(Gladius.modules.Timer, "HideTimer", self.frame[unit])
	-- get unit class
	local class
	local specIcon
	if not Gladius.test then
		local frame = Gladius:GetUnitFrame(unit)
		class = frame.class
		specIcon = frame.specIcon
	else
		class = Gladius.testing[unit].unitClass
		local _, _, _, icon = GetSpecializationInfoByID(Gladius.testing[unit].unitSpecId)
		specIcon = icon
	end
	if Gladius.db.classIconShowSpec then
		if specIcon then
			self.frame[unit].texture:SetTexture(specIcon)
			local left, right, top, bottom = 0, 1, 0, 1
			-- Crop class icon borders
			if Gladius.db.classIconCrop then
				left = left + (right - left) * 0.075
				right = right - (right - left) * 0.075
				top = top + (bottom - top) * 0.075
				bottom = bottom - (bottom - top) * 0.075
			end
			self.frame[unit].texture:SetTexCoord(left, right, top, bottom)
		end
	else
		if class then
			self.frame[unit].texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			local left, right, top, bottom = unpack(CLASS_BUTTONS[class])
			-- Crop class icon borders
			if Gladius.db.classIconCrop then
				left = left + (right - left) * 0.075
				right = right - (right - left) * 0.075
				top = top + (bottom - top) * 0.075
				bottom = bottom - (bottom - top) * 0.075
			end
			self.frame[unit].texture:SetTexCoord(left, right, top, bottom)
		end
	end
end

function ClassIcon:CreateFrame(unit)
	local button = Gladius.buttons[unit]
	if not button then
		return
	end
	-- create frame
	self.frame[unit] = CreateFrame("CheckButton", "Gladius"..self.name.."Frame"..unit, button, "ActionButtonTemplate")
	self.frame[unit]:EnableMouse(false)
	self.frame[unit]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
	self.frame[unit].texture = _G[self.frame[unit]:GetName().."Icon"]
	self.frame[unit].normalTexture = _G[self.frame[unit]:GetName().."NormalTexture"]
	self.frame[unit].cooldown = _G[self.frame[unit]:GetName().."Cooldown"]

	-- secure
	local secure = CreateFrame("Button", "Gladius"..self.name.."SecureButton"..unit, button, "SecureActionButtonTemplate")
	secure:RegisterForClicks("AnyUp")
	self.frame[unit].secure = secure
end

function ClassIcon:Update(unit)
	-- TODO: check why we need this >_<
	self.frame = self.frame or { }

	-- create frame
	if not self.frame[unit] then
		self:CreateFrame(unit)
	end

	local unitFrame = self.frame[unit]

	-- update frame
	unitFrame:ClearAllPoints()
	local parent = Gladius:GetParent(unit, Gladius.db.classIconAttachTo)
	unitFrame:SetPoint(Gladius.db.classIconAnchor, parent, Gladius.db.classIconRelativePoint, Gladius.db.classIconOffsetX, Gladius.db.classIconOffsetY)
	-- frame level
	unitFrame:SetFrameLevel(Gladius.db.classIconFrameLevel)
	if Gladius.db.classIconAdjustSize then
		local height = false
		-- need to rethink that
		--[[for _, module in pairs(Gladius.modules) do
			if module:GetAttachTo() == self.name then
				height = false
			end
		end]]
		if height then
			unitFrame:SetWidth(Gladius.buttons[unit].height)
			unitFrame:SetHeight(Gladius.buttons[unit].height)
		else
			unitFrame:SetWidth(Gladius.buttons[unit].frameHeight)
			unitFrame:SetHeight(Gladius.buttons[unit].frameHeight)
		end
	else
		unitFrame:SetWidth(Gladius.db.classIconSize)
		unitFrame:SetHeight(Gladius.db.classIconSize)
	end

	-- Secure frame
	if self.IsDetached() then
		unitFrame.secure:SetAllPoints(unitFrame)
		unitFrame.secure:SetHeight(unitFrame:GetHeight())
		unitFrame.secure:SetWidth(unitFrame:GetWidth())
		unitFrame.secure:Show()
	else
		unitFrame.secure:Hide()
	end

	unitFrame.texture:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
	-- set frame mouse-interactable area
	local left, right, top, bottom = Gladius.buttons[unit]:GetHitRectInsets()
	if self:GetAttachTo() == "Frame" and not self:IsDetached() then
		if strfind(Gladius.db.classIconRelativePoint, "LEFT") then
			left = - unitFrame:GetWidth() + Gladius.db.classIconOffsetX
		else
			right = - unitFrame:GetWidth() + - Gladius.db.classIconOffsetX
		end
		-- search for an attached frame
		--[[for _, module in pairs(Gladius.modules) do
			if (module.attachTo and module:GetAttachTo() == self.name and module.frame and module.frame[unit]) then
				local attachedPoint = module.frame[unit]:GetPoint()
				if (strfind(Gladius.db.classIconRelativePoint, "LEFT") and (not attachedPoint or (attachedPoint and strfind(attachedPoint, "RIGHT")))) then
					left = left - module.frame[unit]:GetWidth()
				elseif (strfind(Gladius.db.classIconRelativePoint, "LEFT") and (not attachedPoint or (attachedPoint and strfind(attachedPoint, "LEFT")))) then
					right = right - module.frame[unit]:GetWidth()
				end
			end
		end]]
		-- top / bottom
		if unitFrame:GetHeight() > Gladius.buttons[unit]:GetHeight() then
			bottom = -(unitFrame:GetHeight() - Gladius.buttons[unit]:GetHeight()) + Gladius.db.classIconOffsetY
		end
		Gladius.buttons[unit]:SetHitRectInsets(left, right, 0, 0)
		Gladius.buttons[unit].secure:SetHitRectInsets(left, right, 0, 0)
	end
	-- style action button
	unitFrame.normalTexture:SetHeight(unitFrame:GetHeight() + unitFrame:GetHeight() * 0.4)
	unitFrame.normalTexture:SetWidth(unitFrame:GetWidth() + unitFrame:GetWidth() * 0.4)
	unitFrame.normalTexture:ClearAllPoints()
	unitFrame.normalTexture:SetPoint("CENTER", 0, 0)
	unitFrame:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
	unitFrame.texture:ClearAllPoints()
	unitFrame.texture:SetPoint("TOPLEFT", unitFrame, "TOPLEFT")
	unitFrame.texture:SetPoint("BOTTOMRIGHT", unitFrame, "BOTTOMRIGHT")
	unitFrame.normalTexture:SetVertexColor(Gladius.db.classIconGlossColor.r, Gladius.db.classIconGlossColor.g, Gladius.db.classIconGlossColor.b, Gladius.db.classIconGloss and Gladius.db.classIconGlossColor.a or 0)
	unitFrame.texture:SetTexCoord(left, right, top, bottom)

	-- cooldown
	unitFrame.cooldown.isDisabled = not Gladius.db.classIconCooldown
	unitFrame.cooldown:SetReverse(Gladius.db.classIconCooldownReverse)
	Gladius:Call(Gladius.modules.Timer, "RegisterTimer", unitFrame, Gladius.db.classIconCooldown)

	-- hide
	unitFrame:SetAlpha(0)
	self.frame[unit] = unitFrame
end

function ClassIcon:Show(unit)
	local testing = Gladius.test
	-- show frame
	self.frame[unit]:SetAlpha(1)
	-- set class icon
	self:UpdateAura(unit)
end

function ClassIcon:Reset(unit)
	-- reset frame
	self.frame[unit].aura = nil
	self.frame[unit]:SetScript("OnUpdate", nil)
	-- reset cooldown
	self.frame[unit].cooldown:SetCooldown(0, 0)
	-- reset texture
	self.frame[unit].texture:SetTexture("")
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function ClassIcon:ResetModule()
	Gladius.db.classIconAuras = { }
	Gladius.db.classIconAuras = GetDefaultAuraList()
	local newAura = Gladius.options.args[self.name].args.auraList.args.newAura
	Gladius.options.args[self.name].args.auraList.args = {
		newAura = newAura,
	}
	for aura, priority in pairs(Gladius.db.classIconAuras) do
		if priority then
			local isNum = tonumber(aura) ~= nil
			local name = isNum and GetSpellInfo(aura) or aura
			Gladius.options.args[self.name].args.auraList.args[aura] = self:SetupAura(aura, priority, name)
		end
	end
end

function ClassIcon:Test(unit)
	if not Gladius.db.classIconImportantAuras then
		return
	end
	if unit == "arena1" then
		self:ShowAura(unit, {
			icon = select(3, GetSpellInfo(45438)),
			duration = 10
		})
	elseif unit == "arena2" then
		self:ShowAura(unit, {
			icon = select(3, GetSpellInfo(19263)),
			duration = 5
		})
	end
end

function ClassIcon:GetOptions()
	local options = {
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
						classIconImportantAuras = {
							type = "toggle",
							name = L["Class Icon Important Auras"],
							desc = L["Show important auras instead of the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						classIconCrop = {
							type = "toggle",
							name = L["Class Icon Crop Borders"],
							desc = L["Toggle if the class icon borders should be cropped or not."],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 6,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						classIconCooldown = {
							type = "toggle",
							name = L["Class Icon Cooldown Spiral"],
							desc = L["Display the cooldown spiral for important auras"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 10,
						},
						classIconCooldownReverse = {
							type = "toggle",
							name = L["Class Icon Cooldown Reverse"],
							desc = L["Invert the dark/bright part of the cooldown spiral"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 15,
						},
						classIconShowSpec = {
							type = "toggle",
							name = L["Class Icon Spec Icon"],
							desc = L["Shows the specialization icon instead of the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 16,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 17,
						},
						classIconGloss = {
							type = "toggle",
							name = L["Class Icon Gloss"],
							desc = L["Toggle gloss on the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 20,
						},
						classIconGlossColor = {
							type = "color",
							name = L["Class Icon Gloss Color"],
							desc = L["Color of the class icon gloss"],
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							hasAlpha = true,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 25,
						},
						sep3 = {
							type = "description",
							name = "",
							width = "full",
							order = 27,
						},
						classIconFrameLevel = {
							type = "range",
							name = L["Class Icon Frame Level"],
							desc = L["Frame level of the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							min = 1,
							max = 5,
							step = 1,
							width = "double",
							order = 30,
						},
					},
				},
				size = {
					type = "group",
					name = L["Size"],
					desc = L["Size settings"],
					inline = true,
					order = 2,
					args = {
						classIconAdjustSize = {
							type = "toggle",
							name = L["Class Icon Adjust Size"],
							desc = L["Adjust class icon size to the frame size"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						classIconSize = {
							type = "range",
							name = L["Class Icon Size"],
							desc = L["Size of the class icon"],
							min = 10,
							max = 100,
							step = 1,
							disabled = function()
								return Gladius.dbi.profile.classIconAdjustSize or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
					},
				},
				position = {
					type = "group",
					name = L["Position"],
					desc = L["Position settings"],
					inline = true,
					order = 3,
					args = {
						classIconAttachTo = {
							type = "select",
							name = L["Class Icon Attach To"],
							desc = L["Attach class icon to given frame"],
							values = function()
								return Gladius:GetModules(self.name)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 5,
						},
						classIconDetached = {
							type = "toggle",
							name = L["Detached from frame"],
							desc = L["Detach the cast bar from the frame itself"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 6,
						},
						classIconPosition = {
							type = "select",
							name = L["Class Icon Position"],
							desc = L["Position of the class icon"],
							values={ ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"] },
							get = function()
								return strfind(Gladius.db.classIconAnchor, "RIGHT") and "LEFT" or "RIGHT"
							end,
							set = function(info, value)
								if (value == "LEFT") then
									Gladius.db.classIconAnchor = "TOPRIGHT"
									Gladius.db.classIconRelativePoint = "TOPLEFT"
								else
									Gladius.db.classIconAnchor = "TOPLEFT"
									Gladius.db.classIconRelativePoint = "TOPRIGHT"
								end
								Gladius:UpdateFrame(info[1])
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return Gladius.db.advancedOptions
							end,
							order = 7,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 8,
						},
						classIconAnchor = {
							type = "select",
							name = L["Class Icon Anchor"],
							desc = L["Anchor of the class icon"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 10,
						},
						classIconRelativePoint = {
							type = "select",
							name = L["Class Icon Relative Point"],
							desc = L["Relative point of the class icon"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
						order = 15,
						},
							sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 17,
						},
						classIconOffsetX = {
							type = "range",
							name = L["Class Icon Offset X"],
							desc = L["X offset of the class icon"],
							min = - 100, max = 100, step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 20,
						},
						classIconOffsetY = {
							type = "range",
							name = L["Class Icon Offset Y"],
							desc = L["Y offset of the class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = - 50,
							max = 50,
							step = 1,
							order = 25,
						},
					},
				},
			},
		},
		auraList = {
			type = "group",
			name = L["Auras"],
			childGroups = "tree",
			order = 3,
			args = {
				newAura = {
					type = "group",
					name = L["New Aura"],
					desc = L["New Aura"],
					inline = true,
					order = 1,
					args = {
						name = {
							type = "input",
							name = L["Name"],
							desc = L["Name of the aura"],
							get = function()
								return self.newAuraName or ""
							end,
							set = function(info, value)
								self.newAuraName = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
							end,
							order = 1,
						},
						priority = {
							type = "range",
							name = L["Priority"],
							desc = L["Select what priority the aura should have - higher equals more priority"],
							get = function()
								return self.newAuraPriority or 0
							end,
							set = function(info, value)
								self.newAuraPriority = value
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
							end,
							min = 0,
							max = 20,
							step = 1,
							order = 2,
						},
						add = {
							type = "execute",
							name = L["Add new Aura"],
							func = function(info)
								if not self.newAuraName or self.newAuraName == "" then
									return
								end
								if not self.newAuraPriority then
									self.newAuraPriority = 0
								end
								local isNum = tonumber(self.newAuraName) ~= nil
								local name = isNum and GetSpellInfo(self.newAuraName) or self.newAuraName
								Gladius.options.args[self.name].args.auraList.args[self.newAuraName] = self:SetupAura(self.newAuraName, self.newAuraPriority, name)
								Gladius.db.classIconAuras[self.newAuraName] = self.newAuraPriority
								self.newAuraName = ""
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras or not self.newAuraName or self.newAuraName == ""
							end,
							order = 3,
						},
					},
				},
			},
		},
	}
	for aura, priority in pairs(Gladius.db.classIconAuras) do
		if priority then
			local isNum = tonumber(aura) ~= nil
			local name = isNum and GetSpellInfo(aura) or aura
			options.auraList.args[aura] = self:SetupAura(aura, priority, name)
		end
	end
	return options
end

local function setAura(info, value)
	if info[#(info)] == "name" then
		if info[#(info) - 1] == value then
			return
		end
		-- create new aura
		Gladius.db.classIconAuras[value] = Gladius.db.classIconAuras[info[#(info) - 1]]
		-- delete old aura
		Gladius.db.classIconAuras[info[#(info) - 1]] = nil
		local newAura = Gladius.options.args["ClassIcon"].args.auraList.args.newAura
		Gladius.options.args["ClassIcon"].args.auraList.args = {
			newAura = newAura,
		}
		for aura, priority in pairs(Gladius.db.classIconAuras) do
			if priority then
				local isNum = tonumber(aura) ~= nil
				local name = isNum and GetSpellInfo(aura) or aura
				Gladius.options.args["ClassIcon"].args.auraList.args[aura] = ClassIcon:SetupAura(aura, priority, name)
			end
		end
	else
		Gladius.dbi.profile.classIconAuras[info[#(info) - 1]] = value
	end
end

local function getAura(info)
	if info[#(info)] == "name" then
		return info[#(info) - 1]
	else
		return Gladius.dbi.profile.classIconAuras[info[#(info) - 1]]
	end
end

function ClassIcon:SetupAura(aura, priority, name)
	local name = name or aura
	return {
		type = "group",
		name = name,
		desc = name,
		get = getAura,
		set = setAura,
		args = {
			name = {
				type = "input",
				name = L["Name or ID"],
				desc = L["Name or ID of the aura"],
				order = 1,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
				end,
			},
			priority = {
				type = "range",
				name = L["Priority"],
				desc = L["Select what priority the aura should have - higher equals more priority"],
				min = 0,
				max = 20,
				step = 1,
				order = 2,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
				end,
			},
			delete = {
				type = "execute",
				name = L["Delete"],
				func = function(info)
					local defaults = GetDefaultAuraList()
					if defaults[info[#(info) - 1]] then
						Gladius.db.classIconAuras[info[#(info) - 1]] = false
					else
						Gladius.db.classIconAuras[info[#(info) - 1]] = nil
					end
					local newAura = Gladius.options.args[self.name].args.auraList.args.newAura
					Gladius.options.args[self.name].args.auraList.args = {
						newAura = newAura,
					}
					for aura, priority in pairs(Gladius.db.classIconAuras) do
						if priority then
							local isNum = tonumber(aura) ~= nil
							local name = isNum and GetSpellInfo(aura) or aura
							Gladius.options.args[self.name].args.auraList.args[aura] = self:SetupAura(aura, priority, name)
						end
					end
				end,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
				end,
				order = 3,
			},
			reset = {
				type = "execute",
				name = L["Reset Auras"],
				func = function(info)
					self:ResetModule()
				end,
				disabled = function()
					return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.classIconImportantAuras
				end,
				order = 4,
			},
		},
	}
end
