local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,孤雨梧桐-风暴之怒,释言丶-伊森利恩,空灵道-回音山,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,不要捣乱-贫瘠之地,大江江米库-雷霆之王,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯";
local recentDonators = {["伊森利恩"] = "GI,Seral;GH,神话情话;F/,唐柔",["荆棘谷"] = "GI,最初丶",["克尔苏加德"] = "GH,亡月劫;GE,Zorrol;F/,圣男",["主宰之剑"] = "GH,小拳拳砸死你;GE,孤傲冷霜;GD,君無恙;GC,影月谷的夜风;GA,戳一下;F/,Emmazz,笙歌灬",["狂热之刃"] = "GH,丶爱卿丶",["末日行者"] = "GH,花与布偶猫,六月风儿;GG,Prcc;GC,贰零零柒",["毁灭之锤"] = "GH,三季蹈",["石爪峰"] = "GH,阿克懵德;GB,小熊七岁",["泰兰德"] = "GH,杀猪焉用刀",["燃烧之刃"] = "GH,星语星愿;GF,小夜猫子;GD,纯羊奶,Sawyerlol,Bracelet,蜗牛别跑祝福;F+,更位长",["萨菲隆"] = "GH,九龙抬棺",["影之哀伤"] = "GH,自爆绵羊;GB,风行领域;F+,千年神伤",["破碎岭"] = "GH,盗禧,潘尛达,萨是比尔,Asny,Dlaney,装逼加逞能,Sheamuss,Alria,Ildan,铁蛋儿,帅哥来玩啊;GA,小心元素",["死亡之翼"] = "GH,匆匆丶;GG,武磊;GD,Jackpinel,花开不糜;GC,根本丨英俊;GB,冷血小黑猫,新萌小宝;GA,奶僧宝宝,黑手丶涮熊肉;F/,深知她是梦;F+,神月灬卡琳,幸福的沙雕,酒意入桃枝",["安苏"] = "GH,飞将军丶老刘;GG,Boterye;GD,惜树,方应看灬;GB,我是小犄角;F+,荒川灬",["亡语者"] = "GH,狂热分子灬战",["菲拉斯"] = "GH,苦集灭岑",["格瑞姆巴托"] = "GH,丶心有萌虎;GG,来自五橙寺;GF,無言丶;GD,乱射菊花,罗的右手;F/,花卷丶丶,风火灬侠客;F+,醉吟丶幽冥",["血色十字军"] = "GG,诺娃,若无名㒹;GF,桑籍丶",["贫瘠之地"] = "GG,怂输辈,黒子鸟;GF,空条吉影,小鱼饼;GC,鹿晗娘娘;GA,布沙尔;F/,梦回唐朝,轻描丶,美丽视界",["白银之手"] = "GG,我是小猪佩奇;GE,可兒爸比;GD,仙贱骑虾轉,绝命琳娜,落葉凰舞,落葉鳳舞;GB,你柠檬头;GA,老腰子恶霸;F/,Tresdina,丶芯肝呦;F+,夜雨冰岚,王辰风",["地狱咆哮"] = "GG,白夜阑珊丶",["纳克萨玛斯"] = "GG,一条菜狗",["黑锋哨站"] = "GG,不再忧伤",["???"] = "GG,氖丶大师,天佑强哥;GF,冷面枪王;GE,叶酱;GD,彭彭;F+,加拿大丶电鳗",["丽丽（四川）"] = "GG,当麻纱堎;GA,火怒风,珏宁",["黑龙军团"] = "GG,可老坦",["阿古斯"] = "GG,醉后的无言,紅莲劫焰;F+,弑杀",["阿迦玛甘"] = "GG,淼雪,双鱼之悦,双鱼之月,双鱼座,霜鱼座",["冰霜之刃"] = "GG,竹林熊猫;GE,范灬爺;GA,萌丶火焰烈酒",["遗忘海岸"] = "GG,菊神",["暗影之月"] = "GF,火儛丶",["暮色森林"] = "GF,聖光丶",["黑铁"] = "GF,落羽丶",["熊猫酒仙"] = "GF,紫源;GE,优秀的武僧;GC,雅咩跌,一偷心贼一;GB,灬惜缘灬;GA,琉璃寻;F+,姐姐幻肢好硬,姐姐幻肢好烫",["斩魔者"] = "GF,得啵得啵得",["熔火之心"] = "GF,Vril;GB,新泰面条哥;GA,欧皇灬法,巅灬峰,Lintq",["世界之树"] = "GF,雨露星辰",["万色星辰"] = "GF,Vuiu",["布兰卡德"] = "GF,情緣惜兮丶;GD,路西斐尔;F/,我不怕死",["卡德加"] = "GE,枫舞风铃",["冰风岗"] = "GE,余音缭绕;GC,勺子丶;GB,成长快乐",["瓦里安"] = "GE,陶宏开",["无尽之海"] = "GE,我很谦虚丿;GC,空客,｜华佗｜;GB,丶怪怪丶;GA,迷、魂,轻舞杜啦啦;F/,糖果好甜",["凤凰之神"] = "GE,跑调的爱情;GD,灬我劝你善良;GC,严谨;GA,罗纳尔多丶帅;F/,丨戏子,安静的牧,安静的道,团长与狗",["战歌"] = "GE,虾仁猪心",["罗宁"] = "GE,Myatt;GD,風雲萬劍歸宗,暴力狗;F+,明亮双眸,Jooferic",["阿拉希"] = "GE,牌社的小胖",["金色平原"] = "GE,伊莉雅丶枫心",["铜龙军团"] = "GE,枫露饮",["加尔"] = "GD,小孬猪,根本丨美丽",["迦拉克隆"] = "GD,妖小孽;F/,苏三蛋",["巴瑟拉斯"] = "GD,长角獠牙;GC,大帅",["海克泰尔"] = "GD,浮生恍若梦;F/,莫名妖灵",["埃德萨拉"] = "GD,闹翻天丶;GA,海海骸盗",["巫妖之王"] = "GD,白银圣光",["奥杜尔"] = "GD,希尽欢,暮悠然",["地狱之石"] = "GD,倾世女帝",["普罗德摩"] = "GD,秋风之刃",["阿曼尼"] = "GD,大老黑丶",["哈卡"] = "GD,沃夫",["奥拉基尔"] = "GC,幽冥静风",["鬼雾峰"] = "GC,言兮,落下的苹果;GA,萨满陌小三",["海加尔"] = "GC,无敌坏小子",["斯克提斯"] = "GC,恶膜",["奥尔加隆"] = "GC,正面上我啊;GA,玛克希姆;F+,血丝朦胧,末洛艾尔",["加基森"] = "GC,蝶梦流年;GB,神术妙法",["桑德兰"] = "GC,魑魅魍魉家族;F+,虾饺丶",["天空之牆[TW]"] = "GB,可愛的魚魚",["龙骨平原"] = "GB,桃瑞丝丶",["朵丹尼尔"] = "GB,紫杉丶死骑",["奥特兰克"] = "GA,浮云千载",["红龙军团"] = "GA,尐儍疍;F+,取名丶周公",["大地之怒"] = "GA,从頭再来",["蜘蛛王国"] = "GA,夜雨依晨",["自由之风"] = "GA,乌瑞亚",["深渊之巢"] = "GA,Rhymes",["晴日峰（江苏）"] = "F/,涉川",["风暴之怒"] = "F/,浅丶",["国王之谷"] = "F/,素兮娆湄,梦看云升",["霜狼"] = "F/,第六小号",["洛萨"] = "F/,等灯等灯",["壁炉谷"] = "F+,冈本零零壹",["耐奥祖"] = "F+,糯米籽",["迪瑟洛克"] = "F+,Alsarser",["回音山"] = "F+,一位熊猫",["萨尔"] = "F+,王多鱼",["库德兰"] = "F+,东门斩兔",["末日祷告祭坛"] = "F+,幽幽寒冰",["黑翼之巢"] = "F+,Jasonhunter",["夏维安"] = "F+,恋小燕",["提瑞斯法"] = "F+,凉梦无音"};
local start = { year = 2018, month = 8, day = 3, hour = 7, min = 0, sec = 0 }
local now = time()
local player_shown = {}
U1Donators.players = player_shown

local topNamesOrder = {} for i, name in ipairs({ strsplit(',', topNames) }) do topNamesOrder[name] = i end

local realms, players, player_days = {}, {}, {}
local base64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
local function ConvertDonators(day_realm_players)
    if not day_realm_players then return end
    for realm, allday in pairs(day_realm_players) do
        if not tContains(realms, realm) then table.insert(realms, realm) end
        for _, oneday in ipairs({strsplit(';', allday)}) do
            local date;
            for i, player in ipairs({strsplit(',', oneday)}) do
                if i == 1 then
                    local dec = (base64:find(player:sub(1,1)) - 1) * 64 + (base64:find(player:sub(2,2)) - 1)
                    local y, m, d = floor(dec/12/31)+2018, floor(dec/31)%12+1, dec%31+1
                    date = format("%04d-%02d-%02d", y, m, d)
                else
                    local fullname = player .. '-' .. (realm:gsub("%[.-%]", ""))
                    if not tContains(players, fullname) then
                        table.insert(players, fullname)
                        player_days[fullname] = date
                        player_shown[fullname] = topNamesOrder[fullname] or 0
                    end
                end
            end
        end
    end
end
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

function U1Donators:CreateFrame()
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

    f:Hide();
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