local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["燃烧之刃"] = "Lp,混沌丶橙,枸杞威士忌;Lo,鬼迷心窍了;Lm,殷纯;Ll,人间摘星月丶;Lk,Pheonixi;Lh,卡卡丨罗特,墨守灬铖规;Le,创伤成就了我;Lc,克劳德丶霸斩;LY,丷龙爸爸;LR,电胖达;LQ,艾琳云歌;LP,一只猫的梦想;LN,熊猫烧香;LL,艾薇云歌",["奥尔加隆"] = "Lp,Amorstar;LS,阿油",["末日行者"] = "Lp,Maybesomeday;Lj,茜丹,唯我独法;LW,原师傅不粘锅;LT,暗杀者马尔;LR,雨落弦断;LK,夜空中的来客",["安苏"] = "Lp,七吋男儿;Lo,枫椛樰枂;Ln,幸运鼠;Lc,Zewaer;Lb,江河乄大领主,皮痒难耐;La,高坚果丶;LT,Miniminiso;LO,卡哇伊希月;LN,瘦人永不为炉,冰羽卡洛斯,丨熊二丶,逼逼糕;LM,观零",["白银之手"] = "Lo,比尤提佛,千羽清,藻头小狂暴;Lm,米佳乐;Lh,九尾狸御殿,乄三岁半乄,柏林少女丶;Lg,清梦挽歌,清梦挽月;Lf,面包乐,石膏盒子;Le,青山仍在;Ld,胖胖嘚文哥丶;La,小兔乱撞,红烧冰箱;LY,可爱的小阿喵;LW,西柚柠檬茶;LU,丶星爆;LT,北野望;LR,范科长;LQ,兎子;LP,全村的宝宝;LO,忘心殇;LL,你藏好了没;LK,幽幽月光",["安东尼达斯"] = "Lo,群星庭院院长;LL,牧之原翔子",["死亡之翼"] = "Lo,别太复杂;Lg,晨星之辉,星空下的小贼;La,老牛涨停板;LZ,火焰丶誓约;LX,踏剑醉清風;LW,般若丶于;LV,茶余饭後,花儿死翘翘,Varin;LT,小歪脖救地球;LR,鬼景彡森森;LP,貓蛮蛮;LO,我喜欢发育丶,小丶法汐;LN,烽火丨戏诸侯;LK,丷喵喵酱丷,再说我翻脸了,寂之月",["阿拉希"] = "Lo,白衣庵阿美",["永恒之井"] = "Lo,君忘;LT,雷欧阿帕基",["国王之谷"] = "Lo,鐵血戰鷹;LY,大哥憋杀我;LX,Oldskool;LP,刺骨鲤鱼刀",["???"] = "Ln,污衣;Lm,孤俱引山洪;Lg,燃烧平原的风",["风暴之怒"] = "Ln,夏沫浅雨;LT,Woshiz",["丽丽（四川）"] = "Ln,丶半夏瑾年;Le,Etary;Ld,硬核甜橙;Lb,丨甜葵本葵丨;LU,七绝",["勇士岛"] = "Ln,平衡丶初代;Lb,宇佐美莲子",["凤凰之神"] = "Ln,南京陈伟霆,黄昏后的祈望,小襄襄;Lm,星河谣,北风踏歌;Ll,海兔,Patrickstar,阳光落落;Li,眉心微凉;Lg,Acheron;Lf,Deathstrandd,太阳井赵四;Le,方块风暴,清心灬战神;Ld,森森啊,森森呀;Lc,墨魂殇,风褚,小太阳丷;LZ,多佛朗明哥丷;LX,吟风夜尘;LT,狗尾花与猫,虚空小德,今日説法,图腾鲸;LS,亦心灬,乄风神乄,这是只面包君;LR,小呀小酥酥,暗之倪克斯;LQ,撕裂惡梦;LN,雷之奥西里斯,秋天的牛奶;LM,Aegwen,万小尾;LL,Cantean,牛犊爱吃艹",["回音山"] = "Ln,Samcy;Lm,安度嘤;LL,迷之小饭团",["贫瘠之地"] = "Ln,梧桐栖木,露米娜斯阳痕;LQ,图腾帝丶;LP,云霄沙漠剑;LO,恨长风",["格瑞姆巴托"] = "Ln,咕嘿嘿;Lk,香灬熏;Lj,别打了别打了;Lg,风风侠;LZ,怒火疯狂啵;LX,灬军刃;LR,重度孤独患者;LO,旖灬梦;LK,严肃点我有枪",["布兰卡德"] = "Lm,丿凝结的羁绊;Ll,养老院院长",["阿古斯"] = "Lm,婲落知多少",["闪电之刃"] = "Lm,影丸丶,百合女王",["希尔瓦娜斯"] = "Lm,鵺神曦",["迦拉克隆"] = "Lm,猎趣无穷;La,小七八百",["海达希亚"] = "Lk,狼打猎",["罗宁"] = "Lk,左右看風景;Lf,明曰天情;Lc,Deepsix;Lb,马騳驫;LY,冠夢;LR,桃子十九;LQ,顶配欧皇;LP,真不知是誰;LM,艾小静;LK,奥德男爵",["龙骨平原"] = "Lj,马戏团团长;LX,却道天凉",["克尔苏加德"] = "Lj,Biuvbiu;LT,墨舞滄溟;LO,空与晴",["守护之剑"] = "Lj,星痕",["亡语者"] = "Lj,黑猫教主",["迦顿"] = "Li,暮色晨光",["冰霜之刃"] = "Li,兔牙丶;LR,圣光骑士丶冰",["灰谷"] = "Li,放开那",["雷克萨"] = "Lh,圣光小骚蹄;LL,阿古,迷雾丶绿箭侠",["天空之墙"] = "Lh,颜小兮",["无尽之海"] = "Lh,Kentuckky;Lg,瓦絲娸",["破碎岭"] = "Lg,莁妖王;Le,晚风飘摇兮;Lc,Tess;LU,叶落乄无心",["伊森利恩"] = "Lf,打上火花;LV,好几百只鹌鹑;LN,覔萨;LL,Vayne",["霜之哀伤"] = "Lf,熙童;Le,我不是帝凯;Lb,芭芭雅嘎,青椒煎鸡蛋;LY,雅姿娘",["血色十字军"] = "Lf,格寳寳;LV,油腻噶;LO,九江中小华;LN,丶皮蛋;LK,颖子贰拾玖",["阿迦玛甘"] = "Le,Darkblood",["主宰之剑"] = "Ld,养多肉的浣熊;Lb,毒宗丶小醫仙,彩鱗;LY,贼爆肝;LU,肝不救非;LM,Jojorogue",["海克泰尔"] = "Ld,威武极天战圣;LZ,这货不是绿皮;LT,龍一心;LM,奶之圣骑",["盖斯"] = "Ld,加摩尔",["卡拉赞"] = "Lc,大煎饼铺子;LQ,收二手彩电",["熊猫酒仙"] = "Lc,熊大的小花菜;LY,旧梦醉人心;LU,小强尼丶;LN,九七",["夏维安"] = "Lb,英皇丶美屡",["阿曼尼"] = "Lb,兔子爱吃肉,恶魔笑,丶薇薇安",["提尔之手"] = "Lb,黑暗女士",["黑铁"] = "La,打雷了刮风了;LR,旅店;LQ,嘟某人",["熔火之心"] = "La,丶兮祭;LQ,暴躁的花卷儿",["诺兹多姆"] = "La,爱如少年",["影之哀伤"] = "La,Potential;LY,迷灬失,Tutame;LT,饭前一支歌;LN,魂儿丨画儿",["燃烧平原"] = "LZ,小小青柠派;LN,艾喵喵",["爱斯特纳"] = "LY,贼灬无脸",["冰风岗"] = "LY,手鼓猫;LX,浩浩很胖;LK,达伽玛",["风暴之眼"] = "LX,虔诚丶鬼娃",["索瑞森"] = "LW,萌新",["纳克萨玛斯"] = "LU,亚洲神牛",["元素之力"] = "LU,水奶水萨",["法拉希姆"] = "LU,童梦奇缘",["阿克蒙德"] = "LT,上官灵霄",["激流之傲"] = "LT,软云",["麦迪文"] = "LS,三代目;LQ,华晨宇",["血顶"] = "LR,秋风月影",["万色星辰"] = "LQ,库国船长",["伊萨里奥斯"] = "LQ,花呆童",["哈卡"] = "LQ,血小贝戈,丫疼",["海加尔"] = "LQ,能顶能打能奶",["白骨荒野"] = "LP,幻梦霜雪",["加尔"] = "LP,杜晓博分身零",["黑暗之门"] = "LP,Hellscreem",["金色平原"] = "LP,赳赳;LN,艾尔海风",["戈古纳斯"] = "LO,卖老婆买糖吃",["月光林地"] = "LO,翎丶风",["布莱恩"] = "LO,筱筱灵战",["加基森"] = "LN,布兰爱睡觉",["巫妖之王"] = "LN,让开我按错了",["普罗德摩"] = "LM,吴双",["埃德萨拉"] = "LM,Ailuen",["阿格拉玛"] = "LL,你好憨啊",["阿比迪斯"] = "LL,冷月凝霜",["祖阿曼"] = "LK,口黑灬口黑",["利刃之拳"] = "LK,闪光色盲大师"};
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