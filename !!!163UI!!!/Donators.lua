local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["影之哀伤"] = "QZ,Melodyi;QN,兜兜里有小小;Pj,小盒饭,吞仙丹上月亮,尾巴甩你脸;Pi,花落伊人醉丶,林深遇见猫;Ph,暴发的小绿,黢夜独行,青空丶;Pc,性感不是骚;Pb,莜筱筱;PY,灌肠丶高手;PT,发霉的肉包子;PO,凉茶必须加冰;PG,再世情緣,天使艾米麗;PF,誴壹迩终;PA,乄臭丫头乄,山川不念旧;O0,东监区苏哥;Ol,暴力冬季,糯米啊糯米",["夏维安"] = "QZ,扬帆彤行;O8,Neverflee;O4,劍聖",["摩摩尔"] = "QY,灬曲终人散灬",["黑铁"] = "QY,Fisshh;Po,Atlantas;Pi,杨永信之手;PP,夏姬丨八射;PO,兽不了丶;PK,丶六月;Ol,砍柴苦情花",["贫瘠之地"] = "QY,烦灬恼,破裤;PW,Tristeza;PQ,小弃;PN,青山一道;PK,憨憨丶;PJ,Hidey;PB,Kollwitz;O9,雨伴戰苍穹,雨伴戦苍穹;O6,米勒;O5,Hopewater,野丶地震,马老板;O2,在乎丶;Oz,人间大炮;Oy,战狂丶成哥;Ov,僵尸兽;Os,凛冬之烬",["狂热之刃"] = "QY,永恒之约;PI,情趣店老板;O2,鈊悠意滿;O0,知黑丶守白",["银松森林"] = "QY,斯布兰蒂得",["死亡之翼"] = "QY,季夏立冬;Po,炭烧肥咕;Pn,马无缰;Pj,生前是吴彦祖;Pi,奶赵;Ph,温大人,肥牛香咕,肥牛香菇;Pg,霁月绛纱,落烬丶断念;Pe,伏猎侍郎;Pb,丶褪色的刺青;PW,重庆雷克萨胖;PU,迪奥伦娜,丨半丨夏;PP,丶梦的碎碎念;PO,会动的牛肉干;PN,丷冰吻鱼丷;PM,Left,南京小王爷丶;PK,放肆更疯狂,丶壹玖零丶;PJ,星隐寺侍僧;PG,羽丶子;PD,江城;PC,像风又像你;PB,熊有个熊样,打不过就合作;PA,奶喘,兰丨衤申;O/,老狼来了呀;O6,你如何回忆我;O5,网瘾阿姨;O4,帕奇威克;O3,拉斯塔哈老蔡;O1,佳宜丶,马老师丶;O0,肉团团;Ox,琰之有理;Ov,小包子儿,爸爸对不起;Oq,芋圆四号;Op,雅典娜丨;On,布祖沃斯格玛;Om,玛鲁娜,牛肉味的鹌鹑;Ol,奈布加斯格玛,大酋长阿强",["恐怖图腾"] = "QY,乱世丶七宗罪",["凤凰之神"] = "QY,非常流行,绫魂小小;QT,Chenmel;QJ,俊秀钧同;Pp,灬极;Po,哎呦喂大吉;Pk,月哥灬灬,无言无伤,詹姆斯棒槌;Pj,似锦若绯红;Pi,梦中的哀嚎;Ph,坑爹丶小子,丨林宗辉丨;Pf,戈罗姆,酣战;Pd,Anarchy,帕拉伊巴,拉希斯;Pc,圣光术是什么;Pa,亦尘;PZ,丷月迷;PY,中堂;PW,觉觉丷,阿丷宝;PT,Marznoo;PS,柠檬帕尼尼,浮光丨浅夏;PQ,女孩你太可爱;PP,姨妈之殇;PN,爱咋咋滴;PL,八七年丶大叔;PJ,烧菜真牛,会所大镖客;PI,楚夢云語丶,我亦飘零久丶;PH,蔷薇大魔王;PF,九一丶,Lvtea;PD,美好每一天;PC,夢一场丶;PA,蛋疼丶口水牛,宫坂珠希;O/,狼族盟約;O+,快乐田园狐;O8,红叶舞山萩;O5,好多好多熊;O4,Edwen,Varien;O3,玖一;O2,末日危城;O0,被诅咒的咕咕;Oy,纯白牛牛,灬灬道灬灬,酒喇嫲;Ox,極武神;Ow,张丶启丶山;Ov,斩炎剑;Ou,至高岭吴彦祖,柿子巧克力;Ot,卿陌,卿墨,菇孃;Os,灬诗灬画灬,白水水,打滚,灯毒,清凈丷;Or,粒狸的豆狸,豆狸的粒狸,腊肉儿,萬物皆可盘丶;Om,食人魔魔法師,霜染流年;Ok,我干啥啥不行;Oj,丽莎女皇大人,四大王,雨落雨听雨",["白银之手"] = "QY,莉丽安;QU,三剑三刀;QP,王青花;QN,秋汕澪;Pn,玖月离非;Pl,萌萌哒的熙熙;Pk,马鹿鹿,蓋洛特,蜜汁叉烧味;Pj,普洱丶;Pi,凌波微巭;Pe,阿浩丶阿雯,阿浩丶,上帝的杨,零下十度的夜;Pb,无色空澄,Leezia,翻滚吧小黑妹,杜皮丶,夏天好厉害;PX,丨喜鹊丨;PW,耀星;PU,导演丶他耍赖,长尾喵;PT,盗帥留香灬,胖豆豆丶;PR,風起苍岚;PQ,在吗借五十;PP,君鹏;PM,Crushso;PL,背后的老夫子;PI,露普丝蕾琪娜;PC,岚妖儿,江月,阿雯丶阿浩;PA,白面口袋,奶丨瓶;O/,阿尔西摩;O9,阿雯丶爱吃肉;O7,阿浩丶爱吃肉;O6,半白半黑;O5,Wander,小芙蝶;O4,少年的右手,但为君故丶;O3,骚蹄子伊伊;O0,血靈灬残殇,Fovhunter;Ow,項羽;Ou,洛薩之锋;Ot,塞雷纳特;Os,芊蓉寒月;Oq,跟着老子冲,碎光;Om,蔡靓猪,喂小喵;Ol,灬麦克雷;Ok,凯撒的祝福",["埃德萨拉"] = "QY,烟花丶,苇名壹心;PT,鹿儿岛岛花;PM,鱼丸蘸酱;PK,午觉;PI,这个职业没腿",["永恒之井"] = "QY,隔壁宋叔叔;PZ,风太羲;O2,Stefanice",["黑翼之巢"] = "QY,山大爷",["洛萨"] = "QY,要面包的举手",["安苏"] = "QY,啤酒加烟,有执照的流氓,带执照的流氓,戴兹;QX,爆米花骑士;Pp,丶一天世界晴;Pn,村东头丶老高;Pi,肥宅快樂水;Pe,时光的微笑丶;Pb,奥伯莱恩灬;PY,州徐苏江云;PV,丿姥顽童丨灬,提拉米苏乄;PU,爱不易小狐;PQ,廉猛水萨;PO,丷妹可辣舞丷,静静听风;PE,丨云韵丶;PD,复仇惩戒;PC,丿姥衲丨灬灬;O7,左奶上一刀;O6,千里流江,千里流亡;O5,黑糖白咖啡;O0,一颗西红柿丶;Oz,时光在走丶;Ot,绿旋风浩浩,玥耳;Oo,暖屿;Ol,丑老湿;Ok,夏蝉不识冬雪,美杜莎女皇丶",["燃烧之刃"] = "QY,南城亿潇湘;QX,谦大爷;QQ,夏夜暖风;Pr,艾姆纳米;Pl,丷法兰克丷,小诗宝宝;Pi,玛洛恩;Ph,丶無她;Pe,画画的北北;Pc,旺崽牛奶丶;Pb,喵奴;Pa,世间百态丶;PZ,牧云笙歌,枫闲;PY,阿斯特拉丶;PV,望江晴;PT,青灯伴浮生;PO,尘封如梦;PL,認真你就輸了;PH,Libcorpio;PG,变个萌德;PE,网瘾少年小虎,桃红色;PC,傅友兴,啾啾呢,阿啾,炫乂復仇;PA,超人爸爸丶;O+,Yiwar;O9,炫腹马甲线;O5,丷苏喂苏喂丷;O1,Szsz;O0,太壹,苍凉;Oz,黑手军团首席;Ox,百变大铁锤;Ou,奈奈娅;Ot,卿沫,卿殁;Os,跟我去冒险,好大一颗仙丹;Or,糯米糍乀,帝尧;Oq,鑫欣;On,哎呦宝藏男孩;Ol,奥利给大铁锤;Oj,Ultman",["血羽"] = "QY,尐妖妖",["格瑞姆巴托"] = "QY,添添,炒鸡无敌大臭;QX,香酥猪排;QV,丶板栗,神兎唲;Pp,禅那心中浮尘;Pk,绿青蓝紫;Pj,缘梦无痕;Pi,Atelyn;Pc,丨灬泪,生如夏花的兔;Pb,叹息的富士山;PX,陆无双丶;PW,熙顔;PR,夏丶坎;PM,困兽之斗,一声吼抖一抖;PJ,狐鸡耳芒;PI,丁丁小公主;PD,祭祀;PA,Vintneo;O/,小牛丹尼;O+,Hicowboy;O5,无擎哈啦少;O4,遗世忘累;Oz,Dioda;Ox,她说丶丶;Or,萨鲁法尔之手;Op,吕奉先丶;Ok,旧城的涂鸦;Oj,Lman",["麦迪文"] = "QY,寒静萱;PC,我是乳娃娃",["无尽之海"] = "QY,今年夏天;Ps,骚皮皮;Po,心太软;Pm,惠二萌;PY,佩佩大人;PS,為了世界和平,龍爷;PQ,海猫饭店;PI,Blassirter;PF,屋檐下的飘飘;PB,左右萨满;O6,心脏;O2,迷失微笑而已;Oz,大橘為重;Ox,一半人生,顽固;Ov,Kollwitz;Oq,卡门漩涡;Om,是撸撸啊;Ok,舒歌夜;Oj,言书",["阿纳克洛斯"] = "QY,貓糧;Pa,心泣涟漪;PR,Samurai;PB,籃子裏的果;O/,安静猎",["破碎岭"] = "QY,长歌;PY,约书亚的祭礼;PX,请叫我战神丶;PU,迷茫的红茶,迷茫的桃子,迷茫的印记,迷茫的饼干,迷茫的雪花;Oq,舆你無关;On,Turbowarrior;Ol,Moubuns;Oj,呜啦呱唧",["罗宁"] = "QY,钟隐;Pl,桥本有菜丶;Pf,罗伊斯;Pe,深田咏美丶;Pb,西一欧米;PX,水灬镜;PO,温暖的小表妹,Buff;PI,伊卡洛斯灬殇;O+,蓝轩宇;O8,迈克尔丶傏僧;O4,幂大白丶;O1,海边的一封信;Ov,三上悠亚丶;Or,海以东不老松;Oj,似風沒有歸宿",["血色十字军"] = "QX,暴走的忒提斯;Pf,极恶贝利亚;Pd,伊薇;PL,神州丶风行者;PJ,錒甘;PH,拉格纳灬碎骨;PC,陈洁琪丶;O8,阿尔托利亚丿;Ox,长得真差,蜂蜜熊儿;Ow,没有秘密;Ou,兽帝丶;On,哈姆炸炸",["瑞文戴尔"] = "QX,庞斑",["国王之谷"] = "QW,花飞虚灬;QO,蟹酿橙;P0,葵叶至夏季丶;Ph,圆圆会咬人;Pg,肚子丶不饿;Pf,伺晨;Pb,韦小宝丶,虚空征服者;PO,千杯不倒丶;PL,赤豆小丸子;PI,Desseth;PH,灬祖宗灬;PB,杀手小白兔;O/,橙杛,御宅伴侣丶;O+,时光氵荏苒;O1,小小石头弟;Ov,索拉丶织风者;Or,黑暗中的火",["巴纳扎尔"] = "QP,王者行殇",["伊森利恩"] = "QH,可白;Pg,贪财鬼污昂;Pf,哈尔摩尼;Pe,姥攻;Pd,炽煌;Pb,贝恩铁岭;PW,来自夏尔的兔;PJ,天使喵;PI,不想睡;PH,猛子俺瘸子好腿;O/,歪比扒卜,豪佬;O7,浓睡不消;O6,花开荼蘼丷,东尼丿大木;O5,Shaldoreirua,Shaldoreiru;O4,苏焕城;Oz,灬旋律;Oy,Setfree;Ow,屋里几个蛮娜;Ou,丶是猫姐吖;Ot,紫枫萧瑟;Os,胖达丶踏岚;Or,大港王琳钧;Ol,冰与灬之兔丶;Ok,Taxx;Oj,Dryaid",["迅捷微风"] = "P3,橙羯奇;Ph,充钱那个少年;Pc,灬浅墨;PQ,星辰小点点;O3,海的夏天",["梅尔加尼"] = "P0,伤寒老汉;Pe,悄悄的猪;Ox,锤子光",["奥特兰克"] = "Pp,冰凌之心;PP,汏汏的迪奥毛;O4,仲夏的风;Ou,耶梦加得丶",["塞拉摩"] = "Po,虔诚的蛋",["阿尔萨斯"] = "Pn,蒹葭慕晚霞;PS,梦游症",["达斯雷玛"] = "Pn,土中藏地",["主宰之剑"] = "Pn,聖光大领主丶;Pm,受笔男叁;Pj,一了然一;Ph,贰月的风儿;Pe,我想吃酸菜,痛楚无常,凛冽严冬;Pc,二抠;PW,猫玖青栀;PO,洛丹伦彭于晏;PL,路瓜皮,可爱的小萌新;PG,丩葵司丩,贼特耐;PC,富婆丶;PB,喜欢脚磨咖啡;O6,猫熊是熊,萌丶太骑;O2,仓颉灬;Oz,莹莹妈;Ow,欧洲皇家海豹;Ot,昭武吕归尘;Os,零距离的吻;Oq,离炎,哈撒灬给,情蔏;Op,彡葵司彡,你艾希我奶妈;Om,浓缩钢铁侠",["塞泰克"] = "Pn,姬无影",["熔火之心"] = "Pm,迷人的大嫂;Pb,酱油雄仔;PR,妖僧;Oo,丶小筱丶;Om,麒麟仔",["翡翠梦境"] = "Pm,杰良尼影",["丹莫德"] = "Pl,天竺兰影",["阿拉希"] = "Pl,学不会开锁",["通灵学院"] = "Pk,比利兄贵",["末日行者"] = "Pk,一只小污;Pi,优子樱;Pf,猫扑丶;Pc,薇薇鹌;Pb,火丶女;O/,火锅小超人;O8,萧灵汐;Oy,塔尔杰;Ow,银色烈阳,荭麋鹿,荭锦鲤,荭粒粒,傀儡兔;Op,永远别惦记;Om,丶嚒嘚感情丶;Ok,陈有才",["回音山"] = "Pk,假活;Pi,Severusz;Pe,Kmax;Pb,大锤锤敲你胸;Pa,水依依;PC,派大星丷;Ov,打工帝皇;Op,诺丶流年似水;Oj,孤星繁",["银月"] = "Pk,阿巴啊吧",["迦拉克隆"] = "Pk,丶燒房員;O/,廚神諾米,財神周卓,寧神劉浪,福神尚喜;Os,天边丨;On,婕拉德之影",["克洛玛古斯"] = "Pj,龘龖灬哲",["万色星辰"] = "Pj,浪漫片段",["夜空之歌[TW]"] = "Pi,塞西莉亞安",["石爪峰"] = "Pi,小白天然呆;PV,光之信徒",["燃烧军团"] = "Ph,衷愛",["末日祷告祭坛"] = "Ph,你竟然又",["泰兰德"] = "Ph,Animo",["加兹鲁维"] = "Ph,粉墨兔暧斯",["古尔丹"] = "Ph,卑微小刘",["斯克提斯"] = "Ph,洁萝,人間萝",["冰霜之刃"] = "Pg,性感的小豹子;Pf,缡楚,乄哎呦喂丶;PB,悬狐济世;O2,镇会之宝浅念;Oo,怜风耽星稀;Om,疯狂至尊",["诺森德"] = "Pg,保持优雅;O7,Azuta;Ok,凯恩血蹄丶",["卡德罗斯"] = "Pf,米兰小暗号;O7,奶包迷了鹿;O6,Gyshentt;Om,萌丶滚滚",["晴日峰（江苏）"] = "Pf,涉川",["冰风岗"] = "Pe,Scottsummer;PY,阿洛洛酱;PX,水灬镜;PO,先奶为敬;O/,孑曦;O1,百鬼夜行;Ow,做面包的厨神;Oj,腐蚀者千年",["雷克萨"] = "Pd,这个武僧",["熊猫酒仙"] = "Pd,东来问道,不战即亡;Pb,岚妖儿;PV,青玉德丶;PH,Xbxbbby,奥利奥奶酪;Oy,明小说;Ot,燃烧大根",["丽丽（四川）"] = "Pc,徳鲁伊丶",["雷斧堡垒"] = "Pb,咆哮的老狼;O+,路西法的堕落",["遗忘海岸"] = "Pb,逍遥的狮王;Oj,干丶将",["风行者"] = "Pb,娱酒",["金色平原"] = "Pb,丨简丨;PW,麦芽酱;PV,Ribs;PP,相信我,奥克班恩;PB,迷茫的抹茶,迷茫的雪碧;O4,北京,Turbos,Cullinan;Os,Sunyé;Om,帥嘟嘟;Oj,九方醉蓝,布兰斯丶鹰爪",["艾欧娜尔"] = "Pb,双刀大魔王",["血吼"] = "Pa,江東小覇朢;PH,咆哮的公牛;Ot,莉娅德淋",["蜘蛛王国"] = "Pa,Duck;PL,幽雅布丁",["朵丹尼尔"] = "PY,Murmure",["米奈希尔"] = "PY,倾城之恋,初恋",["壁炉谷"] = "PW,紫宫法燕",["玛维·影歌"] = "PV,夏夜",["埃克索图斯"] = "PU,冷凝焰丶,寒江孤影丶",["金度"] = "PU,楠丁格尔",["月光林地"] = "PT,後來的我們;O2,一半人生;Ox,灬笑忘歌,狂奔的阿加西,顽固灬仓颉,最后一个夏天,八月薇安",["玛诺洛斯"] = "PR,醉里一逍遥;O1,追尾巴的猫",["黑锋哨站"] = "PR,柒煞星",["霜之哀伤"] = "PQ,射交达人;O2,心心过往",["希尔瓦娜斯"] = "PO,爱罗武勇;O/,你喝酒我买单",["德拉诺"] = "PO,男神,紫鳶",["阿卡玛"] = "PO,黑夜游魂",["天空之墙"] = "PL,超级大宝劍;Oy,超级大宝剑",["诺莫瑞根"] = "PL,奥兰倪",["提瑞斯法"] = "PK,Loers;O5,阿平呱呱叫;Oz,李丶大丶喵",["诺兹多姆"] = "PJ,幻舞驭风;PH,风语断续;Ok,嚣张威廉",["扎拉赞恩"] = "PI,第六個騎士;Ol,落月情",["屠魔山谷"] = "PI,神圣凯莎",["克尔苏加德"] = "PH,爱可以别深爱;PD,被遗忘的二嬢;O3,Zorro;O1,墨痕星耀;Ox,莫桑比克;Oq,Lachmosa",["瓦拉纳"] = "PH,迷茫的咕咕",["阿古斯"] = "PH,还我小鱼干;Oz,Liebelos",["卡德加"] = "PH,天真的无邪",["奥蕾莉亚"] = "PG,高手,酵母君",["灰谷"] = "PG,水煮牛肉;Oo,锋利的剑刃",["时光之穴"] = "PG,二十九号技师;Oj,起点丨无畏",["海克泰尔"] = "PF,小烂芒果;Os,内个小徳",["安格博达"] = "PE,夜夜当新郎",["鬼雾峰"] = "PE,肆季逗;O5,儒雅猎手;Oy,丨拒绝丨;Oj,叁上悠亚",["阿扎达斯"] = "PE,垜垜灬沫蓠;Or,大车",["范达尔鹿盔"] = "PE,鸳鸯不羡仙",["红龙女王"] = "PD,西蜀霸王",["瓦里安"] = "PC,尖端科技",["奥达曼"] = "PB,死神之吻",["神圣之歌"] = "O9,阿脑袋丶",["阿克蒙德"] = "O8,你说扯不扯",["艾维娜"] = "O6,纳兰小龙",["布兰卡德"] = "O6,巴彦格勒顺,软软仙女;O5,秦月桜;O3,雪碧加枸杞;Oz,阿布多瑞;Ol,白丶小柔;Ok,铁骑丨后生儿",["桑德兰"] = "O5,典狱长",["斯坦索姆"] = "O5,Kissofevil",["黑暗之矛"] = "O5,有事宝宝上",["菲米丝"] = "O4,昨晚你真坏",["闪电之刃"] = "O3,光明奶茶;Op,寂寞晚萧瑟",["迪托马斯"] = "O3,追风逐影",["玛里苟斯"] = "O2,茉嘉娜;Ox,如果回忆",["血环"] = "O2,进口喷子",["风暴峭壁"] = "O0,大地之魄;Ok,鲁万亿",["烈焰峰"] = "Oy,小拳拳",["利刃之拳"] = "Oy,饼干超人",["暗影之月"] = "Ox,能能",["拉文凯斯"] = "Ov,归心",["瓦丝琪"] = "Os,亡心",["萨尔"] = "Os,杨綿綿",["亚雷戈斯"] = "Os,没袜子的多比",["黑龙军团"] = "Os,新新丶",["海加尔"] = "Os,花千岁",["达尔坎"] = "Or,神奈川",["霍格"] = "Or,光幔小蜜蜂",["战歌"] = "Or,专业卡门",["冰川之拳"] = "Oq,天执颜华",["大地之怒"] = "Op,村正",["拉文霍德"] = "Oo,凉风西西",["试炼之环"] = "On,深灬白色",["深渊之巢"] = "On,风一样的包子",["艾萨拉"] = "Oj,福利社头牌",["法拉希姆"] = "Oj,平子",["伊利丹"] = "Oj,Ukulelekenny"};
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