local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,大江江米库-雷霆之王,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔,圣子道-回音山,不嗔-迦拉克隆,荼麟、濤-贫瘠之地,Bloodtd-死亡之翼,Darkage-洛丹伦,轩辕银月-雷克萨,我的夜茉莉-法拉希姆,萌萌的尐熊猫-死亡之翼";
local recentDonators = {["霜之哀伤"] = "D5,昭澜忆未央;D4,术术呀丶;D3,Mocktails",["死亡之翼"] = "D5,油条;D3,悬崖边的花菜,Xno,鳝变男老牧,麻吖",["布兰卡德"] = "D4,暴烈,夜梦离;D3,靑蝉子,有一点丰满",["格瑞姆巴托"] = "D4,月亮爱上猫,暹罗之殇;D3,帕丶纳梅拉,Microtech",["白银之手"] = "D4,Xxtentacion,Victormarcus,水月坏坏哒,初雪春风起,丶诗烟,於国,Misting,黑锋、骑士团,师墓师;D3,暗影守望灬,戰龍在野,少年张有亮,箖荫",["国王之谷"] = "D4,缱绻的馥郁,那一抹晚霞,木木的术;D3,我不眨眼,古早味花生汤",["无尽之海"] = "D4,剑来不;D3,小三班,鲜血的死奴",["阿古斯"] = "D4,晨曦夜雨;D3,铭云小艾",["斯坦索姆"] = "D4,傲娇最讨厌了,罗宁",["血吼"] = "D4,浪子伤了心,别艹我平底锅",["风暴之怒"] = "D4,森林与树,Madtyrant",["安苏"] = "D4,龍炎灬,盗将行丶,丿灰白色,瑟兰迪斯乀;D3,大安,多出林肯,辛未,云然",["金度"] = "D4,牧濑丶红莉栖",["翡翠梦境"] = "D4,韶華白首丶;D3,古尘沙",["提瑞斯法"] = "D4,阳光柯基",["主宰之剑"] = "D4,溙澜德灬语风,丨戴斯菲尔丨,徘徊在边缘;D3,風雨時若,帕奇維克,幻魔枫尘",["海克泰尔"] = "D4,狠特",["达文格尔"] = "D4,芊陌;D3,临夏",["燃烧之刃"] = "D4,蛛丝码迹,尛锅盖,璎洛,梁辰姐姐;D3,悶倒驴,烟火",["血环"] = "D4,闲看花落,刺痛的敏希",["???"] = "D4,破碎的安静;D2,夏新晴,斗鱼万宝路,嘿点看我宝宝;D1,好几百只熊猫;D0,瑾少走路带风;Dz,Yagamiyoru;Dy,车车仔,腾格尔丶冽风,厦门煸豆干;Dx,玛力怒,老山虎;Dw,缇丝托莉亚",["夏维安"] = "D4,逝水无痕",["伊森利恩"] = "D4,寂寞战神;D3,橙水糖",["索瑞森"] = "D4,下半身的叛逆;D3,一本道一休",["雷克萨"] = "D4,辩机;D3,此号纪念小白",["红龙军团"] = "D4,愿圣光奶死你",["罗宁"] = "D4,心碎的方式,蓝倾,梧桐君;D3,Pegasusian,凝芸",["索拉丁"] = "D4,希羅;D3,枫隐士,凯兰催尔",["回音山"] = "D4,瑞德汉德",["阿比迪斯"] = "D4,花椒",["克尔苏加德"] = "D4,虚然染;D3,灵魂未出窍",["白骨荒野"] = "D4,托楚去坎叽叽",["加兹鲁维"] = "D4,丶弹指芳华",["米奈希尔"] = "D4,丨心有萌虎丶",["月光林地"] = "D4,慕明",["冰霜之刃"] = "D4,膨胀的阿昆达,镜花卐水月",["暗影议会"] = "D4,扛不注就射",["天空之墙"] = "D4,奥钉",["诺兹多姆"] = "D4,求其阿才;D3,Coldkiller",["影之哀伤"] = "D4,隔壁旳泰山,恐山安娜,Panwoo;D3,丿、圣诞,坑队友",["烈焰峰"] = "D4,臭小诙",["基尔加丹"] = "D4,暮雪芊岚",["埃苏雷格"] = "D4,偷东西的猫",["迦拉克隆"] = "D4,Exquis;D3,不嗔,请勿殴打追逐,孤烟纵歌,Hypnotia",["卡扎克"] = "D4,牛脑壳",["阿尔萨斯"] = "D4,魂之皈依;D3,谁偷了我的角",["布莱恩"] = "D4,蝶舞丷樱花落",["阿纳克洛斯"] = "D4,可选择的未来",["图拉扬"] = "D4,白皇后;D3,Evilhall",["勇士岛"] = "D4,无情修罗",["熊猫酒仙"] = "D4,大城管克星,凯普;D3,野蛮浮夸丶",["金色平原"] = "D4,爆破手巴斯特,虾酱;D3,马里奥若智",["奥尔加隆"] = "D4,Junna",["奥达曼"] = "D4,圣光汐音",["卡德加"] = "D4,米小茶",["德拉诺"] = "D3,橙珑",["末日行者"] = "D3,三花哩哩,杀戮乄晕奶丶",["玛洛加尔"] = "D3,伊利优乳酸",["阿拉索"] = "D3,傅立叶变换,曾希萌",["暗影之月"] = "D3,酱油小骑士,帅爆地我",["凤凰之神"] = "D3,鹳雀楼,冰鎮牛奶,罗格斯",["远古海滩"] = "D3,去甲肾上腺素",["塞拉摩"] = "D3,音符跳跃",["密林游侠"] = "D3,一起蛤啤,万河",["破碎岭"] = "D3,Callmeback,杨三十二郎",["太阳之井"] = "D3,丨冬叔丨",["血色十字军"] = "D3,白给,来个橙子不,希格拉之耀",["贫瘠之地"] = "D3,側耳倾听,靈渡,曼图海姆",["丽丽（四川）"] = "D3,小悠闲,葬爱丶毛少",["达隆米尔"] = "D3,佛祖在一号线,光丶年",["艾莫莉丝"] = "D3,皮甲都归我",["洛丹伦"] = "D3,水电安装",["晴日峰（江苏）"] = "D3,让你流口水",["地狱之石"] = "D3,胭脂相留醉",["巫妖之王"] = "D3,傲天海带",["遗忘海岸"] = "D3,云间独步",["迅捷微风"] = "D3,阿萌达",["军团要塞"] = "D3,梦成殇",["卡拉赞"] = "D3,奶不动,Blackcode",["桑德兰"] = "D3,灬尐鲜肉",["奥特兰克"] = "D3,殺伐",["玛诺洛斯"] = "D3,大風起",["艾维娜"] = "D3,狂热的阿贵",["冰风岗"] = "D3,Atina",["风行者"] = "D3,亞拉崗",["蜘蛛王国"] = "D3,纽约城的太阳",["燃烧平原"] = "D3,這是我的溫柔"};
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
                    table.insert(players, fullname)
                    player_days[fullname] = date
                    player_shown[fullname] = topNamesOrder[fullname] or 0
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