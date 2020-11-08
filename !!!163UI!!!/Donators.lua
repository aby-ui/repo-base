local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["熊猫酒仙"] = "Ql,目及皆王土,丶儬釹;Qj,瘋人院;Qh,麻瓜麻瓜",["黑铁"] = "Ql,拜拜了您那;Qh,拓老板;Qg,八月丶初秋;Qf,Xiyubaby",["回音山"] = "Ql,这一枪叫晚安;Qj,屠魔侠",["末日行者"] = "Ql,后羿弯弓;Qg,鲍皮,鸡萨",["丽丽（四川）"] = "Ql,丨雨丨;Qj,月银轻芬;Qh,敏若昕,妙若",["冰风岗"] = "Ql,呆萌的贼;Qh,纯粹武夫;Qf,欧皇悲離",["白银之手"] = "Ql,颢耀;Qk,千寒丶,暗夜雖龍,怒海风暴,倾城情雨;Qj,荀彧念作苟或;Qi,圣光敕令,怀念的颜色,甜飞云,欧皇欧霸;Qh,大灯李李,柠檬水饮,画包上的老猫,丨沐雨乘风丨,十八变,Miletus;Qg,Louhh,蹴罢秋千,阿怪哥",["加尔"] = "Ql,伽内砂",["影之哀伤"] = "Ql,铁拳没吃饭吗;Qk,病名爲爱;Qj,希亚;Qh,兰克丶;Qg,夏沫丶浅雨,夏茉灬微凉,挽远;Qf,狸萨,跃动时如火星",["无尽之海"] = "Ql,山一程雪一更;Qk,Aiiceangela,了然灬猎;Qh,丶隻狼灬,妖怪灬了然;Qf,素芬儿",["凤凰之神"] = "Ql,奥雷莉亚公爵;Qk,明丨明;Qj,粉白白;Qi,白羊座灬狐颜,牧牛熊;Qh,拉拉嘴额,轻玥,死亡之亦,暮烟光凝,大奶流,三生梦;Qg,豆虎皮皮,指縫丶,特拉法加鸽王,Dizzymeow,周老师请坐;Qf,君子意如何",["阿克蒙德"] = "Ql,天关破军",["国王之谷"] = "Ql,折戟尘沙;Qk,沒有蛀蚜;Qi,远山晴更多",["死亡之翼"] = "Ql,路西菲尔斯;Qk,温暖的大熊;Qj,迷茫的柚子;Qi,陈墨;Qh,宸诚;Qg,大青兕,三宝公爵,三宝儿降临,犹格索讬斯",["主宰之剑"] = "Ql,她就有点皮;Qj,峰卷残云;Qh,王权乄富贵,太饿猎",["阿纳克洛斯"] = "Ql,逐日者",["伊森利恩"] = "Ql,雪狐的银尾,克己复礼;Qj,白阿白,圣婴大王污昂;Qi,德国骨科;Qh,Kobeneverout;Qg,Rethmo;Qf,猫姐吖",["熔火之心"] = "Ql,艾瑞巴蒂丶",["阿尔萨斯"] = "Ql,Yangie",["???"] = "Ql,奶水挤压者;Qk,忒朗普;Qg,波多野结衣;Qf,灬猎灬人灬;Qe,柒彩;Qd,韩梦武",["血色十字军"] = "Qk,山竹大佬;Qj,胖墩丶;Qf,丶伴伴糖,全聚德烤咕咕,重立体四号,奶粉大宝贝儿,聖光将熄丶,听说过圣光吗,香蕉丶大酋长",["贫瘠之地"] = "Qk,江月庭芜,从晨锋,灬兜兜转灬;Qi,小楼夜听弦;Qh,我愛御姐,刺头丶;Qg,女朋友;Qf,哋灬哋哋,约翰丿列侬",["布兰卡德"] = "Qk,阿圆,不良帥,Atom;Qh,少林菲菲",["外域"] = "Qk,波多野结衣",["灰谷"] = "Qk,一对小得",["暗影之月"] = "Qk,多拉爱梦;Qi,舞麟萌主",["海克泰尔"] = "Qk,艾星鱼人领袖;Qi,紅曜石;Qf,天狂我就是我",["狂热之刃"] = "Qk,Montgomery;Qi,遥射牧女村",["奥拉基尔"] = "Qk,大胸口;Qh,开心的大萝卜",["格瑞姆巴托"] = "Qk,惊丶梦;Qj,小鱼丨小维他,喵丶风暴清酒;Qi,Pudge,追野丸加丶;Qh,武术家马保国;Qg,默默小闹腾;Qf,关伯兰还在笑,关伯兰在笑,戒不掉伈殇",["翡翠梦境"] = "Qj,抽过的烟",["燃烧之刃"] = "Qj,Giftia;Qh,肉离,Sookiechn,烟是回味;Qf,岚夏丶,曾经相识",["埃德萨拉"] = "Qj,许于初见;Qg,红灬桃;Qf,甜酒",["克尔苏加德"] = "Qj,网吧偷单车,阿肥丶;Qi,核心大师",["试炼之环"] = "Qj,魔剑迦游罗",["金色平原"] = "Qj,青山遠黛;Qi,生命奇迹;Qh,把苹果啃哭丶,小禹丶",["巴纳扎尔"] = "Qj,忆墨",["苏拉玛"] = "Qj,迷茫的蓝莓",["瓦里安"] = "Qj,迷茫的山竹",["瓦拉纳"] = "Qj,迷茫的圣光",["雷霆之怒"] = "Qj,楠珏夫人",["莱索恩"] = "Qj,柒夏玲珑",["安苏"] = "Qj,淡年;Qh,璃尛,Vanlatena;Qg,爫奔跑的蜗牛,艹奔跑的蜗牛,丷奔跑的蜗牛,兦奔跑的蜗牛,亾奔跑的蜗牛,乊奔跑的蜗牛,乄奔跑的蜗牛,皿奔跑的蜗牛,覀奔跑的蜗牛,丣奔跑的蜗牛,罓奔跑的蜗牛,罒奔跑的蜗牛,快给我来个橙,都是脆皮,流刘刘鼻涕;Qf,乐观的二五仔",["红云台地"] = "Qj,十七丶猎",["塞拉摩"] = "Qi,猫大夫",["罗宁"] = "Qi,圣光人肉沙包;Qg,Inspired",["白骨荒野"] = "Qi,郁闷的神",["破碎岭"] = "Qi,弑君小贱",["燃烧军团"] = "Qi,夜礼服咩佩",["迦顿"] = "Qi,皓月聆枫;Qg,林深时见鹿",["遗忘海岸"] = "Qi,罄竹难术;Qh,浅潜",["奥特兰克"] = "Qh,满目星河丶",["蓝龙军团"] = "Qh,读条三十秒",["霜之哀伤"] = "Qh,桦溪墨,Xxlxxl",["神圣之歌"] = "Qh,地狱火发型师",["迅捷微风"] = "Qh,血罐,坚果爸比",["洛丹伦"] = "Qh,王来",["血环"] = "Qh,沙之我爱罗",["鲜血熔炉"] = "Qh,Saber",["艾露恩"] = "Qh,Marxism",["千针石林"] = "Qh,陈惠琳",["摩摩尔"] = "Qh,德过且过",["藏宝海湾"] = "Qg,圣光小锤锤",["恶魔之魂"] = "Qg,只刃",["提尔之手"] = "Qg,只是信仰而",["巨龙之吼"] = "Qg,炸油条",["永恒之井"] = "Qf,潍坊纯爷们,沙雕青年",["安纳塞隆"] = "Qf,贺贺",["梦境之树"] = "Qf,一忘路",["风暴之怒"] = "Qf,卑微小号丶"};
local lastDonators = "十七丶猎-红云台地,阿肥丶-克尔苏加德,淡年-安苏,柒夏玲珑-莱索恩,希亚-影之哀伤,胖墩丶-血色十字军,屠魔侠-回音山,荀彧念作苟或-白银之手,楠珏夫人-雷霆之怒,喵丶风暴清酒-格瑞姆巴托,迷茫的柚子-死亡之翼,迷茫的圣光-瓦拉纳,迷茫的山竹-瓦里安,迷茫的蓝莓-苏拉玛,忆墨-巴纳扎尔,粉白白-凤凰之神,青山遠黛-金色平原,圣婴大王污昂-伊森利恩,白阿白-伊森利恩,瘋人院-熊猫酒仙,魔剑迦游罗-试炼之环,网吧偷单车-克尔苏加德,许于初见-埃德萨拉,月银轻芬-丽丽（四川）,Giftia-燃烧之刃,小鱼丨小维他-格瑞姆巴托,抽过的烟-翡翠梦境,峰卷残云-主宰之剑,忒朗普-???,惊丶梦-格瑞姆巴托,Atom-布兰卡德,倾城情雨-白银之手,了然灬猎-无尽之海,不良帥-布兰卡德,大胸口-奥拉基尔,Montgomery-狂热之刃,艾星鱼人领袖-海克泰尔,怒海风暴-白银之手,多拉爱梦-暗影之月,灬兜兜转灬-贫瘠之地,一对小得-灰谷,波多野结衣-外域,从晨锋-贫瘠之地,温暖的大熊-死亡之翼,暗夜雖龍-白银之手,阿圆-布兰卡德,沒有蛀蚜-国王之谷,千寒丶-白银之手,江月庭芜-贫瘠之地,病名爲爱-影之哀伤,Aiiceangela-无尽之海,明丨明-凤凰之神,山竹大佬-血色十字军,克己复礼-伊森利恩,奶水挤压者-???,Yangie-阿尔萨斯,艾瑞巴蒂丶-熔火之心,雪狐的银尾-伊森利恩,逐日者-阿纳克洛斯,她就有点皮-主宰之剑,路西菲尔斯-死亡之翼,折戟尘沙-国王之谷,天关破军-阿克蒙德,奥雷莉亚公爵-凤凰之神,山一程雪一更-无尽之海,丶儬釹-熊猫酒仙,铁拳没吃饭吗-影之哀伤,伽内砂-加尔,颢耀-白银之手,呆萌的贼-冰风岗,丨雨丨-丽丽（四川）,后羿弯弓-末日行者,这一枪叫晚安-回音山,拜拜了您那-黑铁,目及皆王土-熊猫酒仙";
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