local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["黑铁"] = "Su,裕华;Sr,哥特式华尔滋;Si,时代变了,丶浊酒恋红尘,呜哇丶呜哇;Sh,鸽后",["罗宁"] = "Su,心欲静止;Sr,陸老师丶,剑雪封喉;Sn,星宿;Sl,月之光芒;Sk,臻果酱,Asia;Sj,瓜皮提督,术姑娘;Si,瓜皮皮,多了个利,偷零食的喵,把你送回太空;Sh,Magicskyfire,三泽大地;Sg,大典太光世;Sf,艾尔娜星光;Se,一百喝可乐;SW,国服第一骚法;SU,遗忘泪滴,Panacea;SS,开打;SR,Buzzkill;SQ,狂毛,佩罗罗奇诺丶",["遗忘海岸"] = "Su,沅芷澧兰;Sp,乔治巴顿;Sm,美狂乱;Sl,格兰蒂娅,简约风格;Sh,欧品",["永恒之井"] = "St,雪饮狂刀;Sk,宇智波丶大星;SU,一页书;SS,若如雲心",["国王之谷"] = "St,Smileddevil;Ss,終極閃光丶;So,稤人;Sl,黑芝麻胖店长;Sk,柒月拾柒,刘不亏,浪漫氵紫罗兰,赫潘丝;Sj,丶碎碎冰丶,玻璃囚牢;Sh,做入留一线;Sd,小毛贼丁丁;SS,军痞壮熊;SR,慕思蛋糕",["死亡之翼"] = "St,Mingabc,神的丨洗礼,刀口滴泪如虹;Ss,丨乐逍遥丶,合金子弹头,秋黛里,秋黛里灬;Sr,基尔常;Sp,一休大宗师;Sn,热舞吧我的爱,猎户一号,迷糊睡着了,晓公子;Sl,浮想聯翩,丷小眼迷人丷,机智的灵魂兽,小板寸;Sk,天真無鞋丶,安妮菲娅,莫莫大魔王,夜雨聲煩,乄璃洛,小香奈奈,抹茶星冰乐丶,苏忘洲,暴躁小叮当;Sj,小竹熊丶,一念成法,殊茗,Bloodssoul,訡风射月,秋小枫,筱枼丶;Sh,碧咸不帅,面包先森;Sg,奈斯凸迷球;Sf,Return;Se,陈以墨;Sd,物欲;Sc,Willett;SW,小熊熊暴凶;SV,恶魔的微笑;SU,一劍丨御风雷,刘大篮子;ST,丿蛋灬蛋,Olala;SS,猫粮,你闺蜜咧;SR,林月茹丶,筱萌喵;SQ,丷怜香丷;SP,七星鎏虹",["罗曼斯"] = "St,风吹麦浪",["烈焰荆棘"] = "St,古彦祖",["凤凰之神"] = "St,刀口滴泪如虹;Ss,春夏秋昸,蒾鍸丶餹餹;Sr,無空,伊比璐玖,重庆老山城,七月之祭;Sq,倔强嘛,花花的呗呗;So,巴豆配黄芩;Sn,李雪莲,小猪猪佩琦;Sm,嘶吟渡鸦丶,丶尒掱通荭,清风入酒,姨妈外漏,湖中的少女,无名之夏;Sl,绿豆布丁,战肾;Sk,啾咪丶喵团子,钱慢慢,擂神老火锅,最强大宝,欧剃大魔王;Sj,周慧敏丶;Si,Duwurogue,聪明怒角,双子丶猎爹,小柯同学,丶月轩,南栀初见丶,天空的引路人;Sh,浅晴丶,就想怼一炮,就想怼一怼,可莉辣舞,园上矛依未,爱美特赛尔克,丶莱蒙;Sg,地獄特工;Sf,壳壳超会玩,牛三斤;Se,髙圆圆;Sd,湘烟;Sb,矜持,灵魂兽医;Sa,墨霄丶;SW,吕桂花,我为部落狂;SV,雯雯灬;SQ,麻辣丶牛蹄筋,枕上诗书;SP,裤头里拉风,胖熊猫会武功,一抹天晴",["迅捷微风"] = "St,丶婲爺,秒伤不过万;Sk,泽渡真琴,被遗忘的大叔;Sj,霍乱爱情,瞧瞧德行;Si,猫猫皮;Se,零度射击;Sa,啊阿啊阿,啊阿啊啊",["达尔坎"] = "St,滚筒洗衣机",["血色十字军"] = "St,Valaraukar,Avengers;Sp,纯阳;So,Dianaspence;Sm,混乱之魂,Miraclé,急性发钱寒;Sl,折纸咕角,奉天承運,Samuraiheart,院长大人丶;Sk,愿得一人心,七秒钟记忆,回復術士,海鲜可爱多,海鲜大杂烩;Sj,超级咔咔罗特;Sh,绘玩;Sg,怂怂的小呆呆;Sf,快乐的大脚,最爱吃橙子;Sc,凤梨蓝莓;SV,一直很任性,骑猪追火箭丶;ST,疫病之吻;SQ,Desitiny;SP,尘曦光枫",["白银之手"] = "St,怒风乄之魂;Ss,萌的丫皮,如笙;Sp,Sancarlos;So,氤氲圣言,蓝浅黛浓,咪咪眼刑天;Sn,只想看风景呀;Sm,Connaissance,夜惜白;Sl,阿米达居,鸦榆,凤羽箭影,Julygrace,飞跃小水坑;Sk,邪道丸,来日不相见,三生缘起,太懒德丶语疯,魔力丶宝贝,Lietenantcat,鸾鳳和鳴,奥兰納的拥抱,瀦児飛飛丶,円城咲耶,肖恩王,萝莉恐,马大骚;Sj,弦雨,恰饭了没,爱买不买提;Si,黎明黑暗使者,格雷迈狼,宁丶風,绿油油的飞飞,丶无情哈拉少,思遠;Sh,月怒语风,卝断水流卝,碧野仙踪,天边的小白鹤,雷强,漓焰莱薇,杺火;Se,优雅的脏鬼,卡丝莲娜;Sd,王宇光的爷爷,大风儿;Sc,我想看风景呀,乌瑟尔宁;Sb,路上有我;Sa,纯爱戰神,卑微小火法;SR,绯红的樱桃梗;SQ,暗夜星之矢,逆臣贼子;SP,宁風,漫行猫,牧过不留人",["伊森利恩"] = "Ss,动物森友;Sp,丨深夜去打猎;So,星月猫;Sn,化风而去;Sm,背上小书包,一泽大魔王;Sl,Steelstorm,喵了个咪呦,暴走的骚肉肉,术然,王彧;Sk,注册电疗师,空之白练,戰丶狂,Assasination;Si,细雨丶丶,不要辣子,流枔丶,就是修不热;Sg,我找人打你;Se,叶河图;SR,暗影之境丶纞;SQ,灬雷鸣",["布兰卡德"] = "Ss,秋業,椰树椰汁,大椅人;Sp,死傲娇;Sn,大漠飘雪;Sm,Cci;Sl,元素周期律;Sk,看看人家,部落潴,联盟狗,法力灵动,现身说法,猫咕彡色,阿鲁卡多,木旁木旁;Sj,锈蚀的盾牌,子夜灬;Si,Nohkyuo,念无丶;Sh,烟雨难逃;Sf,真影至闇;Sd,山豆玩魔獸",["冰风岗"] = "Ss,丶须臾,夢桜;Sq,萌德来了,啊豆;So,Aming;Sn,君心似我心;Sl,卷毛;Sk,小箭魔,Xxnanqvq;Si,耶子汁;Sh,悠悠丶淺語,朝霞,黛雪丶;Se,Highmat,马宝宝丶;Sb,绯绯;SQ,弎少",["格瑞姆巴托"] = "Ss,艾露丶菲露特,Arcanemaster;Sr,丨老杨丨;Sp,嘿鳗鱼儿;Sm,橙子转圈圈;Sl,允初丷;Sk,为所欲为小萨,西方西方北,花开花落无数,牛影风,怕孤厌闹灬燚;Si,隔壁狐狸;Sh,玛塔丶索萨;Sd,沐若飒;Sc,白银丶奥格,糖门掌门人;Sb,小恶魔丶雯,是妳转身路过;Sa,咒炎丶怨曲;SV,阿雯丶;ST,万般变幻由心;SS,熊猫咕奶奶;SR,夏晨晨",["恶魔之魂"] = "Ss,淋江仙;Sk,心情看天气;Sd,盐酸哌替啶",["奥尔加隆"] = "Ss,裤裤狄奥里多;SW,叶之轩",["伊莫塔尔"] = "Ss,拙拳笨腿;Sk,剑锋天下",["森金"] = "Ss,贾斯帕爱吃鱼",["安苏"] = "Ss,早坂银时;Sr,扇子的夏天;Sq,长安夜未央,温笑的阳光;Sm,我想吃酱大骨;Sk,意气风发,砂糖蜜橘,曼達洛人;Si,西西里多,往昔红颜;Sd,研究本质;Sc,丨干饭王丨;SS,脆脆鲨威化;SP,福星凸肥圆",["回音山"] = "Ss,一天一次;Sq,长寿不喝水;So,在下赵曰天丶;Sj,笛子魔童;Sh,魁雯,星夜乄小狗,真劍胜负;SW,Zzhh;SU,性格变态丶",["海克泰尔"] = "Sr,北海怪兽;Sl,神棍牛;Sk,Balder,Tfboynorth,裹屍布;Sj,叄脚型;SV,桔子味丶馒头;SU,罐罐",["伊利丹"] = "Sr,你瞅我嘎哈;Sk,Agony;SR,小妞向前冲",["末日行者"] = "Sr,天下山河海,祈夏;Sk,六院长,吉姆院长萨玛,朕要夯昊,湖南小超人;Si,乐桃桃;Sf,千俞;Se,麦小乐丶;SS,彼岸行僧;SQ,牛油果夹馍",["影之哀伤"] = "Sr,Skriniar;Sl,麻酱丶,酸菜咕;Sk,倒霉的二狗,Zxouly,北欧冻冻,君莫丶笑,晚安卡特琳娜,咕咕有德;Sj,竖锯,菊之哀傷,列奥德锣,木业白牙;Si,冻结灬寂寞,Sinanju,流浪的红舞鞋,四神海鲜包;Sh,心有小术灬,黑暗教長;Se,简小胖,丶没肉没输出;Sa,水土木月;SW,愤怒的子弹;SV,阿奶的激活;SU,哀伤之烬;ST,不会起門吖,振翅引发海啸;SQ,陈哈尔滨啤酒",["玛维·影歌"] = "Sr,武松他大哥",["无尽之海"] = "Sr,李小琴;Sp,戰闘;Sn,夏至风吹旦旦;Sm,笑談人泩;Sl,希米露丶;Sk,今晚不能熬夜,马哥啊,我不是挨木涕,来都来咯,花梨影木,熟睡的土拨鼠,渐空,Tzjjzt;Sj,铜镜映无邪;Sh,Spyair,非灬全职先生,野兽不再凶猛;Sf,丶小草莓;Sd,七月琴风丶;Sb,漫步游走;SW,莫甘那,颜凉;SS,风北离",["格雷迈恩"] = "Sr,乾坤一掷;Sn,哈雷大叔",["霜狼"] = "Sr,冰障;Sh,全蛋",["燃烧之刃"] = "Sq,相声演员琪琪;Sm,烈焰馒头,苍蓝星丶;Sl,Pdminister,饼干酥酥丶;Sk,喝茶,狐小纤,慕无名,圣疗,半只兎子,笑容渐渐缺德,我看看就好,枭徳丶;Sj,乄落墨丶;Si,紫氣丨東來,冲阵,呆萝卜毛毛,圣光术是什么;Sh,守序善良,黑暗咒师;Se,一枝婲丶,一个小徳;Sc,林依依,Tlk;SV,臻蓝,梦中恶魔;SU,深林见鹿;ST,Kpistols;SS,梓喵酱;SR,爆炸的宝宝坚;SP,白雲苍狗丶,將灬進酒",["熊猫酒仙"] = "Sq,非洲某酋长;Sp,Planys;So,Po;Sm,娜奥米丶月箭;Sl,Dearzed;Sk,纸婚,芝麻儿;Sj,瑞翔;Sh,巴德纳尔,素年祭语,骑个龙多强;Se,Kobbe;Sb,再看把你喝掉,饿了吗;SR,糍饭团子,谨言;SQ,追光语者,墨一火,远去的风景;SP,肥仔风暴烈酒",["主宰之剑"] = "Sq,谦豫,Aalizzwell;Sp,德财兼貝;So,无归无往;Sm,小蛇儿,麒麟之火;Sl,噢嚯,Gexiuzi,依瑟思;Sk,彪猎,圣光大礼炮,杏花儿,梦里春秋度;Sj,健康太平街;Si,多了个利;Sh,余地;Sf,初八丶,黛尓萌德;Se,执卿,丶光之子丶;Sd,翎丨翊;SV,芙列雅,大狗熊;SU,掌中萌虎丷;SS,游来游去的猫;SR,懿橙;SQ,集火那个戰士;SP,貝优妮塔",["埃德萨拉"] = "Sq,流星蝴蝶剑,霜天雪地,做人间怪物;So,药水大师;Sm,林涔;Sl,丶抽真空,钢铁部落;Sk,布拉歌,娇花碎钞击;Sj,节奏大师啊翔,不丶舒服;Sd,桃溪春野;SV,Occoc",["冰霜之刃"] = "Sq,鬽灵;Sk,Mepoe;Si,小油菜花;Sh,太平公主;ST,暗夜丶绮玉",["熔火之心"] = "Sq,Nicemaker;Sk,小石哈;Si,海豹要晒惹",["月神殿"] = "Sq,真相是假",["羽月"] = "Sp,鬼灵若雪",["风暴峭壁"] = "Sp,蓝莲花",["暗影之月"] = "Sp,小蹦豆;Sn,筱哉子儿;Sf,行成于思",["金色平原"] = "Sp,萨提;Sl,冽风,乌合之众;Sh,秋的迷藏;Sf,最爱牛仔哥;Sa,埃尔南多;SU,古达老师;ST,残忍的软泥兔;SP,俗了清风",["黑手军团"] = "Sp,牛奶秋刀鱼",["克洛玛古斯"] = "Sp,牧牧;Se,真的汉子",["霜之哀伤"] = "Sp,Nagisalight;Sm,鹰眼霍克艾;Sk,夜羽丶残殇;Sj,清音圣咏;Si,阳光咕咕,流氓与萧邦;Sh,空山月明;Sc,奶油饼干魔王",["洛丹伦"] = "So,小番茄洋柿子;Sl,别今朝;Sk,呼呼喝喝,丅病毒;Si,红烧蹄子",["迦拉克隆"] = "So,卡莉达丶邪月;Sl,我超勇的丶,吾妖王,非法盗猎者;Sk,汹汹小德;Sj,信了邪;Sg,齐佩甲;Se,天真丶珈百璃;SS,Ayasy",["埃克索图斯"] = "Sn,烈风",["索瑞森"] = "Sn,小柯同学;Sk,拉文霍德,名侦探岳岳;SR,丶绫波丽",["试炼之环"] = "Sn,南风丷知我意;Sk,别歧视我很丑;Si,南风知我意丷;SV,南风知我意丶",["克尔苏加德"] = "Sn,伊斯塔战灵丶;Sl,玛格汉的秋天,倏忽;Sk,小狗宝,丨剑来丨,美年达丶;Sh,秦叔宝;Sf,把你肚皮打穿;Sd,丶天师傅",["风行者"] = "Sn,艾小米",["狂热之刃"] = "Sn,随风而誓;Sj,燃烧殆尽",["壁炉谷"] = "Sn,德德大天才;Sk,库茉,正山小种",["破碎岭"] = "Sn,我爱扬扬一号;Sl,光与影之战;Se,烧刀子",["洛肯"] = "Sn,馒头小兄弟;Sl,点不着的回忆",["巫妖之王"] = "Sn,油腻的师姐",["战歌"] = "Sn,里维阿克曼;Sd,胖子丶骑士",["甜水绿洲"] = "Sn,Dizhu;Sk,基地高射炮",["巨龙之吼"] = "Sn,缘分已定吗;SQ,锝彩",["桑德兰"] = "Sn,拂曉神剑,送葬;Sk,毛蛋蛋球;SR,巭熊熊",["贫瘠之地"] = "Sn,实在太无聊了;Sm,蓝色灬经典;Sl,白发悲红颜;Sk,铁丶山,二狗子好水,盒饭会变身,盒饭加个蛋,川贝灬枇杷膏;Si,魔姬魅姬,东風破,猫叔不高兴;Sa,丶润物细无声;SW,明月别枝;SR,丶丿残影",["黑锋哨站"] = "Sm,米办法",["???"] = "Sm,香蕉;Sl,十六岁油腻,读书不如杀猪;Sk,驯龙的正小义,冰封丶杀戮,Felixfly",["范达尔鹿盔"] = "Sm,Xusihai",["诺兹多姆"] = "Sm,牛麻子;Sk,梦中的狸猫,路人灬乙;Sh,点小妹吃嘎嘎;SP,带朱狂粉四号",["玛洛加尔"] = "Sm,佐仓绫音丶",["阿拉索"] = "Sm,凤舞青竹",["寒冰皇冠"] = "Sm,空白的夜;Sj,风中的彼此",["蜘蛛王国"] = "Sm,Leopp;Sl,进击的沙曼;Sk,亡者降临;Sc,Ckcraft",["丹莫德"] = "Sl,天竺兰影",["神圣之歌"] = "Sl,神惃,盐蝙蝠,疾风点破",["雏龙之翼"] = "Sl,右手很温暖",["鲜血熔炉"] = "Sl,夜昊",["苏塔恩"] = "Sl,白小九,圣光锤锤酱",["红云台地"] = "Sl,丝黛林苟萨;Sk,橘子皮皮虾",["幽暗沼泽"] = "Sl,知北游灬柠真;Sk,制裁",["麦姆"] = "Sl,萧萧下士",["阿尔萨斯"] = "Sl,克克的小甜心",["希尔瓦娜斯"] = "Sl,东篱丶;Sg,夜隱月羙",["天空之墙"] = "Sk,影丶夙尘,蒂亚丽丝",["奥达曼"] = "Sk,时无瑕",["摩摩尔"] = "Sk,甜甜的楠楠酱",["安其拉"] = "Sk,昕昕",["闪电之刃"] = "Sk,工藤龙一",["银松森林"] = "Sk,穷兵灬黩武;Se,巨肉夹馍",["拉文霍德"] = "Sk,暖风",["索拉丁"] = "Sk,楚天歌",["奥杜尔"] = "Sk,幸福的棉被",["外域"] = "Sk,枪兵滚毒暴",["月光林地"] = "Sk,扎尔杜姆",["塞拉摩"] = "Sk,美萝莉郭德纲;Si,芳心纵火贼",["火羽山"] = "Sk,啵灬妞",["阿古斯"] = "Sk,乱刃斩;Si,不説;Sd,汉堡王;SW,余生丫丫",["玛里苟斯"] = "Sk,筋肉小奶咕",["梦境之树"] = "Sk,续杯咖啡",["燃烧军团"] = "Sk,卡扎库斯,菠萝菠罗",["风暴之鳞"] = "Sk,舞王吃太少",["玛法里奥"] = "Sk,提里奥丶丁弗",["万色星辰"] = "Sk,危险流浪者;Sj,Zoc",["生态船"] = "Sk,炎雪千寻",["翡翠梦境"] = "Sk,靓泽",["奥拉基尔"] = "Sk,女子女古女良",["丽丽（四川）"] = "Sk,牛春花;SS,比特币升值器;SQ,铁甲小宝丶;SP,打不过就虚弱",["夏维安"] = "Sj,孤心冷雨",["黄金之路"] = "Sj,Alvitr;Sh,爱恨情仇",["艾露恩"] = "Sj,不续前缘;ST,李风",["地狱之石"] = "Sj,落雪飘凌;Si,卤蛋超人",["艾维娜"] = "Sj,燃烬之尘;Sb,幸运女神合体",["风暴之眼"] = "Sj,风影白眼",["黑翼之巢"] = "Sj,笑傲江湖",["萨菲隆"] = "Sj,木夏树",["燃烧平原"] = "Si,紗迦",["达纳斯"] = "Si,佟丽娅",["萨尔"] = "Si,橘里大魔王;Sa,達芙妮",["艾欧娜尔"] = "Si,阿巴瑟",["加基森"] = "Si,咕咕吃火锅,布道师",["诺莫瑞根"] = "Si,Everyoung",["晴日峰（江苏）"] = "Si,红莲华;Sh,伊吹小风",["暗影议会"] = "Si,双色猫瞳",["普瑞斯托"] = "Si,月影云际",["雷斧堡垒"] = "Si,北海无冰",["诺森德"] = "Si,神的姐夫",["梅尔加尼"] = "Si,正新鸡排",["基尔罗格"] = "Si,深藏身与名",["卡德加"] = "Si,再见灬苏菲丝;Se,草莓卓玛",["守护之剑"] = "Sh,熊贰佰",["银月"] = "Sh,胖之煞",["亚雷戈斯"] = "Sh,大水牛猎;ST,摩挲影魅",["艾萨拉"] = "Sh,猫车,花天月地",["鬼雾峰"] = "Sh,Playerberilo;SS,格洛古",["提尔之手"] = "Sh,Fornaini",["提瑞斯法"] = "Sh,布洛克斯",["加里索斯"] = "Sh,杏加橙加蜜桃",["血吼"] = "Sh,绚烂殺戮",["黑暗虚空"] = "Sh,夜雨醉星辰丶",["军团要塞"] = "Sf,提里奥佛丁",["拉格纳罗斯"] = "Sf,你们缺不缺德",["伊瑟拉"] = "Sc,桃玑",["哈兰"] = "Sc,沫沫智",["奥斯里安"] = "Sc,和谐当道",["麦迪文"] = "Sb,小尼豆",["利刃之拳"] = "Sa,灬绿豆灬;ST,特战队长",["龙骨平原"] = "Sa,绝对双刃",["火焰之树"] = "SW,格子的夏天;SV,魔兽胃必治",["杜隆坦"] = "SW,暗香倾城",["玛瑟里顿"] = "SU,風之天際",["烈焰峰"] = "SS,Artemin",["暗影迷宫"] = "SS,百年好合",["奥特兰克"] = "SR,Possession",["古尔丹"] = "SR,典狱长",["阿纳克洛斯"] = "SQ,雷霆之怒風",["太阳之井"] = "SQ,圣屠",["蓝龙军团"] = "SP,贝贝泰迪",["戈提克"] = "SP,毛泡泡",["泰兰德"] = "SP,来二两"};
local lastDonators = "Miraclé-血色十字军,凤舞青竹-阿拉索,清风入酒-凤凰之神,佐仓绫音丶-玛洛加尔,蓝色灬经典-贫瘠之地,麒麟之火-主宰之剑,我想吃酱大骨-安苏,娜奥米丶月箭-熊猫酒仙,牛麻子-诺兹多姆,Connaissance-白银之手,Xusihai-范达尔鹿盔,橙子转圈圈-格瑞姆巴托,鹰眼霍克艾-霜之哀伤,Cci-布兰卡德,混乱之魂-血色十字军,小蛇儿-主宰之剑,香蕉-???,林涔-埃德萨拉,背上小书包-伊森利恩,丶尒掱通荭-凤凰之神,笑談人泩-无尽之海,美狂乱-遗忘海岸,嘶吟渡鸦丶-凤凰之神,米办法-黑锋哨站,烈焰馒头-燃烧之刃,实在太无聊了-贫瘠之地,送葬-桑德兰,拂曉神剑-桑德兰,哈雷大叔-格雷迈恩,晓公子-死亡之翼,迷糊睡着了-死亡之翼,缘分已定吗-巨龙之吼,Dizhu-甜水绿洲,里维阿克曼-战歌,小猪猪佩琦-凤凰之神,油腻的师姐-巫妖之王,馒头小兄弟-洛肯,星宿-罗宁,我爱扬扬一号-破碎岭,李雪莲-凤凰之神,夏至风吹旦旦-无尽之海,大漠飘雪-布兰卡德,猎户一号-死亡之翼,德德大天才-壁炉谷,随风而誓-狂热之刃,艾小米-风行者,热舞吧我的爱-死亡之翼,伊斯塔战灵丶-克尔苏加德,君心似我心-冰风岗,只想看风景呀-白银之手,南风丷知我意-试炼之环,小柯同学-索瑞森,筱哉子儿-暗影之月,烈风-埃克索图斯,化风而去-伊森利恩,在下赵曰天丶-回音山,卡莉达丶邪月-迦拉克隆,小番茄洋柿子-洛丹伦,药水大师-埃德萨拉,咪咪眼刑天-白银之手,星月猫-伊森利恩,蓝浅黛浓-白银之手,氤氲圣言-白银之手,无归无往-主宰之剑,稤人-国王之谷,Aming-冰风岗,巴豆配黄芩-凤凰之神,Po-熊猫酒仙,Dianaspence-血色十字军,Nagisalight-霜之哀伤,牧牧-克洛玛古斯,Sancarlos-白银之手,牛奶秋刀鱼-黑手军团,萨提-金色平原,小蹦豆-暗影之月,一休大宗师-死亡之翼,Planys-熊猫酒仙,乔治巴顿-遗忘海岸,死傲娇-布兰卡德,嘿鳗鱼儿-格瑞姆巴托,丨深夜去打猎-伊森利恩,戰闘-无尽之海,蓝莲花-风暴峭壁,鬼灵若雪-羽月,纯阳-血色十字军,德财兼貝-主宰之剑,真相是假-月神殿,Nicemaker-熔火之心,花花的呗呗-凤凰之神,鬽灵-冰霜之刃,温笑的阳光-安苏,Aalizzwell-主宰之剑,啊豆-冰风岗,长安夜未央-安苏,做人间怪物-埃德萨拉,霜天雪地-埃德萨拉,流星蝴蝶剑-埃德萨拉,倔强嘛-凤凰之神,谦豫-主宰之剑,非洲某酋长-熊猫酒仙,相声演员琪琪-燃烧之刃,萌德来了-冰风岗,长寿不喝水-回音山,冰障-霜狼,祈夏-末日行者,乾坤一掷-格雷迈恩,李小琴-无尽之海,剑雪封喉-罗宁,基尔常-死亡之翼,哥特式华尔滋-黑铁,武松他大哥-玛维·影歌,陸老师丶-罗宁,Skriniar-影之哀伤,七月之祭-凤凰之神,丨老杨丨-格瑞姆巴托,重庆老山城-凤凰之神,天下山河海-末日行者,伊比璐玖-凤凰之神,你瞅我嘎哈-伊利丹,北海怪兽-海克泰尔,扇子的夏天-安苏,無空-凤凰之神,如笙-白银之手,一天一次-回音山,大椅人-布兰卡德,秋黛里灬-死亡之翼,秋黛里-死亡之翼,早坂银时-安苏,蒾鍸丶餹餹-凤凰之神,Arcanemaster-格瑞姆巴托,贾斯帕爱吃鱼-森金,拙拳笨腿-伊莫塔尔,萌的丫皮-白银之手,合金子弹头-死亡之翼,裤裤狄奥里多-奥尔加隆,椰树椰汁-布兰卡德,淋江仙-恶魔之魂,艾露丶菲露特-格瑞姆巴托,夢桜-冰风岗,春夏秋昸-凤凰之神,丶须臾-冰风岗,秋業-布兰卡德,丨乐逍遥丶-死亡之翼,終極閃光丶-国王之谷,动物森友-伊森利恩,秒伤不过万-迅捷微风,怒风乄之魂-白银之手,Avengers-血色十字军,Valaraukar-血色十字军,滚筒洗衣机-达尔坎,丶婲爺-迅捷微风,刀口滴泪如虹-死亡之翼,刀口滴泪如虹-凤凰之神,古彦祖-烈焰荆棘,神的丨洗礼-死亡之翼,风吹麦浪-罗曼斯,Mingabc-死亡之翼,Smileddevil-国王之谷,雪饮狂刀-永恒之井,沅芷澧兰-遗忘海岸,心欲静止-罗宁,裕华-黑铁";
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