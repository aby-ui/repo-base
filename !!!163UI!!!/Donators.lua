local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,释言丶-伊森利恩,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,坚果别闹-燃烧之刃,老熊饼干-金色平原,冰淇淋上帝-血色十字军,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["燃烧之刃"] = "II,Unfair;IH,微光倾城丶;IF,公子良;IE,闻人沐月,Sawyersky;ID,丶梦的遇见;IC,Unfai,Gaay;IB,谢大力;H/,Rollingstar,寒烟牧牧;H9,小轻玥;H8,简约甚好;H7,|你曰个求|",["耐奥祖"] = "IH,牛肉人武僧",["格瑞姆巴托"] = "IH,以德拿人,阿啵茨的,北笙丶枫林晚;IF,Slipknotdd;IE,岀尘;IC,歲月战歌,魔化派大星;H6,逆光在街头",["死亡之翼"] = "IH,格然健康,灬丨天明丶,欧巴丶思密哒;IG,鳳舞灬,聆雨思欣;IF,那个牛頭人;IC,盖饭超人,熏肉大饼;IB,欧巴丶思密达;IA,师爷苏;H/,指间的寂寞;H7,洗洗睡咧,荒野飆客;H6,Lòve",["贫瘠之地"] = "IH,好多鱼呀;IC,逗比法,筱田丶牛,辛德瑞拉之梦;IB,何地彼方;IA,亚克;H/,明曰花绮羅;H8,素年瑾兮;H6,退骚药,Yonger",["埃德萨拉"] = "IH,Hashiqi;IF,慕行雲;ID,夕谨;H7,教师节快乐",["安苏"] = "IH,快到碗里去丿;IG,熊猫不是貓丶;IF,持盾图晨光;IC,叔叔来颗糖;IA,光橙;H6,触摸自由,状态很好",["主宰之剑"] = "IH,Psychos;IF,才不是熊酱,嫒木涕;IA,冷月凝霜刀,洛丽塔法瑞尔;H9,威利,丶欧皇,柳乳嫣;H7,爱在回忆时;H6,芊儿",["阿纳克洛斯"] = "IH,浪子回头",["雷斧堡垒"] = "IG,一成名再望一",["影之哀伤"] = "IG,冷艳的菊花,清秀的菊花;IB,指熊为能,迷糊的喵崽崽;H+,糯米团子哟;H9,小滚锅、,小滚锅冫,勾若禅师",["海克泰尔"] = "IG,丨勿忘丶心安;H/,又又鸟",["奥杜尔"] = "IG,扎心",["菲拉斯"] = "IG,一咸菊菊",["克苏恩"] = "IG,丶猫老大",["白银之手"] = "IG,铁血萨神;IE,杜蕾蕬,拟态豆荚;IC,圣歌丶星耀,一支冰阔乐;IB,楓随箭舞;IA,疯魔天下;H/,我来酱个油;H+,辣妈乄小蛮腰,丨紅尘烟雨丨;H9,你最爱的啾可;H7,萨满小北",["黑铁"] = "IG,鸡糟灬獸狼;IF,瓦雷拉桑古;H+,月夜葬花魂",["壁炉谷"] = "IG,逍遥流星小月;H/,Autofail",["诺莫瑞根"] = "IG,冲灬锋",["凯尔萨斯"] = "IG,青枫;H6,非酋丶",["神圣之歌"] = "IF,喵爪的魅惑",["斯克提斯"] = "IF,小樱桃灬术",["伊利丹"] = "IF,八部青龙武库",["凤凰之神"] = "IF,阿丶咘啦;IE,辻堂葵;ID,咿唎丹丶怒风;IA,污兮控,白色尾巴尖,抽象的城堡;H+,要当岳父了,诗情又画意;H8,仙女大人;H7,富贵舔中求,丨吴彦祖,丨鸡你太美",["国王之谷"] = "IF,水族馆工读生;IE,什锦果冻;ID,若遇浅香丶;H/,流年染指寂寞;H9,涂山梦梦;H7,米娜斯媞莉絲;H6,亚尼托魂歌",["奥特兰克"] = "IF,空自凝眸;H7,大阿尔克那",["瓦里玛萨斯"] = "IF,清夢了無痕",["密林游侠"] = "IE,Peerless",["熔火之心"] = "IE,尘落丶萌咖;ID,名字被我吃了;IB,貂裘换美酒",["罗宁"] = "IE,油墩丶;H/,Tefuir;H+,休闲猎大;H6,释怀回忆",["末日行者"] = "IE,Futureperiod,王者德霸霸;H7,冰冰貓;H6,流星欧尼酱",["黄金之路"] = "IE,凤凰城",["熊猫酒仙"] = "IE,脆弱的宝宝;IC,天照潘达",["卡德加"] = "IE,叹星",["回音山"] = "ID,血色审判官",["布兰卡德"] = "ID,谢飞机;H+,㒃毛球小栗子",["克尔苏加德"] = "ID,小红人丶",["龙骨平原"] = "ID,不落奶瓶",["月神殿"] = "IC,Blizzed",["托尔巴拉德"] = "IC,风之谷丶绿叶",["阿拉希"] = "IC,乄盗",["巴纳扎尔"] = "IC,起风了;H6,忆步",["遗忘海岸"] = "IC,久月;H7,谈笑风生,无奈之手",["盖斯"] = "IC,破坏球",["深渊之巢"] = "IC,阮大长腿",["寒冰皇冠"] = "IC,和光",["无尽之海"] = "IB,傲娇落兒丨;IA,Jooannan;H/,剑来;H7,南开大鸡丝",["烈焰峰"] = "IB,红颜若兮",["迦拉克隆"] = "IB,剁肉;H7,喂不熟的猫丶;H6,圣光在流淌,生煎孢子",["奥尔加隆"] = "IB,刄莫予毒",["伊森利恩"] = "IB,秋风丶叶落;H/,海棠大官人;H9,荆城老头丶,小小庄师傅,莫等闲丶;H8,川崎沙希",["血色十字军"] = "IB,小九超友好;IA,弦千钧,晴聖,風火雷電;H6,我喂小萝袋盐",["冰风岗"] = "IB,大奈紫;H7,红色的冬瓜",["阿尔萨斯"] = "IA,凌乱随风;H+,风云不羁",["时光之穴"] = "IA,Jkseven",["苏塔恩"] = "H/,绝地科学家",["霜之哀伤"] = "H+,Tommykk;H7,白开",["试炼之环"] = "H+,采野花的老牛",["永恒之井"] = "H+,嘿丶大爷;H9,武为止戈",["玛诺洛斯"] = "H+,有点浪",["瑞文戴尔"] = "H+,仟送伊",["卡德罗斯"] = "H9,筱鬼",["塞拉摩"] = "H8,殇影丿灬毒神",["普罗德摩"] = "H8,恩佐斯",["加尔"] = "H8,妖狩",["狂热之刃"] = "H8,花落沉吟",["达文格尔"] = "H7,清清",["桑德兰"] = "H7,失去的时间",["艾露恩"] = "H6,路野",["血环"] = "H6,丶阳光下呐喊",["风行者"] = "H6,坏坏的傻傻",["扎拉赞恩"] = "H6,专属尐肆亖",["战歌"] = "H6,醉後知久濃"};
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