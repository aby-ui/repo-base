local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["祖阿曼"] = "MG,阿良良木历",["国王之谷"] = "MG,董老湿;MF,长沙粉蒸肉;ME,茗之守护,Hawkii;MD,胖胖嘚文哥;MB,泡泡糖糖;L/,长枫丶;L+,狂暴小西瓜,顾北清歌丶;L9,月心",["凤凰之神"] = "MG,戰意如潮,Melatonin;MF,笨鸟先飞,圣丨小十三,淡若如初;ME,米小乐,夕阳残雪,相顾无言;MD,乄指尖冰凉,卿本佳猫,恺撒灬熙影;MC,Eivan;MB,灬洛神灬,塘风;MA,肉夹馍不闲;L+,百里红妆,巴卫灬;L9,一五零九下铺;L8,忆尘容",["迦拉克隆"] = "MG,青柠丶;L9,之狼丶",["回音山"] = "MG,蛋蛋瞎,厥阴刃,Nernst;MF,落子无悔;MD,咯卡,琉璃圣光;L+,言秋丶;L9,苍萧,绝种龟壳",["熵魔"] = "MG,影丶帝",["塞拉摩"] = "MG,牛板筋好吃么,臭大姐;MA,光年之外",["格瑞姆巴托"] = "MG,不怕就怕,不得顾采薇,狸骚丶;MF,醉千尘;ME,伯爵的猫,啃瓜扯蛋,柚子又抽了,黑夜踩影,奕茹永爱,看相摸骨;MB,猎风尘;MA,柒楽贰拾玖,雾隐烟花落丶;L/,狡猾的灭灭子;L+,小雨嘀嗒嘀,凤姐她姐;L9,青囊煮酒,狐尕喵丷,伤感浪人;L8,勥牛狼,无人认识我",["白银之手"] = "MG,鼠大侠;MF,Zmyy,亲爱的思念的;ME,傲娇最讨厌了,破刃之殇;MD,熱心市民富貴,昝冬珠,吾爱乔文,Simonslo,东南西北,元宝的老母亲,Mariasharp;MC,聒噪的小土包;MB,囧小贱,幕丶秒玄,可耐加油哦,哥丶手握大刀,诡异的鹌鹑蛋,心靈捕手,素昕;MA,充耳盈琇,Dearle;L+,丶小言,歳歳平安;L9,苗坚强;L8,小脚灬冰凉,弥若,跑尸天使,我知你深度,言念丨平安,牧冫诗",["安苏"] = "MG,干活一丶不累,干活迎风布阵;ME,卡哇伊希月,卡哇伊曦月;MA,扬鸿赫铭;L+,夏竹佩,桃花朵朵儿,丿莉娅德琳;L9,俺们是正经人;L8,时光伴你成殇",["贫瘠之地"] = "MG,小萌德,面包超人`;MF,半夏;ME,阿塔尼斯主教;MA,躺尸咾板,彡风筝;L+,安晓晨;L9,宇智波刘德华,Loveofmay;L8,萌萌哒小秦秦",["金色平原"] = "MG,咻咻丨,乄咻咻乄,灬咻咻灬;MD,无心而失;MB,艾尔玛丶霞光;L9,阿旺晨泽尔;L8,伊娜",["冰风岗"] = "MG,小帥比,小萌比;MF,野兽先輩;MC,肾虚",["加兹鲁维"] = "MG,唐絮;L9,小孩并不小",["阿古斯"] = "MG,Thechosen;ME,怪兽哥斯喵",["主宰之剑"] = "MG,刘棒棒;MF,丿瓦莉拉乀,鹿月溪,火星来的骑士;ME,肉总,肥肉乱颤;MD,怡景志洞丶;MA,夏尔貝;L/,钉狗,瑟莱德丝王子;L+,圆滚滚小柯基;L9,灰紫",["雷霆之王"] = "MG,又是括号",["末日行者"] = "MG,檐上落白;MD,奔驰吴;L+,悠笛,伊宜已逸,溫蒂丶瑪貝爾;L9,肉男",["死亡之翼"] = "MG,避雷针,代号找死;MF,传说的小公主;ME,Worx;MD,蜘丶蛛丶侠;MC,萧婉婉,蔡靓猪,丷园寶寶;MB,隆梅尔,圣光下的黑骑;L/,李元淓;L+,翻云覆雨愁,芬达戒不掉丶,王也丿,暮雪寒峰,番茄西红逝;L9,Chichu,伟长坑,丷沐沐;L8,欧|煌",["燃烧之刃"] = "MG,十五年老萨满;ME,激励的阿然然;MD,錦衣卫;MC,陈露莎二号;MB,帅气的君君;L+,有一只座山雕,兜兜里有菠萝;L9,踏雪浪子,明亼不放暗屁,扎个啾啾,联盟之神,Mulrss",["亡语者"] = "MF,浮华上仙",["翡翠梦境"] = "MF,飛雨落花;MB,深暮",["灰谷"] = "MF,传说中的菜逼",["遗忘海岸"] = "MF,藤虎一笑,丶翩若惊鸿",["迅捷微风"] = "MF,雷迦迪奥斯;MB,莫斯提马;MA,疾影的鸟;L/,魏生津",["丽丽（四川）"] = "MF,丶沙烁",["加基森"] = "MF,小小五;L+,鱼没丢,洳淉丶二",["伊瑟拉"] = "MF,叫我小菜菜",["冰霜之刃"] = "MF,孤独随我",["鬼雾峰"] = "MF,奥黛丽灬苏伦;L/,Saebyeolbe",["黑铁"] = "MF,Poacher",["战歌"] = "MF,曜夜",["血色十字军"] = "MF,烟月不识人;ME,代號維羅妮卡;MC,就瞅你杂嘀;MB,沙拉托尔;MA,白银公爵,夜行黑白路,小毒瘤灬;L/,机智的阿风;L9,圣光小毒瘤,夜色圣弓",["无尽之海"] = "ME,关东煮大萝卜,加油;MD,蛋挞使者;MC,千沧雨,马修丿埃蒙斯",["石爪峰"] = "ME,俄里翁不在酒",["???"] = "ME,丶蛰伏丶;MD,我是奶德;MA,雾隐烟花落丶,守护橙子灬",["红龙军团"] = "ME,Physics",["海克泰尔"] = "ME,大椰子耶",["大地之怒"] = "ME,好多好多雨;MB,暮雪焚尘",["罗宁"] = "ME,張耀扬;MD,行走的大腰子,桃子是斗娜吖,爱偷鱼的猫,字孔明号卧龙;MB,骢鸣;L/,惡鬼滅殺;L+,灬灬希娅,安丶小希,请叫我笗呱丶;L9,松糕布丁;L8,炒鸡哈士奇",["银松森林"] = "ME,一斯嘉丽一;L9,Charisman",["奥特兰克"] = "ME,结诚梨斗",["影之哀伤"] = "ME,寧静致遠,丷紫夜丷;L9,狐狸狐途,干天的慈雨,凛上开花",["鲜血熔炉"] = "ME,屠鸡狂魔",["泰兰德"] = "ME,开心大魔王",["暗影之月"] = "ME,貔貅欲成精丶",["龙骨平原"] = "ME,忘尘子;MA,丶救世",["布兰卡德"] = "ME,Igyyf;MC,星光兔子,月火兔子;MB,陌陌灬;MA,Shadowerosio;L9,硬乂黑;L8,克莱尔菲莉斯,聆听月下曲",["太阳之井"] = "ME,呆萌小法師",["阿尔萨斯"] = "ME,狂野美少女",["月光林地"] = "MD,七夜花火",["霜之哀伤"] = "MD,Athenaya,六环少一环,战刃无双;L+,凉生初雨",["奥尔加隆"] = "MD,梦醒时分;MB,花不了的心;L8,云月",["巨龙之吼"] = "MD,依然留心",["布莱克摩"] = "MD,血小吉安",["熊猫酒仙"] = "MD,菲琳丶语风,青鸢;MB,昵称已占用吗,奕辰丨;L/,发条鸟年代记",["伊森利恩"] = "MD,蹉跎歲月;MB,别的颜色",["艾露恩"] = "MD,菲天;L/,布丽吉塔;L9,双线程",["梦境之树"] = "MD,冰焰之忆",["雷克萨"] = "MD,七海七海七海;MB,梯七猎",["天空之墙"] = "MD,丿狩猎者",["勇士岛"] = "MD,战帝丶怒天",["阿克蒙德"] = "MD,蓝色茶几",["荆棘谷"] = "MD,妹控呦;MA,呆呆带师兄",["法拉希姆"] = "MD,豌豆射手君",["千针石林"] = "MC,嘚噜咿",["加尔"] = "MC,Fiora",["万色星辰"] = "MC,优优鸣天剑",["诺莫瑞根"] = "MC,单脚闯天涯;L/,Bearr",["远古海滩"] = "MC,猫冲钅;L+,吨吨嗝",["熔火之心"] = "MC,丶北音,丶隔壁王麻子",["海加尔"] = "MC,Zoom",["金度"] = "MB,Zhangzhi",["神圣之歌"] = "MB,流星之河;MA,丶盗心",["哈卡"] = "MA,肉肉丶",["诺兹多姆"] = "MA,确认过眼神",["埃德萨拉"] = "MA,跪下臣服于我;L/,刀刀刺心,战丨意;L9,諾格弗格",["山丘之王"] = "MA,水天裘一色",["利刃之拳"] = "L/,诶有誒誒",["狂热之刃"] = "L/,铁匠炉子",["阿纳克洛斯"] = "L/,永真",["诺森德"] = "L/,艾奥里亚",["安其拉"] = "L+,无尽夜幕;L9,午后的旅行",["巴纳扎尔"] = "L+,炽焰",["扎拉赞恩"] = "L+,还我奶瓶",["阿比迪斯"] = "L+,漫欲",["希尔瓦娜斯"] = "L9,间歇自闭",["洛丹伦"] = "L9,我要下重手了",["斯坦索姆"] = "L9,熙洛洛",["耳语海岸"] = "L9,艾玛什么鬼",["拉文凯斯"] = "L8,黯之星星"};
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