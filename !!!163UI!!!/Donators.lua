local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,释言丶-伊森利恩,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,戦乙女-霜之哀伤,橙阿鬼丶-达尔坎,站如松-夏维安";
local recentDonators = {["奥特兰克"] = "FR,曲江丶张雨绮;FM,帝王根疗,逗你玩的小舞;FJ,狮灬心",["白银之手"] = "FR,沥血以书;FQ,冷若风霜;FO,冰之女王;FN,妖唁祸众,好大的咸鱼,陌梓若;FM,一慕倾城丶;FL,潘达沙,乌撒之猫;FK,郑爸爸,丶隔壁老李,可伊丶,締造者、奧丁,求你个大头鬼,楓吹稻花香;FJ,偷瓜的猹;FI,信仰之路,我丶冲锋;FH,圣光玫瑰;FG,小酒窝儿,铁齿狗,碧水云寒,歆语风,雷凡勒,丶佛本是道;FF,懒羊羊乀,懒羊羊丿,夜雨青柠",["海克泰尔"] = "FQ,表哥萨,不是算了我的,光哥不带撇;FM,小熊软卷儿,翊悠然;FJ,挚爱丿灬孔;FI,吾名灬天佑;FF,制裁武僧",["回音山"] = "FQ,骁诺;FG,噬魂邪魔;FF,基围蝦,血色小萝莉",["贫瘠之地"] = "FQ,丨伱涛哥;FO,无畏无悔;FM,Yych,戰爭大领主;FL,北生淮枳,丿你瞅啥;FJ,沫见鱼;FI,桔子骑士团",["塞拉摩"] = "FQ,Libertyy",["霜狼"] = "FQ,卡得假;FP,绀野纯子",["德拉诺"] = "FQ,淡月柔云",["风暴之眼"] = "FQ,Crysta",["死亡之翼"] = "FQ,震天魔神;FP,潜行犭且击,血舞残月;FO,高配任达华,盲人协会会长;FN,黑麦咖啡,Kylianmbappe,墨宇尚道;FM,西瓜猎杀土豆,翊悠然;FL,杨柳依雨雪霏;FK,小丶宇;FJ,牛肉的遗志;FI,凯特琳;FH,叫我小奶就好;FG,梅丶小月,看偶眼色行事,什么什么丶微,鬼泣丶但丁;FF,怒罗美",["影之哀伤"] = "FQ,兰克;FP,Silviowls;FN,被驯服的大象,死骑特烦恼;FL,有点乖耶;FJ,天丷呐丶;FH,小青春灬月泽,卌铁丶蛋卌;FG,貌似柯基;FF,夏月丶,曾经旳猫爷",["无尽之海"] = "FQ,瀡浲;FP,洒丨仙;FN,天神李宇春,米小芽;FK,怕猫的哈士奇,Zorrol;FI,幽灵恶魔;FG,阿威十八式丶;FF,只喵",["永恒之井"] = "FQ,斩春;FP,Sparky;FG,Liana",["迦拉克隆"] = "FQ,诸神丶黄昏",["暗影迷宫"] = "FQ,覆盆子,提子",["狂热之刃"] = "FQ,小夜猫子;FK,吥四;FG,赤脚大贤,獅心之怒",["???"] = "FQ,唯怜幽独;FP,丘丘书豪;FN,知道胖,萌音回旋丶;FM,桑德兰虾饺丶;FL,动静皆萧杀;FJ,思念丨随風;FH,香山渊虹",["阿古斯"] = "FP,嗨呀好气阿;FO,暗影利箭;FN,放糖不起门;FK,悦詩風吟,淡雅香;FG,咾魔,丨王者之风丨",["风暴之怒"] = "FP,小贝、霓裳;FK,古瓜;FJ,西北雨;FH,小贝霓裳",["熔火之心"] = "FP,Botticelli;FF,烽火战神",["主宰之剑"] = "FP,糖盒;FO,冰封己心;FL,兎兎丶;FJ,獵小呆;FI,丨赤炼丨;FH,大孬依然给力,雨笑尘;FG,简㨮奥斯汀",["伊利丹"] = "FP,黏黏怪呀;FH,泪过一一无痕;FF,凤栖梧丿猎手",["雷斧堡垒"] = "FP,咸窝虾面;FG,Qomolangma,滋阴壮阳",["深渊之巢"] = "FP,小舅子",["罗宁"] = "FP,源稚女丨,帅到不要脸;FO,无尽灾厄;FN,请你安排我;FM,噩梦凋零;FL,艾莉婕丶;FK,古灵丶柒夜,北极星姐姐;FJ,冫釒丶;FI,门前大桥下,夜晚好无聊;FF,狂野的柯基,妡喵酱",["桑德兰"] = "FP,魔界妖皇;FF,热拿铁跳舞",["克尔苏加德"] = "FP,韩茜茜的凝视;FO,璀璨星光之翼;FI,血之艺;FH,范狄赛児,来一个前空翻",["凤凰之神"] = "FP,灰灰的小灰机,淡忘的荣耀;FO,丶望南笙箫断,丶顾北清歌寒,奔波儿子灞丶;FN,盗无情,安总丷;FM,无耻之刃,马匪;FL,緑光,抗旗拉车瞎,消失的肉嗞啦;FK,蓝色的雨,转折丨蕉哥;FJ,你叔叔,天山飞鸿惊樰;FI,末丶那识;FH,文凤,两清,鬼迷心窍丶;FG,惊声煎饺,鬼迷丶心窍,西西弗斯乄;FF,矮子王丶,二宁丶",["莱索恩"] = "FP,风起苍岚",["守护之剑"] = "FP,铁砧",["耳语海岸"] = "FP,佑右",["亡语者"] = "FP,倾国褒姒",["蜘蛛王国"] = "FP,流浪的狮子座",["安苏"] = "FP,阿尔法澎湃;FM,哦嗷嗷呜呜;FL,Memoirsx,肆叁叁;FK,帮帮龙;FJ,皮皮风神腿;FI,喊韩;FH,丶怡柔;FF,旎大侠",["冰风岗"] = "FO,张德彪;FM,黑白之间;FG,喜欢就去抢;FF,Missandei",["艾露恩"] = "FO,小饮料;FL,Lokik",["迅捷微风"] = "FO,梦境之塔;FN,高丽野阿吽;FM,剑仙;FK,婲爺丶",["克洛玛古斯"] = "FO,正经海带",["黑铁"] = "FO,瓜皮贼;FJ,尤莱卡,疯无邪;FI,雾晨;FF,丶丶冲田杏梨,太原人丶",["神圣之歌"] = "FO,清算",["熊猫酒仙"] = "FO,白晓晓,白米粒;FM,丶糖门蜀黍;FJ,料峭春寒,专杀死肥宅;FH,给我一个佳丶;FG,Komms",["麦维影歌"] = "FO,半点星图",["末日行者"] = "FO,夏亞亞;FN,酷丶安;FM,戴帽子的影子,脚踢嘤嘤怪,天涯灬氺莲,暁丽;FI,南城旧巷;FH,秦风无依;FG,玲玲夏",["天空之墙"] = "FO,冲破现实;FF,唐卿羽",["晴日峰（江苏）"] = "FO,舞夏",["国王之谷"] = "FO,月儿寶贝,阿尔梅利亚;FN,鲸鱼软糖;FM,鱼落鱼吃虾,海大壮;FL,丨古明地恋丨,淘气的两百斤;FI,黑铁骑士;FH,夏洛克灬聖手,Aixz,Bloodbane;FF,美少女岳云鹏,泼风",["血色十字军"] = "FO,斯汶;FK,咕呖,不解人奕,奶瓶妹;FJ,枫丨雪;FI,混沌桔子;FG,丶思念丶,橄榄,刀尖舔蜜,破折,诺娃;FF,懒懒陌小汐,冻米糖",["卡拉赞"] = "FO,暴躁小老弟",["阿拉索"] = "FO,你有多冻症;FI,风行雨落",["格瑞姆巴托"] = "FO,零度萤火;FM,黑魅丶,丸子龙;FL,小浆狗腿子,雷电蔓延;FJ,清风揽月;FH,昱锦,淡定的阿昆达",["加里索斯"] = "FO,Windboy",["图拉扬"] = "FO,黑豆泡饭",["伊森利恩"] = "FO,十二月晴朗;FK,爱吃蓝莓丶,鱼一;FJ,默小念;FH,为了妍女神;FG,迈了佛儿冷,好几百只喵,脆脆的胡萝卜;FF,拿不住,情不知所起丷",["索瑞森"] = "FO,社会主义好;FJ,浪漫巴乔四",["金色平原"] = "FN,巧莓奶渣;FG,守备官阿索卡",["火羽山"] = "FN,北凌",["血环"] = "FN,天之神羽,一个雪茄;FG,Luckycrit,忧郁吖;FF,Moroes",["灰谷"] = "FN,远南",["苏塔恩"] = "FN,糯米圆子",["达纳斯"] = "FN,未聞花名",["冰霜之刃"] = "FN,冰蓝之手;FK,灬麦兜灬灬",["丽丽（四川）"] = "FN,拥抱虚空;FM,黄胖胖丶,邾城胖胖;FJ,晓柯",["鬼雾峰"] = "FN,一馬當先",["红龙军团"] = "FN,Intoxicating,一巴粒死你;FG,罓皿罓,珞珈山下",["黑暗虚空"] = "FN,蓝影龙;FL,我要玩咕咕",["燃烧之刃"] = "FN,丰泽小不服;FM,獵靈魂;FL,焚香祭鬼,朕刺尔等无罪,薛山山,薛慢慢;FJ,Amberlight,欧米加北塔;FI,甴曱;FH,萍乡炒粉,有趣丶;FG,疯人願,先疯通缉犯,发骚的院长;FF,温柔的小萌,飘流的北风",["阿曼尼"] = "FN,强壮的阿昆达;FF,卡屯",["龙骨平原"] = "FM,秃逼难博丸;FI,我只来品包的",["太阳之井"] = "FM,血涩|浪漫",["大地之怒"] = "FM,仁丶",["亚雷戈斯"] = "FM,青红造了个白;FH,摩挲云影",["达文格尔"] = "FM,Soos",["破碎岭"] = "FM,Velen;FJ,德尔丶嘿",["巴瑟拉斯"] = "FM,血小溅",["斯克提斯"] = "FM,白色液体",["血吼"] = "FM,叶无声;FI,空车",["诺兹多姆"] = "FM,克立林舒肤佳;FH,一程程一",["阿尔萨斯"] = "FM,炎涛白燎莽;FK,弦断曲终",["阿拉希"] = "FM,勇气之心;FH,我看见你们了",["玛里苟斯"] = "FM,篠田步美;FJ,宁波射手王",["梦境之树"] = "FM,贤六;FJ,琼恩雪諾;FH,悲鸣云图",["暗影之月"] = "FM,七小囍",["通灵学院"] = "FL,翩若驚鸿;FK,情瘦",["摩摩尔"] = "FL,自闭的裂魂",["翡翠梦境"] = "FL,温柔小剑",["远古海滩"] = "FL,我乃一隻大雕",["山丘之王"] = "FL,夕阳红老萎萎",["萨菲隆"] = "FL,叫我王有容",["月神殿"] = "FK,晴天",["巨龙之吼"] = "FK,达斯叮苟",["霜之哀伤"] = "FK,戦乙女;FI,亚瑞特之怒;FG,玲冬丶",["刺骨利刃"] = "FK,狂澜丶",["布兰卡德"] = "FK,小弘哥;FJ,Lyuuke;FI,对此漫嗟荣辱,蘭华;FG,回首凉云幕叶;FF,秀众生而为言",["壁炉谷"] = "FK,爱上雨天;FJ,阿尤米",["加兹鲁维"] = "FK,引诱天使,茜熙;FG,肚子好难受;FF,奶亦能打",["希雷诺斯"] = "FK,组我不缺德",["末日祷告祭坛"] = "FJ,淡墨素笺",["石爪峰"] = "FJ,Gallardo",["萨洛拉丝"] = "FJ,胡馬依北風",["恐怖图腾"] = "FJ,费老",["符文图腾"] = "FJ,格氏栲;FH,萌萌灬触手;FF,全场八五折",["埃德萨拉"] = "FJ,箭隐锋藏,劔隐锋藏;FH,人在做咕在看;FG,刘小椛",["哈卡"] = "FJ,索澜莉安",["耐奥祖"] = "FJ,夜半鬼敲门",["万色星辰"] = "FJ,发福蝶",["恶魔之魂"] = "FI,傻小蛮",["闪电之刃"] = "FI,丶加藤鹰之手",["风暴之鳞"] = "FI,邪能洪流",["玛法里奥"] = "FI,天堂向左,相忘巛江湖",["甜水绿洲"] = "FI,静听花儿开",["战歌"] = "FI,神棍局局长;FG,永夜;FF,心变宁静海",["阿纳克洛斯"] = "FI,素稳",["达斯雷玛"] = "FH,古河早苗",["雏龙之翼"] = "FH,赏心",["阿迦玛甘"] = "FH,陌上公子",["燃烧平原"] = "FH,沐雨仟痕",["斩魔者"] = "FH,黄泉果实",["鲜血熔炉"] = "FG,拥晚",["埃苏雷格"] = "FG,彩虹幻熊",["古尔丹"] = "FG,无敌芊芊",["希尔瓦娜斯"] = "FG,特级出品人",["影牙要塞"] = "FG,欧德凯",["金度"] = "FG,二猴,二扣",["加基森"] = "FG,萌萌的貓貓",["千针石林"] = "FG,Alongtwoa",["遗忘海岸"] = "FG,青山随云走",["达尔坎"] = "FG,快跑吧小红帽",["扎拉赞恩"] = "FG,魔兽玩家",["激流之傲"] = "FG,圣律辛多雷",["诺莫瑞根"] = "FG,小仙嫂,菊爆小分队",["卡珊德拉"] = "FG,愫、",["艾莫莉丝"] = "FG,木棉花,麦哲伦",["米奈希尔"] = "FG,开始狩猎",["安东尼达斯"] = "FF,阿马欧也",["黑翼之巢"] = "FF,Crya",["杜隆坦"] = "FF,香莲",["火焰之树"] = "FF,晨儒梦",["奥妮克希亚"] = "FF,封尘老鱼",["艾萨拉"] = "FF,榆树钱",["风行者"] = "FF,Sands",["风暴峭壁"] = "FF,萝卜先生"};
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