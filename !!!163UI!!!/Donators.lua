local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["燃烧之刃"] = "UN,丶小了白了兔,李阳脚很臭;UM,电臀静香;UJ,熊呆呆丶;UB,莽多多;T4,沐丨阳,天青惹寂寥;Tz,锦瑟華年;Tx,翀大师;Tj,烟焱;Ti,老白嗷;Tg,夜光小布丁",["戈提克"] = "UN,烈酒傷神",["凤凰之神"] = "UN,云归丶;UL,桂丶渣王;UH,Mastor;UG,夜归寒;UE,桃花树;UD,秋秋百香果;UA,Biubiubiusm;T/,下陛王女我叫;T9,十年回忆杀;T8,禽王绕柱;T3,子夜流觞;T0,老扎皮;Tx,爱治衡真是太好啦,贺筱滢丶;Tu,Theconor;To,阳光宅男;Tk,执法长老;Ti,Montgoholy;Te,丶虚竹丶;Td,梦霜宇,小妞向前冲;Tc,终极版本答案;Tb,艾梅特赛尔克",["血色十字军"] = "UN,大丁丁丶;UA,岁月清欢;T4,甜丶瓜;T1,Ytc;Ty,林小藻,林小枣;Tx,秋日晴空;Tw,战神伍陆柒;Tu,溜名犬;Tk,潋滟丨杯中酒;Tg,黄鸭叫;Tf,因芸;TZ,不信鬼神",["熊猫酒仙"] = "UN,熊丷二,蓝鲸丶杀戮,殇魂丶烟雨;T1,熊贰灬;Tz,清河小影;Tl,骑白虎的饺子",["奥尔加隆"] = "UN,五点睡觉刚好",["月光林地"] = "UM,西门玄乔",["格瑞姆巴托"] = "UM,子参宿狩;T+,銀发;T3,石生缘;Tt,芒果绿茶;Td,可乐灬乄;Tb,一云丶",["死亡之翼"] = "UM,慕歌乄,进击的智齿,暮霭晨曦丶;UL,萌萌小可爱;UI,宁凝,洛神紅茶;UH,丶晞;UG,小丫头欸;UC,小訫訫,我是亻壬何;UB,薄雪中意晚莲;T7,神针子;T6,喂面之子,Kuxd;T4,鹧咕菜;T3,不必候;T2,Kuxiang;Tx,洛神红茶;Tt,越越辉辉;Ts,呆比丶,瞎来呛,奔五德;Tq,阿雯丶爱吃肉;Tm,青山之云,偷偷瞄,忘我大德;Tj,迷醉丨;Ti,Ameno;Th,雪拉贝祺朵;Te,丶蟹棒好吃;Td,离人丶泪;Tb,卩灬聖丨光",["国王之谷"] = "UM,江隂饅頭;UF,月影灬轻风;T8,苏菲不漏;T4,颂雨;Tz,璀璨青春;To,武园枯藤朵兰,乡下土著人",["雷斧堡垒"] = "UM,小女娲娘娘;T7,Ipromise",["夏维安"] = "UM,性感大屁屁;Tw,团结就是力量",["白银之手"] = "UL,紫風乄曼陀羅;UJ,Tendrennss;UI,妖沭;UG,小手拉大脚;UE,白贤;UB,无法吟诵的诗,孤独一大叔;T/,小火林;T+,徳鲁伊伊;T6,颜晓峰;T4,雨落雨听雨;Tx,多才多亿;Tu,远古洗只狼,暗键伤人,按剑伤人,戰圣;Tt,飞翔的复仇;Tp,打更;Tn,砸瓦魯多;Tl,射擊獵人,两亿男人的梦;Th,月下鹡鸰,利奥波德;Tg,爱丽菲儿,灰色兔兔,硅胶宝宝;Tc,有德必尸,砸瓦鲁多;Tb,蛋壳总是脆,缺德萌咕;Ta,为妳念咒;TZ,安牧茜",["荆棘谷"] = "UL,堕落中的男神",["燃烧军团"] = "UL,波利的梦",["回音山"] = "UL,青寒钺;T2,圣美美;Tr,白首;Tg,半山桥野兔;Te,翼雪",["埃德萨拉"] = "UK,那夜;UC,爱吃榴莲千层",["安苏"] = "UK,豆仔丶;UH,江廷宇;UG,Christinamar;T+,时暖时荫凉;T9,聆听雨声丿墨;T7,春不晓;Tz,村东头老高;Ty,奔跑的晓蜗牛;Tx,灵小龙,强力的小明;Tt,Playerjmbbwr,天生喜剧;Ts,一拳捶毁你;Tj,兄弟你兽了;Ti,亞單",["伊森利恩"] = "UK,再一次拥抱;UJ,毛茸茸的爪;T7,暗影之境丶纞;Tv,年华灬流光;Tm,上学威龙;Tj,Floorjansen;Ti,何以解忧丿,丶言松语,叶公子;Th,伊西;Te,小紅仁",["伊利丹"] = "UK,改名为领导先走;T7,Woolala",["金色平原"] = "UK,麦芽小可爱;UA,千叶清秋;T8,阿吉;T1,霍拉拉;Tp,塞理德恩",["元素之力"] = "UJ,切丶格瓦拉",["雷克萨"] = "UH,雪花飞飞",["军团要塞"] = "UH,伤灬感入侵",["狂热之刃"] = "UH,清澈的爱;T7,我说一个数;Tu,百威宝贝,小二班班;Tm,汗臭少年",["罗宁"] = "UG,九亿少女的梦;UA,挽梦;Tx,烈焰摩纳哥;Tv,聖乂骑;Tu,正义的伙伴;Tm,皮皮丹;Tk,轻寒寒;Tc,夏多雷希尔兔,佰寶",["米奈希尔"] = "UG,灰飛煙滅丶",["安纳塞隆"] = "UG,幼儿园老大",["塞泰克"] = "UG,夜之眸",["红龙女王"] = "UF,龙丶妖;T9,丶老白",["龙骨平原"] = "UE,徐然然丶",["贫瘠之地"] = "UD,丶九曜;T7,帕拉伊巴;Tw,Carrotqiuqiu;Tq,Jeffery;Tn,丨紅尘烟雨丨;Tj,炎刃;Ti,九曜丶;Tg,射贱;Tc,布利瑞斯;Tb,婲落知多少丶",["梦境之树"] = "UD,Qi,七濑",["阿拉希"] = "UC,英雄出少女;Tq,蕾丝天鹅蛋",["山丘之王"] = "UB,风骑",["无尽之海"] = "UB,佑诚;T4,丨艾特丨;T3,灵性丶;Ty,扶我上魔兽;Tx,Rita;Tr,八块腹肌喵;Tp,马里奥煎饼;Ta,罒壹罒",["艾露恩"] = "UA,非常哇塞",["暗影之月"] = "UA,熔火之心",["辛迪加"] = "UA,断反",["雷霆之王"] = "T/,阿杨丶",["主宰之剑"] = "T/,月色太清;T8,戰神飄雪;Tk,维内托里奥;Te,無上菩提",["泰兰德"] = "T+,何以为",["奈法利安"] = "T9,麻老李",["丽丽（四川）"] = "T7,小念儿;T3,贴心小宝贝",["迦拉克隆"] = "T7,小善萱;Tz,丶谭咏麟;Tn,油条;Tb,希望的灯火",["洛肯"] = "T6,Zellenleiter;T4,銠鑫",["洛丹伦"] = "T5,遗忘灬记忆;Tq,今晚月色真美",["霜之哀伤"] = "T5,丹尼斯莱耶斯;Tz,白桃乌龙茶丨;Tt,快乐之海;Te,瑞灬弑",["水晶之牙"] = "T3,整他",["末日行者"] = "T3,吉喵;Tt,爷傲奈我何丨,爷傲丨奈我何;Tb,野蛮丨大疯子",["影之哀伤"] = "T2,诗淼,江小白不白;Tx,神秘抓根宝;Tv,大胸坏坏;Tp,狐噜;To,诗涵,夏夜暖风;Tm,逆戟鯨;Tg,捌月壹拾伍;Te,苍烟断",["桑德兰"] = "T1,威尔谢尔",["盖斯"] = "T1,从良詹事",["神圣之歌"] = "T0,仟羽;Ti,白云兮丶",["破碎岭"] = "Ty,希尓咓娜斯",["永恒之井"] = "Tw,小毒蛇",["黑铁"] = "Tw,强袭牛叔",["黑暗虚空"] = "Tv,無伈戀愛",["黑翼之巢"] = "Tv,暴走小怪兽",["索瑞森"] = "Tv,可爱的柯",["阿纳克洛斯"] = "Ts,華夏丶戰之魂",["亡语者"] = "Tr,魔兽世界;Te,云淡心晴",["娅尔罗"] = "Tr,铁头娃二",["冰风岗"] = "Tp,大地震击暴击;Te,帅帅滴板砖酱;Td,天韵五五",["埃雷达尔"] = "Tp,南鸢大人",["卡拉赞"] = "To,八六年凉白开",["雏龙之翼"] = "To,不会就要练;Tl,血色幽蓝",["翡翠梦境"] = "Tm,我无限嚣張",["克尔苏加德"] = "Tm,依旧的依旧,魔法燃烧;TZ,清妤,八度余温",["藏宝海湾"] = "Tl,???",["图拉扬"] = "Tl,小小雪花",["壁炉谷"] = "Tl,近松十人众",["风暴之怒"] = "Tj,塑以花之形;Te,天然元素",["鬼雾峰"] = "Ti,荙芬奇",["深渊之巢"] = "Th,丿田鼠",["能源舰"] = "Th,巫月",["月神殿"] = "Tg,刪除於終點",["瓦丝琪"] = "Tf,小瓶盖儿",["罗曼斯"] = "Td,因为蛋疼所以",["世界之树"] = "Td,Stillalive",["凯恩血蹄"] = "Tc,闪伯利恒之星",["瓦里安"] = "Tc,陈年老号",["迅捷微风"] = "Tc,扶桑啊大红花",["银松森林"] = "Tc,樱桃",["朵丹尼尔"] = "Tc,Miuinitio",["海克泰尔"] = "Tb,叮噹咕嚕",["白骨荒野"] = "Ta,羽月希丶,幻之地狱"};
local lastDonators = "小火林-白银之手,月色太清-主宰之剑,下陛王女我叫-凤凰之神,阿杨丶-雷霆之王,断反-辛迪加,Biubiubiusm-凤凰之神,挽梦-罗宁,千叶清秋-金色平原,熔火之心-暗影之月,岁月清欢-血色十字军,非常哇塞-艾露恩,薄雪中意晚莲-死亡之翼,莽多多-燃烧之刃,孤独一大叔-白银之手,佑诚-无尽之海,无法吟诵的诗-白银之手,晟清明-???,风骑-山丘之王,英雄出少女-阿拉希,我是亻壬何-死亡之翼,爱吃榴莲千层-埃德萨拉,小訫訫-死亡之翼,七濑-梦境之树,Qi-梦境之树,秋秋百香果-凤凰之神,丶九曜-贫瘠之地,桃花树-凤凰之神,白贤-白银之手,徐然然丶-龙骨平原,龙丶妖-红龙女王,月影灬轻风-国王之谷,小丫头欸-死亡之翼,Christinamar-安苏,小手拉大脚-白银之手,夜之眸-塞泰克,幼儿园老大-安纳塞隆,灰飛煙滅丶-米奈希尔,九亿少女的梦-罗宁,夜归寒-凤凰之神,清澈的爱-狂热之刃,伤灬感入侵-军团要塞,雪花飞飞-雷克萨,Mastor-凤凰之神,江廷宇-安苏,丶晞-死亡之翼,妖沭-白银之手,洛神紅茶-死亡之翼,宁凝-死亡之翼,Tendrennss-白银之手,切丶格瓦拉-元素之力,毛茸茸的爪-伊森利恩,熊呆呆丶-燃烧之刃,麦芽小可爱-金色平原,改名为领导先走-伊利丹,再一次拥抱-伊森利恩,豆仔丶-安苏,那夜-埃德萨拉,萌萌小可爱-死亡之翼,青寒钺-回音山,波利的梦-燃烧军团,堕落中的男神-荆棘谷,紫風乄曼陀羅-白银之手,桂丶渣王-凤凰之神,性感大屁屁-夏维安,小女娲娘娘-雷斧堡垒,江隂饅頭-国王之谷,暮霭晨曦丶-死亡之翼,进击的智齿-死亡之翼,慕歌乄-死亡之翼,子参宿狩-格瑞姆巴托,西门玄乔-月光林地,电臀静香-燃烧之刃,李阳脚很臭-燃烧之刃,五点睡觉刚好-奥尔加隆,殇魂丶烟雨-熊猫酒仙,蓝鲸丶杀戮-熊猫酒仙,熊丷二-熊猫酒仙,大丁丁丶-血色十字军,云归丶-凤凰之神,烈酒傷神-戈提克,丶小了白了兔-燃烧之刃";
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