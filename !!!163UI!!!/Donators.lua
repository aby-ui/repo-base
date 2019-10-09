local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,粉红雪山-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["白银之手"] = "KT,Wassim;KQ,马云之子,亿易;KP,月影临风,血色百夫长;KL,光芒冷酷;KJ,福柯里斯;KI,仙女儿在人间;KH,裴老湿,妖龙重生;KG,怜汐,兰斯洛帕拉丁,旋涡凝嫣;KF,织雾猪,米老鼠邀月,安灬小希,安丶小希,董老湿,只是朱颜改丶;KD,片桐镜华,子夜纾怀,血色豪侠;KC,轩辕敬城;KB,兰博挤泥巴;KA,凝眸不为你,长路漫慢,青春越扯越蛋,心中的饿魔;J/,千舆丶千寻;J+,叶小汐;J8,凄美夏末;J7,明曰天情,刘伶醉福酒",["迦拉克隆"] = "KT,萌丶捷列夫;KI,小猪佩奇呦;KG,二里丹丶怒风,匹伐他汀钙;KD,丨湖人老大;J+,墨仙客",["死亡之翼"] = "KT,一夜赫然倾城;KR,碳化硅,妖王之王,鸡蛋盖浇饭;KQ,桂花糕,亲亲胖胖熊,觅丶墨,鱼鱼有饼;KO,Amen,你看不到;KN,花醉羽觞;KM,有苏;KL,奶酪芝士面包,Juggernau,星耀;KJ,废材阿德,在御,萧萧丶;KI,萌萌的小甜甜,市委书記,瘦性大发,九十九个防骑;KH,涅槃毁灭,Mvenus;KG,水果捞丶,唯爱我苗;KF,蕾欧娜娜,萌堂御诺,Kalazh,死亡界主,星河;KD,丶无常;KC,蓝丶非,葡小萄;KB,一梦经年丶,櫹楓;J/,多萝缇娅;J+,暴怒胖可丁,爱臭美的猫丶;J9,鐵哥哥;J8,十里长辞,丶按时吃饭;J7,乔巴不是狗丶",["凤凰之神"] = "KT,Muxii,是谁的心阿;KR,此名字不能用,大雨灬;KQ,生有余辜,鼎酱胖胖哒,Yerger;KP,Constans;KO,暗妮,晨曦丶晓白;KN,布罗利丶邪眼;KL,祸斗丶;KJ,王筱柒,我爱壹条柴,疯狅小北,举起鸡腿;KI,正中眉心暴击;KH,乄盗;KG,Vitamilk,熊噗噗的爸爸,Monsterzs;KF,霸气灬肆射,凝馨木,Yoyoqaq,部落首席血骑,疯狂小北;KD,奶斯兔迷秋,奶思兔迷秋,Rainboow;KB,消遣无奈;J/,冷饭,古城酒巷年少,Gintama;J+,山之阿,丶纸防骑;J9,执刃;J8,温州灬吴彦祖,镇囯神将;J7,一个诗意的名",["安苏"] = "KT,海迦尔的风,此間的少年丶;KS,爷们儿萬歲;KR,眠慕白;KP,陆伯言丶;KN,仙女有只猫;KM,杨秀儿;KI,六万,Kawj;KG,宛安;KF,魔法部委员长;KB,褚筠;KA,十水磷酸钠;J+,泡泡丨茶壶,丷战撕;J8,枸杞威士忌,夜以青雲",["萨格拉斯"] = "KT,霓凰郡主;KF,洋葱哥",["月光林地"] = "KT,浏阳河赛艇;KR,汐玥",["托塞德林"] = "KS,丶洋葱",["无尽之海"] = "KS,我很谦虚;KR,丹峰揽月;KM,丶小果然;KH,换月;KG,哎呦不錯哦;KF,慕容木头,這个斩杀奈斯",["主宰之剑"] = "KS,左岸铭记;KP,吾之阳;KM,林家暗影射手;KL,浅殇,寂寥之心;KJ,清白;KF,獵釰,鹰之号角,Decakil;KD,奥格的小德;J7,Lockhar",["血色十字军"] = "KS,祝您平安;KQ,只萌不新;KO,Crankines,临光;KM,统御法典丶,棉被封印丶;KL,伪夹生肉;KG,咕噜咕嚕;KF,枸杞威士忌;J8,法小师丶",["萨菲隆"] = "KS,徒手掰脊椎",["格瑞姆巴托"] = "KR,半点白;KP,魅魇;KO,迷之圆滚滚;KN,起司汉堡包;KJ,灰色虚空;KF,予安丷,鹤云丶;KA,榮耀属于联盟;J/,Caffein;J8,别吓到我的猫",["晴日峰（江苏）"] = "KR,奶炮;KF,武灵萌主;J/,Szhao",["卡德加"] = "KR,幻影神",["风行者"] = "KR,前川",["伊森利恩"] = "KR,部落壁垒;KN,沖田総司;KM,罗森灬内里;KJ,瘦五斤再改名;KI,余倚之丶,Arisia;KH,娇喘小熊猫丶;KG,我不敢过江;KC,打上火花;J8,防火女真可爱",["影之哀伤"] = "KR,黑夜的寂静;KM,垂死的玖玖;KI,圣痕之牙;KF,思念北方的牛;J9,暗夜魔王丿丶;J7,想念念呀丶",["贫瘠之地"] = "KR,苏珊娜丶,可可;KM,后宫全是牛;KJ,一个方丈老铁;KG,乱世丶圣光;KF,谷令秋;KC,雨茶;J8,丶孤独的信仰",["烈焰峰"] = "KR,Yeliz;KF,迦若",["试炼之环"] = "KR,游学者流年",["影牙要塞"] = "KR,我记性好差",["黑龙军团"] = "KQ,夜長夢還多",["安东尼达斯"] = "KQ,开拓者丶咸鱼",["黑铁"] = "KQ,暗黑胡萝吥;KO,百兽凯多丶;KN,伤心猪大肠;KF,王权富贵是也;J9,千山渡",["玛里苟斯"] = "KQ,堕落之誓;KI,停顿七秒",["洛丹伦"] = "KQ,部落骑士",["加基森"] = "KQ,柒蓝;KI,缺德易灭丶",["末日行者"] = "KP,狂野乔峰,十万城管;KO,雪中捍刀行丶;KN,丶花尽千霜默;KM,狂野黄蓉;KL,梧桐夜语;KG,丶藤井莉娜;KF,幽灵少女,菈米娜,孤盗西风瘦马;KB,伤痕男人勋章",["白骨荒野"] = "KP,永島圣羅",["幽暗沼泽"] = "KP,Kizimao;KC,一头大黑牛",["图拉扬"] = "KP,半盏春",["达拉然[US]"] = "KP,Cathrot",["暗影之月"] = "KP,万神殿丶可心;J9,火儛丶",["诺森德"] = "KO,大卫妮尔",["金色平原"] = "KO,粉红雪山;KM,浮月若苼;KI,艾尔莎索瑞森;KG,鲟将军;J8,艾尔莎星辉,追随圣火的光",["布兰卡德"] = "KO,芒种;KM,咕嘟嘟冒泡泡;KL,暮与晨嚣,组我必悔;KI,这咋玩呀;KD,凌波喵步",["奥妮克希亚"] = "KN,巧面馆",["太阳之井"] = "KN,鸡伱太美诶丶;KL,漂移和飘逸",["回音山"] = "KN,小鲜奶;KH,南柯伊梦;KF,凌冷霜,纷乱丶;KC,血影七杀",["伊利丹"] = "KN,Bloodypyre,Bloodyfive",["迅捷微风"] = "KN,夏比比;KG,旧梦化云烟,也许忘记;KA,前男友灬",["燃烧之刃"] = "KN,对不起都怪我,泰抽抽,月色丶秋风;KM,稀饭凉面;KJ,丶青云,Margie;KI,杰斯很奈斯,未知目标灬灬;KH,你圣爷;KG,小时候可淘了,美叶留京子;KE,光头抠脚大汉,卿夲佳人;KC,北极星的守候;KB,Guee;KA,胖的你嗷嗷叫,狂鲨;J+,妹妹恋爱吗;J8,清风残",["国王之谷"] = "KN,无人咏生;KM,七世笙歌丶;KJ,痛饮丶快乐水;KI,摘仙,惬意灵猫;KF,群殴还是单挑;KE,皎月星魂,抽刀断魂;KD,烬歌",["扎拉赞恩"] = "KN,逍遥丹哥",["埃苏雷格"] = "KN,囧囡囚囧",["天空之墙"] = "KN,病态的怜悯",["冰风岗"] = "KM,虾条;KF,止境丶",["火焰之树"] = "KM,天舞星辰",["伊萨里奥斯"] = "KM,Tsaixx",["海克泰尔"] = "KM,可尔必思丶;KL,电眼男;KH,暮同白衣;KE,星神者丶猎空",["埃德萨拉"] = "KJ,牧行雲;J/,牧行云",["风暴之鳞"] = "KJ,王大钢",["破碎岭"] = "KJ,那一朵玫瑰,Turbowarrior",["罗宁"] = "KI,艾咯文,狂野小猫咪;KH,墩饽饽;KG,Sumail,一个大叔;KF,空恨别梦久丶;KD,丶叶不修;J/,兮译;J9,尼古拉斯大白",["德拉诺"] = "KI,要爽靠自己",["永夜港"] = "KI,恶魔丶殺",["塞拉赞恩"] = "KH,曉馬謌",["石爪峰"] = "KH,冷艳的暧昧",["血环"] = "KH,凉愁浅梦;KG,卸了妆的猫",["希尔瓦娜斯"] = "KH,Eemaster,永恒丶克鲁",["普罗德摩"] = "KH,懒得取名字",["龙骨平原"] = "KH,阿牛;KA,Foreknow",["伊瑟拉"] = "KG,Ysara;J+,暗影之怒",["丹莫德"] = "KG,花苑寂寞红",["阿古斯"] = "KG,摩丶羯",["克尔苏加德"] = "KG,一鹿祐妳",["夏维安"] = "KF,张叶",["艾露恩"] = "KF,小心我捶你",["巴瑟拉斯"] = "KF,如也",["熊猫酒仙"] = "KF,钢铁硬;KD,艾泽里特护甲;KC,一个弓的名字",["守护之剑"] = "KF,瞅你一眼",["末日祷告祭坛"] = "KF,浮生何休",["狂热之刃"] = "KF,兔猫丶法力茶",["奥杜尔"] = "KF,德云断头熙",["利刃之拳"] = "KF,静儿躺着噜",["霜之哀伤"] = "KF,卡尔克斯",["奥特兰克"] = "KF,Onlylonely;KE,空自凝眸丶",["寒冰皇冠"] = "KF,二次元三次元",["亡语者"] = "KF,酷茶德",["斩魔者"] = "KE,转身丶未晚",["奥尔加隆"] = "KE,小星落",["艾莫莉丝"] = "KD,天秤座的乌鸦",["鬼雾峰"] = "KD,舟小鸣仔",["塞拉摩"] = "KD,Ylidanwh;J+,从小就很酷",["霜狼"] = "KC,好大一棵树",["海达希亚"] = "KB,Shiry",["血牙魔王"] = "KB,恶灵死者",["永恒之井"] = "KA,九分儿;J+,蓝巨人,飞火流矢",["闪电之刃"] = "J/,报之以歌",["桑德兰"] = "J/,瘦头哒",["时光之穴"] = "J/,无限弹幕",["壁炉谷"] = "J+,郎郎浪;J7,朗朗浪",["莱索恩"] = "J+,Artemisgrace",["诺莫瑞根"] = "J9,血灬月",["暗影迷宫"] = "J9,斗神",["比格沃斯"] = "J9,上九言",["霍格"] = "J9,阿如汗",["翡翠梦境"] = "J7,大象干蚂蚁",["克洛玛古斯"] = "J7,过把瘾",["斯坦索姆"] = "J7,Thanos",["麦迪文"] = "J7,紫默"};
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