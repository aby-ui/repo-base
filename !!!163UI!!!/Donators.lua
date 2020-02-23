local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["格瑞姆巴托"] = "Md,天蝎法誓,箭羽枪缨;Mc,秘境小钢炮;Ma,虾鸡耳芒,黑骑邪皇;MZ,丶兰色丨海风,熊夭夭;MY,相泽琉香;MX,萨尓图,大牛二愣子,奶爸儿;MW,一醉三千秋丷,丨巅峰灬童话;MV,阿撒灬紫晨,苍崎柳丁,绾颜,空条徐伦丶;MU,血色漫歌,找心愿;MT,浪味小仙,彼时花未开;MS,伊利丨,牛德华丿;MR,奶凶奶凶嘚丶,懒敷敷小公主,塔蘭吉小公主;MQ,你的阿超;MP,小狐妮,Winslet,江西熊;MO,纯甄牛奶丶,一把枪手,离地三厘米,安娜丷,清风少年,胖胖嘚文哥丶;MN,宣武永存丶;MM,忘了所有公式,悄悄抱着你;ML,王大勺;MJ,小白白就是我;MI,Aghora",["伊莫塔尔"] = "Md,冉丶;MY,繁华三千丶;MW,花销魂妥协",["影之哀伤"] = "Md,熊猫骑骑,你的骑士,孤独的爵士;MZ,跑步机,舔狗专业户;MY,缥缈熊猫;MU,何求苦;MR,可小白,丶山新;MQ,裂地神牛;MO,梦惊婵巛;MN,青龍灬贰爺;ML,阿尔托丽雅;MK,飞花丶",["贫瘠之地"] = "Md,霜麟,燚龍;Mc,两室一厅,冬柏;Mb,牛肉小面;MZ,清梦压星河丶;MY,灬沫霞灬;MX,Astella;MW,葫芦游弋,娜影;MU,紫源墨韵;MT,浪骚贱的土豆,轩辕龙傲天,有味清欢;MS,天知遥,灬孤雨寒烟灬;MR,太阳伊布;MQ,涯枭的魔猎;MP,别薅我头发,灬尛霞灬;MM,舞杀,涯枭的猎;ML,霸气丨豪门,白羊座灬若涵,洛丹沦的夏天",["死亡之翼"] = "Md,电竞范德彪;Mc,碧瑶公子,小凡公子,蓝帆;MZ,修不同丷;MY,青灯渡佳人,纲手婆婆;MX,五千多个奶妈,星軌,黄瓜充饥吧;MW,扶丁,孤独随我;MV,灭龍,猎心者丶;MU,深情不复,荔林神,Markvi,汤大包;MS,陌笙灬,神乐花火,禾子同学;MR,突破極限,宫泽礼,未央啊;MO,妄念啊;MN,Dk,二一二;MM,爱上耗子的猫;ML,嗳人丶,创世;MK,一包面巾纸,阿扶扶;MJ,茶叶蛋布偶;MI,大鱼乄",["末日行者"] = "Md,颠覆你的高傲;Mb,重庆小面丶;MW,全无才思;MV,殇之挽歌灬;MN,琉璃洸,哦丶法克;MM,你看着很美味,凌波微布;MI,我闪了",["暗影之月"] = "Md,过往的一只;MO,辉煌圣光闪耀",["燃烧之刃"] = "Md,啵啵咚叭啦,红桃十九;Mc,茨木華扇,骑骑丶,阿板丶;Mb,可爱的大咕咕;Ma,影子煜昊;MZ,观月,梨酒儿;MY,芒果记忆,娇花婆婆,迫击泡;MX,人生若梦,丿瓦莉拉乀,乐坨,灬酱子,丨紅尘烟雨丨;MW,空气清新;MV,狩猎幻影,新鮮的肉,子熊丶祈福桐,灬阿猫灬;MU,Batrii,丨丶空车;MS,暴燥的五花肉,司丽丽;MR,哎丨曰后再说;MQ,团长想害我,野生西瓜君,毛毛丶雨;MP,萨尔大帝,快乐小周,黄汤灌汝口;MO,大雨,博吉尔灬莫瑟,丨半泽直树,Bloodrex,星语梦綾,杰尼龟丶丶;MN,萌宠饲养员;MM,Jesiy;ML,软儿梨,三界,扶尸,禄卢;MK,淡淡冰语,無她,泰岚德丶怒风;MJ,卤面条;MI,好软好舒服",["符文图腾"] = "Md,鼎鼎丶敲可爱",["狂热之刃"] = "Md,临冬城艾莉娅;Mc,婧灬主任;MR,更美好的幻想;MP,收二手彩电;MN,大煎饼铺子;ML,布兰爱睡觉;MI,Pramanix",["熊猫酒仙"] = "Md,Pepperziegle;Ma,越谷;MY,小脑斧灬;MW,君之吾所系,大坏蛋;MQ,道痴叶红鱼,蒲以嘟;ML,盐与香辛料;MI,大菠菜",["迅捷微风"] = "Md,利威尔阿克曼;MX,莫小漠;MO,依然杜哥;MN,丶龘將",["寒冰皇冠"] = "Md,阿肥;Mb,梦境之末",["白银之手"] = "Md,素颜双马尾;Mc,李羊;MZ,渔得鱼,血染斜阳红;MY,季艾沐巳唛,达娃栗波波莎;MX,綪風,蜜丽娅,塔瓦安娜,虚空一一闪耀;MW,过忘川;MV,辛运的哪托丶;MU,Aelia,赵正行,刹那灭却,犼沥邪;MT,极渡恐慌丶;MS,安眠藥,核桃空空;MR,祈梦星;MQ,坠落幻想,王大车,玛丽贝贝尔,小德雅,奥尔邪邪雅;MP,可耐,车头你不配丶,丶百变星君丶;MO,七彩熊,持度,元宝的姑奶奶,若即若离,干净;MN,爱新觉罗梦,怪只打队友;MM,维他什么奶;ML,爸爸粑粑,坠月之歌,左手舞冰火,陌风;MK,青衫丶白衣,巧楽兹,浩小劫,牧之白,艾尐希;MJ,治療,飞奔的凯撒",["安苏"] = "Md,Lokig;Mb,可爱丿小娘子;MZ,Miaomiaowow;MW,白魔法女,荣耀宇智,方生,兄弟来一箭;MV,奥拉奶丶,生浮色墨丶,Alviero,把肉拿来,明影者;MT,妩媚又风骚;MS,十八點五,胡同里的貓;MR,戒吥掉丶,丿丶圣光,感受虚无,落雪夏觞,丶孙燕姿,丨莉莉丝灬,雪萤折鹤;MP,鏖战镇魂曲,陌生人丶;ML,卧龙武帝丷,柠檬酸呀酸;MK,桃花朵朵儿",["阿古斯"] = "Md,藝達晟;MX,脆皮香蕉;MU,瑞宝带我打游戏;MO,冬天猫",["丽丽（四川）"] = "Mc,战神尤朵拉;MY,骚的鸭匹;MX,柒丶筱囡;MW,戎州狐一菲;MV,暗傷;MS,泡泡人;MR,吾在我;MO,那些遗失的梦,李知恩丶;MK,龙梅尔;MJ,厨子丨",["主宰之剑"] = "Mc,萨哒牡;MY,砂鍋豆腐,Flandlo;MX,柔情美汐;MW,紫罗兰的复仇;MV,橙皮酸梅;MS,简宁,椛間壹壶酒,北丨境;MR,徵羽丨,战吼奥丁丶;MP,巪石丶强森;MO,只要半糖丶;MN,美女轻点;ML,那小子真逗;MJ,那小子真猛,那小子真狂",["血色十字军"] = "Mc,落小凡,猪哥的圣光,无夜丶,小叮猫,冰淇淋萨满,冰淇淋踏风,冰淇淋牛战,雪缤纷,冰淇淋战刃;Ma,睿小宝,丶絶;MZ,奶茶仔,航丶咆哮地狱,Cárnage,Noirsakura;MX,尤朵拉船長;MW,宇宙骑士;MU,李元霸丨,惩戒之箭丶柒;MT,乸西熊猫;MQ,飘逸的大胸毛,高里卡布列夫;MN,豆子鱼;MM,Korhal;MK,梧叶笺;MJ,嘟哒哒冒蓝火;MI,鸡肉石锅拌饭",["凤凰之神"] = "Mc,邓超,微笑的泰丽莎;Mb,如歌嘹亮,情巅紫殇,Santafan;Ma,神秘的箱子;MZ,报纸,Ucc,Fcc;MY,月下丶的哥哥,打嗝海狸;MX,丨小小柒丨,Mogulkahn;MW,教堂之枪,心之逸,开个桌子;MV,懒蛋儿,恢复图腾;MU,福角,安娜丷,Solay,丨恭喜發財丨;MT,十三菇凉;MS,火玫丶,轻点我怕疼;MR,丷槑槑的善若,如何回忆妳,康納麦格雷戈,小丶尾,十方霞涌;MQ,锦鲤乁,树熊鸟猫鱼;MP,兔子追猎者,堕落灬夜殇,繁华灬落幕,柠檬红丿;MN,汤尼与兔子;MM,Potency,丷小豆浆;ML,来世再续前缘,白鱈鱈,鑫灶沐炙;MJ,一奶奶,揪啾啾,氷月風華;MI,清艾",["血环"] = "Mc,猴子请的逗笔;MY,爱德华;MQ,云雾散;MO,墨鸦",["无尽之海"] = "Mc,二十三号元素,普通的阿昆达;Mb,春风十里丶丶;MZ,君语;MY,馋你的身子;MW,爱跑步;MV,不逊文风;MU,梦幻小天宇;MQ,蒜香榴莲,风暴灬之魂;MP,乱世冷风,跑者;MO,粗野;MN,大萌斌仔;MM,徐大骚;MK,大梦斌仔,人參菓",["伊利丹"] = "Mc,刑事组曹达华;MZ,死亡莲华丷;MO,發財兽",["龙骨平原"] = "Mc,纳豆加葱;Mb,暴走的格布林,六月的猴儿;MQ,汕水有相逢;MK,怒海狂明",["格雷迈恩"] = "Mc,灬渔灬",["阿纳克洛斯"] = "Mc,黎明清风;MZ,沃德天;MK,暴躁外皮",["埃霍恩"] = "Mc,再战十年",["安其拉"] = "Mc,冲锋踩香蕉",["菲米丝"] = "Mc,小魔猩;MR,治疗别奶我;MO,Doge",["布兰卡德"] = "Mc,犬来八荒;Ma,短吻喵;MY,Greatdruid,壹巴掌呼死伱;MS,炫酷灬肉粽;MQ,猛面小蕉蕉;MO,有一点性感;MN,丿陌陌彡;MM,盗賊;MJ,Artemisr",["克尔苏加德"] = "Mb,盗禧;Ma,夏末耳语;MX,画包上的老猫;MT,飞翔的葡萄;MS,新手卖萌",["破碎岭"] = "Mb,小卷卷;MU,雨师妾丶;ML,傲娇的小圆手",["伊森利恩"] = "Mb,孑琊,油腻噶;Ma,奎爺;MZ,梓殇,柚子柚子、,柚子、柚子,炎虎姬;MX,孤傲的君,小白兔丶奶糖,懒蛋儿;MV,灬子儿灬;MT,赤血,思舟丶;MS,楚地无歌;MO,Mujn;MN,萌萌的尐熊猫;MM,柒柒肆;ML,一颗闪耀的仔,不会不练;MK,灬梧桐、;MI,墨雨纸鸢丶",["金色平原"] = "Mb,茶顏悅色;MX,奥古迪姆;MT,难顶小豆丁;MR,煞窦布惠;MN,神丨智勇,彼得诺夫;ML,男人就玩藏剑,蕾娜丶月歌;MK,瓦捷特",["塞纳留斯"] = "Mb,春风沉醉;MY,Mageey",["萨格拉斯"] = "Mb,连若菡;MY,消失的暗影",["罗宁"] = "Mb,咪法,卤鱼宴,Leserein;Ma,红岸基地;MZ,一颗幸运星;MX,犄角小龙人,同菓酱,喵嗯;MW,瞬风丶猎刃;MV,从小就很善;MU,丈八大蛇矛,一白二穷,Phoenix;MT,潘多哥斯拉,Okiatsu;MP,何欢,爱哭的胖纸;MO,红昭丶愿;MN,不锈钢键盘;MM,炭烤胡子,小猪猡,爱哭的胖子灬;ML,地狱丶圣光;MK,佩劍高歌;MJ,苏青丝;MI,暴走的大臭",["德拉诺"] = "Mb,Lappe;MZ,我已没有眼泪",["国王之谷"] = "Mb,倒吸一口凉气;Ma,和谐平等自由;MZ,温暖终年不遇;MY,、酩酊,得过小红花,大章鱼哥,枫之可乐;MX,安丶小希;MW,夜眼,风评被害;MV,欧皇岁月;MT,隔壁老橙;MR,幕乡;MQ,夜弦朝歌丶;MP,月满星怒;MO,胖胖嘚文哥丶;MN,麦迪娜;MM,唁风,疯瘤涕躺;ML,董老湿;MJ,裴老湿",["洛萨"] = "Mb,梦中慧眼识君",["太阳之井"] = "Ma,丨洛林;MQ,路飛",["埃德萨拉"] = "Ma,泰钽小术;MZ,天上的棉花糖;MM,卖酸牛奶的;MK,Holyhearts,遗忘的守卫",["???"] = "Ma,太阳进华沙伯爵;MX,狐丶爷;MW,箭羽枪缨;MV,阿良丶;MU,丶笑魇無她;MT,火眼洛斯",["回音山"] = "Ma,玄玄;MW,尘影;MV,艾泽拉司基;MU,阳大人;MR,战寒热;MQ,海鸣威;MP,城南忆梦;MM,貊幽;ML,住在大菠萝里;MK,苏两七",["熵魔"] = "MZ,疯人院的恶魔",["艾露恩"] = "MZ,劍八",["月光林地"] = "MZ,青峰总攻",["迦顿"] = "MZ,十三叔;MR,菠萝催血",["时光之穴"] = "MZ,霁无暇",["雷克萨"] = "MZ,桀骜不驯",["诺兹多姆"] = "MZ,走芯;MQ,璀璨的薛迪凯,璀璨的武僧;MN,丨暮雪丨",["千针石林"] = "MZ,小烂芒果;MS,暴走枪手",["冰风岗"] = "MY,一个圣騎士;MX,荒原丶丶;MV,国药准字贰号;MU,尧兆;MP,肥喵爱吃鱼,穆丨偶,萌萌奶萨,听风的歌,银月小茉莉,露露柠檬,Iupl;MO,初号肌丶;ML,小红馒头灬;MI,腐蚀漫天",["燃烧军团"] = "MY,最爱塔塔酱;MQ,女寝的男鬼",["红龙军团"] = "MY,无暇人生,玩尽杀绝;MR,Anathan;MK,無形中狠蒗",["麦姆"] = "MY,公仔面二十蚊",["黑铁"] = "MY,黒丶角;MQ,黒丶脚;MN,沐阳爸爸",["冰霜之刃"] = "MY,职业喷子;MW,强健的阿坤达;MM,Asmenethil",["巫妖之王"] = "MY,尹圈圈;MW,四块五的妞",["霜之哀伤"] = "MY,阿梨酱;MX,一减速度交;MU,糖兜里有糖糖;MQ,旧顏色;MK,不知所以",["奥蕾莉亚"] = "MX,没事",["蓝龙军团"] = "MX,筱樱",["玛多兰"] = "MX,蛋啦啦",["轻风之语"] = "MX,皇家小法,夏目美绪;MT,复仇女神;MP,牧里鱼;MJ,星夜绫",["雷斧堡垒"] = "MX,萨小曼;MO,薄凉尽昏晓",["月神殿"] = "MX,宫园薰,希兹克利夫",["阿格拉玛"] = "MW,紫灬瞳",["密林游侠"] = "MW,地狱来的牛",["幽暗沼泽"] = "MW,你跟猪一样",["伊瑟拉"] = "MV,喵喵熊",["萨菲隆"] = "MV,欧洲的阿昆达;MM,Dk",["巴纳扎尔"] = "MV,赤焰",["熔火之心"] = "MV,艾利西亚;MO,北新桥砍刀王;MK,冲锋释放鬼才",["奥拉基尔"] = "MV,卡其布诺灬",["遗忘海岸"] = "MV,可爱的女孩子;MJ,恐怖钕主角",["利刃之拳"] = "MV,北翎刀",["菲拉斯"] = "MV,伍老虎",["埃克索图斯"] = "MU,老骑士铛铛",["黑翼之巢"] = "MU,狗大帥丶",["血吼"] = "MU,上帝的丫头;MQ,萧瑟勿语",["阿尔萨斯"] = "MU,阿芙洛狄斯丶;MT,爆炸虚驱",["安纳塞隆"] = "MU,冰霜凛冽",["日落沼泽"] = "MU,贫道法号抠脚",["迦拉克隆"] = "MT,Jolyan,沒那么简单;MP,馬忠賢;MO,安薇娜",["拉文凯斯"] = "MT,肛灬烈牛,蓝色马蹄莲",["海克泰尔"] = "MT,丶边牧;MN,请带暖树上车;MK,Moulin,浮生諾夢;MJ,左手的阴暗",["永恒之井"] = "MT,脑勺",["塞拉摩"] = "MT,一场雾;MO,凯尔希钢蛋;MM,虐弑",["巴尔古恩"] = "MT,猫咪小小",["迦罗娜"] = "MT,谪仙逸恋音瑶",["神圣之歌"] = "MT,妞奈蜜柚可",["诺森德"] = "MT,元気蛋",["蜘蛛王国"] = "MS,小呆立",["万色星辰"] = "MS,混子丶",["山丘之王"] = "MS,罗诺比;MP,凹粑马",["莱索恩"] = "MS,香啵啵;MO,Tianna",["梅尔加尼"] = "MS,兔子的绒毛",["石爪峰"] = "MS,潆澈;ML,不老峰传人",["晴日峰（江苏）"] = "MR,乄丶丶龘丶",["麦维影歌"] = "MR,丨丶丨丶凹凸",["玛里苟斯"] = "MR,百特曼;ML,秘制小龙虾",["暗影议会"] = "MR,紫慯",["基尔加丹"] = "MR,阿娣",["风暴之鳞"] = "MR,Breezee;ML,鹌鹑丶莫扎特",["亚雷戈斯"] = "MR,伊利安丶逐曰;MO,文体两开花",["远古海滩"] = "MQ,阿历小妖静;MJ,张楚岚;MI,空城丨旧梦",["壁炉谷"] = "MQ,關我屁事",["甜水绿洲"] = "MQ,茶里荼靡",["阿比迪斯"] = "MQ,萨利休斯;MI,光阴荏苒",["巨龙之吼"] = "MQ,库库噜,库噜噜,库噜库噜",["通灵学院"] = "MQ,馥芮白;MJ,蔡徐坤丶",["扎拉赞恩"] = "MP,不明觉厉丶,不明觉厉;ML,Atanvardo",["鬼雾峰"] = "MP,乂戰宇乂",["翡翠梦境"] = "MP,Passerby,我没有远方;MJ,黄泉引路人",["风暴之怒"] = "MP,贼灬",["戈古纳斯"] = "MO,摇曳的胡椒,燃烧的胡椒",["加基森"] = "MO,一伙大家伙",["斯克提斯"] = "MO,不要捣乱",["尘风峡谷"] = "MN,护短",["古加尔"] = "MN,疯狂情话;MK,单程车票",["麦迪文"] = "MN,小姐不美;ML,口子",["卡德加"] = "MN,裂魂丸",["守护之剑"] = "MN,小夏夏",["萨尔"] = "MN,Bruce",["血顶"] = "MM,丫丫小猫",["阿克蒙德"] = "MM,调皮的恩佐斯;MI,娜尔莉",["羽月"] = "ML,饭时已到",["奥特兰克"] = "ML,星月丶丶;MK,小钱钱真心甜",["夺灵者"] = "ML,很纯很暧昧丶",["藏宝海湾"] = "ML,暗落",["桑德兰"] = "ML,肌肉帕尼尼",["地狱咆哮"] = "MK,鬼吇丶",["海达希亚"] = "MK,小样贼逗",["激流堡"] = "MK,孟女",["冬泉谷"] = "MJ,一秒的刹呐",["血羽"] = "MJ,戦士奉先",["亡语者"] = "MJ,符华上仙",["火焰之树"] = "MI,傲娇管四舅",["奥妮克希亚"] = "MI,夜半私语时丶"};
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