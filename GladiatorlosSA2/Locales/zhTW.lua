-- Mini Dragon(projecteurs@gmail.com)
-- Last update: Jan 29, 2015

local L = LibStub("AceLocale-3.0"):NewLocale("GladiatorlosSA", "zhTW")
if not L then return end

L["Spell_CastSuccess"] = "施法成功"
L["Spell_CastStart"] = "施法開始"
L["Spell_AuraApplied"] = "增益獲得"
L["Spell_AuraRemoved"] = "增益消失"
L["Spell_Interrupt"] = "法術打斷"
L["Spell_Summon"] = "法術召喚"
L["Any"] = "任意"
L["Player"] = "玩家"
L["Target"] = "目標"
L["Focus"] = "關注目標"
L["Mouseover"] = "鼠標指向"
L["Party"] = "小隊"
L["Raid"] = "團隊"
L["Arena"] = "競技場敵方"
L["Boss"] = "副本Boss"
L["Custom"] = "自定義"
L["Friendly"] = "友好"
L["Hostile player"] = "敵對玩家"
L["Hostile unit"] = "敵對單位"
L["Neutral"] = "中立"
L["Myself"] = "玩家自己"
L["Mine"] = "自己或自己的單位"
L["My pet"] = "自己的寵物"
L["Custom Spell"] = "自定義法術"
L["New Sound Alert"] = "新的聲音警報"
L["name"] = "名字"
L["same name already exists"] = "已存在同名警報"
L["spellid"] = "法術ID"
L["Remove"] = "移除"
L["Are you sure?"] = "確認移除?"
L["Test"] = "測試"
L["Use existing sound"] = "使用現存聲音"
L["choose a sound"] = "選擇一個聲音"
L["file path"] = "文件路徑"
L["event type"] = "事件類型"
L["Source unit"] = "來源單位"
L["Source type"] = "來源類型"
L["Custom unit name"] = "自定義單位名字"
L["Dest unit"] = "目標單位"
L["Dest type"] = "目標類型"

L["Profiles"] = "設定檔"

L["GladiatorlosSACredits"] = "Customizable PvP Announcer addon for vocalizing many important spells cast by your enemies.|n|n|cffFFF569Created by|r |cff9482C9Abatorlos|r |cffFFF569of Spinebreaker|r|n|cffFFF569Legion/BfA support by|r |cffC79C6EOrunno|r |cffFFF569of Moon Guard (With permission from zuhligan)|r|n|n|cffFFF569Special Thanks|r|n|cffA330C9superk521|r (Past Project Manager)|n|cffA330C9DuskAshes|r (Chinese Support)|n|cffA330C9N30Ex|r (Mists of Pandaria Support)|n|cffA330C9zuhligan|r (Warlords of Draenor & French Support)|n|cffA330C9jungwan2|r (Korean Support)|n|cffA330C9Mini_Dragon|r (Chinese support for WoD & Legion)|n|cffA330C9LordKuper|r (Russian support for Legion)|n|cffA330C9Tzanee - Wyrmrest Accord|r (Placeholder Voice Lines)|n|nAll feedback, questions, suggestions, and bug reports are welcome at the addon's page on Curse!"
L["PVP Voice Alert"] = "PVP技能語音提示"
L["Load Configuration"] = "加載配置"
L["Load Configuration Options"] = "加載配置選項"
L["General"] = "一般"
L["General options"] = "一般選項"
L["Enable area"] = "當何時啟用"
L["Anywhere"] = "總是啟用"
L["Alert works anywhere"] = "在任何地方GladiatorlosSA都處於開啟狀態"
L["Arena"] = "競技場"
L["Alert only works in arena"] = "在競技場中啟用GladiatorlosSA"
L["Battleground"] = "戰場"
L["Alert only works in BG"] = "在戰場中啟用GladiatorlosSA"
L["World"] = "野外"
L["Alert works anywhere else then anena, BG, dungeon instance"] = "除了戰場、競技場和副本的任何地方都啟用GladiatorlosSA"
L["Voice config"] = "聲音設置"
L["Voice language"] = "語言類型"
L["Select language of the alert"] = "選擇通報所用語音"
L["Chinese(female)"] = "漢語(女聲)"
L["English(female)"] = "英語(女聲)"
L["Volume"] = "聲音大小"
L["adjusting the voice volume(the same as adjusting the system master sound volume)"] = "調節聲音大小(等同於調節系統主音量大小)"
L["Advance options"] = "高級設置"
L["Smart disable"] = "智能禁用模式"
L["Disable addon for a moment while too many alerts comes"] = "處於大型戰場等警報過於頻繁的區域自動禁用"
L["Throttle"] = "節流閥"
L["The minimum interval of each alert"] = "控制聲音警報的最小間隔"
L["Abilities"] = "技能"
L["Abilities options"] = "技能選項"
L["Disable options"] = "技能模組控制"
L["Disable abilities by type"] = "技能各個模組禁用選項"
L["Disable Buff Applied"] = "禁用敵方增益技能"
L["Check this will disable alert for buff applied to hostile targets"] = "勾選此選項以關閉敵方增益型技能通報"
L["Disable Buff Down"] = "禁用敵方增益結束"
L["Check this will disable alert for buff removed from hostile targets"] = "勾選此選項以關閉敵方增益結束通報"
L["Disable Spell Casting"] = "禁用敵方讀條技能"
L["Chech this will disable alert for spell being casted to friendly targets"] = "勾選此選項以關閉敵方對友方讀條技能通報"
L["Disable special abilities"] = "禁用敵方特殊技能"
L["Check this will disable alert for instant-cast important abilities"] = "勾選此選項以關閉敵方對友方特殊技能通報"
L["Disable friendly interrupt"] = "禁用友方打斷技能"
L["Check this will disable alert for successfully-landed friendly interrupting abilities"] = "勾選此選項以關閉友方對敵方打斷技能成功的通報"
L["Buff Applied"] = "敵方增益技能"
L["Target and Focus Only"] = "僅目標或關注目標"
L["Alert works only when your current target or focus gains the buff effect or use the ability"] = "僅當該技能是你的目標或關注目標使用或增益出現在你的目標或關注目標身上才語音通報"
L["Alert Drinking"] = "通報正在進食"
L["In arena, alert when enemy is drinking"] = "在競技場中,通報敵方玩家正在進食"
L["PvP Trinketed Class"] = "徽章職業提示"
L["Also announce class name with trinket alert when hostile targets use PvP trinket in arena"] = "在競技場中,通報徽章的同時提示使用徽章的職業"
L["General Abilities"] = "通用技能"
L["|cffFF7D0ADruid|r"] = "|cffFF7D0A德魯伊|r"
L["|cffF58CBAPaladin|r"] = "|cffF58CBA聖騎士|r"
L["|cffFFF569Rogue|r"] = "|cffFFF569盜賊|r"
L["|cffC79C6EWarrior|r"] = "|cffC79C6E戰士|r"
L["|cffFFFFFFPriest|r"] = "|cffFFFFFF牧師|r"
L["|cff0070daShaman|r"] = "|cff0070DE薩滿|r"
L["|cff0070daShaman (Totems)|r"] = true
L["|cff69CCF0Mage|r"] = "|cff69CCF0法師|r"
L["|cffC41F3BDeath Knight|r"] = "|cffC41F3B死亡騎士|r"
L["|cffABD473Hunter|r"] = "|cffABD473獵人|r"
L["|cFF00FF96Monk|r"] = "|cFF00FF96武僧|r"
L["|cffA330C9Demon Hunter|r"] = "|cffA330C9?|r"
L["Buff Down"] = "敵方增益結束"
L["Spell Casting"] = "敵方讀條技能"
L["BigHeal"] = "大型治療法術"
L["BigHeal_Desc"] = "強效治療術 神聖之光 強效治療波 治療之觸"
L["Resurrection"] = "復活技能"
L["Resurrection_Desc"] = "復活術 救贖 先祖之魂 復活"
L["|cff9482C9Warlock|r"] = "|cff9482C9術士|r"
L["Special Abilities"] = "敵方特殊技能"
L["Friendly Interrupt"] = "友方打斷技能"
L["Spell Lock, Counterspell, Kick, Pummel, Mind Freeze, Skull Bash, Rebuke, Solar Beam, Spear Hand Strike, Wind Shear"] = "法術封鎖 法術反制 腳踢 拳擊 心智冰封 碎顱猛擊 責難"

L["PvPWorldQuests"] = true
L["DisablePvPWorldQuests"] = true
L["DisablePvPWorldQuestsDesc"] = true
L["OperationMurlocFreedom"] = true

L["EnemyInterrupts"] = true
L["EnemyInterruptsDesc"] = true

L["Default / Female voice"] = "默認 / 女聲"
L["Select the default voice pack of the alert"] = "選擇默認語音包"
L["Optional / Male voice"] = "可選 / 男聲"
L["Select the male voice"] = "選擇男性語音包"
L["Optional / Neutral voice"] = "可選 / 中立"
L["Select the neutral voice"] = "選擇中性語音包"
L["Gender detection"] = "性別判斷"
L["Activate the gender detection"] = "開啟性別判斷"
L["Voice menu config"] = "語音菜單選項"
L["Choose a test voice pack"] = "選擇測試語音包"
L["Select the menu voice pack alert"] = "選擇菜單語音包警告"

L["English(male)"] = true
L["No sound selected for the Custom alert : |cffC41F4B"] = true
L["Master Volume"] = true -- changed from L["Volume"] = true
L["Change Output"] = true
L["Unlock the output options"] = true
L["Output"] = true
L["Select the default output"] = true
L["Master"] = true
L["SFX"] = true
L["Ambience"] = true
L["Music"] = true
L["Dialog"] = true

L["DPSDispel"] = true
L["DPSDispel_Desc"] = true
L["HealerDispel"] = true
L["HealerDispel_Desc"] = true
L["CastingSuccess"] = true
L["CastingSuccess_Desc"] = true

L["DispelKickback"] = true

L["Purge"] = true
L["PurgeDesc"] = true

L["FriendlyInterrupted"] = true
L["FriendlyInterruptedDesc"] = true

L["epicbattleground"] = true
L["epicbattlegroundDesc"] = true

L["TankTauntsOFF"] = true
L["TankTauntsOFF_Desc"] = true
L["TankTauntsON"] = true
L["TankTauntsON_Desc"] = true

L["Connected"] = true
L["Connected_Desc"] = true

L["CovenantAbilities"] = true

L["FrostDK"] = true
L["BloodDK"] = true
L["UnholyDK"] = true

L["HavocDH"] = true
L["VengeanceDH"] = true

L["FeralDR"] = true
L["BalanceDR"] = true
L["RestorationDR"] = true
L["GuardianDR"] = true

L["MarksmanshipHN"] = true
L["SurvivalHN"] = true
L["BeastMasteryHN"] = true

L["FrostMG"] = true
L["FireMG"] = true
L["ArcaneMG"] = true

L["MistweaverMN"] = true
L["WindwalkerMN"] = true
L["BrewmasterMN"] = true

L["HolyPD"] = true
L["RetributionPD"] = true
L["ProtectionPD"] = true

L["HolyPR"] = true
L["DisciplinePR"] = true
L["ShadowPR"] = true

L["OutlawRG"] = true
L["AssassinationRG"] = true
L["SubtletyRG"] = true

L["RestorationSH"] = true
L["EnhancementSH"] = true
L["ElementalSH"] = true

L["DestructionWL"] = true
L["DemonologyWL"] = true
L["AfflictionWL"] = true

L["ArmsWR"] = true
L["FuryWR"] = true
L["ProtectionWR"] = true