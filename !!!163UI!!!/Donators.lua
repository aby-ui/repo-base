local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["血色十字军"] = "Ur,讲不出再見;Uo,嘤嘤丿怪;Un,蒹葭慕晚霞;Ul,无心之凹;Ui,番茄栗子;Ug,一心想事成一;Ue,是小薪呀;UY,梦耿耿,怡和媛,风姿卓越",["迅捷微风"] = "Ur,奔驰;UZ,天贶十八",["雷斧堡垒"] = "Uq,厉若海;Ug,血色白杨;Ud,复仇恶魔;Ub,Ntmdjjww",["罗宁"] = "Uq,南宫嘤嘤;Up,资本家;Ul,月之灼灼;Uh,在雨中;Ug,陈年风缕;Ub,溫蒂丶瑪貝爾;Ua,夏天的棉花糖,肆意弥漫;UZ,师兄,鸡蛋唉;UX,杰丽蜜",["安苏"] = "Uq,魅小绫;Ui,专打布洛洛丶;Ue,千瓷;Ud,无尽的虚无;Uc,丷格调丷;UX,多肉葡萄好喝,冲丶鸭,暗影沚殇,可爱点点",["阿克蒙德"] = "Uq,灵飞影",["石爪峰"] = "Uq,费伍德;Ug,蜻蜓队长",["达克萨隆"] = "Uq,伊丽灬莎白",["末日行者"] = "Uq,舞西月;Ui,灬沐舒坦灬;Uh,Game;Uf,头条帝;Ue,美肚杀;Ub,苍老师的圣徒",["白银之手"] = "Up,你好我叫乔;Uo,炭烤鹌鹑丶;Un,欧德莉娜,云卧北溟,云卧北凕,雲卧北冥,云臥北冥,云卧北冥,血色乄杀戮,神聖復仇者;Um,咪咪丶咪咪,蒙泰极;Ul,化瞳,丨风迟丶,苍穹天击;Uk,相乐左之助;Uj,信仰圣光叭丶,李啾啾丶;Ui,古尔达雷;Uh,末世,I深海大鲨鱼;Uf,微醺少女的梦;Ud,风吹淡淡凉;Uc,这是女鬼,安小魔王,Themis,沫若君上尘;Ub,温斯頓,狸笙,死亡之咸猪手;Ua,賊胖胖;UZ,沈夜,花菜炒西红柿;UY,飒珥,玄可改命,宝贝美智子,左眼看不见;UX,丶神祇,灬吞吞",["红龙军团"] = "Up,单点莫斯利安",["主宰之剑"] = "Up,轻语的风;Uo,清风雨;Um,白月魁丷;Ue,徳天独厚;UZ,配合你的演出;UX,艺兴",["塞拉摩"] = "Up,夜雨声声烦;Uk,Grebmar;UY,迈克尔西安",["暗影之月"] = "Up,野百合的春天",["格瑞姆巴托"] = "Up,丨小野槑子丨;Uo,寒蔷;Um,华蓥山土匪;Ug,希尔丶瓦纳思;Ud,灰十八;Ua,Artyom;UZ,灬小甜甜灬;UY,紫薯布丁丶",["燃烧之刃"] = "Uo,暴躁的龙爸爸;Um,奶猴也算猴;Ul,饭特息,墨汐浅醉红颜;Uk,随风壹笑;Uj,电竞奥拉夫;Ui,婧瑜儿;Ue,丿小白去;Ud,曲终人又散;Uc,胸小垫硅胶,崔斯特尔,塔里克尔,Littlebobby;UY,丿苙宝乁,蒋晨晨",["国王之谷"] = "Uo,沉着的小蓝莓;Um,橙吉思涵;Uk,Bbrother,托马斯塞亚;Ug,晓美焰;Ub,羚羊角;UX,吾歌",["死亡之翼"] = "Uo,三勺氮泵;Um,牲口酱一术;Ul,祸神;Ui,吸血鬼寶寶,沙盘上的痕迹,佑枫骑士,塔琪米;Uh,独釣寒江雪,布鲁克克,Cats;Ug,Lyzx;Ud,那墨丶,芬达芬达;Ub,丨熊貓丶;Ua,嫁昼,原味鸡好好吃,麦辣鸡好好吃;UZ,佑枫战刃;UY,娶水,Juventusa,你知不知道啊,仲未死;UX,噼哩啪啪,米小妖",["守护之剑"] = "Uo,敏妹",["克尔苏加德"] = "Uo,辛小美;Uk,赵云子龙德德;Uf,逻辑;UX,板栗丶,丶板栗",["狂热之刃"] = "Un,吃苹果去",["图拉扬"] = "Un,Pyrrla",["哈兰"] = "Un,沫沫智",["凤凰之神"] = "Un,撑伞接泺花;Um,紫云丶;Ul,景依维,我是鱼啦,灬黒宊白灬;Uj,Redsoul,好梦留人睡;Uh,嗷嗷熊,陌伤心,周么么;Uf,南美大虾;Ue,迷秋兔,墨小白;Ud,阿卡姆青年;Uc,柠檬酸不甜,Goodlucktome;Ub,莉莉丶柯林斯;UZ,猴子的血,热情,有钱通其道;UY,猴子涌波;UX,尐鹿斑比,嗜酒仙,裂开的李奶奶",["影之哀伤"] = "Um,灵魂行者黑吊;Ul,御姐好风骚;Uk,星漾;Uh,爱马仕;Ug,朔云满西山;Uf,不化骨丶;Ua,打电动;UY,麻辣香鍋",["回音山"] = "Um,帝翎;Ue,穆有我牛",["熊猫酒仙"] = "Um,Darkhorse;Uk,易燃灬;Uf,大國重器,传送门售票员;Ue,翻车;UZ,音於结弦;UY,娜娜奇丶",["基尔加丹"] = "Um,丿王小贱丶",["伊森利恩"] = "Um,甜水;Ul,雪茶;Uj,好喝的冰阔洛;Uh,顶级男魔;Uf,慕法沙,伯爵茶曲奇;Ud,薪火余灰;Uc,头头君;Ub,下沙黄旭东;Ua,静待荼蘼;UY,你踩到我了,孤山",["利刃之拳"] = "Ul,卡斯迪莱",["末日之刃"] = "Ul,堕落飞霜",["银松森林"] = "Ul,Miuinitio;UY,拙拳",["埃德萨拉"] = "Ul,爆师傅;Uf,Naye;Ud,蛋壳丶牧语;UY,Lovelydruid,狗头萨",["塞纳留斯"] = "Ul,老骨头……",["银月"] = "Ul,打扰了丶",["贫瘠之地"] = "Uk,布偶熊;Uj,甲贺,小神猪;Ui,Fantacola;Ug,熬夜夜丶;Ud,Hkdoll;Uc,重庆胖胖,九曜丨;Ub,晚来风急,凛冬猎手,长街长丶;UY,烂名字想半天",["托塞德林"] = "Uk,小兰丶;UY,萧瑟",["洛肯"] = "Uk,摧残野菊花",["龙骨平原"] = "Uk,徐橙橙丶;UY,徐痛苦灬",["海克泰尔"] = "Uk,朗姆莫吉托;Ua,诺登斯",["阿古斯"] = "Uk,刹那成永恒;Ui,好风凭借力;Ub,剑盾之舞",["月神殿"] = "Uk,手拿棒棒糖;Ue,感染的隐鼠;Uc,萌萌哒鸡蛋饼;Ub,软萌皮卡丘丶",["血环"] = "Uj,北野凛子",["布兰卡德"] = "Uj,陳平安;Ub,Matildaa",["麦迪文"] = "Uj,紫洛;UY,独守达菲",["奥蕾莉亚"] = "Ui,夏虫不可语冰",["???"] = "Uh,宫羽",["无尽之海"] = "Uh,一颗草莓;Ud,疾影的鸟;UX,圣光下打伞",["梦境之树"] = "Ug,一剪没",["拉文凯斯"] = "Ug,战死的刺客",["冰风岗"] = "Ug,仙气儿飘飘丶;Ua,嵩屿丶俗人;UX,丶画心,牛肉法棍",["米奈希尔"] = "Ug,绀蓝",["金色平原"] = "Ug,我想静静丿",["黑暗之门"] = "Ug,欧皇大帝,咸鱼超人",["熔火之心"] = "Ug,九条卡莲;Ud,Enterprise",["诺兹多姆"] = "Ug,调皮的宝宝;Ub,贰零壹零;UX,恩希尔",["迦拉克隆"] = "Uf,罗本无解内切",["玛洛加尔"] = "Uf,徐大娘",["夏维安"] = "Ue,温柔的挠挠你;Ud,团結就是力量,团結",["血羽"] = "Ue,Anllhunter",["晴日峰（江苏）"] = "Ud,老司机会开车",["地狱咆哮"] = "Ud,月魇",["冰霜之刃"] = "Uc,呆毛之王;UX,博士斌",["大地之怒"] = "Uc,为爱痴狂",["艾维娜"] = "Uc,老玩童",["神圣之歌"] = "Uc,Ikaria;UZ,花天月地;UX,追寻曾经",["卡德加"] = "Uc,雷鬼吖",["燃烧军团"] = "Uc,Tt",["索瑞森"] = "Uc,葦名一心",["奥特兰克"] = "Uc,Fit;UX,特级大厨诺米",["提尔之手"] = "Uc,书写星辰",["勇士岛"] = "Ub,尼古拉斯二狗",["丽丽（四川）"] = "Ub,壹弦魄荧惑,系熊啾啾呀",["雷克萨"] = "Ub,决心",["斩魔者"] = "Ub,别扒拉我",["达隆米尔"] = "Ua,铁血长歌",["霍格"] = "Ua,吉田步美",["山丘之王"] = "UZ,赦珑魂;UY,笑靥如花",["破碎岭"] = "UZ,丷小丶噯",["沙怒"] = "UZ,月痕与夜",["奥尔加隆"] = "UZ,托马斯维德",["蜘蛛王国"] = "UZ,煌黑终焉之影",["埃加洛尔"] = "UY,阿西罢",["翡翠梦境"] = "UY,实力电击",["亚雷戈斯"] = "UY,素梦瑾然",["萨菲隆"] = "UY,鸡腿菇凉",["霜之哀伤"] = "UX,林加德",["遗忘海岸"] = "UX,Yyboom",["海加尔"] = "UX,紫月重明"};
local lastDonators = "雪茶-伊森利恩,打扰了丶-银月,灬黒宊白灬-凤凰之神,老骨头……-塞纳留斯,月之灼灼-罗宁,无心之凹-血色十字军,爆师傅-埃德萨拉,Miuinitio-银松森林,苍穹天击-白银之手,堕落飞霜-末日之刃,祸神-死亡之翼,我是鱼啦-凤凰之神,丨风迟丶-白银之手,墨汐浅醉红颜-燃烧之刃,饭特息-燃烧之刃,景依维-凤凰之神,卡斯迪莱-利刃之拳,化瞳-白银之手,御姐好风骚-影之哀伤,甜水-伊森利恩,华蓥山土匪-格瑞姆巴托,蒙泰极-白银之手,丿王小贱丶-基尔加丹,Darkhorse-熊猫酒仙,奶猴也算猴-燃烧之刃,橙吉思涵-国王之谷,紫云丶-凤凰之神,牲口酱一术-死亡之翼,咪咪丶咪咪-白银之手,白月魁丷-主宰之剑,帝翎-回音山,灵魂行者黑吊-影之哀伤,蒹葭慕晚霞-血色十字军,撑伞接泺花-凤凰之神,沫沫智-哈兰,Pyrrla-图拉扬,神聖復仇者-白银之手,血色乄杀戮-白银之手,吃苹果去-狂热之刃,云卧北冥-白银之手,云臥北冥-白银之手,雲卧北冥-白银之手,云卧北凕-白银之手,云卧北溟-白银之手,欧德莉娜-白银之手,辛小美-克尔苏加德,敏妹-守护之剑,三勺氮泵-死亡之翼,沉着的小蓝莓-国王之谷,暴躁的龙爸爸-燃烧之刃,嘤嘤丿怪-血色十字军,寒蔷-格瑞姆巴托,炭烤鹌鹑丶-白银之手,清风雨-主宰之剑,丨小野槑子丨-格瑞姆巴托,野百合的春天-暗影之月,夜雨声声烦-塞拉摩,轻语的风-主宰之剑,单点莫斯利安-红龙军团,资本家-罗宁,你好我叫乔-白银之手,舞西月-末日行者,伊丽灬莎白-达克萨隆,费伍德-石爪峰,灵飞影-阿克蒙德,魅小绫-安苏,南宫嘤嘤-罗宁,厉若海-雷斧堡垒,奔驰-迅捷微风,讲不出再見-血色十字军";
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
      if topNamesOrder[players[index]] then row.name:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(name)) else row.name:SetText(name) end
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