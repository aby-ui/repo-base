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
}

-- 修正闪避
data.corrupts.passive_avoidance = { 8, 12, 16 } --8% 12% 16%
data.corrupts.passive_leech = { 17, 28, 45 } --3% 5% 8%
for _,v in pairs(data.affixes) do v.corrupt = data.corrupts[v.key][v.level] end

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
        local line = (LOCALES[key] or LOCALES.UNKNOWN)

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

local pattern = "^"..ITEM_CORRUPTION_BONUS_STAT:gsub("%+%%d", "%%+[0-9]+").."$" --"+%d 腐蚀"
local hookTooltipSetItem = function(self, link)
    link = select(2, self:GetItem())
    local name, corrupt, level, key, levels = U1GetCorruptionInfo(link)
    local tooltipName = self:GetName()
    if name then
        for i = 5, 20 do
            local left = _G[tooltipName .. "TextLeft" .. i]:GetText()
            if left:match(pattern) then
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