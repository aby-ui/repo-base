local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,释言丶-伊森利恩,绾风-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,天之冀-白银之手,丶小酒鬼-无尽之海,坚果别闹-燃烧之刃,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["月光林地"] = "JD,小猪瞧痣;I1,西行桜吹雪;Iy,小高兴五号",["凤凰之神"] = "JD,是木子阿;JC,旧梦丶红尘;JB,Hypnos;JA,梨子酱,罔二小;I/,绵绵秋雨,没吃早饭,奥曰天;I+,开飞机的貝塔,洪荒,相逢恨晚,洛大马,小仙女迷迷乐;I9,素年大欧皇,大榴蓮;I7,王妃酱,丨苹灬果丨,伊鹤偶像传奇;I5,糖芯丿;I4,别问丶奶不了,虚空大奶;I3,孤獨根号三;I2,意不尽,奈何;I0,嗜血悍匪丶,打鼾的艾瑞克;Iz,丶十点半丶,夕谣;Iy,黑暗莽夫丶;Ix,红花石蒜;Iw,战了个火;Iv,可樂伽冰,黑八兔,Swarlocks",["血色十字军"] = "JD,艾瑞利蕥;JB,清風徐来;I/,帝珑;I+,沐浴聖光的妞;I5,咕呖咕呖,言灵者,布克罗里;I4,花开荼蘼;I2,籣卿卿,全明星蔡徐坤,凌丶绝丶顶;I1,丶潮汐;Ix,情浅缘深;Iw,自闭的皮卡丘;Iv,琥珀大人",["???"] = "JD,凌晨丶花未眠;JC,圆夜小调,月神眷属,丨不懂先生;JA,夏天以末;I+,呼啦啦哗啦啦;I5,晒太阳的鱼",["冰风岗"] = "JC,晓湿媚,孤独灿烂的鬼,枭小笑笑;JB,喵喵阿昆达;I/,承崎;I6,残月璃殇;I5,淡淡无奈;I3,迷雾漫天,等饵的鱼;I0,淡淡無奈;Iz,夜带屠刀,爆炒大咕咕;Iy,腹肌侧漏",["伊利丹"] = "JC,天上哦;I+,Devastate;I1,月下的肖邦;Iw,银河星爆",["燃烧之刃"] = "JC,苏联科学家;I/,执丶行人,师承蔡徐坤丶;I9,丿初秋丶;I8,鲁东东回来了,Atrocious,葬爱柴少,葬爱張少,黑色火柴;I6,菈菈蕾,殺戮的藝術,紅的你嗷嗷叫;I4,Issho,雕刻时光;I2,踏尽苍穹;I0,長襟落落秋風,御涯哥哥;Iy,传说之上,叁千世界;Ix,正义的欧小蓉;Iw,小小的老七;Iv,霜之风行者",["白银之手"] = "JC,安灬小希,越桑;JB,砍怪升级,芣滈興;JA,阿里海蓝,鱼衣,Fovdh;I/,雪雨新風;I+,荷影,浅墨初雪;I9,Majula,长源一哥培生;I8,赤月霜华;I7,家里囿矿,威风大咕咕;I6,喓吆酱,大脸狂魔,一只麻瓜;I5,Skott,天之冀,塵汐;I4,韶光无返;I3,季末心微凉,欧皇丶和天下,谦玉;I2,上善丨水,無影之刃,英短小白猫;I1,狩猎大师,枫羽凝雪,Cularri,那时的时光,摇滚西瓜,暗影蘑菇脆,战场老军医丶;I0,背心尊者丶;Iy,|圣騎士,虎牙五哥,乱战风语;Ix,妖妖的小牧,妖妖的小骑;Iw,妙成山;Iv,浴火焚身,本居小鹅",["克尔苏加德"] = "JC,Dreamseeker;I5,旁友结棍;I0,不落橙梦",["国王之谷"] = "JC,孤独的小浣熊,Thisisstar,偶尔有阵雨;I+,DeadBoom;I8,墨明棋喵;I6,大德如风,豆丁大大,不畏不念,雲成;I5,雨落蒹葭;I3,眉带灬凶兆,妳一号,防波亭鬼灯;Iy,冷玥葬花魂;Iw,虚法;Iv,亚里士不缺德",["熵魔"] = "JC,我愛御姐;I8,春三十娘",["燃烧平原"] = "JC,艾旎;I8,无心柳成荫",["远古海滩"] = "JC,凤凰曜;I0,灵魂收歌者",["安苏"] = "JC,射射花抖;JB,氵疯僧、,迷硴;JA,奇异昂;I/,恍然小悟;I9,张靖怡;I8,Ayacolyte;I7,成小涛,高升桥李伯清;I6,曾经的王者丶;I4,部落最骚骑士;I3,摇曳的雨;I1,小雲子;I0,兮门灬大官人;Iz,凡顺,歆懿;Iy,唯有孤独永恒;Ix,夜幽月,周淑怡妹妹",["加基森"] = "JC,九江双蒸;I+,风度初相遇,狂野的骑士;I6,哆啦的小胖胖",["达纳斯"] = "JC,魂断;I4,影风泪",["迅捷微风"] = "JC,丿宝爷丶;I/,叫丶兽;I6,奇德隆冬槍;I0,丶苏一",["罗宁"] = "JC,黑暗深邃;I6,呜咽梨雨;I2,花无人戴,国粹;I0,爱林依依,瑾嫣灬,悄悄雨歇;Iz,虎姑婆咕咕,Phaedo;Iv,红油抄手丶",["熊猫酒仙"] = "JC,月光优雅;JB,Xiangnan,灰灰的小灰机,马坡三井寿;JA,塔子哥;I9,似水榴莲,熊猫陈酿;I8,阿尓瀚娜星光;I6,尹正,克雷斯波波;I3,别问,弑君者;I1,秦时明月;Ix,幽影之血",["阿纳克洛斯"] = "JC,人工;I6,稀小饭丶;I5,人型自走荣誉;I2,Slrlus",["奥特兰克"] = "JC,小可玉,贱三爷;JB,别惹狐狸;I9,袜子大婶;I4,苇茗一粒丹;Iz,奶瓶丶;Iw,安你大姨;Iv,唯雅诺,丷萌骑丶",["熔火之心"] = "JC,桃爷;I6,马小樂;Iy,生来彷徨",["贫瘠之地"] = "JC,酒厂之花;JB,野丶風,霒蚀君;I9,Yirsy,大领主丨殇;I8,假說,秋月澪;I6,困惑的柏拉图;I5,抖音主播汐寒;I3,宝光如來;I2,木喊木德;I1,戰塵,倾城之喵,長枪守唐魂,晨曦灬不见;Iz,啊童木,斗鱼;Iy,萌走鱼尾纹;Iw,派罗欣;Iv,少年蓝色经典",["火焰之树"] = "JC,Alex;JB,不见炊烟",["狂热之刃"] = "JC,丨韩绮兒灬;JB,李猜猜;JA,幽暗灬大大;I9,Idolo;I7,融融月",["布兰卡德"] = "JC,退堂鼓演奏家;I+,沈季禾;I9,请勿抚摸投食;I7,铁剑男扎克,铁剑男;I4,无敌大大龙;I2,琴月阴;I0,我会出鹦鹉的;Iz,伊小博;Iy,大咪小可怜;Ix,叮咚叮",["壁炉谷"] = "JB,清溪澈,逺坂凛",["金色平原"] = "JB,买了否楞;I+,凯瑟琳丶汉妮;I8,听风看海;I6,鴨子们的爪牙;I5,花粥、;I3,绾风;Iy,徐大锅;Ix,㗊㗊,程婕琦;Iv,Qazshara,艾欧蕾娜",["死亡之翼"] = "JB,伯牙绝铉,小乄鱼;I/,安好丶无念;I+,理想永远年輕,碎影立画,流云永殇;I9,鹌灬鹑;I8,冰霜丶兄弟;I7,Olnytwo,西風凋碧樹;I6,彼岸的青桃,蛞曰鸡;I5,潇湘灬夜羽,那哖灬嗄兲,麦兜响当当丶;I4,德真香;I3,丨紅尘烟雨丨,Aidenoo,滕总;I2,上善若死,夙世,红手的阿昆达,秦风细雨,浅风细雨,宮商角徵羽;I1,Guatama,喵星喵月,虾饺灬,思舟丶;I0,乄冉冉乄,村儿里一枝花;Iz,無名斬神;Iy,枫凛寒丶;Ix,迷尸人体,无聊的胡椒;Iw,桃花源,紫氣丨東來,花凉,大秦帝国张仪;Iv,蛇眼千秋,杀手马里奥,漣屮漪",["格瑞姆巴托"] = "JB,小胖虎,店长;I9,无情的太阳,回忆是星辰;I8,释雪开;I7,晨曦雨露,罐罐嘚瑟;I6,喵呜丷,Exlancer,秋风冷画屏丶,夜风中的香烟;I5,石楠烟斗的雾,丶夜饮黄泉,苏小樾;I2,灵弓逐月;I1,逝去乄流年,数流年空悲喜;I0,彻彻霸霸;Iz,骨弦丶,Yerger,灬十二丶;Ix,尽海蜃城;Iv,一魔山一",["主宰之剑"] = "JB,牧丝一枚;JA,我不会后跳,梦里是谁;I/,何去何從灬;I+,丨咬人猫丨;I9,歐洲小能貓丶;I8,茱茱的大表姐;I7,你吉吉贼小;I5,喜之郎;I3,丷月溪;I2,阿威十八,初丷恋;I1,梅林贝尔,主宰战十三,街角丶卖风骚,史上最萌萨满;I0,兮柔;Iz,身材惹火,酒至微醺;Ix,純情小正太;Iw,你好哇李银河,沉霜落烬乄;Iv,尘封记忆丷",["遗忘海岸"] = "JB,林初一",["奈法利安"] = "JB,Tcmuik",["阿拉索"] = "JB,心之傷;I8,花眠之夜,夢見紫,灰兔兔",["神圣之歌"] = "JB,子嗯丶;I4,三好",["回音山"] = "JB,青龙春丽拳;JA,一箭一小朋友;I+,暗黑之镰;I7,蓝小法;I5,碎蓝;I2,似你如风丶;I0,愿你酷的像风;Iw,泰温",["霜狼"] = "JB,月下丶影无尽;I/,源一;I4,Lesslight;I3,希瑞斯",["摩摩尔"] = "JB,于元岚",["雷霆之王"] = "JB,星贤者罗兰;Iw,幻星辰",["黑铁"] = "JB,成瀬心美;I/,久伴不离;I3,熊志远他四叔;Ix,弥雅;Iw,极光丶小苹苹",["风暴之怒"] = "JB,故土难离",["古加尔"] = "JA,艾伦希亚",["加兹鲁维"] = "JA,鉴黄师;Iw,夜霜之哀",["血环"] = "JA,猫老师;I+,范晓萱;Ix,阿克西斯;Iv,BrocksCarlos",["阿曼尼"] = "JA,熊猫仙子",["影之哀伤"] = "JA,Zozii;I+,小杨哥,王小枪;I9,风丶玻瑞阿斯;I7,李小弋,郎财女貌;I4,刹那星辰,澄墨乄;I2,传说中的御姐;I1,圣丶治愈;I0,季秋,一蓑夕阳丶;Iz,胸口坦荡荡;Iy,织雾丨糖糖;Iw,王小强;Iv,丶钟馨彤彡",["朵丹尼尔"] = "JA,我尾巴不见了;Iz,无敌奶爸",["无尽之海"] = "JA,橙子好吃吗;I/,鸿蒙生死印;I7,微微轻风;I6,工地少年与砖,Unicron;I5,青梅煮;I4,烟火浊了身;I2,小喵喵闹翻天;I1,三亩地,贪恋你的人生,丶小酒鬼;Iz,夏大屋丶,俊哥橙子夜;Iv,薩穆羅,卓绝网吧",["塞拉摩"] = "JA,白小喵丶;Iv,花開丶若相依",["烈焰峰"] = "I/,格里巴巴变;I8,加丨基丨森",["伊森利恩"] = "I/,慕暖,瓦西里的枪;I+,摩登大圣;I6,丷满锅丷;I5,假动作;I4,彼得一激灵;I1,湯圆;I0,傲娇的蒋美美;Iy,汨開朗基羅;Ix,左小左",["太阳之井"] = "I/,依然因你幸福;Iz,黯夜降临;Iv,Aice",["海克泰尔"] = "I/,软萌小德;I9,雨潺潺;I8,典爹;I6,影歌之玉;I5,仰望星空;I2,丨红丨,Yzlee;Iw,点娘",["亚雷戈斯"] = "I/,场极式耳机",["阿古斯"] = "I/,跑尸天使;I7,丿摩云丨千殇;I4,不是憨憨杰尼;Ix,吾敌即黑暗",["天空之墙"] = "I/,哎哟奶起了",["激流之傲"] = "I/,幺陆零伍",["末日祷告祭坛"] = "I+,花间丶一壶酒;I6,恶魔之魇",["火羽山"] = "I+,倾城乄绝恋;Iv,猫猫乖",["埃德萨拉"] = "I9,赞我出九八五;I7,丶少女杀手,卡溹丶;I3,无限星语;I2,氵卅;Iz,Comedian;Iw,百合女王",["图拉扬"] = "I9,狡猾的鲤鱼王,紫炎女王",["芬里斯"] = "I9,演员",["拉文凯斯"] = "I9,Lnln",["艾露恩"] = "I9,小王妃;I8,東夜;I6,尺酒将夜;I2,阿碧丝",["萨菲隆"] = "I8,暗暗重生",["萨尔"] = "I8,电胖达;I6,分手德纪念;Iw,小茉璃",["诺莫瑞根"] = "I8,易悠晨",["诺森德"] = "I8,寒小夜",["克洛玛古斯"] = "I8,红烛",["破碎岭"] = "I8,豆里玩",["永恒之井"] = "I8,风过水依然;I4,小宝贝声望号;I2,艾伯特丶暗砧;I0,菜鸟斌;Iy,鱼亡深海;Ix,比利巴特森",["末日行者"] = "I7,灬仙仙;I5,十万城管;I2,尔東,莉莱丶霜语者;I0,大壊狼,守孤城;Iz,Sunsui,冰冰貓,动若疯喵;Iy,邪幅;Ix,尐聋瞎,荼月",["石爪峰"] = "I7,阿福坐飞机",["洛丹伦"] = "I7,班殳之猎;I2,醉拳大战萝莉;I1,麦兜",["凯恩血蹄"] = "I7,茉祈之殇",["暗影之月"] = "I7,坛九;Iy,妃凌雪",["霜之哀伤"] = "I7,情殤丶;I4,野格陪红牛;Iy,无色的白,一串糖葫芦",["泰兰德"] = "I6,Djentgirl",["奥蕾莉亚"] = "I6,全村人的希望;I2,奔跑的红烧肉;I1,抵抗;I0,兰斯洛",["阿比迪斯"] = "I6,燃烧的萨克尔",["辛达苟萨"] = "I6,莉莉斯",["龙骨平原"] = "I6,手丶指丶;I5,若影如烟;I0,奥德瑞亚",["瓦里玛萨斯"] = "I5,打手甲",["斯坦索姆"] = "I5,迪亚小波罗;I2,血刃血纹;I0,匕尖上的恶魔",["战歌"] = "I5,加尔鲁神",["罗曼斯"] = "I5,Looby",["月神殿"] = "I4,休伦神王希拉",["通灵学院"] = "I4,杰洛特丶",["迦拉克隆"] = "I4,无情葬月丶;Iy,一锅炖魔法,米拉库鲁;Iw,天光",["轻风之语"] = "I4,饿摸猎首",["鲜血熔炉"] = "I4,彼得一激灵",["安纳塞隆"] = "I3,啊菜",["艾莫莉丝"] = "I3,被窝里的呻吟;I0,一只;Iz,半点杀机暗藏;Iy,独影随风;Ix,天国之法",["深渊之巢"] = "I3,张语格",["风暴峭壁"] = "I2,戴兹",["铜龙军团"] = "I2,鱼壹壹;I0,五七酱",["蜘蛛王国"] = "I2,吖苍丶;I1,狗头通灵使",["双子峰"] = "I2,上步七星",["血顶"] = "I2,人超级闲",["凯尔萨斯"] = "I2,一生之萌",["伊萨里奥斯"] = "I2,沈小妍",["甜水绿洲"] = "I2,紫悅",["森金"] = "I1,血色即永恒",["红云台地"] = "I1,苍冰绯炎",["巨龙之吼"] = "I1,静静的笨总",["大地之怒"] = "I1,认识贼么",["晴日峰（江苏）"] = "I1,樊默",["穆戈尔"] = "I1,酋头人牛长",["奥尔加隆"] = "I1,Rarecandy",["玛瑟里顿"] = "I0,小奶嘴",["迦罗娜"] = "I0,墨炎凌",["奎尔丹纳斯"] = "I0,改名变欧皇",["千针石林"] = "I0,上阿迪杰;Ix,土豆烧排骨丶",["毁灭之锤"] = "Iz,Fancy",["盖斯"] = "Iz,宁珂郡主",["埃克索图斯"] = "Iz,精灵娜娜",["恶魔之魂"] = "Iz,酸奶西米露",["艾欧娜尔"] = "Iz,小小甜心",["翡翠梦境"] = "Iz,卖萌的尸姐",["银月"] = "Iz,姐姐的房间",["阿迦玛甘"] = "Iz,古德猫宁",["日落沼泽"] = "Iy,织雾小玉",["冰霜之刃"] = "Iy,Nzz",["亡语者"] = "Iy,羽渡尘",["丽丽（四川）"] = "Iy,告死鸟,夏末灬微凉;Iw,纪晓芙丶",["奥斯里安"] = "Iy,辣椒小超人",["扎拉赞恩"] = "Iy,似雨若离;Ix,失眠到天亮",["拉贾克斯"] = "Ix,念着我的名字",["耐奥祖"] = "Ix,独孤求败",["阿卡玛"] = "Iw,虚空夜宴,文文弱弱",["苏塔恩"] = "Iw,一板砖拍死你",["伊瑟拉"] = "Iw,紫焰星魂",["刺骨利刃"] = "Iw,口古丿口古",["利刃之拳"] = "Iw,狗尾花与猫",["达基萨斯"] = "Iw,壮士请留歩",["冬泉谷"] = "Iw,夜子寒",["海加尔"] = "Iw,笨兮兮",["莱索恩"] = "Iv,鲜血",["古尔丹"] = "Iv,夜仞",["阿克蒙德"] = "Iv,沐与花如笺",["阿尔萨斯"] = "Iv,貓小沫",["风行者"] = "Iv,蔷薇花开",["奥杜尔"] = "Iv,倾国",["霍格"] = "Iv,愿圣光庇佑你"};
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