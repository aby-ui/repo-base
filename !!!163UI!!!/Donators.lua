local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["凤凰之神"] = "R/,好热开空调吧,秋沫丶,凡尔赛丶;R+,夜楼;R9,丶为所欲为丶;R8,黯然神殤,长承;R7,枸杞盖饭;R6,英古莉特,伊利达柒丶;R4,银铃花;R3,Axelalmar;R2,斗战胜佛祖;R1,殺人不分左右,Deni,地藏;Rz,数学考七分;Ry,狂怒战,毛咪咪二代;Ru,妹丶倾国倾城,浩荡若流波,丷阿宝丷,熊二萌;Rt,杰森老师,一念倾君心;Rr,Devilboy,花椒;Rq,巨牛无比,别放,追逐时光的风;Rp,举头望冥钺,初梦灬未满;Ro,為之奈何;Rn,希洁幽儿;Rm,暖屿;Rl,諸葛村夫,哈喽小冰糕;Rk,风起苍岚,奎二爷;Ri,王豆腐,Öqs;Rg,敷衍的誓言,赤魂,仁吼義侠;Rf,善良的钢琴师,恩赐解手,毛线团子,Sho,Sorei;Re,青木枷锁;Rd,賊有钱,审判使者,御姐有三妙,执筆念殇",["血色十字军"] = "R/,走走道丶撞;R+,挽梦依入怀,花潆滢,帝姆罗斯;R9,小红手晚雪;R8,无駄;R4,风暖暖月溶溶;R0,九江市中小华;Rz,Elevation;Ry,养樂多丶,可乐去冰;Rw,Trainer;Rv,漫天都是咕,油炸咕咕串;Ru,修罗王伊平;Rp,裴老湿,董老湿,大筒木灬辉夜,糖醋二锅头;Ro,变狼,熙光丶,槑賊;Rm,喵个球阿;Rk,李砚;Ri,威利鱼鱼旺卡;Rh,光能心潮,小被子丶,亡者祝福;Rg,无故挽歌,夏了个夏天;Rf,猫不二;Re,鯊鱼丶;Rd,全体丨起立",["死亡之翼"] = "R/,湖人牛,Madneess,Doolly,奈斯凸迷球;R9,二段媒介,轉身離去,正经小德,独醉丨;R7,剑天下;R5,超膘;R4,宁静在沸腾,该用戶已成仙;R1,皇家卫士统领;R0,療傷燒肉粽,丿三月,三月乁,浪味小仙,菜糕;Rz,茉莉泪;Ry,迷逸;Rx,降妞十八吻,做舞女的悲哀;Rw,就讓這首歌丶;Rv,这一剑名温柔;Ru,逆天灬浅紫色;Rt,糖门完我就滚;Rs,Hulky;Rr,顶级按摩师;Rq,疼你的姚老师,忧郁的小发,小王子的陨落;Rp,超讨喜呗,皇冠姐丶;Ro,小小板栗;Rn,Celements,爆旋丶陀螺,啊段,二月的鹰飞;Rm,萨拉托加加,重庆胖胖,转身離去;Rl,乔布衣;Rj,曉嘴乱亲,枕上留书,你五岁了吗;Ri,超级乐,Hides,紫川戟;Rh,軟軟的棉花糖,澜墨雪,猎丶人啊,自导自演;Rf,丶名侦探柯南,星河清梦;Re,血牙刀贼",["???"] = "R/,丶叁拾壹;R+,Lupinn,果儿牧师;R6,火锅贝贝;R5,阿呆啊法;R2,零点玖丶,陛下星星",["奥特兰克"] = "R/,大都督吕蒙;Rm,欧泥桑;Rk,大王叫来巡山;Rd,闰土之裤",["麦姆"] = "R/,腰纏萬貫;R3,烟斗客",["守护之剑"] = "R/,丨老妖丨;Rk,别鬧",["格瑞姆巴托"] = "R/,试管毁灭者;R+,猫无艳;R5,朱宬韵,Eclapsee;R2,丨羊成猪丨;R1,喵咩哞,终点叫嗜血;Rt,野中萌好蓝;Rr,地狱的伯爵,Phantasma,遗枫;Rq,丶浮雲丶;Ro,熊猫丨熊猫,我为刀俎;Rn,丨涅墨西斯丨,颠颠;Rm,小小檬,丨抓鸭子丨;Rl,南波旺;Rk,榜一大哥丶,嗨吖;Ri,一个宝宝;Rh,小小睡着了;Rg,鶸鶸的丶暮色,平安喜樂,盗云;Rf,小神有礼了;Re,我艾希伱奶",["伊森利恩"] = "R/,依莉雅斯菲爾;R9,大帅哥楚香香;R8,喜遇猫;R7,黄瓜战将;R5,太猛;R3,Lights;R0,摇曳丷;Rz,大帅哥楚留香;Rx,Desi;Rv,迷惘的夜,半斤砒双,踏梦者温瑟拉,丨紥丨,Residue;Rt,喷将军,得得比;Rs,毛之小子;Rq,丶雪月清;Rp,快乐的彦祖;Ro,日常又自闭;Rk,无处话凄凉;Rj,傲气冲天乄;Ri,凤凰牌电动车,大美熊;Rh,Fantasticki;Rf,尐胖纸丶;Re,丶黑鹅,壹零贰拾,拙锋,远帆;Rd,Tokio",["金色平原"] = "R/,千瓷;Rq,艾尔娜星光;Ro,蜜丝拉;Rj,十六夜娜娜,桃乐丝丶晨翼;Rg,王大蛮",["燃烧之刃"] = "R/,汤姆布利柏丶,叮叮车丶;R9,随梦忆潇湘;R8,一颗尛虎牙;R4,老白哈,老白啊;R3,莫小贝;R0,不讲鹉德;Ry,小孬猪,根本丨英俊;Rx,麻婆血豆腐;Rw,故人归;Ru,忄奈欧天;Rq,旅行家丶;Rp,小兔子南瓜,王先生有块地,情言周;Ro,包子无所畏惧,果皮果肉果核;Rn,Linsong;Rm,暗影狂奔;Rl,Titanfor,Shrrek;Rk,赵灬樱空;Ri,丨苏泠玥丨;Re,狂徒练习生",["影之哀伤"] = "R/,无心丶狩风;R+,如鹿归林丶,冬瓜茶小妹妹;R6,殘虹,怕不是憨憨吧,天涯温热;R5,葉洛萌尘,蓝訫;R2,肤白貌羙;R1,黑桃訫,可口可乐儿,雨点宝宝;Rz,无锋;Ry,劍流雲;Rx,简单酱;Rv,糖霜蔷薇猫,丶红炎;Ru,Zifei,大野圆子;Rt,笑纳;Rs,曾阿阿牛;Rr,艺术丶派大星;Rp,丨安之若兮;Ro,断牙丶;Rn,想的简单;Rm,二孃二孃;Rk,夿丶;Rj,可怕的五花肉;Ri,猥琐的神话,夜闌听雨,射的全是爱;Rh,奔雷手文太;Rg,邓潇洒,尛可心;Re,乄呆波波乄",["戈提克"] = "R/,乌米饭打泡泡",["主宰之剑"] = "R/,小土堆儿;R8,划水的鱼;R4,夏天的油条,Yyaires,墨纹山;R3,夜尽丶晨羲;Rz,狂帝;Rx,带血的叶子;Rt,Wildlord;Rs,阿茶茶;Ro,小无敌敌;Rn,刘珂爱;Rk,应逆天,一只晴天啊丷;Ri,KotoriItsuka;Rg,安果;Rf,堕落的小角,獸教父;Re,单行道",["山丘之王"] = "R/,欢迎您的光临;Rk,内酷你看不到",["白银之手"] = "R/,田心爸爸;R+,战将白起,重庆胖胖;R9,小呈呈;R8,光月时,African,祝你恭喜发财,吾爱乔文;R5,错过的风景啊;R4,讨厌鸡蛋饼,油光水润;R2,凨寻丶;R1,超小夜;R0,Djokawari,吴焰祖;Ry,思想品德老师;Rx,Moneymmax,丶大漂亮丶,巴爾扎克,结诚梨斗;Rw,瞬间战,部落骑士;Rv,袍泽丶尼玛,美味鱼丸子;Ru,郑爽的好大儿,清丰笑浮云,憨憨的信仰,德犸徙娅;Rs,这逼王炸,我不是料神,吸魂邪能沙鲁;Rr,八零后的熊猫;Rq,电视聚;Rp,钉钉来了,静夜入梦,丶大聰明丶;Ro,凉风有夜,漂亮的大蚂蚱,丿餛飩丶,蓝蓝的蓝郁,雪中悍刀熊;Rn,Dnndh,千城丶墨白;Rl,这是女鬼,坚强的西红柿,犹大的烟,猫牧;Ri,凤舞乱发;Rh,荒野残羽,杰佛里斯,愿拆曲成诗;Rg,荒野羽羿;Re,月殇梦忆;Rd,逆流乄曼荼罗,法蕾拉",["巨龙之吼"] = "R/,荣耀丶幻刺,荣耀丶蛋挞;Rk,星爵",["耳语海岸"] = "R+,零度领域;Rl,邪能在燃烧",["艾露恩"] = "R+,深田咏美,神波多壹花,嘢零;Rj,阿普唑仑",["贫瘠之地"] = "R+,惊魂的小发丝,疯狂的骨头;R9,这是个幻觉,轉身淚流;R8,锄丿灬禾;R3,善道丨拾三;R0,震天穿云箭,禁忌猎魔人;Rz,头上的包,北苍霜月,闲庭信步丶;Ry,喲灬哚啦;Rw,醉梦独舞;Ru,纵享丝滑;Rt,Wirepuller;Rr,我咬人可疼了;Rq,卿似无心人;Rp,后會无期,阿澈;Rn,熊数喵;Rm,王风暴假酒;Rk,盾萌萌;Rj,罗克里安音阶;Ri,山河予你;Rg,五更千里梦,死就对了;Rf,你又胖了;Re,Radomss,丽萨丶",["罗宁"] = "R+,丿霜花店,星野瑛斗;R9,普天元独步;R5,恐怖的国猪,黑小个;R3,橙孑酱,泰安诺之殇,浮生泡影;R1,Judelee,Samanth;R0,牧之原駅前猫;Ry,暗影之屹;Rx,大腿带我飞,意气;Rw,霜华幽梦;Rv,只见月光,一月半月半一;Ru,爱吃喜多多,圣光潇潇静;Rs,雪染江山如画;Rq,大殿香烛,逐月清风;Rp,葬心,眼泪也成時;Ro,花飘白鹿涧,Nori,神偷睿睿;Rm,绿三角;Rk,鱼戏莲叶间;Rj,不可言喻的懒,懒神仙,盖世无双;Rh,Oraange,东风洲际导弹;Rg,宫水三葉;Rf,丨夜白灬;Re,侠菩提,梵刹迦蓝;Rd,阿萬音鈴羽",["梅尔加尼"] = "R+,贾老师;Rd,赫尔海姆的羊",["黑暗虚空"] = "R+,路易德",["末日行者"] = "R+,道丶无妄;R4,童颜;Rx,阿尔塞斯,寒燃,风雪话孤城;Rv,娱丶卟棄;Rr,熊萌狮咬;Rq,琉沢;Rn,诺贼拉风;Rf,Simha;Re,哈哈坏天气;Rd,豆豆勇士,Zetacola",["铜龙军团"] = "R+,小年吉祥;R5,长腿欧巴;Rq,王沐沐",["布兰卡德"] = "R+,幼稚园殺手丶;R9,挥剑斩桃花;R4,顶缸;Ru,Cell;Rt,雀喧知鹤静,时光和啤酒肚;Ro,Justgogoo;Rn,辛巴达远山;Rl,罗生门丶九晚,竦斯,不具名的演员;Rk,寂寞地根号三;Rj,Hugeforce,无言宅;Ri,碳酸不补钙;Rh,战歌灬艾力;Re,烟火丶静流年",["冰风岗"] = "R9,罗宾悍;R3,烈焰丶牛;R0,真不戳丶;Rz,批小将;Rw,啊不懂叫什么;Ru,乌波萨斯拉,青花绫;Rq,冷血先生,冷血先森;Rp,伯尼龙根之歌;Ro,二百零八斤;Rn,飞雁;Rk,凡尔赛文学家;Rj,清雾扰山河;Ri,岚夏丶,驴帅尧;Rh,Payson;Rf,六星霜,Sastabber",["安苏"] = "R9,壳壳超爱玩;R7,甘蔗丶,黑檀丶;R6,盗亦哊盗罒;R5,小人鱼;R2,野生巨馍;R1,Playerdkoyan,老師父;R0,逐梦灬影;Rz,圊花,咘咘的可爱;Rw,白辞;Rv,部落来的小德;Ru,公主的保镖;Rr,初七宝,欧弗;Rn,善战乄红尘,小星心;Rm,Arianagrande;Rl,萌奶狗;Rk,一下就好喇;Rh,贫僧颜值担当;Rf,骨头没有肉;Re,浊酒念红尘丶,请叫我烹鱼宴;Rd,爽大乳",["迅捷微风"] = "R9,导演我洗好了,猫咪安妮;R6,曉丶番茄;R5,萦星;R3,杠上花关三家;R1,早春一树;Ry,时命;Rv,黑牛豆奶;Re,寂寞续杯;Rd,壹头好牛牛",["月光林地"] = "R9,炼狱梦儿;Rj,弱鸡法;Rg,你的小虎哥",["鬼雾峰"] = "R9,突然瘋了,放开小白兔;Rz,临海当歌;Ry,爱蛆菌;Rw,以德雷人;Rl,儒雅死骑",["熊猫酒仙"] = "R9,耗子尾汥;R7,丿小情書丶,安静的雪糕;Rz,筱阿橘;Ry,封林琬;Rw,后羿是只喵;Rq,骚一男;Rm,神岚;Rh,真银骑士,空虚婧灵;Rf,周大佬爺;Re,儿时语,瞬间焰火",["无尽之海"] = "R9,圣光与莉莉安;R8,法之神;R6,圣光公爵;R2,乄风;R1,张三丶;R0,山东小跳蛙;Rz,Sebrina,丨曦和丨,梦幻千月;Rr,孙丧志;Ro,Tiky;Rn,污喵之王;Rk,旧爱丶;Ri,超级咕咕,阿咸;Re,再瞅下试试",["加基森"] = "R9,惊情四百年;Ri,曰过范冰冰",["迦拉克隆"] = "R9,严肃的长颈鹿;Ro,龙九灬;Rl,口空空;Rh,还有亡法嘛;Re,梦里花萝;Rd,冲锋丶斩杀",["国王之谷"] = "R9,同福客栈湘玉;R7,苍白灬凉月;R6,佑枫战刃,江隂丨馒頭;R2,那年春天丶,長泽雅美丶;R0,闲的蛋不疼;Rx,半称心;Rt,你什么态度;Rs,菊子桑;Ro,黑白条纹控,沐沐凌;Rm,Eitelkeit;Ri,Rhongomyniad",["风暴之眼"] = "R8,山有扶苏;R5,绿叶多红花少",["奥拉基尔"] = "R8,叶吟霜,库库林白夜",["寒冰皇冠"] = "R8,苍龙占甲",["克尔苏加德"] = "R8,鬼顔;Ry,原来是欧皇呀;Rl,枫之叶飘灬;Rj,翻滚吧绵羊君;Ri,夜话白露;Re,野狐禅",["诺兹多姆"] = "R7,月亮上的等待;Rk,皎月织夜景;Rj,鲸楼",["普罗德摩"] = "R7,武汉欢欢",["洛丹伦"] = "R7,风暴丶打击;R6,松井菠萝包;Rs,非洲来的高手;Rk,圣疗加不满,丶冯宝宝;Rh,永生",["狂热之刃"] = "R6,宸星漫天丶;Ry,浊酒恋红尘;Ri,电放锅",["哈卡"] = "R6,小狐狸人儿;Rw,我媳妇最漂亮",["黑龙军团"] = "R6,Lelouch",["加里索斯"] = "R6,青山与木",["血环"] = "R6,Neeoo",["暗影之月"] = "R6,就是死扛到底;Rw,惔看九重天;Rv,糖麦麦;Rp,丶鬼拳;Ro,Csy;Rg,二郎显聖;Rd,怒风乄之魂",["阿古斯"] = "R5,明天大雪;Ry,舜舜,维他柠萌茶丶;Rx,余生了了丶;Rp,范閑;Ro,兜兜大领主;Rl,咕噜咕噜冒泡;Rj,風的叹息;Ri,伊曈;Re,幸福丿小昊冉",["埃德萨拉"] = "R5,小小大梦想;R2,给老子站到;R1,米老狗;R0,Mario;Rz,狗头萨;Rw,战殇;Rv,野牛不识归途;Rt,阿尔尼娅;Rs,阿斯美,我像恶魔么;Rn,頭號丶小獵人;Rl,龍烈;Rg,箭隐鋒藏;Rf,狗头肥猫;Rd,Sufferer,Pcc",["万色星辰"] = "R5,Manolo,安珀罗斯;Ry,光誓者菲娅",["泰拉尔"] = "R5,丨小胖子丨;Rd,夜丶风",["风暴之怒"] = "R4,青玉大剑仙;R0,锋芒丶丿",["海克泰尔"] = "R4,阿砸的灵魂兽;R2,黑子武蛋,坑坑家的老张;R0,必兮相语丶;Rx,灬歮淼焱犇灬;Ru,秋秋真的最美;Rs,明明头;Ro,猩红乀;Rn,吟风丶颂唱者;Rm,魔力印记;Rk,佐右;Rg,新鲜韭浪两块",["亚雷戈斯"] = "R4,明珠玄象;Rt,丶起舞;Rj,萌萌哒柠檬",["黑暗之矛"] = "R3,战役",["安纳塞隆"] = "R3,小浓瞎",["暗影迷宫"] = "R3,青灯客",["玛多兰"] = "R2,贝露贝特;Rq,画扇浅醉",["阿拉希"] = "R2,七色蔷薇",["埃克索图斯"] = "R2,在下跑得快",["洛肯"] = "R2,大米炮;Rj,Hgxs",["丹莫德"] = "R2,若无花;Rn,圣光护佑着你",["能源舰"] = "R2,巽风",["轻风之语"] = "R2,蝶舞天崖",["卡德加"] = "R2,雷诺,雷锋;Rf,烽火的箭矢",["银月"] = "R2,丶蛐蛐丶;Ru,坏蛋的戒指丶",["银松森林"] = "R1,小圣蹄",["神圣之歌"] = "R1,夜雨星河;Rr,星空蓝莓;Rn,狐男;Rj,恭禧发財,绿茶;Rg,半醒",["雷霆之王"] = "R1,无独;Rs,曠谷幽蘭;Rd,深谷幽蘭",["迦顿"] = "R1,红魔手",["洛萨"] = "R0,布鲁特;Rp,???",["血吼"] = "R0,潴脚;Rf,长大后更帅",["战歌"] = "R0,叔叔摸摸大;Rf,则竹裕之",["暗影议会"] = "R0,宝灵孕保",["格雷迈恩"] = "R0,阿曼苏尔水晶",["自由之风"] = "Rz,奈恩",["普瑞斯托"] = "Rz,运气才是实力",["蓝龙军团"] = "Rz,芷希",["提尔之手"] = "Ry,鹌鹑",["破碎岭"] = "Ry,革新;Rx,一小炒肉一;Rq,珍尼佛;Ri,與你無关;Re,Bingk",["火焰之树"] = "Ry,萨日朗",["玛里苟斯"] = "Ry,蒜苗回锅肉;Rp,晨曦蕾欧娜",["永恒之井"] = "Ry,攻强卷轴;Rr,菲莉妮;Rg,一只小飞狗",["冬拥湖"] = "Ry,焚琴煮鹌鹑",["奥妮克希亚"] = "Ry,Reuentahl",["埃雷达尔"] = "Ry,西九龙曹达华",["回音山"] = "Rx,透过指缝看天;Rw,锤子恶霸;Rs,树下幽影,烽崝;Rr,丨烙印",["霜之哀伤"] = "Rx,卡夫卡的熊;Rs,公主的小黑猪;Rr,中野一花丶;Rg,夜翼迪克,兽栏管里员",["外域"] = "Rx,耶稣",["梦境之树"] = "Rw,终矢",["翡翠梦境"] = "Rw,微尘丶;Ru,晨曦如初见;Rq,泰凯斯芬利;Rp,春风不相识;Rn,巫訞王;Rd,白鸾",["通灵学院"] = "Rw,Lugo",["血牙魔王"] = "Rv,六省文科状元;Rg,晨熙爸爸",["伊利丹"] = "Rv,蜜丝兔丶;Rn,Sxy",["燃烧军团"] = "Rv,煞满;Re,不存在的情人",["遗忘海岸"] = "Rv,比克提尼,折戟尘沙",["丽丽（四川）"] = "Rv,沐仄仄;Rq,笙亦何欢;Rl,艾菲尔铁蛋,是昔流芳丶,田书宇女朋友;Rk,萨拉雷霆;Rf,灬柒爺丶",["龙骨平原"] = "Rv,舒克去两千年;Ro,忽悠王之怒",["恶魔之魂"] = "Rv,游仙;Rm,Foredawn",["阿纳克洛斯"] = "Rv,呆糊糊;Rt,丨丶博美;Rn,易相随;Rj,篮子里的果",["阿尔萨斯"] = "Ru,牧光星灵;Rj,噬碎死牙之兽;Re,Machupicchu",["塞拉摩"] = "Rt,夏末灬未至;Rq,天二儿;Rp,白涩风车;Rn,来个薯条,美琪",["玛诺洛斯"] = "Rt,西西里多",["拉文凯斯"] = "Rt,Skyy",["石爪峰"] = "Rt,王者临峰",["德拉诺"] = "Rt,深渊丶,蓝瞳丶",["迪托马斯"] = "Rt,绯村剑心",["熔火之心"] = "Rt,圣翼;Rm,欧乂皇;Rg,藤井美菜",["达基萨斯"] = "Rs,Virgosharja;Rl,蒸汽引擎",["冰霜之刃"] = "Rs,兽帝丶;Rf,王不留狗",["鹰巢山"] = "Rr,亲亲小乖;Rm,云少殇",["巴瑟拉斯"] = "Rr,Chaosneutral",["黑铁"] = "Rq,Contessa,一程山水歌;Ro,老板来碗凉面;Rg,可爱的李老师;Rf,不要不妖的",["纳沙塔尔"] = "Rp,装逼第二名;Re,喝奶",["希雷诺斯"] = "Rp,干挠之死磕",["雷斧堡垒"] = "Rp,萌萌噠喲;Rh,Lovered",["菲拉斯"] = "Ro,幸运",["勇士岛"] = "Rn,微风拂尘",["索瑞森"] = "Rm,惊觉;Ri,Oministero",["奥尔加隆"] = "Rm,玲珑;Rd,Bwonsamdi",["布鲁塔卢斯"] = "Rm,小蠻腰;Ri,Crazyhunterm",["天空之墙"] = "Rl,丶病娇的萝莉;Rj,Njmpl",["巫妖之王"] = "Rl,厮守灬聼雨;Rk,帝國戰歌",["尘风峡谷"] = "Rl,雲中锦書",["古尔丹"] = "Rl,石佛;Rd,冰冻废土之力",["试炼之环"] = "Rl,月下丶独舞",["希尔瓦娜斯"] = "Rk,阿里拉丶道森",["红龙女王"] = "Rk,人狠話不多",["海加尔"] = "Rk,北京大耳帖子",["奥斯里安"] = "Rj,将由",["提瑞斯法"] = "Ri,暴走的裤衩",["伊萨里奥斯"] = "Ri,射姑龙女",["蜘蛛王国"] = "Rh,愛小丹",["伊瑟拉"] = "Rg,怒放的雪",["埃苏雷格"] = "Rg,Lovoom",["夏维安"] = "Rg,温酒丷叙余生,月落丷霜满天",["黑暗魅影"] = "Rf,妩妖王",["风暴之鳞"] = "Rf,心淡若水",["世界之树"] = "Rf,微笑的蒂妮莎",["白骨荒野"] = "Rf,天煞",["麦迪文"] = "Rf,雪冰凌",["红龙军团"] = "Re,二十个我",["斯坦索姆"] = "Re,圣魔饭饭",["诺莫瑞根"] = "Re,紫露冰凝",["玛瑟里顿"] = "Re,陨落的星辰",["耐奥祖"] = "Rd,王一博,莲藕炖排骨",["黑石尖塔"] = "Rd,夕阳下的梦魇",["克洛玛古斯"] = "Rd,堕灬世丨知梦",["黑锋哨站"] = "Rd,冲锋遇到树,玩不来法爷"};
local lastDonators = "无駄-血色十字军,小红手晚雪-血色十字军,独醉丨-死亡之翼,大帅哥楚香香-伊森利恩,同福客栈湘玉-国王之谷,随梦忆潇湘-燃烧之刃,严肃的长颈鹿-迦拉克隆,惊情四百年-加基森,小呈呈-白银之手,放开小白兔-鬼雾峰,挥剑斩桃花-布兰卡德,普天元独步-罗宁,圣光与莉莉安-无尽之海,耗子尾汥-熊猫酒仙,丶为所欲为丶-凤凰之神,轉身淚流-贫瘠之地,正经小德-死亡之翼,猫咪安妮-迅捷微风,突然瘋了-鬼雾峰,轉身離去-死亡之翼,炼狱梦儿-月光林地,这是个幻觉-贫瘠之地,导演我洗好了-迅捷微风,壳壳超爱玩-安苏,二段媒介-死亡之翼,罗宾悍-冰风岗,果儿牧师-???,幼稚园殺手丶-布兰卡德,猫无艳-格瑞姆巴托,小年吉祥-铜龙军团,道丶无妄-末日行者,嘢零-艾露恩,路易德-黑暗虚空,贾老师-梅尔加尼,星野瑛斗-罗宁,丿霜花店-罗宁,帝姆罗斯-血色十字军,Lupinn-???,花潆滢-血色十字军,冬瓜茶小妹妹-影之哀伤,重庆胖胖-白银之手,疯狂的骨头-贫瘠之地,惊魂的小发丝-贫瘠之地,如鹿归林丶-影之哀伤,神波多壹花-艾露恩,深田咏美-艾露恩,零度领域-耳语海岸,夜楼-凤凰之神,战将白起-白银之手,挽梦依入怀-血色十字军,荣耀丶蛋挞-巨龙之吼,荣耀丶幻刺-巨龙之吼,田心爸爸-白银之手,欢迎您的光临-山丘之王,小土堆儿-主宰之剑,乌米饭打泡泡-戈提克,无心丶狩风-影之哀伤,叮叮车丶-燃烧之刃,汤姆布利柏丶-燃烧之刃,千瓷-金色平原,依莉雅斯菲爾-伊森利恩,凡尔赛丶-凤凰之神,试管毁灭者-格瑞姆巴托,秋沫丶-凤凰之神,奈斯凸迷球-死亡之翼,丨老妖丨-守护之剑,腰纏萬貫-麦姆,大都督吕蒙-奥特兰克,丶叁拾壹-???,Doolly-死亡之翼,Madneess-死亡之翼,湖人牛-死亡之翼,走走道丶撞-血色十字军,好热开空调吧-凤凰之神";
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