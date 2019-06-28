if GetLocale() ~= "zhTW" then return end
local L

-----------------------
--  Flame Leviathan  --
-----------------------
L = DBM:GetModLocalization("FlameLeviathan")

L:SetGeneralLocalization{
	name = "烈焰戰輪"
}
	
L:SetMiscLocalization{
	YellPull	= "發現敵意實體。啟動威脅評估協定。首要目標接近中。30秒後將再度評估。",
	Emote		= "%%s緊追(%S+)%。"
}

L:SetWarningLocalization{
	PursueWarn				= "獵殺: >%s<",
	warnNextPursueSoon		= "5秒後獵殺轉換",
	SpecialPursueWarnYou	= "你中了獵殺 - 快跑",
	warnWardofLife			= "生命結界出現"
}

L:SetOptionLocalization{
	SpecialPursueWarnYou	= "當你中了獵殺時顯示特別警告",
	PursueWarn				= "提示獵殺的目標",
	warnNextPursueSoon		= "為下一次獵殺顯示預先警告",
	warnWardofLife			= "為生命結界出現顯示特別警告"
}

--------------------------------
--  Ignis the Furnace Master  --
--------------------------------
L = DBM:GetModLocalization("Ignis")

L:SetGeneralLocalization{
	name = "『火爐之主』伊格尼司"
}

------------------
--  Razorscale  --
------------------
L = DBM:GetModLocalization("Razorscale")

L:SetGeneralLocalization{
	name = "銳鱗"
}

L:SetWarningLocalization{
	warnTurretsReadySoon	= "20秒後 最後一座砲塔完成",
	warnTurretsReady		= "最後一座砲塔已完成"
}

L:SetTimerLocalization{
	timerTurret1	= "砲塔1",
	timerTurret2	= "砲塔2",
	timerTurret3	= "砲塔3",
	timerTurret4	= "砲塔4",
	timerGrounded	= "地上階段"
}

L:SetOptionLocalization{
	warnTurretsReadySoon	= "為砲塔顯示預先警告",
	warnTurretsReady		= "為砲塔顯示警告",
	timerTurret1			= "為砲塔1顯示計時器",
	timerTurret2			= "為砲塔2顯示計時器",
	timerTurret3			= "為砲塔3顯示計時器 (25人)",
	timerTurret4			= "為砲塔4顯示計時器 (25人)",
	timerGrounded			= "為地上階段顯示計時器"
}

L:SetMiscLocalization{
	YellAir				= "給我們一點時間來準備建造砲塔。",
	YellAir2			= "火熄了!讓我們重建砲塔!",
	YellGround			= "快!她可不會在地面上待太久!",
	EmotePhase2			= "再也飛不動了!"
}

----------------------------
--  XT-002 Deconstructor  --
----------------------------
L = DBM:GetModLocalization("XT002")

L:SetGeneralLocalization{
	name = "XT-002拆解者"
}

--------------------
--  Iron Council  --
--------------------
L = DBM:GetModLocalization("IronCouncil")

L:SetGeneralLocalization{
	name = "鐵之集會所"
}

L:SetOptionLocalization{
	AlwaysWarnOnOverload	= "總是對$spell:63481顯示警告(否則只有當目標是風暴召喚者的時候顯示)"
}

L:SetMiscLocalization{
	Steelbreaker			= "破鋼者",
	RunemasterMolgeim		= "符文大師墨吉姆",
	StormcallerBrundir 		= "風暴召喚者布倫迪爾"
}

----------------------------
--  Algalon the Observer  --
----------------------------
L = DBM:GetModLocalization("Algalon")

L:SetGeneralLocalization{
	name = "『觀察者』艾爾加隆"
}

L:SetTimerLocalization{
	NextCollapsingStar		= "下一次崩陷之星",
	TimerCombatStart		= "戰鬥開始"
}

L:SetWarningLocalization{
	WarnPhase2Soon			= "第2階段即將到來",
	warnStarLow				= "崩陷之星血量低"
}

L:SetOptionLocalization{
	WarningPhasePunch		= "提示相位拳擊的目標",
	NextCollapsingStar		= "為下一次崩陷之星顯示計時器",
	TimerCombatStart		= "為戰鬥開始顯示計時器",
	WarnPhase2Soon			= "為第2階段顯示預先警告 (大約23%)",
	warnStarLow				= "當崩陷之星血量低(大約25%)時顯示特別警告"
}

L:SetMiscLocalization{
	HealthInfo			= "崩陷之星血量",
	YellPull			= "你的行為毫無意義。這場衝突的結果早已計算出來了。不論結局為何，萬神殿仍將收到觀察者的訊息。",
	YellKill			= "我曾經看過塵世沉浸在造物者的烈焰之中，眾生連一聲悲泣都無法呼出，就此凋零。整個星系在彈指之間歷經了毀滅與重生。然而在這段歷程之中，我的心卻無法感受到絲毫的...惻隱之念。我‧感‧受‧不‧到。成千上萬的生命就這麼消逝。他們是否擁有與你同樣堅韌的生命?他們是否與你同樣熱愛生命?",
	Emote_CollapsingStar	= "%s開始召喚崩陷之星!",
	Phase2				= "瞧瞧泰坦造物的能耐吧!",
	FirstPull			= "從我的雙眼觀看你的世界:一個無邊無際的宇宙--連你們之中最具智慧者都無法想像的廣闊無垠。",
}

----------------
--  Kologarn  --
----------------
L = DBM:GetModLocalization("Kologarn")

L:SetGeneralLocalization{
	name = "柯洛剛恩"
}

L:SetTimerLocalization{
	timerLeftArm			= "左臂重生",
	timerRightArm			= "右臂重生",
	achievementDisarmed		= "卸除手臂計時器"
}

L:SetOptionLocalization{
	timerLeftArm			= "為左臂重生顯示計時器",
	timerRightArm			= "為右臂重生顯示計時器",
	achievementDisarmed		= "為成就:卸除手臂顯示計時器"
}

L:SetMiscLocalization{
	Yell_Trigger_arm_left	= "小小的擦傷!",
	Yell_Trigger_arm_right	= "只是皮肉之傷!",
	Health_Body				= "柯洛剛恩身體",
	Health_Right_Arm		= "右臂",
	Health_Left_Arm			= "左臂",
	FocusedEyebeam			= "正在注視著你"
}

---------------
--  Auriaya  --
---------------
L = DBM:GetModLocalization("Auriaya")

L:SetGeneralLocalization{
	name = "奧芮雅"
}

L:SetMiscLocalization{
	Defender = "野性防衛者 (%d)",
	YellPull = "有些事情不該公諸於世!"
}

L:SetTimerLocalization{
	timerDefender	= "野性防衛者復活"
}

L:SetWarningLocalization{
	WarnCatDied 	= "野性防衛者倒下 (剩餘%d隻)",
	WarnCatDiedOne 	= "野性防衛者倒下 (剩下最後一隻)"
}

L:SetOptionLocalization{
	WarnCatDied		= "當野性防衛者死亡時顯示警告",
	WarnCatDiedOne	= "當野性防衛者剩下最後一隻時顯示警告",
	timerDefender   = "當野性防衛者準備復活時顯示計時器"
}

-------------
--  Hodir  --
-------------
L = DBM:GetModLocalization("Hodir")

L:SetGeneralLocalization{
	name = "霍迪爾"
}

L:SetMiscLocalization{
	Pull		= "你將為擅闖付出代價!",
	YellKill	= "我...我終於從他的掌控中...解脫了。"
}

--------------
--  Thorim  --
--------------
L = DBM:GetModLocalization("Thorim")

L:SetGeneralLocalization{
	name = "索林姆"
}

L:SetTimerLocalization{
	TimerHardmode	= "困難模式"
}

L:SetOptionLocalization{
	TimerHardmode	= "為困難模式顯示計時器",
	RangeFrame		= "顯示距離框",
	AnnounceFails	= "公佈中了閃電充能的玩家到團隊頻道<br/>(需要團隊隊長或助理權限)"
}

L:SetMiscLocalization{
	YellPhase1	= "擅闖者!像你們這種膽敢干涉我好事的凡人將付出...等等--你...",
	YellPhase2	= "無禮的小輩，你竟敢在我的王座之上挑戰我?我會親手碾碎你們!",
	YellKill	= "住手!我認輸了!",
	ChargeOn	= "閃電充能: %s",
	Charge		= "中了閃電充能 (這一次): %s" 
}

-------------
--  Freya  --
-------------
L = DBM:GetModLocalization("Freya")

L:SetGeneralLocalization{
	name = "芙蕾雅"
}

L:SetMiscLocalization{
	SpawnYell	= "孩子們，協助我!",
	WaterSpirit	= "上古水之靈",
	Snaplasher	= "猛攫鞭笞者",
	StormLasher	= "風暴鞭笞者",
	YellKill	= "他對我的操控已然退散。我已再次恢復神智了。感激不盡，英雄們。"
}

L:SetWarningLocalization{
	WarnSimulKill	= "第一隻元素死亡 - 大約12秒後復活"
}

L:SetTimerLocalization{
	TimerSimulKill	= "復活"
}

L:SetOptionLocalization{
	WarnSimulKill	= "提示第一隻元素死亡",
	TimerSimulKill	= "為三元素復活顯示計時器"
}

----------------------
--  Freya's Elders  --
----------------------
L = DBM:GetModLocalization("Freya_Elders")

L:SetGeneralLocalization{
	name = "芙蕾雅的長者們"
}

---------------
--  Mimiron  --
---------------
L = DBM:GetModLocalization("Mimiron")

L:SetGeneralLocalization{
	name = "彌米倫"
}

L:SetWarningLocalization{
	MagneticCore		= ">%s<拿到了磁能之核",
	WarnBombSpawn		= "炸彈機器人出現了"
}

L:SetTimerLocalization{
	TimerHardmode	= "困難模式 - 自毀程序",
	TimeToPhase2	= "第2階段開始",
	TimeToPhase3	= "第3階段開始",
	TimeToPhase4	= "第4階段開始"
}

L:SetOptionLocalization{
	TimeToPhase2			= "為第2階段開始顯示計時器",
	TimeToPhase3			= "為第3階段開始顯示計時器",
	TimeToPhase4			= "為第4階段開始顯示計時器",
	MagneticCore			= "提示磁能之核的拾取者",
	WarnBombSpawn			= "為炸彈機器人顯示警告",
	TimerHardmode			= "為困難模式顯示計時器",
	RangeFrame				= "在第1階段顯示距離框(6碼)"
}

L:SetMiscLocalization{
	MobPhase1		= "戰輪MK II",
	MobPhase2		= "VX-001",
	MobPhase3		= "空中指揮裝置",
	YellPull		= "我們沒有太多時間，朋友們!你們要幫我測試我最新也是最偉大的創作。在你們改變心意之前，別忘了就是你們把XT-002搞得一團糟，你們欠我一次。",
	YellHardPull	= "為什麼你要做出這種事?難道你沒看見標示上寫著「請勿觸碰這個按鈕!」嗎?現在自爆裝置已經啟動了，我們要怎麼完成測試呢?",
	LootMsg			= "(.+)拾取了物品:.*Hitem:(%d+)"
}

---------------------
--  General Vezax  --
---------------------
L = DBM:GetModLocalization("GeneralVezax")

L:SetGeneralLocalization{
	name = "威札斯將軍"
}

L:SetTimerLocalization{
	hardmodeSpawn = "薩倫聚惡體出現"
}

L:SetOptionLocalization{
	SetIconOnShadowCrash	= "為$spell:62660的目標設置標記 (頭顱)",
	SetIconOnLifeLeach		= "為$spell:63276的目標設置標記 (十字)",
	hardmodeSpawn			= "為薩倫聚惡體出現顯示計時器 (困難模式)"
}

L:SetMiscLocalization{
	EmoteSaroniteVapors	= "一片薩倫煙霧在附近聚合!"
}

------------------
--  Yogg-Saron  --
------------------
L = DBM:GetModLocalization("YoggSaron")

L:SetGeneralLocalization{
	name = "尤格薩倫"
}

L:SetWarningLocalization{
	WarningGuardianSpawned 			= "第%d個尤格薩倫守護者出現了",
	WarningCrusherTentacleSpawned	= "粉碎觸手出現了",
	WarningSanity 					= "剩下%d理智",
	SpecWarnSanity 					= "剩下%d理智",
	SpecWarnMadnessOutNow			= "瘋狂誘陷即將結束 - 快傳送出去",
	WarnBrainPortalSoon				= "3秒後腦部傳送門",
	specWarnBrainPortalSoon			= "腦部傳送門即將到來"
}

L:SetTimerLocalization{
	NextPortal	= "下一次腦部傳送門"
}

L:SetOptionLocalization{
	WarningGuardianSpawned			= "為尤格薩倫守護者出現顯示警告",
	WarningCrusherTentacleSpawned	= "為粉碎觸手出現顯示警告",
	WarningSanity					= "當理智剩下50時顯示警告",
	SpecWarnSanity					= "當理智過低(25,15,5)時顯示特別警告",
	WarnBrainPortalSoon				= "為腦部傳送門顯示預先警告",
	SpecWarnMadnessOutNow			= "為瘋狂誘陷結束前顯示特別警告",
	SpecWarnFervorCast				= "當薩拉的熱誠正在對你施放時顯示特別警告(必須有最少一名團隊成員設置目標或專注目標)",
	specWarnBrainPortalSoon			= "為下一次腦部傳送門顯示特別警告",
	NextPortal						= "為下一次傳送門顯示計時器"
}

L:SetMiscLocalization{
	YellPull 			= "我們即將有機會打擊怪物的首腦!現在將你的憤怒與仇恨貫注在他的爪牙上!",
	YellPhase2			= "我是清醒的夢境。",
	Sara 				= "薩拉"
}
