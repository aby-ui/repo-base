local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local Serializer = LibStub:GetLibrary("LibSerialize")
local LibDeflate = LibStub:GetLibrary("LibDeflate")
local deflateConfig = {level = 9}

local fromLayout
local indicatorButtons = {}
local selectedIndicators = {}
local Toggle, Validate

-------------------------------------------------
-- parent
-------------------------------------------------
local exportParent = CreateFrame("Frame", "CellOptionsFrame_IndicatorsExport", Cell.frames.indicatorsTab)
exportParent:Hide()
exportParent:SetAllPoints(Cell.frames.indicatorsTab)
exportParent:SetFrameLevel(Cell.frames.indicatorsTab:GetFrameLevel()+20)
exportParent:SetFrameStrata("DIALOG")

-------------------------------------------------
-- export
-------------------------------------------------
local from, listFrame, exportFrame, textArea, exportBtn

local function CreateIndicatorsExportFrame()
    if not Cell.frames.indicatorsTab.mask then
        Cell:CreateMask(Cell.frames.indicatorsTab, nil, {1, -1, -1, 1})
        Cell.frames.indicatorsTab.mask:Hide()
    end

    -- list
    local listParent = Cell:CreateFrame(nil, exportParent, 136, 430)
    Cell:StylizeFrame(listParent, nil, Cell:GetAccentColorTable())
    listParent:SetFrameStrata("DIALOG")
    listParent:SetPoint("BOTTOMLEFT", 5, 24)
    listParent:Show()
    
    -- from
    from = listParent:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    from:SetPoint("TOPLEFT", 5, -5)
    
    listFrame = CreateFrame("Frame", nil, listParent, "BackdropTemplate")
    Cell:StylizeFrame(listFrame)
    listFrame:SetPoint("TOPLEFT", 5, -20)
    listFrame:SetPoint("TOPRIGHT", -5, -5)
    listFrame:SetHeight(362)
    
    Cell:CreateScrollFrame(listFrame)
    listFrame.scrollFrame:SetScrollStep(19)

    -- export area
    exportFrame = Cell:CreateFrame(nil, exportParent, 281, 197)
    Cell:StylizeFrame(exportFrame, nil, Cell:GetAccentColorTable())
    exportFrame:SetPoint("BOTTOMLEFT", listParent, "BOTTOMRIGHT", 5, 0)
    
    -- title
    local title = exportFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    title:SetPoint("TOPLEFT", 5, -5)
    
    -- textArea
    textArea = Cell:CreateScrollEditBox(exportFrame)
    Cell:StylizeFrame(textArea.scrollFrame, {0, 0, 0, 0}, Cell:GetAccentColorTable())
    textArea:SetPoint("TOPLEFT", 5, -20)
    textArea:SetPoint("BOTTOMRIGHT", -5, 5)
    
    -- highlight text
    textArea.eb:SetScript("OnEditFocusGained", function() textArea.eb:HighlightText() end)
    textArea.eb:SetScript("OnMouseUp", function()
        if not isImport then
            textArea.eb:HighlightText()
        end
    end)
    
    -- list buttons
    exportBtn = Cell:CreateButton(listParent, L["Export"], "green", {64, 20})
    exportBtn:SetPoint("BOTTOMLEFT", 5, 5)
    exportBtn:SetEnabled(false)
    exportBtn:SetScript("OnClick", function()
        exportFrame:Show()
        
        local builtIn, custom = 0, 0
        local data = {
            ["indicators"] = {},
            ["related"] = {},
        }
    
        for index in pairs(selectedIndicators) do
            -- count
            if indicatorButtons[index].isBuiltIn then
                builtIn = builtIn + 1
            else
                custom = custom + 1
            end
            
            -- data.indicators
            data["indicators"][index] = CellDB["layouts"][fromLayout]["indicators"][index]
            
            -- data.related
            local name = CellDB["layouts"][fromLayout]["indicators"][index]["indicatorName"]
            if name == "defensiveCooldowns" or name == "allCooldowns" then
                data["related"]["customDefensives"] = CellDB["customDefensives"]
            end
            if name == "externalCooldowns" or name == "allCooldowns" then
                data["related"]["customExternals"] = CellDB["customExternals"]
            end
            
            if name == "debuffs" then
                data["related"]["debuffBlacklist"] = CellDB["debuffBlacklist"]
                data["related"]["bigDebuffs"] = CellDB["bigDebuffs"]
            elseif name == "raidDebuffs" then
                if Cell.isRetail then
                    data["related"]["cleuAuras"] = CellDB["cleuAuras"]
                    data["related"]["cleuGlow"] = CellDB["cleuGlow"]
                end
            elseif name == "targetedSpells" then
                data["related"]["targetedSpellsList"] = CellDB["targetedSpellsList"]
                data["related"]["targetedSpellsGlow"] = CellDB["targetedSpellsGlow"]
            elseif name == "consumables" then
                data["related"]["consumables"] = CellDB["consumables"]
            end
        end
        -- texplore(data)

        title:SetText(L["Export"]..": ".."|cff90EE90"..builtIn.." "..L["built-in(s)"].."|r, |cffFFB5C5"..custom.." "..L["custom(s)"].."|r")
    
        -- prepare string
        local prefix = "!CELL:"..Cell.versionNum..":INDICATOR:"..(builtIn+custom).."!"
    
        local exported = Serializer:Serialize(data) -- serialize
        exported = LibDeflate:CompressDeflate(exported, deflateConfig) -- compress
        exported = LibDeflate:EncodeForPrint(exported) -- encode
        exported = prefix..exported
    
        textArea:SetText(exported)
    end)
    
    local closeBtn = Cell:CreateButton(listParent, L["Close"], "red", {63, 20})
    closeBtn:SetPoint("BOTTOMLEFT", exportBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    closeBtn:SetScript("OnClick", function()
        exportParent:Hide()
    end)
    
    local allBtn = Cell:CreateButton(listParent, L["ALL"], "accent-hover", {64, 20})
    allBtn:SetPoint("BOTTOMLEFT", exportBtn, "TOPLEFT", 0, P:Scale(-1))
    allBtn:SetScript("OnClick", function()
        for i = 1, #indicatorButtons do
            Toggle(i, true)
        end
        Validate()
    end)
    
    local invertBtn = Cell:CreateButton(listParent, L["INVERT"], "accent-hover", {63, 20})
    invertBtn:SetPoint("BOTTOMLEFT", closeBtn, "TOPLEFT", 0, P:Scale(-1))
    invertBtn:SetScript("OnClick", function()
        for i = 1, #indicatorButtons do
            if selectedIndicators[i] then
                Toggle(i, false, true)
            else
                Toggle(i, true)
            end
        end
        Validate()
    end)
end

-------------------------------------------------
-- functions
-------------------------------------------------
Validate = function()
    if F:Getn(selectedIndicators) ~= 0 then
        exportBtn:SetEnabled(true)
    else
        exportBtn:SetEnabled(false)
    end
end

Toggle = function(index, isSelect, unhighlight)
    b = indicatorButtons[index]
    if isSelect then
        selectedIndicators[index] = true
        b:SetBackdropColor(unpack(b.hoverColor))
        b:SetScript("OnEnter", nil)
        b:SetScript("OnLeave", nil)
        b:SetTextColor(0, 1, 0)
        b.selected = true
    else
        selectedIndicators[index] = nil
        b:SetScript("OnEnter", function(self) self:SetBackdropColor(unpack(self.hoverColor)) end)
        b:SetScript("OnLeave", function(self) self:SetBackdropColor(unpack(self.color)) end)
        b:SetTextColor(1, 1, 1)
        b.selected = false
        if unhighlight then
            b:SetBackdropColor(0, 0, 0, 0)
        end
    end
end

local function LoadIndicators(layout)
    wipe(selectedIndicators)
    listFrame.scrollFrame:Reset()

    local last, n
    for i, t in pairs(CellDB["layouts"][layout]["indicators"]) do
        local b = indicatorButtons[i]
        if not b then
            b = Cell:CreateButton(listFrame.scrollFrame.content, " ", "transparent-accent", {20, 20})
            indicatorButtons[i] = b
            b:SetScript("OnClick", function()
                b.selected = not b.selected
                Toggle(i, b.selected)
                Validate()
            end)
        end

        -- reset
        b:Show()
        b:SetParent(listFrame.scrollFrame.content)
        b.selected = false
        b:SetScript("OnEnter", function(self) self:SetBackdropColor(unpack(self.hoverColor)) end)
        b:SetScript("OnLeave", function(self) self:SetBackdropColor(unpack(self.color)) end)
        b:SetTextColor(1, 1, 1)
        b:SetBackdropColor(0, 0, 0, 0)

        if t["type"] == "built-in" then
            b:SetText(L[t["name"]])
            b.isBuiltIn = true
        else
            b:SetText(t["name"])
            b.isBuiltIn = false
            if not b.typeIcon then
                b.typeIcon = b:CreateTexture(nil, "ARTWORK")
                b.typeIcon:SetPoint("RIGHT", -2, 0)
                b.typeIcon:SetSize(16, 16)
                b.typeIcon:SetAlpha(0.5)
                b:GetFontString():ClearAllPoints()
                b:GetFontString():SetPoint("LEFT", 5, 0)
                b:GetFontString():SetPoint("RIGHT", b.typeIcon, "LEFT", -2, 0)
            end
            b.typeIcon:SetTexture("Interface\\AddOns\\Cell\\Media\\Indicators\\indicator-"..t["type"])
        end

        b:SetPoint("RIGHT")
        if last then
            b:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, 1)
        else
            b:SetPoint("TOPLEFT")
        end
        last = b
        n = i
    end

    listFrame.scrollFrame:SetContentHeight(20, n, -1)
end

exportParent:SetScript("OnHide", function()
    exportParent:Hide()
    Cell.frames.indicatorsTab.mask:Hide()
    exportFrame:Hide()
    textArea:SetText("")
end)

exportParent:SetScript("OnShow", function()
    -- raise frame level
    exportFrame:SetFrameStrata("DIALOG")
    Cell.frames.indicatorsTab.mask:Show()
end)

local init
function F:ShowIndicatorsExportFrame(layout)
    if not init then
        init = true
        CreateIndicatorsExportFrame()
    end

    exportParent:Show()
    from:SetText(layout == "default" and _G.DEFAULT or layout)
    LoadIndicators(layout)
    fromLayout = layout
end