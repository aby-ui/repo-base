local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local textureSelector, scrollFrame, confirmBtn, currentTexturePath
local LoadTextures
local buttons = {}
local selectedPath, textureNum

local function CreateTextureSelector()
    if not Cell.frames.indicatorsTab.mask then
        Cell:CreateMask(Cell.frames.indicatorsTab, nil, {1, -1, -1, 1})
        Cell.frames.indicatorsTab.mask:Hide()
    end

    textureSelector = CreateFrame("Frame", "CellOptionsFrame_TextureSelector", Cell.frames.indicatorsTab, "BackdropTemplate")
    Cell:StylizeFrame(textureSelector, nil, Cell:GetAccentColorTable())
    textureSelector:SetFrameLevel(Cell.frames.indicatorsTab:GetFrameLevel()+20)
    textureSelector:SetFrameStrata("DIALOG")
    textureSelector:SetPoint("TOPLEFT", P:Scale(1), -100)
    textureSelector:SetPoint("TOPRIGHT", P:Scale(-1), -100)
    textureSelector:SetHeight(235)

    -- add
    local addEB = Cell:CreateEditBox(textureSelector, 355, 20)
    addEB:SetPoint("TOPLEFT", 5, -5)
    addEB.tip = addEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    addEB.tip:SetTextColor(0.4, 0.4, 0.4, 1)
    addEB.tip:SetText("Interface\\... (tga|blp|jpg)")
    addEB.tip:SetPoint("LEFT", 5, 0)
    addEB:SetScript("OnEditFocusGained", function()
        addEB:HighlightText()
        addEB.tip:Hide()
    end)
    addEB:SetScript("OnEditFocusLost", function()
        addEB:HighlightText(0, 0)
        if addEB:GetText() == "" then
            addEB.tip:Show()
        end
    end)

    local addBtn = Cell:CreateButton(textureSelector, L["Add"], "accent", {66, 20})
    addBtn:SetPoint("TOPLEFT", addEB, "TOPRIGHT", -1, 0)
    addBtn:SetScript("OnClick", function()
        local path = strtrim(addEB:GetText())
        -- check whether exists
        if path ~= "" and not F:TContains(CellDB["customTextures"], path) then
            -- update db
            tinsert(CellDB["customTextures"], path)
            -- reload
            LoadTextures()
        end
    end)

    -- cancel
    local cancelBtn = Cell:CreateButton(textureSelector, L["Cancel"], "red", {70, 20})
    cancelBtn:SetPoint("BOTTOMRIGHT")
    cancelBtn:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))
    cancelBtn:SetScript("OnClick", function()
        textureSelector:Hide()
    end)

    -- OK
    confirmBtn = Cell:CreateButton(textureSelector, L["Confirm"], "green", {70, 20})
    confirmBtn:SetPoint("BOTTOMRIGHT", cancelBtn, "BOTTOMLEFT", P:Scale(1), 0)
    confirmBtn:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))

    -- textures
    local texFrame = Cell:CreateFrame(nil, textureSelector)
    texFrame:Show()
    texFrame:SetPoint("TOPLEFT", addEB, "BOTTOMLEFT", 0, -10)
    texFrame:SetPoint("BOTTOMRIGHT", -5, 30)
    scrollFrame = Cell:CreateScrollFrame(texFrame, -5, 5)
    scrollFrame:SetScrollStep(55)

    -- current path
    currentTexturePath = textureSelector:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    currentTexturePath:SetPoint("BOTTOMLEFT", 5, 5)
    currentTexturePath:SetPoint("RIGHT", confirmBtn, "LEFT", -5, 0)
    currentTexturePath:SetJustifyH("LEFT")
    currentTexturePath:SetWordWrap(false)

    -- OnHide
    textureSelector:SetScript("OnHide", function()
        Cell.frames.indicatorsTab.mask:Hide()
        textureSelector:Hide()
        addEB.tip:Show()
    end)
end

-------------------------------------------------
-- load
-------------------------------------------------
LoadTextures = function()
    scrollFrame:Reset()

    local builtIns, textures = F:GetTextures()
    textureNum = #textures

    -- create buttons
    for i, path in pairs(textures) do
        local b = buttons[i]
        if not b then
            b = CreateFrame("Button", nil, scrollFrame.content, "BackdropTemplate")
            buttons[i] = b
            P:Size(b, 50, 50)
            b:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
            b:SetBackdropColor(0.115, 0.115, 0.115, 1)
            b:SetBackdropBorderColor(0, 0, 0, 1)
            b:SetScript("OnEnter", function()
                b:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))
                b.delBtn:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))

                F:FitWidth(currentTexturePath, path, "right")
            end)
            b:SetScript("OnLeave", function()
                currentTexturePath:SetText("")
                if selectedPath ~= path then
                    b:SetBackdropBorderColor(0, 0, 0, 1)
                    b.delBtn:SetBackdropBorderColor(0, 0, 0, 1)
                end
            end)
            
            b.tex = b:CreateTexture(nil, "ARTWORK")
            b.tex:SetPoint("TOPLEFT", 5, -5)
            b.tex:SetPoint("BOTTOMRIGHT", -5, 5)

            b.delBtn = Cell:CreateButton(b, "×", "red", {13, 13})
            b.delBtn:GetFontString():SetFont("Interface\\AddOns\\Cell\\Media\\font.ttf", 10, "")
            b.delBtn:SetPoint("TOPRIGHT")
            b.delBtn:HookScript("OnEnter", function()
                b:GetScript("OnEnter")(b)
            end)
            b.delBtn:HookScript("OnLeave", function()
                b:GetScript("OnLeave")(b)
            end)
            b.delBtn:SetScript("OnClick", function()
                -- update db
                F:TRemove(CellDB["customTextures"], path)
                -- reload
                LoadTextures()
            end)
        end

        -- point
        b:ClearAllPoints()
        b:SetParent(scrollFrame.content)
        b:Show()
        if i == 1 then
            b:SetPoint("TOPLEFT", 5, 0)
        elseif i % 7 == 1 then
            b:SetPoint("TOPLEFT", buttons[i-7], "BOTTOMLEFT", 0, -5)
        else
            b:SetPoint("TOPLEFT", buttons[i-1], "TOPRIGHT", 5, 0)
        end

        -- texture
        if strfind(strlower(path), "^interface") then
            b.tex:SetTexture(path)
        else
            b.tex:SetAtlas(path)
        end

        -- onclick
        b:SetScript("OnClick", function(self, button)
            selectedPath = path
            for j, bb in pairs(buttons) do
                if i ~= j then
                    bb:SetBackdropBorderColor(0, 0, 0, 1)
                end
            end
        end)

        -- delete
        if i > builtIns then
            b.delBtn:Show()
        else
            b.delBtn:Hide()
        end

        -- highlight selected
        if selectedPath == path then
            b:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))
        else
            b:SetBackdropBorderColor(0, 0, 0, 1)
        end
    end

    -- hide others
    for i = textureNum+1, #buttons do
        buttons[i]:SetParent(nil)
        buttons[i]:ClearAllPoints()
        buttons[i]:Hide()
    end

    -- update height
    scrollFrame:SetContentHeight(50, math.ceil(textureNum/7), 5)
end

-------------------------------------------------
-- functions
-------------------------------------------------
function F:ShowTextureSelector(selected, callback)
    if not textureSelector then
        CreateTextureSelector()
    end
    
    Cell.frames.indicatorsTab.mask:Show()
    textureSelector:Show()

    selectedPath = selected
    LoadTextures()
    confirmBtn:SetScript("OnClick", function()
        textureSelector:Hide()
        if callback then callback(selectedPath) end
    end)
end