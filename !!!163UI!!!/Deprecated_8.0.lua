MainMenuBarPerformanceBar:SetPoint("CENTER", MainMenuMicroButton, "CENTER", 0, 11) --SetSize(28,36) --因为8.0之前按钮大小是28,58，暴雪忘了改了

TEXT = TEXT or function(text)
    return text
end

local hbdp = LibStub("HereBeDragons-2.0")
GetPlayerMapPosition = GetPlayerMapPosition or function(unit)
    local x, y, instance = hbdp:GetPlayerZonePosition(false)
    return x, y
    --local mapId = C_Map.GetBestMapForUnit(unit)
    --if not mapId then return end
    --local player = C_Map.GetPlayerMapPosition(mapId, unit)
    --if not player then return end
    --return player:GetXY()
end

SetMapToCurrentZone = SetMapToCurrentZone or function()
    WorldMapFrame:SetMapID(C_Map.GetBestMapForUnit("player"))
end

GetCurrentMapAreaID = GetCurrentMapAreaID or function()
    if WorldMapFrame:IsVisible() then
        return WorldMapFrame:GetMapID()
    else
       return C_Map.GetBestMapForUnit("player")
    end
end

local cache = {}
local none = {}
GetMapNameByID = GetMapNameByID or function(mapID)
    if not mapID then return end
    if not cache[mapID] then
        cache[mapID] = C_Map.GetMapInfo(mapID) or none
    end
    return cache[mapID].name
end

local oldMapNames={ [4]="杜隆塔尔",[9]="莫高雷",[11]="北贫瘠之地",[13]="卡利姆多",[14]="东部王国",[16]="阿拉希高地",[17]="荒芜之地",[19]="诅咒之地",[20]="提瑞斯法林地",[21]="银松森林",[22]="西瘟疫之地",[23]="东瘟疫之地",[24]="希尔斯布莱德丘陵",[26]="辛特兰",[27]="丹莫罗",[28]="灼热峡谷",[29]="燃烧平原",[30]="艾尔文森林",[32]="逆风小径",[34]="暮色森林",[35]="洛克莫丹",[36]="赤脊山",[37]="北荆棘谷",[38]="悲伤沼泽",[39]="西部荒野",[40]="湿地",[41]="泰达希尔",[42]="黑海岸",[43]="灰谷",[61]="千针石林",[81]="石爪山脉",[101]="凄凉之地",[121]="菲拉斯",[141]="尘泥沼泽",[161]="塔纳利斯",[181]="艾萨拉",[182]="费伍德森林",[201]="安戈洛环形山",[241]="月光林地",[261]="希利苏斯",[281]="冬泉谷",[301]="暴风城",[321]="奥格瑞玛",[341]="铁炉堡",[362]="雷霆崖",[381]="达纳苏斯",[382]="幽暗城",[401]="奥特兰克山谷",[443]="战歌峡谷",[461]="阿拉希盆地",[462]="永歌森林",[463]="幽魂之地",[464]="秘蓝岛",[465]="地狱火半岛",[466]="外域",[467]="赞加沼泽",[471]="埃索达",[473]="影月谷",[475]="刀锋山",[476]="秘血岛",[477]="纳格兰",[478]="泰罗卡森林",[479]="虚空风暴",[480]="银月城",[481]="沙塔斯城",[482]="风暴之眼",[485]="诺森德",[486]="北风苔原",[488]="龙骨荒野",[490]="灰熊丘陵",[491]="嚎风峡湾",[492]="冰冠冰川",[493]="索拉查盆地",[495]="风暴峭壁",[496]="祖达克",[499]="奎尔丹纳斯岛",[501]="冬拥湖",[502]="东瘟疫之地：血色领地",[504]="达拉然",[510]="晶歌森林",[512]="远古海滩",[520]="魔枢",[521]="净化斯坦索姆",[522]="安卡赫特：古代王国",[523]="乌特加德城堡",[524]="乌特加德之巅",[525]="闪电大厅",[526]="岩石大厅",[527]="永恒之眼",[528]="魔环",[529]="奥杜尔",[530]="古达克",[531]="黑曜石圣殿",[532]="阿尔卡冯的宝库",[533]="艾卓-尼鲁布",[534]="达克萨隆要塞",[535]="纳克萨玛斯",[536]="紫罗兰监狱",[539]="吉尔尼斯",[540]="征服之岛",[541]="洛斯加尔登陆点",[542]="冠军的试炼",[543]="十字军的试炼",[544]="失落群岛",[545]="吉尔尼斯",[601]="灵魂洪炉",[602]="萨隆矿坑",[603]="映像大厅",[604]="冰冠堡垒",[605]="科赞",[606]="海加尔山",[607]="南贫瘠之地",[609]="红玉圣殿",[610]="柯尔普萨之森",[611]="吉尔尼斯城",[613]="瓦丝琪尔",[614]="无底海渊",[615]="烁光海床",[626]="双子峰",[640]="深岩之洲",[673]="荆棘谷海角",[677]="吉尔尼斯之战",[678]="吉尔尼斯",[679]="吉尔尼斯",[680]="怒焰裂谷",[681]="失落群岛",[682]="失落群岛",[683]="海加尔山",[684]="吉尔尼斯废墟",[685]="吉尔尼斯城废墟",[686]="祖尔法拉克",[687]="阿塔哈卡神庙",[688]="黑暗深渊",[689]="荆棘谷",[690]="监狱",[691]="诺莫瑞根",[692]="奥达曼",[696]="熔火之心",[697]="祖尔格拉布",[699]="厄运之槌",[700]="暮光高地",[704]="黑石深渊",[708]="托尔巴拉德",[709]="托尔巴拉德半岛",[710]="破碎大厅",[717]="安其拉废墟",[718]="奥妮克希亚的巢穴",[720]="奥丹姆",[721]="黑石塔",[722]="奥金尼地穴",[723]="塞泰克大厅",[724]="暗影迷宫",[725]="鲜血熔炉",[726]="幽暗沼泽",[727]="蒸汽地窟",[728]="奴隶围栏",[729]="生态船",[730]="能源舰",[731]="禁魔监狱",[732]="法力陵墓",[733]="黑色沼泽",[734]="旧希尔斯布莱德丘陵",[736]="吉尔尼斯城",[737]="大漩涡",[747]="托维尔失落之城",[748]="奥丹姆",[749]="哀嚎洞穴",[750]="玛拉顿",[751]="大漩涡",[752]="巴拉丁监狱",[753]="黑石岩窟",[754]="黑翼血环",[755]="黑翼之巢",[756]="死亡矿井",[757]="格瑞姆巴托",[758]="暮光堡垒",[759]="起源大厅",[760]="剃刀高地",[761]="剃刀沼泽",[762]="血色修道院",[763]="通灵学院",[764]="影牙城堡",[765]="斯坦索姆",[766]="安其拉",[767]="潮汐王座",[768]="巨石之核",[769]="旋云之巅",[770]="暮光高地",[772]="安其拉：堕落王国",[773]="风神王座",[775]="海加尔峰",[776]="格鲁尔的巢穴",[779]="玛瑟里顿的巢穴",[780]="毒蛇神殿",[781]="祖阿曼",[782]="风暴要塞",[789]="太阳之井高地",[793]="祖尔格拉布",[795]="熔火前线",[796]="黑暗神殿",[797]="地狱火城墙",[798]="魔导师平台",[799]="卡拉赞",[800]="火焰之地",[803]="魔枢",[806]="翡翠林",[807]="四风谷",[808]="迷踪岛",[809]="昆莱山",[810]="螳螂高原",[811]="锦绣谷",[813]="风暴之眼",[816]="永恒之井",[819]="暮光审判",[820]="时光之末",[823]="暗月岛",[824]="巨龙之魂",[851]="尘泥沼泽",[856]="寇魔古寺",[857]="卡桑琅丛林",[858]="恐惧废土",[860]="碎银矿脉",[862]="潘达利亚",[864]="北郡",[866]="寒脊山谷",[867]="青龙寺",[871]="血色大厅",[873]="雾纱栈道",[874]="血色修道院",[875]="残阳关",[876]="风暴烈酒酿造厂",[877]="影踪禅院",[878]="酝酿风暴",[880]="翡翠林",[881]="寇魔古寺",[882]="盎迦猴岛",[883]="突袭扎尼维斯",[884]="酿月祭",[885]="魔古山宫殿",[886]="永春台",[887]="围攻砮皂寺",[888]="幽影谷",[889]="试炼谷",[890]="纳拉其营地",[891]="回音群岛",[892]="丧钟镇",[893]="逐日岛",[894]="埃门谷",[895]="新工匠镇",[896]="魔古山宝库",[897]="恐惧之心",[898]="通灵学院",[899]="试炼场",[900]="遗忘之王古墓",[903]="双月殿",[905]="七星殿",[906]="尘泥沼泽",[907]="尘泥沼泽",[910]="卡桑琅丛林",[911]="卡桑琅丛林",[912]="王者的耐心",[914]="黑暗中的匕首",[919]="黑暗神殿",[920]="卡桑琅丛林",[922]="矿道地铁",[924]="达拉然",[925]="搏击竞技场",[928]="雷神岛",[929]="巨兽岛",[930]="雷电王座",[933]="雷神岛",[934]="雷电堡",[935]="深风峡谷",[937]="锦绣谷",[938]="怒焰之谜",[939]="丹莫罗",[940]="公海激战",[941]="霜火岭",[945]="塔纳安丛林",[946]="塔拉多",[947]="影月谷",[948]="阿兰卡峰林",[949]="戈尔隆德",[950]="纳格兰",[951]="永恒岛",[953]="决战奥格瑞玛",[955]="天神比武大会",[962]="德拉诺",[964]="血槌炉渣矿井",[969]="影月墓地",[970]="塔纳安丛林",[971]="坠落之月",[973]="坠落之月",[974]="坠落之月",[975]="坠落之月",[976]="霜寒晶壁",[978]="阿什兰",[980]="霜寒晶壁",[981]="霜寒晶壁",[982]="霜寒晶壁",[983]="卡拉波防线",[984]="奥金顿",[986]="沙塔斯城",[987]="钢铁码头",[988]="黑石铸造厂",[989]="通天峰",[990]="霜寒晶壁",[991]="坠落之月",[992]="诅咒之地",[993]="恐轨车站",[994]="悬槌堡",[995]="黑石塔上层",[1007]="破碎群岛",[1008]="永茂林地",[1009]="暴风之盾",[1010]="希尔斯布莱德丘陵",[1011]="战争之矛",[1014]="达拉然",[1015]="阿苏纳",[1017]="风暴峡湾",[1018]="瓦尔莎拉",[1020]="扭曲虚空",[1021]="破碎海滩",[1022]="冥狱深渊",[1024]="至高岭",[1026]="地狱火堡垒",[1027]="纳沙尔海湾",[1028]="破碎深渊马顿",[1031]="破碎海滩",[1032]="守望者地窟",[1033]="苏拉玛",[1034]="冥口浅湾",[1035]="苍穹要塞",[1036]="盾憩岛",[1037]="风暴峡湾",[1038]="艾萨拉",[1039]="冰冠堡垒",[1040]="虚空之光神殿",[1041]="英灵殿",[1042]="冥口峭壁",[1043]="纳格法尔号",[1044]="迷踪岛",[1045]="守望者地窟",[1046]="艾萨拉之眼",[1047]="尼斯卡拉",[1048]="翡翠梦境之路",[1049]="天空之墙",[1050]="恐痕裂隙",[1051]="恐痕裂隙",[1052]="破碎深渊马顿",[1053]="阿苏纳",[1054]="紫罗兰监狱",[1055]="苏拉玛",[1056]="大漩涡",[1057]="大漩涡",[1058]="昆莱山",[1059]="永春台",[1060]="深岩之洲",[1062]="提瑞斯法林地",[1065]="奈萨里奥的巢穴",[1066]="紫罗兰监狱",[1067]="黑心林地",[1068]="守护者圣殿",[1069]="彼岸",[1070]="旋云之巅",[1071]="火焰之地",[1072]="神射手营地",[1073]="影血堡垒",[1075]="深渊之喉",[1076]="奥杜尔",[1077]="梦境林地",[1078]="尼斯卡拉",[1079]="魔法回廊",[1080]="雷霆图腾",[1081]="黑鸦堡垒",[1082]="乌索克之巢",[1084]="薄暮岛礁",[1085]="黑暗神殿",[1086]="玛洛恩的梦魇",[1087]="群星庭院",[1088]="暗夜要塞",[1090]="托尔巴拉德",[1091]="埃索达",[1092]="秘蓝岛",[1094]="翡翠梦魇",[1096]="艾萨拉之眼",[1097]="青龙寺",[1099]="黑鸦堡垒",[1100]="卡拉赞",[1102]="魔法回廊",[1104]="魔环",[1105]="血色修道院",[1114]="勇气试炼",[1115]="卡拉赞",[1116]="萨隆矿坑",[1121]="破碎海滩",[1125]="破碎海滩",[1127]="哀嚎洞穴",[1129]="鲜血图腾洞穴",[1130]="斯坦索姆",[1131]="永恒之眼",[1132]="英灵殿",[1135]="克罗库恩",[1136]="寒脊山谷",[1137]="死亡矿井",[1139]="阿拉希盆地",[1140]="黑石山之战",[1142]="大漩涡",[1143]="诺莫瑞根",[1144]="决战影踪派",[1146]="永夜大教堂",[1147]="萨格拉斯之墓",[1148]="风神王座",[1149]="突袭破碎海滩",[1151]="红玉圣殿",[1152]="破碎深渊马顿",[1156]="风暴峡湾",[1157]="阿苏纳",[1158]="瓦尔莎拉",[1159]="至高岭",[1160]="失落冰川",[1161]="风暴烈酒酿造厂",[1164]="永恒猎场",[1165]="破碎深渊马顿",[1166]="永恒之眼",[1170]="玛凯雷",[1171]="安托兰废土",[1172]="契约大厅",[1173]="禁魔监狱",[1174]="秘蓝岛",[1177]="克罗米之死",[1178]="执政团之座",[1183]="希利苏斯角斗场",[1184]="阿古斯",[1186]="涌泉海滩",[1188]="安托鲁斯，燃烧王座",[1190]="侵入点：奥雷诺",[1191]="侵入点：博尼克",[1192]="侵入点：森加",[1193]="侵入点：奈格塔尔",[1194]="侵入点：萨古亚",[1195]="侵入点：瓦尔",[1196]="大型侵入点：深渊领主维尔姆斯",[1197]="大型侵入点：妖女奥露拉黛儿",[1198]="大型侵入点：主母芙努娜",[1199]="大型侵入点：审判官梅托",[1200]="大型侵入点：索塔纳索尔",[1201]="大型侵入点：奥库拉鲁斯",[1202]="万世熔炉",[1206]="希利苏斯",[1212]="维迪卡尔",[1215]="泰洛古斯裂隙",[1216]="泰洛古斯裂隙",[1217]="太阳之井", }
Aby_GetMapNameByID = function(mapID) return oldMapNames[mapID] end

--[[
GetCurrentMapDungeonLevel = GetCurrentMapDungeonLevel or function()
    local mapID = GetCurrentMapAreaID()
    local mapGroupID = C_Map.GetMapGroupID(mapID)
    if(not mapGroupID) then return 0 end
    local mapGroupMembersInfo C_Map.GetMapGroupMembersInfo(mapGroupID)
    if not mapGroupMembersInfo then return 0 end
    --TODO aby8
end
--]]

UnitPopupFrames = UnitPopupFrames or {}

--[[------------------------------------------------------------
UnitAura, UnitDebuff
---------------------------------------------------------------]]
function Aby_UnitAura_Proxy(UnitAuraFunc, unit, indexOrName, filterOrNil, filter, ...)
    --if type(indexOrName) == "number" then
    --    return UnitAuraFunc(unit, indexOrName, filterOrNil, filter, ...)
    --else
        for i = 1, 40 do
            local name, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, v1, nameplateShowAll, timeMod, value1, value2, value3, v3, v4, v5 = UnitAuraFunc(unit, i, filterOrNil, filter, ...)
            if not name then return end
            if name == indexOrName then return name, nil, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, v1, nameplateShowAll, timeMod, value1, value2, value3, v3, v4, v5 end
        end
    --end
end
function Aby_UnitAura(unit, indexOrName, filterOrNil, filter, ...) return Aby_UnitAura_Proxy(UnitAura, unit, indexOrName, filterOrNil, filter, ...) end
function Aby_UnitBuff(unit, indexOrName, filterOrNil, filter, ...) return Aby_UnitAura_Proxy(UnitBuff, unit, indexOrName, filterOrNil, filter, ...) end
function Aby_UnitDebuff(unit, indexOrName, filterOrNil, filter, ...) return Aby_UnitAura_Proxy(UnitDebuff, unit, indexOrName, filterOrNil, filter, ...) end

CanComplainChat = CanComplainChat or function(lineID)
    local loc = PlayerLocation:CreateFromChatLineID(lineID);
    return C_ChatInfo.CanReportPlayer(loc)
end

RegisterAddonMessagePrefix = RegisterAddonMessagePrefix or C_ChatInfo.RegisterAddonMessagePrefix
SendAddonMessage = SendAddonMessage or C_ChatInfo.SendAddonMessage

CalendarGetDate = CalendarGetDate or function()
    local date = C_Calendar.GetDate()
    return date.weekday, date.month, date.monthDay, date.year
end
CalendarGetMonth = CalendarGetMonth or function(...)
    local m = C_Calendar.GetMonthInfo(...)
    return 	m.month, m.year, m.numDays, m.firstWeekday;
end
function CalendarGetDayEvent(monthOffset, monthDay, index)
	local event = C_Calendar.GetDayEvent(monthOffset, monthDay, index);
	if (event) then
		local hour, minute;
		if (event.sequenceType == "END") then
			hour = event.endTime.hour;
			minute = event.endTime.minute;
		else
			hour = event.startTime.hour;
			minute = event.startTime.minute;
		end
		return event.title, hour, minute, event.calendarType, event.sequenceType, event.eventType, event.iconTexture, event.modStatus, event.inviteStatus, event.invitedBy, event.difficulty, event.inviteType, event.sequenceIndex, event.numSequenceDays, event.difficultyName;
	else
		return nil, 0, 0, "", "", 0, "", "", 0, "", 0, 0, 0, 0, "";
	end
end


-- EquipmentSet from Deprecated_7_2_0
do
	-- Use C_EquipmentSet.SaveEquipmentSet(equipmentSetID[, newIcon]) instead
	function SaveEquipmentSet(equipmentSetName, newIcon)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		C_EquipmentSet.SaveEquipmentSet(equipmentSetID, newIcon);
	end

	-- Use C_EquipmentSet.DeleteEquipmentSet(equipmentSetID) instead
	function DeleteEquipmentSet(equipmentSetName)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		C_EquipmentSet.DeleteEquipmentSet(equipmentSetID);
	end

	-- Use C_EquipmentSet.ModifyEquipmentSet(equipmentSetID, newName, newIcon) instead
	function ModifyEquipmentSet(oldName, newName, newIcon)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(oldName);
		C_EquipmentSet.ModifyEquipmentSet(equipmentSetID, newName, newIcon);
	end

	-- Use C_EquipmentSet.IgnoreSlotForSave(slot) instead
	function EquipmentManagerIgnoreSlotForSave(slot)
		C_EquipmentSet.IgnoreSlotForSave(slot);
	end

	-- Use C_EquipmentSet.IsSlotIgnoredForSave(slot) instead
	function EquipmentManagerIsSlotIgnoredForSave(slot)
		return C_EquipmentSet.IsSlotIgnoredForSave(slot);
	end

	-- Use C_EquipmentSet.ClearIgnoredSlotsForSave() instead
	function EquipmentManagerClearIgnoredSlotsForSave()
		C_EquipmentSet.ClearIgnoredSlotsForSave();
	end

	-- Use C_EquipmentSet.UnignoreSlotForSave(slot) instead
	function EquipmentManagerUnignoreSlotForSave(slot)
		C_EquipmentSet.UnignoreSlotForSave(slot);
	end

	-- Use C_EquipmentSet.GetNumEquipmentSets() instead
	function GetNumEquipmentSets()
		return C_EquipmentSet.GetNumEquipmentSets();
	end

	-- Use C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID) instead
	function GetEquipmentSetInfo(equipmentSetIndex)
		local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs();
		return C_EquipmentSet.GetEquipmentSetInfo(equipmentSetIDs[equipmentSetIndex]);
	end

	-- Use C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID) instead
	function GetEquipmentSetInfoByName(equipmentSetName)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		return C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID);
	end

	-- Use C_EquipmentSet.EquipmentSetContainsLockedItems(equipmentSetID) instead
	function EquipmentSetContainsLockedItems(equipmentSetName)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		return C_EquipmentSet.EquipmentSetContainsLockedItems(equipmentSetID);
	end

	-- Use C_EquipmentSet.PickupEquipmentSet(equipmentSetID) instead
	function PickupEquipmentSetByName(equipmentSetName)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		C_EquipmentSet.PickupEquipmentSet(equipmentSetID);
	end

	-- Use C_EquipmentSet.PickupEquipmentSet(equipmentSetID) instead
	function PickupEquipmentSet(equipmentSetIndex)
		local equipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs();
		C_EquipmentSet.PickupEquipmentSet(equipmentSetIDs[equipmentSetIndex]);
	end

	-- Use C_EquipmentSet.UseEquipmentSet(equipmentSetID) instead
	function UseEquipmentSet(equipmentSetName)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		C_EquipmentSet.UseEquipmentSet(equipmentSetID);
	end

	-- Use C_EquipmentSet.CanUseEquipmentSets() instead
	function CanUseEquipmentSets()
		return C_EquipmentSet.CanUseEquipmentSets();
	end

	-- Use C_EquipmentSet.GetItemIDs(equipmentSetID) instead
	function GetEquipmentSetItemIDs(equipmentSetName, returnTable)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		returnTable = returnTable or {};
		return Mixin(returnTable, C_EquipmentSet.GetItemIDs(equipmentSetID));
	end

	-- Use C_EquipmentSet.GetItemLocations(equipmentSetID) instead
	function GetEquipmentSetLocations(equipmentSetName, returnTable)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		returnTable = returnTable or {};
		return Mixin(returnTable, C_EquipmentSet.GetItemLocations(equipmentSetID));
	end

	-- Use C_EquipmentSet.GetIgnoredSlots(equipmentSetID) instead
	function GetEquipmentSetIgnoreSlots(equipmentSetName, returnTable)
		local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(equipmentSetName);
		returnTable = returnTable or {};
		return Mixin(returnTable, C_EquipmentSet.GetIgnoredSlots(equipmentSetID));
	end
end

do
	-- Power Types from deprecated_7.2.5
	SPELL_POWER_MANA = Enum.PowerType.Mana;
	SPELL_POWER_RAGE = Enum.PowerType.Rage;
	SPELL_POWER_FOCUS = Enum.PowerType.Focus;
	SPELL_POWER_ENERGY = Enum.PowerType.Energy;
	SPELL_POWER_COMBO_POINTS = Enum.PowerType.ComboPoints;
	SPELL_POWER_RUNES = Enum.PowerType.Runes;
	SPELL_POWER_RUNIC_POWER = Enum.PowerType.RunicPower;
	SPELL_POWER_SOUL_SHARDS = Enum.PowerType.SoulShards;
	SPELL_POWER_LUNAR_POWER = Enum.PowerType.LunarPower;
	SPELL_POWER_HOLY_POWER = Enum.PowerType.HolyPower;
	SPELL_POWER_ALTERNATE_POWER = Enum.PowerType.Alternate;
	SPELL_POWER_MAELSTROM = Enum.PowerType.Maelstrom;
	SPELL_POWER_CHI = Enum.PowerType.Chi;
	SPELL_POWER_INSANITY = Enum.PowerType.Insanity;
	SPELL_POWER_ARCANE_CHARGES = Enum.PowerType.ArcaneCharges;
	SPELL_POWER_FURY = Enum.PowerType.Fury;
	SPELL_POWER_PAIN = Enum.PowerType.Pain;

	-- Nothing should have been using these, but preserving since they actually existed
	SPELL_POWER_OBSOLETE = Enum.PowerType.Obsolete;
	SPELL_POWER_OBSOLETE2 = Enum.PowerType.Obsolete2;
end