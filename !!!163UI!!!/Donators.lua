local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,粉红雪山-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["白银之手"] = "KY,大地与山阿,观棋不语;KW,阳大人,漫长的玩笑;KV,此心光明;KU,清风慕斯;KT,Wassim;KQ,马云之子,亿易;KP,月影临风,血色百夫长",["安苏"] = "KY,丨玉米丨;KW,天空不空不空;KV,小鱼小小鱼;KU,我想好好玩,安晨,你的蓝色夜雨;KT,海迦尔的风,此間的少年丶;KS,爷们儿萬歲;KR,眠慕白;KP,陆伯言丶;KN,仙女有只猫;KM,杨秀儿",["国王之谷"] = "KY,哈基石打怪兽;KN,无人咏生;KM,七世笙歌丶",["贫瘠之地"] = "KY,流氓伊锅锅;KW,萌萌哒小喵喵,赛萌铁克;KV,心驰,最爱猫;KR,苏珊娜丶,可可;KM,后宫全是牛",["死亡之翼"] = "KY,微笑乄迪妮莎;KX,礼查德泰森,我不敢过江;KW,叶知秋阿丶,明月涤吾心;KV,她的;KT,一夜赫然倾城;KR,碳化硅,妖王之王,鸡蛋盖浇饭;KQ,桂花糕,亲亲胖胖熊,觅丶墨,鱼鱼有饼;KO,Amen,你看不到;KN,花醉羽觞;KM,有苏",["金色平原"] = "KY,中國好朮士;KX,唯美传说;KO,粉红雪山;KM,浮月若苼",["凤凰之神"] = "KY,舞刄;KW,無相丶,無牧丶,刀宅丶,黑钥匙大魔王,心尖;KV,抓只子怡宝宝,带槽肆伍伍;KU,姐姐幻肢好烫;KT,Muxii,是谁的心阿;KR,此名字不能用,大雨灬;KQ,生有余辜,鼎酱胖胖哒,Yerger;KP,Constans;KO,暗妮,晨曦丶晓白;KN,布罗利丶邪眼",["主宰之剑"] = "KY,可嘉;KX,贝贝骑士;KU,牧格;KS,左岸铭记;KP,吾之阳;KM,林家暗影射手",["永恒之井"] = "KX,自是白衣卿相",["埃德萨拉"] = "KX,Killerslaye,請叫我小邪惡",["燃烧之刃"] = "KX,小红颜;KV,贼神丨炎焱,战神丨炎焱,火燚丶炎焱;KN,对不起都怪我,泰抽抽,月色丶秋风;KM,稀饭凉面",["黑铁"] = "KX,随他去吧;KQ,暗黑胡萝吥;KO,百兽凯多丶;KN,伤心猪大肠",["无尽之海"] = "KX,Lictrey;KS,我很谦虚;KR,丹峰揽月;KM,丶小果然",["迦拉克隆"] = "KW,墨竹凉夜影;KT,萌丶捷列夫",["血色十字军"] = "KW,無牧丶;KV,朱少;KS,祝您平安;KQ,只萌不新;KO,Crankines,临光;KM,统御法典丶,棉被封印丶",["巨龙之吼"] = "KW,完美落幕丶",["冰风岗"] = "KW,比丘神尼;KM,虾条",["雷霆之怒"] = "KW,波西米亚辉",["回音山"] = "KW,灵顿顿;KN,小鲜奶",["伊森利恩"] = "KW,丿丶疯舞;KR,部落壁垒;KN,沖田総司;KM,罗森灬内里",["利刃之拳"] = "KV,神乂救赎",["影之哀伤"] = "KV,嘿|喂狗;KR,黑夜的寂静;KM,垂死的玖玖",["罗宁"] = "KV,彩云朵朵",["日落沼泽"] = "KV,贫道法号梦遗",["戈提克"] = "KV,Beelzubub",["诺莫瑞根"] = "KV,东方仗助",["末日行者"] = "KU,程丶风暴洣酒,程丶风暴米酒;KP,狂野乔峰,十万城管;KO,雪中捍刀行丶;KN,丶花尽千霜默;KM,狂野黄蓉",["冰霜之刃"] = "KU,寒雪眠风",["暗影议会"] = "KU,莫惜肆",["萨格拉斯"] = "KT,霓凰郡主",["月光林地"] = "KT,浏阳河赛艇;KR,汐玥",["托塞德林"] = "KS,丶洋葱",["萨菲隆"] = "KS,徒手掰脊椎",["格瑞姆巴托"] = "KR,半点白;KP,魅魇;KO,迷之圆滚滚;KN,起司汉堡包",["晴日峰（江苏）"] = "KR,奶炮",["卡德加"] = "KR,幻影神",["风行者"] = "KR,前川",["烈焰峰"] = "KR,Yeliz",["试炼之环"] = "KR,游学者流年",["影牙要塞"] = "KR,我记性好差",["黑龙军团"] = "KQ,夜長夢還多",["安东尼达斯"] = "KQ,开拓者丶咸鱼",["玛里苟斯"] = "KQ,堕落之誓",["洛丹伦"] = "KQ,部落骑士",["加基森"] = "KQ,柒蓝",["白骨荒野"] = "KP,永島圣羅",["幽暗沼泽"] = "KP,Kizimao",["图拉扬"] = "KP,半盏春",["达拉然[US]"] = "KP,Cathrot",["暗影之月"] = "KP,万神殿丶可心",["诺森德"] = "KO,大卫妮尔",["布兰卡德"] = "KO,芒种;KM,咕嘟嘟冒泡泡",["奥妮克希亚"] = "KN,巧面馆",["太阳之井"] = "KN,鸡伱太美诶丶",["伊利丹"] = "KN,Bloodypyre,Bloodyfive",["迅捷微风"] = "KN,夏比比",["扎拉赞恩"] = "KN,逍遥丹哥",["埃苏雷格"] = "KN,囧囡囚囧",["天空之墙"] = "KN,病态的怜悯",["火焰之树"] = "KM,天舞星辰",["伊萨里奥斯"] = "KM,Tsaixx",["海克泰尔"] = "KM,可尔必思丶"};
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