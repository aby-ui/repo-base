local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,魅影悠悠-菲拉斯,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔";
local recentDonators = {["安苏"] = "Eb,暮林晚枫,尘封之歌,瀛洲之光;EZ,暗夜的圣光;EU,逍遙劍",["红云台地"] = "Eb,汪汪大魔王;Ea,艹哥,亦寒,八稚女苍月;ET,妖怪爹爹",["贫瘠之地"] = "Eb,天雷渡劫,梦于你,如果那一次,Elunes,最后的丹丹;Ea,Momonin,李貝留嘶,咿唎丹怒風,叫兽、涛;EZ,奔跑的荣誉点,死肥宅奥利奥,萦十三,空白色丨丨;EY,闪现术,眉帶凶兆;EX,大力丶出奇迹;EV,幽幽花舞;EU,Darkwich;ET,八月",["伊森利恩"] = "Eb,淡墨无殇,动次打次动动,黑胡桃心,大耳朵亮亮;Ea,魔神丶,小妖紫晨;EV,小怪受丶;EU,卧底追风,斎藤飞鳥,我不是咕咕",["无尽之海"] = "Eb,有奶也不奶,丷菟丨灬珼珼;Ea,丶龙噬;EZ,绮梦成贞;EY,形意拳阿福;EU,暮雨",["巨龙之吼"] = "Eb,苍崎橙子的烟",["死亡之翼"] = "Eb,少年女性挚友,做饭的阿昆达,人狗双亡丶;Ea,Onslaught,星如海,影心灬;EZ,昼夜星辰,丨牧師丶,蘿蔔不是萝卜,北巷梦不夏;EY,有丶小雨,砍死人,萌萌哒演员;EX,Tyraeli,输出的阿昆达;EV,默默丶阿昆达;EU,Softpeach,贼棒,Tiss;ET,景漫漫丷,梅德库尔川,忆水月吶",["恶魔之魂"] = "Eb,大丑逼;Ea,幽灵戮日",["风暴之怒"] = "Eb,双月之夜;EU,黑桃小九;ET,自闭的阿昆达",["白银之手"] = "Eb,黑手,丶咚咚啵丶,河南王俊凯,Tenderkiss,Xqtrr,Acroyd;Ea,猫小闹,雾歌大魔王丶;EZ,下沙黄旭东,夜雨冰蓝,偷得半天闲;EX,冷月下的魂灵;EV,艾小路;EU,浮生忘流年,深圳鱼帥,幻城丶风雨,圆圆的肉丸;ET,秋月春风丶,梦到一百万",["冰风岗"] = "Eb,白尾蓝猫;Ea,苞米地小飞侠,拆迁队队长,密林遊俠;ET,Onlysoso",["罗曼斯"] = "Eb,榴莲木有刺",["奥特兰克"] = "Eb,天下山河海;EZ,守护骑士丶;EY,Siga;EU,有丶儒雅随和,心斩灵魂,冷凝雪",["暗影之月"] = "Eb,不是不乖;Ea,潴麦",["凤凰之神"] = "Eb,叫你不带帽子,森森阿,最终的圆舞曲;Ea,丨死亡丨灬羿,丶丨英雄丨丶,东来丶,疾风乄残箭,山里有只喵,丶丿秋天灬,血恶弑神;EZ,卡姆九十六,小兮几,维内托;EY,面包师阿毛;EX,小墨、,Furyrain;EV,安菲尔德葵;EU,生气的四季豆,逐日丨鬼鬼,幼儿园之怒;ET,枷锁,彼岸的回忆",["艾萨拉"] = "Eb,黑钥什",["红龙军团"] = "Eb,巴伦支手术刀,卤本伟;Ea,吾南笙",["金色平原"] = "Eb,银月城少年,上官淼淼;EZ,虚空本源",["霜之哀伤"] = "Eb,小恶魔,冰封蓝语,詩月,菲歐娜;Ea,風見幽香",["血环"] = "Eb,枼子红了;EY,奶瓶弟弟;ET,性临春暖",["格瑞姆巴托"] = "Eb,红魔爆炎使丶,慕雅丶,丨花花灬牛,|小菜菜|,月夜丨微凉,训练场机器人,乌鸦先生,尨緢丶;Ea,Yuudachi;EZ,总在下雨天,卡尔佛兰茨,一之濑花名,伊纹;EY,哭晕在天台,年轻的皮皮魔;EV,希亚;EU,周大貓",["扎拉赞恩"] = "Eb,辕门浪子丿永",["月光林地"] = "Eb,Nemesisal;EZ,春风十里如梦,丶铁浮屠;EU,Macaria,皇太子",["冰霜之刃"] = "Eb,艺梦婧美错;EY,孙笑川的奶奶;EU,迷要;ET,虫丶二",["森金"] = "Eb,丨小花丨",["燃烧之刃"] = "Eb,芷丶宓;Ea,安德路吼吼;EZ,尐丶德;EY,丨老佛爺丶;EX,维生灬素素,丿樱木花道,伊丽丹,圣骑十,江诗丹顿;ET,阿笨牛,烈焰游侠",["熊猫酒仙"] = "Eb,可口泡菜,女口止匕舌甘;EY,小凡姑娘;ET,司辰",["桑德兰"] = "Eb,慌得一逼;Ea,狂野刺杀;EX,司马仲达;EU,初晨、",["安东尼达斯"] = "Eb,寒庐煮酒",["龙骨平原"] = "Eb,樱、吹雪;EZ,哆辣辣;EY,平平仄仄",["回音山"] = "Eb,孤独的传教士;Ea,德伊菲尔,筱雨菲菲;EV,空灵道;EU,诅咒的回响;ET,其修远兮",["埃德萨拉"] = "Eb,满地小黄瓜;EZ,星怜,菊丶魔;EX,上去开团;ET,惿里奥丶弗丁",["利刃之拳"] = "Eb,黑虎阿福;EZ,奔波儿爸;EV,小凤的十老婆",["加兹鲁维"] = "Eb,哀行者",["阿克蒙德"] = "Eb,达康书记丶",["血色十字军"] = "Eb,泠泠月上;Ea,大宝剑,三秒;EV,丨眸夜祭歌丨;EU,阿狸么",["夏维安"] = "Eb,忍者肥",["菲拉斯"] = "Eb,魅影悠悠,魔道刺青;ET,西域春",["罗宁"] = "Eb,深渊上的火;Ea,杰尼龟队长,画石,Neria;EZ,他改变了祖国,胖贼龙襄,老花椒丶,陈晨成,霜火挽歌,Disneymagic;EV,雾隐霜月天;ET,牛会长",["???"] = "Eb,善良的托尼,樱桃宝宝丶,奇坦丶血手;EY,超多魚;EX,橙默丶,不要这样子么;EU,杰宝宝丶,丢人丢惯了,快点开英勇丶;ET,耳语灬大雨点,灵打拯救世界,我叫李延志",["蜘蛛王国"] = "Eb,特莉絲",["巴纳扎尔"] = "Eb,喵喵球",["迅捷微风"] = "Eb,上上课睡了;Ea,抡臂大回环;EV,望天灬,霂阳,风霂阳;ET,嶙嶙",["末日行者"] = "Eb,寿司小兔子;Ea,含玉听白,桑诗爷;EY,血红新月;EV,秃头男;EU,灬良羽寒灬;ET,黑铁戰神,一点五梯",["影之哀伤"] = "Eb,劍盾同眠,翠云裘;Ea,Asadsdafdsas,暴躁的平头哥,浮生皆是梦;EZ,咿利丹灬怒风;EY,Lylirra;EX,饺子熟了;ET,咸鱼和远方,一花倾国相欢",["阿古斯"] = "Eb,艾瑞斯;EY,昱剑,青丶檸;EV,豹子头丶林冲",["火喉"] = "Eb,微光塵夏;ET,风月清幽雨",["熔火之心"] = "Eb,永恒德;EV,大胡子灬杨叔;EU,丨死亡丨灬羿",["诺兹多姆"] = "Eb,冬天猫",["图拉扬"] = "Eb,Jill",["基尔加丹"] = "Eb,冷梦雁叶",["能源舰"] = "Eb,零叁叁肆",["迪瑟洛克"] = "Eb,走路骚会闪腰",["戈提克"] = "Eb,术术给你糖吃",["国王之谷"] = "Eb,夜雨茶微凉;Ea,藍月灬靈,冥獄執刑官;EZ,蹦蹦跳跳,独鲤;ET,教官的迪斯科",["弗塞雷迦"] = "Ea,半藏贼溜;EZ,丶兽兽",["永夜港"] = "Ea,丶阿牛",["嚎风峡湾"] = "Ea,冰之泪",["破碎岭"] = "Ea,Turbowarrior;EX,Mfro",["克尔苏加德"] = "Ea,大雨灬,萌小媌媌;EZ,明度;EY,你演个小猫把;EV,噬命丶肉偶;EU,Kroraina,太難得的香蕉",["霜狼"] = "Ea,猫熊猎手;EZ,夏望繁星",["风暴之眼"] = "Ea,虔诚丶挽风,霍青桐",["狂热之刃"] = "Ea,酷爱多,补兵一号;EV,我踏妈没疯丶",["迦拉克隆"] = "Ea,幻夜丶冰羽;EZ,风壹样的少年,你我是谁,盏酒慰风尘;EY,龙骑士丶;EU,霜天指环,潜小菠;ET,乐依罹,骑猪去兜疯",["永恒之井"] = "Ea,椰酥,莲酱的鱼;EZ,",["山丘之王"] = "Ea,只穿板夹;ET,Xantz",["玛里苟斯"] = "Ea,黑渊白花",["苏塔恩"] = "Ea,香坂时雨;EZ,慕斯奶盖",["丽丽（四川）"] = "Ea,智妍,Odpriest,不要集火我丶;EV,十二快蓝娇",["石爪峰"] = "Ea,最后的丶轻语;EX,退役吹比选手",["布兰卡德"] = "Ea,收长头发啊;EZ,爱不易,客官丷丷;EY,我爱七喜丶,Titanshost;EV,老舅;EU,孫悟飯",["雷斧堡垒"] = "Ea,希爾瓦娜斯拉",["艾露恩"] = "Ea,快乐咕咕宝宝",["荆棘谷"] = "Ea,悟达尔",["奥尔加隆"] = "Ea,夏姬八砍;EX,王二寒",["激流之傲"] = "Ea,别在红圈里打;EY,折棠",["天空之墙"] = "Ea,林丶熙娜;EY,徐瑾欢",["巫妖之王"] = "Ea,吃菜;EZ,开放的少女,Arés;ET,Whisperfish",["鬼雾峰"] = "Ea,Ibot;EZ,听岚丶;ET,泪已成霜",["羽月"] = "Ea,Damnit",["黑石尖塔"] = "Ea,二月丶逆流",["守护之剑"] = "Ea,鸾跂鸿惊;EV,月飘零",["梅尔加尼"] = "Ea,聆羽",["神圣之歌"] = "Ea,云岚",["世界之树"] = "Ea,丷灬粉墨丶乀;ET,路连城",["雷霆之怒"] = "EZ,轻风物語;EV,一头大鹅",["壁炉谷"] = "EZ,糖门",["幽暗沼泽"] = "EZ,卩灬阿飞;EX,格里菲因丶;ET,闲朝暮信归途",["黑龙军团"] = "EZ,疆还是劳道辣;EX,疆君",["主宰之剑"] = "EZ,李大佬,零鹰,罗兰丶影歌,炭烧乌龙茶,苏白大大,死亡佩琪;EY,君不劍,丷九月;EU,諾灬靈",["伊瑟拉"] = "EZ,米汤;EX,阿曼苏尔丨芬",["阿拉索"] = "EZ,影帝谢霆锋",["雏龙之翼"] = "EZ,白玉京,鹤顶红丶",["铜龙军团"] = "EZ,哈士骑",["库德兰"] = "EZ,东门斩兔",["萨菲隆"] = "EZ,凝望深渊丶;EX,李小胖;EU,打劫小排骨",["海达希亚"] = "EZ,速风语者",["盖斯"] = "EZ,Reborny",["熵魔"] = "EZ,一世琉璃白",["奥杜尔"] = "EZ,单车龙",["银松森林"] = "EZ,伊利二雷",["达文格尔"] = "EZ,逅邂若恍",["朵丹尼尔"] = "EZ,非洲脱贫酋长;ET,就怕贼惦记",["风行者"] = "EZ,希尔瓦娜斯;ET,没留胡须",["祖阿曼"] = "EZ,安静的葡萄;EX,意得",["日落沼泽"] = "EZ,木尸小玉,半藏为玉效命",["黑铁"] = "EZ,千万战痕,Emhunter;EY,Hatsuduki,天莽;EX,致命安魂曲",["海克泰尔"] = "EZ,壹箭倾心",["埃苏雷格"] = "EZ,怒斩人间愁",["耐奥祖"] = "EY,Hegemon",["血牙魔王"] = "EY,白大锤",["雷霆之王"] = "EY,哎呀有蚊子;EX,伊利达雷公主",["塞泰克"] = "EY,沐灵云",["艾莫莉丝"] = "EY,来自西班牙",["符文图腾"] = "EY,嗜血熊熊",["雷克萨"] = "EY,辩机",["战歌"] = "EY,联合国主席;EX,Skrillex",["亚雷戈斯"] = "EY,哀傷之觸",["范克里夫"] = "EX,往往倦后",["生态船"] = "EX,天地茫茫",["冰川之拳"] = "EX,蛀牙很不爽",["金度"] = "EX,挽手说梦话",["伊兰尼库斯"] = "EX,炸不干的油炸",["万色星辰"] = "EX,优优鸣天箭",["耳语海岸"] = "EV,若汐,夏天;EU,祭月隐修",["加基森"] = "EV,隔代有佳人",["烈焰峰"] = "EV,左右",["恶魔之翼"] = "EV,天季的云",["暮色森林"] = "EV,Gourdsnow",["奈法利安"] = "EV,凌波喵步",["玛诺洛斯"] = "EV,动感小风",["基尔罗格"] = "EU,星尘大海",["普瑞斯托"] = "EU,牛牛的西北方",["伊利丹"] = "EU,Mikelan",["安威玛尔"] = "EU,桃之宝",["安纳塞隆"] = "EU,皮皮的邦桑迪",["火羽山"] = "EU,倾城乄堕落",["太阳之井"] = "EU,仲笠",["洛肯"] = "EU,德拉米尔",["试炼之环"] = "EU,枳花丶驿影",["通灵学院"] = "ET,陆荫杆霞",["阿尔萨斯"] = "ET,Cmelo",["斯克提斯"] = "ET,十点半睡",["翡翠梦境"] = "ET,荆棘刺环",["千针石林"] = "ET,艾尔的荣耀,|艾尔之光"};
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
                    table.insert(players, fullname)
                    player_days[fullname] = date
                    player_shown[fullname] = topNamesOrder[fullname] or 0
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