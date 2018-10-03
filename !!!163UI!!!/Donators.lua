local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔,落落萧萧-罗宁";
local recentDonators = {["龙骨平原"] = "EZ,哆辣辣;EY,平平仄仄",["雷霆之怒"] = "EZ,轻风物語;EV,一头大鹅",["壁炉谷"] = "EZ,糖门",["格瑞姆巴托"] = "EZ,总在下雨天,卡尔佛兰茨,一之濑花名,伊纹;EY,哭晕在天台,年轻的皮皮魔;EV,希亚;EU,周大貓",["永恒之井"] = "EZ,椰酥",["幽暗沼泽"] = "EZ,卩灬阿飞;EX,格里菲因丶;ET,闲朝暮信归途",["凤凰之神"] = "EZ,卡姆九十六,小兮几,维内托;EY,面包师阿毛,丶丿深水鱼灬;EX,小墨、,Furyrain;EV,安菲尔德葵;EU,生气的四季豆,逐日丨鬼鬼,幼儿园之怒;ET,枷锁,彼岸的回忆",["黑龙军团"] = "EZ,疆还是劳道辣;EX,疆君",["月光林地"] = "EZ,春风十里如梦,丶铁浮屠;EU,Macaria,皇太子",["国王之谷"] = "EZ,蹦蹦跳跳,独鲤;ET,教官的迪斯科",["主宰之剑"] = "EZ,李大佬,零鹰,罗兰丶影歌,炭烧乌龙茶,苏白大大,死亡佩琪;EY,君不劍,丷九月;EU,諾灬靈",["埃德萨拉"] = "EZ,星怜,菊丶魔;EX,上去开团;ET,惿里奥丶弗丁",["伊瑟拉"] = "EZ,米汤;EX,阿曼苏尔丨芬",["霜狼"] = "EZ,夏望繁星",["巫妖之王"] = "EZ,开放的少女,Arés;ET,Whisperfish",["死亡之翼"] = "EZ,昼夜星辰,丨牧師丶,蘿蔔不是萝卜,北巷梦不夏;EY,有丶小雨,砍死人,萌萌哒演员;EX,Tyraeli,输出的阿昆达;EV,默默丶阿昆达;EU,Softpeach,贼棒,Tiss;ET,景漫漫丷,梅德库尔川,忆水月吶",["阿拉索"] = "EZ,影帝谢霆锋",["雏龙之翼"] = "EZ,白玉京,鹤顶红丶",["弗塞雷迦"] = "EZ,丶兽兽",["鬼雾峰"] = "EZ,听岚丶;ET,泪已成霜",["安苏"] = "EZ,暗夜的圣光;EU,逍遙劍",["迦拉克隆"] = "EZ,风壹样的少年,你我是谁,盏酒慰风尘;EY,龙骑士丶;EU,霜天指环,潜小菠;ET,乐依罹,骑猪去兜疯",["苏塔恩"] = "EZ,慕斯奶盖",["铜龙军团"] = "EZ,哈士骑",["库德兰"] = "EZ,东门斩兔",["影之哀伤"] = "EZ,咿利丹灬怒风;EY,Lylirra;EX,饺子熟了;ET,咸鱼和远方,一花倾国相欢",["萨菲隆"] = "EZ,凝望深渊丶;EX,李小胖;EU,打劫小排骨",["罗宁"] = "EZ,他改变了祖国,胖贼龙襄,老花椒丶,陈晨成,霜火挽歌,Disneymagic;EV,雾隐霜月天;ET,牛会长",["海达希亚"] = "EZ,速风语者",["贫瘠之地"] = "EZ,奔跑的荣誉点,死肥宅奥利奥,萦十三,空白色丨丨;EY,闪现术,眉帶凶兆;EX,大力丶出奇迹;EV,幽幽花舞;EU,Darkwich;ET,八月",["盖斯"] = "EZ,Reborny",["熵魔"] = "EZ,一世琉璃白",["无尽之海"] = "EZ,绮梦成贞;EY,形意拳阿福;EU,暮雨",["金色平原"] = "EZ,虚空本源",["奥杜尔"] = "EZ,单车龙",["银松森林"] = "EZ,伊利二雷",["白银之手"] = "EZ,下沙黄旭东,夜雨冰蓝,偷得半天闲;EX,冷月下的魂灵;EV,艾小路;EU,浮生忘流年,深圳鱼帥,幻城丶风雨,圆圆的肉丸;ET,秋月春风丶,梦到一百万",["达文格尔"] = "EZ,逅邂若恍",["朵丹尼尔"] = "EZ,非洲脱贫酋长;ET,就怕贼惦记",["风行者"] = "EZ,希尔瓦娜斯;ET,没留胡须",["祖阿曼"] = "EZ,安静的葡萄;EX,意得",["日落沼泽"] = "EZ,木尸小玉,半藏为玉效命",["黑铁"] = "EZ,千万战痕,Emhunter;EY,Hatsuduki,天莽;EX,致命安魂曲",["克尔苏加德"] = "EZ,明度;EY,你演个小猫把;EV,噬命丶肉偶;EU,Kroraina,太難得的香蕉",["奥特兰克"] = "EZ,守护骑士丶;EY,Siga;EU,有丶儒雅随和,心斩灵魂,冷凝雪",["布兰卡德"] = "EZ,爱不易,客官丷丷;EY,我爱七喜丶,Titanshost;EV,老舅;EU,孫悟飯",["海克泰尔"] = "EZ,壹箭倾心",["燃烧之刃"] = "EZ,尐丶德;EY,丨老佛爺丶;EX,维生灬素素,丿樱木花道,伊丽丹,圣骑十,江诗丹顿;ET,阿笨牛,烈焰游侠",["埃苏雷格"] = "EZ,怒斩人间愁",["利刃之拳"] = "EZ,奔波儿爸;EV,小凤的十老婆",["激流之傲"] = "EY,折棠",["冰霜之刃"] = "EY,孙笑川的奶奶;EU,迷要;ET,虫丶二",["末日行者"] = "EY,血红新月;EV,秃头男;EU,灬良羽寒灬;ET,黑铁戰神,一点五梯",["血环"] = "EY,奶瓶弟弟;ET,性临春暖",["耐奥祖"] = "EY,Hegemon",["阿古斯"] = "EY,昱剑,青丶檸;EV,豹子头丶林冲",["血牙魔王"] = "EY,白大锤",["天空之墙"] = "EY,徐瑾欢",["雷霆之王"] = "EY,哎呀有蚊子;EX,伊利达雷公主",["熊猫酒仙"] = "EY,小凡姑娘;ET,司辰",["塞泰克"] = "EY,沐灵云",["艾莫莉丝"] = "EY,来自西班牙",["符文图腾"] = "EY,嗜血熊熊",["雷克萨"] = "EY,辩机",["???"] = "EY,超多魚;EX,橙默丶,不要这样子么;EU,杰宝宝丶,丢人丢惯了,快点开英勇丶;ET,耳语灬大雨点,灵打拯救世界,我叫李延志;EP,掏你裆,Darkcoow",["战歌"] = "EY,联合国主席;EX,Skrillex",["亚雷戈斯"] = "EY,哀傷之觸",["范克里夫"] = "EX,往往倦后",["桑德兰"] = "EX,司马仲达;EU,初晨、",["生态船"] = "EX,天地茫茫",["冰川之拳"] = "EX,蛀牙很不爽",["金度"] = "EX,挽手说梦话",["破碎岭"] = "EX,Mfro",["奥尔加隆"] = "EX,王二寒",["石爪峰"] = "EX,退役吹比选手",["伊兰尼库斯"] = "EX,炸不干的油炸",["万色星辰"] = "EX,优优鸣天箭",["血色十字军"] = "EV,丨眸夜祭歌丨;EU,阿狸么",["回音山"] = "EV,空灵道;EU,诅咒的回响;ET,其修远兮",["伊森利恩"] = "EV,小怪受丶;EU,卧底追风,斎藤飞鳥,我不是咕咕",["耳语海岸"] = "EV,若汐,夏天;EU,祭月隐修",["加基森"] = "EV,隔代有佳人",["烈焰峰"] = "EV,左右",["迅捷微风"] = "EV,望天灬,霂阳,风霂阳;ET,嶙嶙",["丽丽（四川）"] = "EV,十二快蓝娇",["恶魔之翼"] = "EV,天季的云",["暮色森林"] = "EV,Gourdsnow",["奈法利安"] = "EV,凌波喵步",["玛诺洛斯"] = "EV,动感小风",["狂热之刃"] = "EV,我踏妈没疯丶",["守护之剑"] = "EV,月飘零",["熔火之心"] = "EV,大胡子灬杨叔;EU,丨死亡丨灬羿",["基尔罗格"] = "EU,星尘大海",["普瑞斯托"] = "EU,牛牛的西北方",["伊利丹"] = "EU,Mikelan",["安威玛尔"] = "EU,桃之宝",["安纳塞隆"] = "EU,皮皮的邦桑迪",["火羽山"] = "EU,倾城乄堕落",["太阳之井"] = "EU,仲笠",["洛肯"] = "EU,德拉米尔",["试炼之环"] = "EU,枳花丶驿影",["风暴之怒"] = "EU,黑桃小九;ET,自闭的阿昆达",["红云台地"] = "ET,妖怪爹爹",["通灵学院"] = "ET,陆荫杆霞",["山丘之王"] = "ET,Xantz",["火喉"] = "ET,风月清幽雨",["菲拉斯"] = "ET,西域春",["阿尔萨斯"] = "ET,Cmelo",["世界之树"] = "ET,路连城",["冰风岗"] = "ET,Onlysoso",["斯克提斯"] = "ET,十点半睡",["翡翠梦境"] = "ET,荆棘刺环",["千针石林"] = "ET,艾尔的荣耀,|艾尔之光"};
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