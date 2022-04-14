local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["丽丽（四川）"] = "Y6,圣殿之光,主要看气质;Y5,星星侠;Y1,狐了狐了;Yx,小红手狂猎",["冰风岗"] = "Y6,羽衣直夏;Y1,薄荷茶茶;Y0,爱吃橙子",["雷斧堡垒"] = "Y6,说丶一,说一",["白银之手"] = "Y6,说丶一,说一,爱吃糖的唐三,买香蕉去打怪,锦果果,伊姆大人;Y5,萌术萌萌哒;Y2,迷幻人生,賑早見琥珀川,芒果丶布丁;Y1,吃我一锤耶;Y0,流尽几世时光,圣劍;Yz,玩酷花少;Yy,榴莲小领主;Yx,电竞锰男;Yu,丶没办法,人归落雁後",["燃烧之刃"] = "Y6,性感的牙齿,十二点二十;Y5,虞狼罓罓;Y4,云端漫步,竹影凌风;Y3,雾隐貔貅,唯谦全吉;Y1,纯攻,大萨摩耶,丶谭咏麟;Yy,丿魑魅魍魎彡;Yv,Isaug",["安苏"] = "Y6,天依真的无缝;Y5,一闲云野鹤一,Buluphont;Y3,醉眼望云烟丶;Y2,唯有活着;Y1,啊砸;Y0,秘法守护者;Yx,一百万;Yw,刺激哦,咕噜呀",["伊森利恩"] = "Y6,鲨鱼辣椒酱紫,下水道狂暴战;Y3,雨宮蓮;Y2,黑色德芙;Y1,夜店之王;Yz,重拳",["凤凰之神"] = "Y6,三月廿九丶;Y5,圣光寇马克;Y3,情深;Y1,丨恶魔之子丨,树上的向日葵;Y0,翻云覆雨愁;Yz,血精灵丷椰羊丷,紅色冲动;Yy,猴晶旭;Yx,Meon,猫灬小舞;Yv,片小萨,虎丨鲸,椰奶椰奶;Yu,血斧钺戮,墨洺棋妙,张小锤丶,潇潇如雨,悠悠丨德丨心,Sandypriest",["末日行者"] = "Y6,武术至尊",["雷霆之王"] = "Y6,伊莉亚;Yu,卡扎库衫",["国王之谷"] = "Y6,冰墩墩雪容融;Y4,梦断不成归;Y0,春之欢愉;Yy,莫大先生;Yx,西丨猛;Yw,花花伊;Yv,咔德伽",["雏龙之翼"] = "Y6,尼古拉斯二狗,胡桃丶",["影之哀伤"] = "Y6,酒厂之花;Y5,雨夏雨夜;Y2,再战九点零;Y0,凤梨味道;Yz,也曾摘星辰;Yx,翟老师;Yw,丶王小毛;Yu,变化,唐寅字伯虎",["幽暗沼泽"] = "Y6,诶丫丫疼",["亚雷戈斯"] = "Y6,坠落六翼天使",["罗宁"] = "Y6,丶丶斯卡,血染飘发;Y1,大地老虎;Yz,思淼圓圓;Yw,弋妖一独雨;Yv,就是这么烦;Yu,星有零稀",["夏维安"] = "Y6,肖申克救赎;Y5,德了个德",["金色平原"] = "Y6,记忆的足迹;Yz,倚楼听雨;Yx,油腻麦迪昂",["贫瘠之地"] = "Y5,Acan;Y4,冯晓萌;Yz,巴索罗米奧;Yy,听不见大声点;Yx,失落的陈;Yw,水云雨诺,狂野水饺",["寒冰皇冠"] = "Y5,靠拢",["回音山"] = "Y5,爱媛果冻橙;Y0,双笙丶什么鬼;Yx,浪漫不加不减",["死亡之翼"] = "Y5,五七;Y4,Witheredvine,Kamino;Y3,之神,三泽大地;Y2,在摸鱼;Y1,蒼海笑,五丶七;Y0,邹哥哥;Yz,绿若青衣,丶红酥手丶;Yx,无人赴约,仇恨之眼;Yw,她如景;Yu,老友如老酒",["鬼雾峰"] = "Y5,泡沫崽",["火羽山"] = "Y5,糖乀喵喵",["布兰卡德"] = "Y5,暴怒的皮卡丘;Y0,夏沫呆呆;Yw,九个骑士;Yv,艾利摩尔;Yu,白欧欧",["永恒之井"] = "Y5,背心裤衩",["主宰之剑"] = "Y4,露华龙;Y2,红得批爆;Y1,爬进去整丶,握不住的它丶;Yz,西红柿不西;Yy,叁天饿玖顿;Yw,哈罗丶麦芽虫;Yv,国服最强喷子",["埃德萨拉"] = "Y4,Zerokk;Yv,丹丹别打啦",["阿纳克洛斯"] = "Y4,雷丶叱咤风云",["无尽之海"] = "Y4,乄王胖哒,灰灰丨灰灰;Yw,真气啵;Yu,星花火灬",["血色十字军"] = "Y4,丶菜头丸;Yz,包丶仔;Yy,洵美且異",["永夜港"] = "Y3,师气帅",["黑锋哨站"] = "Y3,安妮可姬",["海克泰尔"] = "Y2,米乐米乐",["海达希亚"] = "Y2,糖伯虎点蚊香",["克尔苏加德"] = "Y2,夜话白鹭丶",["洛萨"] = "Y1,雷欧奥特曼;Yu,躲起来的瓶子",["血环"] = "Y1,泪流某个海洋",["神圣之歌"] = "Y1,软饭硬吃",["???"] = "Y0,咆哮的野猪王;Yx,半截半",["熊猫酒仙"] = "Y0,尤型拆卸者;Yx,也是鲁小胖",["达纳斯"] = "Y0,莱瑞蕾",["黑暗魅影"] = "Y0,桑桑威武;Yx,麦麦兜",["迅捷微风"] = "Y0,充钱那各少年;Yz,洛希恩徘徊者",["索瑞森"] = "Yz,知见立知",["迦顿"] = "Yz,花开淡墨痕",["暴风祭坛"] = "Yy,Yellowflashd",["安其拉"] = "Yx,Kadenz",["米奈希尔"] = "Yx,别死",["熔火之心"] = "Yx,给少年的歌",["霜之哀伤"] = "Yx,Zinac",["山丘之王"] = "Yx,八钳蟹",["萨菲隆"] = "Yx,青岚挽风",["血吼"] = "Yw,嗜血安抚驱散",["格瑞姆巴托"] = "Yw,你打歪了",["迦拉克隆"] = "Yv,西丨猛",["卡德加"] = "Yu,夜月圭",["塞拉摩"] = "Yu,小红手露珠"};
local lastDonators = "冯晓萌-贫瘠之地,灰灰丨灰灰-无尽之海,竹影凌风-燃烧之刃,云端漫步-燃烧之刃,梦断不成归-国王之谷,Kamino-死亡之翼,Witheredvine-死亡之翼,丶菜头丸-血色十字军,乄王胖哒-无尽之海,雷丶叱咤风云-阿纳克洛斯,Zerokk-埃德萨拉,露华龙-主宰之剑,背心裤衩-永恒之井,德了个德-夏维安,圣光寇马克-凤凰之神,雨夏雨夜-影之哀伤,暴怒的皮卡丘-布兰卡德,糖乀喵喵-火羽山,泡沫崽-鬼雾峰,星星侠-丽丽（四川）,五七-死亡之翼,爱媛果冻橙-回音山,Buluphont-安苏,一闲云野鹤一-安苏,虞狼罓罓-燃烧之刃,萌术萌萌哒-白银之手,靠拢-寒冰皇冠,Acan-贫瘠之地,血染飘发-罗宁,伊姆大人-白银之手,记忆的足迹-金色平原,肖申克救赎-夏维安,丶丶斯卡-罗宁,十二点二十-燃烧之刃,下水道狂暴战-伊森利恩,坠落六翼天使-亚雷戈斯,胡桃丶-雏龙之翼,锦果果-白银之手,诶丫丫疼-幽暗沼泽,买香蕉去打怪-白银之手,酒厂之花-影之哀伤,尼古拉斯二狗-雏龙之翼,冰墩墩雪容融-国王之谷,伊莉亚-雷霆之王,武术至尊-末日行者,三月廿九丶-凤凰之神,鲨鱼辣椒酱紫-伊森利恩,天依真的无缝-安苏,爱吃糖的唐三-白银之手,性感的牙齿-燃烧之刃,说一-白银之手,说丶一-白银之手,说一-雷斧堡垒,说丶一-雷斧堡垒,羽衣直夏-冰风岗,主要看气质-丽丽（四川）,圣殿之光-丽丽（四川）";
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
      if topNamesOrder[players[index]] then row.name:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(name)) else row.name:SetText(name) end
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