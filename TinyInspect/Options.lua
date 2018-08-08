
--------------
-- 配置面板 --
--------------

local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local VERSION = 2.4

local addon, ns = ...

local L = ns.L or {}

setmetatable(L, { __index = function(_, k)
    return k:gsub("([a-z])([A-Z])", "%1 %2")
end})

local DefaultDB = {
    version163 = "v2",
    version = VERSION,                    --配置的版本號
    ShowItemBorder = false,               --物品直角邊框
    EnableItemLevel  = true,              --物品等級
      ShowColoredItemLevelString = true, --裝等文字隨物品品質
      ShowItemSlotString = false,         --物品部位文字
        EnableItemLevelBag = true,
        EnableItemLevelBank = true,
        EnableItemLevelMerchant = true,
        EnableItemLevelTrade = true,
        EnableItemLevelGuildBank = true,
        EnableItemLevelAuction = true,
        EnableItemLevelAltEquipment = true,
        EnableItemLevelPaperDoll = true,
        EnableItemLevelGuildNews = true,
        EnableItemLevelChat = true,
        EnableItemLevelLoot = true,
    ShowInspectAngularBorder = false,     --觀察面板直角邊框
    ShowInspectColoredLabel = true,       --觀察面板高亮橙裝武器標簽
    ShowOwnFrameWhenInspecting = false,   --觀察同時顯示自己裝備列表
    ShowItemStats = false,                --顯示裝備屬性統計
    ShowCharacterItemSheet = false,        --顯示玩家自己裝備列表
    EnablePartyItemLevel = false,          --小隊裝等
        SendPartyItemLevelToSelf = false,  --發送小隊裝等到自己面板
        SendPartyItemLevelToParty = false, --發送小隊裝等到隊伍頻道
        ShowPartySpecialization = false,   --顯示隊友天賦
    EnableRaidItemLevel = false,          --團隊裝等
    EnableMouseItemLevel = true,          --鼠標裝等
    EnableMouseSpecialization = true,     --鼠標天賦
    EnableMouseWeaponLevel = false,       --鼠標武器等級
    PaperDollItemLevelOutsideString = false, --PaperDoll文字外邊顯示(沒有在配置面板)
    ItemLevelAnchorPoint = "TOPLEFT",         --裝等位置
    ShowPluginGreenState = false,         --裝備綠字屬性前綴顯示
}

local options = {
    { key = "ShowItemBorder" },
    { key = "EnableItemLevel",
      child = {
        { key = "ShowColoredItemLevelString" },
        { key = "ShowItemSlotString" },
      },
      subtype = {
        { key = "Bag" },
        { key = "Bank" },
        { key = "Merchant" },
        { key = "Trade" },
        { key = "Auction" },
        { key = "AltEquipment" },
        { key = "GuildBank" },
        { key = "GuildNews" },
        { key = "PaperDoll" },
        { key = "Chat" },
        { key = "Loot" },
      },
      anchorkey = "ItemLevelAnchorPoint",
    },
    { key = "ShowInspectAngularBorder" },
    { key = "ShowInspectColoredLabel" },
    { key = "ShowCharacterItemSheet" },
    { key = "ShowOwnFrameWhenInspecting" },
    { key = "ShowItemStats" },
    { key = "EnablePartyItemLevel",
      child = {
        { key = "ShowPartySpecialization" },
        { key = "SendPartyItemLevelToSelf" },
        { key = "SendPartyItemLevelToParty" },
      }
    },
    { key = "EnableRaidItemLevel",
        checkedFunc = function() TinyInspectRaidFrame:Show() end,
        uncheckedFunc = function() TinyInspectRaidFrame:Hide() end,
    },
    { key = "EnableMouseItemLevel",
      child = {
        { key = "EnableMouseSpecialization" },
        { key = "EnableMouseWeaponLevel" },
      }
    },
}

if (GetLocale():sub(1,2) == "zh") then
    tinsert(options, { key = "ShowPluginGreenState" })
end

TinyInspectDB = DefaultDB

local function CallCustomFunc(self)
    local checked = self:GetChecked()
    if (checked and self.checkedFunc) then
        self.checkedFunc(self)
    end
    if (not checked and self.uncheckedFunc) then
        self.uncheckedFunc(self)
    end
end

local function StatusSubCheckbox(self, status)
    local checkbox
    for i = 1, self:GetNumChildren() do
        checkbox = select(i, self:GetChildren())
        if (checkbox.key) then
            checkbox:SetEnabled(status)
            StatusSubCheckbox(checkbox, status)
        end
    end
    if (status and self.SubtypeFrame) then
        self.SubtypeFrame:Show()
    elseif (not status and self.SubtypeFrame) then
        self.SubtypeFrame:Hide()
    end
end

local function OnClickCheckbox(self)
    local status = self:GetChecked()
    TinyInspectDB[self.key] = status
    StatusSubCheckbox(self, status)
    CallCustomFunc(self)
end

local function CreateSubtypeFrame(list, parent)
    if (not list) then return end
    if (not parent.SubtypeFrame) then
        parent.SubtypeFrame = CreateFrame("Frame", nil, parent)
        parent.SubtypeFrame:SetScale(0.92)
        parent.SubtypeFrame:SetPoint("TOPLEFT", 333, 0)
        parent.SubtypeFrame:SetBackdrop({
            bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile     = true,
            tileSize = 8,
            edgeSize = 16,
            insets   = {left = 4, right = 4, top = 4, bottom = 4}
        })
        parent.SubtypeFrame:SetBackdropColor(0, 0, 0, 0.6)
        parent.SubtypeFrame:SetBackdropBorderColor(0.6, 0.6, 0.6)
        parent.SubtypeFrame.title = parent.SubtypeFrame:CreateFontString(nil, "BORDER", "GameFontNormalOutline")
        parent.SubtypeFrame.title:SetPoint("TOPLEFT", 16, -18)
        parent.SubtypeFrame.title:SetText(L[parent.key])
    end
    local checkbox
    for i, v in ipairs(list) do
        checkbox = CreateFrame("CheckButton", nil, parent.SubtypeFrame, "InterfaceOptionsCheckButtonTemplate")
        checkbox.key = parent.key .. v.key
        checkbox.checkedFunc = v.checkedFunc
        checkbox.uncheckedFunc = v.uncheckedFunc
        checkbox.Text:SetText(L[v.key])
        checkbox:SetScript("OnClick", OnClickCheckbox)
        checkbox:SetPoint("TOPLEFT", parent.SubtypeFrame, "TOPLEFT", 16, -46-(i-1)*32)
    end
    parent.SubtypeFrame:SetSize(168, #list*32+58)
end

local function CreateAnchorFrame(anchorkey, parent)
    if (not anchorkey) then return end
    local CreateAnchorButton = function(frame, anchorPoint)
        local button = CreateFrame("Button", nil, frame)
        button.anchorPoint = anchorPoint
        button:SetSize(12, 12)
        button:SetPoint(anchorPoint)
        button:SetNormalTexture("Interface\\Buttons\\WHITE8X8")
        if (TinyInspectDB[frame.anchorkey] == anchorPoint) then
            button:GetNormalTexture():SetVertexColor(1, 0.2, 0.1)
        end
        button:SetScript("OnClick", function(self)
            local parent = self:GetParent()
            local anchorPoint = self.anchorPoint
            local anchorOrig = TinyInspectDB[parent.anchorkey]
            if (parent[anchorOrig]) then
                parent[anchorOrig]:GetNormalTexture():SetVertexColor(1, 1, 1)
            end
            self:GetNormalTexture():SetVertexColor(1, 0.2, 0.1)
            TinyInspectDB[parent.anchorkey] = anchorPoint
        end)
        frame[anchorPoint] = button
    end
    local frame = CreateFrame("Frame", nil, parent.SubtypeFrame or parent, "ThinBorderTemplate")
    frame.anchorkey = anchorkey
    frame:SetBackdrop(GameTooltip:GetBackdrop())
    frame:SetBackdropColor(GameTooltip:GetBackdropColor())
    frame:SetBackdropBorderColor(1, 1, 1, 0)
    frame:SetSize(80, 80)
    frame:SetPoint("TOPRIGHT", 100, -5)
    CreateAnchorButton(frame, "TOPLEFT")
    CreateAnchorButton(frame, "LEFT")
    CreateAnchorButton(frame, "BOTTOMLEFT")
    CreateAnchorButton(frame, "TOP")
    CreateAnchorButton(frame, "BOTTOM")
    CreateAnchorButton(frame, "TOPRIGHT")
    CreateAnchorButton(frame, "RIGHT")
    CreateAnchorButton(frame, "BOTTOMRIGHT")
    CreateAnchorButton(frame, "CENTER")
end

local function CreateCheckbox(list, parent, anchor, offsetx, offsety)
    local checkbox, subbox
    local stepx, stepy = 20, 28
    if (not list) then return offsety end
    for i, v in ipairs(list) do
        checkbox = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
        checkbox.key = v.key
        checkbox.checkedFunc = v.checkedFunc
        checkbox.uncheckedFunc = v.uncheckedFunc
        checkbox.Text:SetText(L[v.key])
        checkbox:SetScript("OnClick", OnClickCheckbox)
        checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", offsetx, -6-offsety)
        offsety = offsety + stepy
        offsety = CreateCheckbox(v.child, checkbox, anchor, offsetx+stepx, offsety)
        CreateSubtypeFrame(v.subtype, checkbox)
        CreateAnchorFrame(v.anchorkey, checkbox)
    end
    return offsety
end

local function InitCheckbox(parent)
    local checkbox
    for i = 1, parent:GetNumChildren() do
        checkbox = select(i, parent:GetChildren())
        if (checkbox.key) then
            checkbox:SetChecked(TinyInspectDB[checkbox.key])
            StatusSubCheckbox(checkbox, checkbox:GetChecked())
            CallCustomFunc(checkbox)
            InitCheckbox(checkbox)
        end
    end
    if (parent.SubtypeFrame) then
        InitCheckbox(parent.SubtypeFrame)
    end
end

local frame = CreateFrame("Frame", nil, UIParent)
frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frame.title:SetPoint("TOPLEFT", 18, -16)
frame.title:SetText(addon)
frame.name = addon

CreateCheckbox(options, frame, frame.title, 18, 10)

LibEvent:attachEvent("VARIABLES_LOADED", function()
    if TinyInspectDB and TinyInspectDB.version163 ~= DefaultDB.version163 then
        TinyInspectDB = DefaultDB
    elseif (not TinyInspectDB or not TinyInspectDB.version) then
        TinyInspectDB = DefaultDB
    elseif (TinyInspectDB.version <= DefaultDB.version) then
        TinyInspectDB.version = DefaultDB.version
        for k, v in pairs(DefaultDB) do
            if (TinyInspectDB[k] == nil) then
                TinyInspectDB[k] = v
            end
        end
    end
    InitCheckbox(frame)
end)

InterfaceOptions_AddCategory(frame)
SLASH_TinyInspect1 = "/tinyinspect"
SLASH_TinyInspect2 = "/ti"
function SlashCmdList.TinyInspect(msg, editbox)
    if (msg == "raid") then
        return ToggleFrame(TinyInspectRaidFrame)
    end
    InterfaceOptionsFrame_OpenToCategory(frame)
    InterfaceOptionsFrame_OpenToCategory(frame)
end
