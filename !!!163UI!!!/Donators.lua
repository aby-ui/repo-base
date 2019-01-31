local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,空灵道-回音山,叶心安-远古海滩,孤雨梧桐-风暴之怒,释言丶-伊森利恩,林叔叔丶-死亡之翼,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,优先毕业目标-贫瘠之地,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯";
local recentDonators = {["鹰巢山"] = "GT,沧海一声笑",["无尽之海"] = "GS,丶蛋蛋碎大石;GR,苏小毛,炎帝萌萌哒;GN,倾城丶繁华尽;GI,夜灵希;GC,空客,｜华佗｜;GB,丶怪怪丶;GA,迷、魂,轻舞杜啦啦;F/,糖果好甜",["凤凰之神"] = "GS,夕晖,仙羽羽,邪恶蛋卷;GR,睿宝儿,丨紅尘烟雨丨;GQ,Akumadis,夕钧灬;GO,壹利丹丶寒冬;GN,老醉醉,马尾与发圈,看妳妹的啊,短腿小术,妳斜愣誰,睡你没商量,戏如人生丷;GM,杰克;GL,镜中过往;GK,痕冲直壮,你上我上瘾了,小毛贼丷;GI,一刀切橙;GE,跑调的爱情;GD,灬我劝你善良;GC,严谨;GA,罗纳尔多丶帅;F/,丨戏子,安静的牧,安静的道,团长与狗",["苏塔恩"] = "GS,柔吻有你的夜",["安苏"] = "GS,丶郑钱花,宝贝丶吃爪爪;GO,丨傲霜枝丷;GN,丶木之本樱,一超级小牛一;GK,黑猫要革命;GH,飞将军丶老刘;GG,Boterye;GD,惜树,方应看灬;GB,我是小犄角;F+,荒川灬",["死亡之翼"] = "GS,冬天里的圣光;GR,逸之殇;GQ,哀怨起骚人,山外小姑狼,儒生,丨倾歌亦亦丨;GP,心有所念,谜丶戀,轉鯓離紶,灬素天灬;GO,糖门大胸弟,风白的小兔子;GN,Immanuél,东莞特级技师,水馒头;GM,雨中的承诺,Kraii;GK,蘭尼斯特巨人,九局后半;GJ,林叔叔丶,可乐兑砒礵;GH,匆匆丶;GG,武磊;GD,Jackpinel,花开不糜;GC,根本丨英俊;GB,冷血小黑猫;GA,奶僧宝宝,黑手丶涮熊肉;F/,深知她是梦;F+,神月灬卡琳,幸福的沙雕,酒意入桃枝",["冰风岗"] = "GS,Akmythes;GN,银铯子弾;GL,腚小皮就薄;GE,余音缭绕;GC,勺子丶;GB,成长快乐",["月光林地"] = "GS,烟火在燃烧",["燃烧军团"] = "GS,若呆",["红龙军团"] = "GS,叉烧捞面;GA,尐儍疍;F+,取名丶周公",["金色平原"] = "GS,Virgil;GR,艾尔云歌;GL,艾纶妮塔;GE,伊莉雅丶枫心",["血色十字军"] = "GS,把你鸡儿吓沒;GR,五彩斑斓的黑,老叁;GP,Onlymaka,雨若晴;GJ,冬天的小心思;GI,斜杠丶青年,艾莫莉丝;GG,若无名㒹;GF,桑籍丶",["盖斯"] = "GS,紫弓,番茄丶栗子",["白银之手"] = "GS,Myangil;GR,阿伮彼斯;GP,炸鱼不叫炸鱼,酩酊南柯梦;GO,疯狂小猫,搞破坏大魔王;GN,疯狂的炸鸡,笙箫瑟起;GL,Myrtle;GK,张小鑫灬,大鬃狮,天生太完美,一笑脸萌;GJ,醉封尘;GG,我是小猪佩奇;GE,可兒爸比;GD,仙贱骑虾轉,绝命琳娜,落葉凰舞,落葉鳳舞;GB,你柠檬头;GA,老腰子恶霸;F/,Tresdina,丶芯肝呦;F+,夜雨冰岚,王辰风",["主宰之剑"] = "GS,我的弟弟乔治,淡然烟味;GR,猎刃宝宝;GQ,丶大猪;GO,小猪鱼呆贼,冰舞月光,王雨沐;GN,Slovelin,丶石原里美;GK,早安丷卢卡卡;GJ,氵早安卢卡卡,丶西野七濑;GI,灬功夫熊喵灬;GH,小拳拳砸死你;GE,孤傲冷霜;GD,君無恙;GC,影月谷的夜风;GA,戳一下;F/,Emmazz,笙歌灬",["伊森德雷"] = "GS,柏璃丶",["奥蕾莉亚"] = "GS,烟末",["血羽"] = "GS,小李他吗飞刀;GP,灬茗灬",["辛达苟萨"] = "GS,Jimforever",["末日行者"] = "GS,罗熙熙;GR,Tsunamireb;GQ,光明阳;GP,弥尔希奥蕾,何处不青山,Yukikaze;GN,小令悠悠,皮皮摧心魔;GM,阿芙萝娜,西虹首父;GL,无疆丶;GK,万影千华;GH,花与布偶猫,六月风儿;GG,Prcc;GC,贰零零柒",["贫瘠之地"] = "GS,难得心动,戊己五六;GQ,小小酥丶;GP,优先毕业目标,说走就走;GO,汐蕾;GN,古天樂,冰柠薄荷,小白兔白呦白,乖乖达子,灰灰酱菜;GL,Aksoo;GK,冰芒慕斯;GJ,零丷度;GG,怂输辈,黒子鸟;GF,空条吉影,小鱼饼;GC,鹿晗娘娘;GA,布沙尔;F/,梦回唐朝,轻描丶,美丽视界",["熊猫酒仙"] = "GS,阿迩托莉蕥;GR,黑暗中的舞;GQ,幽兰之露;GP,遗忘的伤痛,丨少氵爺丿;GO,白皮圣光骑士,大猪肉丸;GN,易阳千喜;GK,微笑的凡妮莎,云炎,索拉德;GF,紫源;GE,优秀的武僧;GC,雅咩跌,一偷心贼一;GB,灬惜缘灬;GA,琉璃寻;F+,姐姐幻肢好硬,姐姐幻肢好烫",["格瑞姆巴托"] = "GS,冰镇小酸奶;GQ,十响;GP,暗月枫;GO,無意丶;GM,光阴醉,喜欢宝时捷;GK,补天大造丸;GI,陈猪猪;GH,丶心有萌虎;GG,来自五橙寺;GF,無言丶;GD,乱射菊花,罗的右手;F/,花卷丶丶,风火灬侠客;F+,醉吟丶幽冥",["迅捷微风"] = "GS,尘缘丶;GQ,鹿荧;GM,青春又醉倒在;GL,米米徳",["???"] = "GR,大姐小跟班丶,特汚兔,快乐的小柯基;GM,萌虎嗅蔷薇;GJ,Pagechuizi",["破碎岭"] = "GR,糖菓兒丶;GL,Bebo,Turbowarrior;GK,卡迪亚;GH,盗禧,潘尛达,萨是比尔,Asny,Dlaney,装逼加逞能,Sheamuss,Alria,Ildan,铁蛋儿,帅哥来玩啊;GA,小心元素",["埃加洛尔"] = "GR,宅人",["古达克"] = "GR,太太我就蹭蹭",["深渊之巢"] = "GR,电饭褒;GA,Rhymes",["摩摩尔"] = "GR,再战窝窝丨吕",["万色星辰"] = "GR,灭团归来,天上掉星星;GF,Vuiu",["黑铁"] = "GR,火华烨;GQ,月半口乎口乎;GM,汐霧;GL,奶茶要半糖;GI,丨老杨丨;GF,落羽丶",["冰霜之刃"] = "GR,他年忆;GN,幼狼丶牧;GL,丿初心;GJ,皇浦徵羽;GG,竹林熊猫;GE,范灬爺;GA,萌丶火焰烈酒",["布兰卡德"] = "GR,沉默的许愿机;GF,情緣惜兮丶;GD,路西斐尔;F/,我不怕死",["阿纳克洛斯"] = "GR,刘嘉玲;GQ,拉架王;GL,尛児",["国王之谷"] = "GQ,弥樂;GP,喵仙人丶;F/,素兮娆湄,梦看云升",["寒冰皇冠"] = "GQ,Darkseether",["达尔坎"] = "GQ,七苦酒",["克尔苏加德"] = "GQ,惊声煎饺,三无青年;GL,森瑾;GH,亡月劫;GE,Zorrol;F/,圣男",["神圣之歌"] = "GQ,不世",["燃烧之刃"] = "GQ,无香菜;GP,燃烧的萨克尔,白银三刀流,小小申丶,我珍视的一切;GL,下雪打红红;GK,蜗牛别跑,女子帅白勺牛;GH,星语星愿;GF,小夜猫子;GD,纯羊奶,Sawyerlol,Bracelet,蜗牛别跑祝福;F+,更位长",["闪电之刃"] = "GQ,狸花喵;GO,",["暗影之月"] = "GQ,长夜;GF,火儛丶",["加兹鲁维"] = "GQ,喵喵快跑,我色我痴情",["阿尔萨斯"] = "GQ,宛若水",["伊森利恩"] = "GQ,｜小苹果｜;GP,仔小仔;GN,清浅流年丶;GJ,西里橘;GI,炼狱狂牛,Seral;GH,神话情话;F/,唐柔",["黑龙军团"] = "GQ,普隆徳拉;GG,可老坦",["天空之墙"] = "GQ,宅叔叔丶",["伊莫塔尔"] = "GQ,老板",["世界之树"] = "GP,小菊菊;GK,柔心;GF,雨露星辰",["黑石尖塔"] = "GP,凛冬降至",["提瑞斯法"] = "GP,抹了油的猪;GO,公牛;GM,明月之力;F+,凉梦无音",["丹莫德"] = "GP,白鴿;GN,白鵅",["纳克萨玛斯"] = "GP,水灵依素;GG,一条菜狗",["战歌"] = "GP,雲中鶴;GI,鬼斯通心粉;GE,虾仁猪心",["罗宁"] = "GP,停车费;GN,潜踪匿影,糖门大胸弟;GL,万火焚身丶,晓风冥月;GK,白色的大妈;GJ,暗夜微风;GI,社区主任;GE,Myatt;GD,風雲萬劍歸宗;F+,明亮双眸,Jooferic",["丽丽（四川）"] = "GP,糖果果丶;GL,占士切个奶;GK,西地那非;GG,当麻纱堎;GA,火怒风,珏宁",["翡翠梦境"] = "GP,Nafaliana;GN,阿念丶",["海克泰尔"] = "GP,哎呀灬臭流氓,灬千颂伊灬;GM,小念头丶;GK,尛黑;GD,浮生恍若梦;F/,莫名妖灵",["刺骨利刃"] = "GP,梅艳群芳",["加尔"] = "GP,快到兜里来;GD,小孬猪,根本丨美丽",["甜水绿洲"] = "GP,雾隐苍穹,雾隐貔貅",["狂热之刃"] = "GP,誰與争瘋;GH,丶爱卿丶",["希尔瓦娜斯"] = "GO,哈灬白芝麻,哇灬黑芝麻,灬小黄桃灬;GL,快乐星期天",["雷霆之王"] = "GO,我是一哚娇花",["熵魔"] = "GO,赫拉迪克",["罗曼斯"] = "GO,菊花爆裂斩",["迦拉克隆"] = "GO,暮羽轻风;GL,月在云归;GD,妖小孽;F/,苏三蛋",["鬼雾峰"] = "GO,Sylvanaser;GC,言兮,落下的苹果;GA,萨满陌小三",["拉文凯斯"] = "GO,尛娘们",["埃德萨拉"] = "GO,随风的记忆;GM,纠结灬咕咕,绵羊系佡女;GD,闹翻天丶;GA,海海骸盗",["萨菲隆"] = "GO,熙朶朶;GL,雪中送炭;GH,九龙抬棺",["风暴之怒"] = "GO,皮皮尘;F/,浅丶",["蜘蛛王国"] = "GO,西塘涛哥;GA,夜雨依晨",["回音山"] = "GO,Havoclol;GN,法神阿祖斯;GL,夏沫小米;GK,半盏清风;F+,一位熊猫",["轻风之语"] = "GN,小白爱卿",["朵丹尼尔"] = "GN,诺廿农私生子;GM,Ghiscar;GB,紫杉丶死骑",["利刃之拳"] = "GN,非常马叉虫",["玛洛加尔"] = "GN,大沈叔叔",["风行者"] = "GN,狭山薰,薰丶,杜丶风暴烈酒",["阿古斯"] = "GN,Wrectches;GG,醉后的无言,紅莲劫焰;F+,弑杀",["梦境之树"] = "GN,Elly",["影之哀伤"] = "GN,海中的浪;GM,然叔;GI,黑鸟大牛;GH,自爆绵羊;GB,风行领域;F+,千年神伤",["耳语海岸"] = "GN,有点迷;GL,蘇菲婭",["永恒之井"] = "GN,光与暗影;GI,丶伊卡鲁",["伊瑟拉"] = "GN,希斯特里娅",["霍格"] = "GN,绯色柠檬糖",["恶魔之翼"] = "GN,囍老師",["加基森"] = "GN,挨个放血;GC,蝶梦流年;GB,神术妙法",["圣火神殿"] = "GM,小胖脸嘟嘟",["血环"] = "GM,丿锺秋丶;GI,艾格莱亚",["阿曼尼"] = "GM,恐惧海峡;GD,大老黑丶",["泰兰德"] = "GM,暗羽隐;GH,杀猪焉用刀",["银松森林"] = "GM,小树墩子;GJ,Elydaley",["瓦里玛萨斯"] = "GM,多米妮",["奥特兰克"] = "GM,哈尼鹿鹿;GA,浮云千载",["巴尔古恩"] = "GM,春光乍泻丶",["山丘之王"] = "GM,锅包肉",["暗影议会"] = "GM,英雄",["元素之力"] = "GL,碧蓝大熊熊",["激流之傲"] = "GL,独孤馨馨",["红云台地"] = "GL,魅之影",["试炼之环"] = "GL,康师傅的菜",["蓝龙军团"] = "GL,冰蝴蝶",["萨格拉斯"] = "GL,易安姐",["烈焰峰"] = "GL,懒懒的天",["大漩涡"] = "GL,Hollow",["斯克提斯"] = "GL,Revelation;GC,恶膜",["巫妖之王"] = "GK,婉熙丶,春风十里丶丶;GD,白银圣光",["奥拉基尔"] = "GK,排骨烩酸菜;GC,幽冥静风",["羽月"] = "GK,真武大帝",["地狱咆哮"] = "GK,江浸月;GG,白夜阑珊丶",["火焰之树"] = "GK,亢牛尤悔",["符文图腾"] = "GK,萨拉丶塔斯",["熔火之心"] = "GJ,诗野;GF,Vril;GB,新泰面条哥;GA,欧皇灬法,巅灬峰,Lintq",["夏维安"] = "GJ,杨世碧丶;F+,恋小燕",["莱索恩"] = "GI,Holyshock",["伊萨里奥斯"] = "GI,Kunforever",["月神殿"] = "GI,獵祖獵宗",["塞拉摩"] = "GI,枫寒叶残",["荆棘谷"] = "GI,最初丶",["毁灭之锤"] = "GH,三季蹈",["石爪峰"] = "GH,阿克懵德;GB,小熊七岁",["亡语者"] = "GH,狂热分子灬战",["菲拉斯"] = "GH,苦集灭岑",["黑锋哨站"] = "GG,不再忧伤",["阿迦玛甘"] = "GG,淼雪,双鱼之悦,双鱼之月,双鱼座,霜鱼座",["遗忘海岸"] = "GG,菊神",["暮色森林"] = "GF,聖光丶",["斩魔者"] = "GF,得啵得啵得",["卡德加"] = "GE,枫舞风铃",["瓦里安"] = "GE,陶宏开",["阿拉希"] = "GE,牌社的小胖",["铜龙军团"] = "GE,枫露饮",["巴瑟拉斯"] = "GD,长角獠牙;GC,大帅",["奥杜尔"] = "GD,希尽欢,暮悠然",["地狱之石"] = "GD,倾世女帝",["普罗德摩"] = "GD,秋风之刃",["哈卡"] = "GD,沃夫",["海加尔"] = "GC,无敌坏小子",["奥尔加隆"] = "GC,正面上我啊;GA,玛克希姆;F+,血丝朦胧,末洛艾尔",["桑德兰"] = "GC,魑魅魍魉家族;F+,虾饺丶",["天空之牆[TW]"] = "GB,可愛的魚魚",["龙骨平原"] = "GB,桃瑞丝丶",["大地之怒"] = "GA,从頭再来",["自由之风"] = "GA,乌瑞亚",["晴日峰（江苏）"] = "F/,涉川",["霜狼"] = "F/,第六小号",["洛萨"] = "F/,等灯等灯",["壁炉谷"] = "F+,冈本零零壹",["耐奥祖"] = "F+,糯米籽",["迪瑟洛克"] = "F+,Alsarser",["萨尔"] = "F+,王多鱼",["库德兰"] = "F+,东门斩兔",["末日祷告祭坛"] = "F+,幽幽寒冰",["黑翼之巢"] = "F+,Jasonhunter"};
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