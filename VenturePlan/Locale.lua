local _, T = ...
-- See https://www.townlong-yak.com/addons/venture-plan/localization

local C, z, V, K = GetLocale(), nil
V =
    C == "zhCN" and { -- 94/94 (100%)
      "…或者不是。最好读到最后。", "第一章：法师都是近战。", "别被骗了！咕咕不是应急食品。", "一切正如预言里所说那样。", "结果并不如预言的那样。", "扭转乾坤！力挽狂澜！", "惜败。", "正如预言所说那样。", "有什么问题吗？", "走狗屎运的话可能会赢。",
      "%d 完成", "共%d个待命，其中：","    %d个已加入预设。", "    %d个可用。", "%d 已派遣", "（近战）", "（远程）", "一份由你的随从完成冒险的详细记录。", "点击：提交你的冒险报告","过期时间：", "冒险报告", "所有的随从都准备好冒险了。",
      "预设", "左键：预设随从", "即使失败也会获得该经验。", "增益最近的队友，两轮内使其造成的全部伤害提高{1}，受到的全部伤害降低{2}%。对自身造成{3}点伤害。", "正在检查健康状况...", "清除所有预设队伍", "提交冒险报告","提交你的冒险任务情况，以使插件数据库更完备。","提交步骤：","1.访问该链接：","2.在discord频道里上传以下文本：","重置冒险报告", "点击以完成", "随从生命值发生了变化。", "全部完成", "当前进度：%s |n(注：当前游戏版本，有效的进度最高为20)",
      "结果不确定", "受诅咒的冒险指南", "随从匹配指南", "使全部敌人受到负面效果，接下来的{2}轮内每次造成{1}点伤害。此效果可以多次叠加。", "对所有敌人施加负面效果，在此轮和接下来的三轮中分别造成{1}伤害。此外，受到来自最近敌人三轮内的伤害提高{2}。", "失败", "经验队(失败！只吃经验)", "完成所需时间:", "编辑预设队伍", "每过一轮，一个随机敌人会受到{}％最大生命值的攻击。",
      "每个随从可从此失败的任务中获取%s经验。", "在第%d轮时先发", "随从经验", "正在匹配...", "为{1}治疗最近的盟友。使距离最近的盟友受到的伤害增加{2}%，持续两轮。", "预设队伍中：%s", "受到的攻击：", "对一个随机敌人造成{}的伤害。", "对所有远程敌人造成{}伤害。", "在近战中对所有敌人造成{}伤害，并在三轮内增加20%的自身伤害。",
      "心能不足", "精英", "稀有", "没什么效果。", "没有考虑到所有的技能。", "未检验全部结果。", "预估：", "数量：%s", "所有敌人下轮造成的伤害降低{}%。", "所有敌人两轮内造成的伤害减少{}%。", "使最近盟友两轮受到的伤害降低5000%。", "敌人剩余生命值：%s",
      "小队中需要一名随从", "完成时间：", "奖励：", "选择随从", "一键派遣", "右键：直接派遣", "即将开始…", "目标：", "预设未派遣还可修改", "优先派遣可升一级的随从吃经验",
      "插件版本已过期。", "指南展示了一系列可能的结果，既有胜利，也有可怕的失败。", "随从等级会影响你的部队等级。", "持续轮数：", "存活轮数：%s", "需要轮数：%s", "！匹配成功，点击载入。", "点击：自动完成队伍匹配。", "用法：阅读指南，然后决定你的冒险小队的命运。", "胜利",
      "无胜利匹配", "如果开始的话会赢得: %s", "部队等级：%s |n(注：你的部队等级是随从等级的中位数向下取整数值。)", "[冷却时间：%d轮]",
      "随从","22",
	}
    or C == "zhTW" and { -- 94/94 (100%)
      "…或者不是。最好讀到最后。", "第一章：法師都是近戰。", "別被騙了！咕咕不是應急食品。", "一切正如預言里所說那樣。", "結果并不如預言的那樣。", "扭轉乾坤！力挽狂瀾！", "惜敗。", "正如預言所說那樣。", "有什么問題嗎？", "走狗屎運的話可能會贏。",
      "%d 完成", "共%d個待命，其中：","    %d個已加入預設。", "    %d個可用。", "%d 已派遣", "（近戰）", "（遠程）", "一份由你的隨從完成冒險的詳細記錄。", "點擊：提交你的冒險報告","過期時間：", "冒險報告", "所有的隨從都準備好冒險了。",
      "預設", "左鍵：預設隨從", "即使失敗也會獲得該經驗。", "增益最近的隊友，兩輪內使其造成的全部傷害提高{1}，受到的全部傷害降低{2}%。對自身造成{3}點傷害。", "正在檢查健康狀況...", "清除所有預設隊伍", "提交冒險報告","提交你的冒險任務情況，以使插件數據庫更完備。","提交步驟：","1.訪問該鏈接：","2.在discord頻道里上傳以下文本：","重置冒險報告", "點擊以完成", "隨從生命值發生了變化。", "全部完成", "當前進度：%s |n(注：當前游戲版本，有效的進度最高為20)",
      "結果不確定", "受詛咒的冒險指南", "隨從匹配指南", "使全部敵人受到負面效果，接下來的{2}輪內每次造成{1}點傷害。此效果可以多次疊加。", "對所有敵人施加負面效果，在此輪和接下來的三輪中分別造成{1}傷害。此外，受到來自最近敵人三輪內的傷害提高{2}。", "失敗", "經驗隊(失敗！只吃經驗)", "完成所需時間:", "編輯預設隊伍", "每過一輪，一個隨機敵人會受到{}％最大生命值的攻擊。",
      "每個隨從可從此失敗的任務中獲取%s經驗。", "在第%d輪時先發", "隨從經驗", "正在匹配...", "為{1}治療最近的盟友。使距離最近的盟友受到的傷害增加{2}%，持續兩輪。", "預設隊伍中：%s", "受到的攻擊：", "對一個隨機敵人造成{}的傷害。", "對所有遠程敵人造成{}傷害。", "在近戰中對所有敵人造成{}傷害，并在三輪內增加20%的自身傷害。",
      "心能不足", "精英", "稀有", "沒什么效果。", "沒有考慮到所有的技能。", "未檢驗全部結果。", "預估：", "數量：%s", "所有敵人下輪造成的傷害降低{}%。", "所有敵人兩輪內造成的傷害減少{}%。", "使最近盟友兩輪受到的傷害降低5000%。", "敵人剩余生命值：%s",
      "小隊中需要一名隨從", "完成時間：", "獎勵：", "選擇隨從", "一鍵派遣", "右鍵：直接派遣", "即將開始…", "目標：", "預設未派遣還可修改", "優先派遣可升一級的隨從吃經驗",
      "插件版本已過期。", "指南展示了一系列可能的結果，既有勝利，也有可怕的失敗。", "隨從等級會影響你的部隊等級。", "持續輪數：", "存活輪數：%s", "需要輪數：%s", "！匹配成功，點擊載入。", "點擊：自動完成隊伍匹配。", "用法：閱讀指南，然后決定你的冒險小隊的命運。", "勝利",
      "無勝利匹配", "如果開始的話會贏得: %s", "部隊等級：%s |n(注：你的部隊等級是隨從等級的中位數向下取整數值。)", "[冷卻時間：%d輪]",
      "隨從","22",
    }
    or C == "esES" and { -- 94/94 (100%)
      "\"... or not. Better read this thing to the end.\"", "\"Chapter 1: Mages Must Melee.\"", "\"Do not believe its lies! Balance druids are not emergency rations.\"", "\"Everything went as foretold.\"", "\"Nothing went as expected.\"", "\"Snatch victory from the jaws of defeat!\"", "\"So close, and yet so far.\"", "\"The outcome was as foretold.\"", "\"Was there ever any doubt?\"", "\"With your luck, there is only one way this ends.\"",
      "%d |4adventure:adventures; remaining...", "%d a total of attendants are available,among:","%d |4companion is:companions are; in a tentative party.", "%d |4companion is:companions are; ready for adventures.", "%d |4party:parties; remaining...", "(melee)", "(ranged)", "A detailed record of an adventure completed by your companions.", "Use: Feed the Cursed Adventurer's Guide.", "Adventure Expires In:", "Adventure Report", "All companions are ready for adventures.",
      "Assign Party", "Assign Tentative Party", "Awarded even if the adventurers are defeated.", "Buffs the closest ally, increasing all damage dealt by {1} and reducing all damage taken by {2}% for two turns. Inflicts {3} damage to self.", "Checking health recovery...", "Clear all tentative parties" ,"Wanted: Adventure Reports","The Cursed Adventurer's Guide hungers. Only the tales of your companions' adventures, conveyed in excruciating detail, will satisfy it.","To submit your adventure reports,","1. Visit:","2. Upload the following text in the logs channel:","Reset Adventure Reports", "Click to complete", "Companion health has changed.", "Complete All", "Current Progress: %s",
      "Curse of Uncertainty", "Cursed Adventurer's Guide", "Cursed Tactical Guide", "Debuffs all enemies, dealing {1} damage during each of the next {2} turns. Multiple applications of this effect overlap.", "Debuffs all enemies, dealing {1} damage this turn and during each of the next three turns. Additionally, increases all damage taken by the nearest enemy by {2} for three turns.", "Defeated", "Doomed Run", "Duration:", "Edit party", "Every other turn, a random enemy is attacked for {}% of their maximum health.",
      "Failing this mission grants %s to each companion.", "First cast during turn %d.", "Follower XP", "Futures considered:", "Heals the closest ally for {1}, and increases all damage taken by the ally by {2}% for two turns.", "In Tentative Party - %s", "Incoming attacks:", "Inflicts {} damage to a random enemy.", "Inflicts {} damage to all enemies at range.", "Inflicts {} damage to all enemies in melee, and increases own damage dealt by 20% for three turns.",
      "Insufficient anima", "Elite", "Rare", "It does nothing.", "Not all abilities have been taken into account.", "Not all outcomes have been examined.", "Preliminary:", "Quantity: %s", "Reduces all enemies' damage dealt by {}% during the next turn.", "Reduces all enemies' damage dealt by {}% for two turns.", "Reduces the damage taken by the closest ally by 5000% for two turns.", "Remaining enemy health: %s",
      "Requires a companion in the party", "Returning soon:", "Rewards:", "Select adventurers", "Send Tentative Parties", "Start the adventure", "Starting soon...", "Targets:", "Tentative parties can be changed until you click %s.", "Tentatively assign these rookies to this adventure.",
      "The Guide may be out of date.", "The guide shows you a number of possible futures. In some, the adventure ends in triumph; in others, a particularly horrible failure.", "These companions currently affect your troop level:", "Ticks:", "Turns survived: %s", "Turns taken: %s", "Use: Interrupt the guide's deliberations.", "Use: Let the book select troops and battle tactics.", "Use: Read the guide, determining the fate of your adventuring party.", "Victorious",
      "Victory could not be guaranteed.", "Would win if started in: %s", "Your troop level is the median level of your companions (%s), rounded down. It does not decrease when you recruit additional companions.", "[CD: %dT]",
	  "Follwer","22",
    }
    or C == "esMX" and { -- 94/94 (100%)
      "\"... or not. Better read this thing to the end.\"", "\"Chapter 1: Mages Must Melee.\"", "\"Do not believe its lies! Balance druids are not emergency rations.\"", "\"Everything went as foretold.\"", "\"Nothing went as expected.\"", "\"Snatch victory from the jaws of defeat!\"", "\"So close, and yet so far.\"", "\"The outcome was as foretold.\"", "\"Was there ever any doubt?\"", "\"With your luck, there is only one way this ends.\"",
      "%d |4adventure:adventures; remaining...", "%d a total of attendants are available,among:","%d |4companion is:companions are; in a tentative party.", "%d |4companion is:companions are; ready for adventures.", "%d |4party:parties; remaining...", "(melee)", "(ranged)", "A detailed record of an adventure completed by your companions.", "Use: Feed the Cursed Adventurer's Guide.", "Adventure Expires In:", "Adventure Report", "All companions are ready for adventures.",
      "Assign Party", "Assign Tentative Party", "Awarded even if the adventurers are defeated.", "Buffs the closest ally, increasing all damage dealt by {1} and reducing all damage taken by {2}% for two turns. Inflicts {3} damage to self.", "Checking health recovery...", "Clear all tentative parties" ,"Wanted: Adventure Reports","The Cursed Adventurer's Guide hungers. Only the tales of your companions' adventures, conveyed in excruciating detail, will satisfy it.","To submit your adventure reports,","1. Visit:","2. Upload the following text in the logs channel:","Reset Adventure Reports", "Click to complete", "Companion health has changed.", "Complete All", "Current Progress: %s",
      "Curse of Uncertainty", "Cursed Adventurer's Guide", "Cursed Tactical Guide", "Debuffs all enemies, dealing {1} damage during each of the next {2} turns. Multiple applications of this effect overlap.", "Debuffs all enemies, dealing {1} damage this turn and during each of the next three turns. Additionally, increases all damage taken by the nearest enemy by {2} for three turns.", "Defeated", "Doomed Run", "Duration:", "Edit party", "Every other turn, a random enemy is attacked for {}% of their maximum health.",
      "Failing this mission grants %s to each companion.", "First cast during turn %d.", "Follower XP", "Futures considered:", "Heals the closest ally for {1}, and increases all damage taken by the ally by {2}% for two turns.", "In Tentative Party - %s", "Incoming attacks:", "Inflicts {} damage to a random enemy.", "Inflicts {} damage to all enemies at range.", "Inflicts {} damage to all enemies in melee, and increases own damage dealt by 20% for three turns.",
      "Insufficient anima", "Elite", "Rare", "It does nothing.", "Not all abilities have been taken into account.", "Not all outcomes have been examined.", "Preliminary:", "Quantity: %s", "Reduces all enemies' damage dealt by {}% during the next turn.", "Reduces all enemies' damage dealt by {}% for two turns.", "Reduces the damage taken by the closest ally by 5000% for two turns.", "Remaining enemy health: %s",
      "Requires a companion in the party", "Returning soon:", "Rewards:", "Select adventurers", "Send Tentative Parties", "Start the adventure", "Starting soon...", "Targets:", "Tentative parties can be changed until you click %s.", "Tentatively assign these rookies to this adventure.",
      "The Guide may be out of date.", "The guide shows you a number of possible futures. In some, the adventure ends in triumph; in others, a particularly horrible failure.", "These companions currently affect your troop level:", "Ticks:", "Turns survived: %s", "Turns taken: %s", "Use: Interrupt the guide's deliberations.", "Use: Let the book select troops and battle tactics.", "Use: Read the guide, determining the fate of your adventuring party.", "Victorious",
      "Victory could not be guaranteed.", "Would win if started in: %s", "Your troop level is the median level of your companions (%s), rounded down. It does not decrease when you recruit additional companions.", "[CD: %dT]",
	  "Follwer","22",
    }
    or C == "deDE" and { -- 0/94 (0%)
    }
    or C == "frFR" and { -- 0/94 (0%)
    }
    or C == "itIT" and { -- 0/94 (0%) 
    }
    or C == "koKR" and { -- 0/94 (0%)
    }
    or C == "ruRU" and { -- 0/94 (0%)
    }
    or C == "ptBR" and { -- 0/94 (0%)
    } or nil
K = V and {
      "\"... or not. Better read this thing to the end.\"", "\"Chapter 1: Mages Must Melee.\"", "\"Do not believe its lies! Balance druids are not emergency rations.\"", "\"Everything went as foretold.\"", "\"Nothing went as expected.\"", "\"Snatch victory from the jaws of defeat!\"", "\"So close, and yet so far.\"", "\"The outcome was as foretold.\"", "\"Was there ever any doubt?\"", "\"With your luck, there is only one way this ends.\"",
      "%d |4adventure:adventures; remaining...", "%d a total of attendants are available,among:","%d |4companion is:companions are; in a tentative party.", "%d |4companion is:companions are; ready for adventures.", "%d |4party:parties; remaining...", "(melee)", "(ranged)", "A detailed record of an adventure completed by your companions.", "Use: Feed the Cursed Adventurer's Guide.", "Adventure Expires In:", "Adventure Report", "All companions are ready for adventures.",
      "Assign Party", "Assign Tentative Party", "Awarded even if the adventurers are defeated.", "Buffs the closest ally, increasing all damage dealt by {1} and reducing all damage taken by {2}% for two turns. Inflicts {3} damage to self.", "Checking health recovery...", "Clear all tentative parties" ,"Wanted: Adventure Reports","The Cursed Adventurer's Guide hungers. Only the tales of your companions' adventures, conveyed in excruciating detail, will satisfy it.","To submit your adventure reports,","1. Visit:","2. Upload the following text in the logs channel:","Reset Adventure Reports", "Click to complete", "Companion health has changed.", "Complete All", "Current Progress: %s",
      "Curse of Uncertainty", "Cursed Adventurer's Guide", "Cursed Tactical Guide", "Debuffs all enemies, dealing {1} damage during each of the next {2} turns. Multiple applications of this effect overlap.", "Debuffs all enemies, dealing {1} damage this turn and during each of the next three turns. Additionally, increases all damage taken by the nearest enemy by {2} for three turns.", "Defeated", "Doomed Run", "Duration:", "Edit party", "Every other turn, a random enemy is attacked for {}% of their maximum health.",
      "Failing this mission grants %s to each companion.", "First cast during turn %d.", "Follower XP", "Futures considered:", "Heals the closest ally for {1}, and increases all damage taken by the ally by {2}% for two turns.", "In Tentative Party - %s", "Incoming attacks:", "Inflicts {} damage to a random enemy.", "Inflicts {} damage to all enemies at range.", "Inflicts {} damage to all enemies in melee, and increases own damage dealt by 20% for three turns.",
      "Insufficient anima", "Elite", "Rare", "It does nothing.", "Not all abilities have been taken into account.", "Not all outcomes have been examined.", "Preliminary:", "Quantity: %s", "Reduces all enemies' damage dealt by {}% during the next turn.", "Reduces all enemies' damage dealt by {}% for two turns.", "Reduces the damage taken by the closest ally by 5000% for two turns.", "Remaining enemy health: %s",
      "Requires a companion in the party", "Returning soon:", "Rewards:", "Select adventurers", "Send Tentative Parties", "Start the adventure", "Starting soon...", "Targets:", "Tentative parties can be changed until you click %s.", "Tentatively assign these rookies to this adventure.",
      "The Guide may be out of date.", "The guide shows you a number of possible futures. In some, the adventure ends in triumph; in others, a particularly horrible failure.", "These companions currently affect your troop level:", "Ticks:", "Turns survived: %s", "Turns taken: %s", "Use: Interrupt the guide's deliberations.", "Use: Let the book select troops and battle tactics.", "Use: Read the guide, determining the fate of your adventuring party.", "Victorious",
      "Victory could not be guaranteed.", "Would win if started in: %s", "Your troop level is the median level of your companions (%s), rounded down. It does not decrease when you recruit additional companions.", "[CD: %dT]",
	  "Follwer","All",
}

local L = K and {}
for i=1,K and #K or 0 do
	L[K[i]] = V[i]
end

T.LT = L or nil