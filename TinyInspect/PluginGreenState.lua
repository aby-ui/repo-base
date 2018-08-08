
---------------------------
-- 显示装备绿字前缀
---------------------------

local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local locale = GetLocale():sub(1,2)

local shown = {
    ITEM_MOD_HASTE_RATING_SHORT     = { r=0.9, g=0.9, b=0   },
    ITEM_MOD_MASTERY_RATING_SHORT   = { r=0,   g=0.9, b=0.1 },
    ITEM_MOD_CRIT_RATING_SHORT      = { r=0.9, g=0.3, b=0.1 },
    ITEM_MOD_VERSATILITY            = { r=0,   g=0.9, b=0.8 },
}

local function strsubutf8(s, i, j)
    local bytes = strlen(s)
    local startByte = 1
    local endByte = bytes
    local len = 0
    local pos = 1
    local b
    while pos <= bytes do
        len = len + 1
        if (len == i) then startByte = pos end
        b = string.byte(s, pos)
        if (b >= 240) then
            pos = pos + 4
        elseif (b >= 224) then
            pos = pos + 3
        elseif (b >= 192) then
            pos = pos + 2
        else
            pos = pos + 1
        end
        if (len == j) then
            endByte = pos - 1
            break
        end
    end
    return strsub(s, startByte, endByte)
end

local function IsGreenStateEnabled()
    if (locale ~= "zh") then
        return false
    elseif (TinyInspectDB) then
        return TinyInspectDB.ShowPluginGreenState
    end
end

LibEvent:attachTrigger("INSPECT_FRAME_CREATED", function(this, frame, parent)
    if not IsGreenStateEnabled() then return end
    local i = 1
    local itemframe
    local backdrop = {
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        tile     = true,
        tileSize = 8,
        edgeSize = 1,
        insets   = {left = 1, right = 1, top = 1, bottom = 1}
    }
    while(frame["item"..i]) do
        itemframe = frame["item"..i]
        itemframe.label:SetBackdrop({})
        itemframe.label.text:SetText("")
        itemframe.label:SetWidth(68)
        local j = 1
        for k, v in pairs(shown) do
            itemframe[k] = CreateFrame("Frame", nil, itemframe)
            itemframe[k]:SetSize(16, 14)
            itemframe[k]:SetPoint("LEFT", (j-1)*17, 0)
            itemframe[k]:SetBackdrop(backdrop)
            itemframe[k]:SetBackdropBorderColor(v.r, v.g, v.b, 0.25)
            itemframe[k]:SetBackdropColor(0, 0, 0, 0.5)
            itemframe[k].text = itemframe[k]:CreateFontString(nil, "ARTWORK")
            itemframe[k].text:SetFont(UNIT_NAME_FONT, 12, "NORMAL")
            itemframe[k].text:SetPoint("CENTER")
            itemframe[k].text:SetText(strsubutf8(_G[k] or k,1,1))
            itemframe[k].text:SetTextColor(v.r, v.g, v.b)
            itemframe[k].text:SetShadowOffset(-1, -1)
            itemframe[k].text:SetShadowColor(0, 0, 0, 0.9)
            j = j + 1
        end
        i = i + 1
    end
end)

LibEvent:attachTrigger("INSPECT_ITEMFRAME_UPDATED", function(this, itemframe)
    if not IsGreenStateEnabled() then return end
    for k in pairs(shown) do
        if (itemframe[k]) then itemframe[k]:SetAlpha(0.05) end
    end
    if (itemframe.link) then
        local stats = GetItemStats(itemframe.link)
        for k in pairs(stats) do
            if (shown[k] and itemframe[k]) then
                itemframe[k]:SetAlpha(1)
            end
        end
    end
end)
