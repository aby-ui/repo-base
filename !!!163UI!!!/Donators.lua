local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["燃烧之刃"] = "WZ,雯宝宝;WY,司空摘星;WW,灬一生所爱灬;WV,絶版霸道,Deathros;WR,卿爅,花丨语;WP,别被逮住;WH,学不会开锁;WD,丷佐漫丷;WA,Holybeast;V8,丶满老师;V2,天蜀黍,徐愿;Vx,寒灬欲;Vv,脚毛随风飘丶,射天狼西北望;Vq,Miyadad;Vp,锋飘舞,超级攻强卷轴;Vo,如果我有轻功;Vn,毛德,静香海王;Vm,香犇犇,冰淇淋牛排;Vf,始终怀念;Ve,议事厅哭强战,黄黄皇帝;Vd,尛噩夢,大奶猴也算猴;Vc,辛多雷强哥,霜火挽歌丶;VV,闪开我要装逼",["白银之手"] = "WY,越過山丘;WX,醉卧听禅,卡哇伊希月,星辰碎裂;WV,镰翼,嫁祸诀窍丶;WT,天道紫霄神雷,三十岁小老头;WQ,芸柚;WP,楓叶丶;WO,丶莫忘青葵;WK,天魁星;WC,天地飞舞;WB,立冬夏至;V8,阿狸爱吃肉;V6,昆得莱耀西;V5,萌葱双马尾,青丝任風绾;V3,蓝迦;Vv,麦卡伦的春天;Vr,百香果冰沙,多多队长;Vq,艾星恶势力丶;Vo,Sniperkennys,圣洁重生,契约飞飞,死神小小妹;Vl,Ninesixmage,我要自然醒,丨浣熊丨;Vk,您说的对;Vj,丷不二丷;Vg,畚瓟旳蝸犇,奥蕾莉亚公爵;Vf,血腥战歌,云中寄雨;Ve,彼麦凯蒂丶,Shanbaby,冰冰水冰;Vd,小小心脏,Ntmdjjww,壹贱定天下;Vc,封尘絕念斬;VY,小喵弯月;VV,老板来碗凉面,叶奈法的玩具",["死亡之翼"] = "WY,拿长柄扔炸弾;WX,法嘟嘟;WW,一冲锋就躺丶,中华德,如果丶云知道,肉喵;WU,张祎童大帅比;WT,拉拉环;WQ,大角雄鹿;WP,麦兜麦兜麦兜;WO,牛少丶;WM,玩偶永远滴神;WK,怎么转啊,就咬你屁屁;WJ,终点传送站,猎丶皇;WI,黑丝大长腿,疯踏;WH,大碗卤煮;WE,魇之煞;WD,Mwqx;WB,蝎子來來;V/,古勒塔丶雷索;V5,葱葱橘猫,天然呆小柠檬,小五同学;V3,就喜欢玩偶姐;V1,欧小熙,陆眼,哎呀被发现了;V0,脆脆鲨好吃;Vx,悦曦;Vt,仲夏夜之禁;Vr,安妮可姬;Vq,就喜欢瞎李姐,高先生丶;Vm,野猪大王;Vl,清水泓清,天天喝枸杞;Vj,Berryzl;Vh,谢幕挽歌,昱焱小红手,嘻嘻西茶;Vg,仲夏夜之术,残魂断枫桥,六十八;Vf,拒绝我都被绿,Jeromecc;Vd,杨扬采,仙晨之灵,Lixm;Vc,醉后,老淦部,梦幻彤凡;Vb,发飙的天牛;Va,夜阑听雨丶;VZ,刃命,没教养的瘤;VW,莽斧,南宫仆射灬,梦醒九分丶,油油的小绿皮",["利刃之拳"] = "WY,煙雨丶小爱;Vp,非常爷们;Ve,透明凝清",["亚雷戈斯"] = "WY,枯燥",["塞纳留斯"] = "WY,Whaler;WX,川琦来梦;WV,星球陨落",["金色平原"] = "WY,Trummer;WW,勋爵;WS,诺顿;WO,阳电子炮;WH,卡妙;Vg,泥头车撞太郎;Vc,遇见北极星",["罗宁"] = "WY,亚历山歪罗斯;WV,猫耳朵女郎,碧空之怒,小通;WU,沾繁霜至曙;WJ,Ansh;WH,梦不到的她,宋裤;WE,阿滴;V9,快救救胡桃;Vw,灬無名灬;Vv,滚刀肉球;Vq,蹿吧兔孙,崎涟出云;Vp,小小的小浣熊;Vl,黄油蟹蟹,魔龙,海叶灬;Vg,青夏瑶,暗殺星乄;Vf,墨华,盞茶作酒;Vd,伊利瑟维斯;VZ,川西北大拿;VV,雅詩",["血色十字军"] = "WY,Vcirmson;WX,贰西莫夫,米德尔顿;WS,花花牛牛;WO,夭桃繁杏;WD,哈姆炸炸;WB,岱岩上溪松流;WA,丶天际;V+,粢饭;V3,鬼头桃菜丷;V1,波丶波;V0,昨夜书,倪华丶;Vq,不吃烧烤;Vo,灬追云灬;Vi,马拉喀什;Vh,超级小花花;Vd,世间大雨滂沱;Vc,Lacampanella;VW,赦免",["凤凰之神"] = "WY,纯白的牛;WV,红莲晓雨,奔跑的小狮子,一只汪的觉悟,霍雪糕,梅林胡子;WU,话也说的好听,陌上星语;WS,飞行的老猫;WR,半佛丶半神仙,柚柚妹丨;WQ,Ïðï;WP,瘾大丶;WO,丶小懒猫;WN,果凍果凍;WM,喵喵米娅;WI,生兵死士;WG,兰亭山溪午马;WF,疯揍起的碗哥,晨先森;WE,丨天线宝宝丨;WB,丨杨戬;V9,破碎丶星魂;V6,戍月望日,苗木橙;V5,卫神,不聞不問,啵啵灬小奶嘴;V3,Sorrycooker,阿僖;V1,出生入死骑;V0,没了呀妹妹,超级征服者;Vx,诸葛丶村夫;Vv,林楚儿,辛巴达重山,欧暮暮;Vr,景依维;Vq,双龍天昇剣;Vo,零落的殇,丶北极光丶,Lonergan;Vn,丶浮游;Vm,Horseshoe,双剑合璧;Vl,雪白丨血红,休克;Vk,消失的漫画家;Vi,米米狂乱,狗头萨;Vg,无糖的甜可乐;Vf,天涯觅青鸾,焦嘦嘦,于子酱,小猪佩鱼丷;Ve,自然醒吧;Vd,背影余晖,谜灬失,尤川丶蚩梦,丶对钱没情趣,夜半月听风;Vc,槐琥,阳顶顶丶,拿枪的老牛,熊卟贰,风寂笑,火龙果冻,愤怒毛驴;VY,南京扣德普雷,伊斯嗒娜;VX,超烦之萌",["埃雷达尔"] = "WY,羡渔",["格瑞姆巴托"] = "WX,樱桃丶小雯子,丨泡芙丨;WC,顾熊熊;WA,少年出大荒;V8,软萌小蜜蜜;V6,传说中的无罪;Vz,丶维达;Vt,血落丷凝寒霜,月落丷霜满天,醉舞丷影霓裳;Vs,山青丷花欲燃;Vr,肥龙丶在天;Vq,丨北笙丶,丨秋月无边丶;Vp,刘兮兮;Vj,信号旗;Vh,加肥猫猫,冷艳的暧昧;Vf,琴断弦难断;VY,Aoekaizibao,狂派丨迷乱",["伊利丹"] = "WX,凛冬之痕;WW,希伯来牧羊人;WK,兮丶夜;Vv,树屿牧歌",["丽丽（四川）"] = "WX,老纳的海飞丝;WV,納豆丶;WU,艺辰;WS,草莓没霉;V9,潇潇灬;V8,河西;Vx,尥一蹶子;Vv,丶脉动回来;Vk,丶曰天;Vh,你艾希我奶妈;Vd,烈火战歌丶",["海克泰尔"] = "WX,一咚次一;WV,冬菇冬菇;Vn,傑米蘭尼斯特;Vf,林深鹿幽鸣;Vc,机智的大叔",["贫瘠之地"] = "WX,灬朧灬,灬曨灬,爱徳华,沈梦澜;WW,抱咕痛哭,風满楼;WV,晨光倒影;V8,大胡毛熊;V6,威震一天;V5,梆硬迪;V3,兰州牛肉大王,红烧牛肉拌面;V1,大领主维拉;V0,卡妙;Vz,幽遊白书丶;Vx,阿宝呀丶;Vu,紫狱黑殇;Vr,迪亚布罗;Vq,幽游白书丶;Vo,野猫满;Vg,血红辣椒;Vf,狂魔㐅乱舞;Vd,珊瑚海;Vc,余悸,Avicii;Vb,丶毒;VZ,风起寒秋",["无尽之海"] = "WX,稖黎,双马尾大汉;WU,晨丷曦;WS,浊丷酒;WO,Wy;WN,空小白丶;WJ,好馨情;V/,蓝色的牛奶;V9,有才尛惢;V8,Rosemar;Vx,想飞怕摔;Vv,奶残;Vp,晨丷兮;Vo,Zizioiui;Vj,獨壹無貳;Vf,犇頭德撸衣;Vb,Rossoneris;VZ,带带丶;VW,牧云",["雷霆之王"] = "WX,灬私街小宁",["霜之哀伤"] = "WX,憨憨出动;WV,蓝皮小可爱;WH,柏露;Vg,等待终成遗憾;Vf,卡其布诺灬;Vd,青年蜀黍",["幽暗沼泽"] = "WX,烮空;Vd,万嗜唔忧",["安苏"] = "WX,依然小妖,相信圣光么;WW,求你了,Aribo;WR,月夜万人迷;WO,紫竹軒;WK,组我就团扑,众泰集团经理;WA,九毫克,大刀队老李;V+,网恋被骗柒萬,醉后战狂;V8,爆炸既艺术;V2,爆炸即艺术;Vx,云鬼叱,刹雫;Vv,皮皮猪的粉;Vu,妙哇;Vo,小汤姆哈迪;Vn,墨鱼丸粗面丶;Vl,Decemberm;Vj,韮菜;Vg,童话里的王子;Vf,南吕五日;Ve,丨我很纯洁丶,至尊丶牛犊子;Vd,林楚儿,马大漂亮;Vc,嗨尼玛嘴硬,英雄出少女;VY,猫耳娘丶",["斩魔者"] = "WX,九五二八;Vk,圣光之力丿",["斯坦索姆"] = "WX,游戏要啸着玩",["朵丹尼尔"] = "WX,安好勿念",["战歌"] = "WW,理想之殇;V4,我爱丁丁宁",["塞拉摩"] = "WW,地獄咫尺丶;WV,六欲红尘度;WA,人间有味;Vn,曾经依旧;VX,慕冬",["???"] = "WW,大糖堆;WV,小梦琪,Tva;WP,碰瓷儿少女",["影之哀伤"] = "WW,君莫丶笑灬;WV,柬埔寨产水稻,血色的白浅;WK,蓝心御泠;V9,老北京二锅头;V5,拂晓;V4,牛肉板缅;V2,着魔的咕咕;Vz,犇犇丿熊猫战;Vx,是阿牛啊;Vv,小熊果冻;Vp,战斗训练假人;Vm,箭追魂;Vi,天之梦幻;Vg,丨晓旭丨,肉不够骨头凑;Vf,狂躁方向盘;Ve,沾血的黃瓜;Vc,天秀阁;VW,繧儱兄",["迦拉克隆"] = "WW,弦千韵;WF,托咪老爷;Vt,远方的宁静;Vg,银月星魂;Ve,二叔灬",["燃烧军团"] = "WW,白桃酒酿",["伊森利恩"] = "WW,梦霜宇;WU,開心的馬騮;WT,镜瞳;WH,上锤丶;V0,蓝山;Vv,人间百味;Vu,由月与地;Vs,傀儡之匣,萌丶小伊;Vr,逍遥冷寒刹,小丸子呀;Vp,启源之叟;Vo,小黑瓦娜斯,Orcshaman;Vn,腐质之瓶;Vm,君乐宝;Vl,跋依抛污;Vh,辞忧,習慣隠身;Vg,黑色信封;Vf,桃溪春野;Vd,小小波哥丶;Vb,机智的大叔;Va,执笔绘苍穹;VX,冷月丨",["布兰卡德"] = "WW,蔡先森;V4,Singlecase;V0,薯条可乐;Vw,丶涼風丶;Vv,我要射咯;Vr,萨洛多斯;Vq,南无阿彌陀佛;Vm,莫莫小可爱;VX,玛法里奧怒风",["风暴之眼"] = "WV,Maraad",["熔火之心"] = "WV,五牛断魂丶",["国王之谷"] = "WV,给我来包辣条;WT,守中;WP,姬胤;WO,我只爱霞诗子;Vz,終極閃光;Vr,布丁甜甜;Vi,夏川真凉丶;Vf,留痕;Vc,一凤;Va,战士雍杰大叔",["冰风岗"] = "WV,木攸枫,阿赞;WK,巴伦支;Vx,夜不深不睡;Vw,Elimination;Vh,残丷雪;Vg,我叫匕杀大;Ve,萌萌哒滴萌萌;Vc,天选之子,月玄孤心;Va,洗尽凡间铅华;VV,哆啦比梦",["末日行者"] = "WV,聖光闪闪;WU,悠遊小骑;WO,一步莲桦;WJ,老黑驴;WC,相思在雨中;V7,宁月安然;Vg,Komms,不斷;Vd,隐匿的气息,皮塞船;Vc,坠落战神;Va,Shallnotpass",["遗忘海岸"] = "WV,绕开黑石会",["血环"] = "WU,沐秋;WA,某咸鱼;V8,伊利戴安;V4,Yovanna",["回音山"] = "WU,桜咲夜;Vu,百兽领主;Vt,肆月筱战乄;Vl,魔抗孩;Vh,叁嗣叁",["鬼雾峰"] = "WT,蕾丝舞弓弦;Vc,Relieved;Va,卟忘丶初心",["月神殿"] = "WT,奥丽瑞娜",["神圣之歌"] = "WS,隐秘的射手;WD,樱刀;Vq,Luthien;Vk,部落两大傻;Vc,幽幽小生",["克尔苏加德"] = "WP,鬼洛;V2,孤城丶;Vn,不破眠虫;Vl,盛夏娇杨丶;Vc,凛冬怒吼;VX,丶天师傅",["熊猫酒仙"] = "WO,蹉跎的青春;WN,一射手一;WC,霜思拒雨花缠;WB,萌是柠檬的黄;V4,宁棒棒;Vq,偶尔有点殇;Vn,小黄瓶;Vj,三土兄;Vc,尹力平;VY,泰澜德灬小鬼",["太阳之井"] = "WN,欧米伽丶",["主宰之剑"] = "WM,王者丨帰來;WI,阳光晒干思念;V8,Arrti;V6,焚心炎;V1,肥胖的胖子;Vt,猎神小萌主;Vo,亢慕义斋;Vm,黑凤梨呀;Ve,暗殺星;Vd,冰煌血舞;Vc,球丶;VY,Orionsuio,终焉恩赐,梦里是谁,冯珍珠;VX,娜依秀美;VW,Sicklikeme",["永恒之井"] = "WM,八百里;Vz,周王畿",["奎尔丹纳斯"] = "WL,灬木南霜",["夏维安"] = "WL,蓉城大熊猫",["迅捷微风"] = "WK,青衫夜白;Vx,绝望的鸟,谢顶的阿昆达;Vn,达瓦里氏丶",["伊瑟拉"] = "WJ,小早川怜子",["石爪峰"] = "WJ,摩可那;Vt,摩可拿",["古尔丹"] = "WH,依然戰士",["羽月"] = "WH,风刀雪剑",["艾莫莉丝"] = "WH,深海孤鸿;Vs,正太爱卖萌;Vl,性感小野猫",["红云台地"] = "WH,万有引力",["暗影之月"] = "WF,妲姝",["晴日峰（江苏）"] = "WF,月之左;V3,兜兜丶狠骚",["火烟之谷"] = "WE,Sici",["暮色森林"] = "WE,紅塵買醉",["安东尼达斯"] = "WD,张雨绮丶",["火焰之树"] = "WD,李灬小德",["破碎岭"] = "WC,肥肉肉先生;V+,Turbowarrior;Vr,月丫;Vd,那一抹深蓝色",["萨尔"] = "WA,小腹黑丶",["月光林地"] = "WA,阿珞菲怒风;Vt,雪伦;Vp,花媚玉堂人;Ve,白兔软糖",["埃德萨拉"] = "V/,白衣煮茶;Vi,橘昕大欧皇;Vg,不萌不萌啦;Vd,萨绝人寰",["黑铁"] = "V+,清蒸梦梦",["冰川之拳"] = "V9,幕後丶殘雪;Vf,寶貝卟哭",["黑暗魅影"] = "V8,能打能抗",["拉文凯斯"] = "V8,Remrem;Vg,青烟雨;Vc,小村镇的吻",["泰兰德"] = "V6,雨霾;Vl,包子系马达;Vb,Minikiki",["红龙军团"] = "V6,顽皮的小强",["瓦里玛萨斯"] = "V6,独孤独享",["阿纳克洛斯"] = "V6,罗盘之誓;Vo,残垣立旧篷丶;Vm,残垣立旧篷;VY,棺材板踏浪者",["觅心者"] = "V5,小瑾然",["洛肯"] = "V3,九队牧;Vg,Dklinjiang;Vc,猫哥",["耳语海岸"] = "V2,瓶中自在天",["艾露恩"] = "V1,弗萊婭",["加基森"] = "V0,Blackadder;Vw,第二个我",["伊萨里奥斯"] = "Vz,霹雳雷霆",["试炼之环"] = "Vv,日部落姐姐",["暗影迷宫"] = "Vu,荇菜流之;Vd,带带大天启",["麦迪文"] = "Vt,星星泡饭",["艾萨拉"] = "Vs,玄冰塞弗斯,玄冰佐佑",["日落沼泽"] = "Vs,術心;Vd,眼棱瞎了眼丶",["克洛玛古斯"] = "Vr,来杯拉菲",["麦姆"] = "Vr,尛乄射天狼",["达尔坎"] = "Vq,阿萨德发啊",["地狱之石"] = "Vq,江湖夜雨",["阿迦玛甘"] = "Vq,曾经的记忆",["加里索斯"] = "Vq,心有琉璃",["萨菲隆"] = "Vq,筱丹",["石锤"] = "Vo,Alive",["兰娜瑟尔"] = "Vn,世界之树",["冰霜之刃"] = "Vn,正则灵均",["守护之剑"] = "Vn,笑书神侠;Vk,情流感",["尘风峡谷"] = "Vl,不扰清梦,醉梦独舞",["瑟莱德丝"] = "Vl,懒癌晚期凉凉",["普罗德摩"] = "Vl,丨影刃丨",["阿克蒙德"] = "Vk,睡衣",["玛诺洛斯"] = "Vk,茉莉冰冰",["银松森林"] = "Vk,混沌小小",["蜘蛛王国"] = "Vk,Johnnyr",["翡翠梦境"] = "Vj,Pala",["符文图腾"] = "Vj,嘟嘟",["白骨荒野"] = "Vj,永恒之夜",["德拉诺"] = "Vi,幼儿园大王",["狂热之刃"] = "Vh,孤独伊枫丶",["时光之穴"] = "Vh,花伦同学",["凯恩血蹄"] = "Vh,美女;Vc,易拉罐;VV,丶我不奶",["卡德加"] = "Vh,江湖传奇",["深渊之喉"] = "Vh,动感光波",["图拉扬"] = "Vh,子雨山",["万色星辰"] = "Vg,尤丨迪安",["伊莫塔尔"] = "Vf,舒预言",["血牙魔王"] = "Vf,Mojiedjlr;Vc,七叶一枝花妖",["普瑞斯托"] = "Vf,一念丹香",["诺森德"] = "Vf,无限正义",["阿古斯"] = "Vf,贺豪豪",["巨龙之吼"] = "Vf,馮巩老師丶",["奥妮克希亚"] = "Ve,伽罗丶六道",["寒冰皇冠"] = "Ve,牛克蒙德",["自由之风"] = "Ve,黑枸杞",["风行者"] = "Ve,蔡萌萌",["泰拉尔"] = "Ve,弋影",["索瑞森"] = "Ve,飘渺天下",["安戈洛"] = "Vd,动物园牛总",["恶魔之魂"] = "Vd,破坏者血雨",["暴风祭坛"] = "Vd,Èèsp",["耐普图隆"] = "Vd,小豆先生",["世界之树"] = "Vd,死亡深度",["银月"] = "Vd,风雪夜归人",["天空之墙"] = "Vc,依楼丶听雨",["巫妖之王"] = "Vc,剑出烛影随",["嚎风峡湾"] = "Vc,俄里翁",["洛丹伦"] = "Vc,犇啵霸",["轻风之语"] = "Vb,天选之子",["希雷诺斯"] = "VZ,洛城时光灬",["龙骨平原"] = "VX,小手很凉",["地狱咆哮"] = "VW,呱二蛋",["格雷迈恩"] = "VW,Statet",["大地之怒"] = "VV,灬浮竹灬",["诺兹多姆"] = "VV,少年出大荒"};
local lastDonators = "猫耳朵女郎-罗宁,五牛断魂丶-熔火之心,Maraad-风暴之眼,肉喵-死亡之翼,如果丶云知道-死亡之翼,蔡先森-布兰卡德,Aribo-安苏,希伯来牧羊人-伊利丹,風满楼-贫瘠之地,梦霜宇-伊森利恩,白桃酒酿-燃烧军团,弦千韵-迦拉克隆,勋爵-金色平原,中华德-死亡之翼,君莫丶笑灬-影之哀伤,灬一生所爱灬-燃烧之刃,大糖堆-???,一冲锋就躺丶-死亡之翼,求你了-安苏,地獄咫尺丶-塞拉摩,抱咕痛哭-贫瘠之地,理想之殇-战歌,安好勿念-朵丹尼尔,米德尔顿-血色十字军,相信圣光么-安苏,游戏要啸着玩-斯坦索姆,丨泡芙丨-格瑞姆巴托,沈梦澜-贫瘠之地,九五二八-斩魔者,星辰碎裂-白银之手,依然小妖-安苏,卡哇伊希月-白银之手,烮空-幽暗沼泽,双马尾大汉-无尽之海,爱徳华-贫瘠之地,憨憨出动-霜之哀伤,法嘟嘟-死亡之翼,川琦来梦-塞纳留斯,灬私街小宁-雷霆之王,醉卧听禅-白银之手,稖黎-无尽之海,灬曨灬-贫瘠之地,灬朧灬-贫瘠之地,一咚次一-海克泰尔,老纳的海飞丝-丽丽（四川）,凛冬之痕-伊利丹,贰西莫夫-血色十字军,樱桃丶小雯子-格瑞姆巴托,羡渔-埃雷达尔,纯白的牛-凤凰之神,Vcirmson-血色十字军,亚历山歪罗斯-罗宁,Trummer-金色平原,Whaler-塞纳留斯,司空摘星-燃烧之刃,枯燥-亚雷戈斯,煙雨丶小爱-利刃之拳,拿长柄扔炸弾-死亡之翼,越過山丘-白银之手,雯宝宝-燃烧之刃";
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