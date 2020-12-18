local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["埃德萨拉"] = "RO,南美大虾,钦丶黄先生;RM,八倍镜九八克;RL,夏娜丶;RK,周二二;RI,Hugtwelve,记忆终諟丶;RH,游戏的大喵;RG,宇智波奶牛;RE,单吊丶東风;RC,奶油熊起司;RA,丨丶青衫;Q/,骁哥最帅;Q+,灬阿猫灬,丨丶青衫未旧",["格瑞姆巴托"] = "RO,折耳大松狮,牛奶斩;RM,憨憨德蟀,墨蝶黛霁,夏灬侃;RL,迷汉相亲;RK,输出垫底丶,丨惟馨,丨鬼丶姬;RI,桃花雨;RH,白老师;RF,中島美雪;RE,旺川,哆啦批梦;RB,你枯燥么,东华少阳君,醉酒夢红颜,小鸡球球;Q/,少女映画;Q+,哈啤穿肠过,梦扬天际",["安苏"] = "RO,坏蛋大魔王;RN,弯牙队长;RM,白老師;RK,绿的心慌慌,夏侯怼怼;RJ,丶茹比,Themis,花映丛祠;RH,芒果柠檬西瓜,一朵星光玫瑰;RG,我将帶頭冲锋;RE,十元打五炮,蓝蓝纸飞机,丨四一丨,全是肉没土豆;RC,战倾血爆,贰一,艾小美,红颜最倾城,不谈情怀;RB,奥科萨娜,芋头炖牛腩丶;RA,十字军的清算,魔法宅急送丶;Q/,麦普替林;Q+,只愿诗和远方,冰星心,北暝",["布兰卡德"] = "RO,无访问权限,懒兮兮;RM,桃桃奇妙探险,Hezzy;RK,明澈;RI,姜丝切片;RH,小心肝;RE,迷人又危险丶;RD,喵爪啵奇塔;RC,血色丶阿丽塔,尐尐丶;RB,银涛溜溜,螺丝粉;Q+,欧丿二泉映月",["艾露恩"] = "RO,挽風;RF,彭小兰;RB,巨侠老德;RA,陆老六",["试炼之环"] = "RO,雲中锦書來;RB,霜之雨彤;Q+,牛将军丶老刘",["燃烧之刃"] = "RO,夏拉诺瑞;RM,乄老白乄;RK,岚凌;RJ,九陽;RI,用脚输出丶;RH,Deczz,西固;RG,青梦,宋义进,僵小硬;RF,卡的漂亮,丶果儿丶;RD,圣光洗礼丶;RC,乄老白,老白乄,圣光奶嘴;RB,酒仙女,丨嫣於倾黛;RA,Goodknight,卖皮孩;Q/,疯狂的麦田丶,疯狂的麦子丶,老乄乄白,老乄白,术小鱼",["黑铁"] = "RO,Viu;RL,小小雷丶,凌乱心情;RI,阿翼,念旧;RG,小老板晴晴;RF,优雅的帅夯比",["伊森利恩"] = "RO,麦兜吖,星辰海,殺画丶,浮云千载;RN,地狱血泪,灵子丷,小熊盼盼;RM,橘色鸢尾,丶馋猫丶;RL,喵菲斯特;RJ,小阿宝呐;RI,达雷尔的岛,妳不要玩火;RH,柳涟漪,大猪蹄纸,唯独小休;RG,Joki,冯稀饭,橙管,光铸乔碧萝;RF,隔壁老韦,该角色已诈尸,关于小熊丶;RE,曓力美学,苏美尔;RD,很强,凤黎,星之澪,Lockjaw;RC,Hinataml,Anataml,痱子粉;RB,風無雨;RA,甜酒冲蛋,勾手老大爷;Q/,暗影之境丶雷;Q+,Redone,花花厷孒,北执",["克尔苏加德"] = "RO,萨神片片;RL,夜话白露;RK,季爸;RJ,花泽丿香菜;RG,揮炮干到服;RF,何以忆初訫,斯黛拉;RE,牛奶巧克力,梦想蓝睛灵,凹凸凸叁;RD,双刃法雷尔;RC,沐雪无尘;Q+,枪手哥哥",["国王之谷"] = "RO,猪突猛进,我有我方向;RN,永释,仰望丶夜空;RL,枫叶;RK,哈姆雷特,云翩鸿;RJ,月夜可乐;RI,随梦忆潇湘,菲尔琳;RF,丶骨火,江隂丨饅頭;RE,寒铁在上,小憨憨丶;RC,一笑奈何;RB,人离别,萬岁千秋,白驹氵过隙;RA,树鸟熊猫魚,索拉丶织棘者;Q/,一輪美滿,残盾;Q+,极热,尝试切他中路",["永恒之井"] = "RO,香辣鸡腿堡;RM,临溪观鱼,醉驾;RI,咬哭橙汁;RH,最初的梦想;RG,丨校长秘书丨;RD,十里桃林",["凤凰之神"] = "RO,黒杀,雲端的脚板丫,绝活哥,神经兮兮丶丶;RM,了不起的杰弗,五蒾叁噵,丶小暴,宝哥哥灬;RL,做梦的熊猫,法芮尔;RK,哺育后代,莫小兮,万能的牛,森森呀;RJ,賊走运,安非他命丶;RI,丶雪碧泡饭,北斗晴天,Megoodluck,丿小楽丶,Despredo,火之神神乐丶,Tsai;RH,猫饭饭茶碗蒸;RG,厄運红叶,疾风剑皇,热心肠的小张;RF,青丨阳,滿楽,萌萌的战战,馋他,芭芭拉冲啊;RE,浩子未知,照猫画虎,迷路小兔兔丶,阿姨沾酱;RD,且须饮美酒,风丶逝,胖胖嘚文哥丶;RC,惯犯王,骚嘚斯奶,浮云千载,深野昂,Avogadro;RB,刮痧技师丶,灬纤尘灬;RA,Sakurall,最深情的森西,因幡帝丶,莫歌;Q+,壕运气,绮德丶",["神圣之歌"] = "RO,太阳之子;RH,山水草木",["鬼雾峰"] = "RO,凶猛的胡子;RJ,讨厌那里不行",["白银之手"] = "RO,圣夏丶若空;RN,獸王乄曼陀羅,晴天天丶;RM,墨墨萌萌哒,瀬戸際,猎丶清风,酒杯与铃铛,小能饼干,璎珞晨曦;RL,烤鹌鹑蛋,蔷薇小舞,光头黑叔叔,骄傲的剑姬,心中藏百鬼;RK,邓诗颖;RI,梅尔特莉莉絲,苍穹之跃;RH,择林,苍之无极,亿易,惡靈騎士,狼的一逼;RG,Stnyrah,Kaytse,Oeverhopeful,啾啾就是啾啾;RF,一骜,黄山张老师,侠客风行者,亖宇宙队长亖,德妮维雅,逆风花潇,逆风骑行,愁绪万千;RE,小青龙,啾哩个啾,星空天蝎座,芥末味冰淇淋,火槍手追獵者;RD,Xwh,电竞斯坦森,司言,哲哲大憨憨,擎天過雨;RC,埃提耶什,清梦挽依,野人参;RB,琦玉老师灬,伊雪夜,开光大湿丶,一点不自律,阿尔萨喵,童話鎮;RA,雲杨,温岭胡歌,飞驰柚子,南野;Q/,陳喬恩,乱舞乄风行者,Demondark,维灬他,酒樱;Q+,雷德琪,回梦夜影,天空蔚蓝灬,这是女鬼,老王遛狗,清音梵唱,Penumbra,奶一次绿一次",["阿纳克洛斯"] = "RO,微微一笑,钰慧;RK,远行者公子楠;RI,乐事;RE,Nsaids;RD,雷丶浮生若梦;RA,还有土拨鼠",["死亡之翼"] = "RO,Kissmyaass;RN,亣波;RM,王生气,莎谱糯丝,我不会再逃了,沐丷韩;RL,雷电海王包包,奥格张学友,木剑丶温华,风宸丶;RK,临冬城丹妮丝,奶狗丶,程暖暖;RJ,天才哞哞;RI,炙日星河,天上谣,毛小豆,Betelgeuse,呗之诗丶,大迦楼罗,娜娜的狸猫,跳刀丶跳刀丶;RH,风中大雕哥;RG,牛皇,小小酱油瓶;RF,法神咔咔;RE,老人古井,昊寒冰,风色月,沉默的真相;RD,小喵呜;RC,迢迢間風月,飘雪灬;RB,求你别插进来,紫韵铭馨,莺鸢,傻比晓得;RA,Asknb,魔桀神;Q/,小栞的狐狸,老牛吃嫩草丶;Q+,丷小眼迷人丷,盗口大重九,西柚茉莉茶丶,德抽大重九,手拿大重九",["血色十字军"] = "RO,鱼斯拉朵朵,阮囡囡;RN,西瓜皮丶;RK,Adorable,奎托斯之怒;RI,桃桃芝士,小小灾变;RH,杜家丶小贝,大哔哥哥;RF,Imfit;RE,叹息的富士山,术起中指丶;RD,Meastoso;RC,没有止痛药水;RB,我是个正经人,表妹丶;RA,达拉崩吧丶,珊瑚丶海,蜡笔海盗,昨日青空;Q/,祟图,社会的榜样,爆炸糖果,席梦来;Q+,机车小迷弟",["纳克萨玛斯"] = "RO,傲娇双马尾",["龙骨平原"] = "RO,须弥华光;RF,求之不德,云端丶;RB,Romeo;Q/,战世,丶黑夜传说",["奥达曼"] = "RO,爱吃菠萝",["日落沼泽"] = "RO,Haroin",["金色平原"] = "RO,阿尔忒觅斯;RM,哎呀拉多了;RK,喜气盈门,花小辫;RJ,丁书生;RH,藏宝图宝藏;RF,佐里昂娜;RD,我醉君复乐,贝尔晨酿;RB,誰為我停留;RA,庆余,好灬好美哟",["翡翠梦境"] = "RO,永燃火焰;RL,悲伤绝恋曲",["主宰之剑"] = "RO,暗夜包子;RM,Spe;RK,最后的白月光;RJ,錶子与枪丶;RH,Async,叶之湫,天使也无奈,自在行;RG,虞城丶驿;RF,社会你波哥,射誰谁怀芸,月光下的云海,王权,袁九思,用血捍卫荣耀,小荃,天津饭饭,苦孩;RD,教官的第四科;RB,風吹不散长恨,年轻不讲舞德;RA,一岁可萌了;Q/,导演法;Q+,夜尽丶辰曦,快进到退休",["图拉扬"] = "RO,羽月引弓;RI,乌拉达瓦里希,李大树",["???"] = "RN,丶强颜欢笑;RM,夏丶先生;RK,雪琪酱;RI,年华灬流光,帮瑞哥毛板甲,抱抱是只喵;RF,北卡二号;RE,游魂灯丶",["海克泰尔"] = "RN,艾尔德林,温茶青盏;RG,爱的拳头;RF,耐小九;RE,万亩稻上飞丶;RC,基尔夹卤蛋;RA,旧城半夏,夜丶微凉,灵魂祭司雷尼;Q+,风中一头牛,猜心,心云",["无尽之海"] = "RN,不沾酒,逗德一批;RM,奈何落雪丶;RK,情有獨锺;RJ,晚凉天;RI,大肥小果,温灬凉,又骚又欠打;RH,萨鲁法尔战歌,风丶凉;RF,吥搖碧蓮丶,城里放炮;RE,芸墨,屠魔风暴,死鱼非命,琥珀年崋;RC,风陌轻;RB,做你的宝搞;RA,青衣凉惹白霜;Q/,麒麟仔,食人魔魔法師,翊悬;Q+,慧者实乂橙,灬奶茶炖鸡灬,小原",["奥特兰克"] = "RN,铁血雨落;RE,不正经大叔,仙念丶,花岗岩哥哥,Missflg",["迦拉克隆"] = "RN,愛棒棒;RM,毒岛丶伢子;RI,玳瑁之棍;RF,喵嗷咩;RB,空城美雪,白墨谷雨",["熊猫酒仙"] = "RN,尐冞粒,不羁浪人丶;RM,咕半仙;RK,俊秀钧同;RJ,萨丽曼;RI,小熊掌;RF,拉库拉玛塔塔;RE,李小胖灬,黑醫白翼;RD,你到底怕不怕;RC,欧皇橙满天;RB,小光人,射的你发慌;RA,丿锖兎丶;Q/,JohnPan;Q+,十公里,敗犬",["基尔罗格"] = "RN,扭扭软骨头",["贫瘠之地"] = "RN,丶又菜又稳定,Tiwaz;RM,汝衣,宁静在沸腾;RK,青蘿拂行衣,炎涛白燎莽;RJ,不悟兰因,天堂情书;RI,云谷胖胖,丨你的讯息丨;RG,姥衲法号乱射,风之丶牧语;RF,憨壮壮,奥利给大魔王;RE,丷大橙子丷,暧暧;RD,嫂子好刺激哦,木岂能择鸟,Gigapull,我负责云,是晨阳哟,水果拉面,灵魂超越;RC,荒野老司机,惹我半生风雪,绒布团子;RB,凰弥;RA,官人不卖艺;Q/,末白丶,小牛丹尼,大地香瓜,欧狍;Q+,Shaka,小末日,花丶雨",["亡语者"] = "RN,四埜宫谣",["冰霜之刃"] = "RN,撒旦之心;RK,克尔苏加狗;RB,丶铁柱",["巨龙之吼"] = "RN,憨狗",["影之哀伤"] = "RN,会所大镖客;RM,Icedmilktea;RL,雲端小胖,尤瑞丶艾莉,划水之王老刘,滑水之王老刘,Darthwen,暖心男神;RK,掱心,丨飞鸟与鱼丨,卝叶子,已忘言,苇草,橘子尐尐;RJ,愤怒小熊,Happyholiday;RI,林友有,前男友;RH,二貮贰號;RG,三支香,帝龙灬归来;RF,菠萝催血,月夜白;RE,Euroyalol,有时看雲;RD,天才第壹歩;RC,林空鹿饮溪;RB,挣扎,一瞒天一,丶萧默默;RA,勒子;Q/,流梳灬烟沐,懒懒空天猎;Q+,穿靴子的牛",["风暴之鳞"] = "RN,Hshaman",["末日行者"] = "RN,大刀关凤;RL,As;RK,斯巴达士兵;RJ,偸吻妳的心;RI,奥蕾莉垭,馬咚梅;RG,最爱鱼鱼;RF,安不骑;RE,最爱香菜,西门吹血;RD,摸腿腿丶;RC,安慕茜,愤怒的苗苗;RB,我是乱打的;Q/,舔娃;Q+,小楼一夜趴啪,腹黑骑师",["普瑞斯托"] = "RN,晚雪丶",["圣火神殿"] = "RM,孤高的創世;RC,導演丶我躺哪",["回音山"] = "RM,灬梅比利斯灬;RL,Drakor;RK,Hyitdai;RI,冲锋你没道理;RH,小術丶;RC,夏风爽,Ellerys",["塞拉摩"] = "RM,Sonicarcanum;RL,牧光审判;RK,Sonicsaber;RE,来个署条;RB,清丶酒",["闪电之刃"] = "RM,阿哦咦扫拉;RG,尼玛自己人",["血环"] = "RM,東紫雲軒;RG,小鸡儿灵鬼",["迅捷微风"] = "RM,流螢;RI,孤独的海怪;RG,合剂爸爸,宇宙对我歌唱;RC,外面有狗了,草上飞不动;RB,是与非;Q/,章鱼法",["熔火之心"] = "RM,阿昆达之赐;RI,小牛强强;RF,穿拖鞋的精灵;RD,断离",["罗曼斯"] = "RM,青海萨;RE,游穴者丶周浊",["战歌"] = "RM,夜炑",["奈法利安"] = "RM,救世萨满",["石爪峰"] = "RM,柒宗罪丶",["瑟莱德丝"] = "RM,李純陽",["雷霆之王"] = "RM,搂你小腰;RD,暗雨星魂;RB,格雷丶帕斯塔",["血羽"] = "RM,英雄;RL,灬盲灬",["暮色森林"] = "RM,依然怀念",["朵丹尼尔"] = "RM,阿芝莎",["戈提克"] = "RL,顧頭不顧尾",["卡德加"] = "RL,也许会有明天;RD,烽火得箭矢;RC,一湖心静,洛丹伦二公主",["雏龙之翼"] = "RL,烈酒傷神;Q+,Kej",["阿比迪斯"] = "RL,玄武肥龙",["丽丽（四川）"] = "RL,Lzyzz;RI,勃艮第炖牛腩;RF,Yimin,三刀;RE,剑与斜阳,你好钱先生;RD,Yax,月来凤栖山;RA,南部丑锅锅,别闹灬;Q+,飞花轻梦丶",["狂热之刃"] = "RL,小晴心;RG,三一;RE,钱多给我花",["耐奥祖"] = "RL,Eviljokers",["暗影之月"] = "RL,法夜小狐狸;RF,黯然缥邈;RB,在水之湄",["轻风之语"] = "RL,明夜",["伊瑟拉"] = "RL,推到小朋友;RE,那尔撒斯",["风暴峭壁"] = "RL,噬血大黄鱼;RH,二了吧唧",["破碎岭"] = "RK,玩酷花少;RG,自由的阿昆达;RE,秋喜姐;Q/,堕落的路西法",["泰拉尔"] = "RK,丨乳酸菌丨",["希尔瓦娜斯"] = "RK,乃欣;RJ,云笙",["达尔坎"] = "RK,初逝;Q/,快乐并忧伤",["米奈希尔"] = "RK,Ayu",["灰谷"] = "RK,次元紫雨;RB,蹬蹬爹",["达克萨隆"] = "RK,理想三旬",["激流之傲"] = "RK,鸡婆大师",["伊利丹"] = "RK,恶魔小丑;RE,长短深浅皆知;RA,飞行的老猫",["诺兹多姆"] = "RJ,谁家小娘子;RI,大魔王丽丽;RG,柒异淉",["逐日者"] = "RJ,Aceace",["月光林地"] = "RJ,凌豆腐;RF,凉生丶",["冰风岗"] = "RJ,涅白,丷天意;RF,天上哦,奇克秀;RE,彩翼鲸尾红丝,Rosamond;RD,Relina,源赖式佐田,二百一十六斤,小酌又黄昏;Q/,专业杀鸡拔毛",["古尔丹"] = "RJ,苹果酱",["桑德兰"] = "RJ,Scorpionthor;RD,凯雯小笨蛋;RC,大柚子突然",["玛多兰"] = "RJ,琉璃白",["洛丹伦"] = "RJ,打工人之怒;RH,纯白牛牪犇;RB,赛柯蕾丶血歌",["罗宁"] = "RJ,童真霸霸,欧阳奶奶,灿烂的花火;RI,奥隐;RH,吕根斗,矮老黑;RG,我真是哔了咕,茜茜有环;RF,长袜子皮皮,沐沨;RD,大鱼鱼爱吃肉,炒饭丶;RC,轻拢慢捻;RB,灬桃兔灬,小支百威,远山之巅;RA,大圆蟀,青咿染霜华;Q/,小鷄湯;Q+,Sacrificed",["阿古斯"] = "RJ,简安;RI,帅的闹心;RH,牧濑丨红莉栖;RF,倾国卿宸丶;RE,丨猎魔丨,影踪秘卫沧萍;RC,菊你太美;Q/,Deathbarbie",["斩魔者"] = "RJ,Wwvv;RE,影之逆袭;RA,百山惊鸿",["蜘蛛王国"] = "RI,零伍柒柒",["拉文凯斯"] = "RI,自摸零零漆;Q/,甄美",["阿克蒙德"] = "RI,鈊睟;RE,五花变形肉;RA,Migo",["奥尔加隆"] = "RI,齐格弗里德;RG,幼儿园拳霸",["诺莫瑞根"] = "RI,乖乖酱",["恶魔之魂"] = "RI,永恒丶传奇",["格雷迈恩"] = "RI,有感情的杀手;RF,梦中恶魔,只是注定;Q/,落零星",["耳语海岸"] = "RI,秋刀鱼;RG,朱莉娅风歌;RF,长风当歌",["加兹鲁维"] = "RI,复活的王尼玛;RE,轻井泽",["艾维娜"] = "RI,伊哟喂",["艾森娜"] = "RH,Paletteice",["法拉希姆"] = "RH,十四;Q+,Thatcher,Zarya",["遗忘海岸"] = "RH,星灬耀",["能源舰"] = "RH,死之骑",["梅尔加尼"] = "RH,何康老鬼;RC,小甲甲丶;Q/,悠悠德",["巴纳扎尔"] = "RH,忆梦",["梦境之树"] = "RH,新欢丶",["雷霆号角"] = "RH,落寞十三哥",["密林游侠"] = "RG,没仁花生,十项全男,爆到你心跳",["烈焰峰"] = "RG,午夜的银河电台;RD,小碗",["迪瑟洛克"] = "RG,你我的约会",["影牙要塞"] = "RG,狂徒晓峰;RC,付公子",["壁炉谷"] = "RG,Porsche",["燃烧平原"] = "RG,蛋娘;Q+,Danaikz",["火焰之树"] = "RG,愿逐月华",["麦姆"] = "RG,女神丶",["泰兰德"] = "RF,星曜之刃;RB,熊熊奇妙冒险",["亚雷戈斯"] = "RF,柠檬之夏;Q/,一生有你",["金度"] = "RF,火法;RD,沐北丶半諾殇",["霜之哀伤"] = "RF,祖宗;RD,游学者叮当;RB,丨眰恦丨;Q+,眸中星河似梦,灿烂尐尐,今生为你舔,恰似童话",["阿拉希"] = "RF,加油吖皮卡丘",["黑暗虚空"] = "RF,玛奇玛",["加基森"] = "RF,拒绝丶;Q+,闹闹爸",["巴瑟拉斯"] = "RE,六眼盱鱼",["夜空之歌[TW]"] = "RE,网瘾治疗者",["阿卡玛"] = "RE,清灬茶",["外域"] = "RE,剑开天门",["世界之树"] = "RE,絮语飘雪;RB,瓦尔姬里",["万色星辰"] = "RE,天堂寒;Q/,威廉萌",["幽暗沼泽"] = "RE,Excaliburs;RD,三千歌一笑醉",["卡拉赞"] = "RE,一叶知秋",["弗塞雷迦"] = "RE,咖啡守护汐汐;RC,康师傅冰红茶",["森金"] = "RD,风之逆襲",["库尔提拉斯"] = "RD,村里的爷们",["加尔"] = "RD,奥雷里亚诺;RC,哲学启示录",["芬里斯"] = "RD,玛塔哈里",["通灵学院"] = "RD,夯大锤",["诺森德"] = "RD,哲里",["银月"] = "RC,木牛流马",["提瑞斯法"] = "RC,演员周冬雨",["洛肯"] = "RC,熊壮大猫咪",["托塞德林"] = "RC,小青丶",["爱斯特纳"] = "RC,洛丶天依",["风暴之怒"] = "RC,盛世经典;Q+,似锦年华",["时光之穴"] = "RC,去冰三分糖",["荆棘谷"] = "RB,蟹老板",["扎拉赞恩"] = "RB,妖之骄法",["风行者"] = "RB,隔壁水果店丶",["雷斧堡垒"] = "RB,雷霆扛把子;Q+,七色的魔法使",["玛法里奥"] = "RA,菲奈珂思",["玛瑟里顿"] = "RA,Vitamine",["克洛玛古斯"] = "RA,闪光伯爵",["利刃之拳"] = "RA,马师父;Q/,丶绫波丽",["奥斯里安"] = "RA,双刀就看走",["巫妖之王"] = "Q/,海之间",["索瑞森"] = "Q/,雲中锦書來;Q+,雲影映暈",["玛里苟斯"] = "Q/,艾尔玛娜",["远古海滩"] = "Q+,牛啸天",["苏塔恩"] = "Q+,月影灬晨星",["阿拉索"] = "Q+,不语笑红尘",["寒冰皇冠"] = "Q+,法力残渣丶"};
local lastDonators = "宁静在沸腾-贫瘠之地,沐丷韩-死亡之翼,咕半仙-熊猫酒仙,搂你小腰-雷霆之王,李純陽-瑟莱德丝,柒宗罪丶-石爪峰,奈何落雪丶-无尽之海,救世萨满-奈法利安,夏灬侃-格瑞姆巴托,璎珞晨曦-白银之手,小能饼干-白银之手,丶小暴-凤凰之神,夜炑-战歌,青海萨-罗曼斯,酒杯与铃铛-白银之手,五蒾叁噵-凤凰之神,了不起的杰弗-凤凰之神,我不会再逃了-死亡之翼,Hezzy-布兰卡德,醉驾-永恒之井,乄老白乄-燃烧之刃,阿昆达之赐-熔火之心,流螢-迅捷微风,東紫雲軒-血环,毒岛丶伢子-迦拉克隆,猎丶清风-白银之手,夏丶先生-???,瀬戸際-白银之手,墨蝶黛霁-格瑞姆巴托,丶又菜又稳定-贫瘠之地,丶馋猫丶-伊森利恩,莎谱糯丝-死亡之翼,橘色鸢尾-伊森利恩,临溪观鱼-永恒之井,Spe-主宰之剑,阿哦咦扫拉-闪电之刃,桃桃奇妙探险-布兰卡德,白老師-安苏,墨墨萌萌哒-白银之手,Sonicarcanum-塞拉摩,哎呀拉多了-金色平原,灬梅比利斯灬-回音山,憨憨德蟀-格瑞姆巴托,汝衣-贫瘠之地,孤高的創世-圣火神殿,王生气-死亡之翼,Tiwaz-贫瘠之地,獸王乄曼陀羅-白银之手,不羁浪人丶-熊猫酒仙,温茶青盏-海克泰尔,晚雪丶-普瑞斯托,亣波-死亡之翼,小熊盼盼-伊森利恩,大刀关凤-末日行者,晴天天丶-白银之手,Hshaman-风暴之鳞,仰望丶夜空-国王之谷,会所大镖客-影之哀伤,憨狗-巨龙之吼,西瓜皮丶-血色十字军,撒旦之心-冰霜之刃,四埜宫谣-亡语者,丶又菜又稳定-贫瘠之地,灵子丷-伊森利恩,弯牙队长-安苏,扭扭软骨头-基尔罗格,地狱血泪-伊森利恩,逗德一批-无尽之海,永释-国王之谷,尐冞粒-熊猫酒仙,愛棒棒-迦拉克隆,铁血雨落-奥特兰克,獸王乄曼陀羅-白银之手,不沾酒-无尽之海,艾尔德林-海克泰尔,丶强颜欢笑-???,神经兮兮丶丶-凤凰之神,羽月引弓-图拉扬,暗夜包子-主宰之剑,永燃火焰-翡翠梦境,绝活哥-凤凰之神,雲端的脚板丫-凤凰之神,阮囡囡-血色十字军,阿尔忒觅斯-金色平原,浮云千载-伊森利恩,钰慧-阿纳克洛斯,Haroin-日落沼泽,爱吃菠萝-奥达曼,牛奶斩-格瑞姆巴托,须弥华光-龙骨平原,殺画丶-伊森利恩,傲娇双马尾-纳克萨玛斯,鱼斯拉朵朵-血色十字军,Kissmyaass-死亡之翼,懒兮兮-布兰卡德,微微一笑-阿纳克洛斯,我有我方向-国王之谷,圣夏丶若空-白银之手,凶猛的胡子-鬼雾峰,星辰海-伊森利恩,太阳之子-神圣之歌,黒杀-凤凰之神,香辣鸡腿堡-永恒之井,猪突猛进-国王之谷,萨神片片-克尔苏加德,麦兜吖-伊森利恩,Viu-黑铁,钦丶黄先生-埃德萨拉,夏拉诺瑞-燃烧之刃,雲中锦書來-试炼之环,挽風-艾露恩,无访问权限-布兰卡德,坏蛋大魔王-安苏,折耳大松狮-格瑞姆巴托,南美大虾-埃德萨拉";
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