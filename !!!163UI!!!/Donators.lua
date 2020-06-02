local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["冰风岗"] = "OE,幕天流觴;OD,鱼幼薇乁;OC,祈雨挽歌;N/,第一次玩坦",["死亡之翼"] = "OE,锦程锦瑜,Merr;OC,蝉溟,Devilhunterr;N/,吥德鸟;N+,花落流年度;N9,月下灵毁;N8,皮皮竹丶,沙梨;N6,朝霞与热带鱼,六月丨鸽子蛋;N5,清新丷小纯洁,造孽者;N4,凛冬晨风,丨盜賊丨;N3,禅丶武;N1,风趣又端庄;N0,老中医丷,橘子皮丶啊,青春点燃双刀,肉饼子;Nz,腓特烈",["暗影议会"] = "OE,四是四",["月光林地"] = "OE,炮妈",["主宰之剑"] = "OE,为你联盟;OC,第柒头熊,空白时光;N/,刺客伍六七灬;N6,Trüst;N3,守护坦;N2,梦老白,梦大白;Nz,嗜血小情人,可爱川川",["安苏"] = "OE,小天罡星,小言酱,彡野猪佩奇彡;OA,祢豆法;N7,丨丨怒吼丨丨;N4,巴黎贝贝;N2,鳇体制;N0,氵山河故人丶,破九霄",["雷斧堡垒"] = "OE,河西",["末日行者"] = "OE,月光大叔;N9,千寻冰封;N3,当妮走了丶;N0,戰長沙;Nz,够酥,Osis",["国王之谷"] = "OE,瞧我眼色行事,憨憨的仔丶;OD,御长风,柒柒吖;N/,剁椒小猪蹄;N1,恐怖如斯;Nz,一千朵玫瑰花",["罗宁"] = "OE,梦里是谁;N5,丶苍术;N1,斩服少女,Beany",["厄运之槌"] = "OE,多瑞米法索",["格瑞姆巴托"] = "OE,小犄角角丶;OC,无间狱丶銃墓,乌尔奇奥拉丶;OA,阿葳拾捌式;N/,百嘼凯多;N+,伊翦殇;N4,丨暴丨君丨;N3,黑噝大长腿;N2,血靈之天使;N1,鱼淼情深;N0,吃你的西瓜吧;Nz,御前跳跳侍卫",["熊猫酒仙"] = "OE,泰瑞昻,劒来;N3,繁華落尽",["鬼雾峰"] = "OE,Deadboom;N7,丄小香丄;N4,洛丹伦的夏天",["血色十字军"] = "OE,语瞳;OC,懒兮兮;N3,小睿德丿利齿;N1,浩浩很皮,洛坎丶狩龙者,聖光将熄丶",["金色平原"] = "OE,杰赫妮拉;OB,奈亚子最可爱;N0,灵枫",["亡语者"] = "OE,Liadrin",["燃烧之刃"] = "OE,萨米亚;OB,荏苒;OA,圆滚滚;N/,达雷尔的岛;N+,大洋哥;N7,Sawyerlol;N6,Luckybamboo;N4,述凡;N3,时间就是菳钱,咕妖王;Nz,高圆寺让,西门靓仔,傲娇的杰尼龟",["白银之手"] = "OE,十八岁美女;OD,诺艾西斯,全村儿的希望,奥雷莉亚公爵;OC,过气老骑士,萨拉托加加,霸道的铁锤;OB,蕭蕭丶,丶蕭蕭,哥又给你脸了;OA,小猪猪佩琦,灬王德发,空小白丶;N+,一对柒;N9,轻风马蹄疾;N8,坐上去自己动;N6,全村的希望;N2,導演丶我躺哪;N1,暖色花雨;N0,牛的几波奶,夣迴醉三笙;Nz,元少,疾风之翼",["影之哀伤"] = "OE,德之吾幸丶;OD,刘小美,通州阿宝;OB,Ways;N5,生与死丶;N1,過的好疲憊,听说你们缺德,壹条小青龍丶,妮可羅賓;Nz,滴血之锋",["翡翠梦境"] = "OD,Elenion",["熵魔"] = "OD,好炫酷",["夏维安"] = "OD,恶魔之猎手,何以解忧丿",["永恒之井"] = "OD,伯拉勒斯海风;N0,鹧鸪菜",["贫瘠之地"] = "OD,花翎丶,骑马斩杀;OC,苏清秋;N/,邻家雪缘;N+,兮灬月;N8,圣光打码;N7,画笔;N2,灬阿楽灬;Nz,求之就德",["黑铁"] = "OC,一玛莎拉蒂一",["太阳之井"] = "OC,小小色牛",["瑟莱德丝"] = "OC,Mercy",["无尽之海"] = "OC,君嗼笑;N7,鱼子酱鸡柳,大头打怪兽,小方舟;N1,洁小萨,兔子的绒毛;N0,超凶的小脑斧",["火羽山"] = "OC,灬風輕雲淡灬",["风暴之眼"] = "OC,椎名真音",["凤凰之神"] = "OC,丶米妮,丶妮酱;N/,美食家汉尼拔;N+,丿莫西干丶;N9,彡咻咻彡,一咻咻一,佰變鍂牛,北哥哥;N8,Búrger;N7,塞隆,穿拖鞋的精灵,Phant;N6,蒙牛有点酸,阿咪;N5,斩魂依旧,落雪依旧丶,落雪依旧;N4,三分糖;N1,艾酱的花朵;N0,南生四月雪;Nz,巫照师",["燃烧平原"] = "OC,妖兽雅蔑蝶",["梅尔加尼"] = "OC,香蕉你个皮管",["阿古斯"] = "OB,Emeraldiva;N8,Imdanei;N6,战无不胜",["布兰卡德"] = "OB,醉握故人箭,多尓衮;N+,王者言权;N9,随便飞行少女;N0,宛若新衣",["卡扎克"] = "OB,香草咖啡",["巴瑟拉斯"] = "OB,尐一女",["海克泰尔"] = "OA,武装色战火",["艾露恩"] = "OA,Cesare;N4,陈扒皮;N0,谶术",["破碎岭"] = "OA,雲天河",["战歌"] = "OA,Makgorra",["伊森利恩"] = "OA,夏了个天呀;N/,口吐芬芳的人;N+,你可德了吧;N9,壳壳一八三;Nz,大雨灬,猫猫丶鱼",["???"] = "N/,我住华理二舍;N+,心中有祖国",["奈法利安"] = "N/,Chelseaf",["迅捷微风"] = "N+,卖萌地板贼;N5,哲里",["守护之剑"] = "N+,夜深人静",["阿拉希"] = "N+,蜡笔小丶新;Nz,我名五个字",["图拉扬"] = "N+,月明人倚楼",["阿比迪斯"] = "N+,圆圆的木瓜",["地狱咆哮"] = "N+,灰烬丶领主",["阿克蒙德"] = "N+,颂葬者",["神圣之歌"] = "N+,刀剑如歌,秋断万岳;N8,钓鱼的树懒",["冰霜之刃"] = "N8,大威夭龍;N0,淡然无悔",["暗影裂口"] = "N8,二呆战",["海加尔"] = "N8,林夕菲本人",["塞拉摩"] = "N8,脱粪出血;N3,Dabyday;Nz,Convert",["回音山"] = "N7,冗余丶",["奥拉基尔"] = "N7,卡德布德里奥",["暗影之月"] = "N7,大写;N0,仲夏夜之兔",["雷霆之王"] = "N6,脚安娜",["远古海滩"] = "N6,弱三千",["恶魔之魂"] = "N5,阿尔泰公主",["克尔苏加德"] = "N5,孤森",["卡德加"] = "N5,灶门祢豆子",["迦拉克隆"] = "N4,我是干脆面",["冬寒"] = "N3,诸葛连撸",["闪电之刃"] = "N2,啰汁緗",["霜之哀伤"] = "N1,Chivalry",["血环"] = "N1,大跳崴了脚",["狂野之刃"] = "N0,雾瞳",["托尔巴拉德"] = "N0,奈丨落",["红云台地"] = "Nz,眼药水",["鹰巢山"] = "Nz,池傲天",["洛肯"] = "Nz,岁月神偷丷"};
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