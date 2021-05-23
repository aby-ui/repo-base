local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["狂热之刃"] = "Tu,百威宝贝,小二班班;Tm,汗臭少年",["血色十字军"] = "Tu,溜名犬;Tk,潋滟丨杯中酒;Tg,黄鸭叫;Tf,因芸;TZ,不信鬼神",["凤凰之神"] = "Tu,Theconor;To,阳光宅男;Tk,执法长老;Ti,Montgoholy;Te,丶虚竹丶;Td,梦霜宇,小妞向前冲;Tc,终极版本答案;Tb,艾梅特赛尔克",["白银之手"] = "Tu,远古洗只狼,暗键伤人,按剑伤人,戰圣;Tt,飞翔的复仇;Tp,打更;Tn,砸瓦魯多;Tl,射擊獵人,两亿男人的梦;Th,月下鹡鸰,利奥波德;Tg,爱丽菲儿,灰色兔兔,硅胶宝宝;Tc,有德必尸,砸瓦鲁多;Tb,蛋壳总是脆,缺德萌咕;Ta,为妳念咒;TZ,安牧茜",["罗宁"] = "Tu,正义的伙伴;Tm,皮皮丹;Tk,轻寒寒;Tc,夏多雷希尔兔,佰寶",["霜之哀伤"] = "Tt,快乐之海;Te,瑞灬弑",["死亡之翼"] = "Tt,越越辉辉;Ts,呆比丶,瞎来呛,奔五德;Tq,阿雯丶爱吃肉;Tm,青山之云,偷偷瞄,忘我大德;Tj,迷醉丨;Ti,Ameno;Th,雪拉贝祺朵;Te,丶蟹棒好吃;Td,离人丶泪;Tb,卩灬聖丨光",["安苏"] = "Tt,Playerjmbbwr,天生喜剧;Ts,一拳捶毁你;Tj,兄弟你兽了;Ti,亞單",["末日行者"] = "Tt,爷傲奈我何丨,爷傲丨奈我何;Tb,野蛮丨大疯子",["???"] = "Tt,公子琴;Tp,许琎",["格瑞姆巴托"] = "Tt,芒果绿茶;Td,可乐灬乄;Tb,一云丶",["阿纳克洛斯"] = "Ts,華夏丶戰之魂",["亡语者"] = "Tr,魔兽世界;Te,云淡心晴",["娅尔罗"] = "Tr,铁头娃二",["回音山"] = "Tr,白首;Tg,半山桥野兔;Te,翼雪",["无尽之海"] = "Tr,八块腹肌喵;Tp,马里奥煎饼;Ta,罒壹罒",["贫瘠之地"] = "Tq,Jeffery;Tn,丨紅尘烟雨丨;Tj,炎刃;Ti,九曜丶;Tg,射贱;Tc,布利瑞斯;Tb,婲落知多少丶",["阿拉希"] = "Tq,蕾丝天鹅蛋",["洛丹伦"] = "Tq,今晚月色真美",["影之哀伤"] = "Tp,狐噜;To,诗涵,夏夜暖风;Tm,逆戟鯨;Tg,捌月壹拾伍;Te,苍烟断",["金色平原"] = "Tp,塞理德恩",["冰风岗"] = "Tp,大地震击暴击;Te,帅帅滴板砖酱;Td,天韵五五",["埃雷达尔"] = "Tp,南鸢大人",["国王之谷"] = "To,武园枯藤朵兰,乡下土著人",["卡拉赞"] = "To,八六年凉白开",["雏龙之翼"] = "To,不会就要练;Tl,血色幽蓝",["迦拉克隆"] = "Tn,油条;Tb,希望的灯火",["翡翠梦境"] = "Tm,我无限嚣張",["克尔苏加德"] = "Tm,依旧的依旧,魔法燃烧;TZ,清妤,八度余温",["伊森利恩"] = "Tm,上学威龙,仍唱我的歌;Tj,Floorjansen;Ti,何以解忧丿,丶言松语,叶公子;Th,伊西;Te,小紅仁",["藏宝海湾"] = "Tl,???",["图拉扬"] = "Tl,小小雪花",["壁炉谷"] = "Tl,近松十人众",["熊猫酒仙"] = "Tl,骑白虎的饺子",["主宰之剑"] = "Tk,维内托里奥;Te,無上菩提",["风暴之怒"] = "Tj,塑以花之形;Te,天然元素",["燃烧之刃"] = "Tj,烟焱;Ti,老白嗷;Tg,夜光小布丁",["神圣之歌"] = "Ti,白云兮丶",["鬼雾峰"] = "Ti,荙芬奇",["深渊之巢"] = "Th,丿田鼠",["能源舰"] = "Th,巫月",["月神殿"] = "Tg,刪除於終點",["瓦丝琪"] = "Tf,小瓶盖儿",["罗曼斯"] = "Td,因为蛋疼所以",["世界之树"] = "Td,Stillalive",["凯恩血蹄"] = "Tc,闪伯利恒之星",["瓦里安"] = "Tc,陈年老号",["迅捷微风"] = "Tc,扶桑啊大红花",["银松森林"] = "Tc,樱桃",["朵丹尼尔"] = "Tc,Miuinitio",["海克泰尔"] = "Tb,叮噹咕嚕",["白骨荒野"] = "Ta,羽月希丶,幻之地狱"};
local lastDonators = "咕咕哒咕哒-死亡之翼,悠樂翩跹-迦拉克隆,卡乄尔-格瑞姆巴托,爱德华大主教-罗宁,翊丨翧-主宰之剑,丶木木-死亡之翼,耳尖尖变猫趴-冰霜之刃,哔咔-贫瘠之地,枫叶骑-回音山,沧丶月-贫瘠之地,清少纳言-红龙军团,开门一次伍毛-霜之哀伤,欧皇小倪华-血色十字军,音於洁弦-熊猫酒仙,雅儿背德-主宰之剑,丶凯恩血蹄-伊利丹,名艾-白银之手,丨盼盼丨-暗影议会,云尽月冥-熊猫酒仙,看我打不打你-艾露恩,观察者-奥尔加隆,雪碧加枸杞-凤凰之神,冰冷的寒号鸟-凤凰之神,輘亂-伊森利恩,Laqia-迅捷微风,瞎蹦卡拉卡-回音山,古尔灬彦祖-伊森利恩,丶佬男人-白银之手,丶老男人-白银之手,谢慕云-影之哀伤,Zorro-克尔苏加德,青瓦台王主任-死亡之翼,米哈伊洛夫娜-白银之手,大筱婕-埃德萨拉,米歇尔哪吒-布兰卡德,小脸儿肤白-无尽之海,Romeo-凤凰之神,愛璨璨-死亡之翼,踏雪吉安那-巫妖之王,檀夕-白银之手,果冻熊丷-白银之手,浪子三回头-暗影之月,王牌劣人-巨龙之吼,熊喵大人丶-伊森利恩,圣夜祈-风暴峭壁,别骚叽叽-死亡之翼,提线木偶-无尽之海,风暴降世者-布兰卡德,打劫-桑德兰,丶秋黛里-死亡之翼,和尚爱飘柔-燃烧平原,卡塔库栗丶-影之哀伤,小希瓜-影之哀伤,啪啪想不出来-熊猫酒仙,短圆吞噬魔-达尔坎,那夜灬-埃德萨拉,暗影小小哥-主宰之剑,大师级假死-安苏,兔小昕丶-凤凰之神,亚尔夫海姆-影牙要塞,丷惜月丷-死亡之翼,云朵朵丶-影之哀伤,云轻轻丶-影之哀伤,云染染丶-影之哀伤,我手最红的-白银之手,狗子哥丶-无尽之海,灭团之源-主宰之剑,基莫笑-阿拉希,恶魔小贩-迪瑟洛克,无情的打桩机-主宰之剑,丶按时吃饭-凤凰之神,奔波儿霸丨-血色十字军,给你一瓶可乐-符文图腾,我叫大炮丶-无尽之海,大佬黑丶-萨尔,灬路易基-国王之谷,天火燎赑毛丶-安苏,丝丝有点甜-迦拉克隆,阿寶酱-安苏,闻西丶-影之哀伤,独照峨眉峰丶-凤凰之神,丷菲咪丝丷-白银之手,Saalasa-主宰之剑,重口小萝莉-蜘蛛王国,冷眼是非善恶-凤凰之神,血河-斩魔者,冷眼是非善恶-永恒之井,影双-阿古斯,萌货汪星人-诺森德,Liangsu-凤凰之神,兽仔-贫瘠之地,阿浩丶不吃素-死亡之翼,安牧茜-白银之手,不信鬼神-血色十字军,八度余温-克尔苏加德,清妤-克尔苏加德,为妳念咒-白银之手,幻之地狱-白骨荒野,羽月希丶-白骨荒野,罒壹罒-无尽之海,一云丶-格瑞姆巴托,艾梅特赛尔克-凤凰之神,缺德萌咕-白银之手,野蛮丨大疯子-末日行者,蛋壳总是脆-白银之手,希望的灯火-迦拉克隆,婲落知多少丶-贫瘠之地,卩灬聖丨光-死亡之翼,叮噹咕嚕-海克泰尔,Miuinitio-朵丹尼尔,樱桃-银松森林,砸瓦鲁多-白银之手,佰寶-罗宁,扶桑啊大红花-迅捷微风,陈年老号-瓦里安,夏多雷希尔兔-罗宁,闪伯利恒之星-凯恩血蹄,有德必尸-白银之手,布利瑞斯-贫瘠之地,终极版本答案-凤凰之神,Stillalive-世界之树,可乐灬乄-格瑞姆巴托,小妞向前冲-凤凰之神,梦霜宇-凤凰之神,天韵五五-冰风岗,因为蛋疼所以-罗曼斯,离人丶泪-死亡之翼,小紅仁-伊森利恩,丶虚竹丶-凤凰之神,云淡心晴-亡语者,铁了心爱你-伊森利恩,無上菩提-主宰之剑,帅帅滴板砖酱-冰风岗,丶蟹棒好吃-死亡之翼,天然元素-风暴之怒,苍烟断-影之哀伤,翼雪-回音山,瑞灬弑-霜之哀伤,小瓶盖儿-瓦丝琪,因芸-血色十字军";
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