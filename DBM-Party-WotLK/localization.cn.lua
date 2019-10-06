-- Simplified Chinese by Diablohu
-- http://wow.gamespot.com.cn
-- Last Update: 12/13/2008

-- author: callmejames @《凤凰之翼》 一区藏宝海湾
-- commit by: yaroot <yaroot AT gmail.com>
-- Last Update: 9/16/2010

if GetLocale() ~= "zhCN" then return end

local L

local optionWarning	= "显示%s警报"		-- translate
local optionPreWarning	= "显示%s预警"	-- translate

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
L = DBM:GetModLocalization("Anubarak")

L:SetGeneralLocalization({
	name = "阿努巴拉克(5人副本)"
})

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
	Outro	= "你的旅程才刚开始，年轻的王子。集合你的部队，到诺森德再次挑战我。在那里，我们将了结彼此之间的恩怨，你将了解到你真正的命运。"
})

-------------------
--  Wave Timers  --
-------------------
L = DBM:GetModLocalization("StratWaves")

L:SetGeneralLocalization({
	name = "斯坦索姆小怪"
})

L:SetWarningLocalization({
	WarningWaveNow	= "第%d波: %s 出现了"
})

L:SetTimerLocalization({
	TimerWaveIn		= "下一波(6)",
	TimerRoleplay	= "角色扮演事件计时"
})

L:SetOptionLocalization({
	WarningWaveNow	= optionWarning:format("新一波"),
	TimerWaveIn		= "为下一波显示计时条 (之后的5批小怪)",
	TimerRoleplay	= "为角色扮演事件显示计时条"
})

L:SetMiscLocalization({
	Devouring	= "狼吞虎咽的食尸鬼",
	Enraged		= "暴怒的食尸鬼",
	Necro		= "通灵大师",
	Fiend		= "地穴恶魔",
	Stalker		= "墓穴猎手",
	Abom		= "缝补构造体",
	Acolyte		= "侍僧",
	Wave1		= "%d %s",
	Wave2		= "%d %s 和 %d %s",
	Wave3		= "%d %s，%d %s 和 %d %s",
	Wave4		= "%d %s，%d %s，%d %s 和 %d %s",
	WaveBoss	= "%s",
	WaveCheck	= "天灾波次 = (%d+)/10",
	Roleplay	= "乌瑟尔，你总算及时赶到了。",
	Roleplay2	= "大家都做好准备了吧。记住，斯坦索姆的城民已经受到感染，很快就会丧命。我们必须清洗斯坦索姆，确保洛丹伦的其它地区免受天灾军团的侵蚀。出发吧。"
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
	YellPull		= "笼罩你的寒气就是厄运的先兆。",
	HandlerYell		= "协助防御！快点，废物们！",
	Phase2			= "很快你们就会发现一切都是徒劳无功。",
	YellKill		= "这一切……都是毫无意义的。"
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

--------------
--  Kronus  --
--------------
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
	WarningPhase	= "第%d阶段"
})

L:SetTimerLocalization({
	timerEvent	= "剩余时间"
})

L:SetOptionLocalization({
	WarningPhase	= optionWarning:format("阶段数"),
	timerEvent		= "为事件的持续时间显示计时条"
})

L:SetMiscLocalization({
	Pull	= "嗯，你们帮我看着点外面。我这样的强者只要锤两下就能搞定这破烂……",
	Phase1	= "安全系统发现不明入侵。历史文档的分析工作优先级转为低。对策程序立即启动。",
	Phase2	= "已超出威胁指数标准。天界文档中断。提高安全级别。",
	Phase3	= "威胁指数过高。虚空分析程序关闭。启动清理协议。",
	Kill	= "警告：安全系统自动修复装置已被关闭。立刻消除化全部存储器内容并……"
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
	SplitTrigger1		= "这里有我千万个分身。",
	SplitTrigger2		= "我要让你们尝尝无所适从的滋味!"
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
	commander = "指挥官库鲁尔格"
elseif UnitFactionGroup("player") == "Horde" then
	commander = "指挥官斯托比德"
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
	MakeitCountTimer	= "为成就：分秒必争显示计时条"
})

L:SetMiscLocalization({
	MakeitCountTimer	= "分秒必争"
})

----------------------
--  Mage-Lord Urom  --
----------------------
L = DBM:GetModLocalization(624)

L:SetMiscLocalization({
	CombatStart		= "可怜而无知的蠢货！"
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
	MakeitCountTimer	= "分秒必争"
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
	YellCombatEnd	= "不！不！我还可以……做得更好。"
})

------------------------
--  Utgarde Pinnacle  --
--------------------------
--  Skadi the Ruthless  --
--------------------------
L = DBM:GetModLocalization(643)

L:SetMiscLocalization({
	CombatStart		= "什么样的狗杂种竟然胆敢入侵这里？快点，弟兄们！谁要是能把他们的头提来，就赏他吃肉！",
	Phase2			= "你这只无能的蠢龙！你的尸体干脆给我的新飞龙拿去当点心算了！"
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
	timerRoleplay		= "席瓦拉·索格蕾 开始攻击"
})

L:SetOptionLocalization({
	timerRoleplay		= "为席瓦拉·索格蕾开始攻击前的角色扮演显示计时条"
})

L:SetMiscLocalization({
	SvalaRoleplayStart	= "尊敬的陛下！我已经完成您的全部要求，希望您能不吝赐下伟大的祝福！"
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
	CyanArrived	= "真是一群英勇的卫兵，但这座城市必须被夷平。我要亲自执行玛里苟斯大人的指令！"
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
	name = "传送门计时"
})

L:SetWarningLocalization({
	WarningPortalSoon	= "新传送门即将开启",
	WarningPortalNow	= "传送门 #%d",
	WarningBossNow		= "首领到来"
})

L:SetTimerLocalization({
	TimerPortalIn	= "传送门 #%d"
})

L:SetOptionLocalization({
	WarningPortalNow		= optionWarning:format("新传送门"),
	WarningPortalSoon		= optionPreWarning:format("新传送门"),
	WarningBossNow			= optionWarning:format("首领到来"),
	TimerPortalIn			= "为下一次 传送门显示计时条(击败首领后)",
	ShowAllPortalTimers		= "为所有传送门显示计时条(不准确)"
})

L:SetMiscLocalization({
	Sealbroken	= "我们冲破了监狱的大门！进入达拉然的道路被清理干净了！魔枢之战终于可以结束了！",
	WavePortal	= "已打开传送门：(%d+)/18"
})

-----------------------------
--  Trial of the Champion  --
-----------------------------
--  The Black Knight  --
------------------------
L = DBM:GetModLocalization(637)

L:SetOptionLocalization({
	AchievementCheck		= "报告'这还不算惨'成就的失败信息给小队"
})

L:SetMiscLocalization({
	Pull			= "干得好，今天，你证明了自己的实力。",
	AchievementFailed	= ">> 成就失败: %s 被食尸鬼爆炸击中了 <<",
	YellCombatEnd	= "勇士们，祝贺你们！经历过一系列计划之中和意料之外的试炼，你们终于取得了胜利。"	-- can also be "No! I must not fail... again ..."
})

-----------------------
--  Grand Champions  --
-----------------------
L = DBM:GetModLocalization(634)

L:SetMiscLocalization({
	YellCombatEnd	= "干得漂亮！你的下一个挑战将来自于十字军的骑士们。他们将以强大的实力对你进行测试。"
})

----------------------------------
--  Argent Confessor Paletress  --
----------------------------------
L = DBM:GetModLocalization(636)

L:SetMiscLocalization({
	YellCombatEnd	= "真是精彩！"
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

L:SetWarningLocalization({
	specwarnMirroredSoul	= "Stop damage",
	specwarnWailingSouls	= "Wailing Souls - Get behind"
})

L:SetOptionLocalization({
	specwarnMirroredSoul	= "Show special warning to stop damage on $spell:69051",
	specwarnWailingSouls	= "Show special warning when $spell:68899 is cast"
})


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

L:SetMiscLocalization({
	WaveCheck	= "Spirit Wave = (%d+)/10"
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
