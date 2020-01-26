local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["凤凰之神"] = "MB,灬洛神灬,塘风;MA,肉夹馍不闲;L+,百里红妆,巴卫灬;L9,一五零九下铺;L8,忆尘容;L7,卡兹丶;L6,油腻噶;L5,毒瘤老虾米,卯之花烈,灬渡你成魔丶,朵力;L4,丘山红叶,塔心乂譁,超甜小豆浆,天堂与利刃,气气莫迟疑;L3,心碎还要逞强,我爱谢宝宝,钉铛,醉漾轻舟,三生无梦,Vilgefortz",["雷克萨"] = "MB,梯七猎;L7,好多图腾丶",["白银之手"] = "MB,心靈捕手,素昕;MA,充耳盈琇,Dearle;L+,丶小言,歳歳平安;L9,苗坚强,Mahat;L8,小脚灬冰凉,弥若,跑尸天使,我知你深度,言念丨平安,牧冫诗;L6,目无全牛,花园绘里香,伤害第一吃食;L5,东门斩兔,杉沐杉沐,大神丨宅,暗柔清似水,歌渔乐;L4,嘎嘣脆火锅鸡;L3,冬天猫,温暖终年不遇,琪露诺老师,海钓地藏",["迅捷微风"] = "MB,莫斯提马;MA,疾影的鸟;L/,魏生津;L5,灵异学家",["奥尔加隆"] = "MB,花不了的心;L8,云月",["燃烧之刃"] = "MB,帅气的君君;L+,有一只座山雕,兜兜里有菠萝;L9,踏雪浪子,明亼不放暗屁,扎个啾啾,联盟之神,Mulrss;L7,浪小杰,总冠軍狐人;L6,是我小白啦,此男值得拥有,琨琨大魔王;L5,晴朗的天空;L4,紫星河,威尔昂赛汀;L3,凝云丶雪舞,Sakurai,别抢棉花糖",["血色十字军"] = "MB,沙拉托尔;MA,白银公爵,夜行黑白路,小毒瘤灬;L/,机智的阿风;L9,圣光小毒瘤,夜色圣弓;L6,严莉莉;L5,尖叫的柠檬;L4,阿呆丶丶,阿呆呆,萌戦姬,吴二乂,范尼丝特鲁伊;L3,你来捅死我啊,人间仙子",["死亡之翼"] = "MB,圣光下的黑骑;L/,李元淓;L+,翻云覆雨愁,芬达戒不掉丶,王也丿,暮雪寒峰,番茄西红逝;L9,Chichu,伟长坑,丷沐沐;L8,欧|煌;L7,一只尛团团,野兽先輩,冰雕;L6,不要捣乱;L5,空条承大郎;L4,湮火流年;L3,蜡笔海盗,拯救华语乐坛,爫口爫,夫唯不爭,林有钱,温柔的驾驭你,章魚妞,超火流星,疯医七世,誘人的煎牛排,宇文杀生",["金色平原"] = "MB,艾尔玛丶霞光;L9,阿旺晨泽尔;L8,伊娜;L6,马尾灬影歌",["熊猫酒仙"] = "MB,奕辰丨;L/,发条鸟年代记;L7,恩怨情仇",["伊森利恩"] = "MB,别的颜色;L7,中年妖孽,Lunar;L6,有一只大萌德;L5,猪猪侠,米蕾妮亚,狂岚丶;L3,老夫一抬腿,大明星波克比",["布兰卡德"] = "MA,Shadowerosio;L9,硬乂黑;L8,克莱尔菲莉斯,聆听月下曲;L6,是浅浅呀;L4,终焉权利;L3,丑萌大布娃娃,狂暴的牛鞭",["安苏"] = "MA,扬鸿赫铭;L+,夏竹佩,桃花朵朵儿,丿莉娅德琳;L9,俺们是正经人;L8,时光伴你成殇;L6,玖門提督;L4,大肥豚豚,海沃德;L3,逼逼糕,辉耀之击,南辰希丶",["格瑞姆巴托"] = "MA,柒楽贰拾玖,雾隐烟花落丶;L/,狡猾的灭灭子;L+,小雨嘀嗒嘀,凤姐她姐;L9,青囊煮酒,狐尕喵丷,伤感浪人;L8,勥牛狼,无人认识我;L7,一笑人间万事;L6,推倒狐,残兵令;L5,吻技差;L3,老胖虎,百合折丨",["龙骨平原"] = "MA,丶救世",["塞拉摩"] = "MA,光年之外;L5,凌梦长",["哈卡"] = "MA,肉肉丶",["贫瘠之地"] = "MA,躺尸咾板,彡风筝;L+,安晓晨;L9,宇智波刘德华,Loveofmay;L8,萌萌哒小秦秦;L7,朔夜丶倾城;L3,Libero,就是不拉你,翡翠灬燃",["荆棘谷"] = "MA,呆呆带师兄",["???"] = "MA,雾隐烟花落丶,守护橙子灬;L7,斗萝;L5,青尘丶,冰红茶;L4,丶沐雨澄风",["诺兹多姆"] = "MA,确认过眼神;L3,Misying",["神圣之歌"] = "MA,丶盗心",["埃德萨拉"] = "MA,跪下臣服于我;L/,刀刀刺心,战丨意;L9,諾格弗格;L5,佲汜",["主宰之剑"] = "MA,夏尔貝;L/,钉狗,瑟莱德丝王子;L+,圆滚滚小柯基;L9,灰紫;L7,蓝皮鼠的大脸;L6,五竹庆余年,薄荷叶乀清凉;L5,猫悠悠,匪号丶流氓,冯小倩,丿瓦蕾拉乀,彩鱗;L3,Yahaha",["山丘之王"] = "MA,水天裘一色;L6,青冰的白夜",["艾露恩"] = "L/,布丽吉塔;L9,双线程",["利刃之拳"] = "L/,诶有誒誒",["罗宁"] = "L/,惡鬼滅殺;L+,灬灬希娅,安丶小希,请叫我笗呱丶;L9,松糕布丁;L8,炒鸡哈士奇;L4,司辰,原来是熙熙啊;L3,Troyesivan",["诺莫瑞根"] = "L/,Bearr",["狂热之刃"] = "L/,铁匠炉子;L4,弑风者沙恩",["国王之谷"] = "L/,长枫丶;L+,狂暴小西瓜,顾北清歌丶;L9,月心;L7,盛世锋芒,韦伯斯特;L6,丨蛋丶蛋丨,阿斯塔特;L5,林丰收;L4,萌萌小巡警;L3,轻吟一句情话",["阿纳克洛斯"] = "L/,永真",["诺森德"] = "L/,艾奥里亚",["鬼雾峰"] = "L/,Saebyeolbe",["安其拉"] = "L+,无尽夜幕;L9,午后的旅行",["末日行者"] = "L+,悠笛,伊宜已逸,溫蒂丶瑪貝爾;L9,肉男;L7,贼拉风;L6,不要打豆豆呀;L3,好运姊,憨憨德,夜月之魂,别搞事儿吧",["巴纳扎尔"] = "L+,炽焰",["回音山"] = "L+,言秋丶;L9,苍萧,绝种龟壳;L4,嗨丶英雄",["扎拉赞恩"] = "L+,还我奶瓶",["远古海滩"] = "L+,吨吨嗝",["霜之哀伤"] = "L+,凉生初雨;L3,流霜似霞",["阿比迪斯"] = "L+,漫欲",["加基森"] = "L+,鱼没丢,洳淉丶二",["银松森林"] = "L9,Charisman",["影之哀伤"] = "L9,狐狸狐途,干天的慈雨,凛上开花;L7,嗜血狂杀;L4,卡布奇诺",["希尔瓦娜斯"] = "L9,间歇自闭;L4,蔡靓猪",["洛丹伦"] = "L9,我要下重手了",["加兹鲁维"] = "L9,小孩并不小",["斯坦索姆"] = "L9,熙洛洛",["迦拉克隆"] = "L9,之狼丶;L5,紅鳶;L3,㐅豆儿粥",["耳语海岸"] = "L9,艾玛什么鬼",["拉文凯斯"] = "L8,黯之星星;L3,路过的神父,Van",["冰霜之刃"] = "L7,萨科丿麦迪克;L4,苏苏洛,Yaksa",["阿古斯"] = "L7,达科塔范尼;L3,贫僧法号神棍",["破碎岭"] = "L6,白茶淸欢",["守护之剑"] = "L6,狼烟笑",["瓦里安"] = "L6,术舞九仙",["无尽之海"] = "L6,红手的阿昆达;L5,跟上灬小牧;L3,你就是旋律",["亚雷戈斯"] = "L6,无人",["黑铁"] = "L6,加爾魯什",["芬里斯"] = "L6,永恒叛徒",["风暴之怒"] = "L6,典韦,小小荣耀",["梦境之树"] = "L6,空谷幽蘭;L3,Yxqcovo",["激流堡"] = "L5,珀耳修斯",["燃烧军团"] = "L5,孙总",["亡语者"] = "L5,讷于言敏于行",["月光林地"] = "L5,火墙火墙火墙",["暗影之月"] = "L5,史蒂芬辀",["轻风之语"] = "L5,无人生还",["激流之傲"] = "L5,黄有钱",["克尔苏加德"] = "L5,真的汉子;L4,墨舞劍意",["麦迪文"] = "L5,Dhcctv",["耐普图隆"] = "L4,迦列斯",["普罗德摩"] = "L4,南梅线",["阿拉希"] = "L4,Tine",["时光之穴"] = "L4,一毒奶一",["海克泰尔"] = "L4,惊无命",["冰风岗"] = "L4,阿洛洛丶",["盖斯"] = "L3,邦桑迪之息",["伊利丹"] = "L3,Fourie",["埃苏雷格"] = "L3,海释灵",["泰拉尔"] = "L3,魔夜风",["壁炉谷"] = "L3,我是一支花",["格雷迈恩"] = "L3,猫七七",["卡德加"] = "L3,Mariandel"};
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