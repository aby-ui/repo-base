local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["末日行者"] = "Ky,小猪猡丶;Kj,狂风之舞;Ke,落英;Kd,十万城管;KZ,相今;KU,程丶风暴洣酒,程丶风暴米酒;KP,狂野乔峰;KO,雪中捍刀行丶;KN,丶花尽千霜默;KM,狂野黄蓉",["罗宁"] = "Kx,Kcrorz;Km,覅嗲额妞妞,覅覅额妞妞,梦小夕、;Kk,Mocktails;Kh,青鸿芒克,灬灬导演灬灬;Kf,淡然烟味;Ka,地藏菩,冠冠;KZ,不灭的花火;KV,彩云朵朵",["燃烧之刃"] = "Kx,丨排山倒海丨,风颖;Ko,人生若梦;Km,我爱我的祖国;Kk,宇宙龙爸爸;Kg,灿哥丶丶;Kf,天空树的顶上;Ke,十七笔画;Kc,柒画丶酌望;Kb,茱莉娅;Ka,冰镇丶菠萝,Stefanice;KX,小红颜;KV,贼神丨炎焱,战神丨炎焱,火燚丶炎焱;KN,对不起都怪我,泰抽抽,月色丶秋风;KM,稀饭凉面",["灰谷"] = "Kx,简单灬丨小新;Kr,战之锤",["安苏"] = "Kw,Mxu;Ku,丨只狼丨;Kp,茅山林正英,华月之舞;Kn,表演家丶;Kl,玩具车头,苹果芒果酱;Kj,爷们儿萬歳;Ki,木木林林森;Kf,Billprinter,天空吥空天;KY,丨玉米丨;KW,天空不空不空;KV,小鱼小小鱼;KU,我想好好玩,安晨,你的蓝色夜雨;KT,海迦尔的风,此間的少年丶;KS,爷们儿萬歲;KR,眠慕白;KP,陆伯言丶;KN,仙女有只猫;KM,杨秀儿",["蜘蛛王国"] = "Kw,小脑斧丶",["白银之手"] = "Kw,安灬小希;Ku,等一下,专属小幻,Normee;Kt,致丶命;Kq,清风微暖;Kp,六位帝皇丸;Ko,Playerltwwzd;Kn,铁爐堡;Km,丿酱丶紫;Kk,六时吉祥;Kj,仙女儿在人间;Ki,东钱湖蛳螺;Kf,Hunshaw,馒头多多丶,萌德无量,丶雫;Kb,天水坛子;KY,大地与山阿,观棋不语;KW,阳大人,漫长的玩笑;KV,此心光明;KU,清风慕斯;KT,Wassim;KQ,马云之子,亿易;KP,月影临风,血色百夫长",["羽月"] = "Kw,搞裙子",["暗影迷宫"] = "Kw,可爱又迷人",["翡翠梦境"] = "Kw,白月寒",["凤凰之神"] = "Kw,襄襄;Kv,保姆丫头,Lazyfantasy;Ku,小牛不哞,小觉,杨浩苓;Kt,慕柒寒,慕柒雪,慕柒沫,钟丶馗;Kr,这一次我请;Kq,韩皮皮;Kp,风景;Ko,欧皇腊肠;Kn,浪漫撒加;Km,上去就送,吕小一,三更檐上月丷,臭鸡;Kl,俩难,丨灬德古拉丶,Cns;Ki,星星以北,大宝聪;Kh,小北丷;Kg,吨吨盹,大佬的样子;Kf,傅大寶,坏坏的沙丁鱼;Ke,朔风凛冽;Kd,花椒,白羊座灬幽玥;Kc,玥弦丶熊熊;Kb,桔子丨;Ka,这火冲奈斯丶,有空一起坐牢;KZ,风与溪流,璇子丶,璇子,戰誓,葛文,毛不盗;KY,舞刄;KW,無相丶,無牧丶,刀宅丶,黑钥匙大魔王,心尖;KV,抓只子怡宝宝,带槽肆伍伍;KU,姐姐幻肢好烫;KT,Muxii,是谁的心阿;KR,此名字不能用,大雨灬;KQ,生有余辜,鼎酱胖胖哒,Yerger;KP,Constans;KO,暗妮,晨曦丶晓白;KN,布罗利丶邪眼",["红云台地"] = "Kv,森屿鹿",["激流之傲"] = "Kv,你家的李狗蛋",["海克泰尔"] = "Kv,我们是害虫;Ki,长门;KM,可尔必思丶",["血羽"] = "Kv,说好不哭",["???"] = "Kv,洗风尘;Ku,安萨德鲁;Kp,夜猫早早睡",["克尔苏加德"] = "Ku,丶诺神丶;Kl,墨影潮海",["霜之哀伤"] = "Ku,烧饼丶;Km,豆浆丶;Ke,是水果糖啊丶",["主宰之剑"] = "Ku,朝上;Kt,狂奔的尛蚂蚁;Kq,回眸笑花斩刺;Kp,贫穷弱小能吃;Kh,噬血灬狂殺;Kd,浅梦殇流年;Kc,去超市捏泡面;Ka,泡沫即是幻影,小术点啊;KY,可嘉;KX,贝贝骑士;KU,牧格;KS,左岸铭记;KP,吾之阳;KM,林家暗影射手",["死亡之翼"] = "Ku,乌鸦苍白;Ks,胖胖嘚文哥丶,Evf;Kp,你老味,恨长生,阿芙芙;Ko,醉枫染彤;Kn,乱世小驴,和光同塵;Km,香菜饺子,于与玉与玉;Kl,勒是火法;Kh,佩绣丶,蒙着眼瞎打,寂寞的火神,芒川;Kg,尨貓灬,瞌睡小猫;Kf,天眞无邪;Kd,雪山丨,皇漠;Kc,丶腋下美;Kb,澄空丶丶;Ka,荆棘蛊,治愈系大叔;KY,微笑乄迪妮莎;KX,礼查德泰森,我不敢过江;KW,叶知秋阿丶,明月涤吾心;KV,她的;KT,一夜赫然倾城;KR,碳化硅,妖王之王,鸡蛋盖浇饭;KQ,桂花糕,亲亲胖胖熊,觅丶墨,鱼鱼有饼;KO,Amen,你看不到;KN,花醉羽觞;KM,有苏",["贫瘠之地"] = "Ku,爱你呦希女王;Kq,渚上渔樵;Km,獸医;Kh,Edisondep;Kf,是你的小奶狗;Ke,旧城不暖少年,苏影,莎拉凯瑞甘;Kc,鸟大奶才多;Ka,天地玄武;KY,流氓伊锅锅;KW,萌萌哒小喵喵,赛萌铁克;KV,心驰,最爱猫;KR,苏珊娜丶,可可;KM,后宫全是牛",["冰风岗"] = "Ku,微风清清;KW,比丘神尼;KM,虾条",["梦境之树"] = "Ku,浩云风",["格瑞姆巴托"] = "Ku,声嚣与狂乱;Kq,玛戈达莱妮;Ko,旧情难忘;Km,仲夏忘忧;Kk,雪童子,幸福撞了满怀;Kg,丨大丨帝;Kd,一酒一江湖,泡面来了;Kc,好果汁;Kb,大乌苏丶;Ka,暁白丶;KR,半点白;KP,魅魇;KO,迷之圆滚滚;KN,起司汉堡包",["金色平原"] = "Kt,墨狱;KY,中國好朮士;KX,唯美传说;KO,粉红雪山;KM,浮月若苼",["迦拉克隆"] = "Kt,冰雪夏季;Kf,若梦非凡,猫大人丶;Kd,幽香;Kc,请叫我时光鸡,聽說卖萌可耻;KW,墨竹凉夜影;KT,萌丶捷列夫",["迅捷微风"] = "Kt,你的丶茗字;Kk,是阿薯嘛;Ki,阿三烤鸭;Kd,丶呆呆兽,云谲波诡;KN,夏比比",["菲米丝"] = "Kt,魔悟",["塞拉摩"] = "Kt,鬼刻灬生灵灭,BiaggiZ",["伊森利恩"] = "Kt,朱茵;Km,龍師、;Kh,土肥圆滚滚;Ke,温柔的骑士丶;Ka,忘丨仙灬;KW,丿丶疯舞;KR,部落壁垒;KN,沖田総司;KM,罗森灬内里",["太阳之井"] = "Ks,雅丽桑德拉;KN,鸡伱太美诶丶",["烈焰峰"] = "Ks,丶榴莲可爱多;KR,Yeliz",["冰霜之刃"] = "Ks,残暴蚊香蛙;Kd,丶呆呆兽;KU,寒雪眠风",["加尔"] = "Ks,习切糕",["埃德萨拉"] = "Ks,說好不哭;Kg,梦境风车;KZ,燃烧的熊大;KX,Killerslaye,請叫我小邪惡",["诺森德"] = "Kr,艾德琳伯爵;KO,大卫妮尔",["巫妖之王"] = "Kq,杠靳",["黑铁"] = "Kq,索澜莉安,雨野景太;KZ,晓隼;KX,随他去吧;KQ,暗黑胡萝吥;KO,百兽凯多丶;KN,伤心猪大肠",["国王之谷"] = "Kq,荷鲁斯;Ko,狼牙;Ki,神秘的反派;Kb,长襟落落秋风;KY,哈基石打怪兽;KN,无人咏生;KM,七世笙歌丶",["金度"] = "Kp,泊杋",["回音山"] = "Ko,暮雲;Kj,千里走单马奇;Kf,新大陆苍蓝星,早坂灯里,不死人安里,Dawndeep,龘相;KW,灵顿顿;KN,小鲜奶",["亚雷戈斯"] = "Ko,小妹妹乖乖;Kk,孤独苦酒",["影之哀伤"] = "Ko,洛戾丶塔;Kg,被打死了;KV,嘿|喂狗;KR,黑夜的寂静;KM,垂死的玖玖",["血色十字军"] = "Kn,照美冥丶;Kh,左边画条龙;Kf,圣光流浪;Ke,毒瘤老虾米;Kd,双刀母老虎;KW,無牧丶;KV,朱少;KS,祝您平安;KQ,只萌不新;KO,Crankines,临光;KM,统御法典丶,棉被封印丶",["艾露恩"] = "Kn,小蚂蚁啃树皮",["阿古斯"] = "Kn,菊部有毒;Kd,Ilmelody;Ka,国服第一喷子",["斩魔者"] = "Kn,艾别离",["无尽之海"] = "Km,Galaxxy;Kd,娚嫐嬲;Kc,你的情哥哥;KX,Lictrey;KS,我很谦虚;KR,丹峰揽月;KM,丶小果然",["万色星辰"] = "Kl,白银公爵",["阿克蒙德"] = "Kl,尤迪按",["铜龙军团"] = "Kk,倾世无双",["雷霆之王"] = "Kj,灰色軌迹",["耐奥祖"] = "Kj,游学者周董",["鬼雾峰"] = "Kj,琬媄蕶亂",["密林游侠"] = "Kh,子柒",["奥特兰克"] = "Kh,人小志向大啊",["世界之树"] = "Kg,橘希尔芬福特",["黑龙军团"] = "Kf,毁灭之刃丶;KQ,夜長夢還多",["伊瑟拉"] = "Ke,吃肉即为正义",["杜隆坦"] = "Ke,红妆丶醉",["破碎岭"] = "Ke,呆萌的蛋蛋",["布兰卡德"] = "Ke,顾柒柒;Ka,来齐;KO,芒种;KM,咕嘟嘟冒泡泡",["银松森林"] = "Ke,嘎嘣脆的豆儿",["加基森"] = "Ke,七色;KQ,柒蓝",["提尔之手"] = "Kd,落雪飞缨",["诺兹多姆"] = "Kd,月夜风行者;Kc,影月谷的守望",["熊猫酒仙"] = "Kd,凭什么跟我打",["幽暗沼泽"] = "Kb,翎丨霜;KP,Kizimao",["龙骨平原"] = "Kb,盐烤大明虾",["寒冰皇冠"] = "Ka,四風院丿迷,忆蕓,忆雲",["阿尔萨斯"] = "Ka,阿芙洛蒂斯丶",["丽丽（四川）"] = "Ka,盗格拉斯",["弗塞雷迦"] = "Ka,镜远香宠汐汐",["银月"] = "Ka,拉克丝库莱恩",["希尔瓦娜斯"] = "Ka,有个肝帝",["菲拉斯"] = "KZ,Njnjia",["永恒之井"] = "KX,自是白衣卿相",["巨龙之吼"] = "KW,完美落幕丶",["雷霆之怒"] = "KW,波西米亚辉",["利刃之拳"] = "KV,神乂救赎",["日落沼泽"] = "KV,贫道法号梦遗",["戈提克"] = "KV,Beelzubub",["诺莫瑞根"] = "KV,东方仗助",["暗影议会"] = "KU,莫惜肆",["萨格拉斯"] = "KT,霓凰郡主",["月光林地"] = "KT,浏阳河赛艇;KR,汐玥",["托塞德林"] = "KS,丶洋葱",["萨菲隆"] = "KS,徒手掰脊椎",["晴日峰（江苏）"] = "KR,奶炮",["卡德加"] = "KR,幻影神",["风行者"] = "KR,前川",["试炼之环"] = "KR,游学者流年",["影牙要塞"] = "KR,我记性好差",["安东尼达斯"] = "KQ,开拓者丶咸鱼",["玛里苟斯"] = "KQ,堕落之誓",["洛丹伦"] = "KQ,部落骑士",["白骨荒野"] = "KP,永島圣羅",["图拉扬"] = "KP,半盏春",["达拉然[US]"] = "KP,Cathrot",["暗影之月"] = "KP,万神殿丶可心",["奥妮克希亚"] = "KN,巧面馆",["伊利丹"] = "KN,Bloodypyre,Bloodyfive",["扎拉赞恩"] = "KN,逍遥丹哥",["埃苏雷格"] = "KN,囧囡囚囧",["天空之墙"] = "KN,病态的怜悯",["火焰之树"] = "KM,天舞星辰",["伊萨里奥斯"] = "KM,Tsaixx"};
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