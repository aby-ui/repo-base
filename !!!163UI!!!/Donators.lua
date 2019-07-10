local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,释言丶-伊森利恩,绾风-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,丶小酒鬼-无尽之海,坚果别闹-燃烧之刃,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["无尽之海"] = "I4,烟火浊了身;I2,小喵喵闹翻天;I1,三亩地,贪恋你的人生,丶小酒鬼;Iz,夏大屋丶,俊哥橙子夜;Iv,薩穆羅,卓绝网吧;Ir,杰克莱耶斯;Iq,呦呦白鹿,靑崖白鹿,咔喇咔喇丶;Ip,灵魂征战;Im,绵绵秋雨;If,Haatxl",["阿古斯"] = "I4,不是憨憨杰尼;Ix,吾敌即黑暗;Io,栀夏暖阳;Ii,一条咸鱼王",["白银之手"] = "I3,季末心微凉,欧皇丶和天下,谦玉;I2,上善丨水,無影之刃,英短小白猫;I1,狩猎大师,枫羽凝雪,Cularri,那时的时光,摇滚西瓜,暗影蘑菇脆,战场老军医丶;I0,背心尊者丶;Iy,|圣騎士,虎牙五哥,乱战风语;Ix,妖妖的小牧,妖妖的小骑;Iw,妙成山;Iv,浴火焚身,本居小鹅;Iu,鬼弁,白白的賊,陆熙熙;Is,無常丷情郎,快乐小铁人,温柔对峙,熊老板爱吃面,室女座星云,超级大坏坏,归来且少年;Ir,瓜瓜哒,小躷人児,不拜萧曹,卡嘉莉丶,小猪被宠坏,小水珠幻无影;Iq,耶尔夫帕拉丁,对弈飞黑白,丨荏苒丨,白衣如雪丶,黑铁全能骑士,丶功与名,炸酱面就大蒜,Leserein;Ip,丿輕淺丶,有坚不摧之盾,丿忘忧灬,李晓胖,米拉杰丶,奥露拉黛儿,一路心碎,夜雨聆風;Io,大厨诺米;In,勇者斗恶猪;Im,德挠人且咬人;Il,单点珍珠奶茶;Ik,風骚;Ij,紫陌丶蓝海;Ii,转角遇倒贼;Ih,樱花怒;Ie,孟超然丶",["安纳塞隆"] = "I3,啊菜",["艾莫莉丝"] = "I3,被窝里的呻吟;I0,一只;Iz,半点杀机暗藏;Iy,独影随风;Ix,天国之法",["深渊之巢"] = "I3,张语格;Ii,甘兴霸",["冰风岗"] = "I3,迷雾漫天,等饵的鱼;I0,淡淡無奈;Iz,夜带屠刀,爆炒大咕咕;Iy,腹肌侧漏;Iq,想风也想你;Ip,兜兜裏有橙,浅色夏天,乾坤大挪移;In,凛冽的寒风;Il,龙彡",["贫瘠之地"] = "I3,宝光如來;I2,木喊木德;I1,戰塵,倾城之喵,長枪守唐魂,晨曦灬不见;Iz,啊童木,斗鱼;Iy,萌走鱼尾纹;Iw,派罗欣;Iv,少年蓝色经典;Iu,EGJerry,花尐酱丶;Is,猪蹄好香;Ir,李大忽悠,蠢蛋哈哈;Ip,绿眼豆豆;Io,野屠夫;In,守灬衡;Im,壞尛孓;Ig,Hawker;If,灀烬;Ie,宇智波叉烧饭",["主宰之剑"] = "I3,丷月溪;I2,阿威十八,初丷恋;I1,梅林贝尔,主宰战十三,街角丶卖风骚,史上最萌萨满;I0,兮柔;Iz,身材惹火,酒至微醺;Ix,純情小正太;Iw,你好哇李银河,沉霜落烬乄;Iv,尘封记忆丷;Iu,姑娘丶请自重;Is,聆听风雪月;Ir,蓝雨丨財訷,大知闲闲;Iq,刘大夯,火锅大魔王,大呆雷;Ip,叉烧奶咖,阳光晒干记忆,苏暖年,帝門汉特儿;Im,红豆生蓝国,青芒,只蹭噌不进去;Ik,灰烬乄主宰;Ih,捻花浅笑,暮雨倾城;If,红露凝香,茗之守护;Ie,岭上开三花",["安苏"] = "I3,摇曳的雨;I1,小雲子;I0,兮门灬大官人;Iz,凡顺,歆懿;Iy,唯有孤独永恒;Ix,夜幽月,周淑怡妹妹;Iu,贵族鸡你太美;Is,派大星大佬,呆呆贼鸭,赛兰塔尼斯;Ir,天地功夫;Ip,星耀、战神;Im,乌冬面大仙;Il,丶醉饮丶江河,欧欧小朋友;Ik,一布丁一;Ih,狄安娜之鹿;Ig,菇菇作响;Ie,缺德亡",["死亡之翼"] = "I3,丨紅尘烟雨丨,Aidenoo,滕总;I2,上善若死,夙世,红手的阿昆达,秦风细雨,浅风细雨,宮商角徵羽;I1,Guatama,喵星喵月,虾饺灬,思舟丶;I0,乄冉冉乄,村儿里一枝花;Iz,無名斬神;Iy,枫凛寒丶;Ix,迷尸人体,无聊的胡椒;Iw,桃花源,紫氣丨東來,花凉,大秦帝国张仪;Iv,蛇眼千秋,杀手马里奥,漣屮漪;Iu,一程风;Is,心灵崩坏,暗雨彡大魔王,颠沛亦如是,刺青灬,小学未毕业,她梦;Ir,米奇的土豆,乱踹的小脚脚;Iq,贝贝小可爱,抹茶冰沙,罗氏小龙虾,之风丶,我是一哚娇花,太过倔强;Ip,烬鹳,入江纯,莫得信仰,兰台,卢西奥;Io,熟练老司机,绝望的小鸭;Il,越哥没女朋友;Ik,最闪的衫,梨子酱;Ii,三刀爆砍小鸡;Ig,吐血的阿昆达;If,白嫖;Ie,无比滴丶,奋斗的宝贝",["国王之谷"] = "I3,眉带灬凶兆,妳一号,防波亭鬼灯;Iy,冷玥葬花魂;Iw,虚法;Iv,亚里士不缺德;Iu,SansanVeeker;Is,刺丶惊鸿,暗影丿九头鸟,裹尸布;Ip,象龟兄弟,酱紫戳,元柳,邵疯疯;Io,红花石蒜;Ik,烽火丨烟雲,倾听之南;Ij,小浣熊君丶;Ii,坐看云起落;Ih,夺命老雪花,兜糖嘤嘤樱丶;Ie,李大胆儿",["黑铁"] = "I3,熊志远他四叔;Ix,弥雅;Iw,极光丶小苹苹",["埃德萨拉"] = "I3,无限星语;I2,氵卅;Iz,Comedian;Iw,百合女王;Is,识时,满地柠檬瓜;Ir,月靥丶;Iq,Jjpig;Ip,永恒之悟;Im,仁僧;Ij,风格飘逸;Ie,扯淡的蓝辰",["金色平原"] = "I3,绾风;Iy,徐大锅;Ix,㗊㗊,程婕琦;Iv,Qazshara,艾欧蕾娜;Iu,来个卤蛋,夏花未眠;Ir,阿傻;Iq,肉酱面,希崎潔西卡,子弹滞销了;Ip,如何玩鸡,邓肯丶巴拉莫,得嘞;Io,Alián;In,渔汍;Il,希尔瓦斯罐",["凤凰之神"] = "I3,孤獨根号三;I2,意不尽,奈何;I0,嗜血悍匪丶,打鼾的艾瑞克;Iz,丶十点半丶,夕谣;Iy,黑暗莽夫丶;Ix,红花石蒜;Iw,战了个火;Iv,可樂伽冰,黑八兔,Swarlocks;Iu,大橙子呀;Is,一梦经年丶,别走太远丶丶,局部地区有痰;Ir,不复当年模样,交错的愛,盘栗子的黄桃,游方道人,百花仙子;Iq,大脸乔,无恶不作丶,以星辰之名,丶文珏,丶大器晚成,丶四十七军团;Ip,翻滚吧小咕咕,丶温猪子;In,王独秀丶,迷糊的芝麻糊;Im,魂一夕而九逝;Il,月照大江;Ik,爱生活爱拉芳;Ij,Avrilavril;Ih,清能有容;Ig,無牧丶,汪汪那个太阳;If,丽华锐颖轩,魑鴉;Ie,丷纸短丷",["霜狼"] = "I3,希瑞斯;Ip,叶子长翅膀",["熊猫酒仙"] = "I3,别问,弑君者;I1,秦时明月;Ix,幽影之血;Is,虚肥;Ir,木鱼水上漂;Iq,黑丨凤梨;Ip,南宫小怂,月离丶,唐诗,愿你酷的像风;Ik,王药药",["末日行者"] = "I2,尔東,莉莱丶霜语者;I0,大壊狼,守孤城;Iz,Sunsui,冰冰貓,动若疯喵;Iy,邪幅;Ix,尐聋瞎,荼月;Is,浊酒邀明月,青木兰;Ir,大爺忽悠着你,炼狱贪狼,冷眸含黛;Ip,糖乄序曲;In,德氏;Ii,隐形的纪念;If,思泣",["格瑞姆巴托"] = "I2,灵弓逐月;I1,逝去乄流年,数流年空悲喜;I0,彻彻霸霸;Iz,骨弦丶,Yerger,灬十二丶;Ix,尽海蜃城;Iv,一魔山一;Is,青石幽瓦,脚是个蹄;Ir,灬十三丶;Iq,Mocktail;Ip,李猜猜,红花石蒜,裘千呎;Ik,达盖迩的旗帜;If,焱灬燚灬焱;Ie,你会放电吗",["风暴峭壁"] = "I2,戴兹;Ig,丶摩尔迦娜",["铜龙军团"] = "I2,鱼壹壹;I0,五七酱",["布兰卡德"] = "I2,琴月阴;I0,我会出鹦鹉的;Iz,伊小博;Iy,大咪小可怜;Ix,叮咚叮;Ii,瞄不准",["蜘蛛王国"] = "I2,吖苍丶;I1,狗头通灵使;Iu,寶劈龍丶;Ip,葉奈法",["血色十字军"] = "I2,籣卿卿,全明星蔡徐坤,凌丶绝丶顶;I1,丶潮汐;Ix,情浅缘深;Iw,自闭的皮卡丘;Iv,琥珀大人;Iu,又戈豸召虫单;Is,赤豆;Ir,肉丸子多多丶;Iq,咕呖呖;Ip,油腻尬;In,牛刄;Ik,隔壁老樊丶,菠波浩浩",["罗宁"] = "I2,花无人戴,国粹;I0,爱林依依,瑾嫣灬,悄悄雨歇;Iz,虎姑婆咕咕,Phaedo;Iv,红油抄手丶;Iu,月伤,丽芙摩尔丶;Ir,冰血丶暗语者;Iq,肉麒麟,斩风丶,浊雨;Ip,螭羽,月下无影,萨洛多米,苍月如霜;Ie,北岸风",["双子峰"] = "I2,上步七星",["斯坦索姆"] = "I2,血刃血纹;I0,匕尖上的恶魔;Ih,清白之年",["血顶"] = "I2,人超级闲",["凯尔萨斯"] = "I2,一生之萌",["艾露恩"] = "I2,阿碧丝;Is,七星燈;Ir,白斯克;Ip,维特鲁,紫夜轻风",["阿纳克洛斯"] = "I2,Slrlus;Iq,德喵",["永恒之井"] = "I2,艾伯特丶暗砧;I0,菜鸟斌;Iy,鱼亡深海;Ix,比利巴特森;Is,小胖咕咕;Ip,未来纪元,小飘香,迪兰妮",["影之哀伤"] = "I2,传说中的御姐;I1,圣丶治愈;I0,季秋,一蓑夕阳丶;Iz,胸口坦荡荡;Iy,织雾丨糖糖;Iw,王小强;Iv,丶钟馨彤彡;Ir,奎托斯丶链刃,垂死的沐沐;Ip,我非妳杯茶,麦卡丽慕,说佛;Il,我爱宝宝;Ih,养豚小能手;Ig,博览群峰;If,有趣的灵浑;Ie,仙女有只猫",["洛丹伦"] = "I2,醉拳大战萝莉;I1,麦兜",["伊萨里奥斯"] = "I2,沈小妍;Is,灬索利達爾灬",["甜水绿洲"] = "I2,紫悅;Ir,战无殇",["燃烧之刃"] = "I2,踏尽苍穹;I0,長襟落落秋風,御涯哥哥;Iy,传说之上,叁千世界;Ix,正义的欧小蓉;Iw,小小的老七;Iv,霜之风行者;Iu,鱼斯拉朵朵桑,天邊一隻雁,莎菈丨凯瑞甘,浮生若流年丨;Is,麋什么鹿,色色,丶溯光;Ir,柳随颜,娶太阳暖被窝;Iq,尘稷山路招摇,奈艿;Ip,寒笙,一鈤三浪吾肾,丶子路,深沉凝视,困的猪,罗马尼奥利;In,不德不爱你;Ik,你好骚阿",["回音山"] = "I2,似你如风丶;I0,愿你酷的像风;Iw,泰温;Is,拉灯叔;Ie,千羽丷",["海克泰尔"] = "I2,丨红丨,Yzlee;Iw,点娘;Iu,来嘛崽种;Ip,别勾了,会移动的荣誉,土豆变馒头;Ij,陈浩北",["奥蕾莉亚"] = "I2,奔跑的红烧肉;I1,抵抗;I0,兰斯洛;Ip,月影凛风;In,栗子姨夫",["森金"] = "I1,血色即永恒",["红云台地"] = "I1,苍冰绯炎;Ir,灵魂汲取者",["巨龙之吼"] = "I1,静静的笨总",["大地之怒"] = "I1,认识贼么",["???"] = "I1,微笑柠檬;I0,嗯丨佩佩;Iz,神兽吉祥;Iy,坛九;Iw,欧德晨曦,火车吧",["晴日峰（江苏）"] = "I1,樊默",["穆戈尔"] = "I1,酋头人牛长",["伊森利恩"] = "I1,湯圆;I0,傲娇的蒋美美;Iy,汨開朗基羅;Ix,左小左;Is,匣子怪兽;Ir,小天真;Iq,乃斯,古语有云,小帅哥球球;In,柠檬汐雨",["伊利丹"] = "I1,月下的肖邦;Iw,银河星爆",["月光林地"] = "I1,西行桜吹雪;Iy,小高兴五号",["奥尔加隆"] = "I1,Rarecandy;Iq,奇异酋长",["克尔苏加德"] = "I0,不落橙梦;Iu,战复那個小德,琴丶格蕾",["玛瑟里顿"] = "I0,小奶嘴",["龙骨平原"] = "I0,奥德瑞亚;Ir,Ozpin;Ii,贼有爱心",["迦罗娜"] = "I0,墨炎凌",["奎尔丹纳斯"] = "I0,改名变欧皇",["远古海滩"] = "I0,灵魂收歌者",["迅捷微风"] = "I0,丶苏一;Iq,拾零,敲敲咪咪",["千针石林"] = "I0,上阿迪杰;Ix,土豆烧排骨丶",["毁灭之锤"] = "Iz,Fancy;In,安東",["太阳之井"] = "Iz,黯夜降临;Iv,Aice;Ir,云青青兮;In,花灵",["盖斯"] = "Iz,宁珂郡主;Iq,糖炒丶栗子",["奥特兰克"] = "Iz,奶瓶丶;Iw,安你大姨;Iv,唯雅诺,丷萌骑丶;Is,一只尛团团;Ir,爆兵换家;Iq,虺虺,月影灬枫歌;Ij,一休一休",["朵丹尼尔"] = "Iz,无敌奶爸",["埃克索图斯"] = "Iz,精灵娜娜;Iu,海大爷",["恶魔之魂"] = "Iz,酸奶西米露",["艾欧娜尔"] = "Iz,小小甜心",["翡翠梦境"] = "Iz,卖萌的尸姐;Ir,深蓝猛兽;In,温尔澈",["银月"] = "Iz,姐姐的房间;Ir,路口吃瓜群众;Il,紫水居士",["阿迦玛甘"] = "Iz,古德猫宁",["日落沼泽"] = "Iy,织雾小玉",["冰霜之刃"] = "Iy,Nzz;Ik,熊猫佩奇",["亡语者"] = "Iy,羽渡尘",["丽丽（四川）"] = "Iy,告死鸟,夏末灬微凉;Iw,纪晓芙丶;Is,暮色丶清妍;Iq,断角骚蹄牛;Ip,新月之灵;Im,阴影猎杀者",["霜之哀伤"] = "Iy,无色的白,一串糖葫芦;Ir,丶柠萌丨;Il,霈凌",["熔火之心"] = "Iy,生来彷徨;Ir,Buff;Iq,Ibertine",["奥斯里安"] = "Iy,辣椒小超人",["扎拉赞恩"] = "Iy,似雨若离;Ix,失眠到天亮",["迦拉克隆"] = "Iy,一锅炖魔法,米拉库鲁;Iw,天光;Is,热血邦桑迪,小小洛喻;Ir,荣誉丶;Ip,闹够了沒有,塔布奈,一只璐行鸟,石原里美丶;Ie,五升大雪碧",["暗影之月"] = "Iy,妃凌雪;Is,默写丶那段情;Ir,凸罒亖罒凸;Iq,地狱镇魂歌",["拉贾克斯"] = "Ix,念着我的名字",["血环"] = "Ix,阿克西斯;Iv,BrocksCarlos;Iu,末颜雨;Iq,偶兜兜里有糖;Ie,王者祝福丶,刺芒丶",["耐奥祖"] = "Ix,独孤求败",["阿卡玛"] = "Iw,虚空夜宴,文文弱弱",["苏塔恩"] = "Iw,一板砖拍死你",["伊瑟拉"] = "Iw,紫焰星魂;Is,法兰吉斯,克罗歇尔",["刺骨利刃"] = "Iw,口古丿口古",["加兹鲁维"] = "Iw,夜霜之哀",["利刃之拳"] = "Iw,狗尾花与猫",["雷霆之王"] = "Iw,幻星辰;Ip,瘌痢头撑阳伞",["达基萨斯"] = "Iw,壮士请留歩",["冬泉谷"] = "Iw,夜子寒",["萨尔"] = "Iw,小茉璃",["海加尔"] = "Iw,笨兮兮",["莱索恩"] = "Iv,鲜血",["古尔丹"] = "Iv,夜仞;In,呆卡萌哼哼",["阿克蒙德"] = "Iv,沐与花如笺",["阿尔萨斯"] = "Iv,貓小沫;Iq,阿萨赞",["风行者"] = "Iv,蔷薇花开",["塞拉摩"] = "Iv,花開丶若相依;Ir,逐鹿丶;Ip,雇佣兵",["奥杜尔"] = "Iv,倾国;Io,檐上三寸雪;Im,牧云笙歌",["火羽山"] = "Iv,猫猫乖",["霍格"] = "Iv,愿圣光庇佑你",["泰兰德"] = "Iu,箜篌烟云",["耳语海岸"] = "Iu,布丁,若水叁千;Iq,西子",["时光之穴"] = "Iu,欢笑的大表哥;Im,六十八号技师",["燃烧军团"] = "Iu,無言的結局",["诺兹多姆"] = "Iu,头上顶只猫;Is,卡鲁纳一",["巫妖之王"] = "Iu,蛀牙",["熵魔"] = "Iu,阿尔忒密斯",["幽暗沼泽"] = "Is,以德丶糊人",["黑石尖塔"] = "Is,夜深宜私奔",["影牙要塞"] = "Is,铁马冰河,瞎子不哭",["丹莫德"] = "Is,长此以往;Ii,沉着应战",["索瑞森"] = "Is,雨丶小虹",["阿拉希"] = "Is,阳光光",["法拉希姆"] = "Is,哈兰之星;Ig,Meng",["红龙军团"] = "Is,小秋丶;Ir,Neciik;Ih,啊格拉",["安威玛尔"] = "Is,猎灬爹",["斯克提斯"] = "Is,绝世小艹蛋",["雷斧堡垒"] = "Is,红莲焚天",["玛里苟斯"] = "Is,红炲;Ip,莫不言",["生态船"] = "Is,欧神羽猎",["寒冰皇冠"] = "Is,易爆",["鬼雾峰"] = "Is,孩纸亲;Ip,聖怒丨森",["破碎岭"] = "Ir,Turbowarrior;Ip,辉夜姬会飞;Il,关键一号,鸡蛋饭",["艾萨拉"] = "Ir,四处游荡;Ip,残阳如血",["天空之墙"] = "Ir,人帅爱唱歌;Iq,拿朕的斧子来;Ip,一条小团团",["洛肯"] = "Ir,马兰花秀丽",["奥达曼"] = "Iq,菲利浦银誓",["冬拥湖"] = "Iq,竹影凌风",["菲拉斯"] = "Iq,Clarinet",["万色星辰"] = "Iq,西门卖菜",["山丘之王"] = "Iq,江左梅丶郎",["烈焰峰"] = "Iq,西然;Ip,娜小新",["黑龙军团"] = "Iq,小浮华;Ig,神無月澪",["金度"] = "Iq,阿昆达五号",["布莱克摩"] = "Ip,米那诺依",["图拉扬"] = "Ip,救救派大星",["瓦里玛萨斯"] = "Ip,倾城猎刹",["火焰之树"] = "Ip,诠释丶爱;Ij,木子",["勇士岛"] = "Ip,奥多芙",["踏梦者"] = "Ip,丶小琻毛",["哈兰"] = "Ip,胖哒",["逐日者"] = "Ip,Emoji",["黑暗魅影"] = "Ip,穿毛衣的猫",["拉文凯斯"] = "Ip,Gatanothor,那者",["密林游侠"] = "Ip,滑水的阿昆达",["梦境之树"] = "Ip,鹤令",["暴风祭坛"] = "Ip,Renmoy",["提瑞斯法"] = "Ip,午夜骷髅党;Ii,颓废的小野猪",["风暴之怒"] = "Ip,壹零",["末日祷告祭坛"] = "Il,奥德灰烬",["神圣之歌"] = "Ik,郁郁不得志",["通灵学院"] = "Ik,辣条灬千层",["亚雷戈斯"] = "Ik,特汚兔",["阿比迪斯"] = "Ij,血恋锋",["永夜港"] = "Ij,Hyperionx",["库德兰"] = "Ii,流苏",["恐怖图腾"] = "Ii,鳳凰",["红龙女王"] = "Ih,筱兮",["月神殿"] = "Ih,御坂美琴丶",["尘风峡谷"] = "Ig,老韩和天下",["埃霍恩"] = "Ie,今夕何夕,臭丶嗨",["狂热之刃"] = "Ie,滚地撞到墙",["石爪峰"] = "Ie,東衣"};
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