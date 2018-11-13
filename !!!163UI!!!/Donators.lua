local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,释言丶-伊森利恩,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,橙阿鬼丶-达尔坎,贞姬-霜之哀伤,剑四-幽暗沼泽,站如松-夏维安";
local recentDonators = {["凤凰之神"] = "FC,灬剔忉縡戰灬,隐世少年;FA,板凳腿儿;E+,逗比小战,丨浮兮丨,糖醋丶,姬丶武神;E9,小阿文丶,灰灰的小灰机;E8,走歌,晨潇潇;E7,鹿达尔丶饭盔,Amerill,暖年如歌;E6,Daozei,魔法少女甜甜;E5,么么嚒嚒哒;E4,转折｜小马哥,樰彡舞;E3,阿基米德,IDÆçrider,哪哈哟,墨角兽;E2,Vier;E1,影锋灬",["朵丹尼尔"] = "FC,蜂鸟",["金色平原"] = "FC,七侠镇邢育森;E+,艾迪迪丶鸽鸽;E3,西蒙贝尔蒙特,阿帕罗丶夜风;E2,法伤负数",["血色十字军"] = "FC,青格,燕子楼;E9,烛照;E7,隔壁小孩;E5,、六合;E4,轩尼诗泡龙鞭;E3,风斩氷华,不知火朧;E1,凌东拳霸",["迦拉克隆"] = "FC,夜幕处刑者;E/,乔伊丶,秦汉唐宋;E8,Leyna,星屑的追忆;E7,薛定諤的猫,如蜜传如蜜;E6,呼啸凛冬;E5,赖美云丷,偶尔奔放;E3,初夏听雪;E1,深深的雪",["玛诺洛斯"] = "FC,魔法少年钵钵",["影之哀伤"] = "FC,为为所欲为;FB,今晚还睡你家;FA,地狱丶咆啸;E/,衛宫切嗣,疯狂战争壁垒;E+,丿為了部落,扛妹九条街;E8,左一撇,浮丶休;E7,曾经的猫爷,霍莉沃尔夫;E6,买买竟然;E5,那抹深蓝色;E4,雪舞凋零,末路狂花;E3,卌成鸡思汉卌;E2,柚儿园的蘑菇,跳跳熊冫",["主宰之剑"] = "FC,停吧;FB,邪能阿里巴巴;E/,乔喵喵;E+,狮孑;E9,丨雅典娜丨;E7,Artille;E6,神赐一鸣酸奶,轰炸吉,三分熟丶,勥氼丶;E5,初犬饼;E4,淡淡麵,虚影玫瑰;E3,Magiccoffee,左右看風景",["阿拉索"] = "FC,灬豆丁灬;E/,剑徒之路,Sakurammk;E8,上官灬;E7,魔怪丁叮,圣婴大王",["伊森利恩"] = "FC,小丑黑白;FA,断水流丶,樱桃宝宝丶,Sleepymilk;E/,微笑的廸妮莎,磨人的大聪明;E+,忘川丶无殇;E9,Gyrocopter,奔跑的五花肉;E7,迷之低保;E6,丶我不是咕咕;E4,阿昆达丶卒;E3,武器器,山石大哥,丶风骚小辣椒;E2,随风如影",["奥拉基尔"] = "FC,菲凝;E/,Stoyadoll;E9,泪痕丶",["阿古斯"] = "FC,浮生灬年华,采蘑菇的粉象,白昼梦;E/,樱茶,很反光的树;E8,鸳鸯;E7,米兰的小画匠;E5,大屁股熊;E4,布莱尼丶甜甜;E2,女神丶伊阿索,徳鲁希丽雅",["万色星辰"] = "FC,风暴酒仙;E/,美依莉蕥",["黑铁"] = "FC,徒手摸电门;FA,短腿的阿昆达;E6,如星伴月;E4,剑春归花残梦,爱乐之城;E1,玉狐前",["埃德萨拉"] = "FC,白银公爵,嘤茶;E6,深海鱿鱼堡",["格瑞姆巴托"] = "FC,莱希拉姆;FB,抹了油的猪丶;FA,木岩;E+,吃鲸少年;E9,Matrix;E8,蝦丸;E6,托尼老板丶;E4,老友丶猪肉;E3,首席非酋,野原叫新之助,小新有大象,乄夕陽;E2,丶武侯;E1,法似一明灯",["普罗德摩"] = "FC,妞妞爱牛牛",["死亡之翼"] = "FC,提尔皮茨;FB,斗莫央丶,Wareve;FA,小津灬诗音,护舒宝丶;E/,靑帝丶;E+,小有幸福,高配任达华;E9,奶油大姐,莫德高德;E8,辣鸡贼,丶轉鯓離紶;E7,月丷诗雨,无眠灬;E6,萌萌的小灵魂;E5,糖门术学家丶;E4,情深意浓,朔月九望,沅溜溜,丨丶菟寶寶;E3,酒蒙子丶,成蹊,车队领导着,最终自由,车队领导者,星空下的小宇;E2,Shellin;E1,纳格法尔号,重要的是姿势,荒青春逝流年",["鬼雾峰"] = "FC,那一抹天蓝色",["库尔提拉斯"] = "FC,生如梦幻",["鹰巢山"] = "FC,橙子味蜜柑",["丽丽（四川）"] = "FC,糖那德特浪普;FB,晓卩;E/,飞天小婬贼;E5,六總;E3,桑叶丶白",["白银之手"] = "FC,温茶煮酒;FB,浓浓的父爱,暗夜瞎子;FA,丷白小飞丷,冬吟秋;E+,凕王,换坦嘲讽丶;E9,Maria;E8,骨幕厉影;E7,萌萌会飞,星冰柠檬;E6,大熊啊,暗炎爵,崂山矿泉水,冰熊狼猎;E5,Ojbkko,雷云之将;E4,Darkwich,小恶魔启动,煜帝,初心蓝梦;E3,怀熙,Scientists,莽穿天淦神仙,Voidelfin,东哥不识美,古德貓宁,抠脚灬无情,肥宅快乐祝;E2,圣纳六千,小猪鱼呆贼,牧冥,我不是帝凯;E1,蓝衫极品,九門丶佛爺,妖妖的小猎,烏拉",["无尽之海"] = "FC,晚安曾經;E/,下次硪请;E9,近我者富丷,蛇皮派大星;E7,离你丶十一步,魔怪丁叮,波音;E6,糖果大布娃娃,没人疼没人爱;E4,丿月影,丶心如止水丶,由礼;E3,碧空之歌,血之遗弃者,又起秋风;E2,Venars;E1,酔酒当歌,扶摇索伦",["熊猫酒仙"] = "FB,月影流光;FA,Ãã;E9,扛不住灬就躺,影丶月噬;E8,Peppapig;E6,雾、璃;E5,Conclud;E3,死神的傀儡,翱瀛徽坤;E2,臭飞飞;E1,废柴老奶奶",["洛肯"] = "FB,天佑朝伟",["国王之谷"] = "FB,灰黑化肥会挥发;E+,断月晴;E7,乌啦啦丷,东方喵教主,猫武;E3,虚空咒语,羽影之歌",["贫瘠之地"] = "FB,尤狄安,杀戮救赎,那年夜雨;FA,暴打柠檬青,一箭你就啸,快乐咕咕宝宝,晨翼河风;E/,天线哞哞宝宝;E+,损心;E8,壹米圣光;E7,夜尽此天明,Wulizhao;E6,一秋一林夕;E5,遗忘无忌,处坦克,九月归尘,璃雨;E4,华大帅,碑灵;E3,丨嘚噜噫丨,花魚兒,御箭乘风;E2,东北小野马;E1,Dreamers,二丶同学",["遗忘海岸"] = "FB,小黑虎",["诺兹多姆"] = "FB,酒月桂花香,尝试与死亡,猫语者;E8,黑糖珍珠;E4,江南摩尔",["血吼"] = "FB,执念成殇;E7,一半透明;E5,丨剑魔丨;E3,用嘴铩人,封昆达",["羽月"] = "FB,艾萨克斯,死灵若雪",["萨尔"] = "FB,寡妇村支书,致命杀伤者;E+,Namii",["红龙军团"] = "FB,睁眼瞎变形;E6,黑暗种子",["海克泰尔"] = "FB,若无名,膨胀;FA,快樂风男;E/,上官敬亭;E9,咖喱;E8,;E7,慕法沙;E4,妖夜;E3,糖手扶鼎",["阿纳克洛斯"] = "FB,心有所依;E+,丸纸;E8,Nellyoo;E4,南极大鱼干,别讲想念我;E3,小轻玥;E1,魔中君子",["燃烧之刃"] = "FB,次米,假装王祖贤;FA,裴御珍;E6,Mengdruid;E4,江南吴彦祖,阿喀琉斯丶;E3,尐丶傻馒,韦家三少;E2,酒仙陈玄风;E1,䬕飍䬕䬕,大西叔叔",["暗影之月"] = "FB,非天梦魇;E/,火儛丶;E+,维恩的风铃;E9,卡丿尔;E4,飒风之影",["冰风岗"] = "FB,夜雨祭花魂;E+,小刀;E9,宝宝硬的狠;E1,霸王硬上弓丶",["荆棘谷"] = "FB,苦涩咖啡",["耳语海岸"] = "FB,你已经,小小桃,笨丁丁",["???"] = "FB,Myh;FA,莉雅;E/,元素丶協奏曲,落蘭之殤,橙默丶,头号捣蛋鬼;E+,枫神榜,欧皇鸽砸;E9,美智的宠物;E8,清汤,血窝窝头,损心;E7,Pinkdusk;E5,邪恶的铲子",["熔火之心"] = "FB,尧兆,月尧兆;FA,辛多雷的荣耀;E5,骑警扎小西;E3,好运来来;E1,泡泡茉茉",["艾露恩"] = "FB,大蟹子;E2,豆浆",["达基萨斯"] = "FA,孑了孓子",["破碎岭"] = "FA,迷茫的小猴,迷茫的贰奶,迷茫的芒果,迷茫的茉莉,迷茫的抹茶,迷茫的熊猫,迷茫的萌萌,迷茫的尛熊,迷茫的尛白,迷茫的琪琪,迷茫的記憶;E8,Turbowarrior;E6,偷零食的贼,溈伱鈊賥;E4,饮不尽杯中酒,Flashback,风起水涟漪,水晶尸王毛毛",["伊瑟拉"] = "FA,零八七贰;E5,焦点",["雷克萨"] = "FA,鬼魅潇潇",["黑暗虚空"] = "FA,不能叫我山鸡",["布莱恩"] = "FA,蓝枫",["克尔苏加德"] = "FA,问题兒童,洛克哒;E7,悠闲的行者;E5,紫雲薰児;E3,丨比格沃斯丨;E2,甩动吧肥肉",["安苏"] = "FA,雍丨和;E9,忆丨流沙,歌暮烟水寒;E8,凡一丶,傲气丶老鉄,大叔家的輝;E3,Hellix",["诺森德"] = "FA,Poppy;E/,梧小桐;E8,你猜我猜不猜",["永恒之井"] = "FA,書寶寳,云端之风;E/,假暗牧;E8,巴比伦剑客",["烈焰峰"] = "FA,烈焰震鸡;E9,夜瞳,六条,獸人史莱克;E4,一雨今生,以瑜之名;E1,阿蔓遇见苏儿",["冰霜之刃"] = "FA,Crazytodd;E7,中单;E4,心随流云",["勇士岛"] = "E/,笑熬浆糊,燕南飞",["安威玛尔"] = "E/,与龙角力;E+,柏林",["提尔之手"] = "E/,当你悲伤时",["伊森德雷"] = "E/,三十六个术爷",["斯克提斯"] = "E/,天堂灬风歌;E9,主公大人",["冬泉谷"] = "E/,赤膊穿西装",["巨龙之吼"] = "E/,稀有型库噜;E7,紫瞳萝莉;E3,一岱玹一",["洛萨"] = "E/,壹骑当仟",["雷霆之王"] = "E/,戾犬;E9,要恰饭的嘛;E7,铁拳孙逸仙;E1,江山入画来",["拉文凯斯"] = "E/,浮世乱了流年",["米奈希尔"] = "E/,奶瓶丶潴潴",["回音山"] = "E/,秒杀的艺术;E5,蔷薇果;E4,花彩;E2,Accetation",["扎拉赞恩"] = "E/,专属小钦;E8,涛涛龙行天下",["巫妖之王"] = "E/,四叶游戏,追逐繁星,危机边缘,蝙蝠;E8,Dobimingplus",["龙骨平原"] = "E+,能抗能打能奶",["布兰卡德"] = "E+,拖延者肖雄,行者喵;E8,玉溪儿丶;E7,颜爆大师;E6,兄弟来把狙;E2,命运的落叶;E1,李阳脚很臭,两秒偷药",["奥尔加隆"] = "E+,之翼君;E6,你的宿敌,丶小萌墩;E5,奈文摩尔哦",["亚雷戈斯"] = "E+,少年蓝色经典",["希雷诺斯"] = "E+,你来捅死我啊",["凯恩血蹄"] = "E+,雷楼某",["盖斯"] = "E+,Kira",["霜之哀伤"] = "E+,嘿漠;E2,疾風怒涛",["索瑞森"] = "E+,魏老师;E3,战叼",["寒冰皇冠"] = "E+,瀍幽;E4,涛哥",["提瑞斯法"] = "E+,瘦骨不禁秋",["阿拉希"] = "E+,Mark",["血环"] = "E9,上善若山;E8,果汁分你壹半,罪落凡尘",["斯坦索姆"] = "E9,罗宁",["德拉诺"] = "E9,一朵娇花儿",["塞拉摩"] = "E9,周大發",["达斯雷玛"] = "E9,天理;E3,高压钠灯",["风行者"] = "E9,電波少女",["末日行者"] = "E9,Miracless;E6,风拂树醉,飞扬跋扈,Noodles;E5,梓桐丷丷,殘梦大魔王;E4,白晓晓;E3,语动静默,刺客聂隐娘;E2,艾迦狄亚;E1,凤兮丶曼陀罗",["厄祖玛特"] = "E9,好讨厌的感觉",["哈兰"] = "E9,沫沫烨;E3,泰国脏脏包",["奥杜尔"] = "E9,老夫的少女心",["风暴之眼"] = "E9,寂寞杀杀,静影沉月",["菲米丝"] = "E9,玫果丶",["幽暗沼泽"] = "E8,渺渺兮予怀",["巴瑟拉斯"] = "E8,老虎",["战网"] = "E8,袭月飞血",["迦顿"] = "E8,想学魔法",["火烟之谷"] = "E8,游学者丶小超",["试炼之环"] = "E8,愉快的小野人,轻抚你狗头",["阿尔萨斯"] = "E8,小动物饲养员;E4,斯坦;E3,楊超越丶",["火羽山"] = "E8,御前带砖侍卫",["利刃之拳"] = "E8,丶萌娜丽莎;E3,梁皓然,西蓝花;E1,主体责任",["萨菲隆"] = "E8,Camelia",["加兹鲁维"] = "E8,高山水流不",["雷斧堡垒"] = "E8,卡姿兰大眼睛;E7,Debra;E2,猎空闪光;E1,奥霏莉娅,明玉",["迅捷微风"] = "E8,顺辉数码专卖;E7,小明",["阿比迪斯"] = "E8,黑尾丶",["战歌"] = "E8,糖糖卟喵",["黑龙军团"] = "E8,渣渣兔",["月光林地"] = "E8,铁浮屠丶;E6,Dagger",["加里索斯"] = "E8,拉皮;E2,迷之小友",["壁炉谷"] = "E8,一筛乾坤,晨日斜影;E3,巨闕",["法拉希姆"] = "E8,伊俐玬",["神圣之歌"] = "E8,暮霭苍苍",["阿克蒙德"] = "E7,芳的獵人;E3,切奶的阿昆达",["月神殿"] = "E7,珂珂的宠儿",["太阳之井"] = "E7,解忧杂货店,月落霜满天",["祖尔金"] = "E7,马克沁",["天空之墙"] = "E7,Shmilyqy",["密林游侠"] = "E7,鬼罂粟",["伊萨里奥斯"] = "E7,灬圣光灬",["燃烧军团"] = "E7,甜蜜之吻",["菲拉斯"] = "E7,今回老似前回;E6,吃你家蛋炒饭;E2,风中狂魔",["影牙要塞"] = "E7,八宝景天",["霜狼"] = "E6,久保小鹿,风雷小猎;E4,丨浪费丨;E3,天堂真矢;E1,八荒",["灰谷"] = "E6,Razorclaw",["加尔"] = "E6,乱晴空;E3,親爱的不二",["罗宁"] = "E6,霜麒麟;E5,蛮丑,绯村剑心,敲梨大爷;E2,小猪佩琪,无羁乾坤;E1,無月丶",["芬里斯"] = "E6,Villana;E4,姬小宝",["水晶之刺[TW]"] = "E6,一魚一",["图拉扬"] = "E6,嘉妮丝",["塔纳利斯"] = "E6,乱世丷小怪",["翡翠梦境"] = "E6,Akis;E5,幻侠;E3,鑫丶低调",["诺莫瑞根"] = "E5,长腿柯基",["石锤"] = "E5,我是搬砖的;E3,南城南撞南墙",["卡德罗斯"] = "E5,甄惜",["玛里苟斯"] = "E5,晓风满画楼",["达尔坎"] = "E5,看天",["逐日者"] = "E5,千秋岁",["铜龙军团"] = "E5,傲世无双",["血牙魔王"] = "E5,一念十年、",["斩魔者"] = "E4,奈特哈尔",["聖光之願[TW]"] = "E4,吉子",["深渊之巢"] = "E4,墨斯",["加基森"] = "E4,非酋之巅",["暴风祭坛"] = "E4,Rocketpanda",["纳沙塔尔"] = "E4,魉皇丨鬼灬",["阿卡玛"] = "E4,元气少男奶牛;E3,灬咖啡店卩",["戈古纳斯"] = "E4,夏之冰凝",["麦维影歌"] = "E4,散步的鹌鹑",["玛多兰"] = "E4,疯狂的女人",["萨格拉斯"] = "E4,大魔王车厘子",["克苏恩"] = "E4,埖逝依舊羙",["时光之穴"] = "E4,月色真美",["埃加洛尔"] = "E3,神手健一",["风暴峭壁"] = "E3,暴躁鬼畜少女",["轻风之语"] = "E3,瑪维娜的诗歌",["圣火神殿"] = "E3,逝殇易云",["安其拉"] = "E3,李茶他姑妈",["海达希亚"] = "E3,无限星云",["通灵学院"] = "E3,牧濑丨红莉栖",["蜘蛛王国"] = "E3,還差一點點",["狂热之刃"] = "E3,黯然叉烧饭",["麦迪文"] = "E3,阿水",["奥特兰克"] = "E3,咸鱼冲击",["瓦里玛萨斯"] = "E3,噼里啪啦砰",["耐奥祖"] = "E3,德玛卍西亚,六的一皮;E1,精灵的魅影",["死亡熔炉"] = "E3,散蘰公主",["黑石尖塔"] = "E2,相声演员琪琪",["艾萨拉"] = "E2,六五四二",["外域"] = "E2,魔兽小师妹",["晴日峰（江苏）"] = "E2,丢雷佬母",["古尔丹"] = "E2,Kellykeith",["Illidan[US]"] = "E2,Zenganiu",["远古海滩"] = "E1,天下小白",["安加萨"] = "E1,有点寂寞",["沙怒"] = "E1,傲月痕",["布鲁塔卢斯"] = "E1,毒灬药",["银月"] = "E1,骑墙等红杏",["阿迦玛甘"] = "E1,上半身的希望",["激流堡"] = "E1,思绪的水",["布莱克摩"] = "E1,口水多过浪花",["泰兰德"] = "E1,冰寒",["奥达曼"] = "E1,Douloureux,Astalos",["银松森林"] = "E1,医用有机必过"};
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