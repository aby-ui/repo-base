local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,闪亮的眼睛丶-死亡之翼,空灵道-回音山,瓜瓜哒-白银之手,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,释言丶-伊森利恩,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,坚果别闹-燃烧之刃,冰淇淋上帝-血色十字军,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,短腿肥牛-无尽之海,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["蜘蛛王国"] = "Hl,浪漫豆豆;Hj,伊沐雪一光羽",["安苏"] = "Hl,一心收复月球,丨萨摩耶;Hk,Vampirina;Hj,有利奈绪丶;Hh,驷马难追一牛",["诺兹多姆"] = "Hl,桥归桥路归路;Hi,铁血刑警",["白银之手"] = "Hl,乌云盖雪胖喵,冷月凝霜丶;Hj,小饥渴真好吃,妖妖的小贼;Hi,一切为了祖国,奔奔蹦蹦;Hh,打呼噜打熊猫;Hg,吃饭没有,潮牌潮牌二哥,团团熊屁",["贫瘠之地"] = "Hl,不如丿不见;Hk,梅花三弄,岁月无忧;Hj,淡淡的超人;Hi,伊藤,洪夕颜;Hg,巫咸大人",["奥特兰克"] = "Hl,紅彤彤的鼻子;Hk,咕咕哒;Hj,學醫奶智障",["格瑞姆巴托"] = "Hl,Mikakiller,夏天的雨;Hj,蒼白眼眸;Hi,烟灰丶",["克洛玛古斯"] = "Hl,Dynasty",["凤凰之神"] = "Hl,挪威的森林丶,灬三吉道灬;Hj,余晖烁烁;Hi,Swings;Hh,体验號;Hg,丶明月来相照",["索瑞森"] = "Hl,小咕奶奶",["海克泰尔"] = "Hl,叶落无痕丶",["主宰之剑"] = "Hl,阿丶古斯",["末日行者"] = "Hl,邪恶菠萝",["雷斧堡垒"] = "Hl,帅气黑皮",["死亡之翼"] = "Hl,哦莫成疼;Hk,刀疤兔;Hj,诗人;Hi,清新丶小纯洁,Skydog,莫迩迩,栗想;Hh,碳酸盐,阿克㐅萌德",["熊猫酒仙"] = "Hk,沉醉幻云;Hg,鱼生请多指教",["诺莫瑞根"] = "Hk,笨蛋猫娜娜",["影之哀伤"] = "Hk,洗脚小妹;Hj,诈尸与狗;Hh,Jiojio,万科吴彦祖",["克尔苏加德"] = "Hk,丶诗情画意,Lacusclyne;Hg,诛魔邪刃",["迦拉克隆"] = "Hk,剑子仙迹丶;Hi,呆呆老华",["织亡者"] = "Hk,噩夢丶",["伊森利恩"] = "Hk,落慕繁尘丶;Hj,浩南小弟弟,花开一诺;Hg,唐小丶寅",["国王之谷"] = "Hj,硬吹十挺丶",["黑铁"] = "Hj,特仑淑流莱",["伊利丹"] = "Hj,菊部东南风",["冰风岗"] = "Hj,Rebirthbeck,張大喵;Hg,美就好了",["银松森林"] = "Hj,随缘木木;Hg,随缘烟雨",["金度"] = "Hj,晴素",["???"] = "Hj,沙毕受死,盛夏的白羊座;Hh,Garenmienvi",["梦境之树"] = "Hj,冰焰铭心",["狂热之刃"] = "Hj,安薇娜的触摸",["罗宁"] = "Hj,青鹞子;Hh,超予;Hg,布兰缇什",["阿纳克洛斯"] = "Hi,高冷的白莲花,丶舞动",["布兰卡德"] = "Hi,多拉囧梦",["破碎岭"] = "Hi,原味蛋挞",["阿克蒙德"] = "Hi,四海承风",["加基森"] = "Hi,莲生三十二丶",["丽丽（四川）"] = "Hi,南柯一夢;Hg,惡魔之怒",["奥尔加隆"] = "Hi,丶喵萌萌",["燃烧之刃"] = "Hi,外科医生之手;Hg,千夜刃",["阿古斯"] = "Hi,十八不戒",["回音山"] = "Hh,亦语轻歌;Hg,半月丶",["翡翠梦境"] = "Hh,心上",["熔火之心"] = "Hh,尧小樂",["红龙军团"] = "Hh,摸骨大师",["霍格"] = "Hh,汤圆儿",["烈焰峰"] = "Hh,洛天丨凌風",["血色十字军"] = "Hh,江风悦人;Hg,雕刻丶月光",["灰谷"] = "Hg,伊莫荅尔",["暗影之月"] = "Hg,火儛丶",["甜水绿洲"] = "Hg,膏锋锷",["轻风之语"] = "Hg,Cykablyat",["苏塔恩"] = "Hg,唐細細",["龙骨平原"] = "Hg,罪域的骨丶"};
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