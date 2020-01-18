local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["格瑞姆巴托"] = "L6,残兵令;L5,吻技差;L3,老胖虎,百合折丨;L2,木有宝宝,花鸢丷;Ly,周香香,引美美;Lx,維瑟米尔;Ln,咕嘿嘿",["白银之手"] = "L5,东门斩兔,杉沐杉沐,大神丨宅,暗柔清似水,歌渔乐;L4,嘎嘣脆火锅鸡;L3,冬天猫,温暖终年不遇,琪露诺老师,海钓地藏;Ly,爱国者之子;Lx,可樂貓臉豬,妖仙丶法逍遥,凡妇俗子;Lw,印第安纳琼斯;Lv,孤夜寒凌;Lu,偷灬訫,魔法见闻录,阿良良木火怜,防波亭鬼灯;Lt,苍穹落幕,士官长丨丨乁;Ls,老熊猫,小吱大人,运骑;Lr,、烟雨平生;Lo,比尤提佛,千羽清,藻头小狂暴",["激流堡"] = "L5,珀耳修斯",["塞拉摩"] = "L5,凌梦长",["燃烧军团"] = "L5,孙总",["亡语者"] = "L5,讷于言敏于行",["凤凰之神"] = "L5,毒瘤老虾米,卯之花烈,灬渡你成魔丶,朵力;L4,丘山红叶,塔心乂譁,超甜小豆浆,天堂与利刃,气气莫迟疑;L3,心碎还要逞强,我爱谢宝宝,钉铛,醉漾轻舟,三生无梦,Vilgefortz;L1,稻香村香芋酥,白云烟;Lz,Zebolonsky;Ly,丶茶衣,我爹爹;Lw,变态丶;Lv,油腻噶,激励的阿然然;Lq,临风望抒;Ln,南京陈伟霆,黄昏后的祈望,小襄襄",["燃烧之刃"] = "L5,晴朗的天空;L4,紫星河,威尔昂赛汀;L3,凝云丶雪舞,Sakurai,别抢棉花糖;L2,露拉拉灬;L1,咕咕作响;Lx,Sunadokei;Lw,大德无疆;Lv,乂血之舞乂;Ls,暴躁的龙爸爸;Lp,混沌丶橙,枸杞威士忌;Lo,鬼迷心窍了",["死亡之翼"] = "L5,空条承大郎;L4,湮火流年;L3,蜡笔海盗,拯救华语乐坛,爫口爫,夫唯不爭,林有钱,温柔的驾驭你,章魚妞,超火流星,疯医七世,誘人的煎牛排,宇文杀生;Lw,祖达萨绿巨人,东京不热,夏沫小米;Lv,不会不练;Lt,丶天下无贼,Sakuraxi,Sakurami;Ls,塞林静刃",["迦拉克隆"] = "L5,紅鳶;L3,㐅豆儿粥;Lz,唯一的温存",["伊森利恩"] = "L5,猪猪侠,米蕾妮亚,狂岚丶;L3,老夫一抬腿,大明星波克比;Ly,米妮丶;Lw,终极潘老瘪,麻衣酱;Lv,顾执哥",["无尽之海"] = "L5,跟上灬小牧;L3,你就是旋律;Lr,深情不及玖伴",["月光林地"] = "L5,火墙火墙火墙",["主宰之剑"] = "L5,猫悠悠,匪号丶流氓,冯小倩,丿瓦蕾拉乀,彩鱗;L3,Yahaha;Ly,土吐;Lw,云上飞;Lv,趣致彼尔德;Lu,龍灬骑仕;Ls,回眸映斜阳",["迅捷微风"] = "L5,灵异学家;Lz,Schiffer",["暗影之月"] = "L5,史蒂芬辀;Ly,丶唯依丶",["血色十字军"] = "L5,尖叫的柠檬;L4,阿呆丶丶,阿呆呆,萌戦姬,吴二乂,范尼丝特鲁伊;L3,你来捅死我啊,人间仙子;Lz,六點柒;Ly,土御门御姬,Shuor;Lw,筱懒猫乄;Ls,清川永路何极;Lr,炫雨夜;Lq,寒风生铁衣",["轻风之语"] = "L5,无人生还",["激流之傲"] = "L5,黄有钱",["国王之谷"] = "L5,林丰收;L4,萌萌小巡警;L3,轻吟一句情话;Lo,鐵血戰鷹",["克尔苏加德"] = "L5,真的汉子;L4,墨舞劍意",["???"] = "L5,青尘丶,冰红茶;L4,丶沐雨澄风;L1,咕德丿猫狞",["麦迪文"] = "L5,Dhcctv",["埃德萨拉"] = "L5,佲汜;Lz,开心饮过酒丶",["安苏"] = "L4,大肥豚豚,海沃德;L3,逼逼糕,辉耀之击,南辰希丶;Ly,晨风丿;Lx,玉龙;Ls,幻夜冰封;Lq,目秀眉倾,平民;Lp,七吋男儿;Lo,枫椛樰枂;Ln,幸运鼠",["耐普图隆"] = "L4,迦列斯",["希尔瓦娜斯"] = "L4,蔡靓猪",["普罗德摩"] = "L4,南梅线",["回音山"] = "L4,嗨丶英雄;Ln,Samcy",["冰霜之刃"] = "L4,苏苏洛,Yaksa;L2,大宗师灬;Lx,一捧阳光",["罗宁"] = "L4,司辰,原来是熙熙啊;L3,Troyesivan;Lx,赛雷;Lv,雨落忧殇,云轻轻丶,夏初晴,Moonangel;Lu,米尼斯特;Lt,糾結的小蘿莉,機智的小蘿莉",["狂热之刃"] = "L4,弑风者沙恩;Lx,飞天小猪罗",["影之哀伤"] = "L4,卡布奇诺",["阿拉希"] = "L4,Tine;Lo,白衣庵阿美",["布兰卡德"] = "L4,终焉权利;L3,丑萌大布娃娃,狂暴的牛鞭;L1,阿通丨",["时光之穴"] = "L4,一毒奶一",["海克泰尔"] = "L4,惊无命;L2,美年哒丶",["冰风岗"] = "L4,阿洛洛丶;L1,丶返璞归真",["贫瘠之地"] = "L3,Libero,就是不拉你,翡翠灬燃;Ly,凉寻暮晚;Lv,短腿猫爱吃魚;Lu,一路展宏图;Lr,小河太连清;Ln,梧桐栖木,露米娜斯阳痕",["盖斯"] = "L3,邦桑迪之息",["伊利丹"] = "L3,Fourie",["拉文凯斯"] = "L3,路过的神父,Van;Lz,嘻哈诗人",["末日行者"] = "L3,好运姊,憨憨德,夜月之魂,别搞事儿吧;Lu,Casually;Lp,Maybesomeday",["梦境之树"] = "L3,Yxqcovo",["霜之哀伤"] = "L3,流霜似霞",["诺兹多姆"] = "L3,Misying;L1,黄龙仙",["埃苏雷格"] = "L3,海释灵",["泰拉尔"] = "L3,魔夜风",["壁炉谷"] = "L3,我是一支花",["格雷迈恩"] = "L3,猫七七",["阿古斯"] = "L3,贫僧法号神棍;Lu,时菊芳仙酝",["卡德加"] = "L3,Mariandel",["鬼雾峰"] = "L2,寒霜之翼",["阿曼尼"] = "L2,小卡,小卡开坦克",["阿尔萨斯"] = "L2,七曜的贤狼",["月神殿"] = "L1,丶洛水",["巴瑟拉斯"] = "L0,黑风双萨,爱祢卟变",["玛洛加尔"] = "L0,北方的灬北方",["冬泉谷"] = "L0,幽魂暗影",["熊猫酒仙"] = "L0,申丶小猴;Lw,黑色丛林",["试炼之环"] = "Lz,珍珠蛋挞",["寒冰皇冠"] = "Lz,心随晶晶",["风暴峭壁"] = "Lz,小祖冢,小祖塚",["烈焰峰"] = "Lz,以瑜之名",["金色平原"] = "Lz,千岩高卧",["纳克萨玛斯"] = "Ly,Ee",["熔火之心"] = "Ly,我可是酱爆呀",["闪电之刃"] = "Ly,天选之人",["死亡熔炉"] = "Lx,蛋挞",["艾森娜"] = "Lx,睡梦方醒,魂斗骑",["风暴之怒"] = "Lx,平清盛;Ln,夏沫浅雨",["阿克蒙德"] = "Lv,逮虾户",["破碎岭"] = "Lv,倚楼听雪;Lr,黄昏中的爱",["米奈希尔"] = "Lv,Yanga",["黑暗之门"] = "Lu,库卡隆",["加兹鲁维"] = "Lt,七九八十一,剑风凉",["巴纳扎尔"] = "Ls,Ty",["奥尔加隆"] = "Lp,Amorstar",["安东尼达斯"] = "Lo,群星庭院院长",["永恒之井"] = "Lo,君忘",["丽丽（四川）"] = "Ln,丶半夏瑾年",["勇士岛"] = "Ln,平衡丶初代"};
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