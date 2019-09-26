local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,绾风-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["萨格拉斯"] = "KF,洋葱哥",["末日行者"] = "KF,孤盗西风瘦马;KB,伤痕男人勋章;J0,Estatepain;Jv,棒棒鸡丷;Ju,有点皮;Jt,雪胖子丶;Jq,兲亮了;Jn,十万城管;Jj,莽汁儿,一盒老鲜肉;Jh,哆啦妹丶",["斩魔者"] = "KE,转身丶未晚;Jp,花胳膊叔叔乄",["燃烧之刃"] = "KE,光头抠脚大汉,卿夲佳人;KC,北极星的守候;KB,Guee;KA,胖的你嗷嗷叫,狂鲨;J+,妹妹恋爱吗;J8,清风残;J1,正直庸医奶茶,暗影步火车王;Jy,婦科專家丶;Jx,骑蜗牛;Ju,王牌小饼干;Jt,抱住小鱼干,丑真丑,Chimera;Js,Omegar;Jq,雕刻时光丶;Jo,恶魔小糖豆;Jn,秦川丶;Jm,闪开小弟上,离人丶陌生;Jl,蓝雨芯,阡默;Jk,烟飘雨朦胧;Jj,丿阿司匹林丿,三费仆从,燃燒的青春,战神丨炎焱;Ji,炯迥浻囧猫,丰息,華脩;Jh,黑魂丶",["奥尔加隆"] = "KE,小星落;J6,我真不混啊;Jx,卖萌是本能;Jr,蓝澈;Jl,胖胖叮",["海克泰尔"] = "KE,星神者丶猎空;J5,漫威丶;Jx,落小虫;Jw,擎烛;Jl,Choaya",["国王之谷"] = "KE,皎月星魂,抽刀断魂;KD,烬歌;J6,Muyee;J5,Silentlol;J3,白露丶;Jt,醉插美人隂;Jr,夜乄歌;Jo,靐帑澩蠡,特瑞雅,冥姬;Jn,Speegraf,只穿黑丝;Jj,铁面孔目",["奥特兰克"] = "KE,空自凝眸丶;J0,懒人雨果;Jy,愿圣光强抱你;Jn,大大的迪奥毛;Jm,死战的薄之葬;Jl,资管新规",["艾莫莉丝"] = "KD,天秤座的乌鸦",["迦拉克隆"] = "KD,丨湖人老大;J+,墨仙客;J2,青道;Jy,炸鸡薯条;Jo,古都季末弎;Jn,一圣一光一;Jj,熊貓牧師;Ji,冲锋跪丶",["伊森利恩"] = "KD,我不敢过江;KC,打上火花;J8,防火女真可爱;J2,天丶澜丶澜;Jz,老婆紫,茉筱雨;Jy,钢宗窝子,大丁丁小矮仔,二亅细;Ju,我不敢过江丶;Jm,落红灬染素颜;Jk,小小胖咕,职业丶舔狗;Ji,奶爸不搞事",["主宰之剑"] = "KD,奥格的小德;J7,Lockhar;J5,Rmage;J4,永燃火焰,刘莉娜;J3,狂风血舞,灬圣光赦令灬;J0,微微一初夏;Jt,灵性选手灬;Jp,骚等丶抽根烟,光蹄妹妹;Jn,財柛,鑫拾壹,凄凉月光;Jl,小阿咪丶,心系菩提,心怀邪恶;Jk,你好丶再会;Jj,羽落凡辰,吴山酥油饼;Ji,夜丶肥肉;Jh,酒卿",["布兰卡德"] = "KD,凌波喵步;Jv,玄觞丶;Jt,咕咕大顺子;Jp,海老名菜菜;Jn,澜神;Jl,陈伟霆丶;Jk,琴月萤;Jj,大咪变变身;Jh,Bavykonty",["死亡之翼"] = "KD,丶无常;KC,星河,蓝丶非,葡小萄;KB,一梦经年丶,櫹楓;J/,多萝缇娅;J+,暴怒胖可丁,爱臭美的猫丶;J9,鐵哥哥;J8,十里长辞,丶按时吃饭;J7,乔巴不是狗丶;J6,奔灬波尔霸,云朵兒,星辰哥;J5,归来乄狠角色,南梁王,Alcamusa;J4,入云栖;J3,半雨半晴,檀沁,圣疗没有了;J1,四世丶涯,作业写完了嘛,山河影;J0,丷三井,于与玉与鱼;Jz,洛秋凉丶;Jx,入景随风,快不行了奶我,七爵,小陌酱;Jw,边喝水边嘘嘘;Ju,心晴了,战魂之吻,丷十年;Jt,风之长歌,八带鮹,牛德阿隆索斯;Jr,贱贱的熊猫,独享世界,独享壹格世界,Kororinpa;Jq,衝鋒撞破頭,浅风细雨;Jp,风影丶,花小兔子,西红柿牛柳,似杯酒漸濃丶,心头灭却丶;Jo,叶小小丶,归来乄撒迦,懷特丶曼吉,厉害了小母牛,冉早早;Jn,村镇一枝花,躁动小闪亮,奇怪的萝卜,七月沐雪,前世的术;Jm,失落的高个子,小芳儿;Jl,夜皓明,花灵;Jk,夏沫轻风,圣殿幻影,天好热;Jj,小二上三,阿宝丨情儿,杏呀,Traveljunkie;Ji,樊北鱼,妮露殿下丶,王舞雾,风雨飘瑶丶,奈斯凸米球,踏剑醉清风;Jh,孙小颖脆皮儿",["鬼雾峰"] = "KD,舟小鸣仔",["塞拉摩"] = "KD,Ylidanwh;J+,从小就很酷;Jz,妖刀鬼彻;Jr,老白涮肉坊",["???"] = "KD,宛安;J/,雯子雯",["白银之手"] = "KD,片桐镜华,子夜纾怀,血色豪侠;KC,轩辕敬城;KB,兰博挤泥巴;KA,凝眸不为你,长路漫慢,青春越扯越蛋,心中的饿魔;J/,千舆丶千寻;J+,叶小汐;J8,凄美夏末;J7,明曰天情,刘伶醉福酒;J6,无火的余燼;J5,晓晓夏天尒,丶逆行型毛毛;J4,铁血神萨;J2,封雪寒,玖瑛;Jy,哼唧;Jx,古南泉,西瓜味的猫;Jt,橘子馅饼;Js,布莉吉塔;Jr,咕德猫寧;Jq,这一刀叫晚安,鹤命;Jp,艾里克森,苏暮白,卡多雷风行者;Jo,完美之梦,RobbieC,唯恋缉私,丶祝踏楠;Jn,水月凌幽,一只小憨呀;Jm,Remn;Jl,闪耀的苍山,发育良好,微风骑;Jk,张漂亮真美丽,摇摆的俾格米,灵燕眉;Jj,柏柏乓乓,戰灬无情,鸢木;Ji,卡姗德拉,中國丶欧皇,靑楓,康士坦变化球,茅延咹,青袖舞霓裳,水无痕",["凤凰之神"] = "KD,奶斯兔迷秋,奶思兔迷秋,Rainboow;KB,消遣无奈;KA,Vitamilk;J/,冷饭,古城酒巷年少,Gintama;J+,山之阿,丶纸防骑;J9,执刃;J8,温州灬吴彦祖,镇囯神将;J7,一个诗意的名;J6,薰瑶,我贼浪;J5,依克希尔乔恩,乄瑶瑶乄,犯错;J3,冷冰然,黯渊与酒;J2,自闭的皮卡丘;J0,黯渊碧落,洪興十三妹,Blackzeus;Jy,灬尐渔兒丶;Jx,渡影丶,卡布奇诺斯基,柚子的老郭;Jw,Yebaci;Jv,灭战丶者;Ju,知水,一碗蛋炒饭;Jt,奶萌味,有点得儿;Jr,Daylang,小小柯基,丶忘川,鲨鱼灬辣椒,伱也想起舞吗,大聪明灬,糖醋排骨灬;Jq,晨先生,超甜豆浆;Jp,善逸;Jo,可尐白,也许没资圪,林灭灭,一块小石头丶,一块小石头丨,一块小石头丿,简心妍,拉文凯斯领主;Jn,灬红荼亽,独影随风,至高无上德哥,做我的小公主,神罗天征灬;Jm,灬面条,战复那個小德;Jl,我爱大牛眼睛,忧兮,浊酒相思;Jk,妍夏丘豪,古城久巷年少,阳光美少牛;Jj,少司乄秦时命,天青色等烟雨,我的小德呢,欧乄以神之名;Ji,东瓶西镜放,暮小暖,坤平将军,馨月虎啸,馨月雨木石,十殿阎猡;Jh,曲终红颜殁,甜心发射",["罗宁"] = "KD,丶叶不修;J/,兮译;J9,尼古拉斯大白;J6,嗨芒克,凌梦心;Jz,痕星丶;Jw,小智冲钅,丨木頭丨,暴躁鬼畜少女;Jt,阴阳教小甜甜;Js,这是只面包君;Jo,沐沐;Jm,一秒一喵机会;Jl,疾风剑客,丶小吃货,Nsx;Jk,丶狼鸽,聖焃;Ji,丶天機變丶,风无歌,深邃黑暗",["熊猫酒仙"] = "KD,艾泽里特护甲;KC,一个弓的名字;Jx,归去来兮辞;Jv,超爱变身的魔,冬雪覆城;Ju,肚皮反弹伤害;Jt,宿命星尘;Jm,海拉丶;Jl,Telunsuii;Ji,透透,安静的苹果;Jh,貝貝兒",["晴日峰（江苏）"] = "KD,武灵萌主;J/,Szhao;Jz,娜塔莉波特曼",["幽暗沼泽"] = "KC,一头大黑牛",["霜狼"] = "KC,好大一棵树;Jn,米洛克洛泽;Jk,世上最弱,直哥",["格瑞姆巴托"] = "KC,予安丷;KA,榮耀属于联盟;J/,Caffein;J8,别吓到我的猫;J2,酸菜咕;J0,雪舞飘樱,奶油丶小小,芒果真甜;Jx,觉醒吧圣魂;Jw,寒蝉呜泣之时;Jv,一路|凯旋;Jr,苔丝格雷迈恩;Jq,安丶然契,头盔防闷棍,太难得的记忆;Jp,无糖依然可乐;Jo,跪求躺尸别救,Paladyn;Jn,Shintaro,气敷敷小公主;Jm,雪映倾城;Jl,唉木踢;Jj,幽暗星尘,职业大叔;Ji,铁拳凌晓雨,靳益达,大朗起来喝药,血之命令,艾克清光",["贫瘠之地"] = "KC,雨茶;J8,丶孤独的信仰;J4,大波菜;J2,炎黄铁旅;J0,山河兮;Jv,破晓之狮;Ju,東土大唐;Jt,长安百花时,严守一,天罚红莲;Jq,膝盖送你了;Jp,内向初中生;Jo,倾听雪落声丨,油麻大王;Jn,自然灬恩赐,熊大爱吃肉;Jm,烫头大叔丶,猫九丶;Jk,我灬去,四费五杠四,Egjerry;Jj,丨莫斯;Ji,笋尖,欧皇大表哥",["回音山"] = "KC,血影七杀;J/,纷乱丶;J0,僵小蛮;Jy,星黛露;Jm,丨叮叮;Jk,胡继;Ji,艾丽安",["海达希亚"] = "KB,Shiry",["安苏"] = "KB,褚筠;KA,十水磷酸钠;J+,泡泡丨茶壶,丷战撕;J8,枸杞威士忌,夜以青雲;J5,影碎;J4,Theocrac;J3,暗杀即是艺术,骑白石;Jx,批发小闺女;Jw,丧灬彪;Ju,丶橙風破浪;Jt,水果湖湖主;Jr,墨小星丶;Jq,枫雪雪;Jp,俺哥不是将军;Jo,纷纷的情欲,天空不空天,梁山柏住阳台;Ji,戰㐅枫,暴击丷战神;Jh,|矛",["血牙魔王"] = "KB,恶灵死者",["迅捷微风"] = "KA,前男友灬;Jz,壹壹大魔王;Jw,雪灬神;Js,丶卟呐呐;Jk,奇德",["龙骨平原"] = "KA,Foreknow",["永恒之井"] = "KA,九分儿;J+,蓝巨人,飞火流矢;Jm,逆境丶流觞;Jj,涅槃灬一然,丨一然丨,灬一然灬,丷一然丷;Ji,丶奈何归去,大丽丽",["埃德萨拉"] = "J/,牧行云;J6,天堂的暗影;Jo,永恒华尔兹;Jn,盗甜;Jj,弹尽粮绝",["闪电之刃"] = "J/,报之以歌",["桑德兰"] = "J/,瘦头哒;J6,桃之夭夭;Jk,烈酒重阳",["时光之穴"] = "J/,无限弹幕;Ji,微线儿",["伊瑟拉"] = "J+,暗影之怒;Ji,飞来飞去的火",["壁炉谷"] = "J+,郎郎浪;J7,朗朗浪;Ji,群侠喵喵",["莱索恩"] = "J+,Artemisgrace",["诺莫瑞根"] = "J9,血灬月",["暗影迷宫"] = "J9,斗神",["比格沃斯"] = "J9,上九言",["暗影之月"] = "J9,火儛丶;Jm,砂锅大的锤",["黑铁"] = "J9,千山渡;J3,Muxioo;Ju,布偶兔;Jo,未尽;Jn,任然自由自我;Jl,性暴咕丶小张,Asuuna",["影之哀伤"] = "J9,暗夜魔王丿丶;J7,想念念呀丶;J1,丨西门丨;Jw,月神话;Jv,Peasan;Ju,图美秀秀;Jl,阿汤哥;Ji,雪丨乃,镇魂地狱;Jh,摩天大樓",["霍格"] = "J9,阿如汗",["血色十字军"] = "J8,法小师丶;Jw,霜霜姐姐;Ju,幕后导演,就瞅你杂滴;Jq,福泣;Jp,三余无梦生;Jo,灰色视角;Jn,丶大姨媽;Jm,纱月灯,娇羞的阿昆达;Jk,泷韵,祖国人;Jj,子曰无忌;Ji,缘灬難了,断章诗篇,枫雪丶;Jh,徒手割苞皮",["金色平原"] = "J8,艾尔莎星辉,追随圣火的光;J7,摘仙,山河兮;J2,塞兰蒂丝;Jy,無月;Jm,圣光二狗子;Jl,浪漫绅士;Jk,萌萌灬丫;Jj,冲锋向后",["翡翠梦境"] = "J7,大象干蚂蚁;Jt,火柴天堂;Jp,因催斯汀;Jj,契诃夫;Ji,露琪亚",["克洛玛古斯"] = "J7,过把瘾;J0,吹起小风;Jk,泪落成殇",["斯坦索姆"] = "J7,Thanos;Jh,神圣之息",["麦迪文"] = "J7,紫默",["阿尔萨斯"] = "J6,檬心丶;Jv,风骚十一魅",["狂风峭壁"] = "J6,灬弥赛亚灬",["勇士岛"] = "J6,流云雨",["无尽之海"] = "J6,花开丶何人知,夜风恋月光;J5,舞剑媚;J2,以德丶糊人,传统手工艺人;J0,大海的骚女婿;Ju,索达利尔;Jt,阿拉贡丶罗兰;Jp,喵僧丶;Jo,最后尼齐,桀骜文风,由美;Jm,花谢花开漫天;Jl,啸卿男爵;Jk,曲奇大盗;Ji,蜜汁鸡排饭,蚂蚁牙嘿",["阿古斯"] = "J5,吟魂灬;Ju,夜空弃婴;Jt,清凌萱舞;Jr,云丶娜;Jp,乀乖乖肉丶尕;Jo,熊小瑞宝;Jm,卡露娜,诺灬亚;Jk,神圣的羽芒",["冰风岗"] = "J5,饶朕队友狗命;Jv,㸜伊㸜利㸜丹;Jp,童话镇,凋谢之书;Jn,Copere,稳场祖宗",["霜之哀伤"] = "J5,黑崎丶一护",["索瑞森"] = "J5,情绪化",["雷霆之王"] = "J5,风骚欢哥",["泰兰德"] = "J4,希尔薇安;J0,投降输一半;Jq,迪米乌戈斯;Jp,李小楠;Jj,冰瑟琳",["血环"] = "J4,岁月染指追忆;Jt,霍尼摩尔;Jp,七杀格;Jl,诡匕;Jj,丝足少女",["希尔瓦娜斯"] = "J4,东篱灬;Jn,弥赛亚",["阿曼尼"] = "J3,鞠婧祎;Jv,蒋蒋的阿昆达;Jt,你这瓜保熟吗;Jm,夜场红人",["盖斯"] = "J3,眠丶",["梦境之树"] = "J3,丶躲猫猫丶;Js,伊萨博尔",["艾萨拉"] = "J3,酵母艾薇儿",["玛瑟里顿"] = "J2,马库氏",["菲米丝"] = "J2,灬小妖怪灬",["深渊之巢"] = "J2,淰丶雨妢飛",["能源舰"] = "J1,Amystrasza;Jo,洛穆",["萨洛拉丝"] = "J1,晓龙包;Jo,死亡阴影",["黑龙军团"] = "J1,风暴灬之魂",["阿比迪斯"] = "J1,无名情书",["卡拉赞"] = "J0,随变",["石锤"] = "J0,沉默灬玩具;Ji,我最耐揍了",["黑曜石之锋"] = "J0,Cancerlion",["荆棘谷"] = "J0,菠萝咕咾肉",["拉文凯斯"] = "J0,云箫;Jo,老婆说的对;Jj,筱喵了喵呜",["艾苏恩"] = "Jz,翊天;Jm,钱馨馨",["阿迦玛甘"] = "Jy,倾城月色;Jk,Io",["遗忘海岸"] = "Jx,梦随风远;Jk,孤单的宝宝",["哈卡"] = "Jw,Leon",["布鲁塔卢斯"] = "Jw,洛天依",["熔火之心"] = "Jw,凝馨木;Jq,帝陨;Jo,人与兽,皓龙,火焰战皇,山寨奶爸,皇家御姐,魅魔出租,神歧视,凶煞,紫色幽兰,利爪之王,山寨妖王,嗜血傀儡",["加尔"] = "Jw,恒天鬼娃",["格雷迈恩"] = "Jv,Du",["达隆米尔"] = "Ju,心我无极丶邪",["甜水绿洲"] = "Ju,阿博洛迪忒",["月光林地"] = "Ju,小囧丶",["凯尔萨斯"] = "Ju,月凪;Jl,兔子守护者",["克尔苏加德"] = "Ju,墨染寒霜;Jp,六六小活宝;Jo,颤栗剧毒之弩;Jh,修牧秋",["丽丽（四川）"] = "Ju,七德子;Jn,烟频话少;Jm,牛子哥;Jl,冰似无情,Garenmienvi;Jk,飞升修仙;Ji,鲤鱼王的绝技",["审判"] = "Ju,残酷恐怖",["海加尔"] = "Jt,北京大耳帖子",["影牙要塞"] = "Jt,神灵净明丶玩",["阿纳克洛斯"] = "Jt,Ironheart;Js,Mccree",["烈焰峰"] = "Jt,完美逗笔;Jj,Yukee",["冰霜之刃"] = "Js,呆呆兽丶;Jr,黄三岁丶;Jn,艾文丶帕拉丁;Jl,Tortoiser",["安格博达"] = "Jr,Ecer,飞翔吧叫兽,麦克美",["石爪峰"] = "Jr,静止时光",["加基森"] = "Jr,小西;Jo,古道邊麥爺灬;Jl,篱巍",["血吼"] = "Jr,歌瑞尔",["亚雷戈斯"] = "Jr,Rascal;Ji,燕千月",["屠魔山谷"] = "Jr,其实歧视骑士;Jq,黑玫瑰",["耳语海岸"] = "Jq,核电皮卡丘;Jj,迦南叶",["骨火"] = "Jq,云鬼|嘼犬",["莫格莱尼"] = "Jq,魔兽再少年",["雏龙之翼"] = "Jq,安然",["哈兰"] = "Jq,智沐沐",["火喉"] = "Jq,暮然回首丶",["千针石林"] = "Jp,怎么哪都有你",["弗塞雷迦"] = "Jp,血色武魂;Jh,陌小沫",["朵丹尼尔"] = "Jp,婫丶婫;Ji,张耀扬",["扎拉赞恩"] = "Jp,流星蝴蝶小箭;Jo,废材",["末日祷告祭坛"] = "Jp,Locketaaog",["阿克蒙德"] = "Jp,烈火老猪",["菲拉斯"] = "Jo,奔跑的烤包子",["萨尔"] = "Jo,喜之郎",["卡扎克"] = "Jo,月星寒",["灰谷"] = "Jo,海蓝无心",["万色星辰"] = "Jn,米粉儿",["阿拉索"] = "Jn,Ironshield",["战歌"] = "Jn,风暴牛",["耐普图隆"] = "Jn,晚睡长皱纹",["帕奇维克"] = "Jn,麦兹多克",["山丘之王"] = "Jn,火舞浅瞳",["火烟之谷"] = "Jn,伱猜猜是谁",["黑暗之门"] = "Jm,神级的朗朗",["埃苏雷格"] = "Jm,痴汉",["燃烧平原"] = "Jm,复生给了逼;Ji,敎父",["破碎岭"] = "Jm,安兹丶乌尔恭",["激流之傲"] = "Jl,獠刹",["达尔坎"] = "Jl,神勇牛霸",["熵魔"] = "Jl,玖慕雅黛",["刺骨利刃"] = "Jl,谨守青春;Ji,南鸢丨离梦",["火焰之树"] = "Jl,贼王",["巨龙之吼"] = "Jl,万小萌;Ji,灬橙橙灬",["奥达曼"] = "Jl,蚩尤",["洛萨"] = "Jk,寒霜战神",["戈提克"] = "Jk,Myloveyue",["戈古纳斯"] = "Jk,我又来了啊",["狂热之刃"] = "Jk,靖主任;Jj,吃多了不消化",["密林游侠"] = "Jk,Livio;Jh,请叫我战爹",["地狱之石"] = "Jj,糊不糊丶",["织亡者"] = "Jj,歆丶歆",["死亡熔炉"] = "Jj,格乌恩",["天谴之门"] = "Jj,黑暗小法",["塞拉赞恩"] = "Jj,冧檬茶",["苏塔恩"] = "Jj,光的声音",["丹莫德"] = "Jj,安雨珊;Jh,叫我绅士",["寒冰皇冠"] = "Jj,丶帕露露",["洛肯"] = "Jj,龙漳清",["布莱克摩"] = "Jj,妖魂",["安东尼达斯"] = "Jj,挚丶爱",["图拉扬"] = "Jj,羅夏",["生态船"] = "Jj,拇指",["远古海滩"] = "Ji,花与梦的流星",["玛里苟斯"] = "Ji,上帝之猎",["诺兹多姆"] = "Ji,苍穹之光薇恩",["伊利丹"] = "Ji,一朵小蘑菇",["梅尔加尼"] = "Ji,浪猫",["古尔丹"] = "Ji,叶雷达",["巴瑟拉斯"] = "Ji,親爱的,钢铁直男",["雷霆之怒"] = "Ji,神经兮兮之猫",["通灵学院"] = "Ji,霜瞳灬小劣人",["艾露恩"] = "Ji,尛丷法",["奥妮克希亚"] = "Jh,细雨丶丶"};
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