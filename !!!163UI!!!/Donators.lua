local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["凤凰之神"] = "V5,卫神,不聞不問,啵啵灬小奶嘴;V3,Sorrycooker,阿僖;V1,出生入死骑;V0,没了呀妹妹,超级征服者;Vx,诸葛丶村夫;Vv,林楚儿,辛巴达重山,欧暮暮;Vr,景依维;Vq,双龍天昇剣;Vo,零落的殇,丶北极光丶,Lonergan;Vn,丶浮游;Vm,Horseshoe,双剑合璧;Vl,雪白丨血红,休克;Vk,消失的漫画家;Vi,米米狂乱,狗头萨;Vg,无糖的甜可乐;Vf,天涯觅青鸾,焦嘦嘦,于子酱,小猪佩鱼丷;Ve,自然醒吧,鸣剑;Vd,背影余晖,谜灬失,尤川丶蚩梦,丶对钱没情趣,夜半月听风;Vc,槐琥,阳顶顶丶,拿枪的老牛,熊卟贰,风寂笑,火龙果冻,愤怒毛驴;VY,南京扣德普雷,伊斯嗒娜;VX,超烦之萌",["贫瘠之地"] = "V5,梆硬迪;V3,兰州牛肉大王,红烧牛肉拌面;V1,大领主维拉;V0,卡妙;Vz,幽遊白书丶;Vx,阿宝呀丶;Vu,紫狱黑殇;Vr,迪亚布罗;Vq,幽游白书丶;Vo,野猫满;Vg,血红辣椒;Vf,狂魔㐅乱舞;Vd,珊瑚海;Vc,余悸,Avicii;Vb,丶毒;VZ,风起寒秋",["影之哀伤"] = "V5,拂晓;V4,牛肉板缅;V2,着魔的咕咕;Vz,犇犇丿熊猫战;Vx,是阿牛啊;Vv,小熊果冻;Vp,战斗训练假人;Vm,箭追魂;Vi,天之梦幻;Vg,丨晓旭丨,肉不够骨头凑;Vf,狂躁方向盘;Ve,沾血的黃瓜;Vc,天秀阁;VW,繧儱兄",["白银之手"] = "V5,萌葱双马尾,青丝任風绾;V3,蓝迦;Vv,麦卡伦的春天;Vr,百香果冰沙,多多队长;Vq,艾星恶势力丶;Vo,Sniperkennys,圣洁重生,契约飞飞,死神小小妹;Vl,Ninesixmage,我要自然醒,丨浣熊丨;Vk,您说的对;Vj,丷不二丷;Vg,畚瓟旳蝸犇,奥蕾莉亚公爵;Vf,血腥战歌,云中寄雨;Ve,彼麦凯蒂丶,Shanbaby,冰冰水冰;Vd,小小心脏,Ntmdjjww,壹贱定天下;Vc,封尘絕念斬;VY,小喵弯月;VV,老板来碗凉面,叶奈法的玩具",["觅心者"] = "V5,小瑾然",["死亡之翼"] = "V5,葱葱橘猫,天然呆小柠檬,小五同学;V3,就喜欢玩偶姐;V1,欧小熙,陆眼,哎呀被发现了;V0,脆脆鲨好吃;Vx,悦曦;Vt,仲夏夜之禁;Vr,安妮可姬;Vq,就喜欢瞎李姐,高先生丶;Vm,野猪大王;Vl,清水泓清,天天喝枸杞;Vj,Berryzl;Vh,谢幕挽歌,昱焱小红手,嘻嘻西茶;Vg,仲夏夜之术,残魂断枫桥,六十八;Vf,拒绝我都被绿,Jeromecc;Vd,杨扬采,仙晨之灵,Lixm;Vc,醉后,老淦部,梦幻彤凡;Vb,发飙的天牛;Va,夜阑听雨丶;VZ,刃命,没教养的瘤;VW,莽斧,南宫仆射灬,梦醒九分丶,油油的小绿皮",["战歌"] = "V4,我爱丁丁宁",["布兰卡德"] = "V4,Singlecase;V0,薯条可乐;Vw,丶涼風丶;Vv,我要射咯;Vr,萨洛多斯;Vq,南无阿彌陀佛;Vm,莫莫小可爱;VX,玛法里奧怒风",["熊猫酒仙"] = "V4,宁棒棒;Vq,偶尔有点殇;Vn,小黄瓶;Vj,三土兄;Vc,尹力平;VY,泰澜德灬小鬼",["血环"] = "V4,Yovanna",["???"] = "V3,乂呲奶大师乂;Vv,糖陀螺",["晴日峰（江苏）"] = "V3,兜兜丶狠骚",["洛肯"] = "V3,九队牧;Vg,Dklinjiang;Vc,猫哥",["血色十字军"] = "V3,鬼头桃菜丷;V1,波丶波;V0,昨夜书,倪华丶;Vq,不吃烧烤;Vo,灬追云灬;Vi,马拉喀什;Vh,超级小花花;Vd,世间大雨滂沱;Vc,Lacampanella;VW,赦免",["耳语海岸"] = "V2,瓶中自在天",["燃烧之刃"] = "V2,天蜀黍,徐愿;Vx,寒灬欲;Vv,脚毛随风飘丶,射天狼西北望;Vq,Miyadad;Vp,锋飘舞,超级攻强卷轴;Vo,如果我有轻功;Vn,毛德,静香海王;Vm,香犇犇,冰淇淋牛排;Vf,始终怀念;Ve,议事厅哭强战,黄黄皇帝;Vd,尛噩夢,大奶猴也算猴;Vc,辛多雷强哥,霜火挽歌丶;VV,闪开我要装逼",["安苏"] = "V2,爆炸即艺术;Vx,云鬼叱,刹雫;Vv,皮皮猪的粉;Vu,妙哇;Vo,小汤姆哈迪;Vn,墨鱼丸粗面丶;Vl,Decemberm;Vj,韮菜;Vg,童话里的王子;Vf,南吕五日;Ve,丨我很纯洁丶,至尊丶牛犊子;Vd,林楚儿,马大漂亮;Vc,嗨尼玛嘴硬,英雄出少女;VY,猫耳娘丶",["克尔苏加德"] = "V2,孤城丶;Vn,不破眠虫;Vl,盛夏娇杨丶;Vc,凛冬怒吼;VX,丶天师傅",["主宰之剑"] = "V1,肥胖的胖子;Vt,猎神小萌主;Vo,亢慕义斋;Vm,黑凤梨呀;Ve,暗殺星;Vd,冰煌血舞;Vc,球丶;VY,Orionsuio,终焉恩赐,梦里是谁,冯珍珠;VX,娜依秀美;VW,Sicklikeme",["艾露恩"] = "V1,弗萊婭",["加基森"] = "V0,Blackadder;Vw,第二个我",["伊森利恩"] = "V0,蓝山;Vx,瑶岚;Vv,人间百味;Vu,由月与地;Vs,傀儡之匣,萌丶小伊;Vr,逍遥冷寒刹,小丸子呀;Vp,启源之叟;Vo,小黑瓦娜斯,Orcshaman;Vn,腐质之瓶;Vm,君乐宝;Vl,跋依抛污;Vh,辞忧,習慣隠身;Vg,黑色信封;Vf,桃溪春野;Vd,小小波哥丶;Vb,机智的大叔;Va,执笔绘苍穹;VX,冷月丨",["国王之谷"] = "Vz,終極閃光;Vr,布丁甜甜;Vi,夏川真凉丶;Vf,留痕;Vc,一凤;Va,战士雍杰大叔;VZ,仲长胤",["格瑞姆巴托"] = "Vz,丶维达;Vt,血落丷凝寒霜,月落丷霜满天,醉舞丷影霓裳;Vs,山青丷花欲燃;Vr,肥龙丶在天;Vq,丨北笙丶,丨秋月无边丶;Vp,刘兮兮;Vj,信号旗;Vh,加肥猫猫,冷艳的暧昧;Vf,琴断弦难断;VY,Aoekaizibao,狂派丨迷乱",["永恒之井"] = "Vz,周王畿",["伊萨里奥斯"] = "Vz,霹雳雷霆",["迅捷微风"] = "Vx,绝望的鸟,谢顶的阿昆达;Vn,达瓦里氏丶",["冰风岗"] = "Vx,夜不深不睡;Vw,Elimination;Vh,残丷雪;Vg,我叫匕杀大;Ve,萌萌哒滴萌萌;Vc,天选之子,月玄孤心;Va,洗尽凡间铅华;VV,哆啦比梦",["丽丽（四川）"] = "Vx,尥一蹶子;Vv,丶脉动回来;Vk,丶曰天;Vh,你艾希我奶妈;Vd,烈火战歌丶",["无尽之海"] = "Vx,想飞怕摔;Vw,晨夕;Vv,奶残;Vp,晨丷兮;Vo,Zizioiui;Vj,獨壹無貳;Vf,犇頭德撸衣;Vb,Rossoneris;VZ,带带丶;VW,牧云",["罗宁"] = "Vw,灬無名灬;Vv,滚刀肉球;Vq,蹿吧兔孙,崎涟出云;Vp,小小的小浣熊;Vl,黄油蟹蟹,魔龙,海叶灬;Vg,青夏瑶,暗殺星乄;Vf,墨华,盞茶作酒;Vd,伊利瑟维斯;VZ,川西北大拿;VV,雅詩",["试炼之环"] = "Vv,日部落姐姐",["伊利丹"] = "Vv,树屿牧歌",["暗影迷宫"] = "Vu,荇菜流之;Vd,带带大天启",["回音山"] = "Vu,百兽领主;Vt,肆月筱战乄;Vl,魔抗孩;Vh,叁嗣叁",["石爪峰"] = "Vt,摩可拿",["麦迪文"] = "Vt,星星泡饭",["月光林地"] = "Vt,雪伦;Vp,花媚玉堂人;Ve,白兔软糖",["迦拉克隆"] = "Vt,远方的宁静;Vg,银月星魂;Ve,二叔灬",["艾萨拉"] = "Vs,玄冰塞弗斯,玄冰佐佑",["艾莫莉丝"] = "Vs,正太爱卖萌;Vl,性感小野猫",["日落沼泽"] = "Vs,術心;Vd,眼棱瞎了眼丶",["克洛玛古斯"] = "Vr,来杯拉菲",["破碎岭"] = "Vr,月丫;Vd,那一抹深蓝色",["麦姆"] = "Vr,尛乄射天狼",["达尔坎"] = "Vq,阿萨德发啊",["地狱之石"] = "Vq,江湖夜雨",["阿迦玛甘"] = "Vq,曾经的记忆",["加里索斯"] = "Vq,心有琉璃",["神圣之歌"] = "Vq,Luthien;Vk,部落两大傻;Vc,幽幽小生",["萨菲隆"] = "Vq,筱丹",["利刃之拳"] = "Vp,非常爷们;Ve,透明凝清",["石锤"] = "Vo,Alive",["阿纳克洛斯"] = "Vo,残垣立旧篷丶;Vm,残垣立旧篷;VY,棺材板踏浪者",["兰娜瑟尔"] = "Vn,世界之树",["冰霜之刃"] = "Vn,正则灵均",["守护之剑"] = "Vn,笑书神侠;Vk,情流感",["海克泰尔"] = "Vn,傑米蘭尼斯特;Vf,林深鹿幽鸣;Vc,机智的大叔",["塞拉摩"] = "Vn,曾经依旧;VX,慕冬",["尘风峡谷"] = "Vl,不扰清梦,醉梦独舞",["瑟莱德丝"] = "Vl,懒癌晚期凉凉",["泰兰德"] = "Vl,包子系马达;Vb,Minikiki",["普罗德摩"] = "Vl,丨影刃丨",["阿克蒙德"] = "Vk,睡衣",["玛诺洛斯"] = "Vk,茉莉冰冰",["斩魔者"] = "Vk,圣光之力丿",["银松森林"] = "Vk,混沌小小",["蜘蛛王国"] = "Vk,Johnnyr",["翡翠梦境"] = "Vj,Pala",["符文图腾"] = "Vj,嘟嘟",["白骨荒野"] = "Vj,永恒之夜",["埃德萨拉"] = "Vi,橘昕大欧皇;Vg,不萌不萌啦;Vd,萨绝人寰",["德拉诺"] = "Vi,幼儿园大王",["狂热之刃"] = "Vh,孤独伊枫丶",["时光之穴"] = "Vh,花伦同学",["凯恩血蹄"] = "Vh,美女;Vc,易拉罐;VV,丶我不奶",["卡德加"] = "Vh,江湖传奇",["深渊之喉"] = "Vh,动感光波",["图拉扬"] = "Vh,子雨山",["末日行者"] = "Vg,Komms,不斷;Vd,隐匿的气息,皮塞船;Vc,坠落战神;Va,Shallnotpass",["万色星辰"] = "Vg,尤丨迪安",["拉文凯斯"] = "Vg,青烟雨;Vc,小村镇的吻",["金色平原"] = "Vg,泥头车撞太郎;Vc,遇见北极星",["霜之哀伤"] = "Vg,等待终成遗憾;Vf,卡其布诺灬;Vd,青年蜀黍",["伊莫塔尔"] = "Vf,舒预言",["血牙魔王"] = "Vf,Mojiedjlr;Vc,七叶一枝花妖",["普瑞斯托"] = "Vf,一念丹香",["诺森德"] = "Vf,无限正义",["冰川之拳"] = "Vf,寶貝卟哭",["阿古斯"] = "Vf,贺豪豪",["巨龙之吼"] = "Vf,馮巩老師丶",["奥妮克希亚"] = "Ve,伽罗丶六道",["寒冰皇冠"] = "Ve,牛克蒙德",["自由之风"] = "Ve,黑枸杞",["风行者"] = "Ve,蔡萌萌",["泰拉尔"] = "Ve,弋影",["索瑞森"] = "Ve,飘渺天下",["安戈洛"] = "Vd,动物园牛总",["恶魔之魂"] = "Vd,破坏者血雨",["暴风祭坛"] = "Vd,Èèsp",["幽暗沼泽"] = "Vd,万嗜唔忧",["耐普图隆"] = "Vd,小豆先生",["世界之树"] = "Vd,死亡深度",["银月"] = "Vd,风雪夜归人",["天空之墙"] = "Vc,依楼丶听雨",["巫妖之王"] = "Vc,剑出烛影随",["鬼雾峰"] = "Vc,Relieved;Va,卟忘丶初心",["嚎风峡湾"] = "Vc,俄里翁",["洛丹伦"] = "Vc,犇啵霸",["轻风之语"] = "Vb,天选之子",["希雷诺斯"] = "VZ,洛城时光灬",["龙骨平原"] = "VX,小手很凉",["地狱咆哮"] = "VW,呱二蛋",["格雷迈恩"] = "VW,Statet",["大地之怒"] = "VV,灬浮竹灬",["诺兹多姆"] = "VV,少年出大荒"};
local lastDonators = "悦曦-死亡之翼,刹雫-安苏,是阿牛啊-影之哀伤,想飞怕摔-无尽之海,寒灬欲-燃烧之刃,云鬼叱-安苏,尥一蹶子-丽丽（四川）,谢顶的阿昆达-迅捷微风,夜不深不睡-冰风岗,绝望的鸟-迅捷微风,阿宝呀丶-贫瘠之地,诸葛丶村夫-凤凰之神,幽遊白书丶-贫瘠之地,霹雳雷霆-伊萨里奥斯,犇犇丿熊猫战-影之哀伤,周王畿-永恒之井,丶维达-格瑞姆巴托,終極閃光-国王之谷,蓝山-伊森利恩,倪华丶-血色十字军,超级征服者-凤凰之神,昨夜书-血色十字军,没了呀妹妹-凤凰之神,脆脆鲨好吃-死亡之翼,Blackadder-加基森,薯条可乐-布兰卡德,卡妙-贫瘠之地,波丶波-血色十字军,弗萊婭-艾露恩,哎呀被发现了-死亡之翼,肥胖的胖子-主宰之剑,出生入死骑-凤凰之神,陆眼-死亡之翼,大领主维拉-贫瘠之地,欧小熙-死亡之翼,孤城丶-克尔苏加德,爆炸即艺术-安苏,着魔的咕咕-影之哀伤,徐愿-燃烧之刃,天蜀黍-燃烧之刃,瓶中自在天-耳语海岸,鬼头桃菜丷-血色十字军,九队牧-洛肯,红烧牛肉拌面-贫瘠之地,兰州牛肉大王-贫瘠之地,兜兜丶狠骚-晴日峰（江苏）,乂呲奶大师乂-???,蓝迦-白银之手,阿僖-凤凰之神,Sorrycooker-凤凰之神,就喜欢玩偶姐-死亡之翼,Yovanna-血环,牛肉板缅-影之哀伤,宁棒棒-熊猫酒仙,Singlecase-布兰卡德,我爱丁丁宁-战歌,小五同学-死亡之翼,青丝任風绾-白银之手,天然呆小柠檬-死亡之翼,葱葱橘猫-死亡之翼,小瑾然-觅心者,啵啵灬小奶嘴-凤凰之神,不聞不問-凤凰之神,萌葱双马尾-白银之手,拂晓-影之哀伤,梆硬迪-贫瘠之地,卫神-凤凰之神";
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