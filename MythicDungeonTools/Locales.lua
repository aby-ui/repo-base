--[[------------------------------------------------------------
zhCN locale by 163UI
---------------------------------------------------------------]]

local name, addon = ...
local L = CoreBuildLocale()
addon.L = L

if not (GetLocale() == "zhCN" or GetLocale() == "zhTW") then
    return
end

--------------- MethodDungeonTools.lua -----------------
L["Mythic Dungeon Tools"] = "大秘路线"
L["Click to toggle AddOn Window"] = "左键打开窗口"
L["Right-click to lock Minimap Button"] = "右键锁定小地图按钮"
--L["Default"] = "默认"
--L["<New Preset>"] = "<新建预案>"

--[[
local i = 1
while true do
  local insID = EJ_GetInstanceByIndex(i, false)
  if not insID then break else i=i+1 end
  local name, _, _, _, _, _, mapID = EJ_GetInstanceInfo(insID)
  print(insID, name)
end
]]
local dungeonList = {
    [1] = "Black Rook Hold",             --740
    [2] = "Cathedral of Eternal Night",  --900
    [3] = "Court of Stars",              --800
    [4] = "Darkheart Thicket",           --762
    [5] = "Eye of Azshara",              --716
    [6] = "Halls of Valor",              --721
    [7] = "Maw of Souls",                --727
    [8] = "Neltharion's Lair",           --767
    [9] = "Return to Karazhan Lower",    --860
    [10] = "Return to Karazhan Upper",   --860
    [11] = "Seat of the Triumvirate",    --945
    [12] = "The Arcway",                 --726
    [13] = "Vault of the Wardens",       --707
    [14] = " >Battle for Azeroth",       --0
    [15] = "Atal'Dazar",                 --968
    [16] = "Freehold",                   --1001
    [17] = "Kings' Rest",                --1041
    [18] = "Shrine of the Storm",        --1036
    [19] = "Siege of Boralus",           --1023
    [20] = "Temple of Sethraliss",       --1030
    [21] = "The MOTHERLODE!!",           --1012
    [22] = "The Underrot",               --1022
    [23] = "Tol Dagor",                  --1002
    [24] = "Waycrest Manor",             --1021
    [25] = "Mechagon - Junkyard",        --1178
    [26] = "Mechagon - Workshop",        --1178
    [27] = " >Legion",                   --0
}

--[[
local list = { 740,900,800,762,716,721,727,767,860,860,945,726,707,0,968,1001,1041,1036,1023,1030,1012,1022,1002,1021,1178,1178,0 }
local floors = {}
for i, id in ipairs(list) do
    floors[i] = {}
    if id ~= 0 then
        local name, _, _, _, _, _, mapID = EJ_GetInstanceInfo(id)
        local mapGroupID = C_Map.GetMapGroupID(mapID)
        if not mapGroupID then
            floors[i][1] = C_Map.GetMapInfo(mapID).name
        else
            local mapGroupMembersInfo = C_Map.GetMapGroupMembersInfo(mapGroupID);
            for j, v in ipairs(mapGroupMembersInfo) do
                floors[i][j] = v.name
            end
        end
    end
end
wowluacopy(floors)
--]]

MDT_DungeonSubLevels_zhCN = {
    {
        "渡鸦墓地",
        "大礼堂",
        "渡鸦堡",
        "渡鸦栖木",
        "拉文凯斯领主大厅",
        "渡鸦之冠",
    },
    {
        "月之圣殿",
        "黎明森林",
        "翡翠档案室",
        "辉光之路",
        "艾露恩圣器室",
    },
    { "群星庭院", "宝石庄园", "露台", },
    { "黑心林地", },
    { "艾萨拉之眼", },
    { "至高之门", "永恒猎场", "英灵殿", },
    { "冥口峭壁", "堡垒", "纳格法尔号", },
    { "奈萨里奥的巢穴", },
    {
        "主宰的露台",
        "歌剧院楼座",
        "会客间",
        "宴会厅",
        "上层马厩",
        "仆役宿舍",
    },
    {
        "下层断阶",
        "上层断阶",
        "展览馆",
        "守护者的图书馆",
        "图书馆一层",
        "上层图书馆",
        "象棋大厅",
        "虚空异界",
    },
    { "执政团之座", },
    { "魔法回廊", },
    { "守望者庭院", "守望者地窟", "背叛者地窟", },
    nil,
    { "阿塔达萨", "献祭之池", },
    { "自由镇", },
    { "诸王之眠", },
    { "风暴神殿", "风暴之陨", },
    { "围攻伯拉勒斯", "围攻伯拉勒斯(楼上)",},
    { "塞塔里斯神庙", "塞塔里斯中庭", },
    { "暴富矿区！！", },
    { "地渊孢林", "破灭沉降梯", },
    {
        "托尔达戈",
        "排水道",
        "海狱",
        "禁闭室",
        "军官区",
        "狱长棱堡",
        "狱长平台",
    },
    { "大堂", "上层", "地窖", "墓穴", "裂隙", },
    { "麦卡贡岛", "麦卡贡岛（通道）", },
    { "机械天穹", "废物管道", "地渊废料场", "麦卡贡市", },
    nil
}

L["Black Rook Hold"] = "黑鸦堡"
L["Cathedral of Eternal Night"] = "永夜大教堂"
L["Court of Stars"] = "群星庭院"
L["Darkheart Thicket"] = "黑心林地"
L["Eye of Azshara"] = "艾萨拉之眼"
L["Halls of Valor"] = "英灵殿"
L["Maw of Souls"] = "噬魂之喉"
L["Neltharion's Lair"] = "奈萨里奥的巢穴"
L["Return to Karazhan Lower"] = "重返卡拉赞下层"
L["Return to Karazhan Upper"] = "重返卡拉赞上层"
L["Seat of the Triumvirate"] = "执政团之座"
L["The Arcway"] = "魔法回廊"
L["Vault of the Wardens"] = "守望者地窟"
L[" >Battle for Azeroth"] = " >8.0争霸艾泽拉斯"
L["Atal'Dazar"] = "阿塔达萨"
L["Freehold"] = "自由镇"
L["Kings' Rest"] = "诸王之眠"
L["Shrine of the Storm"] = "风暴神殿"
L["Siege of Boralus"] = "围攻伯拉勒斯"
L["Temple of Sethraliss"] = "塞塔里斯神庙"
L["The MOTHERLODE!!"] = "暴富矿区！！"
L["The Underrot"] = "地渊孢林"
L["Tol Dagor"] = "托尔达戈"
L["Waycrest Manor"] = "维克雷斯庄园"
L["Mechagon - Junkyard"] = "麦卡贡行动-垃圾场"
L["Mechagon - Workshop"] = "麦卡贡行动-车间"
L[" >Legion"] = " >7.0军团再临"

L["Select a dungeon and navigate to different sublevels"] = "选择一个副本并查看不同楼层的地图"
L["Click to select enemies\nCTRL-Click to single-select enemies\nSHIFT-Click to select enemies and create a new pull"] = "点击选择每波要杀的怪\n按住CTRL点击可选择单个小怪\n按住SHIFT点击可选择并新建一波"
L["Manage, share and collaborate on presets"] = "管理、分享和协作预案"
L["Customize dungeon options"] = "选择词缀和副本层数，用于分享分类"
L["Create and manage your pulls\nRight click for more options"] = "增加和修改每波小怪列表\n右键有清空插入等选项"

L["New"] = "新建"
L["Rename"] = "改名"
L["Import"] = "导入"
L["Export"] = "导出"
L["Delete"] = "删除"
L["Delete "] = "删除 "
L["Share"] = "分享"
L["Sending"] = "发送中..."
L["The selected affixes are not the ones of the current week"] = "所选词缀不是本周词缀"
L["Click to switch to current week"] = "点击切换到本周词缀"
L["Dungeon Level"] = "大秘层数"
L["Empty"] = "空（不复制）"
L["Preset "] = "预案 "
L["Reset "] = "重置 "
L["Cannot create preset '"] = "无法创建预案'"
L["' already exists"] = "'已经存在"
L["Invalid import string"] = "无效的导入字符串"
L["Create"] = "创建"
L["Cannot rename preset to '"] = "无法重命名预案为'"
L["Cancel"] = "取消"
L["Clear"] = "清空"
L["Reset"] = "重置"
L["Affixes"] = "词缀"
L["Import Preset:"] = "导入预案："
L["Preset name:"] = "预案名称："
L["Use as a starting point:"] = "复制以下预案已有的内容："
L["Insert new Preset Name:"] = "输入新的预案名称"
L["Preset Export:"] = "预案导出："

L["Import Preset"] = "导入预案"
L["New Preset"] = "新建预案"
L["Rename Preset"] = "改名预案"
L["Preset Export"] = "预案导出"
L["Delete Preset"] = "删除预案"
L["Reset Preset"] = "重置预案"

L["Level "] = "等级 "
L["Forces: %d\nTotal: %d/%d"] = "进度值：%d\n总进度：%d/%d"
L["\nTotal :"] = "\n 总计 "

L["MDI"] = "比赛选项"
L["MDI Mode"] = "MDI模式"
L["Seasonal Affix:"] = "赛季词缀"
L["Beguiling 1 Void"] = "迷醉：奥暴"
L["Beguiling 2 Tides"] = "迷醉：免控"
L["Beguiling 3 Ench."] = "迷醉：反伤"
L["Reaping"] = "收割"
L["Awakened A"] = "觉醒A"
L["Awakened B"] = "觉醒B"
L["Freehold:"] = "自由镇事件"
L["1. Cutwater"] = "乔里(追狗)"
L["2. Blacktooth"] = "拉乌尔(拳手)"
L["3. Bilge Rats"] = "尤朵拉(喝酒)"
L["Join Crew"] = "完成事件"

L["  Join Crew:"] = "完成事件:"
L["Blacktooth"] = "黑齿拳手"
L["Cutwater"] = "追狗"
L["Bilge Rats"] = "喝酒"

L["  Faction:"] = "  玩家阵营:"
L["Horde"] = "部落"
L["Alliance"] = "联盟"


--- AceGUIWidget-MythicDungeonToolsPullButton.lua ---
L["+ Add pull"] = "+ 新增一波"
L["Move up"] = "向上移动"
L["Move down"] = "向下移动"
L["Insert before"] = "在前面插入"
L["Insert after"] = "在后面插入"
L["Merge up"] = "向上合并"
L["Merge down"] = "向下合并"
L["Close"] = "关闭"
L["Merge"] = "合并"

--- EnemyInfo.lua ---
L["Enemy Info"] = "怪物信息"

L["Stealth"] = "潜行"
L["Stealth Detect"] = "侦测潜行"
L["NPC Id"] = "NPC Id"
L["Health"] = "生命值"
L["Creature Type"] = "生物类型"
L["Level"] = "等级"
L["Enemy Forces"] = "进度值"
L["Affected by:"] = "有效技能（仅供参考）："

L["Stun"] = "昏迷"
L["Sap"] = "闷棍"
L["Incapacitate"] = "分筋错骨(武僧)"
L["Repentance"] = "忏悔(圣骑士)"
L["Disorient"] = "迷惑"
L["Banish"] = "残废术(术士)"
L["Fear"] = "恐惧"
L["Root"] = "定身"
L["Polymorph"] = "变形"
L["Shackle Undead"] = "束缚亡灵(牧师)"
L["Mind Control"] = "精神控制(牧师)"
L["Grip"] = "死亡之握(DK)"
L["Knock"] = "击退"
L["Silence"] = "沉默"
L["Taunt"] = "嘲讽"
L["Control Undead"] = "控制亡灵(DK)"
L["Enslave Demon"] = "奴役恶魔(术士)"
L["Slow"] = "减速"
L["Imprison"] = "禁锢(DH)"

L["Automatic Coloring"] = "自动染色"
L["Automatically color pulls"] = "对每波怪自动染色"
L["Local color blind mode"] = "色弱模式"
L["Choose preferred color palette"] = "选择配色方案"
L["Apply to preset"] = "应用到预案"
L["Click to adjust color settings."] = "点击调整颜色设置."
L["Open MDI override options"] = "打开比赛选项，可以选择方尖碑类型和自由镇事件等"

L["Rainbow"] = "彩虹"
L["Black and Yellow"] = "黑黄"
L["Red, Green and Blue"] = "红绿蓝"
L["High Contrast"] = "高对比度"
L["Color Blind Friendly"] = "色弱友好"
L["Custom"] = "自定义"

L["Please report any bugs on https://github.com/Nnoggie/MythicDungeonTools/issues"] = "遇到bug请去 https://github.com/Nnoggie/MythicDungeonTools/issues 报告"
L["Hold CTRL to single-select enemies."] = "按住CTRL键单独选择一个敌人"
L["Hold SHIFT to create a new pull while selecting enemies."] = "选择敌人时按住SHIFT键创建新的一波"
L["Hold SHIFT to delete all presets with the delete preset button."] = "按住SHIFT点击删除按钮，可删除全部方案"
L["Right click a pull for more options."] = "右键点击选好的一波怪有更多选项"
L["Right click an enemy to open the enemy info window."] = "右键点击地图上的一个敌人可以打开怪物信息窗口"
L["Drag the bottom right edge to resize MDT."] = "拖住窗口右下边缘可以缩放"
L["Click the fullscreen button for a maximized view of MDT."] = "点击全屏按钮可以最大化MDT视图"
L["Use /mdt reset to restore the default position and scale of MDT."] = "使用/mdt reset命令可重置所有位置和缩放"
L["Mouseover the Live button while in a group to learn more about Live mode."] = "在小队中时，鼠标放在Live按钮上可以了解更多Live模式信息"
L["You are using MDT. You rock!"] = "你正在使用MDT，你太牛逼了!"
L["You can choose from different color palettes in the automatic pull coloring settings menu."] = "你可以在自动染色菜单里，选择不同的配色方案"
L["You can cycle through different floors by holding CTRL and using the mousewheel."] = "你可以按住CTRL并滚动鼠标滚轮选择不同的副本楼层"
L["You can cycle through dungeons by holding ALT and using the mousewheel."] = "你可以按住ALT并滚动鼠标滚轮选择不同的副本"
L["Mouseover a patrolling enemy with a blue border to view the patrol path."] = "鼠标放在蓝边框的巡逻怪上可以看到巡逻路线"
L["Expand the top toolbar to gain access to drawing and note features."] = "展开顶部的工具栏来操作绘图和笔记功能"

--- DungeonEnemies.lua ---
L["Forces: "] = "进度 "
L["\n\n[Right click for more info]"] = "\n\n[右键点击显示详情]"
L["Risen Soul"] = "复生之魂(近战给坦克叠层)"
L["Tormented Soul"] = "被折磨的幽魂(远程读条)"
L["Lost Soul"] = "失落的灵魂(地上紫圈死后自爆)"
L["Reaping: "] = "收割 "

--[[
a = {}
for d,v in pairs(MythicDungeonTools.dungeonEnemies) do
  if d >= 15 then for _, e in pairs(v) do a[#a+1] = e.id end end
end
table.sort(a) wowluacopy(a)
chcp 65001
curl -Is https://cn.wowhead.com/npc=\1 |find "Location" >> npcs.txt
--]]
L.NPCS = {
[68819]='魔法之眼',
[122963]='莱赞',
[122965]='沃卡尔',
[122967]='女祭司阿伦扎',
[122968]='亚兹玛',
[122969]='赞枢利巫医',
[122970]='影刃追猎者',
[122971]='达萨莱战神',
[122972]='达萨莱占卜师',
[122973]='达萨莱神官',
[122984]='达萨莱巨像',
[126497]='船舱鼠',
[126832]='天空上尉库拉格',
[126845]='乔里船长',
[126847]='拉乌尔船长',
[126848]='尤朵拉船长',
[126918]='铁潮射手',
[126919]='铁潮唤雷者',
[126928]='铁潮海盗',
[126969]='托萨克',
[126983]='哈兰-斯威提',
[127106]='铁潮军官',
[127111]='铁潮桨手',
[127119]='自由镇水手',
[127124]='自由镇酒客',
[127315]='复生图腾',
[127381]='淤泥螃蟹',
[127477]='咸水海龟',
[127479]='泥沙女王',
[127480]='钉刺寄生虫',
[127482]='下水道钳嘴鳄',
[127484]='杰斯-豪里斯',
[127485]='水鼠帮掠夺者',
[127486]='艾什凡军官',
[127488]='艾什凡火法师',
[127490]='骑士队长瓦莱莉',
[127497]='艾什凡卫士',
[127503]='科古斯狱长',
[127757]='复活的荣誉卫士',
[127799]='达萨莱荣誉卫士',
[127879]='祖尔的持盾卫士',
[128434]='飨宴的啸天龙',
[128435]='剧毒细颚龙',
[128455]='特隆加',
[128551]='铁潮猎犬',
[128649]='拜恩比吉中士',
[128650]='屠夫-血钩',
[128651]='哈达尔-黑渊',
[128652]='维克戈斯',
[128967]='艾什凡狙击手',
[128969]='艾什凡指挥官',
[129208]='恐怖船长洛克伍德',
[129214]='投币式群体打击者',
[129227]='艾泽洛克',
[129231]='瑞克莎-流火',
[129232]='商业大亨拉兹敦克',
[129366]='水鼠帮海盗',
[129367]='水鼠帮唤风者',
[129369]='铁潮袭击者',
[129370]='铁潮塑浪者',
[129371]='激流破浪者',
[129372]='黑油投弹者',
[129373]='港口猎犬训练师',
[129374]='雕骨执行者',
[129526]='水鼠帮水兵',
[129527]='水鼠帮海盗',
[129529]='黑齿格斗家',
[129547]='黑齿拳手',
[129548]='黑齿暴徒',
[129550]='水鼠帮健步者',
[129552]='蒙祖米',
[129553]='恐龙统领吉什奥',
[129559]='破浪格斗家',
[129598]='自由镇骡子',
[129599]='破浪飞刀手',
[129600]='水鼠帮盐鳞战士',
[129601]='破浪持戟者',
[129602]='铁潮执行者',
[129640]='咆哮的港口猎犬',
[129699]='路德维希-冯-托尔托伦',
[129788]='铁潮锯骨者',
[129802]='地怒者',
[129879]='铁潮斩杀者',
[129928]='铁潮火枪手',
[130011]='铁潮冒险家',
[130012]='铁潮破坏者',
[130024]='湿乎乎的船舱鼠',
[130025]='铁潮暴徒',
[130026]='水鼠帮海语者',
[130027]='艾什凡水兵',
[130028]='艾什凡炉火医师',
[130400]='铁潮打击者',
[130404]='歹徒诱捕者',
[130435]='混乱的暴徒',
[130436]='下班的劳工',
[130437]='矿井鼠',
[130485]='机械化维和者',
[130488]='机甲驾驶员',
[130521]='自由镇水手',
[130522]='自由镇水兵',
[130582]='沮丧的水手',
[130635]='巨石之怒',
[130653]='暴虐的工兵',
[130661]='风险投资公司塑地者',
[130909]='恶臭蛆虫',
[131112]='破浪打击者',
[131112]='破浪打击者',
[131318]='长者莉娅克萨',
[131383]='孢子召唤师赞查',
[131402]='地渊孢林蜱虫',
[131436]='鲜血主母选民',
[131445]='监狱守卫',
[131492]='虔诚鲜血祭司',
[131527]='维克雷斯勋爵',
[131545]='维克雷斯夫人',
[131585]='被奴役的卫士',
[131586]='宴会招待员',
[131587]='着魔的队长',
[131666]='女巫会塑棘者',
[131667]='魂缚巨像',
[131669]='锯齿猎犬',
[131670]='毒心藤蔓扭曲者',
[131677]='毒心织符者',
[131685]='符文信徒',
[131812]='毒心诱魂者',
[131817]='被感染的岩喉',
[131818]='显眼的女巫',
[131819]='女巫会占卜者',
[131821]='无面女仆',
[131823]='女巫马拉迪',
[131824]='女巫索林娜',
[131825]='女巫布里亚',
[131847]='维克雷斯狂欢者',
[131849]='发狂的射手',
[131850]='疯狂的生存专家',
[131858]='荆棘卫士',
[131863]='贪食的拉尔',
[131864]='高莱克-图尔',
[132126]='鎏金女祭司',
[132530]='库尔提拉斯先锋',
[132532]='库尔提拉斯神射手',
[133007]='不羁畸变怪',
[133345]='不靠谱的助理',
[133379]='阿德里斯',
[133384]='米利克萨',
[133389]='加瓦兹特',
[133392]='塞塔里斯的化身',
[133430]='风险投资公司策划',
[133432]='风险投资公司炼金师',
[133436]='风险投资公司灼天者',
[133463]='风险投资公司战争机器',
[133482]='蛛形地雷',
[133593]='专家技师',
[133663]='狂热的猎头者',
[133685]='亵渎之灵',
[133835]='狂野的群居血虱',
[133836]='复活的护卫',
[133852]='生命腐质',
[133870]='染病鞭笞者',
[133912]='血誓污染者',
[133935]='活化守卫',
[133943]='祖尔的爪牙',
[133944]='阿斯匹克斯',
[133963]='测试对象',
[133990]='雕骨切割者',
[134005]='页岩啃噬者',
[134012]='监工阿斯加里',
[134024]='贪吃的蛆虫',
[134041]='被感染的农夫',
[134056]='阿库希尔',
[134058]='唤风者菲伊',
[134060]='斯托颂勋爵',
[134063]='铁舟修士',
[134069]='低语者沃尔兹斯',
[134137]='神殿侍从',
[134139]='神殿骑士',
[134144]='活体激流',
[134150]='刻符者食客',
[134157]='影裔战士',
[134158]='影裔勇士',
[134173]='活化小水珠',
[134174]='影裔巫医',
[134232]='雇来的刺客',
[134251]='总管姆巴拉',
[134284]='堕落的亡语者',
[134331]='拉胡艾大王',
[134338]='海贤执行者',
[134364]='无信护卵员',
[134417]='深海祭师',
[134418]='溺水的深渊使者',
[134423]='深渊居住者',
[134514]='深渊祭师',
[134599]='灌注能量的唤雷者',
[134600]='卷沙神射手',
[134602]='隐秘之牙',
[134616]='三叶虫宝宝',
[134617]='三叶虫幼崽',
[134629]='厚鳞三叶虫骑手',
[134686]='成年三叶虫',
[134691]='静电充能苦修者',
[134739]='净化构造体',
[134990]='充能的沙尘恶魔',
[134991]='沙怒石拳战士',
[134993]='殓尸者姆沁巴',
[134994]='幽魂猎头者',
[135007]='宝珠卫士',
[135048]='血渍小猪',
[135049]='恐翼渡鸦',
[135052]='瘟疫蟾蜍',
[135167]='幽魂狂战士',
[135192]='荣耀迅猛龙',
[135204]='鬼灵妖术祭司',
[135231]='幽魂蛮兵',
[135234]='染病斗牛犬',
[135235]='幽魂兽王',
[135239]='幽魂巫医',
[135240]='灵魂精华',
[135241]='水鼠帮劫掠者',
[135245]='水鼠帮歼灭者',
[135254]='铁潮袭击者',
[135258]='铁潮掠夺者',
[135322]='黄金风蛇',
[135329]='主母布琳德尔',
[135365]='主母阿尔玛',
[135366]='黑齿纵火犯',
[135470]='征服者阿卡阿里',
[135472]='智者扎纳扎尔',
[135474]='棘刺助祭',
[135475]='屠夫库拉',
[135562]='喷毒盘蛇',
[135699]='艾什凡狱卒',
[135706]='水鼠帮掠夺者',
[135846]='沙鳞突击者',
[135975]='下班的劳工',
[135989]='祖尔的持盾卫士',
[136006]='吵闹的狂欢者',
[136076]='暴怒云气',
[136139]='机械化维和者',
[136160]='达萨大王',
[136186]='海贤灵魂师',
[136214]='风语者海蒂丝',
[136249]='元素卫士',
[136250]='灾厄妖术师',
[136295]='沉落的居民',
[136297]='被遗忘的居民',
[136347]='海贤新兵',
[136353]='巨型触须',
[136470]='零食商贩',
[136643]='艾泽里特提取器',
[136665]='艾什凡观察员',
[136934]='武器测试员',
[137029]='军械专家',
[137405]='攫握恐魔',
[137473]='守卫队长阿图',
[137474]='提玛吉大王',
[137478]='沃希女王',
[137484]='阿库尔大王',
[137485]='血誓代理',
[137486]='帕特拉女王',
[137487]='骸骨狩猎迅猛龙',
[137511]='水鼠帮杀手',
[137516]='艾什凡入侵者',
[137517]='艾什凡破坏者',
[137521]='铁潮火枪手',
[137614]='攻城恐魔',
[137713]='值钱的螃蟹',
[137716]='食泥蟹',
[137830]='苍白吞噬者',
[137940]='护卫鲨鱼',
[137969]='葬礼构造体',
[137989]='防腐液',
[138002]='雕骨切割者',
[138019]='库尔提拉斯先锋',
[138061]='风险投资公司装卸工',
[138064]='时髦的游客',
[138187]='怪诞恐魔',
[138247]='铁潮掠夺者',
[138254]='铁潮火枪手',
[138255]='艾什凡观察员',
[138281]='无面腐蚀者',
[138369]='足球炸弹流氓',
[138464]='艾什凡水手',
[138465]='艾什凡炮手',
[138489]='祖尔之影',
[139110]='火花引导者',
[139269]='阴森恐魔',
[139422]='厚麟三叶虫训者',
[139425]='疯狂的孵化者',
[139626]='淤泥水手',
[139799]='铁舟学徒',
[139800]='唤风者学徒',
[139946]='心脏守卫',
[139949]='瘟疫博士',
[140038]='深渊鳗鱼',
[141282]='库尔提拉斯步兵',
[141283]='库尔提拉斯戟兵',
[141284]='库尔提拉斯护潮者',
[141285]='库尔提拉斯神射手',
[141495]='库尔提拉斯步兵',
[141565]='库尔提拉斯步兵',
[141565]='库尔提拉斯步兵',
[141566]='雕骨切割者',
[144071]='铁潮塑浪者',
[144244]='白金拳手',
[144246]='狂犬K-U-J-0',
[144248]='首席机械师闪流',
[144249]='欧米茄破坏者',
[144286]='资产经理',
--[144293]='waste-processing-unit',
[144294]='麦卡贡工匠',
[144295]='麦卡贡机械师',
[144296]='蜘蛛坦克',
[144298]='防御机器人MKIII型',
[144299]='车间防御者',
--[144300]='mechagon-citizen',
--[144301]='living-waste',
--[144303]='g-u-a-r-d',
[145185]='仁慈侏儒4-U-型',
[150142]='屑骨垃圾投掷者',
[150143]='屑骨碾肉者',
[150146]='屑骨萨满',
[150154]='巨蜥啃骨者',
--[150159]='king-gobbamak',
[150160]='屑骨恶霸',
[150165]='粘液元素',
--[150168]='toxic-monstrosity',
[150169]='剧毒潜伏者',
[150190]='HK-8型空中压制单位',
[150195]='侏儒消化者粘液',
--[150222]='gunker',
[150249]='械顶碎击者',
[150250]='械顶轰击者',
[150251]='械顶机械师',
[150253]='战争机械爬蛛',
[150254]='废钢猎犬',
[150276]='重装拳机',
[150292]='麦卡贡骑兵',
[150293]='麦卡贡徘徊者',
--[150295]='tank-buster-mk1',
[150297]='麦卡贡重整者',
[150396]='R-21-X型空中单位',
[150547]='屑骨低鸣者',
[150712]='崔克茜-击电',
--[151325]='alarm-o-bot',
--[151476]='blastatron-x-80',
--[151649]='defense-bot-mk-i',
--[151657]='bomb-tonk',
--[151658]='strider-tonk',
--[151659]='rocket-tonk',
--[151773]='junkyard-d-0-g',
[152009]='失控的拳机',
[153755]='耐诺-万坠',
[155090]='阳极处理的线圈承载者',
[155094]='麦卡贡步兵',
[155432]='魔力使者',
[155433]='虚触使者',
[155434]='潮汐使者',
--[161124]='urgroth-breaker-of-heroes',
--[161241]='voidweaver-malthir',
--[161243]='samhrek-beckoner-of-chaos',
--[161244]='blood-of-the-corruptor',
[68819]='魔法之眼',
}
L.CREATURES = { Aberration = "畸变怪", Beast = "野兽", Critter = "小动物", Elemental = "元素生物", Giant = "巨人", Humanoid = "人型生物", Mechanical = "机械", ["Not specified"] = "未指定", Undead = "亡灵", }