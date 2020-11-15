local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["艾露恩"] = "Qt,风吹小豆豆;Qq,我要去睡觉;Qp,布丽吉塔;Qh,Marxism",["贫瘠之地"] = "Qs,Saybyeolbe,Pixinsight;Qr,追龍;Qq,高冷猫呀;Qp,情迷意亂,缘玅不可言;Qo,Hyitdai;Qk,江月庭芜,从晨锋,灬兜兜转灬;Qi,小楼夜听弦;Qh,我愛御姐,刺头丶;Qf,哋灬哋哋,约翰丿列侬",["耳语海岸"] = "Qs,林克",["密林游侠"] = "Qs,电击治网瘾",["血色十字军"] = "Qs,伊希塔卡;Qr,瑪法理沙;Qq,康帝,大穷喵,树根;Qp,哈夫维特;Qk,山竹大佬;Qj,胖墩丶;Qf,丶伴伴糖,全聚德烤咕咕,重立体四号,奶粉大宝贝儿,聖光将熄丶,听说过圣光吗,香蕉丶大酋长",["死亡之翼"] = "Qs,弄丑,棉花熊,肥妮克斯,怜香,笨笨喵;Qr,沫熙,会动的牛肉干,丶李二宝;Qq,笑踏联盟狗脸;Qp,网名加载失败,化作水星;Qm,白峰里莎;Ql,路西菲尔斯;Qk,温暖的大熊;Qj,迷茫的柚子;Qi,陈墨;Qh,宸诚;Qg,大青兕,三宝公爵,三宝儿降临,犹格索讬斯",["末日行者"] = "Qs,骑蚂蚁闯黄灯,何以清尘丶;Qp,Hyitdai;Qo,阿蘅;Qn,卡哇伊熙月;Qm,姜萌萌;Ql,后羿弯弓;Qg,鲍皮,鸡萨",["洛丹伦"] = "Qs,劣人丿,灵之亡者;Qr,大来来;Qp,沐雪晨阳,牛牛的爱丶;Qo,血苍白;Qh,王来",["金色平原"] = "Qs,Ilz;Qj,青山遠黛;Qi,生命奇迹;Qh,把苹果啃哭丶,小禹丶",["白银之手"] = "Qs,逃避丶现实;Qr,安慕汐,荒野半神,遇见神明之前,芋圆四号,魂归故囇;Qq,Rookies,冥河边逗鬼仙;Qp,九折,雷千灯,花壹開滿,中华起司猫,就要吃肉肉,古惑死靈因,啃苹果的喵,多放香菜,南极馨;Qo,赵一二;Qn,伤心黑海岸;Qm,帝铠熊,无根白银汤,若写情书;Ql,颢耀;Qk,千寒丶,暗夜雖龍,怒海风暴,倾城情雨;Qj,荀彧念作苟或;Qi,圣光敕令,怀念的颜色,甜飞云,欧皇欧霸;Qh,大灯李李,柠檬水饮,画包上的老猫,丨沐雨乘风丨,十八变,Miletus;Qg,Louhh,蹴罢秋千,阿怪哥",["凤凰之神"] = "Qs,前丶妻,身带高压电;Qr,紫恨情缘,叶舞轻楓,桜沢墨,丷笑生花;Qq,半城丿猎,雪霜,丨温瞳丨灬,丨冷眸丨灬,一二柒八法,暗影之境丶雷;Qp,灬依咕哔咕灬,黑旋风李元霸,阿殇丶,丨白玉亰丨;Qo,就捅一捅,就跳啊跳;Qn,白羊座灬倾心;Qm,黒風;Ql,奥雷莉亚公爵;Qk,明丨明;Qj,粉白白;Qi,白羊座灬狐颜,牧牛熊;Qh,拉拉嘴额,轻玥,死亡之亦,暮烟光凝,大奶流,三生梦;Qg,豆虎皮皮,指縫丶,特拉法加鸽王,Dizzymeow,周老师请坐;Qf,君子意如何",["永恒之井"] = "Qs,Titan;Qf,潍坊纯爷们,沙雕青年",["破碎岭"] = "Qs,樱花儿;Qm,煮茶;Qi,弑君小贱",["国王之谷"] = "Qs,噢呦呦;Qq,诩沁沁;Qp,因古斯特,甜梦熊,甜梦猫;Ql,折戟尘沙;Qk,沒有蛀蚜;Qi,远山晴更多",["无尽之海"] = "Qs,海猫食堂,小蛋挞;Qr,换月;Qp,尐猜丶;Ql,山一程雪一更;Qk,Aliceangela,了然灬猎;Qh,丶隻狼灬,妖怪灬了然;Qf,素芬儿",["格瑞姆巴托"] = "Qs,闪闪的闪闪,弥月泊桑,大白腿;Qr,沐荣,叶心安,Divinevil,黑暗凝视,黑暗冥想;Qq,榴莲炖臭豆腐,别吃了;Qp,必将百倍奉还,柒夏玲珑,为所欲为小德;Qo,光明奶茶;Qk,惊丶梦;Qj,小鱼丨小维他,喵丶风暴清酒;Qi,Pudge,追野丸加丶;Qh,武术家马保国;Qg,默默小闹腾;Qf,关伯兰还在笑,关伯兰在笑,戒不掉伈殇",["艾森娜"] = "Qs,法治之光",["月光林地"] = "Qs,莫摇清碎影",["伊萨里奥斯"] = "Qs,裤里就是吊",["伊森利恩"] = "Qs,Mesric;Qr,战霸,替我当炮灰;Qp,仲莫肥四鸭,冰鎮榴蓮酥,看我变只鸡,十五年老萨满;Ql,雪狐的银尾,克己复礼;Qj,白阿白,圣婴大王污昂;Qi,德国骨科;Qh,Kobeneverout;Qg,Rethmo;Qf,猫姐吖",["迅捷微风"] = "Qs,烈酒奇德;Qh,血罐,坚果爸比",["冰风岗"] = "Qs,初拥;Qr,微微笑丶;Qq,九蓝丶雨中客,九梦蓝,九蓝的护佑,九小天儿;Qp,罗纳河的星夜;Qo,不当奶狗;Ql,呆萌的贼;Qh,纯粹武夫;Qf,欧皇悲離",["诺森德"] = "Qs,Tamaru",["恶魔之魂"] = "Qs,血月聖光;Qn,大鱼鱼爱吃肉;Qg,只刃",["翡翠梦境"] = "Qs,瓦伦斯;Qr,神圣領域;Qj,抽过的烟",["???"] = "Qs,乌鸦救赎;Qr,大典太,月半橘;Ql,奶水挤压者;Qk,忒朗普",["主宰之剑"] = "Qs,欧洲教父;Qr,破裤丶,薄暮的狗蛋儿;Qq,伪裝,然羙羙;Qp,丷葵司乄,丨悲丨,春哥菊花茶,老流氓林克;Qn,动感蓝胖子;Qm,漂泊无依,立花千寻;Ql,她就有点皮;Qj,峰卷残云;Qh,王权乄富贵,太饿猎",["石爪峰"] = "Qr,大宝贝儿丶",["菲拉斯"] = "Qr,小胖鸟",["罗宁"] = "Qr,范哒尔丶钢盔,Tasty;Qq,誅神黄昏,她是我的光,两个火球;Qp,依昔记忆,紫色暗瞳;Qi,圣光人肉沙包;Qg,Inspired",["燃烧之刃"] = "Qr,心灵灰烬,李家小可耐,禾口言皆;Qq,凤神凰,木木争青;Qp,灵冬冬,可可阿華田丶;Qm,玛格汉堡王,萨鲁法尔霸主,子祁;Qj,Giftia;Qh,肉离,Sookiechn,烟是回味;Qf,岚夏丶,曾经相识",["克尔苏加德"] = "Qr,如临花开,Himygirl;Qq,那就太亏了;Qo,那个帅小伙;Qj,网吧偷单车,阿肥丶;Qi,核心大师",["安苏"] = "Qr,恶尘无染,丨断线丶,黑风寨巡山鬼,丨十二丨,丨三五丨,丨三一丨,丨十九丨,丨二一丨,丨二一,从零;Qq,乄暧昧丶;Qp,比梦更真实;Qo,从此不奶;Qj,淡年;Qh,璃尛,Vanlatena;Qg,爫奔跑的蜗牛,艹奔跑的蜗牛,丷奔跑的蜗牛,兦奔跑的蜗牛,亾奔跑的蜗牛,乊奔跑的蜗牛,乄奔跑的蜗牛,皿奔跑的蜗牛,覀奔跑的蜗牛,丣奔跑的蜗牛,罓奔跑的蜗牛,罒奔跑的蜗牛,快给我来个橙,都是脆皮,流刘刘鼻涕;Qf,乐观的二五仔",["达尔坎"] = "Qr,血之幻想",["奎尔丹纳斯"] = "Qr,瓜子香",["斯坦索姆"] = "Qr,暗夜丶破碎",["加兹鲁维"] = "Qr,陌夏残年",["海克泰尔"] = "Qr,一眼星河,左手骨折,无效的昵称;Qo,童阿梨;Qk,艾星鱼人领袖;Qi,紅曜石;Qf,天狂我就是我",["巴纳扎尔"] = "Qr,忆悟;Qj,忆墨",["冰霜之刃"] = "Qr,夏小辣丶",["奥特兰克"] = "Qr,Kopite;Qh,满目星河丶",["狂热之刃"] = "Qr,南栀;Qk,Montgomery;Qi,遥射牧女村",["布兰卡德"] = "Qr,提里奥丶弗丁,陈澄橙;Qq,汐夏丨桃桃酱;Qp,我的小甜姜丶,巴彦格勒顺,葉落知秌,是桐生战兔哒,香灬薰,灬绫灬;Qm,毁灭虹吸;Qk,阿圆,不良帥,Atom;Qh,少林菲菲",["熊猫酒仙"] = "Qr,丶瘋言瘋语;Qn,雲想衣裳;Ql,目及皆王土,丶儬釹;Qj,瘋人院;Qh,麻瓜麻瓜",["影之哀伤"] = "Qr,米翠花;Qp,简庭庭;Qo,Rv;Qm,玲二;Ql,铁拳没吃饭吗;Qk,病名爲爱;Qj,希亚;Qh,兰克丶;Qg,夏沫丶浅雨,夏茉灬微凉,挽远;Qf,狸萨,跃动时如火星",["埃苏雷格"] = "Qr,崩弓子",["熔火之心"] = "Qr,Sunch;Qo,王大蛮;Ql,艾瑞巴蒂丶",["龙骨平原"] = "Qr,温柔的毒药",["萨菲隆"] = "Qr,惟吾德馨",["加基森"] = "Qr,丶时光",["血环"] = "Qr,卡炸飛;Qq,香沫儿;Qh,沙之我爱罗",["哈卡"] = "Qq,田师傅",["幽暗沼泽"] = "Qq,柴柴",["血牙魔王"] = "Qq,Desweet",["风行者"] = "Qq,竹叶清风",["巫妖之王"] = "Qq,故羌",["桑德兰"] = "Qq,海棠花儿开",["踏梦者"] = "Qq,蓝初夏",["血羽"] = "Qq,八云蓝",["丽丽（四川）"] = "Qq,银河星爆;Qp,Alukaduo,皇帝的意志;Ql,丨雨丨;Qj,月银轻芬;Qh,敏若昕,妙若",["希尔瓦娜斯"] = "Qq,行露灬",["遗忘海岸"] = "Qq,哀伤之影;Qm,熊二的皮球;Qi,罄竹难术;Qh,浅潜",["奥尔加隆"] = "Qp,风雨正苍苍",["迦拉克隆"] = "Qp,夏莲香",["熵魔"] = "Qp,纯白小熊猫",["索瑞森"] = "Qp,战吊",["塞拉摩"] = "Qp,灬殇丶影;Qi,猫大夫",["天空之墙"] = "Qp,Proudheart",["斩魔者"] = "Qp,插秧插錯",["格雷迈恩"] = "Qp,随风铃;Qo,橙不欺我",["玛诺洛斯"] = "Qp,大猫本萌",["利刃之拳"] = "Qp,泱洋氧恙",["耐奥祖"] = "Qp,放逐之刃",["燃烧军团"] = "Qo,水冰月喵塔;Qi,夜礼服咩佩",["阿克蒙德"] = "Qo,圣光忽悠尔等;Ql,天关破军",["阿古斯"] = "Qn,余生了了",["哈兰"] = "Qn,智沫沫",["黑龙军团"] = "Qn,醋墨半生",["伊利丹"] = "Qn,姑射处士",["泰兰德"] = "Qm,汲汲于生",["黑铁"] = "Qm,踩个奉献;Ql,拜拜了您那;Qh,拓老板;Qg,八月丶初秋;Qf,Xiyubaby",["回音山"] = "Ql,这一枪叫晚安;Qj,屠魔侠",["加尔"] = "Ql,伽内砂",["阿纳克洛斯"] = "Ql,逐日者",["阿尔萨斯"] = "Ql,Yangie",["外域"] = "Qk,波多野结衣",["灰谷"] = "Qk,一对小得",["暗影之月"] = "Qk,多拉爱梦;Qi,舞麟萌主",["奥拉基尔"] = "Qk,大胸口;Qh,开心的大萝卜",["埃德萨拉"] = "Qj,许于初见;Qg,红灬桃;Qf,甜酒",["试炼之环"] = "Qj,魔剑迦游罗",["苏拉玛"] = "Qj,迷茫的蓝莓",["瓦里安"] = "Qj,迷茫的山竹",["瓦拉纳"] = "Qj,迷茫的圣光",["雷霆之怒"] = "Qj,楠珏夫人",["红云台地"] = "Qj,十七丶猎",["白骨荒野"] = "Qi,郁闷的神",["迦顿"] = "Qi,皓月聆枫;Qg,林深时见鹿",["蓝龙军团"] = "Qh,读条三十秒",["霜之哀伤"] = "Qh,桦溪墨,Xxlxxl",["神圣之歌"] = "Qh,地狱火发型师",["鲜血熔炉"] = "Qh,Saber",["千针石林"] = "Qh,陈惠琳",["摩摩尔"] = "Qh,德过且过",["藏宝海湾"] = "Qg,圣光小锤锤",["提尔之手"] = "Qg,只是信仰而",["巨龙之吼"] = "Qg,炸油条",["安纳塞隆"] = "Qf,贺贺",["梦境之树"] = "Qf,一忘路",["风暴之怒"] = "Qf,卑微小号丶"};
local lastDonators = "笨笨喵-死亡之翼,怜香-死亡之翼,乌鸦救赎-???,瓦伦斯-翡翠梦境,大白腿-格瑞姆巴托,血月聖光-恶魔之魂,灵之亡者-洛丹伦,肥妮克斯-死亡之翼,Tamaru-诺森德,初拥-冰风岗,烈酒奇德-迅捷微风,Mesric-伊森利恩,裤里就是吊-伊萨里奥斯,小蛋挞-无尽之海,弥月泊桑-格瑞姆巴托,身带高压电-凤凰之神,莫摇清碎影-月光林地,法治之光-艾森娜,Pixinsight-贫瘠之地,何以清尘丶-末日行者,闪闪的闪闪-格瑞姆巴托,海猫食堂-无尽之海,棉花熊-死亡之翼,噢呦呦-国王之谷,樱花儿-破碎岭,Titan-永恒之井,前丶妻-凤凰之神,逃避丶现实-白银之手,Ilz-金色平原,劣人丿-洛丹伦,骑蚂蚁闯黄灯-末日行者,弄丑-死亡之翼,伊希塔卡-血色十字军,电击治网瘾-密林游侠,林克-耳语海岸,Saybyeolbe-贫瘠之地,风吹小豆豆-艾露恩";
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
    topNamesOrder = nil
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