local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,叶心安-远古海滩,乱灬乱-伊森利恩,瓜瓜哒-白银之手,Monarch-霜之哀伤,败家少爷-死亡之翼,不含防腐剂-诺森德,不要捣乱-斯克提斯,大江江米库-雷霆之王,蒋公子-死亡之翼,御箭乘风-贫瘠之地,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,橙阿鬼丶-达尔坎,打上花火-伊森利恩,剑四-幽暗沼泽,站如松-夏维安,Noughts-黑石尖塔,落落萧萧-罗宁,圣子道-回音山,不嗔-迦拉克隆,奎托斯丶奎爷-白银之手,荼麟、濤-贫瘠之地,Bloodtd-死亡之翼,Darkage-洛丹伦,轩辕银月-雷克萨,我的夜茉莉-法拉希姆";
local recentDonators = {["暗影之月"] = "EK,五元加我骑德;EF,暗之灬,唐小仔",["亚雷戈斯"] = "EK,长离未离孜;EH,一生有你",["燃烧之刃"] = "EK,林小冉;EJ,爱你;EI,我在天空飞;EG,孚光掠影,车车仔,披星挂月;EF,有眼不识海山;EE,尐丶牧師,嗳佳,刘华强;ED,",["影之哀伤"] = "EK,蒂姆亨特;EJ,静师太,贝优莉塔;EH,Ewxyz;EG,好热开空调吧,来自竹林深处;EF,我的爷;EE,好帥帥哦丶,不问",["寒冰皇冠"] = "EK,辅导员丶",["丽丽（四川）"] = "EK,晓尐;EI,玄觞,冷颜暖语;EH,鱼丁糸;EF,帝苍林丶",["无尽之海"] = "EK,燃烧的灵魂;EJ,十年梦醒;EI,洐澐瑬氺,贱贱顶乾坤;EH,毓婷一片就灵;EG,Ziv,忧伤斜阳,或丶许;ED,閃電",["白银之手"] = "EK,聖光儛步;EJ,乐思,韓先生,Maddison;EI,Toscana,团长有点萌,星铁反曲刀丶,欧皇老杨;EH,纵享地板丝滑;EG,贪玩橙月丶,这里有德,Civilux,圣堂龙烈;EF,肥肥的肉丸,灬毛毛虫,萝摩衍娜;EE,Orangemay,尺间萤火,那哖夏天,苏筱筱,黑框;ED,等待并怀希望,人间不直的,牧滚滚,单纯小耗子,苏米图,一望好多年,Silvermoonfl,很虚",["凤凰之神"] = "EK,伊卡捷琳娜;EJ,习羽灬,传送使者;EI,阿萨德白羊;EH,姐夫你好棒,永远有多远呢;EG,黑崎丶;EF,杨世碧丶;EE,罗纳尔多赵四,舞心乄;ED,转折丨秘密,曹伱摸阿博伊",["贫瘠之地"] = "EK,Elunen;EJ,皮卡丘璎珞,就想怼一怼;EI,一个师的兵力,拉面儿,圣光救不了妮;EH,雅思,灬苍月灬;EG,Ajstyles,魔兽容嬷嬷,就想歇一天;EF,怀梦阿七",["死亡之翼"] = "EK,你的老爹我;EJ,Laomaoo;EI,一是无橙,泉夜;EH,西瓜皮丨;EG,灬巴依老爷灬,败家少爷,妖舞狼姬,花无念,曼莎珠华丶;EF,Brozovic,森夏的回忆,半月板儿;EE,骨板的战复踢;ED,月夏,冠希哥小迷弟,邪恶光环丶,稻香村小奶糕",["黑铁"] = "EK,圣光娜迦;EH,蠕動荣誉,姐控;EG,耐艹,Predatoru;EE,不胜则亡",["壁炉谷"] = "EK,亚当斯旺;EH,断线楓筝",["雷霆之怒"] = "EJ,浅色丨夏末;ED,以星辰之名,Lifedream",["洛萨"] = "EJ,晕了过去",["加基森"] = "EJ,千颂伊;EE,林师傅",["迅捷微风"] = "EJ,糖醋很有爱;EH,希耳瓦娜斯;EF,冲锋下跪释放,胡椒火力;ED,南风识我意",["伊萨里奥斯"] = "EJ,天啊你真怂;EE,Xxzs",["梦境之树"] = "EJ,死亡领主;EH,炙热;ED,萌男奶牧",["阿拉索"] = "EJ,別天神丶,荣歌;EG,古巨基",["烈焰峰"] = "EJ,七七四十九;ED,蠢萌蠢萌德",["图拉扬"] = "EJ,笑一",["萨尔"] = "EJ,喵孒個咪;EI,影灬随风;ED,小小慢漫悠悠",["冰霜之刃"] = "EJ,小乔妹;EI,伊芙蕾尔",["燃烧军团"] = "EJ,苏拉萨琪玛;EF,菠萝小乔;ED,超级丨奶爸",["国王之谷"] = "EJ,Vzj,聖殿守備官;EF,曼殊沙華;EE,大主教秦端雨,明月下西樓;ED,零柒陆叁",["破碎岭"] = "EJ,素昕;EG,玫瑰心殇,流璃;EF,血酬定律",["迦拉克隆"] = "EJ,鲨鱼小米辣,猫咪丶桑桑;EI,荼鸳,半根勺子,一根勺子;EH,刃之輪迴,丶醉逍遥丨,米饼阿哥;EG,小野猫丨,不摇就滚,惠心兰质,Xiaoend;EE,Darkoranger;ED,混沌女皇",["格瑞姆巴托"] = "EJ,十一月的萧邦,雨夜扎马尾;EI,占戈丨十三;EH,残月酒馆馆主;EG,丶此何人哉,雨灬如剑;EE,渐稀,更泩",["金色平原"] = "EJ,七绝弑神,黑涩星期五丶,天弃丶,Firerain;EI,药剂师格雷夫;EH,Shadowonfire;EG,路西亚啊;EF,费纳斯特",["山丘之王"] = "EJ,康定小情歌",["戈提克"] = "EJ,虎山行",["迦罗娜"] = "EJ,月之阴影",["玛里苟斯"] = "EJ,青柠罗勒;ED,红尘輪回,傲笑红尘",["海加尔"] = "EJ,虎牙萌喵",["菲拉斯"] = "EJ,元元",["熔火之心"] = "EJ,长风几万里;EG,山顶冻人",["莫德古德"] = "EJ,再看射死你",["血色十字军"] = "EJ,浪正;EH,天譴領主;EG,想怼迪丽热巴,睿小新还;EF,无故犭苗,Meetorange;EE,妹迷的凯小郑;ED,太难得的记忆",["奥妮克希亚"] = "EJ,源彩钏",["伊森利恩"] = "EJ,今晚打母老虎;EI,圈住那个九,彳亍口巴,壹坛老酒,采露;EH,夏丶斗凰;EF,写咩萌,小布丶豆;EE,落秋丶,看山丶,太阳心,大胖丶;ED,寂寞凌迟",["血之谷[TW]"] = "EJ,慕小柒",["主宰之剑"] = "EJ,君生,刀锋丿之影;EH,再见罔两,邪能阿昆达,摇摆随风;EG,致命魔术乄,我骗你的;ED,九二四零三,我不爱吃鱼",["奥特兰克"] = "EJ,一只没有睫毛;EH,信仰小鲸鱼丶,夏丶紫薇;EG,那真是打扰了,信仰小鲸鱼;ED,维他命果冻",["红云台地"] = "EJ,Stranded",["埃德萨拉"] = "EJ,人猿泰山;EI,变态的阿昆达,风霂阳;EG,扛不住怎么啦,曲终红颜殁;EF,落月之后",["阿古斯"] = "EJ,肉山大馍王",["摩摩尔"] = "EJ,Yolanda;EG,Vtianc",["燃烧平原"] = "EI,丿战弑灬天下",["冰风岗"] = "EI,夜雪;EH,Dekey,伊洛克希;EF,西楼;EE,Poiaris,你温柔的样子",["梅尔加尼"] = "EI,安河桥;EH,冷鋒;EF,菜刀又见菜刀",["红龙军团"] = "EI,叉烧切鸡濑;EF,玛奇,三股螺旋",["铜龙军团"] = "EI,流年碎",["罗宁"] = "EI,瓦莉拉丶瑞亚,唐萌;EG,飘香奶茶;EF,小破团;EE,痕星",["龙骨平原"] = "EI,丶迪安;EH,浅了",["蜘蛛王国"] = "EI,读条带走青春;EH,古月丶",["提瑞斯法"] = "EI,谢大力;EG,烈风的骑士姬;EF,沉沦战魂,漫天小雪",["克尔苏加德"] = "EI,小辫子冲天;EF,今夕何夕然,依然刺刺",["奥达曼"] = "EI,咕噜碳",["刺骨利刃"] = "EI,小橘子大魔王",["麦姆"] = "EI,无火的余烬",["海克泰尔"] = "EI,响罕;EH,灬毒瘤灬;EF,影帝塔里克,满满丶;ED,刘非凡",["永恒之井"] = "EI,最初的梦想;EH,柳暗花瞑;EG,天羽翼",["安苏"] = "EH,刺客之源,崑霅;EG,劣人的德宝宝,啃德吉;EF,路人王丶,灯影牛丸;EE,Skybluesea,傳说丨包纸;ED,壳霸霸",["翡翠梦境"] = "EH,冰影随行;EG,一只国宝;EF,盆盆叔叔;EE,狂野幽灵",["羽月"] = "EH,深白色;EG,白条肉肉;EF,活着不好吗;EE,Seafang",["熊猫酒仙"] = "EH,海天岚的猪猪;EG,唯訫不易;EE,陆丷多多,Icefree,风乄语;ED,婷婷无双",["奥尔加隆"] = "EH,低温耳语",["克洛玛古斯"] = "EH,冰河葬寒心;EF,她予他梦",["奥蕾莉亚"] = "EH,污迪尔",["塞拉摩"] = "EH,兰桨;ED,晨歌光焰,午夜枪手",["诺莫瑞根"] = "EH,神星星",["巫妖之王"] = "EH,绿荳沙",["风暴之怒"] = "EH,爱你哟,在下御姐控丶;EE,黑夜零散",["藏宝海湾"] = "EH,冰河葬寒心乄",["哈兰"] = "EH,卍斯大林卍",["雷斧堡垒"] = "EH,波雅娜",["深渊之巢"] = "EH,情灬不知所起",["鲜血熔炉"] = "EH,陈老湿;EG,Zerotwo",["熵魔"] = "EH,猫橙丶",["风行者"] = "EH,索利达尔",["泰拉尔"] = "EH,云遥丶;EG,霓裳映月",["阿尔萨斯"] = "EG,邪恶之眼,帅德丶伊比",["艾维娜"] = "EG,Wulibonbon",["扎拉赞恩"] = "EG,饭岛爱",["布兰卡德"] = "EG,有一点晚晚,中环西门庆;EF,丶宫水三叶丶",["雷霆号角"] = "EG,Ms",["索瑞森"] = "EG,旅店老板女儿",["阿拉希"] = "EG,冷无月",["祖阿曼"] = "EG,六一朵",["菲米丝"] = "EG,黑猫警长黑;EF,白衣不染尘",["巨龙之吼"] = "EG,大饼叫兽丶",["红龙女王"] = "EG,微哥爱你们哟",["桑德兰"] = "EG,莫师妹",["太阳之井"] = "EG,江湖郎中",["伊瑟拉"] = "EG,浅白",["朵丹尼尔"] = "EG,总之就是壹刀",["???"] = "EG,影踪派胖啾咪;EE,红豆白椒;ED,花梨影木,AlvandaBarthilas;EC,梦中的梦里,米兰阿玛尼乁;EB,贰贰叁肆,Fofof",["艾森娜"] = "EG,饼干",["世界之树"] = "EG,Eenvy/娜喵酱",["斯克提斯"] = "EG,燃烧我的艾酱",["伊利丹"] = "EF,天月依",["深渊之喉"] = "EF,咫尺月明",["末日行者"] = "EF,矮大爷,韩晨羲,玛珐里奥,拳击健将,天下有雪,大靡靡",["斯坦索姆"] = "EF,萨克麦迪克",["火焰之树"] = "EF,烛影斜;EE,洁妹",["库德兰"] = "EF,寂寞来了",["血环"] = "EF,刀锋之血,五晨之光",["自由之风"] = "EF,罪剑问天谴",["千针石林"] = "EF,Ninakidd",["黑暗虚空"] = "EF,三逗比笑呵呵",["瑟莱德丝"] = "EF,Crystalmaid",["艾苏恩"] = "EF,Doublefire",["加兹鲁维"] = "EF,Java",["日落沼泽"] = "EF,Odanobunaga;ED,美屡小玉",["古尔丹"] = "EF,Xiaojinmao",["鬼雾峰"] = "EF,小鸭;EE,輪椅鬥士;ED,花漾铃兰",["暗影议会"] = "EE,幻舞",["末日祷告祭坛"] = "EE,Divano",["泰兰德"] = "EE,动若脱兔",["天空之墙"] = "EE,雨夜敬清秋",["血牙魔王"] = "EE,阴风阵阵",["暮色森林"] = "EE,月之舞斩断吧",["弗塞雷迦"] = "EE,灬镜远香灬",["冬泉谷"] = "EE,夜子冥",["格雷迈恩"] = "EE,玄月哀歌",["基尔加丹"] = "EE,太玄",["麦迪文"] = "EE,遗忘丶阡陌",["达纳斯"] = "EE,血色冰河;ED,诗意",["试炼之环"] = "EE,好朋友;ED,林樨",["塞纳留斯"] = "EE,搬砖小霸王",["回音山"] = "EE,冷色葉瞳,丿落小煙",["达隆米尔"] = "EE,老板娘的腿毛",["达文格尔"] = "EE,碳酸钙",["雷克萨"] = "EE,群体驱散",["石爪峰"] = "EE,丶丨法海無边",["达尔坎"] = "ED,雲小蛋",["卡德加"] = "ED,冰茶哟",["埃克索图斯"] = "ED,鹿鸣",["奈法利安"] = "ED,念念有诗",["玛瑟里顿"] = "ED,白眉",["晴日峰（江苏）"] = "ED,尐丶崽",["阿比迪斯"] = "ED,弑疯",["罗曼斯"] = "ED,Moppa",["阿迦玛甘"] = "ED,雙鱼座"};
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