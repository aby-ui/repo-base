local L = LibStub("AceLocale-3.0"):NewLocale("Details_DeathGraphs", "zhTW") 
if not L then return end 

L["STRING_BRESS"] = "戰鬥復活"
L["STRING_DEATH_DESC"] = "顯示包含玩家死亡的面板。"
L["STRING_DEATHS"] = "死亡"
L["STRING_ENCOUNTER_MAXSEGMENTS"] = "當前戰鬥最大分段"
L["STRING_ENCOUNTER_MAXSEGMENTS_DESC"] = "'當前戰鬥'所能顯示的最大分段數。"
L["STRING_ENDURANCE"] = "生存力"
L["STRING_ENDURANCE_DEATHS_THRESHOLD"] = "生存力死亡閥值"
L["STRING_ENDURANCE_DEATHS_THRESHOLD_DESC"] = "第一個|cFFFFFF00X|r玩家死亡損失生存力百分比。"
L["STRING_ENDURANCE_DESC"] = [=[生存力是概念性分數，其目標是告訴誰在團隊戰鬥中更能生存。

生存力的百分比計算只考慮首次死亡 (可以在'|cFFFFDD00設置死亡限制|r下配置')。]=]
L["STRING_FLAWLESS"] = "|cFF44FF44完美無瑕的玩家！|r"
L["STRING_HEROIC"] = "英雄"
L["STRING_HEROIC_DESC"] = "當你在英雄難度時紀錄死亡。"
L["STRING_LATEST"] = "最後"
L["STRING_MYTHIC"] = "傳奇"
L["STRING_MYTHIC_DESC"] = "當你在傳奇難度時紀錄死亡。"
L["STRING_NORMAL"] = "普通"
L["STRING_NORMAL_DESC"] = "當你在普通難度時紀錄死亡。"
L["STRING_OPTIONS"] = "選項"
L["STRING_OVERALL_DEATHS_THRESHOLD"] = "整體死亡閥值"
L["STRING_OVERALL_DEATHS_THRESHOLD_DESC"] = "第一個cFFFFFF00X | r玩家的死亡登記在整體死亡中。"
L["STRING_OVERTIME"] = "超時"
L["STRING_PLUGIN_DESC"] = [=[在首領戰鬥期間，捕獲團隊成員死亡並從中構建統計數據。

- |cFFFFFFFF當前戰鬥|r: |cFFFF9900顯示最後分段的死亡。

- |cFFFFFFFF時間線|r: |cFFFF9900顯示一個圖表，告訴他們來自首領的debuff和法術是什麼時候在團隊成員上施放並繪製代表死亡時機的線條。

- |cFFFFFFFF生存力|r: |cFFFF9900顯示一個玩家列表，其中百分比表示他們在首領戰中存活多少次。

- |cFFFFFFFF整體|r: |cFFFF9900保留一份有死亡的玩家名單以及死亡前的法術傷害。]=]
L["STRING_PLUGIN_NAME"] = "進階死亡紀錄"
L["STRING_PLUGIN_WELCOME"] = [=[歡迎來到進階死亡紀錄!


-|cFFFFFF00當前戰鬥|r: 顯示上次戰鬥的死亡，預設情況下會存儲最後兩個段的死亡，您可以在選項面板中增加此值。

- |cFFFFFF00時間線|r: 顯示您的團隊什麼時候最多人死亡，同時也顯示敵人技能的時間。

- |cFFFFFF00生存力|r: 測量玩家技能從誰在戰鬥中首先死亡，預設情況下前5名玩家將失去生存力百分比。

- |cFFFFFF00整體|r: 顯示普通死亡記錄加上玩家死亡前所受到的總體傷害。


- 您可以通過單擊鼠標右鍵來關閉視窗！]=]
L["STRING_RAIDFINDER"] = "團隊搜尋器"
L["STRING_RAIDFINDER_DESC"] = "當你在團隊蒐尋器難度時紀錄死亡。"
L["STRING_RESET"] = "重設數據"
L["STRING_SURVIVAL"] = "存活"
L["STRING_TIMELINE_DEATHS_THRESHOLD"] = "時間線死亡閥值"
L["STRING_TIMELINE_DEATHS_THRESHOLD_DESC"] = "第一個cFFFFFF00X | r玩家的死亡登記在時間線圖表中。"
L["STRING_TOOLTIP"] = "顯示死亡圖表"

