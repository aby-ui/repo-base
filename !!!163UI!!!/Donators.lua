local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,大江江米库-雷霆之王,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔,圣子道-回音山,荼麟、濤-贫瘠之地,Bloodtd-死亡之翼,Darkage-洛丹伦,轩辕银月-雷克萨,我的夜茉莉-法拉希姆,沃迪玛-迦拉克隆,萌萌的尐熊猫-死亡之翼";
local recentDonators = {["格瑞姆巴托"] = "D2,赦殇;D1,沐血残衣,吾乃星期四,吉祥,Fredie,德燚,孤独怪喵,丶小月饼儿,丹丹龙",["罗宁"] = "D1,Quinzel,你丶的益达,月曜輪迴;D0,年幼的小伙伴,扭曲的机器",["伊森利恩"] = "D1,圈住那个九,丨抖妇乳丶,黑米糕真好吃;D0,团队核心毒瘤,宝先生,落寞如画",["黑铁"] = "D1,世博一傻,吉米丶雷诺,梦灬夜幽;D0,清爽的风丶",["军团要塞"] = "D1,紫罗兰之心,夜月牧牧",["天空之墙"] = "D1,聖光無双",["安苏"] = "D1,天桥王医生,岚笙,林八两,柔情美汐;D0,百樂",["燃烧之刃"] = "D1,冷色渐变,大碗君,浦饭幽助,狱婪,一万个为什么,哈哈木头;D0,孓子孑,狸小忆,间接正犯,阿喀鎏斯丶",["桑德兰"] = "D1,荦荦丶,芥末辣根",["贫瘠之地"] = "D1,苟住别送,苟旦,Movinghonor,熄梦,淼淼姑,臘梅;D0,圣光阿兴,红魔族悠悠,苴麻,Luckydepapa,孤身往里游丶",["迅捷微风"] = "D1,吉俺娜小粉丝;D0,四眼小牧",["末日行者"] = "D1,提笔绘倾城;D0,老子是书童,十万城管",["轻风之语"] = "D1,艾梅达儿",["加尔"] = "D1,深渊大叔",["时光之穴"] = "D1,暴风小奶狗",["瑟莱德丝"] = "D1,圣光的洗礼",["凤凰之神"] = "D1,柒月小短裙;D0,恒记煲仔饭",["布兰卡德"] = "D1,鲨弋;D0,无鴉夫",["无尽之海"] = "D1,非清蒸猪肉丸,亦雨凡尘,爷最醒目,蕾丝裹胸,呢喃的花火;D0,夏天爱上西瓜,大乘期小浩浩",["白银之手"] = "D1,三重哈德门,愚蠢喵星人,蓝色焱翼,尔摩德罗普,雾歌大魔王,張老白,疾風魅影,圣灵瓦娜斯,迪菲亞;D0,追逐圣光丶",["国王之谷"] = "D1,传说中的圣光,丶常威丶;D0,最后一只萝莉,小灬星星,浪子哥哥,缺德别听慢歌,Giligileye",["玛里苟斯"] = "D1,晓风满画楼",["影之哀伤"] = "D1,阿部坤,哒哒拉;D0,五修黑装德,黎明的救赎,神之佑守",["回音山"] = "D1,Seeles;D0,无用之木,怡丽丹笯沨,你和我的故事",["主宰之剑"] = "D1,进击的小软,五又三分之二;D0,凰丶羽,何堂叶色,柠檬小菊茶,日月空,武道独行者,落木潇潇丶",["达纳斯"] = "D1,灭日碎星",["冰霜之刃"] = "D1,羽墨卿尘;D0,战歌之舞",["托尔巴拉德"] = "D1,晴方好",["丽丽（四川）"] = "D1,三生花;D0,华大帅,坂田银子",["血色十字军"] = "D1,Dreamter,假发阻击手;D0,我妻卡哇伊,翡翠梦行者",["幽暗沼泽"] = "D1,剑四",["耳语海岸"] = "D1,消失的圣光",["迦拉克隆"] = "D1,牛丄,韵动人心",["奥蕾莉亚"] = "D1,月影凌风",["死亡之翼"] = "D1,Kuxiaxia,雷爆馒头,红烧小兔子,奥塔玛螺旋丸,幼清的太妃糖,哑巴会唱歌;D0,丿血蹄丿,丷织夏丷,丷丷小布丁,傲斗大魔王,星屑丶砂时计,丛頭越",["燃烧平原"] = "D1,十年悠悠",["卡拉赞"] = "D1,古丶铁,Archmage",["冰风岗"] = "D1,翻滚吧豆豆君;D0,李大炮筒",["奥特兰克"] = "D1,飘零的菜叶",["弗塞雷迦"] = "D1,悲伤新娘",["亚雷戈斯"] = "D1,刀枪箭戟",["雷斧堡垒"] = "D1,粼粼",["熊猫酒仙"] = "D1,蔚蓝风暴,山海不可平;D0,黯淡的星光,愤怒丨敦敦,每天都是祝福",["诺森德"] = "D1,水煮牛肉片",["霜之哀伤"] = "D1,剑聖晨曦",["雷霆之王"] = "D1,雲梦轩;D0,Cyrus",["菲米丝"] = "D1,非常刘嘉忆",["安其拉"] = "D1,上仙;D0,史密斯葛优",["寒冰皇冠"] = "D1,丧钟回响;D0,消失躲点名",["雷霆之怒"] = "D1,淡蓝色果汁",["安东尼达斯"] = "D1,Gikalo",["盖斯"] = "D1,大洋马",["海克泰尔"] = "D1,钢铁加鲁鲁,Nutrilon,刺心的温柔",["神圣之歌"] = "D1,咸鱼微笑,后跳闪到腰",["加基森"] = "D1,丨鬼手帕丨",["???"] = "D1,好几百只熊猫;D0,瑾少走路带风;Dz,Yagamiyoru;Dy,车车仔,腾格尔丶冽风,厦门煸豆干;Dx,玛力怒,老山虎;Dw,缇丝托莉亚;Du,死莲一朵,橙十三辣;Dt,兽性大发塔塔",["奥达曼"] = "D1,Vesper",["永夜港"] = "D1,摸骨算命",["伊萨里奥斯"] = "D1,离梦蝶;D0,八神",["梅尔加尼"] = "D1,牛哥当自强,阿叔圆滚滚",["斩魔者"] = "D1,妙曼小妖;D0,小軟好好吃",["玛洛加尔"] = "D1,一刀温柔;D0,突破極限",["烈焰峰"] = "D1,洛天丨嗯哼;D0,伊卡洛斯之翼",["刀塔"] = "D1,着床",["梦境之树"] = "D1,黑云飘雪",["卡德罗斯"] = "D1,我将带头搞事",["黑石尖塔"] = "D1,二月逆流",["黄金之路"] = "D1,七彩的素描",["暗影之月"] = "D1,一阿鬼一;D0,雪剑仇",["生态船"] = "D1,丶南有乔木;D0,阿斯塔洛猎手",["克尔苏加德"] = "D0,杨柳小叶儿,卟哩啾啾,夜雨星泪",["甜水绿洲"] = "D0,柒夜聊呀",["拉文凯斯"] = "D0,等一个人咖啡",["萨尔"] = "D0,社会可达鸭",["奎尔萨拉斯"] = "D0,Hardees",["埃加洛尔"] = "D0,没有什么偶然",["黑龙军团"] = "D0,秋天有风",["太阳之井"] = "D0,乄军用馒头乄",["埃德萨拉"] = "D0,瑟兰迪尓,烟花丶易冷,煙花易冷丶,仲夏雨",["巨龙之吼"] = "D0,陈老板",["血环"] = "D0,枫羽之歌,七黑费",["阿尔萨斯"] = "D0,Buring",["艾露恩"] = "D0,卡斯蒂月歌",["扎拉赞恩"] = "D0,卐牧奶医卍",["斯克提斯"] = "D0,古丽古丽",["破碎岭"] = "D0,湛蓝陨石巨剑",["古尔丹"] = "D0,酒醉梨錵",["卡德加"] = "D0,骑士默默。",["熔火之心"] = "D0,熊猫佩奇",["鹰巢山"] = "D0,凝惜",["达文格尔"] = "D0,床前没月光,柳成荫",["狂热之刃"] = "D0,黑白两相忘",["托塞德林"] = "D0,贱贱的想祢"};
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