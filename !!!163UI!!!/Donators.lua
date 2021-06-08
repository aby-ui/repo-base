local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["格瑞姆巴托"] = "T+,銀发;T3,石生缘;Tt,芒果绿茶;Td,可乐灬乄;Tb,一云丶",["泰兰德"] = "T+,何以为",["白银之手"] = "T+,徳鲁伊伊;T6,颜晓峰;T4,雨落雨听雨;Tx,多才多亿;Tu,远古洗只狼,暗键伤人,按剑伤人,戰圣;Tt,飞翔的复仇;Tp,打更;Tn,砸瓦魯多;Tl,射擊獵人,两亿男人的梦;Th,月下鹡鸰,利奥波德;Tg,爱丽菲儿,灰色兔兔,硅胶宝宝;Tc,有德必尸,砸瓦鲁多;Tb,蛋壳总是脆,缺德萌咕;Ta,为妳念咒;TZ,安牧茜",["安苏"] = "T+,时暖时荫凉;T9,聆听雨声丿墨;T7,春不晓;Tz,村东头老高;Ty,奔跑的晓蜗牛;Tx,灵小龙,强力的小明;Tt,Playerjmbbwr,天生喜剧;Ts,一拳捶毁你;Tj,兄弟你兽了;Ti,亞單",["凤凰之神"] = "T9,十年回忆杀;T8,禽王绕柱;T3,子夜流觞;T0,老扎皮;Tx,爱治衡真是太好啦,贺筱滢丶;Tu,Theconor;To,阳光宅男;Tk,执法长老;Ti,Montgoholy;Te,丶虚竹丶;Td,梦霜宇,小妞向前冲;Tc,终极版本答案;Tb,艾梅特赛尔克",["奈法利安"] = "T9,麻老李",["红龙女王"] = "T9,丶老白",["伊森利恩"] = "T8,爱火烧不尽;T7,暗影之境丶纞;Tv,年华灬流光;Tm,上学威龙;Tj,Floorjansen;Ti,何以解忧丿,丶言松语,叶公子;Th,伊西;Te,小紅仁",["主宰之剑"] = "T8,戰神飄雪;Tk,维内托里奥;Te,無上菩提",["国王之谷"] = "T8,苏菲不漏;T4,颂雨;Tz,璀璨青春;To,武园枯藤朵兰,乡下土著人",["金色平原"] = "T8,阿吉;T1,霍拉拉;Tp,塞理德恩",["狂热之刃"] = "T7,我说一个数;Tu,百威宝贝,小二班班;Tm,汗臭少年",["丽丽（四川）"] = "T7,小念儿;T3,贴心小宝贝",["???"] = "T7,狸笙,封于修丶",["雷斧堡垒"] = "T7,Ipromise",["贫瘠之地"] = "T7,帕拉伊巴;Tw,Carrotqiuqiu;Tq,Jeffery;Tn,丨紅尘烟雨丨;Tj,炎刃;Ti,九曜丶;Tg,射贱;Tc,布利瑞斯;Tb,婲落知多少丶",["伊利丹"] = "T7,Woolala",["死亡之翼"] = "T7,神针子;T6,喂面之子,Kuxd;T4,鹧咕菜;T3,不必候;T2,Kuxiang;Tx,洛神红茶;Tt,越越辉辉;Ts,呆比丶,瞎来呛,奔五德;Tq,阿雯丶爱吃肉;Tm,青山之云,偷偷瞄,忘我大德;Tj,迷醉丨;Ti,Ameno;Th,雪拉贝祺朵;Te,丶蟹棒好吃;Td,离人丶泪;Tb,卩灬聖丨光",["迦拉克隆"] = "T7,小善萱;Tz,丶谭咏麟;Tn,油条;Tb,希望的灯火",["洛肯"] = "T6,Zellenleiter;T4,銠鑫",["洛丹伦"] = "T5,遗忘灬记忆;Tq,今晚月色真美",["霜之哀伤"] = "T5,丹尼斯莱耶斯;Tz,白桃乌龙茶丨;Tt,快乐之海;Te,瑞灬弑",["血色十字军"] = "T4,甜丶瓜;T1,Ytc;Ty,林小藻,林小枣;Tx,秋日晴空;Tw,战神伍陆柒;Tu,溜名犬;Tk,潋滟丨杯中酒;Tg,黄鸭叫;Tf,因芸;TZ,不信鬼神",["无尽之海"] = "T4,丨艾特丨;T3,灵性丶;Ty,扶我上魔兽;Tx,Rita;Tr,八块腹肌喵;Tp,马里奥煎饼;Ta,罒壹罒",["燃烧之刃"] = "T4,沐丨阳,天青惹寂寥;Tz,锦瑟華年;Tx,翀大师;Tj,烟焱;Ti,老白嗷;Tg,夜光小布丁",["水晶之牙"] = "T3,整他",["末日行者"] = "T3,吉喵;Tt,爷傲奈我何丨,爷傲丨奈我何;Tb,野蛮丨大疯子",["影之哀伤"] = "T2,诗淼,江小白不白;Tx,神秘抓根宝;Tv,大胸坏坏;Tp,狐噜;To,诗涵,夏夜暖风;Tm,逆戟鯨;Tg,捌月壹拾伍;Te,苍烟断",["回音山"] = "T2,圣美美;Tr,白首;Tg,半山桥野兔;Te,翼雪",["桑德兰"] = "T1,威尔谢尔",["盖斯"] = "T1,从良詹事",["熊猫酒仙"] = "T1,熊贰灬;Tz,清河小影;Tl,骑白虎的饺子",["神圣之歌"] = "T0,仟羽;Ti,白云兮丶",["破碎岭"] = "Ty,希尓咓娜斯",["罗宁"] = "Tx,烈焰摩纳哥;Tv,聖乂骑;Tu,正义的伙伴;Tm,皮皮丹;Tk,轻寒寒;Tc,夏多雷希尔兔,佰寶",["夏维安"] = "Tw,团结就是力量",["永恒之井"] = "Tw,小毒蛇",["黑铁"] = "Tw,强袭牛叔",["黑暗虚空"] = "Tv,無伈戀愛",["黑翼之巢"] = "Tv,暴走小怪兽",["索瑞森"] = "Tv,可爱的柯",["阿纳克洛斯"] = "Ts,華夏丶戰之魂",["亡语者"] = "Tr,魔兽世界;Te,云淡心晴",["娅尔罗"] = "Tr,铁头娃二",["阿拉希"] = "Tq,蕾丝天鹅蛋",["冰风岗"] = "Tp,大地震击暴击;Te,帅帅滴板砖酱;Td,天韵五五",["埃雷达尔"] = "Tp,南鸢大人",["卡拉赞"] = "To,八六年凉白开",["雏龙之翼"] = "To,不会就要练;Tl,血色幽蓝",["翡翠梦境"] = "Tm,我无限嚣張",["克尔苏加德"] = "Tm,依旧的依旧,魔法燃烧;TZ,清妤,八度余温",["藏宝海湾"] = "Tl,???",["图拉扬"] = "Tl,小小雪花",["壁炉谷"] = "Tl,近松十人众",["风暴之怒"] = "Tj,塑以花之形;Te,天然元素",["鬼雾峰"] = "Ti,荙芬奇",["深渊之巢"] = "Th,丿田鼠",["能源舰"] = "Th,巫月",["月神殿"] = "Tg,刪除於終點",["瓦丝琪"] = "Tf,小瓶盖儿",["罗曼斯"] = "Td,因为蛋疼所以",["世界之树"] = "Td,Stillalive",["凯恩血蹄"] = "Tc,闪伯利恒之星",["瓦里安"] = "Tc,陈年老号",["迅捷微风"] = "Tc,扶桑啊大红花",["银松森林"] = "Tc,樱桃",["朵丹尼尔"] = "Tc,Miuinitio",["海克泰尔"] = "Tb,叮噹咕嚕",["白骨荒野"] = "Ta,羽月希丶,幻之地狱"};
local lastDonators = "聖乂骑-罗宁,可爱的柯-索瑞森,暴走小怪兽-黑翼之巢,大胸坏坏-影之哀伤,無伈戀愛-黑暗虚空,年华灬流光-伊森利恩,强袭牛叔-黑铁,战神伍陆柒-血色十字军,小毒蛇-永恒之井,Carrotqiuqiu-贫瘠之地,团结就是力量-夏维安,多才多亿-白银之手,贺筱滢丶-凤凰之神,翀大师-燃烧之刃,强力的小明-安苏,秋日晴空-血色十字军,Rita-无尽之海,烈焰摩纳哥-罗宁,灵小龙-安苏,爱治衡真是太好啦-凤凰之神,神秘抓根宝-影之哀伤,洛神红茶-死亡之翼,林小枣-血色十字军,林小藻-血色十字军,奔跑的晓蜗牛-安苏,希尓咓娜斯-破碎岭,扶我上魔兽-无尽之海,村东头老高-安苏,丶谭咏麟-迦拉克隆,清河小影-熊猫酒仙,白桃乌龙茶丨-霜之哀伤,璀璨青春-国王之谷,锦瑟華年-燃烧之刃,仟羽-神圣之歌,老扎皮-凤凰之神,熊贰灬-熊猫酒仙,Ytc-血色十字军,从良詹事-盖斯,霍拉拉-金色平原,威尔谢尔-桑德兰,Kuxiang-死亡之翼,圣美美-回音山,江小白不白-影之哀伤,诗淼-影之哀伤,子夜流觞-凤凰之神,贴心小宝贝-丽丽（四川）,不必候-死亡之翼,灵性丶-无尽之海,吉喵-末日行者,石生缘-格瑞姆巴托,整他-水晶之牙,天青惹寂寥-燃烧之刃,颂雨-国王之谷,雨落雨听雨-白银之手,鹧咕菜-死亡之翼,銠鑫-洛肯,沐丨阳-燃烧之刃,丨艾特丨-无尽之海,甜丶瓜-血色十字军,丹尼斯莱耶斯-霜之哀伤,遗忘灬记忆-洛丹伦,Kuxd-死亡之翼,颜晓峰-白银之手,Zellenleiter-洛肯,喂面之子-死亡之翼,封于修丶-???,小善萱-迦拉克隆,神针子-死亡之翼,Woolala-伊利丹,帕拉伊巴-贫瘠之地,Ipromise-雷斧堡垒,暗影之境丶纞-伊森利恩,春不晓-安苏,狸笙-???,小念儿-丽丽（四川）,我说一个数-狂热之刃,阿吉-金色平原,苏菲不漏-国王之谷,戰神飄雪-主宰之剑,爱火烧不尽-伊森利恩,禽王绕柱-凤凰之神,聆听雨声丿墨-安苏,丶老白-红龙女王,麻老李-奈法利安,十年回忆杀-凤凰之神,时暖时荫凉-安苏,徳鲁伊伊-白银之手,何以为-泰兰德,銀发-格瑞姆巴托";
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