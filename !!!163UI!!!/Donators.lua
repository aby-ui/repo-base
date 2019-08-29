local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,绾风-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["阿古斯"] = "Jo,熊小瑞宝;Jm,卡露娜,诺灬亚;Jk,神圣的羽芒",["熔火之心"] = "Jo,人与兽,皓龙,火焰战皇,山寨奶爸,皇家御姐,魅魔出租,神歧视,凶煞,紫色幽兰,利爪之王,山寨妖王,嗜血傀儡",["萨洛拉丝"] = "Jo,死亡阴影",["国王之谷"] = "Jo,冥姬;Jn,Speegraf,只穿黑丝;Jj,铁面孔目",["白银之手"] = "Jo,丶祝踏楠;Jn,水月凌幽,一只小憨呀;Jm,Remn;Jl,闪耀的苍山,发育良好,微风骑;Jk,张漂亮真美丽,摇摆的俾格米,灵燕眉;Jj,柏柏乓乓,戰灬无情,鸢木;Ji,卡姗德拉,中國丶欧皇,靑楓,康士坦变化球,茅延咹,青袖舞霓裳,水无痕",["万色星辰"] = "Jn,米粉儿",["布兰卡德"] = "Jn,澜神;Jl,陈伟霆丶;Jk,琴月萤;Jj,大咪变变身;Jh,Bavykonty",["冰霜之刃"] = "Jn,艾文丶帕拉丁;Jl,Tortoiser",["阿拉索"] = "Jn,Ironshield",["战歌"] = "Jn,风暴牛",["格瑞姆巴托"] = "Jn,Shintaro,气敷敷小公主;Jm,雪映倾城;Jl,唉木踢;Jj,幽暗星尘,职业大叔;Ji,铁拳凌晓雨,靳益达,大朗起来喝药,血之命令,艾克清光",["耐普图隆"] = "Jn,晚睡长皱纹",["死亡之翼"] = "Jn,村镇一枝花,躁动小闪亮,奇怪的萝卜,七月沐雪,前世的术;Jm,失落的高个子,小芳儿;Jl,夜皓明,花灵;Jk,夏沫轻风,圣殿幻影,天好热;Jj,小二上三,阿宝丨情儿,杏呀,Traveljunkie;Ji,樊北鱼,妮露殿下丶,王舞雾,风雨飘瑶丶,奈斯凸米球,踏剑醉清风;Jh,孙小颖脆皮儿",["冰风岗"] = "Jn,Copere,稳场祖宗",["凤凰之神"] = "Jn,灬红荼亽,独影随风,必开四五五,至高无上德哥,做我的小公主,神罗天征灬;Jm,灬面条,战复那個小德;Jl,我爱大牛眼睛,忧兮,浊酒相思;Jk,妍夏丘豪,古城久巷年少,阳光美少牛;Jj,少司乄秦时命,天青色等烟雨,卡布奇诺斯基,我的小德呢,欧乄以神之名;Ji,东瓶西镜放,暮小暖,坤平将军,馨月虎啸,馨月雨木石,十殿阎猡;Jh,曲终红颜殁,甜心发射",["希尔瓦娜斯"] = "Jn,弥赛亚",["奥特兰克"] = "Jn,大大的迪奥毛;Jm,死战的薄之葬;Jl,资管新规",["贫瘠之地"] = "Jn,自然灬恩赐,熊大爱吃肉;Jm,烫头大叔丶,猫九丶;Jk,我灬去,四费五杠四,Egjerry;Jj,丨莫斯;Ji,笋尖,欧皇大表哥",["帕奇维克"] = "Jn,麦兹多克",["霜狼"] = "Jn,米洛克洛泽;Jk,世上最弱,直哥",["主宰之剑"] = "Jn,財柛,鑫拾壹,凄凉月光;Jl,小阿咪丶,心系菩提,心怀邪恶;Jk,你好丶再会;Jj,羽落凡辰,吴山酥油饼;Ji,夜丶肥肉;Jh,酒卿",["燃烧之刃"] = "Jn,秦川丶,Monkä;Jm,闪开小弟上,离人丶陌生;Jl,蓝雨芯,阡默;Jk,烟飘雨朦胧;Jj,丿阿司匹林丿,三费仆从,燃燒的青春,战神丨炎焱;Ji,炯迥浻囧猫,丰息,華脩;Jh,黑魂丶",["山丘之王"] = "Jn,火舞浅瞳",["迦拉克隆"] = "Jn,一圣一光一;Jj,熊貓牧師;Ji,冲锋跪丶",["血色十字军"] = "Jn,丶大姨媽;Jm,纱月灯,娇羞的阿昆达;Jk,泷韵,祖国人;Jj,子曰无忌;Ji,缘灬難了,断章诗篇,枫雪丶;Jh,徒手割苞皮",["???"] = "Jn,丶诗酒琴棋客;Jm,小时候可熊了,狠角色小萨;Jj,狂魔之殇;Jh,丿湫兮如风丶;Jg,云丶娜",["火烟之谷"] = "Jn,伱猜猜是谁",["黑铁"] = "Jn,任然自由自我;Jl,性暴咕丶小张,Asuuna",["末日行者"] = "Jn,十万城管;Jj,莽汁儿,一盒老鲜肉;Jh,小老弟丷,哆啦妹丶",["埃德萨拉"] = "Jn,盗甜;Jj,弹尽粮绝",["丽丽（四川）"] = "Jn,烟频话少;Jm,牛子哥;Jl,冰似无情,Garenmienvi,荒野遺孤;Jk,飞升修仙;Ji,鲤鱼王的绝技",["熊猫酒仙"] = "Jn,琻瑹棠;Jm,海拉丶;Jl,Telunsuii;Ji,透透,安静的苹果;Jh,貝貝兒",["罗宁"] = "Jm,一秒一喵机会;Jl,疾风剑客,丶小吃货,Nsx;Jk,丶狼鸽,聖焃;Ji,丶天機變丶,风无歌,深邃黑暗",["暗影之月"] = "Jm,砂锅大的锤",["黑暗之门"] = "Jm,神级的朗朗",["阿曼尼"] = "Jm,夜场红人",["埃苏雷格"] = "Jm,痴汉",["金色平原"] = "Jm,圣光二狗子;Jl,浪漫绅士;Jk,萌萌灬丫;Jj,冲锋向后",["无尽之海"] = "Jm,花谢花开漫天;Jl,啸卿男爵;Jk,曲奇大盗;Ji,蜜汁鸡排饭,蚂蚁牙嘿",["永恒之井"] = "Jm,逆境丶流觞;Jj,涅槃灬一然,丨一然丨,灬一然灬,丷一然丷;Ji,丶奈何归去,大丽丽",["燃烧平原"] = "Jm,复生给了逼;Ji,敎父",["伊森利恩"] = "Jm,落红灬染素颜;Jk,小小胖咕,职业丶舔狗;Ji,奶爸不搞事",["回音山"] = "Jm,丨叮叮;Jk,胡继;Ji,艾丽安",["艾苏恩"] = "Jm,钱馨馨",["破碎岭"] = "Jm,安兹丶乌尔恭",["激流之傲"] = "Jl,獠刹",["奥尔加隆"] = "Jl,胖胖叮",["凯尔萨斯"] = "Jl,兔子守护者",["达尔坎"] = "Jl,神勇牛霸",["熵魔"] = "Jl,玖慕雅黛",["晴日峰（江苏）"] = "Jl,娜塔丽波特曼",["加基森"] = "Jl,篱巍",["影之哀伤"] = "Jl,阿汤哥;Ji,雪丨乃,镇魂地狱;Jh,摩天大樓",["刺骨利刃"] = "Jl,谨守青春;Ji,南鸢丨离梦",["海克泰尔"] = "Jl,Choaya",["火焰之树"] = "Jl,贼王",["巨龙之吼"] = "Jl,万小萌;Ji,灬橙橙灬",["奥达曼"] = "Jl,蚩尤",["血环"] = "Jl,诡匕;Jj,丝足少女",["洛萨"] = "Jk,寒霜战神",["戈提克"] = "Jk,Myloveyue",["戈古纳斯"] = "Jk,我又来了啊",["狂热之刃"] = "Jk,靖主任;Jj,吃多了不消化",["密林游侠"] = "Jk,Livio;Jh,请叫我战爹",["阿迦玛甘"] = "Jk,Io",["遗忘海岸"] = "Jk,孤单的宝宝",["桑德兰"] = "Jk,烈酒重阳",["克洛玛古斯"] = "Jk,泪落成殇",["迅捷微风"] = "Jk,奇德",["时光之穴"] = "Jk,无限弹幕;Ji,微线儿",["地狱之石"] = "Jj,糊不糊丶",["拉文凯斯"] = "Jj,筱喵了喵呜",["织亡者"] = "Jj,歆丶歆",["翡翠梦境"] = "Jj,契诃夫;Ji,露琪亚",["死亡熔炉"] = "Jj,格乌恩",["天谴之门"] = "Jj,黑暗小法",["烈焰峰"] = "Jj,Yukee",["塞拉赞恩"] = "Jj,冧檬茶",["苏塔恩"] = "Jj,光的声音",["泰兰德"] = "Jj,冰瑟琳",["耳语海岸"] = "Jj,迦南叶",["丹莫德"] = "Jj,安雨珊;Jh,叫我绅士",["寒冰皇冠"] = "Jj,丶帕露露",["洛肯"] = "Jj,龙漳清",["布莱克摩"] = "Jj,妖魂",["安东尼达斯"] = "Jj,挚丶爱",["图拉扬"] = "Jj,羅夏",["生态船"] = "Jj,拇指",["远古海滩"] = "Ji,花与梦的流星",["玛里苟斯"] = "Ji,上帝之猎",["安苏"] = "Ji,戰㐅枫,暴击丷战神;Jh,|矛",["亚雷戈斯"] = "Ji,燕千月",["诺兹多姆"] = "Ji,苍穹之光薇恩",["壁炉谷"] = "Ji,群侠喵喵",["伊利丹"] = "Ji,一朵小蘑菇",["梅尔加尼"] = "Ji,浪猫",["古尔丹"] = "Ji,叶雷达",["朵丹尼尔"] = "Ji,张耀扬",["巴瑟拉斯"] = "Ji,親爱的,钢铁直男",["石锤"] = "Ji,我最耐揍了",["雷霆之怒"] = "Ji,神经兮兮之猫",["伊瑟拉"] = "Ji,飞来飞去的火",["通灵学院"] = "Ji,霜瞳灬小劣人",["艾露恩"] = "Ji,尛丷法",["奥妮克希亚"] = "Jh,细雨丶丶",["克尔苏加德"] = "Jh,修牧秋",["斯坦索姆"] = "Jh,神圣之息",["弗塞雷迦"] = "Jh,陌小沫"};
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