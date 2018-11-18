local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,叶心安-远古海滩,释言丶-伊森利恩,魔道刺靑-菲拉斯,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,发骚的院长-燃烧之刃,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,橙阿鬼丶-达尔坎,贞姬-霜之哀伤,剑四-幽暗沼泽";
local recentDonators = {["阿纳克洛斯"] = "FI,素稳",["凤凰之神"] = "FH,文凤,两清,鬼迷心窍丶;FG,惊声煎饺,鬼迷丶心窍,西西弗斯乄;FF,矮子王丶,杨幂的初恋,韩红炮友,二宁丶",["安苏"] = "FH,丶怡柔;FF,旎大侠",["诺兹多姆"] = "FH,一程程一",["???"] = "FH,香山渊虹;FG,摸鱼枭先森;FB,Myh;FA,莉雅;E/,元素丶協奏曲,落蘭之殤,橙默丶,头号捣蛋鬼;E+,枫神榜",["亚雷戈斯"] = "FH,摩挲云影",["燃烧之刃"] = "FH,萍乡炒粉,有趣丶;FG,疯人願,先疯通缉犯,发骚的院长;FF,温柔的小萌,飘流的北风",["埃德萨拉"] = "FH,人在做咕在看;FG,刘小椛",["影之哀伤"] = "FH,小青春灬月泽,卌铁丶蛋卌;FG,貌似柯基;FF,夏月丶,曾经旳猫爷",["克尔苏加德"] = "FH,范狄赛児,来一个前空翻",["国王之谷"] = "FH,夏洛克灬聖手,Aixz,Bloodbane,月儿寶贝;FF,美少女岳云鹏,泼风",["格瑞姆巴托"] = "FH,昱锦,淡定的阿昆达",["白银之手"] = "FH,圣光玫瑰;FG,小酒窝儿,铁齿狗,碧水云寒,歆语风,雷凡勒,丶佛本是道;FF,懒羊羊乀,懒羊羊丿,夜雨青柠",["达斯雷玛"] = "FH,古河早苗",["梦境之树"] = "FH,悲鸣云图",["主宰之剑"] = "FH,大孬依然给力,雨笑尘;FG,简㨮奥斯汀",["冰霜之刃"] = "FH,灬灬麦兜灬",["雏龙之翼"] = "FH,赏心",["风暴之怒"] = "FH,小贝霓裳",["阿迦玛甘"] = "FH,陌上公子",["燃烧平原"] = "FH,沐雨仟痕",["符文图腾"] = "FH,萌萌灬触手;FF,全场八五折",["死亡之翼"] = "FH,叫我小奶就好;FG,梅丶小月,看偶眼色行事,什么什么丶微,鬼泣丶但丁;FF,怒罗美",["末日行者"] = "FH,秦风无依;FG,玲玲夏",["阿拉希"] = "FH,我看见你们了",["斩魔者"] = "FH,黄泉果实",["熊猫酒仙"] = "FH,给我一个佳丶;FG,Komms",["伊森利恩"] = "FH,为了妍女神;FG,迈了佛儿冷,好几百只喵,脆脆的胡萝卜;FF,拿不住,情不知所起丷",["伊利丹"] = "FH,泪过一一无痕;FF,凤栖梧丿猎手",["血色十字军"] = "FG,丶思念丶,橄榄,刀尖舔蜜,破折,诺娃;FF,懒懒陌小汐,冻米糖",["鲜血熔炉"] = "FG,拥晚",["埃苏雷格"] = "FG,彩虹幻熊",["狂热之刃"] = "FG,赤脚大贤,獅心之怒",["古尔丹"] = "FG,无敌芊芊",["战歌"] = "FG,永夜;FF,心变宁静海",["回音山"] = "FG,噬魂邪魔;FF,基围蝦,血色小萝莉",["阿古斯"] = "FG,咾魔,丨王者之风丨",["加兹鲁维"] = "FG,肚子好难受;FF,奶亦能打",["希尔瓦娜斯"] = "FG,特级出品人",["影牙要塞"] = "FG,欧德凯",["血环"] = "FG,Luckycrit,忧郁吖;FF,Moroes",["金度"] = "FG,二猴,二扣",["雷斧堡垒"] = "FG,Qomolangma,滋阴壮阳",["加基森"] = "FG,萌萌的貓貓",["千针石林"] = "FG,Alongtwoa",["遗忘海岸"] = "FG,青山随云走",["达尔坎"] = "FG,快跑吧小红帽",["扎拉赞恩"] = "FG,魔兽玩家",["激流之傲"] = "FG,圣律辛多雷",["诺莫瑞根"] = "FG,小仙嫂,菊爆小分队",["金色平原"] = "FG,守备官阿索卡",["卡珊德拉"] = "FG,愫、",["艾莫莉丝"] = "FG,木棉花,麦哲伦",["永恒之井"] = "FG,Liana",["布兰卡德"] = "FG,回首凉云幕叶;FF,秀众生而为言",["无尽之海"] = "FG,阿威十八式丶;FF,只喵",["霜之哀伤"] = "FG,玲冬丶",["米奈希尔"] = "FG,开始狩猎",["冰风岗"] = "FG,喜欢就去抢;FF,Missandei",["红龙军团"] = "FG,罓皿罓,珞珈山下",["桑德兰"] = "FF,热拿铁跳舞",["安东尼达斯"] = "FF,阿马欧也",["阿曼尼"] = "FF,卡屯",["海克泰尔"] = "FF,制裁武僧",["破碎岭"] = "FF,潘尛达",["黑翼之巢"] = "FF,Crya",["杜隆坦"] = "FF,香莲",["罗宁"] = "FF,狂野的柯基,妡喵酱",["火焰之树"] = "FF,晨儒梦",["天空之墙"] = "FF,唐卿羽",["熔火之心"] = "FF,烽火战神",["奥妮克希亚"] = "FF,封尘老鱼",["黑铁"] = "FF,丶丶冲田杏梨,太原人丶",["艾萨拉"] = "FF,榆树钱",["风行者"] = "FF,Sands",["风暴峭壁"] = "FF,萝卜先生"};
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