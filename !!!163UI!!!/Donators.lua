local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["格雷迈恩"] = "Q/,落零星;Q7,毁灭号角;Qy,莫高",["燃烧之刃"] = "Q/,术小鱼;Q9,Rlieren;Q6,英俊如我,猛侽文在寅,巴达丨克,真魔人;Q5,牛牛小獵人,玛卞巴卞;Q4,输丿输,高恩妃,今天任务很重;Q0,柯基大帝;Qz,暴躁的凉白开,一襟花月,筱暖阳;Qy,老卡老卡,Libra",["无尽之海"] = "Q/,翊悬;Q+,慧者实乂橙,灬奶茶炖鸡灬,小原;Q7,小狐狸奶糖,Buffmageplz,黑桃白丝,沉水润心;Q6,别闹我有药,尐泉花阳丶;Q5,取汁有道,星喃,慕伊斯,猫鳓鳓灬旋律;Q4,贼认钱,卡布佳,Rnival;Q3,倾心;Q2,九尾狐丶,诡术丿妖姬;Q1,红叶铸流光;Qz,Icebe",["安苏"] = "Q+,只愿诗和远方,冰星心,北暝;Q9,九斤哥,牛德雅痞,莫有牙子;Q7,克里斯提利奥,糖姬科德,抽烟;Q6,有只喵叫妞妞,浊酒念红尘丶;Q4,顶缸;Q2,午门三刻,来日方长吧;Q1,水塔陈醋;Q0,華脩,寄蜉蝣于天地,圣光常伴吾身;Qz,叶落乄花雨黯;Qy,山崎宗鉴,一大包仙贝丶",["远古海滩"] = "Q+,牛啸天",["雷斧堡垒"] = "Q+,七色的魔法使;Q5,颠人砖头骨;Q2,贝宝",["白银之手"] = "Q+,雷德琪,回梦夜影,天空蔚蓝灬,这是女鬼,老王遛狗,清音梵唱,Penumbra,奶一次绿一次;Q9,异朮,月殇梦汐,光的颜色,灵之羽翼,天天想输出,Ksimer,欲明王,赫拉迪姆凉皮,怪贩妖市;Q7,Hillermas,泽泽,钢铎;Q6,萨神灬,感恩带德,火化先看骨灰,扬鸿赫铭,牧过不留人丶;Q5,圣宝,抖动的括约肌,Erys;Q4,初锻;Q3,Icemore;Q2,阿米达居,单点碧螺春,包宝宝,混吃的橘猫,丶绾起梨花月;Q1,悠扬归梦,耶夢伽得;Q0,目害目艮火柬,遇见你伏笔,不白忙,不合适;Qz,血小板丷,花与晴的流星,昂口田,霜奶萌萌哒;Qy,花生与酒,一罐冰镇啤酒",["主宰之剑"] = "Q+,夜尽丶辰曦,快进到退休;Q9,Openurmouth,无影之末;Q6,雪毛毛,不会说话的魚;Q4,夜幕狼叔,兴奋得煤气罐,凡与常,星空下第一法,咿呀咿嘿,癫狂丶天劫;Q3,雾染如墨,花泽香菜忄;Q2,丶露水,淡漠以对;Q1,给我烙仨糖饼,丶雪拥蓝关,楼榕剑;Q0,拈花把酒情狂,Amandam,徐锦江的粉丝;Qz,灬郁蓝灬,墨邱立,Cynric,Shadowfalls,收费奶,丶格调;Qy,古神,吉祥乂如意",["埃德萨拉"] = "Q+,灬阿猫灬,丨丶青衫未旧;Q9,皮皮小饭桶;Q6,蔡先森;Q5,丨默丶,普林特叽叽,夏小烟丶;Q3,黑黑丨的土,井井大魔王;Q0,熊灬贰,皮特德;Qz,矢心疯,天凡沉雨,晓之珀;Qy,游戏的大喵",["霜之哀伤"] = "Q+,眸中星河似梦,灿烂尐尐,今生为你舔,恰似童话;Q9,王彧,野人参;Q1,微焦的食物",["索瑞森"] = "Q+,雲影映暈;Q9,雲中锦書,好像很好吃",["凤凰之神"] = "Q+,壕运气,绮德丶;Q9,魔法丶,达柒丶,一天喝八杯水,砍人哥;Q7,寂寞续杯,章鱼法,葑芯绝爱,喵妙妙喵,灬骚瑞灬,愿你耗子尾汁;Q6,瓦拉几亚,噬光丶者,光头大牙贼,有钱就吃腰孑,青糖,檀黎逗,樱花薇柠檬;Q5,Comprehend;Q4,彼岸的回忆,爆头丶;Q3,如何遗忘,恭喜发財,羊你吃涮锅,奶牛桑,苏灬姗,你家兔兔;Q2,墨墨萌萌哒,尔等不讲武德,可爱夕,Meryl,歌丶律,灬小海疼灬,女王死忠粉,以德服亼;Q1,萬惡之靈,白爷丷;Q0,小尾巴不见了,殊茗丶;Qz,终极毒奶,妖刀可太帅了,似风没有归途,逍遥使,粉紅高压電,苏歌乁,黄瓜灬,沙雕爱狗,牧竖之焚,聖侊忽悠着你;Qy,米奈希尔大公,浪里个浪味仙,若影丶林,拉胯弟弟贼,不能叫我山鸡",["雏龙之翼"] = "Q+,Kej",["熊猫酒仙"] = "Q+,十公里,敗犬;Q9,追意,香菇難痩;Q7,幻之地狱;Q6,咕咕是只鸡;Q4,红红的梵嘻嘻,曾希萌;Q3,杨幂的初恋;Q1,我有我方向,蚊子吃西瓜;Qy,火烨炎焱",["燃烧平原"] = "Q+,Danaikz;Q0,疯狂的六总",["死亡之翼"] = "Q+,丷小眼迷人丷,盗口大重九,西柚茉莉茶丶,德抽大重九,手拿大重九;Q9,硬得痛,闪现爆石,冰摇檸檬茶,阿狸丶乔斯达;Q7,坂井灬泉水,壹碟花生米,柠檬灬猫语,莲藕炖排骨,逗比矮子,冰吻鱼丷,只做惩戒;Q6,柒言,无良丶,最后一只狐人,抬上龙椅,你不乖头打歪,咕咕丷,丷落青染丷,我真真是联盟;Q5,诗人的血液,球球就是球球;Q4,乐堡,沙塔斯卫士,云中大雕哥,一只猫貓猫;Q3,落青染丶,是果冻猫啊;Q2,黄皮耗子呀丶,大马户子;Q1,贼认钱,温蒂妮怒风,逝去的银弹;Q0,柚子君呀丶,是柚子君呀丶;Qz,山河予你,丷两根赖毛子,死灵嵐姬;Qy,加载失败,斑马苏宜",["加基森"] = "Q+,闹闹爸;Qy,冻肉丸子",["伊森利恩"] = "Q+,Redone,花花厷孒,北执;Q9,车车厘厘子;Q7,猎杀丶,叶子潼,懒懒空天猎;Q6,阿通;Q4,瞄准射击丶;Q3,我喜欢艾菲热,阿尔特尔,圣光老牛氓;Q2,咕神小喵喵,一曳清风,涩气头头猫,君雅小妹妹;Q1,龙猫猫,艾菲热,森曲魂音丶;Q0,花烛映影深,重乄樓;Qz,狸头有芽儿",["格瑞姆巴托"] = "Q+,哈啤穿肠过,梦扬天际;Q9,玉藻前丷;Q7,骑猪睡咕咕,人間小甜心;Q6,李老八恰牛肉;Q3,天市右垣十一,月炛;Q2,伟大的龟仙人,Amzings;Q1,粪坑潜泳;Qz,雲笙;Qy,糖绿绿",["布兰卡德"] = "Q+,欧丿二泉映月;Q9,会动的牛肉干,稀饭凉面;Q7,萌萌的法狗;Q5,尤巴;Q4,灵魂不守舍;Q2,星屑的追忆;Q1,飞翔的大老鼠,加我莫悲",["海克泰尔"] = "Q+,风中一头牛,猜心,心云;Q6,谦的皮皮,皮皮的谦;Q4,滚地翻大王",["血色十字军"] = "Q+,机车小迷弟;Q9,关伯兰还在笑,坚果别闹,飘风不终朝;Q7,临风,山河永慕,羊犀丶;Q5,枫丶闲;Q4,丷小哥哥丷;Q3,板栗,拔丝红薯,聖灬幽哈;Q2,老老队长;Q1,羽霖铃,桔子修成仙;Q0,泽塔;Qy,带带大冰龙,橙不二丶",["国王之谷"] = "Q+,江隂馒頭,极热,尝试切他中路;Q7,神眼猪老九;Q6,萬侑引力;Q5,随缘藏;Q4,升龙霸骑;Q3,嚣张的板砖;Q2,暮雨微光;Q1,叹为观止;Qz,九星战神龙尘",["末日行者"] = "Q+,小楼一夜趴啪,腹黑骑师;Q9,重庆火锅丶;Q3,贰四六柒,欧西给;Qz,何以清尘灬",["苏塔恩"] = "Q+,月影灬晨星",["试炼之环"] = "Q+,牛将军丶老刘;Q9,风吹半夏;Q4,振翅的阿昆达",["贫瘠之地"] = "Q+,Shaka,小末日,花丶雨;Q9,光明,Abukuma,夜照亮了夜;Q7,霰呀;Q6,百嘼凯多,紫洛辰,丶錦渋年华,呐你摇裤掉了,Calm;Q5,叫术爷丶;Q4,丘逼特,这不扯呢吗;Q3,王保保,萌德沐沐,丶坚果,鸭啦嗦;Q1,也曾海棠依旧,宇智波牛德华;Q0,元丶旦;Qz,信仰之子,丨沙砾丨;Qy,蓦然之间丷,入心,何田田,亡魂灬牧诗",["罗宁"] = "Q+,Sacrificed;Q9,远程施法;Q7,赤罪之瞳,天情;Q6,炎帝丶爕,如果爱忘了,椎名嘟嘟噜;Q5,赫琳;Q3,衝鴨,Miolov,欧达诺布莉耶,慕容晨;Q2,笑狂神,天使长;Q1,暮雪千岚;Qy,爱红红太好了,谢铃飞虫,Archmagic",["影之哀伤"] = "Q+,穿靴子的牛;Q9,瑾色依依,醒大王只吃肉,Vitaminy;Q7,Aeoles,五十毫米口径;Q6,一佛爷一,疏与云归,瑾萱不是醒醒,小总和,风暴守护者;Q5,酥比租比;Q4,阿斯顿丶牛丁,路过一个混子,吞哥真的猛;Q3,天降殺機,魔法少女喵;Q2,柒夏玲珑;Q1,禅师,灬张子修灬,超级咔咔罗特,星尘;Q0,炎焱,骚年冲钅,少林菲;Qz,我需要治疗;Qy,九黎丶龙",["阿拉索"] = "Q+,不语笑红尘",["法拉希姆"] = "Q+,Thatcher,Zarya",["克尔苏加德"] = "Q+,枪手哥哥;Q9,欧皇丶诺神;Q7,恒狱;Q4,夜风拂红尘;Q3,我是卖保险的,嘤嘤宝贝,绯雀栖蝉;Q2,恶行左岸",["丽丽（四川）"] = "Q+,飞花轻梦丶;Q7,果皮果肉果核;Qz,系豆",["风暴之怒"] = "Q+,似锦年华;Q3,秧歌姒妲",["寒冰皇冠"] = "Q+,法力残渣丶;Q2,白羽丶",["???"] = "Q9,夜行猫;Q7,暴烈灬猪皇;Q6,霓裳梅普露,丨太宰丨,打错停手;Q4,Einino;Q3,Ferfectlife,娜么可爱;Q2,凯宇大人;Q0,游德",["黑翼之巢"] = "Q9,逆天灬浅紫色",["时光之穴"] = "Q9,全冰十三分糖",["银月"] = "Q9,秋名山王居士;Q2,姬如千珑",["迦拉克隆"] = "Q9,除魔卫道,辛多雷葵司,飞雪飘飘;Q3,二爷丶蹲坑,迎风快滚;Q2,摁倒踹脸,谦丶卦;Qy,无聊也无橙",["菲拉斯"] = "Q9,缺德组上我;Q2,Xxlucky;Q1,暗灭",["玛里苟斯"] = "Q9,莉莉思",["回音山"] = "Q9,寻风梦月,瞎取命;Q1,小梦大半丶,烙丨印;Qz,Dala",["阿拉希"] = "Q9,神落",["千针石林"] = "Q9,残酷天使",["烈焰峰"] = "Q9,一箭风情",["冰风岗"] = "Q9,人间朝暮;Q7,无尘大师,欧皇诺克灬;Q6,自然生长;Q4,丶朝歌;Q3,灬無雙丶;Q2,隐官,大聪明丨;Q0,九歌乀;Qy,乐神降临,痕星丶",["阿古斯"] = "Q9,逆尔德阑;Q6,小逼跟我玩錘;Qy,素颜",["提瑞斯法"] = "Q9,太上老君;Q2,黑木碎蹄",["天空之墙"] = "Q9,奈茶爱原味",["龙骨平原"] = "Q9,昌乐西瓜丶;Q2,丶山大王",["萨尔"] = "Q9,殺灬無赦;Qy,Peachguard",["盖斯"] = "Q9,二玥红;Q0,小糖人",["迅捷微风"] = "Q9,熊猫人之谜;Q5,帅气的老大",["莱索恩"] = "Q9,炎魔之舞",["黄金之路"] = "Q9,胖胖,绵绵呀",["巫妖之王"] = "Q9,张富贵",["凯恩血蹄"] = "Q7,潜规则丶",["破碎岭"] = "Q7,迷茫的辞典,迷茫的麵包,迷茫的教主,迷茫的落叶,迷茫的陷阱,迷茫的橙子;Q5,月丫;Qy,假装炉石,假装增强",["奥特兰克"] = "Q7,丿笑里藏刀;Q3,挨打就完事了",["鲜血熔炉"] = "Q7,远坂凛;Q0,萨瓦迪卡丶汪",["沙怒"] = "Q7,熊熊圣火",["永夜港"] = "Q7,窥欲无罪",["地狱咆哮"] = "Q7,熘肝尖儿",["血环"] = "Q7,脑科李医生;Q5,荣耀挽歌;Q2,張公子丶;Qy,乐神归来",["伊瑟拉"] = "Q7,刘东霖",["达斯雷玛"] = "Q7,七海麻美",["加兹鲁维"] = "Q7,马赫雷斯;Q1,飘血",["巴瑟拉斯"] = "Q7,罪不可赦;Q1,酸哥",["奥拉基尔"] = "Q7,有尸必有德",["卡德加"] = "Q6,Claret",["艾露恩"] = "Q6,染指丶;Q2,蓦山溪丶",["战歌"] = "Q6,那个瞎子;Q0,小圣之助",["金度"] = "Q6,凯文老师",["火喉"] = "Q6,当厨子的司机",["洛肯"] = "Q6,八号风球丶",["艾维娜"] = "Q6,逐星者",["海加尔"] = "Q6,认怂保平安",["哈兰"] = "Q6,Raffaella",["哈卡"] = "Q6,小女丶狠潇洒",["月光林地"] = "Q6,悲画扇;Q4,灞汽测漏",["金色平原"] = "Q6,说好的幸福呢,艾琳丶霞光,故剑情深;Q5,Graz;Q4,风瘾;Q3,好灬好美;Qz,嗑瓜子儿",["月神殿"] = "Q6,红围巾狗头人",["阿比迪斯"] = "Q5,艾吉奥丶御风",["普罗德摩"] = "Q5,燃烧的鸡脖",["血吼"] = "Q5,选股能力",["甜水绿洲"] = "Q5,李丢丢;Q1,曙光",["图拉扬"] = "Q5,Israfel",["狂热之刃"] = "Q5,混打必爆;Q2,欧德弗莱;Q1,星际小牛",["幽暗沼泽"] = "Q5,大長脚;Q2,Laker;Qy,李玩儿,高粱吉娃娃",["暗影之月"] = "Q5,伊紗贝拉;Q3,彩色镯子",["利刃之拳"] = "Q4,丶萌骑薇娅",["阿尔萨斯"] = "Q4,猥琐的表情丶",["洛丹伦"] = "Q4,邻村的翠花妹;Q2,動感回旋踢;Qy,小奶猪佩奇",["石爪峰"] = "Q4,己巳丁丑",["埃霍恩"] = "Q4,洛嫣儿",["熔火之心"] = "Q4,大湿兄丶;Q2,贰湿兄丶",["古尔丹"] = "Q4,柠檬朗姆",["戈古纳斯"] = "Q3,只是;Qy,秋冷了月光",["瓦里安"] = "Q3,Madeinchina",["黑铁"] = "Q3,死从天降丶",["黑石尖塔"] = "Q3,贰月丶逆流",["伊利丹"] = "Q3,丨小饼干丨",["米奈希尔"] = "Q2,小白兔",["灰谷"] = "Q2,嬲噻熊",["黑暗魅影"] = "Q2,阿丝匹琳酱",["奥斯里安"] = "Q2,三鹿牛",["塞拉摩"] = "Q2,影禄落橘里;Qz,贰队那个戦士",["冰霜之刃"] = "Q1,南枝向暖;Q0,圣光铠;Qz,法力燃烧;Qy,全场最佳半藏",["玛诺洛斯"] = "Q1,丿灬璇玑",["恶魔之魂"] = "Q0,变后不洗手",["鬼雾峰"] = "Q0,汣纔",["雷霆之王"] = "Q0,致命攻击",["荆棘谷"] = "Qz,绿猴子",["奥达曼"] = "Qz,染小莫㐅",["梦境之树"] = "Qz,静谧哈桑",["暴风祭坛"] = "Qy,飞翔的黄金瓜",["阿格拉玛"] = "Qy,墓诗",["奥杜尔"] = "Qy,雪月韵冰茶",["永恒之井"] = "Qy,潍坊",["黑暗虚空"] = "Qy,望朦胧",["朵丹尼尔"] = "Qy,马奎斯",["奥妮克希亚"] = "Qy,迦陵晚"};
local lastDonators = "Penumbra-白银之手,梦扬天际-格瑞姆巴托,心云-海克泰尔,恰似童话-霜之哀伤,Zarya-法拉希姆,Thatcher-法拉希姆,灬奶茶炖鸡灬-无尽之海,腹黑骑师-末日行者,花丶雨-贫瘠之地,不语笑红尘-阿拉索,穿靴子的牛-影之哀伤,尝试切他中路-国王之谷,绮德丶-凤凰之神,清音梵唱-白银之手,小末日-贫瘠之地,老王遛狗-白银之手,Sacrificed-罗宁,北暝-安苏,快进到退休-主宰之剑,Shaka-贫瘠之地,牛将军丶老刘-试炼之环,北执-伊森利恩,慧者实乂橙-无尽之海,花花厷孒-伊森利恩,极热-国王之谷,极热-国王之谷,月影灬晨星-苏塔恩,这是女鬼-白银之手,小楼一夜趴啪-末日行者,今生为你舔-霜之哀伤,灿烂尐尐-霜之哀伤,天空蔚蓝灬-白银之手,江隂馒頭-国王之谷,猜心-海克泰尔,回梦夜影-白银之手,手拿大重九-死亡之翼,德抽大重九-死亡之翼,西柚茉莉茶丶-死亡之翼,机车小迷弟-血色十字军,风中一头牛-海克泰尔,欧丿二泉映月-布兰卡德,丨丶青衫未旧-埃德萨拉,哈啤穿肠过-格瑞姆巴托,Redone-伊森利恩,盗口大重九-死亡之翼,闹闹爸-加基森,丷小眼迷人丷-死亡之翼,Danaikz-燃烧平原,十公里-熊猫酒仙,Kej-雏龙之翼,壕运气-凤凰之神,雲影映暈-索瑞森,眸中星河似梦-霜之哀伤,灬阿猫灬-埃德萨拉,夜尽丶辰曦-主宰之剑,雷德琪-白银之手,七色的魔法使-雷斧堡垒,冰星心-安苏,牛啸天-远古海滩,只愿诗和远方-安苏,翊悬-无尽之海,术小鱼-燃烧之刃,落零星-格雷迈恩";
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