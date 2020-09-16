
-------------------------------------
-- 輸入框首字@可快捷密好友
-- Author:M  NGAID:loudsoul
-------------------------------------

--職業顔色值
local LOCAL_CLASS_INFO = {}

do
    local localClass, class
    for i = 1, GetNumClasses() do
        localClass, class = GetClassInfo(i)
        LOCAL_CLASS_INFO[localClass] = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
        LOCAL_CLASS_INFO[localClass].class = class
    end
end

--按鈕數量
local numButton = 25

--創建信息框
do
    local function onclick(self)
        local parent = self:GetParent()
        local editBox = ChatEdit_GetLastActiveWindow()
        if (self.dataIsBNet) then
            editBox:SetAttribute("chatType", "BN_WHISPER")
            editBox:SetAttribute("tellTarget", self.dataBName)
        else
            editBox:SetAttribute("chatType", "WHISPER")
            editBox:SetAttribute("tellTarget", self.dataName)
        end
        ChatEdit_UpdateHeader(editBox)
        editBox:SetText(strsub(editBox:GetText(),parent.editPos+1))
        parent:Hide()
    end
    local function createButton(parent, index)
        local button = CreateFrame("Button", "ChatAtFriendsFrameButton"..index, parent)
        button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
        button:SetID(index)
        button:SetHeight(26)
        button:SetWidth(128)
        button:SetScript("OnClick", onclick)
        if (index == 1) then
            button:SetPoint("TOP", parent, "TOP", 2, -12)
        else
            button:SetPoint("TOP", _G["ChatAtFriendsFrameButton"..(index-1)], "BOTTOM", 0, -6)
        end
        button.icon = button:CreateTexture(nil, "BORDER")
        button.icon:SetSize(20, 20)
        button.icon:SetPoint("LEFT", 8, 0)
        button.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        button.name = button:CreateFontString(nil, "ARTWORK")
        button.name:SetFont(UNIT_NAME_FONT, 13, "OUTLINE")
        button.name:SetPoint("TOPLEFT", button, "TOPLEFT", 30, 0)
        button.name:SetJustifyH("LEFT")
        button.name:SetSize(90, 18)
        button.area = button:CreateFontString(nil, "ARTWORK")
        button.area:SetFont(GameFontNormal:GetFont(), 9, "NORMAL")
        button.area:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 30, 0)
        button.area:SetJustifyH("LEFT")
        button.area:SetSize(90, 12)
        button.area:SetTextColor(1, 0.82, 0, 0.8)
        button.level = button:CreateFontString(nil, "ARTWORK")
        button.level:SetFont(GameFontNormal:GetFont(), 9, "OUTLINE")
        button.level:SetPoint("LEFT", -2, -6)
        button.level:SetSize(40, 40)
        button.level:SetTextColor(1, 0.82, 0)
    end
    local frame = CreateFrame("Frame", "ChatAtFriendsFrame", UIParent)
    frame:Hide()
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("DIALOG")
    frame:SetSize(136, 500)
    frame:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 8, edgeSize = 8,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    frame:SetBackdropColor(0, 0, 0)
    frame:SetBackdropBorderColor(1, 1, 1, 0.8)
    for i = 1, numButton do createButton(frame, i) end
end

--獲取好友信息
local function ListFriends(text)
    local friends = {}
    local accountName, bnetIDGameAccount, client
    local name, level, class, area, faction, _
    --本服好友
    local numWoWTotal, numWoWOnline = GetNumFriends()
    if (numWoWOnline > 0) then
        faction = UnitFactionGroup("player")
        for id = 1, numWoWOnline do
            name, level, class, area = GetFriendInfo(id)
            tinsert(friends, { name = name, level = level, class = class, area = area, faction = faction, isBNet = false, })
        end
    end
    --戰網好友
    local numBNetTotal, numBNetOnline = BNGetNumFriends()
    if (numBNetOnline > 0) then
        for id = 1, numBNetOnline do
            _, accountName, _, _, _, bnetIDGameAccount, client = BNGetFriendInfo(id)
            if (client == "WoW" and bnetIDGameAccount) then
                _, name, _, _, _, faction, _, class, _, area, level = BNGetGameAccountInfo(bnetIDGameAccount)
                tinsert(friends, { bname = accountName, name = name, level = level, class = class, area = area, faction = faction, isBNet = true, })
            end
        end
    end
    --好友太多的話自動啓用關鍵字匹配
    if (#friends > numButton) then
        text = text:gsub("@", "")
        if (text ~= "") then
            local t = {}
            for _, v in ipairs(friends) do
                if (strfind(v.name, text)) then
                    tinsert(t, v)
                end
            end
            if (#t > 0) then friends = t end
        end
    end

    return friends
end

--顯示好友信息框
local function ChatAtFriendsFrame_Show(self, text)
    local friends = ListFriends(text)
    local faction = UnitFactionGroup("player")
    local position = self.GetCursorPosition and self:GetCursorPosition() or 0
    local button, info
    local index = 1
    if (#friends == 0) then return ChatAtFriendsFrame:Hide() end
    while (friends[index] and index <= numButton) do
        info = LOCAL_CLASS_INFO[friends[index].class]
        button = _G["ChatAtFriendsFrameButton"..index]
        button.name:SetText(friends[index].name)
        button.area:SetText(friends[index].area)
        button.level:SetText(friends[index].level)
		button.name:SetTextColor(info.r, info.g, info.b)
        if (faction == friends[index].faction) then
            button.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
            button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[info.class]))
        else
            button.icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..friends[index].faction)
            button.icon:SetTexCoord(0, 44/64, 0, 44/64)
        end
        button.dataName = friends[index].name
        button.dataIsBNet = friends[index].isBNet
        button.dataBName = friends[index].bname
        button:Show()
        index = index + 1
    end
    ChatAtFriendsFrame:SetHeight((index-1)*32+20)
    while (_G["ChatAtFriendsFrameButton"..index]) do
        _G["ChatAtFriendsFrameButton"..index]:Hide()
        index = index + 1
    end
    ChatAtFriendsFrame.editPos = position
    ChatAtFriendsFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", position*8+40, -4)
    ChatAtFriendsFrame:Show()
end

--隱藏好友信息框
local function ChatAtFriendsFrame_Hide()
    ChatAtFriendsFrame:Hide()
end

--功能附到聊天框 多于3字不顯示
hooksecurefunc("ChatEdit_OnTextChanged", function(self, userInput)
    local text = self:GetText()
    if (userInput) then
        if (strfind(text, "^%s*@%w-") and self:GetUTF8CursorPosition() <= 4) then
            ChatAtFriendsFrame_Show(self, text)
        else
            ChatAtFriendsFrame_Hide()
        end
    end
end)
hooksecurefunc("ChatEdit_OnEditFocusLost", function(self) ChatAtFriendsFrame_Hide() end)
hooksecurefunc("ChatEdit_OnEscapePressed", function(self) ChatAtFriendsFrame_Hide() end)


-------------------------------------
--战网好友显示角色信息
-------------------------------------

hooksecurefunc("ChatEdit_UpdateHeader", function(editBox)
    if (not editBox.nametip) then
        editBox.nametip = CreateFrame("Frame", nil, editBox)
        editBox.nametip:SetPoint("TOPLEFT", editBox, "TOPLEFT", 40, 12)
        editBox.nametip:SetSize(136, 16)
        editBox.nametip.icon = editBox.nametip:CreateTexture(nil, "BORDER")
        editBox.nametip.icon:SetSize(15, 15)
        editBox.nametip.icon:SetPoint("LEFT", 8, 0)
        editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        editBox.nametip.name = editBox.nametip:CreateFontString(nil, "ARTWORK")
        editBox.nametip.name:SetFont(UNIT_NAME_FONT, 16, "OUTLINE")
        editBox.nametip.name:SetPoint("LEFT", editBox.nametip, "LEFT", 25, 0)
        editBox.nametip.name:SetJustifyH("LEFT")
        editBox.nametip.name:SetSize(128, 16)
        editBox.nametip.level = editBox.nametip:CreateFontString(nil, "ARTWORK")
        editBox.nametip.level:SetFont(GameFontNormal:GetFont(), 9, "OUTLINE")
        editBox.nametip.level:SetPoint("LEFT", -2, -4)
        editBox.nametip.level:SetSize(40, 14)
        editBox.nametip.level:SetTextColor(1, 0.82, 0)
        editBox.nametip.faction = UnitFactionGroup("player")
    end
    if (editBox:GetAttribute("chatType") == "BN_WHISPER") then
        local name, faction, class, area, level, info
        local accountName, bnetIDGameAccount, client
        local bname = editBox:GetAttribute("tellTarget")
        local _, numBNetOnline = BNGetNumFriends()
        for i = 1, numBNetOnline do
            _, accountName, _, _, _, bnetIDGameAccount, client = BNGetFriendInfo(i)
            if (bname == accountName and client == "WoW" and bnetIDGameAccount) then
                _, name, _, _, _, faction, _, class, _, area, level = AbyBNGetGameAccountInfo(i)
                info = LOCAL_CLASS_INFO[class]
                editBox.nametip.name:SetText(name)
                editBox.nametip.level:SetText(level)
                editBox.nametip.name:SetTextColor(info.r, info.g, info.b)
                if (editBox.nametip.faction == faction) then
                    editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                    editBox.nametip.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[info.class]))
                else
                    editBox.nametip.icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..faction)
                    editBox.nametip.icon:SetTexCoord(0, 44/64, 0, 44/64)
                end
                return editBox.nametip:Show()
            end
        end
    else
        editBox.nametip:Hide()
    end
end)

--动态创建的聊天框也要处理,密语窗口单击回复
local function simplify(self)
    if not self or self.hasSimplified then return end
    local name = self:GetName()
    self.hasSimplified = true
end

hooksecurefunc("FCF_SetTemporaryWindowType", function(chatFrame, chatType, chatTarget)
simplify(chatFrame)
chatFrame:ScrollToTop()
    _G[chatFrame:GetName().."Tab"]:SetScript("OnDoubleClick", function(self)
        if (chatType == "WHISPER" or chatType == "BN_WHISPER") then
         local editBox = ChatEdit_ChooseBoxForSend()
         editBox:SetAttribute("chatType", chatType)
         editBox:SetAttribute("tellTarget", chatTarget)
         ChatEdit_ActivateChat(editBox)
         editBox:SetText(editBox:GetText())
         end
    end)
end)


-------------------------------------
-- 去掉密語的快捷記憶
-------------------------------------

ChatTypeInfo['WHISPER'].sticky = 0
ChatTypeInfo['BN_WHISPER'].sticky = 0