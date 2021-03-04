local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["安苏"] = "Sd,研究本质;Sc,丨干饭王丨;SS,脆脆鲨威化;SP,福星凸肥圆",["埃德萨拉"] = "Sd,桃溪春野;SV,Occoc",["阿古斯"] = "Sd,汉堡王;SW,余生丫丫",["无尽之海"] = "Sd,七月琴风丶;Sb,漫步游走;SW,莫甘那,颜凉;SS,风北离",["白银之手"] = "Sd,王宇光的爷爷,大风儿;Sc,我想看风景呀,乌瑟尔宁;Sb,路上有我;Sa,纯爱戰神,卑微小火法;SR,绯红的樱桃梗;SQ,暗夜星之矢,逆臣贼子;SP,宁風,漫行猫,牧过不留人",["国王之谷"] = "Sd,小毛贼丁丁;SS,军痞壮熊;SR,慕思蛋糕",["战歌"] = "Sd,胖子丶骑士",["布兰卡德"] = "Sd,山豆玩魔獸",["恶魔之魂"] = "Sd,盐酸哌替啶",["凤凰之神"] = "Sd,湘烟;Sb,矜持,灵魂兽医;Sa,墨霄丶;SW,吕桂花,我为部落狂;SV,雯雯灬;SQ,麻辣丶牛蹄筋,枕上诗书;SP,裤头里拉风,胖熊猫会武功,一抹天晴",["克尔苏加德"] = "Sd,丶天师傅",["主宰之剑"] = "Sd,翎丨翊;SV,芙列雅,大狗熊;SU,掌中萌虎丷;SS,游来游去的猫;SR,懿橙;SQ,集火那个戰士;SP,貝优妮塔",["死亡之翼"] = "Sd,物欲;Sc,Willett;SW,小熊熊暴凶;SV,恶魔的微笑;SU,一劍丨御风雷,刘大篮子;ST,丿蛋灬蛋,Olala;SS,猫粮,你闺蜜咧;SR,林月茹丶,筱萌喵;SQ,丷怜香丷;SP,七星鎏虹",["格瑞姆巴托"] = "Sd,沐若飒;Sc,白银丶奥格,糖门掌门人;Sb,小恶魔丶雯,是妳转身路过;Sa,咒炎丶怨曲;SV,阿雯丶;ST,万般变幻由心;SS,熊猫咕奶奶;SR,夏晨晨",["伊瑟拉"] = "Sc,桃玑",["血色十字军"] = "Sc,凤梨蓝莓;SV,一直很任性,骑猪追火箭丶;ST,疫病之吻;SQ,Desitiny;SP,尘曦光枫",["燃烧之刃"] = "Sc,林依依,Tlk;SV,臻蓝,梦中恶魔;SU,深林见鹿;ST,Kpistols;SS,梓喵酱;SR,爆炸的宝宝坚;SP,白雲苍狗丶,將灬進酒",["蜘蛛王国"] = "Sc,Ckcraft",["哈兰"] = "Sc,沫沫智",["奥斯里安"] = "Sc,和谐当道",["霜之哀伤"] = "Sc,奶油饼干魔王",["麦迪文"] = "Sb,小尼豆",["冰风岗"] = "Sb,绯绯;SQ,弎少",["艾维娜"] = "Sb,幸运女神合体",["熊猫酒仙"] = "Sb,再看把你喝掉,饿了吗;SR,糍饭团子,谨言;SQ,追光语者,墨一火,远去的风景;SP,肥仔风暴烈酒",["金色平原"] = "Sa,埃尔南多;SU,古达老师;ST,残忍的软泥兔;SP,俗了清风",["迅捷微风"] = "Sa,啊阿啊阿,啊阿啊啊",["影之哀伤"] = "Sa,水土木月;SW,愤怒的子弹;SV,阿奶的激活;SU,哀伤之烬;ST,不会起門吖,振翅引发海啸;SQ,陈哈尔滨啤酒",["贫瘠之地"] = "Sa,丶润物细无声;SW,明月别枝;SR,丶丿残影",["利刃之拳"] = "Sa,灬绿豆灬;ST,特战队长",["龙骨平原"] = "Sa,绝对双刃",["萨尔"] = "Sa,達芙妮",["回音山"] = "SW,Zzhh;SU,性格变态丶",["奥尔加隆"] = "SW,叶之轩",["火焰之树"] = "SW,格子的夏天;SV,魔兽胃必治",["???"] = "SW,汼汼;SS,Cyy",["杜隆坦"] = "SW,暗香倾城",["罗宁"] = "SW,国服第一骚法;SU,遗忘泪滴,Panacea;SS,开打;SR,Buzzkill;SQ,狂毛,佩罗罗奇诺丶",["海克泰尔"] = "SV,桔子味丶馒头;SU,罐罐",["试炼之环"] = "SV,南风知我意丶",["永恒之井"] = "SU,一页书;SS,若如雲心",["玛瑟里顿"] = "SU,風之天際",["艾露恩"] = "ST,李风",["亚雷戈斯"] = "ST,摩挲影魅",["冰霜之刃"] = "ST,暗夜丶绮玉",["末日行者"] = "SS,彼岸行僧;SQ,牛油果夹馍",["烈焰峰"] = "SS,Artemin",["迦拉克隆"] = "SS,Ayasy",["暗影迷宫"] = "SS,百年好合",["鬼雾峰"] = "SS,格洛古",["丽丽（四川）"] = "SS,比特币升值器;SQ,铁甲小宝丶;SP,打不过就虚弱",["索瑞森"] = "SR,丶绫波丽;SP,小柯同学",["奥特兰克"] = "SR,Possession",["古尔丹"] = "SR,典狱长",["伊利丹"] = "SR,小妞向前冲",["桑德兰"] = "SR,巭熊熊",["伊森利恩"] = "SR,暗影之境丶纞;SQ,灬雷鸣",["巨龙之吼"] = "SQ,锝彩",["阿纳克洛斯"] = "SQ,雷霆之怒風",["太阳之井"] = "SQ,圣屠",["蓝龙军团"] = "SP,贝贝泰迪",["诺兹多姆"] = "SP,带朱狂粉四号",["戈提克"] = "SP,毛泡泡",["泰兰德"] = "SP,来二两"};
local lastDonators = "有点怕-格雷迈恩,塞布罗斯-贫瘠之地,暗影卫队-贫瘠之地,亚瑟塞维尔-伊森利恩,帝霸服-燃烧之刃,白玉亰-燃烧之刃,世世-龙骨平原,大侠丶别打脸-凤凰之神,别慌丶不要动-冰霜之刃,单唰女生宿舍-回音山,皮开优-影之哀伤,宇智波皮氧-格瑞姆巴托,从小就很萌-洛肯,扶墙继续奶-熊猫酒仙,影月-霜狼,图拉灬牛-血色十字军,寒露-埃霍恩,来二两-泰兰德,貝优妮塔-主宰之剑,福星凸肥圆-安苏,毛泡泡-戈提克,一抹天晴-凤凰之神,將灬進酒-燃烧之刃,七星鎏虹-死亡之翼,牧过不留人-白银之手,胖熊猫会武功-凤凰之神,漫行猫-白银之手,带朱狂粉四号-诺兹多姆,贝贝泰迪-蓝龙军团,裤头里拉风-凤凰之神,宁風-白银之手,尘曦光枫-血色十字军,俗了清风-金色平原,肥仔风暴烈酒-熊猫酒仙,白雲苍狗丶-燃烧之刃,小柯同学-索瑞森,打不过就虚弱-丽丽（四川）,远去的风景-熊猫酒仙,丷怜香丷-死亡之翼,弎少-冰风岗,逆臣贼子-白银之手,枕上诗书-凤凰之神,陈哈尔滨啤酒-影之哀伤,圣屠-太阳之井,灬雷鸣-伊森利恩,麻辣丶牛蹄筋-凤凰之神,暗夜星之矢-白银之手,雷霆之怒風-阿纳克洛斯,Desitiny-血色十字军,矜持-凤凰之神,锝彩-巨龙之吼,铁甲小宝丶-丽丽（四川）,集火那个戰士-主宰之剑,墨一火-熊猫酒仙,佩罗罗奇诺丶-罗宁,牛油果夹馍-末日行者,追光语者-熊猫酒仙,狂毛-罗宁,丶丿残影-贫瘠之地,筱萌喵-死亡之翼,夏晨晨-格瑞姆巴托,暗影之境丶纞-伊森利恩,巭熊熊-桑德兰,小妞向前冲-伊利丹,典狱长-古尔丹,爆炸的宝宝坚-燃烧之刃,谨言-熊猫酒仙,慕思蛋糕-国王之谷,绯红的樱桃梗-白银之手,懿橙-主宰之剑,Buzzkill-罗宁,Possession-奥特兰克,糍饭团子-熊猫酒仙,林月茹丶-死亡之翼,丶绫波丽-索瑞森,比特币升值器-丽丽（四川）,格洛古-鬼雾峰,风北离-无尽之海,你闺蜜咧-死亡之翼,游来游去的猫-主宰之剑,开打-罗宁,若如雲心-永恒之井,百年好合-暗影迷宫,脆脆鲨威化-安苏,熊猫咕奶奶-格瑞姆巴托,梓喵酱-燃烧之刃,猫粮-死亡之翼,Ayasy-迦拉克隆,Artemin-烈焰峰,彼岸行僧-末日行者,Cyy-???,军痞壮熊-国王之谷,疫病之吻-血色十字军,特战队长-利刃之拳,Olala-死亡之翼,Kpistols-燃烧之刃,暗夜丶绮玉-冰霜之刃,摩挲影魅-亚雷戈斯,万般变幻由心-格瑞姆巴托,丿蛋灬蛋-死亡之翼,振翅引发海啸-影之哀伤,不会起門吖-影之哀伤,李风-艾露恩,残忍的软泥兔-金色平原,刘大篮子-死亡之翼,深林见鹿-燃烧之刃,罐罐-海克泰尔,性格变态丶-回音山,掌中萌虎丷-主宰之剑,Panacea-罗宁,風之天際-玛瑟里顿,遗忘泪滴-罗宁,哀伤之烬-影之哀伤,一页书-永恒之井,一劍丨御风雷-死亡之翼,古达老师-金色平原,魔兽胃必治-火焰之树,梦中恶魔-燃烧之刃,阿雯丶-格瑞姆巴托,大狗熊-主宰之剑,臻蓝-燃烧之刃,南风知我意丶-试炼之环,骑猪追火箭丶-血色十字军,阿奶的激活-影之哀伤,桔子味丶馒头-海克泰尔,雯雯灬-凤凰之神,恶魔的微笑-死亡之翼,一直很任性-血色十字军,Occoc-埃德萨拉,芙列雅-主宰之剑,国服第一骚法-罗宁,暗香倾城-杜隆坦,汼汼-???,格子的夏天-火焰之树,小熊熊暴凶-死亡之翼,我为部落狂-凤凰之神,叶之轩-奥尔加隆,余生丫丫-阿古斯,Zzhh-回音山,颜凉-无尽之海,莫甘那-无尽之海,吕桂花-凤凰之神,明月别枝-贫瘠之地,愤怒的子弹-影之哀伤,卑微小火法-白银之手,達芙妮-萨尔,绝对双刃-龙骨平原,灬绿豆灬-利刃之拳,咒炎丶怨曲-格瑞姆巴托,丶润物细无声-贫瘠之地,水土木月-影之哀伤,纯爱戰神-白银之手,墨霄丶-凤凰之神,啊阿啊啊-迅捷微风,啊阿啊阿-迅捷微风,埃尔南多-金色平原,是妳转身路过-格瑞姆巴托,灵魂兽医-凤凰之神,饿了吗-熊猫酒仙,再看把你喝掉-熊猫酒仙,幸运女神合体-艾维娜,路上有我-白银之手,漫步游走-无尽之海,小恶魔丶雯-格瑞姆巴托,绯绯-冰风岗,小尼豆-麦迪文,矜持-凤凰之神,Tlk-燃烧之刃,丨干饭王丨-安苏,乌瑟尔宁-白银之手,奶油饼干魔王-霜之哀伤,Willett-死亡之翼,和谐当道-奥斯里安,我想看风景呀-白银之手,沫沫智-哈兰,Ckcraft-蜘蛛王国,林依依-燃烧之刃,糖门掌门人-格瑞姆巴托,凤梨蓝莓-血色十字军,白银丶奥格-格瑞姆巴托,桃玑-伊瑟拉,沐若飒-格瑞姆巴托,物欲-死亡之翼,翎丨翊-主宰之剑,丶天师傅-克尔苏加德,湘烟-凤凰之神,大风儿-白银之手,盐酸哌替啶-恶魔之魂,山豆玩魔獸-布兰卡德,胖子丶骑士-战歌,小毛贼丁丁-国王之谷,王宇光的爷爷-白银之手,七月琴风丶-无尽之海,汉堡王-阿古斯,桃溪春野-埃德萨拉,研究本质-安苏";
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