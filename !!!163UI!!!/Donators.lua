local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["罗宁"] = "OS,法爷;OR,一箭泯恩仇,银龙斗罗;OP,夹馍,菠萝波洛;ON,云梦丶远道;OM,筱法丝;OL,流鼻血的凡凡;OE,梦里是谁",["羽月"] = "OS,赤胆屠龙;ON,贼胖胖",["国王之谷"] = "OS,我是谁的青春;OP,大手套小手套;OL,丶零丶;OG,丨芣茬犹豫丨,索利达尔丶;OF,柯塔娜水晶,Damon,沧岚丶影月;OE,瞧我眼色行事,憨憨的仔丶",["格瑞姆巴托"] = "OS,微醺时的眼眸;OP,宝宝蘸大酱;OO,万雪千山;ON,挽手欧巴;OL,萌脸大瞎,義丶隨風;OK,八重樱丶丶;OI,灬弘一灬,丨一棵小菜丨,丨一颗小菜丨;OH,游心寓目;OE,小犄角角丶",["金色平原"] = "OS,归于无梦;OL,强哥太坑了,惊悚琉璃盏;OK,沈璧君;OJ,嘿嘿呼呼黑;OE,杰赫妮拉",["暗影之月"] = "OS,曜光之吻;OL,小奶兜",["加基森"] = "OS,假行僧丶;OG,亍亍,睿智的窝头",["埃德萨拉"] = "OS,鲤伴;ON,欲望浴缸鱼,莫墨小白;OH,布拉德皮条撸,暴雨梨花",["凤凰之神"] = "OS,江小宝丶,六库仙賊;OR,灵犀丷;OP,我能打挺多个,牙肿了;OO,国王与乞丐,大红,留恋,马尔蒂尼丶;ON,雨落雨落雨;OM,丶魔封锅,夜夜子;OL,鸢尾花与猫;OJ,檐上落白,伍柒捌,失于指縫,特雷泽盖丶;OI,灬尛冷灬,马尔蒂尼丶一,莫伦特斯丶;OG,Magicxia",["激流堡"] = "OS,思绪的水",["安苏"] = "OS,无怨丶无悔;OR,钱滚滚呐;OQ,酒丶侠,巨馍沾酱丶;ON,加菜啊;OM,猎老;OL,祈赞;OF,又又鸟;OE,小天罡星,小言酱,彡野猪佩奇彡",["黑铁"] = "OS,灬奎托斯",["阿尔萨斯"] = "OR,Britneylol;OI,胭脂;OF,曾大壮",["洛丹伦"] = "OR,苦菜菜子",["白银之手"] = "OR,唔多侍,净空领域,仙糖;OP,芝麻儿;OO,宝玛士;ON,雪月花时,雨夜幽兰丶;OM,萨鲁曼斯;OK,小巧的老胖子;OJ,陇右张小敬;OI,猎杀梦境;OG,黯之星霏;OF,無法潕天;OE,十八岁美女",["死亡之翼"] = "OR,杰克丶斯帕洛;OQ,尤朵啦丶,西呱丶,紫蘇丶,孙丶燕姿,謎翼,谜翼,小喵呔,拜月幽灵,Soii,華氏溫度;ON,夜轻影,烈焰烽爆;OM,满脸迷糊,深渊统领;OL,Wastee;OJ,欧鳇体制;OH,浪里个浪味仙,杯丶莫停;OG,陈寞;OF,破碎的膝盖;OE,锦程锦瑜,Merr",["破碎岭"] = "OR,苏白;OQ,伏惟长秋;OL,雲天河,李逍遙;OI,奶爸富贵儿,魚萌萌",["影之哀伤"] = "OR,月下小剑仙;OO,布洛老爹,清浅丶半夏;ON,大写的感叹号;OM,吸零纳一高,姜贞羽加油吖;OI,君莫笑乄;OE,德之吾幸丶",["冰风岗"] = "OR,Jokerys;OL,Rebirthbank;OK,修不同丷;OJ,萝卜烫了嘴;OG,Daolai;OE,幕天流觴",["安加萨"] = "OR,锦丶枫",["格雷迈恩"] = "OR,托尼史大棵",["龙骨平原"] = "OR,风舞夜月;OM,狂暴之力",["燃烧之刃"] = "OQ,你们的小宝贝,李商琪;OM,风清丶云淡,锁喉丶伏击;OL,尼古拉丝铠骑,奋斗中的熊少;OK,Menethilxx;OJ,让风带我飞,彭大春;OI,念瑶;OE,萨米亚",["瑞文戴尔"] = "OQ,丶小仙女丶",["贫瘠之地"] = "OQ,三牤子;OM,鲁飞;OK,不死斬;OH,想过离开",["末日行者"] = "OQ,小令悠悠;OP,小野君;OJ,Seventhapos;OE,月光大叔",["海克泰尔"] = "OQ,翡翠森灵;OI,猛医",["迅捷微风"] = "OQ,天天撸猫猫;ON,你很好吃啊,你可真香啊;OL,下五洋捉鳖;OH,卖萌地板贼",["月光林地"] = "OQ,囡囡囨囚囨図;OE,炮妈",["???"] = "OQ,灭绝丶人性;OO,晨总丶;ON,九寶,不死法王;OK,Hickey",["霜之哀伤"] = "OP,布里吉塔丶;OL,老花猫",["主宰之剑"] = "OP,哈灬撒给,忧郁的麦麦;OO,特仑灬酥;OL,小黄鸭丶,梦麦鸭;OK,钙嘉锌;OJ,捌月壹拾伍;OH,离炎流;OE,为你联盟",["风暴之怒"] = "OP,西园寺丶世界",["熊猫酒仙"] = "OP,牧始;OE,泰瑞昻,劒来",["回音山"] = "OP,洛枳;OF,赞恩防御者,小马萌萌哒",["迦拉克隆"] = "OP,夯沓夯沓;OI,娜娜别哎呦;OG,你得支棱起来;OF,部落萌德,圆圆的团子,丨夺魄丨,淡烟疏雨",["艾露恩"] = "OP,半妖倾城",["永恒之井"] = "OP,泽晨",["血环"] = "OP,不厌骑烦",["阿拉希"] = "OO,棋盘山老司机",["遗忘海岸"] = "OO,帐贱走天涯",["无尽之海"] = "OO,月丶半小夜曲",["风暴之眼"] = "OO,心无杂念",["雷斧堡垒"] = "OO,琻閃閃;OE,河西",["布兰卡德"] = "OO,虹影之城",["巴纳扎尔"] = "ON,惊蛰",["伊森利恩"] = "ON,毒素萃取图腾,红旗漫江山娇;OF,牛边",["闪电之刃"] = "ON,源氏",["夏维安"] = "ON,神聖流氓",["梅尔加尼"] = "ON,瘟疫领主",["翡翠梦境"] = "ON,愿拆曲成诗",["亚雷戈斯"] = "OM,大米求组;OH,骑士小兰",["冰霜之刃"] = "OM,卡殿",["阿古斯"] = "OM,下岗女工淑芬;OF,小熊宅急送",["塞拉摩"] = "OM,夜凉如水",["鬼雾峰"] = "OL,青眼究极聋;OE,Deadboom",["熔火之心"] = "OK,寒光月澜,魔礼青",["克尔苏加德"] = "OK,墨湮斩夜",["加兹鲁维"] = "OJ,两指逆天",["烈焰峰"] = "OJ,超人猪",["阿纳克洛斯"] = "OI,阿羡丶",["阿克蒙德"] = "OI,瓦拉几亚",["远古海滩"] = "OH,死在夢里",["加里索斯"] = "OG,蜃楼",["恶魔之翼"] = "OG,莫灬慌",["甜水绿洲"] = "OG,雾隐妖瞳",["荆棘谷"] = "OG,秘幻月天",["密林游侠"] = "OG,陈孝正,那个法爷丶",["雷霆之王"] = "OG,影儿",["爱斯特纳"] = "OG,东篱",["狂热之刃"] = "OG,琴瑟博芳泣,碎丶",["血色十字军"] = "OG,阿浩丶不吃素;OF,幽魂丶逐风;OE,语瞳",["蜘蛛王国"] = "OF,姬丝秀忒",["耐奥祖"] = "OF,你看我硬不",["世界之树"] = "OF,咿呀咿呀咿",["奥尔加隆"] = "OF,哈雷丶奎因",["暗影议会"] = "OE,四是四",["厄运之槌"] = "OE,多瑞米法索",["亡语者"] = "OE,Liadrin"};
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