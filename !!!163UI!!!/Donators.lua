local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,释言丶-伊森利恩,空灵道-回音山,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,不要捣乱-贫瘠之地,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯,戦乙女-霜之哀伤";
local recentDonators = {["迅捷微风"] = "Fl,地精油;Fk,冰雪荣耀;Fj,孤绝如初见;Fi,鞘师里保;Fh,Moscatel,雨夜丶菲菲;Fg,让本宝宝先撤",["影之哀伤"] = "Fl,小丶骚猪;Fk,月儿彎彎,御风只影游,康乐;Fj,紫夜幽冥,孤雨寒烟;Fi,朱弦断明镜缺,清极不知寒,钰纾格格,土豆炖牛排,绿茶味可乐;Fh,静水蓝蝶,敏捷的阿昆达",["末日行者"] = "Fk,北子,誓言丶;Fj,茶米茶丶,扶弟魔丶,章较瘦;Fi,剑过无痕,迈达斯的手;Fh,墨竹青衫,圣光的正义啊;Fg,卧梅幽聞花",["银松森林"] = "Fk,英文课;Fi,文森特;Ff,Dfgs",["红龙军团"] = "Fk,九月寒露;Fi,最强肉盾;Fh,我离,绿绿小萝莉,山下来的神棍",["???"] = "Fk,丶贝戎灬贝戎,哦耶哦买噶,星辰禹王;Fj,凡妮莎灾歌,误入奶门;Fi,我名字很帅,翌心,月月鸟大人;Fh,昨天的秀妹子,陈阿飞,夜霜之哀;Ff,王寨村话事人;Fe,诗丨画;Fb,丶摩擦丶",["丽丽（四川）"] = "Fk,不怕你哟,求求你别吃我;Fi,楠楠酱",["主宰之剑"] = "Fk,年年皆琐碎,黑麦咖啡;Fj,琉璃安然,丶思念初夏,蘸狼;Fi,战骑,烈火白羊,泡椒兔兔,飞洋灬,冲释一体;Fh,咕喵酱,红胡子老大爷;Fg,杰哥威武",["菲拉斯"] = "Fk,娜拉贝尔;Fi,嗜血贼叔叔",["克尔苏加德"] = "Fk,醉乄;Fj,小蚊子丶;Fi,滑头老榴莲;Fh,一米两个球,五个图腾,血窝窝头,丿开嗜血灬;Fg,Ainzooalgown",["安苏"] = "Fk,Tyrionchen,刀鋒舞者;Fj,郑天荫,郑天佑,郑天勇,淡忘灬忧伤;Fi,蓝莓哦,尼古拉丝铠骑,古索,帅霸霸丶;Fh,|翊恒|,当歌惊鸿,牛将军丶老刘,成无情;Ff,怪味狐臭,心静自菩提",["海克泰尔"] = "Fk,捡垃圾的旺财,预估的;Fj,快乐炮王丶,谁的益达",["永恒之井"] = "Fk,星际无限美",["灰谷"] = "Fk,没得糖就扯拐;Fh,一切爲了联盟,二郎显圣真君",["燃烧平原"] = "Fk,Shadowwithme;Fh,Horrorsword",["巫妖之王"] = "Fk,公子无双",["盖斯"] = "Fk,佛祖之手",["风暴之眼"] = "Fk,陆小凤的中指",["奥特兰克"] = "Fk,背叛过去,正能量魔导师",["凯尔萨斯"] = "Fk,无庸丶",["回音山"] = "Fk,一公分,Fgthus;Fj,Ashleynamay;Fi,圣光原谅了我,喵筱筱",["死亡之翼"] = "Fk,丨光老板丨;Fj,珈百璃的堕落,你上我掩护,折纸玉珑;Fi,泡泡小萌,邪恶排骨,迷路到你身旁,强击,发条丿橙;Fh,邓士载,炉中剑,无辜的大萌德,势如利刃,Senario",["芬里斯"] = "Fk,天牛丶",["熊猫酒仙"] = "Fk,熊大的西兰花,無敵劉;Fj,一江泪,有梦想旳咸鱼;Fi,Tuulani,笔直的烟斗,Prisoners,丶彭于晏丶;Fh,丫哥卖假药,西西弗斯丶,名侦探喵美;Fg,撕裂信仰",["阿尔萨斯"] = "Fk,青蘿拂行衣;Fj,箭气;Fi,香蕉牛奶;Fh,狰狞",["通灵学院"] = "Fk,指间黑白;Fj,灬虾条灬",["阿拉索"] = "Fk,虚构小说家",["太阳之井"] = "Fk,白芍菜心;Fi,王壮壮",["贫瘠之地"] = "Fk,素年大欧皇,青丝渺渺,Asurin;Fj,杨村长,堕落丨鬼魅,蹦哒的荣誉点,小袭;Fi,Savy,黑峰小哥哥;Fh,凊凉,汰渍净白去渍,早苗,感恩朋友,不要捣乱,平静的杜王町,早上好丶,黑椒牛肉丸",["燃烧之刃"] = "Fk,聖羽之誓;Fj,光明大祭司,米酱;Fi,亲幂无间,我有八倍镜,拼命三郎赵四,洪珉绮,Smileycola;Fh,Polariis,面纱丶,好想羊只咕丶,潶澀灬小妹",["石爪峰"] = "Fk,一佛系青年一;Fj,玖伍伍带槽,花醉三千客",["无尽之海"] = "Fk,奶神张雨绮;Fj,免疫致盲瞎,Jumpsuit,欧皇会武术;Fi,毒液丶;Fh,冰封太子;Fg,灬唆了蜜灬;Ff,今晚吃鸡,鸸鹋丶",["狂热之刃"] = "Fk,有多远射多远;Fj,糖豆的美梦;Fi,郑翔爱吃翔;Fh,加尔鲁什;Fg,打瞌睡的阿噜",["伊森利恩"] = "Fk,壊比,莫迪亚铁之眸;Fj,夜雨语,星如海,Vingsanity;Fi,晨星丶,Noirsakura,惊羽乄,夕月夜;Fh,弥黯,諾夏,逗牛洋芋儿,丨那夜丨;Ff,那乄夜",["凤凰之神"] = "Fk,幺叁伍;Fj,宮脇咲良,曼巴飞舞;Fi,逆鋒扬血,烈酒醉猫,风月缱绻;Fh,小菇梁柒丶,炸天出征,戀夏,风油巾,祈祷落幕,贼胆专家,是十一月天呀;Ff,暗黑风暴",["亚雷戈斯"] = "Fk,Rascal;Fh,化野红绪",["扎拉赞恩"] = "Fk,晓萨;Fj,旧人时光不离,专属小幻",["霍格"] = "Fk,柚子皮好苦丶",["巴尔古恩"] = "Fk,萌萌的椰汁",["踏梦者"] = "Fk,那那",["影牙要塞"] = "Fk,云宫迅音;Fi,间和之光",["白银之手"] = "Fk,萌若曦;Fj,谷二担,笑靥如花灬,胖仔真可怕灬,半条腊肠,薛定谔的咕,丶醉别西楼;Fi,然倾照月空,小禹丶,吃不胖包子,凉墨丶,肥宅快乐绿,悶声发大財,浅墨夏殇,读条带走青春,雪岷,原梦之猎;Fh,多多是欧皇,咪七甘八卦,朵拉丶风行者,瘦蛋儿,狮王之傲旅店,欲灬沉香;Ff,琳菀",["朵丹尼尔"] = "Fk,紫杉丶龙王",["永夜港"] = "Fj,六破",["罗宁"] = "Fj,斯坦索姆,血色之石,最爱冰美式,天狼星月;Fi,晨煦,虎千代,泽风漂缈,小屁莎莎,没人要的玩偶;Fh,有爱有高潮",["幽暗沼泽"] = "Fj,大寶貝哟;Fi,玉高惊魂",["布莱恩"] = "Fj,冷星雨",["卡德加"] = "Fj,淡淡黄昏丶",["山丘之王"] = "Fj,墨筱陌,薇薇呐;Fh,击溃油王",["暗影议会"] = "Fj,气死小居了;Fh,大绝招",["布兰卡德"] = "Fj,苏烨;Fi,酷酷小超超;Fh,碳烤咕咕",["玛里苟斯"] = "Fj,天使的毒奶",["试炼之环"] = "Fj,天丶崖",["黑暗之矛"] = "Fj,帝国海军",["伊森德雷"] = "Fj,火葬场阿明",["烈焰峰"] = "Fj,贰零壹柒;Fi,时间忘记,你的充气男友;Fh,七念",["格瑞姆巴托"] = "Fj,轻轻灬魅儿,蓝妖王,灬滚好么灬;Fi,圣域余晖;Fh,圈圈丶二意,怀中抱妹殺丶;Ff,丶暖小若",["霜之哀伤"] = "Fj,亚瑞特之怒",["冰霜之刃"] = "Fj,为萌妹坦怪;Fg,今夜我唠叨了",["日落沼泽"] = "Fj,圣光小玉",["冰风岗"] = "Fj,这是谁的,重装城管;Fh,蓝色空闲;Fg,路灯披橙",["加基森"] = "Fj,欠债玖佰万,雨过月华升",["生态船"] = "Fj,執著灬",["梦境之树"] = "Fj,温情的向向",["哈兰"] = "Fj,沫沫烨",["白骨荒野"] = "Fj,语澤;Fh,新人中单",["雷霆之王"] = "Fj,圣光之锤",["奥拉基尔"] = "Fj,Seiko;Fi,神滅斬;Fh,真不知是誰",["雷霆之怒"] = "Fj,丶丹妮莉丝",["黑铁"] = "Fj,童咚咚;Ff,摇滚大橙子,南岸青栀",["埃德萨拉"] = "Fj,凡尘之间;Ff,白夜阑珊,公巴佩丶",["迦拉克隆"] = "Fj,羞羞萌萨,河马君;Fi,小彤酱,天降正丶额啊;Fh,忽悠你啥了,Averager,大抱歉牧,山丘之傲;Fg,Ambrosed",["激流之傲"] = "Fj,吉利兄弟",["羽月"] = "Fj,Cleisy,确实够黑",["阿拉希"] = "Fj,卩坏蛋",["血色十字军"] = "Fj,丿丶魂魄妖梦;Fi,该用户被禁言;Fh,扬州奶多哦",["阿克蒙德"] = "Fj,奥格专业开锁;Fi,执迷的老王",["国王之谷"] = "Fj,咸蛋路人甲;Fi,插棍专家丶,穆穆寒雪,欧皇麦兜;Fh,敲你丫的;Fg,红丶小白",["阿斯塔洛"] = "Fj,哈索尔",["奎尔丹纳斯"] = "Fj,舞弥;Fh,姬血冷清",["伊利丹"] = "Fj,尤姆",["玛洛加尔"] = "Fj,流水如云",["密林游侠"] = "Fj,骚年先疯;Fh,舞玲珑",["塞泰克"] = "Fj,这里好多鱼",["奥杜尔"] = "Fj,当年地主",["艾萨拉"] = "Fj,Hank",["屠魔山谷"] = "Fj,阿尔托莉亚",["红云台地"] = "Fj,张布罗;Fg,暗夜之瞳",["安格博达"] = "Fj,云丶七",["希尔瓦娜斯"] = "Fi,丶欧豆豆",["雷克萨"] = "Fi,爱吃牛三宝",["战歌"] = "Fi,优雅之枫",["暗影之月"] = "Fi,雪毛毛,灬地狱男爵",["艾欧娜尔"] = "Fi,大白皮一发",["金色平原"] = "Fi,你丑没事我瞎",["泰拉尔"] = "Fi,山雨",["拉文凯斯"] = "Fi,夏沫奶茶",["埃苏雷格"] = "Fi,绝对疯子",["遗忘海岸"] = "Fi,恐怖钕主角,丶跳刀躲梅肯,聖光先锋;Fg,沉默之石,乌伤郡",["破碎岭"] = "Fi,安息蛇,你们真无聊,網瘾少鲶;Fh,老歌;Ff,慕行",["阿古斯"] = "Fi,豆丶丁,欧皇的秘密;Fh,焦糖土豆",["嚎风峡湾"] = "Fi,Kissazshara",["大地之怒"] = "Fi,酒叔不喝酒",["艾莫莉丝"] = "Fi,刹风",["祖阿曼"] = "Fi,紫雾",["玛法里奥"] = "Fi,爱撒娇",["巨龙之吼"] = "Fi,夜小寒;Ff,韩枫",["鬼雾峰"] = "Fi,甘大大,知我相思苦,Mistakey;Ff,山石大哥",["符文图腾"] = "Fi,杰哥归来",["黑翼之巢"] = "Fi,陌嘫红颜",["末日祷告祭坛"] = "Fi,夏雪丶,树海棠丶",["玛瑟里顿"] = "Fi,无垠的大地,小脚乱顶",["斩魔者"] = "Fi,滕大宝,花泽野菜",["阿纳克洛斯"] = "Fi,偷袭你开心;Fh,小野蠻;Fg,哞哒哒",["索拉丁"] = "Fi,史前史努比",["达尔坎"] = "Fi,凛冬將至",["迦罗娜"] = "Fi,么贼",["基尔加丹"] = "Fi,烟華易冷",["达隆米尔"] = "Fi,九尾鸣人;Fh,愿月神保佑你",["奥蕾莉亚"] = "Fi,顾倾橙;Fh,慕雪蓝采薇",["风暴之怒"] = "Fi,老韩的空酒桶",["军团要塞"] = "Fi,伤灬感入侵",["风行者"] = "Fh,血色丶曼陀罗,我特么要造反",["奥达曼"] = "Fh,老衲要射啦,箭之影;Fg,Chameleos,Freude",["埃加洛尔"] = "Fh,吾生须臾,吾谁与归,太早",["阿扎达斯"] = "Fh,雨灵霖凌",["梅尔加尼"] = "Fh,冽丶风",["图拉扬"] = "Fh,杜琼新羽",["玛诺洛斯"] = "Fh,懐英",["利刃之拳"] = "Fh,七七酱,地狱中最帅",["万色星辰"] = "Fh,花落满肩",["罗曼斯"] = "Fh,临风望抒;Ff,虔诚的单手剑",["奥尔加隆"] = "Fh,光泡泡;Fg,奥利奥可爱多",["沙怒"] = "Fh,名字很好取",["诺兹多姆"] = "Fh,Seelasslgo",["暮色森林"] = "Fh,古伊娜",["希雷诺斯"] = "Fh,殺生",["阿比迪斯"] = "Fh,谈指红颜老",["伊瑟拉"] = "Fh,Chy",["卡德罗斯"] = "Fh,丨仅等于狼丶",["雏龙之翼"] = "Fh,安静",["千针石林"] = "Fh,釺羽千寻,釺羽",["森金"] = "Fh,赤道",["血环"] = "Fh,我是大丁丁",["古尔丹"] = "Fh,丨风雨飘瑶",["银月"] = "Fh,不甜",["艾露恩"] = "Fh,超甜豆浆",["Illidan[US]"] = "Fh,Yohaa",["雷斧堡垒"] = "Fg,悟空大老爷",["德拉诺"] = "Fg,血嫣寒影",["天空之墙"] = "Fg,我有我方向",["寒冰皇冠"] = "Fg,范海訫",["壁炉谷"] = "Fg,Lucifeer",["伊莫塔尔"] = "Fg,沙耶之歌",["蜘蛛王国"] = "Fg,冰之苍月",["卡拉赞"] = "Ff,丶陌",["恶魔之魂"] = "Ff,二逼梁斌",["冰川之拳"] = "Ff,流沙之城",["厄祖玛特"] = "Ff,冰蓝丶"};
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