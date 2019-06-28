local UIDROPDOWNMENUTEMPLATE = "UIDropDownMenuTemplate"
local FRAME_WIDTH = 116;
local _, BG = ...;
_G["BossGuide"] = BG;

WW:Font("BossGuideNormalFontNormal", ChatFontNormal, 13, 1, 0.82, 0):un();
WW:Font("BossGuideNormalFontSpecial", ChatFontNormal, 13, 1, 0.6, 0):un();
WW:Font("BossGuideHighlightFont", ChatFontNormal, 13, 1, 1, 1):un();

local BG_TITLE = "爱不易攻略";
local AUTHOR_PREFIX = "作者: "

BG.data = {
    ["围攻伯拉勒斯"] = {
        { id = 2133, name = "拜恩比吉中士", text = "优先击杀小怪（注意躲近战小怪冲击波）。被追赶的人把boss拉到炸弹上，boss晕了有易伤。千万别让剩下的炸弹爆炸，小怪和玩家都可以踩" },
        { id = 2173, name = "恐怖船长洛克伍德", text = "躲好地上的圈，BOSS上船后出的炮手优先打掉，捡起炮对着船按一下额外技能按钮，BOSS就会下来，循环。" },
        { id = 2134, name = "哈达尔·黑渊", text = "观察潮水方向用雕像掩护（实际伤害不高可以硬吃），千万不要被白圈砸到或踩在冰上，伤害很高。" },
        { id = 2140, name = "维克戈斯", text = "攻城触须会不断刷新，近战范围没人会AOE。在打攻城触须的间隙打攫握触须救工人，工人修大炮，上炮对准BOSS打一下。一共三门炮，建议最后嗜血直接救人开炮。（另有取巧打法，第一门炮修好后不开，远程磨BOSS，适合低保）" },
        { id = 0,    name = "水鼠帮歼灭者", text = "会30码范围群体恐惧，拉到安全位置打小心ADD，可以卡拐角躲恐惧，跟阿塔恐龙BOSS一样" },
        id = 1023,
    },
    ["地渊孢林"] = {
        { id = 2157, name = "长者莉娅克萨", text = "boss前一波小怪先打祭师，Boss会分身，高层大秘需要先杀分身。注意躲头前喷毒", },
        { id = 2131, name = "被感染的岩喉", text = "躲BOSS冲锋，BOSS冲锋后会出虫子，踩地上的虫子，站位分散点别踩重了", },
        { id = 2130, name = "孢子召唤师赞查", text = "T控制boss冲击波清蘑菇，被点名把圈放到蘑菇边上炸，还剩下的就踩吧", },
        { id = 2158, name = "不羁畸变怪", text = "打血肉兽小怪会扣boss的血，孢子躲或者蹭一下清掉，进光圈集合清debuff。（角落木桩打法可能已被修正）", },
        id = 1022,
    },
    ["塞塔里斯神庙"] = {
        { id = 2142, name = "阿德里斯", name2 = "阿斯匹克斯", text = "俩Boss会轮流开反伤盾，看好了打另一个，近战BOSS的电弧冲刺会在玩家脚下出白箭头形成折线，躲开这个路径就无伤。高层灭点，会了就不难", },
        { id = 2143, name = "米利克萨", text = "boss前的小怪互相治疗，千万别add，及时救被缠绕的（晕技秒解，也可集合猎人放冰冻陷阱），转身躲致盲", },
        { id = 2144, name = "加瓦兹特", text = "地上先出白圈然后出柱子，提前看好方向，每个人完整的挡一根，别管DBM层数高的提示，挡完等消了再挡，分配好的话肯定没问题", },
        { id = 2145, name = "塞塔里斯的化身", text = "清光一轮小怪后给boss加血，0% 40% 70%三轮，地上闪电圈一定要躲", },
        id = 1030,
    },
    ["奥迪尔"] = {
        { id = 2168, name = "塔罗克", text = "TODO", },
        { id = 2167, name = "纯净圣母", text = "TODO", },
        { id = 2146, name = "腐臭吞噬者", text = "TODO", },
        { id = 2169, name = "泽克沃兹，恩佐斯的传令官", text = "TODO", },
        { id = 2166, name = "维克提斯", text = "TODO", },
        { id = 2195, name = "重生者祖尔", text = "TODO", },
        { id = 2194, name = "拆解者米斯拉克斯", text = "TODO", },
        { id = 2147, name = "戈霍恩", text = "TODO", },
        id = 1031,
        hide = true,
    },
    ["托尔达戈"] = {
        { id = 2097, name = "泥沙女王", text = "躲开流沙陷阱，BOSS钻地后顶飞一个人，好像没法躲", },
        { id = 2098, name = "杰斯·豪里斯", text = "卡视角躲闪光飞刃，P2开爆发追着BOSS杀，小怪看情况，难度较高", },
        { id = 2099, name = "骑士队长瓦莱莉", text = "把桶搬到一侧，爆炸时躲到安全区", },
        { id = 2096, name = "科古斯狱长", text = "移动会加能量槽，满了就晕很久。360度冲击波躲开黑线。红箭头狙击只能抗一次，第二次别人挡。看好大炮方向，躲", },
        id = 1002,
    },
    ["暴富矿区！！"] = {
        { id = 2109, name = "投币式群体打击者", text = "站在炸弹旁调整方向踢到boss上，boss中炸弹后有易伤，T拉boss躲钱堆离开20码就够", },
        { id = 2114, name = "艾泽洛克", text = "先杀小怪，BOSS拉离人群，被点名的跑", },
        { id = 2115, name = "瑞克莎·流火", text = "躲黄水，躲吹风，吹风会吹动黄水，治疗注意驱散", },
        { id = 2116, name = "商业大亨拉兹敦克", text = "弹幕是两个轰炸机放的，可以提前观察。中导弹的跑远，圈很大。boss上天后要引到柱子上方，砸3次，小怪抽空打", },
        id = 1012,
    },
    ["维克雷斯庄园"] = {
        { id = 2125, name = "女巫布里亚", name2 = "女巫马拉迪", name3 = "女巫索林娜", text = "治疗压力大，打变大的那个，打被控制的队友", },
        { id = 2126, name = "魂缚巨像", text = "T看好boss层数，七八层就可以拉到火上消（有AOE，高层压力大），被捆的尽快救", },
        { id = 2127, name = "贪食的拉尔", text = "躲喷吐，不要让召唤的仆从走到BOSS", },
        { id = 2128, name = "维克雷斯勋爵", text = "中毒的躲开人群，勋爵三管血，一直打死再打女鬼", },
        { id = 2129, name = "高莱克·图尔", text = "先打小怪，然后捡瓶子烧尸体，不然boss会复活它们", },
        id = 1021,
    },
    ["自由镇"] = {
        { id = 2102, name = "天空上尉库拉格", text = "躲冲锋，比较简单", },
        { id = 2093, name = "海盗议会", text = "地图上有黄点任务，完成可少打一个BOSS，每周不同，BOSS战重点躲葡萄弹、打酒桶、躲风躲圈", },
        { id = 2094, name = "藏宝竞技场", text = "5人中间围一圈狂点可秒抓猪。鲨鱼追最近的人非常疼，引到血上可以减速，高层容易减员", },
        { id = 2095, name = "哈兰·斯威提", text = "BOSS前一组小怪会击飞，可以跳过不打，直接在角上打BOSS，放好火，注意召唤的炸弹人", },
        id = 1001,
    },
    ["艾泽拉斯"] = {
        { id = 2139, name = "提赞", text = "TODO", },
        { id = 2141, name = "基阿拉克", text = "TODO", },
        { id = 2197, name = "冰雹构造体", text = "TODO", },
        { id = 2212, name = "雄狮之吼", text = "TODO", },
        { id = 2199, name = "蔚索斯，飞翼台风", text = "TODO", },
        { id = 2198, name = "战争使者耶纳基兹", text = "TODO", },
        { id = 2210, name = "食沙者克劳洛克", text = "TODO", },
        id = 1028,
        hide = true,
    },
    ["诸王之眠"] = {
        { id = 2165, name = "黄金风蛇", text = "金水会生小怪，远离boss集中放水，可控可杀，不能让BOSS碰到，近战多了比较难", },
        { id = 2171, name = "殓尸者姆沁巴", text = "被埋葬了按1晃棺材，其他人仔细观察尽快救人，火圈范围大而且伤害高，注意躲", },
        { id = 2170, name = "智者扎纳扎尔", name2 = "屠夫库拉", name3 = "征服者阿卡阿里", text = "部族议会，依次打3个boss，翻滚需要直线分担，追T的时候必须风筝，四个图腾先打爆炸", },
        { id = 2172, name = "始皇达萨", text = "BOSS冲锋的人跑远点别炸到其他人，地上的圈随便躲躲", },
        id = 1041,
    },
    ["阿塔达萨"] = {
        { id = 2082, name = "女祭司阿伦扎", text = "在BOSS吸血前进水让boss吸毒血，理想情况下5根红线", },
        { id = 2036, name = "沃卡尔", text = "必须同时打掉3个图腾，然后拉着BOSS在外围慢慢移动打", },
        { id = 2083, name = "莱赞", text = "卡视角躲恐惧，地上紫圈踩到就出小怪，也不要让boss踩到", },
        { id = 2030, name = "亚兹玛", text = "碰到紫蜘蛛会出紫水很疼，头上出标记的时候远离boss集中站，标记结束出小蜘蛛，尽快击杀不要让它们碰到boss。高层很难，可灵性走位或规划性踩水", },
        id = 968,
    },
    ["风暴神殿"] = {
        { id = 2153, name = "阿库希尔", text = "BOSS会冲锋，会分裂，分裂了还会冲锋，别被冲到，分裂后先打楼梯那边的小怪", },
        { id = 2154, name = "唤风者菲伊", name2 = "铁舟修士", text = "远程BOSS读条会给全队叠层，但打断会出风。绿色符文可以消层数。近战BOSS变大会变慢需要风筝，白色符文会移除减速效果。根据团队选择打法，是此副本最难的BOSS", },
        { id = 2155, name = "斯托颂勋爵", text = "被控制的人撞黑球，撞完没解控就打出来，解除控制就别再撞了。其他人包括T都要躲球，没难度", },
        { id = 2156, name = "低语者沃尔兹斯", text = "外场阶段拉boss放好水，不要让小怪摸到boss（BOSS满能量转阶段小怪就消失），内场阶段3个dps依次杀两只水母，必须分配好打断；T和奶面对一只大怪，风筝别硬抗", },
        { id = 0,    name = "神殿骑士", text = "有周围小怪减伤75%的光环，首先击杀", },
        id = 1036,
    },
}

local SEND_TIP = "\n|cff00d100点击查看手册，Ctrl点击发送|r"

for k, v in pairs(BG.data) do if v.hide then BG.data[k] = nil end end
local replaceSpellLink = function(s) local link = GetSpellLink(s) return link == "" and '[未知法术]' or link end
for k, v in pairs(BG.data) do
    for i, info in ipairs(v) do
        if(type(info.text)=="string") then
            info.text = {info.name, " ", info.text}
        else
            table.insert(info.text, 1, " ");
            table.insert(info.text, 1, info.name);
        end
        if info.id == 0 then info.text[1] = "小怪："..info.text[1]; end
        for jj, line in ipairs(info.text) do info.text[jj] = line:gsub('%[spell:([0-9]+)%]', replaceSpellLink) end
        if(v.author) then
            table.insert(info.text, " ")
            table.insert(info.text, "|cffffffff" .. AUTHOR_PREFIX ..v.author .. "|r")
        end
        table.insert(info.text, SEND_TIP)
    end
end

BG.menus = {}

local function selectZone(self, arg1, arg2, checked)
    BG.frame.title:SetText(BG_TITLE);
    BG:SelectZone(arg1);
end

for k, v in pairs(BG.data) do
    table.insert(BG.menus, {text=k, value=k, arg1=k, func=selectZone, });
    table.sort(BG.menus, function(a,b)
        a = BG.data[a.value]
        b = BG.data[b.value]
        if not a.id or not b.id then
            return not b.id
        else
            return a.id > b.id
        end
    end)
end

function BG:Initialize()
    BG:CreateUI("BossGuideFrame");
    BG.ToggleMinimum(nil, true);
    CoreDispatchEvent(BG.frame, BG)
    BG:Enable();
    BG:SelectZone("风暴神殿");
    self.frame:SetPoint("TOP", Minimap, "BOTTOM", 30, -50);
    self.frame:StartMoving();
    self.frame:StopMovingOrSizing();
end

function BG:PLAYER_ENTERING_WORLD(...)
    if self.data[GetZoneText()] then
        --BG:StartFlash();
        self:SelectZone(GetZoneText())
    end
end

local autoSent = {}
function BG:CheckUnit(unit)
    local zone = GetZoneText();
    if zone and self.data[zone] and not UnitPlayerControlled(unit) and UnitHealth(unit) > 0 then
        local zoneSent = autoSent[zone] or {};
        autoSent[zone] = zoneSent;
        -- 当前选中目标的话，忽略鼠标指向
        if unit == "mouseover" and not UnitPlayerControlled("target") and UnitHealth("target") > 0 and type(zoneSent[UnitName("target")]) == 'table' then return end
        local name = UnitName(unit);
        local nameData = zoneSent[name]
        if nameData == true then
            return
        elseif nameData then
            self.frame.title:SetText(nameData.name);
            BG:SetButton(self.frame.title, nameData);
            return
        end
        zoneSent[name] = true
        for k, v in ipairs(self.data[zone]) do
            if(v.name==name or v.name2==name or v.name3==name or v.name4==name) then
                self:StartFlash();
                zoneSent[v.name] = v
                if v.name2 then zoneSent[v.name2] = v end
                if v.name3 then zoneSent[v.name3] = v end
                if v.name4 then zoneSent[v.name4] = v end
                self.frame.title:SetText(v.name);
                BG:SetButton(self.frame.title, v);
                return;
            end
        end
    end
end

---恢复名字
function BG:PLAYER_REGEN_ENABLED(event)
    self.frame.title:SetText(BG_TITLE);
end

BG.ZONE_CHANGED_INDOORS = BG.PLAYER_ENTERING_WORLD
BG.ZONE_CHANGED_NEW_AREA = BG.PLAYER_ENTERING_WORLD
BG.ZONE_CHANGED = BG.PLAYER_ENTERING_WORLD
BG.UNIT_TARGET = function(self, event, unit) if unit == "player" then BG:CheckUnit("target") end end
BG.UPDATE_MOUSEOVER_UNIT = function() BG:CheckUnit("mouseover") end

function BG:Enable()
    BG.frame:Show();
    BG.frame:RegisterEvent("ZONE_CHANGED");
    BG.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    BG.frame:RegisterEvent("ZONE_CHANGED_INDOORS");
    BG.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
    BG.frame:RegisterEvent("UNIT_TARGET");
    BG.frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
    BG.frame:RegisterEvent("PLAYER_REGEN_ENABLED");
end

function BG:Disable()
    BG.frame:UnregisterAllEvents();
    BG.frame:Hide();
end

local function sendChat(message)
    local channel = 'SAY'
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        channel = "INSTANCE_CHAT"
    elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
        channel = IsInRaid() and 'RAID' or 'PARTY'
    end
    SendChatMessage(message, channel)
end

local function bossOnClick(self, button)
    --local button = DBM_GUI_OptionsFrameBossModsButton1 button.element.showsub = false; DBM_GUI_OptionsFrame:ToggleSubCategories(button.toggle)
    if self.info then
        local zone = UIDropDownMenu_GetSelectedValue(BG.frame.menu)
        if(IsControlKeyDown())then
            if(self.info.bosslink == nil) then
                local id = BG.data[zone] and BG.data[zone].id
                if(id) then
                    EJ_SelectInstance(id)
                    local i = 1
                    while(true) do
                        local name, desc, bossid, _, link = EJ_GetEncounterInfoByIndex(i)
                        if(not name) then
                            break
                        end
                        if(bossid == self.info.id) then
                            self.info.bosslink = link
                        end
                        i = i + 1
                    end
                end
            end

            local lineNo = 0
            for i=3, #self.info.text-1 do
                local text = self.info.text[i];
                if i==3 then
                    local header = "爱不易攻略"..(self.info.bosslink or "["..self.info.name.."]")..":";
                    if #header + #text > 254 then
                        sendChat("爱不易"..header)
                    else
                        text = header..text;
                    end
                end
                if text and #text:trim() > 0 and not text:find(AUTHOR_PREFIX) then
                    lineNo = lineNo + 1
                    if lineNo > 1 then text = "["..lineNo.."] "..text end
                    sendChat(text)
                end
            end
        else
            --local ids = BG.IDS[zone] print(ids.id, ids[self.info.name])
            if BG.data[zone].id then
                if self.info.id == 0 then return end --小怪就不显示副本手册了
                if not EncounterJournal or not EncounterJournal:IsShown() then
                    ToggleEncounterJournal();
                end
                EncounterJournal_ListInstances();
                EncounterJournal_DisplayInstance(BG.data[zone].id);
                if self.info.id then
                    EncounterJournal_DisplayEncounter(self.info.id)
                    -- if EJ_InstanceIsRaid() then EJ_SetDifficulty(5); else EJ_SetDifficulty(2); end
                end
            end
        end
    end
end

function BG:SetButton(button, info)
    button.info = info;
    button.tooltipLines = info.text;
end

function BG:SelectZone(zone)
    local infos = BG.data[zone];
    if not infos then return end
    UIDropDownMenu_SetSelectedValue(self.frame.menu, zone);
    for i, info in ipairs(infos) do
        if not self.lines[i] then
            local btn = WW:Button(nil, self.frame.menuBtn):SetSize(FRAME_WIDTH,20)
            :SetButtonFont(BossGuideNormalFontNormal)
            :SetHighlightFontObject(BossGuideHighlightFont)
            :SetText(" ");

            if(i==1) then
                btn:TL(self.frame.menuBtn, "BOTTOMLEFT")
            else
                btn:TL(self.lines[i-1], "BOTTOMLEFT");
            end

            CoreUIMakeMovable(btn, self.frame);
            CoreUIEnableTooltip(btn);
            btn:SetScript("OnClick", bossOnClick)
            btn:GetButtonText():SetSize(FRAME_WIDTH-8,13);
            self.lines[i] = btn:un();
        end
        self.lines[i]:Show();
        BG:SetButton(self.lines[i], info);
        self.lines[i]:SetText(info.id == 0 and '|cffaaaaaa'..info.name..'|r' or info.name);
    end
    self.numLines = #infos
    if self.frame.menuBtn:IsShown() then
        CoreUIKeepCorner(self.frame,"TOPLEFT");
        self.frame:SetSize(FRAME_WIDTH, 22 + 20*BG.numLines + (BG.numLines>0 and 5 or 0));
    end

    for i = #infos + 1, #self.lines do
        self.lines[i]:Hide();
    end
end

function BG:StartFlash()
    CoreUIShowCallOut(self.frame, nil, nil, -8, 8, 8, -8)
end

function BG:StopFlash()
    CoreUIHideCallOut();
end

function BG.ToggleMinimum(self, v)
    self = self or BG.frame.collapse;
    local f = BG.frame
    local menuBtn = f.menuBtn;
    CoreUIKeepCorner(f,"TOPRIGHT");
    if menuBtn:IsShown() and v~=false then
        f:SetSize(FRAME_WIDTH-16, 22);
        menuBtn:Hide();
        self:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Up]])
        self:SetPushedTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Down]])
    else
        f:SetSize(FRAME_WIDTH, 22 + 20*BG.numLines + (BG.numLines>0 and 5 or 0));
        menuBtn:Show();
        self:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Up]])
        self:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Up]])
    end
end

function BG:CreateUI(name)
    self.lines = {};
    self.numLines = 0;
    local f = WW:Frame(name, UIParent):Size(100,22):SetToplevel(true):SetClampedToScreen(true):Backdrop(
        [[Interface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-BACKGROUND]],
        [[Interface\Tooltips\UI-Tooltip-Border]], 8, 2)
    CoreUIMakeMovable(f);
    f:SetScript("OnEnter", function()
        BG:StopFlash();
    end)

    local menu = f:Frame("$parentMenu", UIDROPDOWNMENUTEMPLATE, "menu"):un();
    local menuBtn = f:Button():Key("menuBtn"):SetSize(22,22):TL(1,0)
    :SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Up")
    :SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Down")
    :SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
    :SetScript("OnClick", function(self, button)
        for _, v in ipairs(BG.menus) do v.checked = nil end --必须手工清除清除，BG.menus以已被修改
        EasyMenu(BG.menus, menu, self, 0, 0, "MENU", 2);
    end)

    local collapse = f:Button():Key("collapse"):TR(-3,-3):Size(16)
    :SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
    :SetScript("OnClick", BG.ToggleMinimum)

    local title = f:Button():Key("title"):RIGHT(collapse, "LEFT", 0, 1):SetSize(76,13):SetButtonFont(BossGuideNormalFontSpecial):GetButtonText():SetText(BG_TITLE):SetSize(76,13):up():un();
    CoreUIMakeMovable(title, f())
    CoreUIEnableTooltip(title, "爱不易副本小攻略", "\n选中boss然后按Ctrl点击发送，如需关闭请通过插件中心-副本小攻略");
    title:SetScript("OnClick", bossOnClick);

    self.frame = f:un();
end

BG:Initialize()
--WWRun(function(name) BG:CreateUI(name) end, "BossGuideFrame");

--[=[
--获取副本ID和BOSSID

local zones = {}

for i=1, 100 do
  local instanceId,zname, _, _, _, _, zid = EJ_GetInstanceByIndex(i,true)
  if instanceId then zones[instanceId] = zname else break end
end

for i=1, 100 do
  local instanceId,zname, _, _, _, _, zid = EJ_GetInstanceByIndex(i,false)
  if instanceId then zones[instanceId] = zname else break end
end

U1DBTEMP = {}
for instanceId, loc_zname in pairs(zones) do
  local map = {}
  U1DBTEMP[loc_zname] = map
  map.id = instanceId
  EJ_SelectInstance(instanceId)
  for i=1, 100 do
    local name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(i);
    if not name then break end
    map[name] = bossID
  end
end

---直接生成BossGuide数据框架
for instanceId, loc_zname in pairs(zones) do
  local map = {}
  U1DBTEMP[loc_zname] = map
  map.id = instanceId
  EJ_SelectInstance(instanceId)
  for i=1, 100 do
    local name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(i);
    if not name then break end
    tinsert(map, {id = bossID, name = name, text = 'TODO'})
  end
end

/save U1DBTEMP

--]=]




