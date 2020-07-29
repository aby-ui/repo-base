local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["燃烧之刃"] = "O+,Yiwar;O9,炫腹马甲线;O5,丷苏喂苏喂丷;O1,Szsz;O0,太壹,苍凉;Oz,黑手军团首席;Ox,百变大铁锤;Ou,奈奈娅;Ot,卿沫,卿殁;Os,跟我去冒险,好大一颗仙丹;Or,糯米糍乀,帝尧;Oq,鑫欣;On,哎呦宝藏男孩;Ol,奥利给大铁锤;Oj,Ultman;Og,红烧米豆腐;Od,治疗链;Oc,奥格老铁匠;OU,蘇丶清风;OT,优雅的疯子丶,漓汐;OQ,你们的小宝贝,李商琪;OM,风清丶云淡,锁喉丶伏击;OL,尼古拉丝铠骑,奋斗中的熊少;OK,Menethilxx;OJ,让风带我飞,彭大春;OI,念瑶;OE,萨米亚",["罗宁"] = "O+,蓝轩宇;O8,迈克尔丶傏僧;O4,幂大白丶;O1,海边的一封信;Ov,三上悠亚丶;Or,海以东不老松;Oj,似風沒有歸宿;Oe,宿命,年迈的阿炳;Od,夜雨灯;Oc,莉娜因巴斯丨;OU,鬼墓;OS,法爷;OR,一箭泯恩仇,银龙斗罗;OP,夹馍,菠萝波洛;ON,云梦丶远道;OM,筱法丝;OL,流鼻血的凡凡;OE,梦里是谁",["雷斧堡垒"] = "O+,路西法的堕落;Oc,Libras;OO,琻閃閃;OE,河西",["凤凰之神"] = "O+,快乐田园狐;O8,红叶舞山萩;O5,好多好多熊;O4,Edwen,Varien;O3,玖一;O2,末日危城;O0,被诅咒的咕咕;Oy,纯白牛牛,灬灬道灬灬,酒喇嫲;Ox,極武神;Ow,张丶启丶山;Ov,斩炎剑;Ou,至高岭吴彦祖,柿子巧克力;Ot,卿陌,卿墨,菇孃;Os,灬诗灬画灬,白水水,打滚,灯毒,清凈丷;Or,粒狸的豆狸,豆狸的粒狸,腊肉儿,萬物皆可盘丶;Om,食人魔魔法師,霜染流年;Ok,我干啥啥不行;Oj,丽莎女皇大人,四大王,雨落雨听雨;Of,不是我的海;Oe,张满月丶;Od,浅蓝艳爱,水晶裂痕,Septicflesh;Oc,吴彦阻,百叶刃,标准小菜;Ob,倔强呀,六库仙賊,牛犇五十陆,立白;Oa,落水无痕;OZ,情言周;OY,月影娘;OW,邀明月,乾尨,爆戾肘子;OU,聖光妖灵;OS,江小宝丶;OR,灵犀丷;OP,我能打挺多个,牙肿了;OO,国王与乞丐,大红,留恋,马尔蒂尼丶;ON,雨落雨落雨;OM,丶魔封锅,夜夜子;OL,鸢尾花与猫;OJ,檐上落白,伍柒捌,失于指縫,特雷泽盖丶;OI,灬尛冷灬,马尔蒂尼丶一,莫伦特斯丶;OG,Magicxia",["格瑞姆巴托"] = "O+,Hicowboy;O5,无擎哈啦少;O4,遗世忘累;Oz,Dioda;Ox,她说丶丶;Or,萨鲁法尔之手;Op,困兽之斗,吕奉先丶;Ok,旧城的涂鸦;Oj,Lman;Od,又帅又能打,我愛丽丽;OX,倾酒念故人;OW,遣散;OV,丶貔貅丶;OU,欧皇卡卡罗特,嫂子;OP,宝宝蘸大酱;OO,万雪千山;ON,挽手欧巴;OL,萌脸大瞎,義丶隨風;OK,八重樱丶丶;OI,灬弘一灬,丨一棵小菜丨,丨一颗小菜丨;OH,游心寓目;OE,小犄角角丶",["国王之谷"] = "O+,时光氵荏苒;O1,小小石头弟;Ov,索拉丶织风者;Or,黑暗中的火;Of,寒风凛冽;Od,美美萌哒哒;OY,笔刀春秋,回忆的箭丶,饅頭老甲魚;OX,深蓝灬咏叹;OT,笙瀟沫;OS,我是谁的青春;OP,大手套小手套;OL,丶零丶;OG,丨芣茬犹豫丨,索利达尔丶;OF,柯塔娜水晶,Damon,沧岚丶影月;OE,瞧我眼色行事,憨憨的仔丶",["贫瘠之地"] = "O9,雨伴戰苍穹,雨伴戦苍穹;O6,米勒;O5,Hopewater,野丶地震,马老板;O2,在乎丶;Oz,人间大炮;Oy,战狂丶成哥;Ov,僵尸兽;Os,凛冬之烬;OZ,人美歌甜,星火煌煌;OX,给俺老牛摸摸;OU,二手乄;OT,血月梦魇,六月如故丶;OQ,三牤子;OM,鲁飞;OK,不死斬;OH,想过离开",["神圣之歌"] = "O9,阿脑袋丶",["白银之手"] = "O9,阿雯丶爱吃肉;O7,阿浩丶爱吃肉;O6,半白半黑;O5,Wander,小芙蝶;O4,少年的右手,但为君故丶;O3,骚蹄子伊伊;O0,血靈灬残殇,Fovhunter;Ow,項羽;Ou,洛薩之锋;Ot,塞雷纳特;Os,芊蓉寒月;Oq,跟着老子冲,碎光;Om,蔡靓猪,喂小喵;Ol,灬麦克雷;Ok,凯撒的祝福;Of,黑暗中的守护;Od,破刃之魂;Oa,灬逐影寻声丶,黑暗收割者丶;OZ,酒魅;OY,阿浩丶不吃素,阿雯丶只吃肉,Blacksails,丨無灬痕;OX,棠果,赢卿;OT,司小元,歪歪酱丿;OR,唔多侍,净空领域,仙糖;OP,芝麻儿;OO,宝玛士;ON,雪月花时,雨夜幽兰丶;OM,萨鲁曼斯;OK,小巧的老胖子;OJ,陇右张小敬;OI,猎杀梦境;OG,黯之星霏;OF,無法潕天;OE,十八岁美女",["阿克蒙德"] = "O8,你说扯不扯;OI,瓦拉几亚",["夏维安"] = "O8,Neverflee;O4,劍聖;ON,神聖流氓",["血色十字军"] = "O8,阿尔托利亚丿;Ox,长得真差,蜂蜜熊儿;Ow,没有秘密;Ou,兽帝丶;On,哈姆炸炸;Oi,弋江水;Of,哥哥你最棒;Od,冰激凌;Oc,Kom;OZ,背后一只猫;OX,假面骑士;OW,命硬丶;OV,Proff;OG,阿浩丶不吃素;OF,幽魂丶逐风;OE,语瞳",["末日行者"] = "O8,萧灵汐;Oy,塔尔杰;Ow,银色烈阳,荭麋鹿,荭锦鲤,荭粒粒,傀儡兔;Op,永远别惦记;Om,丶嚒嘚感情丶;Ok,陈有才;Of,尐软;Oa,夕灬锘;OQ,小令悠悠;OP,小野君;OJ,Seventhapos;OE,月光大叔",["卡德罗斯"] = "O7,奶包迷了鹿;O6,Gyshentt;Om,萌丶滚滚",["诺森德"] = "O7,Azuta;Ok,凯恩血蹄丶;Od,慕尘",["安苏"] = "O7,左奶上一刀;O6,千里流江,千里流亡;O5,黑糖白咖啡;O0,一颗西红柿丶;Oz,时光在走丶;Ot,绿旋风浩浩,玥耳;Oo,暖屿;Ol,丑老湿;Ok,夏蝉不识冬雪,美杜莎女皇丶;Of,祈胜,贵族大领主;Oe,牛富贵,用心感受丶;Od,丿姥衲丨丶灬;Oc,安苏安苏;OX,最帅那个骑士;OU,老顽童灬,看看内脏,悟小小;OT,丨南京小杆子,牛奶没奶;OS,无怨丶无悔;OR,钱滚滚呐;OQ,酒丶侠,巨馍沾酱丶;ON,加菜啊;OM,猎老;OL,祈赞;OF,又又鸟;OE,小天罡星,小言酱,彡野猪佩奇彡",["伊森利恩"] = "O7,浓睡不消;O6,花开荼蘼丷,东尼丿大木;O5,Shaldoreirua,Shaldoreiru;O4,苏焕城;Oz,灬旋律;Oy,Setfree;Ow,屋里几个蛮娜;Ou,丶是猫姐吖;Ot,紫枫萧瑟;Os,胖达丶踏岚;Or,大港王琳钧;Ol,冰与灬之兔丶;Ok,Taxx;Oj,Dryaid;Og,Jasdek,怒吼之火;Ob,故事的小黄呱;OZ,丶夜澈;OY,饭盒里的饭;OX,就要吃肉肉;ON,毒素萃取图腾,红旗漫江山娇;OF,牛边",["主宰之剑"] = "O6,猫熊是熊,萌丶太骑;O2,仓颉灬;Oz,莹莹妈;Ow,欧洲皇家海豹;Ot,昭武吕归尘;Os,零距离的吻;Oq,离炎,哈撒灬给,情蔏;Op,彡葵司彡,你艾希我奶妈;Om,浓缩钢铁侠;Of,梦尛白,星辰妃昨夜;Oe,六个核桃哦,老而弥坚丶;Od,丨乳比山高丨;Oc,西元前的风;OZ,潢小星,藏韵;OW,加农小钢镚,阿鹿灬;OP,忧郁的麦麦;OO,特仑灬酥;OL,小黄鸭丶,梦麦鸭;OK,钙嘉锌;OJ,捌月壹拾伍;OH,离炎流;OE,为你联盟",["艾维娜"] = "O6,纳兰小龙",["无尽之海"] = "O6,心脏;O2,迷失微笑而已;Oz,大橘為重;Ox,一半人生,顽固;Ov,Kollwitz;Oq,卡门漩涡;Om,是撸撸啊;Ok,舒歌夜;Oj,言书;Og,追忆惘然;Of,黑暗中的守护;Od,灵乱感觉;OY,辛巴达远山;OO,月丶半小夜曲",["布兰卡德"] = "O6,巴彦格勒顺,软软仙女;O5,秦月桜;O3,雪碧加枸杞;Oz,阿布多瑞;Ol,白丶小柔;Ok,铁骑丨后生儿;OX,心灵的声音;OU,谒血之城,织梦之城,觉醒之城,雾泪之城,天怒之城;OO,虹影之城",["死亡之翼"] = "O6,你如何回忆我;O5,网瘾阿姨;O4,帕奇威克;O3,拉斯塔哈老蔡;O1,佳宜丶,马老师丶;O0,肉团团;Ox,琰之有理;Ov,小包子儿,爸爸对不起;Oq,芋圆四号;Op,雅典娜丨;On,布祖沃斯格玛;Om,玛鲁娜,牛肉味的鹌鹑;Ol,奈布加斯格玛,大酋长阿强;Oi,张海棠;Og,呆萌的小鱼酱;Of,小手灬云墨;Oc,上星期天,七芯麦灬,某吃瓜群众;Oa,微扬的风,钢弹大叔;OY,奔波儿壩壩;OT,王秋实,五道杠小青年;OR,杰克丶斯帕洛;OQ,尤朵啦丶,西呱丶,紫蘇丶,孙丶燕姿,謎翼,谜翼,小喵呔,拜月幽灵,Soii,華氏溫度;ON,夜轻影,烈焰烽爆;OM,满脸迷糊,深渊统领;OL,Wastee;OJ,欧鳇体制;OH,浪里个浪味仙,杯丶莫停;OG,陈寞;OF,破碎的膝盖;OE,锦程锦瑜,Merr",["桑德兰"] = "O5,典狱长;OX,微弱思念之人",["斯坦索姆"] = "O5,Kissofevil",["黑暗之矛"] = "O5,有事宝宝上;OT,子瑜",["提瑞斯法"] = "O5,阿平呱呱叫;Oz,李丶大丶喵;Oe,釋迦摩尼",["鬼雾峰"] = "O5,儒雅猎手;Oy,丨拒绝丨;Oj,叁上悠亚;Oi,乂雨愛乂;OT,終归尘土;OL,青眼究极聋;OE,Deadboom",["奥特兰克"] = "O4,仲夏的风;Ou,耶梦加得丶",["菲米丝"] = "O4,昨晚你真坏;Of,李大锤",["金色平原"] = "O4,北京,Turbos,Cullinan;Os,Sunyé;Om,帥嘟嘟;Oj,九方醉蓝,布兰斯丶鹰爪;Od,转身依然微笑,星河迢迢;Oc,林木森,小菩萨;Ob,贪吃的卡比兽;OY,江城之;OS,归于无梦;OL,强哥太坑了,惊悚琉璃盏;OK,沈璧君;OJ,嘿嘿呼呼黑;OE,杰赫妮拉",["克尔苏加德"] = "O3,Zorro;O1,墨痕星耀;Ox,莫桑比克;Oq,Lachmosa;Oc,雄州雾列;OK,墨湮斩夜",["迅捷微风"] = "O3,海的夏天;OZ,萌萌的奶妹;OQ,天天撸猫猫;ON,你很好吃啊,你可真香啊;OL,下五洋捉鳖;OH,卖萌地板贼",["闪电之刃"] = "O3,光明奶茶;Op,寂寞晚萧瑟;OW,波波塔利;ON,源氏",["迪托马斯"] = "O3,追风逐影",["月光林地"] = "O2,一半人生;Ox,灬笑忘歌,狂奔的阿加西,顽固灬仓颉,最后一个夏天,八月薇安;OQ,囡囡囨囚囨図;OE,炮妈",["狂热之刃"] = "O2,鈊悠意滿;O0,知黑丶守白;OX,墨淺丶鬼魅;OG,琴瑟博芳泣,碎丶",["永恒之井"] = "O2,Stefanice;OP,泽晨",["冰霜之刃"] = "O2,镇会之宝浅念;Oo,怜风耽星稀;Om,疯狂至尊;OM,卡殿",["玛里苟斯"] = "O2,茉嘉娜;Ox,如果回忆",["霜之哀伤"] = "O2,心心过往;Oe,维琳德丶星歌,布丽吉塔丶,Nebulamk;OP,布里吉塔丶;OL,老花猫",["血环"] = "O2,进口喷子;OP,不厌骑烦",["玛诺洛斯"] = "O1,追尾巴的猫",["冰风岗"] = "O1,百鬼夜行;Ow,做面包的厨神;Oj,腐蚀者千年;Ob,陽光射手;OZ,尧小尧;OX,Davemustain;OV,關羽雲長;OU,每天的九栗,尤伊;OR,Jokerys;OL,Rebirthbank;OK,修不同丷;OJ,萝卜烫了嘴;OG,Daolai;OE,幕天流觴",["风暴峭壁"] = "O0,大地之魄;Ok,鲁万亿",["影之哀伤"] = "O0,东监区苏哥;Ol,暴力冬季,糯米啊糯米;Of,可乐吹一瓶;Oc,霓裳若羽;OV,Sweetyplus;OR,月下小剑仙;OO,布洛老爹,清浅丶半夏;ON,大写的感叹号;OM,吸零纳一高,姜贞羽加油吖;OI,君莫笑乄;OE,德之吾幸丶",["阿古斯"] = "Oz,Liebelos;OM,下岗女工淑芬;OF,小熊宅急送",["天空之墙"] = "Oy,超级大宝剑",["熊猫酒仙"] = "Oy,明小说;Ot,燃烧大根;Oi,茶小影;Oe,绛色大猫星;Oa,信仰灬战;OV,鎏哖;OT,无敌的缰绳;OP,牧始;OE,泰瑞昻,劒来",["烈焰峰"] = "Oy,小拳拳;OJ,超人猪",["利刃之拳"] = "Oy,饼干超人",["梅尔加尼"] = "Ox,锤子光;ON,瘟疫领主",["暗影之月"] = "Ox,能能;OV,丶柒;OS,曜光之吻;OL,小奶兜",["回音山"] = "Ov,打工帝皇;Op,诺丶流年似水;Oj,孤星繁;OP,洛枳;OF,赞恩防御者,小马萌萌哒",["拉文凯斯"] = "Ov,归心",["血吼"] = "Ot,莉娅德淋",["海克泰尔"] = "Os,内个小徳;OW,熊追猫猫抓鸟;OV,Lethargy;OQ,翡翠森灵;OI,猛医",["瓦丝琪"] = "Os,亡心",["萨尔"] = "Os,杨綿綿",["亚雷戈斯"] = "Os,没袜子的多比;OT,为何如此凸出;OM,大米求组;OH,骑士小兰",["黑龙军团"] = "Os,新新丶",["迦拉克隆"] = "Os,天边丨;On,婕拉德之影;OV,Saartoria;OT,天堂丶陨落;OP,夯沓夯沓;OI,娜娜别哎呦;OG,你得支棱起来;OF,部落萌德,圆圆的团子,丨夺魄丨,淡烟疏雨",["海加尔"] = "Os,花千岁;Ob,Pitt;OZ,千秋岁",["阿扎达斯"] = "Or,大车",["达尔坎"] = "Or,神奈川",["霍格"] = "Or,光幔小蜜蜂",["战歌"] = "Or,专业卡门",["冰川之拳"] = "Oq,天执颜华",["破碎岭"] = "Oq,舆你無关;On,Turbowarrior;Ol,Moubuns;Oj,呜啦呱唧;OR,苏白;OQ,伏惟长秋;OL,雲天河,李逍遙;OI,奶爸富贵儿,魚萌萌",["大地之怒"] = "Op,村正",["拉文霍德"] = "Oo,凉风西西",["熔火之心"] = "Oo,丶小筱丶;Om,麒麟仔;OK,寒光月澜,魔礼青",["灰谷"] = "Oo,锋利的剑刃",["试炼之环"] = "On,深灬白色",["深渊之巢"] = "On,风一样的包子",["扎拉赞恩"] = "Ol,落月情;Ob,丨疯狂的插丨",["黑铁"] = "Ol,砍柴苦情花;Og,哈提是乌鸦的,乌鸦巅峰骑士,乌鸦巅峰战;Oc,尼娅海尤达嘉;Ob,璀璨星梦;OX,狐搅蛮缠;OS,灬奎托斯",["诺兹多姆"] = "Ok,嚣张威廉;Og,Geltao",["艾萨拉"] = "Oj,福利社头牌",["遗忘海岸"] = "Oj,干丶将;OO,帐贱走天涯",["法拉希姆"] = "Oj,平子;Oi,Genji",["时光之穴"] = "Oj,起点丨无畏",["伊利丹"] = "Oj,Ukulelekenny;OV,后面有尾巴",["蜘蛛王国"] = "Oi,加油尛熊熊;OF,姬丝秀忒",["希雷诺斯"] = "Oi,青森夜一;Oa,邓太阿",["凯恩血蹄"] = "Og,纯子弟",["风暴之眼"] = "Og,季师傅不粘锅;OV,娃哈哈不粘锅;OO,心无杂念",["奥蕾莉亚"] = "Of,Watering",["羽月"] = "Of,小笼包;OS,赤胆屠龙;ON,贼胖胖",["日落沼泽"] = "Of,丨大灰狼丶;Oe,情有独钟;OX,丨大猩猩丶",["火焰之树"] = "Oe,依然爱着伱",["丽丽（四川）"] = "Oe,Hunterlove;OV,Winterlove",["圣光之愿"] = "Oe,吉仔",["织亡者"] = "Oe,文森特得很",["埃霍恩"] = "Oe,笔都戳弯了",["银月"] = "Oc,一白洁一",["圣火神殿"] = "Oc,Nancy",["黄金之路"] = "Oc,烁雅",["普罗德摩"] = "Ob,心静幽蓝;OZ,栗子",["通灵学院"] = "Ob,南风北至",["达纳斯"] = "Oa,海琴烟",["安东尼达斯"] = "Oa,苍山如海",["血牙魔王"] = "OY,浅色丶幻影",["龙骨平原"] = "OY,战莽;OR,风舞夜月;OM,狂暴之力",["洛丹伦"] = "OY,Bangorg,喷水的杰尼龟;OR,苦菜菜子",["千针石林"] = "OX,传送门售票员",["踏梦者"] = "OX,Vavola",["永夜港"] = "OW,时桔丶",["甜水绿洲"] = "OV,部落龙牙;OG,雾隐妖瞳",["壁炉谷"] = "OV,可乐咖啡",["塞拉摩"] = "OV,九寶;OM,夜凉如水",["地狱之石"] = "OV,四月的谎言",["聖光之願[TW]"] = "OV,成都嬌子",["暗影议会"] = "OV,银丸,司漓漓;OE,四是四",["燃烧军团"] = "OU,巴尔",["加基森"] = "OU,土不人口牙;OS,假行僧丶;OG,亍亍,睿智的窝头",["斩魔者"] = "OU,不喝可乐",["罗曼斯"] = "OT,鸭羊王",["埃德萨拉"] = "OS,鲤伴;ON,欲望浴缸鱼,莫墨小白;OH,布拉德皮条撸,暴雨梨花",["激流堡"] = "OS,思绪的水",["阿尔萨斯"] = "OR,Britneylol;OI,胭脂;OF,曾大壮",["安加萨"] = "OR,锦丶枫",["格雷迈恩"] = "OR,托尼史大棵",["瑞文戴尔"] = "OQ,丶小仙女丶",["风暴之怒"] = "OP,西园寺丶世界",["艾露恩"] = "OP,半妖倾城",["阿拉希"] = "OO,棋盘山老司机",["巴纳扎尔"] = "ON,惊蛰",["翡翠梦境"] = "ON,愿拆曲成诗",["加兹鲁维"] = "OJ,两指逆天",["阿纳克洛斯"] = "OI,阿羡丶",["远古海滩"] = "OH,死在夢里",["加里索斯"] = "OG,蜃楼",["恶魔之翼"] = "OG,莫灬慌",["荆棘谷"] = "OG,秘幻月天",["密林游侠"] = "OG,陈孝正,那个法爷丶",["雷霆之王"] = "OG,影儿",["爱斯特纳"] = "OG,东篱",["耐奥祖"] = "OF,你看我硬不",["世界之树"] = "OF,咿呀咿呀咿",["奥尔加隆"] = "OF,哈雷丶奎因",["厄运之槌"] = "OE,多瑞米法索",["亡语者"] = "OE,Liadrin"};
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