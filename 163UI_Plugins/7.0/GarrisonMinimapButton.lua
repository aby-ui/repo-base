--[[------------------------------------------------------------
职业大厅按钮处理 2016.9
---------------------------------------------------------------]]
local ProcessGarrisonLandingPageMMB = function()
    if LibDBIcon10_GLPMMB then return end
    local LibDBIcon = LibStub("LibDBIcon-1.0")
    local glpmmb = GarrisonLandingPageMinimapButton

    local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("GLPMMB", {
        type = "launcher",
        text = "职业大厅",
        icon = [[Interface\ICONS\achievement_dungeon_HallsofValor]],
        OnClick = function(self, ...)
            if glpmmb:IsShown() then
                pcall(glpmmb:GetScript("OnClick"), glpmmb, ...)
            end
        end,
        OnTooltipShow = function(tip, ...)
            if glpmmb:IsShown() then
                pcall(glpmmb:GetScript("OnEnter"), glpmmb, ...)
            else
                tip:AddLine("职业大厅")
                tip:AddLine("不可用", 1, 0, 0)
            end
        end,
    })

    U1DB.configs.landingGarrisonMMB = U1DB.configs.landingGarrisonMMB or {}
    local db = U1DB.configs.landingGarrisonMMB
    db.minimapPos = db.minimapPos or 244
    LibDBIcon:Register("GLPMMB", ldb, db)
    if db.hideMinimapIcon then LibDBIcon:Hide("GLPMMB") end

    local dbicon = LibDBIcon10_GLPMMB
    --for _, tex in ipairs({dbicon:GetRegions()}) do tex:Hide() end
    --dbicon:SetSize(36,36)

    local nt = dbicon:CreateTexture()
    nt:SetAllPoints()
    dbicon:SetNormalTexture(nt)
    local pt = dbicon:CreateTexture()
    pt:SetAllPoints()
    dbicon:SetPushedTexture(pt)
    dbicon.icon:Hide()
    hook_GLPMMB_UpdateIcon = hook_GLPMMB_UpdateIcon or function(GLPMMB)
        dbicon:GetNormalTexture():SetAtlas(GLPMMB:GetNormalTexture():GetAtlas(), true)
        dbicon:GetPushedTexture():SetAtlas(GLPMMB:GetPushedTexture():GetAtlas(), true)
    end
    hook_GLPMMB_UpdateIcon(glpmmb)
    hooksecurefunc("GarrisonLandingPageMinimapButton_UpdateIcon", hook_GLPMMB_UpdateIcon)

    glpmmb:SetParent(dbicon)
    glpmmb:SetAllPoints()
    local update = function()
        glpmmb:SetFrameStrata("BACKGROUND")
        glpmmb:SetFrameLevel(0)
    end
    update()
    hooksecurefunc(dbicon, "SetParent", update)

    hooksecurefunc(glpmmb, "Show", function() dbicon:Show() end)
    hooksecurefunc(glpmmb, "Hide", function() dbicon:Hide() end)
    if glpmmb:IsShown() then dbicon:Show() else dbicon:Hide() end

    --其他动画不用设置
    GarrisonLandingPageMinimapButton.LoopingGlow:SetSize(36,36)
end

local addonName = ...
CoreOnEvent("VARIABLES_LOADED", function()
    if U1GetCfgValue(addonName, "garrisonMMB") then
        ProcessGarrisonLandingPageMMB()
    end
end)

_G.U1_ProcessGarrisonLandingPageMMB = ProcessGarrisonLandingPageMMB