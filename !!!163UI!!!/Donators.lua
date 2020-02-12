local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["神圣之歌"] = "MT,妞奈蜜柚可",["贫瘠之地"] = "MT,有味清欢;MS,天知遥,灬孤雨寒烟灬;MR,太阳伊布;MQ,涯枭的魔猎;MP,别薅我头发,灬尛霞灬;MM,舞杀,涯枭的猎;ML,霸气丨豪门,白羊座灬若涵,洛丹沦的夏天",["伊森利恩"] = "MT,思舟丶;MS,楚地无歌;MO,Mujn;MN,萌萌的尐熊猫;MM,柒柒肆;ML,一颗闪耀的仔,不会不练;MK,灬梧桐、;MI,墨雨纸鸢丶",["诺森德"] = "MT,元気蛋",["死亡之翼"] = "MS,陌笙灬,神乐花火,禾子同学;MR,突破極限,宫泽礼,未央啊;MQ,杜海涛;MO,妄念啊;MN,Dk,二一二;MM,爱上耗子的猫;ML,嗳人丶,创世;MK,一包面巾纸,阿扶扶;MJ,茶叶蛋布偶;MI,大鱼乄",["凤凰之神"] = "MS,火玫丶,轻点我怕疼;MR,丷槑槑的善若,如何回忆妳,康納麦格雷戈,小丶尾,十方霞涌;MQ,锦鲤乁,树熊鸟猫鱼;MP,兔子追猎者,堕落灬夜殇,繁华灬落幕,柠檬红丿;MN,汤尼与兔子;MM,Potency,丷小豆浆;ML,来世再续前缘,白鱈鱈,鑫灶沐炙;MJ,一奶奶,揪啾啾,氷月風華;MI,清艾",["蜘蛛王国"] = "MS,小呆立",["千针石林"] = "MS,暴走枪手",["燃烧之刃"] = "MS,暴燥的五花肉,司丽丽;MR,哎丨曰后再说;MQ,团长想害我,野生西瓜君,毛毛丶雨;MP,萨尔大帝,快乐小周,黄汤灌汝口;MO,大雨,博吉尔灬莫瑟,丨半泽直树,Bloodrex,星语梦綾,杰尼龟丶丶;MN,萌宠饲养员;MM,Jesiy;ML,软儿梨,三界,扶尸,禄卢;MK,淡淡冰语,無她,泰岚德丶怒风;MJ,卤面条;MI,好软好舒服",["万色星辰"] = "MS,混子丶",["格瑞姆巴托"] = "MS,伊利丨,牛德华丿;MR,奶凶奶凶嘚丶,懒敷敷小公主,塔蘭吉小公主;MQ,你的阿超;MP,小狐妮,Winslet,江西熊;MO,纯甄牛奶丶,一把枪手,离地三厘米,安娜丷,清风少年,胖胖嘚文哥丶;MN,宣武永存丶;MM,忘了所有公式,悄悄抱着你;ML,王大勺;MJ,小白白就是我;MI,Aghora",["克尔苏加德"] = "MS,新手卖萌",["安苏"] = "MS,十八點五,胡同里的貓;MR,戒吥掉丶,丿丶圣光,感受虚无,落雪夏觞,丶孙燕姿,丨莉莉丝灬,雪萤折鹤;MP,鏖战镇魂曲,陌生人丶;ML,卧龙武帝丷,柠檬酸呀酸;MK,桃花朵朵儿",["布兰卡德"] = "MS,炫酷灬肉粽;MQ,猛面小蕉蕉;MO,有一点性感;MN,丿陌陌彡;MM,盗賊;MJ,Artemisr",["主宰之剑"] = "MS,简宁,椛間壹壶酒,北丨境;MR,徵羽丨,战吼奥丁丶;MP,巪石丶强森;MO,只要半糖丶;MN,美女轻点;ML,那小子真逗;MJ,那小子真猛,那小子真狂",["山丘之王"] = "MS,罗诺比;MP,凹粑马",["丽丽（四川）"] = "MS,泡泡人;MR,吾在我;MO,那些遗失的梦,李知恩丶;MK,龙梅尔;MJ,厨子丨",["莱索恩"] = "MS,香啵啵;MO,Tianna",["白银之手"] = "MS,安眠藥,核桃空空;MR,祈梦星;MQ,坠落幻想,王大车,玛丽贝贝尔,小德雅,奥尔邪邪雅;MP,可耐,车头你不配丶,丶百变星君丶;MO,七彩熊,持度,元宝的姑奶奶,若即若离,干净;MN,爱新觉罗梦,怪只打队友;MM,维他什么奶;ML,爸爸粑粑,坠月之歌,渔得鱼,左手舞冰火,陌风;MK,青衫丶白衣,巧楽兹,浩小劫,牧之白,艾尐希;MJ,治療,飞奔的凯撒",["梅尔加尼"] = "MS,兔子的绒毛",["石爪峰"] = "MS,潆澈;ML,不老峰传人",["菲米丝"] = "MR,治疗别奶我;MO,Doge",["晴日峰（江苏）"] = "MR,乄丶丶龘丶",["麦维影歌"] = "MR,丨丶丨丶凹凸",["影之哀伤"] = "MR,可小白,丶山新;MQ,裂地神牛;MO,梦惊婵巛;MN,青龍灬贰爺;ML,阿尔托丽雅;MK,飞花丶",["玛里苟斯"] = "MR,百特曼;ML,秘制小龙虾",["暗影议会"] = "MR,紫慯",["红龙军团"] = "MR,Anathan;MK,無形中狠蒗",["基尔加丹"] = "MR,阿娣",["国王之谷"] = "MR,幕乡;MQ,夜弦朝歌丶;MP,月满星怒;MO,胖胖嘚文哥丶;MN,麦迪娜;MM,唁风,疯瘤涕躺;ML,董老湿;MJ,裴老湿",["风暴之鳞"] = "MR,Breezee;ML,鹌鹑丶莫扎特",["???"] = "MR,奥丽芙,泡沫咖啡;MQ,低调灬圣光;MN,放放速度放了;MK,小狐僧",["迦顿"] = "MR,菠萝催血",["狂热之刃"] = "MR,更美好的幻想;MP,收二手彩电;MN,大煎饼铺子;ML,布兰爱睡觉;MI,Pramanix",["金色平原"] = "MR,煞窦布惠;MN,神丨智勇,彼得诺夫;ML,男人就玩藏剑,蕾娜丶月歌;MK,瓦捷特",["回音山"] = "MR,战寒热;MQ,海鸣威;MP,城南忆梦;MM,貊幽;ML,住在大菠萝里;MK,苏两七",["亚雷戈斯"] = "MR,伊利安丶逐曰;MO,文体两开花",["远古海滩"] = "MQ,阿历小妖静;MJ,张楚岚;MI,空城丨旧梦",["壁炉谷"] = "MQ,關我屁事",["太阳之井"] = "MQ,路飛",["熊猫酒仙"] = "MQ,道痴叶红鱼,蒲以嘟;ML,盐与香辛料;MI,大菠菜",["霜之哀伤"] = "MQ,旧顏色;MK,不知所以",["血色十字军"] = "MQ,飘逸的大胸毛,高里卡布列夫;MN,豆子鱼;MM,Korhal;MK,梧叶笺;MJ,嘟哒哒冒蓝火;MI,鸡肉石锅拌饭",["龙骨平原"] = "MQ,汕水有相逢;MK,怒海狂明",["无尽之海"] = "MQ,蒜香榴莲,风暴灬之魂;MP,乱世冷风,跑者;MO,粗野;MN,大萌斌仔;MM,徐大骚;MK,大梦斌仔,人參菓",["血吼"] = "MQ,萧瑟勿语",["甜水绿洲"] = "MQ,茶里荼靡",["血环"] = "MQ,云雾散;MO,墨鸦",["阿比迪斯"] = "MQ,萨利休斯;MI,光阴荏苒",["巨龙之吼"] = "MQ,库库噜,库噜噜,库噜库噜",["诺兹多姆"] = "MQ,璀璨的薛迪凯,璀璨的武僧;MN,丨暮雪丨",["黑铁"] = "MQ,黒丶脚;MN,沐阳爸爸",["通灵学院"] = "MQ,馥芮白;MJ,蔡徐坤丶",["燃烧军团"] = "MQ,女寝的男鬼",["冰风岗"] = "MP,肥喵爱吃鱼,穆丨偶,萌萌奶萨,听风的歌,银月小茉莉,露露柠檬,Iupl;MO,初号肌丶;ML,小红馒头灬;MI,腐蚀漫天",["迦拉克隆"] = "MP,馬忠賢;MO,安薇娜",["扎拉赞恩"] = "MP,不明觉厉丶,不明觉厉;ML,Atanvardo",["罗宁"] = "MP,何欢,爱哭的胖纸;MO,红昭丶愿;MN,不锈钢键盘;MM,炭烤胡子,小猪猡,爱哭的胖子灬;ML,地狱丶圣光;MK,佩劍高歌;MJ,苏青丝;MI,暴走的大臭",["鬼雾峰"] = "MP,乂戰宇乂",["轻风之语"] = "MP,牧里鱼;MJ,星夜绫",["翡翠梦境"] = "MP,Passerby,我没有远方;MJ,黄泉引路人",["风暴之怒"] = "MP,贼灬",["雷斧堡垒"] = "MO,薄凉尽昏晓",["阿古斯"] = "MO,冬天猫",["戈古纳斯"] = "MO,摇曳的胡椒,燃烧的胡椒",["加基森"] = "MO,一伙大家伙",["迅捷微风"] = "MO,依然杜哥;MN,丶龘將",["伊利丹"] = "MO,發財兽",["熔火之心"] = "MO,北新桥砍刀王;MK,冲锋释放鬼才",["斯克提斯"] = "MO,不要捣乱",["暗影之月"] = "MO,辉煌圣光闪耀",["塞拉摩"] = "MO,凯尔希钢蛋;MM,虐弑",["尘风峡谷"] = "MN,护短",["古加尔"] = "MN,疯狂情话;MK,单程车票",["麦迪文"] = "MN,小姐不美;ML,口子",["卡德加"] = "MN,裂魂丸",["末日行者"] = "MN,琉璃洸,哦丶法克;MM,你看着很美味,凌波微布;MI,我闪了",["守护之剑"] = "MN,小夏夏",["萨尔"] = "MN,Bruce",["海克泰尔"] = "MN,请带暖树上车;MK,Moulin,浮生諾夢;MJ,左手的阴暗",["冰霜之刃"] = "MM,Asmenethil",["埃德萨拉"] = "MM,卖酸牛奶的;MK,Holyhearts,遗忘的守卫",["血顶"] = "MM,丫丫小猫",["阿克蒙德"] = "MM,调皮的恩佐斯;MI,娜尔莉",["萨菲隆"] = "MM,Dk",["羽月"] = "ML,饭时已到",["奥特兰克"] = "ML,星月丶丶;MK,小钱钱真心甜",["夺灵者"] = "ML,很纯很暧昧丶",["破碎岭"] = "ML,傲娇的小圆手",["藏宝海湾"] = "ML,暗落",["桑德兰"] = "ML,肌肉帕尼尼",["阿纳克洛斯"] = "MK,暴躁外皮",["地狱咆哮"] = "MK,鬼吇丶",["海达希亚"] = "MK,小样贼逗",["激流堡"] = "MK,孟女",["遗忘海岸"] = "MJ,恐怖钕主角",["冬泉谷"] = "MJ,一秒的刹呐",["血羽"] = "MJ,戦士奉先",["亡语者"] = "MJ,符华上仙",["火焰之树"] = "MI,傲娇管四舅",["奥妮克希亚"] = "MI,夜半私语时丶"};
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