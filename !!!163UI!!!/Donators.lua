local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["燃烧之刃"] = "X/,嘎哥哥腰子,萌妹事你少管,辣妹事你少管,奶香起酥;X8,月野兔水冰月;X2,九把胡子;X0,猎族猎宗,Moneybuff;Xy,Angryman;Xw,夜夜云雨;Xv,饼干酥酥,昊男;Xi,厚礼蟹丶;XP,秋洵薰心,Zekrom;XN,春易老;XA,黑暗契约丨幽;W8,厄齐赞古斯;W2,瑜茹小袁籽;Wt,讨打;Wq,天山区;Wn,卿陌;Wj,老牛牛波;Wh,希尔丶瓦娜嘶;Wg,吾之荣耀丶;Wa,Faiz;WZ,茗箭,雯宝宝;WY,司空摘星;WW,灬一生所爱灬;WV,絶版霸道,Deathros;WR,卿爅,花丨语;WP,别被逮住;WH,学不会开锁;WD,丷佐漫丷;WA,Holybeast;V8,丶满老师;V2,天蜀黍,徐愿;Vx,寒灬欲;Vv,脚毛随风飘丶,射天狼西北望;Vq,Miyadad;Vp,锋飘舞,超级攻强卷轴;Vo,如果我有轻功;Vn,毛德,静香海王;Vm,香犇犇,冰淇淋牛排;Vf,始终怀念;Ve,议事厅哭强战,黄黄皇帝;Vd,尛噩夢,大奶猴也算猴;Vc,辛多雷强哥,霜火挽歌丶;VV,闪开我要装逼",["凤凰之神"] = "X/,乡村水牛;X6,喵嘞个咪丶;X1,英雄的荣耀;Xy,Enfamil;Xt,勿问归期;Xq,Finalsoul;Xl,Bloodymoon;XW,兰亭山溪午马;XJ,Janos,炽煌;XH,欧皇小浮华;XG,春水煎茶丶,摩法士丶;XE,灰灰的尾巴;XD,洗剪吹一千;XC,Rius,遇术邻疯;XB,弥音梵尘;W/,Shigemushi,太子神;W+,是小狐狸呀丷;W6,王老师的劣仁;W4,咕嘟咕嘟冒泡;W3,Loveyluck,冷月清霜;Wy,风火连天;Wu,甜蜜香吻;Wt,霏慕游侠,今天下雨好冷,狗哥你好吗;Wr,昭炎;Wo,冬熊夏草;Wm,妄丶想家,星晴故里,殺人不分左右,别惹瞧瞧大王;Wl,咸小鱼丶;Wk,夏灬浅浅,花灬筱妖;Wh,五角钱,尝尝我的鞋;Wg,Johnwicki;Wf,风暴西瓜茶,跳舞兔;Wd,Shigefashi,仇世;Wb,Mikakiller;WY,纯白的牛;WV,红莲晓雨,奔跑的小狮子,一只汪的觉悟,霍雪糕,梅林胡子;WU,话也说的好听,陌上星语;WS,飞行的老猫;WR,柚柚妹丨;WQ,Ïðï;WP,瘾大丶;WO,丶小懒猫;WN,果凍果凍;WM,喵喵米娅;WI,生兵死士;WF,疯揍起的碗哥,晨先森;WE,丨天线宝宝丨;V9,破碎丶星魂;V6,戍月望日,苗木橙;V5,卫神,不聞不問,啵啵灬小奶嘴;V3,Sorrycooker,阿僖;V1,出生入死骑;V0,没了呀妹妹,超级征服者;Vx,诸葛丶村夫;Vv,林楚儿,欧暮暮;Vr,景依维;Vq,双龍天昇剣;Vo,零落的殇,丶北极光丶,Lonergan;Vn,丶浮游;Vm,Horseshoe,双剑合璧;Vl,雪白丨血红,休克;Vk,消失的漫画家;Vi,狗头萨;Vg,无糖的甜可乐;Vf,天涯觅青鸾,焦嘦嘦,于子酱,小猪佩鱼丷;Ve,自然醒吧;Vd,背影余晖,谜灬失,尤川丶蚩梦,丶对钱没情趣,夜半月听风;Vc,槐琥,阳顶顶丶,拿枪的老牛,熊卟贰,风寂笑,火龙果冻,愤怒毛驴;VY,南京扣德普雷,伊斯嗒娜;VX,超烦之萌",["回音山"] = "X/,核心战;Xt,我不理解;XG,雾临萌主;Wm,我是你的老汉;Wb,霸王狂脱;WU,桜咲夜;Vu,百兽领主;Vt,肆月筱战乄;Vl,魔抗孩;Vh,叁嗣叁",["死亡之翼"] = "X+,千里暮平云;X9,密丶瓜;X8,青云闭月;X4,枫镇大肉,冲锋崴到脚丶,浑浆凉粉;X2,安迪先森;Xt,炒菜没特色;Xj,碳烤芥末;Xd,红红葡萄;Xb,易玖玖;XX,黑妞丶妞;XS,雲天;XQ,Snakes;XO,吉薇艾兒;XN,握草;XH,南顾,筱枼;XG,柒霗,丿筱枼;XC,丶哎哟德,尛鬼難纏;W/,Hyitdai;W5,丷猫颜乀;W0,绵绵小仙女,顽皮老板丶;Wv,庄大根;Wu,Price;Wn,这一箭叫相思;Wj,被动;Wi,烤蛋;Wg,过往皆爲序章;Wf,天赐无痕,瑪咔吧咔;We,阝迶亻更身寸,見夢,灭团丨剩骑士,Cde;Wc,头文字帝,丶糖門滚;Wb,丶奇怪的风车,战吊们的亲爹;WY,拿长柄扔炸弾;WX,法嘟嘟;WW,一冲锋就躺丶,中华德,如果丶云知道,肉喵;WU,张祎童大帅比;WT,拉拉环;WQ,大角雄鹿;WP,麦兜麦兜麦兜;WO,牛少丶;WM,玩偶永远滴神;WK,怎么转啊,就咬你屁屁;WJ,终点传送站,猎丶皇;WI,黑丝大长腿,疯踏;WH,大碗卤煮;WE,魇之煞;WD,Mwqx;WB,蝎子來來;V/,古勒塔丶雷索;V5,葱葱橘猫,天然呆小柠檬,小五同学;V3,就喜欢玩偶姐;V1,欧小熙,陆眼,哎呀被发现了;V0,脆脆鲨好吃;Vx,悦曦;Vt,仲夏夜之禁;Vr,安妮可姬;Vq,就喜欢瞎李姐,高先生丶;Vm,野猪大王;Vl,清水泓清,天天喝枸杞;Vj,Berryzl;Vh,谢幕挽歌,昱焱小红手,嘻嘻西茶;Vg,仲夏夜之术,残魂断枫桥,六十八;Vf,拒绝我都被绿,Jeromecc;Vd,杨扬采,仙晨之灵,Lixm;Vc,醉后,老淦部,梦幻彤凡;Vb,发飙的天牛;Va,夜阑听雨丶;VZ,刃命,没教养的瘤;VW,莽斧,南宫仆射灬,梦醒九分丶,油油的小绿皮",["国王之谷"] = "X+,团团小肉熊;X5,狂暴猪头;X0,夂丒炗;Xj,啦莱耶;Xi,太阳能维修;XT,丨江隂饅頭丨;W6,花无劫灬,允良;Ws,一打七;We,硬汉小瓜皮;Wd,不知高低;WV,给我来包辣条;WT,守中;WO,我只爱霞诗子;Vz,終極閃光;Vr,布丁甜甜;Vi,夏川真凉丶;Vf,留痕;Vc,一凤;Va,战士雍杰大叔",["丽丽（四川）"] = "X9,丶火云邪神;XF,灬侠丨岚灬;XA,雀雀怪丶;Wh,整的啥子;WX,老纳的海飞丝;WV,納豆丶;WU,艺辰;WS,草莓没霉;V9,潇潇灬;V8,河西;Vx,尥一蹶子;Vv,丶脉动回来;Vk,丶曰天;Vh,你艾希我奶妈;Vd,烈火战歌丶",["安苏"] = "X9,唯美丶莮神;X3,煎妮;X2,弹殼丶;Xt,晨风挽歌;Xp,暗叶丶;Xi,明日梦,真是令人生气;XU,水平;XR,淡雾;XN,温州王宝强;XD,巴耶克;W+,Euo;W7,Aliciayoyo;W3,蝶舞鸣;Wr,Eco,疯尼姑;Wp,丷火影丷;Wi,醉梦相思;Wd,蘭亭集序;WZ,丨绮梦千年丨;WX,依然小妖,相信圣光么;WW,求你了;WR,月夜万人迷;WO,紫竹軒;WK,组我就团扑,众泰集团经理;WA,九毫克,大刀队老李;V+,网恋被骗柒萬,醉后战狂;V8,爆炸既艺术;V2,爆炸即艺术;Vx,云鬼叱,刹雫;Vv,皮皮猪的粉;Vu,妙哇;Vo,小汤姆哈迪;Vn,墨鱼丸粗面丶;Vl,Decemberm;Vj,韮菜;Vg,童话里的王子;Vf,南吕五日;Ve,丨我很纯洁丶,至尊丶牛犊子;Vd,林楚儿,马大漂亮;Vc,嗨尼玛嘴硬,英雄出少女;VY,猫耳娘丶",["贫瘠之地"] = "X8,七言,丶九丶曜丶;X4,夜涩;X1,和和气气丶,暖风予她丶;Xx,孤儿新收集者;Xq,如果我说爱;Xp,人菜脾气大,其實很簡單;Xc,炸不干的油渣;XS,达丶令;XQ,糖心阿婆小桃;XO,殢无伤,痞傲,胖胖躺尸老板;XH,狗喜说哦问号,伱若離去,电竞孤儿李狗;XA,部落丶忠魂,神明嘎嘎乱鸭,缕隙微光;W+,霏慕骑士;W8,二胡作家阿炳;W7,如若时光倒流;Wx,夜阑听雨眠,江津老白干丶;Wp,肥仔苏;Wo,哒丶令;Wa,千月云;WX,灬朧灬,灬曨灬,爱徳华,沈梦澜;WW,抱咕痛哭,風满楼;WV,晨光倒影;V8,大胡毛熊;V6,威震一天;V5,梆硬迪;V3,兰州牛肉大王,红烧牛肉拌面;V1,大领主维拉;V0,卡妙;Vz,幽遊白书丶;Vx,阿宝呀丶;Vu,紫狱黑殇;Vr,迪亚布罗;Vo,野猫满;Vg,血红辣椒;Vf,狂魔㐅乱舞;Vd,珊瑚海;Vc,余悸,Avicii;Vb,丶毒;VZ,风起寒秋",["布兰卡德"] = "X8,利威爾阿克曼;Xu,嘟嘟等等;Xn,醜醜兒;XM,摩天动物园丶;We,電話烤箱;WZ,纯欲天花板;WW,蔡先森;V4,Singlecase;V0,薯条可乐;Vw,丶涼風丶;Vv,我要射咯;Vr,萨洛多斯;Vq,南无阿彌陀佛;Vm,莫莫小可爱;VX,玛法里奧怒风",["索瑞森"] = "X7,牛肉饼,阿乐,听说很简单;Wx,莫多丶零玖;Ve,飘渺天下",["伊森利恩"] = "X7,帅气的老大;Xl,Sarahb;Xf,Meyac;XO,最愛華仔,小爅;XN,一口小奶茶;XM,Chilez;XJ,彻骨生寒;XC,星空乀;XA,人间值得;W5,雾雲;W4,不离丶;Wy,丶皓;Wx,李丶四风醇酿;Wv,Flongall;Wq,小猪万人迷,何嫔;Wp,温柔抱;Wl,Zinac;Wk,灬濛濛灬,丨嗷呜;Wg,冰葡萄丶,琴瑟知音惜;Wf,人渣萝丶莉控;Wd,小姬友;Wa,也都熬过来了;WW,梦霜宇;WT,镜瞳;WH,上锤丶;V0,蓝山;Vv,人间百味;Vu,由月与地;Vs,傀儡之匣,萌丶小伊;Vr,逍遥冷寒刹,小丸子呀;Vp,启源之叟;Vo,小黑瓦娜斯,Orcshaman;Vn,腐质之瓶;Vl,跋依抛污;Vh,辞忧,習慣隠身;Vg,黑色信封;Vf,桃溪春野;Vd,小小波哥丶;Vb,机智的大叔;Va,执笔绘苍穹;VX,冷月丨",["霜之哀伤"] = "X6,爱吃汉堡堡;Xm,部落队长;XL,再来一瓶冰茶;XJ,Tailmon;W4,剑心无殇;Wt,大呗呐;WX,憨憨出动;WV,蓝皮小可爱;WH,柏露;Vg,等待终成遗憾;Vf,卡其布诺灬;Vd,青年蜀黍",["冰风岗"] = "X5,一至;XV,咩咩熊;XR,书辰德,海东青丨;Wy,茶海糖;Wd,Anicca;Wc,自丶由;WV,木攸枫,阿赞;WK,巴伦支;Vx,夜不深不睡;Vw,Elimination;Vh,残丷雪;Vg,我叫匕杀大;Ve,萌萌哒滴萌萌;Vc,天选之子,月玄孤心;Va,洗尽凡间铅华;VV,哆啦比梦",["白银之手"] = "X4,李开心,雲臥北冥;X2,将风惜;X1,血舞奶茶;X0,冲锋接释放丶;Xy,章鱼的杀戮;Xn,炎武熠;Xm,執筆斷情殤;Xi,封剑祭天;XS,咕阿呱;XO,镜井;XL,晨晨仔;XJ,左邑;XF,犹师傅飞饼;XE,浅墨初雪;XA,温莎修士;W/,心愉侧;W9,以箭封缄;W7,奥利氟,地瓜来了;Wt,网恋熊;Ws,月夜枕星河;Wn,Sudly;Wl,玥色琉汐;Wg,荒野玄宗;Wf,Orangemay;We,风中一叶;Wd,欢乐何在啊;Wc,霜冬,乘风雾里;Wb,白银丶之锋,见子,叮咣一顿呲溜;WY,越過山丘;WX,醉卧听禅,卡哇伊希月,星辰碎裂;WV,镰翼,嫁祸诀窍丶;WT,天道紫霄神雷,三十岁小老头;WQ,芸柚;WP,楓叶丶;WO,丶莫忘青葵;WK,天魁星;WC,天地飞舞;WB,立冬夏至;V8,阿狸爱吃肉;V6,昆得莱耀西;V5,萌葱双马尾,青丝任風绾;V3,蓝迦;Vv,麦卡伦的春天;Vr,百香果冰沙,多多队长;Vq,艾星恶势力丶;Vo,Sniperkennys,圣洁重生,契约飞飞,死神小小妹;Vl,Ninesixmage,我要自然醒,丨浣熊丨;Vk,您说的对;Vj,丷不二丷;Vg,畚瓟旳蝸犇,奥蕾莉亚公爵;Vf,血腥战歌,云中寄雨;Ve,彼麦凯蒂丶,Shanbaby,冰冰水冰;Vd,小小心脏,Ntmdjjww,壹贱定天下;Vc,封尘絕念斬;VY,小喵弯月;VV,老板来碗凉面,叶奈法的玩具",["暗影迷宫"] = "X4,赵依然;XK,无敌大黑牛;Vu,荇菜流之;Vd,带带大天启",["迦拉克隆"] = "X4,只准自己摸;XX,无牙利齿;Wq,人民的奶妈;Wp,极地白熊风暴;WW,弦千韵;WF,托咪老爷;Vt,远方的宁静;Vg,银月星魂;Ve,二叔灬",["洛肯"] = "X4,Dx;V3,九队牧;Vg,Dklinjiang;Vc,猫哥",["盖斯"] = "X4,风归云",["血色十字军"] = "X4,山竹黑白配;X3,Ai;Xx,比尔希尔;Xr,猪扒盖浇饭;Xj,逢春;Xi,小兔子掰掰;XU,穆神;XT,震荡快分担;XR,萌萌然;XA,吾为刀俎,雨天小小;W5,恐惧之魅;W4,叶落尘封;Wx,邪眼魔姬;Wv,Zuijiu;Ws,胜利;Wj,梅樱;Wb,桂丶渣王;Wa,浮华烟雨;WY,Vcirmson;WX,贰西莫夫,米德尔顿;WS,花花牛牛;WO,夭桃繁杏;WD,哈姆炸炸;WB,岱岩上溪松流;WA,丶天际;V+,粢饭;V3,鬼头桃菜丷;V1,波丶波;V0,昨夜书,倪华丶;Vq,不吃烧烤;Vo,灬追云灬;Vi,马拉喀什;Vh,超级小花花;Vd,世间大雨滂沱;Vc,Lacampanella;VW,赦免",["冰霜之刃"] = "X2,小迷弟;XC,離岸;W3,阿尔托丶莉雅;Vn,正则灵均",["纳克萨玛斯"] = "X1,血夜红魔",["埃克索图斯"] = "X1,乂烈风乂;Wx,萌萌哒丶夜风;Wb,苝落师門",["无尽之海"] = "X0,囧犇犇囧,武功;Xy,牛犇乚;Xx,兔大毛;Xp,真气啵丶;Xi,儿时回忆;Xf,小辛巴一号;XB,辛巴达远山;W8,阿狄;W3,龍卷;W0,半佛丨半神仙;Wt,黑椒牛排;Wr,半佛丶半神仙;Wq,不灭钻石;Wm,半佛半神仙丶;Wj,丶白爷;Wi,炑战丶;Wf,伊小博;Wc,说闪就闪;WX,稖黎,双马尾大汉;WU,晨丷曦;WS,浊丷酒;WO,Wy;WN,空小白丶;V/,蓝色的牛奶;V9,有才尛惢;V8,Rosemar;Vx,想飞怕摔;Vv,奶残;Vp,晨丷兮;Vo,Zizioiui;Vj,獨壹無貳;Vf,犇頭德撸衣;Vb,Rossoneris;VZ,带带丶;VW,牧云",["银松森林"] = "Xz,Chancellor;Wi,骑闯天路二;Vk,混沌小小",["罗宁"] = "Xz,Pathfindfox;Xr,花火枫霜;Xb,薇羽;XT,詩乃;XF,细雨无眠;XD,一颗圆滚滚;XC,大桥未久丶;XA,最终真理;W5,龙武;W0,艾露丶菲露特;Wt,恰比;WY,亚历山歪罗斯;WV,猫耳朵女郎,碧空之怒,小通;WU,沾繁霜至曙;WJ,Ansh;WH,梦不到的她,宋裤;WE,阿滴;V9,快救救胡桃;Vw,灬無名灬;Vv,滚刀肉球;Vq,蹿吧兔孙,崎涟出云;Vp,小小的小浣熊;Vl,黄油蟹蟹,魔龙,海叶灬;Vg,青夏瑶,暗殺星乄;Vf,墨华,盞茶作酒;Vd,伊利瑟维斯;VZ,川西北大拿;VV,雅詩",["熊猫酒仙"] = "Xz,福瑞猫猫控;Xk,逍遥行;W7,丶懒懒的熋;Wz,餐具包含叉勺;Wa,热心市民胖某;WO,蹉跎的青春;WN,一射手一;WC,霜思拒雨花缠;WB,萌是柠檬的黄;V4,宁棒棒;Vq,偶尔有点殇;Vn,小黄瓶;Vj,三土兄;Vc,尹力平;VY,泰澜德灬小鬼",["主宰之剑"] = "Xy,飞天御剑;Xm,莴很菜;Xd,执念成狂;XY,轲拉拉;XW,水情天蓝;XQ,贫尼法号乱搞;XI,风未起;XG,西山不太远;XF,夜未眠;W/,千年;W4,疯狂的小毛;W3,佳仪悳;Wk,阿尔卡狄奥;Wi,极木;Wg,翎丨枫,翎丨淑;WM,王者丨帰來;WI,阳光晒干思念;V8,Arrti;V6,焚心炎;V1,肥胖的胖子;Vt,猎神小萌主;Vo,亢慕义斋;Vm,黑凤梨呀;Ve,暗殺星;Vd,冰煌血舞;Vc,球丶;VY,Orionsuio,终焉恩赐,梦里是谁,冯珍珠;VX,娜依秀美;VW,Sicklikeme",["格瑞姆巴托"] = "Xy,故乡的孀花;XF,小脚哇哇凉,黑灵星官;XC,尨貓丷;W+,舔管儿;W5,萧陌丶;W0,白芝驹;Wr,战复丶我爆发;Wq,大号橙色坏蛋;Wd,战服丶我爆发;Wb,希尔丶瓦娜嘶;WX,樱桃丶小雯子,丨泡芙丨;WC,顾熊熊;WA,少年出大荒;V8,软萌小蜜蜜;V6,传说中的无罪;Vz,丶维达;Vt,血落丷凝寒霜,月落丷霜满天,醉舞丷影霓裳;Vs,山青丷花欲燃;Vr,肥龙丶在天;Vq,丨北笙丶,丨秋月无边丶;Vp,刘兮兮;Vj,信号旗;Vh,加肥猫猫,冷艳的暧昧;Vf,琴断弦难断;VY,Aoekaizibao,狂派丨迷乱",["万色星辰"] = "Xx,Limitless;W+,星枫;Vg,尤丨迪安",["影之哀伤"] = "Xw,尤格萨隆丿;Xs,浅墨灬圣骑;Xl,落丶幕,二月水香;Xa,林深时见鹿丷;XV,狂暴西红柿;XU,小面包;XQ,山野丶莽汉;XO,旖乄旎;XK,核爆弾丶;XJ,麻辣小珑虾;XG,临风惜丶;XC,古今;XB,流灬年;W/,潇洒的小郎君;Wq,夜景;Wo,沉辞;Wk,夏月婵歌;Wa,核桃仁酥饼丶;WZ,完美女神;WW,君莫丶笑灬;WV,柬埔寨产水稻,血色的白浅;WK,蓝心御泠;V9,老北京二锅头;V5,拂晓;V4,牛肉板缅;V2,着魔的咕咕;Vz,犇犇丿熊猫战;Vx,是阿牛啊;Vv,小熊果冻;Vp,战斗训练假人;Vm,箭追魂;Vi,天之梦幻;Vg,丨晓旭丨,肉不够骨头凑;Vf,狂躁方向盘;Ve,沾血的黃瓜;Vc,天秀阁;VW,繧儱兄",["血环"] = "Xv,我爱我祖国;Wk,Morganstark;WU,沐秋;WA,某咸鱼;V8,伊利戴安;V4,Yovanna",["末日行者"] = "Xu,礼拜甜;Xj,空恨别夢久,可她总在梦里;W+,芬芳游侠;W7,弄清影;Wy,丶死神天降;WV,聖光闪闪;WU,悠遊小骑;WO,一步莲桦;WJ,老黑驴;WC,相思在雨中;V7,宁月安然;Vg,Komms,不斷;Vd,隐匿的气息,皮塞船;Vc,坠落战神;Va,Shallnotpass",["烈焰峰"] = "Xt,午夜银河电台",["利刃之拳"] = "Xt,奥的灰烬;WY,煙雨丶小爱;Vp,非常爷们;Ve,透明凝清",["雷霆之王"] = "Xs,灬神兜兜灬;WX,灬私街小宁",["亚雷戈斯"] = "Xr,无情的工具人;XH,修羅之刻;Wx,银翼之歌;Wq,一滴也没有了;Wh,守望夏夏天,皓月骑士,皓月萨满,皓月猎手,守望秋天;WY,枯燥",["冬泉谷"] = "Xr,咕嘿嘿",["夏维安"] = "Xp,李知安,醉卧花枝眠;WL,蓉城大熊猫",["埃德萨拉"] = "Xp,欧皇粗野;XW,粗野;W0,一超级路痴一;V/,白衣煮茶;Vi,橘昕大欧皇;Vg,不萌不萌啦;Vd,萨绝人寰",["永恒之井"] = "Xo,人性本恶;Xm,神力女超人;Ws,雷龙觉醒;WM,八百里;Vz,周王畿",["加里索斯"] = "Xn,狮心王瓦里安;Vq,心有琉璃",["破碎岭"] = "Xn,图图其貌不炀;W5,亡权;Wl,罪怒;WC,肥肉肉先生;V+,Turbowarrior;Vr,月丫;Vd,那一抹深蓝色",["克尔苏加德"] = "Xm,斗战圣佛丶;XH,张雨绮丶;W0,低調的欧皇;Wc,閃现;WP,鬼洛;V2,孤城丶;Vn,不破眠虫;Vl,盛夏娇杨丶;Vc,凛冬怒吼;VX,丶天师傅",["狂热之刃"] = "Xl,小二班班长;Vh,孤独伊枫丶",["暗影之月"] = "Xk,月色繁星;WF,妲姝",["战歌"] = "Xj,甘蝶;WW,理想之殇;V4,我爱丁丁宁",["泰兰德"] = "Xj,鹏哥华丽的;V6,雨霾;Vl,包子系马达;Vb,Minikiki",["奥尔加隆"] = "Xi,杰尼晨",["耳语海岸"] = "Xi,米丨小贼;Wm,伊利达雷;V2,瓶中自在天",["遗忘海岸"] = "Xb,丶清白之年;XB,渡鴉;Wb,冥河之灵;WV,绕开黑石会",["神圣之歌"] = "Xb,瑶山长琴丶;XA,七色的灵魂链;Wt,拨云箭日,瀑崩;Wp,雨霾;WS,隐秘的射手;WD,樱刀;Vq,Luthien;Vk,部落两大傻;Vc,幽幽小生",["时光之穴"] = "XY,打架爱转圈;Vh,花伦同学",["雷克萨"] = "XX,Riom",["巴瑟拉斯"] = "XW,烈日行者",["鬼雾峰"] = "XU,蛋蛋污妖王;WT,蕾丝舞弓弦;Vc,Relieved;Va,卟忘丶初心",["迦罗娜"] = "XS,我想吃饭",["萨菲隆"] = "XS,王爷息怒;Vq,筱丹",["奎尔萨拉斯"] = "XR,斯内普教授",["伊利丹"] = "XP,如水;WX,凛冬之痕;WW,希伯来牧羊人;WK,兮丶夜;Vv,树屿牧歌",["通灵学院"] = "XP,兔芽芽",["石爪峰"] = "XM,押韵丶;WJ,摩可那;Vt,摩可拿",["金色平原"] = "XM,梅根丶福克斯;W/,桶装奥利奥;Ws,蔚丶奥莱;Wn,敏宝贝;Wj,糟老头子丶;WY,Trummer;WW,勋爵;WS,诺顿;WO,阳电子炮;WH,卡妙;Vg,泥头车撞太郎;Vc,遇见北极星",["暗影议会"] = "XL,爷青回;XI,月白流苏",["黑铁"] = "XI,鱼滚滚;V+,清蒸梦梦",["普罗德摩"] = "XI,雪菲;Vl,丨影刃丨",["阿卡玛"] = "XI,阿蒂珥安娜",["雷斧堡垒"] = "XF,海蓝朵;Wh,灬小女娲灬",["阿纳克洛斯"] = "XA,啊尔托莉蕥;Wm,多舛;V6,罗盘之誓;Vo,残垣立旧篷丶;Vm,残垣立旧篷;VY,棺材板踏浪者",["风暴之怒"] = "W8,苦难辉煌",["奥特兰克"] = "W7,雨後調情",["灰谷"] = "W6,我欲乘风而去;Wb,大魚楽天",["布莱恩"] = "W4,骷髅歌歌",["斯坦索姆"] = "W2,敏锐的小浩劫;WX,游戏要啸着玩",["哈兰"] = "W0,智沫沫",["风暴峭壁"] = "W0,不灬偷插插",["试炼之环"] = "W0,Bit;WZ,电极烤肉;Vv,日部落姐姐",["诺森德"] = "Wz,小手乱麽;Vf,无限正义",["戈古纳斯"] = "Wy,缉魂",["巴纳扎尔"] = "Wy,独舞",["迅捷微风"] = "Wy,硬汉小瓜皮;WZ,硬汉小明;WK,青衫夜白;Vx,绝望的鸟,谢顶的阿昆达;Vn,达瓦里氏丶",["阿曼尼"] = "Wx,佟丽娅",["伊瑟拉"] = "Wv,白小纯;WJ,小早川怜子",["玛里苟斯"] = "Wv,截剑式",["艾隆纳亚"] = "Wp,风暴使徒,东方饭店",["诺兹多姆"] = "Wn,烈影客;VV,少年出大荒",["达尔坎"] = "Wm,小王只喝可乐;Vq,阿萨德发啊",["龙骨平原"] = "Wm,丶狩猎;Wk,法课博士;Wa,番茄火柿子;VX,小手很凉",["卡德加"] = "Wk,阳光雨露;Wb,灬霓裳魅影灬;Vh,江湖传奇",["银月"] = "Wj,Iaload;Vd,风雪夜归人",["德拉诺"] = "Wj,白银之翼;Vi,幼儿园大王",["壁炉谷"] = "Wj,Eloisesilver",["玛多兰"] = "Wi,岑普罗德摩尓,泰兰徳的香蕉",["祖阿曼"] = "Wi,爱自以为是",["激流之傲"] = "Wi,阿瓦达索命",["黑翼之巢"] = "Wi,十人",["天谴之门"] = "Wi,林下之夕",["伊萨里奥斯"] = "Wi,回忆缱红颜;Vz,霹雳雷霆",["加基森"] = "Wh,丶霸氣;WZ,尛叁少,破忒头;V0,Blackadder;Vw,第二个我",["圣火神殿"] = "Wg,凤千鸾",["自由之风"] = "Wf,一抹绿茶;Ve,黑枸杞",["日落沼泽"] = "We,瓦格良;Vs,術心;Vd,眼棱瞎了眼丶",["霍格"] = "Wd,孙艺珍;WZ,Rui",["藏宝海湾"] = "Wd,一滴水的温度",["瓦里玛萨斯"] = "Wd,灬猫猫灬;V6,独孤独享",["雷霆号角"] = "Wd,Faramita",["天空之墙"] = "Wd,犀利哥丶;Vc,依楼丶听雨",["翡翠梦境"] = "Wb,三氧化二申;Vj,Pala",["永夜港"] = "Wb,朱砂",["寒冰皇冠"] = "WZ,Alstrelm;Ve,牛克蒙德",["塞纳留斯"] = "WY,Whaler;WX,川琦来梦;WV,星球陨落",["埃雷达尔"] = "WY,羡渔",["海克泰尔"] = "WX,一咚次一;WV,冬菇冬菇;Vn,傑米蘭尼斯特;Vf,林深鹿幽鸣",["幽暗沼泽"] = "WX,烮空;Vd,万嗜唔忧",["斩魔者"] = "WX,九五二八;Vk,圣光之力丿",["朵丹尼尔"] = "WX,安好勿念",["塞拉摩"] = "WW,地獄咫尺丶;WV,六欲红尘度;WA,人间有味;Vn,曾经依旧;VX,慕冬",["燃烧军团"] = "WW,白桃酒酿",["风暴之眼"] = "WV,Maraad",["熔火之心"] = "WV,五牛断魂丶",["月神殿"] = "WT,奥丽瑞娜",["太阳之井"] = "WN,欧米伽丶",["奎尔丹纳斯"] = "WL,灬木南霜",["古尔丹"] = "WH,依然戰士",["羽月"] = "WH,风刀雪剑",["艾莫莉丝"] = "WH,深海孤鸿;Vs,正太爱卖萌;Vl,性感小野猫",["红云台地"] = "WH,万有引力",["晴日峰（江苏）"] = "WF,月之左;V3,兜兜丶狠骚",["火烟之谷"] = "WE,Sici",["暮色森林"] = "WE,紅塵買醉",["安东尼达斯"] = "WD,张雨绮丶",["火焰之树"] = "WD,李灬小德",["萨尔"] = "WA,小腹黑丶",["月光林地"] = "WA,阿珞菲怒风;Vt,雪伦;Vp,花媚玉堂人;Ve,白兔软糖",["冰川之拳"] = "V9,幕後丶殘雪;Vf,寶貝卟哭",["黑暗魅影"] = "V8,能打能抗",["拉文凯斯"] = "V8,Remrem;Vg,青烟雨;Vc,小村镇的吻",["红龙军团"] = "V6,顽皮的小强",["觅心者"] = "V5,小瑾然",["艾露恩"] = "V1,弗萊婭",["麦迪文"] = "Vt,星星泡饭",["艾萨拉"] = "Vs,玄冰塞弗斯,玄冰佐佑",["克洛玛古斯"] = "Vr,来杯拉菲",["麦姆"] = "Vr,尛乄射天狼",["地狱之石"] = "Vq,江湖夜雨",["阿迦玛甘"] = "Vq,曾经的记忆",["石锤"] = "Vo,Alive",["兰娜瑟尔"] = "Vn,世界之树",["守护之剑"] = "Vn,笑书神侠;Vk,情流感",["尘风峡谷"] = "Vl,不扰清梦,醉梦独舞",["瑟莱德丝"] = "Vl,懒癌晚期凉凉",["阿克蒙德"] = "Vk,睡衣",["玛诺洛斯"] = "Vk,茉莉冰冰",["蜘蛛王国"] = "Vk,Johnnyr",["符文图腾"] = "Vj,嘟嘟",["白骨荒野"] = "Vj,永恒之夜",["凯恩血蹄"] = "Vh,美女;Vc,易拉罐;VV,丶我不奶",["深渊之喉"] = "Vh,动感光波",["图拉扬"] = "Vh,子雨山",["伊莫塔尔"] = "Vf,舒预言",["血牙魔王"] = "Vf,Mojiedjlr;Vc,七叶一枝花妖",["普瑞斯托"] = "Vf,一念丹香",["阿古斯"] = "Vf,贺豪豪",["巨龙之吼"] = "Vf,馮巩老師丶",["奥妮克希亚"] = "Ve,伽罗丶六道",["风行者"] = "Ve,蔡萌萌",["泰拉尔"] = "Ve,弋影",["安戈洛"] = "Vd,动物园牛总",["恶魔之魂"] = "Vd,破坏者血雨",["暴风祭坛"] = "Vd,Èèsp",["耐普图隆"] = "Vd,小豆先生",["世界之树"] = "Vd,死亡深度",["巫妖之王"] = "Vc,剑出烛影随",["嚎风峡湾"] = "Vc,俄里翁",["洛丹伦"] = "Vc,犇啵霸",["轻风之语"] = "Vb,天选之子",["希雷诺斯"] = "VZ,洛城时光灬",["地狱咆哮"] = "VW,呱二蛋",["格雷迈恩"] = "VW,Statet",["大地之怒"] = "VV,灬浮竹灬"};
local lastDonators = "";
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