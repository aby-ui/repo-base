local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["血牙魔王"] = "Rg,晨熙爸爸",["凤凰之神"] = "Rg,敷衍的誓言,赤魂,仁吼義侠;Rf,善良的钢琴师,恩赐解手,毛线团子,Sho,Sorei;Re,青木枷锁;Rd,賊有钱,审判使者,御姐有三妙,执筆念殇;Rc,宸彧,红狐之智,迪丽热巴吧;Rb,始于初见丶,莫欺老年穷;Ra,玛格汉半藏,詹姆士李,Ninna;RZ,塔心乂崋,妙甜丷斗鱼;RY,大穷喵,Loktarnaiba;RX,偶相信有奇迹,鯊魚辣椒丶,振翅十六连,悲悯与行冥;RW,奥沙利铂,夕阳丶梧桐;RV,丶吴彦祖;RU,Migomigo,德维尔的长弓,暮雪焚尘;RT,马郁兰,蕾蕾梨,丶又菜又稳定,闪闪丶嫣燃,Looktar;RS,Fantasticki,复刻黑暗,追风逐梦;RR,怡丄寶,Lionzz,丨憨憨;RQ,尸位素餐,安久丶奈白,Dolces,阿宝丷小猴子,刘书紀,我先冲快跟上;RP,有只嗷呜,朵蒂;RO,京都念慈鵪,黒杀,雲端的脚板丫,绝活哥,神经兮兮丶丶;RM,了不起的杰弗,五蒾叁噵,丶小暴,宝哥哥灬;RL,做梦的熊猫,法芮尔;RK,哺育后代,莫小兮,万能的牛,森森呀;RJ,賊走运,安非他命丶;RI,丶雪碧泡饭,北斗晴天,Megoodluck,丿小楽丶,Despredo,火之神神乐丶,Tsai;RH,猫饭饭茶碗蒸;RG,厄運红叶,疾风剑皇,热心肠的小张;RF,青丨阳,滿楽,萌萌的战战,馋他,芭芭拉冲啊;RE,浩子未知,照猫画虎,迷路小兔兔丶,阿姨沾酱;RD,且须饮美酒,风丶逝,胖胖嘚文哥丶;RC,骚嘚斯奶,浮云千载,深野昂,Avogadro;RB,刮痧技师丶,灬纤尘灬;RA,Sakurall,最深情的森西,因幡帝丶,莫歌;Q+,壕运气,绮德丶",["神圣之歌"] = "Rg,半醒;RV,莹莹妈;RR,咖喱馒头;RO,太阳之子;RH,山水草木",["伊瑟拉"] = "Rg,怒放的雪;RL,推到小朋友;RE,那尔撒斯",["暗影之月"] = "Rg,二郎显聖;Rd,怒风乄之魂;Rc,牛奶柚;RR,绮楼春城暮;RL,法夜小狐狸;RF,黯然缥邈;RB,在水之湄",["影之哀伤"] = "Rg,邓潇洒,尛可心;Re,乄呆波波乄;Rc,想念老团长;Rb,暮谷灬声晓,融融月,丨婕丨,木语清岚;Ra,人间怎会白头;RZ,灵境血的消失,人间岂会白头,有点帅耶;RY,透明的风;RX,红色丶闪光,Favourer,单吃小魔王;RV,无色;RS,珠海张学友,枫月,伏魔御厨子,法国来的约汉;RR,Robu,梦魇之源,花落醉清颜,暗夏;RP,纳哥,炎哥,灌铅脚步,冬是会长师傅,猩红之影;RO,又起秋风,指尖上的钢琴;RN,会所大镖客;RM,Icedmilktea;RL,雲端小胖,尤瑞丶艾莉,划水之王老刘,滑水之王老刘,Darthwen,暖心男神;RK,掱心,丨飞鸟与鱼丨,卝叶子,已忘言,苇草,橘子尐尐;RJ,愤怒小熊,Happyholiday;RI,林友有,前男友;RH,二貮贰號;RG,三支香,帝龙灬归来;RF,菠萝催血,月夜白;RE,Euroyalol,有时看雲;RD,天才第壹歩;RC,林空鹿饮溪;RB,挣扎,一瞒天一,丶萧默默;RA,勒子;Q/,流梳灬烟沐,懒懒空天猎;Q+,穿靴子的牛",["永恒之井"] = "Rg,一只小飞狗;Rc,不羁君子意;RW,希耶尔;RP,莎布尼古拉糸;RO,香辣鸡腿堡;RM,临溪观鱼,醉驾;RI,咬哭橙汁;RH,最初的梦想;RG,丨校长秘书丨;RD,十里桃林",["埃德萨拉"] = "Rg,箭隐鋒藏;Rf,狗头肥猫;Rd,Sufferer,Pcc;Ra,甜蜜的复仇;RY,Euphy;RW,梦影黄昏,劝你耗子尾汁;RV,玥晚晚;RU,马穆鲁克,啪灬啪灬啪;RQ,丨未闻花名丶;RP,温柔抱;RO,南美大虾,钦丶黄先生;RM,八倍镜九八克;RL,夏娜丶;RK,周二二;RI,Hugtwelve,记忆终諟丶;RH,游戏的大喵;RG,宇智波奶牛;RE,单吊丶東风;RC,奶油熊起司;RA,丨丶青衫;Q/,骁哥最帅;Q+,灬阿猫灬,丨丶青衫未旧",["海克泰尔"] = "Rg,新鲜韭浪两块;RZ,胜天半子文彤;RT,王力宏;RP,丨問題吥大丨;RO,丶天晴,影歌之月;RN,艾尔德林,温茶青盏;RG,爱的拳头;RF,耐小九;RE,万亩稻上飞丶;RC,基尔夹卤蛋;RA,旧城半夏,夜丶微凉,灵魂祭司雷尼;Q+,风中一头牛,猜心,心云",["贫瘠之地"] = "Rg,五更千里梦,死就对了;Rf,你又胖了;Re,Radomss,丽萨丶;Rc,紫焱;Rb,知名猎狗选手,游客嗯冲丶,芸芸众生米煮饭;RZ,少糖蜜汁排骨,小马叔,星淬,嘿丶阿宝呀;RY,浩克男;RV,莫歌;RT,黄泉送葬;RS,焱燚七;RR,我不知道丶;RQ,雨浪;RP,Sugarn,天罚雷霆,阿灬爵,丨萨勒芬妮丨;RO,光之霓裳;RN,Tiwaz;RM,汝衣,宁静在沸腾;RK,青蘿拂行衣,炎涛白燎莽;RJ,不悟兰因,天堂情书;RI,云谷胖胖,丨你的讯息丨;RG,姥衲法号乱射,风之丶牧语;RF,憨壮壮,奥利给大魔王;RE,丷大橙子丷,暧暧;RD,嫂子好刺激哦,木岂能择鸟,Gigapull,我负责云,是晨阳哟,水果拉面,灵魂超越;RC,荒野老司机,惹我半生风雪,绒布团子;RB,凰弥;RA,官人不卖艺;Q/,末白丶,小牛丹尼,大地香瓜,欧狍;Q+,Shaka,小末日,花丶雨",["黑铁"] = "Rg,可爱的李老师;Rf,不要不妖的;RW,情如殇;RU,牙儿迈;RT,欧欧的阿昆达;RR,月落雪梦;RQ,乌尔奇墺拉;RP,单刷大宝剑;RO,Viu;RL,凌乱心情;RI,阿翼,念旧;RG,小老板晴晴;RF,优雅的帅夯比",["金色平原"] = "Rg,王大蛮;RV,徘徊的猎神,借我凌云笔;RS,艾米希尔;RO,阿尔忒觅斯;RM,哎呀拉多了;RK,喜气盈门,花小辫;RJ,丁书生;RH,藏宝图宝藏;RF,佐里昂娜;RD,我醉君复乐,贝尔晨酿;RB,誰為我停留;RA,庆余,好灬好美哟",["霜之哀伤"] = "Rg,夜翼迪克,兽栏管里员;RY,青椒真的红;RR,香芋奶茶;RP,南京九五之尊;RF,祖宗;RD,游学者叮当;RB,丨眰恦丨;Q+,眸中星河似梦,灿烂尐尐,今生为你舔,恰似童话",["主宰之剑"] = "Rg,安果;Rf,堕落的小角,獸教父;Re,单行道;Rc,孑然与律;Rb,你喜欢红椒吗,洱熱;RZ,Mandycc;RX,德财谦备,德欧妮,锤子所向披靡;RW,病酒;RV,朴实佬猎;RU,Era,陆鸦丫;RS,淩静,牛排嫩嫩的;RR,我系真滴猛,雨下半夜,晴天丶好心情;RQ,宮水三枼,灰烬中重生;RO,暗夜包子;RM,Spe;RK,最后的白月光;RJ,錶子与枪丶;RH,Async,叶之湫,天使也无奈,自在行;RG,虞城丶驿;RF,社会你波哥,射誰谁怀芸,月光下的云海,王权,袁九思,用血捍卫荣耀,小荃,天津饭饭,苦孩;RD,教官的第四科;RB,風吹不散长恨,年轻不讲舞德;RA,一岁可萌了;Q/,导演法;Q+,夜尽丶辰曦,快进到退休",["血色十字军"] = "Rg,无故挽歌,夏了个夏天;Rf,董老湿,猫不二;Re,鯊鱼丶;Rd,全体丨起立;Ra,一只小柚子,推倒狐,白萝卜丶;RZ,不灭火焰,雙面宿傩,十丈丶红尘;RY,佟彤宝贝,打断我来,殇御灬血怒,月白苍穹;RW,星丨宇,熊心咕咕胆;RU,电脑丨暴躁的;RT,日向灬花火,有个大家伙;RR,蓝啵基妮;RQ,德鲁二;RP,路西法的梦;RO,鱼斯拉朵朵,阮囡囡;RN,西瓜皮丶;RK,Adorable,奎托斯之怒;RI,桃桃芝士,小小灾变;RH,杜家丶小贝,大哔哥哥;RF,Imfit;RE,叹息的富士山,术起中指丶;RD,Meastoso;RC,没有止痛药水;RB,我是个正经人,表妹丶;RA,达拉崩吧丶,珊瑚丶海,蜡笔海盗,昨日青空;Q/,祟图,社会的榜样,爆炸糖果,席梦来;Q+,机车小迷弟",["格瑞姆巴托"] = "Rg,鶸鶸的丶暮色,平安喜樂,盗云;Rf,小神有礼了;Re,我艾希伱奶;Rb,天兰色;RZ,城池葫芦娃;RY,奶好我中不中,林深时见鹿;RW,麥肯的傲慢;RV,酷盖,小花菇;RT,壹捌壹陆;RS,暴毙的莱赞,帝国太君;RR,大頭頭大;RQ,梅希拉;RO,科波菲,速度咩丿,折耳大松狮,牛奶斩;RM,憨憨德蟀,墨蝶黛霁,夏灬侃;RL,迷汉相亲;RK,输出垫底丶,丨惟馨,丨鬼丶姬;RI,桃花雨;RH,白老师;RF,中島美雪;RE,旺川,哆啦批梦;RB,你枯燥么,东华少阳君,醉酒夢红颜,小鸡球球;Q/,少女映画;Q+,哈啤穿肠过,梦扬天际",["熔火之心"] = "Rg,藤井美菜;Rb,奔波霸霸波奔;RY,幸运守护;RV,伊犁丹;RO,桃白白;RM,阿昆达之赐;RI,小牛强强;RF,穿拖鞋的精灵;RD,断离",["罗宁"] = "Rg,宫水三葉;Rf,丨夜白灬;Re,侠菩提,梵刹迦蓝;Rd,阿萬音鈴羽;Rc,你的夜茉莉;Rb,赫拉迪姆凉皮,塔下街洗头房,墨渊天,怪贩妖市;Ra,希儿瑞娜风歌;RZ,冰酒酿;RW,割麦子;RV,丧尸丶暴龙兽;RU,丨夜白丨;RT,消逝的圣光,Bwei,童贞女王,丨夜白;RS,阿咚,侵入体肥大;RR,白了又了白,妄行;RP,瞬风丶骑;RO,小懒鱼;RJ,童真霸霸,欧阳奶奶,灿烂的花火;RI,奥隐;RH,吕根斗,矮老黑;RG,我真是哔了咕,茜茜有环;RF,长袜子皮皮,沐沨;RD,大鱼鱼爱吃肉,炒饭丶;RC,轻拢慢捻;RB,灬桃兔灬,小支百威,远山之巅;RA,大圆蟀,青咿染霜华;Q/,小鷄湯;Q+,Sacrificed",["埃苏雷格"] = "Rg,Lovoom",["夏维安"] = "Rg,温酒丷叙余生,月落丷霜满天",["白银之手"] = "Rg,荒野羽羿;Re,月殇梦忆;Rd,逆流乄曼荼罗,法蕾拉;Ra,莉丝妲黛,虎狩,哏丶残骸;RZ,Stellagosa,刚集火就灭团,灰烬征服者,老张爱包子;RY,圣光无码;RX,水瓶双鱼,木子曦,迷人德,皮卡啾灬;RW,Mocktails,手残不会火法;RV,寞墨,第九骑;RU,丘比特的弓,Montybear,Montyshoot,仙女在人间,拇指画叉叉,小晨晨耶,水之无月;RT,陈惠琳,三鲜鱼翅;RS,不二宝宝;RR,Showyoulove,冰冰的箭;RQ,星辰圣裁,联盟的圣骑,大意丶没有闪,运气才是实力,知天风;RP,光頭加爆撃,裤裆里的锤子,咩噗猪,德氏,前男友;RO,花会枯萎,咸鱼宝剑,圣夏丶若空;RN,獸王乄曼陀羅,晴天天丶;RM,墨墨萌萌哒,瀬戸際,猎丶清风,酒杯与铃铛,小能饼干,璎珞晨曦;RL,烤鹌鹑蛋,蔷薇小舞,光头黑叔叔,骄傲的剑姬,心中藏百鬼;RK,邓诗颖;RI,梅尔特莉莉絲,苍穹之跃;RH,择林,苍之无极,亿易,惡靈騎士,狼的一逼;RG,Stnyrah,Kaytse,Oeverhopeful,啾啾就是啾啾;RF,一骜,黄山张老师,侠客风行者,亖宇宙队长亖,德妮维雅,逆风花潇,逆风骑行,愁绪万千;RE,小青龙,啾哩个啾,星空天蝎座,芥末味冰淇淋,火槍手追獵者;RD,Xwh,电竞斯坦森,司言,哲哲大憨憨,擎天過雨;RC,埃提耶什,清梦挽依,野人参;RB,琦玉老师灬,伊雪夜,开光大湿丶,一点不自律,阿尔萨喵,童話鎮;RA,雲杨,温岭胡歌,飞驰柚子,南野;Q/,陳喬恩,乱舞乄风行者,Demondark,维灬他,酒樱;Q+,雷德琪,回梦夜影,天空蔚蓝灬,这是女鬼,老王遛狗,清音梵唱,Penumbra,奶一次绿一次",["月光林地"] = "Rg,你的小虎哥;RW,雨点先生;RJ,凌豆腐;RF,凉生丶",["死亡之翼"] = "Rf,丶名侦探柯南,星河清梦;Re,血牙刀贼;Rb,萌萌哒雨神,獯鬻,伱佬味,璃洛;Ra,丶名侦探工藤,丶名侦探高调,别抢我养的猪,梦心颖,叮叮起床了,姚巨侠;RZ,風羽铃奈;RY,翻滚滴大海,风间琉漓,苏弍蛋;RX,樱井莉娅;RW,我太脆了,白色煤球;RV,邹哥,天剑丶非天;RU,荒世丷;RT,血法小姑娘;RS,胖德没朋友,西楚猎,月心蓝;RR,搞大来啊天真,村头发廊托尼,陈一花儿,在下丨萝莉控;RQ,Lcyn,希拉贝尔丶,星陨无痕;RP,风间铜羽,禁止投喂挑逗;RO,悠哉君,秃丶凸丶突,Kissmyaass;RN,亣波;RM,王生气,莎谱糯丝,我不会再逃了,沐丷韩;RL,雷电海王包包,奥格张学友,木剑丶温华,风宸丶;RK,临冬城丹妮丝,奶狗丶,程暖暖;RJ,天才哞哞;RI,炙日星河,天上谣,毛小豆,Betelgeuse,呗之诗丶,大迦楼罗,娜娜的狸猫,跳刀丶跳刀丶;RH,风中大雕哥;RG,牛皇,小小酱油瓶;RF,法神咔咔;RE,老人古井,昊寒冰,风色月,沉默的真相;RD,小喵呜;RC,迢迢間風月,飘雪灬;RB,求你别插进来,紫韵铭馨,莺鸢,傻比晓得;RA,Asknb,魔桀神;Q/,小栞的狐狸,老牛吃嫩草丶;Q+,丷小眼迷人丷,盗口大重九,西柚茉莉茶丶,德抽大重九,手拿大重九",["冰霜之刃"] = "Rf,王不留狗;RP,长牙齿的柚子;RN,撒旦之心;RK,克尔苏加狗;RB,丶铁柱",["冰风岗"] = "Rf,六星霜,Sastabber,顶缸;Rd,飞雁;Rc,Papa,微凉初秋;Rb,夹心果冻;RZ,凌风血咒;RX,丶藤原千花;RW,小哪吒来了,贾正景,残忍的软泥兔;RU,寂月,橙意漫天;RT,僵晓鱼,中二小雨老师;RS,盖世德,辣笔小丶新,思柔,萌小咩;RR,发条丨橙;RQ,兜兜裏有糖,安迪丶杜费伦;RP,Akailol,西瓜冰粉,Ksamax,冬熊夏喵;RO,莉娜灬,Lilbaby;RJ,涅白,丷天意;RF,天上哦,奇克秀;RE,彩翼鲸尾红丝,Rosamond;RD,Relina,源赖式佐田,二百一十六斤,小酌又黄昏;Q/,专业杀鸡拔毛",["黑暗魅影"] = "Rf,妩妖王;Rc,玉米鸡胸肉;RU,组了我不缺德",["末日行者"] = "Rf,Simha;Re,哈哈坏天气;Rd,豆豆勇士,Zetacola;Rb,灬炏灬;RY,星夥,眉心微凉;RX,不是一般的好;RS,一品堂李延宗;RP,走火入魔;RO,时光的指针;RN,大刀关凤;RL,As;RK,斯巴达士兵;RJ,偸吻妳的心;RI,奥蕾莉垭,馬咚梅;RG,最爱鱼鱼;RF,安不骑;RE,最爱香菜,西门吹血;RD,摸腿腿丶;RC,安慕茜,愤怒的苗苗;RB,我是乱打的;Q/,舔娃;Q+,小楼一夜趴啪,腹黑骑师",["安苏"] = "Rf,骨头没有肉;Re,浊酒念红尘丶,请叫我烹鱼宴;Rd,爽大乳;Rb,素颜醉浮兮;RY,小鸽仔,梦里那个她丷;RX,长江边的瓜皮;RW,丷超甜丷,Lamiammw;RV,胖之明,小小姑奶奶,注意自保;RS,德讲武德;RQ,丨格利德丨;RP,镜白;RO,坏蛋大魔王;RN,弯牙队长;RM,白老師;RK,绿的心慌慌,夏侯怼怼;RJ,丶茹比,Themis,花映丛祠;RH,芒果柠檬西瓜,一朵星光玫瑰;RG,我将帶頭冲锋;RE,十元打五炮,蓝蓝纸飞机,丨四一丨,全是肉没土豆;RC,战倾血爆,贰一,艾小美,红颜最倾城,不谈情怀;RB,奥科萨娜,芋头炖牛腩丶;RA,十字军的清算,魔法宅急送丶;Q/,麦普替林;Q+,只愿诗和远方,冰星心,北暝",["伊森利恩"] = "Rf,尐胖纸丶;Re,丶黑鹅,壹零贰拾,拙锋,远帆;Rd,Tokio;Rb,安神丶,孤山远影;Ra,公会得希望;RZ,逍遥紫逸;RY,星星爱吃香菜,混混大咕咕,夜丶后觉,鲨鱼罐头,嗲嗲;RX,烟幕丶锁寒楼,Masklol;RV,朔夜观星,张一箭,酒酿蜜桃丶;RU,雕毛满天飞飞;RT,神丶潘多拉,邪丶神;RR,寒风染素衣丶;RQ,千针石林;RP,幻梦霜雪;RO,可口可乐,麦兜吖,星辰海,殺画丶,浮云千载;RN,地狱血泪,灵子丷,小熊盼盼;RM,橘色鸢尾,丶馋猫丶;RL,喵菲斯特;RJ,小阿宝呐;RI,达雷尔的岛,妳不要玩火;RH,柳涟漪,大猪蹄纸,唯独小休;RG,Joki,冯稀饭,橙管,光铸乔碧萝;RF,隔壁老韦,该角色已诈尸,关于小熊丶;RE,曓力美学,苏美尔;RD,很强,凤黎,星之澪,Lockjaw;RC,Hinataml,Anataml,痱子粉;RB,風無雨;RA,甜酒冲蛋,勾手老大爷;Q/,暗影之境丶雷;Q+,Redone,花花厷孒,北执",["卡德加"] = "Rf,烽火的箭矢;RL,也许会有明天;RD,烽火得箭矢;RC,一湖心静,洛丹伦二公主",["风暴之鳞"] = "Rf,心淡若水;RN,Hshaman",["世界之树"] = "Rf,微笑的蒂妮莎;RS,岚山步鸟;RE,絮语飘雪;RB,瓦尔姬里",["白骨荒野"] = "Rf,天煞;RU,打嗝海狸;RS,量子猫",["血吼"] = "Rf,长大后更帅;RQ,猫了个蜜",["战歌"] = "Rf,则竹裕之;Rc,用爱策反联盟;RM,夜炑",["麦迪文"] = "Rf,雪冰凌",["丽丽（四川）"] = "Rf,灬柒爺丶;Rb,丶柒爺灬;Ra,峨眉山扛霸子;RZ,一箭东来;RX,散华弥礼;RV,江枫思渺然;RS,灬瑞灬;RP,帅的丁心,帝苍林;RL,Lzyzz;RI,勃艮第炖牛腩;RF,Yimin,三刀;RE,剑与斜阳,你好钱先生;RD,Yax,月来凤栖山;RA,南部丑锅锅,别闹灬;Q+,飞花轻梦丶",["熊猫酒仙"] = "Rf,周大佬爺;Re,儿时语,瞬间焰火;Rb,楓夜;Ra,开开小可爱;RY,呓丶语;RS,德剋斯特;RR,怕你不脱;RQ,驰风;RP,欐舂院丶錵魁,丿锖莵丶,帝國戰歌;RN,尐冞粒,不羁浪人丶;RM,咕半仙;RK,俊秀钧同;RJ,萨丽曼;RI,小熊掌;RE,李小胖灬,黑醫白翼;RD,你到底怕不怕;RC,欧皇橙满天;RB,小光人,射的你发慌;RA,丿锖兎丶;Q/,JohnPan;Q+,十公里,敗犬",["???"] = "Rf,Reincord;Rb,能有账号最好;Ra,嘢火;RX,彪马野郎,俺吥懒,亻尹瑞尔",["破碎岭"] = "Re,Bingk;RZ,逆轰启辉;RW,心平浪静;RQ,Turbowarrior;RK,玩酷花少;RG,自由的阿昆达;RE,秋喜姐;Q/,堕落的路西法",["无尽之海"] = "Re,再瞅下试试;Rc,耂馬,大排量男子;Ra,法令紋;RZ,沒枪的条子,雪灬在烧;RV,小黄瓜的爸爸;RU,白给德;RT,柠檬丶橘子,黑曜石大领主;RQ,花姥姥;RP,偷偷不是偷,布加迪巍熊,芴莣芯荌;RO,心境,我要崩溃啦;RN,不沾酒,逗德一批;RM,奈何落雪丶;RK,情有獨锺;RJ,晚凉天;RI,大肥小果,温灬凉,又骚又欠打;RH,萨鲁法尔战歌,风丶凉;RF,吥搖碧蓮丶,城里放炮;RE,芸墨,屠魔风暴,死鱼非命,琥珀年崋;RB,做你的宝搞;RA,青衣凉惹白霜;Q/,麒麟仔,食人魔魔法師,翊悬;Q+,慧者实乂橙,灬奶茶炖鸡灬,小原",["燃烧之刃"] = "Re,狂徒练习生;Rc,Edelgard,四月雨,北巷浊酒;Rb,龙爸爸丶;Ra,鸥鹭;RZ,月下丶影无尽;RY,给战神道歉;RX,文艺复兴,炙热之剑;RW,就瞅你杂滴,牛贰丶;RU,妖妖泠,奶瓶請还給我;RT,饕餮丶兽,混血武僧;RS,素笺鸣尊;RR,快乐的小熊猫;RP,吴彦祖丨;RO,拉库拉玛塔塔,夏拉诺瑞;RM,乄老白乄;RK,岚凌;RJ,九陽;RI,用脚输出丶;RH,Deczz,西固;RG,青梦,宋义进,僵小硬;RF,卡的漂亮,丶果儿丶;RD,圣光洗礼丶;RC,乄老白,老白乄,圣光奶嘴;RB,酒仙女,丨嫣於倾黛;RA,Goodknight,卖皮孩;Q/,疯狂的麦田丶,疯狂的麦子丶,老乄乄白,老乄白,术小鱼",["迦拉克隆"] = "Re,梦里花萝;Rd,冲锋丶斩杀;RU,有事秘书干丶;RS,Satila;RQ,躞蹀丶;RN,愛棒棒;RM,毒岛丶伢子;RI,玳瑁之棍;RF,喵嗷咩;RB,空城美雪,白墨谷雨",["红龙军团"] = "Re,二十个我",["纳沙塔尔"] = "Re,喝奶;RP,抹茶大福",["阿尔萨斯"] = "Re,Machupicchu",["斯坦索姆"] = "Re,圣魔饭饭",["阿古斯"] = "Re,幸福丿小昊冉;Rc,此花亭奇谭;RZ,姬萌萌;RQ,冲丨大师;RJ,简安;RI,帅的闹心;RH,牧濑丨红莉栖;RF,倾国卿宸丶;RE,丨猎魔丨,影踪秘卫沧萍;RC,菊你太美;Q/,Deathbarbie",["布兰卡德"] = "Re,烟火丶静流年;Rc,姜撞奶;RX,丶十点半丶;RW,长沙老冰棍,琥珀海;RT,此用戸不存在;RS,吹散了我的梦,雾丶;RQ,丨一棵小菜丨;RO,丶青梧,初见忆起,无访问权限,懒兮兮;RM,桃桃奇妙探险,Hezzy;RK,明澈;RH,小心肝;RE,迷人又危险丶;RD,喵爪啵奇塔;RC,血色丶阿丽塔,尐尐丶;RB,银涛溜溜,螺丝粉;Q+,欧丿二泉映月",["克尔苏加德"] = "Re,野狐禅;RU,断线重连;RT,买酒白云边;RS,如果你追到我;RP,高家台十九号;RO,宝宝你上,萨神片片;RL,夜话白露;RK,季爸;RJ,花泽丿香菜;RG,揮炮干到服;RF,何以忆初訫,斯黛拉;RE,牛奶巧克力,梦想蓝睛灵,凹凸凸叁;RD,双刃法雷尔;RC,沐雪无尘;Q+,枪手哥哥",["诺莫瑞根"] = "Re,紫露冰凝;RI,乖乖酱",["迅捷微风"] = "Re,寂寞续杯;Rd,壹头好牛牛;RO,萨戈;RM,流螢;RI,孤独的海怪;RG,合剂爸爸,宇宙对我歌唱;RC,外面有狗了,草上飞不动;RB,是与非;Q/,章鱼法",["玛瑟里顿"] = "Re,陨落的星辰;RA,Vitamine",["燃烧军团"] = "Re,不存在的情人",["奥尔加隆"] = "Rd,Bwonsamdi;RZ,世界末日丶;RR,齐格弗里德;RG,幼儿园拳霸",["梅尔加尼"] = "Rd,赫尔海姆的羊;Rc,紙人;Rb,上九天揽月;RH,何康老鬼;RC,小甲甲丶;Q/,悠悠德",["耐奥祖"] = "Rd,王一博,莲藕炖排骨;RL,Eviljokers",["黑石尖塔"] = "Rd,夕阳下的梦魇;Ra,无眠灬",["奥特兰克"] = "Rd,闰土之裤;RZ,穿拖鞋的精灵;RY,Perplexity;RN,铁血雨落;RE,不正经大叔,仙念丶,花岗岩哥哥,Missflg",["克洛玛古斯"] = "Rd,堕灬世丨知梦;Rb,狂屠一座城;RA,闪光伯爵",["古尔丹"] = "Rd,冰冻废土之力;RJ,苹果酱",["雷霆之王"] = "Rd,矌谷幽蘭,深谷幽蘭;RR,星之卡比猪;RP,圆滚滚大王;RM,搂你小腰;RD,暗雨星魂;RB,格雷丶帕斯塔",["翡翠梦境"] = "Rd,白鸾;Rc,大冰河;RO,墨上,永燃火焰;RL,悲伤绝恋曲",["泰拉尔"] = "Rd,夜丶风;RK,丨乳酸菌丨",["黑锋哨站"] = "Rd,冲锋遇到树,玩不来法爷",["范达尔鹿盔"] = "Rc,那夜唯美",["黑翼之巢"] = "Rc,谢衣",["晴日峰（江苏）"] = "Rc,魅魔",["龙骨平原"] = "Rc,自命不凡地瀦;Rb,贝塔随之远去,春丶春;RT,舒克带我离开;RR,妞妞丶;RP,小春春;RO,须弥华光;RF,求之不德,云端丶;RB,Romeo;Q/,战世,丶黑夜传说",["回音山"] = "Rc,溜溜榴,南天南;RZ,思想品德老师;RV,红皮嘤嘤怪;RS,艾维欣,阿宁快跑;RQ,肉婕;RM,灬梅比利斯灬;RL,Drakor;RK,Hyitdai;RI,冲锋你没道理;RH,小術丶;RC,夏风爽,Ellerys",["幽暗沼泽"] = "Rc,虞燼;RE,Excaliburs;RD,三千歌一笑醉",["外域"] = "Rc,常威;RE,剑开天门",["国王之谷"] = "Rc,踏岚风;RW,花无心灬,三亚海景房;RV,虚空腐蚀;RU,森花;RT,飞天小草莓;RS,夫唯不爭,小肉米,元一,Lsq,Lts,灬熊大丶;RR,你看这把剑;RQ,骑士哈雷;RO,谷水者兮,猪突猛进,我有我方向;RN,永释,仰望丶夜空;RL,枫叶;RK,哈姆雷特,云翩鸿;RJ,月夜可乐;RI,随梦忆潇湘,菲尔琳;RF,丶骨火,江隂丨饅頭;RE,寒铁在上,小憨憨丶;RC,一笑奈何;RB,人离别,萬岁千秋,白驹氵过隙;RA,树鸟熊猫魚,索拉丶织棘者;Q/,一輪美滿,残盾;Q+,极热,尝试切他中路",["伊利丹"] = "Rb,地狱信仰者;RZ,凯尔薇娅丶;RT,云天青;RQ,风陌轻;RP,Wizark;RK,恶魔小丑;RE,长短深浅皆知;RA,飞行的老猫",["银松森林"] = "Rb,团宝的逆袭",["伊萨里奥斯"] = "Rb,秋末",["洛肯"] = "Rb,Juppiter;RR,影血;RC,熊壮大猫咪",["火焰之树"] = "Rb,跳并快乐着;RG,愿逐月华",["恶魔之魂"] = "Rb,夏娜;RI,永恒丶传奇",["永夜港"] = "Ra,Bloodoath",["壁炉谷"] = "Ra,燕莺穿秀幕;RV,暴力大湿兄;RG,Porsche",["大地之怒"] = "Ra,竹子",["荆棘谷"] = "Ra,妹控欧皇呀;RB,蟹老板",["巫妖之王"] = "Ra,厮守灬聴雨;RO,继续灬浪漫;Q/,海之间",["风行者"] = "Ra,畅饮妇炎洁;RQ,Hellscyther;RB,隔壁水果店丶",["诺森德"] = "Ra,亚索;RT,Mnsen;RD,哲里",["诺兹多姆"] = "RZ,路人灬甲;RW,带朱狂粉三号;RV,一二三亖五,火炎灬焱燚;RJ,谁家小娘子;RI,大魔王丽丽;RG,柒异淉",["弗塞雷迦"] = "RZ,乡里三耕田;RQ,一条小团团;RE,咖啡守护汐汐;RC,康师傅冰红茶",["泰兰德"] = "RZ,木村唯人;RF,星曜之刃;RB,熊熊奇妙冒险",["斯克提斯"] = "RZ,冬天睡觉觉",["亡语者"] = "RZ,专业退堂鼓;RV,貝吉塔;RN,四埜宫谣",["蜘蛛王国"] = "RZ,七星岗;RU,扎昆;RI,零伍柒柒",["奎尔丹纳斯"] = "RZ,芳心纵火犯",["加基森"] = "RY,泡泡玛特;RS,纠察丶;RP,猫的秤;RF,拒绝丶;Q+,闹闹爸",["死亡熔炉"] = "RY,紫薯布丁丶",["塞拉摩"] = "RY,夏丶丶;RM,Sonicarcanum;RL,牧光审判;RK,Sonicsaber;RE,来个署条;RB,清丶酒",["洛丹伦"] = "RY,大嘴胖;RW,法老之鹰;RJ,打工人之怒;RH,纯白牛牪犇;RB,赛柯蕾丶血歌",["烈焰峰"] = "RY,螺丝刀;RG,午夜的银河电台;RD,小碗",["索瑞森"] = "RY,木木猪;RU,羞羞得斩杀;Q/,雲中锦書來;Q+,雲影映暈",["亚雷戈斯"] = "RX,江北杀手;RF,柠檬之夏;Q/,一生有你",["雷斧堡垒"] = "RX,Isingle,说丶一;RB,雷霆扛把子;Q+,七色的魔法使",["黄金之路"] = "RX,夏美哩哩",["万色星辰"] = "RX,斯蒂琳;RE,天堂寒;Q/,威廉萌",["拉文凯斯"] = "RX,老虎也是仙儿;RU,啊互;RR,瑕年;RI,自摸零零漆;Q/,甄美",["远古海滩"] = "RW,我不是贝贝,Xiaoy;Q+,牛啸天",["石锤"] = "RW,最后一个傻馒",["阿纳克洛斯"] = "RW,柠檬不萌,随風;RU,暴走的三公主;RP,嬉笑者马冬梅;RO,微微一笑,钰慧;RK,远行者公子楠;RI,乐事;RE,Nsaids;RD,雷丶浮生若梦;RA,还有土拨鼠",["熵魔"] = "RW,九歌丶雲中君",["红龙女王"] = "RW,和她只是玩玩",["普瑞斯托"] = "RW,昂口田;RN,晚雪丶",["哈卡"] = "RW,一米诺陶一",["雷霆之怒"] = "RW,叶一;RR,丿不再永恒丶",["天空之墙"] = "RV,冰鎮檸檬",["凯尔萨斯"] = "RV,有点任性",["达尔坎"] = "RV,软萌大魔王;RK,初逝;Q/,快乐并忧伤",["加里索斯"] = "RV,法兰西",["试炼之环"] = "RV,蘑菇胖胖;RO,雲中锦書來;RB,霜之雨彤;Q+,牛将军丶老刘",["山丘之王"] = "RV,卡路迪亚;RQ,修昔底德",["奥金顿"] = "RV,野猪佩奇参见",["阿曼尼"] = "RV,战神罒奎托斯;RR,亲我帅吗",["血环"] = "RV,翠儿;RQ,Wzix;RM,東紫雲軒;RG,小鸡儿灵鬼",["符文图腾"] = "RV,淡殇;RU,鬼神童子丶",["艾苏恩"] = "RU,天玄魅惑",["玛里苟斯"] = "RU,王爷;Q/,艾尔玛娜",["冬拥湖"] = "RU,焚琴煮鶴",["阿克蒙德"] = "RU,Cagalli;RI,鈊睟;RE,五花变形肉;RA,Migo",["图拉扬"] = "RT,谁可相忘;RO,羽月引弓;RI,乌拉达瓦里希,李大树",["提瑞斯法"] = "RT,时间众筹研究;RC,演员周冬雨",["阿拉希"] = "RT,依然遥远;RF,加油吖皮卡丘",["Illidan[US]"] = "RS,Deprawei",["伊莫塔尔"] = "RS,果皮果肉果核",["銀翼要塞[TW]"] = "RS,玛唯影歌",["血羽"] = "RS,瑟瑟阿瑟瑟;RM,英雄;RL,灬盲灬",["卡拉赞"] = "RS,尤娜蕾丝卡;RE,一叶知秋",["艾露恩"] = "RS,玖龍皇帝;RP,泰克莱尔;RO,受王颂,挽風;RF,彭小兰;RB,巨侠老德;RA,陆老六",["蓝龙军团"] = "RS,道友留步啊",["鬼雾峰"] = "RR,坎十二;RQ,成辰;RO,凶猛的胡子;RJ,讨厌那里不行",["逐日者"] = "RR,Aceace",["格雷迈恩"] = "RR,熊孩孒,鸡你太美;RI,有感情的杀手;RF,梦中恶魔,只是注定;Q/,落零星",["萨尔"] = "RQ,沙盘上的痕迹",["月神殿"] = "RQ,Axelalmar",["戈提克"] = "RQ,千年龙神;RL,顧頭不顧尾",["末日祷告祭坛"] = "RQ,Williamm",["玛法里奥"] = "RQ,我的老北鼻;RA,菲奈珂思",["能源舰"] = "RQ,第七狩魂;RH,死之骑",["黑龙军团"] = "RQ,爱似婉秋丶",["凯恩血蹄"] = "RP,公子宸",["风暴之怒"] = "RP,自豪的打工人;RC,盛世经典;Q+,似锦年华",["巴尔古恩"] = "RO,韶华易逝",["玛多兰"] = "RO,想不好;RJ,琉璃白",["刺骨利刃"] = "RO,骠骑龙儿",["森金"] = "RO,Trollarcher;RD,风之逆襲",["瓦里玛萨斯"] = "RO,虚空大剑客",["纳克萨玛斯"] = "RO,傲娇双马尾",["奥达曼"] = "RO,爱吃菠萝",["日落沼泽"] = "RO,Haroin",["基尔罗格"] = "RN,扭扭软骨头",["巨龙之吼"] = "RN,憨狗",["圣火神殿"] = "RM,孤高的創世;RC,導演丶我躺哪",["闪电之刃"] = "RM,阿哦咦扫拉;RG,尼玛自己人",["罗曼斯"] = "RM,青海萨;RE,游穴者丶周浊",["奈法利安"] = "RM,救世萨满",["石爪峰"] = "RM,柒宗罪丶",["瑟莱德丝"] = "RM,李純陽",["暮色森林"] = "RM,依然怀念",["朵丹尼尔"] = "RM,阿芝莎",["雏龙之翼"] = "RL,烈酒傷神;Q+,Kej",["阿比迪斯"] = "RL,玄武肥龙",["狂热之刃"] = "RL,小晴心;RG,三一;RE,钱多给我花",["轻风之语"] = "RL,明夜",["风暴峭壁"] = "RL,噬血大黄鱼;RH,二了吧唧",["希尔瓦娜斯"] = "RK,乃欣;RJ,云笙",["米奈希尔"] = "RK,Ayu",["灰谷"] = "RK,次元紫雨;RB,蹬蹬爹",["达克萨隆"] = "RK,理想三旬",["激流之傲"] = "RK,鸡婆大师",["桑德兰"] = "RJ,Scorpionthor;RD,凯雯小笨蛋;RC,大柚子突然",["斩魔者"] = "RJ,Wwvv;RE,影之逆袭;RA,百山惊鸿",["耳语海岸"] = "RI,秋刀鱼;RG,朱莉娅风歌;RF,长风当歌",["加兹鲁维"] = "RI,复活的王尼玛;RE,轻井泽",["艾维娜"] = "RI,伊哟喂",["艾森娜"] = "RH,Paletteice",["法拉希姆"] = "RH,十四;Q+,Thatcher,Zarya",["遗忘海岸"] = "RH,星灬耀",["巴纳扎尔"] = "RH,忆梦",["梦境之树"] = "RH,新欢丶",["雷霆号角"] = "RH,落寞十三哥",["密林游侠"] = "RG,没仁花生,十项全男,爆到你心跳",["迪瑟洛克"] = "RG,你我的约会",["影牙要塞"] = "RG,狂徒晓峰;RC,付公子",["燃烧平原"] = "RG,蛋娘;Q+,Danaikz",["麦姆"] = "RG,女神丶",["金度"] = "RF,火法;RD,沐北丶半諾殇",["黑暗虚空"] = "RF,玛奇玛",["巴瑟拉斯"] = "RE,六眼盱鱼",["夜空之歌[TW]"] = "RE,网瘾治疗者",["阿卡玛"] = "RE,清灬茶",["库尔提拉斯"] = "RD,村里的爷们",["加尔"] = "RD,奥雷里亚诺;RC,哲学启示录",["芬里斯"] = "RD,玛塔哈里",["通灵学院"] = "RD,夯大锤",["银月"] = "RC,木牛流马",["托塞德林"] = "RC,小青丶",["爱斯特纳"] = "RC,洛丶天依",["时光之穴"] = "RC,去冰三分糖",["扎拉赞恩"] = "RB,妖之骄法",["利刃之拳"] = "RA,马师父;Q/,丶绫波丽",["奥斯里安"] = "RA,双刀就看走",["苏塔恩"] = "Q+,月影灬晨星",["阿拉索"] = "Q+,不语笑红尘",["寒冰皇冠"] = "Q+,法力残渣丶"};
local lastDonators = "单行道-主宰之剑,浊酒念红尘丶-安苏,梦里花萝-迦拉克隆,Radomss-贫瘠之地,狂徒练习生-燃烧之刃,再瞅下试试-无尽之海,哈哈坏天气-末日行者,梵刹迦蓝-罗宁,侠菩提-罗宁,丶黑鹅-伊森利恩,Bingk-破碎岭,儿时语-熊猫酒仙,Reincord-???,周大佬爺-熊猫酒仙,Sorei-凤凰之神,小神有礼了-格瑞姆巴托,Sho-凤凰之神,獸教父-主宰之剑,星河清梦-死亡之翼,你又胖了-贫瘠之地,灬柒爺丶-丽丽（四川）,猫不二-血色十字军,雪冰凌-麦迪文,丨夜白灬-罗宁,则竹裕之-战歌,长大后更帅-血吼,天煞-白骨荒野,微笑的蒂妮莎-世界之树,毛线团子-凤凰之神,心淡若水-风暴之鳞,烽火的箭矢-卡德加,尐胖纸丶-伊森利恩,骨头没有肉-安苏,恩赐解手-凤凰之神,顶缸-冰风岗,Simha-末日行者,善良的钢琴师-凤凰之神,狗头肥猫-埃德萨拉,不要不妖的-黑铁,妩妖王-黑暗魅影,Sastabber-冰风岗,六星霜-冰风岗,王不留狗-冰霜之刃,董老湿-血色十字军,堕落的小角-主宰之剑,丶名侦探柯南-死亡之翼,你的小虎哥-月光林地,荒野羽羿-白银之手,月落丷霜满天-夏维安,温酒丷叙余生-夏维安,盗云-格瑞姆巴托,平安喜樂-格瑞姆巴托,尛可心-影之哀伤,兽栏管里员-霜之哀伤,夏了个夏天-血色十字军,Lovoom-埃苏雷格,宫水三葉-罗宁,藤井美菜-熔火之心,鶸鶸的丶暮色-格瑞姆巴托,无故挽歌-血色十字军,安果-主宰之剑,夜翼迪克-霜之哀伤,王大蛮-金色平原,死就对了-贫瘠之地,可爱的李老师-黑铁,五更千里梦-贫瘠之地,新鲜韭浪两块-海克泰尔,箭隐鋒藏-埃德萨拉,一只小飞狗-永恒之井,仁吼義侠-凤凰之神,邓潇洒-影之哀伤,二郎显聖-暗影之月,怒放的雪-伊瑟拉,半醒-神圣之歌,赤魂-凤凰之神,敷衍的誓言-凤凰之神,晨熙爸爸-血牙魔王";
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