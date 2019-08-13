local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,绾风-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,天之冀-白银之手,丶小酒鬼-无尽之海,坚果别闹-燃烧之刃,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["凤凰之神"] = "Ja,罒孔雀翎罒;JZ,烟火浊了身,徘徊吟游;JY,Redmou;JX,且随吾心;JW,微笑的蒋美美,一剑沉沦;JV,我有只狸花猫,皮侃子,圣光小熊猫;JU,心怒难平,心爱难舍;JT,你的姑娘,熊腰;JS,守灬恒,Tnate;JR,最爱小韵子,严父,五言寒冬;JQ,挠你裤衩,自闭的森森;JP,老李的脆骨;JN,守丶恒;JM,夜枫丶,染指瑬姩,暮恩,生当为人杰;JL,灵児丶念伱,沧澜墨羽;JK,盐酸甲,小招潮蟹;JJ,庙街十三少灬,此人多半無敌,麋鹿在迷雾;JI,人形小泰迪,泡芙星冰乐丶,庙街十三少;JH,一个小薯条丶,蜡笔丨小明",["古尔丹"] = "JZ,Ecoceo;JJ,发型好吊",["主宰之剑"] = "JZ,Owen,缘迹,践鸡行事;JY,宁波臭冬瓜;JX,磁爆步兵老楊;JV,Dog,月下花醉舞,喜恋菊;JT,你是什么垃圾;JS,啾啾小公主丷;JR,那年|情书|;JQ,林家圣光骑士;JP,沐灵云,懿孓兮;JO,秋夜丶寒,Cousin;JM,我比從前快楽,嘵婷,混沌之怒;JL,狐荼荼,脏脏私房菜;JK,灬冷清秋灬;JJ,唐吉轲德;JI,相思賦予誰,傲娇双马尾丶;JH,坦爸爸灬,先生你真稳,乐漫谣阿乐",["安苏"] = "JZ,浪走,划得一手好奶;JX,图晨光,小鷄駃跑;JW,暮色星晨;JS,吾神在此;JQ,小依雲丶;JO,月来凤栖山;JN,嗒嗒丶萌萌哒,卧血狂眠;JL,乱来动心;JI,烈酒老友;JH,铁血教父",["罗宁"] = "JZ,奶牛骑士;JQ,燕归巢;JN,落雪丿千魅,颜素素;JM,丶雨下一整晚;JK,Dreamermetj,陈三胖",["冰风岗"] = "JZ,灿烂人生丶;JX,潴灬虎虎生威;JU,孤单灿烂的鬼,悲剧小寂寞;JT,老王叔叔㒃;JR,言语就像风;JN,Ifate;JH,Lucifire",["耳语海岸"] = "JZ,圣光永驻",["自由之风"] = "JZ,灭世之锤",["卡拉赞"] = "JZ,东北蛮牛;JU,Holyavenger",["白银之手"] = "JZ,渐渐遠行;JY,小波菜,就叫小急吧丶,Raivh;JX,落幕的丨青春;JW,墙西;JU,清心丨如水;JT,兰陵笑笑川;JS,断花之罪;JR,美元;JQ,半世淡年华,初之宸,Tuulani,Danieliu;JP,地狱丶圣光;JO,速度咩,豆蔻小青烽,Tigerausf;JL,你要次个丸子吗;JK,安吉柆齐格勒;JJ,轻吟一句骚话,牛牛鱼三哥,冰豆奶,海藻海藻海藻;JI,大针,甘来,时间小飞,达康书记丶,圣光忽诱你丶;JH,崩天恨羽,帕拉丁胖了点",["???"] = "JZ,我是老黑;JV,康斯袒丁大帝",["鬼雾峰"] = "JZ,叶奈法;JP,聖輄在右;JO,孩纸",["伊森利恩"] = "JZ,終是春风拂柳;JY,断肠也无怨;JX,刺客聂隐娘;JT,顿顿丶,温柔是谎言丶,聖光阿昆达;JQ,泰死腹中;JP,海陆空最强;JO,文丶;JN,蓝色圈圈;JL,凝光幻剑,突然好想装逼;JK,落秋灬;JJ,兔宝淼淼;JH,顾执",["格瑞姆巴托"] = "JZ,莉莉祀;JX,枫枫超可爱;JT,乱武,都挺好的;JS,张布罗,天地同寿奶;JP,喔嚯;JO,炽暗天使,丶黛梦丨,婆罗浮图,豆子;JN,丨剑来丨㑋;JM,弓弩箭,文森特;JL,随心飘洒;JI,恶形恶状;JH,一粒丶沙红尘",["兰娜瑟尔"] = "JY,爆雪弩炮",["雷斧堡垒"] = "JY,子月十五,大丨爺",["勇士岛"] = "JY,氧气泡泡,苍穹第一德;JX,|丶嘤嘤怪",["死亡之翼"] = "JY,墨染青瓷,芈雅;JX,拿头抢怪,西風凋碧樹,拉赞达女勋爵,虚丨竹;JW,三角题,弑魔风语;JV,丷格格巫丷,丷紫川秀,渺渺兮予怀丶,青岛第一帅;JU,万帅,雷霆铁警,泰勒偲威芙特,哈丨佩佩,嗯丨佩佩,感觉丶;JT,王者祝福丶;JS,蘇小諾,挠痒痒丶,游荡的脂肪;JR,皇家皮卡丘,嘟某人;JQ,春卷水饺,我是奶先溜;JO,丨神话故事丨;JN,头铁,澹台绮韵,随性随心,耐依佐特,爆炒香辣蟹;JM,你曾是少年吧;JL,垫底馍馍片;JJ,梧叶笺,北风向南丶;JI,吉原丶月咏",["法拉希姆"] = "JY,玥兒彎彎;JJ,啊空加瓜",["血色十字军"] = "JY,剑决浮云气,一直向西;JX,倪华丶,|恶魔|;JU,沾血的黃瓜,莫丽森,馨儿朵朵;JT,油腻咖;JS,詩月,丶东梨,莎洝娜;JM,阿颤,维他柠檬茶丶;JJ,可爱怪哼哼;JH,佶米,小贝丶追忆",["克尔苏加德"] = "JY,乐趣丶;JO,花开云落",["万色星辰"] = "JY,陌灬筱筱;JM,死亡盖伦",["加基森"] = "JY,阿依呀咦哟;JW,莎乐美;JR,沐辰丶,孟鹤堂;JP,陪你去追风",["末日行者"] = "JY,小假死;JV,故意隐藏实力;JU,鸽子在我手里;JT,丨暗影之舞丨,神偷皮特;JS,旋宇苍穹;JP,玖叁丶;JL,櫻桃肉丸子;JK,丨七星丨;JH,真的不爱吃鱼",["布兰卡德"] = "JY,柒喜丶;JN,圣光的阿昆达,了德,醉拳大战萝莉;JK,真白萌萌哒;JI,我不是术爷",["熊猫酒仙"] = "JY,小阿文丶;JS,杰克馬;JP,皮皮咕;JO,呆虾;JN,老奶狗;JJ,伊人在水,邪瞳丷;JI,喵喵咕咕呀,Holopsychon,阿丶文",["燃烧之刃"] = "JY,村头王二蛋;JX,花满楼;JW,空气青忄,麦小豆;JU,Kurara,、龙舌兰;JT,麦莎,友边的你;JR,墨汐浅梦红颜;JP,奎托斯丶链刃,浩劫是种信仰;JN,老实的很,波户总攻,我要吃甜点;JM,何处惹尘埃丨,冷冄廡聲;JL,像旧时光丶,元歌㑋;JK,今天不想挨揍;JJ,叫我绅士,Mmars;JI,筱霍霍;JH,步满奕,Savarne",["国王之谷"] = "JY,丨大怪兽丶;JW,無尽黑暗;JT,可児那由多,佑枫骑士;JS,溯烨,我们风雨同舟;JQ,蠕动荣誉丶;JO,捌零后丶范范;JN,芙兰朵露丶;JM,风清洋,猎白;JK,冯二狗;JJ,仁帥宝贝大,眉戴灬凶兆,筝丶名堂",["奥达曼"] = "JY,恶魔首领",["血环"] = "JX,丶纸防骑;JV,饿了麽猎手",["贫瘠之地"] = "JX,奶糖味的刺客,Radoms;JW,灬鹰眼灬,敗者食尘;JU,浮生丶醉夜;JT,Zoxic;JS,醉醉最醉;JR,赤冰;JQ,丨北丶蛋丨;JL,山道年;JK,瑾夏年华,不如撸串丶,Evelynn;JJ,小啊嘉,野丶火山,吃酸奶的喵",["海克泰尔"] = "JX,初寒;JW,你的骚气,抽象没有爱情;JT,匕加锁;JQ,Btsky;JL,Batk;JK,透明鹅;JH,清风墓雨,PlayerPMRTJS",["巴纳扎尔"] = "JX,银翼晨风",["古加尔"] = "JX,菌子;JR,一頁書丶",["回音山"] = "JX,青岚皎月;JO,佐助灬;JI,月夜丨微凉;JH,信長之野望",["洛肯"] = "JX,墨斯",["丽丽（四川）"] = "JW,心随风散,七号技师丶;JR,乌梢蛇;JQ,非洲老土著",["塞泰克"] = "JW,孤雲独閑",["刺骨利刃"] = "JW,山龙隐秀",["无尽之海"] = "JW,風丶顏汐;JP,火之蛋蛋;JL,滚地熊丶;JK,影恸;JH,這个剔骨奈斯",["破碎岭"] = "JW,土贵山龙傲天;JV,箭指丿灬长空;JR,啾啾小咪蒙;JO,黑桃小九;JK,慢慢跑丨;JI,红莲之弓矢",["石锤"] = "JW,哎呀小法师",["梅尔加尼"] = "JV,痔疮在流血,维持世界和平",["毁灭之锤"] = "JV,黑蜀黍",["火焰之树"] = "JV,执笔画浮尘;JL,锦鲤灬",["奥特兰克"] = "JV,守序圣者;JT,野战军主治医;JN,熊猫阿萌;JI,豆红豆红豆",["影之哀伤"] = "JV,风骚丶需要钱;JS,半岛忧伤丶;JR,大勾哟;JQ,千年神伤丶,逆风飞扬;JP,丶知否知否;JN,扛怪奶爸;JM,Amystrasza;JL,希亜;JK,野外遇贝爷;JH,瓜皮叼髦猎,Thinkagain",["巫妖之王"] = "JV,心灵丶",["冰霜之刃"] = "JV,Grommash;JU,月无尘",["哈兰"] = "JV,智沐沐",["黑龙军团"] = "JV,霞丿诗羽;JL,奥尼",["甜水绿洲"] = "JV,糖小猫;JS,马桶丶圈",["洛萨"] = "JV,南昌堇业先锋;JS,Kukulcan,软萌滚滚;JM,阿斯塔罗忒",["梦境之树"] = "JU,Firecross;JR,伽勒比海带",["伊利丹"] = "JU,闷闷丶闷闷;JK,Matumbaman",["萨格拉斯"] = "JU,苏城牛少;JR,茶余饭后",["狂热之刃"] = "JU,啊洗爸;JR,天气很好丶,杰尼杰尼杰尼;JM,欧西里斯",["加兹鲁维"] = "JU,砸死你个小样",["闪电之刃"] = "JU,无声,霏凡",["斯坦索姆"] = "JT,小猪猡",["阿拉希"] = "JT,山炮山寨版",["埃德萨拉"] = "JT,三百个胖子;JP,小菜太咸啊;JL,疾风归来",["月光林地"] = "JT,贝贝的布布;JM,呆萌的蛋蛋",["黑铁"] = "JS,就瞅你咋滴;JO,狂暴皮卡丘;JK,Richisme",["迅捷微风"] = "JS,六艺;JO,假职业;JK,带头大哥丶",["加尔"] = "JS,明教教主",["翡翠梦境"] = "JS,熊野",["格雷迈恩"] = "JS,影缥缈丶",["火羽山"] = "JS,灼骨炎傷",["太阳之井"] = "JS,死亡之亦,暮烟光凝",["金色平原"] = "JR,半熟奶爸;JM,三分骚,午夜梦回;JJ,艾尔莎海风;JI,Aliera",["奥尔加隆"] = "JR,Priestly;JH,不是我的海",["永恒之井"] = "JR,最美虚空;JL,園園吖",["迦拉克隆"] = "JR,赛纳斯丶语风;JP,伊利斯逐星",["地狱之石"] = "JR,寂静路途",["恐怖图腾"] = "JR,入神",["雷霆之怒"] = "JR,霜染流年",["战歌"] = "JQ,纠小结丶;JL,一切终将逝去;JJ,小强之魂",["日落沼泽"] = "JQ,Biubiubiub",["戈提克"] = "JQ,完颜红猎",["军团要塞"] = "JQ,醉舞夕阳情",["血羽"] = "JP,清风洒兰雪",["伊瑟拉"] = "JP,十三神仙钱",["远古海滩"] = "JO,清梦挽月",["奎尔丹纳斯"] = "JO,夜店丶暗",["燃烧平原"] = "JO,冷剑冰心",["凯尔萨斯"] = "JO,雷娜塔",["利刃之拳"] = "JN,阿啦索",["雏龙之翼"] = "JN,玄末",["萨菲隆"] = "JM,浪里白条;JI,暮光丷烟焱",["洛丹伦"] = "JM,Playerkoeqoa",["巨龙之吼"] = "JM,棠桑;JL,就是不会玩",["烈焰峰"] = "JM,瞧瞧我的中指;JH,紫轩雨",["霜之哀伤"] = "JM,昭月澜曦;JL,啰啰嗦嗦",["阿古斯"] = "JM,阿斯顿的夜;JL,小道贼",["灰谷"] = "JM,雙冷酒粥",["血牙魔王"] = "JM,龙爪巨斧",["黑暗魅影"] = "JL,库洛斯玛丽安",["玛洛加尔"] = "JL,芒果嗳回味",["诺莫瑞根"] = "JL,五湖闲人",["石爪峰"] = "JL,花名丶未闻",["阿克蒙德"] = "JL,厄末厄",["海达希亚"] = "JL,你听我解释;JK,Susu",["提尔之手"] = "JL,冲锋崴了脚",["艾露恩"] = "JL,旧衣依旧",["拉文凯斯"] = "JK,扒宝舟;JJ,有我且安",["黄金之路"] = "JK,白駒過隙",["深渊之巢"] = "JK,Yukanana",["巴瑟拉斯"] = "JJ,無聲冷月",["托尔巴拉德"] = "JJ,Boat",["踏梦者"] = "JJ,劈你叫哇",["逐日者"] = "JJ,折冲,折衝,Wowwangwanli",["塞拉摩"] = "JJ,折衝,Snifflerose,Inmethetiger,Acemonk;JI,丶瓦拉加尔",["银松森林"] = "JJ,Acereturn",["暗影之月"] = "JJ,地狱丶圣光",["阿曼尼"] = "JH,心如止水",["幽暗沼泽"] = "JH,丶如何丶",["诺兹多姆"] = "JH,暗夜幻日",["瓦里玛萨斯"] = "JH,言叶",["守护之剑"] = "JH,白起",["藏宝海湾"] = "JH,三千"};
local start = { year = 2018, month = 8, day = 3, hour = 7, min = 0, sec = 0 }
local now = time()
local player_shown = {}
U1Donators.players = player_shown

local topNamesOrder = {} for i, name in ipairs({ strsplit(',', topNames) }) do topNamesOrder[name] = i end

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
        local order1 = topNamesOrder[a] or 9999
        local order2 = topNamesOrder[b] or 9999
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