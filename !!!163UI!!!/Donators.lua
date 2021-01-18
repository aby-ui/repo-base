local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["埃德萨拉"] = "Rt,阿尔尼娅;Rs,阿斯美,我像恶魔么;Rn,頭號丶小獵人;Rl,龍烈;Rg,箭隐鋒藏;Rf,狗头肥猫;Rd,Sufferer,Pcc",["凤凰之神"] = "Rt,杰森老师,一念倾君心;Rr,Devilboy,花椒;Rq,巨牛无比,别放,追逐时光的风;Rp,举头望冥钺,初梦灬未满;Ro,為之奈何;Rn,希洁幽儿;Rm,暖屿;Rl,諸葛村夫,哈喽小冰糕;Rk,风起苍岚,奎二爷;Ri,王豆腐,Öqs;Rg,敷衍的誓言,赤魂,仁吼義侠;Rf,善良的钢琴师,恩赐解手,毛线团子,Sho,Sorei;Re,青木枷锁;Rd,賊有钱,审判使者,御姐有三妙,执筆念殇",["塞拉摩"] = "Rt,夏末灬未至;Rq,天二儿;Rp,白涩风车;Rn,来个薯条,美琪",["亚雷戈斯"] = "Rt,丶起舞;Rj,萌萌哒柠檬",["影之哀伤"] = "Rt,笑纳;Rs,曾阿阿牛;Rr,艺术丶派大星;Rp,丨安之若兮;Ro,断牙丶;Rn,迷途小和尚,想的简单;Rm,二孃二孃;Rk,夿丶;Rj,可怕的五花肉;Ri,猥琐的神话,夜闌听雨,射的全是爱;Rh,奔雷手文太;Rg,邓潇洒,尛可心;Re,乄呆波波乄",["格瑞姆巴托"] = "Rt,野中萌好蓝;Rr,地狱的伯爵,Phantasma,遗枫;Rq,丶浮雲丶;Ro,熊猫丨熊猫,我为刀俎;Rn,丨涅墨西斯丨,颠颠;Rm,小小檬,丨抓鸭子丨;Rl,南波旺;Rk,榜一大哥丶,嗨吖;Ri,一个宝宝;Rh,小小睡着了;Rg,鶸鶸的丶暮色,平安喜樂,盗云;Rf,小神有礼了;Re,我艾希伱奶",["玛诺洛斯"] = "Rt,西西里多",["伊森利恩"] = "Rt,喷将军,得得比;Rs,毛之小子;Rq,丶雪月清;Rp,快乐的彦祖;Ro,日常又自闭;Rk,无处话凄凉;Rj,傲气冲天乄;Ri,凤凰牌电动车,大美熊;Rh,Fantasticki;Rf,尐胖纸丶;Re,丶黑鹅,壹零贰拾,拙锋,远帆;Rd,Tokio",["拉文凯斯"] = "Rt,Skyy",["布兰卡德"] = "Rt,雀喧知鹤静,时光和啤酒肚;Ro,Justgogoo;Rn,辛巴达远山;Rl,罗生门丶九晚,竦斯,不具名的演员;Rk,寂寞地根号三;Rj,Hugeforce,无言宅;Ri,碳酸不补钙;Rh,战歌灬艾力;Re,烟火丶静流年",["阿纳克洛斯"] = "Rt,丨丶博美;Ro,殺人不分左右;Rn,易相随;Rj,篮子里的果",["石爪峰"] = "Rt,王者临峰",["国王之谷"] = "Rt,你什么态度;Rs,菊子桑;Ro,黑白条纹控,沐沐凌;Rm,Eitelkeit;Ri,Rhongomyniad",["德拉诺"] = "Rt,深渊丶,蓝瞳丶",["迪托马斯"] = "Rt,绯村剑心",["死亡之翼"] = "Rt,糖门完我就滚;Rs,Hulky;Rr,顶级按摩师;Rq,疼你的姚老师,忧郁的小发,小王子的陨落;Rp,超讨喜呗,皇冠姐丶;Ro,小小板栗;Rn,Celements,爆旋丶陀螺,啊段,二月的鹰飞;Rm,萨拉托加加,重庆胖胖,转身離去;Rl,乔布衣;Rj,曉嘴乱亲,枕上留书,你五岁了吗;Ri,超级乐,Hides,紫川戟;Rh,軟軟的棉花糖,澜墨雪,猎丶人啊,自导自演;Rf,丶名侦探柯南,星河清梦;Re,血牙刀贼",["熔火之心"] = "Rt,圣翼;Rm,欧乂皇;Rg,藤井美菜",["主宰之剑"] = "Rt,Wildlord;Rs,阿茶茶;Ro,小无敌敌;Rn,謙儿叔,刘珂爱;Rk,应逆天,一只晴天啊丷;Ri,KotoriItsuka;Rg,安果;Rf,堕落的小角,獸教父;Re,单行道",["洛丹伦"] = "Rs,非洲来的高手;Rk,圣疗加不满,丶冯宝宝;Rh,永生",["达基萨斯"] = "Rs,Virgosharja;Rl,蒸汽引擎",["回音山"] = "Rs,树下幽影,烽崝;Rr,丨烙印",["霜之哀伤"] = "Rs,公主的小黑猪;Rr,中野一花丶;Rg,夜翼迪克,兽栏管里员",["冰霜之刃"] = "Rs,兽帝丶;Rf,王不留狗",["白银之手"] = "Rs,这逼王炸,我不是料神,吸魂邪能沙鲁;Rr,八零后的熊猫;Rq,电视聚;Rp,钉钉来了,静夜入梦,丶大聰明丶;Ro,凉风有夜,漂亮的大蚂蚱,丿餛飩丶,蓝蓝的蓝郁,雪中悍刀熊;Rn,Dnndh,千城丶墨白;Rm,错过的风景啊;Rl,这是女鬼,坚强的西红柿,犹大的烟,猫牧;Ri,凤舞乱发;Rh,荒野残羽,杰佛里斯,愿拆曲成诗;Rg,荒野羽羿;Re,月殇梦忆;Rd,逆流乄曼荼罗,法蕾拉",["雷霆之王"] = "Rs,曠古幽蘭;Rd,深谷幽蘭",["海克泰尔"] = "Rs,明明头;Ro,猩红乀;Rn,吟风丶颂唱者;Rm,魔力印记;Rk,佐右;Rg,新鲜韭浪两块",["罗宁"] = "Rs,雪染江山如画;Rq,大殿香烛,逐月清风;Rp,葬心,眼泪也成時;Ro,花飘白鹿涧,Nori,神偷睿睿;Rm,绿三角;Rk,鱼戏莲叶间;Rj,不可言喻的懒,懒神仙,盖世无双;Rh,Oraange,东风洲际导弹;Rg,宫水三葉;Rf,丨夜白灬;Re,侠菩提,梵刹迦蓝;Rd,阿萬音鈴羽",["???"] = "Rs,沐橙;Rr,游胜,熊熊的蛋刀;Rn,艾尔娜星光;Rm,天卿丶,酷酷滴小男人;Rl,白月魁",["安苏"] = "Rr,初七宝,欧弗;Rn,善战乄红尘,小星心;Rm,Arianagrande;Rl,萌奶狗;Rk,一下就好喇;Rh,贫僧颜值担当;Rf,骨头没有肉;Re,浊酒念红尘丶,请叫我烹鱼宴;Rd,爽大乳",["鹰巢山"] = "Rr,亲亲小乖;Rm,云少殇",["永恒之井"] = "Rr,菲莉妮;Rg,一只小飞狗",["神圣之歌"] = "Rr,星空蓝莓;Rn,狐男;Rj,恭禧发財,绿茶;Rg,半醒",["末日行者"] = "Rr,熊萌狮咬;Rq,阿尔塞斯,琉沢;Ro,下岗了没饭吃;Rn,诺贼拉风;Rf,Simha;Re,哈哈坏天气;Rd,豆豆勇士,Zetacola",["贫瘠之地"] = "Rr,我咬人可疼了;Rq,卿似无心人;Rp,后會无期,阿澈;Rn,熊数喵;Rm,王风暴假酒;Rk,盾萌萌;Rj,罗克里安音阶;Ri,山河予你;Rg,五更千里梦,死就对了;Rf,你又胖了;Re,Radomss,丽萨丶",["无尽之海"] = "Rr,孙丧志;Ro,Tiky;Rn,污喵之王;Rk,旧爱丶;Ri,超级咕咕,阿咸;Re,再瞅下试试",["巴瑟拉斯"] = "Rr,Chaosneutral",["冰风岗"] = "Rq,冷血先生,冷血先森;Rp,伯尼龙根之歌;Ro,二百零八斤;Rn,飞雁;Rk,凡尔赛文学家;Rj,清雾扰山河;Ri,岚夏丶,驴帅尧;Rh,Payson;Rf,六星霜,Sastabber,顶缸",["翡翠梦境"] = "Rq,泰凯斯芬利;Rp,春风不相识;Rn,巫訞王;Rd,白鸾",["金色平原"] = "Rq,艾尔娜星光;Ro,蜜丝拉;Rj,十六夜娜娜,桃乐丝丶晨翼;Rg,王大蛮",["黑铁"] = "Rq,Contessa,一程山水歌;Ro,老板来碗凉面;Rg,可爱的李老师;Rf,不要不妖的",["破碎岭"] = "Rq,珍尼佛;Ri,與你無关;Re,Bingk",["燃烧之刃"] = "Rq,旅行家丶;Rp,小兔子南瓜,王先生有块地,情言周;Ro,包子无所畏惧,果皮果肉果核;Rn,Linsong;Rm,暗影狂奔;Rl,Titanfor,Shrrek;Rk,赵灬樱空;Ri,丨苏泠玥丨;Re,狂徒练习生",["丽丽（四川）"] = "Rq,笙亦何欢;Rl,艾菲尔铁蛋,是昔流芳丶,田书宇女朋友;Rk,萨拉雷霆;Rf,灬柒爺丶",["玛多兰"] = "Rq,画扇浅醉",["熊猫酒仙"] = "Rq,骚一男;Rm,神岚;Rh,真银骑士,空虚婧灵;Rf,周大佬爺;Re,儿时语,瞬间焰火",["铜龙军团"] = "Rq,王沐沐",["血色十字军"] = "Rp,裴老湿,董老湿,大筒木灬辉夜,糖醋二锅头;Ro,变狼,熙光丶,槑賊;Rm,喵个球阿;Rk,李砚;Ri,威利鱼鱼旺卡;Rh,光能心潮,小被子丶,亡者祝福;Rg,无故挽歌,夏了个夏天;Rf,猫不二;Re,鯊鱼丶;Rd,全体丨起立",["暗影之月"] = "Rp,丶鬼拳;Ro,Csy;Rg,二郎显聖;Rd,怒风乄之魂",["伊利丹"] = "Rp,恨醉姑娘;Rn,Sxy",["纳沙塔尔"] = "Rp,装逼第二名;Re,喝奶",["玛里苟斯"] = "Rp,晨曦蕾欧娜",["阿古斯"] = "Rp,范閑;Ro,兜兜大领主;Rl,咕噜咕噜冒泡;Rj,風的叹息;Ri,伊曈;Re,幸福丿小昊冉",["希雷诺斯"] = "Rp,干挠之死磕",["洛萨"] = "Rp,???",["雷斧堡垒"] = "Rp,萌萌噠喲;Rh,Lovered",["菲拉斯"] = "Ro,幸运",["龙骨平原"] = "Ro,忽悠王之怒",["迦拉克隆"] = "Ro,龙九灬;Rl,口空空;Rh,还有亡法嘛;Re,梦里花萝;Rd,冲锋丶斩杀",["勇士岛"] = "Rn,微风拂尘",["丹莫德"] = "Rn,圣光护佑着你",["恶魔之魂"] = "Rm,Foredawn",["索瑞森"] = "Rm,惊觉;Ri,Oministero",["奥尔加隆"] = "Rm,玲珑;Rd,Bwonsamdi",["布鲁塔卢斯"] = "Rm,小蠻腰;Ri,Crazyhunterm",["奥特兰克"] = "Rm,欧泥桑;Rk,大王叫来巡山;Rd,闰土之裤",["天空之墙"] = "Rl,丶病娇的萝莉;Rj,Njmpl",["巫妖之王"] = "Rl,厮守灬聼雨;Rk,帝國戰歌",["尘风峡谷"] = "Rl,雲中锦書",["古尔丹"] = "Rl,石佛;Rd,冰冻废土之力",["耳语海岸"] = "Rl,邪能在燃烧",["试炼之环"] = "Rl,月下丶独舞",["克尔苏加德"] = "Rl,枫之叶飘灬;Rj,翻滚吧绵羊君;Ri,夜话白露;Re,野狐禅",["鬼雾峰"] = "Rl,儒雅死骑",["诺兹多姆"] = "Rk,皎月织夜景;Rj,鲸楼",["巨龙之吼"] = "Rk,星爵",["希尔瓦娜斯"] = "Rk,阿里拉丶道森",["红龙女王"] = "Rk,人狠話不多",["海加尔"] = "Rk,北京大耳帖子",["守护之剑"] = "Rk,别鬧",["山丘之王"] = "Rk,内酷你看不到",["月光林地"] = "Rj,弱鸡法;Rg,你的小虎哥",["艾露恩"] = "Rj,阿普唑仑",["奥斯里安"] = "Rj,将由",["阿尔萨斯"] = "Rj,噬碎死牙之兽;Re,Machupicchu",["洛肯"] = "Rj,Hgxs",["加基森"] = "Ri,曰过范冰冰",["狂热之刃"] = "Ri,电放锅",["提瑞斯法"] = "Ri,暴走的裤衩",["伊萨里奥斯"] = "Ri,射姑龙女",["蜘蛛王国"] = "Rh,愛小丹",["血牙魔王"] = "Rg,晨熙爸爸",["伊瑟拉"] = "Rg,怒放的雪",["埃苏雷格"] = "Rg,Lovoom",["夏维安"] = "Rg,温酒丷叙余生,月落丷霜满天",["黑暗魅影"] = "Rf,妩妖王",["卡德加"] = "Rf,烽火的箭矢",["风暴之鳞"] = "Rf,心淡若水",["世界之树"] = "Rf,微笑的蒂妮莎",["白骨荒野"] = "Rf,天煞",["血吼"] = "Rf,长大后更帅",["战歌"] = "Rf,则竹裕之",["麦迪文"] = "Rf,雪冰凌",["红龙军团"] = "Re,二十个我",["斯坦索姆"] = "Re,圣魔饭饭",["诺莫瑞根"] = "Re,紫露冰凝",["迅捷微风"] = "Re,寂寞续杯;Rd,壹头好牛牛",["玛瑟里顿"] = "Re,陨落的星辰",["燃烧军团"] = "Re,不存在的情人",["梅尔加尼"] = "Rd,赫尔海姆的羊",["耐奥祖"] = "Rd,王一博,莲藕炖排骨",["黑石尖塔"] = "Rd,夕阳下的梦魇",["克洛玛古斯"] = "Rd,堕灬世丨知梦",["泰拉尔"] = "Rd,夜丶风",["黑锋哨站"] = "Rd,冲锋遇到树,玩不来法爷"};
local lastDonators = "情言周-燃烧之刃,眼泪也成時-罗宁,皇冠姐丶-死亡之翼,阿澈-贫瘠之地,后會无期-贫瘠之地,糖醋二锅头-血色十字军,丨安之若兮-影之哀伤,萌萌噠喲-雷斧堡垒,???-洛萨,丶大聰明丶-白银之手,超讨喜呗-死亡之翼,静夜入梦-白银之手,初梦灬未满-凤凰之神,王先生有块地-燃烧之刃,白涩风车-塞拉摩,葬心-罗宁,干挠之死磕-希雷诺斯,范閑-阿古斯,大筒木灬辉夜-血色十字军,春风不相识-翡翠梦境,晨曦蕾欧娜-玛里苟斯,装逼第二名-纳沙塔尔,举头望冥钺-凤凰之神,恨醉姑娘-伊利丹,快乐的彦祖-伊森利恩,小兔子南瓜-燃烧之刃,丶鬼拳-暗影之月,伯尼龙根之歌-冰风岗,钉钉来了-白银之手,董老湿-血色十字军,裴老湿-血色十字军,小王子的陨落-死亡之翼,王沐沐-铜龙军团,天二儿-塞拉摩,丶浮雲丶-格瑞姆巴托,骚一男-熊猫酒仙,画扇浅醉-玛多兰,笙亦何欢-丽丽（四川）,忧郁的小发-死亡之翼,逐月清风-罗宁,一程山水歌-黑铁,大殿香烛-罗宁,旅行家丶-燃烧之刃,珍尼佛-破碎岭,丶雪月清-伊森利恩,追逐时光的风-凤凰之神,电视聚-白银之手,别放-凤凰之神,琉沢-末日行者,Contessa-黑铁,艾尔娜星光-金色平原,泰凯斯芬利-翡翠梦境,疼你的姚老师-死亡之翼,卿似无心人-贫瘠之地,阿尔塞斯-末日行者,冷血先森-冰风岗,冷血先生-冰风岗,巨牛无比-凤凰之神,熊熊的蛋刀-???,丨烙印-回音山,Chaosneutral-巴瑟拉斯,孙丧志-无尽之海,遗枫-格瑞姆巴托,八零后的熊猫-白银之手,中野一花丶-霜之哀伤,顶级按摩师-死亡之翼,花椒-凤凰之神,我咬人可疼了-贫瘠之地,熊萌狮咬-末日行者,Phantasma-格瑞姆巴托,欧弗-安苏,游胜-???,艺术丶派大星-影之哀伤,Devilboy-凤凰之神,星空蓝莓-神圣之歌,菲莉妮-永恒之井,亲亲小乖-鹰巢山,地狱的伯爵-格瑞姆巴托,初七宝-安苏,吸魂邪能沙鲁-白银之手,我不是料神-白银之手,沐橙-???,我像恶魔么-埃德萨拉,毛之小子-伊森利恩,雪染江山如画-罗宁,菊子桑-国王之谷,明明头-海克泰尔,曾阿阿牛-影之哀伤,曠古幽蘭-雷霆之王,烽崝-回音山,这逼王炸-白银之手,兽帝丶-冰霜之刃,Hulky-死亡之翼,公主的小黑猪-霜之哀伤,树下幽影-回音山,阿斯美-埃德萨拉,Virgosharja-达基萨斯,非洲来的高手-洛丹伦,阿茶茶-主宰之剑,一念倾君心-凤凰之神,时光和啤酒肚-布兰卡德,Wildlord-主宰之剑,圣翼-熔火之心,糖门完我就滚-死亡之翼,绯村剑心-迪托马斯,蓝瞳丶-德拉诺,深渊丶-德拉诺,你什么态度-国王之谷,王者临峰-石爪峰,丨丶博美-阿纳克洛斯,雀喧知鹤静-布兰卡德,得得比-伊森利恩,Skyy-拉文凯斯,喷将军-伊森利恩,西西里多-玛诺洛斯,野中萌好蓝-格瑞姆巴托,笑纳-影之哀伤,丶起舞-亚雷戈斯,夏末灬未至-塞拉摩,杰森老师-凤凰之神,阿尔尼娅-埃德萨拉";
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