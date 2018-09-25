local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,蒋公子-死亡之翼,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔,落落萧萧-罗宁,圣子道-回音山,不嗔-迦拉克隆";
local recentDonators = {["伊利丹"] = "EQ,Deathdestiny;EP,天胡一方;EF,天月依",["回音山"] = "EQ,无用之圣骑,枭铘,捌陆丶;EP,灬周愚皇;EE,冷色葉瞳,丿落小煙",["布兰卡德"] = "EQ,复古小雷;EG,有一点晚晚,中环西门庆;EF,丶宫水三叶丶",["迦拉克隆"] = "EQ,大哈皮,萨满丿是真弱;EN,西风丿德;EL,蕙心兰质,Oathkeeper,月下影相随;EJ,鲨鱼小米辣,猫咪丶桑桑;EI,荼鸳,半根勺子,一根勺子;EH,刃之輪迴,丶醉逍遥丨,米饼阿哥;EG,小野猫丨,不摇就滚,惠心兰质,Xiaoend;EE,Darkoranger;ED,混沌女皇",["萨菲隆"] = "EQ,上浮",["海克泰尔"] = "EQ,梁辰一岁了;EO,清乄明,清明,信仰狂暴战;EL,蕾蕾吖,香香的辣条,冲锋的阿昆达,烟霞随步;EI,响罕;EH,灬毒瘤灬;EF,影帝塔里克,满满丶;ED,刘非凡",["奥特兰克"] = "EQ,Uncledebai;EP,蜜丝凡德罗;EM,大主教倚瑞尔;EK,老领主会尬舞;EJ,一只没有睫毛;EH,信仰小鲸鱼丶,夏丶紫薇;EG,那真是打扰了,信仰小鲸鱼;ED,维他命果冻",["库尔提拉斯"] = "EQ,听说你很皮噢",["死亡之翼"] = "EQ,丶淩晨;EP,贝优灬妮塔,丶斑马斑马,胡须丷;EO,妖妖的小猎,弗拉德、一世,暴躁灬爺骚;EN,赞达拉勇士,十七月寻,晟冕之风,哈库喇玛塔塔;EL,东城旧少年,Lostlife,害羞的丁丁;EK,岛田家的独苗,丶微微一笑灬,你的老爹我;EJ,Laomaoo;EI,一是无橙,泉夜;EH,西瓜皮丨;EG,灬巴依老爷灬,败家少爷,妖舞狼姬,花无念,曼莎珠华丶;EF,Brozovic,森夏的回忆,半月板儿;EE,骨板的战复踢;ED,月夏,冠希哥小迷弟,邪恶光环丶,稻香村小奶糕",["凤凰之神"] = "EQ,偶尔灬;EP,Auxohormone;EO,行云,两百斤的胖子,灬偶尔;EN,破壳阿,Demonnice;EM,愫昧平生,点炮王者;EL,退休按摩师,路边社小记者,一只小海疼丶;EK,热心市民胖虎,伊卡捷琳娜;EJ,习羽灬,传送使者;EI,阿萨德白羊;EH,姐夫你好棒,永远有多远呢;EG,黑崎丶;EF,杨世碧丶;EE,罗纳尔多赵四,舞心乄;ED,转折丨秘密,曹伱摸阿博伊",["丽丽（四川）"] = "EQ,细雨流年,妄川秋水;EO,奶残;EN,丶纳森,百牛;EK,晓尐;EI,玄觞,冷颜暖语;EH,鱼丁糸;EF,帝苍林丶",["燃烧之刃"] = "EQ,啤酒肚查理;EP,Nevercry,吉利安,㓞炎㓞;EO,亦渴赛艇;EN,戰兔,日月空,浪仔鱼;EK,林小冉;EJ,爱你;EI,我在天空飞;EG,孚光掠影,车车仔,披星挂月;EF,有眼不识海山;EE,尐丶牧師,嗳佳,刘华强;ED,",["阿斯塔洛"] = "EQ,遗忘之爱",["末日行者"] = "EQ,偷偷戳你菊花,一奇马当千;EP,弍四六柒;EO,雪花酥;EL,破曉丶;EK,方纯真丶;EF,矮大爷,韩晨羲,玛珐里奥,拳击健将,天下有雪,大靡靡",["奥杜尔"] = "EQ,零度丶",["哈卡"] = "EQ,飞扬世界",["国王之谷"] = "EQ,傻馒美奈子;EO,绕指三千丶;EM,安格尔,寂霜晨;EL,嘭嘎嘎,貝爾摩德;EK,橙十三辣;EJ,Vzj,聖殿守備官;EF,曼殊沙華;EE,大主教秦端雨,明月下西樓;ED,零柒陆叁",["格瑞姆巴托"] = "EQ,猩红之影;EP,Llidance,Rodney;EO,倾城依旧;EL,Aboriginal,萆薢分清饮;EJ,十一月的萧邦,雨夜扎马尾;EI,占戈丨十三;EH,残月酒馆馆主;EG,丶此何人哉,雨灬如剑;EE,渐稀,更泩",["生态船"] = "EP,爱吃藤椒鸡",["永恒之井"] = "EP,校长;EL,正太控丶奥兹;EI,最初的梦想;EH,柳暗花瞑;EG,天羽翼",["冰风岗"] = "EP,秋水仙;EO,许昌赵子龙;EI,夜雪;EH,Dekey,伊洛克希;EF,西楼;EE,Poiaris,你温柔的样子",["白银之手"] = "EP,我是算命的,我是草莓,壳都吓没了,半支湮;EO,维他入沃心,蓝里凪,灵魂卖给我吧;EN,爱糖的豆豆,怀念乂莫流;EM,鹅妹子嘤丶,海潮之声,芙尔图娜,周卓;EK,致远,温大仁,聖光儛步;EJ,乐思,韓先生,Maddison;EI,Toscana,团长有点萌,星铁反曲刀丶,欧皇老杨;EH,纵享地板丝滑;EG,贪玩橙月丶,这里有德,Civilux,圣堂龙烈;EF,肥肥的肉丸,灬毛毛虫,萝摩衍娜;EE,Orangemay,尺间萤火,那哖夏天,苏筱筱,黑框;ED,等待并怀希望,人间不直的,牧滚滚,单纯小耗子,苏米图,一望好多年,Silvermoonfl,很虚",["丹莫德"] = "EP,欧皇丶;EM,蹲在厕所玩鸟",["血色十字军"] = "EP,老柚子;EO,黄的一匹;EN,圣光灬将熄;EL,一树梨花,酒后少女的夢;EJ,浪正;EH,天譴領主;EG,想怼迪丽热巴,睿小新还;EF,无故犭苗,Meetorange;EE,妹迷的凯小郑;ED,太难得的记忆",["壁炉谷"] = "EP,二泉映月阿炳;EK,亚当斯旺;EH,断线楓筝",["罗宁"] = "EP,枕风宿雪,某不知名法师;EN,撸死枸碧汪;EL,凌风逐月;EK,欧洲咪;EI,瓦莉拉丶瑞亚,唐萌;EG,飘香奶茶;EF,小破团;EE,痕星",["影牙要塞"] = "EP,暗夜雖龍",["阿古斯"] = "EP,九十八号技师;EM,可怕的读条;EL,啦啦拉灬别跑;EJ,肉山大馍王",["伊莫塔尔"] = "EP,会圣光的大虾",["迅捷微风"] = "EP,有我无战火;EO,/路西斐尔;EM,Silon;EJ,糖醋很有爱;EH,希耳瓦娜斯;EF,冲锋下跪释放,胡椒火力;ED,南风识我意",["阿格拉玛"] = "EP,猥琐的红领巾;EK,番茄之刃",["???"] = "EP,掏你裆,Darkcoow;EM,虫虫,镇魂丶挽歌,噹噹小伙球,肉总;EL,乐本宝藏;EK,Gourdsnow;EG,影踪派胖啾咪",["希尔瓦娜斯"] = "EP,这是只面包君;EL,无冬夜",["塞拉摩"] = "EP,墙外等红杏丶;EN,诛天血魇,丨阿卡林;EH,兰桨;ED,晨歌光焰,午夜枪手",["阿纳克洛斯"] = "EP,Icez,布洛克斯希嘉;EK,猛逃",["戈提克"] = "EP,翻滚吧脐橙君;EJ,虎山行",["哈兰"] = "EP,卍路易斯卐,卍回锅肉卍,冯宝宝;EH,卍斯大林卍",["翡翠梦境"] = "EP,熊小邑;EN,谎言贼帅了;EH,冰影随行;EG,一只国宝;EF,盆盆叔叔;EE,狂野幽灵",["天空之墙"] = "EP,赵云;EK,忧伤的涟漪;EE,雨夜敬清秋",["洛萨"] = "EP,最後一次;EJ,晕了过去",["主宰之剑"] = "EP,六极;EO,琼霄丶御座,Yuu,背后的关怀;EL,机智的赛弗斯,弎亿少女的梦,骑士丨信仰;EJ,君生,刀锋丿之影;EH,再见罔两,邪能阿昆达,摇摆随风;EG,致命魔术乄,我骗你的;ED,九二四零三,我不爱吃鱼",["贫瘠之地"] = "EP,尐闲鱼,丷零度丷;EN,夏侯肉包;EM,白描,维她丶玄米茶;EL,灬黯丨玥灬,李儿,叮咚锵锵;EK,就想踢一下,如此嗨皮,Elunen;EJ,皮卡丘璎珞,就想怼一怼;EI,一个师的兵力,拉面儿,圣光救不了妮;EH,雅思,灬苍月灬;EG,Ajstyles,魔兽容嬷嬷,就想歇一天;EF,怀梦阿七",["熊猫酒仙"] = "EP,王大车;EK,双刀流一刀砍,天空之鬽;EH,海天岚的猪猪;EG,唯訫不易;EE,陆丷多多,Icefree,风乄语;ED,婷婷无双",["破碎岭"] = "EP,朝花乄夕拾;EL,瓦里安呜瑞恩;EJ,素昕;EG,玫瑰心殇,流璃;EF,血酬定律",["瓦里玛萨斯"] = "EP,最终幻像",["狂热之刃"] = "EP,丨丶光头强",["艾莫莉丝"] = "EP,邓毛",["风暴峭壁"] = "EP,启迪;EM,布利;EL,乳耻動人",["雷斧堡垒"] = "EO,软噗噗大冒险;EK,悲人;EH,波雅娜",["无尽之海"] = "EO,鱼语愚;EN,消逝的狂野,为爱丶鼓掌;EL,顽皮豹,黑色的眼眸;EK,Annisbear,燃烧的灵魂;EJ,十年梦醒;EI,洐澐瑬氺,贱贱顶乾坤;EH,毓婷一片就灵;EG,Ziv,忧伤斜阳,或丶许;ED,閃電",["阿克蒙德"] = "EO,听说小僧火;EM,愤怒的鹏宇",["洛肯"] = "EO,白汤",["纳克萨玛斯"] = "EO,那么大鸡排",["玛里苟斯"] = "EO,可乐糖丶;EK,傲世红尘;EJ,青柠罗勒;ED,傲笑红尘",["烈焰峰"] = "EO,这把我要收丶;EN,神奇妹妹;EJ,七七四十九;ED,蠢萌蠢萌德",["末日祷告祭坛"] = "EO,杀剧舞荒;EE,Divano",["安苏"] = "EO,仪式兰斯;EN,卒神;EM,丶大点点;EH,刺客之源,崑霅;EG,劣人的德宝宝,啃德吉;EF,路人王丶,灯影牛丸;EE,Skybluesea,傳说丨包纸;ED,壳霸霸",["菲拉斯"] = "EO,尼古叮,炼狱丶审判;EL,醉酒戏紅颜;EJ,元元",["巨龙之吼"] = "EO,浩然正汽;EM,把过去尘封;EL,Drab;EG,大饼叫兽丶",["艾维娜"] = "EO,伊慕诗;EK,Wulicoco;EG,Wulibonbon",["斯克提斯"] = "EO,饺子熟了;EG,燃烧我的艾酱",["影之哀伤"] = "EO,王卓雅;EN,李叫兽;EK,蒂姆亨特;EJ,静师太,贝优莉塔;EH,Ewxyz;EG,好热开空调吧,来自竹林深处;EF,我的爷;EE,好帥帥哦丶,不问",["卡德罗斯"] = "EO,大脸熊",["神圣之歌"] = "EN,官人我又要",["雷霆号角"] = "EN,薪尽自然凉;EG,Ms",["亚雷戈斯"] = "EN,三曰月柔一;EK,长离未离孜;EH,一生有你",["古加尔"] = "EN,奥术师塔莉萨",["伊森利恩"] = "EN,孟乔森综合症;EL,神圣化身;EK,闪耀钻石,丨噩梦丨;EJ,今晚打母老虎;EI,圈住那个九,彳亍口巴,壹坛老酒,采露;EH,夏丶斗凰;EF,写咩萌,小布丶豆;EE,落秋丶,看山丶,太阳心,大胖丶;ED,寂寞凌迟",["克尔苏加德"] = "EN,Lurke;EI,小辫子冲天;EF,今夕何夕然,依然刺刺",["甜水绿洲"] = "EN,黑皮包;EM,任君截取",["晴日峰（江苏）"] = "EN,血刀出鞘必贱;ED,尐丶崽",["鬼雾峰"] = "EN,圣怒一森;EF,小鸭;EE,輪椅鬥士;ED,花漾铃兰",["冰霜之刃"] = "EN,红焖水晶肘;EM,欧尔麦特;EJ,小乔妹;EI,伊芙蕾尔",["奈法利安"] = "EN,阿虚;ED,念念有诗",["梅尔加尼"] = "EN,Icemore;EK,朝阳热心群众;EI,安河桥;EH,冷鋒;EF,菜刀又见菜刀",["红龙军团"] = "EN,小雨啊小雨;EI,叉烧切鸡濑;EF,玛奇,三股螺旋",["萨格拉斯"] = "EN,白巧克力",["基尔加丹"] = "EN,刀鸣散华;EE,太玄",["索瑞森"] = "EN,天会亮心会暖;EG,旅店老板女儿",["太阳之井"] = "EN,青青若然;EL,丿月影;EG,江湖郎中",["千针石林"] = "EN,艾尔的诫律;EK,呼儿嘿呦;EF,Ninakidd",["达隆米尔"] = "EN,非常骨感;EE,老板娘的腿毛",["瑟莱德丝"] = "EM,冰与火的间隙;EF,Crystalmaid",["加基森"] = "EM,不再熬夜丶;EJ,千颂伊;EE,林师傅",["寒冰皇冠"] = "EM,寒蝉呜泣之时;EK,辅导员丶",["莱索恩"] = "EM,干就完事了",["芬里斯"] = "EM,筋斗云;EL,翡翠玉",["拉文凯斯"] = "EM,啥亮按啥",["黑铁"] = "EM,光光丨丨加偶;EL,看看吥懂;EK,圣光娜迦;EH,蠕動荣誉,姐控;EG,耐艹,Predatoru;EE,不胜则亡",["永夜港"] = "EM,北葵向暖",["埃德萨拉"] = "EM,高考唱山歌;EL,远在远方的风,开水煮青蛙;EJ,人猿泰山;EI,变态的阿昆达,风霂阳;EG,扛不住怎么啦,曲终红颜殁;EF,落月之后",["暗影之月"] = "EM,Always;EK,五元加我骑德;EF,暗之灬,唐小仔",["荆棘谷"] = "EM,花村游戏机",["斩魔者"] = "EM,帅的不明显",["迦顿"] = "EL,橙全",["诺莫瑞根"] = "EL,绳命如此辉煌;EH,神星星",["诺兹多姆"] = "EL,红杏",["血吼"] = "EL,豐神",["雷霆之王"] = "EL,全橙大领主",["白骨荒野"] = "EL,八连杀|小蛋",["索拉丁"] = "EL,一沐沐一",["逐日者"] = "EL,Fxl",["克洛玛古斯"] = "EL,踏雪霸天;EH,冰河葬寒心;EF,她予他梦",["血顶"] = "EL,云霆",["阿尔萨斯"] = "EL,Dyinxd,Dyin;EG,邪恶之眼,帅德丶伊比",["血环"] = "EK,队长已开枪,几百万个圣骑,似水;EF,刀锋之血,五晨之光",["图拉扬"] = "EK,天一;EJ,笑一",["加尔"] = "EK,丢你蕾姆",["山丘之王"] = "EK,净僧丶;EJ,康定小情歌",["达尔坎"] = "EK,歎息業火;ED,雲小蛋",["卡德加"] = "EK,清水羽织;ED,冰茶哟",["屠魔山谷"] = "EK,笑丶苍生",["祖阿曼"] = "EK,西湖醋鱼;EG,六一朵",["伊萨里奥斯"] = "EK,羊村的希望;EJ,天啊你真怂;EE,Xxzs",["格雷迈恩"] = "EK,喊老公;EE,玄月哀歌",["金色平原"] = "EK,野性撕扯理性;EJ,七绝弑神,黑涩星期五丶,天弃丶,Firerain;EI,药剂师格雷夫;EH,Shadowonfire;EG,路西亚啊;EF,费纳斯特",["斯坦索姆"] = "EK,伊莉妲丶怒風;EF,萨克麦迪克",["遗忘海岸"] = "EK,Byzyz",["雷霆之怒"] = "EJ,浅色丨夏末;ED,以星辰之名,Lifedream",["梦境之树"] = "EJ,死亡领主;EH,炙热;ED,萌男奶牧",["阿拉索"] = "EJ,別天神丶,荣歌;EG,古巨基",["萨尔"] = "EJ,喵孒個咪;EI,影灬随风;ED,小小慢漫悠悠",["燃烧军团"] = "EJ,苏拉萨琪玛;EF,菠萝小乔;ED,超级丨奶爸",["迦罗娜"] = "EJ,月之阴影",["海加尔"] = "EJ,虎牙萌喵",["熔火之心"] = "EJ,长风几万里;EG,山顶冻人",["莫德古德"] = "EJ,再看射死你",["奥妮克希亚"] = "EJ,源彩钏",["血之谷[TW]"] = "EJ,慕小柒",["红云台地"] = "EJ,Stranded",["摩摩尔"] = "EJ,Yolanda;EG,Vtianc",["燃烧平原"] = "EI,丿战弑灬天下",["铜龙军团"] = "EI,流年碎",["龙骨平原"] = "EI,丶迪安;EH,浅了",["蜘蛛王国"] = "EI,读条带走青春;EH,古月丶",["提瑞斯法"] = "EI,谢大力;EG,烈风的骑士姬;EF,沉沦战魂,漫天小雪",["奥达曼"] = "EI,咕噜碳",["刺骨利刃"] = "EI,小橘子大魔王",["麦姆"] = "EI,无火的余烬",["羽月"] = "EH,深白色;EG,白条肉肉;EF,活着不好吗;EE,Seafang",["奥尔加隆"] = "EH,低温耳语",["奥蕾莉亚"] = "EH,污迪尔",["巫妖之王"] = "EH,绿荳沙",["风暴之怒"] = "EH,爱你哟,在下御姐控丶;EE,黑夜零散",["藏宝海湾"] = "EH,冰河葬寒心乄",["深渊之巢"] = "EH,情灬不知所起",["鲜血熔炉"] = "EH,陈老湿;EG,Zerotwo",["熵魔"] = "EH,猫橙丶",["风行者"] = "EH,索利达尔",["泰拉尔"] = "EH,云遥丶;EG,霓裳映月",["扎拉赞恩"] = "EG,饭岛爱",["阿拉希"] = "EG,冷无月",["菲米丝"] = "EG,黑猫警长黑;EF,白衣不染尘",["红龙女王"] = "EG,微哥爱你们哟",["桑德兰"] = "EG,莫师妹",["伊瑟拉"] = "EG,浅白",["朵丹尼尔"] = "EG,总之就是壹刀",["艾森娜"] = "EG,饼干",["世界之树"] = "EG,Eenvy/娜喵酱",["深渊之喉"] = "EF,咫尺月明",["火焰之树"] = "EF,烛影斜;EE,洁妹",["库德兰"] = "EF,寂寞来了",["自由之风"] = "EF,罪剑问天谴",["黑暗虚空"] = "EF,三逗比笑呵呵",["艾苏恩"] = "EF,Doublefire",["加兹鲁维"] = "EF,Java",["日落沼泽"] = "EF,Odanobunaga;ED,美屡小玉",["古尔丹"] = "EF,Xiaojinmao",["暗影议会"] = "EE,幻舞",["泰兰德"] = "EE,动若脱兔",["血牙魔王"] = "EE,阴风阵阵",["暮色森林"] = "EE,月之舞斩断吧",["弗塞雷迦"] = "EE,灬镜远香灬",["冬泉谷"] = "EE,夜子冥",["麦迪文"] = "EE,遗忘丶阡陌",["达纳斯"] = "EE,血色冰河;ED,诗意",["试炼之环"] = "EE,好朋友;ED,林樨",["塞纳留斯"] = "EE,搬砖小霸王",["达文格尔"] = "EE,碳酸钙",["雷克萨"] = "EE,群体驱散",["石爪峰"] = "EE,丶丨法海無边",["埃克索图斯"] = "ED,鹿鸣",["玛瑟里顿"] = "ED,白眉",["阿比迪斯"] = "ED,弑疯",["罗曼斯"] = "ED,Moppa",["阿迦玛甘"] = "ED,雙鱼座"};
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
                    table.insert(players, fullname)
                    player_days[fullname] = date
                    player_shown[fullname] = topNamesOrder[fullname] or 0
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