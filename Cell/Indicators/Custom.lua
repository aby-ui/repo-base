local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs

-------------------------------------------------
-- custom indicators
-------------------------------------------------
local enabledIndicators = {}
local customIndicators = {
    ["buff"] = {},
    ["debuff"] = {},
}

Cell.snippetVars.enabledIndicators = enabledIndicators
Cell.snippetVars.customIndicators = customIndicators

function I:CreateIndicator(parent, indicatorTable)
    local indicatorName = indicatorTable["indicatorName"]
    local indicator
    if indicatorTable["type"] == "icon" then
        indicator = I:CreateAura_BarIcon(parent:GetName()..indicatorName, parent.widget.overlayFrame)
    elseif indicatorTable["type"] == "text" then
        indicator = I:CreateAura_Text(parent:GetName()..indicatorName, parent.widget.overlayFrame)
    elseif indicatorTable["type"] == "bar" then
        indicator = I:CreateAura_Bar(parent:GetName()..indicatorName, parent.widget.overlayFrame)
    elseif indicatorTable["type"] == "rect" then
        indicator = I:CreateAura_Rect(parent:GetName()..indicatorName, parent.widget.overlayFrame)
    elseif indicatorTable["type"] == "icons" then
        indicator = I:CreateAura_Icons(parent:GetName()..indicatorName, parent.widget.overlayFrame, 10)
    elseif indicatorTable["type"] == "color" then
        indicator = I:CreateAura_Color(parent:GetName()..indicatorName, parent)
    elseif indicatorTable["type"] == "texture" then
        indicator = I:CreateAura_Texture(parent:GetName()..indicatorName, parent.widget.overlayFrame)
    end
    parent.indicators[indicatorName] = indicator
    
    --! init enabledIndicators & customIndicators
    local auraType = indicatorTable["auraType"]
    if parent ~= CellIndicatorsPreviewButton and not customIndicators[auraType][indicatorName] then
        -- keep custom indicators in table
        if indicatorTable["enabled"] then enabledIndicators[indicatorName] = true end

        -- NOTE: icons is different from other custom indicators, more like the Debuffs indicator
        if indicatorTable["type"] == "icons" then
            customIndicators[auraType][indicatorName] = {
                ["auras"] = F:ConvertTable(indicatorTable["auras"]), -- auras to match
                ["isIcons"] = true,
                ["found"] = {},
                ["num"] = indicatorTable["num"],
                -- ["castByMe"]
            }
        else
            customIndicators[auraType][indicatorName] = {
                ["auras"] = F:ConvertTable(indicatorTable["auras"]), -- auras to match
                ["top"] = {}, -- top aura details
                ["topOrder"] = {}, -- top aura order
                -- ["castByMe"]
            }
        end

        if auraType == "buff" then
            customIndicators[auraType][indicatorName]["castByMe"] = indicatorTable["castByMe"]
        end
    end

    return indicator
end

function I:RemoveIndicator(parent, indicatorName, auraType)
    local indicator = parent.indicators[indicatorName]
    indicator:ClearAllPoints()
    indicator:Hide()
    indicator:SetParent(nil)
    parent.indicators[indicatorName] = nil
    enabledIndicators[indicatorName] = nil
    customIndicators[auraType][indicatorName] = nil
end

-- used for switching to a new layout
function I:RemoveAllCustomIndicators(parent)
    for indicatorName, indicator in pairs(parent.indicators) do
        if string.find(indicatorName, "^indicator") then
            indicator:ClearAllPoints()
            indicator:Hide()
            indicator:SetParent(nil)
            parent.indicators[indicatorName] = nil
        end
    end

    if parent ~= CellIndicatorsPreviewButton then
        wipe(enabledIndicators)
        wipe(customIndicators["buff"])
        wipe(customIndicators["debuff"])
    end
end

local function UpdateCustomIndicators(layout, indicatorName, setting, value, value2)
    if layout and layout ~= Cell.vars.currentLayout then return end

    if not indicatorName or not string.find(indicatorName, "^indicator") then return end

    if setting == "enabled" then
        if value then
            enabledIndicators[indicatorName] = true
        else
            enabledIndicators[indicatorName] = nil
        end
    elseif setting == "auras" then
        customIndicators[value][indicatorName]["auras"] = F:ConvertTable(value2)
    elseif setting == "checkbutton" then
        if customIndicators["buff"][indicatorName] then
            customIndicators["buff"][indicatorName][value] = value2
        elseif customIndicators["debuff"][indicatorName] then
            customIndicators["debuff"][indicatorName][value] = value2
        end
    elseif setting == "num" then
        if customIndicators["buff"][indicatorName] then
            customIndicators["buff"][indicatorName]["num"] = value
        elseif customIndicators["debuff"][indicatorName] then
            customIndicators["debuff"][indicatorName]["num"] = value
        end
    end
end
Cell:RegisterCallback("UpdateIndicators", "UpdateCustomIndicators", UpdateCustomIndicators)

-------------------------------------------------
-- reset
-------------------------------------------------
function I:ResetCustomIndicators(unitButton, auraType)
    local unit = unitButton.state.displayedUnit

    for indicatorName, indicatorTable in pairs(customIndicators[auraType]) do
        if indicatorTable["isIcons"] then
            indicatorTable["found"][unit] = 0

            for i = 1, 10 do
                unitButton.indicators[indicatorName][i]:Hide()
            end
            unitButton.indicators[indicatorName]:Hide()

        else
            indicatorTable["topOrder"][unit] = 999
            if not indicatorTable["top"][unit] then
                indicatorTable["top"][unit] = {}
            else
                wipe(indicatorTable["top"][unit])
            end

            unitButton.indicators[indicatorName]:Hide()
        end
    end
end

-------------------------------------------------
-- update
-------------------------------------------------
local function Update(indicator, indicatorTable, unit, spellId, start, duration, debuffType, icon, count, refreshing)
    if indicatorTable["isIcons"] then
        if indicatorTable["found"][unit] < indicatorTable["num"] then
            indicatorTable["found"][unit] = indicatorTable["found"][unit] + 1
            indicator:UpdateSize(indicatorTable["found"][unit])
            indicator[indicatorTable["found"][unit]]:SetCooldown(start, duration, debuffType, icon, count, refreshing)
            indicator:Show()
        end
    else
        if indicatorTable["auras"][spellId] < indicatorTable["topOrder"][unit] then
            indicatorTable["topOrder"][unit] = indicatorTable["auras"][spellId]
            indicatorTable["top"][unit]["start"] = start
            indicatorTable["top"][unit]["duration"] = duration
            indicatorTable["top"][unit]["debuffType"] = debuffType
            indicatorTable["top"][unit]["texture"] = icon
            indicatorTable["top"][unit]["count"] = count
            indicatorTable["top"][unit]["refreshing"] = refreshing
        end
    end
end

function I:UpdateCustomIndicators(unitButton, auraInfo, refreshing)
    local unit = unitButton.state.displayedUnit

    local auraType = auraInfo.isHelpful and "buff" or "debuff"
    local icon = auraInfo.icon
    local debuffType = auraInfo.isHarmful and (auraInfo.dispelName or "")
    local count = auraInfo.applications
    local duration = auraInfo.duration
    local start = (auraInfo.expirationTime or 0) - auraInfo.duration
    local spellId = auraInfo.spellId
    local castByMe = auraInfo.sourceUnit == "player"

    for indicatorName, indicatorTable in pairs(customIndicators[auraType]) do
        if enabledIndicators[indicatorName] and unitButton.indicators[indicatorName] then
            if indicatorTable["auras"][spellId] or indicatorTable["auras"][0] then -- is in indicator spell list
                if auraType == "buff" then
                    -- check castByMe
                    if (indicatorTable["castByMe"] and castByMe) or (not indicatorTable["castByMe"]) then
                        Update(unitButton.indicators[indicatorName], indicatorTable, unit, spellId, start, duration, debuffType, icon, count, refreshing)
                    end
                else -- debuff
                    Update(unitButton.indicators[indicatorName], indicatorTable, unit, spellId, start, duration, debuffType, icon, count, refreshing)
                end
            end
        end
    end
end

-------------------------------------------------
-- show
-------------------------------------------------
function I:ShowCustomIndicators(unitButton, auraType)
    local unit = unitButton.state.displayedUnit
    for indicatorName, indicatorTable in pairs(customIndicators[auraType]) do
        if enabledIndicators[indicatorName] and unitButton.indicators[indicatorName] then
            if not indicatorTable["isIcons"] then
                if indicatorTable["top"][unit]["start"] then
                    unitButton.indicators[indicatorName]:SetCooldown(
                        indicatorTable["top"][unit]["start"], 
                        indicatorTable["top"][unit]["duration"], 
                        indicatorTable["top"][unit]["debuffType"], 
                        indicatorTable["top"][unit]["texture"], 
                        indicatorTable["top"][unit]["count"], 
                        indicatorTable["top"][unit]["refreshing"])
                end
            end
        end
    end
end