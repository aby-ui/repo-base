local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,绾风-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["龙骨平原"] = "KH,阿牛;KA,Foreknow",["罗宁"] = "KH,墩饽饽;KG,Sumail,一个大叔;KF,空恨别梦久丶;KD,丶叶不修;J/,兮译;J9,尼古拉斯大白",["凤凰之神"] = "KH,乄盗;KG,Vitamilk,熊噗噗的爸爸,Monsterzs;KF,霸气灬肆射,凝馨木,Yoyoqaq,部落首席血骑,疯狂小北;KD,奶斯兔迷秋,奶思兔迷秋,Rainboow;KB,消遣无奈;J/,冷饭,古城酒巷年少,Gintama;J+,山之阿,丶纸防骑;J9,执刃;J8,温州灬吴彦祖,镇囯神将;J7,一个诗意的名",["伊瑟拉"] = "KG,Ysara;J+,暗影之怒",["贫瘠之地"] = "KG,乱世丶圣光;KF,谷令秋;KC,雨茶;J8,丶孤独的信仰",["血环"] = "KG,卸了妆的猫",["燃烧之刃"] = "KG,小时候可淘了,美叶留京子;KE,光头抠脚大汉,卿夲佳人;KC,北极星的守候;KB,Guee;KA,胖的你嗷嗷叫,狂鲨;J+,妹妹恋爱吗;J8,清风残",["无尽之海"] = "KG,哎呦不錯哦;KF,慕容木头,這个斩杀奈斯",["丹莫德"] = "KG,花苑寂寞红",["迦拉克隆"] = "KG,二里丹丶怒风,匹伐他汀钙;KD,丨湖人老大;J+,墨仙客",["白银之手"] = "KG,怜汐,兰斯洛帕拉丁,旋涡凝嫣;KF,织雾猪,米老鼠邀月,安灬小希,安丶小希,董老湿,只是朱颜改丶;KD,片桐镜华,子夜纾怀,血色豪侠;KC,轩辕敬城;KB,兰博挤泥巴;KA,凝眸不为你,长路漫慢,青春越扯越蛋,心中的饿魔;J/,千舆丶千寻;J+,叶小汐;J8,凄美夏末;J7,明曰天情,刘伶醉福酒",["伊森利恩"] = "KG,我不敢过江;KC,打上火花;J8,防火女真可爱",["迅捷微风"] = "KG,旧梦化云烟,也许忘记;KA,前男友灬",["血色十字军"] = "KG,咕噜咕嚕;KF,枸杞威士忌;J8,法小师丶",["死亡之翼"] = "KG,水果捞丶,唯爱我苗;KF,蕾欧娜娜,萌堂御诺,Kalazh,死亡界主,星河;KD,丶无常;KC,蓝丶非,葡小萄;KB,一梦经年丶,櫹楓;J/,多萝缇娅;J+,暴怒胖可丁,爱臭美的猫丶;J9,鐵哥哥;J8,十里长辞,丶按时吃饭;J7,乔巴不是狗丶",["阿古斯"] = "KG,摩丶羯",["克尔苏加德"] = "KG,一鹿祐妳",["安苏"] = "KG,宛安;KF,魔法部委员长;KB,褚筠;KA,十水磷酸钠;J+,泡泡丨茶壶,丷战撕;J8,枸杞威士忌,夜以青雲",["金色平原"] = "KG,鲟将军;J8,艾尔莎星辉,追随圣火的光;J7,摘仙,山河兮",["末日行者"] = "KG,丶藤井莉娜;KF,幽灵少女,菈米娜,孤盗西风瘦马;KB,伤痕男人勋章",["主宰之剑"] = "KF,獵釰,鹰之号角,Decakil;KD,奥格的小德;J7,Lockhar",["夏维安"] = "KF,张叶",["艾露恩"] = "KF,小心我捶你",["国王之谷"] = "KF,群殴还是单挑;KE,皎月星魂,抽刀断魂;KD,烬歌",["巴瑟拉斯"] = "KF,如也",["熊猫酒仙"] = "KF,钢铁硬;KD,艾泽里特护甲;KC,一个弓的名字",["守护之剑"] = "KF,瞅你一眼",["晴日峰（江苏）"] = "KF,武灵萌主;J/,Szhao",["影之哀伤"] = "KF,思念北方的牛;J9,暗夜魔王丿丶;J7,想念念呀丶",["末日祷告祭坛"] = "KF,浮生何休",["狂热之刃"] = "KF,兔猫丶法力茶",["奥杜尔"] = "KF,德云断头熙",["黑铁"] = "KF,王权富贵是也;J9,千山渡",["冰风岗"] = "KF,止境丶",["利刃之拳"] = "KF,静儿躺着噜",["霜之哀伤"] = "KF,卡尔克斯",["回音山"] = "KF,凌冷霜,纷乱丶;KC,血影七杀",["格瑞姆巴托"] = "KF,予安丷,鹤云丶;KA,榮耀属于联盟;J/,Caffein;J8,别吓到我的猫",["奥特兰克"] = "KF,Onlylonely;KE,空自凝眸丶",["烈焰峰"] = "KF,迦若",["寒冰皇冠"] = "KF,二次元三次元",["亡语者"] = "KF,酷茶德",["萨格拉斯"] = "KF,洋葱哥",["斩魔者"] = "KE,转身丶未晚",["奥尔加隆"] = "KE,小星落",["海克泰尔"] = "KE,星神者丶猎空",["艾莫莉丝"] = "KD,天秤座的乌鸦",["布兰卡德"] = "KD,凌波喵步",["鬼雾峰"] = "KD,舟小鸣仔",["塞拉摩"] = "KD,Ylidanwh;J+,从小就很酷",["幽暗沼泽"] = "KC,一头大黑牛",["霜狼"] = "KC,好大一棵树",["海达希亚"] = "KB,Shiry",["血牙魔王"] = "KB,恶灵死者",["永恒之井"] = "KA,九分儿;J+,蓝巨人,飞火流矢",["埃德萨拉"] = "J/,牧行云",["闪电之刃"] = "J/,报之以歌",["桑德兰"] = "J/,瘦头哒",["???"] = "J/,雯子雯",["时光之穴"] = "J/,无限弹幕",["壁炉谷"] = "J+,郎郎浪;J7,朗朗浪",["莱索恩"] = "J+,Artemisgrace",["诺莫瑞根"] = "J9,血灬月",["暗影迷宫"] = "J9,斗神",["比格沃斯"] = "J9,上九言",["暗影之月"] = "J9,火儛丶",["霍格"] = "J9,阿如汗",["翡翠梦境"] = "J7,大象干蚂蚁",["克洛玛古斯"] = "J7,过把瘾",["斯坦索姆"] = "J7,Thanos",["麦迪文"] = "J7,紫默"};
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