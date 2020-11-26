local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["末日行者"] = "Q3,贰四六柒,欧西给;Qz,何以清尘灬",["???"] = "Q3,Ferfectlife,娜么可爱;Q2,凯宇大人;Q0,游德;Qz,妖鱼,扬中河豚岛;Qy,九尾吉月,丿小楽丶;Qw,櫻桃大丸子,弥凯朗淇洛,第七狩魂,Ssaberalter,牛油果去哪了,赫克托尔;Qu,山椒鱼丶半蔵,夯无力,大鸡脖美少女",["罗宁"] = "Q3,衝鴨,Miolov,欧达诺布莉耶,慕容晨;Q2,笑狂神,天使长;Q1,暮雪千岚;Qy,爱红红太好了,谢铃飞虫,Archmagic",["伊森利恩"] = "Q3,我喜欢艾菲热,阿尔特尔,圣光老牛氓;Q2,咕神小喵喵,一曳清风,涩气头头猫,君雅小妹妹;Q1,龙猫猫,艾菲热,森曲魂音丶;Q0,花烛映影深,重乄樓;Qz,狸头有芽儿",["冰风岗"] = "Q3,灬無雙丶;Q2,隐官,大聪明丨;Q0,九歌乀;Qy,乐神降临,痕星丶",["死亡之翼"] = "Q3,落青染丶,是果冻猫啊;Q2,黄皮耗子呀丶,大马户子;Q1,贼认钱,温蒂妮怒风,逝去的银弹;Q0,柚子君呀丶,是柚子君呀丶;Qz,山河予你,丷两根赖毛子,死灵嵐姬;Qy,加载失败,斑马苏宜",["凤凰之神"] = "Q3,如何遗忘,恭喜发財,羊你吃涮锅,奶牛桑,苏灬姗,你家兔兔;Q2,墨墨萌萌哒,尔等不讲武德,可爱夕,Meryl,歌丶律,灬小海疼灬,女王死忠粉,以德服亼;Q1,萬惡之靈,白爷丷;Q0,小尾巴不见了,殊茗丶;Qz,终极毒奶,妖刀可太帅了,似风没有归途,逍遥使,粉紅高压電,苏歌乁,黄瓜灬,沙雕爱狗,牧竖之焚,聖侊忽悠着你;Qy,米奈希尔大公,浪里个浪味仙,若影丶林,拉胯弟弟贼,不能叫我山鸡",["国王之谷"] = "Q3,嚣张的板砖;Q2,暮雨微光;Q1,叹为观止;Qz,九星战神龙尘",["格瑞姆巴托"] = "Q3,天市右垣十一,月炛;Q2,伟大的龟仙人,Amzings;Q1,粪坑潜泳;Qz,雲笙;Qy,糖绿绿",["血色十字军"] = "Q3,板栗,拔丝红薯,聖灬幽哈;Q2,老老队长;Q1,羽霖铃,桔子修成仙;Q0,泽塔;Qy,带带大冰龙,橙不二丶",["埃德萨拉"] = "Q3,黑黑丨的土,井井大魔王;Q0,熊灬贰,皮特德;Qz,矢心疯,天凡沉雨,晓之珀;Qy,游戏的大喵",["戈古纳斯"] = "Q3,只是;Qy,秋冷了月光",["风暴之怒"] = "Q3,秧歌姒妲",["影之哀伤"] = "Q3,天降殺機,魔法少女喵;Q2,柒夏玲珑;Q1,禅师,灬张子修灬,超级咔咔罗特,星尘;Q0,炎焱,骚年冲钅,少林菲;Qz,我需要治疗;Qy,九黎丶龙",["瓦里安"] = "Q3,Madeinchina",["贫瘠之地"] = "Q3,王保保,萌德沐沐,丶坚果,鸭啦嗦;Q1,也曾海棠依旧,宇智波牛德华;Q0,元丶旦;Qz,信仰之子,丨沙砾丨;Qy,蓦然之间丷,入心,何田田,亡魂灬牧诗",["无尽之海"] = "Q3,倾心;Q2,九尾狐丶,诡术丿妖姬;Q1,红叶铸流光;Qz,Icebe",["克尔苏加德"] = "Q3,我是卖保险的,嘤嘤宝贝,绯雀栖蝉;Q2,恶行左岸",["主宰之剑"] = "Q3,雾染如墨,花泽香菜忄;Q2,丶露水,淡漠以对;Q1,给我烙仨糖饼,丶雪拥蓝关,楼榕剑;Q0,拈花把酒情狂,Amandam,徐锦江的粉丝;Qz,灬郁蓝灬,墨邱立,Cynric,Shadowfalls,收费奶,丶格调;Qy,古神,吉祥乂如意",["迦拉克隆"] = "Q3,二爷丶蹲坑,迎风快滚;Q2,摁倒踹脸,谦丶卦;Qy,无聊也无橙",["暗影之月"] = "Q3,彩色镯子",["熊猫酒仙"] = "Q3,杨幂的初恋;Q1,我有我方向,蚊子吃西瓜;Qy,火烨炎焱",["金色平原"] = "Q3,好灬好美;Qz,嗑瓜子儿",["奥特兰克"] = "Q3,挨打就完事了",["白银之手"] = "Q3,Icemore;Q2,阿米达居,单点碧螺春,包宝宝,混吃的橘猫,丶绾起梨花月;Q1,悠扬归梦,耶夢伽得;Q0,目害目艮火柬,遇见你伏笔,不白忙,不合适;Qz,血小板丷,花与晴的流星,昂口田,霜奶萌萌哒;Qy,花生与酒,一罐冰镇啤酒",["黑铁"] = "Q3,死从天降丶",["黑石尖塔"] = "Q3,贰月丶逆流",["伊利丹"] = "Q3,丨小饼干丨",["米奈希尔"] = "Q2,小白兔",["灰谷"] = "Q2,嬲噻熊",["黑暗魅影"] = "Q2,阿丝匹琳酱",["奥斯里安"] = "Q2,三鹿牛",["艾露恩"] = "Q2,蓦山溪丶",["塞拉摩"] = "Q2,影禄落橘里;Qz,贰队那个戦士",["布兰卡德"] = "Q2,星屑的追忆;Q1,飞翔的大老鼠,加我莫悲",["雷斧堡垒"] = "Q2,贝宝",["寒冰皇冠"] = "Q2,白羽丶",["菲拉斯"] = "Q2,Xxlucky;Q1,暗灭",["洛丹伦"] = "Q2,動感回旋踢;Qy,小奶猪佩奇",["安苏"] = "Q2,午门三刻,来日方长吧;Q1,水塔陈醋;Q0,華脩,寄蜉蝣于天地,圣光常伴吾身;Qz,叶落乄花雨黯;Qy,山崎宗鉴,一大包仙贝丶",["银月"] = "Q2,姬如千珑",["熔火之心"] = "Q2,贰湿兄丶",["血环"] = "Q2,張公子丶;Qy,乐神归来",["幽暗沼泽"] = "Q2,Laker;Qy,李玩儿,高粱吉娃娃",["提瑞斯法"] = "Q2,黑木碎蹄",["狂热之刃"] = "Q2,欧德弗莱;Q1,星际小牛",["龙骨平原"] = "Q2,丶山大王",["巴瑟拉斯"] = "Q1,酸哥",["冰霜之刃"] = "Q1,南枝向暖;Q0,圣光铠;Qz,法力燃烧;Qy,全场最佳半藏",["玛诺洛斯"] = "Q1,丿灬璇玑",["霜之哀伤"] = "Q1,微焦的食物",["回音山"] = "Q1,小梦大半丶,烙丨印;Qz,Dala",["甜水绿洲"] = "Q1,曙光",["加兹鲁维"] = "Q1,飘血",["盖斯"] = "Q0,小糖人",["恶魔之魂"] = "Q0,变后不洗手",["战歌"] = "Q0,小圣之助",["鬼雾峰"] = "Q0,汣纔",["鲜血熔炉"] = "Q0,萨瓦迪卡丶汪",["雷霆之王"] = "Q0,致命攻击",["燃烧平原"] = "Q0,疯狂的六总",["燃烧之刃"] = "Q0,柯基大帝;Qz,暴躁的凉白开,一襟花月,筱暖阳;Qy,老卡老卡,Libra",["荆棘谷"] = "Qz,绿猴子",["丽丽（四川）"] = "Qz,系豆",["奥达曼"] = "Qz,染小莫㐅",["梦境之树"] = "Qz,静谧哈桑",["格雷迈恩"] = "Qy,莫高",["暴风祭坛"] = "Qy,飞翔的黄金瓜",["阿格拉玛"] = "Qy,墓诗",["奥杜尔"] = "Qy,雪月韵冰茶",["破碎岭"] = "Qy,假装炉石,假装增强",["永恒之井"] = "Qy,潍坊",["阿古斯"] = "Qy,素颜",["黑暗虚空"] = "Qy,望朦胧",["萨尔"] = "Qy,Peachguard",["加基森"] = "Qy,冻肉丸子",["朵丹尼尔"] = "Qy,马奎斯",["奥妮克希亚"] = "Qy,迦陵晚"};
local lastDonators = "月炛-格瑞姆巴托,魔法少女喵-影之哀伤,丨小饼干丨-伊利丹,绯雀栖蝉-克尔苏加德,慕容晨-罗宁,贰月丶逆流-黑石尖塔,鸭啦嗦-贫瘠之地,死从天降丶-黑铁,Icemore-白银之手,挨打就完事了-奥特兰克,欧达诺布莉耶-罗宁,丶坚果-贫瘠之地,萌德沐沐-贫瘠之地,迎风快滚-迦拉克隆,花泽香菜忄-主宰之剑,好灬好美-金色平原,嘤嘤宝贝-克尔苏加德,杨幂的初恋-熊猫酒仙,彩色镯子-暗影之月,苏灬姗-凤凰之神,是果冻猫啊-死亡之翼,二爷丶蹲坑-迦拉克隆,雾染如墨-主宰之剑,我是卖保险的-克尔苏加德,拔丝红薯-血色十字军,奶牛桑-凤凰之神,倾心-无尽之海,羊你吃涮锅-凤凰之神,王保保-贫瘠之地,欧西给-末日行者,恭喜发財-凤凰之神,Madeinchina-瓦里安,天降殺機-影之哀伤,井井大魔王-埃德萨拉,Miolov-罗宁,娜么可爱-???,秧歌姒妲-风暴之怒,只是-戈古纳斯,黑黑丨的土-埃德萨拉,板栗-血色十字军,天市右垣十一-格瑞姆巴托,圣光老牛氓-伊森利恩,嚣张的板砖-国王之谷,如何遗忘-凤凰之神,落青染丶-死亡之翼,灬無雙丶-冰风岗,阿尔特尔-伊森利恩,我喜欢艾菲热-伊森利恩,衝鴨-罗宁,Ferfectlife-???,贰四六柒-末日行者";
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