local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["国王之谷"] = "RB,萬岁千秋,白驹氵过隙;RA,树鸟熊猫魚,索拉丶织棘者;Q/,一輪美滿,残盾;Q+,江隂馒頭,极热,尝试切他中路",["主宰之剑"] = "RB,年轻不讲舞德;RA,一岁可萌了;Q/,导演法;Q+,夜尽丶辰曦,快进到退休",["血色十字军"] = "RB,表妹丶;RA,达拉崩吧丶,珊瑚丶海,蜡笔海盗,昨日青空;Q/,祟图,社会的榜样,爆炸糖果,席梦来;Q+,机车小迷弟",["红云台地"] = "RB,荼荼",["熊猫酒仙"] = "RB,射的你发慌;RA,丿锖兎丶;Q/,JohnPan;Q+,十公里,敗犬",["冰霜之刃"] = "RB,丶铁柱",["燃烧之刃"] = "RB,酒仙女,丨嫣於倾黛;RA,Goodknight,卖皮孩;Q/,疯狂的麦田丶,疯狂的麦子丶,老乄乄白,老乄白,术小鱼",["影之哀伤"] = "RB,丶萧默默;RA,勒子;Q/,流梳灬烟沐,懒懒空天猎;Q+,穿靴子的牛",["贫瘠之地"] = "RB,凰弥;RA,官人不卖艺;Q/,末白丶,小牛丹尼,大地香瓜,欧狍;Q+,Shaka,小末日,花丶雨",["洛丹伦"] = "RB,赛柯蕾丶血歌",["格瑞姆巴托"] = "RB,小鸡球球;Q/,少女映画;Q+,哈啤穿肠过,梦扬天际",["白银之手"] = "RB,阿尔萨喵,童話鎮;RA,雲杨,温岭胡歌,飞驰柚子,南野;Q/,陳喬恩,乱舞乄风行者,Demondark,维灬他,酒樱;Q+,雷德琪,回梦夜影,天空蔚蓝灬,这是女鬼,老王遛狗,清音梵唱,Penumbra,奶一次绿一次",["灰谷"] = "RB,蹬蹬爹",["凤凰之神"] = "RB,灬纤尘灬;RA,Sakurall,最深情的森西,森森鸭,因幡帝丶,莫歌;Q+,壕运气,绮德丶",["死亡之翼"] = "RB,紫韵铭馨,莺鸢,傻比晓得;RA,Asknb,魔桀神;Q/,小栞的狐狸,老牛吃嫩草丶;Q+,丷小眼迷人丷,盗口大重九,西柚茉莉茶丶,德抽大重九,手拿大重九",["扎拉赞恩"] = "RB,妖之骄法",["艾露恩"] = "RB,巨侠老德;RA,陆老六",["风行者"] = "RB,隔壁水果店丶",["安苏"] = "RB,芋头炖牛腩丶;RA,十字军的清算,魔法宅急送丶;Q/,麦普替林;Q+,只愿诗和远方,冰星心,北暝",["雷斧堡垒"] = "RB,雷霆扛把子;Q+,七色的魔法使",["金色平原"] = "RA,庆余,好灬好美哟",["斩魔者"] = "RA,百山惊鸿",["玛法里奥"] = "RA,菲奈珂思",["伊森利恩"] = "RA,甜酒冲蛋,勾手老大爷;Q/,暗影之境丶雷;Q+,Redone,花花厷孒,北执",["玛瑟里顿"] = "RA,Vitamine",["阿克蒙德"] = "RA,Migo",["海克泰尔"] = "RA,旧城半夏,夜丶微凉,灵魂祭司雷尼;Q+,风中一头牛,猜心,心云",["丽丽（四川）"] = "RA,南部丑锅锅,别闹灬;Q+,飞花轻梦丶",["阿纳克洛斯"] = "RA,还有土拨鼠",["克洛玛古斯"] = "RA,闪光伯爵",["无尽之海"] = "RA,青衣凉惹白霜;Q/,麒麟仔,食人魔魔法師,翊悬;Q+,慧者实乂橙,灬奶茶炖鸡灬,小原",["伊利丹"] = "RA,飞行的老猫",["罗宁"] = "RA,大圆蟀,青咿染霜华;Q/,小鷄湯;Q+,Sacrificed",["利刃之拳"] = "RA,马师父;Q/,丶绫波丽",["埃德萨拉"] = "RA,丨丶青衫;Q/,骁哥最帅;Q+,灬阿猫灬,丨丶青衫未旧",["奥斯里安"] = "RA,双刀就看走",["巫妖之王"] = "Q/,海之间",["拉文凯斯"] = "Q/,甄美",["万色星辰"] = "Q/,威廉萌",["末日行者"] = "Q/,舔娃;Q+,小楼一夜趴啪,腹黑骑师",["迅捷微风"] = "Q/,章鱼法",["亚雷戈斯"] = "Q/,一生有你",["索瑞森"] = "Q/,雲中锦書來;Q+,雲影映暈",["玛里苟斯"] = "Q/,艾尔玛娜",["???"] = "Q/,来呀丨张哥,冰强砸铁锤,Montyshoot,原来是青衫呀,大俊;Q9,夜行猫;Q7,暴烈灬猪皇;Q6,霓裳梅普露,丨太宰丨,打错停手;Q4,Einino;Q3,Ferfectlife,娜么可爱;Q2,凯宇大人",["龙骨平原"] = "Q/,战世,丶黑夜传说",["冰风岗"] = "Q/,专业杀鸡拔毛",["达尔坎"] = "Q/,快乐并忧伤",["阿古斯"] = "Q/,Deathbarbie",["破碎岭"] = "Q/,堕落的路西法",["梅尔加尼"] = "Q/,悠悠德",["格雷迈恩"] = "Q/,落零星",["远古海滩"] = "Q+,牛啸天",["霜之哀伤"] = "Q+,眸中星河似梦,灿烂尐尐,今生为你舔,恰似童话",["雏龙之翼"] = "Q+,Kej",["燃烧平原"] = "Q+,Danaikz",["加基森"] = "Q+,闹闹爸",["布兰卡德"] = "Q+,欧丿二泉映月",["苏塔恩"] = "Q+,月影灬晨星",["试炼之环"] = "Q+,牛将军丶老刘",["阿拉索"] = "Q+,不语笑红尘",["法拉希姆"] = "Q+,Thatcher,Zarya",["克尔苏加德"] = "Q+,枪手哥哥",["风暴之怒"] = "Q+,似锦年华",["寒冰皇冠"] = "Q+,法力残渣丶"};
local lastDonators = "食人魔魔法師-无尽之海,麒麟仔-无尽之海,酒樱-白银之手,老乄白-燃烧之刃,老乄乄白-燃烧之刃,疯狂的麦子丶-燃烧之刃,疯狂的麦田丶-燃烧之刃,残盾-国王之谷,悠悠德-梅尔加尼,丶黑夜传说-龙骨平原,席梦来-血色十字军,暗影之境丶雷-伊森利恩,大俊-???,欧狍-贫瘠之地,堕落的路西法-破碎岭,骁哥最帅-埃德萨拉,原来是青衫呀-???,Deathbarbie-阿古斯,快乐并忧伤-达尔坎,专业杀鸡拔毛-冰风岗,Montyshoot-???,冰强砸铁锤-???,JohnPan-熊猫酒仙,大地香瓜-贫瘠之地,战世-龙骨平原,爆炸糖果-血色十字军,少女映画-格瑞姆巴托,来呀丨张哥-???,老牛吃嫩草丶-死亡之翼,懒懒空天猎-影之哀伤,麦普替林-安苏,艾尔玛娜-玛里苟斯,维灬他-白银之手,Demondark-白银之手,流梳灬烟沐-影之哀伤,乱舞乄风行者-白银之手,导演法-主宰之剑,社会的榜样-血色十字军,丶绫波丽-利刃之拳,雲中锦書來-索瑞森,小栞的狐狸-死亡之翼,一輪美滿-国王之谷,一生有你-亚雷戈斯,章鱼法-迅捷微风,舔娃-末日行者,威廉萌-万色星辰,小牛丹尼-贫瘠之地,小鷄湯-罗宁,末白丶-贫瘠之地,陳喬恩-白银之手,甄美-拉文凯斯,海之间-巫妖之王,祟图-血色十字军,别闹灬-丽丽（四川）,双刀就看走-奥斯里安,南野-白银之手,勒子-影之哀伤,丨丶青衫-埃德萨拉,马师父-利刃之拳,青咿染霜华-罗宁,大圆蟀-罗宁,魔法宅急送丶-安苏,勾手老大爷-伊森利恩,灵魂祭司雷尼-海克泰尔,丿锖兎丶-熊猫酒仙,夜丶微凉-海克泰尔,昨日青空-血色十字军,飞行的老猫-伊利丹,青衣凉惹白霜-无尽之海,闪光伯爵-克洛玛古斯,好灬好美哟-金色平原,魔桀神-死亡之翼,索拉丶织棘者-国王之谷,Asknb-死亡之翼,官人不卖艺-贫瘠之地,蜡笔海盗-血色十字军,还有土拨鼠-阿纳克洛斯,珊瑚丶海-血色十字军,达拉崩吧丶-血色十字军,飞驰柚子-白银之手,南部丑锅锅-丽丽（四川）,莫歌-凤凰之神,卖皮孩-燃烧之刃,旧城半夏-海克泰尔,温岭胡歌-白银之手,因幡帝丶-凤凰之神,Goodknight-燃烧之刃,树鸟熊猫魚-国王之谷,Migo-阿克蒙德,Vitamine-玛瑟里顿,森森鸭-凤凰之神,甜酒冲蛋-伊森利恩,一岁可萌了-主宰之剑,最深情的森西-凤凰之神,菲奈珂思-玛法里奥,百山惊鸿-斩魔者,陆老六-艾露恩,Sakurall-凤凰之神,庆余-金色平原,雲杨-白银之手,十字军的清算-安苏,雷霆扛把子-雷斧堡垒,傻比晓得-死亡之翼,芋头炖牛腩丶-安苏,隔壁水果店丶-风行者,巨侠老德-艾露恩,莺鸢-死亡之翼,妖之骄法-扎拉赞恩,紫韵铭馨-死亡之翼,灬纤尘灬-凤凰之神,丨嫣於倾黛-燃烧之刃,童話鎮-白银之手,蹬蹬爹-灰谷,阿尔萨喵-白银之手,小鸡球球-格瑞姆巴托,赛柯蕾丶血歌-洛丹伦,凰弥-贫瘠之地,白驹氵过隙-国王之谷,丶萧默默-影之哀伤,酒仙女-燃烧之刃,丶铁柱-冰霜之刃,射的你发慌-熊猫酒仙,荼荼-红云台地,表妹丶-血色十字军,年轻不讲舞德-主宰之剑,萬岁千秋-国王之谷";
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