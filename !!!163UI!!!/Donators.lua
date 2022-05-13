local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["伊森利恩"] = "ZY,星河枫;ZP,于浴菊;ZO,板甲依然在;ZG,丶青鸟,Sakota;ZC,泡酱大魔神,沉睡刀锋;ZA,兜兜酱丶;Y+,醉梦相思;Y9,黯灵;Y8,七尺生态牛肉;Y6,鲨鱼辣椒酱紫,下水道狂暴战;Y3,雨宮蓮;Y2,黑色德芙;Y1,夜店之王;Yz,重拳",["白银之手"] = "ZY,鹿栀栀;ZU,象山小道仙,极昼,伊零;ZT,死于装逼过度,永远爱马竞;ZS,大胡子大智慧,氵阿叶;ZQ,星星红了眼丶,星星落了枕丶;ZP,丹娣丶;ZO,玛德丶法科,Okasa;ZM,Chinfungpld,一步之遙;ZK,维多利亚秀芬,葉洛书;ZH,薄樱鬼,独孤善心,晋升冲击,打个咚咚;ZG,Sian;ZD,疯不觉丨丨,天使城,Babymillie;ZC,神奇橙夫人;Y+,色批头籽;Y8,请宝贝转身丶;Y7,粉嫩马竞球迷;Y6,说丶一,说一,爱吃糖的唐三,买香蕉去打怪,锦果果,伊姆大人;Y5,萌术萌萌哒;Y2,迷幻人生,賑早見琥珀川,芒果丶布丁;Y1,吃我一锤耶;Y0,流尽几世时光,圣劍;Yz,玩酷花少;Yy,榴莲小领主;Yx,电竞锰男;Yu,丶没办法,人归落雁後",["凤凰之神"] = "ZX,海耶斯穿山甲;ZW,长弓飞猎;ZU,允禾,哟灬尛柯;ZT,雪乃深冬;ZS,Bibiboomboom;ZQ,充钱那各少年,橙紫㐅,装甲掷弹兵;ZP,Corging;ZO,过路的酱油,Chunshuijc,学海幠涯;ZN,夏灬雪,生存猎;ZM,坏坏丷;ZJ,梦醉花海;ZH,Bibibibibibi,Bibigun;ZG,鬼舞辻法泠;ZF,来回溜达;ZC,饭团太郎;Y/,華夏丶阿里曼;Y9,丶洒脱,自由羽翼,牧泱犬,那个裂仁;Y7,安菲而德;Y6,三月廿九丶;Y5,圣光寇马克;Y3,情深;Y1,丨恶魔之子丨,树上的向日葵;Y0,翻云覆雨愁;Yz,血精灵丷椰羊丷,紅色冲动;Yy,猴晶旭;Yx,Meon,猫灬小舞;Yv,片小萨,虎丨鲸,椰奶椰奶;Yu,血斧钺戮,墨洺棋妙,张小锤丶,潇潇如雨,悠悠丨德丨心,Sandypriest",["末日行者"] = "ZX,胸毛萨满丶;ZM,恶灵挽歌;Y6,武术至尊",["黑铁"] = "ZX,雅典娜之刃;ZT,Palo;ZI,乐事妙脆角;ZD,丶可乐要加冰;ZC,冲锋释放;ZA,Nukenu",["伊利丹"] = "ZX,十三香下龙瞎",["???"] = "ZX,修;ZR,丶可乐大宗师;ZO,盗墓没笔记",["奥尔加隆"] = "ZW,万德福儿童团",["回音山"] = "ZW,叕叕;ZU,皮皮摧心魔;ZR,如花;ZQ,甘道夫灰袍;Y/,唯爱丶菲菲;Y5,爱媛果冻橙;Y0,双笙丶什么鬼;Yx,浪漫不加不减",["死亡之翼"] = "ZW,我踏马莱纳,初肆,丶独自等待;ZU,丷相公丷,葱爆鸡翅,楚狂丶;ZT,黑灬鬼;ZR,小鱼儿爱米莉;ZQ,路易丶德華;ZP,Manamasive;ZO,南酱牧宸,融化你的任性;ZM,丷老公丷;ZK,爱神小色;ZI,大鱼丷;ZG,紫米露,她不知道,麦子家的小郎,我不背钅呙;ZF,蓝色一望无际;ZD,血眸之魔,比较恐怖,李槐;ZC,法号丶老空车;ZB,普罗西斯;ZA,死亡之迷翼;Y9,落星贯日;Y8,丶要相信光;Y7,老沉了;Y5,五七;Y4,Witheredvine,Kamino;Y3,之神,三泽大地;Y2,在摸鱼;Y1,蒼海笑,五丶七;Y0,邹哥哥;Yz,绿若青衣,丶红酥手丶;Yx,无人赴约,仇恨之眼;Yw,她如景;Yu,老友如老酒",["主宰之剑"] = "ZW,逆闪;ZV,葉子豬;ZO,逆光兔姿;ZH,吉茵珂丝;ZE,阿咪児丶;ZB,初春踏雪;ZA,红莲狱火;Y8,兔兎;Y7,太阳系总队长,則卷千兵衛;Y4,露华龙;Y2,红得批爆;Y1,爬进去整丶,握不住的它丶;Yz,西红柿不西;Yy,叁天饿玖顿;Yw,哈罗丶麦芽虫;Yv,国服最强喷子",["艾萨拉"] = "ZW,丨游丨侠丨",["国王之谷"] = "ZW,白花恋诗;ZV,国服技师质检;ZO,黑暗咒师;ZM,恋萌萌丶;ZA,尤巴;Y6,冰墩墩雪容融;Y4,梦断不成归;Y0,春之欢愉;Yy,莫大先生;Yx,西丨猛;Yw,花花伊;Yv,咔德伽",["埃德萨拉"] = "ZW,心海呀;ZM,战吊没武器;Y+,湮灭连奏;Y4,Zerokk;Yv,丹丹别打啦",["烈焰峰"] = "ZW,星氪;ZM,大英雄阿拉什",["罗宁"] = "ZW,两个毛球;ZU,狐酱,罗小喵丶;ZT,会长缺徳不;ZP,人生如我,网红镇,我妻由乃;ZM,休凡,清澈的休繁;ZJ,玛塔丶索萨;ZI,仟燕;ZF,腰间盘,是真的椰;ZA,什么小豆苗,昂口田;Y/,东瘟疫之地;Y8,汉唐雄风,戰斗包子;Y6,丶丶斯卡,血染飘发;Y1,大地老虎;Yz,思淼圓圓;Yw,弋妖一独雨;Yv,就是这么烦;Yu,星有零稀",["无尽之海"] = "ZV,蹲坑要扶墙;ZU,观海,虚弱的黄毛,北方的狼族;ZK,扶墙而走;ZI,时常丶孤独;ZH,德柴兼备;Y8,艾泽再临;Y4,乄王胖哒,灰灰丨灰灰;Yw,真气啵;Yu,星花火灬",["希尔瓦娜斯"] = "ZV,缘灬君临;ZJ,心恸,一个眼神",["海克泰尔"] = "ZV,幽默纯属扯淡;ZD,驭风控弦乄;ZA,狐梅尔斯;Y+,陌灬人;Y9,暗夜树熊;Y2,米乐米乐",["雏龙之翼"] = "ZV,吃了就睡;Y6,尼古拉斯二狗,胡桃丶",["燃烧之刃"] = "ZU,該隐之吻,吃饱的小猪;ZQ,霍乱爱情;ZP,Killeoo;ZN,丶三茶;ZK,阿丁;ZG,不负曾经,烧尽;Y8,巴丁高瑞克什,言颜;Y7,假心人;Y6,性感的牙齿,十二点二十;Y5,虞狼罓罓;Y4,云端漫步,竹影凌风;Y3,雾隐貔貅,唯谦全吉;Y1,纯攻,大萨摩耶,丶谭咏麟;Yy,丿魑魅魍魎彡;Yv,Isaug",["阿纳克洛斯"] = "ZU,暗影灬烈酒;Y9,為人民服務;Y8,使徒;Y4,雷丶叱咤风云",["莱索恩"] = "ZT,御坂灬美琴",["克尔苏加德"] = "ZT,悠长假期,不破冰菓,大王我想活丶;ZS,风过影无痕;ZQ,花有重开;ZO,舒芙蕾;Y/,抠脚丶大叔;Y2,夜话白鹭丶",["梦境之树"] = "ZS,神血牧",["金色平原"] = "ZS,伊琳奈尔;ZD,雨过芙池;Y9,小凡凡丶;Y8,艾丝丶凯特;Y6,记忆的足迹;Yz,倚楼听雨;Yx,油腻麦迪昂",["布兰卡德"] = "ZR,莫西丨莫西;ZN,程鹿不送姜;ZH,微光暖暖;ZF,好梦留人睡;ZE,慕蓝晓晓;Y+,汝彼母寻亡乎,发一下光;Y5,暴怒的皮卡丘;Y0,夏沫呆呆;Yw,九个骑士;Yv,艾利摩尔;Yu,白欧欧",["巨龙之魂"] = "ZR,月缺不改光",["熊猫酒仙"] = "ZQ,渺淼炊烟丶,Clizumy;ZP,林苑清秋;ZH,兄台何出此言;ZF,了风;Y0,尤型拆卸者;Yx,也是鲁小胖",["贫瘠之地"] = "ZQ,醒醒的超人;ZP,改为鹅城的鹅,鹅城的鹅;ZO,牛柒柒;ZN,Scandy;ZK,臭臭迪尔;ZB,采蘑菇的阿姨;ZA,狂战霸天,待续丷,霜魂;Y+,过往皆为序章;Y5,Acan;Y4,冯晓萌;Yz,巴索罗米奧;Yy,听不见大声点;Yx,失落的陈;Yw,水云雨诺,狂野水饺",["银月"] = "ZQ,莪米豆腐",["泰兰德"] = "ZP,萌面欧尼酱;ZN,尼尔迪兰狄",["艾森娜"] = "ZP,禅师",["塞拉摩"] = "ZO,奎思;ZI,我的朋友很少;ZF,死硬肥牛;Yu,小红手露珠",["血色十字军"] = "ZO,艾别离;ZJ,邪恶光环;ZH,桂丶敏感鸡;ZF,森屿弥鹿;ZE,逝去的怨念,Brabbit;Y/,鱼我所欲;Y4,丶菜头丸;Yz,包丶仔;Yy,洵美且異",["影之哀伤"] = "ZO,易丨外星红大黑;ZM,灬烈刃,枫叶丨;ZI,让我欢乐一点;ZG,不爱抓宝宝;ZE,逝者之血;ZC,请叫我猫儿,阿吉;ZA,小红手丶阿卷,萝卜游侠,红心;Y+,丨止于终老;Y8,飘花为柒;Y6,酒厂之花;Y5,雨夏雨夜;Y2,再战九点零;Y0,凤梨味道;Yz,也曾摘星辰;Yx,翟老师;Yw,丶王小毛;Yu,变化,唐寅字伯虎",["玛维·影歌"] = "ZO,丨灬德古拉丶;ZH,晨熙",["迅捷微风"] = "ZO,旧时代卝残党;ZJ,大灭;Y0,充钱那各少年;Yz,洛希恩徘徊者",["托塞德林"] = "ZO,雨疏风骤",["通灵学院"] = "ZO,左手一只鸡",["遗忘海岸"] = "ZO,混帐的天空",["山丘之王"] = "ZN,用心创造快乐;ZB,雷神之箭;Yx,八钳蟹",["安苏"] = "ZN,月夜战女神;ZF,暴走一个吻;ZE,Jayc;ZD,黯灭之王,原初之王;Y8,Dzlqs,湛蓝千年;Y7,吉娜莱丝;Y6,天依真的无缝;Y5,一闲云野鹤一,Buluphont;Y3,醉眼望云烟丶;Y2,唯有活着;Y1,啊砸;Y0,秘法守护者;Yx,一百万;Yw,刺激哦,咕噜呀",["摩摩尔"] = "ZN,射丶",["格瑞姆巴托"] = "ZM,压迫衆生;ZI,潇静藤;ZG,狂暴战老王;ZE,早上不吃小面,不要为难胖虎;ZC,棍棍是好棍棍;Y+,Mzyzm;Y9,小红手迟迟;Yw,你打歪了",["丽丽（四川）"] = "ZM,劍鑫;ZC,星夜千雪月;ZA,圣殿丶之光;Y8,木籽灬;Y6,圣殿之光,主要看气质;Y5,星星侠;Y1,狐了狐了;Yx,小红手狂猎",["玛法里奥"] = "ZM,嗨嗨人生",["晴日峰（江苏）"] = "ZM,优湖骁",["冰风岗"] = "ZK,纤岚;ZH,桥豆麻袋;ZB,炽燃;Y6,羽衣直夏;Y1,薄荷茶茶;Y0,爱吃橙子",["霜之哀伤"] = "ZJ,乘乘她爸;ZD,南宫筠;ZB,不卖萌不振翅;Y7,何锐;Yx,Zinac",["瓦里玛萨斯"] = "ZJ,秦柏",["外域"] = "ZI,泡泡哒希",["艾欧娜尔"] = "ZI,殺人偿命",["雷霆之王"] = "ZH,壹米贰叁;Y6,伊莉亚;Yu,卡扎库衫",["逐日者"] = "ZG,尤丶迪丶安",["奥拉基尔"] = "ZF,弱点就在蛋上",["迦拉克隆"] = "ZF,五海雷点;Y9,乐然;Yv,西丨猛",["卡拉赞"] = "ZF,天呐你真帅;ZE,瓶子战",["屠魔山谷"] = "ZE,温暖的圣光",["奥妮克希亚"] = "ZE,Hillwind",["阿古斯"] = "ZE,傻男",["红龙女王"] = "ZE,西野七濑",["神圣之歌"] = "ZD,汝听之人言否;Y1,软饭硬吃",["天空之墙"] = "ZC,润鑫",["龙骨平原"] = "ZC,亲密接触",["暗影议会"] = "ZB,工具仁",["图拉扬"] = "ZA,葉雨阑珊",["荆棘谷"] = "ZA,希尔瓦纳丽思",["风暴之怒"] = "Y/,一头猪",["石爪峰"] = "Y/,流口水的老牛",["战歌"] = "Y+,瑟莉丝",["银松森林"] = "Y+,黄酒小菜",["铜龙军团"] = "Y+,佑逝",["太阳之井"] = "Y+,长岛冰茶丶",["诺森德"] = "Y+,落榜美术生",["阿迦玛甘"] = "Y9,茉小仙",["风行者"] = "Y9,落幕枯心",["冰霜之刃"] = "Y8,小甜甜李铁柱",["地狱咆哮"] = "Y8,花姑娘滴呦丶",["蜘蛛王国"] = "Y7,堕落西红柿",["朵丹尼尔"] = "Y7,孤儿所",["雷斧堡垒"] = "Y6,说丶一,说一",["幽暗沼泽"] = "Y6,诶丫丫疼",["亚雷戈斯"] = "Y6,坠落六翼天使",["夏维安"] = "Y6,肖申克救赎;Y5,德了个德",["寒冰皇冠"] = "Y5,靠拢",["鬼雾峰"] = "Y5,泡沫崽",["火羽山"] = "Y5,糖乀喵喵",["永恒之井"] = "Y5,背心裤衩",["永夜港"] = "Y3,师气帅",["黑锋哨站"] = "Y3,安妮可姬",["海达希亚"] = "Y2,糖伯虎点蚊香",["洛萨"] = "Y1,雷欧奥特曼;Yu,躲起来的瓶子",["血环"] = "Y1,泪流某个海洋",["达纳斯"] = "Y0,莱瑞蕾",["黑暗魅影"] = "Y0,桑桑威武;Yx,麦麦兜",["索瑞森"] = "Yz,知见立知",["迦顿"] = "Yz,花开淡墨痕",["暴风祭坛"] = "Yy,Yellowflashd",["安其拉"] = "Yx,Kadenz",["米奈希尔"] = "Yx,别死",["熔火之心"] = "Yx,给少年的歌",["萨菲隆"] = "Yx,青岚挽风",["血吼"] = "Yw,嗜血安抚驱散",["卡德加"] = "Yu,夜月圭"};
local lastDonators = "如花-回音山,莫西丨莫西-布兰卡德,丶可乐大宗师-???,伊琳奈尔-金色平原,神血牧-梦境之树,Bibiboomboom-凤凰之神,氵阿叶-白银之手,风过影无痕-克尔苏加德,大胡子大智慧-白银之手,大王我想活丶-克尔苏加德,会长缺徳不-罗宁,雪乃深冬-凤凰之神,不破冰菓-克尔苏加德,永远爱马竞-白银之手,悠长假期-克尔苏加德,黑灬鬼-死亡之翼,死于装逼过度-白银之手,御坂灬美琴-莱索恩,Palo-黑铁,暗影灬烈酒-阿纳克洛斯,哟灬尛柯-凤凰之神,北方的狼族-无尽之海,楚狂丶-死亡之翼,允禾-凤凰之神,罗小喵丶-罗宁,葱爆鸡翅-死亡之翼,伊零-白银之手,极昼-白银之手,皮皮摧心魔-回音山,狐酱-罗宁,吃饱的小猪-燃烧之刃,該隐之吻-燃烧之刃,象山小道仙-白银之手,丷相公丷-死亡之翼,虚弱的黄毛-无尽之海,观海-无尽之海,国服技师质检-国王之谷,吃了就睡-雏龙之翼,葉子豬-主宰之剑,幽默纯属扯淡-海克泰尔,缘灬君临-希尔瓦娜斯,蹲坑要扶墙-无尽之海,丶独自等待-死亡之翼,两个毛球-罗宁,星氪-烈焰峰,心海呀-埃德萨拉,白花恋诗-国王之谷,初肆-死亡之翼,丨游丨侠丨-艾萨拉,长弓飞猎-凤凰之神,逆闪-主宰之剑,我踏马莱纳-死亡之翼,叕叕-回音山,万德福儿童团-奥尔加隆,修-???,十三香下龙瞎-伊利丹,雅典娜之刃-黑铁,胸毛萨满丶-末日行者,海耶斯穿山甲-凤凰之神,鹿栀栀-白银之手,星河枫-伊森利恩";
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