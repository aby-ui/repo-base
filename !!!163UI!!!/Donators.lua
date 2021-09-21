local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["无尽之海"] = "Vo,Zizioiui;Vj,獨壹無貳;Vf,犇頭德撸衣;Vb,Rossoneris;VZ,带带丶;VW,牧云",["血色十字军"] = "Vo,灬追云灬;Vi,马拉喀什;Vh,超级小花花;Vd,世间大雨滂沱;Vc,Lacampanella;VW,赦免",["主宰之剑"] = "Vo,亢慕义斋;Vm,黑凤梨呀;Ve,暗殺星;Vd,冰煌血舞;Vc,球丶;VY,Orionsuio,终焉恩赐,梦里是谁,冯珍珠;VX,娜依秀美;VW,Sicklikeme",["白银之手"] = "Vo,Sniperkennys,圣洁重生,契约飞飞,死神小小妹;Vl,Ninesixmage,我要自然醒,丨浣熊丨;Vk,您说的对;Vj,丷不二丷;Vg,畚瓟旳蝸犇,奥蕾莉亚公爵;Vf,血腥战歌,云中寄雨;Ve,彼麦凯蒂丶,Shanbaby,冰冰水冰;Vd,小小心脏,Ntmdjjww,壹贱定天下;Vc,封尘絕念斬;VY,小喵弯月;VV,老板来碗凉面,叶奈法的玩具",["凤凰之神"] = "Vo,零落的殇,丶北极光丶,Lonergan;Vn,丶浮游;Vm,Horseshoe,双剑合璧;Vl,雪白丨血红,休克;Vk,消失的漫画家;Vi,米米狂乱,狗头萨;Vg,无糖的甜可乐;Vf,天涯觅青鸾,焦嘦嘦,于子酱,小猪佩鱼丷;Ve,自然醒吧,鸣剑;Vd,背影余晖,谜灬失,尤川丶蚩梦,丶对钱没情趣,夜半月听风;Vc,槐琥,阳顶顶丶,拿枪的老牛,熊卟贰,风寂笑,火龙果冻,愤怒毛驴;Va,尐软;VY,南京扣德普雷,伊斯嗒娜;VX,超烦之萌",["伊森利恩"] = "Vo,小黑瓦娜斯,Orcshaman;Vn,独自去偷歡,腐质之瓶;Vm,君乐宝;Vl,跋依抛污;Vh,辞忧,習慣隠身;Vg,黑色信封;Vf,桃溪春野;Vd,小小波哥丶;Vb,机智的大叔;Va,执笔绘苍穹;VX,冷月丨",["石锤"] = "Vo,Alive",["阿纳克洛斯"] = "Vo,残垣立旧篷丶;Vm,残垣立旧篷;VY,棺材板踏浪者",["贫瘠之地"] = "Vo,野猫满;Vg,血红辣椒;Vf,狂魔㐅乱舞;Vd,珊瑚海;Vc,余悸,Avicii;Vb,丶毒;VZ,风起寒秋",["安苏"] = "Vo,小汤姆哈迪;Vn,墨鱼丸粗面丶;Vl,Decemberm;Vk,人间小陀螺丶;Vj,韮菜;Vg,童话里的王子;Vf,南吕五日;Ve,丨我很纯洁丶,至尊丶牛犊子;Vd,林楚儿,马大漂亮;Vc,嗨尼玛嘴硬,英雄出少女;VY,猫耳娘丶",["燃烧之刃"] = "Vo,如果我有轻功;Vn,毛德,静香海王;Vm,香犇犇,冰淇淋牛排;Vf,始终怀念;Ve,议事厅哭强战,黄黄皇帝;Vd,尛噩夢,大奶猴也算猴;Vc,辛多雷强哥,霜火挽歌丶;VV,闪开我要装逼",["???"] = "Vn,Chiancaptain,萨丶白寒;Vm,可乐味的鱼丶;Vj,阿卅;Vi,放羊的灰太狼",["兰娜瑟尔"] = "Vn,世界之树",["克尔苏加德"] = "Vn,不破眠虫;Vl,盛夏娇杨丶;Vc,凛冬怒吼;VX,丶天师傅",["熊猫酒仙"] = "Vn,小黄瓶;Vj,三土兄;Vc,尹力平;VY,泰澜德灬小鬼",["冰霜之刃"] = "Vn,正则灵均",["守护之剑"] = "Vn,笑书神侠;Vk,情流感",["迅捷微风"] = "Vn,达瓦里氏丶",["海克泰尔"] = "Vn,傑米蘭尼斯特;Vf,林深鹿幽鸣;Vc,机智的大叔",["塞拉摩"] = "Vn,曾经依旧;VX,慕冬",["影之哀伤"] = "Vm,箭追魂;Vi,天之梦幻;Vg,丨晓旭丨,肉不够骨头凑;Vf,狂躁方向盘;Ve,沾血的黃瓜;Vc,天秀阁;VW,繧儱兄",["死亡之翼"] = "Vm,野猪大王;Vl,清水泓清,天天喝枸杞;Vj,Berryzl;Vh,谢幕挽歌,昱焱小红手,嘻嘻西茶;Vg,仲夏夜之术,残魂断枫桥,六十八;Vf,拒绝我都被绿,Jeromecc;Vd,杨扬采,仙晨之灵,Lixm;Vc,醉后,老淦部,梦幻彤凡;Vb,发飙的天牛;Va,夜阑听雨丶;VZ,刃命,没教养的瘤;VW,莽斧,南宫仆射灬,梦醒九分丶,油油的小绿皮",["布兰卡德"] = "Vm,莫莫小可爱;VX,玛法里奧怒风",["艾莫莉丝"] = "Vl,性感小野猫",["罗宁"] = "Vl,黄油蟹蟹,魔龙,海叶灬;Vg,青夏瑶,暗殺星乄;Vf,墨华,盞茶作酒;Vd,伊利瑟维斯;VZ,川西北大拿;VV,雅詩",["尘风峡谷"] = "Vl,不扰清梦,醉梦独舞",["瑟莱德丝"] = "Vl,懒癌晚期凉凉",["回音山"] = "Vl,魔抗孩;Vh,叁嗣叁",["泰兰德"] = "Vl,包子系马达;Vb,Minikiki",["普罗德摩"] = "Vl,丨影刃丨",["阿克蒙德"] = "Vk,睡衣",["玛诺洛斯"] = "Vk,茉莉冰冰",["斩魔者"] = "Vk,圣光之力丿",["银松森林"] = "Vk,混沌小小",["神圣之歌"] = "Vk,部落两大傻;Vc,幽幽小生",["蜘蛛王国"] = "Vk,Johnnyr",["丽丽（四川）"] = "Vk,丶曰天;Vh,你艾希我奶妈;Vd,烈火战歌丶",["翡翠梦境"] = "Vj,Pala",["符文图腾"] = "Vj,嘟嘟",["格瑞姆巴托"] = "Vj,信号旗;Vh,加肥猫猫,冷艳的暧昧;Vf,琴断弦难断;VY,Aoekaizibao,狂派丨迷乱",["白骨荒野"] = "Vj,永恒之夜",["国王之谷"] = "Vi,夏川真凉丶;Vf,留痕;Vc,一凤;Va,战士雍杰大叔;VZ,仲长胤",["埃德萨拉"] = "Vi,橘昕大欧皇;Vg,不萌不萌啦;Vd,萨绝人寰",["德拉诺"] = "Vi,幼儿园大王",["狂热之刃"] = "Vh,孤独伊枫丶",["时光之穴"] = "Vh,花伦同学",["冰风岗"] = "Vh,残丷雪;Vg,我叫匕杀大;Ve,萌萌哒滴萌萌;Vc,天选之子,月玄孤心;Va,洗尽凡间铅华;VV,哆啦比梦",["凯恩血蹄"] = "Vh,美女;Vc,易拉罐;VV,丶我不奶",["卡德加"] = "Vh,江湖传奇",["深渊之喉"] = "Vh,动感光波",["图拉扬"] = "Vh,子雨山",["末日行者"] = "Vg,Komms,不斷;Vd,隐匿的气息,皮塞船;Vc,坠落战神;Va,Shallnotpass",["迦拉克隆"] = "Vg,银月星魂;Ve,二叔灬",["万色星辰"] = "Vg,尤丨迪安",["拉文凯斯"] = "Vg,青烟雨;Vc,小村镇的吻",["金色平原"] = "Vg,泥头车撞太郎;Vc,遇见北极星",["霜之哀伤"] = "Vg,等待终成遗憾;Vf,卡其布诺灬;Vd,青年蜀黍",["洛肯"] = "Vg,Dklinjiang;Vc,猫哥",["伊莫塔尔"] = "Vf,舒预言",["血牙魔王"] = "Vf,Mojiedjlr;Vc,七叶一枝花妖",["普瑞斯托"] = "Vf,一念丹香",["诺森德"] = "Vf,无限正义",["冰川之拳"] = "Vf,寶貝卟哭",["阿古斯"] = "Vf,贺豪豪",["巨龙之吼"] = "Vf,馮巩老師丶",["奥妮克希亚"] = "Ve,伽罗丶六道",["寒冰皇冠"] = "Ve,牛克蒙德",["月光林地"] = "Ve,白兔软糖",["自由之风"] = "Ve,黑枸杞",["风行者"] = "Ve,蔡萌萌",["泰拉尔"] = "Ve,弋影",["利刃之拳"] = "Ve,透明凝清",["索瑞森"] = "Ve,飘渺天下",["安戈洛"] = "Vd,动物园牛总",["恶魔之魂"] = "Vd,破坏者血雨",["暗影迷宫"] = "Vd,带带大天启",["暴风祭坛"] = "Vd,Èèsp",["破碎岭"] = "Vd,那一抹深蓝色",["幽暗沼泽"] = "Vd,万嗜唔忧",["耐普图隆"] = "Vd,小豆先生",["世界之树"] = "Vd,死亡深度",["日落沼泽"] = "Vd,眼棱瞎了眼丶",["银月"] = "Vd,风雪夜归人",["天空之墙"] = "Vc,依楼丶听雨",["巫妖之王"] = "Vc,剑出烛影随",["鬼雾峰"] = "Vc,Relieved;Va,卟忘丶初心",["嚎风峡湾"] = "Vc,俄里翁",["洛丹伦"] = "Vc,犇啵霸",["轻风之语"] = "Vb,天选之子",["希雷诺斯"] = "VZ,洛城时光灬",["龙骨平原"] = "VX,小手很凉",["地狱咆哮"] = "VW,呱二蛋",["格雷迈恩"] = "VW,Statet",["大地之怒"] = "VV,灬浮竹灬",["诺兹多姆"] = "VV,少年出大荒"};
local lastDonators = "Berryzl-死亡之翼,永恒之夜-白骨荒野,信号旗-格瑞姆巴托,嘟嘟-符文图腾,韮菜-安苏,三土兄-熊猫酒仙,Pala-翡翠梦境,獨壹無貳-无尽之海,丷不二丷-白银之手,阿卅-???,丶曰天-丽丽（四川）,Johnnyr-蜘蛛王国,部落两大傻-神圣之歌,混沌小小-银松森林,您说的对-白银之手,消失的漫画家-凤凰之神,情流感-守护之剑,人间小陀螺丶-安苏,圣光之力丿-斩魔者,茉莉冰冰-玛诺洛斯,睡衣-阿克蒙德,丨影刃丨-普罗德摩,包子系马达-泰兰德,休克-凤凰之神,魔抗孩-回音山,跋依抛污-伊森利恩,海叶灬-罗宁,魔龙-罗宁,天天喝枸杞-死亡之翼,雪白丨血红-凤凰之神,懒癌晚期凉凉-瑟莱德丝,丨浣熊丨-白银之手,醉梦独舞-尘风峡谷,Decemberm-安苏,不扰清梦-尘风峡谷,我要自然醒-白银之手,黄油蟹蟹-罗宁,Ninesixmage-白银之手,性感小野猫-艾莫莉丝,盛夏娇杨丶-克尔苏加德,清水泓清-死亡之翼,莫莫小可爱-布兰卡德,双剑合璧-凤凰之神,可乐味的鱼丶-???,君乐宝-伊森利恩,冰淇淋牛排-燃烧之刃,Horseshoe-凤凰之神,黑凤梨呀-主宰之剑,野猪大王-死亡之翼,箭追魂-影之哀伤,香犇犇-燃烧之刃,残垣立旧篷-阿纳克洛斯,静香海王-燃烧之刃,曾经依旧-塞拉摩,腐质之瓶-伊森利恩,傑米蘭尼斯特-海克泰尔,达瓦里氏丶-迅捷微风,达瓦里氏丶-迅捷微风,笑书神侠-守护之剑,正则灵均-冰霜之刃,小黄瓶-熊猫酒仙,不破眠虫-克尔苏加德,丶浮游-凤凰之神,墨鱼丸粗面丶-安苏,独自去偷歡-伊森利恩,萨丶白寒-???,毛德-燃烧之刃,世界之树-兰娜瑟尔,Chiancaptain-???,死神小小妹-白银之手,如果我有轻功-燃烧之刃,契约飞飞-白银之手,小汤姆哈迪-安苏,野猫满-贫瘠之地,Lonergan-凤凰之神,圣洁重生-白银之手,残垣立旧篷丶-阿纳克洛斯,Alive-石锤,Orcshaman-伊森利恩,小黑瓦娜斯-伊森利恩,丶北极光丶-凤凰之神,零落的殇-凤凰之神,Sniperkennys-白银之手,亢慕义斋-主宰之剑,灬追云灬-血色十字军,Zizioiui-无尽之海";
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