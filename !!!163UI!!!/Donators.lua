local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,海潮之声-白银之手,枪炮丶玫瑰-菲拉斯,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔";
local recentDonators = {["金色平原"] = "Ef,焦博,游学者清风,真情不露;Ec,吉黑德的運氣;Eb,银月城少年,上官淼淼;EZ,虚空本源",["格瑞姆巴托"] = "Ef,秦楚如此悲伤,Sleader;Ee,慢递邮戳,音净丶,神猎,加里维克斯灬,王大車,娱乐格外;Ed,Namiaon,小杰,帅气的猫师傅;Ec,乖哈弗洛,萌萌的轩轩,可乐丶梆梆熊,佑掱灬畵懿,牛儿嘿嘿;Eb,红魔爆炎使丶,慕雅丶,丨花花灬牛,|小菜菜|,月夜丨微凉,训练场机器人,乌鸦先生,尨緢丶;Ea,Yuudachi;EZ,总在下雨天,卡尔佛兰茨,一之濑花名,伊纹;EY,哭晕在天台,年轻的皮皮魔;EV,希亚;EU,周大貓",["冰风岗"] = "Ef,鹿花;Ee,杰尼龟丶头大;Ed,Louye,夜雪,八九不离十;Ec,风恋残音,帅的溙坦造物,阴霾的天空;Eb,白尾蓝猫;Ea,苞米地小飞侠,拆迁队队长,密林遊俠;ET,Onlysoso",["凤凰之神"] = "Ef,Wareve,慢慢人生路,张丶背刺,一箭带走,Snarler;Ed,杨寶寶,沐月之林;Ec,大灬亨,Epicure,菜逼帝凯丶,犽謌;Eb,叫你不带帽子,森森阿,最终的圆舞曲;Ea,丨死亡丨灬羿,丶丨英雄丨丶,东来丶,疾风乄残箭,山里有只喵,丶丿秋天灬,血恶弑神;EZ,卡姆九十六,小兮几,维内托;EY,面包师阿毛;EX,小墨、,Furyrain;EV,安菲尔德葵;EU,生气的四季豆,逐日丨鬼鬼,幼儿园之怒;ET,枷锁,彼岸的回忆",["无尽之海"] = "Ef,职业不符;Ee,伊利冫;Ed,郝老贰,下一片落叶、,槍响之后;Ec,四季冷暖是你,小可爱呀;Eb,有奶也不奶,丷菟丨灬珼珼;Ea,丶龙噬;EZ,绮梦成贞;EY,形意拳阿福;EU,暮雨",["克尔苏加德"] = "Ef,暮光闪闪丶,小霸霸児;Ea,大雨灬,萌小媌媌;EZ,明度;EY,你演个小猫把;EV,噬命丶肉偶;EU,Kroraina,太難得的香蕉",["阿古斯"] = "Ef,回忆小雪,氵三哥;Ed,豹子头丶林冲;Eb,艾瑞斯;EY,昱剑,青丶檸;EV,",["迅捷微风"] = "Ef,翼之回归,有多多欧鳇丶;Ec,星屑丶砂时计;Eb,上上课睡了;Ea,抡臂大回环;EV,望天灬,霂阳,风霂阳;ET,嶙嶙",["???"] = "Ef,钙丶片,林哥丶,疯牛不倜傥,绝世面包;Ed,潶澀灬小妹;Eb,善良的托尼,樱桃宝宝丶,奇坦丶血手;EY,超多魚;EX,橙默丶",["安苏"] = "Ef,圣光保佑你哦,战纪;Ec,印度神犇;Eb,暮林晚枫,尘封之歌,瀛洲之光;EZ,暗夜的圣光;EU,逍遙劍",["天空之墙"] = "Ef,半年丶;Ed,英语六级;Ea,林丶熙娜;EY,徐瑾欢",["阿尔萨斯"] = "Ef,孤月影;ET,Cmelo",["熊猫酒仙"] = "Ef,这很魔兽丶;Ed,利刃隨人,胖浩;Ec,卤蛋飞飞;Eb,可口泡菜,女口止匕舌甘;EY,小凡姑娘;ET,司辰",["奥特兰克"] = "Ef,谈指红颜老;Ee,Valio,夯丶风暴烈酒;Eb,天下山河海;EZ,守护骑士丶;EY,Siga;EU,有丶儒雅随和,心斩灵魂,冷凝雪",["贫瘠之地"] = "Ef,小饭熊,醋醋,Alunen;Ee,情殇亦过往,帝灬;Ed,了德过;Ec,死于真乐,壞尛孓;Eb,冰糖葫芦娃丶,奶攸,天雷渡劫,梦于你,如果那一次,Elunes,最后的丹丹;Ea,Momonin,李貝留嘶,咿唎丹怒風,叫兽、涛;EZ,奔跑的荣誉点,死肥宅奥利奥,萦十三,空白色丨丨;EY,闪现术,眉帶凶兆;EX,大力丶出奇迹;EV,幽幽花舞;EU,Darkwich;ET,八月",["迦拉克隆"] = "Ef,霜天之环;Ee,光晖岁月;Ed,那怎么话喃;Ec,老弓真箭;Ea,幻夜丶冰羽;EZ,风壹样的少年,你我是谁,盏酒慰风尘;EY,龙骑士丶;EU,潜小菠;ET,乐依罹,骑猪去兜疯",["布兰卡德"] = "Ef,鬼贵;Ee,碰巧,欧皇丶丶;Ed,疯狂戴夫,折翼卫生巾;Ec,觉醒者,超爱上厕所;Ea,收长头发啊;EZ,爱不易,客官丷丷;EY,我爱七喜丶,Titanshost;EV,老舅;EU,孫悟飯",["国王之谷"] = "Ef,月初东山之上;Ee,噹噹小火球;Ed,江阴魔神;Ec,君寒在;Eb,夜雨茶微凉;Ea,藍月灬靈,冥獄執刑官;EZ,蹦蹦跳跳,独鲤;ET,教官的迪斯科",["燃烧之刃"] = "Ef,Etemity;Ee,丶不动如山,烈烈无敌,小芬达,血祭惡魔;Ed,我在路上奔,迷迷瓜,Zzajds,娃灬娃灬;Ec,Innovations,槟榔瘾丶,戒斷;Eb,芷丶宓;Ea,安德路吼吼;EZ,尐丶德;EY,丨老佛爺丶;EX,维生灬素素,丿樱木花道,伊丽丹,圣骑十,江诗丹顿;ET,阿笨牛,烈焰游侠",["回音山"] = "Ef,硬又黑丶;Ee,两只小肥猫;Ec,落寂天星;Eb,孤独的传教士;Ea,德伊菲尔,筱雨菲菲;EV,空灵道;EU,诅咒的回响;ET,其修远兮",["恶魔之魂"] = "Ef,埃辛喏斯;Eb,大丑逼;Ea,幽灵戮日",["库尔提拉斯"] = "Ef,比熊,萌二蛋",["黑铁"] = "Ef,Enock;Ee,泪丶陨,Wrathzt,赤小西喵喵,Greedzt;Ed,阿兰斯;Ec,甜心氵;EZ,千万战痕,Emhunter;EY,Hatsuduki,天莽;EX,致命安魂曲",["白银之手"] = "Ef,萨慢慢,丶大言;Ee,艾文格林,羽风泰兰德,银骑士塔卡,萦绕于心;Ed,栤葑绿茶,泠月凝霜刀;Ec,法拉莉莉,流月芳华,珏媛的小男友,耳后呼吸;Eb,黑手,丶咚咚啵丶,河南王俊凯,Tenderkiss,Xqtrr,Acroyd;Ea,猫小闹,雾歌大魔王丶;EZ,下沙黄旭东,夜雨冰蓝,偷得半天闲;EX,冷月下的魂灵;EV,艾小路;EU,浮生忘流年,深圳鱼帥,幻城丶风雨,圆圆的肉丸;ET,秋月春风丶,梦到一百万",["蓝龙军团"] = "Ef,死息",["山丘之王"] = "Ef,雅典娜之怒;Ea,只穿板夹;ET,Xantz",["莱索恩"] = "Ef,木仓示申",["主宰之剑"] = "Ef,Tevis;Ee,梧桐乄树上;Ed,唯梦相随,珍珠酱;Ec,听风说往事;EZ,李大佬,零鹰,罗兰丶影歌,炭烧乌龙茶,苏白大大,死亡佩琪;EY,君不劍,丷九月;EU,諾灬靈",["斯克提斯"] = "Ef,羁旅天涯;ET,十点半睡",["伊森利恩"] = "Ef,嗳呦、欣,棒棒儿不咬人,猎手丶小青春;Ee,天蓝色的梦,暗影菊暴,百变哈缪尔;Ed,圈住那个九;Ec,薛伊利;Eb,淡墨无殇,动次打次动动,黑胡桃心,大耳朵亮亮;Ea,魔神丶,小妖紫晨;EV,小怪受丶;EU,卧底追风,斎藤飞鳥,我不是咕咕",["火焰之树"] = "Ef,胡歌;Ec,听楓挽",["图拉扬"] = "Ee,隔壁老杜;Ed,锦衣夜逃;Eb,Jill",["冰霜之刃"] = "Ee,赤色约定;Ec,Kalila;Eb,艺梦婧美错;EY,孙笑川的奶奶;EU,迷要;ET,虫丶二",["太阳之井"] = "Ee,覇王别姬;EU,仲笠",["雷克萨"] = "Ee,如歌的行饭;EY,辩机",["大地之怒"] = "Ee,奥莉薇雅",["银月"] = "Ee,年迈的战吊;Ec,四费星界",["斩魔者"] = "Ee,曼妙小妖",["诺莫瑞根"] = "Ee,斯大林二",["风行者"] = "Ee,请别拍打喂;EZ,希尔瓦娜斯;ET,没留胡须",["罗宁"] = "Ee,橙心的锤锤,暗双子,霜伤丶;Ec,可楽儿,嘟嘟嘴柯基;Eb,深渊上的火;Ea,杰尼龟队长,画石,Neria;EZ,他改变了祖国,胖贼龙襄,老花椒丶,陈晨成,霜火挽歌,Disneymagic;EV,雾隐霜月天;ET,牛会长",["萨菲隆"] = "Ee,二口类;EZ,凝望深渊丶;EX,李小胖;EU,打劫小排骨",["艾露恩"] = "Ee,村镇一枝花;Ed,白白的大白兔,天线哞哞宝宝;Ea,快乐咕咕宝宝",["守护之剑"] = "Ee,梦醒九分丶,旺仔馒頭;Ec,一牛仔很忙一;Ea,鸾跂鸿惊;EV,月飘零",["索瑞森"] = "Ee,Ox;Ed,枯法的阿昆达",["熵魔"] = "Ee,一世琉璃白丶;EZ,一世琉璃白",["达纳斯"] = "Ee,吃饱了好睡觉",["符文图腾"] = "Ee,哎哟我的肝;Ec,Xalatath;EY,嗜血熊熊",["勇士岛"] = "Ee,舒麻子,今晚打老腐",["海克泰尔"] = "Ee,汐雾;Ec,射击猎丶;EZ,壹箭倾心",["元素之力"] = "Ee,悲灵笑骨",["战歌"] = "Ee,將灬進酒;EY,联合国主席;EX,Skrillex",["丽丽（四川）"] = "Ee,闇丶佟大為,Midou;Ec,Theonerely;Ea,智妍,Odpriest,不要集火我丶;EV,十二快蓝娇",["暗影之月"] = "Ee,火儛、;Eb,不是不乖;Ea,潴麦",["提瑞斯法"] = "Ee,凤凰的咒语",["埃德萨拉"] = "Ee,吨吨盹吨;Eb,满地小黄瓜;EZ,星怜,菊丶魔;EX,上去开团;ET,惿里奥丶弗丁",["法拉希姆"] = "Ee,赐我一个名字",["苏拉玛"] = "Ee,Karsa",["布莱恩"] = "Ee,十月的橘子",["狂热之刃"] = "Ee,骑牛看夕阳;Ec,Cczone;Ea,酷爱多,补兵一号;EV,我踏妈没疯丶",["伊兰尼库斯"] = "Ee,德意不德;EX,炸不干的油炸",["血色十字军"] = "Ee,不要名字,感冒的小竹鼠;Ed,京华舞,丝提希亚,伊卡洛赛斯;Ec,詩寇蒂,非酋大叔;Eb,泠泠月上;Ea,大宝剑,三秒;EV,丨眸夜祭歌丨;EU,阿狸么",["影之哀伤"] = "Ee,黑暗中永眠;Ed,受折磨的靈魂;Ec,不要这样子么,离谱小白;Eb,劍盾同眠,翠云裘;Ea,Asadsdafdsas,暴躁的平头哥,浮生皆是梦;EZ,咿利丹灬怒风;EY,Lylirra;EX,饺子熟了;ET,咸鱼和远方,一花倾国相欢",["诺兹多姆"] = "Ee,拜了佛冷;Eb,冬天猫",["末日行者"] = "Ee,爱萍如梦;Ec,埃尔伯,正义的大板砖,外乡人,逆羽幻翎,寂寞成詩丶;Eb,寿司小兔子;Ea,含玉听白,桑诗爷;EY,血红新月;EV,秃头男;EU,灬良羽寒灬;ET,黑铁戰神,一点五梯",["能源舰"] = "Ee,柳枝;Eb,零叁叁肆",["死亡之翼"] = "Ee,阿古斯之影,枉度輪回;Ed,今天不偷袭,米九九丶,Kairrigana,知名影帝,昊天大师,Justlce;Eb,少年女性挚友,做饭的阿昆达,人狗双亡丶;Ea,Onslaught,星如海,影心灬;EZ,昼夜星辰,丨牧師丶,蘿蔔不是萝卜,北巷梦不夏;EY,有丶小雨,砍死人,萌萌哒演员;EX,Tyraeli,输出的阿昆达;EV,默默丶阿昆达;EU,Softpeach,贼棒,Tiss;ET,景漫漫丷,梅德库尔川,忆水月吶",["艾森娜"] = "Ee,钢然天盗",["梅尔加尼"] = "Ee,呆萌小熊猫,呆萌大熊猫;Ea,聆羽",["夏维安"] = "Ee,基纽特种部队;Eb,忍者肥",["风暴之眼"] = "Ee,月影有爱;Ea,虔诚丶挽风,霍青桐",["风暴峭壁"] = "Ed,乐乐的鼠标垫;Ec,Monical",["血吼"] = "Ed,小小的盗賊",["军团要塞"] = "Ed,维丶他;Ec,十余秋",["外域"] = "Ed,愤怒的高端蛋",["黑龙军团"] = "Ed,梦溪一小德;EZ,疆还是劳道辣;EX,疆君",["艾维娜"] = "Ed,小羊咩咩",["阿斯塔洛"] = "Ed,啡色烟光",["风暴之鳞"] = "Ed,艾玛杜蒙特",["戈提克"] = "Ed,云尺;Eb,术术给你糖吃",["鹰巢山"] = "Ed,哇灬侽人",["铜龙军团"] = "Ed,紫色大飞机;EZ,哈士骑",["阿克蒙德"] = "Ed,发电的阿昆达;Eb,达康书记丶",["塞拉摩"] = "Ed,蜡笔的小新丶",["末日祷告祭坛"] = "Ed,九霄天骄",["远古海滩"] = "Ed,Darksky;Ec,孑孑",["菲米丝"] = "Ed,坏晓德",["弗塞雷迦"] = "Ed,耳語;Ea,半藏贼溜;EZ,丶兽兽",["永夜港"] = "Ed,红魔小慧;Ea,丶阿牛",["伊利丹"] = "Ed,伤心更伤;EU,Mikelan",["奥尔加隆"] = "Ed,韩菱纱;Ea,夏姬八砍;EX,王二寒",["古尔丹"] = "Ed,天使之风",["血牙魔王"] = "Ed,雷熊熊;Ec,夜阑听宇;EY,白大锤",["日落沼泽"] = "Ed,看我眼神;EZ,木尸小玉,半藏为玉效命",["屠魔山谷"] = "Ed,怒火丶中烧",["火羽山"] = "Ec,大鸡霸喜洋洋;EU,倾城乄堕落",["红龙女王"] = "Ec,就很生气阿",["纳克萨玛斯"] = "Ec,洛水·天依",["戈古纳斯"] = "Ec,冷月红魔鬼",["轻风之语"] = "Ec,术亦有专攻",["暮色森林"] = "Ec,飞起的俊俊;EV,Gourdsnow",["希尔瓦娜斯"] = "Ec,树上的羊",["闪电之刃"] = "Ec,冷月",["银松森林"] = "Ec,眯了个叽;EZ,伊利二雷",["菲拉斯"] = "Ec,枪炮丶玫瑰;Eb,魅影悠悠,魔道刺青;ET,西域春",["达文格尔"] = "Ec,青衫;EZ,逅邂若恍",["熔火之心"] = "Ec,玥弦丶熊熊;Eb,永恒德;EV,大胡子灬杨叔;EU,丨死亡丨灬羿",["加里索斯"] = "Ec,莫古利",["加基森"] = "Ec,Joyilol,悠月哓哓;EV,隔代有佳人",["沙怒"] = "Ec,丶潜行小白",["洛萨"] = "Ec,乱箭似雪",["奥蕾莉亚"] = "Ec,殇红尘",["雷斧堡垒"] = "Ec,说一;Ea,希爾瓦娜斯拉",["金度"] = "Ec,最美的时光;EX,挽手说梦话",["红龙军团"] = "Ec,嘴嚼丨屁児歪;Eb,巴伦支手术刀,卤本伟;Ea,吾南笙",["霜之哀伤"] = "Ec,冰雪之殇;Eb,小恶魔,冰封蓝语;Ea,風見幽香",["燃烧军团"] = "Ec,纵情屠戮",["巴纳扎尔"] = "Ec,血伯爵;Eb,喵喵球",["日落沼澤[TW]"] = "Ec,月丶夜",["红云台地"] = "Eb,汪汪大魔王;Ea,艹哥,亦寒,八稚女苍月;ET,妖怪爹爹",["巨龙之吼"] = "Eb,苍崎橙子的烟",["风暴之怒"] = "Eb,双月之夜;EU,黑桃小九;ET,自闭的阿昆达",["罗曼斯"] = "Eb,榴莲木有刺",["艾萨拉"] = "Eb,黑钥什",["血环"] = "Eb,枼子红了;EY,奶瓶弟弟;ET,性临春暖",["扎拉赞恩"] = "Eb,辕门浪子丿永",["月光林地"] = "Eb,Nemesisal;EZ,春风十里如梦,丶铁浮屠;EU,Macaria,皇太子",["森金"] = "Eb,丨小花丨",["桑德兰"] = "Eb,慌得一逼;Ea,狂野刺杀;EX,司马仲达;EU,初晨、",["安东尼达斯"] = "Eb,寒庐煮酒",["龙骨平原"] = "Eb,樱、吹雪;EZ,哆辣辣;EY,平平仄仄",["利刃之拳"] = "Eb,黑虎阿福;EZ,奔波儿爸;EV,小凤的十老婆",["加兹鲁维"] = "Eb,哀行者",["蜘蛛王国"] = "Eb,特莉絲",["火喉"] = "Eb,微光塵夏;ET,风月清幽雨",["基尔加丹"] = "Eb,冷梦雁叶",["迪瑟洛克"] = "Eb,走路骚会闪腰",["嚎风峡湾"] = "Ea,冰之泪",["破碎岭"] = "Ea,Turbowarrior;EX,Mfro",["霜狼"] = "Ea,猫熊猎手;EZ,夏望繁星",["永恒之井"] = "Ea,椰酥,莲酱的鱼;EZ,",["玛里苟斯"] = "Ea,黑渊白花",["苏塔恩"] = "Ea,香坂时雨;EZ,慕斯奶盖",["石爪峰"] = "Ea,最后的丶轻语;EX,退役吹比选手",["荆棘谷"] = "Ea,悟达尔",["激流之傲"] = "Ea,别在红圈里打;EY,折棠",["巫妖之王"] = "Ea,吃菜;EZ,开放的少女,Arés;ET,Whisperfish",["鬼雾峰"] = "Ea,Ibot;EZ,听岚丶;ET,泪已成霜",["羽月"] = "Ea,Damnit",["黑石尖塔"] = "Ea,二月丶逆流",["神圣之歌"] = "Ea,云岚",["世界之树"] = "Ea,丷灬粉墨丶乀;ET,路连城",["雷霆之怒"] = "EZ,轻风物語;EV,一头大鹅",["壁炉谷"] = "EZ,糖门",["幽暗沼泽"] = "EZ,卩灬阿飞;EX,格里菲因丶;ET,闲朝暮信归途",["伊瑟拉"] = "EZ,米汤;EX,阿曼苏尔丨芬",["阿拉索"] = "EZ,影帝谢霆锋",["雏龙之翼"] = "EZ,白玉京,鹤顶红丶",["库德兰"] = "EZ,东门斩兔",["海达希亚"] = "EZ,速风语者",["盖斯"] = "EZ,Reborny",["奥杜尔"] = "EZ,单车龙",["朵丹尼尔"] = "EZ,非洲脱贫酋长;ET,就怕贼惦记",["祖阿曼"] = "EZ,安静的葡萄;EX,意得",["埃苏雷格"] = "EZ,怒斩人间愁",["耐奥祖"] = "EY,Hegemon",["雷霆之王"] = "EY,哎呀有蚊子;EX,伊利达雷公主",["塞泰克"] = "EY,沐灵云",["艾莫莉丝"] = "EY,来自西班牙",["亚雷戈斯"] = "EY,哀傷之觸",["范克里夫"] = "EX,往往倦后",["生态船"] = "EX,天地茫茫",["冰川之拳"] = "EX,蛀牙很不爽",["万色星辰"] = "EX,优优鸣天箭",["耳语海岸"] = "EV,若汐,夏天;EU,祭月隐修",["烈焰峰"] = "EV,左右",["恶魔之翼"] = "EV,天季的云",["奈法利安"] = "EV,凌波喵步",["玛诺洛斯"] = "EV,动感小风",["基尔罗格"] = "EU,星尘大海",["普瑞斯托"] = "EU,牛牛的西北方",["安威玛尔"] = "EU,桃之宝",["安纳塞隆"] = "EU,皮皮的邦桑迪",["洛肯"] = "EU,德拉米尔",["试炼之环"] = "EU,枳花丶驿影",["通灵学院"] = "ET,陆荫杆霞",["翡翠梦境"] = "ET,荆棘刺环",["千针石林"] = "ET,艾尔的荣耀,|艾尔之光"};
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
                    table.insert(players, fullname)
                    player_days[fullname] = date
                    player_shown[fullname] = topNamesOrder[fullname] or 0
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