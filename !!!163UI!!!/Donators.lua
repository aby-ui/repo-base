local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,释言丶-伊森利恩,乱灬乱-伊森利恩,渔汍-金色平原,古麗古麗-死亡之翼,Monarch-霜之哀伤,坚果别闹-燃烧之刃,短腿肥牛-无尽之海,冰淇淋上帝-血色十字军,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["永恒之井"] = "Ip,迪兰妮",["主宰之剑"] = "Ip,苏暖年,帝門汉特儿;Im,红豆生蓝国,青芒,只蹭噌不进去;Ik,灰烬乄主宰;Ih,捻花浅笑,暮雨倾城;If,红露凝香,茗之守护;Ie,岭上开三花",["熊猫酒仙"] = "Ip,月离丶,唐诗,愿你酷的像风;Ik,王药药",["燃烧之刃"] = "Ip,深沉凝视,困的猪,罗马尼奥利;In,不德不爱你;Ik,你好骚阿",["血色十字军"] = "Ip,油腻尬;In,牛刄;Ik,隔壁老樊丶,菠波浩浩",["艾露恩"] = "Ip,维特鲁,紫夜轻风",["格瑞姆巴托"] = "Ip,李猜猜,红花石蒜,裘千呎;Ik,达盖迩的旗帜;If,焱灬燚灬焱;Ie,你会放电吗",["海克泰尔"] = "Ip,会移动的荣誉,土豆变馒头;Ij,陈浩北",["雷霆之王"] = "Ip,瘌痢头撑阳伞",["冰风岗"] = "Ip,乾坤大挪移;In,凛冽的寒风;Il,龙彡",["金色平原"] = "Ip,如何玩鸡,邓肯丶巴拉莫,得嘞;Io,Alián;In,渔汍;Il,希尔瓦斯罐",["奥蕾莉亚"] = "Ip,月影凛风;In,栗子姨夫",["艾萨拉"] = "Ip,残阳如血",["勇士岛"] = "Ip,奥多芙",["白银之手"] = "Ip,米拉杰丶,奥露拉黛儿,一路心碎,夜雨聆風;Io,大厨诺米;In,勇者斗恶猪;Im,德挠人且咬人;Il,单点珍珠奶茶;Ik,風骚;Ij,紫陌丶蓝海;Ii,转角遇倒贼;Ih,樱花怒;Ie,孟超然丶",["罗宁"] = "Ip,苍月如霜;Ie,北岸风",["凤凰之神"] = "Ip,丶温猪子;In,王独秀丶,迷糊的芝麻糊;Im,魂一夕而九逝;Il,月照大江;Ik,爱生活爱拉芳;Ij,Avrilavril;Ih,清能有容;Ig,無牧丶,汪汪那个太阳;If,丽华锐颖轩,魑鴉;Ie,丷纸短丷",["迦拉克隆"] = "Ip,闹够了沒有,塔布奈,一只璐行鸟,石原里美丶;Ie,五升大雪碧",["踏梦者"] = "Ip,丶小琻毛",["哈兰"] = "Ip,胖哒",["末日行者"] = "Ip,糖乄序曲;In,德氏;Ii,隐形的纪念;If,思泣",["影之哀伤"] = "Ip,说佛;Il,我爱宝宝;Ih,养豚小能手;Ig,博览群峰;If,有趣的灵浑;Ie,仙女有只猫",["死亡之翼"] = "Ip,入江纯,莫得信仰,兰台,卢西奥;Io,熟练老司机,绝望的小鸭;Il,越哥没女朋友;Ik,最闪的衫,梨子酱;Ii,三刀爆砍小鸡;Ig,吐血的阿昆达;If,白嫖;Ie,无比滴丶,奋斗的宝贝",["逐日者"] = "Ip,Emoji",["黑暗魅影"] = "Ip,穿毛衣的猫",["拉文凯斯"] = "Ip,Gatanothor,那者",["玛里苟斯"] = "Ip,莫不言",["国王之谷"] = "Ip,邵疯疯;Io,红花石蒜;Ik,烽火丨烟雲,倾听之南;Ij,小浣熊君丶;Ii,坐看云起落;Ih,夺命老雪花,兜糖嘤嘤樱丶;Ie,李大胆儿",["天空之墙"] = "Ip,一条小团团",["密林游侠"] = "Ip,滑水的阿昆达",["霜狼"] = "Ip,叶子长翅膀",["梦境之树"] = "Ip,鹤令",["暴风祭坛"] = "Ip,Renmoy",["埃德萨拉"] = "Ip,永恒之悟;Im,仁僧;Ij,风格飘逸;Ie,扯淡的蓝辰",["提瑞斯法"] = "Ip,午夜骷髅党;Ii,颓废的小野猪",["烈焰峰"] = "Ip,娜小新",["破碎岭"] = "Ip,辉夜姬会飞;Il,关键一号,鸡蛋饭",["???"] = "Ip,丶氣質;Ij,卯月夕颜",["风暴之怒"] = "Ip,壹零",["安苏"] = "Ip,星耀、战神;Im,乌冬面大仙;Il,丶醉饮丶江河,欧欧小朋友;Ik,一布丁一;Ih,狄安娜之鹿;Ig,菇菇作响;Ie,缺德亡",["贫瘠之地"] = "Io,野屠夫;In,守灬衡;Im,壞尛孓;Ig,Hawker;If,灀烬;Ie,宇智波叉烧饭",["奥杜尔"] = "Io,檐上三寸雪;Im,牧云笙歌",["阿古斯"] = "Io,栀夏暖阳;Ii,一条咸鱼王",["毁灭之锤"] = "In,安東",["古尔丹"] = "In,呆卡萌哼哼",["翡翠梦境"] = "In,温尔澈",["太阳之井"] = "In,花灵",["伊森利恩"] = "In,柠檬汐雨",["丽丽（四川）"] = "Im,阴影猎杀者",["时光之穴"] = "Im,六十八号技师",["无尽之海"] = "Im,绵绵秋雨;If,Haatxl",["霜之哀伤"] = "Il,霈凌",["末日祷告祭坛"] = "Il,奥德灰烬",["银月"] = "Il,紫水居士",["冰霜之刃"] = "Ik,熊猫佩奇",["神圣之歌"] = "Ik,郁郁不得志",["通灵学院"] = "Ik,辣条灬千层",["亚雷戈斯"] = "Ik,特汚兔",["奥特兰克"] = "Ij,一休一休",["阿比迪斯"] = "Ij,血恋锋",["火焰之树"] = "Ij,木子",["永夜港"] = "Ij,Hyperionx",["布兰卡德"] = "Ii,瞄不准",["库德兰"] = "Ii,流苏",["龙骨平原"] = "Ii,贼有爱心",["深渊之巢"] = "Ii,甘兴霸",["恐怖图腾"] = "Ii,鳳凰",["丹莫德"] = "Ii,沉着应战",["蜘蛛王国"] = "Ii,我系小学僧哟",["红龙女王"] = "Ih,筱兮",["斯坦索姆"] = "Ih,清白之年",["月神殿"] = "Ih,御坂美琴丶",["红龙军团"] = "Ih,啊格拉",["尘风峡谷"] = "Ig,老韩和天下",["法拉希姆"] = "Ig,Meng",["黑龙军团"] = "Ig,神無月澪",["风暴峭壁"] = "Ig,丶摩尔迦娜",["埃霍恩"] = "Ie,今夕何夕,臭丶嗨",["狂热之刃"] = "Ie,滚地撞到墙",["石爪峰"] = "Ie,東衣",["血环"] = "Ie,王者祝福丶,刺芒丶",["回音山"] = "Ie,千羽丷"};
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