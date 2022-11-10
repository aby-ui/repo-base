local mod	= DBM:NewMod("CoSTrash", "DBM-Party-Legion", 7)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221109022224")
--mod:SetModelID(47785)
mod:SetOOCBWComms()

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 209027 212031 209485 209410 209413 211470 211464 209404 209495 225100 211299 209378 397892 397897 207979 212784",
	"SPELL_AURA_APPLIED 209033 209512 397907 373552",
	"SPELL_AURA_REMOVED 397907",
	"CHAT_MSG_MONSTER_SAY",
	"GOSSIP_SHOW"
)

--TODO, at least 1-2 more GTFOs I forgot names of
--TODO, verify if Disintegration beam is interruptable at 207980 or 207981
--TODO, target scan https://www.wowhead.com/beta/spell=397897/crushing-leap ?
local warnImpendingDoom				= mod:NewTargetAnnounce(397907, 2)
local warnCrushingLeap				= mod:NewCastAnnounce(397897, 3)
local warnEyeStorm					= mod:NewCastAnnounce(212784, 3)
local warnHypnosisBat				= mod:NewTargetNoFilterAnnounce(373552, 3)

local specWarnFortification			= mod:NewSpecialWarningDispel(209033, "MagicDispeller", nil, nil, 1, 2)
local specWarnQuellingStrike		= mod:NewSpecialWarningDodge(209027, "Tank", nil, nil, 1, 2)
local specWarnChargedBlast			= mod:NewSpecialWarningDodge(212031, "Tank", nil, nil, 1, 2)
local specWarnChargedSmash			= mod:NewSpecialWarningDodge(209495, "Tank", nil, nil, 1, 2)
local specWarnShockwave				= mod:NewSpecialWarningDodge(207979, nil, nil, nil, 2, 2)
local specWarnDrainMagic			= mod:NewSpecialWarningInterrupt(209485, "HasInterrupt", nil, nil, 1, 2)
local specWarnNightfallOrb			= mod:NewSpecialWarningInterrupt(209410, "HasInterrupt", nil, nil, 1, 2)
local specWarnSuppress				= mod:NewSpecialWarningInterrupt(209413, "HasInterrupt", nil, nil, 1, 2)
local specWarnBewitch				= mod:NewSpecialWarningInterrupt(211470, "HasInterrupt", nil, nil, 1, 2)
local specWarnChargingStation		= mod:NewSpecialWarningInterrupt(225100, "HasInterrupt", nil, nil, 1, 2)
local specWarnSearingGlare			= mod:NewSpecialWarningInterrupt(211299, "HasInterrupt", nil, nil, 1, 2)
local specWarnDisintegrationBeam	= mod:NewSpecialWarningInterrupt(207980, "HasInterrupt", nil, nil, 1, 2)
local specWarnFelDetonation			= mod:NewSpecialWarningMoveTo(211464, nil, nil, nil, 2, 2)
local specWarnSealMagic				= mod:NewSpecialWarningRun(209404, false, nil, 2, 4, 2)
local specWarnWhirlingBlades		= mod:NewSpecialWarningRun(209378, "Melee", nil, nil, 4, 2)
local specWarnScreamofPain			= mod:NewSpecialWarningCast(397892, "SpellCaster", nil, nil, 1, 2)
local specWarnImpendingDoom			= mod:NewSpecialWarningMoveAway(397907, nil, nil, nil, 1, 2)
local yellImpendingDoom				= mod:NewYell(397907)
local yellImpendingDoomFades		= mod:NewShortFadesYell(397907)
local specWarnGTFO					= mod:NewSpecialWarningGTFO(209512, nil, nil, nil, 1, 8)

mod:AddBoolOption("SpyHelper", true)
mod:AddBoolOption("SendToChat", false)

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 generalized, 7 GTFO

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 209027 and self:AntiSpam(3, 2) then
		specWarnQuellingStrike:Show()
		specWarnQuellingStrike:Play("shockwave")
	elseif spellId == 212031 and self:AntiSpam(3, 2) then
		specWarnChargedBlast:Show()
		specWarnChargedBlast:Play("shockwave")
	elseif spellId == 207979 and self:AntiSpam(3, 2) then
		specWarnShockwave:Show()
		specWarnShockwave:Play("shockwave")
	elseif spellId == 209485 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnDrainMagic:Show(args.sourceName)
		specWarnDrainMagic:Play("kickcast")
	elseif spellId == 209410 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnNightfallOrb:Show(args.sourceName)
		specWarnNightfallOrb:Play("kickcast")
	elseif spellId == 209413 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSuppress:Show(args.sourceName)
		specWarnSuppress:Play("kickcast")
	elseif spellId == 211470 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnBewitch:Show(args.sourceName)
		specWarnBewitch:Play("kickcast")
	elseif spellId == 225100 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnChargingStation:Show(args.sourceName)
		specWarnChargingStation:Play("kickcast")
	elseif spellId == 211299 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSearingGlare:Show(args.sourceName)
		specWarnSearingGlare:Play("kickcast")
	elseif spellId == 207980 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnDisintegrationBeam:Show(args.sourceName)
		specWarnDisintegrationBeam:Play("kickcast")
	elseif spellId == 211464 and self:AntiSpam(3, 4) then
		specWarnFelDetonation:Show(DBM_COMMON_L.BREAK_LOS)
		specWarnFelDetonation:Play("findshelter")
	elseif spellId == 209404 and self:AntiSpam(3, 5) then
		specWarnSealMagic:Show()
		specWarnSealMagic:Play("runout")
	elseif spellId == 209495 then
		--Don't want to move too early, just be moving already as cast is finishing
		specWarnChargedSmash:Schedule(1.2)
		specWarnChargedSmash:ScheduleVoice(1.2, "chargemove")
	elseif spellId == 209378 and self:AntiSpam(3, 1) then
		specWarnWhirlingBlades:Show()
		specWarnWhirlingBlades:Play("runout")
	elseif spellId == 397892 then
		specWarnScreamofPain:Show()
		specWarnScreamofPain:Play("stopcast")
	elseif spellId == 397897 and self:AntiSpam(3, 6) then
		warnCrushingLeap:Show()
	elseif spellId == 212784 and self:AntiSpam(3, 6) then
		warnEyeStorm:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 209033 and not args:IsDestTypePlayer() and self:CheckDispelFilter("magic") then
		specWarnFortification:Show(args.destName)
		specWarnFortification:Play("dispelnow")
	elseif spellId == 209512 and args:IsPlayer() and self:AntiSpam(3, 7) then
		specWarnGTFO:Show(args.spellName)
		specWarnGTFO:Play("watchfeet")
	elseif spellId == 397907 then
		warnImpendingDoom:CombinedShow(0.5, args.destname)
		if args:IsPlayer() then
			specWarnImpendingDoom:Show()
			specWarnImpendingDoom:Play("scatter")
			yellImpendingDoom:Yell()
			yellImpendingDoomFades:Countdown(spellId)
		end
	elseif spellId == 373552 then
		warnHypnosisBat:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 397907 and args:IsPlayer() then
		yellImpendingDoomFades:Cancel()
	end
end

do
	local hintTranslations = {
		["gloves"] = L.Gloves,
		["no gloves"] = L.NoGloves,
		["cape"] = L.Cape,
		["no cape"] = L.Nocape,
		["light vest"] = L.LightVest,
		["dark vest"] = L.DarkVest,
		["female"] = L.Female,
		["male"] = L.Male,
		["short sleeves"] = L.ShortSleeve,
		["long sleeves"] = L.LongSleeve,
		["potions"] = L.Potions,
		["no potion"] = L.NoPotions,
		["book"] = L.Book,
		["pouch"] = L.Pouch
	}
	local hints = {}
	local clues = {
		[L.Gloves1] = "gloves",
		[L.Gloves2] = "gloves",
		[L.Gloves3] = "gloves",
		[L.Gloves4] = "gloves",

		[L.NoGloves1] = "no gloves",
		[L.NoGloves2] = "no gloves",
		[L.NoGloves3] = "no gloves",
		[L.NoGloves4] = "no gloves",

		[L.Cape1] = "cape",
		[L.Cape2] = "cape",

		[L.NoCape1] = "no cape",
		[L.NoCape2] = "no cape",

		[L.LightVest1] = "light vest",
		[L.LightVest2] = "light vest",
		[L.LightVest3] = "light vest",

		[L.DarkVest1] = "dark vest",
		[L.DarkVest2] = "dark vest",
		[L.DarkVest3] = "dark vest",
		[L.DarkVest4] = "dark vest",

		[L.Female1] = "female",
		[L.Female2] = "female",
		[L.Female3] = "female",
		[L.Female4] = "female",

		[L.Male1] = "male",
		[L.Male2] = "male",
		[L.Male3] = "male",
		[L.Male4] = "male",

		[L.ShortSleeve1] = "short sleeves",
		[L.ShortSleeve2] = "short sleeves",
		[L.ShortSleeve3] = "short sleeves",
		[L.ShortSleeve4] = "short sleeves",

		[L.LongSleeve1] = "long sleeves",
		[L.LongSleeve2] = "long sleeves",
		[L.LongSleeve3] = "long sleeves",
		[L.LongSleeve4] = "long sleeves",

		[L.Potions1] = "potions",
		[L.Potions2] = "potions",
		[L.Potions3] = "potions",
		[L.Potions4] = "potions",

		[L.NoPotions1] = "no potion",
		[L.NoPotions2] = "no potion",

		[L.Book1] = "book",
		[L.Book2] = "book",

		[L.Pouch1] = "pouch",
		[L.Pouch2] = "pouch",
		[L.Pouch3] = "pouch",
		[L.Pouch4] = "pouch"
	}
	local bwClues = {
		[1] = "cape",
		[2] = "no cape",
		[3] = "pouch",
		[4] = "potions",
		[5] = "long sleeves",
		[6] = "short sleeves",
		[7] = "gloves",
		[8] = "no gloves",
		[9] = "male",
		[10] = "female",
		[11] = "light vest",
		[12] = "dark vest",
		[13] = "no potion",
		[14] = "book"
	}

	local function updateInfoFrame()
		local lines = {}
		for hint, _ in pairs(hints) do
			local text = hintTranslations[hint] or hint
			lines[text] = ""
		end
		return lines
	end

	function mod:ResetGossipState()--/run DBM:GetModByName("CoSTrash"):ResetGossipState()
		table.wipe(hints)
		DBM.InfoFrame:Hide()
	end

	function mod:CHAT_MSG_MONSTER_SAY(msg)
		if msg:find(L.Found) then
			self:SendSync("Finished")
		end
	end

	function mod:GOSSIP_SHOW()
		if not self.Options.SpyHelper then return end
		local guid = UnitGUID("target")
		if not guid then return end
		local cid = self:GetCIDFromGUID(guid)

		if cid == 106468 then-- Disguise NPC
			local table = C_GossipInfo.GetOptions()
			if table[1] and table[1].gossipOptionID then
				C_GossipInfo.SelectOption(table[1].gossipOptionID)
				C_GossipInfo.CloseGossip()
			end
		end

		if cid == 107486 then-- Suspicious noble
			local table = C_GossipInfo.GetOptions()
			if table[1] and table[1].gossipOptionID then
				C_GossipInfo.SelectOption(table[1].gossipOptionID)
			else
				local clue = clues[C_GossipInfo.GetText()]
				if clue and not hints[clue] then
					C_GossipInfo.CloseGossip()
					if self.Options.SendToChat then
						if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
							SendChatMessage(hintTranslations[clue], "INSTANCE_CHAT")
						elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
							SendChatMessage(hintTranslations[clue], "PARTY")
						end
					end
					hints[clue] = true
					self:SendSync("CoS", clue)
					DBM.InfoFrame:Show(5, "function", updateInfoFrame)
				end
			end
		end
	end

	function mod:OnSync(msg, clue)
		if not self.Options.SpyHelper then return end
		if msg == "CoS" and clue then
			hints[clue] = true
			DBM.InfoFrame:Show(5, "function", updateInfoFrame)
		elseif msg == "Finished" then
			self:ResetGossipState()
		end
	end
	function mod:OnBWSync(msg, extra)
		if msg ~= "clue" then return end
		extra = tonumber(extra)
		if extra and extra > 0 and extra < 15 then
			DBM:Debug("Recieved BigWigs Comm:"..extra)
			local bwClue = bwClues[extra]
			hints[bwClue] = true
			DBM.InfoFrame:Show(5, "function", updateInfoFrame)
		end
	end
end
