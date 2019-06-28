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
		[GetSpellInfo(167152)]   = 10,    -- Refreshment
		[GetSpellInfo(118358)]   = 10,    -- Drink
		[GetSpellInfo(1784)]     = 10,    -- Stealth
		[GetSpellInfo(5215)]     = 10,    -- Prowl
		["198158"]               = 10.3,  -- Mass Invisibility
		[GetSpellInfo(215769)]   = 10,    -- Spirit of the Redeemer
		[GetSpellInfo(45438)]    = 10,    -- Ice Block
		["45182"]                = 10,    -- Cheating Death
		["116888"]               = 10,    -- Purgatory
		[GetSpellInfo(269513)]   = 10,    -- Death from Above
		[GetSpellInfo(46924)]    = 10,    -- Bladestorm fury
		[GetSpellInfo(227847)]   = 10,    -- Bladestorm arms
		[GetSpellInfo(47585)]    = 10,    -- Dispersion
		[GetSpellInfo(642)]      = 10,    -- Divine Shield
		[GetSpellInfo(228050)]   = 10.1,  -- Prot pala Party Bubble
		[GetSpellInfo(210918)]   = 10,    -- Ethereal Form
		[GetSpellInfo(27827)]    = 10,    -- Spirit of Redemption
		[GetSpellInfo(186265)]   = 10,    -- Aspect of the Turtle
		[GetSpellInfo(196555)]   = 10,    -- Netherwalk
		[GetSpellInfo(58984)]    = 10,    -- Shadowmeld

		[GetSpellInfo(2094)]      = 9.1,  -- Blind
		[GetSpellInfo(202274)]    = 9.1,  -- Brew Breath
		[GetSpellInfo(207167)]    = 9,    -- Blinding Sleet
		[GetSpellInfo(209753)]    = 9.1,  -- Cyclone (boomy)
		[GetSpellInfo(33786)]     = 9.1,  -- Cyclone (rdruid/feral)
		["221527"]                = 9.1,  -- Imprison talented
		[GetSpellInfo(605)]       = 9,    -- Mind Control
		[GetSpellInfo(118699)]    = 9,    -- Fear
		["226943"]                = 9,    -- Mind Bomb disorient
		[GetSpellInfo(236748)]    = 9,    -- disorienting roar
		[GetSpellInfo(2637)]      = 9,    -- Hibernate
		[GetSpellInfo(3355)]      = 9.1,  -- Freezing Trap
		[GetSpellInfo(203337)]    = 9.1,  -- Freezing Trap (talented)
		[GetSpellInfo(51514)]     = 9,    -- Hex
		[GetSpellInfo(211004)]    = 9,    -- Hex
		[GetSpellInfo(210873)]    = 9,    -- Hex
		[GetSpellInfo(211015)]    = 9,    -- Hex
		[GetSpellInfo(211010)]    = 9,    -- Hex
		[GetSpellInfo(277784)]    = 9,    -- Hex
		[GetSpellInfo(277778)]    = 9,    -- Hex
		[GetSpellInfo(269352)]    = 9,    -- Hex
		[GetSpellInfo(5246)]      = 9,    -- Intimidating Shout
		[GetSpellInfo(6789)]      = 9,    -- Mortal Coil
		[GetSpellInfo(118)]       = 9,    -- Polymorph
		[GetSpellInfo(277787)]    = 9,    -- Polymorph direhorn
		[GetSpellInfo(277792)]    = 9,    -- Polymorph bumblebee
		[GetSpellInfo(28272)]     = 9,    -- Polymorph pig
		[GetSpellInfo(61305)]     = 9,    -- Polymorph black cat
		[GetSpellInfo(61721)]     = 9,    -- Polymorph rabbit
		[GetSpellInfo(161372)]    = 9,    -- Polymorph peacock
		[GetSpellInfo(28271)]     = 9,    -- Polymorph turtle
		[GetSpellInfo(161355)]    = 9,    -- Polymorph penguin
		[GetSpellInfo(61780)]     = 9,    -- Polymorph turkey
		[GetSpellInfo(126819)]    = 9,    -- Polymorph porcupine
		[GetSpellInfo(161353)]    = 9,    -- Polymorph bear cup
		[GetSpellInfo(161354)]    = 9,    -- Polymorph monkey
		[GetSpellInfo(105421)]    = 9,    -- Blinding Light
		[GetSpellInfo(213691)]    = 9,    -- Scatter Shot
		[GetSpellInfo(8122)]      = 9,    -- Psychic Scream
		[GetSpellInfo(20066)]     = 9,    -- Repentance
		[GetSpellInfo(82691)]     = 9,    -- Ring of Frost
		[GetSpellInfo(6770)]      = 9.1,  -- Sap
		[GetSpellInfo(107079)]    = 9,    -- Quaking Palm
		[GetSpellInfo(6358)]      = 9,    -- Seduction (Succubus)
		[GetSpellInfo(261589)]    = 9,    -- Seduction (Player)
		[GetSpellInfo(1776)]      = 9,    -- Gouge
		[GetSpellInfo(31661)]     = 9,    -- Dragon's Breath

		[GetSpellInfo(207685)]    = 8,    -- Sigil of Misery Disorient
		[GetSpellInfo(198909)]    = 8,    -- Song of Chi-Ji
		[GetSpellInfo(221562)]    = 8,    -- Asphyxiate blood
		[GetSpellInfo(108194)]    = 8,    -- Asphyxiate frost/unholy
		[GetSpellInfo(210141)]    = 8,    -- Zombie Explosion
		[GetSpellInfo(91797)]     = 8,    -- transformed Gnaw
		[GetSpellInfo(91800)]     = 8,    -- untransformed Gnaw
		[GetSpellInfo(89766)]     = 8,    -- Axe Toss (Felguard)
		[GetSpellInfo(24394)]     = 8,    -- Intimidation
		[GetSpellInfo(202244)]    = 8,    -- Overrun bear stun
		[GetSpellInfo(1833)]      = 8,    -- Cheap Shot
		[GetSpellInfo(205630)]    = 8,    -- Illidan's Grasp 1
		[GetSpellInfo(208618)]    = 8,    -- Illidan's Grasp 2
		[GetSpellInfo(213491)]    = 8,    -- Demonic Trample knockdown
		[GetSpellInfo(199804)]    = 8,    -- Between the Eyes
		[GetSpellInfo(235612)]    = 8,    -- Frost DK stun
		[GetSpellInfo(287254)]    = 8,    -- Remorseless Winter stun
		["77505"]                 = 8,    -- Earthquake
		[GetSpellInfo(213688)]    = 8,    -- Fel Cleave
		[GetSpellInfo(853)]       = 8,    -- Hammer of Justice
		[GetSpellInfo(200196)]    = 8,    -- Holy Word: Chastise
		[GetSpellInfo(408)]       = 8,    -- Kidney Shot
		[GetSpellInfo(202346)]    = 8,    -- Keg Stun
		[GetSpellInfo(200200)]    = 8,    -- Holy Word: Chastise
		[GetSpellInfo(119381)]    = 8.2,  -- Leg Sweep
		[GetSpellInfo(179057)]    = 8.1,  -- Chaos Nova
		[GetSpellInfo(211881)]    = 8,    -- Fel Eruption
		[GetSpellInfo(204399)]    = 8,    -- Earthfury
		[GetSpellInfo(255723)]    = 8,    -- Bull Rush
		[GetSpellInfo(204437)]    = 8,    -- Lightning Lasso
		[GetSpellInfo(197214)]    = 8,    -- Sundering
		[GetSpellInfo(203123)]    = 8,    -- Maim stun
		[GetSpellInfo(64044)]     = 8,    -- Psychic Horror
		[GetSpellInfo(199085)]    = 8,    -- Heroic Leap Stun
		[GetSpellInfo(5211)]      = 8,    -- Mighty Bash
		[GetSpellInfo(118345)]    = 8,    -- Pulverize (Primal Earth Elemental)
		[GetSpellInfo(30283)]     = 8,    -- Shadowfury
		[GetSpellInfo(22703)]     = 8,    -- Summon Infernal stun
		[GetSpellInfo(132168)]    = 8,    -- Shockwave
		[GetSpellInfo(118905)]    = 8,    -- Lightning Surge Totem
		[GetSpellInfo(132169)]    = 8,    -- Storm Bolt
		[GetSpellInfo(20549)]     = 8,    -- War Stomp
		[GetSpellInfo(87204)]     = 8,    -- Sin and Punishment
		["117526"]                = 8,    -- Binding Shot
		["163505"]                = 8,    -- Rake stun
		[GetSpellInfo(48792)]     = 8,    -- Icebound Fortitude
		[GetSpellInfo(287081)]    = 8,    -- Lichborne
		[GetSpellInfo(115078)]    = 8.1,  -- Paralysis
		["217832"]                = 8,    -- Imprison
		[GetSpellInfo(236025)]    = 8,    -- Enraged Maim incap

		[GetSpellInfo(104773)]    = 7.5,  -- Unending Resolve affli/demo/destro
		["77606"]                 = 7.4,  -- Dark Simulacrum
		["122470"]                = 7,    -- Touch of Karma debuff
		["125174"]                = 7,    -- Touch of Karma buff
		[GetSpellInfo(5277)]      = 7.4,  -- Evasion
		[GetSpellInfo(213602)]    = 7.4,  -- Greater Fade
		[GetSpellInfo(199027)]    = 7.2,  -- Evasion2 post stealth
		[GetSpellInfo(199754)]    = 7.3,  -- Riposte
		[GetSpellInfo(198144)]    = 7.3,  -- Ice Form
		[GetSpellInfo(188499)]    = 7.3,  -- Blade Dance
		[GetSpellInfo(210152)]    = 7.3,  -- Death Sweep
		[GetSpellInfo(212800)]    = 7.2,  -- Blur
		[GetSpellInfo(209426)]    = 7.1,  -- Darkness
		["6940"]                  = 7.2,  -- Blessing of Sacrifice
		["199448"]                = 7.2,  -- Blessing of Sacrifice
		[GetSpellInfo(1022)]      = 7.4,  -- Hand of Protection
		[GetSpellInfo(18499)]     = 7.3,  -- Berserker Rage
		[GetSpellInfo(212704)]    = 7.3,  -- The Beast Within
		["196364"]                = 7,    -- Unstable Affliction silence
		[GetSpellInfo(1330)]      = 7,    -- Garrote (Silence)
		[GetSpellInfo(15487)]     = 7,    -- Silence
		[GetSpellInfo(204490)]    = 7,    -- Sigil of Silence
		[GetSpellInfo(217824)]    = 7,    -- Prot Pala Silence
		[GetSpellInfo(236077)]    = 7,    -- War Disarm
		[GetSpellInfo(207777)]    = 7,    -- Dismantle
		[GetSpellInfo(233759)]    = 7,    -- Grapple Weapon
		[GetSpellInfo(209749)]    = 7,    -- Faerie Swarm disarm
		["202933"]                = 7,    -- Spider Sting
		[GetSpellInfo(47476)]     = 7.5,  -- Strangulate
		[GetSpellInfo(81261)]     = 7,    -- Solar Beam

		[GetSpellInfo(8178)]      = 6.3,  -- Grounding Totem Effect
		[GetSpellInfo(91807)]     = 6,    -- Shambling Rush (Ghoul)
		["116706"]                = 6,    -- Disable
		[GetSpellInfo(157997)]    = 6,    -- Ice Nova
		[GetSpellInfo(228600)]    = 6,    -- Glacial Spike
		[GetSpellInfo(198121)]    = 6,    -- Frostbite
		[GetSpellInfo(233395)]    = 6,    -- Frozen Center
		[GetSpellInfo(64695)]     = 6,    -- Earthgrab Totem
		[GetSpellInfo(233582)]    = 6,    -- Destro root
		[GetSpellInfo(285515)]    = 6,    -- Frost Shock root (talent)
		[GetSpellInfo(339)]       = 6,    -- Entangling Roots
		["162480"]                = 6,    -- Steel Trap root
		[GetSpellInfo(235963)]    = 6,    -- Entangling Roots undispellable
		[GetSpellInfo(170855)]    = 6,    -- Ironbark Entangling Roots
		[GetSpellInfo(45334)]     = 6,    -- Immobilized (Wild Charge - Bear)
		[GetSpellInfo(33395)]     = 6,    -- Freeze (Water Elemental)
		[GetSpellInfo(122)]       = 6,    -- Frost Nova
		[GetSpellInfo(102359)]    = 6,    -- Mass Entanglement
		[GetSpellInfo(190927)]    = 6,    -- Harpoon
		["212638"]                = 6,    -- Tracker's Net (miss atks)
		[GetSpellInfo(105771)]    = 6,    -- Charge root
		["204085"]                = 6,    -- Deathchill root

		["198222"]                = 5.9,  -- System Shock 90% slow
		[GetSpellInfo(48707)]     = 5.2,  -- Anti-Magic Shell
		[GetSpellInfo(204018)]    = 5.3,  -- Magic Bop
		[GetSpellInfo(212295)]    = 5.2,  -- Nether Ward
		[GetSpellInfo(221705)]    = 5.1,  -- Casting Circle
		[GetSpellInfo(234084)]    = 5.1,  -- Boomy 70% kick reduc
		[GetSpellInfo(196773)]    = 5.1,  -- inner focus
		[GetSpellInfo(290641)]    = 5.1,  -- Ancestral Gift
		[GetSpellInfo(289655)]    = 5.1,  -- Holy Word: Concentration
		[GetSpellInfo(209584)]    = 5.1,  -- Zen Focus Tea
		[GetSpellInfo(116849)]    = 5,    -- Life Cocoon
		[GetSpellInfo(110960)]    = 5.1,  -- Greater Invisibility
		[GetSpellInfo(113862)]    = 5,    -- Greater Invisibility
		[GetSpellInfo(108271)]    = 5,    -- Astral Shift
		[GetSpellInfo(22812)]     = 5,    -- Barkskin
		[GetSpellInfo(871)]       = 5,    -- Shield Wall
		[GetSpellInfo(232707)]    = 5.4,  -- Ray of Hope
		[GetSpellInfo(31224)]     = 5.3,  -- Cloak of Shadows
		[GetSpellInfo(118038)]    = 5.1,  -- Die by the Sword
		[GetSpellInfo(227744)]    = 5,    -- Ravager parry
		[GetSpellInfo(81256)]     = 5,    -- Dancing Rune weapon
		[GetSpellInfo(498)]       = 5,    -- Divine Protection
		[GetSpellInfo(236321)]    = 5,    -- War Banner
		[GetSpellInfo(199507)]    = 5,    -- Spreading The Word: Protection
		[GetSpellInfo(205191)]    = 5.1,  -- Eye for an Eye
		[GetSpellInfo(47788)]     = 5,    -- Guardian Spirit
		[GetSpellInfo(207498)]    = 5,    -- Ancestral Protection Totem
		[GetSpellInfo(66)]        = 5,    -- Invisibility
		[GetSpellInfo(32612)]     = 5,    -- Invisibility
		[GetSpellInfo(102342)]    = 5,    -- Ironbark
		[GetSpellInfo(199038)]    = 5,    -- Intercept 90% dmg reduc
		[GetSpellInfo(202748)]    = 5,    -- survival tactics
		[GetSpellInfo(210256)]    = 5,    -- Blessing of Sanctuary
		[GetSpellInfo(213610)]    = 5,    -- Holy Ward
		[GetSpellInfo(122783)]    = 5.1,  -- Diffuse Magic
		[GetSpellInfo(33206)]     = 5,    -- Pain Suppression
		[GetSpellInfo(53480)]     = 5,    -- Roar of Sacrifice
		[GetSpellInfo(192081)]    = 5,    -- Ironfur
		[GetSpellInfo(31850)]     = 5,    -- Ardent Defender
		[GetSpellInfo(86659)]     = 5.3,  -- Prot Pala Wall
		[GetSpellInfo(184364)]    = 5,    -- Enraged Regeneration
		[GetSpellInfo(207736)]    = 5,    -- Shadowy Duel
		[GetSpellInfo(236273)]    = 5,    -- Duel
		[GetSpellInfo(207756)]    = 5,    -- Shadowy Duel
		[GetSpellInfo(210294)]    = 5,    -- Divine Favor
		[GetSpellInfo(198111)]    = 5,    -- Temporal Shield
		[GetSpellInfo(216890)]    = 5.1,  -- Spell Reflection
		[GetSpellInfo(23920)]     = 5.1,  -- Spell Reflection prot
		[GetSpellInfo(213915)]    = 5.1,  -- Mass Spell Reflection
		[GetSpellInfo(147833)]    = 5.2,  -- Intercepted Spell Redirect
		[GetSpellInfo(202248)]    = 5.1,  -- zen meditation
		[GetSpellInfo(248519)]    = 5.1,  -- Interlope (bm pet redirect)
		[GetSpellInfo(61336)]     = 5,    -- Survival Instincts

		[GetSpellInfo(206803)]    = 4.1,  -- Rain from Above
		[GetSpellInfo(206804)]    = 4,    -- Rain from Above
		[GetSpellInfo(1044)]      = 4,    -- Blessing of Freedom
		[GetSpellInfo(290500)]    = 4,    -- Wind Waker
		[GetSpellInfo(216113)]    = 4,    -- Way of the crane
		[GetSpellInfo(199545)]    = 4,    -- prot pala freedom
		[GetSpellInfo(48265)]     = 4,    -- death's advance
		[GetSpellInfo(201447)]    = 4,    -- Ride the Wind
		[GetSpellInfo(256948)]    = 4,    -- Spatial Rift
		[GetSpellInfo(213664)]    = 4,    -- Nimble Brew
		[GetSpellInfo(197003)]    = 4,    -- Maneuverability
		[GetSpellInfo(198065)]    = 4,    -- Prismatic Cloak
		[GetSpellInfo(54216)]     = 4,    -- Master's Call
		[GetSpellInfo(115192)]    = 4.1,  -- Subterfuge
		[GetSpellInfo(11327)]     = 4,    -- Vanish

		[GetSpellInfo(12042)]     = 3,    -- Arcane Power
		[GetSpellInfo(29166)]     = 3,    -- Innervate
		[GetSpellInfo(114050)]    = 3,    -- Ascendance ele
		[GetSpellInfo(208997)]    = 3.1,  -- Counterstrike Totem
		["236696"]                = 3.1,  -- Thorns boomy/feral
		[GetSpellInfo(114051)]    = 3,    -- Ascendance enha
		[GetSpellInfo(114052)]    = 3,    -- Ascendance resto
		[GetSpellInfo(47536)]     = 3.1,  -- Rapture
		[GetSpellInfo(198760)]    = 3,    -- Intercept 30% dmg reduc
		[GetSpellInfo(231895)]    = 3,    -- Crusade
		[GetSpellInfo(194249)]    = 3,    -- Voidform
		[GetSpellInfo(204362)]    = 3.3,  -- Heroism
		[GetSpellInfo(204361)]    = 3.3,  -- Bloodlust
		[GetSpellInfo(12472)]     = 3,    -- Icy Veins
		[GetSpellInfo(51690)]     = 3.1,  -- Killing Spree
		[GetSpellInfo(33891)]     = 3.1,  -- Incarnation: Treeform
		[GetSpellInfo(117679)]    = 3,    -- Incarnation: Tree of Life
		[GetSpellInfo(102560)]    = 3,    -- Incarnation: Chosen of Elune
		[GetSpellInfo(102543)]    = 3,    -- Incarnation: King of the Jungle
		[GetSpellInfo(102558)]    = 3,    -- Incarnation: Son of Ursoc
		[GetSpellInfo(19574)]     = 3,    -- Bestial Wrath
		[GetSpellInfo(190319)]    = 3,    -- Combustion
		[GetSpellInfo(193526)]    = 3,    -- Trueshot
		[GetSpellInfo(266779)]    = 3,    -- Coordinated Assault
		[GetSpellInfo(1719)]      = 3,    -- Recklessness
		[GetSpellInfo(194223)]    = 3,    -- Celestial Alignment
		["191427"]                = 3,    -- Metamorphosis talented
		["162264"]                = 3,    -- Metamorphosis
		["187827"]                = 3,    -- Metamorphosis (tank)
		[GetSpellInfo(152173)]    = 3,    -- Serenity

		[GetSpellInfo(185422)]    = 2.3,  -- Shadow Dance
		[GetSpellInfo(121471)]    = 2.2,  -- Shadow Blades
		[GetSpellInfo(197871)]    = 2.5,  -- Dark Archangel
		[GetSpellInfo(79140)]     = 2.3,  -- Vendetta
		["198529"]                = 2.3,  -- Plunder Armor
		[GetSpellInfo(51271)]     = 2.1,  -- Pillar of Frost
		[GetSpellInfo(107574)]    = 2.1,  -- Avatar
		[GetSpellInfo(13750)]     = 2.1,  -- Adrenaline Rush
		[GetSpellInfo(201318)]    = 2.1,  -- Fortifying Brew (WW)
		[GetSpellInfo(243435)]    = 2.1,  -- Fortifying Brew (MW)
		[GetSpellInfo(120954)]    = 2.1,  -- Fortifying Brew (BM)
		[GetSpellInfo(55233)]     = 2.2,  -- Vampiric Blood
		[GetSpellInfo(31884)]     = 2.1,  -- Avenging Wrath
		[GetSpellInfo(207289)]    = 2.1,  -- unholy frenzy
		[GetSpellInfo(216331)]    = 2.1,  -- Avenging Crusader
		[GetSpellInfo(116014)]    = 2,    -- Rune of Power
		[GetSpellInfo(1966)]      = 2.1,  -- Feint
		[GetSpellInfo(288977)]    = 2.1,  -- Transfusion
		[GetSpellInfo(213871)]    = 2.1,  -- Bodyguard
		[GetSpellInfo(223658)]    = 2.2,  -- Safeguard dmg reduc
		[GetSpellInfo(202162)]    = 2.2,  -- Guard
		[GetSpellInfo(201633)]    = 2.2,  -- Earthen Totem
		[GetSpellInfo(122278)]    = 2.2,  -- Dampen Harm
		[GetSpellInfo(207498)]    = 2.1,  -- Ancestral Protection
		[GetSpellInfo(206649)]    = 2,    -- Eye of Leotheras

		[GetSpellInfo(116095)]    = 1.1,  -- Disable
		[GetSpellInfo(221886)]    = 1.1,  -- Divine Steed
		[GetSpellInfo(116841)]    = 1,    -- Tiger's Lust
		[GetSpellInfo(286349)]    = 1,    -- Gladiator's Maledict
		["286342"]                = 1,    -- Gladiator's Safeguard
		[GetSpellInfo(277187)]    = 1,    -- Gladiator's Emblem
		[GetSpellInfo(97463)]     = 1,    -- Rallying Cry
		[GetSpellInfo(12975)]     = 1.3,  -- Last Stand
		[GetSpellInfo(202900)]    = 1.3,  -- scorpid sting
		[GetSpellInfo(212552)]    = 1.1,  -- Wraith Walk
		[GetSpellInfo(188501)]    = 1,    -- Spectral Sight
		[GetSpellInfo(5384)]      = 1,    -- Feign Death
		[GetSpellInfo(145629)]    = 1,    -- Anti-Magic Zone
		[GetSpellInfo(81782)]     = 1,    -- Disc Barrier
		[GetSpellInfo(204293)]    = 1,    -- Spirit Link
		[GetSpellInfo(98007)]     = 1,    -- Spirit Link Totem
		[GetSpellInfo(212183)]    = 1,    -- Smoke Bomb
		[GetSpellInfo(202797)]    = 1,    -- Viper Sting
		[GetSpellInfo(197690)]    = 1,    -- Defensive Stance
		[GetSpellInfo(783)]       = 1.1,  -- Travel form
		[GetSpellInfo(5487)]      = 1.1,  -- Bear form
		[GetSpellInfo(768)]       = 1.1,  -- Cat form
		[GetSpellInfo(197625)]    = 1.1,  -- Moonkin form 1
		[GetSpellInfo(24858)]     = 1.1,  -- Moonkin form 2
		[GetSpellInfo(199890)]    = 1,    -- Curse of Tongues
		[GetSpellInfo(199892)]    = 1,    -- Curse of Weakness
		[GetSpellInfo(199954)]    = 1,    -- Curse of Fragility
		[GetSpellInfo(290786)]    = 1,    -- Ultimate Retribution
		["205369"]                = 1,    -- Mind Bomb pre disorient
		[GetSpellInfo(200587)]    = 1.2,  -- Fel Fissure
		["198819"]                = 1.2,  -- Sharpen Blade
		["199845"]                = 1.2,  -- Psyfiend
		["199483"]                = 1.2,  -- Camouflage
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
