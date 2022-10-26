local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["安苏"] = "cA,郑天罡;b/,奶茶超亻;b+,灰烬的抉择;b5,Lesliejing;bz,滨西刑侦宁宇;bf,明天退游;bb,手刃恩师,逐星丶洛羽;bX,天使爱唱歌;bV,啊拉宁波;bR,寸耀兰;bQ,无名的士兵;bM,布拉德丷特皮;bI,阿啦宁波",["亚雷戈斯"] = "b/,调戏老婆,破丷咒",["影之哀伤"] = "b/,尤巴;b1,丷倾情丷;bi,狐狸娃娃;bX,Rara;bQ,伊利蛋顶红;bP,萱萱大魔王;bI,丶奈斯兔米球;bH,丨江隂饅頭丨,门当牛不对;bG,壹天尐話痨,米拉提;bE,叶俢",["燃烧之刃"] = "b/,履至尊制六合;b+,翘思慕远人;b7,毁灭苍炎;be,林克小飞侠;bX,洛丶歌,书没读好;bW,丶枯叶;bP,听说你叫噗丶;bO,牛儿憨憨;bN,丢你那星;bM,虐弑;bL,张大明白,山下有猎户;bK,丶死神降临;bI,Nibuxing;bH,萌萌然;bF,翘屁",["克洛玛古斯"] = "b/,涩狼德狼",["白银之手"] = "b+,雯浩丶,歐仔榮少;b7,潘玉魄;b6,猎屠;b5,醉卧桃花林,北城丶梦魇;b3,柏仁,丨似水流年丶;b0,白条肉肉;by,拳击社;bv,零贰肆零壹肆;bn,张小然;bh,圣骑爷爷;bf,天使小兔;bd,乄夕陽;bc,Deadtempler;bb,大雄叔叔;ba,梓嫣;bY,索楼,娇嫩的小鲨鱼;bW,碧落幽阳;bT,永之皓月;bR,霜沉;bN,妖言老君;bL,星晨軌跡;bK,丶大爺;bH,劜亇,我就进来二玩,追意;bG,手心里的聪宝,之之;bF,小柯基呀丶,Damnn,沉沦六道",["凤凰之神"] = "b+,Tjt;b6,问就删号;b5,一早;b3,八泽;bz,超级草莓芝士;bx,她把风吹走了;bw,卡西卡洛;br,丿諾灬;bh,蓝跃光;bf,爱吃喵儿的鱼;bV,安妮赫兰之弦;bT,小丶潞;bO,灌不注;bM,Anhee;bK,啤酒不是皮酒;bJ,放纵着忧伤,爱笑的加菲;bI,姬魅蓝,晴時,丨云无月;bG,心灵契约丶",["Dalaran[US]"] = "b+,Buringice",["龙骨平原"] = "b9,马戏团团长;bQ,我奶你先上;bI,我不够狠",["死亡之翼"] = "b9,夜风轻语;b4,伊腻丹;b2,汐丶诺;bz,欢笑;bv,是猫颜阿;bq,白桃丶奶茶,法号丶二楞;bo,小厚先森,清蒸牛匾;be,大熊叔叔;bZ,九龙仓丶烈风,苝落师門,莫高雷丶烈风;bY,貮囍;bV,糖三;bT,炽天使彦;bS,术嘟嘟;bR,灭咩灭;bM,遍野山色青峰;bL,丷夜色里,偏不;bK,丨布朗熊丨;bI,Gahiji;bH,南宫僕射,条野丁史大,球球不是球球;bG,胖蛋蛋儿;bF,剑仙帝",["迦拉克隆"] = "b8,張先生;bq,折戟断流;bo,泛风流年;bd,留流胡,叫我小奶;bI,圣光制裁使",["深渊之巢"] = "b8,牛春晖",["塞泰克"] = "b7,若晗",["金色平原"] = "b7,伊米希尔;bR,雲中锦書;bQ,Alois;bM,近战如何生存;bG,爱丽丝丶日怒",["???"] = "b6,就决定是你了",["主宰之剑"] = "b6,青色;b2,琉璃宸瞳;b1,Gideon;bs,北山的雷;br,紫月嬋娟;bf,三仓镇丶段坤;be,神曲之殇,魂亡;bW,莫得理萨;bQ,大红手小禹;bM,大领主飞扬;bI,可爱丶牧;bH,漩涡灬鸣人,有容丶乃;bF,甠飏",["红龙军团"] = "b6,库库林白夜",["艾露恩"] = "b6,旺福",["回音山"] = "b5,回音山灵;bM,远古列王守卫;bK,橘子味的书海",["伊森利恩"] = "b5,卫法斯;bp,水野樱;ba,晚峰揽月;bI,呱二蛋;bF,Kuchikirukia",["克尔苏加德"] = "b5,后里;ba,东里路,心随萌动;bJ,衛宮切嗣",["米奈希尔"] = "b5,狮心王瓦里安",["阿古斯"] = "b4,妖精的梦想",["无尽之海"] = "b4,鱼的脚印;by,蝎子殿下;bo,陈天歌;be,七月青歆;bF,哈哈氦",["鬼雾峰"] = "b4,土匪小头头;bP,逼小狸,逼小咩",["埃克索图斯"] = "b3,射日甜心",["布兰卡德"] = "b2,永啼鸟;bf,八千丶;bV,王思丶葱;bN,胖娃杀手;bJ,抽黑兰的大摩;bG,不德鸟,不得鸟",["丽丽（四川）"] = "b1,德里克;bs,那天阳光很好",["格瑞姆巴托"] = "b1,逗逼李二蛋;bx,仙吕下凡;bR,艾尔丶菲尔特;bM,安克瑟拉姆;bI,银枪大叔;bH,乣沂吴先生,芒果灬布丁,芒果灬乌龙;bF,乱射丨菊花,侧面增强",["泰兰德"] = "b1,玩猜猜",["奥蕾莉亚"] = "b1,仁德仁心",["罗宁"] = "b1,一五爷一;bp,王木木;bb,半日浮生;ba,丶亦衡灬;bR,哥丶有点风骚,一介莽夫;bQ,蛋灬泥;bP,橙不二;bN,二般路人德;bM,玉棠春",["芬里斯"] = "b0,Coquette;bJ,冬坏爷老祖",["雷斧堡垒"] = "bz,Wryy;bU,机智的小明仔",["幽暗沼泽"] = "by,绿色发光眼;bd,亮闪闪的世界",["荆棘谷"] = "bw,丨丶雲小白",["雷霆之王"] = "bt,风修罗;bd,陈一发",["奥特兰克"] = "bs,麦她丽卡",["能源舰"] = "bs,夜喵",["莱索恩"] = "br,爱神",["艾森娜"] = "bo,Paletteice",["影牙要塞"] = "bn,丨丶忄",["诺兹多姆"] = "bk,海的姑妈",["银松森林"] = "bj,无情的工具人;bL,射得一手好丝",["塞拉摩"] = "bh,Akadiza",["戈古纳斯"] = "bh,海盗丶",["遗忘海岸"] = "bg,混帐的天空",["伊瑟拉"] = "bg,月神之镰;bI,怕黑的小白",["霜之哀伤"] = "bf,伊诺莉;bF,启示骑士",["埃德萨拉"] = "bf,調理師花玖;bX,莫兰諦",["时光之穴"] = "be,塔拉夏",["末日行者"] = "be,信仰毁灭;bT,庆尙",["巨龙之吼"] = "be,王大菜",["熊猫酒仙"] = "bd,故梦;bQ,阿鸣;bM,村里小胖,荭豆;bF,拂尘晓,寒影丶,至清",["晴日峰（江苏）"] = "bd,熊三不列颠",["艾欧娜尔"] = "bX,笑死街头",["厄运之槌"] = "bW,小俊汐",["萨菲隆"] = "bW,番茄蛋饭",["日落沼泽"] = "bV,江洲小猎;bI,你背后的神",["艾莫莉丝"] = "bU,通天巨物",["狂热之刃"] = "bT,山风舞云",["迅捷微风"] = "bS,我被主播网爆",["埃霍恩"] = "bS,云天衡;bH,玖壹吴先森",["麦迪文"] = "bR,红色小皮皮;bM,星空二,流星宇宙",["布鲁塔卢斯"] = "bQ,Immature",["燃烧平原"] = "bP,暗夜浩劫",["燃烧军团"] = "bP,眉清目秀",["千针石林"] = "bO,勇敢牛牛",["卡德加"] = "bN,狩猎星空,寻找火星的你;bF,干净",["黑铁"] = "bN,靓佳慧;bJ,睡觉不如跳舞",["贫瘠之地"] = "bM,川川;bL,云鸿;bE,缒風",["天空之墙"] = "bL,派大星的大招",["血色十字军"] = "bL,老林,阿宁啊,风弓羽箭,必殺;bF,半点白",["国王之谷"] = "bL,元素老头;bI,Darkzhou;bF,寒風丶",["卡拉赞"] = "bL,訫随风飘逝",["冰风岗"] = "bL,Gnx;bG,Aquamancc",["神圣之歌"] = "bL,神話",["洛肯"] = "bK,渣男斩女",["黑翼之巢"] = "bK,艾伦",["血吼"] = "bI,乄虢乄",["Illidan[US]"] = "bI,Unholyooxx",["亡语者"] = "bI,全程鸥剃",["奈萨里奥"] = "bH,不是杨花,映雪红装",["霜狼"] = "bG,霜曈",["德拉诺"] = "bG,醜公",["阿纳克洛斯"] = "bG,雷丶叱咤风云",["冰霜之刃"] = "bG,夏吉尔安;bF,元素使,小冰塔",["风暴之怒"] = "bF,一尾巴抽死你",["蜘蛛王国"] = "bF,冷月寒枫"};
local lastDonators = "白条肉肉-白银之手,Coquette-芬里斯,一五爷一-罗宁,仁德仁心-奥蕾莉亚,丷倾情丷-影之哀伤,Gideon-主宰之剑,玩猜猜-泰兰德,逗逼李二蛋-格瑞姆巴托,德里克-丽丽（四川）,汐丶诺-死亡之翼,琉璃宸瞳-主宰之剑,永啼鸟-布兰卡德,丨似水流年丶-白银之手,射日甜心-埃克索图斯,柏仁-白银之手,八泽-凤凰之神,土匪小头头-鬼雾峰,鱼的脚印-无尽之海,妖精的梦想-阿古斯,伊腻丹-死亡之翼,狮心王瓦里安-米奈希尔,一早-凤凰之神,Lesliejing-安苏,后里-克尔苏加德,卫法斯-伊森利恩,北城丶梦魇-白银之手,醉卧桃花林-白银之手,回音山灵-回音山,旺福-艾露恩,库库林白夜-红龙军团,猎屠-白银之手,问就删号-凤凰之神,青色-主宰之剑,就决定是你了-???,伊米希尔-金色平原,毁灭苍炎-燃烧之刃,潘玉魄-白银之手,若晗-塞泰克,牛春晖-深渊之巢,張先生-迦拉克隆,夜风轻语-死亡之翼,马戏团团长-龙骨平原,Buringice-Dalaran[US],灰烬的抉择-安苏,Tjt-凤凰之神,歐仔榮少-白银之手,翘思慕远人-燃烧之刃,雯浩丶-白银之手,涩狼德狼-克洛玛古斯,履至尊制六合-燃烧之刃,尤巴-影之哀伤,破丷咒-亚雷戈斯,调戏老婆-亚雷戈斯,奶茶超亻-安苏,郑天罡-安苏";
local start = { year = 2018, month = 8, day = 3, hour = 7, min = 0, sec = 0 }
local now = time()
local player_shown = {}
U1Donators.players = player_shown

local topNamesOrder = {} for i, name in ipairs({ strsplit(',', topNames) }) do topNamesOrder[name] = 5000 + i end
local lastNamesOrder = {} for i, name in ipairs({ strsplit(',', lastDonators) }) do lastNamesOrder[name] = i end

local pairs, ipairs, strsplit, format = pairs, ipairs, strsplit, format

local players, player_days = {}, {}
local base64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
local function ConvertDonators(day_realm_players)
    if not day_realm_players then return end
    for realm, allday in pairs(day_realm_players) do
        for _, oneday in ipairs({strsplit(';', allday)}) do
            local date;
            for i, player in ipairs({strsplit(',', oneday)}) do
                if i == 1 then
                    local dec = (base64:find(player:sub(1,1)) - 1) * 64 + (base64:find(player:sub(2,2)) - 1)
                    local y, m, d = floor(dec/12/31)+2018, floor(dec/31)%12+1, dec%31+1
                    date = format("%04d-%02d-%02d", y, m, d)
                else
                    local fullname = player .. '-' .. (realm:gsub("%[.-%]", ""))
                    if player_days[fullname] == nil then
                        table.insert(players, fullname)
                        player_days[fullname] = date
                    end
                end
            end
        end
    end
end
local function GetPlayerNames(day_realm_players)
    if not day_realm_players then return end
    for realm, allday in pairs(day_realm_players) do
        for _, oneday in ipairs({strsplit(';', allday)}) do
            for i, player in ipairs({strsplit(',', oneday)}) do
                if i > 1 then
                    local fullname = player .. '-' .. (realm:gsub("%[.-%]", ""))
                    player_shown[fullname] = topNamesOrder[fullname] or 0
                end
            end
        end
    end
end
GetPlayerNames(recentDonators)
GetPlayerNames(U1.historyDonators)

function U1Donators:CreateFrame()
    ConvertDonators(recentDonators)
    recentDonators = nil
    ConvertDonators(U1.historyDonators)
    U1.historyDonators = nil

    table.sort(players, function(a, b)
        local order1 = lastNamesOrder[a] or topNamesOrder[a] or 9999
        local order2 = lastNamesOrder[b] or topNamesOrder[b] or 9999
        if order1 ~= order2 then return order1 < order2 end
        local _, r1 = strsplit("-", a)
        local _, r2 = strsplit("-", b)
        if r1 ~= r2 then
            if r1 == '???' then return false
            elseif r2 == '???' then return true
            else return r1 < r2; end
        end
        local day1 = player_days[a]
        local day2 = player_days[b]
        if day1 ~= day2 then return day1 > day2 end
        return a < b
    end)
    -- 排完序就不需要了
    topNames = nil
    lastNamesOrder = nil

    local f = WW:Frame("U1DonatorsFrame", UIParent, "BasicFrameTemplateWithInset"):Size(320, 500):TR(U1Frame, "TL", -10, 0):SetToplevel(1):SetFrameStrata("DIALOG")

    f.TitleText:SetText("爱不易的捐助者，谢谢你们")
    f.InsetBg:SetPoint("TOPLEFT", 4, -50)
    CoreUIMakeMovable(f)

    local scroll = CoreUICreateHybridStep1(nil, f(), nil, true, true, nil)
    WW(scroll):TL(f.InsetBg, 3, -3):BR(f.InsetBg, -2-21, 2):un() --:TL(3, -20)
    f.scroll = scroll

    local headn = TplColumnButton(f, nil, 22):SetWidth(108):SetText("玩家主角色"):SetScript("OnClick", noop):un()
    WW(headn:GetFontString()):SetFontHeight(14):un()
    local heads = TplColumnButton(f, nil, 22):SetWidth(80):SetText("服务器"):SetScript("OnClick", noop):un()
    WW(heads:GetFontString()):SetFontHeight(14):un()
    local headd = TplColumnButton(f, nil, 22):SetWidth(100):SetText("捐助时间"):SetScript("OnClick", noop):un()
    WW(headd:GetFontString()):SetFontHeight(14):un()
    CoreUIAnchor(f, "TOPLEFT", "TOPLEFT", 8, -30, "LEFT", "RIGHT", 0, 0, headn, heads, headd)

    local function fix_text_width(obj)
      obj:GetFontString():SetAllPoints()
    end

    scroll.creator = function(self, index, name)
      local row = WW(self.scrollChild):Button(name):LEFT():RIGHT():Size(0, 20)
      row:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], 'ADD')

      row.name = row:Button():Size(100, 20):EnableMouse(false):SetButtonFont(U1FCenterTextMid):SetText(111):GetButtonText():SetJustifyH("Center"):up()
      row.server = row:Button():Size(75, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(111):GetButtonText():SetJustifyH("Right"):up()
      row.firstdate = row:Button():Size(90, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(333):GetButtonText():SetJustifyH("Right"):up()

      fix_text_width(row.name)
      fix_text_width(row.server)
      fix_text_width(row.firstdate)

      CoreUIAnchor(row, "LEFT", "LEFT", 5, 0, "LEFT", "RIGHT", 5, 0, row.name, row.server, row.firstdate)
      return row:un()
    end

    scroll.getNumFunc = function()
      return #players
    end

    scroll.updateFunc = function(self, row, index)
      row.index = index
      local name, realm = strsplit('-', players[index])
      if topNamesOrder[players[index]] then row.name:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(name)) else row.name:SetText(name) end
      row.server:SetText(realm)
      row.firstdate:SetText(player_days[players[index]]);
      --row.name:GetFontString():SetTextColor(1,1,1)
      --local date_fmt = '%Y/%m/%d'
      --local txt = date(date_fmt, time())
      --row.firstdate:SetText(txt)
    end

    CoreUICreateHybridStep2(scroll, 0, 0, "TOPLEFT", "TOPLEFT", 0)

    f:Hide()

    collectgarbage()
    return f()
end

CoreOnEvent("PLAYER_ENTERING_WORLD", function()
    local origs = {}
    local addMessageReplace = function(self, msg, ...)
        msg = msg and tostring(msg) or ""
        local h, t, part1, fullname, part2 = msg:find("(\124Hplayer:(.-):.-:.-:.-\124h%[)(\124c.........-\124r%]\124h)")
        if fullname and ((U1Donators and U1Donators.players[fullname]) or (U1STAFF and U1STAFF[fullname])) then
            --local _, height = self:GetFont()
            msg = msg:sub(1,h-1) .. part1 .. '\124TInterface\\AddOns\\!!!163UI!!!\\Textures\\UI2-logo:' .. (13) .. '\124t' .. part2 .. msg:sub(t+1);
        end
        origs[self](self, msg, ...)
    end
    WithAllChatFrame(function(cf)
        if cf:GetID() == 2 then return end
        origs[cf] = cf.AddMessage
        cf.AddMessage = addMessageReplace
    end)
    return "remove"
end)