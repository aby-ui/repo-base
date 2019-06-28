U1PLUG["163UI_Quest"] = function()

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
2011.8.20  2016.9 仅保留界面增强
---------------------------------------------------------------]]

local EventFrame = CreateFrame("Frame")
_G.U1QuestEventFrame = EventFrame
EventFrame:RegisterEvent("GOSSIP_SHOW")
EventFrame:RegisterEvent("QUEST_FINISHED")
EventFrame:RegisterEvent("QUEST_DETAIL")
EventFrame:RegisterEvent("QUEST_PROGRESS")
EventFrame:RegisterEvent("QUEST_COMPLETE")
EventFrame:RegisterEvent("QUEST_GREETING")

--交还任务：GOSSIP_SHOW -> GOSSIP_CLOSED -> QUEST_PROCESS -> QUEST_COMPLETE -> QUEST_TURNED_IN -> QUEST_FINISHED -> QUEST_REMOVED
--任务列表接: GOSSIP_SHOW -> GOSSIP_CLOSED -> QUEST_DETAIL -> QUEST_FINISHED -> ... -> QUEST_ACCEPTED
--直接接任务: QUEST_DETAIL -> QUEST_FINISHED -> ... -> QUEST_ACCEPTED 有时FINISHED在DETAIL前面
--有可能直接: QUEST_COMPLETE -> QUEST_FINISHED
--另一种情况：QUEST_GREETING 任务列表 -> QUEST_DETAIL -> QUEST_GREETING -> QUEST_DETAIL -> ... 直接 QUEST_DETAIL 了

EventFrame:SetScript("OnEvent", function(self,event, ...)
    -- print('\t\t\t', event)
    self[event](self, event, ...)
end)

local autoName

local function clearAutoName()
    local tmp = autoName
    autoName = nil
    return tmp
end

function EventFrame:QUEST_FINISHED()
    clearAutoName()
end

hooksecurefunc('AbandonQuest', clearAutoName)

function EventFrame:QUEST_PROGRESS()
    local questName = GetTitleText()
    if questName == autoName then
        CompleteQuest()
    else
        autoName = nil
    end
end

function EventFrame:QUEST_DETAIL()
    local questName = GetTitleText()
    if clearAutoName() == questName and questName then
        return AcceptQuest()
    end
end

function EventFrame:GOSSIP_SHOW()
    clearAutoName()
end

function EventFrame:QUEST_GREETING()
    clearAutoName()
end

local function titleButtonOnClick(self)
    local id = self:GetParent():GetID();
    if self.type=="available" then
        autoName = select((id-1)*6+1, GetGossipAvailableQuests())
        SelectGossipAvailableQuest(id)
    else
        autoName = select((id-1)*6+1, GetGossipActiveQuests())
        SelectGossipActiveQuest(id)
    end
end

local function titleButtonOnClickQuest(self)
    local id = self:GetParent():GetID();
    if self.type=="available" then
        autoName = GetAvailableTitle(id)
        SelectAvailableQuest(id)
    else
        autoName = GetActiveTitle(id)
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
        if titleButton then
            if not titleButton.btnComplete then createButtons(titleButton, true) end
            titleButton.btnAccept:Hide()
            local title, isComplete = GetActiveTitle(i);
            if isComplete then
                titleButton.btnComplete:Show()
            else
                titleButton.btnComplete:Hide()
            end
        end
    end
    for i=(numActiveQuests + 1), (numActiveQuests + numAvailableQuests), 1 do
        local titleButton = _G["QuestTitleButton"..i]
        if not titleButton then break end
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

function EventFrame:QUEST_COMPLETE()
    local questName = GetTitleText()
    -- print("QUEST_COMPLETE", questName, autoName[questName], GetMostExpensiveChoice())
    changeAutoChooseState()
    if ( clearAutoName() == questName and questName ) then
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
end