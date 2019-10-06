local L

----------------------------------
--  Ahn'Kahet: The Old Kingdom  --
----------------------------------
--  Prince Taldaram  --
-----------------------
L = DBM:GetModLocalization(581)

-------------------
--  Elder Nadox  --
-------------------
L = DBM:GetModLocalization(580)

---------------------------
--  Jedoga Shadowseeker  --
---------------------------
L = DBM:GetModLocalization(582)

---------------------
--  Herald Volazj  --
---------------------
L = DBM:GetModLocalization(584)

----------------
--  Amanitar  --
----------------
L = DBM:GetModLocalization(583)

-------------------
--  Azjol-Nerub  --
---------------------------------
--  Krik'thir the Gatewatcher  --
---------------------------------
L = DBM:GetModLocalization(585)

----------------
--  Hadronox  --
----------------
L = DBM:GetModLocalization(586)

-------------------------
--  Anub'arak (Party)  --
-------------------------
L = DBM:GetModLocalization(587)

---------------------------------------
--  Caverns of Time: Old Stratholme  --
---------------------------------------
--  Meathook  --
----------------
L = DBM:GetModLocalization(611)

--------------------------------
--  Salramm the Fleshcrafter  --
--------------------------------
L = DBM:GetModLocalization(612)

-------------------------
--  Chrono-Lord Epoch  --
-------------------------
L = DBM:GetModLocalization(613)

-----------------
--  Mal'Ganis  --
-----------------
L = DBM:GetModLocalization(614)

L:SetMiscLocalization({
	Outro	= "Your journey has just begun, young prince. Gather your forces and meet me in the arctic land of Northrend. It is there that we shall settle the score between us. It is there that your true destiny will unfold."
})

-------------------
--  Wave Timers  --
-------------------
L = DBM:GetModLocalization("StratWaves")

L:SetGeneralLocalization({
	name = "Stratholme Waves"
})

L:SetWarningLocalization({
	WarningWaveNow = "Wave %d: %s spawned"
})

L:SetTimerLocalization({
	TimerWaveIn		= "Next wave (6)",
	TimerRoleplay	= "Arthas roleplay"
})

L:SetOptionLocalization({
	WarningWaveNow	= "Show warning for new wave",
	TimerWaveIn		= "Show timer for next set of waves (after wave 5 boss)",
	TimerRoleplay	= "Show timer for opening roleplay event."
})

L:SetMiscLocalization({
	Devouring	= "Devouring Ghoul",
	Enraged		= "Enraging Ghoul",
	Necro		= "Necromancer",
	Fiend		= "Crypt Fiend",
	Stalker		= "Tomb Stalker",
	Abom		= "Patchwork Construct",
	Acolyte		= "Acolyte",
	Wave1		= "%d %s",
	Wave2		= "%d %s and %d %s",
	Wave3		= "%d %s, %d %s and %d %s",
	Wave4		= "%d %s, %d %s, %d %s and %d %s",
	WaveBoss	= "%s",
	Roleplay	= "Glad you could make it, Uther.",
	Roleplay2	= "Everyone looks ready. Remember, these people are all infected with the plague and will die soon. We must purge Stratholme to protect the remainder of Lordaeron from the Scourge. Let's go."
})

------------------------
--  Drak'Tharon Keep  --
------------------------
--  Trollgore  --
-----------------
L = DBM:GetModLocalization(588)

--------------------------
--  Novos the Summoner  --
--------------------------
L = DBM:GetModLocalization(589)

L:SetMiscLocalization({
	YellPull		= "The chill you feel is the herald of your doom!",
	HandlerYell		= "Bolster my defenses! Hurry, curse you!",
	Phase2			= "Surely you can see the futility of it all!",
	YellKill		= "Your efforts... are in vain."
})

-----------------
--  King Dred  --
-----------------
L = DBM:GetModLocalization(590)

-----------------------------
--  The Prophet Tharon'ja  --
-----------------------------
L = DBM:GetModLocalization(591)

---------------
--  Gundrak  --
----------------
--  Slad'ran  --
----------------
L = DBM:GetModLocalization(592)

---------------
--  Moorabi  --
---------------
L = DBM:GetModLocalization(594)

-------------------------
--  Drakkari Colossus  --		
-------------------------
L = DBM:GetModLocalization(593)

-----------------
--  Gal'darah  --
-----------------
L = DBM:GetModLocalization(596)

-------------------------
--  Eck the Ferocious  --
-------------------------
L = DBM:GetModLocalization(595)

--------------------------
--  Halls of Lightning  --
--------------------------
--  General Bjarngrim  --
-------------------------
L = DBM:GetModLocalization(597)

-------------
--  Ionar  --
-------------
L = DBM:GetModLocalization(599)

---------------
--  Volkhan  --
---------------
L = DBM:GetModLocalization(598)

-------------
--  Loken  --
-------------
L = DBM:GetModLocalization(600)

----------------------
--  Halls of Stone  --
-----------------------
--  Maiden of Grief  --
-----------------------
L = DBM:GetModLocalization(605)

------------------
--  Krystallus  --
------------------
L = DBM:GetModLocalization(604)

------------------------------
--  Sjonnir the Ironshaper  --
------------------------------
L = DBM:GetModLocalization(607)

--------------------------------------
--  Brann Bronzebeard Escort Event  --
--------------------------------------
L = DBM:GetModLocalization(606)

L:SetWarningLocalization({
	WarningPhase	= "Phase %d"
})

L:SetTimerLocalization({
	timerEvent	= "Time remaining"
})

L:SetOptionLocalization({
	WarningPhase	= "Show warning for phase change",
	timerEvent		= "Show timer for event duration"
})

L:SetMiscLocalization({
	Pull	= "Now keep an eye out! I'll have this licked in two shakes of a--",
	Phase1	= "Security breach in progress. Analysis of historical archives transferred to lower-priority queue. Countermeasures engaged.",
	Phase2	= "Threat index threshold exceeded.  Celestial archive aborted. Security level heightened.",
	Phase3	= "Critical threat index. Void analysis diverted. Initiating sanitization protocol.",
	Kill	= "Alert: security fail-safes deactivated. Beginning memory purge and... "
})

-----------------
--  The Nexus  --
-----------------
--  Anomalus  --
----------------
L = DBM:GetModLocalization(619)

-------------------------------
--  Ormorok the Tree-Shaper  --
-------------------------------
L = DBM:GetModLocalization(620)

----------------------------
--  Grand Magus Telestra  --
----------------------------
L = DBM:GetModLocalization(618)

L:SetMiscLocalization({
	SplitTrigger1		= "There's plenty of me to go around.",			-- translate
	SplitTrigger2		= "I'll give you more than you can handle."		-- translate
})

-------------------
--  Keristrasza  --
-------------------
L = DBM:GetModLocalization(621)

-----------------------------------
--  Commander Kolurg/Stoutbeard  --
-----------------------------------
L = DBM:GetModLocalization("Commander")

local commander = "Unknown"
if UnitFactionGroup("player") == "Alliance" then
	commander = "Commander Kolurg"
elseif UnitFactionGroup("player") == "Horde" then
	commander = "Commander Stoutbeard"
end

L:SetGeneralLocalization({
	name = commander
})

------------------
--  The Oculus  --
-------------------------------
--  Drakos the Interrogator  --
-------------------------------
L = DBM:GetModLocalization(622)

L:SetOptionLocalization({
	MakeitCountTimer	= "Show timer for Make It Count (achievement)"
})

L:SetMiscLocalization({
	MakeitCountTimer	= "Make It Count"
})

----------------------
--  Mage-Lord Urom  --
----------------------
L = DBM:GetModLocalization(624)

L:SetMiscLocalization({
	CombatStart		= "Poor blind fools!"
})

--------------------------
--  Varos Cloudstrider  --
--------------------------
L = DBM:GetModLocalization(623)

---------------------------
--  Ley-Guardian Eregos  --
---------------------------
L = DBM:GetModLocalization(625)

L:SetMiscLocalization({
	MakeitCountTimer	= "Make It Count"
})

--------------------
--  Utgarde Keep  --
-----------------------
--  Prince Keleseth  --
-----------------------
L = DBM:GetModLocalization(638)

--------------------------------
--  Skarvald the Constructor  --
--  & Dalronn the Controller  --
--------------------------------
L = DBM:GetModLocalization(639)

----------------------------
--  Ingvar the Plunderer  --
----------------------------
L = DBM:GetModLocalization(640)

L:SetMiscLocalization({
	YellCombatEnd	= "No! I can do... better! I can..."
})

------------------------
--  Utgarde Pinnacle  --
--------------------------
--  Skadi the Ruthless  --
--------------------------
L = DBM:GetModLocalization(643)

L:SetMiscLocalization({
	CombatStart		= "What mongrels dare intrude here? Look alive, my brothers!  A feast for the one that brings me their heads!",
	Phase2			= "You motherless knaves! Your corpses will make fine morsels for my new drake!"
})

-------------------
--  King Ymiron  --
-------------------
L = DBM:GetModLocalization(644)

-------------------------
--  Svala Sorrowgrave  --
-------------------------
L = DBM:GetModLocalization(641)

L:SetTimerLocalization({
	timerRoleplay		= "Svala Sorrowgrave active"
})

L:SetOptionLocalization({
	timerRoleplay		= "Show timer for roleplay before Svala Sorrowgrave becomes active"
})

L:SetMiscLocalization({
	SvalaRoleplayStart	= "My liege! I have done as you asked, and now beseech you for your blessing!"
})

-----------------------
--  Gortok Palehoof  --
-----------------------
L = DBM:GetModLocalization(642)

-----------------------
--  The Violet Hold  --
-----------------------
--  Cyanigosa  --
-----------------
L = DBM:GetModLocalization(632)

L:SetMiscLocalization({
	CyanArrived	= "A valiant defense, but this city must be razed. I will fulfill Malygos's wishes myself!"
})

--------------
--  Erekem  --
--------------
L = DBM:GetModLocalization(626)

---------------
--  Ichoron  --
---------------
L = DBM:GetModLocalization(628)

-----------------
--  Lavanthor  --
-----------------
L = DBM:GetModLocalization(630)

--------------
--  Moragg  --
--------------
L = DBM:GetModLocalization(627)

--------------
--  Xevozz  --
--------------
L = DBM:GetModLocalization(629)

-------------------------------
--  Zuramat the Obliterator  --
-------------------------------
L = DBM:GetModLocalization(631)

---------------------
--  Portal Timers  --
---------------------
L = DBM:GetModLocalization("PortalTimers")

L:SetGeneralLocalization({
	name = "Portal Timers"
})

L:SetWarningLocalization({
	WarningPortalSoon	= "New portal soon",
	WarningPortalNow	= "Portal #%d",
	WarningBossNow		= "Boss incoming"
})

L:SetTimerLocalization({
	TimerPortalIn	= "Portal #%d", 
})

L:SetOptionLocalization({
	WarningPortalNow		= "Show warning for new portal",
	WarningPortalSoon		= "Show pre-warning for new portal",
	WarningBossNow			= "Show warning for boss incoming",
	TimerPortalIn			= "Show timer for next portal (after Boss)",
	ShowAllPortalTimers		= "Show timers for all portals (inaccurate)"
})

L:SetMiscLocalization({
	Sealbroken	= "We've broken through the prison gate! The way into Dalaran is clear! Now we finally put an end to the Nexus War!"
})

-----------------------------
--  Trial of the Champion  --
-----------------------------
--  The Black Knight  --
------------------------
L = DBM:GetModLocalization(637)

L:SetOptionLocalization({
	AchievementCheck		= "Announce 'I've Had Worse' achievement failure to party"
})

L:SetMiscLocalization({
	Pull				= "Well done. You have proven yourself today-",
	AchievementFailed	= ">> ACHIEVEMENT FAILED: %s was hit by Ghoul Explode <<",
	YellCombatEnd		= "My congratulations, champions. Through trials both planned and unexpected, you have triumphed."	-- can also be "No! I must not fail... again ..."
})

-----------------------
--  Grand Champions  --
-----------------------
L = DBM:GetModLocalization(634)

L:SetMiscLocalization({
	YellCombatEnd	= "Well fought! Your next challenge comes from the Crusade's own ranks. You will be tested against their considerable prowess."
})

----------------------------------
--  Argent Confessor Paletress  --
----------------------------------
L = DBM:GetModLocalization(636)

L:SetMiscLocalization({
	YellCombatEnd	= "Excellent work!"
})

-----------------------
--  Eadric the Pure  --
-----------------------
L = DBM:GetModLocalization(635)

L:SetMiscLocalization({
	YellCombatEnd	= "I yield! I submit. Excellent work. May I run away now?"
})

--------------------
--  Pit of Saron  --
---------------------
--  Ick and Krick  --
---------------------
L = DBM:GetModLocalization(609)

L:SetMiscLocalization({
	Barrage	= "%s begins rapidly conjuring explosive mines!"
})

----------------------------
--  Forgemaster Garfrost  --
----------------------------
L = DBM:GetModLocalization(608)

L:SetOptionLocalization({
	AchievementCheck			= "Announce 'Doesn't Go to Eleven' achievement warnings to party"
})

L:SetMiscLocalization({
	SaroniteRockThrow	= "%s hurls a massive saronite boulder at you!",
	AchievementWarning	= "Warning: %s has %d stacks of Permafrost",
	AchievementFailed	= ">> ACHIEVEMENT FAILED: %s has %d stacks of Permafrost <<"
})

----------------------------
--  Scourgelord Tyrannus  --
----------------------------
L = DBM:GetModLocalization(610)

L:SetMiscLocalization({
	CombatStart	= "Alas, brave, brave adventurers, your meddling has reached its end. Do you hear the clatter of bone and steel coming up the tunnel behind you? That is the sound of your impending demise.",
	HoarfrostTarget	= "The frostwyrm Rimefang gazes at (%S+) and readies an icy attack!",
	YellCombatEnd	= "Impossible.... Rimefang.... warn...."
})

----------------------
--  Forge of Souls  --
----------------------
--  Bronjahm  --
----------------
L = DBM:GetModLocalization(615)

-------------------------
--  Devourer of Souls  --
-------------------------
L = DBM:GetModLocalization(616)

---------------------------
--  Halls of Reflection  --
---------------------------
--  Wave Timers  --
-------------------
L = DBM:GetModLocalization("HoRWaveTimer")

L:SetGeneralLocalization({
	name = "Wave Timers"
})

L:SetWarningLocalization({
	WarnNewWaveSoon	= "New wave soon",
	WarnNewWave		= "%s incoming"
})

L:SetTimerLocalization({
	TimerNextWave	= "Next wave"
})

L:SetOptionLocalization({
	WarnNewWave			= "Show warning for boss incoming",
	WarnNewWaveSoon		= "Show pre-warning for new wave (after wave 5 boss)",
	ShowAllWaveWarnings	= "Show warnings for all waves",
	TimerNextWave		= "Show timer for next set of waves (after wave 5 boss)",
	ShowAllWaveTimers	= "Show pre-warning and timers for all waves (Inaccurate)"
})

--------------
--  Falric  --
--------------
L = DBM:GetModLocalization(601)

--------------
--  Marwyn  --
--------------
L = DBM:GetModLocalization(602)

-----------------------
--  Lich King Event  --
-----------------------
L = DBM:GetModLocalization(603)

L:SetWarningLocalization({
	WarnWave		= "%s"
})

L:SetTimerLocalization({
	achievementEscape	= "Time to escape"
})

L:SetOptionLocalization({
	WarnWave	= "Show warning for incoming waves"
})

L:SetMiscLocalization({
	ACombatStart	= "He is too powerful. We must leave this place at once! My magic can hold him in place for only a short time. Come quickly, heroes!",
	HCombatStart	= "He's... too powerful. Heroes, quickly... come to me! We must leave this place at once! I will do what I can to hold him in place while we flee."
})
