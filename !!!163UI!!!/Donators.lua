local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["奥尔加隆"] = "UZ,托马斯维德;UN,五点睡觉刚好",["凤凰之神"] = "UZ,有钱通其道;UY,猴子涌波;UX,尐鹿斑比,嗜酒仙,裂开的李奶奶;UW,火超强,画丶雨,向錢,乄白夜,空气显卡,Cristianno;UU,灬璃洛灬;US,战坦丶,夜皇;UR,沈肖微;UN,云归丶;UL,桂丶渣王;UH,Mastor;UG,夜归寒;UE,桃花树;UD,秋秋百香果;UA,Biubiubiusm;T/,下陛王女我叫;T9,十年回忆杀;T8,禽王绕柱;T3,子夜流觞;T0,老扎皮;Tx,爱治衡真是太好啦,贺筱滢丶;Tu,Theconor;To,阳光宅男;Tk,执法长老;Ti,Montgoholy;Te,丶虚竹丶;Td,梦霜宇,小妞向前冲;Tc,终极版本答案;Tb,艾梅特赛尔克",["迅捷微风"] = "UZ,天贶十八;Tc,扶桑啊大红花",["罗宁"] = "UZ,鸡蛋唉;UX,杰丽蜜;UW,一起呸呸妚;UT,潋滟丨杯中酒;US,西索奇术师;UR,万色小萨,总监丶;UQ,遇见卫青青;UO,星辰巧克力;UG,九亿少女的梦;UA,挽梦;Tx,烈焰摩纳哥;Tv,聖乂骑;Tu,正义的伙伴;Tm,皮皮丹;Tk,轻寒寒;Tc,夏多雷希尔兔,佰寶",["白银之手"] = "UZ,花菜炒西红柿;UY,飒珥,玄可改命,宝贝美智子,左眼看不见;UX,丶神祇,灬吞吞;UW,丨圣圣,九央,刘伯阳丶;UU,弥紗;US,Enelm,变熊小能手;UL,紫風乄曼陀羅;UJ,Tendrennss;UI,妖沭;UG,小手拉大脚;UE,白贤;UB,无法吟诵的诗,孤独一大叔;T/,小火林;T+,徳鲁伊伊;T6,颜晓峰;T4,雨落雨听雨;Tx,多才多亿;Tu,远古洗只狼,暗键伤人,按剑伤人,戰圣;Tt,飞翔的复仇;Tp,打更;Tn,砸瓦魯多;Tl,射擊獵人,两亿男人的梦;Th,月下鹡鸰,利奥波德;Tg,爱丽菲儿,灰色兔兔,硅胶宝宝;Tc,有德必尸,砸瓦鲁多;Tb,蛋壳总是脆,缺德萌咕;Ta,为妳念咒;TZ,安牧茜",["蜘蛛王国"] = "UZ,煌黑终焉之影",["塞拉摩"] = "UY,迈克尔西安",["贫瘠之地"] = "UY,烂名字想半天;UW,老尼哥,孤心丶;UT,熬夜丶;US,可攻可受;UD,丶九曜;T7,帕拉伊巴;Tw,Carrotqiuqiu;Tq,Jeffery;Tn,丨紅尘烟雨丨;Tj,炎刃;Ti,九曜丶;Tg,射贱;Tc,布利瑞斯;Tb,婲落知多少丶",["燃烧之刃"] = "UY,丿苙宝乁,蒋晨晨;UW,维罗妮卡丨,不加糖,小心奕奕,山河皆可平;UT,Crowder;UN,丶小了白了兔,李阳脚很臭;UM,电臀静香;UJ,熊呆呆丶;UB,莽多多;T4,沐丨阳,天青惹寂寥;Tz,锦瑟華年;Tx,翀大师;Tj,烟焱;Ti,老白嗷;Tg,夜光小布丁",["死亡之翼"] = "UY,娶水,Juventusa,你知不知道啊,仲未死;UX,噼哩啪啪,米小妖;UW,丶哎哟喂,猫颜,浮生灬如夢,夕露沾我衣;UU,阿雯丶,栗子是神啊;US,法号丶吃鸡;UM,慕歌乄,进击的智齿,暮霭晨曦丶;UL,萌萌小可爱;UI,宁凝,洛神紅茶;UH,丶晞;UG,小丫头欸;UC,小訫訫,我是亻壬何;UB,薄雪中意晚莲;T7,神针子;T6,喂面之子,Kuxd;T4,鹧咕菜;T3,不必候;T2,Kuxiang;Tx,洛神红茶;Tt,越越辉辉;Ts,呆比丶,瞎来呛,奔五德;Tq,阿雯丶爱吃肉;Tm,青山之云,偷偷瞄,忘我大德;Tj,迷醉丨;Ti,Ameno;Th,雪拉贝祺朵;Te,丶蟹棒好吃;Td,离人丶泪;Tb,卩灬聖丨光",["山丘之王"] = "UY,笑靥如花;UB,风骑",["龙骨平原"] = "UY,徐痛苦灬;UE,徐然然丶",["埃德萨拉"] = "UY,Lovelydruid,狗头萨;UQ,扑街啊;UK,那夜;UC,爱吃榴莲千层",["影之哀伤"] = "UY,麻辣香鍋;UW,夜染孤影,君灬怜月,梦天丶戮;UU,孤儿;UO,豪傑;T2,诗淼,江小白不白;Tx,神秘抓根宝;Tv,大胸坏坏;Tp,狐噜;To,诗涵,夏夜暖风;Tm,逆戟鯨;Tg,捌月壹拾伍;Te,苍烟断",["埃加洛尔"] = "UY,阿西罢",["血色十字军"] = "UY,梦耿耿,怡和媛,风姿卓越;UR,说了不听,苏墨菸;UN,大丁丁丶;UA,岁月清欢;T4,甜丶瓜;T1,Ytc;Ty,林小藻,林小枣;Tx,秋日晴空;Tw,战神伍陆柒;Tu,溜名犬;Tk,潋滟丨杯中酒;Tg,黄鸭叫;Tf,因芸;TZ,不信鬼神",["翡翠梦境"] = "UY,实力电击;UO,不要再胖了;Tm,我无限嚣張",["熊猫酒仙"] = "UY,娜娜奇丶;UW,黝黝呦嘿;UU,豆丶小狐;UN,熊丷二,蓝鲸丶杀戮,殇魂丶烟雨;T1,熊贰灬;Tz,清河小影;Tl,骑白虎的饺子",["???"] = "UY,摧残野菊花;UW,门门宝宝,Alive;UQ,欧吧噜",["格瑞姆巴托"] = "UY,紫薯布丁丶;UW,胸腔闭式引流;UT,北望天狼星;UQ,吃掉烤咕咕;UM,子参宿狩;T+,銀发;T3,石生缘;Tt,芒果绿茶;Td,可乐灬乄;Tb,一云丶",["麦迪文"] = "UY,独守达菲;UQ,叶洛",["银松森林"] = "UY,拙拳;UW,最爱方思思;Tc,樱桃",["托塞德林"] = "UY,萧瑟",["伊森利恩"] = "UY,你踩到我了,孤山;UW,江南丶郭大侠,好喝的冰阔落;UK,再一次拥抱;UJ,毛茸茸的爪;T7,暗影之境丶纞;Tv,年华灬流光;Tm,上学威龙;Tj,Floorjansen;Ti,何以解忧丿,丶言松语,叶公子;Th,伊西;Te,小紅仁",["亚雷戈斯"] = "UY,素梦瑾然",["萨菲隆"] = "UY,鸡腿菇凉",["冰风岗"] = "UX,丶画心,牛肉法棍;UW,琴瑟灬,幸運观众,小狐妖王;Tp,大地震击暴击;Te,帅帅滴板砖酱;Td,天韵五五",["霜之哀伤"] = "UX,林加德;UR,乱花迷人眼;T5,丹尼斯莱耶斯;Tz,白桃乌龙茶丨;Tt,快乐之海;Te,瑞灬弑",["克尔苏加德"] = "UX,板栗丶,丶板栗;UW,噬渊行者;UU,青言;US,戰神降临灬;UQ,Devilive;Tm,依旧的依旧,魔法燃烧;TZ,清妤,八度余温",["遗忘海岸"] = "UX,Yyboom;UU,月见花开",["主宰之剑"] = "UX,艺兴;UW,谷令秋;T/,月色太清;T8,戰神飄雪;Tk,维内托里奥;Te,無上菩提",["安苏"] = "UX,多肉葡萄好喝,冲丶鸭,暗影沚殇,可爱点点;UW,夜舞陵歌;UR,Treasureess;UK,豆仔丶;UH,江廷宇;UG,Christinamar;T+,时暖时荫凉;T9,聆听雨声丿墨;T7,春不晓;Tz,村东头老高;Ty,奔跑的晓蜗牛;Tx,灵小龙,强力的小明;Tt,Playerjmbbwr,天生喜剧;Ts,一拳捶毁你;Tj,兄弟你兽了;Ti,亞單",["无尽之海"] = "UX,圣光下打伞;UW,黑旗军;UQ,唯独我逆流行;UB,佑诚;T4,丨艾特丨;T3,灵性丶;Ty,扶我上魔兽;Tx,Rita;Tr,八块腹肌喵;Tp,马里奥煎饼;Ta,罒壹罒",["海加尔"] = "UX,紫月重明",["诺兹多姆"] = "UX,恩希尔;UU,风雨飘零",["神圣之歌"] = "UX,追寻曾经;T0,仟羽;Ti,白云兮丶",["国王之谷"] = "UX,吾歌;UW,响油鳝丝;UM,江隂饅頭;UF,月影灬轻风;T8,苏菲不漏;T4,颂雨;Tz,璀璨青春;To,武园枯藤朵兰,乡下土著人",["冰霜之刃"] = "UX,博士斌",["奥特兰克"] = "UX,特级大厨诺米;UT,春风不寒",["丹莫德"] = "UW,我还能二段跳",["雷霆之王"] = "UW,吕一炮;T/,阿杨丶",["红云台地"] = "UW,方小辰",["阿比迪斯"] = "UW,至尊牛宝",["金色平原"] = "UW,雅安丶芯缘;UK,麦芽小可爱;UA,千叶清秋;T8,阿吉;T1,霍拉拉;Tp,塞理德恩",["泰兰德"] = "UW,夕綺;T+,何以为",["巫妖之王"] = "UW,素晴",["加兹鲁维"] = "UW,黑铯瑬星",["风暴峭壁"] = "UW,月黑风高",["圣火神殿"] = "UW,紅茶媽媽",["洛肯"] = "UW,牛肉馅儿饼;T6,Zellenleiter;T4,銠鑫",["狂热之刃"] = "UW,丨大脸猫丶;UH,清澈的爱;T7,我说一个数;Tu,百威宝贝,小二班班;Tm,汗臭少年",["拉文凯斯"] = "UW,小青橘,青兒",["厄祖玛特"] = "UT,没有坏心思",["鹰巢山"] = "UT,霸王別急",["霜狼"] = "UR,李子成",["血环"] = "UR,射箭大汉",["永恒之井"] = "UQ,曾经拥有的梦;Tw,小毒蛇",["菲米丝"] = "UQ,落木",["阿纳克洛斯"] = "UP,Galaaxy;Ts,華夏丶戰之魂",["鬼雾峰"] = "UP,灬筱阳丿翛燃;Ti,荙芬奇",["回音山"] = "UO,伊格普勒伊尔,维缇绮纳;UL,青寒钺;T2,圣美美;Tr,白首;Tg,半山桥野兔;Te,翼雪",["布兰卡德"] = "UO,抹茶红豆糖",["黑石尖塔"] = "UO,伊修托利",["戈提克"] = "UN,烈酒傷神",["月光林地"] = "UM,西门玄乔",["雷斧堡垒"] = "UM,小女娲娘娘;T7,Ipromise",["夏维安"] = "UM,性感大屁屁;Tw,团结就是力量",["荆棘谷"] = "UL,堕落中的男神",["燃烧军团"] = "UL,波利的梦",["伊利丹"] = "UK,改名为领导先走;T7,Woolala",["元素之力"] = "UJ,切丶格瓦拉",["雷克萨"] = "UH,雪花飞飞",["军团要塞"] = "UH,伤灬感入侵",["米奈希尔"] = "UG,灰飛煙滅丶",["安纳塞隆"] = "UG,幼儿园老大",["塞泰克"] = "UG,夜之眸",["红龙女王"] = "UF,龙丶妖;T9,丶老白",["梦境之树"] = "UD,Qi,七濑",["阿拉希"] = "UC,英雄出少女;Tq,蕾丝天鹅蛋",["艾露恩"] = "UA,非常哇塞",["暗影之月"] = "UA,熔火之心",["辛迪加"] = "UA,断反",["奈法利安"] = "T9,麻老李",["丽丽（四川）"] = "T7,小念儿;T3,贴心小宝贝",["迦拉克隆"] = "T7,小善萱;Tz,丶谭咏麟;Tn,油条;Tb,希望的灯火",["洛丹伦"] = "T5,遗忘灬记忆;Tq,今晚月色真美",["水晶之牙"] = "T3,整他",["末日行者"] = "T3,吉喵;Tt,爷傲奈我何丨,爷傲丨奈我何;Tb,野蛮丨大疯子",["桑德兰"] = "T1,威尔谢尔",["盖斯"] = "T1,从良詹事",["破碎岭"] = "Ty,希尓咓娜斯",["黑铁"] = "Tw,强袭牛叔",["黑暗虚空"] = "Tv,無伈戀愛",["黑翼之巢"] = "Tv,暴走小怪兽",["索瑞森"] = "Tv,可爱的柯",["亡语者"] = "Tr,魔兽世界;Te,云淡心晴",["娅尔罗"] = "Tr,铁头娃二",["埃雷达尔"] = "Tp,南鸢大人",["卡拉赞"] = "To,八六年凉白开",["雏龙之翼"] = "To,不会就要练;Tl,血色幽蓝",["藏宝海湾"] = "Tl,???",["图拉扬"] = "Tl,小小雪花",["壁炉谷"] = "Tl,近松十人众",["风暴之怒"] = "Tj,塑以花之形;Te,天然元素",["深渊之巢"] = "Th,丿田鼠",["能源舰"] = "Th,巫月",["月神殿"] = "Tg,刪除於終點",["瓦丝琪"] = "Tf,小瓶盖儿",["罗曼斯"] = "Td,因为蛋疼所以",["世界之树"] = "Td,Stillalive",["凯恩血蹄"] = "Tc,闪伯利恒之星",["瓦里安"] = "Tc,陈年老号",["朵丹尼尔"] = "Tc,Miuinitio",["海克泰尔"] = "Tb,叮噹咕嚕",["白骨荒野"] = "Ta,羽月希丶,幻之地狱"};
local lastDonators = "灬吞吞-白银之手,特级大厨诺米-奥特兰克,可爱点点-安苏,博士斌-冰霜之刃,吾歌-国王之谷,暗影沚殇-安苏,冲丶鸭-安苏,丶神祇-白银之手,追寻曾经-神圣之歌,恩希尔-诺兹多姆,杰丽蜜-罗宁,嗜酒仙-凤凰之神,紫月重明-海加尔,圣光下打伞-无尽之海,多肉葡萄好喝-安苏,艺兴-主宰之剑,Yyboom-遗忘海岸,米小妖-死亡之翼,牛肉法棍-冰风岗,尐鹿斑比-凤凰之神,噼哩啪啪-死亡之翼,丶板栗-克尔苏加德,板栗丶-克尔苏加德,林加德-霜之哀伤,丶画心-冰风岗,鸡腿菇凉-萨菲隆,素梦瑾然-亚雷戈斯,孤山-伊森利恩,你踩到我了-伊森利恩,萧瑟-托塞德林,拙拳-银松森林,独守达菲-麦迪文,狗头萨-埃德萨拉,紫薯布丁丶-格瑞姆巴托,风姿卓越-血色十字军,摧残野菊花-???,仲未死-死亡之翼,娜娜奇丶-熊猫酒仙,实力电击-翡翠梦境,怡和媛-血色十字军,梦耿耿-血色十字军,左眼看不见-白银之手,阿西罢-埃加洛尔,宝贝美智子-白银之手,你知不知道啊-死亡之翼,麻辣香鍋-影之哀伤,Juventusa-死亡之翼,Lovelydruid-埃德萨拉,猴子涌波-凤凰之神,徐痛苦灬-龙骨平原,蒋晨晨-燃烧之刃,玄可改命-白银之手,笑靥如花-山丘之王,飒珥-白银之手,娶水-死亡之翼,丿苙宝乁-燃烧之刃,烂名字想半天-贫瘠之地,迈克尔西安-塞拉摩,煌黑终焉之影-蜘蛛王国,花菜炒西红柿-白银之手,鸡蛋唉-罗宁,天贶十八-迅捷微风,有钱通其道-凤凰之神,托马斯维德-奥尔加隆";
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
      if topNamesOrder[players[index]] then row.name:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(name)) else row.name:SetText(name) end
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