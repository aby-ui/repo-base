-- Mini Dragon(projecteurs@gmail.com)
-- Last update: Jan 29, 2015

local L = LibStub("AceLocale-3.0"):NewLocale("GladiatorlosSA", "zhCN")
if not L then return end

L["Spell_CastSuccess"] = "施法成功"
L["Spell_CastStart"] = "施法开始"
L["Spell_AuraApplied"] = "增益获得"
L["Spell_AuraRemoved"] = "增益消失"
L["Spell_Interrupt"] = "法术打断"
L["Spell_Summon"] = "法术召唤"
L["Any"] = "任意"
L["Player"] = "玩家"
L["Target"] = "目标"
L["Focus"] = "焦点"
L["Mouseover"] = "鼠标指向"
L["Party"] = "小队"
L["Raid"] = "团队"
L["Arena"] = "竞技场敌方"
L["Boss"] = "副本Boss"
L["Custom"] = "自定义"
L["Friendly"] = "友好"
L["Hostile player"] = "敌对玩家"
L["Hostile unit"] = "敌对单位"
L["Neutral"] = "中立"
L["Myself"] = "玩家自己"
L["Mine"] = "自己或自己的单位"
L["My pet"] = "自己的宠物"
L["Custom Spell"] = "自定义法术"
L["New Sound Alert"] = "新的声音警报"
L["name"] = "名字"
L["same name already exists"] = "已存在同名警报"
L["spellid"] = "法术ID"
L["Remove"] = "移除"
L["Are you sure?"] = "确认移除?"
L["Test"] = "测试"
L["Use existing sound"] = "使用现存声音"
L["choose a sound"] = "选择一个声音"
L["file path"] = "文件路径"
L["event type"] = "事件类型"
L["Source unit"] = "来源单位"
L["Source type"] = "来源类型"
L["Custom unit name"] = "自定义单位名字"
L["Dest unit"] = "目标单位"
L["Dest type"] = "目标类型"

L["Profiles"] = "配置文件"

L["GladiatorlosSACredits"] = "Customizable PvP Announcer addon for vocalizing many important spells cast by your enemies.|n|n|cffFFF569Created by|r |cff9482C9Abatorlos|r |cffFFF569of Spinebreaker|r|n|cffFFF569Legion/BfA support by|r |cffC79C6EOrunno|r |cffFFF569of Moon Guard (With permission from zuhligan)|r|n|n|cffFFF569Special Thanks|r|n|cffA330C9superk521|r (Past Project Manager)|n|cffA330C9DuskAshes|r (Chinese Support)|n|cffA330C9N30Ex|r (Mists of Pandaria Support)|n|cffA330C9zuhligan|r (Warlords of Draenor & French Support)|n|cffA330C9jungwan2|r (Korean Support)|n|cffA330C9Mini_Dragon|r (Chinese support for WoD & Legion)|n|cffA330C9LordKuper|r (Russian support for Legion)|n|cffA330C9Tzanee - Wyrmrest Accord|r (Placeholder Voice Lines)|n|nAll feedback, questions, suggestions, and bug reports are welcome at the addon's page on Curse!"
L["PVP Voice Alert"] = "PVP技能语音提示"
L["Load Configuration"] = "加载配置"
L["Load Configuration Options"] = "加载配置选项"
L["General"] = "一般"
L["General options"] = "一般选项"
L["Enable area"] = "当何时启用"
L["Anywhere"] = "总是启用"
L["Alert works anywhere"] = "在任何地方GladiatorlosSA都处于开启状态"
L["Arena"] = "竞技场"
L["Alert only works in arena"] = "在竞技场中启用GladiatorlosSA"
L["Battleground"] = "战场"
L["Alert only works in BG"] = "在战场中启用GladiatorlosSA"
L["World"] = "野外"
L["Alert works anywhere else then anena, BG, dungeon instance"] = "除了战场、竞技场和副本的任何地方都启用GladiatorlosSA"
L["Voice config"] = "声音设置"
L["Voice language"] = "语言类型"
L["Select language of the alert"] = "选择通报所用语言"
L["Chinese(female)"] = "汉语(女声)"
L["English(female)"] = "英语(女声)"
L["Volume"] = "声音大小"
L["adjusting the voice volume(the same as adjusting the system master sound volume)"] = "调节声音大小(等同于调节系统主音量大小)"
L["Advance options"] = "高级设置"
L["Smart disable"] = "智能禁用模式"
L["Disable addon for a moment while too many alerts comes"] = "处于大型战场等警报过于频繁的区域自动禁用"
L["Throttle"] = "节流阀"
L["The minimum interval of each alert"] = "控制声音警报的最小间隔"
L["Abilities"] = "技能"
L["Abilities options"] = "技能选项"
L["Disable options"] = "技能模块控制"
L["Disable abilities by type"] = "技能各个模块禁用选项"
L["Disable Buff Applied"] = "禁用敌方增益技能"
L["Check this will disable alert for buff applied to hostile targets"] = "勾选此选项以关闭敌方增益技能通报"
L["Disable Buff Down"] = "禁用敌方增益结束"
L["Check this will disable alert for buff removed from hostile targets"] = "勾选此选项以关闭敌方增益结束通报"
L["Disable Spell Casting"] = "禁用敌方读条技能"
L["Chech this will disable alert for spell being casted to friendly targets"] = "勾选此选项以关闭敌方读条技能通报"
L["Disable special abilities"] = "禁用敌方特殊技能"
L["Check this will disable alert for instant-cast important abilities"] = "勾选此选项以关闭敌方特殊技能通报"
L["Disable friendly interrupt"] = "禁用友方打断技能"
L["Check this will disable alert for successfully-landed friendly interrupting abilities"] = "勾选此选项以关闭敌方打断技能成功的通报"
L["Buff Applied"] = "敌方增益技能"
L["Target and Focus Only"] = "仅目标或焦点"
L["Alert works only when your current target or focus gains the buff effect or use the ability"] = "仅当该技能是你的目标或焦点使用或增益出现在你的目标或焦点身上才语音通报"
L["Alert Drinking"] = "通报正在进食"
L["In arena, alert when enemy is drinking"] = "在竞技场中通报敌方玩家正在进食"
L["PvP Trinketed Class"] = "徽章职业提示"
L["Also announce class name with trinket alert when hostile targets use PvP trinket in arena"] = "在竞技场中,通报徽章的同时提示使用徽章的职业"
L["General Abilities"] = "通用技能"
L["|cffFF7D0ADruid|r"] = "|cffFF7D0A德鲁伊|r"
L["|cffF58CBAPaladin|r"] = "|cffF58CBA圣骑士|r"
L["|cffFFF569Rogue|r"] = "|cffFFF569潜行者|r"
L["|cffC79C6EWarrior|r"] = "|cffC79C6E战士|r"
L["|cffFFFFFFPriest|r"] = "|cffFFFFFF牧师|r"
L["|cff0070daShaman|r"] = "|cff0070DE萨满|r"
L["|cff0070daShaman (Totems)|r"] = true
L["|cff69CCF0Mage|r"] = "|cff69CCF0法师|r"
L["|cffC41F3BDeath Knight|r"] = "|cffC41F3B死亡骑士|r"
L["|cffABD473Hunter|r"] = "|cffABD473猎人|r"
L["|cFF00FF96Monk|r"] = "|cFF558A84武僧|r"
L["|cffA330C9Demon Hunter|r"] = "|cffA330C9?|r"
L["Buff Down"] = "敌方增益结束"
L["Spell Casting"] = "敌方读条技能"
L["BigHeal"] = "大型治疗法术"
L["BigHeal_Desc"] = "强效治疗术 神圣之光 强效治疗波 治疗之触"
L["Resurrection"] = "复活技能"
L["Resurrection_Desc"] = "复活术 救赎 先祖之魂 复活"
L["|cff9482C9Warlock|r"] = "|cff9482C9术士|r"
L["Special Abilities"] = "敌方特殊技能"
L["Friendly Interrupt"] = "友方打断技能"
L["Spell Lock, Counterspell, Kick, Pummel, Mind Freeze, Skull Bash, Rebuke, Solar Beam, Spear Hand Strike, Wind Shear"] = "法术封锁 法术反制 脚踢 拳击 心智冰封 碎颅猛击 责难 太阳光束"

L["PvPWorldQuests"] = true
L["DisablePvPWorldQuests"] = true
L["DisablePvPWorldQuestsDesc"] = true
L["OperationMurlocFreedom"] = true

L["EnemyInterrupts"] = true
L["EnemyInterruptsDesc"] = true

L["Default / Female voice"] = "默认 / 女声"
L["Select the default voice pack of the alert"] = "选择默认语音包"
L["Optional / Male voice"] = "可选 / 男声"
L["Select the male voice"] = "选择男性语音包"
L["Optional / Neutral voice"] = "可选 / 中立"
L["Select the neutral voice"] = "选择中性语音包"
L["Gender detection"] = "性别判断"
L["Activate the gender detection"] = "开启性别判断"
L["Voice menu config"] = "语音菜单选项"
L["Choose a test voice pack"] = "选择测试语音包"
L["Select the menu voice pack alert"] = "选择菜单语音包警告"

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