local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔,落落萧萧-罗宁,圣子道-回音山,不嗔-迦拉克隆,奎托斯丶奎爷-白银之手,荼麟、濤-贫瘠之地,Bloodtd-死亡之翼,Darkage-洛丹伦,轩辕银月-雷克萨,我的夜茉莉-法拉希姆";
local recentDonators = {["???"] = "EG,影踪派胖啾咪;EE,红豆白椒;ED,花梨影木,AlvandaBarthilas;EC,梦中的梦里,米兰阿玛尼乁;EB,贰贰叁肆,Fofof;D/,葉洛萌尘,南宫萱灵;D+,乌龙茶,夜空邦尼,后羿灬;D9,痴人丶",["血色十字军"] = "EG,睿小新还;EF,无故犭苗,Meetorange;EE,妹迷的凯小郑;ED,太难得的记忆",["主宰之剑"] = "EG,我骗你的;ED,九二四零三,我不爱吃鱼",["死亡之翼"] = "EG,曼莎珠华丶;EF,Brozovic,森夏的回忆,半月板儿;EE,骨板的战复踢;ED,月夏,冠希哥小迷弟,邪恶光环丶,稻香村小奶糕",["泰拉尔"] = "EG,霓裳映月",["奥特兰克"] = "EG,信仰小鲸鱼;ED,维他命果冻",["阿尔萨斯"] = "EG,帅德丶伊比",["永恒之井"] = "EG,天羽翼",["影之哀伤"] = "EG,来自竹林深处;EF,我的爷;EE,好帥帥哦丶,不问",["艾森娜"] = "EG,饼干",["金色平原"] = "EG,路西亚啊;EF,费纳斯特",["白银之手"] = "EG,圣堂龙烈;EF,肥肥的肉丸,灬毛毛虫,萝摩衍娜;EE,Orangemay,尺间萤火,那哖夏天,苏筱筱,黑框;ED,等待并怀希望,人间不直的,牧滚滚,单纯小耗子,苏米图,一望好多年,Silvermoonfl,很虚",["无尽之海"] = "EG,或丶许;ED,閃電",["燃烧之刃"] = "EG,披星挂月;EF,有眼不识海山;EE,尐丶牧師,嗳佳,刘华强;ED,",["贫瘠之地"] = "EG,就想歇一天;EF,怀梦阿七",["世界之树"] = "EG,Eenvy/娜喵酱",["埃德萨拉"] = "EG,曲终红颜殁;EF,落月之后",["鲜血熔炉"] = "EG,Zerotwo",["破碎岭"] = "EG,流璃;EF,血酬定律",["斯克提斯"] = "EG,燃烧我的艾酱",["布兰卡德"] = "EG,中环西门庆;EF,丶宫水三叶丶",["提瑞斯法"] = "EF,沉沦战魂,漫天小雪",["伊利丹"] = "EF,天月依",["深渊之喉"] = "EF,咫尺月明",["安苏"] = "EF,路人王丶,灯影牛丸;EE,Skybluesea,傳说丨包纸;ED,壳霸霸",["凤凰之神"] = "EF,杨世碧丶;EE,罗纳尔多赵四,舞心乄;ED,转折丨秘密,曹伱摸阿博伊",["末日行者"] = "EF,矮大爷,韩晨羲,玛珐里奥,拳击健将,天下有雪,大靡靡",["斯坦索姆"] = "EF,萨克麦迪克",["丽丽（四川）"] = "EF,帝苍林丶",["燃烧军团"] = "EF,菠萝小乔;ED,超级丨奶爸",["克洛玛古斯"] = "EF,她予他梦",["红龙军团"] = "EF,玛奇,三股螺旋",["火焰之树"] = "EF,烛影斜;EE,洁妹",["海克泰尔"] = "EF,影帝塔里克,满满丶;ED,刘非凡",["迅捷微风"] = "EF,冲锋下跪释放,胡椒火力;ED,南风识我意",["伊森利恩"] = "EF,写咩萌,小布丶豆;EE,落秋丶,看山丶,太阳心,大胖丶;ED,寂寞凌迟",["库德兰"] = "EF,寂寞来了",["罗宁"] = "EF,小破团;EE,痕星",["国王之谷"] = "EF,曼殊沙華;EE,大主教秦端雨,明月下西樓;ED,零柒陆叁",["血环"] = "EF,刀锋之血,五晨之光",["自由之风"] = "EF,罪剑问天谴",["千针石林"] = "EF,Ninakidd",["羽月"] = "EF,活着不好吗;EE,Seafang",["黑暗虚空"] = "EF,三逗比笑呵呵",["瑟莱德丝"] = "EF,Crystalmaid",["克尔苏加德"] = "EF,今夕何夕然,依然刺刺",["梅尔加尼"] = "EF,菜刀又见菜刀",["暗影之月"] = "EF,暗之灬,唐小仔",["艾苏恩"] = "EF,Doublefire",["加兹鲁维"] = "EF,Java",["日落沼泽"] = "EF,Odanobunaga;ED,美屡小玉",["菲米丝"] = "EF,白衣不染尘",["古尔丹"] = "EF,Xiaojinmao",["冰风岗"] = "EF,西楼;EE,Poiaris,你温柔的样子",["鬼雾峰"] = "EF,小鸭;EE,輪椅鬥士;ED,花漾铃兰",["翡翠梦境"] = "EF,盆盆叔叔;EE,狂野幽灵",["伊萨里奥斯"] = "EE,Xxzs",["熊猫酒仙"] = "EE,陆丷多多,Icefree,风乄语;ED,婷婷无双",["暗影议会"] = "EE,幻舞",["风暴之怒"] = "EE,黑夜零散",["黑铁"] = "EE,不胜则亡",["末日祷告祭坛"] = "EE,Divano",["泰兰德"] = "EE,动若脱兔",["天空之墙"] = "EE,雨夜敬清秋",["格瑞姆巴托"] = "EE,渐稀,更泩",["血牙魔王"] = "EE,阴风阵阵",["暮色森林"] = "EE,月之舞斩断吧",["弗塞雷迦"] = "EE,灬镜远香灬",["加基森"] = "EE,林师傅",["冬泉谷"] = "EE,夜子冥",["格雷迈恩"] = "EE,玄月哀歌",["基尔加丹"] = "EE,太玄",["麦迪文"] = "EE,遗忘丶阡陌",["迦拉克隆"] = "EE,Darkoranger;ED,混沌女皇",["达纳斯"] = "EE,血色冰河;ED,诗意",["试炼之环"] = "EE,好朋友;ED,林樨",["塞纳留斯"] = "EE,搬砖小霸王",["回音山"] = "EE,冷色葉瞳,丿落小煙",["达隆米尔"] = "EE,老板娘的腿毛",["达文格尔"] = "EE,碳酸钙",["雷克萨"] = "EE,群体驱散",["石爪峰"] = "EE,丶丨法海無边",["达尔坎"] = "ED,雲小蛋",["梦境之树"] = "ED,萌男奶牧",["卡德加"] = "ED,冰茶哟",["埃克索图斯"] = "ED,鹿鸣",["奈法利安"] = "ED,念念有诗",["玛瑟里顿"] = "ED,白眉",["塞拉摩"] = "ED,晨歌光焰,午夜枪手",["烈焰峰"] = "ED,蠢萌蠢萌德",["晴日峰（江苏）"] = "ED,尐丶崽",["阿比迪斯"] = "ED,弑疯",["罗曼斯"] = "ED,Moppa",["阿迦玛甘"] = "ED,雙鱼座",["玛里苟斯"] = "ED,红尘輪回,傲笑红尘",["雷霆之怒"] = "ED,以星辰之名,Lifedream",["萨尔"] = "ED,小小慢漫悠悠"};
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