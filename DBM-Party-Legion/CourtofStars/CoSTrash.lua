local mod	= DBM:NewMod("CoSTrash", "DBM-Party-Legion", 7)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20230117042742")
--mod:SetModelID(47785)
mod:SetOOCBWComms()
mod:SetMinSyncRevision(20221228000000)
mod:SetZone(1571)

mod.isTrashMod = true

--LW solution, unregister/reregister other addons/WA frames from GOSSIP_SHOW
--This is to prevent things like https://wago.io/M+Timer/114 from breaking clue helper do to advancing
--dialog before we get a chance to read gossipID
local frames = {GetFramesRegisteredForEvent("GOSSIP_SHOW")}
for i = 1, #frames do
	frames[i]:UnregisterEvent("GOSSIP_SHOW")
end
mod:RegisterEvents(
	"SPELL_CAST_START 209027 212031 209485 209410 209413 211470 211464 209404 209495 225100 211299 209378 397892 397897 207979 212784 207980",
	"SPELL_AURA_APPLIED 209033 209512 397907 373552",
	"SPELL_AURA_REMOVED 397907",
	"CHAT_MSG_MONSTER_SAY",
	"GOSSIP_SHOW"
)
for i = 1, #frames do
	frames[i]:RegisterEvent("GOSSIP_SHOW")
end

--TODO, at least 1-2 more GTFOs I forgot names of
--TODO, target scan https://www.wowhead.com/beta/spell=397897/crushing-leap ?
--TODO, few more auto gossips
--Buffs/Utility (professions and classs perks)
--45278 Haste Buff Court of Stars (cooking/herbalism?)
--Distractions (to separate boss)
--45473 Warrior Distraction Court of Stars
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

mod:AddBoolOption("AGBoat", true)
mod:AddBoolOption("AGDisguise", true)
mod:AddBoolOption("SpyHelper", true)
mod:AddBoolOption("SendToChat2", true)
mod:AddBoolOption("SpyHelperClose2", false)

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
		warnImpendingDoom:CombinedShow(0.5, args.destName)
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
	local clueTotal = 0
	local hintTranslations = {
		[1] = L.Cape or "cape",
		[2] = L.Nocape or "no cape",
		[3] = L.Pouch or "pouch",
		[4] = L.Potions or "potions",
		[5] = L.LongSleeve or "long sleeves",
		[6] = L.ShortSleeve or "short sleeves",
		[7] = L.Gloves or "gloves",
		[8] = L.NoGloves or "no gloves",
		[9] = L.Male or "male",
		[10] = L.Female or "female",
		[11] = L.LightVest or "light vest",
		[12] = L.DarkVest or "dark vest",
		[13] = L.NoPotions or "no potions",
		[14] = L.Book or "book",
	}
	local hints = {}
	local clueIds = {
		[45674] = 1,--Cape
		[45675] = 2,--No Cape
		[45660] = 3,--Pouch
		[45666] = 4,--Potions
		[45676] = 5,--Long Sleeves
		[45677] = 6,--Short Sleeves
		[45673] = 7,--Gloves
		[45672] = 8,--No Gloves
		[45657] = 9,--Male
		[45658] = 10,--Female
		[45636] = 11,--Light Vest
		[45635] = 12,--Dark Vest
		[45667] = 13,--No Potions
		[45659] = 14--Book
	}

	local function updateInfoFrame()
		local lines = {}
		for hint, _ in pairs(hints) do
			local text = hintTranslations[hint]
			lines[text] = ""
		end
		return lines
	end

	local function callUpdate()
		clueTotal = clueTotal + 1
		DBM.InfoFrame:SetHeader(L.CluesFound:format(clueTotal))
		DBM.InfoFrame:Show(5, "function", updateInfoFrame)
	end

	function mod:ResetGossipState()--/run DBM:GetModByName("CoSTrash"):ResetGossipState()
		table.wipe(hints)
		clueTotal = 0
		DBM.InfoFrame:Hide()
	end

	function mod:CHAT_MSG_MONSTER_SAY(msg, _, _, _, target)
		if msg:find(L.Found) or msg == L.Found then
			self:SendSync("Finished", target)
		end
	end

	function mod:GOSSIP_SHOW()
		local gossipOptionID = self:GetGossipID()
		if gossipOptionID then
			DBM:Debug("GOSSIP_SHOW triggered with a gossip ID of: "..gossipOptionID)
			if self.Options.AGBoat and gossipOptionID == 45624 then -- Boat
				self:SelectGossip(gossipOptionID)
			elseif self.Options.AGDisguise and gossipOptionID == 45656 then -- Disguise
				self:SelectGossip(gossipOptionID)
			elseif clueIds[gossipOptionID] then -- SpyHelper
				if not self.Options.SpyHelper then return end
				local clue = clueIds[gossipOptionID]
				if not hints[clue] then
					if self.Options.SendToChat2 then
						local text = hintTranslations[clue]
						if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
							SendChatMessage(text, "INSTANCE_CHAT")
						elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
							SendChatMessage(text, "PARTY")
						end
					end
					hints[clue] = true
					self:SendSync("CoS", clue)
					callUpdate()
					--Still required to advance dialog or demon hunters can't use spectral sight
					--We try to delay it by .1 so other mods can still parse gossip ID in theory
					C_Timer.After(0.1, function() self:SelectGossip(gossipOptionID) end)
				end
				if self.Options.SpyHelperClose2 then
					--Delay used so DBM doesn't prevent other mods or WAs from parsing data
					C_Timer.After(0.3, function() C_GossipInfo.CloseGossip() end)
				end
			end
		end
	end

	function mod:OnSync(msg, clue)
		if not self.Options.SpyHelper then return end
		if msg == "CoS" and clue then
			clue = tonumber(clue)
			if clue and not hints[clue] then
				hints[clue] = true
				callUpdate()
			end
		elseif msg == "Finished" then
			self:ResetGossipState()
			if clue then
				local targetname = DBM:GetUnitFullName(clue) or clue
				DBM:AddMsg(L.SpyFound:format(targetname))
			end
		end
	end
	function mod:OnBWSync(msg, extra)
		if not self.Options.SpyHelper then return end
		if msg ~= "clue" then return end
		extra = tonumber(extra)
		if extra and extra > 0 and extra < 15 and not hints[extra] then
			DBM:Debug("Recieved BigWigs Comm:"..extra)
			hints[extra] = true
			callUpdate()
		end
	end
end
