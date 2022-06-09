local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["末日行者"] = "Zz,书歌;Zy,灬火灬;Zs,风灬无痕;Zf,昨日明日与一;ZX,胸毛萨满丶;ZM,恶灵挽歌;Y6,武术至尊",["冰风岗"] = "Zz,丨紅尘烟雨丨;Zy,夢児乄麥兜,夢児灬麥兜;Zv,破洞牛仔裤丶;Zu,鸽鸡鸭;Zj,雨雾中漫舞;ZZ,叙平生;ZK,纤岚;ZH,桥豆麻袋;ZB,炽燃;Y6,羽衣直夏;Y1,薄荷茶茶;Y0,爱吃橙子",["雷霆之王"] = "Zz,灬羊山芋灬;ZH,壹米贰叁;Y6,伊莉亚;Yu,卡扎库衫",["影之哀伤"] = "Zz,反转指针;Zs,蘑菇小熊;Zo,中文六级;Zl,Meepon,他把它当她丶,丨女子石更灬,丨女子石更丶;Zg,午夜不寂寞丶,午夜不寂寞;Zd,Pommrabit;ZO,易丨外星红大黑;ZM,灬烈刃,枫叶丨;ZI,让我欢乐一点;ZG,不爱抓宝宝;ZE,逝者之血;ZC,请叫我猫儿,阿吉;ZA,小红手丶阿卷,萝卜游侠,红心;Y+,丨止于终老;Y8,飘花为柒;Y6,酒厂之花;Y5,雨夏雨夜;Y2,再战九点零;Y0,凤梨味道;Yz,也曾摘星辰;Yx,翟老师;Yw,丶王小毛;Yu,变化,唐寅字伯虎",["国王之谷"] = "Zy,麒麟丶撒野;Zt,声望加成真香;Zs,贴捏捏的,打不过就修复,酒盏玉露清,老子只会暗牧,顾盼花发鸿蒙;Zi,丨江隂饅頭丨;Zf,天空云天;ZZ,江隂饅頭丨术,戦萌萌丶;ZW,白花恋诗;ZV,国服技师质检;ZO,黑暗咒师;ZM,恋萌萌丶;ZA,尤巴;Y6,冰墩墩雪容融;Y4,梦断不成归;Y0,春之欢愉;Yy,莫大先生;Yx,西丨猛;Yw,花花伊;Yv,咔德伽",["白银之手"] = "Zy,六道丶小熊,天宮桜;Zw,清幽梦丶,轩月上栊,齊天丿大聖;Zu,灬战灵天影灬,猎人转角遇到嫒;Zs,薄樱鬼,Lancelort,破刃之耀,橘陽菜,暝仍不移其晖;Zp,欧皇棒棒;Zm,钻石独角兽;Zl,冰之墩墩;Zj,小负屃;Zg,圆圆的阿坤达;Zd,埃格莱恩,Sissipapa;Zc,紫貂兒,可爱小白兔;Zb,拒收病婿;Za,森与麋鹿丶;ZY,诡影,不会上树的熊,纳尔咖哒,鹿栀栀;ZU,象山小道仙,极昼,伊零;ZT,死于装逼过度,永远爱马竞;ZS,大胡子大智慧,氵阿叶;ZQ,星星红了眼丶,星星落了枕丶;ZP,丹娣丶;ZO,玛德丶法科,Okasa;ZM,Chinfungpld,一步之遙;ZK,维多利亚秀芬,葉洛书;ZH,独孤善心,晋升冲击,打个咚咚;ZG,Sian;ZD,疯不觉丨丨,天使城,Babymillie;ZC,神奇橙夫人;Y+,色批头籽;Y8,请宝贝转身丶;Y7,粉嫩马竞球迷;Y6,说丶一,说一,爱吃糖的唐三,买香蕉去打怪,锦果果,伊姆大人;Y5,萌术萌萌哒;Y2,迷幻人生,賑早見琥珀川,芒果丶布丁;Y1,吃我一锤耶;Y0,流尽几世时光,圣劍;Yz,玩酷花少;Yy,榴莲小领主;Yx,电竞锰男;Yu,丶没办法,人归落雁後",["???"] = "Zy,梁小雨;Zv,大漂亮灬;Zt,咕;Zr,啾咪",["凤凰之神"] = "Zx,麻辣小珑虾;Zw,大耳朵图图丷,Poamphitrite;Zv,小红手窈窈;Zu,术业有专弓丶,流沙河水鬼丶;Zt,定春是美短,哈库拉犸塔塔;Zs,拂晓战歌,亦无所思,猪脚饭真好吃;Zq,仲春廿肆;Zp,醉不知花开;Zn,麦璇风;Zm,普莉斯蒂,別氹我;Zk,恶棍子,硬搞;Zj,左手孤单啊;Zh,Rosinsunyu,喵咕斯,帮她按住我,禧晴;Ze,部落贵族,Bibibb;Zd,丶蝎子莱莱儿;Za,愫白;ZZ,鳳凰神,真气啵;ZX,海耶斯穿山甲;ZW,长弓飞猎;ZU,允禾,哟灬尛柯;ZT,雪乃深冬;ZS,Bibiboomboom;ZQ,充钱那各少年,橙紫㐅,装甲掷弹兵;ZP,Corging;ZO,过路的酱油,学海幠涯;ZN,夏灬雪,生存猎;ZM,坏坏丷;ZJ,梦醉花海;ZH,Bibibibibibi,Bibigun;ZG,鬼舞辻法泠;ZF,来回溜达;ZC,饭团太郎;Y/,華夏丶阿里曼;Y9,丶洒脱,自由羽翼,牧泱犬,那个裂仁;Y7,安菲而德;Y6,三月廿九丶;Y5,圣光寇马克;Y3,情深;Y1,丨恶魔之子丨,树上的向日葵;Y0,翻云覆雨愁;Yz,血精灵丷椰羊丷,紅色冲动;Yy,猴晶旭;Yx,Meon,猫灬小舞;Yv,片小萨,虎丨鲸,椰奶椰奶;Yu,血斧钺戮,墨洺棋妙,张小锤丶,潇潇如雨,悠悠丨德丨心,Sandypriest",["迦拉克隆"] = "Zx,狐闹;Zw,虚空小美眉;Zn,小善萱;ZF,五海雷点;Y9,乐然;Yv,西丨猛",["玛里苟斯"] = "Zx,寒衣",["死亡之翼"] = "Zx,欧利;Zu,道剑丶剑非道,圣光雷龙王;Zt,谜逸,术不奉陪丶;Zs,宥熙美琪,风雨迎彩虹,呜哒,芹菜菠萝;Zr,呀崂山可乐;Zq,星星牛,鑫鑫牛,射程一万米,星星来啦;Zn,Cavalierr;Zi,鲨鱼滑滑;Zg,猥琐的郑钱;Zd,Tab,懂又不懂呀;Zc,丶肉墩;Zb,鲨鱼汉堡;Za,不悦,步仇;ZZ,伐要幫吾佬卵;ZY,櫻井莉娅;ZW,我踏马莱纳,初肆,丶独自等待;ZU,丷相公丷,葱爆鸡翅,楚狂丶;ZT,黑灬鬼;ZR,小鱼儿爱米莉;ZQ,路易丶德華;ZP,Manamasive;ZO,南酱牧宸,融化你的任性;ZM,丷老公丷;ZK,爱神小色;ZI,大鱼丷;ZG,紫米露,她不知道,麦子家的小郎,我不背钅呙;ZF,蓝色一望无际;ZD,血眸之魔,比较恐怖,李槐;ZC,法号丶老空车;ZB,普罗西斯;ZA,死亡之迷翼;Y9,落星贯日;Y8,丶要相信光;Y7,老沉了;Y5,五七;Y4,Witheredvine,Kamino;Y3,之神,三泽大地;Y2,在摸鱼;Y1,蒼海笑,五丶七;Y0,邹哥哥;Yz,绿若青衣,丶红酥手丶;Yx,无人赴约,仇恨之眼;Yw,她如景;Yu,老友如老酒",["罗宁"] = "Zw,柠檬它不萌灬,路人灬;Zu,Vec;Zt,沐斯丶,养只狸花猫;Zk,美淇琪;Zf,Aryashadow;ZW,两个毛球;ZU,狐酱,罗小喵丶;ZT,会长缺徳不;ZP,人生如我,网红镇,我妻由乃;ZM,休凡,清澈的休繁;ZJ,玛塔丶索萨;ZI,仟燕;ZF,腰间盘,是真的椰;ZA,什么小豆苗,昂口田;Y/,东瘟疫之地;Y8,汉唐雄风,戰斗包子;Y6,丶丶斯卡,血染飘发;Y1,大地老虎;Yz,思淼圓圓;Yw,弋妖一独雨;Yv,就是这么烦;Yu,星有零稀",["黑铁"] = "Zw,亿分之五;ZX,雅典娜之刃;ZT,Palo;ZI,乐事妙脆角;ZD,丶可乐要加冰;ZC,冲锋释放;ZA,Nukenu",["亚雷戈斯"] = "Zw,微风轻语;Zf,小渔;Y6,坠落六翼天使",["无尽之海"] = "Zw,Eastward;Zt,寝取;Zs,天之涯海之角;ZY,恶之花;ZV,蹲坑要扶墙;ZU,观海,虚弱的黄毛,北方的狼族;ZK,扶墙而走;ZI,时常丶孤独;ZH,德柴兼备;Y8,艾泽再临;Y4,乄王胖哒,灰灰丨灰灰;Yw,真气啵;Yu,星花火灬",["燃烧之刃"] = "Zw,霓魂蝶;Zv,上帝丶是个妞;Zs,德古拉狗蛋児;Zp,阿斯蒙迪斯,飞菲肥肥;Zh,蒙奇猎手;Zf,别问了不生存;Zb,劣质的劣人,橙墨墨;Za,半佛半神仙丶;ZU,該隐之吻,吃饱的小猪;ZQ,霍乱爱情;ZP,Killeoo;ZN,丶三茶;ZK,阿丁;ZG,不负曾经,烧尽;Y8,巴丁高瑞克什,言颜;Y7,假心人;Y6,十二点二十;Y5,虞狼罓罓;Y4,云端漫步,竹影凌风;Y3,雾隐貔貅,唯谦全吉;Y1,纯攻,大萨摩耶,丶谭咏麟;Yy,丿魑魅魍魎彡;Yv,Isaug",["加尔"] = "Zv,烬斯亻练练,巴雷武;Zs,孤梨",["神圣之歌"] = "Zv,少年油纸伞;Zb,Akiho;ZD,汝听之人言否;Y1,软饭硬吃",["主宰之剑"] = "Zv,爆爆炎丸,猎恶魔手;Zt,梁谷公符,梁谷秋雁;Zo,终极工具人;Zl,琉璃冬海;Zk,马什么梅呀;Zi,爆爆头奶牛;Ze,红得扣胩,雲凤丶;Zc,输出拉库;ZY,马雷凯斯;ZW,逆闪;ZV,葉子豬;ZO,逆光兔姿;ZH,吉茵珂丝;ZE,阿咪児丶;ZB,初春踏雪;ZA,红莲狱火;Y8,兔兎;Y7,太阳系总队长,則卷千兵衛;Y4,露华龙;Y2,红得批爆;Y1,爬进去整丶,握不住的它丶;Yz,西红柿不西;Yy,叁天饿玖顿;Yw,哈罗丶麦芽虫;Yv,国服最强喷子",["密林游侠"] = "Zv,豆腐仔;Zs,风凌雪",["伊森利恩"] = "Zv,从来不背拳谱;Zt,一口小奶啤,临渊羡鱼丨;Zs,鲨鱼鱼子酱,霸王银枪;Zr,马王爷叁只眼;Zj,暴走的大臭;Zg,独立团李团长,鹹寧柒;Zf,圣焰药师;Zd,发糖了发糖咯;Zc,黑心貓丶,无垢白刃;ZY,星河枫;ZP,于浴菊;ZO,板甲依然在;ZG,丶青鸟,Sakota;ZC,泡酱大魔神,沉睡刀锋;ZA,兜兜酱丶;Y+,醉梦相思;Y9,黯灵;Y8,七尺生态牛肉;Y6,鲨鱼辣椒酱紫,下水道狂暴战;Y3,雨宮蓮;Y2,黑色德芙;Y1,夜店之王;Yz,重拳",["日落沼泽"] = "Zv,热砂丶西西",["基尔加丹"] = "Zu,阿肥",["狂热之刃"] = "Zu,无赖小宝;ZY,赤子亦我",["阿克蒙德"] = "Zu,邪丶瞳,布露妮娅",["安苏"] = "Zu,芸谷鹤峰;Zq,妃丶英理;Zn,要相信光啊;Zj,至尊牛宝;Zf,丷塔克;Zb,下完这场雨灬;Za,勤受,贰对德;ZN,月夜战女神;ZF,暴走一个吻;ZE,Jayc;ZD,黯灭之王,原初之王;Y8,Dzlqs,湛蓝千年;Y7,吉娜莱丝;Y6,天依真的无缝;Y5,一闲云野鹤一,Buluphont;Y3,醉眼望云烟丶;Y2,唯有活着;Y1,啊砸;Y0,秘法守护者;Yx,一百万;Yw,刺激哦,咕噜呀",["暗影议会"] = "Zu,血滴铠;ZB,工具仁",["迅捷微风"] = "Zu,苏兮丶丫丫;ZO,旧时代卝残党;ZJ,大灭;Y0,充钱那各少年;Yz,洛希恩徘徊者",["霜之哀伤"] = "Zu,叶師傅;Zl,Hanabii,津門第一;ZJ,乘乘她爸;ZD,南宫筠;ZB,不卖萌不振翅;Y7,何锐;Yx,Zinac",["克尔苏加德"] = "Zt,百事苏加德,兰斯洛斯特,牛牛没奶了,灵魂舞步;Zf,小藤椒;ZT,悠长假期,不破冰菓,大王我想活丶;ZS,风过影无痕;ZQ,花有重开;ZO,舒芙蕾;Y/,抠脚丶大叔;Y2,夜话白鹭丶",["丽丽（四川）"] = "Zt,张嘉译;Zr,七玺;Zg,无尽的叹息;ZM,劍鑫;ZC,星夜千雪月;ZA,圣殿丶之光;Y8,木籽灬;Y6,圣殿之光,主要看气质;Y5,星星侠;Y1,狐了狐了;Yx,小红手狂猎",["血色十字军"] = "Zt,八十八号技師;Zs,給朕跪下;Zo,橙不二冫;Zk,Tomosoul;Zh,赵白给,实哥的小迷妹;ZO,艾别离;ZJ,邪恶光环;ZH,桂丶敏感鸡;ZF,森屿弥鹿;ZE,逝去的怨念,Brabbit;Y/,鱼我所欲;Y4,丶菜头丸;Yz,包丶仔;Yy,洵美且異",["回音山"] = "Zt,破星当;Zs,血条消失;Zo,牌牌战;Zb,Kinomoto;ZW,叕叕;ZU,皮皮摧心魔;ZR,如花;ZQ,甘道夫灰袍;Y/,唯爱丶菲菲;Y5,爱媛果冻橙;Y0,双笙丶什么鬼;Yx,浪漫不加不减",["贫瘠之地"] = "Zs,李哥哥的愛妃;Zl,善哉丨善哉;Zk,最爱猛牛随变;Zd,沈梦溪;ZQ,醒醒的超人;ZP,改为鹅城的鹅,鹅城的鹅;ZO,牛柒柒;ZN,Scandy;ZK,臭臭迪尔;ZB,采蘑菇的阿姨;ZA,狂战霸天,待续丷,霜魂;Y+,过往皆为序章;Y5,Acan;Y4,冯晓萌;Yz,巴索罗米奧;Yy,听不见大声点;Yx,失落的陈;Yw,水云雨诺,狂野水饺",["冰霜之刃"] = "Zs,艾莉儿;Zk,鬼先生;Y8,小甜甜李铁柱",["熔火之心"] = "Zs,丶真谛熊;Yx,给少年的歌",["塞拉摩"] = "Zs,残阳沐血;Zc,潇洒小猪丶;ZO,奎思;ZI,我的朋友很少;ZF,死硬肥牛;Yu,小红手露珠",["提瑞斯法"] = "Zs,Kiluna",["火烟之谷"] = "Zs,为爱战死床头",["灰谷"] = "Zs,小咪憨憨",["菲拉斯"] = "Zs,帕尔木丁",["龙骨平原"] = "Zs,Thebird;ZC,亲密接触",["格瑞姆巴托"] = "Zs,执劍饮烈酒;Zr,血蹄村花;Zi,阿瓦塔斯;ZM,压迫衆生;ZI,潇静藤;ZG,狂暴战老王;ZE,早上不吃小面,不要为难胖虎;ZC,棍棍是好棍棍;Y+,Mzyzm;Y9,小红手迟迟;Yw,你打歪了",["伊利丹"] = "Zs,淡蓝色的忧伤;Zi,执笔画浮尘;ZX,十三香下龙瞎",["艾维娜"] = "Zs,五帝",["元素之力"] = "Zs,德神",["希雷诺斯"] = "Zs,劲爆跳跳糖",["海克泰尔"] = "Zs,炸酱面配白粥;Zm,一颗卤蛋丿;Za,张碧晨;ZV,幽默纯属扯淡;ZD,驭风控弦乄;ZA,狐梅尔斯;Y+,陌灬人;Y9,暗夜树熊;Y2,米乐米乐",["红云台地"] = "Zs,晴空深蓝;Zp,香蕉你喜欢吗;Ze,香蕉她喜欢吗",["轻风之语"] = "Zp,胖球",["逐日者"] = "Zp,斯虞;ZG,尤丶迪丶安",["艾苏恩"] = "Zp,土匪姐姐呀",["卡德加"] = "Zo,郄哥;Zf,黑鴉;Yu,夜月圭",["阿纳克洛斯"] = "Zo,天尝滴酒;ZU,暗影灬烈酒;Y9,為人民服務;Y8,使徒;Y4,雷丶叱咤风云",["金色平原"] = "Zn,玛娜丶双锁;ZS,伊琳奈尔;ZD,雨过芙池;Y9,小凡凡丶;Y8,艾丝丶凯特;Y6,记忆的足迹;Yz,倚楼听雨;Yx,油腻麦迪昂",["达尔坎"] = "Zm,风影吴痕",["蜘蛛王国"] = "Zm,滚滚的樂樂;Y7,堕落西红柿",["苏塔恩"] = "Zk,大木师",["暮色森林"] = "Zk,Adieu",["泰兰德"] = "Zj,摇滚小熊;ZP,萌面欧尼酱;ZN,尼尔迪兰狄",["加兹鲁维"] = "Zj,彡不吃猫的鱼",["奥妮克希亚"] = "Zj,星如雨;ZE,Hillwind",["月光林地"] = "Zh,希灵",["布兰卡德"] = "Zg,卟德鳥;Za,猫不易丶;ZR,莫西丨莫西;ZN,程鹿不送姜;ZH,微光暖暖;ZF,好梦留人睡;ZE,慕蓝晓晓;Y+,汝彼母寻亡乎,发一下光;Y5,暴怒的皮卡丘;Y0,夏沫呆呆;Yw,九个骑士;Yv,艾利摩尔;Yu,白欧欧",["晴日峰（江苏）"] = "Zg,万州烤鱼;ZM,优湖骁",["霜狼"] = "Zf,爫丿爫",["熊猫酒仙"] = "Zf,帕拉丁;Zb,图灵二进制;ZQ,渺淼炊烟丶,Clizumy;ZP,林苑清秋;ZH,兄台何出此言;ZF,了风;Y0,尤型拆卸者;Yx,也是鲁小胖",["银松森林"] = "Ze,光辉闪耀;Y+,黄酒小菜",["扎拉赞恩"] = "Ze,专属小卿",["艾森娜"] = "Ze,仇敌克星,伊利达尔;ZP,禅师",["暴风祭坛"] = "Zd,熊猫牌可乐;Yy,Yellowflashd",["血环"] = "Za,沐橙;Y1,泪流某个海洋",["奎尔丹纳斯"] = "Za,戏如人生",["埃德萨拉"] = "ZY,止爱止殇;ZW,心海呀;ZM,战吊没武器;Y+,湮灭连奏;Y4,Zerokk;Yv,丹丹别打啦",["奥尔加隆"] = "ZW,万德福儿童团",["艾萨拉"] = "ZW,丨游丨侠丨",["烈焰峰"] = "ZW,星氪;ZM,大英雄阿拉什",["希尔瓦娜斯"] = "ZV,缘灬君临;ZJ,心恸,一个眼神",["雏龙之翼"] = "ZV,吃了就睡;Y6,尼古拉斯二狗,胡桃丶",["莱索恩"] = "ZT,御坂灬美琴",["梦境之树"] = "ZS,神血牧",["巨龙之魂"] = "ZR,月缺不改光",["银月"] = "ZQ,莪米豆腐",["玛维·影歌"] = "ZO,丨灬德古拉丶;ZH,晨熙",["托塞德林"] = "ZO,雨疏风骤",["通灵学院"] = "ZO,左手一只鸡",["遗忘海岸"] = "ZO,混帐的天空",["山丘之王"] = "ZN,用心创造快乐;ZB,雷神之箭;Yx,八钳蟹",["摩摩尔"] = "ZN,射丶",["玛法里奥"] = "ZM,嗨嗨人生",["瓦里玛萨斯"] = "ZJ,秦柏",["外域"] = "ZI,泡泡哒希",["艾欧娜尔"] = "ZI,殺人偿命",["奥拉基尔"] = "ZF,弱点就在蛋上",["卡拉赞"] = "ZF,天呐你真帅;ZE,瓶子战",["屠魔山谷"] = "ZE,温暖的圣光",["阿古斯"] = "ZE,傻男",["红龙女王"] = "ZE,西野七濑",["天空之墙"] = "ZC,润鑫",["图拉扬"] = "ZA,葉雨阑珊",["荆棘谷"] = "ZA,希尔瓦纳丽思",["风暴之怒"] = "Y/,一头猪",["石爪峰"] = "Y/,流口水的老牛",["战歌"] = "Y+,瑟莉丝",["铜龙军团"] = "Y+,佑逝",["太阳之井"] = "Y+,长岛冰茶丶",["诺森德"] = "Y+,落榜美术生",["阿迦玛甘"] = "Y9,茉小仙",["风行者"] = "Y9,落幕枯心",["地狱咆哮"] = "Y8,花姑娘滴呦丶",["朵丹尼尔"] = "Y7,孤儿所",["雷斧堡垒"] = "Y6,说丶一,说一",["幽暗沼泽"] = "Y6,诶丫丫疼",["夏维安"] = "Y6,肖申克救赎;Y5,德了个德",["寒冰皇冠"] = "Y5,靠拢",["鬼雾峰"] = "Y5,泡沫崽",["火羽山"] = "Y5,糖乀喵喵",["永恒之井"] = "Y5,背心裤衩",["永夜港"] = "Y3,师气帅",["黑锋哨站"] = "Y3,安妮可姬",["海达希亚"] = "Y2,糖伯虎点蚊香",["洛萨"] = "Y1,雷欧奥特曼;Yu,躲起来的瓶子",["达纳斯"] = "Y0,莱瑞蕾",["黑暗魅影"] = "Y0,桑桑威武;Yx,麦麦兜",["索瑞森"] = "Yz,知见立知",["迦顿"] = "Yz,花开淡墨痕",["安其拉"] = "Yx,Kadenz",["米奈希尔"] = "Yx,别死",["萨菲隆"] = "Yx,青岚挽风",["血吼"] = "Yw,嗜血安抚驱散"};
local lastDonators = "定春是美短-凤凰之神,一口小奶啤-伊森利恩,沐斯丶-罗宁,梁谷秋雁-主宰之剑,梁谷公符-主宰之剑,谜逸-死亡之翼,百事苏加德-克尔苏加德,鸽鸡鸭-冰风岗,猎人转角遇到嫒-白银之手,Vec-罗宁,叶師傅-霜之哀伤,苏兮丶丫丫-迅捷微风,血滴铠-暗影议会,布露妮娅-阿克蒙德,芸谷鹤峰-安苏,邪丶瞳-阿克蒙德,圣光雷龙王-死亡之翼,无赖小宝-狂热之刃,灬战灵天影灬-白银之手,流沙河水鬼丶-凤凰之神,道剑丶剑非道-死亡之翼,阿肥-基尔加丹,术业有专弓丶-凤凰之神,热砂丶西西-日落沼泽,大漂亮灬-???,从来不背拳谱-伊森利恩,上帝丶是个妞-燃烧之刃,豆腐仔-密林游侠,猎恶魔手-主宰之剑,破洞牛仔裤丶-冰风岗,爆爆炎丸-主宰之剑,小红手窈窈-凤凰之神,少年油纸伞-神圣之歌,巴雷武-加尔,烬斯亻练练-加尔,霓魂蝶-燃烧之刃,Poamphitrite-凤凰之神,虚空小美眉-迦拉克隆,齊天丿大聖-白银之手,大耳朵图图丷-凤凰之神,Eastward-无尽之海,轩月上栊-白银之手,清幽梦丶-白银之手,微风轻语-亚雷戈斯,亿分之五-黑铁,路人灬-罗宁,柠檬它不萌灬-罗宁,欧利-死亡之翼,寒衣-玛里苟斯,狐闹-迦拉克隆,麻辣小珑虾-凤凰之神,天宮桜-白银之手,梁小雨-???,六道丶小熊-白银之手,灬火灬-末日行者,麒麟丶撒野-国王之谷,夢児灬麥兜-冰风岗,夢児乄麥兜-冰风岗,反转指针-影之哀伤,灬羊山芋灬-雷霆之王,丨紅尘烟雨丨-冰风岗,书歌-末日行者";
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
      if topNamesOrder[players[index]] then row.name:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(name)) else row.name:SetText(name) end
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