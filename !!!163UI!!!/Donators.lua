local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["凤凰之神"] = "RJ,賊走运,安非他命丶;RI,丶雪碧泡饭,北斗晴天,Megoodluck,丿小楽丶,Despredo,火之神神乐丶,Tsai;RH,猫饭饭茶碗蒸;RG,厄運红叶,疾风剑皇,热心肠的小张;RF,青丨阳,滿楽,萌萌的战战,馋他,芭芭拉冲啊;RE,浩子未知,照猫画虎,迷路小兔兔丶,阿姨沾酱;RD,且须饮美酒,风丶逝,胖胖嘚文哥丶;RC,惯犯王,骚嘚斯奶,浮云千载,深野昂,Avogadro;RB,刮痧技师丶,灬纤尘灬;RA,Sakurall,最深情的森西,森森鸭,因幡帝丶,莫歌;Q+,壕运气,绮德丶",["诺兹多姆"] = "RJ,谁家小娘子;RI,大魔王丽丽;RG,柒异淉",["逐日者"] = "RJ,Aceace",["熊猫酒仙"] = "RJ,萨丽曼;RI,小熊掌;RF,拉库拉玛塔塔;RE,李小胖灬,黑醫白翼;RD,你到底怕不怕;RC,欧皇橙满天;RB,小光人,射的你发慌;RA,丿锖兎丶;Q/,JohnPan;Q+,十公里,敗犬",["贫瘠之地"] = "RJ,不悟兰因,天堂情书;RI,云谷胖胖,丨你的讯息丨;RG,姥衲法号乱射,风之丶牧语;RF,憨壮壮,奥利给大魔王;RE,丷大橙子丷,暧暧;RD,嫂子好刺激哦,木岂能择鸟,Gigapull,我负责云,是晨阳哟,水果拉面,灵魂超越;RC,荒野老司机,惹我半生风雪,绒布团子;RB,凰弥;RA,官人不卖艺;Q/,末白丶,小牛丹尼,大地香瓜,欧狍;Q+,Shaka,小末日,花丶雨",["末日行者"] = "RJ,偸吻妳的心;RI,奥蕾莉垭,馬咚梅;RG,最爱鱼鱼;RF,安不骑;RE,最爱香菜,西门吹血;RD,摸腿腿丶;RC,安慕茜,愤怒的苗苗;RB,我是乱打的;Q/,舔娃;Q+,小楼一夜趴啪,腹黑骑师",["伊森利恩"] = "RJ,菠萝小可颂,小阿宝呐;RI,达雷尔的岛,妳不要玩火;RH,柳涟漪,大猪蹄纸,唯独小休;RG,Joki,冯稀饭,橙管,光铸乔碧萝;RF,隔壁老韦,该角色已诈尸,关于小熊丶;RE,曓力美学,苏美尔;RD,很强,凤黎,星之澪,Lockjaw;RC,Hinataml,Anataml,痱子粉;RB,風無雨;RA,甜酒冲蛋,勾手老大爷;Q/,暗影之境丶雷;Q+,Redone,花花厷孒,北执",["安苏"] = "RJ,丶茹比,Themis,花映丛祠;RH,芒果柠檬西瓜,一朵星光玫瑰;RG,我将帶頭冲锋;RE,十元打五炮,蓝蓝纸飞机,丨四一丨,全是肉没土豆;RC,战倾血爆,贰一,艾小美,红颜最倾城,不谈情怀;RB,奥科萨娜,芋头炖牛腩丶;RA,十字军的清算,魔法宅急送丶;Q/,麦普替林;Q+,只愿诗和远方,冰星心,北暝",["月光林地"] = "RJ,凌豆腐;RF,凉生丶",["冰风岗"] = "RJ,涅白,丷天意;RF,天上哦,奇克秀;RE,彩翼鲸尾红丝,Rosamond;RD,Relina,源赖式佐田,二百一十六斤,小酌又黄昏;Q/,专业杀鸡拔毛",["希尔瓦娜斯"] = "RJ,云笙",["死亡之翼"] = "RJ,天才哞哞;RI,炙日星河,天上谣,毛小豆,Betelgeuse,呗之诗丶,大迦楼罗,娜娜的狸猫,跳刀丶跳刀丶;RH,风中大雕哥;RG,牛皇,小小酱油瓶;RF,法神咔咔;RE,老人古井,昊寒冰,风色月,沉默的真相;RD,小喵呜;RC,迢迢間風月,飘雪灬;RB,求你别插进来,紫韵铭馨,莺鸢,傻比晓得;RA,Asknb,魔桀神;Q/,小栞的狐狸,老牛吃嫩草丶;Q+,丷小眼迷人丷,盗口大重九,西柚茉莉茶丶,德抽大重九,手拿大重九",["古尔丹"] = "RJ,苹果酱",["桑德兰"] = "RJ,Scorpionthor;RD,凯雯小笨蛋;RC,大柚子突然",["玛多兰"] = "RJ,琉璃白",["洛丹伦"] = "RJ,打工人之怒;RH,纯白牛牪犇;RB,赛柯蕾丶血歌",["燃烧之刃"] = "RJ,九陽;RI,用脚输出丶;RH,Deczz,西固;RG,青梦,宋义进,僵小硬;RF,卡的漂亮,丶果儿丶;RD,圣光洗礼丶;RC,乄老白,老白乄,圣光奶嘴;RB,酒仙女,丨嫣於倾黛;RA,Goodknight,卖皮孩;Q/,疯狂的麦田丶,疯狂的麦子丶,老乄乄白,老乄白,术小鱼",["鬼雾峰"] = "RJ,讨厌那里不行",["克尔苏加德"] = "RJ,花泽丿香菜;RG,揮炮干到服;RF,何以忆初訫,斯黛拉;RE,牛奶巧克力,梦想蓝睛灵,凹凸凸叁;RD,双刃法雷尔;RC,沐雪无尘;Q+,枪手哥哥",["影之哀伤"] = "RJ,愤怒小熊,Happyholiday;RI,林友有,前男友;RH,二貮贰號;RG,三支香,帝龙灬归来;RF,菠萝催血,月夜白;RE,Euroyalol,有时看雲;RD,天才第壹歩;RC,林空鹿饮溪;RB,挣扎,一瞒天一,丶萧默默;RA,勒子;Q/,流梳灬烟沐,懒懒空天猎;Q+,穿靴子的牛",["罗宁"] = "RJ,童真霸霸,欧阳奶奶,灿烂的花火;RI,奥隐;RH,吕根斗,矮老黑;RG,我真是哔了咕,茜茜有环;RF,长袜子皮皮,沐沨;RD,大鱼鱼爱吃肉,炒饭丶;RC,轻拢慢捻;RB,灬桃兔灬,小支百威,远山之巅;RA,大圆蟀,青咿染霜华;Q/,小鷄湯;Q+,Sacrificed",["阿古斯"] = "RJ,简安;RI,帅的闹心;RH,牧濑丨红莉栖;RF,倾国卿宸丶;RE,丨猎魔丨,影踪秘卫沧萍;RC,菊你太美;Q/,Deathbarbie",["斩魔者"] = "RJ,Wwvv;RE,影之逆袭;RA,百山惊鸿",["无尽之海"] = "RJ,晚凉天;RI,大肥小果,温灬凉,又骚又欠打;RH,萨鲁法尔战歌,风丶凉;RF,吥搖碧蓮丶,城里放炮;RE,芸墨,屠魔风暴,死鱼非命,琥珀年崋;RC,风陌轻;RB,做你的宝搞;RA,青衣凉惹白霜;Q/,麒麟仔,食人魔魔法師,翊悬;Q+,慧者实乂橙,灬奶茶炖鸡灬,小原",["国王之谷"] = "RJ,月夜可乐;RI,随梦忆潇湘,菲尔琳;RF,丶骨火,江隂丨饅頭;RE,寒铁在上,小憨憨丶;RC,一笑奈何;RB,人离别,萬岁千秋,白驹氵过隙;RA,树鸟熊猫魚,索拉丶织棘者;Q/,一輪美滿,残盾;Q+,极热,尝试切他中路",["金色平原"] = "RJ,丁书生;RH,藏宝图宝藏;RF,佐里昂娜;RE,哈杜伦丶塞隆;RD,我醉君复乐,贝尔晨酿;RB,誰為我停留;RA,庆余,好灬好美哟",["主宰之剑"] = "RJ,錶子与枪丶;RH,Async,叶之湫,天使也无奈,自在行;RG,虞城丶驿;RF,社会你波哥,射誰谁怀芸,月光下的云海,王权,袁九思,用血捍卫荣耀,小荃,天津饭饭,苦孩;RD,教官的第四科;RB,風吹不散长恨,年轻不讲舞德;RA,一岁可萌了;Q/,导演法;Q+,夜尽丶辰曦,快进到退休",["图拉扬"] = "RI,乌拉达瓦里希,李大树",["蜘蛛王国"] = "RI,零伍柒柒",["拉文凯斯"] = "RI,自摸零零漆;Q/,甄美",["黑铁"] = "RI,阿翼,念旧;RG,小老板晴晴;RF,优雅的帅夯比",["熔火之心"] = "RI,小牛强强;RF,穿拖鞋的精灵;RD,断离",["阿克蒙德"] = "RI,鈊睟;RE,五花变形肉;RA,Migo",["血色十字军"] = "RI,桃桃芝士,小小灾变;RH,杜家丶小贝,大哔哥哥;RF,Imfit;RE,叹息的富士山,术起中指丶;RD,Meastoso;RC,没有止痛药水;RB,我是个正经人,表妹丶;RA,达拉崩吧丶,珊瑚丶海,蜡笔海盗,昨日青空;Q/,祟图,社会的榜样,爆炸糖果,席梦来;Q+,机车小迷弟",["???"] = "RI,年华灬流光,帮瑞哥毛板甲,抱抱是只喵;RF,北卡二号;RE,游魂灯丶;RC,战丶小凡",["布兰卡德"] = "RI,姜丝切片;RH,小心肝;RE,迷人又危险丶;RD,喵爪啵奇塔;RC,血色丶阿丽塔,尐尐丶;RB,银涛溜溜,螺丝粉;Q+,欧丿二泉映月",["奥尔加隆"] = "RI,齐格弗里德;RG,幼儿园拳霸",["诺莫瑞根"] = "RI,乖乖酱",["回音山"] = "RI,冲锋你没道理;RH,小術丶;RC,夏风爽,Ellerys",["丽丽（四川）"] = "RI,勃艮第炖牛腩;RF,Yimin,三刀;RE,剑与斜阳,你好钱先生;RD,Yax,月来凤栖山;RA,南部丑锅锅,别闹灬;Q+,飞花轻梦丶",["恶魔之魂"] = "RI,永恒丶传奇",["迦拉克隆"] = "RI,玳瑁之棍;RF,喵嗷咩;RB,空城美雪,白墨谷雨",["格雷迈恩"] = "RI,有感情的杀手;RF,梦中恶魔,只是注定;Q/,落零星",["埃德萨拉"] = "RI,Hugtwelve,记忆终諟丶;RH,游戏的大喵;RG,宇智波奶牛;RE,单吊丶東风;RC,奶油熊起司;RA,丨丶青衫;Q/,骁哥最帅;Q+,灬阿猫灬,丨丶青衫未旧",["阿纳克洛斯"] = "RI,乐事;RE,Nsaids;RD,雷丶浮生若梦;RA,还有土拨鼠",["耳语海岸"] = "RI,秋刀鱼;RG,朱莉娅风歌;RF,长风当歌",["迅捷微风"] = "RI,孤独的海怪;RG,合剂爸爸,宇宙对我歌唱;RC,外面有狗了,草上飞不动;RB,是与非;Q/,章鱼法",["格瑞姆巴托"] = "RI,桃花雨,憨憨德帅;RH,白老师;RF,中島美雪;RE,旺川,哆啦批梦;RB,你枯燥么,东华少阳君,醉酒夢红颜,小鸡球球;Q/,少女映画;Q+,哈啤穿肠过,梦扬天际",["白银之手"] = "RI,梅尔特莉莉絲,苍穹之跃;RH,择林,苍之无极,亿易,惡靈騎士,狼的一逼;RG,Stnyrah,Kaytse,Oeverhopeful,啾啾就是啾啾;RF,一骜,黄山张老师,侠客风行者,亖宇宙队长亖,德妮维雅,逆风花潇,逆风骑行,愁绪万千;RE,小青龙,啾哩个啾,星空天蝎座,芥末味冰淇淋,火槍手追獵者;RD,Xwh,电竞斯坦森,司言,哲哲大憨憨,擎天過雨;RC,埃提耶什,清梦挽依,野人参;RB,琦玉老师灬,伊雪夜,开光大湿丶,一点不自律,阿尔萨喵,童話鎮;RA,雲杨,温岭胡歌,飞驰柚子,南野;Q/,陳喬恩,乱舞乄风行者,Demondark,维灬他,酒樱;Q+,雷德琪,回梦夜影,天空蔚蓝灬,这是女鬼,老王遛狗,清音梵唱,Penumbra,奶一次绿一次",["加兹鲁维"] = "RI,复活的王尼玛;RE,轻井泽",["永恒之井"] = "RI,咬哭橙汁;RH,最初的梦想;RG,丨校长秘书丨;RD,十里桃林",["艾维娜"] = "RI,伊哟喂",["艾森娜"] = "RH,Paletteice",["法拉希姆"] = "RH,十四;Q+,Thatcher,Zarya",["遗忘海岸"] = "RH,星灬耀",["风暴峭壁"] = "RH,二了吧唧",["能源舰"] = "RH,死之骑",["梅尔加尼"] = "RH,何康老鬼;RC,小甲甲丶;Q/,悠悠德",["巴纳扎尔"] = "RH,忆梦",["梦境之树"] = "RH,新欢丶",["雷霆号角"] = "RH,落寞十三哥",["神圣之歌"] = "RH,山水草木",["密林游侠"] = "RG,没仁花生,十项全男,爆到你心跳",["烈焰峰"] = "RG,午夜的银河电台;RD,小碗",["迪瑟洛克"] = "RG,你我的约会",["闪电之刃"] = "RG,尼玛自己人",["狂热之刃"] = "RG,三一;RE,钱多给我花",["影牙要塞"] = "RG,狂徒晓峰;RC,付公子",["壁炉谷"] = "RG,Porsche",["破碎岭"] = "RG,自由的阿昆达;RE,秋喜姐;Q/,堕落的路西法",["燃烧平原"] = "RG,蛋娘;Q+,Danaikz",["火焰之树"] = "RG,愿逐月华",["麦姆"] = "RG,女神丶",["海克泰尔"] = "RG,爱的拳头;RF,耐小九;RE,万亩稻上飞丶;RC,基尔夹卤蛋;RA,旧城半夏,夜丶微凉,灵魂祭司雷尼;Q+,风中一头牛,猜心,心云",["血环"] = "RG,小鸡儿灵鬼",["泰兰德"] = "RF,星曜之刃;RB,熊熊奇妙冒险",["亚雷戈斯"] = "RF,柠檬之夏;Q/,一生有你",["金度"] = "RF,火法;RD,沐北丶半諾殇",["霜之哀伤"] = "RF,祖宗;RD,游学者叮当;RB,丨眰恦丨;Q+,眸中星河似梦,灿烂尐尐,今生为你舔,恰似童话",["暗影之月"] = "RF,黯然缥邈;RB,在水之湄",["阿拉希"] = "RF,加油吖皮卡丘",["黑暗虚空"] = "RF,玛奇玛",["艾露恩"] = "RF,彭小兰;RB,巨侠老德;RA,陆老六",["龙骨平原"] = "RF,求之不德,云端丶;RB,Romeo;Q/,战世,丶黑夜传说",["加基森"] = "RF,拒绝丶;Q+,闹闹爸",["巴瑟拉斯"] = "RE,六眼盱鱼",["夜空之歌[TW]"] = "RE,网瘾治疗者",["阿卡玛"] = "RE,清灬茶",["伊瑟拉"] = "RE,那尔撒斯",["塞拉摩"] = "RE,来个署条;RB,清丶酒",["伊利丹"] = "RE,长短深浅皆知;RA,飞行的老猫",["外域"] = "RE,剑开天门",["世界之树"] = "RE,絮语飘雪;RB,瓦尔姬里",["万色星辰"] = "RE,天堂寒;Q/,威廉萌",["幽暗沼泽"] = "RE,Excaliburs;RD,三千歌一笑醉",["奥特兰克"] = "RE,不正经大叔,仙念丶,花岗岩哥哥,Missflg",["罗曼斯"] = "RE,游穴者丶周浊",["卡拉赞"] = "RE,一叶知秋",["弗塞雷迦"] = "RE,咖啡守护汐汐;RC,康师傅冰红茶",["森金"] = "RD,风之逆襲",["卡德加"] = "RD,烽火得箭矢;RC,一湖心静,洛丹伦二公主",["雷霆之王"] = "RD,暗雨星魂;RB,格雷丶帕斯塔",["库尔提拉斯"] = "RD,村里的爷们",["加尔"] = "RD,奥雷里亚诺;RC,哲学启示录",["芬里斯"] = "RD,玛塔哈里",["通灵学院"] = "RD,夯大锤",["诺森德"] = "RD,哲里",["银月"] = "RC,木牛流马",["提瑞斯法"] = "RC,演员周冬雨",["洛肯"] = "RC,熊壮大猫咪",["托塞德林"] = "RC,小青丶",["爱斯特纳"] = "RC,洛丶天依",["风暴之怒"] = "RC,盛世经典;Q+,似锦年华",["圣火神殿"] = "RC,導演丶我躺哪",["时光之穴"] = "RC,去冰三分糖",["试炼之环"] = "RB,霜之雨彤;Q+,牛将军丶老刘",["荆棘谷"] = "RB,蟹老板",["冰霜之刃"] = "RB,丶铁柱",["灰谷"] = "RB,蹬蹬爹",["扎拉赞恩"] = "RB,妖之骄法",["风行者"] = "RB,隔壁水果店丶",["雷斧堡垒"] = "RB,雷霆扛把子;Q+,七色的魔法使",["玛法里奥"] = "RA,菲奈珂思",["玛瑟里顿"] = "RA,Vitamine",["克洛玛古斯"] = "RA,闪光伯爵",["利刃之拳"] = "RA,马师父;Q/,丶绫波丽",["奥斯里安"] = "RA,双刀就看走",["巫妖之王"] = "Q/,海之间",["索瑞森"] = "Q/,雲中锦書來;Q+,雲影映暈",["玛里苟斯"] = "Q/,艾尔玛娜",["达尔坎"] = "Q/,快乐并忧伤",["远古海滩"] = "Q+,牛啸天",["雏龙之翼"] = "Q+,Kej",["苏塔恩"] = "Q+,月影灬晨星",["阿拉索"] = "Q+,不语笑红尘",["寒冰皇冠"] = "Q+,法力残渣丶"};
local lastDonators = "用脚输出丶-燃烧之刃,跳刀丶跳刀丶-死亡之翼,温灬凉-无尽之海,伊哟喂-艾维娜,讨厌那里不行-鬼雾峰,娜娜的狸猫-死亡之翼,咬哭橙汁-永恒之井,复活的王尼玛-加兹鲁维,大迦楼罗-死亡之翼,呗之诗丶-死亡之翼,大肥小果-无尽之海,抱抱是只喵-???,帅的闹心-阿古斯,念旧-黑铁,奥隐-罗宁,菲尔琳-国王之谷,Tsai-凤凰之神,记忆终諟丶-埃德萨拉,馬咚梅-末日行者,苍穹之跃-白银之手,Betelgeuse-死亡之翼,梅尔特莉莉絲-白银之手,桃花雨-格瑞姆巴托,妳不要玩火-伊森利恩,火之神神乐丶-凤凰之神,孤独的海怪-迅捷微风,秋刀鱼-耳语海岸,乐事-阿纳克洛斯,毛小豆-死亡之翼,Hugtwelve-埃德萨拉,前男友-影之哀伤,有感情的杀手-格雷迈恩,Despredo-凤凰之神,李大树-图拉扬,玳瑁之棍-迦拉克隆,丿小楽丶-凤凰之神,永恒丶传奇-恶魔之魂,帮瑞哥毛板甲-???,随梦忆潇湘-国王之谷,达雷尔的岛-伊森利恩,林友有-影之哀伤,勃艮第炖牛腩-丽丽（四川）,Megoodluck-凤凰之神,冲锋你没道理-回音山,天上谣-死亡之翼,云谷胖胖-贫瘠之地,乖乖酱-诺莫瑞根,北斗晴天-凤凰之神,炙日星河-死亡之翼,大魔王丽丽-诺兹多姆,小熊掌-熊猫酒仙,齐格弗里德-奥尔加隆,小小灾变-血色十字军,姜丝切片-布兰卡德,年华灬流光-???,桃桃芝士-血色十字军,鈊睟-阿克蒙德,丶雪碧泡饭-凤凰之神,小牛强强-熔火之心,阿翼-黑铁,奥蕾莉垭-末日行者,自摸零零漆-拉文凯斯,零伍柒柒-蜘蛛王国,乌拉达瓦里希-图拉扬,錶子与枪丶-主宰之剑,天堂情书-贫瘠之地,丁书生-金色平原,月夜可乐-国王之谷,晚凉天-无尽之海,Wwvv-斩魔者,花映丛祠-安苏,灿烂的花火-罗宁,欧阳奶奶-罗宁,简安-阿古斯,丷天意-冰风岗,Happyholiday-影之哀伤,小阿宝呐-伊森利恩,童真霸霸-罗宁,愤怒小熊-影之哀伤,花泽丿香菜-克尔苏加德,讨厌那里不行-鬼雾峰,九陽-燃烧之刃,打工人之怒-洛丹伦,琉璃白-玛多兰,Scorpionthor-桑德兰,苹果酱-古尔丹,安非他命丶-凤凰之神,天才哞哞-死亡之翼,云笙-希尔瓦娜斯,涅白-冰风岗,Themis-安苏,凌豆腐-月光林地,丶茹比-安苏,菠萝小可颂-伊森利恩,偸吻妳的心-末日行者,不悟兰因-贫瘠之地,萨丽曼-熊猫酒仙,Aceace-逐日者,谁家小娘子-诺兹多姆,賊走运-凤凰之神";
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