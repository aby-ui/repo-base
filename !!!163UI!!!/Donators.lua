local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["国王之谷"] = "RF,江隂丨饅頭;RE,寒铁在上,小憨憨丶;RC,一笑奈何;RB,人离别,萬岁千秋,白驹氵过隙;RA,树鸟熊猫魚,索拉丶织棘者;Q/,一輪美滿,残盾;Q+,极热,尝试切他中路",["白银之手"] = "RF,逆风骑行,愁绪万千;RE,小青龙,啾哩个啾,星空天蝎座,芥末味冰淇淋,火槍手追獵者;RD,Xwh,电竞斯坦森,司言,哲哲大憨憨,擎天過雨;RC,埃提耶什,清梦挽依,野人参;RB,琦玉老师灬,伊雪夜,开光大湿丶,一点不自律,阿尔萨喵,童話鎮;RA,雲杨,温岭胡歌,飞驰柚子,南野;Q/,陳喬恩,乱舞乄风行者,Demondark,维灬他,酒樱;Q+,雷德琪,回梦夜影,天空蔚蓝灬,这是女鬼,老王遛狗,清音梵唱,Penumbra,奶一次绿一次",["加基森"] = "RF,拒绝丶;Q+,闹闹爸",["主宰之剑"] = "RF,苦孩;RD,教官的第四科;RB,風吹不散长恨,年轻不讲舞德;RA,一岁可萌了;Q/,导演法;Q+,夜尽丶辰曦,快进到退休",["死亡之翼"] = "RF,法神咔咔;RE,老人古井,昊寒冰,风色月,沉默的真相;RD,小喵呜;RC,迢迢間風月,飘雪灬;RB,求你别插进来,紫韵铭馨,莺鸢,傻比晓得;RA,Asknb,魔桀神;Q/,小栞的狐狸,老牛吃嫩草丶;Q+,丷小眼迷人丷,盗口大重九,西柚茉莉茶丶,德抽大重九,手拿大重九",["冰风岗"] = "RF,奇克秀;RE,彩翼鲸尾红丝,Rosamond;RD,Relina,源赖式佐田,二百一十六斤,小酌又黄昏;Q/,专业杀鸡拔毛",["血色十字军"] = "RF,Imfit;RE,叹息的富士山,术起中指丶;RD,Meastoso;RC,没有止痛药水,Tsai;RB,我是个正经人,表妹丶;RA,达拉崩吧丶,珊瑚丶海,蜡笔海盗,昨日青空;Q/,祟图,社会的榜样,爆炸糖果,席梦来;Q+,机车小迷弟",["龙骨平原"] = "RF,云端丶;RB,Romeo;Q/,战世,丶黑夜传说",["阿纳克洛斯"] = "RE,Nsaids;RD,雷丶浮生若梦;RA,还有土拨鼠",["巴瑟拉斯"] = "RE,六眼盱鱼",["夜空之歌[TW]"] = "RE,网瘾治疗者",["海克泰尔"] = "RE,万亩稻上飞丶;RC,基尔夹卤蛋;RA,旧城半夏,夜丶微凉,灵魂祭司雷尼;Q+,风中一头牛,猜心,心云",["加兹鲁维"] = "RE,轻井泽",["格瑞姆巴托"] = "RE,旺川,哆啦批梦;RB,你枯燥么,东华少阳君,醉酒夢红颜,小鸡球球;Q/,少女映画;Q+,哈啤穿肠过,梦扬天际",["阿卡玛"] = "RE,清灬茶",["无尽之海"] = "RE,芸墨,屠魔风暴,死鱼非命,琥珀年崋;RC,风陌轻;RB,做你的宝搞;RA,青衣凉惹白霜;Q/,麒麟仔,食人魔魔法師,翊悬;Q+,慧者实乂橙,灬奶茶炖鸡灬,小原",["伊瑟拉"] = "RE,那尔撒斯",["斩魔者"] = "RE,影之逆袭;RA,百山惊鸿",["布兰卡德"] = "RE,迷人又危险丶;RD,喵爪啵奇塔;RC,血色丶阿丽塔,尐尐丶;RB,银涛溜溜,螺丝粉;Q+,欧丿二泉映月",["埃德萨拉"] = "RE,单吊丶東风;RC,奶油熊起司;RA,丨丶青衫;Q/,骁哥最帅;Q+,灬阿猫灬,丨丶青衫未旧",["丽丽（四川）"] = "RE,剑与斜阳,你好钱先生;RD,Yax,月来凤栖山;RA,南部丑锅锅,别闹灬;Q+,飞花轻梦丶",["熊猫酒仙"] = "RE,李小胖灬,黑醫白翼;RD,你到底怕不怕;RC,欧皇橙满天;RB,小光人,射的你发慌;RA,丿锖兎丶;Q/,JohnPan;Q+,十公里,敗犬",["塞拉摩"] = "RE,来个署条;RB,清丶酒",["阿克蒙德"] = "RE,五花变形肉;RA,Migo",["伊利丹"] = "RE,长短深浅皆知;RA,飞行的老猫",["凤凰之神"] = "RE,浩子未知,照猫画虎,迷路小兔兔丶,阿姨沾酱;RD,且须饮美酒,风丶逝,胖胖嘚文哥丶;RC,惯犯王,骚嘚斯奶,浮云千载,深野昂,Avogadro;RB,刮痧技师丶,灬纤尘灬;RA,Sakurall,最深情的森西,森森鸭,因幡帝丶,莫歌;Q+,壕运气,绮德丶",["克尔苏加德"] = "RE,牛奶巧克力,梦想蓝睛灵,凹凸凸叁;RD,双刃法雷尔;RC,沐雪无尘;Q+,枪手哥哥",["贫瘠之地"] = "RE,丷大橙子丷,暧暧;RD,嫂子好刺激哦,木岂能择鸟,Gigapull,我负责云,是晨阳哟,水果拉面,灵魂超越;RC,荒野老司机,惹我半生风雪,绒布团子;RB,凰弥;RA,官人不卖艺;Q/,末白丶,小牛丹尼,大地香瓜,欧狍;Q+,Shaka,小末日,花丶雨",["阿古斯"] = "RE,丨猎魔丨,影踪秘卫沧萍;RC,菊你太美;Q/,Deathbarbie",["外域"] = "RE,剑开天门",["世界之树"] = "RE,絮语飘雪;RB,瓦尔姬里",["末日行者"] = "RE,最爱香菜,西门吹血;RD,摸腿腿丶;RC,安慕茜,愤怒的苗苗;RB,我是乱打的;Q/,舔娃;Q+,小楼一夜趴啪,腹黑骑师",["???"] = "RE,游魂灯丶;RC,战丶小凡;Q/,来呀丨张哥,冰强砸铁锤,Montyshoot,原来是青衫呀,大俊;Q9,夜行猫;Q7,暴烈灬猪皇;Q6,霓裳梅普露,丨太宰丨,打错停手",["影之哀伤"] = "RE,Euroyalol,有时看雲;RD,天才第壹歩;RC,林空鹿饮溪;RB,挣扎,一瞒天一,丶萧默默;RA,勒子;Q/,流梳灬烟沐,懒懒空天猎;Q+,穿靴子的牛",["安苏"] = "RE,十元打五炮,蓝蓝纸飞机,丨四一丨,全是肉没土豆;RC,战倾血爆,贰一,艾小美,红颜最倾城,不谈情怀;RB,奥科萨娜,芋头炖牛腩丶;RA,十字军的清算,魔法宅急送丶;Q/,麦普替林;Q+,只愿诗和远方,冰星心,北暝",["万色星辰"] = "RE,天堂寒;Q/,威廉萌",["狂热之刃"] = "RE,钱多给我花",["金色平原"] = "RE,哈杜伦丶塞隆;RD,我醉君复乐,贝尔晨酿;RB,誰為我停留;RA,庆余,好灬好美哟",["幽暗沼泽"] = "RE,Excaliburs;RD,三千歌一笑醉",["破碎岭"] = "RE,秋喜姐;Q/,堕落的路西法",["奥特兰克"] = "RE,不正经大叔,仙念丶,花岗岩哥哥,Missflg",["伊森利恩"] = "RE,曓力美学,苏美尔;RD,很强,凤黎,星之澪,Lockjaw;RC,Hinataml,Anataml,痱子粉;RB,風無雨;RA,甜酒冲蛋,勾手老大爷;Q/,暗影之境丶雷;Q+,Redone,花花厷孒,北执",["罗曼斯"] = "RE,游穴者丶周浊",["卡拉赞"] = "RE,一叶知秋",["弗塞雷迦"] = "RE,咖啡守护汐汐;RC,康师傅冰红茶",["熔火之心"] = "RD,断离",["桑德兰"] = "RD,凯雯小笨蛋;RC,大柚子突然",["森金"] = "RD,风之逆襲",["燃烧之刃"] = "RD,圣光洗礼丶;RC,乄老白,老白乄,圣光奶嘴;RB,酒仙女,丨嫣於倾黛;RA,Goodknight,卖皮孩;Q/,疯狂的麦田丶,疯狂的麦子丶,老乄乄白,老乄白,术小鱼",["霜之哀伤"] = "RD,游学者叮当;RB,丨眰恦丨;Q+,眸中星河似梦,灿烂尐尐,今生为你舔,恰似童话",["卡德加"] = "RD,烽火得箭矢;RC,一湖心静,洛丹伦二公主",["雷霆之王"] = "RD,暗雨星魂;RB,格雷丶帕斯塔",["库尔提拉斯"] = "RD,村里的爷们",["金度"] = "RD,沐北丶半諾殇",["罗宁"] = "RD,大鱼鱼爱吃肉,炒饭丶;RC,轻拢慢捻;RB,灬桃兔灬,小支百威,远山之巅;RA,大圆蟀,青咿染霜华;Q/,小鷄湯;Q+,Sacrificed",["烈焰峰"] = "RD,小碗",["加尔"] = "RD,奥雷里亚诺;RC,哲学启示录",["芬里斯"] = "RD,玛塔哈里",["通灵学院"] = "RD,夯大锤",["诺森德"] = "RD,哲里",["永恒之井"] = "RD,十里桃林",["影牙要塞"] = "RC,付公子",["银月"] = "RC,木牛流马",["提瑞斯法"] = "RC,演员周冬雨",["洛肯"] = "RC,熊壮大猫咪",["迅捷微风"] = "RC,外面有狗了,草上飞不动;RB,是与非;Q/,章鱼法",["梅尔加尼"] = "RC,小甲甲丶;Q/,悠悠德",["托塞德林"] = "RC,小青丶",["回音山"] = "RC,夏风爽,Ellerys",["爱斯特纳"] = "RC,洛丶天依",["风暴之怒"] = "RC,盛世经典;Q+,似锦年华",["圣火神殿"] = "RC,導演丶我躺哪",["时光之穴"] = "RC,去冰三分糖",["泰兰德"] = "RB,熊熊奇妙冒险",["迦拉克隆"] = "RB,空城美雪,白墨谷雨",["试炼之环"] = "RB,霜之雨彤;Q+,牛将军丶老刘",["暗影之月"] = "RB,在水之湄",["荆棘谷"] = "RB,蟹老板",["红云台地"] = "RB,荼荼",["冰霜之刃"] = "RB,丶铁柱",["洛丹伦"] = "RB,赛柯蕾丶血歌",["灰谷"] = "RB,蹬蹬爹",["扎拉赞恩"] = "RB,妖之骄法",["艾露恩"] = "RB,巨侠老德;RA,陆老六",["风行者"] = "RB,隔壁水果店丶",["雷斧堡垒"] = "RB,雷霆扛把子;Q+,七色的魔法使",["玛法里奥"] = "RA,菲奈珂思",["玛瑟里顿"] = "RA,Vitamine",["克洛玛古斯"] = "RA,闪光伯爵",["利刃之拳"] = "RA,马师父;Q/,丶绫波丽",["奥斯里安"] = "RA,双刀就看走",["巫妖之王"] = "Q/,海之间",["拉文凯斯"] = "Q/,甄美",["亚雷戈斯"] = "Q/,一生有你",["索瑞森"] = "Q/,雲中锦書來;Q+,雲影映暈",["玛里苟斯"] = "Q/,艾尔玛娜",["达尔坎"] = "Q/,快乐并忧伤",["格雷迈恩"] = "Q/,落零星",["远古海滩"] = "Q+,牛啸天",["雏龙之翼"] = "Q+,Kej",["燃烧平原"] = "Q+,Danaikz",["苏塔恩"] = "Q+,月影灬晨星",["阿拉索"] = "Q+,不语笑红尘",["法拉希姆"] = "Q+,Thatcher,Zarya",["寒冰皇冠"] = "Q+,法力残渣丶"};
local lastDonators = "苏美尔-伊森利恩,咖啡守护汐汐-弗塞雷迦,有时看雲-影之哀伤,一叶知秋-卡拉赞,凹凸凸叁-克尔苏加德,仙念丶-奥特兰克,游穴者丶周浊-罗曼斯,曓力美学-伊森利恩,黑醫白翼-熊猫酒仙,火槍手追獵者-白银之手,影踪秘卫沧萍-阿古斯,你好钱先生-丽丽（四川）,沉默的真相-死亡之翼,丨四一丨-安苏,暧暧-贫瘠之地,术起中指丶-血色十字军,不正经大叔-奥特兰克,秋喜姐-破碎岭,风色月-死亡之翼,Rosamond-冰风岗,芥末味冰淇淋-白银之手,琥珀年崋-无尽之海,阿姨沾酱-凤凰之神,Excaliburs-幽暗沼泽,迷路小兔兔丶-凤凰之神,蓝蓝纸飞机-安苏,星空天蝎座-白银之手,哈杜伦丶塞隆-金色平原,昊寒冰-死亡之翼,钱多给我花-狂热之刃,老人古井-死亡之翼,哆啦批梦-格瑞姆巴托,死鱼非命-无尽之海,天堂寒-万色星辰,照猫画虎-凤凰之神,十元打五炮-安苏,Euroyalol-影之哀伤,西门吹血-末日行者,游魂灯丶-???,最爱香菜-末日行者,絮语飘雪-世界之树,剑开天门-外域,梦想蓝睛灵-克尔苏加德,丨猎魔丨-阿古斯,丷大橙子丷-贫瘠之地,牛奶巧克力-克尔苏加德,彩翼鲸尾红丝-冰风岗,浩子未知-凤凰之神,啾哩个啾-白银之手,长短深浅皆知-伊利丹,五花变形肉-阿克蒙德,小青龙-白银之手,寒铁在上-国王之谷,来个署条-塞拉摩,李小胖灬-熊猫酒仙,剑与斜阳-丽丽（四川）,单吊丶東风-埃德萨拉,迷人又危险丶-布兰卡德,屠魔风暴-无尽之海,影之逆袭-斩魔者,那尔撒斯-伊瑟拉,芸墨-无尽之海,清灬茶-阿卡玛,旺川-格瑞姆巴托,轻井泽-加兹鲁维,万亩稻上飞丶-海克泰尔,网瘾治疗者-夜空之歌[TW],叹息的富士山-血色十字军,六眼盱鱼-巴瑟拉斯,Nsaids-阿纳克洛斯,云端丶-龙骨平原,Imfit-血色十字军,愁绪万千-白银之手,奇克秀-冰风岗,法神咔咔-死亡之翼,苦孩-主宰之剑,拒绝丶-加基森,逆风骑行-白银之手,江隂丨饅頭-国王之谷";
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