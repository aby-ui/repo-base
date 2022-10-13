local mod	= DBM:NewMod("FatedAffixes", "DBM-Affixes")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221007014442")
--mod:SetModelID(47785)
mod:SetZone(2296, 2450, 2481)--Shadowlands Raids

mod.isTrashMod = true
mod.isTrashModBossFightAllowed = true

mod:RegisterEvents(
	"SPELL_CAST_START 372638",
	"SPELL_CAST_SUCCESS 372634",
	"SPELL_SUMMON 371254",
	"SPELL_AURA_APPLIED 369505 371447 371597",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 369505",
--	"SPELL_DAMAGE",
--	"SPELL_MISSED",
	"ENCOUNTER_START",
	"ENCOUNTER_END"
)

--[[
(ability.id = 372419 or ability.id = 372642 or ability.id = 372418 or ability.id = 372647 or ability.id = 372424) and type = "applybuff"
 or ability.id = 372638 and type = "begincast" or ability.id = 371254
 or (ability.id = 369505 or ability.id = 371447 or ability.id = 372286) and (type = "applybuff" or type = "applydebuff")
 or (ability.id = 328921 or ability.id = 330959 or ability.id = 323402 or ability.id = 348805 or ability.id = 328117 or ability.id = 355525 or ability.id = 357739 or ability.id = 362505 or ability.id = 361200 or ability.id = 360300 or ability.id = 360304 or ability.id = 352385 or ability.id = 360516) and (type = "removebuff")
 or (ability.id = 347376 or ability.id = 330959 or ability.id = 357729 or ability.id = 326005) and type = "cast"
 or (ability.id = 348805 or ability.id = 350857 or ability.id = 348146 or ability.id = 355525 or ability.id = 352051 or ability.id = 357739 or ability.id = 362505 or ability.id = 360300 or ability.id = 360304 or ability.id = 368383 or ability.id = 181089 or ability.id = 323402 or ability.id = 352385) and type = "applybuff"
 or (ability.id = 348974 or ability.id = 328117 or ability.id = 333932 or ability.id = 352293 or ability.id = 359235 or ability.id = 359236 or ability.id = 363130 or ability.id = 360717 or ability.id = 363533 or ability.id = 364114 or ability.id = 367851 or ability.id = 367290 or ability.id = 352660 or ability.id = 352538 or ability.id = 365872) and type = "begincast"
 or ability.id = 371597 or ability.id = 372634
--]]
local warnChaoticDestruction					= mod:NewCastAnnounce(372638, 3)--Add activating
local warnChaoticEssence						= mod:NewSpellAnnounce(372634, 2)--Clicked add
local warnCreationSpark							= mod:NewTargetNoFilterAnnounce(369505, 3)
local warnProtoformBarrier						= mod:NewTargetNoFilterAnnounce(371447, 3)
local warnReconfigurationEmitter				= mod:NewSpellAnnounce(371254, 3)

local specWarnCreationSpark						= mod:NewSpecialWarningYou(369505, nil, nil, nil, 1, 2)
local yellCreationSpark							= mod:NewYell(369505)
local specWarnCreationSparkSoak					= mod:NewSpecialWarningSoak(369505, nil, nil, nil, 2, 7)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(209862, nil, nil, nil, 1, 8)

local timerChaoticEssenceCD						= mod:NewCDTimer(58.8, 372634, nil, nil, nil, 1)--Consistent
local timerCreationSparkCD						= mod:NewCDTimer(44.9, 369505, nil, nil, nil, 3)--Consistent
local timerProtoformBarrierCD					= mod:NewCDTimer(50, 371447, nil, nil, nil, 5)--50-65
local timerReconfigurationEmitterCD				= mod:NewCDTimer(55, 371254, nil, nil, nil, 1)--55-75

local activeBosses = {}
local activeAffixes = {}
local borrowedTime = {}
local specialTimers = {
	[372419] = {--Emitter
		[0] = {--Repeating Timer
			--Castle Nathria
			[2418] = {75},--Huntsman Altimor
			[2412] = {75, 75},--Council of Blood (always 75, but restarts after dances)
			[2402] = {75, 75},--Kael
			[2398] = {},--Shriekwing
			[2405] = {75},--Artificer XyMox
			[2383] = {75},--Hungering Destroyer
			[2406] = {75},--Lady Inerva Darkvein
			[2399] = {67.9},--Sludgefist
			[2417] = {75},--Stoneborne Generals
			[2407] = {60, 79, 70},--Sire Denathrius (can spell queue higher like 79-89 for Stage 2 if hand of destruction cast pushes it back
			--Sanctum of Domination
			[2423] = {75},--The Tarragrue
			[2433] = {75, 75, 75},--The Eye of the Jailer
			[2429] = {},--The Nine
			[2432] = {75},--Remnant of Ner'zhul
			[2434] = {75},--Soulrender Dormazain
			[2430] = {},--Painsmith Raznal (unknown between casts, dps too high)
			[2436] = {},--Guardian of the First Ones
			[2431] = {80, 80, 80},--Fatescribe Roh-Kalo
			[2422] = {75, 75},--Kel'Thuzad
			[2435] = {75, 0, 75},--Sylvanas Windrunner
			--Sepulcher of the First Ones
			[2512] = {},--Vigilant Guardian
			[2542] = {75},--Skolex, the Insatiable Ravener
			[2553] = {75},--Artificer Xy'mox
			[2540] = {75},--Dausegne, the Fallen Oracle
			[2544] = {75},--Prototype Pantheon
			[2539] = {75, 75},--Lihuvim, Principal Architect
			[2529] = {75, 75},--Halondrus the Reclaimer (unknown, 75s are placeholders)
			[2546] = {75, 75, 75},--Anduin Wrynn
			[2543] = {0, 0},--Lords of Dread (only cast once per phase cycle so no in between casts timers)
			[2549] = {0, 0},--Rygelon
			[2537] = {0, 0, 0, 0},--The Jailer (used on pull basically)
		},
		[1] = {--Initial pull/new stages (pull count reduced by 1 due to delayed start)
			--Castle Nathria
			[2418] = {4.8},--Huntsman Altimor
			[2412] = {4.8, 3.2},--Council of Blood
			[2402] = {4.8},--Kael
			[2398] = {},--Shriekwing
			[2405] = {4.8},--Artificer XyMox
			[2383] = {4.8},--Hungering Destroyer
			[2406] = {4.8},--Lady Inerva Darkvein
			[2399] = {24.9},--Sludgefist
			[2417] = {4.8},--Stoneborne Generals
			[2407] = {24, 10.5, 29.5},--Sire Denathrius (sometimes sire will skip first cast in stage 2)
			--Sanctum of Domination
			[2423] = {4.8},--The Tarragrue
			[2433] = {4.8, 0, 24.8},--The Eye of the Jailer
			[2429] = {},--The Nine
			[2432] = {4.8},--Remnant of Ner'zhul
			[2434] = {4.8},--Soulrender Dormazain
			[2430] = {4.8, 10.6, 10.6},--Painsmith Raznal
			[2436] = {},--Guardian of the First Ones
			[2431] = {4.8, 10, 10},--Fatescribe Roh-Kalo
			[2422] = {4.8, 5},--Kel'Thuzad
			[2435] = {4.8, 16.5, 20.3},--Sylvanas Windrunner
			--Sepulcher of the First Ones
			[2512] = {},--Vigilant Guardian
			[2542] = {4.8},--Skolex, the Insatiable Ravener
			[2553] = {4.8},--Artificer Xy'mox
			[2540] = {4.8},--Dausegne, the Fallen Oracle
			[2544] = {4.8},--Prototype Pantheon
			[2539] = {4.8, 24.4},--Lihuvim, Principal Architect
			[2529] = {4.8, 11},--Halondrus the Reclaimer
			[2546] = {4.8, 8.6, 11.5},--Anduin Wrynn
			[2543] = {10, 9.1},--Lords of Dread
			[2549] = {0, 14.7},--Rygelon
			[2537] = {1, 1, 14, 0},--The Jailer (basically used immeddiately on 3 of the 4 stages)
		},
	},
	[372642] = {-- Chaotic Essence
		[0] = {--Repeating Timer
			--Castle Nathria
			[2418] = {58.8},--Huntsman Altimor
			[2412] = {58.8, 58.8},--Council of Blood
			[2402] = {58.8, 58.8},--Kael
			[2398] = {58.8, 58.8},--Shriekwing
			[2405] = {58.8},--Artificer XyMox
			[2383] = {58.8},--Hungering Destroyer
			[2406] = {58.8},--Lady Inerva Darkvein
			[2399] = {67.9},--Sludgefist
			[2417] = {58.8},--Stoneborne Generals
			[2407] = {58.8, 79.3, 58.8},--Sire Denathrius (P2 is 80-85)
			--Sanctum of Domination
			[2423] = {},--The Tarragrue
			[2433] = {54.7, 54.7, 54.7},--The Eye of the Jailer
			[2429] = {58.8},--The Nine
			[2432] = {58.8},--Remnant of Ner'zhul
			[2434] = {},--Soulrender Dormazain
			[2430] = {58.8, 58.8, 58.8},--Painsmith Raznal
			[2436] = {0, 0},--Guardian of the First Ones
			[2431] = {},--Fatescribe Roh-Kalo (Unknown betweens, fights pulls getting shorter)
			[2422] = {58.8, 58.8},--Kel'Thuzad
			[2435] = {58.8, 0, 58.8},--Sylvanas Windrunner (stage 2 timers are chaotic and not quite figured out yet, so disabled)
			--Sepulcher of the First Ones
			[2512] = {58.8},--Vigilant Guardian
			[2542] = {58.8},--Skolex, the Insatiable Ravener
			[2553] = {58.8},--Artificer Xy'mox
			[2540] = {},--Dausegne, the Fallen Oracle
			[2544] = {58.8},--Prototype Pantheon
			[2539] = {58.8, 58.8},--Lihuvim, Principal Architect (not cast twice in any stage, used once per phasing cycle)
			[2529] = {80, 80},--Halondrus the Reclaimer
			[2546] = {58.8, 58.8, 58.8},--Anduin Wrynn
			[2543] = {0, 0},--Lords of Dread
			[2549] = {0, 0},--Rygelon (has no CD, it's just synced to singularity stage beginnings and not recast any other time)
			[2537] = {0, 0, 0, 0},--The Jailer
		},
		[1] = {--Initial pull/new stages (pull count reduced by 1 due to delayed start)
			--Castle Nathria
			[2418] = {11},--Huntsman Altimor
			[2412] = {11, 9.3},--Council of Blood
			[2402] = {11},--Kael
			[2398] = {11, 12.4},--Shriekwing
			[2405] = {11},--Artificer XyMox
			[2383] = {11},--Hungering Destroyer
			[2406] = {11},--Lady Inerva Darkvein
			[2399] = {32.5},--Sludgefist
			[2417] = {11},--Stoneborne Generals
			[2407] = {37, 21, 35.9},--Sire Denathrius
			--Sanctum of Domination
			[2423] = {},--The Tarragrue
			[2433] = {11, 3.3, 35.1},--The Eye of the Jailer
			[2429] = {11},--The Nine
			[2432] = {11},--Remnant of Ner'zhul
			[2434] = {},--Soulrender Dormazain
			[2430] = {11, 17.3, 17.3},--Painsmith Raznal
			[2436] = {41.1, 38.6},--Guardian of the First Ones
			[2431] = {11, 17.1, 17.1},--Fatescribe Roh-Kalo
			[2422] = {11, 11.2},--Kel'Thuzad
			[2435] = {11, 0, 26},--Sylvanas Windrunner (stage 2 timers are chaotic and not quite figured out yet, so disabled)
			--Sepulcher of the First Ones
			[2512] = {11},--Vigilant Guardian
			[2542] = {11},--Skolex, the Insatiable Ravener
			[2553] = {11},--Artificer Xy'mox
			[2540] = {},--Dausegne, the Fallen Oracle
			[2544] = {11},--Prototype Pantheon
			[2539] = {11, 30},--Lihuvim, Principal Architect
			[2529] = {11, 17.4},--Halondrus the Reclaimer
			[2546] = {11, 14.5, 0},--Anduin Wrynn (3rd unknown, since most are bugging out affix 3rd reset by skipping one of grasp events)
			[2543] = {16.2, 15.2},--Lords of Dread
			[2549] = {0, 18.2},--Rygelon (Seems to still vary a bit)
			[2537] = {2.2, 3.5, 15, 2},--The Jailer
		},

	},
	[372418] = {--Barrier
		[0] = {--Repeating Timer
			--Castle Nathria
			[2418] = {},--Huntsman Altimor
			[2412] = {60, 60, 60},--Council of Blood
			[2402] = {60},--Kael (always 60 but reflection of guilt fading causes an ICD that delays current cast, but not one after it)
			[2398] = {60, 60},--Shriekwing
			[2405] = {60},--Artificer XyMox
			[2383] = {60},--Hungering Destroyer
			[2406] = {60},--Lady Inerva Darkvein
			[2399] = {70},--Sludgefist
			[2417] = {60},--Stoneborne Generals
			[2407] = {56.9, 79.9, 70},--Sire Denathrius
			--Sanctum of Domination
			[2423] = {60},--The Tarragrue
			[2433] = {60, 60, 60},--The Eye of the Jailer
			[2429] = {60},--The Nine
			[2432] = {},--Remnant of Ner'zhul
			[2434] = {60},--Soulrender Dormazain
			[2430] = {60, 60, 60},--Painsmith Raznal
			[2436] = {0, 0},--Guardian of the First Ones
			[2431] = {},--Fatescribe Roh-Kalo
			[2422] = {60, 60},--Kel'Thuzad
			[2435] = {60, 0, 60},--Sylvanas Windrunner
			--Sepulcher of the First Ones
			[2512] = {60},--Vigilant Guardian
			[2542] = {},--Skolex, the Insatiable Ravener
			[2553] = {60},--Artificer Xy'mox
			[2540] = {60},--Dausegne, the Fallen Oracle
			[2544] = {60},--Prototype Pantheon
			[2539] = {0, 60},--Lihuvim, Principal Architect
			[2529] = {60, 60},--Halondrus the Reclaimer
			[2546] = {60, 60, 60},--Anduin Wrynn
			[2543] = {0, 0},--Lords of Dread (no in between casts, since it's reset by both bosses specials)
			[2549] = {0, 0},--Rygelon
			[2537] = {0, 0, 0, 0},--The Jailer
		},
		[1] = {--Initial pull/new stages (pull count reduced by 1 due to delayed start)
			--Castle Nathria
			[2418] = {},--Huntsman Altimor
			[2412] = {14.8, 13.7},--Council of Blood
			[2402] = {14.8},--Kael
			[2398] = {14.8, 15},--Shriekwing
			[2405] = {14.8},--Artificer XyMox
			[2383] = {14.8},--Hungering Destroyer
			[2406] = {14.8},--Lady Inerva Darkvein
			[2399] = {34.9},--Sludgefist
			[2417] = {14.8},--Stoneborne Generals
			[2407] = {1, 14.4, 44.5},--Sire Denathrius (used near instantly on pull)
			--Sanctum of Domination
			[2423] = {14.8},--The Tarragrue
			[2433] = {14.8, 30.4, 4.3},--The Eye of the Jailer
			[2429] = {14.8},--The Nine
			[2432] = {},--Remnant of Ner'zhul
			[2434] = {14.8},--Soulrender Dormazain
			[2430] = {14.8, 21, 20.3},--Painsmith Raznal
			[2436] = {24.9, 22},--Guardian of the First Ones
			[2431] = {},--Fatescribe Roh-Kalo
			[2422] = {14.8, 15},--Kel'Thuzad
			[2435] = {14.8, 0, 30},--Sylvanas Windrunner
			--Sepulcher of the First Ones
			[2512] = {14.8},--Vigilant Guardian
			[2542] = {},--Skolex, the Insatiable Ravener
			[2553] = {14.8},--Artificer Xy'mox
			[2540] = {14.8},--Dausegne, the Fallen Oracle
			[2544] = {14.8},--Prototype Pantheon
			[2539] = {14.8, 34.4},--Lihuvim, Principal Architect
			[2529] = {14.8, 21, 21},--Halondrus the Reclaimer
			[2546] = {14.8, 18.6, 22.1},--Anduin Wrynn
			[2543] = {20, 19},--Lords of Dread
			[2549] = {0, 14.7},--Rygelon (only used after big bang)
			[2537] = {0, 0, 14, 0},--The Jailer
		},

	},
	[372647] = {-- Creation Spark
		[0] = {--Repeating Timer
			--Castle Nathria
			[2418] = {44.9},--Huntsman Altimor
			[2412] = {44.9, 44.9},--Council of Blood
			[2402] = {44.9, 44.9},--Kael
			[2398] = {44.9, 44.9},--Shriekwing
			[2405] = {44.9},--Artificer XyMox
			[2383] = {44.9},--Hungering Destroyer
			[2406] = {44.9},--Lady Inerva Darkvein
			[2399] = {68.3},--Sludgefist (one of few bosses that has a diff timer)
			[2417] = {44.9},--Stoneborne Generals
			[2407] = {57.9, 84.9, 70},--Sire Denathrius
			--Sanctum of Domination
			[2423] = {44.9},--The Tarragrue
			[2433] = {},--The Eye of the Jailer
			[2429] = {44.9},--The Nine
			[2432] = {44.9},--Remnant of Ner'zhul
			[2434] = {44.9},--Soulrender Dormazain
			[2430] = {},--Painsmith Raznal
			[2436] = {0, 0},--Guardian of the First Ones (unknown, since the stage resetting it are far more likely than seeing it twice)
			[2431] = {80, 80, 80},--Fatescribe Roh-Kalo (first one known, guessed to match same as other 2)
			[2422] = {44.9, 44.9},--Kel'Thuzad
			[2435] = {44.9, 0, 44.9},--Sylvanas Windrunner
			--Sepulcher of the First Ones
			[2512] = {44.9},--Vigilant Guardian
			[2542] = {44.9},--Skolex, the Insatiable Ravener
			[2553] = {44.9},--Artificer Xy'mox
			[2540] = {44.9},--Dausegne, the Fallen Oracle
			[2544] = {44.9},--Prototype Pantheon
			[2539] = {0, 44.9},--Lihuvim, Principal Architect
			[2529] = {44.9, 44.9},--Halondrus the Reclaimer
			[2546] = {44.9, 44.9, 44.9},--Anduin Wrynn
			[2543] = {0, 0},--Lords of Dread
			[2549] = {0, 0},--Rygelon
			[2537] = {44.9, 44.9, 44.9, 44.9},--The Jailer (stage 4 not yet known)
		},
		[1] = {--Initial pull/new stages (pull count reduced by 1 due to delayed start)
			--Castle Nathria
			[2418] = {19.9},--Huntsman Altimor
			[2412] = {19.9, 18.2},--Council of Blood
			[2402] = {19.9},--Kael
			[2398] = {19.9, 20},--Shriekwing
			[2405] = {19.9},--Artificer XyMox
			[2383] = {19.9},--Hungering Destroyer
			[2406] = {19.9},--Lady Inerva Darkvein
			[2399] = {39.9},--Sludgefist
			[2417] = {19.9},--Stoneborne Generals
			[2407] = {3, 24.5, 39.5},--Sire Denathrius
			--Sanctum of Domination
			[2423] = {19.9},--The Tarragrue
			[2433] = {},--The Eye of the Jailer
			[2429] = {19.9},--The Nine
			[2432] = {19.9},--Remnant of Ner'zhul
			[2434] = {19.9},--Soulrender Dormazain
			[2430] = {},--Painsmith Raznal
			[2436] = {30, 27},--Guardian of the First Ones
			[2431] = {19.9, 25.5, 24.7},--Fatescribe Roh-Kalo
			[2422] = {19.9, 20},--Kel'Thuzad
			[2435] = {19.9, 0, 35.3},--Sylvanas Windrunner
			--Sepulcher of the First Ones
			[2512] = {19.9},--Vigilant Guardian
			[2542] = {19.9},--Skolex, the Insatiable Ravener
			[2553] = {19.9},--Artificer Xy'mox
			[2540] = {19.9},--Dausegne, the Fallen Oracle
			[2544] = {19.9},--Prototype Pantheon
			[2539] = {19.9, 39.8},--Lihuvim, Principal Architect
			[2529] = {19.9, 26},--Halondrus the Reclaimer
			[2546] = {19.9, 23.6, 26.6},--Anduin Wrynn
			[2543] = {24.9, 23.9},--Lords of Dread
			[2549] = {0, 5.1},--Rygelon
			[2537] = {3.5, 3.4, 16.5, 3},--The Jailer (stage 4 used to be cast immediately, but now 3 seconds, or maybe that was due to 2nd affix, unsure)
		},

	},
}

do
	--Callback handler too update timers without registering duplicate CLEU events in affixes mod.
	local function dbmEventCallback(event, ...)
		if event == "DBM_AffixEvent" then
			--eventType 0 = Stop, eventType 1 = Start, eventType 2 = extend due to spell queue/delay
			local _, _, eventType, encounterID, stage, timeAdjust, spellDebit = ...
			if activeBosses[encounterID] then
				stage = stage or 1
				activeBosses[encounterID] = stage
				if activeAffixes[372419] then--Fated Power: Reconfiguration Emitter
					if eventType == 0 then
						timerReconfigurationEmitterCD:Stop()
					elseif eventType == 1 and specialTimers[372419][1][encounterID][stage] then
						timerReconfigurationEmitterCD:Restart(specialTimers[372419][1][encounterID][stage])
					elseif timeAdjust and eventType == 2 then
						if timerReconfigurationEmitterCD:GetRemaining() < timeAdjust then
							local elapsed, total = timerReconfigurationEmitterCD:GetTime()
							local extend = timeAdjust - (total-elapsed)
							DBM:Debug("timerReconfigurationEmitterCD extended by: "..extend, 2)
							timerReconfigurationEmitterCD:Update(elapsed, total+extend)
							if spellDebit then--The extended timer is debited from next cast
								borrowedTime[372419] = extend
							end
						end
					end
				end
				if activeAffixes[372642] then--Fated Power: Chaotic Essence
					if eventType == 0 then
						timerChaoticEssenceCD:Stop()
					elseif eventType == 1 and specialTimers[372642][1][encounterID][stage] then
						timerChaoticEssenceCD:Restart(specialTimers[372642][1][encounterID][stage])
					elseif timeAdjust and eventType == 2 then
						if timerChaoticEssenceCD:GetRemaining() < timeAdjust then
							local elapsed, total = timerChaoticEssenceCD:GetTime()
							local extend = timeAdjust - (total-elapsed)
							DBM:Debug("timerChaoticEssenceCD extended by: "..extend, 2)
							timerChaoticEssenceCD:Update(elapsed, total+extend)
							if spellDebit then--The extended timer is debited from next cast
								borrowedTime[372642] = extend
							end
						end
					end
				end
				if activeAffixes[372418] then--Fated Power: Protoform Barrier
					if eventType == 0 then
						timerProtoformBarrierCD:Stop()
					elseif eventType == 1 and specialTimers[372418][1][encounterID][stage] then
						timerProtoformBarrierCD:Restart(specialTimers[372418][1][encounterID][stage])
					elseif timeAdjust and eventType == 2 then
						if timerProtoformBarrierCD:GetRemaining() < timeAdjust then
							local elapsed, total = timerProtoformBarrierCD:GetTime()
							local extend = timeAdjust - (total-elapsed)
							DBM:Debug("timerProtoformBarrierCD extended by: "..extend, 2)
							timerProtoformBarrierCD:Update(elapsed, total+extend)
							if spellDebit then--The extended timer is debited from next cast
								borrowedTime[372418] = extend
							end
						end
					end
				end
				if activeAffixes[372647] then--Fated Power: Creation Spark
					if eventType == 0 then
						timerCreationSparkCD:Stop()
					elseif eventType == 1 and specialTimers[372647][1][encounterID][stage] then
						timerCreationSparkCD:Restart(specialTimers[372647][1][encounterID][stage])
					elseif timeAdjust and eventType == 2 then
						if timerCreationSparkCD:GetRemaining() < timeAdjust then
							local elapsed, total = timerCreationSparkCD:GetTime()
							local extend = timeAdjust - (total-elapsed)
							DBM:Debug("timerCreationSparkCD extended by: "..extend, 2)
							timerCreationSparkCD:Update(elapsed, total+extend)
							if spellDebit then--The extended timer is debited from next cast
								borrowedTime[372647] = extend
							end
						end
					end
				end
			end
		end
	end
	DBM:RegisterCallback("DBM_AffixEvent", dbmEventCallback)
end

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 372638 and self:AntiSpam(3, 1) then
		warnChaoticDestruction:Show()
		local encounterID = activeAffixes[372642]
		local stage = activeBosses[encounterID] or 1
		local timer = encounterID and specialTimers[372642][0][encounterID][stage] or 58.8
		if borrowedTime[372642] then
			timerChaoticEssenceCD:Start(timer-borrowedTime[372642])
			borrowedTime[372642] = nil
		else
			timerChaoticEssenceCD:Start(timer)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 372634 then
		warnChaoticEssence:Show()
	end
end

function mod:SPELL_SUMMON(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 371254 and self:AntiSpam(3, 2) then
		warnReconfigurationEmitter:Show()
		local encounterID = activeAffixes[372419]
		local stage = activeBosses[encounterID] or 1
		local timer = encounterID and specialTimers[372419][0][encounterID][stage]--No or rule for now since no fights are agreeable on good base
		if timer then
			if borrowedTime[372419] then
				timerReconfigurationEmitterCD:Start(timer-borrowedTime[372419])
				borrowedTime[372419] = nil
			else
				timerReconfigurationEmitterCD:Start(timer)
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 369505 then
		warnCreationSpark:CombinedShow(0.3, args.destName)
		if self:AntiSpam(3, 3) then
			local encounterID = activeAffixes[372647]
			local stage = activeBosses[encounterID] or 1
			local timer = encounterID and specialTimers[372647][0][encounterID][stage] or 44.9
			if borrowedTime[372647] then
				timerCreationSparkCD:Start(timer-borrowedTime[372647])
				borrowedTime[372647] = nil
			else
				timerCreationSparkCD:Start(timer)
			end
		end
		if args:IsPlayer() then
			specWarnCreationSpark:Show()
			specWarnCreationSpark:Play("targetyou")
		end
	elseif spellId == 371447 and args:IsDestTypeHostile() then
		warnProtoformBarrier:Show(args.destName)
		local encounterID = activeAffixes[372418]
		local stage = activeBosses[encounterID] or 1
		local timer = encounterID and specialTimers[372418][0][encounterID][stage]--No or rule for now since no fights are agreeable on good base
		if timer then
			if borrowedTime[372418] then
				timerProtoformBarrierCD:Start(timer-borrowedTime[372418])
				borrowedTime[372418] = nil
			else
				timerProtoformBarrierCD:Start(timer)
			end
		end
--	elseif (spellId == 371597) and self:AntiSpam(3, 6) then
--		warnProtoformBarrier:Show(DBM_COMMON_L.ENEMIES)
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 369505 and self:AntiSpam(5, 2) then
		specWarnCreationSparkSoak:Show()
		specWarnCreationSparkSoak:Play("helpsoak")
	end
end

do
	local function CheckBosses(eID, delay)
		local found = false
		for i = 1, 8 do
			local unitID = "boss"..i
			local unitGUID = UnitGUID(unitID)
			if UnitExists(unitID) then
				--Currently it's only possible for bosses to have one of them
				--However, we don't elseif rule it because it future proofs support for a case boss might later support 2+
				--Code will break if more than one boss pulled at same time with same affix though
				--All timers are minus 1
				if DBM:UnitBuff(unitID, 372419) and not activeAffixes[372419] then--Fated Power: Reconfiguration Emitter
					found = true
					activeAffixes[372419] = eID
					borrowedTime[372419] = nil
					local timer = (specialTimers[372419][1][eID][1] or 4.9)-delay
					if timer > 0 then
						timerReconfigurationEmitterCD:Start(timer)
					end
				end
				if DBM:UnitBuff(unitID, 372642) and not activeAffixes[372642] then--Fated Power: Chaotic Essence
					found = true
					activeAffixes[372642] = eID
					borrowedTime[372642] = nil
					local timer = (specialTimers[372642][1][eID][1] or 11)-delay
					if timer > 0 then
						timerChaoticEssenceCD:Start(timer)
					end
				end
				if DBM:UnitBuff(unitID, 372418) and not activeAffixes[372418] then--Fated Power: Protoform Barrier
					found = true
					activeAffixes[372418] = eID
					borrowedTime[372418] = nil
					local timer = (specialTimers[372418][1][eID][1] or 15)-delay
					if timer > 0 then
						timerProtoformBarrierCD:Start(timer)
					end
				end
				if DBM:UnitBuff(unitID, 372647) and not activeAffixes[372647] then--Fated Power: Creation Spark
					found = true
					activeAffixes[372647] = eID
					borrowedTime[372647] = nil
					local timer = (specialTimers[372647][1][eID][1] or 19.9)-delay
					if timer > 0 then
						timerCreationSparkCD:Start(timer)
					end
				end
				if found then
					activeBosses[eID] = 1
				end
			end
		end
		if not found then
			--Failed to find any affix on any boss ID, in a raid that's fated, try again after delay
			if delay < 10 then
				mod:Unschedule(CheckBosses, eID)
				mod:Schedule(2, CheckBosses, eID, delay+2)
			else
				if not activeBosses[eID] then
					DBM:Debug("Failed to detect Fated affix after 10 seconds of scanning, notify DBM authors with this ID: "..eID)
				end
			end
		end
	end

	function mod:ENCOUNTER_START(eID)
		if not self:IsFated() then return end
		--Delay check to make sure INSTANCE_ENCOUNTER_ENGAGE_UNIT has fired and boss unit Ids are valid
		--Yet we avoid using INSTANCE_ENCOUNTER_ENGAGE_UNIT directly since that increases timer start variation versus ENCOUNTER_START by a few milliseconds
		self:Unschedule(CheckBosses, eID)
		self:Schedule(2, CheckBosses, eID, 1)
	end

	function mod:ENCOUNTER_END(eID)
		--Carefully only terminate fated timers if fated was active for fight and specific affix was active for fight
		--This way we can try to avoid canceling timers for other fights that might be engaged at same time
		self:Unschedule(CheckBosses, eID)
		if activeBosses[eID] then
			if activeAffixes[372419] then--Fated Power: Reconfiguration Emitter
				activeAffixes[372419] = nil
				borrowedTime[372419] = nil
				timerReconfigurationEmitterCD:Stop()
			end
			if activeAffixes[372642] then--Fated Power: Chaotic Essence
				activeAffixes[372642] = nil
				borrowedTime[372642] = nil
				timerChaoticEssenceCD:Stop()
			end
			if activeAffixes[372418] then--Fated Power: Protoform Barrier
				activeAffixes[372418] = nil
				borrowedTime[372418] = nil
				timerProtoformBarrierCD:Stop()
			end
			if activeAffixes[372647] then--Fated Power: Creation Spark
				activeAffixes[372647] = nil
				borrowedTime[372647] = nil
				timerCreationSparkCD:Stop()
			end
			activeBosses[eID] = nil
		end
	end
end


--[[
function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 209862 and destGUID == UnitGUID("player") and self:AntiSpam(3, 7) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE
--]]
