
local Details = Details
local DetailsFramework = _G.DetailsFramework
local GameCooltip2 = GameCooltip2

function Details:CreateAPI2Frame()
    if (not _G.DetailsAPI2Frame or not _G.DetailsAPI2Frame.Initialized) then

        --menu settings
        
        _G.DetailsAPI2Frame.Initialized = true
        
        local panelWidth = 800
        local panelHeight = 610
        local scrollWidth = 200
        local scrollHeight = 570
        local lineHeight = 20
        local lineAmount = 27
        local backdropColor = {.2, .2, .2, 0.2}
        local backdropColorOnEnter = {.8, .8, .8, 0.4}
        local backdropColorSelected = {1, 1, .8, 0.4}
        local yStart = -30
        local xAnchorPoint = 250
        local parametersAmount = 10
        local returnAmount = 10

        --local Api2Frame = DetailsFramework:CreateSimplePanel (UIParent, panelWidth, panelHeight, "Details! API 2.0", "DetailsAPI2Frame")
        local Api2Frame = _G.DetailsAPI2Frame 
        
        Api2Frame:SetFrameStrata ("FULLSCREEN")
        Api2Frame:SetPoint ("center")
        DetailsFramework:ApplyStandardBackdrop (Api2Frame, false, 1.2)
        
        --store
        local apiFunctionNames = {}
        local parametersLines = {}
        local returnLines = {}
        local currentSelected = 1
        
        local api = Details.API_Description.namespaces[1].api
        
        --on select api on the menu
        local onSelectAPI = function (self)
            local apiName = apiFunctionNames [self.index]
            if (not apiName) then
                Details:Msg ("API name not found:", apiName)
                return
            end
            
            --fill the box in the right with information about the API
            local apiInfo = api [self.index]
            if (not apiInfo) then
                Details:Msg ("API information for api not found", apiName)
                return
            end
            
            currentSelected = self.index
            
            --update name and desc
            Api2Frame.ApiFunctionName.text = apiName
            Api2Frame.ApiFunctionDesc.text = apiInfo.desc
            
            --update the copy line text box
            local parameters = ""
            for parameterIndex, parameterInfo in ipairs (apiInfo.parameters) do
                if (parameterInfo.required) then
                    parameters = parameters .. parameterInfo.name .. ", "
                end
            end
            parameters = parameters:gsub (", $", "")
            
            local returnValues = "local "
            for returnIndex, returnInfo in ipairs (apiInfo.returnValues) do
                returnValues = returnValues .. returnInfo.name .. ", "
            end
            returnValues = returnValues:gsub (", $", "")
            returnValues = returnValues .. " = "
            
            if (parameters ~= "") then
                Api2Frame.ApiCopy.text = returnValues .. "Details." .. apiName .. "( " .. parameters .. " )"
            else
                Api2Frame.ApiCopy.text = returnValues .. "Details." .. apiName .. "()"
            end
            
            Api2Frame.ApiCopy:SetFocus (true)
            Api2Frame.ApiCopy:HighlightText()
            
            --parameters
            for i = 1, #parametersLines do
                local parameterLine = parametersLines [i]
                local parameterInfo = apiInfo.parameters [i]
                
                if (parameterInfo) then
                    parameterLine:Show()
                    parameterLine.index = i
                    parameterLine.name.text = parameterInfo.name
                    parameterLine.typeData.text = parameterInfo.type
                    parameterLine.required.text = parameterInfo.required and "yes" or "no"
                    parameterLine.default.text = parameterInfo.default or ""
                else
                    parameterLine:Hide()
                end
            end	
            
            --return values
            for i = 1, #returnLines do
                local returnLine = returnLines [i]
                local returnInfo = apiInfo.returnValues [i]
            
                if (returnInfo) then
                    returnLine:Show()
                    returnLine.index = i
                    returnLine.name.text = returnInfo.name
                    returnLine.typeData.text = returnInfo.type
                    returnLine.desc.text = returnInfo.desc
                    
                else
                    returnLine:Hide()
                end
            end
            
            --refresh the scroll box
            Api2Frame.scrollMenu:Refresh()
        end
        
        --menu scroll
        local apiMenuScrollRefresh = function (self, data, offset, total_lines)
            for i = 1, total_lines do
                local index = i + offset
                local apiName = data [index]
                if (apiName) then
                    local line = self:GetLine (i)
                    line.text:SetText (apiName)
                    line.index = index
                    
                    if (currentSelected == index) then
                        line:SetBackdropColor (unpack (backdropColorSelected))
                    else
                        line:SetBackdropColor (unpack (backdropColor))
                    end
                end
            end
        end
        
        for apiIndex, apiDesc in ipairs (api) do
            tinsert (apiFunctionNames, apiDesc.name)
        end
        
        local api2ScrollMenu = DetailsFramework:CreateScrollBox (Api2Frame, "$parentApi2MenuScroll", apiMenuScrollRefresh, apiFunctionNames, scrollWidth, scrollHeight, lineAmount, lineHeight)
        DetailsFramework:ReskinSlider (api2ScrollMenu)
        api2ScrollMenu:SetPoint ("topleft", Api2Frame, "topleft", 10, yStart)
        Api2Frame.scrollMenu = api2ScrollMenu
        
        local lineOnEnter = function (self)
            self:SetBackdropColor (unpack (backdropColorOnEnter))
            
            local apiName = apiFunctionNames [self.index]
            if (not apiName) then
                return
            end
            
            --fill the box in the right with information about the API
            local apiInfo = api [self.index]
            if (not apiInfo) then
                return
            end
            
            GameCooltip2:Preset(2)
            GameCooltip2:SetOwner (self, "left", "right", 2, 0)
            GameCooltip2:AddLine (apiInfo.desc)
            GameCooltip2:ShowCooltip()
        end
        
        local lineOnLeave = function (self)
            if (currentSelected == self.index) then
                self:SetBackdropColor (unpack (backdropColorSelected))
            else
                self:SetBackdropColor (unpack (backdropColor))
            end
            
            GameCooltip2:Hide()
        end
        
        --create lines
        for i = 1, lineAmount do 
            api2ScrollMenu:CreateLine (function (self, index)
                local line = CreateFrame ("button", "$parentLine" .. index, self, "BackdropTemplate")
                line:SetPoint ("topleft", self, "topleft", 1, -((index-1)*(lineHeight+1)) - 1)
                line:SetSize (scrollWidth - 2, lineHeight)
                line.index = index
                
                line:SetScript ("OnEnter", lineOnEnter)
                line:SetScript ("OnLeave", lineOnLeave)
                
                line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
                line:SetBackdropColor (unpack (backdropColor))
            
                line.text = DetailsFramework:CreateLabel (line)
                line.text:SetPoint ("left", line, "left", 2, 0)
                
                line:SetScript ("OnMouseDown", onSelectAPI)
                
                return line
            end)
        end

        --info box
            local infoWidth = panelWidth - xAnchorPoint - 10
            --api name
            Api2Frame.ApiFunctionName = DetailsFramework:CreateLabel (Api2Frame, "", 14, "orange")
            Api2Frame.ApiFunctionName:SetPoint ("topleft", Api2Frame, "topleft", xAnchorPoint, yStart)
            --api desc
            Api2Frame.ApiFunctionDesc = DetailsFramework:CreateLabel (Api2Frame)
            Api2Frame.ApiFunctionDesc:SetPoint ("topleft", Api2Frame.ApiFunctionName, "bottomleft", 0, -2)
            Api2Frame.ApiFunctionDesc.width = infoWidth
            Api2Frame.ApiFunctionDesc.height = 22
            Api2Frame.ApiFunctionDesc.valign = "top"
            
            --api func to copy
            local apiCopyString = DetailsFramework:CreateLabel (Api2Frame, "Copy String", 12, "orange")
            apiCopyString:SetPoint ("topleft", Api2Frame.ApiFunctionDesc, "bottomleft", 0, -20)
            Api2Frame.ApiCopy = DetailsFramework:CreateTextEntry (Api2Frame, function() end, infoWidth, 20)
            Api2Frame.ApiCopy:SetPoint ("topleft", apiCopyString, "bottomleft", 0, -2)
            Api2Frame.ApiCopy:SetTemplate (DetailsFramework:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX"))
            
            --parameters
            local parametersYStart = yStart - 110
            local parametersString = DetailsFramework:CreateLabel (Api2Frame, "Parameters", 12, "orange")
            parametersString:SetPoint ("topleft", Api2Frame, "topleft", xAnchorPoint, parametersYStart)
            
            parametersYStart = parametersYStart - 20
            
            local space1, space2, space3 = 150, 300, 450
            local parametersHeader = CreateFrame ("frame", nil, Api2Frame, "BackdropTemplate")
            parametersHeader:SetSize (infoWidth, 20)
            parametersHeader:SetPoint ("topleft", Api2Frame, "topleft", xAnchorPoint, parametersYStart)
            parametersHeader:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
            parametersHeader:SetBackdropColor (unpack (backdropColor))
            parametersHeader.name = DetailsFramework:CreateLabel (parametersHeader, "Name", 12, "yellow")
            parametersHeader.typeData = DetailsFramework:CreateLabel (parametersHeader, "Type", 12, "yellow")
            parametersHeader.required = DetailsFramework:CreateLabel (parametersHeader, "Is Required", 12, "yellow")
            parametersHeader.default = DetailsFramework:CreateLabel (parametersHeader, "Default Value", 12, "yellow")
            parametersHeader.name:SetPoint ("left", parametersHeader, "left", 2, 0)
            parametersHeader.typeData:SetPoint ("left", parametersHeader, "left", space1, 0)
            parametersHeader.required:SetPoint ("left", parametersHeader, "left", space2, 0)
            parametersHeader.default:SetPoint ("left", parametersHeader, "left", space3, 0)
            
            local parameterOnEnter = function (self) 
                GameCooltip2:Preset(2)
                GameCooltip2:SetOwner (self)
                
                --fill the box in the right with information about the API
                local apiInfo = api [currentSelected]
                if (not apiInfo) then
                    return
                end
                GameCooltip2:AddLine (apiInfo.parameters [self.index].desc)
                GameCooltip2:ShowCooltip()
                
                self:SetBackdropColor (unpack (backdropColorOnEnter))
            end
            local parameterOnLeave = function (self) 
                GameCooltip2:Hide()
                self:SetBackdropColor (unpack (backdropColor))
            end
            
            for i = 1, parametersAmount do
                local parameterLine = {}
                local f = CreateFrame ("frame", nil, Api2Frame, "BackdropTemplate")
                f:SetSize (infoWidth, 20)
                f:SetScript ("OnEnter", parameterOnEnter)
                f:SetScript ("OnLeave", parameterOnLeave)
                f:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
                f:SetBackdropColor (unpack (backdropColor))
                f:Hide()
                
                f.name = DetailsFramework:CreateLabel (f)
                f.typeData = DetailsFramework:CreateLabel (f)
                f.required = DetailsFramework:CreateLabel (f)
                f.default = DetailsFramework:CreateLabel (f)
                
                f:SetPoint ("topleft", Api2Frame, "topleft", xAnchorPoint, parametersYStart + (-i * 20))
                
                f.name:SetPoint ("left", f, "left", 2, 0)
                f.typeData:SetPoint ("left", f, "left", space1, 0)
                f.required:SetPoint ("left", f, "left", space2, 0)
                f.default:SetPoint ("left", f, "left", space3, 0)
                
                tinsert (parametersLines, f)
            end
        
        --return value box
            local returnYStart = yStart - 260
            local returnString = DetailsFramework:CreateLabel (Api2Frame, "Return Values", 12, "orange")
            returnString:SetPoint ("topleft", Api2Frame, "topleft", xAnchorPoint, returnYStart)
            
            returnYStart = returnYStart - 20
            
            local space1 = 200
            local returnHeader = CreateFrame ("frame", nil, Api2Frame, "BackdropTemplate")
            returnHeader:SetSize (infoWidth, 20)
            returnHeader:SetPoint ("topleft", Api2Frame, "topleft", xAnchorPoint, returnYStart)
            returnHeader:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
            returnHeader:SetBackdropColor (unpack (backdropColor))
            returnHeader.name = DetailsFramework:CreateLabel (returnHeader, "Name", 12, "yellow")
            returnHeader.typeData = DetailsFramework:CreateLabel (returnHeader, "Type", 12, "yellow")
            returnHeader.name:SetPoint ("left", returnHeader, "left", 2, 0)
            returnHeader.typeData:SetPoint ("left", returnHeader, "left", space1, 0)

            local returnOnEnter = function (self) 
                self:SetBackdropColor (unpack (backdropColorOnEnter))
            end
            local returnOnLeave = function (self) 
                self:SetBackdropColor (unpack (backdropColor))
            end
            
            for i = 1, returnAmount do
                local parameterLine = {}
                local f = CreateFrame ("frame", nil, Api2Frame, "BackdropTemplate")
                f:SetSize (infoWidth, 20)
                f:SetScript ("OnEnter", returnOnEnter)
                f:SetScript ("OnLeave", returnOnLeave)
                f:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
                f:SetBackdropColor (unpack (backdropColor))
                f:Hide()
                
                f.name = DetailsFramework:CreateLabel (f)
                f.typeData = DetailsFramework:CreateLabel (f)
                
                f.desc = DetailsFramework:CreateLabel (f, "", 10, "gray")
                f.desc.width = infoWidth
                f.desc.height = 60
                f.desc.valign = "top"
                
                f:SetPoint ("topleft", Api2Frame, "topleft", xAnchorPoint, returnYStart + (-i * 20))
                
                f.name:SetPoint ("left", f, "left", 2, 0)
                f.typeData:SetPoint ("left", f, "left", space1, 0)
                
                f.desc:SetPoint ("topleft", f.name, "bottomleft", 0, -5)
                
                tinsert (returnLines, f)
            end

        function Api2Frame.Refresh()
            onSelectAPI (api2ScrollMenu.Frames [1])
        end
    end
end