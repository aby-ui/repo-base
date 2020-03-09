local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["托塞德林"] = "Mu,铁柱",["死亡之翼"] = "Mu,婷好丶挺好,阿洋丶;Mt,梦回海布里;Ms,暴力春春,谁动了我情弦,请叫我王先生;Mr,雾羽崎,浅若灬梨花落;Mq,思舟丶,许光汉,是阿喵啊,Eviscarite,盗版杀手;Mp,洛天丨凌風,不羁与醉,破魔之紫蔷薇;Mo,肥嘟嘟布紫灰,晓灬筱,跟我去冒险,人死雕朝天;Mm,Yawakaze,Flywan,Furiosalol;Mj,萨戈尼奥,铁腕凯恩,吃货不痴货丶",["天空之墙"] = "Mu,丶晴空灬燃烬;Mm,聽不語",["主宰之剑"] = "Mu,冰域,用萌感动部落;Mt,玥辰乄,魔剑阿波菲斯;Mr,崇文;Mo,只牵你的手;Mn,乌黑亮丽;Mj,山东大汉丶,使命救赎,馥馥芳蕤",["巨龙之吼"] = "Mu,虚空毁灭射线",["伊森利恩"] = "Mu,北方的北方;Mr,Tonight,灬暴丨君灬;Mo,套套,祸晴儿;Mm,逍遥水中月;Mj,認真對待一切,油炸嫩香蕉",["克尔苏加德"] = "Mu,鱼塘星女神;Mn,醒目可乐味",["古尔丹"] = "Mu,哆多",["格瑞姆巴托"] = "Mu,云雾散,苏瑶儿丶,尨貓灬;Mt,望穿丶;Ms,火鸡味锅巴,Asakalu;Mr,今夜前往繁星;Mq,Vintone;Mo,大哥棒棒哒;Mm,麻酱拌面;Mj,拯救迷路少女,贝尔丶阿迪克,小饭",["???"] = "Mu,猫熊天天;Mt,三只鼠,Asparas;Ms,苏瑶儿丶;Mr,丶战撸;Mq,乄無芯之湿;Mn,丿丨小怪兽;Mj,厉血烟",["永夜港"] = "Mu,Bluzzer;Mr,舟",["血牙魔王"] = "Mu,聖光忽悠着尼,非洲小龙瞎,江狐筱贼",["白银之手"] = "Mu,賎气凛然,Fovdk;Mt,雾都老胖娃儿;Ms,深蹲的男人,Dondo,Luciferyang,Violettayang,聖卡洛斯;Mr,勿飞,三吉丶彩花;Mq,暖男,冰焰之忆;Mj,Ioststars,粥祭丨捣蛋",["燃烧之刃"] = "Mu,哆咪;Mt,恶之魔,Milkteea,咪咪九九八,红发亞特鲁,炎爆术丶;Ms,萨萨;Mr,纯情小种马,困住的野兽;Mp,麥甜甜;Mo,没有奶的棍棍;Mn,蝎子丿莱莱,丶笑魇無她;Mm,小宝月;Mj,造梦小丶姐,Matildaa,豪横丶,新大陸的白風,一襟花月,牛牛小武僧",["贫瘠之地"] = "Mu,皮皮虾打篮球;Mt,Mortychen,谈爱恨;Ms,雾雨夜,花菜;Mr,萌闪闪;Mq,花江鲤;Mm,狐铁花",["伊瑟拉"] = "Mu,依瑞爾;Mt,布鲁斯大爷",["凤凰之神"] = "Mu,胡极霸郎,暮光微醺;Mt,她乡之秋;Ms,晚謃;Mr,丶菠萝包;Mq,九五年保温杯;Mp,吉原悠一;Mn,友情以上;Mm,小基基丶,八千年玉老;Mj,工部尚书,Kratos",["国王之谷"] = "Mt,任性大领主,末日決戰,溺死了过往;Mr,熊猫丶污妖王;Mp,离谱小白;Mo,来舔我饅頭嘛;Mm,丶二柱子,彩子丶;Mj,阿卡灬贝拉",["罗宁"] = "Mt,最后一朵奇葩,Elfo;Ms,我不玩奶德,拉不住是菜,我不是战吊,元沐夕;Mq,Tzuheng;Mp,心允朵朵;Mo,真不知盘誰;Mn,谁有不平事;Mm,蛋蛋风风;Mj,保护我方鲁班",["自由之风"] = "Mt,Baintha",["末日行者"] = "Mt,喵三千;Mp,幽默不失离骚;Mo,黄旭西,曾经的安静;Mj,丁妮戈菲",["金色平原"] = "Mt,哎喽微,哒卜妞;Mp,彡咻咻彡",["安苏"] = "Mt,差劲先生;Mr,Mcon,未驲观光;Mp,梦幻领袖;Mn,皮爱吉;Mj,八宝丶宝",["回音山"] = "Mt,云岚;Mq,小黄骑;Mo,樱岛麻衣酱;Mj,滑蛋牛柳",["范达尔鹿盔"] = "Mt,不怕不怕你",["血色十字军"] = "Mt,Yearned,Yearning;Ms,梅发怒;Mp,烧糊的生花菜;Mn,小小茉莉丶;Mm,丶尛柒灬",["卡德罗斯"] = "Mt,鲜艳的红领巾",["无尽之海"] = "Mt,静水阳流,三级无尽;Ms,欧皇圣光,乐炅,不关枸杞的事;Mq,欧皇信仰;Mo,欧皇劣人,喵嗚不停;Mj,河边的悉达多",["暗影议会"] = "Mt,跳跳神牛",["月神殿"] = "Mt,土豆皮儿;Ms,樱桃之祸",["神圣之歌"] = "Mt,小土豆丶恶魔;Ms,浮世沉香;Mr,Overous",["萨尔"] = "Mt,Scottsummer",["布兰卡德"] = "Ms,我渴了要喝水;Mq,詩經;Mo,Oshotokill,見得風是得雨,雪落下的声音",["迅捷微风"] = "Ms,音樂老師",["末日祷告祭坛"] = "Ms,文沐沐,王俊凯嘤嘤",["雷霆之王"] = "Ms,三级腐蚀",["影之哀伤"] = "Ms,橙匕;Mr,清风扶醉月,斩杀了奶好我;Mj,闷人的狐臭",["黑翼之巢"] = "Ms,喜庆",["黑手军团"] = "Ms,大象优雅",["木喉要塞"] = "Mr,苦胆",["阿古斯"] = "Mr,螭吻丿,阿克萌德丿;Mq,雨灬",["熊猫酒仙"] = "Mr,咕喵王丶;Mp,潶白;Mo,柒木;Mj,晴曛丶",["翡翠梦境"] = "Mr,养多肉的浣熊",["灰谷"] = "Mr,米琳达",["玛里苟斯"] = "Mr,北冽鲸涛",["蜘蛛王国"] = "Mr,紫影儿",["丽丽（四川）"] = "Mr,夏沫丶浅雨;Mp,戎州张家辉,倚林醉;Mo,清风拂杨柳丶",["阿尔萨斯"] = "Mr,再见路西儿",["埃德萨拉"] = "Mq,啊宝,哥歌,大饼干灬,大饼干;Mj,烟花小喵",["聖光之願[TW]"] = "Mq,Aasiyah",["希雷诺斯"] = "Mq,达芙妮",["恶魔之魂"] = "Mq,猫仙女要抱抱;Mj,凉丶凉,花开一季",["战歌"] = "Mq,Goldberg",["奈法利安"] = "Mp,拂浪影山川",["鬼雾峰"] = "Mp,妖孽丶",["狂热之刃"] = "Mp,墨淺灬南筏",["凯尔萨斯"] = "Mp,Galahad",["丹莫德"] = "Mp,聪少爷的箭丶;Mm,老牛牛波",["阿迦玛甘"] = "Mp,一样",["能源舰"] = "Mp,大圣",["阿纳克洛斯"] = "Mp,羽流丶;Mj,阿远丶狂奔",["血顶"] = "Mp,白琰",["奎尔萨拉斯"] = "Mp,淡定的阿雅",["迦玛兰"] = "Mo,Deloco",["迦拉克隆"] = "Mo,不朽之王;Mm,靑沐",["熔火之心"] = "Mo,拳王的故事",["麦维影歌"] = "Mo,泡椒小花生",["亚雷戈斯"] = "Mo,丨神乐",["密林游侠"] = "Mo,软子夜壶丶",["诺森德"] = "Mo,凤箫吟",["提尔之手"] = "Mo,安杜尼苏斯",["冰风岗"] = "Mo,Magebanes",["天谴之门"] = "Mo,瘦丿西风",["荆棘谷"] = "Mo,诺凡;Mm,大叔做不到",["米奈希尔"] = "Mo,拾步殺壹人",["梅尔加尼"] = "Mo,宝贝妮子",["寒冰皇冠"] = "Mn,天道茫茫",["刺骨利刃"] = "Mn,无敌干涉",["龙骨平原"] = "Mn,陈丶疯爆劣酒",["幽暗沼泽"] = "Mn,谁叫我胖虎",["壁炉谷"] = "Mn,天生一水",["试炼之环"] = "Mn,暗丶魂乡",["奥特兰克"] = "Mn,可道可名",["霜之哀伤"] = "Mn,周杰倫;Mm,貓南北",["伊利丹"] = "Mm,不死亚瑟",["克洛玛古斯"] = "Mm,小圆",["嚎风峡湾"] = "Mj,爆狂",["血环"] = "Mj,西城阿哥",["加基森"] = "Mj,杜兰达尔",["奥尔加隆"] = "Mj,枫与糖",["暗影之月"] = "Mj,凤年梧桐",["尘风峡谷"] = "Mj,狂野小魔星",["太阳之井"] = "Mj,唯伊",["诺兹多姆"] = "Mj,苇渡江安公子",["鲜血熔炉"] = "Mj,游若阑",["黑铁"] = "Mj,小狂牛",["风暴之鳞"] = "Mj,張公子"};
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