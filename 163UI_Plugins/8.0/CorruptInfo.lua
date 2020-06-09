local LOCALES = {
    PATTERN_INFO = "Level%d %s",
    UNKNOWN = "Special",
    special = "Special",

    passive_crit_dam = "CritDam",
    passive_mastery = "MasteryB",
    passive_haste = "HasteB",
    passive_versatility = "VersatB",
    passive_crit = "CritB",
    passive_avoidance = "Avoid",
    passive_leech = "Leech",

    proc_haste = "HasteA",
    proc_crit = "CritA",
    proc_mastery = "MasteryA",
    proc_versatility = "VersatA",

    twilight = "Twinlight",
    ritual = "Ritual",
    twisted = "Twisted",
    clarity = "Clarity",
    truth = "Truth",
    echo = "Echo",
    star = "Star",
    bleed = "Bleed",
}

if GetLocale():sub(1,2) == "zh" then
    LOCALES = {
        PATTERN_INFO = "%d级%s",
        UNKNOWN = "其他或专有",
        special = "专有",

        passive_crit_dam = "爆伤",
        passive_mastery = "渠精",
        passive_haste = "渠急",
        passive_versatility = "渠全",
        passive_crit = "渠暴",
        passive_avoidance = "闪避",
        passive_leech = "吸血",

        proc_haste = "急速",
        proc_crit = "暴击",
        proc_mastery = "精通",
        proc_versatility = "全能",

        twilight = "暮光",
        ritual = "仪式",
        twisted = "触须",
        clarity = "洞察",
        truth = "真相",
        echo = "回响",
        star = "无尽",
        bleed = "龟裂",
    }
end

local data = {
  affixes = {
    [6437] = { key = "passive_crit_dam", level = 1, },
    [6438] = { key = "passive_crit_dam", level = 2, },
    [6439] = { key = "passive_crit_dam", level = 3, },
    [6471] = { key = "passive_mastery", level = 1, },
    [6472] = { key = "passive_mastery", level = 2, },
    [6473] = { key = "passive_mastery", level = 3, },
    [6474] = { key = "passive_haste", level = 1, },
    [6475] = { key = "passive_haste", level = 2, },
    [6476] = { key = "passive_haste", level = 3, },
    [6477] = { key = "passive_versatility", level = 1, },
    [6478] = { key = "passive_versatility", level = 2, },
    [6479] = { key = "passive_versatility", level = 3, },
    [6480] = { key = "passive_crit", level = 1, },
    [6481] = { key = "passive_crit", level = 2, },
    [6482] = { key = "passive_crit", level = 3, },
    [6483] = { key = "passive_avoidance", level = 1, },
    [6484] = { key = "passive_avoidance", level = 2, },
    [6485] = { key = "passive_avoidance", level = 3, },
    [6493] = { key = "passive_leech", level = 1, },
    [6494] = { key = "passive_leech", level = 2, },
    [6495] = { key = "passive_leech", level = 3, },
    [6537] = { key = "twilight", level = 1, },
    [6538] = { key = "twilight", level = 2, },
    [6539] = { key = "twilight", level = 3, },
    [6540] = { key = "ritual", level = 1, },
    [6541] = { key = "ritual", level = 2, },
    [6542] = { key = "ritual", level = 3, },
    [6543] = { key = "twisted", level = 1, },
    [6544] = { key = "twisted", level = 2, },
    [6545] = { key = "twisted", level = 3, },
    [6546] = { key = "clarity", level = 1, },
    [6547] = { key = "truth", level = 1, },
    [6548] = { key = "truth", level = 2, },
    [6549] = { key = "echo", level = 1, },
    [6550] = { key = "echo", level = 2, },
    [6551] = { key = "echo", level = 3, },
    [6552] = { key = "star", level = 1, },
    [6553] = { key = "star", level = 2, },
    [6554] = { key = "star", level = 3, },
    [6555] = { key = "proc_haste", level = 1, },
    [6556] = { key = "proc_crit", level = 1, },
    [6557] = { key = "proc_mastery", level = 1, },
    [6558] = { key = "proc_versatility", level = 1, },
    [6559] = { key = "proc_haste", level = 2, },
    [6560] = { key = "proc_haste", level = 3, },
    [6561] = { key = "proc_crit", level = 2, },
    [6562] = { key = "proc_crit", level = 3, },
    [6563] = { key = "proc_mastery", level = 2, },
    [6564] = { key = "proc_mastery", level = 3, },
    [6565] = { key = "proc_versatility", level = 2, },
    [6566] = { key = "proc_versatility", level = 3, },
    [6573] = { key = "bleed", level = 1, },
  },
  corrupts = {
    bleed = { 15, },
    clarity = { 15, },
    echo = { 25, 35, 60, },
    passive_avoidance = { 10, 15, 20, },
    passive_crit = { 10, 15, 20, },
    passive_crit_dam = { 10, 15, 20, },
    passive_haste = { 10, 15, 20, },
    passive_leech = { 10, 15, 20, },
    passive_mastery = { 10, 15, 20, },
    passive_versatility = { 10, 15, 20, },
    proc_crit = { 15, 20, 35, },
    proc_haste = { 15, 20, 35, },
    proc_mastery = { 15, 20, 35, },
    proc_versatility = { 15, 20, 35, },
    ritual = { 15, 35, 66, },
    star = { 20, 50, 75, },
    truth = { 12, 30, },
    twilight = { 25, 50, 75, },
    twisted = { 10, 35, 66, },
  },
  vendors = {
      bleed = { 177977, },
      clarity = { 177976, },
      echo = { 177967, 177968, 177969, },
      passive_avoidance = { 177970, 177971, 177972, },
      passive_crit = { 177992, 177993, 177994, },
      passive_crit_dam = { 177998, 177999, 178000, },
      passive_haste = { 177973, 177974, 177975, },
      passive_leech = { 177995, 177996, 177997, },
      passive_mastery = { 177986, 177987, 177988, },
      passive_versatility = { 178010, 178011, 178012, },
      proc_crit = { 177955, 177965, 177966, },
      proc_haste = { 177989, 177990, 177991, },
      proc_mastery = { 177978, 177979, 177980, },
      proc_versatility = { 178001, 178002, 178003, },
      ritual = { 178013, 178014, 178015, },
      star = { 177983, 177984, 177985, },
      truth = { 177981, 177982, },
      twilight = { 178004, 178005, 178006, },
      twisted = { 178007, 178008, 178009, },
  },
  items = {},
}

for key, v in pairs(data.vendors) do
    for lvl, id in ipairs(v) do
        data.items[tostring(id)] = { key, lvl }
    end
end

-- 修正闪避
data.corrupts.passive_avoidance = { 8, 12, 16 } --8% 12% 16%
data.corrupts.passive_leech = { 17, 28, 45 } --3% 5% 8%
for _,v in pairs(data.affixes) do v.corrupt = data.corrupts[v.key][v.level] end

local icons = {
  bleed = "Interface/Icons/Ability_IronMaidens_CorruptedBlood",
  clarity = "Interface/Icons/ability_warlock_soulswap",
  echo = "Interface/Icons/Ability_Priest_VoidEntropy",
  passive_avoidance = "Interface/Icons/spell_warlock_demonsoul",
  passive_crit = "Interface/Icons/Ability_Priest_ShadowyApparition",
  passive_crit_dam = "Interface/Icons/Achievement_Profession_Fishing_FindFish",
  passive_haste = "Interface/Icons/Ability_Mage_NetherWindPresence",
  passive_leech = "Interface/Icons/Spell_Shadow_LifeDrain02_purple",
  passive_mastery = "Interface/Icons/Ability_Rogue_SinisterCalling",
  passive_versatility = "Interface/Icons/Spell_Arcane_ArcaneTactics",
  proc_crit = "Interface/Icons/Ability_Hunter_RaptorStrike",
  proc_haste = "Interface/Icons/Ability_Warrior_BloodFrenzy",
  proc_mastery = "Interface/Icons/Spell_Nature_FocusedMind",
  proc_versatility = "Interface/Icons/Ability_Hunter_OneWithNature",
  ritual = "Interface/Icons/Spell_Shadow_Shadesofdarkness",
  star = "Interface/Icons/Ability_Druid_Starfall",
  truth = "Interface/Icons/INV_Wand_1H_NzothRaid_D_01",
  twilight = "Interface/Icons/Spell_Priest_VoidSear",
  twisted = "Interface/Icons/Achievement_Boss_YoggSaron_01",
  special = "INterface\\Icons\\INV_Misc_QuestionMark",
}

--[[
local function fake_item(diff, affix)
  local diffs = { "", "", "4822:1487", "", "4823:1502", "4824:1517" }
  return format("\124cffa335ee\124Hitem:174170::::::::120:65::%d:3:%s:%d:::\124h[龙骨护臂]\124h\124r", diff, diffs[diff], affix)
end

local affixes = {
  passive_crit_dam = { 6437 },
  passive_mastery = { 6471 },
  passive_haste = { 6474, },
  passive_versatility = { 6477 },
  passive_crit = { 6480 },
  passive_avoidance = { 6483 },
  passive_leech = { 6493 },

  proc_haste = { 6555, 6559, 6560 },
  proc_crit = { 6556, 6561, 6562 },
  proc_mastery = { 6557, 6563, 6564, },
  proc_versatility = { 6558, 6565, 6566 },

  twilight = { 6537, 6538, 6539 },
  ritual = { 6540, 6541, 6542 },
  twisted = { 6543, 6544, 6545, },
  clarity = { 6546, },
  truth = { 6547, 6548 },
  echo = { 6549, 6550, 6551, },
  star = { 6552, 6553, 6554, },
  bleed = { 6573 },
}
local reverse, corruptions = {}, {}
local tmp = {}
for k,v in pairs(affixes) do
  local passive = k:sub(1,8) == "passive_"
  if passive then
    for i=1,2 do tinsert(v, v[1]+i) end
  end
  corruptions[k] = {}
  for i, id in ipairs(v) do
    reverse[id] = { key=k, level=i }
    if passive then
      reverse[id].corrupt = i==1 and 10 or i==2 and 15 or i==3 and 20
    else
      local link = fake_item(3, id)
      GetItemStats(link, tmp)
      reverse[id].corrupt = tmp.ITEM_MOD_CORRUPTION
    end
    tinsert(corruptions[k], reverse[id].corrupt)
    reverse[id].corrupt = nil
  end
end
wowluacopy({ affixes = reverse, corrupts = corruptions})
--]]

function U1GetCorruptionInfo(itemString)
  if type(itemString)~="string" then return end
  if not IsCorruptedItem(itemString) then return end
  local itemString = itemString:match("item[%-?%d:]+") or ""-- Standardize itemlink to itemstring
  local num, affixes = select(14, strsplit(":", itemString, 15))
  num = tonumber(num) or 0
  if num == 0 then return end
  affixes = { strsplit(":", affixes, num + 1) }
  for i=1, num do
    local info = data.affixes[tonumber(affixes[i])]
    if info then return LOCALES[info.key], info.corrupt, info.level, info.key, data.corrupts[info.key] end
  end
  return LOCALES.UNKNOWN, GetItemStats(itemString).ITEM_MOD_CORRUPTION
end

local wipe, strrep = wipe, strrep
local slots = { Waist=6, Legs=7, Feet=8, Wrist=9, Hands=10, Finger0=11, Finger1=12, MainHand=16, SecondaryHand=17, }
local tmpInfo = {}
local tmpKeys = {}
function U1GetAllCorruptionText(slotLinks)
    wipe(tmpInfo)
    local count_all, count_corrupted = 0, 0
    for _, slot in pairs(slots) do
        local link = slotLinks[slot]
        if link then
            count_all = count_all + 1
            local name, corrupt, level, key = U1GetCorruptionInfo(link)
            if name then
                count_corrupted = count_corrupted + 1
                key = key or "special"
                level = level or 1
                tmpInfo[key] = (tmpInfo[key] or 0) + (level == 1 and 1 or level == 2 and 100 or level == 3 and 10000 or 1000000)
            end
        end
    end

    wipe(tmpKeys)
    for k, _ in pairs(tmpInfo) do tmpKeys[#tmpKeys+1] = k end
    if #tmpKeys == 0 then return "" end
    table.sort(tmpKeys)

    local color = "|cff946cd0" --"|cffA377E4"
    local text = ""
    for _, key in ipairs(tmpKeys) do
        local info = tmpInfo[key]
        local lv1 = info % 100; info = math.floor(info / 100)
        local lv2 = info % 100; info = math.floor(info / 100)
        local lv3 = info % 100;
        local line = format("\124T%s:11\124t ", icons[key] or icons.special) .. (LOCALES[key] or LOCALES.UNKNOWN)

        local total
        if key:sub(1, #"passive_") == "passive_" then
            -- 渠精 34% (3+3+3+2+2+1)
            if key == "passive_crit_dam" then
                total = (2 * lv1 + 3 * lv2 + 4 * lv3) .. "%"
            elseif key == "passive_avoidance" then
                total = (8 * lv1 + 12 * lv2 + 16 * lv3) .. "%"
            elseif key == "passive_leech" then
                total = (3 * lv1 + 5 * lv2 + 8 * lv3) .. "%"
            else
                total = (6 * lv1 + 9 * lv2 + 12 * lv3) .. "%"
            end
        elseif key == "bleed" or key == "twilight" or key == "clarity" or key == "star" or key == "twisted" or key == "echo" then
            total = (1 * lv1 + 2 * lv2 + 3 * lv3) .. "级"
        elseif key == "truth" then
            total = (30 * lv1 + 50 * lv2) .. "%"
        elseif key == "ritual" then
            total = "" .. (14 * lv1 + 33 * lv2 + 63 * lv3)
        elseif key == "proc_haste" then
            total = "" .. (546 * lv1 + 728 * lv2 + 1275 * lv3)
        elseif key == "proc_crit" then
            total = "" .. (31 * lv1 + 41 * lv2 + 72 * lv3)
        elseif key == "proc_mastery" then
            total = "" .. (392 * lv1 + 523 * lv2 + 915 * lv3)
        elseif key == "proc_versatility" then
            total = "" .. (343 * lv1 + 458 * lv2 + 801 * lv3)
        end
        if total then line = line .. " |r|c0000ff00" .. total .. "|r" .. color end

        line = line .. " (" ..  strrep("3+", lv3 or 0) .. strrep("2+", lv2 or 0) .. strrep("1+", lv1 or 0)
        line = line:sub(1, -2) .. ")"

        text = (#text > 0 and text .."\n" or "") .. line
    end

    return color .. text .. "|r", count_all, count_corrupted
end

local pattern1 = "^"..ITEM_CORRUPTION_BONUS_STAT:gsub("%+%%d", "%%+[0-9]+").."$" --"+%d 腐蚀"
local pattern2 = "^\124cFFB686FF%d+[ ]*" .. ITEM_MOD_CORRUPTION .. "\124r$"
local hookTooltipSetItem = function(self, link)
    link = select(2, self:GetItem())
    local name, corrupt, level, key, levels
    local _, _, itemID = link:find("\124Hitem:([0-9]+):")
    if itemID and data.items[itemID] then
        key, level = unpack(data.items[itemID])
        levels = data.corrupts[key]
        name, corrupt = LOCALES[key], levels[level]
    else
        name, corrupt, level, key, levels = U1GetCorruptionInfo(link)
    end
    if name then
        local tooltipName = self:GetName()
        for i = 2, 20 do
            local left = _G[tooltipName .. "TextLeft" .. i]:GetText()
            if left and (left:match(pattern1) or left:match(pattern2)) then
                local right = _G[tooltipName .. "TextRight" .. i]
                local text = ""
                if not level then
                    text = name
                else
                    text = format(LOCALES.PATTERN_INFO, level, name)
                    text = text .. "("
                    for j = 1, #levels do
                        if j > 1 then text = text .. "/" end
                        if j == level then text = text .. "|cff00ff00" .. levels[j] .. "|r" else text = text .. levels[j] end
                    end
                    text = text .. ")"
                end
                right:SetText(text)
                right:SetTextColor(0.5843, 0.42745, 0.8196)
                right:Show()
                break
            end
        end
    end
end
SetOrHookScript(GameTooltip, "OnTooltipSetItem", hookTooltipSetItem)
SetOrHookScript(ItemRefTooltip, "OnTooltipSetItem", hookTooltipSetItem)

--[[------------------------------------------------------------
兑换信息
---------------------------------------------------------------]]
local success, CharIcon = pcall(function() return CharacterStatsPane.ItemLevelFrame.Corruption end)
if success and GetCVar("portal") == "CN" then
    local prices = { [8] = 2400, [10] = 3000, [12] = 3300, [15] = 4125, [16] = 4250, [17] = 4250, [20] = 5000, [25] = 6250, [28] = 6300, [30] = 6750, [35] = 7875, [45] = 9000, [50] = 10000, [66] = 13200, [75] = 15000, }
    local vendors = {
        { { "truth", 1, }, { "proc_mastery", 1, }, { "passive_crit_dam", 2, }, { "passive_mastery", 2, }, { "passive_haste", 3, }, { "twisted", 3, }, },
        { { "passive_mastery", 1, }, { "ritual", 1, }, { "proc_crit", 2, }, { "passive_leech", 2, }, { "truth", 2, }, { "passive_versatility", 3, }, { "passive_avoidance", 2, }, },
        { { "star", 1, }, { "proc_versatility", 1, }, { "clarity", 1, }, { "passive_crit", 2, }, { "proc_haste", 3, }, { "passive_leech", 3, }, { "passive_avoidance", 3, }, },
        { { "passive_crit", 1, }, { "passive_leech", 1, }, { "passive_haste", 2, }, { "twilight", 2, }, { "proc_mastery", 3, }, { "passive_crit_dam", 3, }, },
        { { "passive_haste", 1, }, { "twisted", 1, }, { "proc_haste", 2, }, { "echo", 2, }, { "star", 3, }, { "passive_crit", 3, }, },
        { { "proc_haste", 1, }, { "passive_crit_dam", 1, }, { "proc_versatility", 2, }, { "ritual", 2, }, { "passive_mastery", 3, }, { "twilight", 3, }, { "passive_avoidance", 1, }, },
        { { "echo", 1, }, { "passive_versatility", 1, }, { "proc_mastery", 2, }, { "star", 2, }, { "proc_crit", 3, }, { "ritual", 3, }, { "bleed", 1, }, },
        { { "twisted", 2, }, { "proc_crit", 1, }, { "passive_versatility", 2, }, { "proc_versatility", 3, }, { "twilight", 1, }, { "echo", 3, }, },
    }
    local firstTime = time({ year =2020, month=5, day=21, hour=7})
    local interval = 60*60*24*7/2
    local timeFormat = "%m月%d日%H:%M"

    local tip = CorruptionVendorTooltip or CreateFrame("GameTooltip", "CorruptionVendorTooltip", UIParent, "GameTooltipTemplate")

    local function formatOne(key, level)
        if not key then return " " end
        return format("\124T%s:11\124t %d级%s %s", icons[key] or icons.special, level, LOCALES[key] or LOCALES.UNKNOWN, data.corrupts[key] and prices[data.corrupts[key][level]] or "????")
    end

    local function addVendorTip(list, color)
        for i=1, #list, 2 do
            local left = formatOne(list[i][1], list[i][2])
            local right = list[i+1] and formatOne(list[i+1][1], list[i+1][2]) or " "
            GameTooltip_AddColoredDoubleLine(tip, left, right, color or HIGHLIGHT_FONT_COLOR, color or HIGHLIGHT_FONT_COLOR, true);
        end
    end

    CoreScheduleTimer(false, 2, function()
    SetOrHookScript(GameTooltip, "OnHide", function() tip:Hide() end)
    CharIcon:HookScript("OnEnter", function()
        local round = floor((time()-firstTime)/interval)
        round = round % 8 + 1 --0->1 7->8 8->1
        local nextDate = date("%m月%d日 %H:%M", firstTime + round * interval)

        tip:SetOwner(GameTooltip, "ANCHOR_NONE")
        tip:ClearAllPoints()
        tip:SetMinimumWidth(100)
        tip:SetPoint("TOPLEFT", GameTooltip, "TOPRIGHT", 5, 0)
        GameTooltip_AddColoredLine(tip, "腐蚀兑换情况", HIGHLIGHT_FONT_COLOR);
        GameTooltip_AddColoredLine(tip, "心之密室纯净圣母处可以用回响换腐蚀附魔，因为国服更新时间晚于美服，所以北京时间每周二晚23:00可以预知周四早7:00、每周六中午11:00可以预知周日晚19:00刷新的腐蚀", NORMAL_FONT_COLOR);

        GameTooltip_AddBlankLineToTooltip(tip);
        GameTooltip_AddColoredLine(tip, "当前 至 " .. date(timeFormat, firstTime + round * interval), NORMAL_FONT_COLOR);
        local list = vendors[round]
        if not list then
            GameTooltip_AddColoredLine(tip, "没有数据，请更新爱不易", HIGHLIGHT_FONT_COLOR)
        else
            addVendorTip(list)
        end

        GameTooltip_AddBlankLineToTooltip(tip);
        GameTooltip_AddColoredLine(tip, "下轮 " .. date(timeFormat, firstTime + round * interval) .. " 至 " .. date(timeFormat, firstTime + (round+1) * interval), NORMAL_FONT_COLOR, false);
        list = vendors[round+1]
        if not list then
            local round2 = floor((time()+32*60*60-firstTime)/interval) --提前32小时
            round2 = round2 % 8 + 1
            GameTooltip_AddColoredLine(tip, round == round2 and "美服尚未更新，请等待并及时更新爱不易" or "没有数据，请等待并及时更新爱不易", GRAY_FONT_COLOR)
        else
            addVendorTip(list, GRAY_FONT_COLOR)
        end

        for i=2,7 do
            --GameTooltip_AddBlankLineToTooltip(tip);
            GameTooltip_AddColoredLine(tip, date(timeFormat, firstTime + (round+i) * interval) .. " 至 " .. date(timeFormat, firstTime + (round+i+1) * interval), NORMAL_FONT_COLOR);
            local list = vendors[(round+i-1)%8+1]
            if not list then
                GameTooltip_AddColoredLine(tip, "尚未轮换", GRAY_FONT_COLOR)
            else
                addVendorTip(list, GRAY_FONT_COLOR)
            end
        end

        tip:Show()
    end)
    end)
end


--[[
DEFAULT_CHAT_FRAME:AddMessage("\124cff1eff00\124Hitem:119207::::::::120::::1:6551:\124h[切肉斧]\124h\124r");
print("\124cffa335ee\124Hitem:174532::::::::120:65::5:7:4823:6578:6579:6550:6515:1502:4786:::\124h[脓液之刺指环]\124h\124r")
print("\124cffa335ee\124Hitem:174532::::::::120:65::5:5:4823:6516:6515:1502:4786:::\124h[脓液之刺指环]\124h\124r")
print("\124cffa335ee\124Hitem:174532::::::::120:65::5:3:4823:1502:6545:::\124h[脓液之刺指环]\124h\124r")

list = { 6543, 6544, 6545, 6552, 6553, 6554 }
diffs = { "", "", "4822:1487", "", "4823:1502", "4824:1517" }
for _, affix in ipairs(list) do
  local a = ""
  for j, diff in ipairs(diffs) do
    if diff~="" then a = a .. format("\124cffa335ee\124Hitem:174170::::::::120:65::%d:3:%s:%d:::\124h[龙骨护臂]\124h\124r", j, diff, affix) end
  end
  print(a)
end
--]]

--[[
6437 暴伤2 3 4
6450 5腐蚀 6469 24腐蚀
6470 20腐蚀
6471 6%精通
6472 9%精通
6473 12%精通
6474 6%急速 9 12
6477 全能
6480 暴击
6483 闪避=急速*8% 12 16
6486 洞察-冷却
6493 吸血3% 5 8
6537 暮光
6540 仪式
6543 鞭笞
6546 洞察 15
6547 12 冷却速度30%
6548 30 冷却速度50%
6549 回响
6552 无尽之星
6555 急速 15 546 4s
6556 暴击 15 31*5
6557 精通 15 392 10s
6558 全能 15 312 20s
6559 急速 20 728 4s
6560 急速 35 1275
6561 暴击 20 41*5
6562 暴击 35 72*5
6563 精通 20 523 10s
6564 精通 35 915 10s
6565 全能 20 416 20s
6566 全能 35 728 20s
6567 噬灵
6568 猎人冷却
6569 25 触须-30%速度6秒
6570 20 智力
6571 30 灼热七夕
6572 50 黑曜石之肤
6573 渗血
]]