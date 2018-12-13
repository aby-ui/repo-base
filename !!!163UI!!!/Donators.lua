local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,释言丶-伊森利恩,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,不要捣乱-贫瘠之地,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,戦乙女-霜之哀伤";
local recentDonators = {["罗宁"] = "Fi,没人要的玩偶;Fh,有爱有高潮;Fe,神眷露露缇雅,艾玛斯通|;Fc,Iweirdo;FZ,咕噜子;FY,铭河,杜光亭;FX,七芯幽若",["无尽之海"] = "Fi,毒液丶;Fh,冰封太子;Fg,灬唆了蜜灬;Ff,今晚吃鸡,鸸鹋丶;Fd,默片;Fc,撒灬加,歌神陈奕迅;FX,灬断肠灬;FW,大脑腐,灵魂怒放,Saturne,银耳莲子汤",["熊猫酒仙"] = "Fi,丶彭于晏丶;Fh,丫哥卖假药,未丶来,西西弗斯丶,名侦探喵美;Fg,撕裂信仰;Fe,;Fc,哎哟喂丶亲爹;Fb,云烟成雨;FZ,渊兮丶,熊猫蜜桃;FX,灬忆往昔灬;FW,依然很贼,叶红鱼",["风行者"] = "Fh,血色丶曼陀罗,我特么要造反;FZ,东方未名",["达隆米尔"] = "Fh,愿月神保佑你",["冰风岗"] = "Fh,蓝色空闲;Fg,路灯披橙;Fe,蠕动荣誉丶;Fa,默罕默德道长,狗丶白",["红龙军团"] = "Fh,我离,绿绿小萝莉,山下来的神棍",["奥拉基尔"] = "Fh,真不知是誰",["灰谷"] = "Fh,一切爲了联盟,二郎显圣真君;FW,天堂的阶梯",["主宰之剑"] = "Fh,咕喵酱,红胡子老大爷;Fg,杰哥威武;Fe,矮丑土肥圆;Fd,思念初夏,玖茅菻玖;Fa,花惜杀阵;FX,不知名的鹿丶;FW,朕乄魂哥,那个萨满切奶,老顽童,鲱鱼罐头丶",["奥达曼"] = "Fh,老衲要射啦,箭之影;Fg,Chameleos,Freude;FX,薛滴凯",["燃烧之刃"] = "Fh,Polariis,面纱丶,好想羊只咕丶,潶澀灬小妹;Fa,来来爸爸,十三年老萨满;FY,Calvink;FX,供销社的小翠;FW,妩媚小蛮腰",["死亡之翼"] = "Fh,邓士载,炉中剑,无辜的大萌德,势如利刃,Senario;Fd,莫名与莫言;Fc,苍丶天;Fb,史汰濃,術欲静,Shllin;Fa,丨影行者丨;FY,丶忧郁小驴,丶叮当喵,冰封丶曦;FX,繁花与盾,安度因灬大虾,凉城旧梦;FW,Felixy,狂野老司机,嘤嘤酱",["埃加洛尔"] = "Fh,吾生须臾,吾谁与归,太早;FX,疯狂喷涌",["暗影议会"] = "Fh,大绝招",["凤凰之神"] = "Fh,小菇梁柒丶,炸天出征,戀夏,风油巾,祈祷落幕,贼胆专家,是十一月天呀;Ff,暗黑风暴;Fe,琉璃魂,神圣琉璃;Fc,小木,楸枫,戦榊,夵杨;Fa,南柯一夏;FY,依三;FX,静如心丨清溪,神秘的阿昆达,翻滚灬红荼,一叶花一菩提,灰灰的小灰机,公爵莉亚德琳",["阿扎达斯"] = "Fh,雨灵霖凌;FW,一起哈皮",["贫瘠之地"] = "Fh,凊凉,汰渍净白去渍,早苗,感恩朋友,不要捣乱,平静的杜王町,早上好丶,黑椒牛肉丸;Fc,丘丘书豪;Fb,花魚兒;Fa,花田一路;FZ,王大妮丶,倔强的小火龙;FY,时颜;FX,花饮月",["梅尔加尼"] = "Fh,冽丶风;Fc,很黄很暴力;FZ,剑落惊风雨",["图拉扬"] = "Fh,杜琼新羽;Fd,黑莓",["玛诺洛斯"] = "Fh,懐英",["克尔苏加德"] = "Fh,一米两个球,五个图腾,血窝窝头,丿开嗜血灬;Fg,Ainzooalgown",["格瑞姆巴托"] = "Fh,圈圈丶二意,怀中抱妹殺丶;Ff,丶暖小若;Fe,氵波涛汹涌氵,硬札;Fd,一个灵活胖子;Fc,羽弥;Fb,常州大恐龙;Fa,红豆凉;FX,墨唐魑魅,奥德莉娅",["白银之手"] = "Fh,多多是欧皇,咪七甘八卦,朵拉丶风行者,瘦蛋儿,狮王之傲旅店,欲灬沉香;Ff,琳菀;Fe,鱼晖;Fd,辟邪丶,狡猾的阿不思,青衣颜;Fa,无敌裁决者,堸吹稻花香;FZ,就不要想起我,管住嘴迈开腿;FY,楓夜;FX,木槿兮年;FW,欧浅浅",["布兰卡德"] = "Fh,碳烤咕咕",["末日行者"] = "Fh,墨竹青衫,圣光的正义啊;Fg,卧梅幽聞花;Fd,狂蜂乄浪蝶,枫羽沫;Fc,丶阿破克列;Fb,妹纸的法丝;Fa,嘴角的发丝",["伊森利恩"] = "Fh,弥黯,諾夏,逗牛洋芋儿,|那夜|;Ff,那乄夜;FX,灬柠檬丶咖啡;FW,卡梅隆,Lancoo",["???"] = "Fh,昨天的秀妹子,陈阿飞,夜霜之哀;Ff,王寨村话事人;Fe,诗丨画;Fb,丶摩擦丶;Fa,狮心;FY,九里外的风车",["亚雷戈斯"] = "Fh,化野红绪",["阿古斯"] = "Fh,焦糖土豆;FY,可米小胖子,可米小丸子",["血色十字军"] = "Fh,扬州奶多哦;Fe,阿瑞斯丶;Fd,獸人獵;FY,两仪丶;FW,Charprime,飞妖兒",["奥蕾莉亚"] = "Fh,慕雪蓝采薇",["燃烧平原"] = "Fh,Horrorsword;Fd,听雨丶;Fa,;FZ,;FW,回不去的风筝",["迦拉克隆"] = "Fh,忽悠你啥了,Averager,大抱歉牧,山丘之傲;Fg,Ambrosed;Fa,一对牛角",["利刃之拳"] = "Fh,七七酱,地狱中最帅",["白骨荒野"] = "Fh,新人中单;Fb,丨独影丶",["万色星辰"] = "Fh,花落满肩",["迅捷微风"] = "Fh,Moscatel,雨夜丶菲菲;Fg,让本宝宝先撤;FZ,熊猫媛媛;FX,乄一条小熊猫",["阿纳克洛斯"] = "Fh,小野蠻;Fg,哞哒哒;Fe,我欲乘风破浪;Fb,一盘溜肉段;FZ,青峰小乔木",["罗曼斯"] = "Fh,临风望抒;Ff,虔诚的单手剑",["奥尔加隆"] = "Fh,光泡泡;Fg,奥利奥可爱多;Fa,拼多多;FY,雪柯基",["影之哀伤"] = "Fh,静水蓝蝶,敏捷的阿昆达;FZ,人間不值得;FW,七月半",["安苏"] = "Fh,|翊恒|,当歌惊鸿,牛将军丶老刘,成无情;Ff,怪味狐臭,心静自菩提;Fe,乄血匕;Fc,弯不下腰;Fa,第五正;FW,丶戎馬书生",["沙怒"] = "Fh,名字很好取",["国王之谷"] = "Fh,敲你丫的;Fg,红丶小白;Fd,丿灬枫之影,枫羽沫;Fb,月色猫爪子;FZ,月儿寶貝;FX,洅雲端;FW,瑞文丶戴尔",["诺兹多姆"] = "Fh,Seelasslgo;Fb,Bluefox",["破碎岭"] = "Fh,老歌;Ff,慕行;Fd,网瘾少年;FY,Turbowarrior",["暮色森林"] = "Fh,古伊娜;FX,夜雨风情",["希雷诺斯"] = "Fh,殺生;FW,小程",["阿比迪斯"] = "Fh,谈指红颜老",["伊瑟拉"] = "Fh,Chy",["烈焰峰"] = "Fh,七念",["卡德罗斯"] = "Fh,丨仅等于狼丶",["雏龙之翼"] = "Fh,安静",["千针石林"] = "Fh,釺羽千寻,釺羽;FW,天佑丶复生,天佑丿复生,天佑丨复生",["森金"] = "Fh,赤道",["血环"] = "Fh,我是大丁丁;FW,",["古尔丹"] = "Fh,丨风雨飘瑶",["银月"] = "Fh,不甜;FW,绽花儿",["山丘之王"] = "Fh,击溃油王;Fe,紫袖幻浮生",["艾露恩"] = "Fh,超甜豆浆;Fc,莉娜巴恩斯",["奎尔丹纳斯"] = "Fh,姬血冷清",["密林游侠"] = "Fh,舞玲珑;FZ,甲乙丙丁",["狂热之刃"] = "Fh,加尔鲁什;Fg,打瞌睡的阿噜",["阿尔萨斯"] = "Fh,狰狞",["Illidan[US]"] = "Fh,Yohaa",["雷斧堡垒"] = "Fg,悟空大老爷",["德拉诺"] = "Fg,血嫣寒影;Fb,大香菇",["天空之墙"] = "Fg,我有我方向;Fd,假面死骑;FY,我爱平底锅",["寒冰皇冠"] = "Fg,范海訫",["壁炉谷"] = "Fg,Lucifeer;Fd,冰豬丶",["遗忘海岸"] = "Fg,沉默之石,乌伤郡",["伊莫塔尔"] = "Fg,沙耶之歌",["红云台地"] = "Fg,暗夜之瞳;Fb,伦仔",["冰霜之刃"] = "Fg,今夜我唠叨了;FW,时过境迁,房飞冯",["蜘蛛王国"] = "Fg,冰之苍月",["卡拉赞"] = "Ff,丶陌;FX,古魔法師",["恶魔之魂"] = "Ff,二逼梁斌;FY,Cancel;FW,镜影",["埃德萨拉"] = "Ff,白夜阑珊,公巴佩丶;Fe,Danaiki;Fc,剑隐锋藏;FX,带带大猪蹄子;FW,九枭",["黑铁"] = "Ff,摇滚大橙子,南岸青栀;FZ,凭实力送人头",["银松森林"] = "Ff,Dfgs",["冰川之拳"] = "Ff,流沙之城",["鬼雾峰"] = "Ff,山石大哥;FX,天空繁星点点",["厄祖玛特"] = "Ff,冰蓝丶;Fa,Warcraf",["巨龙之吼"] = "Ff,韩枫",["毁灭之锤"] = "Fe,贵灬妃,莽灬子,戏灬子;FX,德了吧德了",["羽月"] = "Fe,那个灬胖子",["太阳之井"] = "Fe,裂膝;Fd,贾纳尔的图腾,贾纳尔的牺牲,贾纳尔的变化,贾纳尔的冲锋",["提克迪奥斯"] = "Fe,Yechuang",["耳语海岸"] = "Fe,圣光灬逆袭;FX,你觉得怎么样",["安其拉"] = "Fe,乄媚姬乄",["地狱之石"] = "Fe,一泶荻锎一",["伊利丹"] = "Fd,霜之利刃",["扎拉赞恩"] = "Fd,涂安玲;FZ,富江富江富江",["暗影之月"] = "Fd,火儛丶;FZ,亚纪人,文盲",["巫妖之王"] = "Fd,Mamson",["风暴之眼"] = "Fd,半点白",["守护之剑"] = "Fc,魔傀;Fa,Booth",["莱索恩"] = "Fc,大仙楚兮",["红龙女王"] = "Fc,霜语冰舞",["奥特兰克"] = "Fc,九尾明曰奈",["回音山"] = "Fb,我丶老李师傅;FW,油腻咖",["血顶"] = "Fb,维克雷斯夫人",["纳沙塔尔"] = "Fa,鬼魅丶",["鹰巢山"] = "Fa,封稀冰",["艾森娜"] = "Fa,钢然妞妞",["海克泰尔"] = "Fa,黑锋党委书记;FX,呆牛扛不住,红猫丶,十爱九离,雨林雨林",["斩魔者"] = "Fa,剑影;FX,一个好爸爸",["玛法里奥"] = "Fa,灬树",["布莱克摩"] = "FZ,Communist",["斯坦索姆"] = "FZ,我真是哔了咕",["雷霆之王"] = "FZ,暴怒的猫老大",["爱斯特纳"] = "FY,浮城旧事丶",["黑暗之门"] = "FY,哥当时就怒了;FW,抓栏杆撕床单",["战歌"] = "FY,孟丶子义",["卡德加"] = "FY,造粪机",["阿迦玛甘"] = "FY,Dmoon",["萨尔"] = "FX,大青山;FW,熵魔張叁豐,黑丶执事",["金色平原"] = "FX,君莫思归",["翡翠梦境"] = "FX,拂晓丶炽焰",["迦顿"] = "FX,犹她",["埃苏雷格"] = "FX,寒夜清宵",["霜之哀伤"] = "FX,安得文",["阿曼尼"] = "FW,耳火弓长",["熔火之心"] = "FW,咕德喵咛",["戈提克"] = "FW,安心油条"};
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