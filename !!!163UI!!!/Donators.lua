local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,空灵道-回音山,瓜瓜哒-白银之手,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,释言丶-伊森利恩,林叔叔丶-死亡之翼,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,短腿肥牛-无尽之海,冰淇淋上帝-血色十字军,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["死亡之翼"] = "HD,瘦人永不发福;HC,伊利瞎丹,放肆一吻,我不玩坦克;HB,张天萌丶;HA,Yeran,塔蕾莎的回忆;G/,海鲜可爱多,蔓蔓卿心,齐总,明月大哥,秦风细雨;G+,好嗨佑;G9,剪丶烛,因爱执着;G8,随缘丷,Octavius,丶纸防骑,最强王者;G6,郎郎酱;G4,信仰聖光垻;G3,乳酪芝士面包;G2,糊涂小刀,真希波玛丽;G1,夜曳依然,逐光之影丶,拽根宝,喵丶小寒;Gz,古麗古麗",["末日行者"] = "HC,绝种哈士骑,月夜之子;HB,我不是骡子,丶朱孝天;HA,零六壹捌,梦落大人;G/,荔枝味之吻,快乐的小易易,尒抹茶,青椒扣肉;G6,爆炸小红豆;G5,醉舞饮千觞;G3,無始無終;G2,我受够了寂寞",["安苏"] = "HC,Lanyuchen;HB,我芸丶;HA,嗒嗒丨,青规戒律,淡漠行;G/,谢丶燕君,铁骑乄小章,醉秋红;G+,瓦嘎;G9,往誓隧風;G7,小妹贵姓;G6,乄奔放哥丨;G5,酒不好喝么,巴音布鲁克丶;G4,铁血乄威士忌;G1,Brightroar",["主宰之剑"] = "HC,小阿咪丶,喵筱筱,换坦丶嘲讽;HB,夏雪宜的盾;HA,丶韩菱纱丶;G/,传说冰有淚,绝世歌姬海牙,Culaccino,叶落初冬丶,黑夜战神,先民的权柄,丨寒影丨,在下瞄人凤;G+,大匠,很简单;G5,巫女大人;G2,伊薇露艾;G0,昊泽;Gz,天才小熊猫,丶射掱",["无尽之海"] = "HC,我很谦虚;HB,提拉米米苏;G/,海猪海猪;G9,大雨将至,哼哼唧唧;G7,文燕;G5,Stefanieyu,蛋总的忧殇;G2,丶小海棠,守护丶奶妈",["玛洛加尔"] = "HC,影丶夜舞;Gz,红滴像番茄",["丽丽（四川）"] = "HC,观海听潮;HA,樱落,一个列人丶;G+,清风佛杨柳丶;G9,吃不完蛋百粉;G6,彭摆鱼;G5,老肥;G3,丶华哥;G2,糖果果灬;G0,流泪手心",["???"] = "HC,蔡叔叔丶,戰丨仕,凡悟;HB,欧神诺,骑猪追竹鼠;G/,丷笑生花,Faceblindnes,来福;G8,乳牛;G7,邪恶的大西西,Yunglongx;G6,云星空",["迅捷微风"] = "HC,那些你给的梦,完美有多美,脉伦;HA,醉花荫丶;G0,虾纸",["白银之手"] = "HC,季丶鸳,Sinéad,曲绯烟;HB,寂寞依然,飘扬的红裤衩,莉兹与青鸟;HA,传奇圣斗士,江畔伊人;G/,陈丨冠希,风暴烈酒丶刘,舔枸,手術刀,灰色的心,云水優優,Yorhatypeb,白咕咕灬;G+,兽本善良,纳格兰的静谧,假爱之名,奥妮氪希亚;G9,暴乀徒;G8,打野千珏,納格蘭的靜謐;G7,我在途中丶,王大少,Vesperlynd,命格无双丶,晚安丶喵;G6,吞风闻雨落,橙夢;G5,佬克;G4,密微微其清闲,疯花生;G3,风姿傲骨;G2,Fovcjq,斯坦恩布莱德,执笔绘红尘丶,极品宠物;G1,月伴清宵;G0,雷哥没时间,血月星空,木岩;Gz,建议放弃治疗,胖神仙,寒月当空,深海活鱼",["普罗德摩"] = "HC,醉看风拂袖;G+,妖怪别跑灬",["安东尼达斯"] = "HC,独孤鱼",["太阳之井"] = "HC,飘雪若絮;G3,丶偷神月岁,恶搞大魔王丶;G2,刹雪;G0,谜之粉粉",["加基森"] = "HC,江湖再無熊哥;G/,坐在高岗上",["诺兹多姆"] = "HC,墨兰嘿;HB,奥黛丽丶王",["贫瘠之地"] = "HC,邪恶打击,崔笑笑,就想扫一扫;HB,秀儿童鞋,叁从肆;HA,桜木花道,清欢丶白茶;G/,为了一个傻话,小兔宝宝,不吃喵的鱼,落叶满长安丶;G+,丷零度丶,泰火战坦,妖娆的胖子;G7,慕丝丝,Viruscorpio;G2,骁骁哥布林;G1,绿色的爬爬,冷色;G0,小肆儿,大建出奇迹,奶茶续命,鑫然灬;Gz,丶壞尛孓丶",["迦玛兰"] = "HC,灵犀一闪",["凤凰之神"] = "HC,葡萄酒火锅;HB,牛蛙丶丶,辣目洋子,梦境大奶牛;HA,雷皮之槌,自由镇书记,殺风;G/,绯色天堂,沉鱼欧巴,易丶愿,丨闹小闹丨,谢无生,离歌罒,四蛆兄弟,Silentheart;G+,关爱老实人,乔姐,浅酌笑红尘,心若浮云;G9,深了个邃;G8,Maikuraki,无丶里头,涅槃妙心;G6,黯然丶销魂饭,一碗蛋花汤,中传媒桃源晓,可爱哒兔子,兔兔丶兔姐姐;G5,风起明月;G4,怑夏,风雷斬;G3,脸黑的阿昆达,丶厶鈊馡灬;G2,殺画丶,殺生丶;G1,怒风乄战神,兔子姐姐",["狂热之刃"] = "HC,尖锐博士;G7,大丑丑;G3,丨千手修罗丨",["闪电之刃"] = "HC,寛霸",["罗宁"] = "HC,月落微涼;HB,你好高冷啊,嗨朵朵;HA,盘他开哦,曰暮酒醒;G/,飞翔的大熊猫,四百搭免杠,落霞菲,黒崎一护;G6,桜五月;G5,白骑士丶月光;Gz,欧阳小哥哥",["雷斧堡垒"] = "HC,冫釒丶;G/,骚琦灬老伺机;G+,田蜗虾面;G5,一杯敬圣光",["血色十字军"] = "HC,满意大魔王;G/,像极了爱情;G9,小朋友爱吃糖;G8,一高人蛋大;G7,睡也睡不醒,风行者阿西吧,身材小总爱跳,丿丶阿九,阿呆呆,狂奔的虫子;G5,Demonci;G4,褒姒别点我;G2,乖乖咙嘀咚;Gz,洳意丶",["格瑞姆巴托"] = "HC,不破不灭,Doomedo;HB,带带大师妹,和风;HA,胯下那杀气,Justgogoo;G/,叮当当咚咚当,小黄爷丶,辅导员灬;G+,笨笨豬丶,丨纞丶戰丨;G7,破军星灬小楼;G4,砸烂复读机;G2,Keeric;G1,水星环游记丶,知阴大鸽鸽;G0,清歌绝影,落叶丶悲痛,灬刃丶猫灬,华北可能有雾",["风行者"] = "HC,緑涩",["熊猫酒仙"] = "HC,何来爱吃大福;HB,奥西尔;HA,喝死在卫生间,未丶来;G/,無雙,战霜翼,哈哈兔小爷;G6,令狐盟主;G3,狂野的红领巾,傻气丶,相当的牛;G2,大力花菜",["冰霜之刃"] = "HC,HunterRay;G8,墨如夜",["阿曼尼"] = "HC,Thug;HB,Nine;G/,我有小尾巴",["斯坦索姆"] = "HC,腹肌最讨厌了",["加尔"] = "HB,愤怒之罪;HA,友边的你;G3,提不动刀",["伊利丹"] = "HB,爱露露最好了,南宫铁柱;HA,蠕动荣誉;G/,慕容翠花;G1,左慈",["麦迪文"] = "HB,Easy",["密林游侠"] = "HB,Boomboomboom",["翡翠梦境"] = "HB,锦猫儿;G/,守候誓言;G9,凸血色凸,深了个邃",["鬼雾峰"] = "HB,魔法少女胡歌;G/,未知维度;G8,Nonohnb;G7,祖国的花骨朵儿,祖国的花骨朵",["金色平原"] = "HB,小鱼饼丶,法力虚空;HA,Nightelfmonk;G/,罗仪轻寒,由姝儿,乔瑟夫丶乔亚;G+,晨夜雨风行者;G8,Octavius;G2,Hertz;G0,水墨畫",["影之哀伤"] = "HB,菊之怒放,菊之绽放;HA,丶噩尨咆哮,单挑宿管阿姨;G9,神說丶要有光,皇家恐怖卫兵,法神丶大花生;G8,莫高雷收割机;G7,冰龍吐息丶;G4,羽沐歌;G2,阿亮丶萌德;G1,神隐忘舒,Angelmm,绿皮不语;G0,滋不滋瓷,阿亮丶贼帅",["达隆米尔"] = "HB,大萝卜哥哥",["埃德萨拉"] = "HB,Sheeran;G8,感谢神赐力量;G7,神話丶三三,咕德猫林;G3,蠱毒",["霜之哀伤"] = "HB,桐姥爷;G9,诵葬者;G4,遊牧人,咆哮的徒花",["伊森利恩"] = "HB,兔宝爱淼淼;HA,Keithmagic,暴走的小亮亮;G/,雷丶鸣,血腥爱情故事,呆毛王的愤怒,小麦与我同在,锻崖,安安归;G8,壹拾伍橙;G6,曾经已為追忆;G5,暴走的阿肉肉;G3,亚丶花残;G2,没我跑的快;G0,带你去看繁星;Gz,法力残渣丶,躺着舒服",["黑铁"] = "HB,勇猛的年糕;HA,提莫大将军;G9,亞丶絲娜;G5,二线酱油;G1,倾羽丶;Gz,刘大公子",["祖尔金"] = "HB,洪世贤;Gz,林品如",["轻风之语"] = "HB,面包师;G/,Malefica",["苏塔恩"] = "HB,黑牛之王",["阿纳克洛斯"] = "HB,加钱;G/,老衲摸摸;G+,鬼切;Gz,家庭女教师,毁灭加农炮",["燃烧之刃"] = "HB,珈蓝丶炎焱;HA,提里奥灬莫瑟,确实是个混子,成都李荣浩,鬼迷丶心窍;G/,领灬舞,红烧柠檬茶;G+,傳說中的骑仕,我是大丁丁,省直机关;G9,超梦的逆袭;G8,华伦天奴丶;G7,蛮大力,念小初;G6,子龙的粉丝;G5,阿琨达;G4,吉野婕,無她㢙,米米徳;G3,稳住我们能嬴;G1,影歌丶紫玉;G0,西门威哥;Gz,吉檀迦利",["破碎岭"] = "HB,醉过才知酒浓;G1,Turbowarrior",["阿克蒙德"] = "HB,Meninblack;G/,芥末糊一脸",["桑德兰"] = "HB,开盖惊喜丶;HA,察拉旺;G/,来个柠檬",["火焰之树"] = "HB,龙息火炮;G0,阿尔忒尼斯",["国王之谷"] = "HA,五十度善;G9,膝盖送你了;G8,乌瑞恩的老姨;G5,云彩上的天空;G4,清蒸灰熊掌;G2,小領主",["试炼之环"] = "HA,海瑟薇,希女王;G6,怀空;G0,白贤;Gz,枯叶蝶丶",["弗塞雷迦"] = "HA,天使不在人间;G2,一个冬菇鸭",["龙骨平原"] = "HA,Ozpin;G/,心安处即吾乡;G1,Playerkaiarb",["回音山"] = "HA,幻想破坏,六费黑骑士;G/,哈酷纳玛塔塔,油腻伽,烏妖王;G7,夜猫子的梦境;G6,杨巅峰",["奥蕾莉亚"] = "HA,落羽神魂,月影灵风;G/,星星点瞪",["红龙军团"] = "HA,樱桃小丸子",["塞拉摩"] = "HA,海医周杰伦;G+,放开丶那只熊;G8,抚琴听泉;G1,逃家小兔,透明雨滴",["艾萨拉"] = "HA,哥只抽玉溪,天使族淋透",["迦拉克隆"] = "HA,雪落灬初音,重度话唠患者,请叫我小软;G/,叮当法术喵;G3,影月之伤;G0,伊柒珥;Gz,绝望杀戮",["洛萨"] = "HA,苍岚的风",["海克泰尔"] = "HA,灬岁月如歌灬;G/,Lzmzzq,玲珑寂灭,雪潇然,Trust;G+,Ashedeserves;G7,可以刚这波;G3,棉花糖兔兔",["奥特兰克"] = "HA,脊背痒痒,幺蛾子颠颠;G/,沫楠枫丶,葳蕤灯火;G8,云音乐;G6,哈尼缇娜,流星,孙悟空;G3,火爆旭旭;Gz,死神涞了",["阿比迪斯"] = "HA,莫吉蒂",["布兰卡德"] = "HA,沙曼之神;G3,人多你别闹嘛,不行我要抱啦",["萨尔"] = "HA,嘟儿メ请留步;G6,主公快走",["永恒之井"] = "HA,战舞者丶;G1,阿兰若",["烈焰峰"] = "HA,丨小灬鹿丨;G5,抠脚猎",["阿斯塔洛"] = "HA,燎牙",["千针石林"] = "G/,晓月圆舞",["铜龙军团"] = "G/,凉凉丶,王立軍,Fayewong",["蜘蛛王国"] = "G/,潇潇晓晓,卓然天成;G8,伊沐雪一林语,伊沐雪一珍娜;Gz,伊沐雪",["冰风岗"] = "G/,、沫深;G8,山寨乄嗳情,富察丶傅恒,大梦文雀;G7,山葵汉堡,丨冰封夕阳,西门寺幽幽子;G1,久伴不离,潴灬牛气冲天,Tovelo",["神圣之歌"] = "G/,夜雨连明;G8,柯哒;G2,丶休",["泰兰德"] = "G/,颜值才是正义",["诺森德"] = "G/,德艺两开花",["熔火之心"] = "G/,四十几个武僧,孤丹丶旎,塔蘭吉公主;G+,淡淡的優傷;G8,Victoria;G6,超烦之萌;G2,苦工哒哒",["迪瑟洛克"] = "G/,又大又粗又长",["巴纳扎尔"] = "G/,冷雨听风",["托尔巴拉德"] = "G/,易知",["银松森林"] = "G/,最后的使徒子",["克尔苏加德"] = "G/,Clearlové,咿幺大叔,荀令君;G+,伊幺大叔;G3,网红镇",["月光林地"] = "G/,飞剑决浮云;G+,望月莎;G5,风哥;G3,水銀瓷;G0,人非物非世非",["法拉希姆"] = "G/,铁歌;G2,戏听清影横笛",["血牙魔王"] = "G/,柯基骑士",["诺莫瑞根"] = "G/,神也酱酱;G3,山药丶",["血吼"] = "G/,漫漫你好骚啊",["寒冰皇冠"] = "G/,蓝郁;G9,壁垒",["外域"] = "G/,Suyua",["暗影议会"] = "G/,王者之枫;G4,樱木花卷丶",["天空之墙"] = "G/,秋诺",["甜水绿洲"] = "G/,花大妞",["耳语海岸"] = "G/,蘇菲娅,漂亮的狗狗",["斯克提斯"] = "G/,六星大乱斗",["瓦里安"] = "G/,玖橙",["恶魔之魂"] = "G/,白银之手丶,别奶我",["夏维安"] = "G/,摇了摇头",["纳沙塔尔"] = "G/,娜依秀美",["战歌"] = "G/,飞天小女警",["耐奥祖"] = "G+,Eviljoker",["玛瑟里顿"] = "G+,小角乱顶",["海加尔"] = "G+,十方霞涌",["艾欧娜尔"] = "G9,秦域珑珑",["幽暗沼泽"] = "G9,阿吉",["古尔丹"] = "G9,血刺印;G2,亚洲王祖贤",["奥杜尔"] = "G8,断水",["血羽"] = "G8,Yukiteru",["玛多兰"] = "G8,Cleisy",["阿古斯"] = "G8,布兰妮丶甜甜",["亚雷戈斯"] = "G7,哀木梯",["守护之剑"] = "G7,莫小舞",["壁炉谷"] = "G7,水蜜桃挽歌;G1,万籁俱静",["暮色森林"] = "G7,我就这么欧",["芬里斯"] = "G6,四二五带孔",["踏梦者"] = "G6,风马不羁",["毁灭之锤"] = "G6,就是丑",["奥尔加隆"] = "G6,晓灬蛮腰;G4,卖萌不卖身;G2,夜幕幽幽",["玛诺洛斯"] = "G6,茶板",["希雷诺斯"] = "G5,铅笔小欣",["巫妖之王"] = "G5,雪落无痕",["摩摩尔"] = "G5,最后的處男",["图拉扬"] = "G5,缝夏;G0,多洛丽丝",["生态船"] = "G5,瞬狱影杀",["巨龙之吼"] = "G5,空条徐伦",["黑暗虚空"] = "G4,吃可爱长大的",["哈卡"] = "G4,朲緬獸伈",["艾露恩"] = "G4,毛蛤蜊;G3,Luckycore",["蓝龙军团"] = "G3,坎巴斯",["深渊之巢"] = "G3,越长大越孤单",["萨菲隆"] = "G3,滨湖梁朝伟",["遗忘海岸"] = "G3,诗酒趁年华丶",["红龙女王"] = "G3,筱犄角;G0,纳闷儿",["德拉诺"] = "G3,天命沐沐",["洛丹伦"] = "G2,月落风云舞",["恶魔之翼"] = "G2,幽默感",["大地之怒"] = "G2,超重青年;G0,贫乳灬控",["黄金之路"] = "G2,时间去哪",["奈法利安"] = "G2,北执",["黑暗魅影"] = "G2,肉嘟嘟",["艾莫莉丝"] = "G1,黄内障",["卡德加"] = "G1,木木西",["阿尔萨斯"] = "G0,冬熊夏咕;Gz,皮拳兒",["影牙要塞"] = "Gz,死亡妖灵",["鲜血熔炉"] = "Gz,星界",["萨格拉斯"] = "Gz,风火灬侠客",["屠魔山谷"] = "Gz,王欣欣",["暗影之月"] = "Gz,太多的变化",["地狱咆哮"] = "Gz,南笙"};
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