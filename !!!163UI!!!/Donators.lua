local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,释言丶-伊森利恩,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,坚果别闹-燃烧之刃,老熊饼干-金色平原,冰淇淋上帝-血色十字军,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["贫瘠之地"] = "IC,辛德瑞拉之梦;IB,何地彼方;IA,亚克;H/,明曰花绮羅;H8,素年瑾兮;H6,退骚药,Yonger;H5,牧小北;H4,大鵰萌妹,尼利艾露;H2,所罗门的夕阳;H0,东海有鱼名咸;Hy,躺尸佬板;Hx,影乂刃;Ht,紫色假发;Hs,Ettard;Hr,三联生活周刊;Hm,老夫少女心;Hl,不如丿不见;Hk,梅花三弄,岁月无忧;Hj,淡淡的超人;Hi,伊藤,洪夕颜;Hg,巫咸大人",["寒冰皇冠"] = "IC,和光",["安苏"] = "IC,叔叔来颗糖;IA,光橙;H6,触摸自由,状态很好;H2,丷柳岩;H0,月下咏唱;Hz,萤火虫的思念;Hy,黎明的星芒;Hw,艾东提,百花爵士;Hu,夜冷月;Ht,刘五岁啊;Hp,泰山;Ho,悦耳情话丶,青青灬子矜;Hm,忆往汐,風起丶;Hl,一心收复月球,丨萨摩耶;Hk,Vampirina;Hj,有利奈绪丶;Hh,驷马难追一牛",["燃烧之刃"] = "IC,Gaay;IB,谢大力;H/,Rollingstar,寒烟牧牧;H9,小轻玥;H8,简约甚好;H7,|你曰个求|;H4,Winkly;H3,芒果乄芒果,茶意微凉,少年与老狗;H2,灵烛司梦;H0,那年那个豆包;Hz,Vordemort;Hx,Carmel;Hu,夜雨眠;Hs,铲子,奎托斯娃;Hp,贰时代的胖,雷电忽悠着你;Hm,一首席退堂鼓;Hi,外科医生之手;Hg,千夜刃",["死亡之翼"] = "IB,欧巴丶思密达;IA,师爷苏;H/,指间的寂寞;H7,洗洗睡咧,荒野飆客;H6,Lòve;H5,烟兮忆梦,依然很强力,时光与你丶;H4,大原娜娜;H2,Mñ,洛希多尔;H0,丶扰,Helheimyang;Hz,栗想說,丶花子;Hy,绝世嘤雄;Hx,喜喜哥;Hr,灏小之,丶孜;Hq,好可爱呀;Hn,豆花上线了;Hm,Bumblebee,单身灬怠解救;Hl,哦莫成疼;Hk,刀疤兔;Hj,诗人;Hi,清新丶小纯洁,Skydog,莫迩迩,栗想;Hh,碳酸盐,阿克㐅萌德",["无尽之海"] = "IB,傲娇落兒丨;IA,Jooannan;H/,剑来;H7,南开大鸡丝;Hy,饭毛兔;Hu,擎丶天柱;Ht,戈什娜丶暮光;Hs,电电,俺是魔法少女;Hp,冯小倩",["影之哀伤"] = "IB,指熊为能,迷糊的喵崽崽;H+,糯米团子哟;H9,小滚锅、,小滚锅冫,勾若禅师;H1,大灰狼飞馕,静寂时分;H0,秋乾柒柒;Hz,夜若輕羽;Hw,我阴影中降临;Hu,劦晶尛灥猋;Hm,欧洲蚊子哥,梦之风语;Hk,洗脚小妹;Hj,诈尸与狗;Hh,Jiojio,万科吴彦祖",["烈焰峰"] = "IB,红颜若兮;Hp,愉悦的黄瓜;Hh,洛天丨凌風",["迦拉克隆"] = "IB,剁肉;H7,喂不熟的猫丶;H6,圣光在流淌,生煎孢子;H4,闪电尼克;Hy,语风灬闇影;Hs,卡塔库栗丶;Hq,豌豆绿;Hm,訫丶落初;Hk,剑子仙迹丶;Hi,呆呆老华",["奥尔加隆"] = "IB,刄莫予毒;Ho,一棍撑天地;Hi,丶喵萌萌",["白银之手"] = "IB,楓随箭舞;IA,疯魔天下;H/,我来酱个油;H+,辣妈乄小蛮腰,丨紅尘烟雨丨;H9,你最爱的啾可;H7,萨满小北;H5,瞧这小脚丫;H3,七七四十九丶,白给嗷;H2,一簑煙雨,自带飞行模式,一只脸萌喵;H1,吉穿春黛,锕突突;H0,单打独,Pandorayang,丶秋眸流盼;Hy,冰红酒,辣妈乂小蛮腰;Hx,月染蒹葭;Hw,利艾萨卡,瓜瓜哒;Hu,荒野远行,暗殇之秋,虚空吟咏,深海游龙;Hs,沧海渡余生;Hr,伱的名字;Hp,五七酱,岳狩;Ho,我睡过头了;Hl,乌云盖雪胖喵,冷月凝霜丶;Hj,小饥渴真好吃,妖妖的小贼;Hi,一切为了祖国,奔奔蹦蹦;Hh,打呼噜打熊猫;Hg,吃饭没有,潮牌潮牌二哥,团团熊屁",["伊森利恩"] = "IB,秋风丶叶落;H/,海棠大官人;H9,荆城老头丶,小小庄师傅,莫等闲丶;H8,川崎沙希;H5,德意丶;H3,Naye;H2,猪蹄;Hw,御劫,睿睿萌到晕厥;Hr,魂斗士;Hq,旖旎灬晨晨,超级萌萌;Hk,落慕繁尘丶;Hj,浩南小弟弟,花开一诺;Hg,唐小丶寅",["血色十字军"] = "IB,小九超友好;IA,弦千钧,晴聖,風火雷電;H6,我喂小萝袋盐;H1,丨安之若兮;Hz,佶米;Hy,深棕,加不起来;Hw,小头菇,蛋清芝士;Hu,白露為霜,白霜为露;Hs,李墨愁;Hq,啤酒丶小龙虾,郑小凯的嫩模;Ho,孟鲁司特钠丶;Hn,没耳朵的猫;Hh,江风悦人;Hg,雕刻丶月光",["熔火之心"] = "IB,貂裘换美酒;Hm,辉液;Hh,尧小樂",["冰风岗"] = "IB,大奈紫;H7,红色的冬瓜;H4,朦胧夜雨;H0,帝哎吃;Hx,上官汉堡,小糯米丷;Ht,小风筝;Hj,Rebirthbeck,張大喵;Hg,美就好了",["主宰之剑"] = "IA,冷月凝霜刀,洛丽塔法瑞尔;H9,威利,丶欧皇,柳乳嫣;H7,爱在回忆时;H6,芊儿;H3,欧洲雷宝;Hy,Almostlove;Hx,奶白圣歌;Hr,、欧皇;Hq,早安乂卢卡卡;Hp,仙萝丷;Hn,锦髦狮王;Hm,矮泽拉斯;Hl,阿丶古斯",["阿尔萨斯"] = "IA,凌乱随风;H+,风云不羁",["时光之穴"] = "IA,Jkseven;Hn,星辰木木",["凤凰之神"] = "IA,污兮控,白色尾巴尖,抽象的城堡;H+,要当岳父了,诗情又画意;H8,仙女大人;H7,富贵舔中求,丨吴彦祖,丨鸡你太美;H4,关大欧丶;H3,飞雪凝霜,请对我坏一点;H2,馮寶寶丶;H0,守护者丶果粒;Hy,Dadncht,镜流,鸢语丶,空城丶灬;Hu,大领主丶果粒,大祭司丶果粒;Ht,比眉伴天荒;Hs,大了灬我娶你;Hr,灬小哥哥灬;Hp,独立长亭丶,鈅銫涟漪;Ho,爆闪的咕,喬治丨船長,佩奇丨船长;Hn,恋伊;Hm,立花瑠莉;Hl,挪威的森林丶,灬三吉道灬;Hj,余晖烁烁;Hi,Swings;Hh,体验號;Hg,丶明月来相照",["海克泰尔"] = "H/,又又鸟;H4,流倾赋予诗;Hy,加尔鲁十;Hl,叶落无痕丶",["苏塔恩"] = "H/,绝地科学家;Hg,唐細細",["壁炉谷"] = "H/,Autofail;H3,莫小莫的寞",["罗宁"] = "H/,Tefuir;H+,休闲猎大;H6,释怀回忆;Hz,花之血契;Hx,自闭的皮卡丘;Hs,国服第一骚猎,帅哥爸爸,炟总驾到;Hr,带带萌新吧,月之丶优雅;Hm,夏茨祂请;Hj,青鹞子;Hh,超予;Hg,布兰缇什",["国王之谷"] = "H/,流年染指寂寞;H9,涂山梦梦;H7,米娜斯媞莉絲;H6,亚尼托魂歌;H3,百分百纯棉;H2,捂奶洛一丶;Hz,一绊凋零;Hx,吾乃洛一丶;Hr,笑不语;Ho,潺潺霜林晚;Hm,快躲开;Hj,硬吹十挺丶",["霜之哀伤"] = "H+,Tommykk;H7,白开;H5,小包子小星星",["黑铁"] = "H+,月夜葬花魂;H1,莉袜袜丶;Hw,勇闯集合石;Hs,妮露丶;Hj,特仑淑流莱",["布兰卡德"] = "H+,㒃毛球小栗子;Hi,多拉囧梦",["试炼之环"] = "H+,采野花的老牛",["永恒之井"] = "H+,嘿丶大爷;H9,武为止戈;Hz,蓝珏;Hx,球形闪电,海上明珠;Hs,夜如影",["玛诺洛斯"] = "H+,有点浪;Hs,沙鱼",["瑞文戴尔"] = "H+,仟送伊;Ht,潇杀灭红尘",["卡德罗斯"] = "H9,筱鬼",["???"] = "H9,加灬菲灬貓",["塞拉摩"] = "H8,殇影丿灬毒神;H0,来个米果,来个果冻;Hr,天你基霸真矮;Hq,唏嘘潴肉佬",["普罗德摩"] = "H8,恩佐斯;Hw,倒吸一口凉气;Hq,信仰丶",["加尔"] = "H8,妖狩",["狂热之刃"] = "H8,花落沉吟;H5,思吾爱;H1,藤藤菜乄;Hj,安薇娜的触摸",["达文格尔"] = "H7,清清",["遗忘海岸"] = "H7,谈笑风生,无奈之手;Hs,薄荷嘤嘤鱼",["埃德萨拉"] = "H7,教师节快乐;H5,影丸丶;H2,烟花萌德;H0,英雄出少年;Hx,Warmbodies;Ht,请别抚摸投食;Hp,睡不醒丷",["末日行者"] = "H7,冰冰貓;H6,流星欧尼酱;H2,佑枫骑士;Hy,面灵气;Hu,落葉;Hs,麦田微风;Hl,邪恶菠萝",["桑德兰"] = "H7,失去的时间;H3,武姬;Hr,余晖烁烁;Hm,等到放晴那天",["奥特兰克"] = "H7,大阿尔克那;H5,一只没有欧气;Hz,茄瓜盖浇饭;Hy,卿非卿;Hs,我身负双翼;Hr,盾盾向左;Hl,紅彤彤的鼻子;Hk,咕咕哒;Hj,學醫奶智障",["巴纳扎尔"] = "H6,忆步",["艾露恩"] = "H6,路野;Ho,西虹市首富",["血环"] = "H6,丶阳光下呐喊;H2,Keyra,龙父之牙;Ho,普莱斯扥特;Hn,歪加",["凯尔萨斯"] = "H6,非酋丶",["风行者"] = "H6,坏坏的傻傻",["格瑞姆巴托"] = "H6,逆光在街头;H4,子彧;H2,丨小饼干丨;Hz,好吃不如餃子;Hy,持度,夜班车;Hw,默都;Ht,刘昊然;Hq,瑟兰迪斯乀,丨独影丶;Hp,莽灬子;Hm,市之,莫得灵魂;Hl,Mikakiller,夏天的雨;Hj,蒼白眼眸;Hi,烟灰丶",["扎拉赞恩"] = "H6,专属尐肆亖",["战歌"] = "H6,醉後知久濃",["永夜港"] = "H5,城钟濡羽",["风暴峭壁"] = "H5,小鱼的理想",["火焰之树"] = "H5,聖氮同学;Hw,无敌敏敏公主,雨丨未來,雨丶未來;Hn,大雨灬",["提瑞斯法"] = "H5,霸气的葱;Ho,战争主宰",["熊猫酒仙"] = "H5,丿萌德丨;H2,Sovae;H0,云水泱泱;Hz,菲雨嫣然;Hm,马铃老鼠;Hk,沉醉幻云;Hg,鱼生请多指教",["回音山"] = "H4,全场最佳和尚;Hh,亦语轻歌;Hg,半月丶",["希尔瓦娜斯"] = "H4,沐浴聖光的妞",["翡翠梦境"] = "H4,兄弟猛曰;Hh,心上",["銀翼要塞[TW]"] = "H4,喵也不知道",["摩摩尔"] = "H4,胖之煞",["闪电之刃"] = "H3,胖得飞不动;Hs,小叮当",["诺莫瑞根"] = "H3,泰兰徳·歪风;Hk,笨蛋猫娜娜",["阿纳克洛斯"] = "H3,Colourful;Hi,高冷的白莲花,丶舞动",["卡德加"] = "H3,青色的风筝",["泰兰德"] = "H3,决绝;H1,秦陵",["雷霆之王"] = "H2,徐小影;Hx,永夜将尽;Ht,大剑仙",["克尔苏加德"] = "H2,Zorro,我们的女士;H0,一刀贼,一刀骑;Hy,勇者之刃;Hx,丿徐鳳年丨;Hs,花生瓜子糖;Hk,Lacusclyne;Hg,诛魔邪刃",["阿古斯"] = "H2,霞之丘溡祤,灬不准看我灬;Hn,冯寶寶;Hi,十八不戒",["芬里斯"] = "H2,讷言武僧",["萨尔"] = "H2,自由镇书记;H1,自由镇镇长;Hx,南极小受",["卡拉赞"] = "H2,一个二饼",["大漩涡"] = "H2,最爱小绵羊",["风暴之眼"] = "H2,月色悲哀",["天空之墙"] = "H2,勇敢的林林;Hm,缱绻噩梦",["灰谷"] = "H2,咾斯基;Hg,伊莫荅尔",["自由之风"] = "H1,糖醋乄锦鲤",["迦顿"] = "H1,王者祝福丶",["拉文凯斯"] = "H1,冰血肥牛;Ht,大壊狼",["冰霜之刃"] = "H1,丶忘川;Ho,方丈戒嗔",["金度"] = "H1,灰不拉几;Hj,晴素",["阿拉索"] = "H0,Anicca",["巫妖之王"] = "H0,冲钅的阿坤达",["梦境之树"] = "H0,折一纸鸢;Hj,冰焰铭心",["破碎岭"] = "H0,爱回家;Hs,Turbowarrior;Hi,原味蛋挞",["亚雷戈斯"] = "H0,轩辕剑客",["神圣之歌"] = "H0,柯宇娃娃;Hq,自闭了;Hn,墨一兮",["埃霍恩"] = "Hz,喜乐",["迅捷微风"] = "Hz,斗鱼丶乌苏白;Hr,月刊少女",["泰拉尔"] = "Hy,儿歌丶三百首",["古尔丹"] = "Hy,消遣无奈",["金色平原"] = "Hy,老熊饼干;Hx,杭州吴彦祖",["霍格"] = "Hx,早餐两块半;Hh,汤圆儿",["奈法利安"] = "Hx,面朝错误方向",["鲜血熔炉"] = "Hx,五河琴里;Hq,泉此方",["萨菲隆"] = "Hw,十七笔画",["藏宝海湾"] = "Hw,逝水阵云昏",["克洛玛古斯"] = "Hw,光芒冷酷;Hs,Andante;Hl,Dynasty",["玛里苟斯"] = "Hu,竹林晨曦",["晴日峰（江苏）"] = "Hu,敏敏丶特穆尔",["踏梦者"] = "Hu,空车侠",["凯恩血蹄"] = "Hu,柒七",["纳克萨玛斯"] = "Hu,真的还可以",["洛萨"] = "Hu,Momark",["洛丹伦"] = "Hu,上偙",["哈卡"] = "Hu,李老八骗婚",["亡语者"] = "Ht,趙子龍灬",["斩魔者"] = "Ht,花臂乄",["鬼雾峰"] = "Hs,邦桑丷德",["狂风峭壁"] = "Hs,星月妖妖",["天谴之门"] = "Hs,狂派",["艾莫莉丝"] = "Hs,千年",["加基森"] = "Hr,二十二岁的枫;Hi,莲生三十二丶",["达纳斯"] = "Hq,野獸仙貝",["霜狼"] = "Hq,清酒桑",["红龙女王"] = "Hq,丝茉茉丶",["燃烧军团"] = "Hq,菠萝",["地狱之石"] = "Hq,虚空女帝;Ho,晓夜一黑色",["安威玛尔"] = "Hp,布鲁斯塔",["耳语海岸"] = "Hp,喜玛拉雅之剑",["伊莫塔尔"] = "Hp,丿脾气火爆",["日落沼泽"] = "Hp,哈登",["丽丽（四川）"] = "Hp,言诗沐雨,奶大腰細;Hi,南柯一夢;Hg,惡魔之怒",["梅尔加尼"] = "Hp,丛儿飞",["蜘蛛王国"] = "Hp,糖加三勺;Hl,浪漫豆豆;Hj,伊沐雪一光羽",["符文图腾"] = "Hp,山哥信佛啦丶",["加里索斯"] = "Hp,法克丶",["丹莫德"] = "Ho,灬忆往昔灬,一葉知秋",["达基萨斯"] = "Ho,Rafael",["伊兰尼库斯"] = "Hn,Constans",["红龙军团"] = "Hn,兰斯洛大帝;Hh,摸骨大师",["瓦里安"] = "Hn,索林燃须",["弗塞雷迦"] = "Hm,Fallingangel",["银月"] = "Hm,话事人",["诺兹多姆"] = "Hl,桥归桥路归路;Hi,铁血刑警",["索瑞森"] = "Hl,小咕奶奶",["雷斧堡垒"] = "Hl,帅气黑皮",["织亡者"] = "Hk,噩夢丶",["伊利丹"] = "Hj,菊部东南风",["银松森林"] = "Hj,随缘木木;Hg,随缘烟雨",["阿克蒙德"] = "Hi,四海承风",["暗影之月"] = "Hg,火儛丶",["甜水绿洲"] = "Hg,膏锋锷",["轻风之语"] = "Hg,Cykablyat",["龙骨平原"] = "Hg,罪域的骨丶"};
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