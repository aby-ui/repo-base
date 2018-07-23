
-------------------------------------
-- 觀察目標裝備屬性統計
-- @Author: M
-- @DepandsOn: InspectUnit.lua
-------------------------------------

local locale = GetLocale()

if (locale == "koKR" or locale == "enUS" or locale == "zhCN" or locale == "zhTW") then
else return end

local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")

local states = {
    --迴避 /80
    [ITEM_MOD_CR_AVOIDANCE_SHORT]   = function(value) return value/80 end,
    --速度 /101.2
    [ITEM_MOD_CR_SPEED_SHORT]       = function(value) return value/101.2 end,
    --精通 /800
    [ITEM_MOD_MASTERY_RATING_SHORT] = function(value) return value/800 end,
    --臨機應變 /475
    [ITEM_MOD_VERSATILITY]          = function(value) return value/475 end,
    --致命一擊 /400
    [ITEM_MOD_CRIT_RATING_SHORT]    = function(value) return value/400 end,
    --汲取 /225
    [ITEM_MOD_CR_LIFESTEAL_SHORT]   = function(value) return value/225 end,
    --加速 /375
    [ITEM_MOD_HASTE_RATING_SHORT]   = function(value) return value/375 end,
}

local function GetStatePercent(unit, state, value, default)
    local _, race = UnitRace(unit)
    local _, class = UnitClass(unit)
    local specID = GetInspectSpecialization(unit)
    local level = UnitLevel(unit)
    if (TinyInspectDB and TinyInspectDB.DisplayPercentageStats and tonumber(value) and level == 110) then
        if (states[state]) then
            return format("+%.2f%%", states[state](value))
        else
            return value
        end
    else
        return value or default
    end
end

function ShowInspectItemStatsFrame(frame, unit)
    if (not frame.expandButton) then
        local expandButton = CreateFrame("Button", nil, frame)
        expandButton:SetSize(12, 12)
        expandButton:SetPoint("TOPRIGHT", -5, -5)
        expandButton:SetNormalTexture("Interface\\Cursor\\Item")
        expandButton:GetNormalTexture():SetTexCoord(12/32, 0, 0, 12/32)
        expandButton:SetScript("OnClick", function(self)
            local parent = self:GetParent()
            ToggleFrame(parent.statsFrame)
            if (parent.statsFrame:IsShown()) then
                ShowInspectItemStatsFrame(parent, parent.unit)
            end
        end)
        frame.expandButton = expandButton
    end
    if (not frame.statsFrame) then
        local statsFrame = CreateFrame("Frame", nil, frame, "InsetFrameTemplate3")
        statsFrame:SetSize(197, 157)
        statsFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, -1)
        for i = 1, 20 do
            statsFrame["stat"..i] = CreateFrame("FRAME", nil, statsFrame, "CharacterStatFrameTemplate")
            statsFrame["stat"..i]:EnableMouse(false)
            statsFrame["stat"..i]:SetWidth(197)
            statsFrame["stat"..i]:SetPoint("TOPLEFT", 0, -17*i+13)
            statsFrame["stat"..i].Background:SetVertexColor(0, 0, 0)
            statsFrame["stat"..i].Value:SetPoint("RIGHT", -64, 0)
            statsFrame["stat"..i].PlayerValue = statsFrame["stat"..i]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
            statsFrame["stat"..i].PlayerValue:SetPoint("LEFT", statsFrame["stat"..i], "RIGHT", -54, 0)
        end
        local mask = statsFrame:CreateTexture()
        mask:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
        mask:SetPoint("TOPLEFT", statsFrame, "TOPRIGHT", -58, -3)
        mask:SetPoint("BOTTOMRIGHT", statsFrame, "BOTTOMRIGHT", -3, 2)
        mask:SetBlendMode("ADD")
        mask:SetGradientAlpha("VERTICAL", 0.1, 0.4, 0.4, 0.8, 0.1, 0.2, 0.2, 0.8)
        frame.statsFrame = statsFrame
    end
    if (not frame.statsFrame:IsShown()) then return end
    local inspectStats, playerStats = {}, {}
    local _, inspectItemLevel = LibItemInfo:GetUnitItemLevel(unit, inspectStats)
    local _, playerItemLevel  = LibItemInfo:GetUnitItemLevel("player", playerStats)
    local baseInfo = {}
    table.insert(baseInfo, {label = LEVEL, iv = UnitLevel(unit), pv = UnitLevel("player") })
    table.insert(baseInfo, {label = HEALTH, iv = AbbreviateLargeNumbers(UnitHealthMax(unit)), pv = AbbreviateLargeNumbers(UnitHealthMax("player")) })
    table.insert(baseInfo, {label = STAT_AVERAGE_ITEM_LEVEL, iv = format("%.1f",inspectItemLevel), pv = format("%.1f",playerItemLevel) })
    local index = 1
    for _, v in pairs(baseInfo) do
        frame.statsFrame["stat"..index].Label:SetText(v.label)
        frame.statsFrame["stat"..index].Label:SetTextColor(0.2, 1, 1)
        frame.statsFrame["stat"..index].Value:SetText(v.iv)
        frame.statsFrame["stat"..index].Value:SetTextColor(0, 0.7, 0.9)
        frame.statsFrame["stat"..index].PlayerValue:SetText(v.pv)
        frame.statsFrame["stat"..index].PlayerValue:SetTextColor(0, 0.7, 0.9)
        frame.statsFrame["stat"..index].Background:SetShown(index%2~=0)
        frame.statsFrame["stat"..index]:Show()
        index = index + 1
    end
    for k, v in pairs(inspectStats) do
        if (v.r + v.g + v.b < 1.2) then
            frame.statsFrame["stat"..index].Label:SetText(k)
            frame.statsFrame["stat"..index].Label:SetTextColor(v.r, v.g, v.b)
            frame.statsFrame["stat"..index].Value:SetText(GetStatePercent(unit,k,v.value))
            frame.statsFrame["stat"..index].Value:SetTextColor(v.r, v.g, v.b)
            frame.statsFrame["stat"..index].PlayerValue:SetText(GetStatePercent("player",k,playerStats[k] and playerStats[k].value,"-"))
            frame.statsFrame["stat"..index].PlayerValue:SetTextColor(v.r, v.g, v.b)
            frame.statsFrame["stat"..index].Background:SetShown(index%2~=0)
            frame.statsFrame["stat"..index]:Show()
            index = index + 1
        end
    end
    for k, v in pairs(playerStats) do
        if (not inspectStats[k] and v.r + v.g + v.b < 1.2) then
            frame.statsFrame["stat"..index].Label:SetText(k)
            frame.statsFrame["stat"..index].Label:SetTextColor(v.r, v.g, v.b)
            frame.statsFrame["stat"..index].Value:SetText("-")
            frame.statsFrame["stat"..index].Value:SetTextColor(v.r, v.g, v.b)
            frame.statsFrame["stat"..index].PlayerValue:SetText(GetStatePercent("player",k,v.value))
            frame.statsFrame["stat"..index].PlayerValue:SetTextColor(v.r, v.g, v.b)
            frame.statsFrame["stat"..index].Background:SetShown(index%2~=0)
            frame.statsFrame["stat"..index]:Show()
            index = index + 1
        end
    end
    for k, v in pairs(inspectStats) do
        if (v.r + v.g + v.b > 1.2) then
            frame.statsFrame["stat"..index].Label:SetText(k)
            frame.statsFrame["stat"..index].Label:SetTextColor(1, 0.82, 0)
            frame.statsFrame["stat"..index].Value:SetText(v.value)
            frame.statsFrame["stat"..index].Value:SetTextColor(v.r, v.g, v.b)
            if (playerStats[k]) then
                frame.statsFrame["stat"..index].PlayerValue:SetText(playerStats[k].value)
                frame.statsFrame["stat"..index].PlayerValue:SetTextColor(playerStats[k].r, playerStats[k].g, playerStats[k].b)
            else
                frame.statsFrame["stat"..index].PlayerValue:SetText("-")
            end
            frame.statsFrame["stat"..index].Background:SetShown(index%2~=0)
            frame.statsFrame["stat"..index]:Show()
            index = index + 1
        end
    end
    for k, v in pairs(playerStats) do
        if (not inspectStats[k] and v.r + v.g + v.b > 1.2) then
            frame.statsFrame["stat"..index].Label:SetText(k)
            frame.statsFrame["stat"..index].Label:SetTextColor(1, 0.82, 0)
            frame.statsFrame["stat"..index].Value:SetText("-")
            frame.statsFrame["stat"..index].Value:SetTextColor(v.r, v.g, v.b)
            frame.statsFrame["stat"..index].PlayerValue:SetText(v.value)
            frame.statsFrame["stat"..index].PlayerValue:SetTextColor(v.r, v.g, v.b)
            frame.statsFrame["stat"..index].Background:SetShown(index%2~=0)
            frame.statsFrame["stat"..index]:Show()
            index = index + 1
        end
    end
    frame.statsFrame:SetHeight(index*17-10)
    while (frame.statsFrame["stat"..index]) do
        frame.statsFrame["stat"..index]:Hide()
        index = index + 1
    end
end

hooksecurefunc("ShowInspectItemListFrame", function(unit, parent, itemLevel)
    local frame = parent.inspectFrame
    if (not frame) then return end
    if (unit == "player") then return end
    if (TinyInspectDB and not TinyInspectDB.ShowItemStats) then return end
    ShowInspectItemStatsFrame(frame, unit)
end)
