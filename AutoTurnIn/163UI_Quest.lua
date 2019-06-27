--字
local typeTexts = {
    ["INVTYPE_NECK"] = "项",
    ["INVTYPE_BODY"] = "衬",
    ["INVTYPE_FINGER"] = "戒",
    ["INVTYPE_TRINKET"] = "饰",
    ["INVTYPE_CLOAK"] = "披",
    ["INVTYPE_WEAPON"] = "单",
    ["INVTYPE_SHIELD"] = "盾",
    ["INVTYPE_2HWEAPON"] = "双",
    ["INVTYPE_WEAPONMAINHAND"] = "主",
    ["INVTYPE_WEAPONOFFHAND"] = "副",
    ["INVTYPE_HOLDABLE"] = "副",
    ["INVTYPE_RANGED"] = "远",
    ["INVTYPE_THROWN"] = "远",
    ["INVTYPE_RANGEDRIGHT"] = "远",
    ["INVTYPE_RELIC"] = "圣",
}

local CLASS_AMOR_TYPE = {
    ["WARRIOR"]     = '板',
    ["MAGE"]        = '布',
    ["ROGUE"]       = '皮',
    ["DRUID"]       = '皮',
    ["HUNTER"]      = '锁',
    ["SHAMAN"]      = '锁',
    ["PRIEST"]      = '布',
    ["WARLOCK"]     = '布',
    ["PALADIN"]     = '板',
    ["DEATHKNIGHT"] = '板',
}
local player_class = select(2, UnitClass'player')

local function SetTypeText(link, button)
    local subTypeText = button.subTypeText
    if link then
        local class, subclass, _, slot = select(6, GetItemInfo(link))
        if class=="护甲" and subclass and slot~="INVTYPE_CLOAK" then
            subclass = subclass:sub(1,3)
            if subclass=="布" or subclass=="皮" or subclass=="锁" or subclass=="板" then
                subTypeText:SetText(subclass)
                if(subclass == CLASS_AMOR_TYPE[player_class]) then
                    subTypeText:SetTextColor(.1,.8,.1)
                else
                    subTypeText:SetTextColor(1, 1, 1)
                end
                return
            end
        end
        if slot and typeTexts[slot] then
            subTypeText:SetText(typeTexts[slot])
            subTypeText:SetTextColor(.1,.7,1)
            return
        end
    end
    subTypeText:SetText("")
end
------------------------------------------------------------
-- QuestPrice.lua
--
-- Abin
-- 2010/12/10
------------------------------------------------------------
local _G = _G
local QuestLogFrame = QuestLogFrame
local pcall = pcall
local GetQuestLogItemLink = GetQuestLogItemLink
local GetQuestItemLink = GetQuestItemLink
local select = select
local GetItemInfo = GetItemInfo
local MoneyFrame_SetType = MoneyFrame_SetType
local MoneyFrame_Update = MoneyFrame_Update

local function QuestPriceFrame_OnUpdate(self)
    local button = self:GetParent()
    button.subTypeText:SetText("")
    self = _G[button:GetName().."QuestPriceFrame"]
    if not button.rewardType or button.rewardType == "item" then
        local func = QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink
        local link = func(button.type, button:GetID())
        SetTypeText(link, button)
        local price = link and select(11, GetItemInfo(link))
        if price and price > 0 then
            MoneyFrame_Update(self, price)
            local _, _, _, offsetx, _ = _G[self:GetName().."CopperButtonText"]:GetPoint()
            _G[self:GetName().."GoldButtonText"]:SetPoint("RIGHT", offsetx, 0);
            _G[self:GetName().."SilverButtonText"]:SetPoint("RIGHT", offsetx, 0);
            _G[self:GetName().."CopperButtonText"]:SetPoint("RIGHT", offsetx, 0);
            self:Show()
        else
            self:Hide()
        end
    end
end

local function CreatePriceFrame(name)
    local button = _G[name]
    if button then
        local frame = CreateFrame("Frame", name.."QuestPriceFrame", button, "SmallMoneyFrameTemplate")
        frame:SetPoint("BOTTOMRIGHT", 10, 3)
        frame:Raise()
        frame:SetScale(0.85)
        MoneyFrame_SetType(frame, "STATIC")
        frame.button = button
        local text = _G[button:GetName().."Name"]
        text:SetPoint("LEFT", _G[button:GetName().."NameFrame"], 15, -3);
        text:SetJustifyV("TOP")
        hooksecurefunc(text, "SetText", QuestPriceFrame_OnUpdate)

        local ft = button:CreateFontString()
        ft:SetFont(ChatFontNormal:GetFont(), 12, "OUTLINE")
        ft:SetTextColor(.5,1,.5)
        ft:SetPoint("BOTTOMLEFT", 0, 4)
        button.subTypeText = ft
    end
end

--6.0是后创建的按钮
hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
    local rewardButtons = rewardsFrame == QuestInfoRewardsFrame and rewardsFrame.RewardButtons or nil; --or MapQuestInfoRewardsFrame, but we don't create text on those.
    if ( rewardButtons and rewardButtons[index] and not rewardButtons[index].subTypeText) then
        CreatePriceFrame(rewardButtons[index]:GetName()) --"QuestInfoRewardsFrameQuestInfoItem"..index
    end
end)

--[[------------------------------------------------------------
自动交接任务
warbaby
2011.8.20
---------------------------------------------------------------]]

--[===[
local f = CreateFrame("Frame")
_G.U1QuestEventFrame = f
f:RegisterEvent("GOSSIP_SHOW")
f:RegisterEvent("QUEST_FINISHED")
f:RegisterEvent("QUEST_DETAIL")
f:RegisterEvent("CHAT_MSG_SYSTEM")
f:RegisterEvent("QUEST_PROGRESS")
f:RegisterEvent("QUEST_COMPLETE")
f:RegisterEvent("QUEST_GREETING")

--交还任务：GOSSIP_SHOW -> GOSSIP_CLOSED -> QUEST_PROCESS -> QUEST_COMPLETE -> QUEST_TURNED_IN -> QUEST_FINISHED -> QUEST_REMOVED
--任务列表接: GOSSIP_SHOW -> GOSSIP_CLOSED -> QUEST_DETAIL -> QUEST_FINISHED -> ... -> QUEST_ACCEPTED
--直接接任务: QUEST_DETAIL -> QUEST_FINISHED -> ... -> QUEST_ACCEPTED 有时FINISHED在DETAIL前面
--有可能直接: QUEST_COMPLETE -> QUEST_FINISHED
--另一种情况：QUEST_GREETING 任务列表 -> QUEST_DETAIL -> QUEST_GREETING -> QUEST_DETAIL -> ... 直接 QUEST_DETAIL 了

f:SetScript("OnEvent", function(self,event, ...)
    -- print('\t\t\t', event)
    self[event](self, event, ...)
end)

local numTotal, numAccepted, lastNPC = 0, 0, nil
local autoName = {}

--需要考虑钓鱼小屋接不了第一个任务的情况
local wipeTimer = nil

function cancelAutoNameTimer()
    if wipeTimer then CoreCancelTimer(wipeTimer, true) end
end

function scheduleAutoNameTimer()
    cancelAutoNameTimer()
    wipeTimer = CoreScheduleTimer(false, 2, function() wipe(autoName) end);
end

function f:QUEST_FINISHED()
    --在QUEST_DETAIL/QUEST_PROGRESS上设置更好, 这里不重置，只设置
    if not wipeTimer then scheduleAutoNameTimer() end
end

hooksecurefunc('AbandonQuest', function() wipe(autoName) end)

function f:QUEST_PROGRESS()
    scheduleAutoNameTimer();
    --print("QUEST_PROGRESS", GetTitleText())
    local questName = GetTitleText()
    if IsQuestCompletable() and (autoName[questName] or IsAltKeyDown()) then
        CompleteQuest()
    end
end

local inNewbieAera
do
    local mapids = {
        894, -- #Ammen Vale!1!1!0!1!!",
        890, -- #Camp Narache!1!1!1!1!!",
        891, -- #Echo Isles!1!1!1!1!!",
        888, -- #Shadowglen!1!1!0!1!!",
        889, -- #Valley of Trials!1!1!1!1!!",
        866, -- #Coldridge Valley!1!1!0!2!!",
        892, -- #Deathknell!1!1!1!2!!",
        895, -- #New Tinkertown!1!1!0!2!!",
        864, -- #Northshire!1!1!0!2!!",
        893, -- #Sunstrider Isle!1!1!1!2!!",
        611, -- #Gilneas City!1!5!2!2!!",
        605, -- #Kezan!1!5!1!8!!",
    }
    -- GetMapNameByID
    -- GetCurrentMapAreaID()
    local newbieMaps = {}
    for _, id in next, mapids do
        local name = GetMapNameByID(id)
        if(name) then
            newbieMaps[name] = true
        end
    end

    function inNewbieAera()
        return --[[UnitLevel'player' <= 10 and]] newbieMaps[GetRealZoneText()]
    end
end

local function acceptGossipQuest(index, name, level, isLowLevel, isDaily, isRepeatable, isLegendary, ...)
    if name then
        autoName[name] = 2 --mop接受时接受的是下一个任务
        if(inNewbieAera() or index == 1) then
            SelectGossipAvailableQuest(index)
        end
        return acceptGossipQuest(index + 1, ...)
    end
end

local function completeGossipQuest(index, name, level, isTrivial, isComplete, isLegendary, ...)
    --print(index, name, isComplete)
    if name then
        if isComplete then
            autoName[name] = 1
            autoName.autoCompleting = true
            SelectGossipActiveQuest(index)
        else
            return completeGossipQuest(index + 1, ...)
        end
    end
end

local pattern = "^"..ERR_QUEST_ACCEPTED_S:gsub("%%s", ".*")
function f:CHAT_MSG_SYSTEM(event, msg)
    if msg:find(pattern) then
        QuestInfoDescriptionText:SetAlphaGradient(1024, QUEST_DESCRIPTION_GRADIENT_LENGTH);
        if autoName.autoAccepting then
            autoName.autoAccepting = autoName.autoAccepting - 1
            if autoName.autoAccepting == 0 then
                if autoName.autoAcceptingNum > 1 then
                    RunOnNextFrame(U1Message, format("已接受全部|cffffff00[%d]|r个任务。",autoName.autoAcceptingNum))
                end
                autoName.autoAccepting = nil
            end
        end
    end
end


function f:QUEST_DETAIL()
    scheduleAutoNameTimer();
    --未经过GossipShow和QuestGreeting出来的Detail就要自动接
    local questName = GetTitleText()
    if autoName.autoCompleting then
        CoreScheduleBucket("QuestPriceAutoCompleting", 1, function() autoName.autoCompleting = nil end)
        AcceptQuest()
        U1Message("自动交还任务："..questName)
    elseif autoName[questName] then
        autoName[questName] = autoName[questName]==2 and 1 or nil --mop change
        return AcceptQuest()
    elseif IsAltKeyDown() then
        return AcceptQuest()
    end
end


WW:Button("GossipFrameGreetingAcceptAllButton", GossipFrameGreetingPanel, "MagicButtonTemplate"):SetText("全部接受"):Size(95, 23):BL(2, 19):On("Load"):un()
CoreUIEnableTooltip(GossipFrameGreetingAcceptAllButton, "按住ALT点NPC可自动接受", "此NPC的任务可以一次全部接受")

GossipFrameGreetingAcceptAllButton:SetScript("OnClick", function()
    table.wipe(autoName)
    if GetNumGossipAvailableQuests() > 0 then
        autoName.autoAccepting = GetNumGossipAvailableQuests()
        autoName.autoAcceptingNum = GetNumGossipAvailableQuests()
        acceptGossipQuest(1, GetGossipAvailableQuests())
    end
end)


WW:Button("GossipFrameGreetingCompleteAllButton", GossipFrameGreetingPanel, "MagicButtonTemplate"):SetText("交还首个"):Size(95, 23):LEFT(GossipFrameGreetingAcceptAllButton, "RIGHT"):On("Load"):un()
CoreUIEnableTooltip(GossipFrameGreetingCompleteAllButton, "说明", "受游戏接口限制，无法一键完成全部任务，所以只能逐个交还（但省去了点击确认的步骤）")

GossipFrameGreetingCompleteAllButton:SetScript("OnClick", function()
    table.wipe(autoName)
    if GetNumGossipActiveQuests() > 0 then
        completeGossipQuest(1, GetGossipActiveQuests())
    end
end)

local function GetNumGossipCompleteQuests(...)
    local num = 0
    for i=1, select("#", ...), 5 do
        local name, level, _, isComplete, _ = select(i, ...)
        -- print(i, name, isComplete)
        if(isComplete) then 
            num = num + 1
        end
    end
    return num
end

function f:GOSSIP_SHOW()
    cancelAutoNameTimer();
    -- table.wipe(autoName);
    --autoName.autoCompleting = nil
    --autoName.autoAccepting = nil
    CoreUIEnableOrDisable(GossipFrameGreetingAcceptAllButton, GetNumGossipAvailableQuests() > 0)
    CoreUIEnableOrDisable(GossipFrameGreetingCompleteAllButton, GetNumGossipCompleteQuests(GetGossipActiveQuests()) > 0)
    if(IsAltKeyDown()) then
        if GossipFrameGreetingAcceptAllButton:IsEnabled() then GossipFrameGreetingAcceptAllButton:Click() end
        if GossipFrameGreetingCompleteAllButton:IsEnabled() then GossipFrameGreetingCompleteAllButton:Click() end
    end

    if( GetNumGossipAvailableQuests() > 0) then
        local firstQuest = GetGossipAvailableQuests()
        if(autoName[firstQuest] == 2) then
            SelectGossipAvailableQuest(1)
        end
    else
        wipe(autoName)
    end
end

--[[------------------------------------------------------------
QuestGreeting, 拖把每日
---------------------------------------------------------------]]
WW:Button("QuestFrameGreetingAcceptAllButton", QuestFrameGreetingPanel, "MagicButtonTemplate"):SetText("接受首个"):Size(95, 23):BL(2, 19):On("Load"):un()
CoreUIEnableTooltip(QuestFrameGreetingAcceptAllButton, "按住Alt点NPC可自动接受", "此NPC的任务一次只能接受一个，无法全部接受")

QuestFrameGreetingAcceptAllButton:SetScript("OnClick", function()
    table.wipe(autoName)
    local num = GetNumAvailableQuests()
    if num > 0 then
        autoName.autoAccepting = 1
        autoName.autoAcceptingNum = 1
        local name = GetAvailableTitle(1)
        autoName[name] = 1
        SelectAvailableQuest(1)
    end
end)

WW:Button("QuestFrameGreetingCompleteAllButton", QuestFrameGreetingPanel, "MagicButtonTemplate"):SetText("交还首个"):Size(95, 23):LEFT(QuestFrameGreetingAcceptAllButton, "RIGHT"):On("Load"):un()
CoreUIEnableTooltip(QuestFrameGreetingCompleteAllButton, "说明", "受游戏接口限制，无法一键完成全部任务，所以只能逐个交还（但省去了点击确认的步骤）")

QuestFrameGreetingCompleteAllButton:SetScript("OnClick", function()
    table.wipe(autoName)
    local num = GetNumActiveQuests()
    if num > 0 then
        for i=1, num do
            local name, complete = GetActiveTitle(i)
            if complete then
                autoName[name] = 2
                autoName.autoCompleting = true
                SelectActiveQuest(i)
            end
        end
    end
end)

local function GetNumQuestCompleteQuests()
    local num = 0
    for i=1, GetNumActiveQuests() do
        local title, complete = GetActiveTitle(i)
        if complete then
            num = num + 1
        end
    end
    return num
end

function f:QUEST_GREETING()
    cancelAutoNameTimer();
    table.wipe(autoName);
    CoreUIEnableOrDisable(QuestFrameGreetingAcceptAllButton, GetNumAvailableQuests() > 0)
    CoreUIEnableOrDisable(QuestFrameGreetingCompleteAllButton, GetNumQuestCompleteQuests() > 0)
    if QuestFrameGreetingAcceptAllButton:IsEnabled() and IsAltKeyDown() then QuestFrameGreetingAcceptAllButton:Click() end
    if QuestFrameGreetingCompleteAllButton:IsEnabled() and IsAltKeyDown() then QuestFrameGreetingCompleteAllButton:Click() end
end

local function titleButtonOnClick(self)
    local id = self:GetParent():GetID();
    local name
    if self.type=="available" then
        name = select((id-1)*6+1, GetGossipAvailableQuests())
        wipe(autoName)
        autoName[name] = 1
        SelectGossipAvailableQuest(id)
    else
        name = select((id-1)*5+1, GetGossipActiveQuests())
        wipe(autoName)
        autoName[name] = 1
        autoName.autoCompleting = true
        SelectGossipActiveQuest(id)
    end
end

local function titleButtonOnClickQuest(self)
    local id = self:GetParent():GetID();
    local name
    if self.type=="available" then
        name = GetAvailableTitle(id)
        table.wipe(autoName)
        autoName[name] = 1
        SelectAvailableQuest(id)
    else
        name = GetActiveTitle(id)
        table.wipe(autoName)
        autoName[name] = 1
        autoName.autoCompleting = true
        SelectActiveQuest(id)
    end
end

local function createButtons(titleButton, questNotGossip)
    TplPanelButton(titleButton):Key("btnAccept"):Size(80,16):RIGHT(-10,0):SetText("直接接受"):SetScript("OnClick", questNotGossip and titleButtonOnClickQuest or titleButtonOnClick):un().type="available"
    CoreUISetButtonFonts(titleButton.btnAccept, DialogButtonNormalText, DialogButtonHighlightText)
    TplPanelButton(titleButton):Key("btnComplete"):Size(80,16):RIGHT(-10,0):SetText("直接交还"):SetScript("OnClick", questNotGossip and titleButtonOnClickQuest or titleButtonOnClick):un().type="active"
    CoreUISetButtonFonts(titleButton.btnComplete, DialogButtonNormalText, DialogButtonHighlightText)
end

hooksecurefunc("GossipFrameUpdate", function()
    for i=1, NUMGOSSIPBUTTONS do
        local titleButton = _G["GossipTitleButton"..i]
        if not titleButton.btnComplete then createButtons(titleButton) end
        if titleButton:IsShown() then
            if titleButton.type == "Active" then
                local titleButtonIcon = _G[titleButton:GetName() .. "GossipIcon"];
                if titleButtonIcon:GetTexture():find("Incomplete") then
                    titleButton.btnComplete:Hide()
                else
                    titleButton.btnComplete:Show()
                end
                titleButton.btnAccept:Hide()
            elseif titleButton.type == "Available" then
                titleButton.btnAccept:Show()
                titleButton.btnComplete:Hide()
            else
                titleButton.btnAccept:Hide()
                titleButton.btnComplete:Hide()
            end
        end
    end
end)

QuestFrameGreetingPanel:HookScript("OnShow", function()
	local numActiveQuests = GetNumActiveQuests();
	local numAvailableQuests = GetNumAvailableQuests();
    for i=1, numActiveQuests, 1 do
        local titleButton = _G["QuestTitleButton"..i]
        if not titleButton.btnComplete then createButtons(titleButton, true) end
        titleButton.btnAccept:Hide()
        local title, isComplete = GetActiveTitle(i);
        if isComplete then
            titleButton.btnComplete:Show()
        else
            titleButton.btnComplete:Hide()
        end
    end
    for i=(numActiveQuests + 1), (numActiveQuests + numAvailableQuests), 1 do
        local titleButton = _G["QuestTitleButton"..i]
        if not titleButton.btnComplete then createButtons(titleButton, true) end
        titleButton.btnComplete:Hide()
        titleButton.btnAccept:Show()
    end
end)

--/run ShowUIPanel(QuestLogFrame) QuestLog_SetSelection(5) AbandonQuest()
--/run WW:Button("$parentComplete", QuestTitleButton1,"UIPanelButtonTemplate"):Size(100,23):RIGHT()
--/run QuestTitleButton1Complete:SetSize(80,23)
--/run for i=1, 100 do local a = _G["QuestTitleButton"..i] if not a then break end WW:Button("$parentComplete", a,"UIPanelButtonTemplate"):Size(50,16):RIGHT(-10,0):SetText("交还"):GetFontString():SetFontObject(U1TextFontSmall) end
--/run for i=1, 100 do local a = _G["GossipTitleButton"..i] if not a then break end WW:Button("$parentComplete", a,"UIPanelButtonTemplate"):Size(50,16):RIGHT(-10,0):SetText("交还"):GetFontString():SetFontObject(U1TextFontSmall) end

local function GetMostExpensiveChoice()
    local max = -1
    local chosenLink, chosenId
    for i=1, GetNumQuestChoices() do
        local link = GetQuestItemLink("choice", i)
        local _, _, quantity = GetQuestItemInfo('choice', i)
        if not link then return end --ItemCache issue
        local price = link and select(11, GetItemInfo(link)) or 0
        price = price * (quantity or 1)
		if price > max then
            max = price
            chosenLink = link
            chosenId = i
        end
        SetTypeText(link, _G["QuestInfoRewardsFrameQuestInfoItem"..i])
    end
    if max > 0 then
        return chosenLink, chosenId, max
    end
end

local btnAutoChoose = WW:Button("$parentAutoChooseButton", QuestFrameRewardPanel, "MagicButtonTemplate"):SetText("自动完成"):Size(95, 23):BR(-54, 19):On("Load"):un()
CoreUIEnableTooltip(btnAutoChoose, "自动选择奖励并交还任务", function(button, tip)
    local chosen = GetMostExpensiveChoice()
    if chosen then
        tip:AddLine("注意：请确认后双击按钮，以免造成无法挽回的损失。", 1, 0, 0, 1)
        tip:AddLine(" ")
        tip:AddLine("会选择以下最贵的任务奖励：")
        local name,_,_,_,_,type,subtype,_,_,texture,price = GetItemInfo(chosen);
        tip:AddLine("|T"..texture..":24|t "..chosen)
        tip:AddDoubleLine((subtype or type or ""), "|cffffd100售价：|r"..GetMoneyString(price), 1, 1, 1, 1, 1, 1)
    end
end)

btnAutoChoose:SetScript("OnClick", function()
    if not btnAutoChoose.timer then
        btnAutoChoose.timer = CoreScheduleTimer(false, 0.5, function()
            U1Message("请双击按钮，自动选择并交还任务！", 1, 0.82, 0)
            btnAutoChoose.timer = nil
        end);
    end
end)

btnAutoChoose:SetScript("OnDoubleClick", function()
    if btnAutoChoose.timer then
        CoreCancelTimer(btnAutoChoose.timer)
        btnAutoChoose.timer = nil
    end
    local chosen, id = GetMostExpensiveChoice()
    if chosen then
        GetQuestReward(id)
        U1Message("自动选择了任务奖励："..chosen)
    end
end)

hooksecurefunc("QuestInfoItem_OnClick", function()
    CoreUIEnableOrDisable(btnAutoChoose, QuestInfoFrame.itemChoice == 0 )
end)

local changeAutoChooseState, scheduleChange
function changeAutoChooseState()
    if QuestFrame:IsVisible() then
        local chosen = GetMostExpensiveChoice()
        CoreUIEnableOrDisable(btnAutoChoose, chosen)
        if GetNumQuestChoices() > 0 and not chosen then
            scheduleChange()
        end
    end
end

function scheduleChange()
    CoreScheduleTimer(false, .5, changeAutoChooseState)
end

function f:QUEST_COMPLETE()
    local questName = GetTitleText()
    -- print("QUEST_COMPLETE", questName, autoName[questName], GetMostExpensiveChoice())
    changeAutoChooseState()
    if ( autoName.autoCompleting and autoName[questName] == 1) or
        IsAltKeyDown() then
        autoName[questName] = nil
        -- 大于一个选择奖励 不选择
        if GetNumQuestChoices() > 1 then
            -- local chosen, id = GetMostExpensiveChoice()
            -- if chosen then
            --     GetQuestReward(id)
            --     U1Message("自动选择了任务奖励："..chosen)
            -- end
        else
            -- GetQuestReward 会报错
            if(pcall(GetQuestReward)) then return end
            if(pcall(GetQuestReward, 1)) then return end
            if(pcall(CompleteQuest)) then return end
        end
    end
end

--自动接收拾取物品的任务
local frameStatus = {}
local function anyFrameOpened()
    for frame, opened in next, frameStatus do
        if(opened) then
            return true
        end
    end
    return false
end

local AceEvent = LibStub'AceEvent-3.0'

local lastFound = {}
local firstCheck = true
local function hookContainerFrame_Update()
    if  (not U1GetCfgValue('163UI_Quest', 'searchcontainer')) or
        InCombatLockdown() or QuestFrame:IsVisible() or anyFrameOpened() then
        return
    end

    for bag=0,NUM_BAG_SLOTS do
        for slot=1,GetContainerNumSlots(bag) do
            local isQuestItem, questId, isActive = GetContainerItemQuestInfo(bag, slot);
            if (questId and not isActive) then
                local link = select(7, GetContainerItemInfo(bag, slot))
                if link then
                    if firstCheck then
                        lastFound[link] = true
                    else
                        if not lastFound[link] then
                            lastFound[link] = true
                            UseContainerItem(bag, slot)
                            return
                        end
                    end
                end
            end
        end
    end
    firstCheck = nil
end

--初始建立已有物品列表
AceEvent:RegisterEvent("PLAYER_LOGIN", function()
    return hookContainerFrame_Update()
end)

--f:RegisterEvent("BAG_UPDATE") --in Cfg
AceEvent:RegisterEvent('BAG_UPDATE', function()
    return CoreScheduleBucket("QP_BAG_UPDATE", 0.5, hookContainerFrame_Update)
end)

local function frameOpenedFactory(openEvent, closeEvent, statusName)
    AceEvent:RegisterEvent(openEvent, function() frameStatus[statusName] = true end)
    AceEvent:RegisterEvent(openEvent, function()
        frameStatus[statusName] = false
        return hookContainerFrame_Update()
    end)
end

frameOpenedFactory('BANKFRAME_OPENED', 'BANKFRAME_CLOSED', 'bank')
frameOpenedFactory('MAIL_SHOW', 'MAIL_CLOSED', 'mail')
frameOpenedFactory('MERCHANT_SHOW', 'MERCHANT_CLOSED', 'merchant')
frameOpenedFactory('GUILDBANKFRAME_OPENED', 'GUILDBANKFRAME_CLOSED', 'guildbank')
frameOpenedFactory('VOID_STORAGE_OPEN', 'VOID_STORAGE_CLOSE', 'voidstorage')

--]===]
