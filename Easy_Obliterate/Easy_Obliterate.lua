--Easy Obliterate by Motig
LoadAddOn("Blizzard_ObliterumUI")

local addonVersion = 31
local currentPage = 1
local selectedButton = nil
local previousSelectedButton = nil
local itemCache = {}
local itemButtons = {}
local eligibleItems = {}
local lastEligibleItemCount = -1
local autoSelect = false
local ashLooted = false
local failedItems = {}
local itemIgnoreList = {}
local showGetItemError = false
local lastItem = {itemID = 0, itemLevel = 0, ashAmount = 0}
local currentItem = {itemID = 0, itemLevel = 0}
local currentLineID = nil
local saveData = {}
local first0AshMessage = true

local defaultSettings = {
    showTooltip = true,
    showAshStats = true,
    ignoreWardrobeItems = false,
    show0AshMessage = true
}

local backupAshText = 'Obliterum Ash'
local textColor = {r='0.99999779462814', g='0.12548992037773', b='0.12548992037773', a='0.99999779462814'}
local function dprint(text) if _eadebug then print(text) end end

local tooltipFrame = CreateFrame('GameTooltip', "EasyObliterateTooltipReader", nil, "GameTooltipTemplate")
tooltipFrame:SetOwner(UIParent, "ANCHOR_NONE")

local function getAshForItemID(itemID, itemLevel)
    itemID = tonumber(itemID)
    itemLevel = tonumber(itemLevel)
    if saveData.ashStats[itemID] and saveData.ashStats[itemID][itemLevel] then
        return saveData.ashStats[itemID][itemLevel].averageAsh, saveData.ashStats[itemID][itemLevel].obliterateCount
    else
        return 0
    end
end

local function getSelectedButton()
    local id = (selectedButton-1)%#itemButtons
    return itemButtons[id+1]
end

local function getSelectedButtonID()
    local id = (selectedButton-1)%#itemButtons
    return id+1
end

local function getPreviousSelectedButton()
    local id = (previousSelectedButton-1)%#itemButtons
    return itemButtons[id+1]
end

local function inIgnoreList(link)
    for k,v in pairs(itemIgnoreList) do if v == link then return k end end return false
end

local function getEligibleAshTotal()
    local totalA = 0
    for i = 1, #eligibleItems do
        if saveData.ashStats[eligibleItems[i].itemID] then
            for k,v in pairs(saveData.ashStats[eligibleItems[i].itemID]) do
                totalA = totalA + v.averageAsh
            end
        end
    end
    return totalA
end

local function itemInWardrobeSet(itemID, bag, slot)
    for i = 0, C_EquipmentSet.GetNumEquipmentSets()-1 do
        local setName = C_EquipmentSet.GetEquipmentSetInfo(i)
        local items = C_EquipmentSet.GetItemIDs(i)
        for z = 1, 19 do --would be nicer to get the slot id beforehand so we don't have to loop over all the items in a set
            if items[z] then
                if itemID == items[z] then
                    local equipmentSetInfo = C_EquipmentSet.GetItemLocations(i)
                    local onPlayer, inBank, inBags, inVoidStorage, slotNumber, bagNumber = EquipmentManager_UnpackLocation(equipmentSetInfo[z])
                    if bag == bagNumber and slot == slotNumber then
                        return true
                    end
                end
            end
        end
    end
    return false
end

--This is gross but is done to not have to maintain a list of items that can be obliterated.
local function itemEligible(itemID)
    if itemCache[itemID] ~= nil then
        return itemCache[itemID]
    else     
        tooltipFrame:ClearLines()      
        if GetItemInfo(itemID) then
            tooltipFrame:SetItemByID(itemID)
            for i = tooltipFrame:NumLines(), tooltipFrame:NumLines()-3, -1 do
                if i >= 1 then
                    local text = _G["EasyObliterateTooltipReaderTextLeft"..i]:GetText()                  
                    if text == ITEM_OBLITERATEABLE_NOT then
                        itemCache[itemID] = false
                        return false
                    elseif text == ITEM_OBLITERATEABLE then
                        itemCache[itemID] = true
                        return true
                    end
                end
            end
            return false
        else
            table.insert(failedItems, itemID)
            return false
        end
    end
end

local function getEligibleItems()
   eligibleItems = {}
   failedItems = {}
   C_TradeSkillUI.ClearPendingObliterateItem()
   
   local setItemsIgnored = 0
   
   for bag = 0, 4 do
      for i = 1, GetContainerNumSlots(bag) do
         local itemID = GetContainerItemID(bag, i)
         --if itemLink and itemEligible(itemLink, itemID) then
         --if itemID and itemEligible(itemLink, itemID) then
         if itemID and itemEligible(itemID) then
            local texture, itemCount, locked, quality, readable, lootable, itemLink, isFiltered = GetContainerItemInfo(bag, i)
            
            if saveData.addonSettings.ignoreWardrobeItems then
                if not itemInWardrobeSet(itemID, bag, i) then
                    table.insert(eligibleItems, {bag = bag, index = i, itemLink = itemLink, itemTexture = texture, itemCount = itemCount, itemID = itemID, itemQuality = quality, itemName = string.match(itemLink, "%[(.+)%]")})
                else
                    setItemsIgnored = setItemsIgnored + 1
                end
            else
                table.insert(eligibleItems, {bag = bag, index = i, itemLink = itemLink, itemTexture = texture, itemCount = itemCount, itemID = itemID, itemQuality = quality, itemName = string.match(itemLink, "%[(.+)%]")})           
            end
         end
      end
   end
   
   local ignoredItems = {}
   local availableItems = {}
   
    for i = 1, #eligibleItems do
        if inIgnoreList(eligibleItems[i].itemLink) then
            table.insert(ignoredItems, eligibleItems[i])
        else
            table.insert(availableItems, eligibleItems[i])
        end
    end
   
    --Sort ignored and unignored items seperately and join.
    table.sort(ignoredItems, function(a, b)
        return a.itemName < b.itemName
    end)
    
    table.sort(availableItems, function(a, b)
        return a.itemName < b.itemName
    end)
    
    eligibleItems = {}
    for i = 1, #ignoredItems do
        eligibleItems[i] = ignoredItems[i]
        eligibleItems[i].ignore = true
    end
    
    for i = 1, #availableItems do
        eligibleItems[#ignoredItems+i] = availableItems[i]
    end

    if #failedItems > 0 and showGetItemError then
        showGetItemError = false
        if _eadebug then for i = 1, #failedItems do print(failedItems[i]) end end
        DEFAULT_CHAT_FRAME:AddMessage('Easy Obliterate: Failed to retrieve item info for some items. Usually this happens if you open the forge too soon after logging in. They will appear as you obliterate items or if you open the forge at a later time if they can be obliterated.')
    end
    
    if saveData.addonSettings.ignoreWardrobeItems and setItemsIgnored > 0 then
        DEFAULT_CHAT_FRAME:AddMessage('Easy Obliterate: Ignored '..setItemsIgnored..' item(s) that are used in a saved equipment set.')
    end
end

local function updateItemButtons(forceAnim)
    local playAnim = false
    if lastEligibleItemCount ~= #eligibleItems or forceAnim then
        lastEligibleItemCount = #eligibleItems
        playAnim = true
    end
    
    for i = 1, #itemButtons do      
        local id = ((currentPage-1)*#itemButtons)+i
        if eligibleItems[id] then
            SetItemButtonTexture(itemButtons[i], eligibleItems[id].itemTexture)
            SetItemButtonCount(itemButtons[i], eligibleItems[id].itemCount);
            SetItemButtonQuality(itemButtons[i], eligibleItems[id].itemQuality, eligibleItems[id].itemLink)
            SetItemButtonDesaturated(itemButtons[i], false)
            itemButtons[i].itemRef = id
            itemButtons[i].icon:Show()
            itemButtons[i].ignoredTexture:Hide()

            if playAnim then
                itemButtons[i].glowAnimation:Play()
            end

            if eligibleItems[id].ignore then
                itemButtons[i].IconBorder:SetVertexColor(0.5, 0.5, 0.5)
                SetItemButtonDesaturated(itemButtons[i], true)
                itemButtons[i].ignoredTexture:Show()
            end
        else
            SetItemButtonCount(itemButtons[i], 0)
            SetItemButtonQuality(itemButtons[i], 0)
            itemButtons[i].itemRef = nil
            itemButtons[i].icon:Hide()
            itemButtons[i].ignoredTexture:Hide()
        end
    end
   
    if selectedButton then
        if selectedButton > (currentPage-1)*#itemButtons and selectedButton <= ((currentPage-1)*#itemButtons)+#itemButtons then
            SetItemButtonDesaturated(getSelectedButton(), true)
            AnimatedShine_Start(getSelectedButton())
        else
            AnimatedShine_Stop(getSelectedButton())       
        end
    end
end

local function selectNextItem()
    dprint('Attempting to find next item.')
    if #eligibleItems > 0 then
        if previousSelectedButton then
            dprint('Found a previous button')
            if eligibleItems[previousSelectedButton] and not eligibleItems[previousSelectedButton].ignore then
                dprint('previous button turned into a new item so we can click again')
                getPreviousSelectedButton():Click()
            else
                dprint('previous button is now nill or should be ignored so lets find the next button to click')
                local foundButton = false
                for i = #eligibleItems, 1, -1 do
                    if not eligibleItems[i].ignore then
                        previousSelectedButton = i
                        foundButton = true
                        break
                    end
                end
                if foundButton then
                    dprint('Found next button')
                    getPreviousSelectedButton():Click()
                else
                    dprint('We someone ended up with no button to click')
                end
            end
        else
            dprint('Did not find a previous button')
            itemButtons[1]:Click()
        end
    end
end

local mainFrame = CreateFrame('Frame', nil, ObliterumForgeFrame)
mainFrame:SetPoint('TOP', ObliterumForgeFrame, 'BOTTOM', 0, 16)
mainFrame:SetSize(ObliterumForgeFrame:GetWidth()-16, 264) --248
mainFrame:EnableMouse(true)
mainFrame:SetFrameLevel(ObliterumForgeFrame:GetFrameLevel()-1)
mainFrame:SetBackdrop({
      bgFile="Interface\\FrameGeneral\\UI-Background-Marble", 
      edgeFile='Interface/Tooltips/UI-Tooltip-Border', 
      tile = false, tileSize = 16, edgeSize = 16,
      insets = { left = 4, right = 4, top = 4, bottom = 4 }}
)

mainFrame.totalText = mainFrame:CreateFontString()
mainFrame.totalText:SetFontObject("GameFontHighlight")
mainFrame.totalText:SetText("Total: 55")
mainFrame.totalText:SetPoint('BOTTOMLEFT', 16, 12)

mainFrame.buttons = {}
for i = 1, 2 do
   mainFrame.buttons[i] = CreateFrame('Button', nil, mainFrame)
   if i == 1 then
      mainFrame.buttons[i]:SetNormalTexture('Interface/Buttons/UI-SpellbookIcon-PrevPage-Up')
      mainFrame.buttons[i]:SetPushedTexture('Interface/Buttons/UI-SpellbookIcon-PrevPage-Down')
      mainFrame.buttons[i]:SetDisabledTexture('Interface/Buttons/UI-SpellbookIcon-PrevPage-Disabled')
      mainFrame.buttons[i]:SetPoint("BOTTOMRIGHT", -60, 6)
   else
      mainFrame.buttons[i]:SetNormalTexture('Interface/Buttons/UI-SpellbookIcon-NextPage-Up')
      mainFrame.buttons[i]:SetPushedTexture('Interface/Buttons/UI-SpellbookIcon-NextPage-Down')
      mainFrame.buttons[i]:SetDisabledTexture('Interface/Buttons/UI-SpellbookIcon-NextPage-Disabled')
   end
   mainFrame.buttons[i]:SetHighlightTexture('Interface/Buttons/UI-Common-MouseHilight', 'ADD')
   mainFrame.buttons[i]:SetSize(24, 24)
end

local settingsButton = CreateFrame('Button', nil, mainFrame, 'GameMenuButtonTemplate')
settingsButton:SetSize(74, 20)
settingsButton:SetPoint('RIGHT', mainFrame.buttons[1], 'LEFT', -10, 0)
settingsButton:SetText('Settings')

local itemName = ObliterumForgeFrame:CreateFontString()
itemName:SetFontObject("GameFontHighlight")
itemName:SetPoint('CENTER', ObliterumForgeFrame.ItemSlot, 'TOP', 0, 42)

local itemLevel = ObliterumForgeFrame:CreateFontString()
itemLevel:SetFontObject("GameFontHighlight")
itemLevel:SetPoint('TOP', itemName, 'BOTTOM', 0, -4)


local ashText = CreateFrame('Frame', nil, ObliterumForgeFrame)
ashText:SetSize(104, 24)
ashText:EnableMouse(true)
--ashText:SetPoint('LEFT', ObliterumForgeFrame.ItemSlot, 'RIGHT', 20, 0)
ashText:SetPoint('TOP', ObliterumForgeFrame.ItemSlot, 'BOTTOM', 0, -12)
ashText:Hide()

ashText.fs = ashText:CreateFontString()
ashText.fs:SetFontObject("GameFontHighlight")
ashText.fs:SetPoint('CENTER')

local ashTotalText = CreateFrame('Frame', nil, ashText)
ashTotalText:SetSize(104, 10)
ashTotalText:EnableMouse(true)
ashTotalText:SetPoint('TOP', ashText, 'BOTTOM', 0, 0)

ashTotalText.fs = ashTotalText:CreateFontString()
ashTotalText.fs:SetFontObject("GameFontHighlight")
ashTotalText.fs:SetPoint('CENTER')

ashText:SetScript('OnEnter', function()
    GameTooltip:SetOwner(ashText, "ANCHOR_TOPRIGHT")
    GameTooltip:AddLine('|cFFFF0000最少|r/|cFFFFAA00平均|r/|cFF00FF00最大|r 灰烬数.', 1, 1, 1)
    GameTooltip:AddLine('拆解至少3件物品才会显示.')
    GameTooltip:Show()
end)

ashText:SetScript('OnLeave', function()
    GameTooltip:Hide()
end)

ashTotalText:SetScript('OnEnter', function()
    GameTooltip:SetOwner(ashTotalText, "ANCHOR_TOPRIGHT")
    GameTooltip:AddLine('估算背包中所有此物品拆解后得到的灰烬总数.', 1, 1, 1)
    GameTooltip:AddLine('拆解至少3件物品才会显示.')
    GameTooltip:Show()
end)

ashTotalText:SetScript('OnLeave', function()
    GameTooltip:Hide()
end)

local ashTextToggle = CreateFrame('Button', nil, ObliterumForgeFrame)
ashTextToggle:SetPoint('CENTER', ObliterumForgeFrameInset, 'BOTTOMRIGHT', -20, 20)
ashTextToggle:SetSize(32, 32)

ashTextToggle.n = ashTextToggle:CreateTexture()
ashTextToggle.n:SetTexture("Interface\\common\\help-i")
ashTextToggle.n:SetAllPoints()

ashTextToggle.g = ashTextToggle:CreateTexture(nil, 'OVERLAY')
ashTextToggle.g:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
ashTextToggle.g:SetBlendMode("ADD")
ashTextToggle.g:SetAllPoints()
ashTextToggle.g:Hide()

ashTextToggle:SetScript('OnEnter', function(self)
    self.g:Show()
    GameTooltip:SetOwner(ashTextToggle, "ANCHOR_TOPRIGHT")
    GameTooltip:AddLine('放入物品时显示拆解结果.', 1, 1, 1)
    GameTooltip:Show()
end)

ashTextToggle:SetScript('OnLeave', function(self)
    self.g:Hide()
    GameTooltip:Hide()
end)

ashTextToggle:SetScript('OnClick', function(self)
    if saveData.addonSettings.showAshStats then
        saveData.addonSettings.showAshStats = false
        self.n:SetDesaturated(true)
        if itemName:IsVisible() then ashText:Hide() end
    else
        saveData.addonSettings.showAshStats = true
        self.n:SetDesaturated(false)
        if itemName:IsVisible() then ashText:Show() end
    end
    --self.g:Hide()
end)

local function hideSelection()
    if selectedButton then
        SetItemButtonDesaturated(getSelectedButton(), false)
        AnimatedShine_Stop(getSelectedButton())
        previousSelectedButton = selectedButton
        selectedButton = nil
    end
    itemName:Hide()
    itemLevel:Hide()
    
    ashText:Hide()
end

mainFrame.autoLoot = ObliterumForgeFrame:CreateFontString()
mainFrame.autoLoot:SetFontObject("GameFontHighlight")
mainFrame.autoLoot:SetText("自动拾取:")
mainFrame.autoLoot:SetPoint('LEFT', ObliterumForgeFramePortrait, 'RIGHT', 20, -20)

mainFrame.autoLootCheck = CreateFrame('CheckButton', nil, ObliterumForgeFrame, "UICheckButtonTemplate")
mainFrame.autoLootCheck:SetPoint('LEFT', mainFrame.autoLoot, 'RIGHT', 0, -2)
mainFrame.autoLootCheck:SetSize(28, 28)
mainFrame.autoLootCheck:SetScript('OnClick', function(self)
    if GetCVar('autoLootDefault') == '1' then
        DEFAULT_CHAT_FRAME:AddMessage('抑魔金助手：界面中启用自动拾取时，无法关闭此选项.')
        self:SetChecked(true)
    end
end)

mainFrame.autoLootCheck:SetScript('OnEnter', function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText('是否自动拾取抑魔金灰烬?')
    GameTooltip:Show()
end)

mainFrame.autoLootCheck:SetScript('OnLeave', function(self)
    GameTooltip:Hide()
end)

mainFrame.autoSelect = ObliterumForgeFrame:CreateFontString()
mainFrame.autoSelect:SetFontObject("GameFontHighlight")
mainFrame.autoSelect:SetText("自动选择:")
mainFrame.autoSelect:SetPoint('LEFT', mainFrame.autoLoot, 'RIGHT', 50, 0)

mainFrame.autoSelectCheck = CreateFrame('CheckButton', nil, ObliterumForgeFrame, "UICheckButtonTemplate")
mainFrame.autoSelectCheck:SetPoint('LEFT', mainFrame.autoSelect, 'RIGHT', 0, -2)
mainFrame.autoSelectCheck:SetSize(28, 28)
mainFrame.autoSelectCheck:SetScript('OnClick', function(self)
    if self:GetChecked() then
        autoSelect = true
        ashLooted = true
        --[[
        if not selectedButton then
            selectNextItem()
        end
        --]]
    else
        autoSelect = false
        ashLooted = true
        --C_TradeSkillUI.ClearPendingObliterateItem()
    end
end)

mainFrame.autoSelectCheck:SetScript('OnEnter', function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText('自动选择拆解下一件物品?\n|cFFFF0000注意: 小心不要拆解了你需要的装备!|r')
    GameTooltip:Show()
end)

mainFrame.autoSelectCheck:SetScript('OnLeave', function(self)
    GameTooltip:Hide()
end)

mainFrame.pageNumber = mainFrame:CreateFontString()
mainFrame.pageNumber:SetFontObject("GameFontHighlight")
mainFrame.pageNumber:SetText("1/1")
mainFrame.pageNumber:SetPoint('LEFT', mainFrame.buttons[1], 'RIGHT', 2, 0)
mainFrame.buttons[2]:SetPoint('LEFT', mainFrame.pageNumber, 'RIGHT', 4, 0)

--[[
mainFrame.statsButton = CreateFrame('Button', nil, mainFrame, 'GameMenuButtonTemplate')
mainFrame.statsButton:SetSize(110, 22)
mainFrame.statsButton:SetText('Statistics')
mainFrame.statsButton:SetPoint('BOTTOM', 0, 6)
-]]

local contentFrame = CreateFrame('ScrollFrame', nil, mainFrame)
contentFrame:SetSize(mainFrame:GetWidth()-16, 256-64+16)
contentFrame:SetPoint('TOP', 0, -24-16+16)
contentFrame:SetBackdrop({
      bgFile="Interface\\FrameGeneral\\UI-Background-Marble", 
      edgeFile='Interface/Tooltips/UI-Tooltip-Border', 
      tile = false, tileSize = 16, edgeSize = 16,
      insets = { left = 4, right = 4, top = 4, bottom = 4 }}
)
contentFrame:SetBackdropBorderColor(1, 1, 0, 1)

local ignoreTip = contentFrame:CreateFontString()
ignoreTip:SetFontObject("GameFonthighlight")
ignoreTip:SetText("右键点击物品忽略之")
ignoreTip:SetTextColor(0.9, 0.9, 0.9, 1)
ignoreTip:SetPoint('TOP', 0, -8)

local function showTooltip(self)
    if self.itemRef then
        if not eligibleItems[self.itemRef].ignore then
            GameTooltip:SetOwner(self, "ANCHOR_MOUSE");
            GameTooltip:SetHyperlink(eligibleItems[self.itemRef].itemLink)
            GameTooltip:AddLine('左键点击放入熔炉.', 1, 1, 1);
            GameTooltip:AddLine('右键点击忽略/取消忽略.', 1, 1, 1);
            GameTooltip:Show()
        else
            GameTooltip:SetOwner(self, "ANCHOR_MOUSE");
            GameTooltip:SetText(eligibleItems[self.itemRef].itemName)
            GameTooltip:AddLine('|cFFFFFFFF这件物品已被忽略.|r')
            GameTooltip:Show()        
        end
    end
end

local function hideTooltip(self)
   if self.itemRef then
      GameTooltip:Hide()
   end
end

local function addItemToForge(self, button)
    if not ashLooted then
        DEFAULT_CHAT_FRAME:AddMessage('抑魔金助手: 关闭拾取窗口.')
        CloseLoot()
        return
    end

    if self.itemRef then
        if button == 'LeftButton' then
            if not eligibleItems[self.itemRef].ignore then
                if selectedButton then
                    if selectedButton ~= self.itemRef then
                        hideSelection()
                        selectedButton = self.itemRef
                        UseContainerItem(eligibleItems[self.itemRef].bag, eligibleItems[self.itemRef].index)       
                    elseif selectedButton == self.itemRef then
                        C_TradeSkillUI.ClearPendingObliterateItem()
                    end
                else
                    selectedButton = self.itemRef
                    UseContainerItem(eligibleItems[self.itemRef].bag, eligibleItems[self.itemRef].index)
                end
                hideTooltip(self)
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) 
            end               
        elseif button == 'RightButton' then
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            if not eligibleItems[self.itemRef].ignore then
                --itemIgnoreList[eligibleItems[self.itemRef].itemLink] = true
                table.insert(itemIgnoreList, eligibleItems[self.itemRef].itemLink)
                --DEFAULT_CHAT_FRAME:AddMessage('Easy Obliterate: Added '..eligibleItems[self.itemRef].itemName..' to ignored items.')

                for i = 1, #itemButtons do
                    if itemButtons[i].itemRef then
                        if eligibleItems[itemButtons[i].itemRef].itemLink == eligibleItems[self.itemRef].itemLink then
                            itemButtons[i].IconBorder:SetVertexColor(0.5, 0.5, 0.5)
                            SetItemButtonDesaturated(itemButtons[i], true)
                            eligibleItems[itemButtons[i].itemRef].ignore = true
                            itemButtons[i].ignoredTexture:Show()
                        end
                    end
                end
            elseif eligibleItems[self.itemRef].ignore then
                local k = inIgnoreList(eligibleItems[self.itemRef].itemLink)
                if k then
                    table.remove(itemIgnoreList, k)
                    --DEFAULT_CHAT_FRAME:AddMessage('Easy Obliterate: Removed '..eligibleItems[self.itemRef].itemName..' from ignored items.')
                    for i = 1, #itemButtons do
                        if itemButtons[i].itemRef then
                            if eligibleItems[itemButtons[i].itemRef].itemLink == eligibleItems[self.itemRef].itemLink then
                                SetItemButtonQuality(itemButtons[i], eligibleItems[itemButtons[i].itemRef].itemQuality, eligibleItems[itemButtons[i].itemRef].itemLink)
                                SetItemButtonDesaturated(itemButtons[i], false)
                                itemButtons[i].ignoredTexture:Hide()                                
                            end
                        end
                    end
                end               
            end
            getEligibleItems()
            updateItemButtons(true)
            if GameTooltip:IsVisible() then showTooltip(self) end
        end     
    end
end

local function createItemButton(i)
    local frame = CreateFrame('Button', 'EasyObliterateItemButton'..i, contentFrame, "ItemButtonTemplate")
    frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    frame.bg = frame:CreateTexture(nil, 'BACKGROUND')
    frame.bg:SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled")
    frame.bg:SetSize(54, 54)
    frame.bg:SetPoint('CENTER')

    frame.shine = CreateFrame('Frame', frame:GetName().."Shine", frame, "AnimatedShineTemplate")
    frame.shine:SetAllPoints()

    frame.glow = frame:CreateTexture(nil, 'OVERLAY')
    frame.glow:SetColorTexture(1, 1, 1, 0.8)
    frame.glow:SetAllPoints()
    frame.glow:SetAlpha(0)

    frame.glowAnimation = frame.glow:CreateAnimationGroup()
    frame.glowAnimation[1] = frame.glowAnimation:CreateAnimation("Alpha")
    frame.glowAnimation[1]:SetDuration(0.2)
    frame.glowAnimation[1]:SetFromAlpha(0.8)
    frame.glowAnimation[1]:SetToAlpha(0)
    frame.glowAnimation[1]:SetOrder(1)
    
    frame.ignoredTexture = frame:CreateTexture(nil, 'OVERLAY')
    frame.ignoredTexture:SetTexture("Interface\\PetBattles\\DeadPetIcon")
    frame.ignoredTexture:SetSize(12, 12)
    frame.ignoredTexture:SetAlpha(0.8)
    frame.ignoredTexture:SetPoint('TOPLEFT', 1, -1)
  
    frame.itemRef = nil

    frame:SetScript('OnEnter', showTooltip)
    frame:SetScript('OnLeave', hideTooltip)
    frame:SetScript('OnClick', addItemToForge)

    return frame
end

--ItemButtons
for i = 0, 27 do
   local spacing = math.floor(((contentFrame:GetWidth()-16)-(7*32))/7)
   local perRow = 7
   local maxRows = 4
   local x = 16 + i%perRow*(32+spacing)
   local y = -30 - math.floor(i/7)*42
   
   itemButtons[i+1] = createItemButton(i+1)
   itemButtons[i+1]:SetSize(32, 32)     
   itemButtons[i+1]:SetPoint('TOPLEFT', x, y)
end

local function getMaxPage()
    local maxPage = math.ceil(#eligibleItems/#itemButtons)
    if maxPage == 0 then maxPage = 1 end
    return maxPage
end

local function updateText()
   mainFrame.totalText:SetText("总共: "..#eligibleItems)
   mainFrame.pageNumber:SetText(currentPage.."/"..getMaxPage())
end

local function updatePageButtons()
   if currentPage == getMaxPage() then
      mainFrame.buttons[2]:Disable()
   else
      mainFrame.buttons[2]:Enable()
   end
   
   if currentPage == 1 then
      mainFrame.buttons[1]:Disable()
   else
      mainFrame.buttons[1]:Enable()
   end
end

local function updateContentFrame()
    if currentPage > getMaxPage() then
        currentPage = getMaxPage()
    end
    updateItemButtons()
    updateText()
    updatePageButtons()
end

local function populateFrame()
    getEligibleItems()  
    updateContentFrame()
    if autoSelect and ashLooted then
        selectNextItem()
    end
end

mainFrame.buttons[1]:SetScript('OnClick', function()
    C_TradeSkillUI.ClearPendingObliterateItem() 
    currentPage = currentPage - 1      
    updateContentFrame()
end)

mainFrame.buttons[2]:SetScript('OnClick', function()
    C_TradeSkillUI.ClearPendingObliterateItem()  
    currentPage = currentPage + 1
    updateContentFrame()
end)

local function showSelection()
    local link = C_TradeSkillUI.GetPendingObliterateItemLink()
    if link then     
        if not selectedButton or eligibleItems[getSelectedButton().itemRef].itemLink ~= link then
            for i = 1, #itemButtons do
                if eligibleItems[itemButtons[i].itemRef].itemLink == link then
                    if selectedButton then hideSelection() end
                    selectedButton = i
                    break
                end
            end
        end
        
        itemName:SetText(link)
        local _,_,_, iLvl = GetItemInfo(link)
        itemLevel:SetText(iLvl)
        itemName:Show()
        itemLevel:Show()
        

        
        local totalCount = 0
        for i = 1, #eligibleItems do
            if eligibleItems[i].itemLink == link then
                totalCount = totalCount + eligibleItems[i].itemCount
            end
        end
        
        if saveData.ashStats[C_TradeSkillUI.GetPendingObliterateItemID()] and saveData.ashStats[C_TradeSkillUI.GetPendingObliterateItemID()][iLvl] and totalCount > 0 then
            if saveData.ashStats[C_TradeSkillUI.GetPendingObliterateItemID()][iLvl].obliterateCount >= 3 then
                local itemID = C_TradeSkillUI.GetPendingObliterateItemID()
                --ashText.fs:SetText('= '..string.format("%.2f", saveData.ashStats[itemID][iLvl].averageAsh)..' ('..string.format("%.2f", (saveData.ashStats[itemID][iLvl].averageAsh*totalCount))..')')
                --ashText.fs:SetText(saveData.ashStats[itemID][iLvl].minAsh..' - '..saveData.ashStats[itemID][iLvl].maxAsh)
                
                ashTotalText.fs:SetText('('..string.format("%.1f", (saveData.ashStats[itemID][iLvl].averageAsh*totalCount))..')')
                ashText.fs:SetText('|cFFFF0000'..saveData.ashStats[itemID][iLvl].minAsh..'|r'..'/'..'|cFFFFAA00'..string.format("%.1f", saveData.ashStats[itemID][iLvl].averageAsh)..'|r'..'/'..'|cFF00FF00'..saveData.ashStats[itemID][iLvl].maxAsh..'|r')
            else
                ashTotalText.fs:SetText('(?)')
                ashText.fs:SetText('|cFFFF0000?|r/|cFFFFAA00?|r/|cFF00FF00?|r')               
            end
        else
            ashTotalText.fs:SetText('(?)')
            ashText.fs:SetText('|cFFFF0000?|r/|cFFFFAA00?|r/|cFF00FF00?|r')
        end
        
        if saveData.addonSettings.showAshStats then
            ashText:Show()
        end


        
        AnimatedShine_Start(getSelectedButton(), 1, 1, 0.4)
        SetItemButtonDesaturated(getSelectedButton(), true)
        
        currentItem.itemID = C_TradeSkillUI.GetPendingObliterateItemID()
        currentItem.itemLevel = iLvl
    else
        mainFrame:RegisterEvent('GET_ITEM_INFO_RECEIVED');
        dprint('Awaiting GET_ITEM_INFO_RECEIVED')
    end
end

local function cleanMinAsh100Stats()
    if not saveData.ashStats then return end

    EA_itemsRemoved = {}
    for itemID, itemLevels in pairs(saveData.ashStats) do
        for itemLevel, ashStats in pairs(saveData.ashStats[itemID]) do
            if ashStats.minAsh == 100 then
                table.insert(EA_itemsRemoved, {itemID = itemID, itemLevel = itemLevel})
                saveData.ashStats[itemID][itemLevel] = nil
                GetItemInfo(itemID)
            end
        end
    end
    
    --Removed items that may have bugged stats if none then user was unnafected and doesn't need to know.
    if #EA_itemsRemoved > 0 then
        StaticPopup_Show("EasyObliterate_MinAsh100Bug")
    end
end

local function cleanMinAsh0Stats()
    if not saveData.ashStats then return end

    EA_itemsRemoved = {}
    for itemID, itemLevels in pairs(saveData.ashStats) do
        for itemLevel, ashStats in pairs(saveData.ashStats[itemID]) do
            if ashStats.minAsh == 0 then
                table.insert(EA_itemsRemoved, {itemID = itemID, itemLevel = itemLevel})
                saveData.ashStats[itemID][itemLevel] = nil
                GetItemInfo(itemID)
            end
        end
    end
    
    --Removed items that may have bugged stats if none then user was unnafected and doesn't need to know.
    if #EA_itemsRemoved > 0 then
        StaticPopup_Show("EasyObliterate_MinAsh0Bug")
    end
end

local function updateAshStats(itemID, itemLevel, ashCount)
    if not itemID or not itemLevel or not ashCount then return end
    ashCount = tonumber(ashCount)
    
    if ashCount <= 0 then 
        if saveData.addonSettings.show0AshMessage then
            if first0AshMessage then
                DEFAULT_CHAT_FRAME:AddMessage('Easy Obliterate: Unable to determine amount of ash looted. Are you using an addon that affects the looting process? You can |cFFFF0000disable|r these messages in Easy Obliterate settings.')
                first0AshMessage = false
            else
                 DEFAULT_CHAT_FRAME:AddMessage('Easy Obliterate: Unable to determine amount of ash looted, stats not updated.')           
            end
        end
        return 
    end
    
    if not saveData.ashStats[itemID] then saveData.ashStats[itemID] = {} end
    if not saveData.ashStats[itemID][itemLevel] then saveData.ashStats[itemID][itemLevel] = {minAsh = ashCount, maxAsh = ashCount, averageAsh = 0, obliterateCount = 0} end
    
    if ashCount < saveData.ashStats[itemID][itemLevel].minAsh then saveData.ashStats[itemID][itemLevel].minAsh = ashCount end
    if ashCount > saveData.ashStats[itemID][itemLevel].maxAsh then saveData.ashStats[itemID][itemLevel].maxAsh = ashCount end
    
    saveData.ashStats[itemID][itemLevel].averageAsh = ((saveData.ashStats[itemID][itemLevel].averageAsh*saveData.ashStats[itemID][itemLevel].obliterateCount)+ashCount)/(saveData.ashStats[itemID][itemLevel].obliterateCount + 1)
    saveData.ashStats[itemID][itemLevel].obliterateCount = saveData.ashStats[itemID][itemLevel].obliterateCount + 1
end

local function createDefaultSettings()
    dprint('SETTING SETTINGS TO DEFAULT!')
    saveData.addonSettings = defaultSettings
end

local function createSaveData()
    dprint('Creating save data.')
    saveData = {}
    saveData.ashStats = {}
    createDefaultSettings()
end

local function updateAddonSettings()
    dprint('Updating settings.')
    for k,v in pairs(defaultSettings) do
        if saveData.addonSettings[k] == nil then saveData.addonSettings[k] = v dprint('Added ['..k..'] with default value') end
    end
end

mainFrame:SetScript('OnEvent', function(self, event, ...)
    dprint(event)
    if event == 'BAG_UPDATE_DELAYED' then       
        populateFrame()       
    elseif event == 'LOOT_OPENED' then
        local lootIcon, _, lootQuantity = GetLootSlotInfo(1)
        if lootIcon == 1341655 or lootIcon == 1455891 or lootIcon == 1455894 then --pvp tokens
            lastItem.ashAmount = lootQuantity
            if mainFrame.autoLootCheck:GetChecked() then
                LootSlot(1)
                --CloseLoot()
            end  
        end    
    elseif event == 'CHAT_MSG_LOOT' or event == 'CHAT_MSG_CURRENCY' then
        local lootstring = ...
        if event == 'CHAT_MSG_LOOT' then
            local itemID = string.match(lootstring, "Hitem:(%d+):")
            if itemID == '136342' and not ashLooted then
                ashLooted = true
                updateAshStats(lastItem.itemID, lastItem.itemLevel, lastItem.ashAmount)
            end
        elseif event == 'CHAT_MSG_CURRENCY' then
            local currencyID = string.match(lootstring, "Hcurrency:(%d+)")
            if (currencyID == '1356' or currencyID == '1357') and not ashLooted then
                ashLooted = true
            end
        end
    elseif event == 'OBLITERUM_FORGE_PENDING_ITEM_CHANGED' then
        if C_TradeSkillUI.GetPendingObliterateItemLink() then
            if not inIgnoreList(C_TradeSkillUI.GetPendingObliterateItemLink()) then
                showSelection()
            else
                C_TradeSkillUI.ClearPendingObliterateItem()
                DEFAULT_CHAT_FRAME:AddMessage('抑魔金助手: 此物品已被忽略!')
            end
        else
            hideSelection()
        end
    elseif event == 'UNIT_SPELLCAST_START' then
        local unitTag, spellName, rank, lineID, spellID = ...
        --If we're obliterating store the currently selected item and the lineid
        if spellID == C_TradeSkillUI.GetObliterateSpellID() then
            currentLineID = lineID
            
            ObliterumForgeFrame.ObliterateButton:Disable()
        end
    elseif event == 'UNIT_SPELLCAST_INTERRUPTED' then
        local unitTag, spellName, rank, lineID, spellID = ...
        if lineID == currentLineID and spellID == C_TradeSkillUI.GetObliterateSpellID() then
            curentLineID = nil
            ObliterumForgeFrame.ObliterateButton:Enable()
        end
    elseif event == 'UNIT_SPELLCAST_SUCCEEDED' then
        local unitTag, spellName, rank, lineID, spellID = ...
        if lineID == currentLineID and spellID == C_TradeSkillUI.GetObliterateSpellID() then   
            lastItem.itemID = currentItem.itemID
            lastItem.itemLevel = currentItem.itemLevel
            lastItem.ashAmount = 0
        
            if not ashLooted then
                --This should never happen it means we never received our ash. Bug with the fel forge, I'm pretty sure it's not caused by Easy Obliterate.
                StaticPopup_Show ("EasyObliterate_AshNotFound")
            end
            
            ashLooted = false
        end
    elseif event == 'GET_ITEM_INFO_RECEIVED' then
		self:UnregisterEvent('GET_ITEM_INFO_RECEIVED')
        showSelection()
    elseif event == 'ADDON_LOADED' then
        local name = ...
        if name == 'Easy_Obliterate' then
            if EasyObliterate_Data then
                dprint('Easy Obliterate: Loaded _DATA')
                saveData = EasyObliterate_Data
             
                if saveData.addonVersion == 16 then
                    saveData.ashStats = {}
                    StaticPopup_Show ("EasyObliterate_AshStatsWiped")
                end
                
                if saveData.addonVersion < 28 then
                    --See if user is affected by minAsh bug and inform if so and clean items with 100 minAsh
                    cleanMinAsh100Stats()
                end
                
                if saveData.addonVersion < 29 then
                    --See if user is affected by minAsh bug and inform if so and clean items with 100 minAsh
                    cleanMinAsh0Stats()
                end
                
                if not saveData.addonSettings then
                    createDefaultSettings()
                end
                
                if saveData.addonVersion < addonVersion then
                    updateAddonSettings()
                end
                
            else
                createSaveData()        
            end
            
           if EasyObliterate_IgnoreList then 
                dprint('Easy Obliterate: IgnoreList found')
                itemIgnoreList = EasyObliterate_IgnoreList
            else
                dprint('Easy Obliterate: IgnoreList CREATED')
                itemIgnoreList = {}
            end
            
            mainFrame:UnregisterEvent('ADDON_LOADED')
        end
    elseif event == 'PLAYER_LOGOUT' then
        saveData.addonVersion = addonVersion
        EasyObliterate_Data = saveData
        EasyObliterate_IgnoreList = itemIgnoreList
    end
end)

savedOnShow = ObliterumForgeFrame:GetScript('OnShow')
savedOnHide = ObliterumForgeFrame:GetScript('OnHide')
mainFrame:RegisterEvent('ADDON_LOADED')
mainFrame:RegisterEvent('PLAYER_LOGOUT')

ObliterumForgeFrame:SetScript('OnShow', function(self)
    savedOnShow(self)
    mainFrame:RegisterEvent('BAG_UPDATE_DELAYED')
    mainFrame:RegisterEvent('LOOT_OPENED')
    mainFrame:RegisterEvent('CHAT_MSG_LOOT')
    mainFrame:RegisterEvent('CHAT_MSG_CURRENCY')
    mainFrame:RegisterEvent('OBLITERUM_FORGE_PENDING_ITEM_CHANGED')
    mainFrame:RegisterUnitEvent('UNIT_SPELLCAST_SUCCEEDED', 'player')
    mainFrame:RegisterUnitEvent('UNIT_SPELLCAST_START', 'player')
    mainFrame:RegisterUnitEvent('UNIT_SPELLCAST_INTERRUPTED', 'player')

    currentPage = 1
    hideSelection()
    
    showGetItemError = true
    populateFrame()
    
    if GetCVar('autoLootDefault') == '1' then
        mainFrame.autoLootCheck:SetChecked(true)
    end
    
    ashLooted = true
    autoSelect = false
    mainFrame.autoSelectCheck:SetChecked(false)
    previousSelectedButton = nil
    selectedButton = nil
    
    if saveData.addonSettings.showAshStats then
        ashTextToggle.n:SetDesaturated(false)
    else
        ashTextToggle.n:SetDesaturated(true)
    end
end)

ObliterumForgeFrame:SetScript('OnHide', function(self)
      savedOnHide(self)
      mainFrame:UnregisterEvent('BAG_UPDATE_DELAYED')
      mainFrame:UnregisterEvent('LOOT_OPENED')
      mainFrame:UnregisterEvent('CHAT_MSG_LOOT')
      mainFrame:UnregisterEvent('CHAT_MSG_CURRENCY')
      mainFrame:UnregisterEvent('OBLITERUM_FORGE_PENDING_ITEM_CHANGED')
      mainFrame:UnregisterEvent('UNIT_SPELLCAST_SUCCEEDED')
      mainFrame:UnregisterEvent('UNIT_SPELLCAST_START')
      mainFrame:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED')
end)

BINDING_HEADER_EASYOBLITERATEHEAD = "Easy Obliterate"
_G["BINDING_NAME_CLICK EasyObliterate:LeftButton"] = "Obliterate Item"
if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    BINDING_HEADER_EASYOBLITERATEHEAD = "抑魔金助手"
    _G["BINDING_NAME_CLICK EasyObliterate:LeftButton"] = "分解物品"
end

local b = CreateFrame('Button', 'EasyObliterate', nil, 'SecureActionButtonTemplate')
b:SetAttribute('type', 'click')
b:SetAttribute('clickbutton', ObliterumForgeFrame.ObliterateButton)

StaticPopupDialogs["EasyObliterate_AshNotFound"] = {
   text = 'Easy Obliterate\n\n It seems you did not receive ash from your previous item. If this keeps happening try relogging or restarting the game.',
   button1 = "Ok",
   timeout = 0,
   whileDead = true,
   hideOnEscape = true,
   preferredIndex = 3,
}

StaticPopupDialogs["EasyObliterate_MinAsh100Bug"] = {
    text = 'Easy Obliterate\n\n Due to a bug, items that always yield more than 100 ash have been showing lower average ash stats than they should\'ve. The stats for these items have been reset, would you like to see which items were affected?',
    button1 = "Yes",
    button2 = "No",
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnAccept = function()
        if EA_itemsRemoved then
            DEFAULT_CHAT_FRAME:AddMessage('--Easy Obliterate--')
            for i = 1, #EA_itemsRemoved do
                local itemName = GetItemInfo(EA_itemsRemoved[i].itemID)
                if itemName then
                    DEFAULT_CHAT_FRAME:AddMessage(itemName..'(iLvL '..EA_itemsRemoved[i].itemLevel..')')
                else
                    DEFAULT_CHAT_FRAME:AddMessage('Failed to retrieve item name for itemID: '..EA_itemsRemoved[i].itemID)
                end
            end    
            DEFAULT_CHAT_FRAME:AddMessage('--Easy Obliterate--')
        end
    end
}

StaticPopupDialogs["EasyObliterate_MinAsh0Bug"] = {
    text = 'Easy Obliterate\n\n Addons that affect the looting process sometimes caused Easy Obliterate to register 0 ash for items obliterated. The stats for these items have been reset, would you like to see which items were affected?',
    button1 = "Yes",
    button2 = "No",
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnAccept = function()
        if EA_itemsRemoved then
            DEFAULT_CHAT_FRAME:AddMessage('--Easy Obliterate--')
            for i = 1, #EA_itemsRemoved do
                local itemName = GetItemInfo(EA_itemsRemoved[i].itemID)
                if itemName then
                    DEFAULT_CHAT_FRAME:AddMessage(itemName..'(iLvL '..EA_itemsRemoved[i].itemLevel..')')
                else
                    DEFAULT_CHAT_FRAME:AddMessage('Failed to retrieve item name for itemID: '..EA_itemsRemoved[i].itemID)
                end
            end    
            DEFAULT_CHAT_FRAME:AddMessage('--Easy Obliterate--')
        end
    end
}

StaticPopupDialogs["EasyObliterate_AshStatsWiped"] = {
   text = 'Easy Obliterate\n\n Due to a bug, ash stats were sometimes calculated the wrong way when you were close to 1000 ash in your bags. Ash stats have been reset for that reason, sorry for the inconvience.',
   button1 = "Ok",
   timeout = 0,
   editBoxWidth = 350,
   whileDead = true,
   hideOnEscape = true,
   preferredIndex = 3,
}

local function tooltipText(tooltip)
    if saveData.addonSettings.showTooltip then
        local itemName, hyperLink = tooltip:GetItem()
        if hyperLink then
            local itemID = string.match(hyperLink, "Hitem:(%d+):")
            if saveData.ashStats[tonumber(itemID)] then
                local _,_,_, itemLevel = GetItemInfo(hyperLink)
                local ashCount = getAshForItemID(itemID, itemLevel)
                if ashCount > 0 then
                    local ashText = saveData.addonSettings.ashTextLocalized
                    if not ashText then
                        --136342
                        local localName = GetItemInfo(136342)
                        if localName then
                            saveData.addonSettings.ashTextLocalized = localName
                            ashText = localName
                        else
                            ashText = backupAshText
                        end
                    end
                    
                    tooltip:AddLine('|cffffffff'..ashText..':|r |cFF19ff19'..string.format("%.1f", ashCount)..'|r |T'..(1341655)..':0|t')  
                    --1341655      
                    --1341656
                end
            end
        end
    end
end

GameTooltip:HookScript("OnTooltipSetItem", function(self) tooltipText(self) end)
ItemRefTooltip:HookScript("OnTooltipSetItem", function(self) tooltipText(self) end)


local optionsFrame = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
optionsFrame.name = 'Easy Obliterate'

optionsFrame.title = optionsFrame:CreateFontString()
optionsFrame.title:SetPoint('TOPLEFT', 16, -16)
optionsFrame.title:SetFontObject('GameFontNormalLarge')
optionsFrame.title:SetText('抑魔金助手')

optionsFrame.subText = optionsFrame:CreateFontString()
optionsFrame.subText:SetFontObject('GameFontHighlightSmall')
optionsFrame.subText:SetText('抑魔金助手设置')
optionsFrame.subText:SetPoint('TOPLEFT', optionsFrame.title, 'BOTTOMLEFT', 0, -12)

optionsFrame.showTooltip = CreateFrame('CheckButton', nil, optionsFrame, 'UICheckButtonTemplate')
optionsFrame.showTooltip:SetSize(32, 32)
optionsFrame.showTooltip:SetPoint('TOPLEFT', optionsFrame.subText, 'BOTTOMLEFT', 0, -24)

optionsFrame.showTooltip.text = optionsFrame.showTooltip:CreateFontString()
optionsFrame.showTooltip.text:SetFontObject('GameFontNormal')
optionsFrame.showTooltip.text:SetText('鼠标提示中显示抑魔金灰烬的信息.')
optionsFrame.showTooltip.text:SetPoint('LEFT', 36, 0)

optionsFrame.showTooltip:SetScript('OnClick', function()
    saveData.addonSettings.showTooltip = not saveData.addonSettings.showTooltip
end)

optionsFrame.ignoreWardrobeItems = CreateFrame('CheckButton', nil, optionsFrame, 'UICheckButtonTemplate')
optionsFrame.ignoreWardrobeItems:SetSize(32, 32)
optionsFrame.ignoreWardrobeItems:SetPoint('TOPLEFT', optionsFrame.subText, 'BOTTOMLEFT', 0, -54)

optionsFrame.ignoreWardrobeItems.text = optionsFrame.ignoreWardrobeItems:CreateFontString()
optionsFrame.ignoreWardrobeItems.text:SetFontObject('GameFontNormal')
optionsFrame.ignoreWardrobeItems.text:SetText('Hide items used in an equipment set.')
optionsFrame.ignoreWardrobeItems.text:SetPoint('LEFT', 36, 0)

optionsFrame.ignoreWardrobeItems:SetScript('OnClick', function()
    saveData.addonSettings.ignoreWardrobeItems = not saveData.addonSettings.ignoreWardrobeItems
    if ObliterumForgeFrame:IsVisible() then
        populateFrame()
    end
end)

optionsFrame.show0AshMessage = CreateFrame('CheckButton', nil, optionsFrame, 'UICheckButtonTemplate')
optionsFrame.show0AshMessage:SetSize(32, 32)
optionsFrame.show0AshMessage:SetPoint('TOPLEFT', optionsFrame.subText, 'BOTTOMLEFT', 0, -84)

optionsFrame.show0AshMessage.text = optionsFrame.show0AshMessage:CreateFontString()
optionsFrame.show0AshMessage.text:SetFontObject('GameFontNormal')
optionsFrame.show0AshMessage.text:SetText('Show message informing you Easy Obliterate was unable to determine ash quantity.')
optionsFrame.show0AshMessage.text:SetPoint('LEFT', 36, 0)

optionsFrame.show0AshMessage:SetScript('OnClick', function()
    saveData.addonSettings.show0AshMessage = not saveData.addonSettings.show0AshMessage
end)

optionsFrame.keyBindingsButton = CreateFrame('Button', nil, optionsFrame, 'GameMenuButtonTemplate')
optionsFrame.keyBindingsButton:SetSize(128, 32)
optionsFrame.keyBindingsButton:SetPoint('TOPLEFT', optionsFrame.show0AshMessage, 'BOTTOMLEFT', 0, -12)
optionsFrame.keyBindingsButton:SetText('Keybinding')
optionsFrame.keyBindingsButton:SetScript('OnClick', function()
    InterfaceOptionsFrame:Hide()
    LoadAddOn("Blizzard_BindingUI")
    KeyBindingFrame:Show()
    KeyBindingFrameCategoryListButton11:Click()
end)
    
optionsFrame:SetScript("OnShow", function()
    if saveData.addonSettings.showTooltip then
        optionsFrame.showTooltip:SetChecked(true)
    else
        optionsFrame.showTooltip:SetChecked(false)
    end
    
    if saveData.addonSettings.ignoreWardrobeItems then
        optionsFrame.ignoreWardrobeItems:SetChecked(true)
    else
        optionsFrame.ignoreWardrobeItems:SetChecked(false)
    end
    
    optionsFrame.show0AshMessage:SetChecked(saveData.addonSettings.show0AshMessage)
end)

InterfaceOptions_AddCategory(optionsFrame)

SLASH_EASYOBLITERATE1 = '/easyobliterate'
SlashCmdList['EASYOBLITERATE'] = function() InterfaceOptionsFrame_OpenToCategory(optionsFrame) InterfaceOptionsFrame_OpenToCategory(optionsFrame) end
settingsButton:SetScript('OnClick', function() InterfaceOptionsFrame_OpenToCategory(optionsFrame) InterfaceOptionsFrame_OpenToCategory(optionsFrame) end)
