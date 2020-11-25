local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["凤凰之神"] = "Q3,你家兔兔;Q2,墨墨萌萌哒,尔等不讲武德,可爱夕,Meryl,歌丶律,灬小海疼灬,女王死忠粉,以德服亼;Q1,萬惡之靈,白爷丷;Q0,小尾巴不见了,殊茗丶;Qz,终极毒奶,妖刀可太帅了,似风没有归途,逍遥使,粉紅高压電,苏歌乁,黄瓜灬,沙雕爱狗,牧竖之焚,聖侊忽悠着你;Qy,米奈希尔大公,浪里个浪味仙,若影丶林,拉胯弟弟贼,不能叫我山鸡;Qx,褚赢,天使曦夢,雨落心安丷,雨落心安,丷沈剑心丷,Mimmy;Qw,丰息,任妻终结者,蒙多大冒险,汌上富江,Yimmy,筱攸怡;Qv,艾露尼斯丶,静丶喵喵灬;Qu,这是为什么呢,大红乌苏,往昔如云,安卡的初拥,索兰莉荌,愤怒的雷宝宝;Qt,神圣的加摩尔,丶阿木,白羊座灬若涵,婧萱;Qs,前丶妻,身带高压电;Qr,紫恨情缘,叶舞轻楓,桜沢墨,丷笑生花;Qq,半城丿猎,雪霜,丨温瞳丨灬,丨冷眸丨灬,一二柒八法,暗影之境丶雷;Qp,灬依咕哔咕灬,黑旋风李元霸,阿殇丶,丨白玉亰丨;Qo,就捅一捅,就跳啊跳;Qn,白羊座灬倾心;Qm,黒風;Ql,奥雷莉亚公爵;Qk,明丨明;Qj,粉白白;Qi,白羊座灬狐颜,牧牛熊;Qh,拉拉嘴额,轻玥,死亡之亦,暮烟光凝,大奶流,三生梦;Qg,豆虎皮皮,指縫丶,特拉法加鸽王,Dizzymeow,周老师请坐;Qf,君子意如何",["血色十字军"] = "Q3,聖灬幽哈;Q2,老老队长;Q1,羽霖铃,桔子修成仙;Q0,泽塔;Qy,带带大冰龙,橙不二丶;Qw,忘却录音,紫色潮汐,清風煦来,白箱,红叶怨秋风;Qv,一只大柚子,梧小桐;Qt,Makamaka;Qs,伊希塔卡;Qr,瑪法理沙;Qq,康帝,大穷喵,树根;Qp,哈夫维特;Qk,山竹大佬;Qj,胖墩丶;Qf,丶伴伴糖,全聚德烤咕咕,重立体四号,奶粉大宝贝儿,聖光将熄丶,听说过圣光吗,香蕉丶大酋长",["白银之手"] = "Q2,阿米达居,单点碧螺春,包宝宝,混吃的橘猫,丶绾起梨花月;Q1,悠扬归梦,耶夢伽得;Q0,目害目艮火柬,遇见你伏笔,不白忙,不合适;Qz,血小板丷,花与晴的流星,昂口田,霜奶萌萌哒;Qy,花生与酒,一罐冰镇啤酒;Qx,魔女阿拉蕾;Qw,何来不吃海鲜,海椒皮皮;Qv,執筆斷情殤,茗歌,Subjective,社区片警,西索奇术师;Qu,冰焰铭心,漏网之鱼丶;Qt,Pronoea,Outing,你喵了个咪,丶星冠型毛毛,嘿丶凤梨;Qs,逃避丶现实;Qr,安慕汐,荒野半神,遇见神明之前,芋圆四号,魂归故囇;Qq,Rookies,冥河边逗鬼仙;Qp,九折,雷千灯,花壹開滿,中华起司猫,就要吃肉肉,古惑死靈因,啃苹果的喵,多放香菜,南极馨;Qo,赵一二;Qn,伤心黑海岸;Qm,帝铠熊,无根白银汤,若写情书;Ql,颢耀;Qk,千寒丶,暗夜雖龍,怒海风暴,倾城情雨;Qj,荀彧念作苟或;Qi,圣光敕令,怀念的颜色,甜飞云,欧皇欧霸;Qh,大灯李李,柠檬水饮,画包上的老猫,丨沐雨乘风丨,十八变,Miletus;Qg,Louhh,蹴罢秋千,阿怪哥",["影之哀伤"] = "Q2,柒夏玲珑;Q1,禅师,灬张子修灬,超级咔咔罗特,星尘;Q0,炎焱,骚年冲钅,少林菲;Qz,我需要治疗;Qy,九黎丶龙;Qx,Thereed,随灬情;Qw,白大師;Qv,山城彭于晏,神骰;Qu,得歩德,沐雪清颜,贰丫,王逸;Qt,暗风之影;Qr,米翠花;Qp,简庭庭;Qo,Rv;Qm,玲二;Ql,铁拳没吃饭吗;Qk,病名爲爱;Qj,希亚;Qh,兰克丶;Qg,夏沫丶浅雨,夏茉灬微凉,挽远;Qf,狸萨,跃动时如火星",["米奈希尔"] = "Q2,小白兔",["伊森利恩"] = "Q2,咕神小喵喵,一曳清风,涩气头头猫,君雅小妹妹;Q1,龙猫猫,艾菲热,森曲魂音丶;Q0,花烛映影深,重乄樓;Qz,狸头有芽儿;Qw,北执;Qv,Redone;Qs,Mesric;Qr,战霸,替我当炮灰;Qp,仲莫肥四鸭,冰鎮榴蓮酥,看我变只鸡,十五年老萨满;Ql,雪狐的银尾,克己复礼;Qj,白阿白,圣婴大王污昂;Qi,德国骨科;Qh,Kobeneverout;Qg,Rethmo;Qf,猫姐吖",["灰谷"] = "Q2,嬲噻熊;Qk,一对小得",["主宰之剑"] = "Q2,丶露水,淡漠以对;Q1,给我烙仨糖饼,丶雪拥蓝关,楼榕剑;Q0,拈花把酒情狂,Amandam,徐锦江的粉丝;Qz,灬郁蓝灬,墨邱立,Cynric,Shadowfalls,收费奶,丶格调;Qy,古神,吉祥乂如意;Qw,冬灵猎,谁也表拦我;Qv,枸杞咖啡,土汢;Qu,素灬秋,百里骐;Qt,痴汉裴至炫,褪色的你;Qs,欧洲教父;Qr,破裤丶,薄暮的狗蛋儿;Qq,伪裝,然羙羙;Qp,丷葵司乄,丨悲丨,春哥菊花茶,老流氓林克;Qn,动感蓝胖子;Qm,漂泊无依,立花千寻;Ql,她就有点皮;Qj,峰卷残云;Qh,王权乄富贵,太饿猎",["罗宁"] = "Q2,笑狂神,天使长;Q1,暮雪千岚;Qy,爱红红太好了,谢铃飞虫,Archmagic;Qx,天肝勿燥;Qw,酸奶真好喝,奶饱你;Qr,范哒尔丶钢盔,Tasty;Qq,誅神黄昏,她是我的光,两个火球;Qp,依昔记忆,紫色暗瞳;Qi,圣光人肉沙包;Qg,Inspired",["黑暗魅影"] = "Q2,阿丝匹琳酱",["奥斯里安"] = "Q2,三鹿牛",["迦拉克隆"] = "Q2,摁倒踹脸,谦丶卦;Qy,无聊也无橙;Qp,夏莲香",["艾露恩"] = "Q2,蓦山溪丶;Qt,风吹小豆豆;Qq,我要去睡觉;Qp,布丽吉塔;Qh,Marxism",["格瑞姆巴托"] = "Q2,伟大的龟仙人,Amzings;Q1,粪坑潜泳;Qz,雲笙;Qy,糖绿绿;Qx,图腾肩上扛;Qw,青花椒,Dozzi,桃花依柒梦;Qv,李槐,看见星空了吗;Qu,断離丶;Qt,城南墨客;Qs,闪闪的闪闪,弥月泊桑,大白腿;Qr,沐荣,叶心安,Divinevil,黑暗凝视,黑暗冥想;Qq,榴莲炖臭豆腐,别吃了;Qp,必将百倍奉还,为所欲为小德;Qo,光明奶茶;Qk,惊丶梦;Qj,小鱼丨小维他,喵丶风暴清酒;Qi,Pudge,追野丸加丶;Qh,武术家马保国;Qg,默默小闹腾;Qf,关伯兰还在笑,关伯兰在笑,戒不掉伈殇",["国王之谷"] = "Q2,暮雨微光;Q1,叹为观止;Qz,九星战神龙尘;Qx,雾丶小僧;Qw,小德雅,意怡,鹿城旺财三,一笑懸命;Qu,帅菌;Qs,噢呦呦;Qq,诩沁沁;Qp,因古斯特,甜梦熊,甜梦猫;Ql,折戟尘沙;Qk,沒有蛀蚜;Qi,远山晴更多",["塞拉摩"] = "Q2,影禄落橘里;Qz,贰队那个戦士;Qp,灬殇丶影;Qi,猫大夫",["布兰卡德"] = "Q2,星屑的追忆;Q1,飞翔的大老鼠,加我莫悲;Qu,咸鱼咆哮;Qr,提里奥丶弗丁,陈澄橙;Qq,汐夏丨桃桃酱;Qp,我的小甜姜丶,巴彦格勒顺,葉落知秌,是桐生战兔哒,香灬薰,灬绫灬;Qm,毁灭虹吸;Qk,阿圆,不良帥,Atom;Qh,少林菲菲",["死亡之翼"] = "Q2,黄皮耗子呀丶,大马户子;Q1,贼认钱,温蒂妮怒风,逝去的银弹;Q0,柚子君呀丶,是柚子君呀丶;Qz,山河予你,丷两根赖毛子,死灵嵐姬;Qy,加载失败,斑马苏宜;Qx,天天兄,巨摸法丶,水比特瓦根;Qw,元气森林丶,上善若山,骄王轻花慢酒,遗忘的肾,Aiolos;Qv,名称加载失败;Qt,七英里旅程,魔法小猪猪,原来是买买呀,小心熊出没丶;Qs,弄丑,棉花熊,肥妮克斯,怜香,笨笨喵;Qr,沫熙,会动的牛肉干,丶李二宝;Qq,笑踏联盟狗脸;Qp,网名加载失败,化作水星;Qm,白峰里莎;Ql,路西菲尔斯;Qk,温暖的大熊;Qj,迷茫的柚子;Qi,陈墨;Qh,宸诚;Qg,大青兕,三宝公爵,三宝儿降临,犹格索讬斯",["雷斧堡垒"] = "Q2,贝宝;Qv,青春就是骚",["寒冰皇冠"] = "Q2,白羽丶",["菲拉斯"] = "Q2,Xxlucky;Q1,暗灭;Qr,小胖鸟",["克尔苏加德"] = "Q2,恶行左岸;Qv,网瘾少女豚豚,无心菜;Qr,如临花开,Himygirl;Qq,那就太亏了;Qo,那个帅小伙;Qj,网吧偷单车,阿肥丶;Qi,核心大师",["洛丹伦"] = "Q2,動感回旋踢;Qy,小奶猪佩奇;Qw,六阶带化无;Qt,爱情加载失败;Qs,劣人丿,灵之亡者;Qr,大来来;Qp,沐雪晨阳,牛牛的爱丶;Qo,血苍白;Qh,王来",["无尽之海"] = "Q2,九尾狐丶,诡术丿妖姬;Q1,红叶铸流光;Qz,Icebe;Qw,小小怪怪;Qv,一条小猎猎,豚豚龙骑士;Qu,西域一番僧,青灯焚骨,威猛绿皮怪,电竞阿卡丽;Qs,海猫食堂,小蛋挞;Qr,换月;Qp,尐猜丶;Ql,山一程雪一更;Qk,Aliceangela,了然灬猎;Qh,丶隻狼灬,妖怪灬了然;Qf,素芬儿",["安苏"] = "Q2,午门三刻,来日方长吧;Q1,水塔陈醋;Q0,華脩,寄蜉蝣于天地,圣光常伴吾身;Qz,叶落乄花雨黯;Qy,山崎宗鉴,一大包仙贝丶;Qx,剑吼荒墟,失去得回忆,一大袋雪饼丶,破灭圣光,燃炸;Qw,爷爷老眼昏花,自行车痴汉,春风不入驴耳,水蓝色午夜,灬太阳骑士;Qv,搅合搅合,加油打工喵;Qr,恶尘无染,丨断线丶,黑风寨巡山鬼,丨十二丨,丨三五丨,丨三一丨,丨十九丨,丨二一丨,丨二一,从零;Qq,乄暧昧丶;Qp,比梦更真实;Qo,从此不奶;Qj,淡年;Qh,璃尛,Vanlatena;Qg,爫奔跑的蜗牛,艹奔跑的蜗牛,丷奔跑的蜗牛,兦奔跑的蜗牛,亾奔跑的蜗牛,乊奔跑的蜗牛,乄奔跑的蜗牛,皿奔跑的蜗牛,覀奔跑的蜗牛,丣奔跑的蜗牛,罓奔跑的蜗牛,罒奔跑的蜗牛,快给我来个橙,都是脆皮,流刘刘鼻涕;Qf,乐观的二五仔",["银月"] = "Q2,姬如千珑",["熔火之心"] = "Q2,贰湿兄丶;Qw,纯工具人丶;Qr,Sunch;Qo,王大蛮;Ql,艾瑞巴蒂丶",["血环"] = "Q2,張公子丶;Qy,乐神归来;Qr,卡炸飛;Qq,香沫儿;Qh,沙之我爱罗",["幽暗沼泽"] = "Q2,Laker;Qy,李玩儿,高粱吉娃娃;Qq,柴柴",["提瑞斯法"] = "Q2,黑木碎蹄;Qw,瞬身止水",["狂热之刃"] = "Q2,欧德弗莱;Q1,星际小牛;Qw,谢小蕾;Qt,凛音;Qr,南栀;Qk,Montgomery;Qi,遥射牧女村",["冰风岗"] = "Q2,隐官,大聪明丨;Q0,九歌乀;Qy,乐神降临,痕星丶;Qw,張韶涵,粥酱,柳生云;Qv,宁姚;Qs,初拥;Qr,微微笑丶;Qq,九蓝丶雨中客,九梦蓝,九蓝的护佑,九小天儿;Qp,罗纳河的星夜;Qo,不当奶狗;Ql,呆萌的贼;Qh,纯粹武夫;Qf,欧皇悲離",["贫瘠之地"] = "Q2,丶坚果;Q1,也曾海棠依旧,宇智波牛德华;Q0,元丶旦;Qz,信仰之子,丨沙砾丨;Qy,蓦然之间丷,入心,何田田,亡魂灬牧诗;Qx,亦有道丷;Qw,表妹考辛思,表妹考欣思;Qv,云臥北凕,云卧北凕,橡树丶萌徳儿;Qu,虎蜻蜓,桐瞳;Qt,移动蛆肉罐头,Evelina,Kazusa;Qs,Saybyeolbe,Pixinsight;Qr,追龍;Qq,高冷猫呀;Qp,情迷意亂,缘玅不可言;Qo,Hyitdai;Qk,江月庭芜,从晨锋,灬兜兜转灬;Qi,小楼夜听弦;Qh,我愛御姐,刺头丶;Qf,哋灬哋哋,约翰丿列侬",["龙骨平原"] = "Q2,丶山大王;Qr,温柔的毒药",["???"] = "Q2,凯宇大人;Q0,游德;Qz,妖鱼,扬中河豚岛;Qy,九尾吉月,丿小楽丶;Qw,櫻桃大丸子,弥凯朗淇洛,第七狩魂,Ssaberalter,牛油果去哪了,赫克托尔;Qu,山椒鱼丶半蔵,夯无力,大鸡脖美少女;Qt,逸风,希丶小斯",["巴瑟拉斯"] = "Q1,酸哥;Qv,风白羽",["熊猫酒仙"] = "Q1,我有我方向,蚊子吃西瓜;Qy,火烨炎焱;Qw,谁与争蜂,萨里曼,朦胧宵宵;Qv,Strive,娜乌西卡,丿莼菓乐丶;Qu,乱世冷风,问天九歌丶;Qt,遇过彩虹;Qr,丶瘋言瘋语;Qn,雲想衣裳;Ql,目及皆王土,丶儬釹;Qj,瘋人院;Qh,麻瓜麻瓜",["冰霜之刃"] = "Q1,南枝向暖;Q0,圣光铠;Qz,法力燃烧;Qy,全场最佳半藏;Qr,夏小辣丶",["玛诺洛斯"] = "Q1,丿灬璇玑;Qp,大猫本萌",["霜之哀伤"] = "Q1,微焦的食物;Qw,夏达尔丶星歌,幺六七,忍者不是我;Qu,拉不完的车;Qh,桦溪墨,Xxlxxl",["回音山"] = "Q1,小梦大半丶,烙丨印;Qz,Dala;Qv,恶魔的召唤,玉面飛龍,三汤两菜;Qt,走南;Ql,这一枪叫晚安;Qj,屠魔侠",["甜水绿洲"] = "Q1,曙光;Qw,向死而生丶;Qu,静听花儿开",["加兹鲁维"] = "Q1,飘血;Qr,陌夏残年",["盖斯"] = "Q0,小糖人",["恶魔之魂"] = "Q0,变后不洗手;Qs,血月聖光;Qn,大鱼鱼爱吃肉;Qg,只刃",["埃德萨拉"] = "Q0,熊灬贰,皮特德;Qz,矢心疯,天凡沉雨,晓之珀;Qy,游戏的大喵;Qx,熊野;Qw,劍隐锋藏;Qu,白艾,龙井白泽,咻灬咻;Qj,许于初见;Qg,红灬桃;Qf,甜酒",["战歌"] = "Q0,小圣之助;Qw,大意了",["鬼雾峰"] = "Q0,汣纔;Qx,荒芜一涅槃;Qw,牛蛋蛋的蛋",["鲜血熔炉"] = "Q0,萨瓦迪卡丶汪;Qh,Saber",["雷霆之王"] = "Q0,致命攻击;Qw,还魂的酒",["燃烧平原"] = "Q0,疯狂的六总;Qu,听雨",["燃烧之刃"] = "Q0,柯基大帝;Qz,暴躁的凉白开,一襟花月,筱暖阳;Qy,老卡老卡,Libra;Qx,炒饭之萌丶;Qw,奔驰的小野妈,胖波波,丨安之若兮,凌云逸;Qv,友边的你,丨灬梦涵灬丨,霜如梵;Qu,小雨傘,风暴召唤者;Qr,心灵灰烬,李家小可耐,禾口言皆;Qq,凤神凰,木木争青;Qp,灵冬冬,可可阿華田丶;Qm,玛格汉堡王,萨鲁法尔霸主,子祁;Qj,Giftia;Qh,肉离,Sookiechn,烟是回味;Qf,岚夏丶,曾经相识",["荆棘谷"] = "Qz,绿猴子;Qu,我就一张牌啦",["丽丽（四川）"] = "Qz,系豆;Qq,银河星爆;Qp,Alukaduo,皇帝的意志;Ql,丨雨丨;Qj,月银轻芬;Qh,敏若昕,妙若",["奥达曼"] = "Qz,染小莫㐅",["梦境之树"] = "Qz,静谧哈桑;Qu,冰炎铭心;Qf,一忘路",["金色平原"] = "Qz,嗑瓜子儿;Qw,彼岸华尔兹,帕凡,聊赠一枝,凌殿;Qu,胤娜;Qs,Ilz;Qj,青山遠黛;Qi,生命奇迹;Qh,把苹果啃哭丶,小禹丶",["末日行者"] = "Qz,何以清尘灬;Qw,阿尔塞斯国王,格瑞兹华尔德,现在只想静静;Qu,暮之秋,凯思琳,醉人魂丶;Qs,骑蚂蚁闯黄灯,何以清尘丶;Qp,Hyitdai;Qo,阿蘅;Qn,卡哇伊熙月;Qm,姜萌萌;Ql,后羿弯弓;Qg,鲍皮,鸡萨",["格雷迈恩"] = "Qy,莫高;Qp,随风铃;Qo,橙不欺我",["暴风祭坛"] = "Qy,飞翔的黄金瓜",["阿格拉玛"] = "Qy,墓诗",["奥杜尔"] = "Qy,雪月韵冰茶",["破碎岭"] = "Qy,假装炉石,假装增强;Qs,樱花儿;Qm,煮茶;Qi,弑君小贱",["永恒之井"] = "Qy,潍坊;Qs,Titan;Qf,潍坊纯爷们,沙雕青年",["阿古斯"] = "Qy,素颜;Qx,复变函数,行云,风的幻想;Qn,余生了了",["黑暗虚空"] = "Qy,望朦胧;Qv,老板是只猫丶",["萨尔"] = "Qy,Peachguard",["加基森"] = "Qy,冻肉丸子;Qr,丶时光",["朵丹尼尔"] = "Qy,马奎斯;Qt,芷希",["戈古纳斯"] = "Qy,秋冷了月光",["奥妮克希亚"] = "Qy,迦陵晚",["阿纳克洛斯"] = "Qx,风后奇门丶也;Qv,进击的熊孩子;Qt,羽流;Ql,逐日者",["蜘蛛王国"] = "Qx,Lumia",["安东尼达斯"] = "Qx,威廉邦尼",["布莱恩"] = "Qx,致郁系",["芬里斯"] = "Qx,射到抽筋",["克洛玛古斯"] = "Qx,暮光星灵",["奥特兰克"] = "Qx,水晶扣儿;Qr,Kopite;Qh,满目星河丶",["艾维娜"] = "Qx,桃地再不斩",["迅捷微风"] = "Qx,一口大黄牙;Qw,我来组成火把;Qt,银雪大人;Qs,烈酒奇德;Qh,血罐,坚果爸比",["伊利丹"] = "Qw,哎哟好多鱼;Qt,禅悟轨迹;Qn,姑射处士",["神圣之歌"] = "Qw,青菜克罗米;Qv,脱缰的野狗;Qt,圣光会忽悠;Qh,地狱火发型师",["阿迦玛甘"] = "Qw,我给你一下子",["风暴峭壁"] = "Qw,健康太平街",["雷克萨"] = "Qw,希丶小怡",["桑德兰"] = "Qw,罪孽深德;Qq,海棠花儿开",["泰兰德"] = "Qw,总是回忆;Qm,汲汲于生",["血羽"] = "Qw,百花仙;Qq,八云蓝",["月光林地"] = "Qw,巨龙童年记忆;Qs,莫摇清碎影",["索瑞森"] = "Qw,雷電灬;Qp,战吊",["地狱咆哮"] = "Qw,达达利亚",["石爪峰"] = "Qw,得之我幸;Qr,大宝贝儿丶",["暗影迷宫"] = "Qw,带法湿",["遗忘海岸"] = "Qw,混帐的天空;Qq,哀伤之影;Qm,熊二的皮球;Qi,罄竹难术;Qh,浅潜",["古尔丹"] = "Qw,臻烋",["黑铁"] = "Qw,西禅寺肉丸子,西禅寺泡泡肉;Qv,抹茶红豆糖;Qm,踩个奉献;Ql,拜拜了您那;Qh,拓老板;Qg,八月丶初秋;Qf,Xiyubaby",["森金"] = "Qw,碳烤巧乐兹",["太阳之井"] = "Qw,Drakedogs",["奥尔加隆"] = "Qw,阿鲁迪巴;Qp,风雨正苍苍",["诺兹多姆"] = "Qw,空丶",["伊萨里奥斯"] = "Qw,米米滋滋;Qs,裤里就是吊",["玛瑟里顿"] = "Qw,白眉",["达文格尔"] = "Qw,小翠花",["巫妖之王"] = "Qw,死亡弹药;Qq,故羌",["勇士岛"] = "Qw,绝尘",["埃霍恩"] = "Qv,贼嗨戝",["海克泰尔"] = "Qv,一个过客;Qu,多练;Qr,一眼星河,左手骨折,无效的昵称;Qo,童阿梨;Qk,艾星鱼人领袖;Qi,紅曜石;Qf,天狂我就是我",["霜狼"] = "Qv,飛逸",["尘风峡谷"] = "Qv,汉之盾星彩",["黄金之路"] = "Qu,复仇之刃",["斯坦索姆"] = "Qu,Granhiert;Qr,暗夜丶破碎",["伊瑟拉"] = "Qu,李阳脚很臭;Qt,铭记于心丶",["加尔"] = "Qu,俄罗斯小肥鲤;Ql,伽内砂",["风行者"] = "Qu,Hellscythe;Qq,竹叶清风",["巨龙之吼"] = "Qu,没毛老虎",["试炼之环"] = "Qu,索林丶双刃剑,索林丶橡木剑;Qj,魔剑迦游罗",["阿拉索"] = "Qu,小小铭",["安加萨"] = "Qt,纳克萨",["血牙魔王"] = "Qt,Entice;Qq,Desweet",["翡翠梦境"] = "Qt,舞阳,幽猫;Qs,瓦伦斯;Qr,神圣領域;Qj,抽过的烟",["红龙军团"] = "Qt,落丶冰风",["羽月"] = "Qt,洛天依",["纳沙塔尔"] = "Qt,透明风",["达纳斯"] = "Qt,噬血梦之恋",["耳语海岸"] = "Qs,林克",["密林游侠"] = "Qs,电击治网瘾",["艾森娜"] = "Qs,法治之光",["诺森德"] = "Qs,Tamaru",["达尔坎"] = "Qr,血之幻想",["奎尔丹纳斯"] = "Qr,瓜子香",["巴纳扎尔"] = "Qr,忆悟;Qj,忆墨",["埃苏雷格"] = "Qr,崩弓子",["萨菲隆"] = "Qr,惟吾德馨",["哈卡"] = "Qq,田师傅",["踏梦者"] = "Qq,蓝初夏",["希尔瓦娜斯"] = "Qq,行露灬",["熵魔"] = "Qp,纯白小熊猫",["天空之墙"] = "Qp,Proudheart",["斩魔者"] = "Qp,插秧插錯",["利刃之拳"] = "Qp,泱洋氧恙",["耐奥祖"] = "Qp,放逐之刃",["燃烧军团"] = "Qo,水冰月喵塔;Qi,夜礼服咩佩",["阿克蒙德"] = "Qo,圣光忽悠尔等;Ql,天关破军",["哈兰"] = "Qn,智沫沫",["黑龙军团"] = "Qn,醋墨半生",["阿尔萨斯"] = "Ql,Yangie",["外域"] = "Qk,波多野结衣",["暗影之月"] = "Qk,多拉爱梦;Qi,舞麟萌主",["奥拉基尔"] = "Qk,大胸口;Qh,开心的大萝卜",["苏拉玛"] = "Qj,迷茫的蓝莓",["瓦里安"] = "Qj,迷茫的山竹",["瓦拉纳"] = "Qj,迷茫的圣光",["雷霆之怒"] = "Qj,楠珏夫人",["红云台地"] = "Qj,十七丶猎",["白骨荒野"] = "Qi,郁闷的神",["迦顿"] = "Qi,皓月聆枫;Qg,林深时见鹿",["蓝龙军团"] = "Qh,读条三十秒",["千针石林"] = "Qh,陈惠琳",["摩摩尔"] = "Qh,德过且过",["藏宝海湾"] = "Qg,圣光小锤锤",["提尔之手"] = "Qg,只是信仰而",["安纳塞隆"] = "Qf,贺贺",["风暴之怒"] = "Qf,卑微小号丶"};
local lastDonators = "飞翔的大老鼠-布兰卡德,星际小牛-狂热之刃,酸哥-巴瑟拉斯,禅师-影之哀伤,龙猫猫-伊森利恩,给我烙仨糖饼-主宰之剑,凯宇大人-???,大聪明丨-冰风岗,以德服亼-凤凰之神,天使长-罗宁,淡漠以对-主宰之剑,丶山大王-龙骨平原,女王死忠粉-凤凰之神,灬小海疼灬-凤凰之神,丶坚果-贫瘠之地,大马户子-死亡之翼,歌丶律-凤凰之神,隐官-冰风岗,欧德弗莱-狂热之刃,黑木碎蹄-提瑞斯法,Laker-幽暗沼泽,張公子丶-血环,贰湿兄丶-熔火之心,君雅小妹妹-伊森利恩,谦丶卦-迦拉克隆,姬如千珑-银月,Meryl-凤凰之神,诡术丿妖姬-无尽之海,可爱夕-凤凰之神,来日方长吧-安苏,午门三刻-安苏,九尾狐丶-无尽之海,動感回旋踢-洛丹伦,丶绾起梨花月-白银之手,恶行左岸-克尔苏加德,Xxlucky-菲拉斯,混吃的橘猫-白银之手,白羽丶-寒冰皇冠,Amzings-格瑞姆巴托,贝宝-雷斧堡垒,涩气头头猫-伊森利恩,黄皮耗子呀丶-死亡之翼,尔等不讲武德-凤凰之神,星屑的追忆-布兰卡德,影禄落橘里-塞拉摩,暮雨微光-国王之谷,一曳清风-伊森利恩,伟大的龟仙人-格瑞姆巴托,蓦山溪丶-艾露恩,摁倒踹脸-迦拉克隆,墨墨萌萌哒-凤凰之神,三鹿牛-奥斯里安,老老队长-血色十字军,阿丝匹琳酱-黑暗魅影,笑狂神-罗宁,丶露水-主宰之剑,嬲噻熊-灰谷,包宝宝-白银之手,咕神小喵喵-伊森利恩,小白兔-米奈希尔,单点碧螺春-白银之手,柒夏玲珑-影之哀伤,阿米达居-白银之手,聖灬幽哈-血色十字军,你家兔兔-凤凰之神";
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