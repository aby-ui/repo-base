local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,不含防腐剂-诺森德,大江江米库-雷霆之王,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔,落落萧萧-罗宁,圣子道-回音山,不嗔-迦拉克隆,奎托斯丶奎爷-白银之手,荼麟、濤-贫瘠之地,Bloodtd-死亡之翼,Darkage-洛丹伦,轩辕银月-雷克萨,我的夜茉莉-法拉希姆";
local recentDonators = {["国王之谷"] = "D/,发糖啦孩子们;D+,蓝染川,喵乌王;D9,天毅;D7,丶血舞天;D6,就是你韦小宝,麦芽的香气;D4,缱绻的馥郁,那一抹晚霞,木木的术;D3,我不眨眼,古早味花生汤",["影之哀伤"] = "D/,跪斗丶;D+,才不怕你呢,何不二丶;D9,叼根烟丶;D7,睫毛彎彎;D5,港岛哥哥灬,Leyoyo,小半夏,小小半夏;D4,隔壁旳泰山,恐山安娜,Panwoo;D3,丿、圣诞,坑队友",["芬里斯"] = "D/,喋血之刃",["破碎岭"] = "D/,Frozensnow;D+,默小忆;D7,大叔丶你真氺;D3,Callmeback,杨三十二郎",["???"] = "D/,南宫萱灵;D+,乌龙茶,夜空邦尼,后羿灬;D9,痴人丶;D7,丶风止于秋水;D6,曾相识今陌路;D5,安格尔丶莎娃,玩的是寂寞;D4,破碎的安静;D2,夏新晴,斗鱼万宝路,嘿点看我宝宝;D1,好几百只熊猫",["血顶"] = "D/,踽踽猫",["伊森德雷"] = "D/,夫复何求",["凤凰之神"] = "D/,丿喃喃;D+,转折;D9,丨斬殺丨,穹光织星;D8,醉蚂蚁;D7,洫色殘陽丶,深邃的德魯伊;D6,梦绕魂牵丶,囂張雯雯,菜逼飞飞丶,超级丨奶爸;D5,超级灬大哼;D3,鹳雀楼,冰鎮牛奶,罗格斯",["迅捷微风"] = "D/,Calflove;D3,阿萌达",["利刃之拳"] = "D/,战姿;D7,黑崎一护,胖猪猪",["能源舰"] = "D/,俯视苍茫,欧利西斯;D5,洋气的香菜",["血色十字军"] = "D+,郑小凯的迷妹;D9,右掌舵,木浪;D6,Loktor;D5,Showtimez,野生的萨满;D3,白给,来个橙子不,希格拉之耀",["雷斧堡垒"] = "D+,将戟;D6,雷斧背锅侠",["奥杜尔"] = "D+,望涯",["格瑞姆巴托"] = "D+,繁星丶星小悦,欧彡气,消泯;D9,星期三先生;D6,幸运的阿昆达;D5,圣教父,连橙曦;D4,月亮爱上猫,暹罗之殇;D3,帕丶纳梅拉,Microtech",["闪电之刃"] = "D+,Kstrial;D6,维恩的风铃",["奥尔加隆"] = "D+,奥利奥可爱多;D7,水晶美惠;D5,这个不重要;D4,Junna",["贫瘠之地"] = "D+,灬肥仔,零度丶枫;D9,萌系滚喵喵;D8,星碎丶执念,布丽吉塔丶;D7,炎爆小龙虾,斯文败类丶,这很难说;D6,星訫欣,冥丶文远,勿忘禅心;D5,阿脉,弄花香满衣丶,天蓝色的梦;D3,側耳倾听,靈渡,曼图海姆",["永恒之井"] = "D+,潍坊纯爷们,看這夕陽死去;D9,乄焦先森乄;D6,缱绻灬时光",["末日行者"] = "D+,七丶宝,记花明与柳暗;D9,萌萌哒小杀戮;D8,有时有逝,变心的灵魂;D7,奶嘴断了;D3,三花哩哩,杀戮乄晕奶丶",["克尔苏加德"] = "D+,会搓脑残箭,琉蓝;D9,小提沫;D8,鱼语愚,卡住门框;D5,大漩渦;D4,虚然染;D3,灵魂未出窍",["耳语海岸"] = "D+,纱由",["屠魔山谷"] = "D+,奔放有内涵丶;D7,冷杉二大妈",["罗宁"] = "D+,懒的逍遥;D9,夜风织梦;D8,欧阳,落落萧萧,无视你存在;D7,殇丶夜凌霜,天小猫,大不列颠烤肠;D6,杯雪归尘,胤苓;D5,与君三愿,高級動物;D4,心碎的方式,蓝倾,梧桐君;D3,Pegasusian,凝芸",["伊森利恩"] = "D+,圈住那个九,Natsu,夜丶第七章;D8,Slipknott;D7,一只小盆友,疯癫老中医,妩媚小媳妇,可能有点秀,Annwyn;D5,第五夜,时光礼记丶;D4,寂寞战神;D3,橙水糖",["白银之手"] = "D+,天古之极,肉了也挨揍;D9,木小福,虎啸于林丶;D8,丶一战橙名,花心的菠萝,执念在心;D7,天国星坠,Aanmu,热心市民小基,Beelzebart,帕布提斯马;D6,秀独香,楚腰,奎托斯丶奎爷,霜冷长天;D5,铠铠,丷玄策大人丷,迷域,罗玄羽,铁血神猪,海姆先生,風之轻語,长衣景祺,Makisechris,丶初号机,疾風魅影;D4,Xxtentacion,Victormarcus,水月坏坏哒,初雪春风起,丶诗烟,於国,Misting,黑锋、骑士团,师墓师;D3,暗影守望灬,戰龍在野,少年张有亮,箖荫",["山丘之王"] = "D+,蹭蹭",["金色平原"] = "D+,唐家少爺;D9,甜豆儿;D5,鹦鹉宝宝;D4,爆破手巴斯特,虾酱;D3,马里奥若智",["主宰之剑"] = "D+,单向度,芒果养个鹅宝,都叫我豆包,一切都是虛幻;D9,君唱臣和,红玉明月青霜,碧落无耀,心米地方停;D8,林家死神领主;D7,扬眉吐气,沫丶小呆,一梦十几年;D6,特玛德丶邪歌,心情很复杂,卿月铭;D4,溙澜德灬语风,丨戴斯菲尔丨,徘徊在边缘;D3,風雨時若,帕奇維克,幻魔枫尘",["扎拉赞恩"] = "D+,水漪月",["埃苏雷格"] = "D+,烈酒醉人心;D4,偷东西的猫",["冰风岗"] = "D+,女伯爵月夕雅,灬奎托斯;D8,虹鸶;D6,萨魯曼;D5,面团不是团;D3,Atina",["死亡之翼"] = "D+,好久不见啦,葬爱骑,非洲大总统,本宝宝不掉毛;D9,王小诺,你渴望乃子么;D8,举刃逆苍天,夜乄剑噬苍穹,红色的爆风,切个大西瓜呀,俊芳,璐璐安;D7,月下黑,有理丷,今夕何夕然,甜甜橘子味,丿清影丶,远程射手,Kohck,彪悍飙汗;D6,Almore,小黄人哔哩哩,Mç,混混豹丶,阴影灬毒奶,血匕透腥凉灬,槑猫;D5,烈风劲啸,Dzrion,灬我是自愿的,裤裤狄奥里多,油条;D3,悬崖边的花菜,Xno,鳝变男老牧,麻吖",["熊猫酒仙"] = "D+,逗你玩的小舞;D4,大城管克星,凯普;D3,野蛮浮夸丶",["丽丽（四川）"] = "D+,羽冉;D7,謬之;D6,Soma;D3,小悠闲,葬爱丶毛少",["伊利丹"] = "D+,学步;D9,Paradise;D6,瞧我咋样",["阿拉希"] = "D+,晓学狗;D5,哲别",["回音山"] = "D+,城忆微骤,Deepestlove,卖糖果;D9,Sele,黄渡枯法者;D8,苏坡密;D6,圣光萝莉,戴佛斯;D5,旧克,江听潮,語风;D4,瑞德汉德",["霜之哀伤"] = "D+,千与千寻丶;D9,Monarch;D7,抵制不良游戏,孔仔哥;D6,舒服德;D5,昭澜忆未央;D4,术术呀丶;D3,Mocktails",["天空之墙"] = "D+,波普艺术家;D5,雪顶咖啡;D4,奥钉",["军团要塞"] = "D+,伤灬感入侵;D3,梦成殇",["血环"] = "D+,收回你的套路;D8,狼院小黄人;D5,二比虫;D4,闲看花落,刺痛的敏希",["暗影之月"] = "D+,帅比;D3,酱油小骑士,帅爆地我",["黑铁"] = "D+,陈逗逗,Lfy;D8,转角遇到谁",["伊瑟拉"] = "D+,熊猫武僧;D8,橙条条",["逐日者"] = "D+,红小手",["提瑞斯法"] = "D+,薛慢慢;D9,遥远的梦;D7,麻瓜丶;D4,阳光柯基",["泰兰德"] = "D+,孤独的牧垟人;D7,海龟成功入睡",["杜隆坦"] = "D+,希雅",["艾苏恩"] = "D+,师夷长基;D5,大宝剑丶",["萨尔"] = "D+,林檎",["试炼之环"] = "D9,小道林樨;D8,小猪丨佩琪",["红龙军团"] = "D9,豆奶小盆友;D8,Kishiro;D6,白兔兔;D5,倪晓猫;D4,愿圣光奶死你",["海克泰尔"] = "D9,喜出望外;D6,光复泰达希尔;D5,虎将云长;D4,狠特",["安苏"] = "D9,集火他们萨满,捌捌肆捌,Zzssdd;D8,守夜丶;D6,Herbtea,夜空如海;D5,丶李梦龙,Sleepymurky,半斤黄瓜,海冰,阵营女神;D4,龍炎灬,盗将行丶,丿灰白色,瑟兰迪斯乀;D3,大安,多出林肯,辛未,云然",["燃烧之刃"] = "D9,親愛德丶,飙水枪;D7,拈花为雨;D6,我还是那么贱,暹罗菌丶,污流才子;D5,萩原子荻,芒果丶,小猪珮琦;D4,蛛丝码迹,尛锅盖,璎洛,梁辰姐姐;D3,悶倒驴,烟火",["壁炉谷"] = "D9,熟睡的土拔鼠",["德拉诺"] = "D9,赫拉克勒斯;D3,橙珑",["阿拉索"] = "D9,凤凰水仙;D5,荣歌;D3,傅立叶变换,曾希萌",["萨菲隆"] = "D9,扒会长裤衩",["恶魔之魂"] = "D9,寒武纪年;D7,初小七",["丹莫德"] = "D9,坂崎由莉灬",["熔火之心"] = "D9,屠龙;D5,Coldzera",["阿古斯"] = "D9,徐毛豆,瞬风;D7,人间不值得,丶空心;D6,祭斯;D4,晨曦夜雨;D3,铭云小艾",["暗影议会"] = "D9,Druish;D6,浮生光;D4,扛不注就射",["阿尔萨斯"] = "D9,阿斯帝;D7,皮皮朽;D5,谁偷了我的角;D4,魂之皈依;D3,",["桑德兰"] = "D9,步步生莲花,迷路的皮皮虾;D5,唐松之脉;D3,灬尐鲜肉",["达文格尔"] = "D9,铁心男;D4,芊陌;D3,临夏",["无尽之海"] = "D9,用爱飞翔;D8,莱克萨斯丶;D7,黑色的眼眸丿,冰封骑士,锋行客;D6,一块海绵;D4,剑来不;D3,小三班,鲜血的死奴",["伊萨里奥斯"] = "D9,几星霜;D8,西湖醋鱼;D7,柒玥",["卡拉赞"] = "D9,欧灵;D3,奶不动,Blackcode",["图拉扬"] = "D9,丶艾尔托利亚;D4,白皇后;D3,Evilhall",["战歌"] = "D9,犇羴鱻;D8,东风月",["森金"] = "D9,圣西罗的梦",["迦拉克隆"] = "D9,灬塔隆灬;D7,干柿鬼鲛丶;D5,清果青澄;D4,Exquis;D3,不嗔,请勿殴打追逐,孤烟纵歌,Hypnotia",["冰霜之刃"] = "D9,丷冰雪丷;D8,心随流云;D4,膨胀的阿昆达,镜花卐水月",["诺兹多姆"] = "D9,我萨满贼稳;D6,战争螺旋;D5,添添;D4,求其阿才;D3,Coldkiller",["晴日峰（江苏）"] = "D9,灌水大王;D8,伊吹小风;D3,让你流口水",["布兰卡德"] = "D8,果泥果泥,缌肆葉雨;D6,糖心宝宝,流暮;D4,暴烈,夜梦离;D3,靑蝉子,有一点丰满",["祖阿曼"] = "D8,瑪麗蓮灬夢露",["艾露恩"] = "D8,闷骚带点含蓄;D5,临风听暮蝉,霸天虎猪力蛋",["黄金之路"] = "D8,弱小萤火虫;D6,寡妇村的救星",["生态船"] = "D8,Ksimertwo",["埃德萨拉"] = "D8,在下大魔王;D5,我了个德",["外域"] = "D8,无敌坦克",["塞拉摩"] = "D8,貌似没睡好;D3,音符跳跃",["洛萨"] = "D8,渲泄;D6,Moudo",["雷霆之王"] = "D8,曾经的双叶;D5,痞子泽",["狂热之刃"] = "D8,無灵;D7,变戏法;D6,泰瑞西斯",["鬼雾峰"] = "D8,謝佳佳;D5,那么美星人",["阿比迪斯"] = "D7,Richwtf;D4,花椒",["通灵学院"] = "D7,得撸一個月",["奥蕾莉亚"] = "D7,冰火之歌,鹿饮溪",["安东尼达斯"] = "D7,惜玥,疯狂老马",["太阳之井"] = "D7,一叶御叁籹;D3,丨冬叔丨",["迦罗娜"] = "D7,装阔耐",["艾维娜"] = "D7,鸿渐于磐;D3,狂热的阿贵",["诺森德"] = "D7,不含防腐剂",["斩魔者"] = "D7,仙女舜",["时光之穴"] = "D7,芜菁胡萝北丶",["黑暗之门"] = "D7,伊利达雷之刃",["巴瑟拉斯"] = "D7,千鹤",["泰拉尔"] = "D7,儿歌三百首,糖诗三百首",["诺莫瑞根"] = "D7,輝月姬",["洛丹伦"] = "D7,傲慢的懒猫,年轻力壮的鸭;D3,水电安装",["遗忘海岸"] = "D7,藤花末叶;D3,云间独步",["血吼"] = "D7,斡瑞儿;D4,浪子伤了心,别艹我平底锅",["迦顿"] = "D6,萌面小怪兽",["影牙要塞"] = "D6,云海盗月",["纳克萨玛斯"] = "D6,傲气银雪",["巫妖之王"] = "D6,絕灬,无面者丶欧帝;D3,傲天海带",["阿克蒙德"] = "D6,爷们真能熬;D5,快夸我帅",["埃加洛尔"] = "D6,晓輝爱妮子",["万色星辰"] = "D6,纤腰可顾",["灰谷"] = "D6,救一次十万",["风暴之怒"] = "D6,烈火奔雷;D4,森林与树,Madtyrant",["卡珊德拉"] = "D6,李白不写诗",["寒冰皇冠"] = "D6,雪域孤狼;D5,柳幻雪",["斯坦索姆"] = "D6,你们自寻死路;D4,傲娇最讨厌了,罗宁",["克洛玛古斯"] = "D6,吾食已到",["阿纳克洛斯"] = "D6,团长来吃药了;D4,可选择的未来",["羽月"] = "D6,健身教练",["朵丹尼尔"] = "D6,为了呜喵王丶;D5,矮壮粗",["古尔丹"] = "D6,半夏丿微醺;D5,淡紫色的刃",["世界之树"] = "D6,谎言如此动听;D5,雨露星辰",["熵魔"] = "D6,御姐爱我",["烈焰峰"] = "D6,追风猎手耶稣;D4,臭小诙",["梦境之树"] = "D6,啦啦荣肥",["白骨荒野"] = "D6,曉滿;D4,托楚去坎叽叽",["蜘蛛王国"] = "D5,想念广爷;D3,纽约城的太阳",["巨龙之吼"] = "D5,莫拉斯",["玛瑟里顿"] = "D5,光明游",["月光林地"] = "D5,智慧之灯;D4,慕明",["玛里苟斯"] = "D5,确认過眼神",["加里索斯"] = "D5,陌小沫",["奥特兰克"] = "D5,青衫薄,半壶纱;D3,殺伐",["激流之傲"] = "D5,幽兰泡泡",["玛法里奥"] = "D5,兰博基妮",["巴纳扎尔"] = "D5,夜色神偷",["燃烧平原"] = "D5,Kotoa;D3,這是我的溫柔",["幽暗沼泽"] = "D5,灰色的修饰,琼华灵均",["神圣之歌"] = "D5,Shadowdaisy",["夏维安"] = "D5,邪刃;D4,逝水无痕",["暮色森林"] = "D5,Demantoid",["藏宝海湾"] = "D5,Nmumi",["末日祷告祭坛"] = "D5,斯娜瓦爾希",["黑暗虚空"] = "D5,不能叫我山鸡",["月神殿"] = "D5,丶洛水",["梅尔加尼"] = "D5,Fullfronta",["普瑞斯托"] = "D5,雾里寻花",["希尔瓦娜斯"] = "D5,巜巜乖小孩灬",["库尔提拉斯"] = "D5,江山如画",["金度"] = "D4,牧濑丶红莉栖",["翡翠梦境"] = "D4,韶華白首丶;D3,古尘沙",["索瑞森"] = "D4,下半身的叛逆;D3,一本道一休",["雷克萨"] = "D4,辩机;D3,此号纪念小白",["索拉丁"] = "D4,希羅;D3,枫隐士,凯兰催尔",["加兹鲁维"] = "D4,丶弹指芳华",["米奈希尔"] = "D4,丨心有萌虎丶",["基尔加丹"] = "D4,暮雪芊岚",["卡扎克"] = "D4,牛脑壳",["布莱恩"] = "D4,蝶舞丷樱花落",["勇士岛"] = "D4,无情修罗",["奥达曼"] = "D4,圣光汐音",["卡德加"] = "D4,米小茶",["玛洛加尔"] = "D3,伊利优乳酸",["远古海滩"] = "D3,去甲肾上腺素",["密林游侠"] = "D3,一起蛤啤,万河",["达隆米尔"] = "D3,佛祖在一号线,光丶年",["艾莫莉丝"] = "D3,皮甲都归我",["地狱之石"] = "D3,胭脂相留醉",["玛诺洛斯"] = "D3,大風起",["风行者"] = "D3,亞拉崗"};
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