local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,释言丶-伊森利恩,空灵道-回音山,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,不要捣乱-贫瘠之地,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯,戦乙女-霜之哀伤";
local recentDonators = {["格雷迈恩"] = "Fs,Monkee",["熊猫酒仙"] = "Fs,追逐九号球;Fr,飘逸贝贝,幽梦鹊花鹃;Fp,葱拌豆花;Fo,黑铁矮子;Fn,未丶来,雾丶漓;Fm,拒绝鱼;Fl,剁椒人头;Fk,熊大的西兰花,無敵劉;Fj,一江泪,有梦想旳咸鱼;Fi,Tuulani,笔直的烟斗,Prisoners,丶彭于晏丶;Fh,丫哥卖假药,西西弗斯丶,名侦探喵美;Fg,撕裂信仰",["迦拉克隆"] = "Fs,Lionkk;Fr,弑神武帝;Fo,Odanobunaga;Fm,承影;Fj,羞羞萌萨,河马君;Fi,小彤酱,天降正丶额啊;Fh,忽悠你啥了,Averager,大抱歉牧,山丘之傲;Fg,Ambrosed",["白银之手"] = "Fs,银鞍照白馬,清心的劣人;Fr,嘤嘤鱼,疯花生,灬哆哆灬,Fovdkt;Fq,小傻瓜月牙,聖米迦勒,宝强稳住;Fo,吾辈为何而战,死人无需多龉;Fn,火的冰点;Fm,安吉丽娜茉莉,娇兰魂魄,艾丶娜;Fl,李轻候,流鹦,皇家凉粉,蘭兮;Fk,萌若曦;Fj,谷二担,笑靥如花灬,胖仔真可怕灬,半条腊肠,薛定谔的咕,丶醉别西楼;Fi,然倾照月空,小禹丶,吃不胖包子,凉墨丶,肥宅快乐绿,悶声发大財,浅墨夏殇,读条带走青春,雪岷,原梦之猎;Fh,多多是欧皇,咪七甘八卦,朵拉丶风行者,瘦蛋儿,狮王之傲旅店,欲灬沉香;Ff,琳菀",["奥尔加隆"] = "Fs,北白;Fn,芯灵儿,星落如雨;Fh,光泡泡;Fg,奥利奥可爱多",["贫瘠之地"] = "Fs,冰封的冷漠;Fr,暖暖的回忆,隅野沙耶香,灬哆哆灬;Fq,霰丶,闇丶影,汽水糖児;Fo,Quella,大石头之石,汽水糖兒;Fn,滋瓷董先生,天然维生术;Fm,酒鬼丶废物牛,仲夏夜的星星,我是猫妖妖喵;Fk,素年大欧皇,青丝渺渺,Asurin;Fj,杨村长,堕落丨鬼魅,蹦哒的荣誉点,小袭;Fi,Savy,黑峰小哥哥;Fh,凊凉,汰渍净白去渍,早苗,感恩朋友,不要捣乱,平静的杜王町,早上好丶,黑椒牛肉丸",["凤凰之神"] = "Fs,一缕散暮愁,哦耶哦买噶;Fq,七月七夕,吴名是;Fp,和平丶;Fn,霜月之怜;Fm,Staub,格格的欢乐谷,理想瞎;Fl,刺激寻欢客,铁血娃丶,紫广,炽天使爱美丽;Fk,幺叁伍;Fj,宮脇咲良,曼巴飞舞;Fi,逆鋒扬血,烈酒醉猫,风月缱绻;Fh,小菇梁柒丶,炸天出征,戀夏,风油巾,祈祷落幕,贼胆专家,是十一月天呀;Ff,暗黑风暴",["安东尼达斯"] = "Fs,滴滴打滴",["死亡之翼"] = "Fs,丶凌晨㥆,秦风细雨;Fr,逆天猪,优秀的武僧,祝掌门吐血啦,布川一夫;Fq,放牛郎丶;Fn,Plmm,高配刘德华,二白天然呆,琥珀年华;Fm,Tomica;Fl,阿苍丶,豆花爱我,鬼佛,南辞北海丶;Fk,丨光老板丨;Fj,珈百璃的堕落,你上我掩护,折纸玉珑;Fi,泡泡小萌,邪恶排骨,迷路到你身旁,强击,发条丿橙;Fh,邓士载,炉中剑,无辜的大萌德,势如利刃,Senario",["主宰之剑"] = "Fs,季秋,淼焱丶;Fr,張少主,蒙头睡的书虫,自闭的弱鱼;Fp,飞洋灬;Fo,苍天一箭,阿蜜拉;Fn,丶贝戎灬贝戎,初丷夜,丨灭影之锋丨;Fm,陈希希,或翌;Fl,饭冈佳奈子,狩猎邪能,輝煌醉相思,躺恩,水晶胖胖;Fk,年年皆琐碎,黑麦咖啡;Fj,琉璃安然,丶思念初夏,蘸狼;Fi,战骑,烈火白羊,泡椒兔兔,冲释一体;Fh,咕喵酱,红胡子老大爷;Fg,杰哥威武",["萨尔"] = "Fs,伊利蛋努凤",["伊兰尼库斯"] = "Fs,Hawkeye",["灰谷"] = "Fs,梁朝伟;Fq,初宸;Fp,前所未见;Fk,没得糖就扯拐;Fh,一切爲了联盟,二郎显圣真君",["爱斯特纳"] = "Fs,愤怒的泡泡",["丹莫德"] = "Fs,焚书战神",["阿古斯"] = "Fs,元素圣灵;Fq,躺地板,爱晒大阳的鱼;Fn,小珂漫漫;Fl,猎血沸腾;Fi,豆丶丁,欧皇的秘密;Fh,焦糖土豆",["无尽之海"] = "Fs,女神张钧甯;Fq,捅过蛋总一刀;Fo,欧皇会武术,婲見婲開;Fm,有趣的小怪怪;Fl,婆娑双树;Fk,奶神张雨绮;Fj,免疫致盲瞎,Jumpsuit;Fi,毒液丶;Fh,冰封太子;Fg,灬唆了蜜灬;Ff,今晚吃鸡,鸸鹋丶",["梅尔加尼"] = "Fs,伊森亨特;Fn,灵魂抽筋;Fh,冽丶风",["埃苏雷格"] = "Fs,只道寻常;Fn,流火;Fi,绝对疯子",["丽丽（四川）"] = "Fs,Saintangle;Fo,亜古兽;Fn,小不不;Fm,丶阡陌丶;Fl,才死不久;Fk,不怕你哟,求求你别吃我;Fi,楠楠酱",["???"] = "Fs,甲基苯丙;Fm,钟丽无艳,伊莉雅丶怒風;Fk,星辰禹王;Fj,凡妮莎灾歌,误入奶门",["龙骨平原"] = "Fs,Dps",["试炼之环"] = "Fs,奔跑的糍饭糕;Fo,霜之语彤;Fj,天丶崖",["加里索斯"] = "Fr,橙皮酸梅",["影牙要塞"] = "Fr,橘貓皇吾;Fk,云宫迅音;Fi,间和之光",["烈焰峰"] = "Fr,小乌龟啊;Fl,阔口阔乐;Fj,贰零壹柒;Fi,时间忘记,你的充气男友;Fh,七念",["奥蕾莉亚"] = "Fr,逝去的黑风;Fi,顾倾橙;Fh,慕雪蓝采薇",["影之哀伤"] = "Fr,燃烧卡路里丶;Fq,綽約多姿,夜若轻羽,丨竹叶青;Fn,忘尘客;Fm,貌似妖怪;Fl,哎丶脑阔疼,河马灬,小丶骚猪;Fk,月儿彎彎,御风只影游,康乐;Fj,紫夜幽冥,孤雨寒烟;Fi,朱弦断明镜缺,清极不知寒,钰纾格格,土豆炖牛排,绿茶味可乐;Fh,静水蓝蝶,敏捷的阿昆达",["亚雷戈斯"] = "Fr,狗鸭蛋;Fq,你耶耶突然;Fk,Rascal;Fh,化野红绪",["罗曼斯"] = "Fr,南夏奈;Fp,星白闲;Fh,临风望抒;Ff,虔诚的单手剑",["夏维安"] = "Fr,肉炒电线杆丶",["提瑞斯法"] = "Fr,零六水鱼",["燃烧之刃"] = "Fr,斷劍陰盜言;Fp,兔子软贝特丶;Fn,糖葫芦蘸腐乳,不疯何以成魔,青菜叉烧包;Fm,嫂子请住嘴,弛格阁;Fl,图丶拉丶杨,膜法少女全蛋;Fk,聖羽之誓;Fj,光明大祭司,米酱;Fi,亲幂无间,我有八倍镜,拼命三郎赵四,洪珉绮,Smileycola;Fh,Polariis,面纱丶,好想羊只咕丶,潶澀灬小妹",["安苏"] = "Fr,威士乄忌;Fq,Junriver,那个水法;Fo,莫尔丶;Fk,Tyrionchen,刀鋒舞者;Fj,郑天荫,郑天佑,郑天勇,淡忘灬忧伤;Fi,蓝莓哦,尼古拉丝铠骑,古索,帅霸霸丶;Fh,|翊恒|,当歌惊鸿,牛将军丶老刘,成无情;Ff,怪味狐臭,心静自菩提",["埃克索图斯"] = "Fr,灬阿猫灬",["海克泰尔"] = "Fr,姒妖;Fp,怕吉,小心我打你哦;Fl,玲迪斯;Fk,捡垃圾的旺财,预估的;Fj,快乐炮王丶,谁的益达",["伊森利恩"] = "Fr,北冰洋;Fq,你耶耶突然;Fo,非酋猎魔丶;Fn,素雪飘零,不拉怪的坦;Fm,凛冬来袭,Sixthmilk;Fl,Marnie,居延烈酒;Fk,壊比,莫迪亚铁之眸;Fj,夜雨语,星如海,Vingsanity;Fi,晨星丶,Noirsakura,惊羽乄,夕月夜;Fh,弥黯,諾夏,逗牛洋芋儿,丨那夜丨;Ff,那乄夜",["银月"] = "Fr,神之利牙;Fh,不甜",["霜狼"] = "Fr,Fayditachi",["埃德萨拉"] = "Fr,Arthasgrw;Fo,神话无限;Fj,凡尘之间;Ff,白夜阑珊,公巴佩丶",["破碎岭"] = "Fr,鹤命;Fq,迷茫的炭烧;Fi,安息蛇,你们真无聊,網瘾少鲶;Fh,老歌;Ff,慕行",["冰霜之刃"] = "Fr,汗圆焚尸手;Fn,蔚芊月;Fj,为萌妹坦怪;Fg,今夜我唠叨了",["国王之谷"] = "Fr,太湖雪;Fo,妇女;Fn,那个灬男人;Fj,咸蛋路人甲;Fi,插棍专家丶,穆穆寒雪,欧皇麦兜;Fh,敲你丫的;Fg,红丶小白",["血吼"] = "Fq,卡卡德鲁",["洛丹伦"] = "Fq,戦將;Fm,喵小飒",["安纳塞隆"] = "Fq,双马尾",["斩魔者"] = "Fq,东东丨枪,东东丶枪;Fi,滕大宝,花泽野菜",["暗影之月"] = "Fq,莉娅苟萨;Fi,雪毛毛,灬地狱男爵",["末日行者"] = "Fq,丨简丶单丨;Fp,名流之恋;Fn,虚空豆沙包,胡桃夹子呀丶,晚睡;Fl,醉后战意;Fk,北子,誓言丶;Fj,茶米茶丶,扶弟魔丶,章较瘦;Fi,剑过无痕,迈达斯的手;Fh,墨竹青衫,圣光的正义啊;Fg,卧梅幽聞花",["金色平原"] = "Fq,冰镇冰冰猫;Fn,Bearkun;Fi,你丑没事我瞎",["格瑞姆巴托"] = "Fq,爱吃火龙果丶;Fp,清雨潇寒;Fo,猕猴没有桃;Fn,兎兎丷,天无羡丶魁星;Fm,别杀小朋友;Fl,一霓烟火;Fj,轻轻灬魅儿,蓝妖王,灬滚好么灬;Fi,圣域余晖;Fh,圈圈丶二意,怀中抱妹殺丶;Ff,丶暖小若",["风暴峭壁"] = "Fq,有黑眼圈多好",["罗宁"] = "Fq,菊花芬外香;Fp,欣喵酱,忻喵酱;Fm,奶妈一枚;Fl,清酒溯空,薄荷梗,Eoi,龍吟灬信仰;Fj,斯坦索姆,血色之石,最爱冰美式,天狼星月;Fi,晨煦,虎千代,泽风漂缈,小屁莎莎,没人要的玩偶;Fh,有爱有高潮",["幽暗沼泽"] = "Fq,丶麒麟;Fj,大寶貝哟;Fi,玉高惊魂",["亡语者"] = "Fq,我以为你死了",["血色十字军"] = "Fq,风骚喝糖水;Fm,卡米拉丶晨锋;Fj,丿丶魂魄妖梦;Fi,该用户被禁言;Fh,扬州奶多哦",["莱索恩"] = "Fq,遇朮临疯",["苏塔恩"] = "Fq,壹灯;Fm,雪断桥",["瓦拉斯塔兹"] = "Fq,Evolution",["回音山"] = "Fq,落寂天星;Fp,風中縋楓,夏沫灬小米;Fo,残灰飞;Fn,术手灬无策;Fl,初凉亦夏;Fk,一公分,Fgthus;Fj,Ashleynamay;Fi,圣光原谅了我,喵筱筱",["勇士岛"] = "Fq,奥多芙",["燃烧平原"] = "Fp,灬锯齿灬;Fo,清净;Fl,MuseScore;Fk,Shadowwithme;Fh,Horrorsword",["诺兹多姆"] = "Fp,Whitley;Fh,Seelasslgo",["万色星辰"] = "Fp,巫行云;Fh,花落满肩",["杜隆坦"] = "Fp,灵小溪",["寒冰皇冠"] = "Fp,Reclusive;Fg,范海訫",["克尔苏加德"] = "Fp,荧丶惑,何曰是归年,何曰是来年;Fo,Summero;Fk,醉乄;Fj,小蚊子丶;Fi,滑头老榴莲;Fh,一米两个球,五个图腾,血窝窝头,丿开嗜血灬;Fg,Ainzooalgown",["艾萨拉"] = "Fp,师承冠希;Fj,Hank",["布兰卡德"] = "Fp,富贵牛牛;Fl,狂徒真的垃圾;Fj,苏烨;Fi,酷酷小超超;Fh,碳烤咕咕",["守护之剑"] = "Fp,风暴祭司;Fm,阿瓦隆之手",["梦境之树"] = "Fp,阿弹;Fj,温情的向向",["鹰巢山"] = "Fp,九五二七;Fl,霜之牛牛",["菲拉斯"] = "Fp,盾之朽木;Fn,木头一号;Fk,娜拉贝尔;Fi,嗜血贼叔叔",["鬼雾峰"] = "Fo,我张嘴你张腿,布鲁布鲁布鲁;Fi,甘大大,知我相思苦,Mistakey;Ff,山石大哥",["泰兰德"] = "Fo,墨梦;Fm,艳射",["阿拉索"] = "Fo,Jalic;Fk,虚构小说家",["冰风岗"] = "Fo,星瓴,欧帝一身溙坦;Fn,丶锋痕,美股提款机;Fl,柒丶喜;Fj,这是谁的,重装城管;Fh,蓝色空闲;Fg,路灯披橙",["双子峰"] = "Fo,下水道职业丨",["玛洛加尔"] = "Fo,胡小悦;Fj,流水如云",["洛萨"] = "Fo,重拾荣耀",["熔火之心"] = "Fo,Felicis;Fn,瑟莱德絲公主,傻傻爱着",["永夜港"] = "Fo,带狗撩妹;Fj,六破",["末日祷告祭坛"] = "Fo,一树海棠丶",["古尔丹"] = "Fn,你好缺德吗;Fl,骚粉丶;Fh,丨风雨飘瑶",["麦姆"] = "Fn,Olia",["荆棘谷"] = "Fn,比卡丘爱吃鱼,新来的奶德",["霜之哀伤"] = "Fn,安逸圣君;Fj,亚瑞特之怒",["血之谷[TW]"] = "Fn,生受罪死带角",["雷霆之王"] = "Fn,六季稻;Fj,圣光之锤",["森金"] = "Fn,板儿砖出奇迹;Fh,赤道",["狂热之刃"] = "Fn,Papaya;Fk,有多远射多远;Fj,糖豆的美梦;Fi,郑翔爱吃翔;Fh,加尔鲁什;Fg,打瞌睡的阿噜",["阿克蒙德"] = "Fn,君撷陌上弓;Fm,守缺;Fj,奥格专业开锁;Fi,执迷的老王",["索拉丁"] = "Fn,炎弗;Fi,史前史努比",["奥特兰克"] = "Fn,一波流武僧;Fl,繁华尽诗酒藏;Fk,背叛过去,正能量魔导师",["红龙女王"] = "Fn,十元结衣;Fl,小犄角",["加基森"] = "Fn,辣鸡职业;Fj,欠债玖佰万,雨过月华升",["迅捷微风"] = "Fn,章先生丶;Fl,地精油;Fk,冰雪荣耀;Fj,孤绝如初见;Fi,鞘师里保;Fh,Moscatel,雨夜丶菲菲;Fg,让本宝宝先撤",["銀翼要塞[TW]"] = "Fn,雅琴",["塞拉摩"] = "Fn,独卧云巅瞰",["迦顿"] = "Fm,丶奔放小嘿",["神圣之歌"] = "Fm,执念灬轩",["伊利丹"] = "Fm,Mikelan;Fj,尤姆",["遗忘海岸"] = "Fm,云行雨施;Fi,恐怖钕主角,丶跳刀躲梅肯,聖光先锋;Fg,沉默之石,乌伤郡",["暴风祭坛"] = "Fm,阿毛的线",["托尔巴拉德"] = "Fm,闪闪地板王",["阿比迪斯"] = "Fm,朝小树;Fh,谈指红颜老",["哈卡"] = "Fm,凨情",["战歌"] = "Fm,噢丶糟了;Fi,优雅之枫",["瓦里玛萨斯"] = "Fm,丨洛丽塔丨",["太阳之井"] = "Fm,兽不兽;Fk,白芍菜心;Fi,王壮壮",["凯恩血蹄"] = "Fm,倚清秋",["翡翠梦境"] = "Fm,贼帅",["图拉扬"] = "Fl,葱油拌面;Fh,杜琼新羽",["布莱恩"] = "Fl,花依旧玉人渺;Fj,冷星雨",["黑龙军团"] = "Fl,普隆德拉",["壁炉谷"] = "Fl,红色嘉年华;Fg,Lucifeer",["外域"] = "Fl,明月逐来",["蜘蛛王国"] = "Fl,犯罪现场;Fg,冰之苍月",["黑铁"] = "Fl,茫然之飞刃,别问问就放血;Fj,童咚咚;Ff,摇滚大橙子,南岸青栀",["德拉诺"] = "Fl,欢如平生;Fg,血嫣寒影",["加兹鲁维"] = "Fl,一直到厌倦",["阿曼尼"] = "Fl,二嫂肥肠面",["耳语海岸"] = "Fl,青树湖都",["羽月"] = "Fl,蛋花,梦想抓只咕咕,王铁柱;Fj,Cleisy,确实够黑",["阿尔萨斯"] = "Fl,好新之刃;Fk,青蘿拂行衣;Fj,箭气;Fi,香蕉牛奶;Fh,狰狞",["巫妖之王"] = "Fl,白银之手新兵;Fk,公子无双",["银松森林"] = "Fk,英文课;Fi,文森特;Ff,Dfgs",["红龙军团"] = "Fk,九月寒露;Fi,最强肉盾;Fh,我离,绿绿小萝莉,山下来的神棍",["永恒之井"] = "Fk,星际无限美",["盖斯"] = "Fk,佛祖之手",["风暴之眼"] = "Fk,陆小凤的中指",["凯尔萨斯"] = "Fk,无庸丶",["芬里斯"] = "Fk,天牛丶",["通灵学院"] = "Fk,指间黑白;Fj,灬虾条灬",["石爪峰"] = "Fk,一佛系青年一;Fj,玖伍伍带槽,花醉三千客",["扎拉赞恩"] = "Fk,晓萨;Fj,旧人时光不离,专属小幻",["霍格"] = "Fk,柚子皮好苦丶",["巴尔古恩"] = "Fk,萌萌的椰汁",["踏梦者"] = "Fk,那那",["朵丹尼尔"] = "Fk,紫杉丶龙王",["卡德加"] = "Fj,淡淡黄昏丶",["山丘之王"] = "Fj,墨筱陌,薇薇呐;Fh,击溃油王",["暗影议会"] = "Fj,气死小居了;Fh,大绝招",["玛里苟斯"] = "Fj,天使的毒奶",["黑暗之矛"] = "Fj,帝国海军",["伊森德雷"] = "Fj,火葬场阿明",["日落沼泽"] = "Fj,圣光小玉",["生态船"] = "Fj,執著灬",["哈兰"] = "Fj,沫沫烨",["白骨荒野"] = "Fj,语澤;Fh,新人中单",["奥拉基尔"] = "Fj,Seiko;Fi,神滅斬;Fh,真不知是誰",["雷霆之怒"] = "Fj,丶丹妮莉丝",["激流之傲"] = "Fj,吉利兄弟",["阿拉希"] = "Fj,卩坏蛋",["阿斯塔洛"] = "Fj,哈索尔",["奎尔丹纳斯"] = "Fj,舞弥;Fh,姬血冷清",["密林游侠"] = "Fj,骚年先疯;Fh,舞玲珑",["塞泰克"] = "Fj,这里好多鱼",["奥杜尔"] = "Fj,当年地主",["屠魔山谷"] = "Fj,阿尔托莉亚",["红云台地"] = "Fj,张布罗;Fg,暗夜之瞳",["安格博达"] = "Fj,云丶七",["希尔瓦娜斯"] = "Fi,丶欧豆豆",["雷克萨"] = "Fi,爱吃牛三宝",["艾欧娜尔"] = "Fi,大白皮一发",["泰拉尔"] = "Fi,山雨",["拉文凯斯"] = "Fi,夏沫奶茶",["嚎风峡湾"] = "Fi,Kissazshara",["大地之怒"] = "Fi,酒叔不喝酒",["艾莫莉丝"] = "Fi,刹风",["祖阿曼"] = "Fi,紫雾",["玛法里奥"] = "Fi,爱撒娇",["巨龙之吼"] = "Fi,夜小寒;Ff,韩枫",["符文图腾"] = "Fi,杰哥归来",["黑翼之巢"] = "Fi,陌嘫红颜",["玛瑟里顿"] = "Fi,无垠的大地,小脚乱顶",["阿纳克洛斯"] = "Fi,偷袭你开心;Fh,小野蠻;Fg,哞哒哒",["达尔坎"] = "Fi,凛冬將至",["迦罗娜"] = "Fi,么贼",["基尔加丹"] = "Fi,烟華易冷",["达隆米尔"] = "Fi,九尾鸣人;Fh,愿月神保佑你",["风暴之怒"] = "Fi,老韩的空酒桶",["军团要塞"] = "Fi,伤灬感入侵",["风行者"] = "Fh,血色丶曼陀罗,我特么要造反",["奥达曼"] = "Fh,老衲要射啦,箭之影;Fg,Chameleos,Freude",["埃加洛尔"] = "Fh,吾生须臾,吾谁与归,太早",["阿扎达斯"] = "Fh,雨灵霖凌",["玛诺洛斯"] = "Fh,懐英",["利刃之拳"] = "Fh,七七酱,地狱中最帅",["沙怒"] = "Fh,名字很好取",["暮色森林"] = "Fh,古伊娜",["希雷诺斯"] = "Fh,殺生",["伊瑟拉"] = "Fh,Chy",["卡德罗斯"] = "Fh,丨仅等于狼丶",["雏龙之翼"] = "Fh,安静",["千针石林"] = "Fh,釺羽千寻,釺羽",["血环"] = "Fh,我是大丁丁",["艾露恩"] = "Fh,超甜豆浆",["Illidan[US]"] = "Fh,Yohaa",["雷斧堡垒"] = "Fg,悟空大老爷",["天空之墙"] = "Fg,我有我方向",["伊莫塔尔"] = "Fg,沙耶之歌",["卡拉赞"] = "Ff,丶陌",["冰川之拳"] = "Ff,流沙之城",["厄祖玛特"] = "Ff,冰蓝丶"};
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
                    if not tContains(players, fullname) then
                        table.insert(players, fullname)
                        player_days[fullname] = date
                        player_shown[fullname] = topNamesOrder[fullname] or 0
                    end
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