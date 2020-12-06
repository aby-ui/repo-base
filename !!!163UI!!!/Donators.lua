local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["通灵学院"] = "RD,夯大锤",["诺森德"] = "RD,哲里",["熊猫酒仙"] = "RD,你到底怕不怕;RC,欧皇橙满天;RB,小光人,射的你发慌;RA,丿锖兎丶;Q/,JohnPan;Q+,十公里,敗犬",["永恒之井"] = "RD,十里桃林",["伊森利恩"] = "RD,Lockjaw;RC,Hinataml,Anataml,痱子粉;RB,風無雨;RA,甜酒冲蛋,勾手老大爷;Q/,暗影之境丶雷;Q+,Redone,花花厷孒,北执",["冰风岗"] = "RD,小酌又黄昏;Q/,专业杀鸡拔毛",["贫瘠之地"] = "RD,灵魂超越;RC,荒野老司机,惹我半生风雪,绒布团子;RB,凰弥;RA,官人不卖艺;Q/,末白丶,小牛丹尼,大地香瓜,欧狍;Q+,Shaka,小末日,花丶雨",["克尔苏加德"] = "RC,沐雪无尘;Q+,枪手哥哥",["燃烧之刃"] = "RC,乄老白,老白乄,圣光奶嘴;RB,酒仙女,丨嫣於倾黛;RA,Goodknight,卖皮孩;Q/,疯狂的麦田丶,疯狂的麦子丶,老乄乄白,老乄白,术小鱼",["凤凰之神"] = "RC,胖胖嘚文哥丶,惯犯王,骚嘚斯奶,浮云千载,深野昂,Avogadro;RB,刮痧技师丶,灬纤尘灬;RA,Sakurall,最深情的森西,森森鸭,因幡帝丶,莫歌;Q+,壕运气,绮德丶",["白银之手"] = "RC,埃提耶什,清梦挽依,野人参;RB,琦玉老师灬,伊雪夜,开光大湿丶,一点不自律,阿尔萨喵,童話鎮;RA,雲杨,温岭胡歌,飞驰柚子,南野;Q/,陳喬恩,乱舞乄风行者,Demondark,维灬他,酒樱;Q+,雷德琪,回梦夜影,天空蔚蓝灬,这是女鬼,老王遛狗,清音梵唱,Penumbra,奶一次绿一次",["阿古斯"] = "RC,菊你太美;Q/,Deathbarbie",["埃德萨拉"] = "RC,奶油熊起司;RA,丨丶青衫;Q/,骁哥最帅;Q+,灬阿猫灬,丨丶青衫未旧",["影之哀伤"] = "RC,林空鹿饮溪;RB,挣扎,一瞒天一,丶萧默默;RA,勒子;Q/,流梳灬烟沐,懒懒空天猎;Q+,穿靴子的牛",["布兰卡德"] = "RC,血色丶阿丽塔,尐尐丶;RB,银涛溜溜,螺丝粉;Q+,欧丿二泉映月",["末日行者"] = "RC,安慕茜,愤怒的苗苗;RB,我是乱打的;Q/,舔娃;Q+,小楼一夜趴啪,腹黑骑师",["死亡之翼"] = "RC,迢迢間風月,飘雪灬;RB,求你别插进来,紫韵铭馨,莺鸢,傻比晓得;RA,Asknb,魔桀神;Q/,小栞的狐狸,老牛吃嫩草丶;Q+,丷小眼迷人丷,盗口大重九,西柚茉莉茶丶,德抽大重九,手拿大重九",["加尔"] = "RC,哲学启示录",["影牙要塞"] = "RC,付公子",["银月"] = "RC,木牛流马",["卡德加"] = "RC,一湖心静,洛丹伦二公主",["海克泰尔"] = "RC,基尔夹卤蛋;RA,旧城半夏,夜丶微凉,灵魂祭司雷尼;Q+,风中一头牛,猜心,心云",["安苏"] = "RC,战倾血爆,贰一,艾小美,红颜最倾城,不谈情怀;RB,奥科萨娜,芋头炖牛腩丶;RA,十字军的清算,魔法宅急送丶;Q/,麦普替林;Q+,只愿诗和远方,冰星心,北暝",["国王之谷"] = "RC,一笑奈何;RB,人离别,萬岁千秋,白驹氵过隙;RA,树鸟熊猫魚,索拉丶织棘者;Q/,一輪美滿,残盾;Q+,江隂馒頭,极热,尝试切他中路",["提瑞斯法"] = "RC,演员周冬雨",["洛肯"] = "RC,熊壮大猫咪",["无尽之海"] = "RC,风陌轻;RB,做你的宝搞;RA,青衣凉惹白霜;Q/,麒麟仔,食人魔魔法師,翊悬;Q+,慧者实乂橙,灬奶茶炖鸡灬,小原",["迅捷微风"] = "RC,外面有狗了,草上飞不动;RB,是与非;Q/,章鱼法",["梅尔加尼"] = "RC,小甲甲丶;Q/,悠悠德",["托塞德林"] = "RC,小青丶",["???"] = "RC,战丶小凡;Q/,来呀丨张哥,冰强砸铁锤,Montyshoot,原来是青衫呀,大俊;Q9,夜行猫;Q7,暴烈灬猪皇;Q6,霓裳梅普露,丨太宰丨,打错停手;Q4,Einino",["血色十字军"] = "RC,没有止痛药水,Tsai;RB,我是个正经人,表妹丶;RA,达拉崩吧丶,珊瑚丶海,蜡笔海盗,昨日青空;Q/,祟图,社会的榜样,爆炸糖果,席梦来;Q+,机车小迷弟",["回音山"] = "RC,夏风爽,Ellerys",["桑德兰"] = "RC,大柚子突然",["爱斯特纳"] = "RC,洛丶天依",["风暴之怒"] = "RC,盛世经典;Q+,似锦年华",["圣火神殿"] = "RC,導演丶我躺哪",["罗宁"] = "RC,轻拢慢捻;RB,灬桃兔灬,小支百威,远山之巅;RA,大圆蟀,青咿染霜华;Q/,小鷄湯;Q+,Sacrificed",["时光之穴"] = "RC,去冰三分糖",["弗塞雷迦"] = "RC,康师傅冰红茶",["格瑞姆巴托"] = "RB,你枯燥么,东华少阳君,醉酒夢红颜,小鸡球球;Q/,少女映画;Q+,哈啤穿肠过,梦扬天际",["塞拉摩"] = "RB,清丶酒",["泰兰德"] = "RB,熊熊奇妙冒险",["雷霆之王"] = "RB,格雷丶帕斯塔",["世界之树"] = "RB,瓦尔姬里",["迦拉克隆"] = "RB,空城美雪,白墨谷雨",["试炼之环"] = "RB,霜之雨彤;Q+,牛将军丶老刘",["龙骨平原"] = "RB,Romeo;Q/,战世,丶黑夜传说",["暗影之月"] = "RB,在水之湄",["荆棘谷"] = "RB,蟹老板",["金色平原"] = "RB,誰為我停留;RA,庆余,好灬好美哟",["主宰之剑"] = "RB,風吹不散长恨,年轻不讲舞德;RA,一岁可萌了;Q/,导演法;Q+,夜尽丶辰曦,快进到退休",["红云台地"] = "RB,荼荼",["冰霜之刃"] = "RB,丶铁柱",["洛丹伦"] = "RB,赛柯蕾丶血歌",["灰谷"] = "RB,蹬蹬爹",["扎拉赞恩"] = "RB,妖之骄法",["艾露恩"] = "RB,巨侠老德;RA,陆老六",["风行者"] = "RB,隔壁水果店丶",["雷斧堡垒"] = "RB,雷霆扛把子;Q+,七色的魔法使",["斩魔者"] = "RA,百山惊鸿",["玛法里奥"] = "RA,菲奈珂思",["玛瑟里顿"] = "RA,Vitamine",["阿克蒙德"] = "RA,Migo",["丽丽（四川）"] = "RA,南部丑锅锅,别闹灬;Q+,飞花轻梦丶",["阿纳克洛斯"] = "RA,还有土拨鼠",["克洛玛古斯"] = "RA,闪光伯爵",["伊利丹"] = "RA,飞行的老猫",["利刃之拳"] = "RA,马师父;Q/,丶绫波丽",["奥斯里安"] = "RA,双刀就看走",["巫妖之王"] = "Q/,海之间",["拉文凯斯"] = "Q/,甄美",["万色星辰"] = "Q/,威廉萌",["亚雷戈斯"] = "Q/,一生有你",["索瑞森"] = "Q/,雲中锦書來;Q+,雲影映暈",["玛里苟斯"] = "Q/,艾尔玛娜",["达尔坎"] = "Q/,快乐并忧伤",["破碎岭"] = "Q/,堕落的路西法",["格雷迈恩"] = "Q/,落零星",["远古海滩"] = "Q+,牛啸天",["霜之哀伤"] = "Q+,眸中星河似梦,灿烂尐尐,今生为你舔,恰似童话",["雏龙之翼"] = "Q+,Kej",["燃烧平原"] = "Q+,Danaikz",["加基森"] = "Q+,闹闹爸",["苏塔恩"] = "Q+,月影灬晨星",["阿拉索"] = "Q+,不语笑红尘",["法拉希姆"] = "Q+,Thatcher,Zarya",["寒冰皇冠"] = "Q+,法力残渣丶"};
local lastDonators = "是与非-迅捷微风,螺丝粉-布兰卡德,远山之巅-罗宁,風吹不散长恨-主宰之剑,誰為我停留-金色平原,一点不自律-白银之手,做你的宝搞-无尽之海,人离别-国王之谷,醉酒夢红颜-格瑞姆巴托,蟹老板-荆棘谷,开光大湿丶-白银之手,在水之湄-暗影之月,Romeo-龙骨平原,白墨谷雨-迦拉克隆,奥科萨娜-安苏,伊雪夜-白银之手,小支百威-罗宁,一瞒天一-影之哀伤,我是乱打的-末日行者,風無雨-伊森利恩,我是个正经人-血色十字军,霜之雨彤-试炼之环,空城美雪-迦拉克隆,瓦尔姬里-世界之树,格雷丶帕斯塔-雷霆之王,灬桃兔灬-罗宁,东华少阳君-格瑞姆巴托,刮痧技师丶-凤凰之神,银涛溜溜-布兰卡德,熊熊奇妙冒险-泰兰德,挣扎-影之哀伤,琦玉老师灬-白银之手,求你别插进来-死亡之翼,清丶酒-塞拉摩,你枯燥么-格瑞姆巴托,小光人-熊猫酒仙,康师傅冰红茶-弗塞雷迦,飘雪灬-死亡之翼,去冰三分糖-时光之穴,Avogadro-凤凰之神,野人参-白银之手,绒布团子-贫瘠之地,轻拢慢捻-罗宁,痱子粉-伊森利恩,尐尐丶-布兰卡德,不谈情怀-安苏,導演丶我躺哪-圣火神殿,Ellerys-回音山,清梦挽依-白银之手,盛世经典-风暴之怒,Tsai-血色十字军,洛丶天依-爱斯特纳,深野昂-凤凰之神,大柚子突然-桑德兰,欧皇橙满天-熊猫酒仙,惹我半生风雪-贫瘠之地,荒野老司机-贫瘠之地,夏风爽-回音山,没有止痛药水-血色十字军,战丶小凡-???,圣光奶嘴-燃烧之刃,红颜最倾城-安苏,艾小美-安苏,小青丶-托塞德林,草上飞不动-迅捷微风,小甲甲丶-梅尔加尼,贰一-安苏,外面有狗了-迅捷微风,风陌轻-无尽之海,洛丹伦二公主-卡德加,浮云千载-凤凰之神,熊壮大猫咪-洛肯,骚嘚斯奶-凤凰之神,演员周冬雨-提瑞斯法,一笑奈何-国王之谷,Anataml-伊森利恩,Hinataml-伊森利恩,战倾血爆-安苏,基尔夹卤蛋-海克泰尔,一湖心静-卡德加,木牛流马-银月,愤怒的苗苗-末日行者,付公子-影牙要塞,哲学启示录-加尔,迢迢間風月-死亡之翼,安慕茜-末日行者,血色丶阿丽塔-布兰卡德,林空鹿饮溪-影之哀伤,惯犯王-凤凰之神,奶油熊起司-埃德萨拉,菊你太美-阿古斯,埃提耶什-白银之手,胖胖嘚文哥丶-凤凰之神,老白乄-燃烧之刃,乄老白-燃烧之刃,沐雪无尘-克尔苏加德,灵魂超越-贫瘠之地,小酌又黄昏-冰风岗,Lockjaw-伊森利恩,十里桃林-永恒之井,你到底怕不怕-熊猫酒仙,哲里-诺森德,夯大锤-通灵学院";
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
    topNamesOrder = nil
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
      row.name:SetText(name)
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