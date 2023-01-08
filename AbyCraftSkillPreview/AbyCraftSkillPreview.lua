local FrameName, private = ...
local L = private.L

local function getPreviewFrame()
    return _G[FrameName]
end

--ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm
local function updateSkillPoint(changeEditBox)
    local ct = getPreviewFrame()
    if ct.initializing or ct.adjusting then return end

    local allEqual = true
    local reagents = {}
    for i = 1, #ct.edits do
        if ct.edits[i][1]:IsVisible() then
            local numText = ct.edits[i][3].numText

            --先自动减去其他的
            local diff, current = -numText.quantity, false
            for j = 1, 3 do
                if ct.edits[i][j] == changeEditBox then current = true end
                diff = diff + (ct.edits[i][j]:GetValue() or 0)
            end
            if current and diff > 0 then
                ct.adjusting = true
                for j = 1, 3 do
                    local edit = ct.edits[i][j]
                    if edit ~= changeEditBox and edit:GetValue() > 0 then
                        local change = min(edit:GetValue(), diff)
                        edit:SetValue(edit:GetValue() - change)
                        diff = diff - change
                        if diff == 0 then break end
                    end
                end
                ct.adjusting = nil
            end

            --生成配方table, 并判断是否能计算, 不能计算的时候配方table用不到
            local total = 0
            for j = 1, 3 do
                local edit = ct.edits[i][j]
                local quantity = edit:GetValue()
                if quantity and quantity > 0 then
                    total = total + quantity
                    --@see Blizzard_ProfessionsTransaction.lua ProfessionsRecipeTransactionMixin:CreateCraftingReagentInfoTblIf(predicate)
                    local craftingReagentInfo = Professions.CreateCraftingReagentInfo(edit.itemID, edit.dataSlotIndex, quantity);
                    table.insert(reagents, craftingReagentInfo);
                end
            end
            local equal = total == numText.quantity
            numText:SetFormattedText(equal and "|cff00ff00%d/%d|r" or "|cffff0000%d/%d|r", total, numText.quantity)
            allEqual = allEqual and equal
        end
    end

    ct.toggle.text:SetText(L["Quantity Mismatch"])
    if allEqual then
        local self = ct.form
        --@see Blizzard_ProfessionsRecipeSchematicForm.lua ProfessionsRecipeSchematicFormMixin:GetRecipeOperationInfo()
        local recipeInfo = self.currentRecipeInfo;
        if recipeInfo then
            if self.recipeSchematic.hasCraftingOperationInfo then
                local recraftItemGUID, recraftOrderID = self.transaction:GetRecraftAllocation();
                local craftingReagents = reagents --self.transaction:CreateCraftingReagentInfoTbl()
                local opInfo
                if recraftOrderID then
                    opInfo = C_TradeSkillUI.GetCraftingOperationInfoForOrder(recipeInfo.recipeID, craftingReagents, recraftOrderID);
                else
                    opInfo = C_TradeSkillUI.GetCraftingOperationInfo(recipeInfo.recipeID, craftingReagents, self.transaction:GetAllocationItemGUID());
                end
                ct.toggle.text:SetFormattedText("%s |cff00ff00%d|r", L["Estimate Skill"], opInfo.baseSkill + opInfo.bonusSkill)
            end
        end
    end
end

local function togglePreview(hideToggle)
    local ct = getPreviewFrame()
    ct.toggle:SetShown(not hideToggle)
    local show = ct.toggle:GetChecked() and not hideToggle
    ct:SetShown(show)
    ct.toggle.text:SetFont(ct.toggle.text:GetFont(), show and L.TitleFontSize or 15, "")
    if show then
        updateSkillPoint()
    else
        ct.toggle.text:SetText(L["Try Reagents"])
    end
    if ct.form then
        local slots = ct.form.reagentSlots
        slots = slots and slots[Enum.CraftingReagentType.Basic]
        for i, slot in ipairs(slots or {}) do
            local alpha = ct.edits and ct.edits[i][1]:IsVisible() and 0 or 1
            slot.Name:SetAlpha(alpha)
            slot.Checkmark:SetAlpha(alpha)
        end
    end
end

local function createEdit(ct, i, j)
    local edit = CreateFrame("EditBox", nil, ct, "NumericInputSpinnerTemplate")
    ct.edits[i][j] = edit
    edit:SetScript("OnEnter", function(self)
        if self.itemID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetItemByID(self.itemID);
            GameTooltip:Show();
        end
    end)
    edit:SetScript("OnLeave", function()
        GameTooltip:Hide();
    end)
    edit:SetOnValueChangedCallback(updateSkillPoint)
    edit.DecrementButton:ClearAllPoints() edit.DecrementButton:SetPoint("TOPLEFT", edit, "BOTTOMLEFT", -7, 2)
    edit.IncrementButton:ClearAllPoints() edit.IncrementButton:SetPoint("TOPRIGHT", edit, "BOTTOMRIGHT", 3, 2)
    if j == 3 then
        edit.numText = edit:CreateFontString()
        edit.numText:SetFontObject(ChatFontSmall)
        edit.numText:SetPoint("TOPLEFT", edit, "TOPRIGHT", 5, -4)
    end
    return edit
end

local function setup()
    local ct = CreateFrame("Frame", FrameName, UIParent)
    ct.toggle = CreateFrame("CheckButton", nil, nil, "UICheckButtonTemplate")
    ct.toggle:SetScale(0.8)
    ct.toggle:SetScript("OnClick", function() togglePreview() end)
    ct.toggle:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if Locale_zhCN then
            GameTooltip:SetText("说明")
            GameTooltip:AddLine("本功能由warbaby(爱不易)原创开发")
            GameTooltip:AddLine("用于查看不同品质的材料对配方技能的影响")
            GameTooltip:AddLine("注意：不包括卓然洞悉等附加的技能")
            GameTooltip:AddLine("制作时一定要看右侧<制作详情>中的实际技能，如因插件错误导致损失，恕不负责。", nil, nil, nil, true)
        else
            GameTooltip:SetText(FrameName)
            GameTooltip:AddDoubleLine(" ", "by warbaby")
        end
            GameTooltip:Show();
    end)
    ct.toggle:SetScript("OnLeave", function()
        GameTooltip:Hide();
    end)

    ct.maxLevel = ct:CreateFontString()
    ct.maxLevel:SetFontObject(GameFontHighlightSmall)

    ct.edits = {}

    local function hookFormInit(self)
        if not self:IsVisible() then return end
        ct.form = self
        ct:SetParent(ct.form)
        ct.toggle:SetParent(ct.form)
        ct.toggle:SetPoint("LEFT", ct.form.Reagents.Label, "LEFT", 90, -1)
        ct.maxLevel:SetParent(ct.form)
        ct.maxLevel:SetPoint("TOPLEFT", 85, -12)

        ------ 不相干的一个功能 ------
        if Locale_zhCN then
            local maxTrivialLevel = self.currentRecipeInfo and self.currentRecipeInfo.maxTrivialLevel
            if maxTrivialLevel and maxTrivialLevel > 0 then
                ct.maxLevel:SetFormattedText("（技能提升上限：|cff00ff00%d|r）", maxTrivialLevel)
            else
                ct.maxLevel:SetText("")
            end
        end
        ---------------------------

        local slots = self.reagentSlots and self.reagentSlots[Enum.CraftingReagentType.Basic] or {}
        local edits = ct.edits
        local needPreview = false
        ct.initializing = true

        for i, slot in ipairs(slots) do
            local schema = slot:GetReagentSlotSchematic()
            edits[i] = edits[i] or {}
            for j = 1, 3 do
                local edit = edits[i][j] or createEdit(ct, i, j)
                if j == 1 then
                    edit:SetPoint("TopLeft", slot.Button, "TopRight", 18, -1)
                else
                    edit:SetPoint("TopLeft", edits[i][j-1], "TopRight", 15, 0)
                end

                local showChoice = schema and schema.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent
                edit:SetShown(showChoice)
                if showChoice then
                    needPreview = true
                    local num = schema.quantityRequired
                    edit:SetMinMaxValues(0, num);
                    edit:SetValue(j==2 and num or 0)
                    edit.dataSlotIndex = schema.dataSlotIndex
                    edit.itemID = schema.reagents[j].itemID
                end
            end

            local numText = edits[i][3].numText
            numText.quantity = schema.quantityRequired
            numText:SetFormattedText("|cff00ff00%d/%d|r", schema.quantityRequired, schema.quantityRequired)
        end

        ct.initializing = nil
        for i = (slots and #slots or 0) + 1, #edits do
            for j=1,3 do edits[i][j]:Hide() end
        end

        togglePreview(not needPreview)
    end
    hooksecurefunc(ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm, "Init", hookFormInit)
    hooksecurefunc(ProfessionsFrame.CraftingPage.SchematicForm, "Init", hookFormInit)
end

if CoreDependCall then
    CoreDependCall("Blizzard_Professions", setup)
else
    if not IsAddOnLoaded("Blizzard_Professions") then
        ProfessionsFrame_LoadUI()
    end
    setup()
end