local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,魔道刺青-菲拉斯,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,空灵道-回音山,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔";
local recentDonators = {["克尔苏加德"] = "Eo,邪惡的早餐;El,影月酱;Ek,流火丶,卡迪福兰姆;Ei,仲村由理;Eh,千本菊,觸碰那记憶",["布兰卡德"] = "Eo,萌萌的尐熊猫;En,牛气冲云霄;Eh,为我撩人",["格瑞姆巴托"] = "Eo,灵气之魂;En,夏亚专用丰田,那个喵丶,老狐;Em,浅术低吟,暗月小星星,静脉颤音;El,Tebieniubi,再读一个炎爆,张施主,夢裡輪迴;Ek,首席非酋,独行彡瘋,丷木乄槿丷;Ej,婆罗浮屠,晴空未眠,广寒清晖;Ei,丶拟墨画扇;Eh,一叶秋风",["回音山"] = "En,柯德平;Em,八级大狂风;Ek,斯提克斯;Ej,Leserein;Eh,一只肥仔",["红云台地"] = "En,Matriix",["古尔丹"] = "En,白色恶魔;Ei,凉雾",["主宰之剑"] = "En,吴清语,乖一点就亲你,非常皮;Em,半丨藏,君不劍;El,帅气的二狗子;Ek,丨卫庄丨;Ej,夕阳红斗士,怕屁,怕芼,一心为你灬;Ei,滚地三连,吴起展;Eh,黎明之锤丶",["影之哀伤"] = "En,杨柳依雨雪霏,老四丶打手;Ek,豌豆猎手,邦桑迪;Ej,猩红之瓶,香橙与咖啡;Ei,Ewxyzz",["末日行者"] = "En,於心有愧,仰望虚空;Em,逸见艾丽卡,雪落叔叔,烟雨潇凝,古登陶克;El,水很大;Ek,丶丶伊立蛋丶,小不忍;Ej,捌捌肆捌,花落愺愺;Ei,佩丨奇,织雾丨糖糖,仙仙灬;Eh,票房的毒藥",["诺兹多姆"] = "En,洛蕾尼尔",["破碎岭"] = "En,铁大妈;Ek,迷茫的尛兔;Ej,青风逐羽",["贫瘠之地"] = "En,老牛会变身,达大达大达,皮皮猎手心灬,就想骚一把,离樱错梦丶;Em,祭月隐修;El,再封试试丶;Ek,丶炉石,雷玛风行者,断丷角;Ej,月见海,待到重阳节;Ei,林妤丶,花魚兒;Eh,逝去的小法,冷血不语,雅皮",["盖斯"] = "En,三千世界",["死亡之翼"] = "En,梦天机,八级大地震,壹切唯我造;Em,顽咖,咯咯无;El,一只绝味鸭;Ek,你也在等我吧;Ej,丨远坂凛丨,巧克力花和尚;Ei,重生知会;Eh,斷腸,胖嘟小佳宝,Raptorx",["奥特兰克"] = "En,破裤;Em,害羞的菊花,洪镇乐翁;Ek,之只止御用奶;Ej,浪息亚麻布;Ei,眼线高手,老水手小甜菜,夜与胡渣",["生态船"] = "En,苏绫;Ej,六橙合体丶",["熔火之心"] = "En,绝望小熊,丶火辣辣",["白银之手"] = "En,三围真火,归隐风中,洪、七,光的颜色;Em,小文的骑士,時年丶初訫,雷凡乐,丶小意外灬,珊寶寶胸超大,这个名字最刁;El,阿福洛达特,小萌想,克灬宽,空气蕉灼;Ek,夏夜追凉,浮生闲云,棠小唐,郑天阳,宁折不弯;Ej,心口鼻息,追雪之风,田依城,跳刀空大,阿佛洛黛特;Ei,黑羊之墙,夷陵丶魏无羡,绝世面包;Eh,水歌调头,黎筱雨",["???"] = "En,半截战袍;Em,安幕希丶,流浪的阿水呀;Ek,小眉如印,晨梦昂志丶;Ej,以痛苦的民义,骑警扎小西,殇御灬血怒;Ef,钙丶片,林哥丶,疯牛不倜傥",["血色十字军"] = "En,清風丶,买了佛冷;Em,章兮兮;Ej,马猴烧酒猫爪,丶杏加橙,花为雨落,何时雨会停;Ei,复苏之风丿",["伊森德雷"] = "En,西里橘",["恶魔之魂"] = "En,融融月;El,大战吊",["勇士岛"] = "En,宝宝霜",["天空之墙"] = "En,Excarliber",["卡拉赞"] = "En,暴躁老哥,茜雨寳贝,糖棉花",["海克泰尔"] = "En,只因那時年少,波爺丶;El,零距离冲锋;Ej,張氏情歌,薇琪尔的怠惰;Ei,两米七",["丽丽（四川）"] = "En,水深火熱;Em,扶地魔,丨智妍丨;Ei,被阉掉的布偶,逆境天堂;Eh,西樓",["罗宁"] = "En,还是小木桩;Em,莫丶库什勒,圣光修女,优秀的吉米;Ek,尛鋺餖,夜风轻语;Ej,不如一见;Ei,安薇娜丶语歌;Eh,风灵之语",["凤凰之神"] = "En,看你鬽;Em,狂流哈喇子丶,茹释喵,、小暴,喷火的神灵;El,宮商角徵羽;Ek,灬大火法灬;Ej,耿秋;Ei,丶五月雨,长庚在东,陌流年丶,燃烧的灵魂,枣真夜,可爱术,寂寞繁华;Eh,清风无常,蟑螂丶恶霸,小爅",["冰风岗"] = "En,噗嗨哈;Em,清清豌豆,萨利休斯;Ek,有点小鸡冻;Ei,凉白白,水信灬玄饼;Eh,甜水,你英俊的阿爸",["阿斯塔洛"] = "En,黎明挽歌",["迦拉克隆"] = "En,馨语嫣然;El,桃杀;Ek,桥头恶霸,桐桐一桐;Ei,浩荡,咔佧罗特",["麦维影歌"] = "En,泡椒小花生",["塞纳留斯"] = "En,赵以疯",["金色平原"] = "En,薇薇安丶柯文;El,天之刹那,紫宮初雪;Ek,李老鸨;Eh,小岩井四叶",["伊森利恩"] = "En,Letme,丶北落灬星辰;Em,大門,一莉亞德琳一;El,風無聖,咕咕是一只鸟;Ek,橘猫杀手,奶茶奶茶君,夜沐沉香,轻奏离殇,丿魑魅灬魍魉;Ej,皮皮闪电灬,邦嗓迪,春晖是最强哒;Ei,寂寞的法神,白沙翊",["远古海滩"] = "En,萝珂塔;Ei,Flavia",["烈焰峰"] = "En,白发魔法;Ek,没盾开盾墙",["提瑞斯法"] = "En,王炸灬",["加兹鲁维"] = "En,计生寺住持",["阿拉希"] = "En,气球一元一个",["阿纳克洛斯"] = "En,幸福的蜗牛;Ei,雨好大;Eh,月陸",["迅捷微风"] = "En,杨超跃;Ek,好甜灬;Ei,工程学博士,暖乄風;Eh,瘸腿的阿昆达",["灰谷"] = "En,泉丶此方;Em,Iyrel;Ei,迦顿男爵",["大地之怒"] = "En,鸥鹭;Ej,包养小萌宠",["鬼雾峰"] = "En,葡萄灬紫;Ek,Rapple,豆奶火,汐夜梦魇;Eh,懵悠悠",["哈卡"] = "Em,熊猫奶盖乌龙;Ek,五十亲一口",["奥尔加隆"] = "Em,最是寻常梦,药家鑫灬;Ei,潜意识回忆",["塞拉摩"] = "Em,Mine;El,豆豆丶奥特曼;Ej,冲锋崴了脚丶",["安苏"] = "Em,圣光治愈你;El,喔喔嘛嘛;Ek,血沸丶,星空召唤师;Ej,Luckyclover;Eh,呆萌乄叔,奥卡姆剃刀君",["雷斧堡垒"] = "Em,Lapis",["朵丹尼尔"] = "Em,达尔达尼央",["斩魔者"] = "Em,百山惊鸿",["燃烧之刃"] = "Em,不熬夜的傀儡;Ej,大脚大牙怪,乱试佳人,苏坡密;Ei,大哉乾乾,Shevchenk;Eh,你敢打熊猫丶,奶残",["熊猫酒仙"] = "Em,荆楚九頭鳥;El,天狼星下;Ek,月下独饮酒;Ej,火龙奇士;Ei,Âô;Eh,风起肃然,名字不能乱写",["伊萨里奥斯"] = "Em,彎彎",["基尔加丹"] = "Em,镝剑",["伊莫塔尔"] = "Em,给我个机会",["世界之树"] = "Em,故人何在;Ei,膨胀",["无尽之海"] = "Em,冲锋裂地斩;Ek,無敵神棍德,恶魔也疯狂丶;Ei,夜幕下的侵袭,凌衷遗言,吧啦吧啦咘;Eh,咸鱼咆哮",["拉文凯斯"] = "Em,嘣次哒次;El,凛风冲击;Ek,爱莉丶斯菲尔",["耐普图隆"] = "Em,双子丶瓦莉拉",["风暴之怒"] = "Em,打断我来;El,Deathvalkyri;Ej,污丶云",["黑暗之门"] = "Em,手无扶鸡之力",["麦姆"] = "Em,老牛很忙",["巨龙之吼"] = "Em,俺们村丶奶奶",["黑铁"] = "Em,一个小可爱;El,张无喵丶;Ek,Lostlife;Ej,Limerance;Eh,朴昭妍",["血环"] = "Em,致命遂志泽坎;Eh,墨丶小乖",["阿古斯"] = "Em,熊仔熊;El,红颜灬伊然;Eh,逆丶夏",["符文图腾"] = "Em,快乐的牛牛",["拉文霍德"] = "Em,大丨黒丨手",["寒冰皇冠"] = "Em,Bronya;El,颖悦",["暮色森林"] = "Em,筱雅沐馡",["诺莫瑞根"] = "Em,丑的无语",["黑龙军团"] = "Em,梦溪一囧架架;Ek,哎呀呆呆,Bwonsamdl;Ej,肝疼的阿昆达;Ei,黑了个手",["加基森"] = "Em,Cczone",["狂热之刃"] = "Em,犬昔;El,甜甜的小白牛;Ej,笑依然,莉丽斯",["霜之哀伤"] = "El,晨曦之徒;Ek,哥哥来咧;Ej,菲歐娜",["铜龙军团"] = "El,浮沉丶",["玛洛加尔"] = "El,丿灬迷鹿",["斯坦索姆"] = "El,亚汉",["洛丹伦"] = "El,巴哈姆特践踏",["龙骨平原"] = "El,拾意;Ek,樱丶吹雪;Eh,愣愣",["丹莫德"] = "El,我不是圆的",["埃德萨拉"] = "El,安拉胡阿克巴;Ek,Surrebder;Ei,盗嗳,康納麦克雷戈",["金度"] = "El,挽手说梦话丶",["阿克蒙德"] = "El,丶清柠咖啡;Ek,Damage",["轻风之语"] = "El,鮮衣怒馬",["艾维娜"] = "El,風起的憐惜;Ei,詩琪,消愁",["银松森林"] = "El,孤峰无伴",["国王之谷"] = "El,卡德伽马;Ej,乄米客;Ei,崩崩跳跳,宏灬宝灬莱",["试炼之环"] = "Ek,王者迪克;Ej,牛德华;Ei,Augusto",["能源舰"] = "Ek,渡我被身子",["斯克提斯"] = "Ek,赖美云丷;Ei,遗忘灬时光",["密林游侠"] = "Ek,哼哼我的嘿",["时光之穴"] = "Ek,Boombiubiu",["艾莫莉丝"] = "Ek,铁心",["埃克索图斯"] = "Ek,冷色调调,猫污猫",["幽暗沼泽"] = "Ek,吉哥哥",["翡翠梦境"] = "Ek,天雨正泽;Ej,蛮锤海明威;Ei,叫地主,影歌丷;Eh,糖门丨红手",["永恒之井"] = "Ek,黑白大彩电",["提尔之手"] = "Ek,一刀繚乱;Ej,Kderhzdd;Ei,柠檬小丸子",["克洛玛古斯"] = "Ek,一本初心",["末日祷告祭坛"] = "Ek,丶干炸熊咕",["玛诺洛斯"] = "Ek,Revengor",["萨菲隆"] = "Ek,有的放矢",["雷霆号角"] = "Ek,我叫亲亲",["月神殿"] = "Ek,笔冢墨池",["加尔"] = "Ek,孤独狼人",["红龙女王"] = "Ek,就是不可能;Eh,啼笑木偶",["熵魔"] = "Ej,杀无尽",["鲜血熔炉"] = "Ej,让包子飞",["遗忘海岸"] = "Ej,剑春归花残梦;Ei,刘振",["红龙军团"] = "Ej,Predatory",["麦迪文"] = "Ej,最强之刃",["蜘蛛王国"] = "Ej,被抓住的咸鱼;Ei,若蓝",["雷霆之怒"] = "Ej,谜阿丶,林丶熙娜;Ei,尘灬风暴烈酒,小跳蛙",["萨尔"] = "Ej,我冰箱了",["战歌"] = "Ej,糖糖卟甜",["暗影之月"] = "Ej,奥娜,月色了无痕",["逐日者"] = "Ej,王银圣",["黑暗魅影"] = "Ej,范大鹏有点方",["梅尔加尼"] = "Ej,喜来宝",["库尔提拉斯"] = "Ej,燃烟",["达尔坎"] = "Ei,丶采薇",["范克里夫"] = "Ei,判官",["冰霜之刃"] = "Ei,寧負",["奥杜尔"] = "Ei,小豪豪",["埃加洛尔"] = "Ei,朵朵菊花开",["索瑞森"] = "Ei,都是世界的错,非攻",["菲拉斯"] = "Ei,魔道刺青",["凯恩血蹄"] = "Ei,最后的赞歌丶",["风行者"] = "Ei,伊生",["暗影迷宫"] = "Ei,赵依然",["自由之风"] = "Ei,唧唧",["菲米丝"] = "Ei,Purplee",["黑暗虚空"] = "Ei,长歌藐倥偬",["石爪峰"] = "Ei,丶电火流萤",["神圣之歌"] = "Ei,脆皮小熊猫",["千针石林"] = "Ei,艾尔的静谧",["血吼"] = "Ei,上辈子的情人;Eh,符华",["巫妖之王"] = "Eh,盖世英雄灬",["玛里苟斯"] = "Eh,芸七彩",["壁炉谷"] = "Eh,Arenge",["日落沼泽"] = "Eh,盛乄夏",["风暴峭壁"] = "Eh,奶茶店的萝莉",["艾露恩"] = "Eh,小明",["亚雷戈斯"] = "Eh,断肠",["芬里斯"] = "Eh,Linyolol",["阿拉索"] = "Eh,残忍的软泥兔",["伊利丹"] = "Eh,Kazs",["米奈希尔"] = "Eh,送来送去"};
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