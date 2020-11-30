local UIDROPDOWNMENUTEMPLATE = "UIDropDownMenuTemplate"
local FRAME_WIDTH = 116;
local addonName, BG = ...;
_G["BossGuide"] = BG;

WW:Font("BossGuideNormalFontNormal", ChatFontNormal, 13, 1, 0.82, 0):un();
WW:Font("BossGuideNormalFontSpecial", ChatFontNormal, 13, 1, 0.6, 0):un();
WW:Font("BossGuideHighlightFont", ChatFontNormal, 13, 1, 1, 1):un();

local BG_TITLE = "爱不易攻略";
local AUTHOR_PREFIX = "作者: "

BG.data = {
    ["伤逝剧场"] = {
        [1] = { id = 2397, name = "狭路相逢", name2 = "斩首者德茜雅", name3 = "疫毒者巴瑟兰", name4 = "受诅者赛泽尔", text = "3码分散别炸队友，先杀放瘟疫箭的，再杀受诅者，注意驱散", },
        [2] = { id = 2401, name = "斩血", text = "先集合，再躲钩子，小怪死了有毒圈，注意场地分配", },
        [3] = { id = 2390, name = "无堕者哈夫", text = "迅速集火战旗，躲头躲顺劈，坦克注意减伤，会点名俩DPS对战，尽快把一人打到10%", },
        [4] = { id = 2389, name = "库尔萨洛克", text = "近战范围要有人，躲绿圈。点名DOT离开人群，驱散一个加一个。灵魂分离要追上，治疗加好", },
        [5] = { id = 2417, name = "无尽女皇莫德蕾莎", text = "镰刀T减伤，躲射线。出圈时分散6码，炸了打小怪。出裂隙不能被吸进去", },
        author = "哚秘书@NGA",
        id = 1187,
    },
    ["凋魂之殇"] = {
        [1] = { id = 2419, name = "酤团", text = "躲正面，践踏前集合，大软小软远离boss", },
        [2] = { id = 2403, name = "伊库斯博士", text = "小怪拉小岛背后先杀，否则提前触发boss，招啥打啥有啥躲啥", },
        [3] = { id = 2423, name = "多米娜·毒刃", text = "紫圈出人群，被晕队友靠近救，白网踩干净坏人自现形", },
        [4] = { id = 2404, name = "斯特拉达玛侯爵", text = "躲小怪，看方向躲触须，绿圈T来踩，谁亮先躲谁", },
        author = "哚秘书@NGA",
        id = 1183,
    },
    ["塞兹仙林的迷雾"] = {
        { id = 0,    name = "找不同", text = "树桩旁站人显示图案，看有无边框，空心实心，叶子或花，四个树桩会有一个在某项上和其他三个不同，就是真路。唤雾者BOSS召唤小怪也是这个原理", },
        { id = 2400, name = "英格拉·马洛克", text = "先打高的再打矮的", },
        { id = 2402, name = "唤雾者", text = "躲箭头，找不同，远离狐狸打boss", },
        { id = 2405, name = "特雷德奥瓦", text = "暴食护盾必须断，有啥躲啥，连线扯断，别被小怪追上", },
        author = "哚秘书@NGA",
        id = 1184,
    },
    ["彼界"] = {
        [1] = { id = 2408, name = "夺灵者哈卡", text = "红圈分散不传染，哈卡之子放角落击杀，鲜血屏障谁都打，远离鲜血弹幕", },
        [2] = { id = 2409, name = "米尔豪斯·法力风暴", name2 = "米尔菲丝·法力风暴", text = "分散站，拆炸弹，电锯开减伤，点名不要慌", },
        [3] = { id = 2398, name = "商人赛·艾柯莎", text = "有啥躲啥，爆破计谋升天躲，炸弹人自己上去别炸队友", },
        [4] = { id = 2410, name = "穆厄扎拉", text = "抬左手往右走，抬右手往左走，双手扭一扭集体远离往后走，TN进一门，其他分散进，打完分身点柱子", },
        author = "哚秘书@NGA",
        id = 1188,
    },
    ["晋升高塔"] = {
        [1] = { id = 2399, name = "金-塔拉", text = "boss和鸟共血量，别被连线刮刀，打不到boss打鸟，躲好羽毛", },
        [2] = { id = 2416, name = "雯图纳柯丝", text = "桩子放同边，躲好溜溜球", },
        [3] = { id = 2414, name = "奥莱芙莉安", text = "近战躲头前，点圈远离人，群点集合放，别让球碰到boss，坦克盗贼吃", },
        [4] = { id = 2412, name = "德沃丝", text = "躲冲锋，黑球炸前进罩子，转阶段时把所有白球运到中间，上炮打Boss，注意别打偏", },
        author = "哚秘书@NGA",
        id = 1186,
    },
    ["赎罪大厅"] = {
        [1] = { id = 2406, name = "哈尔吉亚斯", text = "出红圈无限被恐，躲好脚下玻璃渣", },
        [2] = { id = 2387, name = "艾谢朗", text = "队友远离黄圈，黄圈框住小怪尸体，否则无限复活", },
        [3] = { id = 2411, name = "高阶裁决官阿丽兹", text = "被追者，请躲边缘柱子后", },
        [4] = { id = 2413, name = "宫务大臣", text = "单线躲石像头前，多线远离boss，挡线防aoe，别吃震射波", },
        author = "哚秘书@NGA",
        id = 1185,
    },
    ["赤红深渊"] = {
        [1] = { id = 2388, name = "贪食的克里克西斯", text = "点名分摊击飞后拉远boss，血稳再吃球", },
        [2] = { id = 2415, name = "执行者塔沃德", text = "先站右后站左，小怪优先击杀，玻璃渣不要踩", },
        [3] = { id = 2421, name = "大学监贝律莉娅", text = "躲红圈，吃金球(一人3个)躲红圈，吃金球，躲红圈……", },
        [4] = { id = 2407, name = "卡尔将军", text = "注意走廊一侧有风，BOSS出水也躲。一人拿盾，DBM提示掩体时开盾", },
        author = "哚秘书@NGA",
        id = 1189,
    },
    ["通灵战潮"] = {
        [1] = { id = 2395, name = "凋骨", text = "人群躲开点名喷吐的方向，出的小虫子迅速击杀否则爆炸", },
        [2] = { id = 2391, name = "阿玛厄斯", text = "打龙→打断法师→嘲讽战士→杀弓箭手 提前分工 杀人再杀龙", },
        [3] = { id = 2392, name = "外科医生缝肉", text = "胖子读钩子，被点名的把钩子箭头指向Boss", },
        [4] = { id = 2396, name = "缚霜者纳尔佐", text = "白圈远离队友再驱散，地上白旋涡一步一步跳秧歌就能躲", },
        id = 1182,
    },
--    ["暗影界"] = {
--        [1] = { id = 2430, name = "瓦里诺，万古之光", text = "TODO", },
--        [2] = { id = 2431, name = "莫塔尼斯", text = "TODO", },
--        [3] = { id = 2432, name = "“长青之枝”奥拉诺莫诺斯", text = "TODO", },
--        [4] = { id = 2433, name = "诺尔伽什·泥躯", text = "TODO", },
--        id = 1192,
--    },
--    ["纳斯利亚堡"] = {
--        [1] = { id = 2393, name = "啸翼", text = "TODO", },
--        [2] = { id = 2429, name = "猎手阿尔迪莫", text = "TODO", },
--        [3] = { id = 2422, name = "太阳之王的救赎", text = "TODO", },
--        [4] = { id = 2418, name = "圣物匠赛·墨克斯", text = "TODO", },
--        [5] = { id = 2428, name = "饥饿的毁灭者", text = "TODO", },
--        [6] = { id = 2420, name = "伊涅瓦·暗脉女勋爵", text = "TODO", },
--        [7] = { id = 2426, name = "猩红议会", text = "TODO", },
--        [8] = { id = 2394, name = "泥拳", text = "TODO", },
--        [9] = { id = 2425, name = "顽石军团干将", text = "TODO", },
--        [10] = { id = 2424, name = "德纳修斯大帝", text = "TODO", },
--        id = 1190,
--    },
}

-- [5] = { id = 2397, name = "值钱的螃蟹", text = "抬左手往右走，抬右手往左走，双手扭一扭集体远离往后走，TN进一门，其他分散进，打完分身点柱子", },
-- GetZoneText = function() return "通灵战潮" end

local SEND_TIP = "\n|cff00d100右键查看手册，Ctrl点击发送|r"

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
            table.insert(info.text, "\n|cffffffff" .. AUTHOR_PREFIX ..v.author .. "|r")
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
    CoreDispatchEvent(BG.frame, BG)
    BG:Enable();
    self.frame:SetPoint("TOP", Minimap, "BOTTOM", 30, -50);
    self.frame:StartMoving();
    self.frame:StopMovingOrSizing();
end

function BG:ADDON_LOADED(event, addon)
    if addon == addonName then
        self.frame:UnregisterEvent("ADDON_LOADED")
        AbyBossGuideDB = AbyBossGuideDB or {}
        local db = AbyBossGuideDB
        BG.db = db
        BG:ToggleMinimum(db.collapse)
        BG:SelectZone(db.lastZone or "凋魂之殇");
    end
end

function BG:PLAYER_ENTERING_WORLD(...)
    local zone = GetZoneText()
    if self.data[zone] then
        if zone ~= BG.db.lastZone then
            BG:ToggleMinimum(false)
            BG:StartFlash()
        end
        self:SelectZone(zone)
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
                zoneSent[v.name] = v
                if v.name2 then zoneSent[v.name2] = v end
                if v.name3 then zoneSent[v.name3] = v end
                if v.name4 then zoneSent[v.name4] = v end
                self.frame.title:SetText(v.name);
                BG:SetButton(self.frame.title, v);
                self.tip:SetBoss(v)
                self:StartFlash(self.tip);
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
    BG.frame:RegisterEvent("ADDON_LOADED");
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
        if button == "CHAT" or IsControlKeyDown() then
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
            if button == "RightButton" then
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
            else
                if BG.tip:IsShown() and BG.tip.info == self.info then
                    BG.tip:Hide()
                else
                    BG.tip:SetBoss(self.info)
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
    BG.db.lastZone = zone
    BG.tip:Hide()
    UIDropDownMenu_SetSelectedValue(self.frame.menu, zone);
    for i, info in ipairs(infos) do
        if not self.lines[i] then
            local btn = WW:Button(nil, self.frame.menuBtn):SetSize(FRAME_WIDTH,20)
            :RegisterForClicks("AnyUp")
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

local flashTimer
function BG:StartFlash(frame)
    CoreUIShowCallOut(frame or self.frame, nil, nil, -8, 8, 8, -8)
    CoreCancelTimer(flashTimer, true)
    flashTimer = CoreScheduleTimer(false, 6.2, function() BG:StopFlash() end)
end

function BG:StopFlash()
    CoreUIHideCallOut();
    CoreCancelTimer(flashTimer, true)
end

function BG:ToggleMinimum(v)
    if v == nil then v = not BG.db.collapse end
    local collapseBtn = BG.frame.collapse;
    local f = BG.frame
    local menuBtn = f.menuBtn;
    CoreUIKeepCorner(f,"TOPRIGHT");
    if menuBtn:IsShown() and v~=false then
        f:SetSize(FRAME_WIDTH-16, 22);
        menuBtn:Hide();
        collapseBtn:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Up]])
        collapseBtn:SetPushedTexture([[Interface\Minimap\UI-Minimap-ZoomInButton-Down]])
    else
        f:SetSize(FRAME_WIDTH, 22 + 20*BG.numLines + (BG.numLines>0 and 5 or 0));
        menuBtn:Show();
        collapseBtn:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Up]])
        collapseBtn:SetNormalTexture([[Interface\Minimap\UI-Minimap-ZoomOutButton-Up]])
    end
    BG.db.collapse = v
end

function BG:CreateUI(name)
    self.lines = {};
    self.numLines = 0;
    local f = WW:Frame(name, UIParent, ABY_BD_TPL):Size(100,22):SetToplevel(true):SetClampedToScreen(true):Backdrop(
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
    :SetScript("OnClick", function(self, button) BG:ToggleMinimum() end)

    local title = f:Button():Key("title"):RIGHT(collapse, "LEFT", 0, 1):SetSize(76,13):SetButtonFont(BossGuideNormalFontSpecial):GetButtonText():SetText(BG_TITLE):SetSize(76,13):up():un();
    CoreUIMakeMovable(title, f())
    CoreUIEnableTooltip(title, "爱不易副本小攻略", "\n选中boss然后按Ctrl点击发送，如需关闭请通过插件中心-副本小攻略");
    title:SetScript("OnClick", bossOnClick);

    self.tip = WW:GameTooltip(addonName .. "Tip", f, "GameTooltipTemplate"):Size(128,64):TOPLEFT(f, "BOTTOMLEFT"):un()
    GameTooltip_OnLoad(self.tip)
    local tipClose = WW:Button(nil, self.tip):Size(32,32):TOPRIGHT(2,2)
    :SetNormalTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Up]])
    :SetPushedTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Down]])
    :SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]], "ADD")
    :SetScript("OnClick", function(self) self:GetParent():Hide() end)
    :un()
    WW:Button(nil, self.tip):Size(20,20):RIGHT(tipClose, "LEFT", -5, 0)
    :SetNormalAtlas("chatframe-button-icon-voicechat")
    :SetPushedAtlas("chatframe-button-icon-voicechat")
    :SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]], "ADD")
    :SetScript("OnClick", function(self) bossOnClick(self:GetParent(), "CHAT")end)
    :un()


    function self.tip:SetBoss(info)
        self.info = info
        local lines = info.text
        if not lines or #lines < 4 then return end
        self:SetOwner(self:GetParent(), "ANCHOR_PRESERVE")
        self:AddLine(lines[1],1,1,1)
        local prefix = "\n|cffffffff" .. AUTHOR_PREFIX
        for i=3, #lines - 1 do
            if lines[i]:sub(1, #prefix) ~= prefix then
                self:AddLine(lines[i],nil,nil,nil,true)
            end
        end
        self:Show()
    end

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




