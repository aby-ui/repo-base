--任务排序：数字越小，越排到最前面
zPaiXu = {
["XPitem"] = 1,            --经验物品
["XP"] = 2,                --经验
["SoulCinders"] = 3,       --灵魂薪尘
["Gold"] = 4,              --金币
["ReservoirAnima"] = 5,    --心能
["BattlePetCurrency"] = 6, --小宠物币
["VeiledAugmentRune"] = 7, --帷幕强化符文 (加力量、智力等)
["Treasure"] = 8,          --箱子
["Covenants"] = 9,         --盟约
["Campaign"] = 10,         --战役
["Equip"] = 11,            --装备
["Maw"] = 12,              --噬渊
["Reputation"] = 13,       --声望
--["BattlePet"] = 14,      --小宠物
--["Other"] = 15,          --其他
--["Ignore"] = 16,         --忽略
["Unknown"] = 17,          --未知
}

--任务类型数据
--任务ID = 自定义类型
--missionID = type(custom)
lbs = {
[2300]="XPitem", --懒散划水
[2301]="XPitem", --名师出高徒
[2302]="XPitem", --铁腕战士小队
[2303]="XPitem", --惯常勒索
[2304]="XPitem", --多喝了两杯
[2305]="XPitem", --意外延迟
[2306]="XPitem", --包裹安检
[2307]="XPitem", --海盗问题
[2169]="XP", --控制翠绿徘徊者
[2171]="XP", --通灵师的巢穴
[2172]="XP", --头狼沃尔夫兰
[2185]="XP", --腐楠暴怒
[2201]="XP", --弃誓方阵兵
[2202]="XP", --幽影团
[2235]="XP", --无人守护的裂隙
[2240]="XP", --灵魂之慰
[2257]="XP", --噬渊展览园
[2276]="XP", --枯败时代
[2287]="XP", --驱逐安德洛墨妲
[2308]="SoulCinders", --轻盈清道夫
[2309]="SoulCinders", --填饱肚子
[2310]="SoulCinders", --尖皮尖牙
[2311]="SoulCinders", --凶猛之翼
[2312]="SoulCinders", --猎人成为猎物
[2313]="SoulCinders", --破门者
[2178]="Gold", --戈姆侵扰
[2186]="Gold", --暴走的欺诈者
[2188]="Gold", --被附身的清道夫
[2203]="Gold", --制服执事者
[2207]="Gold", --延缓黑暗
[2209]="Gold", --阴影中的徘徊者
[2217]="Gold", --最终陨落
[2221]="Gold", --钢铁与忧伤之脊
[2227]="Gold", --绿色软泥和金子般的心
[2236]="Gold", --新秩序
[2243]="Gold", --调查那些调查者
[2261]="Gold", --安抚天鬃马
[2263]="Gold", --棘祸的反抗
[2271]="Gold", --侦查通灵战潮
[2282]="Gold", --饕餮的心能窃贼
[2288]="Gold", --翼狮威胁
[2168]="ReservoirAnima", --灾难般的骷髅侵扰
[2175]="ReservoirAnima", --教程：脊骨集群
[2177]="ReservoirAnima", --抓获心能走私者
[2174]="ReservoirAnima", --教程：处理碎岩
[2187]="ReservoirAnima", --收敛狂野
[2183]="ReservoirAnima", --腐楠吵闹鬼
[2191]="ReservoirAnima", --劫猎和啮咬
[2199]="ReservoirAnima", --痛苦挽歌
[2206]="ReservoirAnima", --心能回收
[2208]="ReservoirAnima", --黑暗协作
[2219]="ReservoirAnima", --受保护的亵渎者
[2223]="ReservoirAnima", --沾满软泥的水晶
[2225]="ReservoirAnima", --骸虱幼虫
[2233]="ReservoirAnima", --高塔上的恐惧之翼
[2237]="ReservoirAnima", --苛捐杂税
[2241]="ReservoirAnima", --贵族的欺诈
[2244]="ReservoirAnima", --诱捕追踪者
[2262]="ReservoirAnima", --放肆的灰烬食尸鬼
[2266]="ReservoirAnima", --击溃棘祸
[2292]="ReservoirAnima", --解决德鲁斯特
[2295]="ReservoirAnima", --教程：通灵干预
[2314]="ReservoirAnima", --心能之涌的传说
[2315]="ReservoirAnima", --心能之涌的传说
[2316]="ReservoirAnima", --心能之涌的传说
[2317]="ReservoirAnima", --心能之涌的传说
[2182]="BattlePetCurrency", --清理沼泽鹿
[2190]="BattlePetCurrency", --戴菲尔归来
[2275]="BattlePetCurrency", --如棘在喉
[2277]="BattlePetCurrency", --入侵行为
[2220]="VeiledAugmentRune", --龋齿
[2226]="VeiledAugmentRune", --守卫之怒
[2264]="VeiledAugmentRune", --摇滚罪碑
[2270]="VeiledAugmentRune", --哈利斯男爵
[2180]="Treasure", --黑暗歌利亚的暴虐
[2181]="Treasure", --狂野的戴菲尔
[2184]="Treasure", --收复暗穴
[2193]="Treasure", --碎皮具象
[2222]="Treasure", --清洗失败
[2238]="Treasure", --违法庆祝
[2265]="Treasure", --罪碑贮藏者
[2170]="Treasure", --腐心最后的安息
[2273]="Treasure", --云羽守护者
[2274]="Treasure", --通灵战潮
[2278]="Treasure", --可怕的卢吉尔
[2279]="Treasure", --光烬入侵
[2280]="Treasure", --决斗大师罗文
[2281]="Treasure", --维阿莱女士
[2285]="Treasure", --挑战柯克苏
[2286]="Treasure", --巨化憎恶
[2289]="Treasure", --阿伊拉的回响
[2290]="Treasure", --贪婪的费尔姆
[2291]="Treasure", --危险的收获
[2192]="Covenants", --森林之傲
[2210]="Covenants", --微光蝶数量过剩
[2272]="Covenants", --记忆错误
[2293]="Covenants", --窃种者
[2194]="Campaign", --战役：艾雷祖尔的暴怒
[2195]="Campaign", --战役：尖啸者禁音
[2196]="Campaign", --战役：救援符光跳跃者
[2197]="Campaign", --战役：净化被附身者
[2198]="Campaign", --战役：暗穴之末
[2211]="Campaign", --战役：黑暗低语
[2212]="Campaign", --战役：裁定者的承诺
[2213]="Campaign", --战役：拯救天驹
[2214]="Campaign", --战役：弃誓者反击战
[2215]="Campaign", --战役：战地队长之哀
[2228]="Campaign", --战役：虽被遗弃，但并非无用
[2229]="Campaign", --战役：碎骨者的宝藏
[2230]="Campaign", --战役：安卡特的黑暗
[2231]="Campaign", --战役：尼尔瓦斯卡的宏伟计划
[2232]="Campaign", --战役：骸虱灾祸
[2245]="Campaign", --战役：斯塔卡的最后一搏
[2246]="Campaign", --战役：殴骨头狼
[2247]="Campaign", --战役：不屈的查尔索克斯
[2248]="Campaign", --战役：大闪和朋友们
[2249]="Campaign", --战役：最终拼图
[2176]="Equip", --艾雷祖尔和他的族群
[2179]="Equip", --戈姆集群
[2204]="Equip", --师与徒
[2218]="Equip", --骨锻？还是骨“断”吧
[2224]="Equip", --逃离的通灵鳐
[2242]="Equip", --后补旅团
[2267]="Equip", --解构时间
[2268]="Equip", --对决成吉斯
[2283]="Equip", --泥与罚
[2284]="Equip", --母蛛螫肢
[2250]="Maw", --突破平原
[2251]="Maw", --盖拉克的复仇
[2252]="Maw", --凝团冥殇
[2253]="Maw", --消灭巨人
[2254]="Maw", --阴暗天空，黑暗未来
[2255]="Maw", --德拉沃克的阴谋
[2256]="Maw", --豪华设计
[2258]="Maw", --斩断丝线
[2259]="Maw", --绝望之影
[2260]="Maw", --克雷拉，悲哀之翼
[2296]="Maw", --噬渊：突破平原
[2297]="Maw", --噬渊：盖拉克的复仇
[2298]="Maw", --噬渊：凝团冥殇
[2299]="Maw", --噬渊：消灭巨人
[2189]="Reputation", --戈姆蛴啮咬者
[2200]="Reputation", --骄矜必败
[2205]="Reputation", --恐怖研究
[2216]="Reputation", --被误导的畸体
[2234]="Reputation", --暴走的殴骨者
[2239]="Reputation", --突袭恐惧之翼
[2269]="Reputation", --软泥和暴食者
[2294]="Reputation", --潜伏者泛滥
}