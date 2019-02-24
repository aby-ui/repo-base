local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,空灵道-回音山,瓜瓜哒-白银之手,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,释言丶-伊森利恩,林叔叔丶-死亡之翼,乱灬乱-伊森利恩,Monarch-霜之哀伤,优先毕业目标-贫瘠之地,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯";
local recentDonators = {["遗忘海岸"] = "Gq,暗影的问候;Gl,远夜",["太阳之井"] = "Gq,李改锥丶;Gn,小熊粉色;Gk,女冰皇;Gh,弥撒",["耐奥祖"] = "Gq,霜痕",["末日行者"] = "Gq,力大猛如虎;Gn,回忆白;Gj,指尖哥,李阳脚很臭;Gi,丶片叶知秋,涵术;Gh,曦辕;Gg,虚空召唤师,小佐仓千代;Ge,进击的大海",["海克泰尔"] = "Gq,小洛吖;Go,摄丶政王;Gl,慈祥的老父亲;Gi,铁戈",["国王之谷"] = "Gq,塞兰;Gk,残暴的村长;Gh,灬承影丶;Gg,国服沐浴,破晓鸽王;Gf,死亡拖孩",["埃德萨拉"] = "Gq,肥宅可;Gh,熊贱贱;Gf,猎丶魔",["白银之手"] = "Gp,瓜瓜哒,亿易;Go,流浪的雲,暮色挽戨,貌似大蛋;Gn,语翎,因为是兔子;Gm,迷人德;Gl,妖妖的骑士,要要的骑士;Gk,空城碎梦,语月清风;Gj,宋丞苟;Gi,Kellyms;Gh,把酒当鸽;Gg,小采薇,大力花菜;Gf,风吹散的情话,打不溜溜,丶逝去丶,企鵝;Ge,筱克;Gd,愿生梦",["梅尔加尼"] = "Gp,克丽珊娜;Gd,纯棉袄",["冬拥湖"] = "Gp,伊鲁德啊萌",["拉文凯斯"] = "Gp,凝风夜幕;Gf,星怒",["凤凰之神"] = "Gp,时光苍逝容颜,不爱喝桔汁;Go,子安红豆,柠檬菠萝冻灬;Gn,变形的阿昆达;Gm,谢无生,童谣丶;Gl,干锅小豆包;Gk,弦歌月落,雕刻丶月光,Zdass,那个小白啊,最爱天宝宝;Gj,马老师,下尾美羽;Gi,谱曲念红颜,转折丨蕓煙;Gf,江禾,尘寰的羁绊丶,相丷濡;Ge,转折丨芸煙;Gd,风陵君忆,纸鹤,转折|骑士",["破碎岭"] = "Gp,呜拉呱唧;Go,迹忆,Sodagreened;Gn,听说你缺徳,我非骑士;Gk,卡巴斯基;Gf,芯肝",["死亡之翼"] = "Gp,嘿丶兄弟儿,肉夾馍,榴莲披萨丶,二月二十八,七同;Gn,鸽鸽哒丶,Dyin;Gm,刀落泣鬼神,光上帝的长女,逼得练个坦克;Gl,黑大长硬粗;Gk,野蠻小妹;Gj,我真的很能打,有多多欧鳇丶;Gi,Davilma,令人智熄的你,等死速度灭,黎阿,深知她是夢;Gh,Noirsakura;Gf,浅风细雨;Ge,木灬,慕丶,鱼酥苦丁茶;Gd,七曜刺",["试炼之环"] = "Gp,伏念",["安苏"] = "Gp,丨木丶偶丨,Dystopian;Go,皮厚像坦克,玺芝琅,大師兇丶;Gn,铁骑丨米氵酉;Gm,记得快乐呦;Gk,成妍丶;Gj,飘飘然丶毁灭;Gi,败将食尘;Gg,北极偏北,观丶自在;Gd,Treenewbeea,锴恩",["迅捷微风"] = "Gp,照烧鸡腿饭;Gd,Hanniball",["燃烧军团"] = "Gp,松子菠萝",["熊猫酒仙"] = "Gp,连醉,独丶角丶戏;Gn,黑曜石之路,鬢如霜;Gm,丶陳冠希丶,丶小牛呶呶叫,索菲亚丶丶,二狗丶铜须;Gl,凉拌咕咕;Gk,织雾霾;Gj,点头叫二;Gh,后羿小飛虾,伊枼之秋",["迦拉克隆"] = "Gp,皮皮的阿昆达;Gk,丶抽抽,城头一块砖;Gj,莉莉丝女公爵;Gh,又是一夜雨丶;Gg,祥丶菰夜独坐;Ge,丶生抽;Gd,嗜血罗莎",["回音山"] = "Gp,蛤蛤子;Gl,全区最帅;Gd,寻找小晚,李焖鱼灬",["桑德兰"] = "Gp,柊镜",["战歌"] = "Gp,丶辣个劣人丶;Gi,Cynegetics;Gf,季末丶妮儿",["金色平原"] = "Gp,穆萨艾尔沙林;Go,顾小醉;Gn,磕瓜子儿;Gm,斯莫皮格佩奇;Gi,雲鸽;Gf,鼠片;Ge,散华灬",["耳语海岸"] = "Gp,聖光忽悠著伱",["格瑞姆巴托"] = "Go,蒙丽娜莎,青海长云,氵工小白;Gn,丶阿普唑仑;Gl,秦艾德;Gj,狂浪丶尐逗比;Gh,|幽游,齊丶戒,逸肖;Gg,;Gf,爱笑的蓝孩纸;Gd,禹惜寸阴",["伊森利恩"] = "Go,灬平厎鍋灬,养个小月亮吧;Gl,冰糖葫芦娃丶,青衫红颜;Gj,暴走的胖熊猫,鶸鶕,三星老伐木机,白丷夭夭;Gi,取名字真的难,娇莺恰恰啼;Gg,颓废丶男人,寂寞并非孤独;Gf,先砍为敬丶;Ge,暴走的大咪咪;Gd,語諷灬羙眻眻",["暗影之月"] = "Go,我来组成头部;Gd,虔誠的褻瀆",["深渊之巢"] = "Go,小熊猫朵朵;Gj,丶良人;Gf,堺雅人;Gd,振翅熬翔",["奥蕾莉亚"] = "Go,有鸭梨就假死",["德拉诺"] = "Go,馬糊噜",["大地之怒"] = "Go,瘦瘦的小排骨",["夏维安"] = "Go,兽猎之魂",["黑暗魅影"] = "Go,灬筱柒仔灬;Gn,仓科加奈;Gd,领悟",["恐怖图腾"] = "Go,Focused",["阿纳克洛斯"] = "Go,小时候可跳了,星光赠与你;Gm,阿扶;Gi,丰息",["贫瘠之地"] = "Go,莲子丷;Gn,一殺戮一;Gm,盘黄桃的培根,寒笑泯烟云;Gl,倒车踩油门,煮酒等故人,橙涩信仰,盘栗子的黄桃;Gh,叶落随枫;Gg,俺姑奶奶;Ge,别闹我有糖,酒呑,桔子酸奶,御箭乘风,天堂蝎;Gd,紫依优琳,最爱荔枝肉,哈是佩奇",["塞拉摩"] = "Go,请放下手中鞭",["主宰之剑"] = "Go,离殇罒;Gn,丶晓手;Gm,欧屮皇;Gk,清風拂楊柳,达蓋尔的旗帜;Gj,轻岚;Gi,玲迪斯;Gh,红胡子老大爷,风潇尘,灬火锅灬;Gg,张小鑫灬;Gd,蓝雨丨財神,红尘壹,丨往后余生",["罗宁"] = "Go,段明懒;Gm,方无应;Gk,萌禽;Gg,Kuiy,贝欧尼塔,箐箐点点,颈儿鹿;Gf,Tsunamireb;Ge,裹诗布;Gd,神裂丶火織,陵叁",["利刃之拳"] = "Go,Kennys;Ge,非常傲娇丷",["黑铁"] = "Go,旧城半夏丶灬;Gn,舊欢如梦;Gm,木荷;Gd,雏蜂",["冰风岗"] = "Go,普罗德莫尔欧;Gn,Jnkdog;Ge,丿鹦鹉,暮雨流芸;Gd,冰炎的心,捂奶富江",["朵丹尼尔"] = "Go,叶落西风;Gd,小赫哲",["熔火之心"] = "Go,千鳥淵愛音,冬馬和紗;Gn,此言差矣丨;Gm,拓跋野",["燃烧之刃"] = "Go,领丨舞,丶领灬舞;Gn,故里归长安,帅气的二狗子;Gl,潇洒的二狗子;Gi,白的要命,無她㡉,骑飞机追大鹅;Gg,Maliksi;Gf,兮木;Gd,情迷丝滑德芙,辕丶偐,丶邦桑迪",["狂热之刃"] = "Go,Charcoal;Gn,枯星;Gj,鲸丶;Gi,鱼语愚",["哈卡"] = "Gn,一追雨一",["奥特兰克"] = "Gn,丶残雪",["霜之哀伤"] = "Gn,墨染流雲;Gl,背嵬军;Gh,小谢儿",["无尽之海"] = "Gn,得之坦然灬;Gl,二公子丶,黑啤枸杞茶;Gg,小海棠丶",["月光林地"] = "Gm,偏离水平线;Gd,朝露",["布兰卡德"] = "Gm,肉酱酱丶,性能专家皮威;Gk,咸鱼咆哮;Gi,桃乃木香,小禾禾;Gg,低調丨河尐马;Gf,我有大苹果;Ge,Fallxu,吃飯就像打仗;Gd,同光十三绝,个记刮三了",["诺兹多姆"] = "Gm,落基;Gk,阿奴丶",["玛法里奥"] = "Gm,沐沨",["???"] = "Gm,胖之明;Gj,防骑铁驮;Gi,夜訫丶无颜月",["梦境之树"] = "Gm,Spaghetti,冰法丶丶",["伊利丹"] = "Gm,桂妮薇娅",["风行者"] = "Gm,瞧不上不爽;Gl,尛丶白;Gd,醉红尘,猎红尘,雁过拔毛、",["伊萨里奥斯"] = "Gm,一不一不;Gg,圣光一号技师,肖杰在线;Ge,浴花泪血;Gd,咎丶",["影之哀伤"] = "Gm,何以为安丶;Gl,这杯奶茶很腻,Vincemage;Gj,熱血乄妖哥;Gg,铭丶魔猎,拘灵遣将;Ge,一午夜骚男一,壹三;Gd,视众生如蝼蚁",["幽暗沼泽"] = "Gl,Douziwoer;Gf,痞猫猫",["鬼雾峰"] = "Gl,胡歌;Ge,吃飯就像打仗",["巴纳扎尔"] = "Gl,忆沫",["风暴之眼"] = "Gl,红颜觊觎;Gg,Deathdancing",["加里索斯"] = "Gl,陆小凤的中指,陆小凤的手指,陆小凤的食指",["天空之墙"] = "Gl,元気咸柠七;Gf,俯视太阳",["加基森"] = "Gl,僧坦;Gd,塞德里克杀",["红云台地"] = "Gl,囵囝",["芬里斯"] = "Gl,Emolieshou",["克尔苏加德"] = "Gl,散散步约约会;Gj,暗夜丶;Gi,冷月",["诺莫瑞根"] = "Gl,死亡金属",["丽丽（四川）"] = "Gl,遗忘初心;Gk,一眼入魂;Gf,鷓鴣菜;Gd,情霜恶",["远古海滩"] = "Gl,星光永烁",["加尔"] = "Gl,加勒比丶海带",["血色十字军"] = "Gk,东风快递员;Gf,氵缘丷;Ge,陈大皮,丶小琻毛",["亚雷戈斯"] = "Gk,立顿花茶",["银松森林"] = "Gk,妙脆角斗士;Gg,熾天使之翼丶",["风暴之鳞"] = "Gk,蒙牛哎哟喂",["自由之风"] = "Gk,知世丶",["诺森德"] = "Gk,追风大叔",["鹰巢山"] = "Gj,不让叫豆豆;Gi,Wzix",["奥尔加隆"] = "Gj,辛多雷之刃;Gd,小贼贼",["古尔丹"] = "Gj,阿尔托莉亜;Gi,凉城乄",["丹莫德"] = "Gj,玛格汉子",["阿格拉玛"] = "Gj,树下小白",["羽月"] = "Gj,雲之诗",["阿拉希"] = "Gj,格尔鲁什;Gd,小猫汪汪叫",["达斯雷玛"] = "Gj,左一的暗号",["巨龙之吼"] = "Gj,依然愤怒",["杜隆坦"] = "Gj,Feibo",["艾萨拉"] = "Gj,鄙人不擅奔跑",["法拉希姆"] = "Gj,戏听淸影横笛",["阿古斯"] = "Gi,宁波射手王;Gf,武涛;Gd,学习路上",["提瑞斯法"] = "Gi,姜似",["米奈希尔"] = "Gi,解丷星恨",["塞纳留斯"] = "Gi,黎若雨",["雏龙之翼"] = "Gi,风王;Gd,幽默的老张",["黑锋哨站"] = "Gi,咖喱丶牛肉",["霜狼"] = "Gi,郡千景",["瓦里玛萨斯"] = "Gi,回眸筱開心",["玛洛加尔"] = "Gi,加拿大电鳗",["格雷迈恩"] = "Gh,桂纶镁丶",["风暴之怒"] = "Gh,飘流的北风;Gd,兔兔丷",["壁炉谷"] = "Gh,奶大德",["地狱咆哮"] = "Gh,灵魂超度",["符文图腾"] = "Gg,万事屋喔,万夫不当,万佛朝宗;Gd,大神宗山君",["双子峰"] = "Gg,你丑你先睡",["奥杜尔"] = "Gf,内收霸气",["巴尔古恩"] = "Gf,春江花月夜丶",["布莱恩"] = "Ge,满包子",["纳克萨玛斯"] = "Ge,粉沫",["山丘之王"] = "Ge,可哀的馒头",["千针石林"] = "Gd,黄叶轻轻跳",["雷克萨"] = "Gd,你给我奔放点",["达纳斯"] = "Gd,Romeo",["红龙军团"] = "Gd,花落雨",["麦姆"] = "Gd,丷栀寒",["奥达曼"] = "Gd,生命的救赎",["卡德加"] = "Gd,小凉湿手",["雷斧堡垒"] = "Gd,阿季米德",["永恒之井"] = "Gd,郁闷的大脸猫"};
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