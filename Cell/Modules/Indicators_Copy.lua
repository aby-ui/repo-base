local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local Toggle, Validate
local from, to
local indicatorButtons = {}
local selectedIndicators = {}

local copyFrame, fromDropdown, toDropdown, fromList, copyBtn, closeBtn, allBtn, invertBtn

-- local function GetCustomIndicatorNames(indicators)
--     local names = {}
--     for i = Cell.defaults.builtIns+1, #indicators do
--         local iTbl = indicators[i]
--         names[iTbl["name"]] = {i, iTbl["indicatorName"]}
--     end
--     return names
-- end

local function CreateIndicatorsCopyFrame()
    if not Cell.frames.indicatorsTab.mask then
        Cell:CreateMask(Cell.frames.indicatorsTab, nil, {1, -1, -1, 1})
        Cell.frames.indicatorsTab.mask:Hide()
    end

    copyFrame = Cell:CreateFrame("CellOptionsFrame_IndicatorsCopy", Cell.frames.indicatorsTab, 136, 425)
    -- Cell.frames.indicatorsCopyFrame = copyFrame
    Cell:StylizeFrame(copyFrame, nil, Cell:GetAccentColorTable())
    copyFrame:SetFrameStrata("DIALOG")
    copyFrame:SetPoint("BOTTOMLEFT", 5, 24)
    copyFrame:Hide()

    -- dropdowns
    fromDropdown = Cell:CreateDropdown(copyFrame, 126)
    fromDropdown:SetPoint("TOPLEFT", 5, -24)
    
    toDropdown = Cell:CreateDropdown(copyFrame, 126)
    toDropdown:SetPoint("TOPLEFT", fromDropdown, "BOTTOMLEFT", 0, -22)
    
    local fromText = copyFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    fromText:SetPoint("BOTTOMLEFT", fromDropdown, "TOPLEFT", 0, 1)
    fromText:SetText(L["From"])
    
    local toText = copyFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_CLASS")
    toText:SetPoint("BOTTOMLEFT", toDropdown, "TOPLEFT", 0, 1)
    toText:SetText(L["To"])
    
    -- list
    fromList = CreateFrame("Frame", nil, copyFrame, "BackdropTemplate")
    Cell:StylizeFrame(fromList)
    fromList:SetPoint("TOPLEFT", toDropdown, "BOTTOMLEFT", 0, -5)
    fromList:SetPoint("TOPRIGHT", toDropdown, "BOTTOMRIGHT", 0, -5)
    -- fromList:SetPoint("BOTTOM", 0, 34)
    fromList:SetHeight(286)
    
    Cell:CreateScrollFrame(fromList)
    fromList.scrollFrame:SetScrollStep(19)
    
    -- buttons
    copyBtn = Cell:CreateButton(copyFrame, L["Copy"], "green", {64, 20})
    copyBtn:SetPoint("BOTTOMLEFT", 5, 5)
    copyBtn:SetEnabled(false)
    copyBtn:SetScript("OnClick", function()
        local last = #CellDB["layouts"][to]["indicators"]
        last = tonumber(string.match(CellDB["layouts"][to]["indicators"][last]["indicatorName"], "%d+")) or last
    
        for i in pairs(selectedIndicators) do
            if i <= Cell.defaults.builtIns then -- built-in
                CellDB["layouts"][to]["indicators"][i] = F:Copy(CellDB["layouts"][from]["indicators"][i])
            else -- user-created
                last = last + 1
                local indicator = F:Copy(CellDB["layouts"][from]["indicators"][i])
                indicator["indicatorName"] = "indicator"..last
                tinsert(CellDB["layouts"][to]["indicators"], indicator)
            end
        end
        Cell:Fire("UpdateIndicators", to)
        Cell:Fire("IndicatorsChanged", to)
        copyFrame:Hide()
    end)
    
    closeBtn = Cell:CreateButton(copyFrame, L["Close"], "red", {63, 20})
    closeBtn:SetPoint("BOTTOMLEFT", copyBtn, "BOTTOMRIGHT", P:Scale(-1), 0)
    closeBtn:SetScript("OnClick", function()
        copyFrame:Hide()
    end)
    
    allBtn = Cell:CreateButton(copyFrame, L["ALL"], "accent-hover", {64, 20})
    allBtn:SetPoint("BOTTOMLEFT", copyBtn, "TOPLEFT", 0, P:Scale(-1))
    allBtn:SetScript("OnClick", function()
        for i = 1, #indicatorButtons do
            Toggle(i, true)
        end
        Validate()
    end)
    
    invertBtn = Cell:CreateButton(copyFrame, L["INVERT"], "accent-hover", {63, 20})
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

    -- scripts
    copyFrame:SetScript("OnShow", function()
        Cell.frames.indicatorsTab.mask:Show()
    end)
    
    copyFrame:SetScript("OnHide", function()
        copyFrame:Hide()
        Cell.frames.indicatorsTab.mask:Hide()
        fromList.scrollFrame:Reset()
        fromDropdown:SetSelected()
        toDropdown:SetSelected()
        copyBtn:SetEnabled(false)
        wipe(selectedIndicators)
        from, to = nil, nil
    end)
end

-------------------------------------------------
-- functions
-------------------------------------------------
Validate = function()
    from, to = fromDropdown:GetSelected(), toDropdown:GetSelected()
    if from and to and F:Getn(selectedIndicators) ~= 0 then
        copyBtn:SetEnabled(true)
    else
        copyBtn:SetEnabled(false)
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
    fromList.scrollFrame:Reset()

    local last, n
    for i, t in pairs(CellDB["layouts"][layout]["indicators"]) do
        local b = indicatorButtons[i]
        if not b then
            b = Cell:CreateButton(fromList.scrollFrame.content, " ", "transparent-accent", {20, 20})
            indicatorButtons[i] = b
            b.selected = false
            b:SetScript("OnClick", function()
                b.selected = not b.selected
                Toggle(i, b.selected)
                Validate()
            end)
        else
            -- reset
            b:Show()
            b:SetParent(fromList.scrollFrame.content)
            b.selected = false
            b:SetScript("OnEnter", function(self) self:SetBackdropColor(unpack(self.hoverColor)) end)
            b:SetScript("OnLeave", function(self) self:SetBackdropColor(unpack(self.color)) end)
            b:SetTextColor(1, 1, 1)
            b:SetBackdropColor(0, 0, 0, 0)
        end

        if t["type"] == "built-in" then
            b:SetText(L[t["name"]])
        else
            b:SetText(t["name"])
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

    fromList.scrollFrame:SetContentHeight(20, n, -1)
end

local function LoadToDropdown(from)
    local masters, slaves = {}, {}

    -- update master-slave
    for l, t in pairs(CellDB["layouts"]) do
        local master = t["syncWith"]
        if master then
            if CellDB["layouts"][master] then -- master exists
                if not masters[master] then masters[master] = {} end
                masters[master][l] = true
                slaves[l] = master
            end
        end
    end

    local indices = {}

    if slaves[from] then -- if FROM is a slave
        local master = slaves[from]
        for l, t in pairs(CellDB["layouts"]) do
            -- not FROM, not its master, and its siblings
            if l ~= from and l ~= master and not masters[master][l] then
                if l == "default" then
                    tinsert(indices, 1, "default")
                else
                    tinsert(indices, l)
                end
            end
        end
    elseif masters[from] then -- if FROM is a master
        for l, t in pairs(CellDB["layouts"]) do
            -- not FROM, not its slaves
            if l ~= from and not masters[from][l] then
                if l == "default" then
                    tinsert(indices, 1, "default")
                else
                    tinsert(indices, l)
                end
            end
        end
    else
        for l, t in pairs(CellDB["layouts"]) do
            -- not FROM
            if l ~= from then
                if l == "default" then
                    tinsert(indices, 1, "default")
                else
                    tinsert(indices, l)
                end
            end
        end
    end

    local toItems = {}

    for _, l in ipairs(indices) do
        tinsert(toItems, {
            ["text"] = l == "default" and _G.DEFAULT or l,
            ["value"] = l,
            ["onClick"] = function()
                Validate()
            end,
        })
    end
    
    toDropdown:SetItems(toItems)
end

local function LoadFromDropdown()
    local fromItems = {}

    tinsert(fromItems, {
        ["text"] = _G.DEFAULT,
        ["value"] = "default",
        ["onClick"] = function()
            LoadIndicators("default")
            Validate()
            toDropdown:ClearItems()
            LoadToDropdown("default")
        end,
    })
    
    for l, t in pairs(CellDB["layouts"]) do
        if l ~= "default" then
            tinsert(fromItems, {
                ["text"] = l,
                ["onClick"] = function()
                    LoadIndicators(l)
                    Validate()
                    toDropdown:ClearItems()
                    LoadToDropdown(l)
                end,
            })
        end
    end

    fromDropdown:SetItems(fromItems)
end

-------------------------------------------------
-- scripts
-------------------------------------------------
local init
function F:ShowIndicatorsCopyFrame()
    if not init then
        init = true
        CreateIndicatorsCopyFrame()
    end

    -- texplore(selectedIndicators)
    LoadFromDropdown()
    toDropdown:ClearItems()
    copyFrame:Show()
end