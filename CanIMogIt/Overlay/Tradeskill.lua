-- Overlay for the crafting windows.


----------------------------
-- UpdateIcon functions   --
----------------------------

local function string_starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end


function CIMI_UpdateTradeSkillIcons()
    if not CIMI_CheckOverlayIconEnabled() then
        return
    end
    local tradeSkillFrame = _G["TradeSkillFrame"]
    local buttons = tradeSkillFrame.RecipeList.buttons

    for i, button in ipairs(buttons) do
        if button ~= nil and button.tradeSkillInfo ~= nil and button.tradeSkillInfo.recipeID ~= nil then
            local recipeID = button.tradeSkillInfo.recipeID
            local text = button:GetText()
            local itemLink = C_TradeSkillUI.GetRecipeItemLink(recipeID)
            if itemLink ~= nil then
                local icon = CanIMogIt:GetIconText(itemLink)
                if icon ~= nil and not string_starts(text, icon) then
                    text = icon .. text
                    button:SetText(text)
                end
            end
        end
    end
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


------------------------
-- Event functions    --
------------------------


local function TradeSkillEvents(event, addon)
    if event == "ADDON_LOADED" and addon == "Blizzard_TradeSkillUI" then

        local tradeSkillFrame = _G["TradeSkillFrame"]
        -- Update on most things (like clicking)
        hooksecurefunc(tradeSkillFrame.RecipeList, "RefreshDisplay", CIMI_UpdateTradeSkillIcons)

        -- Update on scroll
        tradeSkillFrame.RecipeList.scrollBar:HookScript("OnValueChanged", CIMI_UpdateTradeSkillIcons)

        -- Update on tab changes (with delay due to something updating after the change)
        tradeSkillFrame.RecipeList.UnlearnedTab:HookScript("OnClick", function () C_Timer.After(.25, CIMI_UpdateTradeSkillIcons) end)
        tradeSkillFrame.RecipeList.LearnedTab:HookScript("OnClick", function () C_Timer.After(.25, CIMI_UpdateTradeSkillIcons) end)

        -- Update when the user switches profession windows (with a delay due to something updating after the change)
        hooksecurefunc(tradeSkillFrame.RecipeList, "OnDataSourceChanged", function () C_Timer.After(.25, CIMI_UpdateTradeSkillIcons) end)

        -- Update when an option changes (with delay)
        local function UpdateTradskillWindow()
            _G["TradeSkillFrame"].RecipeList:RefreshDisplay()
        end

        CanIMogIt:RegisterMessage("OptionUpdate", function () C_Timer.After(.25, UpdateTradskillWindow) end)
    end
end

CanIMogIt.frame:AddEventFunction(TradeSkillEvents)
