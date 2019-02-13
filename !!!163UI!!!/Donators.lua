local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,释言丶-伊森利恩,林叔叔丶-死亡之翼,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,优先毕业目标-贫瘠之地,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯";
local recentDonators = {["无尽之海"] = "Gg,小海棠丶;Gb,卖萌的京阿尼;Ga,心碎释迦摩尼,赫者;GZ,唛吟;GX,黑石狼牙;GW,夜丶后觉;GS,丶蛋蛋碎大石",["破碎岭"] = "Gf,芯肝;GZ,艿德;GT,悠然似风",["奥杜尔"] = "Gf,内收霸气",["丽丽（四川）"] = "Gf,鷓鴣菜;Gd,情霜恶;Gc,油膩中年華哥;GV,欧咪咪",["罗宁"] = "Gf,Tsunamireb;Ge,裹诗布;Gd,神裂丶火織,陵叁;GZ,初容",["埃德萨拉"] = "Gf,猎丶魔;Gb,惯例,雏菊真香;GX,此德很奈斯;GV,四岁;GT,烟灬花易冷,烟花小魔王,幽默泡泡丶",["???"] = "Gf,一刀神话;Ge,佩奇丶布鲁克;Gd,枫叶点、荻花;Gc,堕落丶魂噬;GX,穆雷西蒙,电力工作者",["燃烧之刃"] = "Gf,元了个元,兮木;Gd,情迷丝滑德芙,辕丶偐,丶邦桑迪;Gc,安小靚丶;Gb,麦英俊,幼艾心,骗的一手伤害;Ga,五月的救赎,夜雨晨;GZ,猪事亨通,惧妻,翻滚吧小兔;GX,獸教父;GU,乔雯静刃,寻道问天",["阿古斯"] = "Gf,武涛;Gd,学习路上;Gc,心底温柔是你;GX,周丿卓;GW,快乐的小蛋挞",["幽暗沼泽"] = "Gf,痞猫猫",["血色十字军"] = "Gf,氵缘丷;Ge,陈大皮,丶小琻毛;Gc,赫连赋;GZ,布鲁斯丨李,融老爺;GY,;GS,把你鸡儿吓沒",["凤凰之神"] = "Gf,江禾,尘寰的羁绊丶,相丷濡;Ge,转折丨芸煙;Gd,风陵君忆,纸鹤,转折|骑士;Gc,青夏丶,止水的心;Gb,一只软咩咩,大萌斌仔,脱非入欧,可乐泡沫,Raincrazy;Ga,灬笑醉灬,洪流几线阻,Aldur,Gingerlele;GZ,丶野鹿,龍灬貓;GY,蘑菇丶酱,你的小鱼叉,素影;GX,Honorshaman,内个神棍德,正皇愤怒,麻木不仁,欧哩欧氣;GV,组我绝对红爆,杨世碧丶;GU,丶丨我是演员;GT,山石大哥,聆听,艾泽柆斯的风;GS,夕晖,仙羽羽,邪恶蛋卷",["格瑞姆巴托"] = "Gf,爱笑的蓝孩纸;Gd,禹惜寸阴;Ga,Aloties,枫色晨曦;GZ,秦艾德,吾乃洛一丶;GY,浪花花,科多;GX,漂移和飘逸,胖次;GV,我只僾她,德伊德飘儿;GU,墨色玄离;GT,Vv;GS,冰镇小酸奶",["白银之手"] = "Gf,风吹散的情话,打不溜溜,丶逝去丶,企鵝;Ge,筱克;Gd,愿生梦;Gc,幻明;Gb,老薯,绵绵冰哈士奇,菊花嗨翻天,江禾;Ga,神醉梦迷;GZ,突丶突;GY,秃头的刺猬,霸气不失优雅,珍珠布丁,一劍悟世界,圣光乄无用,黒崎一護,今晚吃鸡腿;GX,紫枫灬洛沫,糖九九;GW,Hasayake;GV,口八亚希;GU,哟丶叉叉酱,墨小菊;GT,相思最难熬,六十七号技师,仙婆婆,乌云丶,大海旳女婿;GS,Myangil",["金色平原"] = "Gf,鼠片;Ge,散华灬;Gc,仰望流星,剑与天秤;Gb,尤格萨碧,譕殇;Ga,战任怒;GZ,剑御苍穹;GX,雲無月,天降大凶罩;GV,尛尛騎,尛尛獵,尛尛術,尛尛灋;GS,Virgil",["巴尔古恩"] = "Gf,春江花月夜丶",["国王之谷"] = "Gf,死亡拖孩;Gc,天河雪琼丶;GW,卡多雷夜行者;GU,宿敌",["战歌"] = "Gf,季末丶妮儿",["深渊之巢"] = "Gf,堺雅人;Gd,振翅熬翔;Gc,Baileys;GZ,译幻听",["伊森利恩"] = "Gf,先砍为敬丶;Ge,暴走的大咪咪,罗罗诺亚;Gd,語諷灬羙眻眻;Gc,阿泰尔之心,土豆烧饼灬,热心市民欧尼,緋緋的小音符;Ga,凭什么吃猛击;GZ,恰雪来故;GY,丽丶风暴烈酒,一夜瞳一,一夜曈一,把你壳都奶没,卡巴内利丶,捶死你个龟孙,丷清欢,阿昆达叔叔,㔣欧几里德;GU,Iyrel,柒月灬浠",["布兰卡德"] = "Gf,我有大苹果;Ge,Fallxu,吃飯就像打仗;Gd,同光十三绝,个记刮三了;Gb,Iloveni;GZ,理查德米,汗米尔盾,格拉苏帝,泰割豪雅,罗杰肚比,雅克德罗,僵士丹顿,怕马强尼;GT,黑漆嘛踏,欧洲小弘哥",["死亡之翼"] = "Gf,浅风细雨;Ge,木灬,慕丶,鱼酥苦丁茶;Gd,七曜刺;Ga,刻望,Xeric,小短腿柯基,思舟,晴天果果灬;GZ,大坏蛋嘤樱嘤,乄默熙乄,Razgriz,Dyinxd,Dylol;GY,灬雷克斯灬,关月瞳;GX,心中的恶喵,弦断笙歌落,昼司命,阿隆索斯,君子交蛋掳碎,风吹半夏;GW,Xeont,秋天的胖子;GV,大恶人双叶,默默丶幻,战飞天;GT,比法爷猛的术,小泰立丶,造化众神秀;GS,冬天里的圣光",["拉文凯斯"] = "Gf,星怒",["天空之墙"] = "Gf,俯视太阳;Ga,瘸腿的阿昆达,缺舟一帆渡,一骑红尘笑丶,其实我是血风",["贫瘠之地"] = "Ge,别闹我有糖,酒呑,桔子酸奶,御箭乘风,天堂蝎;Gd,紫依优琳,最爱荔枝肉,哈是佩奇;Gc,Kizz;Gb,小煭人,桑卡;Ga,空白色丨;GZ,潘达大爷,成名在望丶;GY,青冥之长天,花洛流年;GX,丿你瞅啥呢,发狂的牛牛;GU,近神人一页书,尾崎由香;GT,霧瞳,易安姐;GS,难得心动,戊己五六",["布莱恩"] = "Ge,满包子",["纳克萨玛斯"] = "Ge,粉沫",["利刃之拳"] = "Ge,非常傲娇丷;Gc,迪达弹弹",["影之哀伤"] = "Ge,一午夜骚男一,壹三;Gd,这杯奶茶很腻,视众生如蝼蚁;Gb,手贱的阿昆达;Ga,这个副本不会;GZ,咕咚尼达斯,咕咚尔丹,全团的打断;GY,脑瓜子嗡嗡嘚;GX,三十战网点",["冰风岗"] = "Ge,丿鹦鹉,暮雨流芸;Gd,冰炎的心,捂奶富江;Gc,摊牌;Gb,新年块乐;GX,苏老大,弹指亦倾城,丶莉亚德琳丶;GW,毒奶小可爱;GV,王昭悠;GU,Trustthelove;GS,Akmythes",["迦拉克隆"] = "Ge,丶生抽;Gd,嗜血罗莎;Gc,天要黑了;GY,二栗家蜗牛;GU,梦之火舞;GT,快乐的小柯基",["鬼雾峰"] = "Ge,吃飯就像打仗;Gc,超巨黑洞;GT,浮世三千",["山丘之王"] = "Ge,可哀的馒头",["末日行者"] = "Ge,进击的大海;Gc,锦鲤灬杨超越;Gb,胖不了先生;Ga,塔吉利斯,希伦蒂斯,恒哲;GY,贼煌;GX,撒哈拉的鱼,秋風悲画扇;GV,Xanxus,林遇清;GU,尐軟;GT,啪嗒嘭;GS,罗熙熙",["迅捷微风"] = "Ge,猫爷小时候;Gd,Hanniball;GY,虚空恐惧丶;GS,尘缘丶",["伊萨里奥斯"] = "Ge,浴花泪血;Gd,咎丶;Gb,钢铁棉花糖",["千针石林"] = "Gd,黄叶轻轻跳",["梅尔加尼"] = "Gd,纯棉袄",["雷克萨"] = "Gd,你给我奔放点",["达纳斯"] = "Gd,Romeo",["主宰之剑"] = "Gd,蓝雨丨財神,红尘壹,丨往后余生;Gc,萌淑丶,告诉我下一站,莹星;Gb,焦糖豆包,福祿寿囍;Ga,鬼月七曜;GY,壹隊防骑,怜邪姬,约丹慕枫,九條命,米伽羅,伽羅;GX,淡墨郁离;GW,Rabbearz;GV,聖侊,伊莉蛋怒风;GU,麻辣啤酒虾,艾沙夕沫;GS,我的弟弟乔治,淡然烟味",["红龙军团"] = "Gd,花落雨;GX,寂灭之手;GS,叉烧捞面",["雏龙之翼"] = "Gd,幽默的老张",["符文图腾"] = "Gd,大神宗山君",["麦姆"] = "Gd,丷栀寒",["奥达曼"] = "Gd,生命的救赎;GW,红炉点雪",["月光林地"] = "Gd,朝露;GX,暮光恶魔;GS,烟火在燃烧",["黑暗魅影"] = "Gd,领悟;GU,阿丝匹琳酱",["卡德加"] = "Gd,小凉湿手;Ga,二手血帝克;GX,仙踪林",["雷斧堡垒"] = "Gd,阿季米德",["安苏"] = "Gd,Treenewbeea,锴恩;Ga,安渡因络萨;GX,安迪杜福兰,千里流觞;GW,阿部察察灬,会魔法的月儿;GV,丶太阳光;GU,;GS,丶郑钱花,宝贝丶吃爪爪",["回音山"] = "Gd,寻找小晚,李焖鱼灬;Ga,夕阳之痕;GZ,烬烬如霜;GY,Retolies",["朵丹尼尔"] = "Gd,小赫哲",["风行者"] = "Gd,醉红尘,猎红尘,雁过拔毛、;GZ,暗夜祭司",["暗影之月"] = "Gd,虔誠的褻瀆;Gb,络绎丶;GT,殇囚",["阿拉希"] = "Gd,小猫汪汪叫",["加基森"] = "Gd,塞德里克杀;Gc,郭富橙灬",["奥尔加隆"] = "Gd,小贼贼;GY,卡咖卡",["黑铁"] = "Gd,雏蜂;Gb,小攀;GY,六库仙贼丶,停滞的时光;GX,蒙娜丽猪",["永恒之井"] = "Gd,郁闷的大脸猫",["风暴之怒"] = "Gd,兔兔丷",["冰霜之刃"] = "Gc,脑公啊;GW,软耳兔兔;GU,果肉多多",["艾莫莉丝"] = "Gc,西西是只喵;GZ,弑雪霜鸦",["德拉诺"] = "Gc,丶伊俐丹",["麦迪文"] = "Gc,刺青之聲",["卡拉赞"] = "Gc,一个机械法",["萨尔"] = "Gc,我不能忍,清风拂烟雨;GU,血影猎手",["熊猫酒仙"] = "Gc,柠檬小喵酱,第七跑道;Ga,月夜萌萌德,信仰之吻;GX,一小颗绿豆,月影殤;GV,神器;GS,阿迩托莉蕥",["甜水绿洲"] = "Gc,浅酌低唱;GY,啪嗒丶;GW,野兽的朋友",["塞拉摩"] = "Gc,小浪犬;GY,一道坎",["烈焰峰"] = "Gc,百羽猎魂;GX,外带王,陶陶的小白",["奥特兰克"] = "Gc,第一可爱",["风暴峭壁"] = "Gc,无法吟诵的诗",["海克泰尔"] = "Gb,晨熙灬杰寶,毁灭东京;GY,长髮绾君心;GX,阿宁快跑",["莱索恩"] = "Gb,牛鬼",["菲米丝"] = "Gb,Nyctophobia;GW,怒雷丶",["石锤"] = "Gb,夜凰孤舞;GY,淡紫色天空",["遗忘海岸"] = "Gb,堕落的贝塔;Ga,Bybyz",["洛丹伦"] = "Gb,班殳之圣,班殳之德;GY,咖喱给给丶",["燃烧军团"] = "Gb,不二城;GS,若呆",["狂热之刃"] = "Gb,紅馒头;GZ,星红收割者",["克尔苏加德"] = "Gb,大空间反推;GW,五仁妹;GV,Summero",["红龙女王"] = "Gb,童乳巨颜;Ga,唐丶寅",["熔火之心"] = "Gb,Chrisucc;GZ,王乡长;GV,爆爆;GU,二牛",["玛法里奥"] = "Gb,呢喃地狱",["加里索斯"] = "Gb,一雪",["翡翠梦境"] = "Ga,缘辛辛;GZ,以近知远",["霜之哀伤"] = "Ga,恶臭术,天哪你真骚",["耐普图隆"] = "Ga,丶纸防骑",["太阳之井"] = "Ga,萌萌白白尨;GV,十月二十;GT,跳跳狐",["血环"] = "Ga,Duet;GU,知世丷",["伊利丹"] = "Ga,菩提与花",["神圣之歌"] = "Ga,心然,湛然",["亡语者"] = "Ga,枷楼风",["鹰巢山"] = "GZ,哇灬男人;GT,沧海一声笑",["蜘蛛王国"] = "GZ,丶小馒頭",["霍格"] = "GZ,鸟德里",["红云台地"] = "GZ,斯蒂芬浪",["月神殿"] = "GZ,丶洛水",["艾萨拉"] = "GZ,杜蕾蕬",["斯克提斯"] = "GZ,武灬怒火冲天",["菲拉斯"] = "GZ,乱劈妖裁,叶尔羌",["阿纳克洛斯"] = "GZ,启瑞;GX,玉米粥",["密林游侠"] = "GY,社会主义冲鋒",["通灵学院"] = "GY,鸡肉粘湿",["阿曼尼"] = "GY,菲儿凌蒂斯;GU,忘却了",["亚雷戈斯"] = "GY,神罗天蒸",["藏宝海湾"] = "GY,天地一",["永夜港"] = "GY,伊丽娜",["夏维安"] = "GY,呆丶茄子",["苏塔恩"] = "GY,地皮埃斯;GS,柔吻有你的夜",["提尔之手"] = "GY,橙色随缘箭",["阿尔萨斯"] = "GY,暗香盈袖",["凯恩血蹄"] = "GY,陨落的星辰",["雷霆之怒"] = "GY,尕丶尕",["万色星辰"] = "GX,秦红棉,Luminia",["瓦里玛萨斯"] = "GX,漫天风雪",["杜隆坦"] = "GX,枭徳",["风暴之眼"] = "GX,钱小样",["逐日者"] = "GX,幸福的小羊",["壁炉谷"] = "GX,十区瑟兰迪丝",["哈兰"] = "GX,欧莱雅男士",["阿格拉玛"] = "GX,毁灭之刃",["希雷诺斯"] = "GX,好吃不如饺子",["奥蕾莉亚"] = "GW,一丢丢大;GS,烟末",["死亡熔炉"] = "GW,点烟冲锋释放",["玛洛加尔"] = "GV,宽口径奶嘴",["冰川之拳"] = "GV,苏沐橙",["弗塞雷迦"] = "GV,断角库亚塔",["洛肯"] = "GV,Autumnsnow,航拽",["玛里苟斯"] = "GV,好嗨呀",["罗曼斯"] = "GU,偷偷出去玩",["银松森林"] = "GU,克非改命",["萨洛拉丝"] = "GU,凑崎纱夏",["古尔丹"] = "GT,夕颜漪语",["卡德罗斯"] = "GT,永恒地星空",["自由之风"] = "GT,浮世轻歌",["瓦拉纳"] = "GT,专注魔法",["羽月"] = "GT,功夫胖胖",["冬拥湖"] = "GT,朵朵海堂",["军团要塞"] = "GT,伤灬感入侵",["海达希亚"] = "GT,光明中升华",["盖斯"] = "GS,紫弓,番茄丶栗子",["伊森德雷"] = "GS,柏璃丶",["血羽"] = "GS,小李他吗飞刀",["辛达苟萨"] = "GS,Jimforever"};
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