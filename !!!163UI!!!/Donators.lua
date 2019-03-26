local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,闪亮的眼睛丶-死亡之翼,空灵道-回音山,瓜瓜哒-白银之手,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,释言丶-伊森利恩,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,坚果别闹-燃烧之刃,冰淇淋上帝-血色十字军,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["燃烧之刃"] = "HL,左边比较大,㑋丶晚安,跳刀拉比克;HH,落幕的月光,小炯丶;HG,玉强活动房屋;HF,坚果别闹;HD,娜塔亚的视界,龍狩;HB,珈蓝丶炎焱;HA,提里奥灬莫瑟,确实是个混子,成都李荣浩,鬼迷丶心窍;G/,领灬舞,红烧柠檬茶;G+,傳說中的骑仕,我是大丁丁,省直机关;G9,超梦的逆袭;G8,华伦天奴丶;G7,蛮大力,念小初;G6,子龙的粉丝;G5,阿琨达;G4,吉野婕,無她㢙,米米徳;G3,稳住我们能嬴;G1,影歌丶紫玉;G0,西门威哥;Gz,吉檀迦利",["主宰之剑"] = "HL,欧一冷总一皇,愛德華丿蒂奇;HK,未来皆可期;HJ,深秋;HH,绯红咖啡,风华是指流砂,丨寒影丨;HG,邪恶光环丶;HD,暴走;HC,小阿咪丶,喵筱筱,换坦丶嘲讽;HB,夏雪宜的盾;HA,丶韩菱纱丶;G/,传说冰有淚,绝世歌姬海牙,Culaccino,叶落初冬丶,黑夜战神,先民的权柄,在下瞄人凤;G+,大匠,很简单;G5,巫女大人;G2,伊薇露艾;G0,昊泽;Gz,天才小熊猫,丶射掱",["死亡之翼"] = "HL,超甜豆浆,猫天棒,阿伽修罗,争当豹子头,环保小卫士;HK,爱新觉罗凯牛;HJ,蚂丿蚁,丨丶斩;HI,洛秋凉丶,过来肝我全尸;HH,Ripperzz,三刀而已;HG,残落丶;HF,深知她是懜;HE,莲花色,丶悠悠球;HD,闪亮的眼睛丶,天刀小杨,瘦人永不发福;HC,伊利瞎丹,放肆一吻,我不玩坦克;HB,张天萌丶;HA,Yeran,塔蕾莎的回忆;G/,海鲜可爱多,蔓蔓卿心,齐总,明月大哥,秦风细雨;G+,好嗨佑;G9,剪丶烛,因爱执着;G8,随缘丷,Octavius,丶纸防骑,最强王者;G6,郎郎酱;G4,信仰聖光垻;G3,乳酪芝士面包;G2,糊涂小刀,真希波玛丽;G1,夜曳依然,逐光之影丶,拽根宝,喵丶小寒;Gz,古麗古麗",["菲米丝"] = "HL,静静的昕昕",["迦拉克隆"] = "HL,骗你是小咕;HK,刃之無雙,諸神之怒;HJ,突然好想伱,米饼丶猎;HF,冲丨大士;HE,清风扶杨;HD,慕九九,西风摇影;HA,雪落灬初音,重度话唠患者,请叫我小软;G/,叮当法术喵;G3,影月之伤;G0,伊柒珥;Gz,绝望杀戮",["白银之手"] = "HL,天肝勿燥,迪达弹弹;HK,梦魇术术;HJ,小孙策,阿不思的克星;HI,郭达曰斯坦森,福柯奥斯,荒原战歌;HG,放电小绵羊,云冷;HF,頑世主;HC,季丶鸳,Sinéad,曲绯烟;HB,寂寞依然,飘扬的红裤衩,莉兹与青鸟;HA,传奇圣斗士,江畔伊人;G/,陈丨冠希,风暴烈酒丶刘,舔枸,手術刀,灰色的心,云水優優,Yorhatypeb,白咕咕灬;G+,兽本善良,纳格兰的静谧,假爱之名,奥妮氪希亚;G9,暴乀徒;G8,打野千珏,納格蘭的靜謐;G7,我在途中丶,王大少,Vesperlynd,命格无双丶,晚安丶喵;G6,吞风闻雨落,橙夢;G5,佬克;G4,密微微其清闲,疯花生;G3,风姿傲骨;G2,Fovcjq,斯坦恩布莱德,执笔绘红尘丶,极品宠物;G1,月伴清宵;G0,雷哥没时间,血月星空,木岩;Gz,建议放弃治疗,胖神仙,寒月当空,深海活鱼",["安苏"] = "HL,丨灬流沙灬丨;HK,奶油土豆泥;HH,青鸟衔红巾;HG,醉青竹;HF,千里流氓;HE,帥气的文哥;HD,醉酒当歌;HC,Lanyuchen;HB,我芸丶;HA,嗒嗒丨,青规戒律,淡漠行;G/,谢丶燕君,铁骑乄小章,醉秋红;G+,瓦嘎;G9,往誓隧風;G7,小妹贵姓;G6,乄奔放哥丨;G5,酒不好喝么,巴音布鲁克丶;G4,铁血乄威士忌;G1,Brightroar",["国王之谷"] = "HL,米娜斯媞莉絲;HJ,时而不着调;HG,隱哥,晚夜烛凉,法拉米尔夏月;HF,职业坦克;HE,卡多雷风行者;HA,五十度善;G9,膝盖送你了;G8,乌瑞恩的老姨;G5,云彩上的天空;G4,清蒸灰熊掌;G2,小領主",["燃烧军团"] = "HL,菠萝波罗",["恶魔之翼"] = "HL,你亲爱的姐夫;G2,幽默感",["荆棘谷"] = "HL,贵气王族",["凤凰之神"] = "HL,Ryujyamazaki;HK,敏敏新垣结衣;HJ,似水无恨,奶茶配辣条丶;HI,陈冠曦,关爱老实人,汉寿亭侯丶;HH,飞鸟与鱼丶,灬筱柒仔灬,教官我想上课,忘了这事了,凍骨頭丶;HG,火炎丷焱燚,胖胖的牛德头;HF,白米粒,百万少男的梦,六批,西游内斯塔丶,馨月虎啸,荒年丶,体驗号;HE,沐小白啊,借你妹一用丶,风暴志玲;HD,丨鑫然丨,鑫然灬;HC,葡萄酒火锅;HB,牛蛙丶丶,辣目洋子,梦境大奶牛;HA,雷皮之槌,自由镇书记,殺风;G/,绯色天堂,沉鱼欧巴,易丶愿,丨闹小闹丨,谢无生,离歌罒,四蛆兄弟,Silentheart;G+,乔姐,浅酌笑红尘,心若浮云;G9,深了个邃;G8,Maikuraki,无丶里头,涅槃妙心;G6,黯然丶销魂饭,一碗蛋花汤,中传媒桃源晓,可爱哒兔子,兔兔丶兔姐姐;G5,风起明月;G4,怑夏,风雷斬;G3,脸黑的阿昆达,丶厶鈊馡灬;G2,殺画丶,殺生丶;G1,怒风乄战神,兔子姐姐",["瓦里安"] = "HK,硬邦邦的;G/,玖橙",["伊瑟拉"] = "HK,滑雪爱好者",["奈法利安"] = "HK,新垣结衣;G2,北执",["阿比迪斯"] = "HK,经开建;HA,莫吉蒂",["无尽之海"] = "HK,秀气娇娘,綉気毒舞;HJ,有丶帅的怪怪;HI,洛丝维亚瑟,森岛囚鹿;HH,发电的阿昆达;HF,瘾藏人物;HD,心无海怎去浪,灬刀剑如梦灬;HC,我很谦虚;HB,提拉米米苏;G/,海猪海猪;G9,大雨将至,哼哼唧唧;G7,文燕;G5,Stefanieyu,蛋总的忧殇;G2,丶小海棠,守护丶奶妈",["迅捷微风"] = "HK,妖瞳百魅;HE,关大彪丶;HC,那些你给的梦,完美有多美,脉伦;HA,醉花荫丶;G0,虾纸",["遗忘海岸"] = "HK,女武神丶;HD,啊猫喵喵;G3,诗酒趁年华丶",["熊猫酒仙"] = "HK,蝴蝶之夏,雪落苍山;HJ,暗殺星㐩,Guckkasten;HE,死神丶墨语,浮生若流年丨;HD,月下寒霜;HC,何来爱吃大福;HB,奥西尔;HA,喝死在卫生间,未丶来;G/,無雙,战霜翼,哈哈兔小爷;G6,令狐盟主;G3,狂野的红领巾,傻气丶,相当的牛;G2,大力花菜",["格瑞姆巴托"] = "HK,脆脆丶奥斯卡,突然空闲;HI,一根儿木头丶;HH,你好丶阿瑞斯;HG,然然的苏菲;HD,Overlorder,赵琳琳;HC,不破不灭,Doomedo;HB,带带大师妹,和风;HA,胯下那杀气,Justgogoo;G/,叮当当咚咚当,小黄爷丶,辅导员灬;G+,笨笨豬丶,丨纞丶戰丨;G7,破军星灬小楼;G4,砸烂复读机;G2,Keeric;G1,水星环游记丶,知阴大鸽鸽;G0,清歌绝影,落叶丶悲痛,灬刃丶猫灬,华北可能有雾",["伊森利恩"] = "HK,暴走的肉圆子;HD,大拉斯塔哈王;HB,兔宝爱淼淼;HA,Keithmagic,暴走的小亮亮;G/,雷丶鸣,血腥爱情故事,呆毛王的愤怒,小麦与我同在,锻崖,安安归;G6,曾经已為追忆;G5,暴走的阿肉肉;G3,亚丶花残;G2,没我跑的快;G0,带你去看繁星;Gz,法力残渣丶,躺着舒服",["阿克蒙德"] = "HK,死前两米;HJ,丫疼;HB,Meninblack;G/,芥末糊一脸",["克尔苏加德"] = "HK,小聆听;HI,舌尖上的咕咕;HE,零柒伍柒;HD,月无期;G/,Clearlové,咿幺大叔,荀令君;G+,伊幺大叔;G3,网红镇",["末日行者"] = "HJ,大师在流浪,不气饭的阿饭;HG,I残灬叶I;HF,辣个踏风;HE,纯种哈士骑;HD,老李头丶,终成陌路,大梦似长歌丶,我脑上有犄角,亦无邪;HC,月夜之子;HB,我不是骡子,丶朱孝天;HA,零六壹捌,梦落大人;G/,荔枝味之吻,快乐的小易易,尒抹茶,青椒扣肉;G6,爆炸小红豆;G5,醉舞饮千觞;G3,無始無終;G2,我受够了寂寞",["罗宁"] = "HJ,光之灵;HI,偷走妳的心;HD,黃猿,布落落,绣绣乖,朵朵花,朵朵嗨;HC,月落微涼;HB,嗨朵朵;HA,盘他开哦,曰暮酒醒;G/,飞翔的大熊猫,四百搭免杠,落霞菲,黒崎一护;G6,桜五月;G5,白骑士丶月光;Gz,欧阳小哥哥",["梅尔加尼"] = "HJ,新屋熊",["冰风岗"] = "HJ,小红手阿坤达;HI,树读,大毛贼,Verne,先奶为敬;HE,卖萌谁不会;G/,、沫深;G8,山寨乄嗳情,富察丶傅恒,大梦文雀;G7,山葵汉堡,丨冰封夕阳,西门寺幽幽子;G1,久伴不离,潴灬牛气冲天,Tovelo",["阿尔萨斯"] = "HJ,Evansyong;G0,冬熊夏咕;Gz,皮拳兒",["范克里夫"] = "HJ,星辰灬曜月",["贫瘠之地"] = "HJ,帅得坦然,邦桒迪;HI,辛德瑞拉之耀,迦勒底盾娘;HF,夜雨澜梦,大忍戒怒;HE,讲道理别打我,小白笨笨萨满,清风落三花,无故自悲伤,帅就够了;HC,邪恶打击,崔笑笑,就想扫一扫;HB,秀儿童鞋,叁从肆;HA,桜木花道,清欢丶白茶;G/,为了一个傻话,小兔宝宝,不吃喵的鱼,落叶满长安丶;G+,丷零度丶,泰火战坦,妖娆的胖子;G7,慕丝丝,Viruscorpio;G2,骁骁哥布林;G1,绿色的爬爬,冷色;G0,小肆儿,大建出奇迹,奶茶续命;Gz,丶壞尛孓丶",["破碎岭"] = "HJ,你好高冷癌;HI,按住了逼逼;HB,醉过才知酒浓;G1,Turbowarrior",["千针石林"] = "HJ,艾尔的醒醐,艾尔的灵魂;G/,晓月圆舞",["血环"] = "HJ,泥巴坨坨",["凯尔萨斯"] = "HJ,深邃之光",["大地之怒"] = "HJ,永恒的史诗;G2,超重青年;G0,贫乳灬控",["哈卡"] = "HJ,Github;G4,朲緬獸伈",["血色十字军"] = "HJ,佛系牙牙;HI,未语嫣然;HF,阳关无故人丶;HE,霸世狂骑,有清风如许丶;HD,小柚几;HC,满意大魔王;G/,像极了爱情;G9,小朋友爱吃糖;G8,一高人蛋大;G7,睡也睡不醒,风行者阿西吧,身材小总爱跳,丿丶阿九,阿呆呆,狂奔的虫子;G5,Demonci;G4,褒姒别点我;G2,乖乖咙嘀咚;Gz,洳意丶",["回音山"] = "HI,毛茸茸不是胖;HF,哀木涕最流弊;HA,幻想破坏,六费黑骑士;G/,哈酷纳玛塔塔,油腻伽,烏妖王;G7,夜猫子的梦境;G6,杨巅峰",["克洛玛古斯"] = "HI,狂戦,指尖的燃烧",["太阳之井"] = "HI,沧海半缘;HC,飘雪若絮;G3,丶偷神月岁,恶搞大魔王丶;G2,刹雪;G0,谜之粉粉",["海克泰尔"] = "HI,夕阳残雪;HD,汪财财;HA,灬岁月如歌灬;G/,Lzmzzq,玲珑寂灭,雪潇然,Trust;G+,Ashedeserves;G7,可以刚这波;G3,棉花糖兔兔",["黑暗虚空"] = "HI,血熊猫;G4,吃可爱长大的",["狂热之刃"] = "HI,兰蔻丶;HG,江上数峰青;HE,炼狱圣光;HC,尖锐博士;G7,大丑丑;G3,丨千手修罗丨",["铜龙军团"] = "HI,藤井树;HD,长耳朵兔子;G/,凉凉丶,王立軍,Fayewong",["火烟之谷"] = "HI,罗宾",["伊莫塔尔"] = "HI,舒孑影",["埃德萨拉"] = "HH,大锅喝醉了,烟花大魔王;HF,满地小美瓜;HE,莫兰蒂,陸老师丶;HB,Sheeran;G8,感谢神赐力量;G7,神話丶三三,咕德猫林;G3,蠱毒",["黑铁"] = "HH,雷丘的小伙伴,雨鸣丶;HB,勇猛的年糕;HA,提莫大将军;G9,亞丶絲娜;G5,二线酱油;Gz,刘大公子",["轻风之语"] = "HH,Intotrush;HB,面包师;G/,Malefica",["万色星辰"] = "HH,大荒,银灯",["屠魔山谷"] = "HH,想吃小孩;Gz,王欣欣",["血牙魔王"] = "HH,夜空之辉;G/,柯基骑士",["黑龙军团"] = "HH,北巷故人;HD,Vash",["拉文凯斯"] = "HH,民间贼神",["普瑞斯托"] = "HH,沉鱼",["奥特兰克"] = "HH,六不六;HF,天降血骑;HA,脊背痒痒,幺蛾子颠颠;G/,沫楠枫丶,葳蕤灯火;G8,云音乐;G6,哈尼缇娜,流星,孙悟空;G3,火爆旭旭;Gz,死神涞了",["世界之树"] = "HH,玉髓",["影之哀伤"] = "HG,风吹奶甩两边;HF,赤龍雲邈;HD,Weavile;HB,菊之怒放,菊之绽放;HA,丶噩尨咆哮,单挑宿管阿姨;G9,神說丶要有光,皇家恐怖卫兵,法神丶大花生;G8,莫高雷收割机;G7,冰龍吐息丶;G4,羽沐歌;G2,阿亮丶萌德;G1,神隐忘舒,Angelmm,绿皮不语;G0,滋不滋瓷,阿亮丶贼帅",["霜之哀伤"] = "HG,猩红审判;HB,桐姥爷;G9,诵葬者;G4,遊牧人,咆哮的徒花",["耳语海岸"] = "HG,也曾经心动过;G/,蘇菲娅,漂亮的狗狗",["冬泉谷"] = "HG,青鸢",["泰兰德"] = "HG,清靜淡雅;G/,颜值才是正义",["冰霜之刃"] = "HG,Anzi;HC,HunterRay;G8,墨如夜",["丽丽（四川）"] = "HG,戎州杨超越;HD,Blindside;HC,观海听潮;HA,樱落,一个列人丶;G+,清风佛杨柳丶;G9,吃不完蛋百粉;G6,彭摆鱼;G5,老肥;G3,丶华哥;G2,糖果果灬;G0,流泪手心",["黑手军团"] = "HF,猪肉贩子",["加里索斯"] = "HF,粵港澳惡少",["金色平原"] = "HF,若不离丶;HE,快把水晶给我;HB,小鱼饼丶,法力虚空;HA,Nightelfmonk;G/,罗仪轻寒,由姝儿,乔瑟夫丶乔亚;G+,晨夜雨风行者;G8,Octavius;G2,Hertz;G0,水墨畫",["翡翠梦境"] = "HF,弯弓丿射小鸟;HB,锦猫儿;G/,守候誓言;G9,凸血色凸,深了个邃",["黄金之路"] = "HF,一叶知秋丶;G2,时间去哪",["卡德加"] = "HF,二手战士;G1,木木西",["加兹鲁维"] = "HE,白衣渡江",["风暴之怒"] = "HE,平忠盛",["玛诺洛斯"] = "HE,贪玩的小布丁;G6,茶板",["斩魔者"] = "HE,五更琉璃",["菲拉斯"] = "HE,沐风",["扎拉赞恩"] = "HE,墨辰轩",["玛瑟里顿"] = "HE,奎师那;G+,小角乱顶",["石锤"] = "HE,卡隆",["暗影之月"] = "HE,痴情的奶牛;Gz,太多的变化",["阿曼尼"] = "HE,厄瑞玻斯;HC,Thug;HB,Nine;G/,我有小尾巴",["试炼之环"] = "HD,永远百事;HA,海瑟薇,希女王;G6,怀空;G0,白贤;Gz,枯叶蝶丶",["???"] = "HD,泡芙与雪饼;HC,蔡叔叔丶,戰丨仕,凡悟",["加基森"] = "HD,棉花丶;HC,江湖再無熊哥;G/,坐在高岗上",["伊利丹"] = "HD,真武;HB,爱露露最好了,南宫铁柱;HA,蠕动荣誉;G/,慕容翠花;G1,左慈",["红龙女王"] = "HD,星辰禹王;G3,筱犄角;G0,纳闷儿",["阿薩斯[TW]"] = "HD,貝殼裡的海",["狂熱之刃[TW]"] = "HD,阿萊克西亞",["布兰卡德"] = "HD,摸也摸不得;HA,沙曼之神;G3,人多你别闹嘛,不行我要抱啦",["玛洛加尔"] = "HC,影丶夜舞;Gz,红滴像番茄",["普罗德摩"] = "HC,醉看风拂袖;G+,妖怪别跑灬",["安东尼达斯"] = "HC,独孤鱼",["诺兹多姆"] = "HC,墨兰嘿;HB,奥黛丽丶王",["迦玛兰"] = "HC,灵犀一闪",["闪电之刃"] = "HC,寛霸",["雷斧堡垒"] = "HC,冫釒丶;G/,骚琦灬老伺机;G+,田蜗虾面;G5,一杯敬圣光",["风行者"] = "HC,緑涩",["斯坦索姆"] = "HC,腹肌最讨厌了",["加尔"] = "HB,愤怒之罪;HA,友边的你;G3,提不动刀",["麦迪文"] = "HB,Easy",["密林游侠"] = "HB,Boomboomboom",["鬼雾峰"] = "HB,魔法少女胡歌;G/,未知维度;G8,Nonohnb;G7,祖国的花骨朵儿,祖国的花骨朵",["达隆米尔"] = "HB,大萝卜哥哥",["祖尔金"] = "HB,洪世贤;Gz,林品如",["苏塔恩"] = "HB,黑牛之王",["阿纳克洛斯"] = "HB,加钱;G/,老衲摸摸;G+,鬼切;Gz,家庭女教师,毁灭加农炮",["桑德兰"] = "HB,开盖惊喜丶;HA,察拉旺;G/,来个柠檬",["火焰之树"] = "HB,龙息火炮;G0,阿尔忒尼斯",["弗塞雷迦"] = "HA,天使不在人间;G2,一个冬菇鸭",["龙骨平原"] = "HA,Ozpin;G/,心安处即吾乡;G1,Playerkaiarb",["奥蕾莉亚"] = "HA,落羽神魂,月影灵风;G/,星星点瞪",["红龙军团"] = "HA,樱桃小丸子",["塞拉摩"] = "HA,海医周杰伦;G+,放开丶那只熊;G8,抚琴听泉;G1,逃家小兔,透明雨滴",["艾萨拉"] = "HA,哥只抽玉溪,天使族淋透",["洛萨"] = "HA,苍岚的风",["萨尔"] = "HA,嘟儿メ请留步;G6,主公快走",["永恒之井"] = "HA,战舞者丶;G1,阿兰若",["烈焰峰"] = "HA,丨小灬鹿丨;G5,抠脚猎",["阿斯塔洛"] = "HA,燎牙",["蜘蛛王国"] = "G/,潇潇晓晓,卓然天成;G8,伊沐雪一林语,伊沐雪一珍娜;Gz,伊沐雪",["神圣之歌"] = "G/,夜雨连明;G8,柯哒;G2,丶休",["诺森德"] = "G/,德艺两开花",["熔火之心"] = "G/,四十几个武僧,孤丹丶旎,塔蘭吉公主;G+,淡淡的優傷;G8,Victoria;G6,超烦之萌;G2,苦工哒哒",["迪瑟洛克"] = "G/,又大又粗又长",["巴纳扎尔"] = "G/,冷雨听风",["托尔巴拉德"] = "G/,易知",["银松森林"] = "G/,最后的使徒子",["月光林地"] = "G/,飞剑决浮云;G+,望月莎;G5,风哥;G3,水銀瓷;G0,人非物非世非",["法拉希姆"] = "G/,铁歌;G2,戏听清影横笛",["诺莫瑞根"] = "G/,神也酱酱;G3,山药丶",["血吼"] = "G/,漫漫你好骚啊",["寒冰皇冠"] = "G/,蓝郁;G9,壁垒",["外域"] = "G/,Suyua",["暗影议会"] = "G/,王者之枫;G4,樱木花卷丶",["天空之墙"] = "G/,秋诺",["甜水绿洲"] = "G/,花大妞",["斯克提斯"] = "G/,六星大乱斗",["恶魔之魂"] = "G/,白银之手丶,别奶我",["夏维安"] = "G/,摇了摇头",["纳沙塔尔"] = "G/,娜依秀美",["战歌"] = "G/,飞天小女警",["耐奥祖"] = "G+,Eviljoker",["海加尔"] = "G+,十方霞涌",["艾欧娜尔"] = "G9,秦域珑珑",["幽暗沼泽"] = "G9,阿吉",["古尔丹"] = "G9,血刺印;G2,亚洲王祖贤",["奥杜尔"] = "G8,断水",["血羽"] = "G8,Yukiteru",["玛多兰"] = "G8,Cleisy",["阿古斯"] = "G8,布兰妮丶甜甜",["亚雷戈斯"] = "G7,哀木梯",["守护之剑"] = "G7,莫小舞",["壁炉谷"] = "G7,水蜜桃挽歌;G1,万籁俱静",["暮色森林"] = "G7,我就这么欧",["芬里斯"] = "G6,四二五带孔",["踏梦者"] = "G6,风马不羁",["毁灭之锤"] = "G6,就是丑",["奥尔加隆"] = "G6,晓灬蛮腰;G4,卖萌不卖身;G2,夜幕幽幽",["希雷诺斯"] = "G5,铅笔小欣",["巫妖之王"] = "G5,雪落无痕",["摩摩尔"] = "G5,最后的處男",["图拉扬"] = "G5,缝夏;G0,多洛丽丝",["生态船"] = "G5,瞬狱影杀",["巨龙之吼"] = "G5,空条徐伦",["艾露恩"] = "G4,毛蛤蜊;G3,Luckycore",["蓝龙军团"] = "G3,坎巴斯",["深渊之巢"] = "G3,越长大越孤单",["萨菲隆"] = "G3,滨湖梁朝伟",["德拉诺"] = "G3,天命沐沐",["洛丹伦"] = "G2,月落风云舞",["黑暗魅影"] = "G2,肉嘟嘟",["艾莫莉丝"] = "G1,黄内障",["影牙要塞"] = "Gz,死亡妖灵",["鲜血熔炉"] = "Gz,星界",["萨格拉斯"] = "Gz,风火灬侠客",["地狱咆哮"] = "Gz,南笙"};
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