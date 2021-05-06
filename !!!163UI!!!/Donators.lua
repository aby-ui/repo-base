local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["死亡之翼"] = "Td,离人丶泪;Tb,卩灬聖丨光;TY,阿浩丶不吃素;TV,丷惜月丷;TT,丶秋黛里;TS,别骚叽叽,愛璨璨;TR,青瓦台王主任;TP,丶木木,咕咕哒咕哒;TM,御用厨师长,橙色风暴之王;TK,囬灵气;TG,星辰溢彩,鱼人语六级;TE,平平大魔王;TD,Aviciinova;TC,拖儿;TB,夜澜冰映月;TA,枝枝,和諧啊和諧,橙紫倾言;S/,正义的狼;S6,老病友,地狱灬咆哮丨;S5,顾老师我滴神,三步一殺,養乐多;S4,萌萌的杨超越,皆空丶,大喷子丶,酒铯财气;S3,丷喵酱;S2,小白爱嘭嘭,祝雨渚;Sz,丷矢泽妮可丷,爱新觉罗睡;Sy,和光灬同尘;Sw,小老虎头子,子夜深寒;Su,清逸;St,Mingabc,神的丨洗礼,刀口滴泪如虹;Ss,丨乐逍遥丶,合金子弹头,秋黛里,秋黛里灬;Sr,基尔常;Sp,一休大宗师;Sn,热舞吧我的爱,猎户一号,迷糊睡着了,晓公子;Sl,浮想聯翩,丷小眼迷人丷,机智的灵魂兽,小板寸;Sk,天真無鞋丶,安妮菲娅,莫莫大魔王,夜雨聲煩,乄璃洛,小香奈奈,抹茶星冰乐丶,苏忘洲,暴躁小叮当;Sj,小竹熊丶,一念成法,殊茗,Bloodssoul,訡风射月,秋小枫,筱枼丶;Sh,碧咸不帅,面包先森;Sg,奈斯凸迷球;Sf,Return;Se,陈以墨;Sd,物欲;Sc,Willett;SW,小熊熊暴凶;SV,恶魔的微笑;SU,一劍丨御风雷,刘大篮子;ST,丿蛋灬蛋,Olala;SS,猫粮,你闺蜜咧;SR,林月茹丶,筱萌喵;SQ,丷怜香丷;SP,七星鎏虹",["罗曼斯"] = "Td,因为蛋疼所以;St,风吹麦浪",["冰风岗"] = "Td,天韵五五;TI,Devllmaycry;TH,我爱洗澡澡;TG,执法皇帝;S6,杭州阿六头;Sy,芝士二锅头;Sx,顶缸,丨冰冷丨;Sw,张子路;Su,超威蓝猫丶;Ss,丶须臾,夢桜;Sq,萌德来了,啊豆;So,Aming;Sn,君心似我心;Sl,卷毛;Sk,小箭魔,Xxnanqvq;Si,耶子汁;Sh,悠悠丶淺語,朝霞,黛雪丶;Se,Highmat,马宝宝丶;Sb,绯绯;SQ,弎少",["凤凰之神"] = "Td,梦霜宇,小妞向前冲;Tc,终极版本答案;Tb,艾梅特赛尔克;TY,Liangsu,冷眼是非善恶,独照峨眉峰丶;TV,丶按时吃饭;TU,兔小昕丶;TS,Romeo;TR,冰冷的寒号鸟;TQ,雪碧加枸杞;TN,黯燃蛋炒饭;TL,Robenlly,多花一百五;TK,小缇娜乀;TJ,丨跳跳虎丨;TG,我有小苹果;TE,醉灬红灬顏,灬恶魔之路灬;TD,嗨呀;TC,仁者藏青;TA,鱼晖;S/,玖月流火,散了吧打不了;S+,特蕾沙,Hikikyo;S9,尐菇孃,你家小兔兔,丶圣培露;S8,露娜乀;S6,眼科医院院长;S4,爱悠;S3,龢諧菿底,Caribbeansea,搞鸡不搞基,反抗之拳,迷人的贝塔,索西雅的圣杯,幽魂澤澤,丨归乄尘丨,Isabbella;S2,梵涌;S1,兜风嘛妹妹,烽火連三月;S0,骁丶骑;Sz,桂丶鸡六三;Sy,Youai;Sx,丨韩菱纱丨;Sv,可爱没脑呆,兽大胆;Su,小资灬大调,落眉成书丶;St,刀口滴泪如虹;Ss,春夏秋昸,蒾鍸丶餹餹;Sr,無空,伊比璐玖,重庆老山城,七月之祭;Sq,倔强嘛,花花的呗呗;So,巴豆配黄芩;Sn,李雪莲,小猪猪佩琦;Sm,嘶吟渡鸦丶,清风入酒,姨妈外漏,湖中的少女,无名之夏;Sl,绿豆布丁,战肾;Sk,啾咪丶喵团子,钱慢慢,擂神老火锅,最强大宝,欧剃大魔王;Sj,周慧敏丶;Si,Duwurogue,聪明怒角,双子丶猎爹,小柯同学,丶月轩,南栀初见丶,天空的引路人;Sh,浅晴丶,就想怼一炮,就想怼一怼,可莉辣舞,园上矛依未,丶莱蒙;Sg,地獄特工;Sf,壳壳超会玩,牛三斤;Se,髙圆圆;Sd,湘烟;Sb,矜持,灵魂兽医;Sa,墨霄丶;SW,吕桂花,我为部落狂;SV,雯雯灬;SQ,麻辣丶牛蹄筋,枕上诗书;SP,裤头里拉风,胖熊猫会武功,一抹天晴",["格瑞姆巴托"] = "Td,可乐灬乄;Tb,一云丶;TP,卡乄尔;TM,泡面麻麻吗;TJ,前夫;TG,抓住那只小射;TD,落英不殇;S+,卡密哒;S9,丶萧默默,萧墨丶印清秋,枫闲;S8,阿浩丶不吃素;S1,紫陌桑田;S0,低配维克多崔;Sz,Darktime;Sv,想要兩颗西柚,水围城;Su,一箭追魂;Ss,艾露丶菲露特,Arcanemaster;Sr,丨老杨丨;Sp,嘿鳗鱼儿;Sm,橙子转圈圈;Sl,允初丷;Sk,为所欲为小萨,西方西方北,花开花落无数,牛影风,怕孤厌闹灬燚;Si,隔壁狐狸;Sh,玛塔丶索萨;Sd,沐若飒;Sc,白银丶奥格,糖门掌门人;Sb,小恶魔丶雯,是妳转身路过;Sa,咒炎丶怨曲;SV,阿雯丶;ST,万般变幻由心;SS,熊猫咕奶奶;SR,夏晨晨",["世界之树"] = "Td,Stillalive",["贫瘠之地"] = "Tc,布利瑞斯;Tb,婲落知多少丶;TY,兽仔;TP,沧丶月,哔咔;TL,艾微;TK,且随疾风前荇;TJ,冬虫夏草灬,丨雷霆嘎巴,小开訫;TI,秋枫丨漠;TD,主力坦;TB,湖蓝色忧郁;TA,好多好多鱼,吉祥绾绾;S4,Waynext;S0,神奈川冲焰鼠;Sv,夏之忧郁,抱抱我的牛;Sn,实在太无聊了;Sm,蓝色灬经典;Sl,白发悲红颜;Sk,铁丶山,二狗子好水,盒饭会变身,盒饭加个蛋,川贝灬枇杷膏;Si,魔姬魅姬,东風破,猫叔不高兴;Sa,丶润物细无声;SW,明月别枝;SR,丶丿残影",["白银之手"] = "Tc,有德必尸,砸瓦鲁多;Tb,蛋壳总是脆,缺德萌咕;Ta,为妳念咒;TZ,安牧茜;TY,丷菲咪丝丷;TV,我手最红的;TS,果冻熊丷,檀夕;TR,米哈伊洛夫娜,丶老男人,丶佬男人;TQ,名艾;TO,苍山一眸;TN,欢喜丨;TM,坠星落月;TK,赶路的小蜗牛;TJ,痒丨;TI,晓開心,蜀山弟子;TH,始潮涅扎哈,旺仔妞妞奶,丷請勿投餵丷;TG,血灵搓火刨冰,生汆丸子汤;TF,丨戦聖;TE,是胖胖呀;TC,萌王哈迪司;TA,帝皮埃斯,露露大宝贝丶;S9,阿橘丶,阿拉狐阿克巴;S7,鸟倦飞而知还,蘸血的黄瓜,北郡骑士团长;S6,暗影牧尸;S5,萌大力九兵卫;S4,白糖乂玛奇朵;S0,血灵晓月,逍遥如意,大猪宝宝;Sz,扔到天空的砖;Sy,萧峰;Sw,骑士团子;Su,漪萝君,小月半丁,撅腚,怒风宁;St,怒风乄之魂;Ss,萌的丫皮,如笙;Sp,Sancarlos;So,氤氲圣言,蓝浅黛浓,咪咪眼刑天;Sn,只想看风景呀;Sm,Connaissance,夜惜白;Sl,阿米达居,鸦榆,凤羽箭影,Julygrace,飞跃小水坑;Sk,邪道丸,来日不相见,三生缘起,太懒德丶语疯,魔力丶宝贝,Lietenantcat,鸾鳳和鳴,奥兰納的拥抱,瀦児飛飛丶,円城咲耶,肖恩王,萝莉恐,马大骚;Sj,弦雨,恰饭了没,爱买不买提;Si,黎明黑暗使者,格雷迈狼,宁丶風,绿油油的飞飞,丶无情哈拉少,思遠;Sh,月怒语风,卝断水流卝,碧野仙踪,天边的小白鹤,雷强,漓焰莱薇,杺火;Se,优雅的脏鬼,卡丝莲娜;Sd,王宇光的爷爷,大风儿;Sc,我想看风景呀,乌瑟尔宁;Sb,路上有我;Sa,纯爱戰神,卑微小火法;SR,绯红的樱桃梗;SQ,暗夜星之矢,逆臣贼子;SP,宁風,漫行猫,牧过不留人",["凯恩血蹄"] = "Tc,闪伯利恒之星",["罗宁"] = "Tc,夏多雷希尔兔,佰寶;TP,爱德华大主教;S+,挽手欧巴;S3,塔拉夏尔;S2,蛋花米酒;S0,瓜皮提督,慕湮云;Sx,丨冰冷丨;Sw,你这个吃货,两只小鬼;Sv,啊呜丶汪;Su,蒂花,心欲静止;Sr,陸老师丶,剑雪封喉;Sn,星宿;Sl,月之光芒;Sk,臻果酱,Asia;Sj,术姑娘;Si,瓜皮皮,多了个利,偷零食的喵,把你送回太空;Sh,Magicskyfire,三泽大地;Sg,大典太光世;Sf,艾尔娜星光;Se,一百喝可乐;SW,国服第一骚法;SU,遗忘泪滴,Panacea;SS,开打;SR,Buzzkill;SQ,狂毛,佩罗罗奇诺丶",["瓦里安"] = "Tc,陈年老号",["迅捷微风"] = "Tc,扶桑啊大红花;TR,Laqia;S4,回春堂的朱二;St,丶婲爺,秒伤不过万;Sk,被遗忘的大叔;Sj,霍乱爱情,瞧瞧德行;Si,猫猫皮;Se,零度射击;Sa,啊阿啊阿,啊阿啊啊",["银松森林"] = "Tc,樱桃;S+,Chauvinistor;Sk,穷兵灬黩武;Se,巨肉夹馍",["朵丹尼尔"] = "Tc,Miuinitio",["海克泰尔"] = "Tb,叮噹咕嚕;S6,Drg;Sr,北海怪兽;Sl,神棍牛;Sk,Balder,Tfboynorth,裹屍布;Sj,叄脚型;SV,桔子味丶馒头;SU,罐罐",["迦拉克隆"] = "Tb,希望的灯火;TW,丝丝有点甜;TP,悠樂翩跹;TF,月光鎭魂曲;TB,北曦;S8,风吹過的夏天;So,卡莉达丶邪月;Sl,我超勇的丶,吾妖王,非法盗猎者;Sk,汹汹小德;Sj,信了邪;Sg,齐佩甲;Se,天真丶珈百璃;SS,Ayasy",["末日行者"] = "Tb,野蛮丨大疯子;TI,法律无法阻止;Sr,天下山河海,祈夏;Sk,六院长,吉姆院长萨玛,朕要夯昊,湖南小超人;Si,乐桃桃;Sf,千俞;Se,麦小乐丶;SS,彼岸行僧;SQ,牛油果夹馍",["无尽之海"] = "Ta,罒壹罒;TW,我叫大炮丶;TV,狗子哥丶;TS,提线木偶,小脸儿肤白;TG,Abbby;TC,电竞奥拉夫;S5,哥丶;S4,麦穗儿;S0,今日說法;Sy,菜菜;Su,果儿和刺儿;Sr,李小琴;Sp,戰闘;Sn,夏至风吹旦旦;Sm,笑談人泩;Sl,希米露丶;Sk,今晚不能熬夜,马哥啊,我不是挨木涕,来都来咯,花梨影木,熟睡的土拨鼠,渐空,Tzjjzt;Sj,铜镜映无邪;Sh,Spyair,非灬全职先生,野兽不再凶猛;Sf,丶小草莓;Sd,七月琴风丶;Sb,漫步游走;SW,莫甘那,颜凉;SS,风北离",["白骨荒野"] = "Ta,羽月希丶,幻之地狱",["克尔苏加德"] = "TZ,清妤,八度余温;TR,Zorro;S0,舔狼;Sn,伊斯塔战灵丶;Sl,玛格汉的秋天,倏忽;Sk,小狗宝,丨剑来丨,美年达丶;Sh,秦叔宝;Sf,把你肚皮打穿",["血色十字军"] = "TZ,不信鬼神;TV,奔波儿霸丨;TP,欧皇小倪华;TI,铁马妖孽;TH,糖水菠萝;S/,兔二丶,迷人丶大反派;S8,死亡符文丶;S4,瑾宁;S3,至高岭话事咕;S2,无心骑士;Sx,黑暗圣堂丶;Sv,翘思慕远人;Su,殺手的尊严;St,Valaraukar,Avengers;Sp,纯阳;So,Dianaspence;Sm,混乱之魂,Miraclé,急性发钱寒;Sl,折纸咕角,奉天承運,Samuraiheart,院长大人丶;Sk,愿得一人心,七秒钟记忆,回復術士,海鲜可爱多,海鲜大杂烩;Sj,超级咔咔罗特;Sh,绘玩;Sg,怂怂的小呆呆;Sf,快乐的大脚,最爱吃橙子;Sc,凤梨蓝莓;SV,一直很任性,骑猪追火箭丶;ST,疫病之吻;SQ,Desitiny;SP,尘曦光枫",["诺森德"] = "TY,萌货汪星人;S1,哈卡莱饮血者,提醒我补智力;Si,神的姐夫",["阿古斯"] = "TY,影双;S3,丨摩羯丨;S1,Theskydh,天情丶;Sw,三刀丨刘索隆;Su,不带狗的劣人;Sk,乱刃斩;Si,不説;Sd,汉堡王;SW,余生丫丫",["永恒之井"] = "TY,冷眼是非善恶;TD,圣光灬舞动,愛我久久;S8,雪舞芳菲;St,雪饮狂刀;Sk,宇智波丶大星;SU,一页书;SS,若如雲心",["斩魔者"] = "TY,血河;S4,薇薇安丶",["蜘蛛王国"] = "TY,重口小萝莉;Sm,Leopp;Sl,进击的沙曼;Sk,亡者降临;Sc,Ckcraft",["主宰之剑"] = "TY,Saalasa;TV,无情的打桩机,灭团之源;TU,暗影小小哥;TQ,雅儿背德;TP,翊丨翧;TN,半夜砸玻璃;TB,低吟浅语;S+,雲雾;S3,慕兮;Sz,风月不沾她衣;Sw,煋汉灿烂;Sq,谦豫,Aalizzwell;Sp,德财兼貝;So,无归无往;Sm,小蛇儿,麒麟之火;Sl,噢嚯,Gexiuzi,依瑟思;Sk,彪猎,圣光大礼炮,杏花儿,梦里春秋度;Sj,健康太平街;Si,多了个利;Sh,余地;Sf,初八丶,黛尓萌德;Se,执卿,丶光之子丶;Sd,翎丨翊;SV,芙列雅,大狗熊;SU,掌中萌虎丷;SS,游来游去的猫;SR,懿橙;SQ,集火那个戰士;SP,貝优妮塔",["影之哀伤"] = "TY,闻西丶;TV,云染染丶,云轻轻丶,云朵朵丶;TU,小希瓜;TT,卡塔库栗丶;TR,谢慕云;TK,Forya,Yeats;TI,阿菲哥;TE,拽拽;TB,楚二郎;S/,仅等于狼;S6,我胖我灵活呀;S5,简胖胖;S2,坚定信念,Caesura;S0,简尐胖;Sz,㐅琉璃;Sw,虎视眈眈;Sr,Skriniar;Sl,麻酱丶,酸菜咕;Sk,Zxouly,北欧冻冻,君莫丶笑,晚安卡特琳娜,咕咕有德;Sj,竖锯,菊之哀傷,列奥德锣,木业白牙;Si,冻结灬寂寞,Sinanju,流浪的红舞鞋,四神海鲜包;Sh,心有小术灬,黑暗教長;Se,简小胖,丶没肉没输出;Sa,水土木月;SW,愤怒的子弹;SV,阿奶的激活;SU,哀伤之烬;ST,不会起門吖,振翅引发海啸;SQ,陈哈尔滨啤酒",["安苏"] = "TY,阿寶酱;TW,天火燎赑毛丶;TU,大师级假死;TN,噢利給;TL,吐洱淇冰淇淋;TK,交响,抗压的人;TI,提拉米苏可颂,豪无敌;TB,长庚丶;S/,美滴狠;S9,璀璨星空丿贝,聆听雨声丿伤;Sz,鱼大鲸;Sv,天空斩空天;Ss,早坂银时;Sr,扇子的夏天;Sq,长安夜未央,温笑的阳光;Sm,我想吃酱大骨;Sk,意气风发,砂糖蜜橘,曼達洛人;Si,西西里多,往昔红颜;Sd,研究本质;Sc,丨干饭王丨;SS,脆脆鲨威化;SP,福星凸肥圆",["国王之谷"] = "TW,灬路易基;TK,醉闹;TJ,江隂馒頭;TI,宝可梦大师丶;S+,粉色跳楼少女;S9,晨曦灬梵琳;S7,玄翁;S2,二了吧唧茶;Sw,酸到变形,闪灵镇魂曲;Su,云彩依旧;St,Smileddevil;Ss,終極閃光丶;So,稤人;Sl,黑芝麻胖店长;Sk,柒月拾柒,刘不亏,浪漫氵紫罗兰,赫潘丝;Sj,丶碎碎冰丶,玻璃囚牢;Sh,做入留一线;Sd,小毛贼丁丁;SS,军痞壮熊;SR,慕思蛋糕",["萨尔"] = "TW,大佬黑丶;Si,橘里大魔王;Sa,達芙妮",["伊森利恩"] = "TW,世界第一等;TS,熊喵大人丶;TR,古尔灬彦祖,輘亂;TD,我想看风景呀;S+,卡拉几胖;S9,丷鲨鱼辣椒丶;S8,板甲依然在;S7,Smexxin;S6,仟瑟瑟;S5,欧洲;S4,我只想看风景呀;S3,罒壹罒;S2,導演;S1,阿什肯迪;Sy,深街酒贵,塔蓝吉公主,黑手黨教父丶;Sw,逍遥二哈;Ss,动物森友;Sp,丨深夜去打猎;So,星月猫;Sn,化风而去;Sm,背上小书包,一泽大魔王;Sl,Steelstorm,喵了个咪呦,暴走的骚肉肉,术然,王彧;Sk,注册电疗师,空之白练,戰丶狂,Assasination;Si,细雨丶丶,不要辣子,流枔丶,就是修不热;Sg,我找人打你;Se,叶河图;SQ,灬雷鸣",["符文图腾"] = "TW,给你一瓶可乐",["迪瑟洛克"] = "TV,恶魔小贩",["阿拉希"] = "TV,基莫笑",["影牙要塞"] = "TU,亚尔夫海姆",["埃德萨拉"] = "TU,那夜灬;TS,大筱婕;TK,那夜的人;TF,夜那丶;TB,夜那;TA,那夜乄;S1,夏幕之心;Sy,狂热的阿昆达,Exiia;Sv,月夜凌風;Sq,流星蝴蝶剑,霜天雪地,做人间怪物;So,药水大师;Sm,林涔;Sl,丶抽真空,钢铁部落;Sk,布拉歌,娇花碎钞击;Sj,节奏大师啊翔,不丶舒服;Sd,桃溪春野;SV,Occoc",["达尔坎"] = "TU,短圆吞噬魔;St,滚筒洗衣机",["熊猫酒仙"] = "TU,啪啪想不出来;TQ,云尽月冥;TP,音於洁弦;TN,音於詰弦;TD,棉丶花丶糖;S/,喏咓;S+,路野;S2,Frostfire;Sx,银发小表妹;Sw,阿鸡咪德;Sv,徐二娃,孤獨伴酒,雄壮商队雷龙;Su,心儿堵;Sq,非洲某酋长;Sp,Planys;So,Po;Sm,娜奥米丶月箭;Sl,Dearzed;Sk,纸婚,芝麻儿;Sj,瑞翔;Sh,巴德纳尔,素年祭语,骑个龙多强;Se,Kobbe;Sb,再看把你喝掉,饿了吗;SR,糍饭团子,谨言;SQ,追光语者,墨一火,远去的风景;SP,肥仔风暴烈酒",["燃烧平原"] = "TT,和尚爱飘柔;Si,紗迦",["桑德兰"] = "TS,打劫;Sn,拂曉神剑,送葬;Sk,毛蛋蛋球;SR,巭熊熊",["布兰卡德"] = "TS,风暴降世者,米歇尔哪吒;TO,清风慕白;TD,随性随心;TB,澳洲野玫瑰丶,洛洛神丶;S3,锐萌萌丶;Sz,皆川尤菜;Ss,秋業,椰树椰汁,大椅人;Sp,死傲娇;Sn,大漠飘雪;Sm,Cci;Sl,元素周期律;Sk,看看人家,部落潴,联盟狗,法力灵动,现身说法,猫咕彡色,阿鲁卡多,木旁木旁;Sj,锈蚀的盾牌,子夜灬;Si,Nohkyuo,念无丶;Sh,烟雨难逃;Sf,真影至闇;Sd,山豆玩魔獸",["风暴峭壁"] = "TS,圣夜祈;Sp,蓝莲花",["巨龙之吼"] = "TS,王牌劣人;Sn,缘分已定吗;SQ,锝彩",["暗影之月"] = "TS,浪子三回头;Sp,小蹦豆;Sn,筱哉子儿;Sf,行成于思",["巫妖之王"] = "TS,踏雪吉安那;Sn,油腻的师姐",["回音山"] = "TR,瞎蹦卡拉卡;TP,枫叶骑;TN,让箭飞会儿;Sv,小清影;Ss,一天一次;Sq,长寿不喝水;So,在下赵曰天丶;Sj,笛子魔童;Sh,魁雯,星夜乄小狗,真劍胜负;SW,Zzhh;SU,性格变态丶",["奥尔加隆"] = "TQ,观察者;TM,北白丶;Ss,裤裤狄奥里多;SW,叶之轩",["艾露恩"] = "TQ,看我打不打你;Sj,不续前缘;ST,李风",["暗影议会"] = "TQ,丨盼盼丨;Si,双色猫瞳",["伊利丹"] = "TQ,丶凯恩血蹄;TE,赞达拉之耀;Sy,胧灬月;Sr,你瞅我嘎哈;Sk,Agony",["霜之哀伤"] = "TP,开门一次伍毛;TL,工匠猎手;TK,林中霜骑;TJ,看看好不好玩;S9,星黛鹿;S5,武汉彭于晏丶;S4,水墨;Sp,Nagisalight;Sm,鹰眼霍克艾;Sk,夜羽丶残殇;Sj,清音圣咏;Si,阳光咕咕,流氓与萧邦;Sh,空山月明;Sc,奶油饼干魔王",["红龙军团"] = "TP,清少纳言;TF,Oblivious",["冰霜之刃"] = "TP,耳尖尖变猫趴;Sq,鬽灵;Sk,Mepoe;Si,小油菜花;Sh,太平公主;ST,暗夜丶绮玉",["熔火之心"] = "TO,Ryoho;Sq,Nicemaker;Sk,小石哈;Si,海豹要晒惹",["洛丹伦"] = "TO,三岁就很帅;So,小番茄洋柿子;Sl,别今朝;Sk,呼呼喝喝,丅病毒;Si,红烧蹄子",["祈福"] = "TO,银海",["梅尔加尼"] = "TN,灵鬼儿;Si,正新鸡排",["勇士岛"] = "TN,一梦魇一;TG,神箭丘比特",["黑暗虚空"] = "TN,武汉热干面;Sh,夜雨醉星辰丶",["麦迪文"] = "TN,沉默的独;Sb,小尼豆",["鬼雾峰"] = "TM,滇池水葫芦,夕夏残阳落幕;TE,又西给丶;Sh,Playerberilo;SS,格洛古",["杜隆坦"] = "TM,开灯妹妹;SW,暗香倾城",["破碎岭"] = "TM,指尖暗影;S/,由丶夜;S8,中箭的膝盖;Sn,我爱扬扬一号;Sl,光与影之战;Se,烧刀子",["金色平原"] = "TL,冷月离静;TG,山中兰叶径,沙场秋点兵;S0,修伊;Sz,晚安曲;Sp,萨提;Sl,冽风;Sh,秋的迷藏;Sf,最爱牛仔哥;Sa,埃尔南多;SU,古达老师;ST,残忍的软泥兔;SP,俗了清风",["火焰之树"] = "TL,落幕煙花,落幕煙火;SW,格子的夏天;SV,魔兽胃必治",["布莱恩"] = "TL,霹雳喵",["燃烧之刃"] = "TL,Autum;TG,你说不可能;S6,我踩故我在;S5,秋风听雨;S4,冬青,静待流年;S2,丶影流之主丶;S1,锦瑟華年;S0,狂暴哥;Sx,无声的雨夜;Sv,茗之守护;Su,天小瑞;Sq,相声演员琪琪;Sm,烈焰馒头,苍蓝星丶;Sl,Pdminister,饼干酥酥丶;Sk,喝茶,狐小纤,慕无名,圣疗,半只兎子,笑容渐渐缺德,我看看就好,枭徳丶;Sj,乄落墨丶;Si,紫氣丨東來,冲阵,呆萝卜毛毛,圣光术是什么;Sh,守序善良,黑暗咒师;Se,一枝婲丶,一个小徳;Sc,林依依,Tlk;SV,臻蓝,梦中恶魔;SU,深林见鹿;ST,Kpistols;SS,梓喵酱;SR,爆炸的宝宝坚;SP,白雲苍狗丶,將灬進酒",["斯坦索姆"] = "TK,好潮嘅捞咾",["黑铁"] = "TK,Lovelydruid;Sw,圣光即是正义;Su,鲁东东回来了,裕华;Sr,哥特式华尔滋;Si,时代变了,丶浊酒恋红尘,呜哇丶呜哇;Sh,鸽后",["雷斧堡垒"] = "TJ,山竹炖荔枝;TF,伊丽和莎白,仙灬道;Si,北海无冰",["瓦丝琪"] = "TJ,丨暖丨",["死亡熔炉"] = "TJ,土豆糖",["霜狼"] = "TI,食人不吐皮;Sr,冰障",["雷克萨"] = "TH,我就叫德",["巴纳扎尔"] = "TH,忆萨;S/,白露",["达基萨斯"] = "TG,蒸汽蛋蛋",["火喉"] = "TG,Patrickstar",["神圣之歌"] = "TF,嘿丶蛮;Sl,神惃,盐蝙蝠,疾风点破",["伊兰尼库斯"] = "TF,乔雯影刃",["遗忘海岸"] = "TF,Fubai;S3,泽渡真琴;S0,我叫过子洁;Sv,超哥;Su,沅芷澧兰;Sp,乔治巴顿;Sm,美狂乱;Sl,格兰蒂娅,简约风格;Sh,欧品",["奥妮克希亚"] = "TE,甘甘",["晴日峰（江苏）"] = "TD,影蚀;TA,骚丶兜兜;Si,红莲华;Sh,伊吹小风",["伊瑟拉"] = "TD,修女芙莉德;S3,小玖玖;Sc,桃玑",["龙骨平原"] = "TC,馄饨;Sx,番茄小饼干;Sa,绝对双刃",["战歌"] = "TA,地板好凉;Sn,里维阿克曼;Sd,胖子丶骑士",["试炼之环"] = "TA,我叫刘大能;Sx,派大星丷;Sv,天堂超市;Sn,南风丷知我意;Sk,别歧视我很丑;Si,南风知我意丷;SV,南风知我意丶",["克洛玛古斯"] = "S8,吥离灬;Sp,牧牧;Se,真的汉子",["黑龙军团"] = "S8,小心眼子",["外域"] = "S8,火山里数数;Sk,枪兵滚毒暴",["苏塔恩"] = "S7,释迦摩尼;Sl,白小九,圣光锤锤酱",["刺骨利刃"] = "S7,小沐沐",["月光林地"] = "S6,煉獄梦儿;S4,豆丁甜甜;Sk,扎尔杜姆",["艾维娜"] = "S5,伊豆豆;Sj,燃烬之尘;Sb,幸运女神合体",["诺莫瑞根"] = "S5,十二楼五城;Si,Everyoung",["天空之墙"] = "S5,马冬梅丶丶;Sk,影丶夙尘,蒂亚丽丝",["狂热之刃"] = "S5,每天都;S4,彼岸雪;Sv,圣光大帝;Sn,随风而誓;Sj,燃烧殆尽",["阿尔萨斯"] = "S5,心跳;Sl,克克的小甜心",["奥特兰克"] = "S4,愤怒的爷们;Sz,疍疍的痛;SR,Possession",["夏维安"] = "S4,练灬傻喵;Su,斗萝;Sj,孤心冷雨",["血羽"] = "S3,丨慕灬寒丨",["守护之剑"] = "S3,一丶寸灰;Sh,熊贰佰",["哈卡"] = "S3,右手的情诗",["加基森"] = "S3,御凌风;Si,咕咕吃火锅,布道师",["加尔"] = "S3,七舅姥姥灬,朵儿灬,大年初一,萨拉灬橡心",["伊萨里奥斯"] = "S1,淘气的小妖",["提尔之手"] = "S0,冰煌雪舞;Sh,Fornaini",["卡扎克"] = "S0,丶大衛",["血环"] = "Sz,天神下凡丶",["拉格纳罗斯"] = "Sy,酱爆牛筋拌饭;Sf,你们缺不缺德",["丽丽（四川）"] = "Sy,末与卿闻;Sk,牛春花;SS,比特币升值器;SQ,铁甲小宝丶;SP,打不过就虚弱",["提瑞斯法"] = "Sy,誤落凡塵;Sh,布洛克斯",["血吼"] = "Sy,今夕是何年;Sh,绚烂殺戮",["寒冰皇冠"] = "Sy,快给我来个橙;Sm,空白的夜;Sj,风中的彼此",["格雷迈恩"] = "Sx,吉恩;Sr,乾坤一掷;Sn,哈雷大叔",["山丘之王"] = "Sv,旖乄旎",["闪电之刃"] = "Sv,Truthseeker;Sk,工藤龙一",["蓝龙军团"] = "Sv,小狗快跑;SP,贝贝泰迪",["暴风祭坛"] = "Sv,王思聪",["火羽山"] = "Sv,露草;Sk,啵灬妞",["索拉丁"] = "Sv,御坂美琴;Sk,楚天歌",["黑手军团"] = "Su,梦醒时见妳丶;Sp,牛奶秋刀鱼",["烈焰荆棘"] = "St,古彦祖",["恶魔之魂"] = "Ss,淋江仙;Sk,心情看天气;Sd,盐酸哌替啶",["伊莫塔尔"] = "Ss,拙拳笨腿;Sk,剑锋天下",["森金"] = "Ss,贾斯帕爱吃鱼",["玛维·影歌"] = "Sr,武松他大哥",["月神殿"] = "Sq,真相是假",["羽月"] = "Sp,鬼灵若雪",["埃克索图斯"] = "Sn,烈风",["索瑞森"] = "Sn,小柯同学;Sk,拉文霍德,名侦探岳岳;SR,丶绫波丽",["风行者"] = "Sn,艾小米",["壁炉谷"] = "Sn,德德大天才;Sk,库茉,正山小种",["洛肯"] = "Sn,馒头小兄弟;Sl,点不着的回忆",["甜水绿洲"] = "Sn,Dizhu;Sk,基地高射炮",["黑锋哨站"] = "Sm,米办法",["范达尔鹿盔"] = "Sm,Xusihai",["诺兹多姆"] = "Sm,牛麻子;Sk,梦中的狸猫,路人灬乙;Sh,点小妹吃嘎嘎;SP,带朱狂粉四号",["玛洛加尔"] = "Sm,佐仓绫音丶",["阿拉索"] = "Sm,凤舞青竹",["丹莫德"] = "Sl,天竺兰影",["雏龙之翼"] = "Sl,右手很温暖",["鲜血熔炉"] = "Sl,夜昊",["红云台地"] = "Sl,丝黛林苟萨;Sk,橘子皮皮虾",["幽暗沼泽"] = "Sl,知北游灬柠真;Sk,制裁",["麦姆"] = "Sl,萧萧下士",["希尔瓦娜斯"] = "Sl,东篱丶;Sg,夜隱月羙",["奥达曼"] = "Sk,时无瑕",["摩摩尔"] = "Sk,甜甜的楠楠酱",["安其拉"] = "Sk,昕昕",["拉文霍德"] = "Sk,暖风",["奥杜尔"] = "Sk,幸福的棉被",["塞拉摩"] = "Sk,美萝莉郭德纲;Si,芳心纵火贼",["玛里苟斯"] = "Sk,筋肉小奶咕",["梦境之树"] = "Sk,续杯咖啡",["燃烧军团"] = "Sk,卡扎库斯,菠萝菠罗",["风暴之鳞"] = "Sk,舞王吃太少",["玛法里奥"] = "Sk,提里奥丶丁弗",["万色星辰"] = "Sk,危险流浪者;Sj,Zoc",["生态船"] = "Sk,炎雪千寻",["翡翠梦境"] = "Sk,靓泽",["奥拉基尔"] = "Sk,女子女古女良",["黄金之路"] = "Sj,Alvitr;Sh,爱恨情仇",["地狱之石"] = "Sj,落雪飘凌;Si,卤蛋超人",["风暴之眼"] = "Sj,风影白眼",["黑翼之巢"] = "Sj,笑傲江湖",["萨菲隆"] = "Sj,木夏树",["达纳斯"] = "Si,佟丽娅",["艾欧娜尔"] = "Si,阿巴瑟",["普瑞斯托"] = "Si,月影云际",["基尔罗格"] = "Si,深藏身与名",["卡德加"] = "Si,再见灬苏菲丝;Se,草莓卓玛",["银月"] = "Sh,胖之煞",["亚雷戈斯"] = "Sh,大水牛猎;ST,摩挲影魅",["艾萨拉"] = "Sh,猫车,花天月地",["加里索斯"] = "Sh,杏加橙加蜜桃",["军团要塞"] = "Sf,提里奥佛丁",["哈兰"] = "Sc,沫沫智",["奥斯里安"] = "Sc,和谐当道",["利刃之拳"] = "Sa,灬绿豆灬;ST,特战队长",["玛瑟里顿"] = "SU,風之天際",["烈焰峰"] = "SS,Artemin",["暗影迷宫"] = "SS,百年好合",["古尔丹"] = "SR,典狱长",["阿纳克洛斯"] = "SQ,雷霆之怒風",["太阳之井"] = "SQ,圣屠",["戈提克"] = "SP,毛泡泡",["泰兰德"] = "SP,来二两"};
local lastDonators = "咕咕哒咕哒-死亡之翼,悠樂翩跹-迦拉克隆,卡乄尔-格瑞姆巴托,爱德华大主教-罗宁,翊丨翧-主宰之剑,丶木木-死亡之翼,耳尖尖变猫趴-冰霜之刃,哔咔-贫瘠之地,枫叶骑-回音山,沧丶月-贫瘠之地,清少纳言-红龙军团,开门一次伍毛-霜之哀伤,欧皇小倪华-血色十字军,音於洁弦-熊猫酒仙,雅儿背德-主宰之剑,丶凯恩血蹄-伊利丹,名艾-白银之手,丨盼盼丨-暗影议会,云尽月冥-熊猫酒仙,看我打不打你-艾露恩,观察者-奥尔加隆,雪碧加枸杞-凤凰之神,冰冷的寒号鸟-凤凰之神,輘亂-伊森利恩,Laqia-迅捷微风,瞎蹦卡拉卡-回音山,古尔灬彦祖-伊森利恩,丶佬男人-白银之手,丶老男人-白银之手,谢慕云-影之哀伤,Zorro-克尔苏加德,青瓦台王主任-死亡之翼,米哈伊洛夫娜-白银之手,大筱婕-埃德萨拉,米歇尔哪吒-布兰卡德,小脸儿肤白-无尽之海,Romeo-凤凰之神,愛璨璨-死亡之翼,踏雪吉安那-巫妖之王,檀夕-白银之手,果冻熊丷-白银之手,浪子三回头-暗影之月,王牌劣人-巨龙之吼,熊喵大人丶-伊森利恩,圣夜祈-风暴峭壁,别骚叽叽-死亡之翼,提线木偶-无尽之海,风暴降世者-布兰卡德,打劫-桑德兰,丶秋黛里-死亡之翼,和尚爱飘柔-燃烧平原,卡塔库栗丶-影之哀伤,小希瓜-影之哀伤,啪啪想不出来-熊猫酒仙,短圆吞噬魔-达尔坎,那夜灬-埃德萨拉,暗影小小哥-主宰之剑,大师级假死-安苏,兔小昕丶-凤凰之神,亚尔夫海姆-影牙要塞,丷惜月丷-死亡之翼,云朵朵丶-影之哀伤,云轻轻丶-影之哀伤,云染染丶-影之哀伤,我手最红的-白银之手,狗子哥丶-无尽之海,灭团之源-主宰之剑,基莫笑-阿拉希,恶魔小贩-迪瑟洛克,无情的打桩机-主宰之剑,丶按时吃饭-凤凰之神,奔波儿霸丨-血色十字军,给你一瓶可乐-符文图腾,世界第一等-伊森利恩,我叫大炮丶-无尽之海,大佬黑丶-萨尔,灬路易基-国王之谷,天火燎赑毛丶-安苏,丝丝有点甜-迦拉克隆,阿寶酱-安苏,闻西丶-影之哀伤,独照峨眉峰丶-凤凰之神,丷菲咪丝丷-白银之手,Saalasa-主宰之剑,重口小萝莉-蜘蛛王国,冷眼是非善恶-凤凰之神,血河-斩魔者,冷眼是非善恶-永恒之井,影双-阿古斯,萌货汪星人-诺森德,Liangsu-凤凰之神,兽仔-贫瘠之地,阿浩丶不吃素-死亡之翼,安牧茜-白银之手,不信鬼神-血色十字军,八度余温-克尔苏加德,清妤-克尔苏加德,为妳念咒-白银之手,幻之地狱-白骨荒野,羽月希丶-白骨荒野,罒壹罒-无尽之海,一云丶-格瑞姆巴托,艾梅特赛尔克-凤凰之神,缺德萌咕-白银之手,野蛮丨大疯子-末日行者,蛋壳总是脆-白银之手,希望的灯火-迦拉克隆,婲落知多少丶-贫瘠之地,卩灬聖丨光-死亡之翼,叮噹咕嚕-海克泰尔,Miuinitio-朵丹尼尔,樱桃-银松森林,砸瓦鲁多-白银之手,佰寶-罗宁,扶桑啊大红花-迅捷微风,陈年老号-瓦里安,夏多雷希尔兔-罗宁,闪伯利恒之星-凯恩血蹄,有德必尸-白银之手,布利瑞斯-贫瘠之地,终极版本答案-凤凰之神,Stillalive-世界之树,可乐灬乄-格瑞姆巴托,小妞向前冲-凤凰之神,梦霜宇-凤凰之神,天韵五五-冰风岗,因为蛋疼所以-罗曼斯,离人丶泪-死亡之翼";
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