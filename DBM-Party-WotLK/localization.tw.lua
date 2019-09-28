if GetLocale() ~= "zhTW" then return end
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
	Outro	= "你的旅途才剛開始，年輕的王子。召集你的軍隊，到北裂境的嚴寒之地來見我。在那裡，我們可以算算我們之間的新仇舊恨。你將在那裡理解你真正的命運。"
})

-------------------
--  Wave Timers  --
-------------------
L = DBM:GetModLocalization("StratWaves")

L:SetGeneralLocalization({
	name = "斯坦波數"
})

L:SetWarningLocalization({
	WarningWaveNow	= "第%d波: %s出現了"
})

L:SetTimerLocalization({
	TimerWaveIn		= "下一波 (6)",
	TimerRoleplay	= "角色扮演阿薩斯計時"
})

L:SetOptionLocalization({
	WarningWaveNow	= "為新一進攻顯示警告",
	TimerWaveIn		= "為下一波顯示計時器 (之後5隻小兵波數)",
	TimerRoleplay	= "為角色扮演事件顯示計時器"
})

L:SetMiscLocalization({
	Devouring	= "吞噬食屍鬼",
	Enraged		= "狂怒食屍鬼",
	Necro		= "死靈大法師",
	Fiend		= "地穴惡魔",
	Stalker		= "墓穴巡者",
	Abom		= "縫補傀儡",
	Acolyte		= "侍僧",
	Wave1		= "%d %s",
	Wave2		= "%d %s 及 %d %s",
	Wave3		= "%d %s，%d %s 及 %d %s",
	Wave4		= "%d %s，%d %s，%d %s 及 %d %s",
	WaveBoss	= "%s",
	Roleplay	= "真高興你趕到了，烏瑟。",
	Roleplay2	= "大家看來都準備好了。記得，這些人受到恐怖瘟疫所感染，不久人世。我們得淨化斯坦索姆以保護其他百姓免受天譴軍的威脅。出發吧。"
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
	YellPull		= "籠罩你的寒氣就是厄運的先兆。",
	HandlerYell		= "協助防禦!快點，廢物們!",
	Phase2			= "你一定看得出來，這一切都只是徒勞無功罷了!",
	YellKill		= "你的努力...全是白費。"
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
	WarningPhase	= "第%d階段"
})

L:SetTimerLocalization({
	timerEvent	= "剩餘時間"
})

L:SetOptionLocalization({
	WarningPhase	= "為階段改變顯示警告",
	timerEvent		= "為事件的持續時間顯示計時器"
})

L:SetMiscLocalization({
	Pull	= "幫我看著外頭!我只要三兩下就可以搞定這玩意--",
	Phase1	= "安全機制突破中，史實資料分析已調至低優先佇列，啟動反制程序。",
	Phase2	= "已超出威脅指數標準。天界資料庫已中止。安全等級已提昇。",
	Phase3	= "威脅指數過高。已轉移無效的分析。啟動清潔處理協定。",
	Kill	= "警告:安全性系統自動修復裝置已被關閉。開始記憶體內容消除與..."
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
	SplitTrigger1		= "這裡有我千萬個分身。",
	SplitTrigger2		= "我要讓你們嚐嚐無所適從的滋味!"
})

-------------------
--  Keristrasza  --
-------------------
L = DBM:GetModLocalization(621)

-----------------------------------
--  Commander Kolurg/Stoutbeard  --
-----------------------------------
L = DBM:GetModLocalization("Commander")

local commander = "未知"
if UnitFactionGroup("player") == "Alliance" then
	commander = "指揮官寇勒格"
elseif UnitFactionGroup("player") == "Horde" then
	commander = "指揮官厚鬚"
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
	MakeitCountTimer	= "為成就:倒數吧顯示計時器"
})

L:SetMiscLocalization({
	MakeitCountTimer	= "倒數吧"
})

----------------------
--  Mage-Lord Urom  --
----------------------
L = DBM:GetModLocalization(624)

L:SetMiscLocalization({
	CombatStart		= "可憐而無知的蠢貨!"
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
	MakeitCountTimer	= "倒數吧"
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
	YellCombatEnd	= "不!不!我還可以...做得更好..."
})

------------------------
--  Utgarde Pinnacle  --
--------------------------
--  Skadi the Ruthless  --
--------------------------
L = DBM:GetModLocalization(643)

L:SetMiscLocalization({
	CombatStart		= "哪來的蠢狗敢入侵此地?打起精神來，我的兄弟們!誰能把他們的頭顱帶來，我會好好的犒賞一番!",
	Phase2			= "你們這些沒教養的垃圾!你們的屍體剛好拿來當龍的點心!"
})

-------------------
--  King Ymiron  --
-------------------
L = DBM:GetModLocalization(644)

-------------------------
--  Svala Sorrowgrave  --
-------------------------
L = DBM:GetModLocalization(641)

L:SetWarningLocalization({
	timerRoleplay		= "絲瓦拉·悲傷亡墓活動"
})

L:SetTimerLocalization({
	timerRoleplay		= "為絲瓦拉·悲傷亡墓能夠活動前的角色扮演顯示計時器"
})

L:SetOptionLocalization({
	SvalaRoleplayStart	= "陛下!我已完成您的要求，如今懇求您的祝福!"
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
	CyanArrived	= "真是一群英勇的衛兵，但這座城市必須被夷平。我必須親自執行瑪里苟斯大人的指令!"
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
	name = "傳送門計時"
})

L:SetWarningLocalization({
	WarningPortalSoon	= "新傳送門即將到來",
	WarningPortalNow	= "第%d個傳送門",
	WarningBossNow		= "首領到來"
})

L:SetTimerLocalization({
	TimerPortalIn	= "第%d個傳送門"
})

L:SetOptionLocalization({
	WarningPortalNow		= "為新傳送門顯示警告",
	WarningPortalSoon		= "為新傳送門顯示預先警告",
	WarningBossNow			= "為首領到來顯示警告",
	TimerPortalIn			= "為下一次傳送門顯示計時器 (擊敗首領後)",
	ShowAllPortalTimers		= "為所有傳送門顯示計時器 (不準確)"
})

L:SetMiscLocalization({
	Sealbroken	= "我們攻破了監獄大門!通往達拉然的通道已經暢通了!現在我們終於可以終結奧核戰爭了!"
})

-----------------------------
--  Trial of the Champion  --
-----------------------------
--  The Black Knight  --
------------------------
L = DBM:GetModLocalization(637)

L:SetOptionLocalization({
	AchievementCheck		= "提示 '糟糕透頂' 成就失敗到隊伍頻道"
})

L:SetMiscLocalization({
	Pull				= "幹得好。今天，你已證明了你自己-",
	AchievementFailed	= ">> 成就失敗: %s 被食屍鬼爆炸炸到了 <<",
	YellCombatEnd		= "恭喜你，勇士們。儘管試煉隱藏著許多不安的變數，但你們仍然通過了考驗。"
})

-----------------------
--  Grand Champions  --
-----------------------
L = DBM:GetModLocalization(634)

L:SetMiscLocalization({
	YellCombatEnd	= "精采的戰鬥!你的下一個挑戰者是從十字軍中挑選出來的英勇鬥士。你將會親身面對他們超卓實力的考驗。"
})

----------------------------------
--  Argent Confessor Paletress  --
----------------------------------
L = DBM:GetModLocalization(636)

L:SetMiscLocalization({
	YellCombatEnd	= "你們做得很好!"
})

-----------------------
--  Eadric the Pure  --
-----------------------
L = DBM:GetModLocalization(635)

L:SetMiscLocalization({
	YellCombatEnd	= "我認輸了!我投降。幹得好。我現在可以離場了嗎?"
})

--------------------
--  Pit of Saron  --
---------------------
--  Ick and Krick  --
---------------------
L = DBM:GetModLocalization(609)

L:SetOptionLocalization({
})

L:SetMiscLocalization({
	Barrage		= "%s開始迅速地召喚爆裂地雷!"
})

----------------------------
--  Forgemaster Garfrost  --
----------------------------
L = DBM:GetModLocalization(608)

L:SetOptionLocalization({
	AchievementCheck	= "提示 '別到十一' 的成就警告到隊伍頻道"
})

L:SetMiscLocalization({
	SaroniteRockThrow	= "%s對你丟出一大塊薩鋼巨石!",
	AchievementWarning	= "小心: %s已擁有%d層極寒冰霜",
	AchievementFailed	= ">> 成就失敗: %s已超過%d層極寒冰霜 <<"
})

----------------------------
--  Scourgelord Tyrannus  --
----------------------------
L = DBM:GetModLocalization(610)

L:SetOptionLocalization({
})

L:SetMiscLocalization({
	CombatStart		= "終於，勇敢、勇敢的冒險者，你的干擾終到盡頭。你聽見了身後隧道中的金屬與骨頭敲擊聲嗎?這就是你即將面對的死亡之聲。",
	HoarfrostTarget	= "冰霜巨龍霜牙凝視著(%S+)，準備發動寒冰攻擊!",
	YellCombatEnd	= "不可能...霜牙...警告..."
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

L:SetOptionLocalization({
})

---------------------------
--  Halls of Reflection  --
---------------------------
--  Wave Timers  --
-------------------
L = DBM:GetModLocalization("HoRWaveTimer")

L:SetGeneralLocalization({
	name = "波數計時"
})

L:SetWarningLocalization({
	WarnNewWaveSoon	= "新一波即將到來",
	WarnNewWave		= "%s 到來"
})

L:SetTimerLocalization({
	TimerNextWave	= "下一波"
})

L:SetOptionLocalization({
	WarnNewWave			= "當首領到來時顯示警告",
	WarnNewWaveSoon		= "為新一波顯示預先警告 (擊敗首領後)",
	ShowAllWaveWarnings	= "為所有波數顯示警告",
	TimerNextWave		= "為下一波顯示計時器 (擊敗首領後)",
	ShowAllWaveTimers	= "為所有波數顯示計時器及預先警告 (不準確)"
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
	achievementEscape	= "逃離計時"
})

L:SetOptionLocalization({
	WarnWave		= "為下一波到來顯示警告"
})

L:SetMiscLocalization({
	ACombatStart	= "他太強大了!我們必須立刻離開這裡!我的魔法只能困住他一小段時間。快來吧，英雄們!",
	HCombatStart	= "他...太強大了。英雄們，快點...到我這裡來!我們要立刻離開這裡!我會盡可能地在我們逃走時把他困住。"
})
