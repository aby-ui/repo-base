local L = CoreBuildLocale()
if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    L['Preview puzzle'] = "预览源锁界面"
    L['Cantaric Protolock'] = "声乐源锁"
    L['Mezzonic Protolock'] = "中音源锁"
    L['Fugueal Protolock'] = "赋格源锁"
    L["SCALE"] = "界面缩放"
    L["Default 1, Right click = reset"] = "默认为1, 右键点击重置"
    L["Enabled puzzle:"] = "对选中谜题启用助手:"
    L["SOLVE"] = "查看解谜步骤"
    L["RESET"] = "重置"
end

local aura_env = {}
aura_env.region = {}
aura_env.config = {}

aura_env.config.defaultCfg = {
    ["point"] = {
        "RIGHT", -- [1]
        -258, -- [2]
        73, -- [3]
    },
    ["scale"] = "1",
    ["puzzle"] = 2,
    ["puzzleEnabled"] = {
        true, -- [1]
        true, -- [2]
        true, -- [3]
    },
}
local loaded = true;

ZMPHSaved = ZMPHSaved or aura_env.config.defaultCfg

aura_env.dataIds = {}
function aura_env.updateData()
    aura_env.dataIds = {
        --Fugueal Protolock
        [366046] = ZMPHSaved.puzzleEnabled[3],
        [366108] = ZMPHSaved.puzzleEnabled[3],
        [359488] = ZMPHSaved.puzzleEnabled[3],
        --Mezzonic Protolock
        [366042] = ZMPHSaved.puzzleEnabled[2],
        [366106] = ZMPHSaved.puzzleEnabled[2],
        [351405] = ZMPHSaved.puzzleEnabled[2],
        --Cantaric Protolock
        [365840] = ZMPHSaved.puzzleEnabled[1],
        [366107] = ZMPHSaved.puzzleEnabled[1],
        [348792] = ZMPHSaved.puzzleEnabled[1],
    }
end 

aura_env.puzzleId = 0

aura_env.updateData()

local LibGlow = LibStub("LibCustomGlow-1.0")

local fontMain = GameFontNormal:GetFont() --"Interface\\Addons\\ZerethMortisPuzzleHelper\\Media\\Fonts\\FiraMono-Medium.ttf" --dont change.
local pathToMedia = "Interface\\Addons\\ZerethMortisPuzzleHelper\\Media\\"
local backdrop = { bgFile = pathToMedia.."Textures\\UI-Tooltip-Background.blp", edgeFile = pathToMedia.."Textures\\UI-Tooltip-Border.blp", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } }
local backdrop2 = { bgFile = pathToMedia.."Textures\\UI-Tooltip-Background.blp", tile = true, tileSize = 16, edgeFile = pathToMedia.."Textures\\WHITE8X8.BLP", edgeSize = 2 }


if aura_env.frame then
    aura_env.frame:Hide()
    aura_env.frame:SetParent(nil)
end

local function frameAddBg(frame, bd, color, border)
    frame:SetBackdrop(bd)
    frame:SetBackdropColor(unpack(color or {0,0,0,1}))
    frame:SetBackdropBorderColor(unpack(border or {1,1,1,1}))
end

local function WidgetButton_OnEnter(self)
    self:SetBackdropColor(0.2, 0.2, 0.2, 1)
    self:SetBackdropBorderColor(1, 1, 1, 1)
end

local function WidgetButton_OnLeave(self)
    self:SetBackdropColor(0, 0, 0, 0.5)
    self:SetBackdropBorderColor(1, 1, 1, 0.3)
end

local function WidgetButton_OnEnter2(self)
    self:SetBackdropBorderColor(0.59,0.98,0.59,1)  
end

local function WidgetButton_OnLeave2(self)
    self:SetBackdropColor(0, 0, 0, 0.7)
    self:SetBackdropBorderColor(1, 1, 1, 0.3)
end

local function frame_OnDragStart(self)
    self:StartMoving()
end

local function frame_OnDragStop(self)
    self:StopMovingOrSizing()
end

local function createDropdown(opts)
    local menuItems = opts['items'] or {}
    local titleText = opts['title'] or ""
    local dropdownWidth = 0
    local default = opts['default'] or ""
    local change = opts['changeFunc'] or function (dropdownVal) end
    local dropdown = CreateFrame("Frame", nil, aura_env.settingsFrame, 'UIDropDownMenuTemplate')
    local dropdownText = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dropdownText:SetPoint("TOPLEFT", 20, 10)
    for _, item in pairs(menuItems) do 
        dropdownText:SetText(item)
        local textWidth = dropdownText:GetStringWidth() + 20
        if textWidth > dropdownWidth then
            dropdownWidth = textWidth
        end
    end
    UIDropDownMenu_SetWidth(dropdown, dropdownWidth + 40)
    UIDropDownMenu_SetText(dropdown, default)
    dropdownText:SetText(titleText)
    UIDropDownMenu_Initialize(dropdown, function(self, level, _)
            local info = UIDropDownMenu_CreateInfo()
            for key, val in pairs(menuItems) do
                info.text = val;
                info.checked = false
                info.menuList= key
                info.hasArrow = false
                info.func = function(b)
                    UIDropDownMenu_SetSelectedValue(dropdown, b.value, b.value)
                    UIDropDownMenu_SetText(dropdown, b.value)
                    b.checked = true
                    change(dropdown, b.menuList)
                end
                UIDropDownMenu_AddButton(info)
            end
    end)
    return dropdown
end

local function createCheckButton(frame, x, y, text)
    local checkButton = CreateFrame("CheckButton", nil, frame, "ChatConfigCheckButtonTemplate");
    checkButton:SetPoint("TOPLEFT", frame, x, y)
    checkButton:SetSize(25,25)
    checkButton.text = checkButton:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    checkButton.text:SetPoint("LEFT",  checkButton, 25, 0)
    checkButton.text:SetText(text)
    return checkButton
end

local function puzzleStarter(id,show, setID)
    local waOptions = setID
    if show then
        
        aura_env.reset()
        --Fugueal Protolock
        if id == 366046 or id == 366108 or id == 359488 or waOptions == 3 then
            aura_env.frame:SetSize(640, 675)
            aura_env.puzzle3()
        end
        
        --Mezzonic Protolock
        if id == 366042 or id == 366106 or id == 351405 or waOptions == 2  then
            aura_env.frame:SetSize(515, 530)
            aura_env.puzzle2()
        end    
        
        --Cantaric Protolock
        if id == 365840 or id == 366107 or id == 348792 or waOptions == 1  then
            aura_env.frame:SetSize(582, 520)
            aura_env.puzzle1()
        end    
    else
        if not aura_env.frame then return end --abyui
        aura_env.frame:Hide()
        aura_env.frame:SetParent(nil)
    end 
end

aura_env.settingsFrame = CreateFrame('Frame', nil, UIParent, 'BackdropTemplate')
aura_env.settingsFrame:ClearAllPoints()
aura_env.settingsFrame:SetSize(320, 350)
aura_env.settingsFrame:SetPoint("CENTER")
aura_env.settingsFrame:EnableMouse(true)
aura_env.settingsFrame:SetClampedToScreen(true)
aura_env.settingsFrame:SetDontSavePosition(true)
aura_env.settingsFrame:SetMovable(true)
aura_env.settingsFrame:RegisterForDrag("LeftButton")
aura_env.settingsFrame:SetScript("OnDragStart", frame_OnDragStart)
aura_env.settingsFrame:SetScript("OnDragStop", frame_OnDragStop)  
aura_env.settingsFrame:SetScale(1)
frameAddBg(aura_env.settingsFrame, backdrop2, {0,0,0,0.3}, {1,1,1,0.3})
aura_env.settingsFrame:Hide()

local closeButtonSettings = CreateFrame('Button', nil, aura_env.settingsFrame, 'BackdropTemplate')
closeButtonSettings:ClearAllPoints()
closeButtonSettings:SetPoint("TOPRIGHT", aura_env.settingsFrame, "TOPRIGHT", 3, 3)
closeButtonSettings:SetSize(25, 25)
closeButtonSettings.texture = closeButtonSettings:CreateTexture("Texture", 'ARTWORK')
closeButtonSettings.texture:SetPoint('CENTER')
closeButtonSettings.texture:SetTexture(pathToMedia.."Textures\\cancel-icon.tga")

closeButtonSettings.texture:SetSize(15, 15)
closeButtonSettings.texture:SetDesaturated(1)
closeButtonSettings:SetScript("OnEnter", function(self) self.texture:SetDesaturated(nil) end)
closeButtonSettings:SetScript("OnLeave", function(self) self.texture:SetDesaturated(1) end)
closeButtonSettings:SetScript("OnClick", function(self) self:GetParent():Hide();aura_env.frame:Hide(); end)


local sliderScale = CreateFrame("Slider", nil, aura_env.settingsFrame, "OptionsSliderTemplate");
sliderScale:SetPoint("TOP", aura_env.settingsFrame, "TOP", 0, -30)
sliderScale:SetMinMaxValues(0.2, 2);
sliderScale:SetValue(1);
sliderScale:SetValueStep(0.01);
sliderScale:SetObeyStepOnDrag(true)
sliderScale.tooltipText = L"Default 1, Right click = reset"
sliderScale.disable = nil;

local sliderValueText = sliderScale:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
sliderValueText:SetPoint("TOP", sliderScale, "BOTTOM", -5, 0)
sliderValueText:SetText(1)

sliderScale:SetScript("OnValueChanged", function(self, value)
        if aura_env.frame then
            if self.disable then
                return
            end
            aura_env.frame:SetScale(string.format("%.3g", value));
            ZMPHSaved.scale = string.format("%.3g", value)
            sliderValueText:SetText(string.format("%.3g", value))
        end   
end)

sliderScale:SetScript("OnMouseUp", function (self, button)
        if button == "RightButton" then
            self.disable = nil
        end
end)

sliderScale:SetScript("OnMouseDown", function (self, button)
        if button=="RightButton" then 
            self.disable = true
            aura_env.frame:SetScale(string.format("%.3g", 1.0));
            ZMPHSaved.scale = string.format("%.3g", 1.0)
            sliderValueText:SetText(string.format("%.3g", 1.0))
        end
end)

local sliderHeadText =  aura_env.settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
sliderHeadText:SetPoint("TOP",  aura_env.settingsFrame, "TOP", 0, -10)
sliderHeadText:SetText(L"SCALE")

local optionsVersionText =  aura_env.settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
optionsVersionText:SetPoint("BOTTOM",  aura_env.settingsFrame, "BOTTOM", 0, 10)
optionsVersionText:SetText("ZMPH 1.6.2")
optionsVersionText:SetFont(fontMain, 12, "OUTLINE")

local groupEnabled = CreateFrame('Frame', nil, aura_env.settingsFrame, 'BackdropTemplate')
groupEnabled:ClearAllPoints()
groupEnabled:SetSize(300, 110)
groupEnabled:SetPoint("TOPLEFT",aura_env.settingsFrame, 10, -105) 
frameAddBg(groupEnabled, backdrop, {0,0,0,0.3}, {1,1,1,0.3})
groupEnabled.text = groupEnabled:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
groupEnabled.text:SetPoint("TOPLEFT",  groupEnabled, 10, 12)
groupEnabled.text:SetText(L"Enabled puzzle:")
groupEnabled.text:SetFont(fontMain, 12)

local puzzleOpts = {
    ['title']=L'Preview puzzle',
    ['items']= {L'Cantaric Protolock', L'Mezzonic Protolock', L'Fugueal Protolock' },
    ['default']=L'Mezzonic Protolock',
    ['changeFunc']=function(dropdownFrame, dropdownVal)
        ZMPHSaved.puzzle = dropdownVal
        puzzleStarter(13,true,ZMPHSaved.puzzle)
    end
}

local previewSelect = createDropdown(puzzleOpts)
previewSelect:SetPoint("BOTTOMLEFT", groupEnabled, -10, -60);

local checkButtonPuzzle = {}
checkButtonPuzzle[1] = createCheckButton(aura_env.settingsFrame, 25, -120, L"Cantaric Protolock")
checkButtonPuzzle[2] = createCheckButton(aura_env.settingsFrame, 170, -120, L"Mezzonic Protolock")
checkButtonPuzzle[3] = createCheckButton(aura_env.settingsFrame, 25, -170, L"Fugueal Protolock")

checkButtonPuzzle[1]:SetScript("OnClick",  function(self) local setChange = self:GetChecked();ZMPHSaved.puzzleEnabled[1] = setChange;aura_env.updateData() end);
checkButtonPuzzle[2]:SetScript("OnClick", function(self) local setChange = self:GetChecked();ZMPHSaved.puzzleEnabled[2] = setChange;aura_env.updateData() end);
checkButtonPuzzle[3]:SetScript("OnClick", function(self) local setChange = self:GetChecked();ZMPHSaved.puzzleEnabled[3] = setChange;aura_env.updateData() end);

aura_env.settingsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
aura_env.settingsFrame:RegisterEvent("ZONE_CHANGED")
aura_env.settingsFrame:SetScript("OnEvent", function(self, event)
        if (event == "PLAYER_ENTERING_WORLD") then
            if loaded then
                sliderValueText:SetText(ZMPHSaved.scale)
                sliderScale:SetValue(ZMPHSaved.scale);
                checkButtonPuzzle[1]:SetChecked(ZMPHSaved.puzzleEnabled[1])
                checkButtonPuzzle[2]:SetChecked(ZMPHSaved.puzzleEnabled[2])
                checkButtonPuzzle[3]:SetChecked(ZMPHSaved.puzzleEnabled[3])
                aura_env.updateData()
                loaded = false
            end
        end
        if (event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED") then
            local bestMapID = C_Map.GetBestMapForUnit("player")
            if bestMapID == 1970 then
                self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            else 
                self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            end
        end
        if event == "COMBAT_LOG_EVENT_UNFILTERED" then
            local _,subevent,_,_,_,_,_,_,destName,_,_,spellId = CombatLogGetCurrentEventInfo()
            
            if subevent == "SPELL_AURA_APPLIED" then 
                if destName == UnitName("player") then
                    if aura_env.dataIds[spellId] then
                        aura_env.puzzleId = spellId 
                        puzzleStarter(aura_env.puzzleId,true, 0)
                    end  
                end
            end
            
            if subevent == "SPELL_AURA_REMOVED" then 
                if destName == UnitName("player") then
                    if aura_env.dataIds[spellId] then
                        aura_env.puzzleId = 0
                        puzzleStarter(aura_env.puzzleId,false, 0)
                    end  
                end
            end
            
        end
end)

function aura_env.reset()
    if aura_env.frame then
        aura_env.frame:Hide()
        aura_env.frame:SetParent(nil)
    end
    
    aura_env.frame = CreateFrame('Frame', nil, UIParent, 'BackdropTemplate')
    aura_env.frame:ClearAllPoints()
    
    aura_env.frame:SetSize(450, 450)
    aura_env.frame:SetPoint(ZMPHSaved.point[1], ZMPHSaved.point[2], ZMPHSaved.point[3])
    
    aura_env.frame:EnableMouse(true)
    aura_env.frame:SetClampedToScreen(true)
    aura_env.frame:SetDontSavePosition(true)
    aura_env.frame:SetMovable(true)
    aura_env.frame:RegisterForDrag("LeftButton")
    aura_env.frame:SetScript("OnDragStart", function(self) self:StartMoving();  end)
    aura_env.frame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing();
            local point, relativeTo, relativePoint, xOfs, yOfs = aura_env.frame:GetPoint()
            ZMPHSaved.point = {point,xOfs,yOfs}                
    end)  
    aura_env.frame:SetScale(ZMPHSaved.scale)
    frameAddBg(aura_env.frame, backdrop2, {0,0,0,0.3}, {1,1,1,0.3})
    
    local closeButton = CreateFrame('Button', nil, aura_env.frame, 'BackdropTemplate')
    closeButton:ClearAllPoints()
    closeButton:SetPoint("TOPRIGHT", aura_env.frame, "TOPRIGHT", 3, 3)
    closeButton:SetSize(25, 25)
    closeButton.texture = closeButton:CreateTexture("Texture", 'ARTWORK')
    closeButton.texture:SetPoint('CENTER')
    closeButton.texture:SetTexture(pathToMedia.."Textures\\cancel-icon.tga")
    closeButton.texture:SetSize(15, 15)
    closeButton.texture:SetDesaturated(1)
    closeButton:SetScript("OnEnter", function(self) self.texture:SetDesaturated(nil) end)
    closeButton:SetScript("OnLeave", function(self) self.texture:SetDesaturated(1) end)
    closeButton:SetScript("OnClick", function(self) self:GetParent():Hide() end)
end

function aura_env.puzzle3()    
    
    local groupsObjects = {{}, {}, {}}
    
    local objects = {
        [1]={0,0,0,0},[2]={0,0,0,0},[3]={0,0,0,0},
        [4]={0,0,0,0},[5]={0,0,0,0},[6]={0,0,0,0},
        [7]={0,0,0,0},[8]={0,0,0,0},[9]={0,0,0,0},
    };
    
    local function createButton(group, y, x, text)
        
        local widget = CreateFrame('Button', nil, group, 'BackdropTemplate')
        widget:ClearAllPoints()
        widget:SetPoint("TOPLEFT", group, "TOPLEFT", 24 + ((x-1) * 50), -12 - (y * 45))
        widget:SetSize(50, 40)
        widget.text = widget:CreateFontString(nil, nil, "GameFontNormal")
        widget.text:SetPoint("CENTER")
        widget.text:SetTextColor(1,1,1,1)
        widget.text:SetText(text)
        widget.text:SetJustifyH("CENTER")
        widget.text:SetFont(fontMain, 16)
        frameAddBg(widget,backdrop, {0,0,0,0.5}, {1,1,1,0.3})
        widget:SetScript("OnEnter", WidgetButton_OnEnter)
        widget:SetScript("OnLeave", WidgetButton_OnLeave)
        widget.glow = false;
        return widget;
        
    end
    
    local function createTexture(frame, id, type)
        local figures = {
            "Interface\\Icons\\inv_prg_icon_puzzle13",
            "Interface\\Icons\\inv_prg_icon_puzzle14",
            "Interface\\Icons\\inv_prg_icon_puzzle06"
        }
        local shapes = {
            pathToMedia.."Textures\\Ring_40px.tga",
            pathToMedia.."Textures\\square_border_10px.tga",
            pathToMedia.."Textures\\Square_White.tga"
        }
        local texture = frame:CreateTexture("Texture", 'ARTWORK')
        texture:SetPoint('CENTER')
        
        if type == 3 then
            texture:SetTexture(figures[id])
            texture:SetTexCoord(0.1,0.90,0.1,0.90)
            texture:SetSize(28, 28)
            if id == 2 then
                texture:SetRotation(1.5708)
            end    
        end
        
        if type == 2 then 
            local textLines = {}
            local settingsLines = {[1] = {"CENTER", 0}, [2] = {"CENTER", -5, "CENTER", 5}, [3] = {"CENTER", 0, "CENTER", -10, "CENTER", 9.5}}
            local cc = 2;
            for w = 1, id do
                textLines[w] = frame:CreateFontString(nil, nil, "GameFontNormal")
                textLines[w]:SetPoint(settingsLines[id][cc-1], frame, 0 , settingsLines[id][cc] + 17)    
                textLines[w]:SetTextColor(1,1,1,1)
                textLines[w]:SetText("_")
                textLines[w]:SetJustifyH("CENTER")
                textLines[w]:SetFont(fontMain, 38)
                cc = cc + 2
            end
        end
        
        if type == 1 then
            texture:SetTexture(shapes[id])
            texture:SetSize(24, 24)
            texture:SetAlpha(0.75)
            if id == 3 then 
                local mask = frame:CreateMaskTexture()
                mask:SetAllPoints(texture)
                mask:SetTexture("Interface/ARCHEOLOGY/Arch-Keystone-Mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
                texture:AddMaskTexture(mask)
            end     
        end
        
        return texture
    end
    
    
    for y1 = 1, 3 do
        for x1 = 1, 3 do
            groupsObjects[y1][x1] = CreateFrame('Frame', nil, aura_env.frame, 'BackdropTemplate')
            groupsObjects[y1][x1]:ClearAllPoints()
            groupsObjects[y1][x1]:SetPoint("TOPLEFT", aura_env.frame, "TOPLEFT", 10 + ((x1-1)* 210), -13 - ((y1-1)* 210))
            groupsObjects[y1][x1]:SetSize(200, 200)
            frameAddBg(groupsObjects[y1][x1], backdrop, {0,0,0,0.35}, {1,1,1,0.3})
            groupsObjects[y1][x1].buttons = { {}, {}, {} , {} }
            for y = 1, 4 do
                for x = 1, 3 do
                    if y==4 then
                        groupsObjects[y1][x1].buttons[y][x] = createButton(groupsObjects[y1][x1], (y-1), x, x)
                    else
                        groupsObjects[y1][x1].buttons[y][x] = createButton(groupsObjects[y1][x1], (y-1), x, "")
                        groupsObjects[y1][x1].buttons[y][x].texture = createTexture(groupsObjects[y1][x1].buttons[y][x], x, y)
                    end
                    
                    groupsObjects[y1][x1].buttons[y][x]:SetScript("OnClick", function(self)
                            for z = 1, 3 do
                                LibGlow.ButtonGlow_Stop(groupsObjects[y1][x1].buttons[y][z])
                                if z~=x then
                                    groupsObjects[y1][x1].buttons[y][z].glow = false;
                                end
                            end
                            local idGroup = x1+((y1-1)*3);
                            if (groupsObjects[y1][x1].buttons[y][x].glow == false) then
                                LibGlow.ButtonGlow_Start(groupsObjects[y1][x1].buttons[y][x])
                                groupsObjects[y1][x1].buttons[y][x].glow = true;
                                objects[idGroup][y] = x;
                            else
                                groupsObjects[y1][x1].buttons[y][x].glow = false;
                                objects[idGroup][y] = 0;
                            end
                    end) 
                end
            end
        end
    end
    
    local function solve(x1,x2,x3) 
        local result = {false,false,false,false};   
        for i = 1, 4 do
            if objects[x1][i] ~= 0 and objects[x1][i] == objects[x2][i] and objects[x1][i] == objects[x3][i] then result[i] = true end
            local dif = {};
            local check = {};
            for _,v in ipairs({objects[x1][i],objects[x2][i],objects[x3][i]}) do
                if (not check[v]) then
                    dif[#dif+1] = v 
                    check[v] = true
                end
            end
            if #dif == 3 then result[i] = true end
        end
        return result[1] == true and result[2] == true and result[3] == true and result[4] == true
    end
    
    local function drawSolution(id,group) 
        local colors = { {1,0.31,0.31,1}, {0,0.6,1,1}, {0.2,0.8,0.2,1}};
        local ref = {
            [1]={1,1},[2]={1,2},[3]={1,3},
            [4]={2,1},[5]={2,2},[6]={2,3},
            [7]={3,1},[8]={3,2},[9]={3,3},
        };
        groupsObjects[ref[id][1]][ref[id][2]]:SetBackdropColor(unpack(colors[group]))
        groupsObjects[ref[id][1]][ref[id][2]]:SetBackdropBorderColor(unpack({1,1,1,1})) 
    end
    
    local solveButton = createButton(groupsObjects[3][1], 4, 1, L"SOLVE")
    solveButton:SetPoint("TOPLEFT", groupsObjects[3][1], "TOPLEFT", 0, -205)
    solveButton:SetSize(410, 30)
    frameAddBg(solveButton, backdrop2, {0,0,0,0.7}, {1,1,1,0.3})
    solveButton:SetScript("OnEnter", WidgetButton_OnEnter2)
    solveButton:SetScript("OnLeave", WidgetButton_OnLeave2)
    
    local resetButton = createButton(groupsObjects[3][3], 4, 3, L"RESET")
    resetButton:SetPoint("TOPLEFT", groupsObjects[3][3], "TOPLEFT", 0, -205)
    resetButton:SetSize(200, 30)
    frameAddBg(resetButton, backdrop2, {0,0,0,0.7}, {1,1,1,0.3})
    resetButton:SetScript("OnEnter", WidgetButton_OnEnter2)
    resetButton:SetScript("OnLeave", WidgetButton_OnLeave2)
    
    resetButton:SetScript("OnClick", function(self)
            objects = {
                [1]={0,0,0,0},[2]={0,0,0,0},[3]={0,0,0,0},
                [4]={0,0,0,0},[5]={0,0,0,0},[6]={0,0,0,0},
                [7]={0,0,0,0},[8]={0,0,0,0},[9]={0,0,0,0},
            };
            for y1 = 1, 3 do 
                for x1 = 1, 3 do
                    frameAddBg(groupsObjects[y1][x1], backdrop, {0,0,0,0.35}, {1,1,1,0.3})
                    for y = 1, 4 do
                        for x = 1, 3 do
                            LibGlow.ButtonGlow_Stop(groupsObjects[y1][x1].buttons[y][x])
                            groupsObjects[y1][x1].buttons[y][x].glow = false;
                            groupsObjects[y1][x1].buttons[y][x]:Show();
                        end
                    end
                end
            end
    end)
    
    local function findSolutionReverse()
        local used = {};
        local solveCount = 0;
        local draws = {}
        for t = 9, 1, -1 do
            if (not used[t]) then
                local pickInt = t;
                for i = 9, 1, -1 do
                    if i ~= pickInt then
                        for x=9, 1,-1 do
                            if x ~= pickInt and x<i and not used[t] and not used[i] and not used[x] then
                                if (solve(pickInt,i,x)) then
                                    solveCount = solveCount + 1;     
                                    table.insert(draws,{pickInt,solveCount})
                                    table.insert(draws,{i,solveCount})
                                    table.insert(draws,{x,solveCount})
                                    used[pickInt] = true; 
                                    used[i] = true;
                                    used[x] = true;
                                end
                            end
                        end
                    end
                end
            end
        end   
        return used,draws
    end
    
    solveButton:SetScript("OnClick", function(self)
            local used = {};
            local solveCount = 0;
            local draws = {}
            
            for t = 1, 9 do
                if (not used[t]) then
                    local pickInt = t;
                    for i = 1, 9 do
                        if i ~= pickInt then
                            for x=1, 9 do
                                if x ~= pickInt and x>i and not used[t] and not used[i] and not used[x] then
                                    if (solve(pickInt,i,x)) then
                                        solveCount = solveCount + 1;
                                        
                                        table.insert(draws,{pickInt,solveCount})
                                        table.insert(draws,{i,solveCount})
                                        table.insert(draws,{x,solveCount})
                                        
                                        used[pickInt] = true; 
                                        used[i] = true;
                                        used[x] = true;
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            if #used ~= 9 then
                used,draws = findSolutionReverse();
            end
            
            for i = 1, #draws do
                drawSolution(draws[i][1],draws[i][2])
            end
            
            if #used ~= 9 then
                print("Zereth Mortis Puzzle Helper: Solution not found")
            else
                for y1 = 1, 3 do 
                    for x1 = 1, 3 do
                        for y = 1, 4 do
                            for x = 1, 3 do
                                groupsObjects[y1][x1].buttons[y][x]:Hide();
                            end
                        end
                    end
                end
            end
    end)
end

function aura_env.puzzle1()
    
    local function createButton(group, y, x, text, active, hidden)
        local widget = CreateFrame('Button', nil, group, 'BackdropTemplate')
        widget:ClearAllPoints()
        widget:SetPoint("TOPLEFT", group, "TOPLEFT", 3 + ((x-1) * 51), -12 - (y * 41))
        widget:SetSize(50, 40)
        widget.text = widget:CreateFontString(nil, nil, "GameFontNormal")
        widget.text:SetPoint("CENTER")
        widget.text:SetTextColor(1,1,1,1)
        widget.text:SetText(text)
        widget.text:SetJustifyH("CENTER")
        widget.text:SetFont(fontMain, 16)
        if active then
            frameAddBg(widget,backdrop2, {0,0,0,0.5}, {1,1,1,0.3})
            widget:SetScript("OnEnter", WidgetButton_OnEnter)
            widget:SetScript("OnLeave", WidgetButton_OnLeave)
        else
            frameAddBg(widget,backdrop2, {0,0,0,0.1}, {1,1,1,0.3})
        end
        if hidden then
            --widget:Hide()
            widget:SetBackdrop(nil)
            widget:SetBackdropColor(nil)
            widget:SetBackdropBorderColor(nil)
        end
        widget.glow = false;
        widget.draw = false;
        return widget;
    end
    
    local function createTexture(frame,type)
        local textureType = {"Interface\\Addons\\ZerethMortisPuzzleHelper\\Media\\Textures\\lightsTexture.tga","Interface\\Icons\\inv_prg_icon_puzzle13"}
        local texture = frame:CreateTexture("Texture", 'ARTWORK')
        texture:SetPoint('CENTER')
        texture:SetTexture(textureType[type])
        texture:SetSize(30, 30)
        texture:Hide()
        if type==2 then 
            texture:SetTexCoord(0.1,0.90,0.1,0.90)
            -- texture:SetVertexColor(0.4, 0.4, 0.6, 1.0)
            texture:SetSize(28, 28)
            
            texture:Show()
        end
        return texture
    end
    
    local groupButtons = CreateFrame('Frame', nil, aura_env.frame, 'BackdropTemplate')
    groupButtons:ClearAllPoints()
    groupButtons:SetPoint("TOPLEFT", aura_env.frame, "TOPLEFT", 10 + ((1-1)* 210), -10 - ((1-1)* 210))
    groupButtons:SetSize(610, 510)
    groupButtons.buttonsPuzzle = { {}, {} }
    groupButtons.buttons = { {}, {}, {}, {}, {}, {}, {}, {}, {} }
    groupButtons.buttonsSolve = { {}, {} }
    for y = 1, 2 do
        for x = 1, 10 do
            if y == 1 then
                if (x<10) then
                    groupButtons.buttonsPuzzle[y][x] = createButton(groupButtons, x - 1, y + 1, x, true, false)
                    groupButtons.buttonsPuzzle[y][x].texture = createTexture(groupButtons.buttonsPuzzle[y][x],1)
                end
                groupButtons.buttonsSolve[y][x] = createButton(groupButtons, x - 1, y , "", true, true)
                groupButtons.buttonsSolve[y][x].texture = createTexture(groupButtons.buttonsSolve[y][x],2)
            else
                groupButtons.buttonsPuzzle[y][x] = createButton(groupButtons, 9, x + 1, x, true, false)
                groupButtons.buttonsPuzzle[y][x].texture = createTexture(groupButtons.buttonsPuzzle[y][x],1)
                groupButtons.buttonsSolve[y][x] = createButton(groupButtons, 10, x + 1, "", true, true)
                groupButtons.buttonsSolve[y][x].texture = createTexture(groupButtons.buttonsSolve[y][x],2)
            end
            
            if groupButtons.buttonsPuzzle[y][x] then
                groupButtons.buttonsPuzzle[y][x]:SetScript("OnClick", function(self)            
                        if (groupButtons.buttonsPuzzle[y][x].glow == false) then
                            LibGlow.ButtonGlow_Start(groupButtons.buttonsPuzzle[y][x])
                            groupButtons.buttonsPuzzle[y][x].glow = true;
                            groupButtons.buttonsPuzzle[y][x].texture:Show()  
                        else
                            LibGlow.ButtonGlow_Stop(groupButtons.buttonsPuzzle[y][x])
                            groupButtons.buttonsPuzzle[y][x].glow = false;
                            groupButtons.buttonsPuzzle[y][x].texture:Hide()
                        end
                end)
            end
        end
    end
    for y = 1, 9 do 
        for x = 1, 9 do
            groupButtons.buttons[y][x] = createButton(groupButtons, y - 1, x + 2, "", false, false)
            groupButtons.buttons[y][x].texture = createTexture(groupButtons.buttons[y][x],1)
        end
    end
    
    local solveButton = createButton(groupButtons, 1, 1, L"SOLVE", true)
    solveButton:SetPoint("TOPLEFT", groupButtons, "TOPLEFT", 52, -465)
    solveButton:SetSize(340, 30)
    frameAddBg(solveButton, backdrop2, {0,0,0,0.7}, {1,1,1,0.3})
    solveButton:SetScript("OnEnter", WidgetButton_OnEnter2)
    solveButton:SetScript("OnLeave", WidgetButton_OnLeave2)
    
    local resetButton = createButton(groupButtons, 1, 1, L"RESET", true)
    resetButton:SetPoint("TOPLEFT", groupButtons, "TOPLEFT", 402, -465)
    resetButton:SetSize(160, 30)
    frameAddBg(resetButton, backdrop2, {0,0,0,0.7}, {1,1,1,0.3})
    resetButton:SetScript("OnEnter", WidgetButton_OnEnter2)
    resetButton:SetScript("OnLeave", WidgetButton_OnLeave2)
    
    solveButton:SetScript("OnClick", function(self)
            local line1 = 0
            local line2 = 0
            for i=1, 9 do
                if groupButtons.buttonsPuzzle[1][i].glow == true then line1 = line1 + 1 end
            end
            if groupButtons.buttonsPuzzle[2][1].glow == true then line1 = line1 + 1; line2 = line2 + 1 end
            for i=1, 9 do
                if groupButtons.buttonsPuzzle[2][i + 1].glow == true then line2 = line2 + 1 end
            end   
            
            for y = 1, 2 do
                for x = 1, 10 do
                    if ((y == 1 and x < 10) or y == 2) then
                        groupButtons.buttonsPuzzle[y][x].text:SetText("")
                        groupButtons.buttonsPuzzle[y][x].texture:Hide();
                        LibGlow.ButtonGlow_Stop(groupButtons.buttonsPuzzle[y][x])                      
                    end
                end 
            end   
            
            local function drawLine(node,act)
                if act then
                    node.texture:Show()
                    node.draw = true
                else
                    node.texture:Hide()
                    node.draw = false;
                end
            end
            
            local function setNode(button, set)
                button.text:SetText(set)
                button.text:SetPoint("CENTER")          
                button.texture:Show();   
                LibGlow.ButtonGlow_Start(button) 
                button:Show();
                button.texture:SetVertexColor(0.4, 0.4, 0.6, 1.0)
            end
            
            local function reverseNode(node)
                if node then return false end
                if node == false then return true end            
            end
            
            local function checkSolve(board,r1,r2)
                local simBoard = {}
                local countTick = 0
                
                for y=1,10 do 
                    simBoard[y] = {}
                    for x=1,10 do 
                        simBoard[y][x] = board[y][x]
                    end
                end
                
                --sim actions
                for y=1,10 do
                    if board[y][1] == r1 then 
                        countTick = countTick + 1
                        for x=1,10 do 
                            simBoard[y][x] = reverseNode(simBoard[y][x])
                        end
                    end
                end
                
                for x=1,10 do
                    if board[10][x] == r2 then 
                        countTick = countTick + 1
                        for y=1,10 do 
                            simBoard[y][x] = reverseNode(simBoard[y][x])
                        end
                    end
                end
                
                --check solve
                local solved = countTick <= 7;
                
                for y=1,10 do
                    for x=1,10 do 
                        if simBoard[y][x] then solved = false;break; end
                    end
                end
                
                return solved 
            end
            
            local function drawBoard(board)
                for y=1,9 do 
                    for x=1,9 do
                        drawLine(groupButtons.buttons[y][x], board[y][x+1])
                    end
                end
                for x=1,9 do 
                    drawLine(groupButtons.buttonsPuzzle[1][x], board[x][1])
                end
                drawLine(groupButtons.buttonsPuzzle[2][1], board[10][1])
                for x=2,10 do 
                    drawLine(groupButtons.buttonsPuzzle[2][x], board[10][x])
                end
                
            end
            
            local board = {}
            for y=1,9 do 
                board[y] = {}
                for x=1,10 do
                    board[y][x] = groupButtons.buttonsPuzzle[1][y].glow
                end
            end
            board[10] = {}
            for x=1,10 do
                board[10][x] = groupButtons.buttonsPuzzle[2][1].glow
            end
            for x=1,10 do
                if groupButtons.buttonsPuzzle[2][x].glow ~= board[10][1] then
                    for y=1,10 do
                        board[y][x] = reverseNode(board[y][x])
                    end
                end
            end
            
            drawBoard(board)
            
            for y = 1, 2 do
                for x = 1, 10 do
                    groupButtons.buttonsSolve[y][x].texture:Hide()
                    groupButtons.buttonsSolve[y][x]:Hide(); 
                end
            end
            
            --v1.5 solution
            local rev1 = line1 <= 5
            local rev2 = true
            
            if checkSolve(board,true,true) then rev1 = true;rev2 = true; end
            if checkSolve(board,true,false) then rev1 = true; rev2 = false; end
            if checkSolve(board,false,true) then rev1 = false; rev2 = true; end
            if checkSolve(board,false,false) then rev1 = false; rev2 = false; end
            
            local set = 1;
            
            for i=1, 9 do
                if groupButtons.buttonsPuzzle[1][i].glow == rev1 then 
                    setNode(groupButtons.buttonsSolve[1][i],set)    
                    set = set + 1
                end
            end
            if groupButtons.buttonsPuzzle[2][1].glow == rev1 then
                setNode(groupButtons.buttonsSolve[1][10],set)    
                set = set + 1
            end           
            for i=1, 10 do
                if groupButtons.buttonsPuzzle[2][i].glow == rev2 then 
                    setNode(groupButtons.buttonsSolve[2][i],set)  
                    set = set + 1
                end
            end
            
            for y = 1, 2 do
                for x = 1, 10 do
                    if ((y == 1 and x < 10) or y == 2) then
                        groupButtons.buttonsPuzzle[y][x].glow = false
                    end
                end 
            end   
    end)
    
    resetButton:SetScript("OnClick", function(self)
            for y = 1, 2 do
                for x = 1, 10 do
                    if ((y == 1 and x < 10) or y == 2) then
                        groupButtons.buttonsPuzzle[y][x].text:SetText(x)
                        groupButtons.buttonsPuzzle[y][x].texture:Hide();
                        groupButtons.buttonsPuzzle[y][x].glow = false
                        groupButtons.buttonsPuzzle[y][x].draw = false;
                        LibGlow.ButtonGlow_Stop(groupButtons.buttonsPuzzle[y][x])                    
                    end
                    
                    groupButtons.buttonsSolve[y][x].texture:Show();
                    groupButtons.buttonsSolve[y][x].glow = false
                    groupButtons.buttonsSolve[y][x].draw = false;
                    groupButtons.buttonsSolve[y][x]:Show(); 
                    groupButtons.buttonsSolve[y][x].texture:SetVertexColor(1,1,1,1)
                    groupButtons.buttonsSolve[y][x].text:SetText("")
                    LibGlow.ButtonGlow_Stop(groupButtons.buttonsSolve[y][x]) 
                end 
            end       
            for y = 1, 9 do 
                for x = 1, 9 do
                    groupButtons.buttons[y][x].draw = false;
                    groupButtons.buttons[y][x].texture:Hide();
                end
            end 
    end)
end

function aura_env.puzzle2()
    
    local function createButton(group, y, x, text)
        local widget = CreateFrame('Button', nil, group, 'BackdropTemplate')
        widget:ClearAllPoints()
        widget:SetPoint("TOPLEFT", group, "TOPLEFT", 24 + ((x-1) * 90), -12 - ((y-1) * 90))
        widget:SetSize(90, 90)
        widget.text = widget:CreateFontString(nil, nil, "GameFontNormal")
        widget.text:SetPoint("CENTER")
        widget.text:SetTextColor(1,1,1,1)
        widget.text:SetText(text)
        widget.text:SetJustifyH("CENTER")
        widget.text:SetFont(fontMain, 16)
        frameAddBg(widget,backdrop2, {0,0,0,0.5}, {1,1,1,0.3})
        widget:SetScript("OnEnter", WidgetButton_OnEnter)
        widget:SetScript("OnLeave", WidgetButton_OnLeave)
        widget.glow = false;
        return widget;
    end
    
    local function createTexture(frame)
        local texture = frame:CreateTexture("Texture", 'ARTWORK')
        texture:SetPoint('CENTER')
        texture:SetTexture("Interface\\Addons\\ZerethMortisPuzzleHelper\\Media\\Textures\\lightsTexture.tga")
        texture:SetSize(80, 80)
        texture:Hide()
        return texture
    end
    
    local groupButtons = CreateFrame('Frame', nil, aura_env.frame, 'BackdropTemplate')
    groupButtons:ClearAllPoints()
    groupButtons:SetPoint("TOPLEFT", aura_env.frame, "TOPLEFT", 10 + ((1-1)* 210), -10 - ((1-1)* 210))
    groupButtons:SetSize(505, 510)
    --frameAddBg(groupButtons, backdrop2, {0,0,0,0.35}, {1,1,1,0.3})
    groupButtons.buttonsPuzzle = { {}, {}, {}, {}, {} }
    groupButtons.buttons = { {}, {}, {}, {}, {}}
    for y = 1, 5 do
        for x = 1, 5 do
            groupButtons.buttons[y][x] = createButton(groupButtons, y, x, "")
            groupButtons.buttons[y][x].texture = createTexture(groupButtons.buttons[y][x])
            groupButtons.buttons[y][x]:SetScript("OnClick", function(self)            
                    if (groupButtons.buttons[y][x].glow == false) then
                        LibGlow.ButtonGlow_Start(groupButtons.buttons[y][x])
                        groupButtons.buttons[y][x].glow = true;
                        groupButtons.buttons[y][x].texture:Show()
                    else
                        LibGlow.ButtonGlow_Stop(groupButtons.buttons[y][x])
                        groupButtons.buttons[y][x].glow = false;
                        groupButtons.buttons[y][x].texture:Hide()
                    end            
            end)
        end       
    end
    
    local solveButton = createButton(groupButtons, 1, 1, L"SOLVE")
    solveButton:SetPoint("TOPLEFT", groupButtons, "TOPLEFT", 24, -470)
    solveButton:SetSize(320, 30)
    frameAddBg(solveButton, backdrop2, {0,0,0,0.7}, {1,1,1,0.3})
    solveButton:SetScript("OnEnter", WidgetButton_OnEnter2)
    solveButton:SetScript("OnLeave", WidgetButton_OnLeave2)
    
    local resetButton = createButton(groupButtons, 1, 1, L"RESET")
    resetButton:SetPoint("TOPLEFT", groupButtons, "TOPLEFT", 352, -470)
    resetButton:SetSize(120, 30)
    frameAddBg(resetButton, backdrop2, {0,0,0,0.7}, {1,1,1,0.3})
    resetButton:SetScript("OnEnter", WidgetButton_OnEnter2)
    resetButton:SetScript("OnLeave", WidgetButton_OnLeave2)
    
    local function resetForm()
        for y=1,5 do
            for x=1,5 do
                LibGlow.ButtonGlow_Stop(groupButtons.buttons[y][x])
                groupButtons.buttons[y][x].texture:Hide()
                groupButtons.buttons[y][x].glow = false 
                groupButtons.buttons[y][x].text:SetText("") 
                frameAddBg(groupButtons.buttons[y][x], backdrop2, {0,0,0,0.5}, {1,1,1,0.3})
                groupButtons.buttons[y][x]:SetScript("OnEnter", WidgetButton_OnEnter)
                groupButtons.buttons[y][x]:SetScript("OnLeave", WidgetButton_OnLeave)
            end
        end  
    end
    
    resetButton:SetScript("OnClick", function(self) 
            resetForm();  
    end)
    
    solveButton:SetScript("OnClick", function(self)
            
            local function nextTick(sim, x, y)
                local dir = {{0,0},{1,0},{-1,0},{0,1},{0,-1}}
                if (x>=1 and x <=5 and y>=1 and y <=5) then
                    for i=1,5 do
                        local x1 = x + dir[i][1]
                        local y1 = y + dir[i][2]
                        if (x1>=1 and x1 <=5 and y1>=1 and y1 <=5) then
                            if sim[y1][x1] then sim[y1][x1] = false else sim[y1][x1] = true end
                        end
                    end
                end
                return sim;
            end
            
            local solved = false;
            --x,y,sx,sy
            local direction = {[1] = {0, 1, 1, 1},[2] = {0, -1, 1, 5},[3] = {1,0, 1, 1},[4] = {-1,0, 5, 1}}
            --[y,x,dir]
            
            -- Angle traps FIX 1.4 update
            local preMoves = {{},}
            local anglePos = {
                {{1,3},{2,1},{2,2},{{1,1},{1,2}}}, -- topleft
                {{1,2},{2,2},{3,1},{{1,1},{2,1}}}, -- topleft
                {{1,4},{2,4},{3,5},{{1,5},{2,5}}}, -- topright
                {{1,3},{2,4},{2,5},{{1,4},{1,5}}}, -- topright
                {{4,1},{4,2},{5,3},{{5,1},{5,2}}}, -- bottomleft
                {{3,1},{4,2},{5,2},{{4,1},{5,1}}}, -- bottomleft
                {{4,4},{4,5},{5,3},{{5,4},{5,5}}}, -- bottomright
                {{3,5},{4,4},{5,4},{{4,5},{5,5}}}, -- bottomright
                --
                {{1,1},{1,2},{2,1},{{1,1}}}, -- topleft
                {{4,1},{5,1},{5,2},{{5,1}}}, -- bottomleft
                {{1,4},{1,5},{2,5},{{1,5}}}, -- topright
                {{5,4},{5,5},{4,5},{{5,5}}} -- bottomright
            }
            
            for i=1,#anglePos do
                local angleTrap = true
                for p=1,3 do
                    local y = anglePos[i][p][1]
                    local x = anglePos[i][p][2]
                    if not groupButtons.buttons[y][x].glow then angleTrap = false end
                end
                if angleTrap then
                    table.insert(preMoves,anglePos[i][4])
                end
            end
            
            local function copy(group)
                local s = {{},{},{},{},{}}
                for y=1,5 do
                    for x=1,5 do
                        if group.buttons[y][x].glow then 
                            s[y][x] = true
                        else
                            s[y][x] = false
                        end
                    end
                end
                return s
            end
            
            local function copy2(g)
                local s = {{},{},{},{},{}}
                for y=1,5 do
                    for x=1,5 do
                        if g[y][x] then 
                            s[y][x] = true
                        else
                            s[y][x] = false
                        end
                    end
                end
                return s
            end
            
            local function checkSolution(sim)
                local result = true
                for y=1,5 do
                    for x=1,5 do
                        if sim[y][x] then 
                            result = false;
                            break;
                        end
                    end
                end
                return result
            end
            
            for r=1, #preMoves do
                local rMoves = 0
                local rPath = {}
                local preSimulation = copy(groupButtons)
                for ps=1, #preMoves[r] do
                    rMoves = rMoves + 1
                    rPath[rMoves] = {preMoves[r][ps][2],preMoves[r][ps][1]}
                    preSimulation = nextTick(preSimulation,preMoves[r][ps][2],preMoves[r][ps][1])
                end
                
                --up, bottom, left, right
                local edgeCheck = {0,0,0,0}
                local nodes = {0,0,0,0}
                local startNodes = {}
                
                for i=1,5 do 
                    if preSimulation[1][i] then edgeCheck[1] = edgeCheck[1] + 1; nodes[1]=nodes[1]+1;table.insert(startNodes,{1+direction[1][2],i,1}) else nodes[1]=0  end
                    if preSimulation[5][i] then edgeCheck[2] = edgeCheck[2] + 1; nodes[2]=nodes[2]+1;table.insert(startNodes,{5+direction[2][2],i,2}) else nodes[2]=0  end
                    if preSimulation[i][1] then edgeCheck[3] = edgeCheck[3] + 1; nodes[3]=nodes[3]+1;table.insert(startNodes,{i,1+direction[3][1],3}) else nodes[3]=0  end
                    if preSimulation[i][5] then edgeCheck[4] = edgeCheck[4] + 1; nodes[4]=nodes[4]+1;table.insert(startNodes,{i,5+direction[4][1],4}) else nodes[4]=0  end
                    for x=1,4 do
                        if nodes[x]>=3 then table.insert(startNodes,{direction[x][4] + math.abs(direction[x][1] * (i-2)) , direction[x][3]  + math.abs(direction[x][2] * (i-2)),x}) end
                    end
                end
                
                for i=1,4 do
                    if edgeCheck[i] == 0 then table.insert(startNodes,{-1,-1,i}) end
                end
                
                if preSimulation[1][1] then table.insert(startNodes, {1,1,1});table.insert(startNodes, {1,1,3}) end  
                if preSimulation[5][1] then table.insert(startNodes, {5,1,2});table.insert(startNodes, {5,1,3}) end
                if preSimulation[1][5] then table.insert(startNodes, {1,5,3});table.insert(startNodes, {1,5,4}) end
                if preSimulation[5][5] then table.insert(startNodes, {5,5,4});table.insert(startNodes, {5,5,4}) end
                
                for i=1,5 do 
                    if preSimulation[1][i] then table.insert(startNodes,{1,i,1}) end
                    if preSimulation[5][i] then table.insert(startNodes,{5,i,2}) end
                    if preSimulation[i][1] then table.insert(startNodes,{i,1,3}) end
                    if preSimulation[i][5] then table.insert(startNodes,{i,5,4}) end
                end
                
                if #startNodes > 0 then
                    for v=1, #startNodes do
                        if not solved then
                            local moves = 0
                            local path = {}
                            local id = startNodes[v][3]
                            local simulation = copy2(preSimulation)
                            
                            local x = startNodes[v][2]
                            local y = startNodes[v][1]
                            if (x ~= -1 and y ~= -1) then 
                                moves = moves + 1
                                path[moves] = {x,y}
                                simulation = nextTick(simulation,x,y)
                            end
                            
                            for times=0, 4 do
                                for i=0,4 do
                                    local x1 = direction[id][3]+math.abs(direction[id][2] * i) + direction[id][1] * times
                                    local y1 = direction[id][4]+math.abs(direction[id][1] * i) + direction[id][2] * times
                                    if simulation[y1][x1] then
                                        moves = moves + 1
                                        path[moves] = {x1+direction[id][1],y1+direction[id][2]}
                                        simulation = nextTick(simulation,x1+direction[id][1],y1+direction[id][2])
                                    end
                                end
                            end
                            
                            if moves+rMoves <= 5 and checkSolution(simulation) then
                                resetForm()
                                
                                for i=1, moves do
                                    local x2 = path[i][1]
                                    local y2 = path[i][2]
                                    groupButtons.buttons[y2][x2]:SetBackdropColor(unpack({0.2,0.8,0.2,1}))
                                    groupButtons.buttons[y2][x2]:SetBackdropBorderColor(unpack({1,1,1,1}))
                                    groupButtons.buttons[y2][x2].texture:Hide()
                                    groupButtons.buttons[y2][x2].text:SetText(i+rMoves)
                                    groupButtons.buttons[y2][x2]:SetScript("OnEnter", function() end)
                                    groupButtons.buttons[y2][x2]:SetScript("OnLeave", function() end)
                                end
                                for i=1,rMoves do
                                    local x2 = rPath[i][1]
                                    local y2 = rPath[i][2]
                                    groupButtons.buttons[y2][x2]:SetBackdropColor(unpack({0.2,0.8,0.2,1}))
                                    groupButtons.buttons[y2][x2]:SetBackdropBorderColor(unpack({1,1,1,1}))
                                    groupButtons.buttons[y2][x2].texture:Hide()
                                    groupButtons.buttons[y2][x2].text:SetText(i)
                                    groupButtons.buttons[y2][x2]:SetScript("OnEnter", function() end)
                                    groupButtons.buttons[y2][x2]:SetScript("OnLeave", function() end)
                                end
                                solved = true
                            end 
                        end
                    end  
                end                
            end                
            
            if not solved then
                print("Zereth Mortis Puzzle Helper: Solution not found")
            end  
    end)
end

local settingsOpen = false;
_G["SLASH_zmph1"] = "/zmph"
SlashCmdList["zmph"] = function(msg)
    local isShown = aura_env.settingsFrame:IsShown()
    aura_env.settingsFrame:SetShown(not isShown)
    if not isShown then
        puzzleStarter(13,true,ZMPHSaved.puzzle)
    else
        puzzleStarter(13,false,ZMPHSaved.puzzle)
    end
    
end
