local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,孤雨梧桐-风暴之怒,释言丶-伊森利恩,空灵道-回音山,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,不要捣乱-贫瘠之地,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯";
local recentDonators = {["末日行者"] = "GC,贰零零柒;F8,餍足;F7,小楼听風;F4,醉后祷告,醉后审判,Taissa;Fv,花与布偶猫;Fq,丨简丶单丨;Fp,名流之恋",["奥拉基尔"] = "GC,幽冥静风",["鬼雾峰"] = "GC,言兮,落下的苹果;GA,萨满陌小三;F1,Nikobelic",["巴瑟拉斯"] = "GC,大帅;F4,小忽悠姐姐;F1,牛骑;Fw,锈水财阀泰迪",["熊猫酒仙"] = "GC,雅咩跌,一偷心贼一;GB,灬惜缘灬;GA,琉璃寻;F+,姐姐幻肢好硬,姐姐幻肢好烫;F7,滋啦滋啦;F5,大春卷,熔岩王丶呱呱;F0,花兒對我笑;Fx,眼瞎的阿昆达;Fu,擒贼先擒汪;Ft,恶魔灬来临;Fs,追逐九号球;Fr,飘逸贝贝,幽梦鹊花鹃;Fp,葱拌豆花",["海加尔"] = "GC,无敌坏小子",["主宰之剑"] = "GC,影月谷的夜风;GA,戳一下;F/,Emmazz,笙歌灬;F8,踽踽独行丶,丶苞米;F3,啪啪枪;F2,丨观心丨;F1,冬瓜光环,凉心丶丶;F0,独立长亭丶,丨安之若曦,诗与逺方;Fz,禁衛軍乄布依,哺育后代,红山擀面皮;Fy,玖玥玖玥;Fx,愤怒丶的豆子;Fw,暮雨晨曦;Fv,亅大炮;Fu,壹枕黄粱;Fs,季秋,淼焱丶;Fr,張少主,蒙头睡的书虫,自闭的弱鱼;Fp,飞洋灬",["贫瘠之地"] = "GC,鹿晗娘娘;GA,布沙尔;F/,梦回唐朝,轻描丶,美丽视界;F9,馨多蕾;F8,晚风不在;F6,夢之瀾,Numpy;F5,妖小慈,圣光丶捍卫者;F3,梦璃寒烟;F1,你旳春夏秋冬;F0,知非诗,丶零度丶,圆球丶;Fz,有味清欢,Luoyidz,又土又豆,蚰蜒;Fx,抓一只小德,梦醉红尘;Fu,古友;Fs,冰封的冷漠;Fr,暖暖的回忆,隅野沙耶香,灬哆哆灬;Fq,霰丶,闇丶影,汽水糖児",["冰风岗"] = "GC,勺子丶;GB,成长快乐;F8,吉薇艾兒;F1,绝对射孨;F0,突然空闲,划拨鱼;Fz,四爷的战刃;Fy,乄麦芽糖;Fv,Rebirthdeak",["死亡之翼"] = "GC,根本丨英俊;GB,冷血小黑猫,新萌小宝;GA,奶僧宝宝,黑手丶涮熊肉;F/,深知她是梦;F+,神月灬卡琳,幸福的沙雕,酒意入桃枝;F9,小白丶快点跑;F8,野蠻妹子;F6,血灬莓,光榮與夢想丶;F3,女友全国最美;F1,白露唯霜丶,薪王的烧火棍;F0,三极头;Fz,冰蓝灬;Fx,丶凌晨㥆,屁风暴烈酒;Fw,闪闪发光滴;Ft,寸刃,第一神手;Fs,秦风细雨;Fr,逆天猪,优秀的武僧,祝掌门吐血啦,布川一夫;Fq,放牛郎丶",["斯克提斯"] = "GC,恶膜",["奥尔加隆"] = "GC,正面上我啊;GA,玛克希姆;F+,血丝朦胧,末洛艾尔;F1,紅色冲动;Fz,茹鸶;Ft,雪莉;Fs,北白",["无尽之海"] = "GC,空客,｜华佗｜;GB,丶怪怪丶;GA,迷、魂,轻舞杜啦啦;F/,糖果好甜;F6,罪渊,战且退且陶醉,牛奶谷子;F5,花儿乂朵朵;F2,我很谦虚灬;F1,红颜飞影;Fv,沐秋色,古德拜拜;Fu,焱焰;Fs,女神张钧甯;Fq,捅过蛋总一刀",["凤凰之神"] = "GC,严谨;GA,罗纳尔多丶帅;F/,丨戏子,安静的牧,安静的道,团长与狗;F8,小思信丶桃子,天肝勿燥;F6,Albisqvq;F4,芯灵儿,Minnier,起名名;F3,自戳双目,小夜猫子;F2,宁卿;F1,别问就是强,汉釜丨旖旎;F0,丶名侦探朽;Fz,杰森似坦僧,丶追风丿,哒达哒;Fy,求求你打死我,学习个屁,欢乐斗帝主;Fx,Wxh,雪怒乄;Fw,守望光明,丨巭勥丨;Fu,暴暴的硬邦邦,白芍菜心;Ft,清風丶呆贼,怕死的黑牛丶;Fs,一缕散暮愁,哦耶哦买噶;Fq,七月七夕,吴名是;Fp,和平丶",["加基森"] = "GC,蝶梦流年;GB,神术妙法;F8,矢部川绯鲤;F1,一只桃;Ft,临江暮雪",["桑德兰"] = "GC,魑魅魍魉家族;F+,虾饺丶;F6,凌云客",["天空之牆[TW]"] = "GB,可愛的魚魚",["白银之手"] = "GB,你柠檬头;GA,老腰子恶霸;F/,Tresdina,丶芯肝呦;F+,夜雨冰岚,王辰风;F7,可爱的村长,丶芯肝丶;F6,Eraymios,圣光啾啾;F5,西芫;F4,小狼肥肥;F1,冬天來了;F0,凯恩丶卡尔,葛叶,恰似童话,努力的脚男;Fz,鲜奶汁;Fy,包子吃不胖,唐卡特琳娜;Fw,王贼,春风十里丶丶;Fv,喵本熊;Ft,是曲奇饼干哟,秋秋叁佰斤;Fs,银鞍照白馬,清心的劣人;Fr,嘤嘤鱼,疯花生,灬哆哆灬,Fovdkt;Fq,小傻瓜月牙,聖米迦勒,宝强稳住",["龙骨平原"] = "GB,桃瑞丝丶;F1,Sonja;Fy,残盾丶;Fs,Dps",["熔火之心"] = "GB,新泰面条哥;GA,欧皇灬法,巅灬峰,Lintq;F0,黑驰;Fv,瑟萊德絲公主",["安苏"] = "GB,我是小犄角;F+,荒川灬;F8,最初的单纯,兄弟你在搞我;F6,七宿青龙;F5,你敢打熊猫丶;F4,秩序丶誓约者;F3,迪皮艾斯爆炸;F2,大了、,绝对占有丨;F0,Pepperziegle,半神乄赎罪;Fz,能猫人圣骑;Fy,魅影灬爱洁儿,战莽;Fu,二哈灬愤怒;Ft,莽夫丶蒋;Fr,威士乄忌;Fq,Junriver,那个水法",["朵丹尼尔"] = "GB,紫杉丶死骑;F4,婉熙清扬;Fw,冷雨叶",["影之哀伤"] = "GB,风行领域;F+,千年神伤;F9,红烧五花柚;F6,法神丶花生,黄橙澄;F5,快開嗜血;F4,被丶看穿了吗;F1,咆哮的番茄丶;F0,可小白;Fv,一念无明,咕喵王梦境;Fu,走光;Fr,燃烧卡路里丶;Fq,綽約多姿,夜若轻羽,丨竹叶青",["石爪峰"] = "GB,小熊七岁;F1,Luckydevil;Fx,黄瓜娃娃丶",["奥特兰克"] = "GA,浮云千载;F9,Blackbyebye;Fu,群主发红包;Ft,哆啦誒萌",["红龙军团"] = "GA,尐儍疍;F+,取名丶周公;F7,阿瑞凘",["大地之怒"] = "GA,从頭再来;F0,弒福",["埃德萨拉"] = "GA,海海骸盗;F7,勇猛的阿昆达,晓风满画楼;F6,Claren;F3,絔菟糖丶;F2,水晶裂痕,团长您缺德么;F1,魔兽陈奕迅,禁基的奶德;Fr,Arthasgrw",["冰霜之刃"] = "GA,萌丶火焰烈酒;F4,国服第一神猎;Fz,安德;Fw,丶陶醉乄;Fr,汗圆焚尸手",["丽丽（四川）"] = "GA,火怒风,珏宁;F9,胖迪热巴,伍贰零小超;F6,丶阿玮很懒;F2,今晚我很骚;F1,黄小胖丶,非酋空降;Fs,Saintangle",["破碎岭"] = "GA,小心元素;F0,富贵儿;Fz,小米粥丶;Fr,鹤命;Fq,迷茫的炭烧",["蜘蛛王国"] = "GA,夜雨依晨",["自由之风"] = "GA,乌瑞亚",["深渊之巢"] = "GA,Rhymes;Fy,八戒",["晴日峰（江苏）"] = "F/,涉川",["伊森利恩"] = "F/,唐柔;F9,冲钅丶吧;F8,万万也没想到,困住的野兽,一只柒柒;F6,灬鎹鐘雞灬;F4,炽血;F0,花的姿态丶;Fu,蠢蠢小粉猪;Fr,北冰洋;Fq,你耶耶突然",["格瑞姆巴托"] = "F/,花卷丶丶,风火灬侠客;F+,醉吟丶幽冥;F6,丷初乄夏丷;F5,厸丶尛焱馫;F3,圣光大萌子;F1,抠脚丶闻手,余超颖丶;F0,代理小学生;Fy,丶风林火山丶;Fw,夜里很温柔;Fv,拜舍尔鲸鸟;Fq,爱吃火龙果丶;Fp,清雨潇寒",["风暴之怒"] = "F/,浅丶",["国王之谷"] = "F/,素兮娆湄,梦看云升;F5,狂杀戮,蕊秋;F4,克里斯托公爵,Furies;F0,簌簌无落;Fy,白袍巫师呢;Fx,迪路獣;Fw,瑪雅之靈;Fv,秀冬;Fu,哇咖;Ft,气宗天下第一;Fr,太湖雪",["克尔苏加德"] = "F/,圣男;F5,三浦无垢;F4,Vagg;F1,Misic;Fy,迪蒙赫特;Fv,南巷;Ft,老夫一抬腿;Fp,荧丶惑,何曰是归年,何曰是来年",["海克泰尔"] = "F/,莫名妖灵;F8,枫桥若雨;F4,这一拳叫晚安;F1,长髮绾君心;Fx,感覺;Fr,姒妖;Fp,怕吉,小心我打你哦",["霜狼"] = "F/,第六小号;F9,救救;Fu,藤丸立香;Fr,Fayditachi",["洛萨"] = "F/,等灯等灯",["迦拉克隆"] = "F/,苏三蛋;F7,Figaro;F6,仗剑执酒天涯;F4,羞萌闪电贱;F3,星魂残影;Fw,薛定諤旳貓;Fs,Lionkk;Fr,弑神武帝",["布兰卡德"] = "F/,我不怕死;F8,云雾空,丨天线宝宝丨;F7,Deathitsme;F3,髙买;F0,定格;Fp,富贵牛牛",["壁炉谷"] = "F+,冈本零零壹;F0,Crushr",["耐奥祖"] = "F+,糯米籽",["罗宁"] = "F+,明亮双眸,Jooferic;F7,小绫叁,江了个酱,弥尔希奥蕾,哩哏啷,小鸟;F6,小尾巴浪蹄子,蒙面脱光;F5,萌瞎,丶抹茶饼干丶;F1,杰杰布鲁更,馥苼白;Fz,圣光迪妮莎,画壁;Fy,无法形容;Fq,菊花芬外香;Fp,欣喵酱,忻喵酱",["迪瑟洛克"] = "F+,Alsarser",["回音山"] = "F+,一位熊猫;F4,灬伊小伊灬;Fz,琴瑟涟漪;Fx,蠢萌小熊猫;Fq,落寂天星;Fp,風中縋楓,夏沫灬小米",["燃烧之刃"] = "F+,更位长;F8,月照雪,小餅干;F6,术爷用砖攻灬;F5,矢志无羁;F2,断灬罪之翼;F0,大丘,Gamesrevo,瞎了眼睛;Fy,丶迷醉,杀剧舞荒;Fx,次米粉;Fv,路灰灰,虚晃一枪;Fu,小封心丷;Ft,酒尽归故里;Fr,斷劍陰盜言;Fp,兔子软贝特丶",["阿古斯"] = "F+,弑杀;F9,舞月风华,一迪奥一;F5,天使勿忘;F3,风的承诺,传说冰有淚;Fz,小浣熊君丶;Fv,十八疯了;Fu,布兰妮,我是饿馍;Ft,焦糖豆包;Fs,元素圣灵;Fq,躺地板,爱晒大阳的鱼",["萨尔"] = "F+,王多鱼;F9,刀疤兔;F5,柚子滚雪球;F2,宝宝上我殿后;Fs,伊利蛋努凤",["库德兰"] = "F+,东门斩兔;F0,别来无恙",["末日祷告祭坛"] = "F+,幽幽寒冰",["黑翼之巢"] = "F+,Jasonhunter",["夏维安"] = "F+,恋小燕;Fr,肉炒电线杆丶",["???"] = "F+,加拿大丶电鳗;F5,月伤",["提瑞斯法"] = "F+,凉梦无音;Fr,零六水鱼",["伊利丹"] = "F9,陈乐一;F7,地狱治愈者",["太阳之井"] = "F9,灭覇",["暗影之月"] = "F9,萊恩;F6,单人终有一死;F3,阴影之刃;Fq,莉娅苟萨",["普罗德摩"] = "F9,桑葚;Fx,土匪妈妈",["希雷诺斯"] = "F9,爺灬杀无赦;F4,攥石王老五",["天空之墙"] = "F9,博文丶;Ft,博問丶,博闻丶",["艾萨拉"] = "F9,梦魇术术;Fp,师承冠希",["海达希亚"] = "F9,繁华如梦丶",["艾莫莉丝"] = "F9,安然我心",["毁灭之锤"] = "F9,龙泽罗拉,幽默未遂,奥恩,爱妃接旨,德莱运转,猛牛午餐奶,御封嫖愘,第九频盗,爱德华妞盖特,风骚妩媚娘,风骚看守者,血暗凋灵,特瑞丶,鬼灵猫儿,安度因风行者,天赐刀疤",["遗忘海岸"] = "F9,溜溜球了;F0,Folk;Fy,犄角大魔王",["洛丹伦"] = "F9,糖丶胖子;Fy,大魔王桐桐;Fq,戦將",["黑龙军团"] = "F8,蝈灬蝈;F0,尛卝鼻",["加里索斯"] = "F8,舒塔;Fr,橙皮酸梅",["熵魔"] = "F8,殘丶枫",["血色十字军"] = "F8,再不奶,电泵,伊伦迪尔之星;F4,斡瑞尔;F1,大领主负责帅;F0,贼灬冷酷,烧不死的柴柴;Fw,丶汐诺;Fu,盗魂;Fq,风骚喝糖水",["神圣之歌"] = "F8,櫻桃炸弾",["卡德加"] = "F8,逆风之殇",["扎拉赞恩"] = "F7,泠莺;Ft,远游",["艾露恩"] = "F7,厉凌云;Fz,Certify",["战歌"] = "F7,Elves;Fx,丫头牛牛",["莱索恩"] = "F7,纯黑;Fq,遇朮临疯",["轻风之语"] = "F7,铂爵;Fu,Tearsinrain",["迅捷微风"] = "F7,憨憨的重拳;F4,欧皇了;Fz,楓魂怒弑;Fw,神澈,尐老弓",["密林游侠"] = "F7,冰火歌",["麦维影歌"] = "F7,泡椒小花生;F0,禁猎迪皮埃斯",["布莱恩"] = "F7,九月初九",["影牙要塞"] = "F6,轩辕小阳;Fr,橘貓皇吾",["死亡熔炉"] = "F6,Megumi",["托塞德林"] = "F6,猴賽雷",["菲拉斯"] = "F6,潘多拉之梦魇;Fp,盾之朽木",["古尔丹"] = "F6,戦愺莓",["血顶"] = "F6,喇叭开花",["塞拉摩"] = "F6,焗烤兔腿;Fu,伊丽达雷;Ft,鬼刀手里干",["梦境之树"] = "F6,这波我很轻啊;Fu,明月清风;Fp,阿弹",["屠魔山谷"] = "F5,Darkritual;Fz,逝夜",["远古海滩"] = "F5,叶心安的兮兮;F0,涛少",["阿尔萨斯"] = "F5,哈妮克孜丶,阿萨赞",["盖斯"] = "F5,一笑震天",["麦迪文"] = "F5,云岚丶圣舞者",["奥妮克希亚"] = "F5,甘油三酯熊",["银松森林"] = "F5,AKari;Fw,少年蓝色经典",["瓦拉斯塔兹"] = "F4,蚕豆;Fq,Evolution",["守护之剑"] = "F4,素手芳华;Fp,风暴祭司",["凯恩血蹄"] = "F4,最后的救赎丶",["丹莫德"] = "F3,缪洁尔;Ft,游龍;Fs,焚书战神",["霜之哀伤"] = "F3,Uniterainbow;Fw,托尔贝恩",["世界之树"] = "F3,闪闪的萌德;F0,命数如织",["狂热之刃"] = "F3,吳彦诅;F2,丶囧囧有神丶",["泰兰德"] = "F3,破光之盾",["金色平原"] = "F2,波比丶光辉;F1,凤妖;F0,虚空本源;Fz,冲锋术丶卒,宝月巴,美柳千奈美,风吹雪,冷冷;Fx,忆露年丶;Fq,冰镇冰冰猫",["永恒之井"] = "F2,普罗德魔尔,孽灬尛雯;F1,为卿厮陌;Ft,烟脂酒鬼",["伊兰尼库斯"] = "F2,大鵰萌妹;Fs,Hawkeye",["风行者"] = "F2,菊笑颜开;F0,凌空逸默",["地狱之石"] = "F2,雨落涧",["羽月"] = "F1,丑得有性格;Fv,Disneymagic",["冬寒"] = "F1,Rêve",["白骨荒野"] = "F1,嗨丶你的肥皂",["翡翠梦境"] = "F1,爱豆豆,愛豆豆;F0,倚楼听风",["玛洛加尔"] = "F1,萌氏足浴会所",["芬里斯"] = "F1,灵魂放逐,安丨可",["杜隆坦"] = "F1,丨大丶白丨;Fp,灵小溪",["血牙魔王"] = "F1,聖戰騎士",["亚雷戈斯"] = "F1,翻滾白熊;Fr,狗鸭蛋;Fq,你耶耶突然",["黑铁"] = "F0,神之吕布;Fy,墨丨",["月光林地"] = "F0,丶铁浮屠,花间一瞬",["巫妖之王"] = "F0,白银之手老兵",["阿斯塔洛"] = "F0,自由之石",["瓦里玛萨斯"] = "F0,多米尼卡",["耳语海岸"] = "F0,开个嗜血",["瑞文戴尔"] = "F0,傲荼蘼",["斯坦索姆"] = "F0,缺月看将落",["达文格尔"] = "F0,灬夜之影舞",["戈古纳斯"] = "F0,Ttong,犄角小龙人",["阿曼尼"] = "Fz,婀娜灬柒爷",["冬拥湖"] = "Fz,斩他嘛的",["雷斧堡垒"] = "Fz,大小姊",["玛里苟斯"] = "Fy,冰柠雪",["雷霆之怒"] = "Fy,永夜初夏;Fv,乔宝宝丶",["能源舰"] = "Fy,张海棠",["血环"] = "Fy,Lansnot",["红龙女王"] = "Fy,曲线湾",["索拉丁"] = "Fy,云师兄",["苏塔恩"] = "Fx,以梦丶;Fq,壹灯",["拉文凯斯"] = "Fx,晚夜烛凉;Fv,兜里有圣光",["闪电之刃"] = "Fx,图噜咔咔哇",["拉贾克斯"] = "Fw,听暖",["玛法里奥"] = "Fw,阿紫",["雷霆之王"] = "Fw,柴小协真好听",["洛肯"] = "Fv,Siners",["奥杜尔"] = "Fv,美少女小猎,美少女猎手",["铜龙军团"] = "Fv,墨染青颜丶",["萨菲隆"] = "Fv,莉亞",["黑暗虚空"] = "Fv,不能叫我山鸡",["阿纳克洛斯"] = "Fv,小马兄",["甜水绿洲"] = "Fv,丶林夕丶",["激流之傲"] = "Fv,Tiann",["語風[TW]"] = "Fu,灰獭獭",["千针石林"] = "Fu,天佑盘古墓,天佑与复生,天佑和复生",["安东尼达斯"] = "Fu,不想遇见你;Fs,滴滴打滴",["黄金之路"] = "Fu,红叶知弦",["日落沼澤[TW]"] = "Fu,姓聖的騎士",["格雷迈恩"] = "Fu,慕容紫莹;Fs,Monkee",["奈法利安"] = "Ft,五更琉璃灬",["红云台地"] = "Ft,幽玄影",["灰谷"] = "Fs,梁朝伟;Fq,初宸;Fp,前所未见",["爱斯特纳"] = "Fs,愤怒的泡泡",["梅尔加尼"] = "Fs,伊森亨特",["埃苏雷格"] = "Fs,只道寻常",["试炼之环"] = "Fs,奔跑的糍饭糕",["烈焰峰"] = "Fr,小乌龟啊",["奥蕾莉亚"] = "Fr,逝去的黑风",["罗曼斯"] = "Fr,南夏奈;Fp,星白闲",["埃克索图斯"] = "Fr,灬阿猫灬",["银月"] = "Fr,神之利牙",["血吼"] = "Fq,卡卡德鲁",["安纳塞隆"] = "Fq,双马尾",["斩魔者"] = "Fq,东东丨枪,东东丶枪",["风暴峭壁"] = "Fq,有黑眼圈多好",["幽暗沼泽"] = "Fq,丶麒麟",["亡语者"] = "Fq,我以为你死了",["勇士岛"] = "Fq,奥多芙",["燃烧平原"] = "Fp,灬锯齿灬",["诺兹多姆"] = "Fp,Whitley",["万色星辰"] = "Fp,巫行云",["寒冰皇冠"] = "Fp,Reclusive",["鹰巢山"] = "Fp,九五二七"};
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