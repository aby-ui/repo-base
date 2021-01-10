local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["天空之墙"] = "Rl,丶病娇的萝莉;Rj,Njmpl",["安苏"] = "Rl,萌奶狗;Rk,一下就好喇;Rh,贫僧颜值担当;Rf,骨头没有肉;Re,浊酒念红尘丶,请叫我烹鱼宴;Rd,爽大乳",["布兰卡德"] = "Rl,罗生门丶九晚,竦斯,不具名的演员;Rk,寂寞地根号三;Rj,Hugeforce,无言宅;Ri,碳酸不补钙;Rh,战歌灬艾力;Re,烟火丶静流年",["阿古斯"] = "Rl,咕噜咕噜冒泡;Rj,風的叹息,范閑;Ri,伊曈;Re,幸福丿小昊冉",["埃德萨拉"] = "Rl,龍烈;Rg,箭隐鋒藏;Rf,狗头肥猫;Rd,Sufferer,Pcc",["迦拉克隆"] = "Rl,口空空;Rh,还有亡法嘛;Re,梦里花萝;Rd,冲锋丶斩杀",["白银之手"] = "Rl,这是女鬼,坚强的西红柿,犹大的烟,猫牧;Ri,凤舞乱发;Rh,荒野残羽,杰佛里斯,愿拆曲成诗;Rg,荒野羽羿;Re,月殇梦忆;Rd,逆流乄曼荼罗,法蕾拉",["凤凰之神"] = "Rl,諸葛村夫,哈喽小冰糕;Rk,风起苍岚,奎二爷;Ri,王豆腐,Öqs;Rg,敷衍的誓言,赤魂,仁吼義侠;Rf,善良的钢琴师,恩赐解手,毛线团子,Sho,Sorei;Re,青木枷锁;Rd,賊有钱,审判使者,御姐有三妙,执筆念殇",["达基萨斯"] = "Rl,蒸汽引擎",["巫妖之王"] = "Rl,厮守灬聼雨;Rk,帝國戰歌",["丽丽（四川）"] = "Rl,艾菲尔铁蛋,是昔流芳丶,田书宇女朋友;Rk,萨拉雷霆;Rf,灬柒爺丶",["格瑞姆巴托"] = "Rl,南波旺;Rk,榜一大哥丶,嗨吖;Ri,一个宝宝;Rh,小小睡着了;Rg,鶸鶸的丶暮色,平安喜樂,盗云;Rf,小神有礼了;Re,我艾希伱奶",["???"] = "Rl,白月魁;Rf,Reincord",["尘风峡谷"] = "Rl,雲中锦書",["古尔丹"] = "Rl,石佛;Rd,冰冻废土之力",["耳语海岸"] = "Rl,邪能在燃烧",["死亡之翼"] = "Rl,乔布衣;Rj,曉嘴乱亲,枕上留书,你五岁了吗;Ri,超级乐,Hides,紫川戟;Rh,軟軟的棉花糖,澜墨雪,猎丶人啊,自导自演;Rf,丶名侦探柯南,星河清梦;Re,血牙刀贼",["燃烧之刃"] = "Rl,Titanfor,Shrrek;Rk,赵灬樱空;Ri,丨苏泠玥丨;Re,狂徒练习生",["试炼之环"] = "Rl,月下丶独舞",["克尔苏加德"] = "Rl,枫之叶飘灬;Rj,翻滚吧绵羊君;Ri,夜话白露;Re,野狐禅",["鬼雾峰"] = "Rl,儒雅死骑",["血色十字军"] = "Rk,李砚;Ri,威利鱼鱼旺卡;Rh,光能心潮,小被子丶,亡者祝福;Rg,无故挽歌,夏了个夏天;Rf,董老湿,猫不二;Re,鯊鱼丶;Rd,全体丨起立",["诺兹多姆"] = "Rk,皎月织夜景;Rj,鲸楼",["巨龙之吼"] = "Rk,星爵",["贫瘠之地"] = "Rk,盾萌萌;Rj,罗克里安音阶;Ri,山河予你;Rg,五更千里梦,死就对了;Rf,你又胖了;Re,Radomss,丽萨丶",["希尔瓦娜斯"] = "Rk,阿里拉丶道森",["无尽之海"] = "Rk,旧爱丶;Ri,超级咕咕,阿咸;Re,再瞅下试试",["罗宁"] = "Rk,鱼戏莲叶间;Rj,不可言喻的懒,懒神仙,盖世无双;Rh,Oraange,东风洲际导弹;Rg,宫水三葉;Rf,丨夜白灬;Re,侠菩提,梵刹迦蓝;Rd,阿萬音鈴羽",["海克泰尔"] = "Rk,佐右;Rg,新鲜韭浪两块",["红龙女王"] = "Rk,人狠話不多",["伊森利恩"] = "Rk,无处话凄凉;Rj,傲气冲天乄;Ri,凤凰牌电动车,大美熊;Rh,Fantasticki;Rf,尐胖纸丶;Re,丶黑鹅,壹零贰拾,拙锋,远帆;Rd,Tokio",["冰风岗"] = "Rk,凡尔赛文学家;Rj,清雾扰山河;Ri,岚夏丶,驴帅尧;Rh,Payson;Rf,六星霜,Sastabber,顶缸;Rd,飞雁",["主宰之剑"] = "Rk,应逆天,一只晴天啊丷;Ri,KotoriItsuka;Rg,安果;Rf,堕落的小角,獸教父;Re,单行道",["海加尔"] = "Rk,北京大耳帖子",["守护之剑"] = "Rk,别鬧",["山丘之王"] = "Rk,内酷你看不到",["洛丹伦"] = "Rk,圣疗加不满,丶冯宝宝;Rh,永生",["影之哀伤"] = "Rk,夿丶;Rj,可怕的五花肉;Ri,猥琐的神话,夜闌听雨,射的全是爱;Rh,奔雷手文太;Rg,邓潇洒,尛可心;Re,乄呆波波乄",["奥特兰克"] = "Rk,大王叫来巡山;Rd,闰土之裤",["神圣之歌"] = "Rj,恭禧发財,绿茶;Rg,半醒",["金色平原"] = "Rj,十六夜娜娜,桃乐丝丶晨翼;Rg,王大蛮",["阿纳克洛斯"] = "Rj,篮子里的果",["月光林地"] = "Rj,弱鸡法;Rg,你的小虎哥",["艾露恩"] = "Rj,阿普唑仑",["奥斯里安"] = "Rj,将由",["阿尔萨斯"] = "Rj,噬碎死牙之兽;Re,Machupicchu",["亚雷戈斯"] = "Rj,萌萌哒柠檬",["洛肯"] = "Rj,Hgxs",["加基森"] = "Ri,曰过范冰冰",["破碎岭"] = "Ri,與你無关;Re,Bingk",["索瑞森"] = "Ri,Oministero",["狂热之刃"] = "Ri,电放锅",["提瑞斯法"] = "Ri,暴走的裤衩",["布鲁塔卢斯"] = "Ri,Crazyhunterm",["国王之谷"] = "Ri,Rhongomyniad",["伊萨里奥斯"] = "Ri,射姑龙女",["熊猫酒仙"] = "Rh,真银骑士,空虚婧灵;Rf,周大佬爺;Re,儿时语,瞬间焰火",["雷斧堡垒"] = "Rh,Lovered",["蜘蛛王国"] = "Rh,愛小丹",["血牙魔王"] = "Rg,晨熙爸爸",["伊瑟拉"] = "Rg,怒放的雪",["暗影之月"] = "Rg,二郎显聖;Rd,怒风乄之魂",["永恒之井"] = "Rg,一只小飞狗",["黑铁"] = "Rg,可爱的李老师;Rf,不要不妖的",["霜之哀伤"] = "Rg,夜翼迪克,兽栏管里员",["熔火之心"] = "Rg,藤井美菜",["埃苏雷格"] = "Rg,Lovoom",["夏维安"] = "Rg,温酒丷叙余生,月落丷霜满天",["冰霜之刃"] = "Rf,王不留狗",["黑暗魅影"] = "Rf,妩妖王",["末日行者"] = "Rf,Simha;Re,哈哈坏天气;Rd,豆豆勇士,Zetacola",["卡德加"] = "Rf,烽火的箭矢",["风暴之鳞"] = "Rf,心淡若水",["世界之树"] = "Rf,微笑的蒂妮莎",["白骨荒野"] = "Rf,天煞",["血吼"] = "Rf,长大后更帅",["战歌"] = "Rf,则竹裕之",["麦迪文"] = "Rf,雪冰凌",["红龙军团"] = "Re,二十个我",["纳沙塔尔"] = "Re,喝奶",["斯坦索姆"] = "Re,圣魔饭饭",["诺莫瑞根"] = "Re,紫露冰凝",["迅捷微风"] = "Re,寂寞续杯;Rd,壹头好牛牛",["玛瑟里顿"] = "Re,陨落的星辰",["燃烧军团"] = "Re,不存在的情人",["奥尔加隆"] = "Rd,Bwonsamdi",["梅尔加尼"] = "Rd,赫尔海姆的羊",["耐奥祖"] = "Rd,王一博,莲藕炖排骨",["黑石尖塔"] = "Rd,夕阳下的梦魇",["克洛玛古斯"] = "Rd,堕灬世丨知梦",["雷霆之王"] = "Rd,矌谷幽蘭,深谷幽蘭",["翡翠梦境"] = "Rd,白鸾",["泰拉尔"] = "Rd,夜丶风",["黑锋哨站"] = "Rd,冲锋遇到树,玩不来法爷"};
local lastDonators = "愿拆曲成诗-白银之手,小小睡着了-格瑞姆巴托,永生-洛丹伦,愛小丹-蜘蛛王国,亡者祝福-血色十字军,东风洲际导弹-罗宁,贫僧颜值担当-安苏,Lovered-雷斧堡垒,小被子丶-血色十字军,Fantasticki-伊森利恩,自导自演-死亡之翼,猎丶人啊-死亡之翼,杰佛里斯-白银之手,澜墨雪-死亡之翼,軟軟的棉花糖-死亡之翼,光能心潮-血色十字军,荒野残羽-白银之手,Payson-冰风岗,空虚婧灵-熊猫酒仙,奔雷手文太-影之哀伤,Oraange-罗宁,还有亡法嘛-迦拉克隆,真银骑士-熊猫酒仙,战歌灬艾力-布兰卡德,丨苏泠玥丨-燃烧之刃,射的全是爱-影之哀伤,射姑龙女-伊萨里奥斯,夜闌听雨-影之哀伤,一个宝宝-格瑞姆巴托,Rhongomyniad-国王之谷,凤舞乱发-白银之手,紫川戟-死亡之翼,Crazyhunterm-布鲁塔卢斯,KotoriItsuka-主宰之剑,威利鱼鱼旺卡-血色十字军,大美熊-伊森利恩,Öqs-凤凰之神,Hides-死亡之翼,王豆腐-凤凰之神,暴走的裤衩-提瑞斯法,猥琐的神话-影之哀伤,电放锅-狂热之刃,山河予你-贫瘠之地,Oministero-索瑞森,阿咸-无尽之海,超级乐-死亡之翼,夜话白露-克尔苏加德,與你無关-破碎岭,超级咕咕-无尽之海,碳酸不补钙-布兰卡德,伊曈-阿古斯,凤凰牌电动车-伊森利恩,驴帅尧-冰风岗,曰过范冰冰-加基森,岚夏丶-冰风岗,Hgxs-洛肯,萌萌哒柠檬-亚雷戈斯,噬碎死牙之兽-阿尔萨斯,范閑-阿古斯,将由-奥斯里安,清雾扰山河-冰风岗,翻滚吧绵羊君-克尔苏加德,可怕的五花肉-影之哀伤,阿普唑仑-艾露恩,无言宅-布兰卡德,Hugeforce-布兰卡德,傲气冲天乄-伊森利恩,弱鸡法-月光林地,你五岁了吗-死亡之翼,绿茶-神圣之歌,風的叹息-阿古斯,桃乐丝丶晨翼-金色平原,盖世无双-罗宁,懒神仙-罗宁,枕上留书-死亡之翼,篮子里的果-阿纳克洛斯,不可言喻的懒-罗宁,Njmpl-天空之墙,曉嘴乱亲-死亡之翼,罗克里安音阶-贫瘠之地,鲸楼-诺兹多姆,十六夜娜娜-金色平原,恭禧发財-神圣之歌,一只晴天啊丷-主宰之剑,大王叫来巡山-奥特兰克,夿丶-影之哀伤,萨拉雷霆-丽丽（四川）,寂寞地根号三-布兰卡德,丶冯宝宝-洛丹伦,圣疗加不满-洛丹伦,内酷你看不到-山丘之王,嗨吖-格瑞姆巴托,别鬧-守护之剑,一下就好喇-安苏,北京大耳帖子-海加尔,应逆天-主宰之剑,凡尔赛文学家-冰风岗,无处话凄凉-伊森利恩,帝國戰歌-巫妖之王,人狠話不多-红龙女王,榜一大哥丶-格瑞姆巴托,佐右-海克泰尔,鱼戏莲叶间-罗宁,旧爱丶-无尽之海,奎二爷-凤凰之神,阿里拉丶道森-希尔瓦娜斯,盾萌萌-贫瘠之地,赵灬樱空-燃烧之刃,星爵-巨龙之吼,皎月织夜景-诺兹多姆,李砚-血色十字军,风起苍岚-凤凰之神,儒雅死骑-鬼雾峰,田书宇女朋友-丽丽（四川）,是昔流芳丶-丽丽（四川）,不具名的演员-布兰卡德,Shrrek-燃烧之刃,竦斯-布兰卡德,猫牧-白银之手,枫之叶飘灬-克尔苏加德,月下丶独舞-试炼之环,Titanfor-燃烧之刃,乔布衣-死亡之翼,犹大的烟-白银之手,邪能在燃烧-耳语海岸,石佛-古尔丹,雲中锦書-尘风峡谷,白月魁-???,南波旺-格瑞姆巴托,艾菲尔铁蛋-丽丽（四川）,哈喽小冰糕-凤凰之神,厮守灬聼雨-巫妖之王,蒸汽引擎-达基萨斯,諸葛村夫-凤凰之神,坚强的西红柿-白银之手,这是女鬼-白银之手,口空空-迦拉克隆,龍烈-埃德萨拉,咕噜咕噜冒泡-阿古斯,罗生门丶九晚-布兰卡德,萌奶狗-安苏,丶病娇的萝莉-天空之墙";
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
    topNamesOrder = nil
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