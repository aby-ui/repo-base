local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["回音山"] = "Mj,滑蛋牛柳",["凤凰之神"] = "Mj,Kratos;Mi,胖小;Mh,性感丶小墩墩,暖乂风;Mg,小福妮,河豚的腮帮子,严陵山居士,水晶虾饺丶,Lovecc,空灵丿;Me,指尖的暧昧,灬演技派灬,鑫灶沐炙,俗人一个;Mc,邓超,微笑的泰丽莎;Mb,如歌嘹亮,情巅紫殇,Santafan",["燃烧之刃"] = "Mj,牛牛小武僧;Mh,江湖孤影,三吉彩花丶,皮皮滋,腐蚀乃梦兮丶,橙梨丶;Mg,秋楓紅葉落丶,百强剧组导演;Mf,小臭牛,擀面条;Me,Astraeas,鳳凰院凶真,Kanae,|奶|;Md,啵啵咚叭啦,红桃十九;Mc,茨木華扇,骑骑丶,阿板丶;Mb,可爱的大咕咕",["国王之谷"] = "Mi,最後灬大表哥,余江川丶;Mh,泰慌德,情话小红手;Mb,倒吸一口凉气",["血色十字军"] = "Mi,怯雨,南北丶,胶东王家卫;Mg,冰淇淋布丁,冰淇淋火法,冰淇淋骑士,冰淇淋死骑,冰淇淋血月,冰淇淋小德;Mf,孫涂特,欧买尬德;Mc,落小凡,猪哥的圣光,无夜丶,小叮猫,冰淇淋萨满,冰淇淋踏风,冰淇淋牛战,雪缤纷,冰淇淋战刃",["主宰之剑"] = "Mi,西蒙德里克,屠夫与少女,莫斯丶;Mh,觅心贼宝;Mg,Bearr;Me,山东大汉、;Mc,萨哒牡",["贫瘠之地"] = "Mi,坎沃德达奈子,黎明之锋;Mh,醉繁华,小森雾丶,坟头戏鬼;Md,Sakuramomoko,刺客狐铁花,Sharkchilli,霜麟,燚龍;Mc,两室一厅,冬柏;Mb,牛肉小面",["格瑞姆巴托"] = "Mi,飘羽,浪味仙乄,林允儿乀;Mh,云雾不是山;Mg,Tomhardy,一梦经年丶,十七帅;Mf,胆结石;Me,有奶的骑士,箫声震武林;Md,奶牛斩,天蝎法誓;Mc,秘境小钢炮",["末日行者"] = "Mi,流云夜殇;Mg,再打我试试灬,苏格兰小猪,泽城美雪;Me,消失的暗影,温良弓;Md,颠覆你的高傲;Mb,重庆小面丶",["雷斧堡垒"] = "Mi,流云雪衣;Md,薄凉尽昏晓",["布兰卡德"] = "Mi,成华区流氓;Mh,影魔丶;Mf,丶故里归长安,小狐仙儿;Md,克雷斯圣光;Mc,犬来八荒",["???"] = "Mi,艾森娜之赐,Cyunique;Mf,风烛悴月丶,曦宝宝丶;Ma,太阳进华沙伯爵",["白银之手"] = "Mi,丨联盟宝宝丨;Mh,小号总动员;Mg,朵猫猫丶,浅月迷离,羆羆,正太控丶奥兹,怀念终成灰烬;Me,铃羽酱,来英勇起,瑞雪乄游侠;Md,素颜双马尾;Mc,李羊",["影之哀伤"] = "Mi,尛包子;Mg,雷霆铁警;Mf,年少没有为;Md,熊猫骑骑,你的骑士,孤独的爵士",["死亡之翼"] = "Mi,跳跳神牛,藿香正气娃;Mh,欢乐荳;Mg,客官不可以,难搞噢;Me,门前大树下,浅夏丨影;Md,Vajragourd,电竞范德彪;Mc,碧瑶公子,小凡公子,蓝帆",["冰风岗"] = "Mi,丷撒拉弗丷;Mg,福尔图娜",["黑铁"] = "Mi,猩红香克斯",["红龙军团"] = "Mi,风影小小",["麦迪文"] = "Mi,维他柠懵茶",["熊猫酒仙"] = "Mi,Cohiba;Md,Pepperziegle",["埃德萨拉"] = "Mh,暴力造物;Mg,一氪赛艇;Mf,命运多舛",["卡拉赞"] = "Mh,洋葱德",["无尽之海"] = "Mh,基尔加熊;Mc,二十三号元素,普通的阿昆达;Mb,春风十里丶丶",["丹莫德"] = "Mh,Ginmzengzune",["伊森利恩"] = "Mh,油腻咖;Mg,小萝卜历险记;Mf,時間的對岸;Mb,孑琊",["金色平原"] = "Mh,嗨大个子稳住;Mb,茶顏悅色",["奥尔加隆"] = "Mh,没什么卯月;Me,嘤丶嘤丶嘤",["火烟之谷"] = "Mh,云刀斩仙",["阿古斯"] = "Mg,一旧游如梦一;Md,藝達晟",["安苏"] = "Mg,老衲动粗了;Md,王素芹,高猛酷大叔,Lokig;Mb,可爱丿小娘子",["诺森德"] = "Mg,托尔贝恩亲王;Mf,大丨萌徳",["泰兰德"] = "Mg,美到灵魂深处",["晴日峰（江苏）"] = "Mg,陌壹仟",["壁炉谷"] = "Mg,路西法",["冰霜之刃"] = "Mg,小花卷丶",["破碎岭"] = "Mg,无丶忧;Mb,小卷卷",["霜狼"] = "Mg,圣徒丨哀伤;Me,Lisztvon",["德拉诺"] = "Mg,雷蒙勃朗宁;Mb,Lappe",["摩摩尔"] = "Mg,萌萌大魔头",["银松森林"] = "Mf,神威天魔",["暗影议会"] = "Mf,凛音",["寒冰皇冠"] = "Mf,一只小奶狗;Md,阿肥;Mb,梦境之末",["迅捷微风"] = "Mf,纠结的鸟,雾魂的鸟;Me,狂暴的凹凸曼;Md,利威尔阿克曼",["恶魔之魂"] = "Mf,木子氺阑",["时光之穴"] = "Mf,殊茗",["迦拉克隆"] = "Mf,丨曾经的猎物;Me,有事秘书干",["亚雷戈斯"] = "Mf,幻舞灵动",["鬼雾峰"] = "Mf,沉默羔羊",["夏维安"] = "Me,Inno",["伊森德雷"] = "Me,傳說琦琦",["雏龙之翼"] = "Me,排骨笑苍生",["石爪峰"] = "Me,四七五带槽",["烈焰峰"] = "Me,晓钰",["风暴之鳞"] = "Me,唐僧肉",["伊瑟拉"] = "Me,挽风与你",["风暴之眼"] = "Me,大战争领主",["克尔苏加德"] = "Me,Anguss;Mb,盗禧",["丽丽（四川）"] = "Me,谢师傅;Mc,战神尤朵拉",["遗忘海岸"] = "Me,飞鹤达雷",["罗宁"] = "Md,我有两个蛋;Mb,咪法,卤鱼宴,Leserein",["奥特兰克"] = "Md,人造人阿萌",["奥蕾莉亚"] = "Md,铜墙铁壁",["白骨荒野"] = "Md,無敌小紅手",["织亡者"] = "Md,Monkiki",["伊莫塔尔"] = "Md,冉丶",["暗影之月"] = "Md,过往的一只",["符文图腾"] = "Md,鼎鼎丶敲可爱",["狂热之刃"] = "Md,临冬城艾莉娅;Mc,婧灬主任",["血环"] = "Mc,猴子请的逗笔",["伊利丹"] = "Mc,刑事组曹达华",["龙骨平原"] = "Mc,纳豆加葱;Mb,暴走的格布林,六月的猴儿",["格雷迈恩"] = "Mc,灬渔灬",["阿纳克洛斯"] = "Mc,黎明清风",["埃霍恩"] = "Mc,再战十年",["安其拉"] = "Mc,冲锋踩香蕉",["菲米丝"] = "Mc,小魔猩",["塞纳留斯"] = "Mb,春风沉醉",["萨格拉斯"] = "Mb,连若菡",["洛萨"] = "Mb,梦中慧眼识君"};
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