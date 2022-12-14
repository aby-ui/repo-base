local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["燃烧之刃"] = "cz,Hellcasterr;cx,醉紅顏,醉小术,秦柚子;cs,莫凌天丶,丨远坂丶凛丨;cq,凡间角落;cm,褚橙;ch,爱喝红牛,乄小兽;ce,Gokssakuray,鈴羽;cd,果粒鲜橙多;cb,刀锋霸王,Ezechiel;cZ,以恩护之名;cY,老白白不白;cX,超只因熊;cV,搞丝搞污,狸花猫某某;cU,兔兔崽子;cQ,小大不溜;cJ,不是那种劣人",["金色平原"] = "cy,空城烟沙;cv,敏宝贝;cc,快来救救我;cb,暴走痞子;ca,洛朗;cO,伊諾;cM,杰哥不要辣",["贫瘠之地"] = "cy,结城结;cl,一只小青虫;cj,冬羽;cZ,丿丶叶子;cY,瑾歆,湖中之月;cX,手残丶老戦士;cO,花神月;cK,淡淡的思恋;cJ,初冬之烬",["死亡之翼"] = "cy,关从戈;cv,牛德很嗯哼;cu,Unmerce;co,Tacodeathkin,白桃丶奶糖;cl,戮歌;cj,洒娇,爱吃獣人;ch,希望与绝望间;cb,骄王轻花慢酒,瓦迪;ca,垣琻,晞黎,法号丶丘处鸡,秀米;cY,肥妮克斯,含辛茹苦的爹;cX,魂归暮夕处丶,夜风如歌;cW,摇摇兔耳朵;cV,威猫;cT,咩咩灭了腻;cR,法号丶幺鸡;cO,诗忆丶;cL,Parade;cK,灬侠丨岚灬,灯笼果好酸;cJ,丨龙血炮手丨;cI,丨叉烧丨;cH,跟驴去了远方,柿柿迷路啦",["白银之手"] = "cx,辻堂葵;cv,月夜灵晶;ct,撒旦的大表哥,Bumblebean;cs,Montysoul;cr,十点三十分,中医调系理;cq,水很咸;cp,丶托蒂,奧雷俐亚;cn,疯不觉丨;cm,放逐之翼,Bedaiahyang;cl,一夜灵一,消逝的容颜;ci,风月无心,萌萌的法爷;ch,地瓜;cg,卡萨诺个;cb,猪中的神,冰心悦;ca,Oys,Sumuwa;cZ,狂徒无畏;cY,白狼丨傑洛特,Melissayang,甜味小橘猫,爱猫;cX,香酥脆骨饭,戰鬥暴龍獸,白牧之,Zmyy,最牛的牛人;cW,叀心,黎龍;cT,奶凶的小花,浩劫橙说,妙语,妙鸾;cS,恶魔之王守护,大强丶雄起;cR,小演員;cQ,丨鵼丨;cP,彳亍禾呈石马,雯浩灬宝宝;cO,雯浩宝宝,杀气正浓;cM,丶逝水流年,花小木;cL,旅店老板贝蒂,氫橘;cK,学院派草莓",["世界之树"] = "cx,王思聪",["罗宁"] = "cx,星灬尘灬;cu,嗝屁的浪味仙;cq,骚不为,愚鸠;cn,狩猎女人心;cm,Freedy,风花苑;cf,疯狼狙婿;ce,拒绝魚;ca,苍青;cX,缃叶;cO,中年的樵夫;cN,南夜;cM,Redmu;cL,亖零亖,瞬风丶术,易訫",["丽丽（四川）"] = "cx,城南花已开丶;ci,山崩;cb,天龍人;cZ,守护之魂",["凤凰之神"] = "cx,黄龙仙;cu,冰过的饮料;ct,正义大魔王;cq,我是真的很皮;cp,洗澡泡;co,丶陌兮;cn,泡酱大魔神;cj,翎羽汐幻;ci,皮老神棍,迷人斩;cg,苏妗;ce,琼冉丶,华冉丶,霜冉丶,花销魂妥协,三千繁华丶,思冉丶,三千思冉丶;ca,幽默泡泡;cZ,朴召妍;cY,她的睫毛弯,挪威脊背龙,灬丨卡特丨灬,灬威慑灬,火灬龙果;cX,渊寒,艾诶诶,凨暴;cW,八块腹肌喵,水火不倒翁,淡你个定;cU,丶风影,张燕;cT,史布拉咕;cS,赵泽佑丶,清如許;cR,蕾丝姐姐;cO,八一星;cN,Acanknight;cL,楠胖胖丶;cK,墨洺棋妙;cI,Glouocdk",["血色十字军"] = "cx,吝啬鬼团团;cu,鹌鹑;cf,村头一朵小花;cY,九弓的执命;cU,林深有鹿为梦;cR,Hshaman;cM,从来都不乖;cJ,Aveen;cH,杏遇墙",["霜狼"] = "cx,卡尔丶血蹄",["石锤"] = "cw,沧灬桑;cj,校长请留步",["冰风岗"] = "cw,棒棒糖送你;cd,起名太难了,利爪;cc,盜贼姑娘",["影之哀伤"] = "cw,路灯王;cp,Lexusls;co,大佬祺;cn,霸气的小老虎;ci,摩多罗隐岐奈,射击丶;cc,都清醒都独立;ca,真的遭不住啊;cY,木头人儿,Nihiliity;cX,風丨騷;cT,丷沉沙丷;cS,这把能限时,杨二车妠姆;cN,琻甲银枪",["石爪峰"] = "cv,丿陌丶小默艹",["克尔苏加德"] = "cv,苏打老干菜;cr,提里奥丶弗丁;cp,雷庭崖地头蛇;cV,铺盖面",["巴尔古恩"] = "cv,纳一束月光",["???"] = "cu,红手恰饭饭;cn,行澐",["无尽之海"] = "cu,丨沐沐;cs,丶逮虾户;co,Tiaralcrazy;cl,给撸给亲亲;cc,管杀又管埋;cX,心在淌着血;cQ,心橙;cK,考焦小松饼",["主宰之剑"] = "cu,鹿玥溪;cr,空気;co,騎蚊子闖天下;cn,哥哥霏;cj,冯蜜桃;cc,魂逝;ca,Artilla,圣路独行;cZ,五玥天;cY,妄音音;cO,不秀就要死;cI,寶旎",["伊森利恩"] = "ct,吢丕丶;cp,为了蛋总;cl,大猫带小猫;cj,白灼西兰花;cd,宋乖乖;cb,凉月武士;cX,安纯丶;cT,試着嶶笑;cS,请叫我大胸妹;cK,一猩四射;cJ,小刀锋利;cH,曾志伟丿",["安苏"] = "ct,啦莱耶;cp,小狐狸哇;cj,安娜丽丝怒风;ci,门将军;cd,暗黑丶哈士奇;ca,东方明月;cY,摸鱼地阿昆达,元烛;cX,凱旋在子夜;cV,牪仔,夏日甜沙;cT,恶魔丶訫;cN,夏二萨,二十;cM,亲爱的亲爱的;cL,汉字序顺;cK,追梦;cI,风摇白露;cH,万古第一狂神",["卡德加"] = "ct,冰宇爱;ch,李达康书记",["加基森"] = "ct,艾利桑德;cY,拾舟;cM,佑佑爸爸",["壁炉谷"] = "cs,八云紫;cX,阿林林织围巾",["拉文凯斯"] = "cr,名字被起了",["刺骨利刃"] = "cr,魅影無極",["阿克蒙德"] = "cq,電台司令;cp,毒刺骨;cO,Witas",["铜龙军团"] = "cq,空白猎",["艾露恩"] = "cq,剑元;cf,乐小鱼",["回音山"] = "cp,艾尔萨斯国王;co,咖啡大人;cl,梁小欠;cj,谢怜啊;ci,铅笔画;ch,小呆立;cX,水月;cI,苍云归来",["灰谷"] = "cp,只愛喝雪碧;cX,Karkinos",["格瑞姆巴托"] = "cp,四碗起司;cj,半糖芝士葡萄,半糖杨枝甘露;cb,祖龙神;cZ,长弓一梦;cY,违章動物,灬心好疼,小鹿甜心丶,银月城的风语;cX,番茄炒皮蛋,卧底城管;cV,丶艹莓;cQ,地狱火萨满;cN,尛洲,糖醋溜丸,袁崇焕;cL,萌面怪兽;cI,花开月圆;cH,限失真,铜铁锤",["轻风之语"] = "cp,涅罗;co,蛮王布尔凯索",["梅尔加尼"] = "co,Ellen",["血环"] = "co,虎虎酱;cj,迷恋丶夏天;cb,芬妮娅提香",["麦迪文"] = "co,三代目;ce,Withoutwings;cH,敲蛋砖家",["熔火之心"] = "co,一叶之修;ce,嘤嘤怪阿糖;cJ,孤独予戈",["菲米丝"] = "co,仝泽",["翡翠梦境"] = "cn,蝴蝶谷灬缱绻;cj,雪月蝶;cY,萨拉赫丁致",["达尔坎"] = "cn,火火光光军",["破碎岭"] = "cm,迷茫的红龙;cl,魔渊;cW,雨竹轻飘",["狂热之刃"] = "cm,皮咔丘;cJ,猪狂",["阿格拉玛"] = "cm,Penny",["桑德兰"] = "cm,阴阳不测;cY,飘逸的名子",["朵丹尼尔"] = "cm,殇丶千羽",["遗忘海岸"] = "cm,混帐的天空;cR,十里坡废痨",["阿纳克洛斯"] = "cm,艾兹多姆;cl,浪味儿鲜;ch,管城吴彦祖;ca,谈笑者稻花香",["自由之风"] = "cl,哈根达斯",["伊利丹"] = "cl,黑桃丶枪;cc,钟欣潼",["布兰卡德"] = "cj,梦魇污染;cZ,压到头发了;cY,冰火五重天;cP,Fait;cN,熙成则灵;cI,夏了夏天",["弗塞雷迦"] = "cj,榜一大哥",["燃烧军团"] = "cj,牡丹",["卡拉赞"] = "cj,隐秘之刃",["地狱之石"] = "ci,死海文书;cU,片尾曲",["霜之哀伤"] = "ci,沧浪亭;ch,椰风;cY,阿拉小德,Davidwarrior;cX,剑与棉花糖,Icecross;cH,钓鱼大哥请留名",["冰霜之刃"] = "ci,妖怪闪灵,落成雪",["米奈希尔"] = "ci,雨轩;cX,恶魔小班长",["布鲁塔卢斯"] = "ch,花石头",["国王之谷"] = "ch,Quovadis;cY,小宇小牧;cX,美瑜子,战斗矿骡,希尔里维斯",["圣火神殿"] = "cg,寂灭者阿古斯",["黑龙军团"] = "cg,江厦厦;cX,锅巴不淘气",["冬拥湖"] = "cf,一葉輕舟",["索瑞森"] = "cf,悟空大师",["勇士岛"] = "ce,烛龙",["冰風崗哨[TW]"] = "ce,圣光龍龍",["托尔巴拉德"] = "ce,随风飘荡的云",["埃克索图斯"] = "cd,哈斯笨德",["熵魔"] = "cb,最帅的射手",["奈法利安"] = "ca,斯崔克",["黑锋哨站"] = "ca,死判丶吉宇",["月光林地"] = "ca,最嚣张的兔子;cW,歹毒绵羊",["鬼雾峰"] = "ca,再见的彼方;cX,愤怒的阿狸",["耐奥祖"] = "ca,随心随缘",["红云台地"] = "ca,娜塔丽波特曼;cS,Balthazar;cR,天启的回响",["萨尔"] = "cZ,Loaiax",["洛丹伦"] = "cZ,雪谷幽兰",["海克泰尔"] = "cZ,汉子;cR,龙展颜",["黑铁"] = "cZ,侦探雷伊;cL,酸酸寿司侠",["伊瑟拉"] = "cY,Darthvadar",["雷霆号角"] = "cY,云小星",["奥尔加隆"] = "cY,战歌风暴",["龙骨平原"] = "cY,Kinoheart",["玛里苟斯"] = "cY,希优顿的信念;cO,知柏地黄丸",["迦拉克隆"] = "cY,安全着陆,红粉毛毛兔;cX,拓了个海,斗魂骇客丶;cW,圣光制裁使;cQ,冒泡泡咕噜,我系渣渣辉",["末日行者"] = "cY,云中游,徳依依;cX,伊朵,Defendsmile,撒旦寒;cL,兰藉",["埃德萨拉"] = "cY,敬之;cX,灬戏吇丶",["埃雷达尔"] = "cY,莉娅娜",["山丘之王"] = "cY,Melusine",["月神殿"] = "cY,精灵依依",["末日祷告祭坛"] = "cX,Noxious",["库德兰"] = "cX,火舞双瞳",["塞拉摩"] = "cX,小十七",["瑞文戴尔"] = "cX,至爱凡舒",["恐怖图腾"] = "cX,小潘",["迅捷微风"] = "cX,没什么心情",["凯尔萨斯"] = "cX,樱花的情人",["阿拉希"] = "cX,念奴娇",["克苏恩"] = "cX,闲牛勿扰",["莱索恩"] = "cX,爱神",["恶魔之魂"] = "cW,蓝色外套",["符文图腾"] = "cV,放开那群太婆",["瓦拉斯塔兹"] = "cU,Chinamobile",["阿斯塔洛"] = "cU,彡弟",["燃烧平原"] = "cU,咖喱牛腩饭;cL,自由自在點",["阿比迪斯"] = "cT,土豆小布丁",["德拉诺"] = "cT,墨殇",["希雷诺斯"] = "cS,第一章第一页",["迦玛兰"] = "cR,爱上咖啡涩;cK,释星魂",["巫妖之王"] = "cR,沦落人",["亡语者"] = "cQ,丿流氓咕咕",["安东尼达斯"] = "cQ,冰丶夏",["摩摩尔"] = "cQ,若晨",["晴日峰（江苏）"] = "cP,一只巨熊",["夏维安"] = "cO,瑟银矿石;cN,Nsydlts,将军夜引弓",["红龙军团"] = "cO,传奇猎手",["火焰之树"] = "cO,斯人如逝",["加尔"] = "cM,赐我一场好梦",["洛萨"] = "cM,阿明血蹄",["阿迦玛甘"] = "cL,仙紫",["熊猫酒仙"] = "cL,开溜",["基尔罗格"] = "cL,世情薄人情恶",["艾莫莉丝"] = "cI,天地哥",["拉格纳罗斯"] = "cI,Revolutionx",["血吼"] = "cH,莫里莫西",["海达希亚"] = "cH,特和",["幽暗沼泽"] = "cH,木牧木"};
local lastDonators = "卡尔丶血蹄-霜狼,吝啬鬼团团-血色十字军,秦柚子-燃烧之刃,黄龙仙-凤凰之神,城南花已开丶-丽丽（四川）,星灬尘灬-罗宁,醉小术-燃烧之刃,醉紅顏-燃烧之刃,王思聪-世界之树,辻堂葵-白银之手,关从戈-死亡之翼,结城结-贫瘠之地,空城烟沙-金色平原,Hellcasterr-燃烧之刃";
local start, now = { year = 2018, month = 8, day = 3, hour = 7, min = 0, sec = 0 }, time()
local afdianDonators = "西格尼修斯-死亡之翼,小李哥儿-白银之手,陨落叉子-伊森利恩,寂寞的电灯泡-阿斯塔洛,勇敢的大牛牛-贫瘠之地,雨中年华-死亡之翼,橘陽菜-白银之手,牧之韵-血色十字军,桃之小妖妖-克尔苏加德,默无情-玛利苟斯,简繁-斗鱼,Kyrielight-憤怒使者,菲特菲菲酱-奥特兰克,圣骑筱胖鱼-熊猫酒仙,夜灬瞳-熊猫酒仙,蜜丨薯-白银之手,無心射鷄-白银之手,战五渣酱油-罗宁,牛丷逼-凤凰之神,戰灬戰丶戰罒-燃烧之刃,浅井舞香-凤凰之神,导演丶-冰风岗,蓝白碗-死亡之翼"
local afdianRecent, afdianRecentNum = "西格尼修斯-死亡之翼", 0
local player_shown = {}
U1Donators.players = player_shown
U1Donators.cell = U1.cellPatrons or {}

function U1GetDonatorTitles(fullname, onlyone)
    if not fullname then return end
    local aby = U1STAFF and U1STAFF[fullname]
    if not aby then
        aby = U1Donators.players[fullname]
        if aby then aby = "爱不易" .. (aby > 0 and "" or "") .. "捐助者" end
    else
        return aby --特别title就不用其他捐助信息了
    end
    local cell = U1Donators.cell[fullname] and "Cell插件捐助者"
    if onlyone then
        return aby or cell --仅观察界面用，性能OK
    else
        return aby, cell
    end
end

function U1IsDonator(fullname)
    if not fullname then return end
    return (U1STAFF and U1STAFF[fullname]) or (U1Donators and U1Donators.players[fullname]) or (U1Donators and U1Donators.cell[fullname])
end

local topNamesOrder = {} for i, name in ipairs({ strsplit(',', topNames) }) do topNamesOrder[name] = 5000 + i end
local lastNamesOrder = {}
for i, name in ipairs({ strsplit(',', afdianDonators) }) do if name == afdianRecent then afdianRecentNum = i-1 break end lastNamesOrder[name] = i end
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
        if fullname and U1IsDonator(fullname) then
            msg = msg:sub(1,h-1) .. part1 .. '\124TInterface\\AddOns\\!!!163UI!!!\\Textures\\UI2-logo-small:' .. (13) .. '\124t' .. part2 .. msg:sub(t+1);
        end
        origs[self](self, msg, ...)
    end
    WithAllAndFutureChatFrames(function(cf)
        if cf:GetID() == 2 then return end
        origs[cf] = cf.AddMessage
        cf.AddMessage = addMessageReplace
    end)
    return "remove"
end)