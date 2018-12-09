local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,释言丶-伊森利恩,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,戦乙女-霜之哀伤,橙阿鬼丶-达尔坎";
local recentDonators = {["白银之手"] = "Fd,辟邪丶,狡猾的阿不思,青衣颜;Fa,无敌裁决者,堸吹稻花香;FZ,就不要想起我,管住嘴迈开腿;FY,楓夜;FX,木槿兮年;FW,欧浅浅",["卡拉赞"] = "Fd,、陌;FX,古魔法師",["主宰之剑"] = "Fd,思念初夏,玖茅菻玖;Fa,花惜杀阵;FX,不知名的鹿丶;FW,朕乄魂哥,那个萨满切奶,老顽童,鲱鱼罐头丶",["死亡之翼"] = "Fd,莫名与莫言;Fc,苍丶天;Fb,史汰濃,術欲静,Shllin;Fa,丨影行者丨;FY,丶忧郁小驴,丶叮当喵,冰封丶曦;FX,繁花与盾,安度因灬大虾,凉城旧梦;FW,Felixy,狂野老司机,嘤嘤酱",["伊利丹"] = "Fd,霜之利刃",["血色十字军"] = "Fd,獸人獵;FY,两仪丶;FW,Charprime,飞妖兒",["壁炉谷"] = "Fd,冰豬丶",["无尽之海"] = "Fd,默片;Fc,撒灬加,歌神陈奕迅;FX,灬断肠灬;FW,大脑腐,灵魂怒放,Saturne,银耳莲子汤",["扎拉赞恩"] = "Fd,涂安玲;FZ,富江富江富江",["暗影之月"] = "Fd,火儛丶;FZ,亚纪人,文盲",["燃烧平原"] = "Fd,听雨丶;Fa,;FZ,听雨ヽ;FW,回不去的风筝",["巫妖之王"] = "Fd,Mamson",["天空之墙"] = "Fd,假面死骑;FY,我爱平底锅",["破碎岭"] = "Fd,网瘾少年;FY,Turbowarrior",["图拉扬"] = "Fd,黑莓",["太阳之井"] = "Fd,贾纳尔的图腾,贾纳尔的牺牲,贾纳尔的变化,贾纳尔的冲锋",["末日行者"] = "Fd,狂蜂乄浪蝶,枫羽沫;Fc,丶阿破克列;Fb,妹纸的法丝;Fa,嘴角的发丝",["国王之谷"] = "Fd,丿灬枫之影,枫羽沫;Fb,月色猫爪子;FZ,月儿寶貝;FX,洅雲端;FW,瑞文丶戴尔",["格瑞姆巴托"] = "Fd,一个灵活胖子;Fc,羽弥;Fb,常州大恐龙;Fa,红豆凉;FX,墨唐魑魅,奥德莉娅",["风暴之眼"] = "Fd,半点白",["守护之剑"] = "Fc,魔傀;Fa,Booth",["凤凰之神"] = "Fc,村民丶,小木,楸枫,戦榊,夵杨;Fa,南柯一夏;FY,依三;FX,静如心丨清溪,神秘的阿昆达,翻滚灬红荼,一叶花一菩提,灰灰的小灰机,公爵莉亚德琳",["莱索恩"] = "Fc,大仙楚兮",["埃德萨拉"] = "Fc,剑隐锋藏;FX,带带大猪蹄子;FW,九枭",["艾露恩"] = "Fc,莉娜巴恩斯",["红龙女王"] = "Fc,霜语冰舞",["罗宁"] = "Fc,Iweirdo;FZ,咕噜子;FY,铭河,杜光亭;FX,七芯幽若",["安苏"] = "Fc,弯不下腰;Fa,第五正;FW,迷恋苞娜,丶戎馬书生",["奥特兰克"] = "Fc,九尾明曰奈",["梅尔加尼"] = "Fc,很黄很暴力;FZ,剑落惊风雨",["贫瘠之地"] = "Fc,丘丘书豪;Fb,花魚兒;Fa,花田一路;FZ,王大妮丶,倔强的小火龙;FY,时颜;FX,花饮月",["熊猫酒仙"] = "Fc,哎哟喂丶亲爹;Fb,云烟成雨;FZ,渊兮丶,熊猫蜜桃;FX,灬忆往昔灬;FW,依然很贼,叶红鱼",["阿纳克洛斯"] = "Fb,一盘溜肉段;FZ,青峰小乔木",["???"] = "Fb,丶摩擦丶;Fa,狮心;FY,九里外的风车;FW,Corcere;FT,消逝嘚焰火",["德拉诺"] = "Fb,大香菇",["诺兹多姆"] = "Fb,Bluefox",["白骨荒野"] = "Fb,丨独影丶",["回音山"] = "Fb,我丶老李师傅;FW,油腻咖",["红云台地"] = "Fb,伦仔",["血顶"] = "Fb,维克雷斯夫人",["奥尔加隆"] = "Fa,拼多多;FY,雪柯基",["山丘之王"] = "Fa,紫袖幻浮年",["迦拉克隆"] = "Fa,一对牛角",["冰风岗"] = "Fa,默罕默德道长,狗丶白",["纳沙塔尔"] = "Fa,鬼魅丶",["燃烧之刃"] = "Fa,来来爸爸,十三年老萨满;FY,Calvink;FX,供销社的小翠;FW,妩媚小蛮腰",["鹰巢山"] = "Fa,封稀冰",["艾森娜"] = "Fa,钢然妞妞",["海克泰尔"] = "Fa,黑锋党委书记;FX,呆牛扛不住,红猫丶,十爱九离,雨林雨林",["斩魔者"] = "Fa,剑影;FX,一个好爸爸",["厄祖玛特"] = "Fa,Warcraf",["玛法里奥"] = "Fa,灬树",["布莱克摩"] = "FZ,Communist",["影之哀伤"] = "FZ,人間不值得;FW,七月半",["迅捷微风"] = "FZ,熊猫媛媛;FX,乄一条小熊猫",["黑铁"] = "FZ,凭实力送人头",["斯坦索姆"] = "FZ,我真是哔了咕",["雷霆之王"] = "FZ,暴怒的猫老大",["密林游侠"] = "FZ,甲乙丙丁",["风行者"] = "FZ,东方未名",["爱斯特纳"] = "FY,浮城旧事丶",["黑暗之门"] = "FY,哥当时就怒了;FW,抓栏杆撕床单",["恶魔之魂"] = "FY,Cancel;FW,镜影",["战歌"] = "FY,孟丶子义",["阿古斯"] = "FY,可米小胖子,可米小丸子",["卡德加"] = "FY,造粪机",["阿迦玛甘"] = "FY,Dmoon",["萨尔"] = "FX,大青山;FW,熵魔張叁豐,黑丶执事",["埃加洛尔"] = "FX,疯狂喷涌",["耳语海岸"] = "FX,你觉得怎么样",["金色平原"] = "FX,君莫思归",["翡翠梦境"] = "FX,拂晓丶炽焰",["毁灭之锤"] = "FX,德了吧德了",["鬼雾峰"] = "FX,天空繁星点点",["迦顿"] = "FX,犹她",["暮色森林"] = "FX,夜雨风情",["埃苏雷格"] = "FX,寒夜清宵",["奥达曼"] = "FX,薛滴凯",["霜之哀伤"] = "FX,安得文",["伊森利恩"] = "FX,灬柠檬丶咖啡;FW,卡梅隆,Lancoo",["千针石林"] = "FW,天佑丶复生,天佑丿复生,天佑丨复生",["阿扎达斯"] = "FW,一起哈皮",["阿曼尼"] = "FW,耳火弓长",["冰霜之刃"] = "FW,时过境迁,房飞冯",["熔火之心"] = "FW,咕德喵咛",["血环"] = "FW,我是大丁丁",["银月"] = "FW,绽花儿",["灰谷"] = "FW,天堂的阶梯",["戈提克"] = "FW,安心油条",["希雷诺斯"] = "FW,小程"};
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
                    if not tContains(players, fullname) then
                        table.insert(players, fullname)
                        player_days[fullname] = date
                        player_shown[fullname] = topNamesOrder[fullname] or 0
                    end
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