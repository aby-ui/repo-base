local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["亡语者"] = "cQ,丿流氓咕咕;cG,画圈圈诅咒你;bI,全程鸥剃",["格瑞姆巴托"] = "cQ,地狱火萨满;cN,尛洲,糖醋溜丸,袁崇焕;cL,萌面怪兽;cI,花开月圆;cH,限失真,铜铁锤;cG,梦落南风;cE,芥末丶小攻鸡;cD,肉酱意面,骑猪吃麻辣烫;cB,景初,天空淡蓝色;b1,逗逼李二蛋;bx,仙吕下凡;bR,艾尔丶菲尔特;bM,安克瑟拉姆;bI,银枪大叔;bH,乣沂吴先生,芒果灬布丁,芒果灬乌龙;bF,乱射丨菊花,侧面增强",["迦拉克隆"] = "cQ,冒泡泡咕噜,我系渣渣辉;b8,張先生;bq,折戟断流;bo,泛风流年;bd,留流胡,叫我小奶;bI,圣光制裁使",["???"] = "cQ,别被逮住嗷;cO,小德举高高,萨头里,小达不溜;cI,无聊很强大;cH,爱的飞行日记;cF,猫鳓鳓灬旋律,飞天小嘚瑟;cE,Xiayi,Superpolice;cD,Gaki",["安东尼达斯"] = "cQ,冰丶夏",["无尽之海"] = "cQ,心橙;cK,考焦小松饼;cF,花沐兰;cD,豋豋;cC,咕咕不好吃;cB,老司机的挽歌;b4,鱼的脚印;by,蝎子殿下;bo,陈天歌;be,七月青歆;bF,哈哈氦",["摩摩尔"] = "cQ,若晨",["白银之手"] = "cQ,丨鵼丨;cP,彳亍禾呈石马,雯浩灬宝宝;cO,雯浩宝宝,杀气正浓;cM,丶逝水流年,花小木;cL,旅店老板贝蒂,氫橘;cK,学院派草莓;cG,锐华幸运的丶,丨苏小木丨;cF,守护雯之盾,雪落思寒,世界的后果,卢英俊,我就进来二玩;cE,丨鸠丨,七彩丶雨舞,丨染丨,亿丰,饮不尽杯中酒,贰壹贰陆贰伍;cD,手术室天使,布半克丶托尔,Nidaye;cB,肉包很咸鱼,听说很木雪雪;b+,雯浩丶,歐仔榮少;b7,潘玉魄;b6,猎屠;b5,醉卧桃花林,北城丶梦魇;b3,柏仁,丨似水流年丶;b0,白条肉肉;by,拳击社;bv,零贰肆零壹肆;bn,张小然;bh,圣骑爷爷;bf,天使小兔;bd,乄夕陽;bc,Deadtempler;bb,大雄叔叔;ba,梓嫣;bY,索楼,娇嫩的小鲨鱼;bW,碧落幽阳;bT,永之皓月;bR,霜沉;bN,妖言老君;bL,星晨軌跡;bK,丶大爺;bH,劜亇,追意;bG,手心里的聪宝,之之;bF,小柯基呀丶,Damnn,沉沦六道",["燃烧之刃"] = "cQ,小大不溜;cJ,不是那种劣人;cG,簡影;cF,扬航,茗箭;cE,蓝莓奶油,丶刀舞,Balerions,姑娘莫慌是我;cD,咆哮的牛牛;cC,欧欧的阿昆达,伪恋;cB,焚天灭曰;b/,履至尊制六合;b+,翘思慕远人;b7,毁灭苍炎;be,林克小飞侠;bX,洛丶歌,书没读好;bW,丶枯叶;bP,听说你叫噗丶;bO,牛儿憨憨;bN,丢你那星;bM,虐弑;bL,张大明白,山下有猎户;bK,丶死神降临;bI,Nibuxing;bH,萌萌然;bF,翘屁",["布兰卡德"] = "cP,Fait;cN,熙成则灵;cI,夏了夏天;cF,Giftia;b2,永啼鸟;bf,八千丶;bV,王思丶葱;bN,胖娃杀手;bJ,抽黑兰的大摩;bG,不德鸟,不得鸟",["晴日峰（江苏）"] = "cP,一只巨熊;bd,熊三不列颠",["死亡之翼"] = "cO,诗忆丶;cL,Parade;cK,灬侠丨岚灬,灯笼果好酸;cJ,丨龙血炮手丨;cI,丨叉烧丨;cH,跟驴去了远方,柿柿迷路啦;cG,想和你贴贴;cF,Sjerry,心动太难,惜心;cE,一巴掌乎死你;cD,喜德千斤;cC,望尽长安花;cB,炙热的猎手;b9,夜风轻语;b4,伊腻丹;b2,汐丶诺;bz,欢笑;bv,是猫颜阿;bq,白桃丶奶茶,法号丶二楞;bo,小厚先森,清蒸牛匾;be,大熊叔叔;bZ,九龙仓丶烈风,苝落师門,莫高雷丶烈风;bY,貮囍;bV,糖三;bT,炽天使彦;bS,术嘟嘟;bR,灭咩灭;bM,遍野山色青峰;bL,丷夜色里,偏不;bK,丨布朗熊丨;bI,Gahiji;bH,南宫僕射,条野丁史大,球球不是球球;bG,胖蛋蛋儿;bF,剑仙帝",["夏维安"] = "cO,瑟银矿石;cN,Nsydlts,将军夜引弓",["贫瘠之地"] = "cO,花神月;cK,淡淡的思恋;cJ,初冬之烬;cF,沙狐勇者,青橘炒柠檬;bM,川川;bL,云鸿;bE,缒風",["阿克蒙德"] = "cO,Witas",["凤凰之神"] = "cO,八一星;cN,Acanknight;cL,楠胖胖丶;cK,墨洺棋妙;cI,Glouocdk;cG,爛命一条,钰九涵;cF,苦痛钢琴师,牧嫣;cE,踏空,潇洒大铭哥;cC,二喵等一下,晨曦载曜;cB,Netero;b+,Tjt;b6,问就删号;b5,一早;b3,八泽;bz,超级草莓芝士;bx,她把风吹走了;bw,卡西卡洛;br,丿諾灬;bh,蓝跃光;bf,爱吃喵儿的鱼;bV,安妮赫兰之弦;bT,小丶潞;bO,灌不注;bM,Anhee;bK,啤酒不是皮酒;bJ,放纵着忧伤,爱笑的加菲;bI,姬魅蓝,晴時,丨云无月;bG,心灵契约丶",["玛里苟斯"] = "cO,知柏地黄丸",["主宰之剑"] = "cO,不秀就要死;cI,寶旎;cE,诡异天使;cD,间道;b6,青色;b2,琉璃宸瞳;b1,Gideon;bs,北山的雷;br,紫月嬋娟;bf,三仓镇丶段坤;be,神曲之殇,魂亡;bW,莫得理萨;bQ,大红手小禹;bM,大领主飞扬;bI,可爱丶牧;bH,漩涡灬鸣人,有容丶乃;bF,甠飏",["金色平原"] = "cO,伊諾;cM,杰哥不要辣;cG,实习祭司茉莉;cC,琉龙马;b7,伊米希尔;bR,雲中锦書;bQ,Alois;bM,近战如何生存;bG,爱丽丝丶日怒",["罗宁"] = "cO,中年的樵夫;cN,南夜;cM,Redmu;cL,亖零亖,瞬风丶术,易訫;cF,天高三寸,洁箩,天空的彩虹,阳春既望;cE,天從雲,野战军丶大萌;cD,意念;cC,Yeesuet;cB,Aceace,十万伏皮卡丘,Dreambrewmas;b1,一五爷一;bp,王木木;bb,半日浮生;ba,丶亦衡灬;bR,哥丶有点风骚,一介莽夫;bQ,蛋灬泥;bP,橙不二;bN,二般路人德;bM,玉棠春",["红龙军团"] = "cO,传奇猎手;cD,Ulysses;b6,库库林白夜",["火焰之树"] = "cO,斯人如逝",["影之哀伤"] = "cN,琻甲银枪;cG,谷德曼;cF,破碎的歌谣;cD,Skriniar;cC,Moment,丨阿坤灬;b/,尤巴;b1,丷倾情丷;bi,狐狸娃娃;bX,Rara;bQ,伊利蛋顶红;bP,萱萱大魔王;bI,丶奈斯兔米球;bH,丨江隂饅頭丨,门当牛不对;bG,壹天尐話痨,米拉提;bE,叶俢",["安苏"] = "cN,夏二萨,二十;cM,亲爱的亲爱的;cL,汉字序顺;cK,追梦;cI,风摇白露;cH,万古第一狂神;cG,丷莎缇拉丷,不及格巫师;cE,吐洱淇冰淇淋;cC,壹晴天,凉茶乀;cB,爱老鼠得蕏;cA,郑天罡;b/,奶茶超亻;b+,灰烬的抉择;b5,Lesliejing;bz,滨西刑侦宁宇;bf,明天退游;bb,手刃恩师,逐星丶洛羽;bX,天使爱唱歌;bV,啊拉宁波;bR,寸耀兰;bQ,无名的士兵;bM,布拉德丷特皮;bI,阿啦宁波",["血色十字军"] = "cM,从来都不乖;cJ,Aveen;cH,杏遇墙;cG,拉普耶鲁丶;cF,若灬渐离;cD,血色的乌鸦;cC,星陨丶,洛桥晚望;cB,一心憧憬;bL,老林,阿宁啊,风弓羽箭,必殺;bF,半点白",["加基森"] = "cM,佑佑爸爸;cB,饮风共醉月,清醒梦境之忆",["加尔"] = "cM,赐我一场好梦",["洛萨"] = "cM,阿明血蹄",["末日行者"] = "cL,兰藉;cF,灬崔灬;be,信仰毁灭;bT,庆尙",["燃烧平原"] = "cL,自由自在點;bP,暗夜浩劫",["黑铁"] = "cL,酸酸寿司侠;bN,靓佳慧;bJ,睡觉不如跳舞",["阿迦玛甘"] = "cL,仙紫",["熊猫酒仙"] = "cL,开溜;cG,韩菱砂;cE,Codedog;cB,聖刺客,挽梦忆笙歌;bd,故梦;bQ,阿鸣;bM,村里小胖,荭豆;bF,拂尘晓,寒影丶,至清",["基尔罗格"] = "cL,世情薄人情恶",["迦玛兰"] = "cK,释星魂",["伊森利恩"] = "cK,一猩四射;cJ,小刀锋利;cH,曾志伟丿;cG,希尔瓦娜斯;cF,Haggis;cE,先生做保健不,狐莉娅,圣阿尔托利雅;cD,暮雪千岚;cC,闲卿,全球全球帝;cB,雲丶;b5,卫法斯;bp,水野樱;ba,晚峰揽月;bI,呱二蛋;bF,Kuchikirukia",["熔火之心"] = "cJ,孤独予戈;cE,锦衣卫丿花牛",["狂热之刃"] = "cJ,猪狂;cF,希风;cB,業火丶;bT,山风舞云",["艾莫莉丝"] = "cI,天地哥;bU,通天巨物",["回音山"] = "cI,苍云归来;cC,Marywintour,战斧牛牌;b5,回音山灵;bM,远古列王守卫;bK,橘子味的书海",["拉格纳罗斯"] = "cI,Revolutionx",["血吼"] = "cH,莫里莫西;bI,乄虢乄",["海达希亚"] = "cH,特和",["麦迪文"] = "cH,敲蛋砖家;bR,红色小皮皮;bM,星空二,流星宇宙",["幽暗沼泽"] = "cH,木牧木;by,绿色发光眼;bd,亮闪闪的世界",["霜之哀伤"] = "cH,钓鱼大哥请留名;bf,伊诺莉;bF,启示骑士",["金度"] = "cG,夜之暗战",["甜水绿洲"] = "cG,盾在手人在抖",["塞泰克"] = "cG,永远爱果果;b7,若晗",["外域"] = "cF,Ziggs",["雷克萨"] = "cF,Buffret",["索瑞森"] = "cF,竹影清风",["阿古斯"] = "cF,比迪丽;b4,妖精的梦想",["鬼雾峰"] = "cF,胤凯;b4,土匪小头头;bP,逼小狸,逼小咩",["巴尔古恩"] = "cF,莉莉原上草",["克尔苏加德"] = "cF,夢桜;cE,衛宮切嗣;cD,紫雲若寒;b5,后里;ba,东里路,心随萌动",["丽丽（四川）"] = "cE,大和队长,一襟花月;cB,今天想暴富;b1,德里克;bs,那天阳光很好",["希雷诺斯"] = "cE,黑芝酥心糖",["雷斧堡垒"] = "cE,月舞光辉;bz,Wryy;bU,机智的小明仔",["萨菲隆"] = "cE,湖上的骑士;cD,惟吾德馨;bW,番茄蛋饭",["恶魔之魂"] = "cE,尤妮娅丶晨诗,庙街双刀火鸡,惜缘灬明菁",["国王之谷"] = "cE,你雀儿食胎神;cB,丨殷為有妳丨;bL,元素老头;bI,Darkzhou;bF,寒風丶",["海克泰尔"] = "cD,川菠萝",["屠魔山谷"] = "cD,秘银之羽",["神圣之歌"] = "cD,浆泡女士;cB,丁真四号;bL,神話",["黑龙军团"] = "cD,清澈明朗",["玛洛加尔"] = "cC,马尔泰弱爆",["冰风岗"] = "cC,逼傻是念着倒;bL,Gnx;bG,Aquamancc",["达斯雷玛"] = "cC,萌萌的潘多拉",["拉文霍德"] = "cC,猎迹斑斑",["银月"] = "cC,法爷强得离谱",["天空之墙"] = "cB,思思大魔王;bL,派大星的大招",["日落沼泽"] = "cB,怎么独活;bV,江洲小猎;bI,你背后的神",["亚雷戈斯"] = "cB,灭世;b/,调戏老婆,破丷咒",["迅捷微风"] = "cB,Fairness;bS,我被主播网爆",["奥特兰克"] = "cB,落落羊;bs,麦她丽卡",["翡翠梦境"] = "cB,黄花大角",["龙骨平原"] = "cB,四段牛牛;b9,马戏团团长;bQ,我奶你先上;bI,我不够狠",["克洛玛古斯"] = "b/,涩狼德狼",["Dalaran[US]"] = "b+,Buringice",["深渊之巢"] = "b8,牛春晖",["艾露恩"] = "b6,旺福",["米奈希尔"] = "b5,狮心王瓦里安",["埃克索图斯"] = "b3,射日甜心",["泰兰德"] = "b1,玩猜猜",["奥蕾莉亚"] = "b1,仁德仁心",["芬里斯"] = "b0,Coquette;bJ,冬坏爷老祖",["荆棘谷"] = "bw,丨丶雲小白",["雷霆之王"] = "bt,风修罗;bd,陈一发",["能源舰"] = "bs,夜喵",["莱索恩"] = "br,爱神",["艾森娜"] = "bo,Paletteice",["影牙要塞"] = "bn,丨丶忄",["诺兹多姆"] = "bk,海的姑妈",["银松森林"] = "bj,无情的工具人;bL,射得一手好丝",["塞拉摩"] = "bh,Akadiza",["戈古纳斯"] = "bh,海盗丶",["遗忘海岸"] = "bg,混帐的天空",["伊瑟拉"] = "bg,月神之镰;bI,怕黑的小白",["埃德萨拉"] = "bf,調理師花玖;bX,莫兰諦",["时光之穴"] = "be,塔拉夏",["巨龙之吼"] = "be,王大菜",["艾欧娜尔"] = "bX,笑死街头",["厄运之槌"] = "bW,小俊汐",["埃霍恩"] = "bS,云天衡;bH,玖壹吴先森",["布鲁塔卢斯"] = "bQ,Immature",["燃烧军团"] = "bP,眉清目秀",["千针石林"] = "bO,勇敢牛牛",["卡德加"] = "bN,狩猎星空,寻找火星的你;bF,干净",["卡拉赞"] = "bL,訫随风飘逝",["洛肯"] = "bK,渣男斩女",["黑翼之巢"] = "bK,艾伦",["Illidan[US]"] = "bI,Unholyooxx",["奈萨里奥"] = "bH,不是杨花,映雪红装",["霜狼"] = "bG,霜曈",["德拉诺"] = "bG,醜公",["阿纳克洛斯"] = "bG,雷丶叱咤风云",["冰霜之刃"] = "bG,夏吉尔安;bF,元素使,小冰塔",["风暴之怒"] = "bF,一尾巴抽死你",["蜘蛛王国"] = "bF,冷月寒枫"};
local lastDonators = "传奇猎手-红龙军团,中年的樵夫-罗宁,伊諾-金色平原,小达不溜-???,不秀就要死-主宰之剑,知柏地黄丸-玛里苟斯,八一星-凤凰之神,Witas-阿克蒙德,花神月-贫瘠之地,杀气正浓-白银之手,萨头里-???,瑟银矿石-夏维安,小德举高高-???,雯浩宝宝-白银之手,诗忆丶-死亡之翼,雯浩灬宝宝-白银之手,一只巨熊-晴日峰（江苏）,彳亍禾呈石马-白银之手,Fait-布兰卡德,小大不溜-燃烧之刃,丨鵼丨-白银之手,若晨-摩摩尔,心橙-无尽之海,冰丶夏-安东尼达斯,我系渣渣辉-迦拉克隆,别被逮住嗷-???,冒泡泡咕噜-迦拉克隆,地狱火萨满-格瑞姆巴托,丿流氓咕咕-亡语者";
local start, now = { year = 2018, month = 8, day = 3, hour = 7, min = 0, sec = 0 }, time()
local afdianDonators = "牛丷逼-凤凰之神,戰灬戰丶戰罒-燃烧之刃,浅井舞香-凤凰之神,导演丶-冰风岗,蓝白碗-死亡之翼"
local afdianRecent, afdianRecentNum = "浅井舞香-凤凰之神", 0
local player_shown = {}
U1Donators.players = player_shown

local topNamesOrder = {} for i, name in ipairs({ strsplit(',', topNames) }) do topNamesOrder[name] = 5000 + i end
local lastNamesOrder = {}
for i, name in ipairs({ strsplit(',', afdianDonators) }) do lastNamesOrder[name] = i if name == afdianRecent then afdianRecentNum = i break end end
for i, name in ipairs({ strsplit(',', lastDonators) }) do lastNamesOrder[name] = i + afdianRecentNum end

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
for _, fullname in ipairs({ strsplit(',', afdianDonators) }) do player_shown[fullname] = 0 end

function U1Donators:CreateFrame()
    ConvertDonators(recentDonators)
    recentDonators = nil
    ConvertDonators(U1.historyDonators)
    U1.historyDonators = nil
    for _, fullname in ipairs({ strsplit(',', afdianDonators) }) do
        table.insert(players, fullname)
        player_days[fullname] = ""
    end
    afdianDonators = nil

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
        local date = player_days[players[index]]
        row.firstdate:SetText(date == "" and "爱发电" or date);
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