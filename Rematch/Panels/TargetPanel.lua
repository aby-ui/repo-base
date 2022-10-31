local _,L = ...
local rematch = Rematch
local loadoutPanel = RematchLoadoutPanel
local panel = loadoutPanel.TargetPanel
local settings

-- workingList is a simple list of headers and indexes into rematch.targetData to reflect
-- the currently displayed targets. because this gets wiped and repopulated it should not be
-- nested tables. instead, the values will be one of four things:
--  1. "A~All" (string) the "All Targets" expand/collapse item at the top of the unfiltered list
--  2. "X~expansionID" (string) an expansion header where expansionID is from targetData
--  3. "M~expansionID~mapID" (string) an expansion+map header where expansionID and mapID are from targetData
--  4. something (number) an index into rematch.targetData
local workingList = {}

local HEADER_ALL = "A~All"
local HEADER_EXP_FORMAT = "X~%s"
local HEADER_MAP_FORMAT = "M~%s~%s"
local HELP_TAG = "help"

local searchPattern = nil -- desensitized text entered in search box
local headersMade = {} -- lookup table to see if a header was made yet when building workingList

function panel:Initialize()

    settings = RematchSettings
    settings.ExpandedTargetHeaders = settings.ExpandedTargetHeaders or {}

    -- if 'Remember Expanded Lists' not checked, then start each session with all lists collapsed
    if not settings.RememberExpandedLists then
        wipe(settings.ExpandedTargetHeaders)
    end

    panel.Top.SearchBox.Instructions:SetText(L["Search Targets"])

	local scrollFrame = panel.List
	scrollFrame.template = settings.SlimListButtons and "RematchCompactTargetListButtonTemplate" or "RematchTargetListButtonTemplate"
	scrollFrame.templateType = "RematchCompositeButton"
	scrollFrame.list = workingList
    scrollFrame.callback = panel.FillTargetListButton
    scrollFrame.dynamicButtonHeight = panel.GetButtonHeight
    
    panel.Top.BackButton.Arrow:Hide()
end

function panel:Update()
    if panel:IsVisible() then
		panel:PopulateTargetList()
		panel.List:Update()
	end
end

-- back button has an OnKeyDown to capture ESC keys; anything else is propagated through
-- this OnKeyDown is only active while the target panel is up, so ESC will close the panel if nothing else
function panel:OnBackButtonKeyDown(key)
    if key==GetBindingKey("TOGGLEGAMEMENU") then
        -- if "Close Lists On ESC" is checked, see if anything is expanded and close it if so rather than closing panel
        if settings.CollapseListsOnESC then
            -- if pet card is up (and if we got here, then card is floating and unlocked), dismiss without closing target
            if rematch.PetCard:IsVisible() then
                rematch.PetCard:Hide()
                return
            end
            -- otherwise look for any expanded headers
            for k,isExpanded in pairs(settings.ExpandedTargetHeaders) do
                if isExpanded then -- checking this way rather than next(setting.etc) because a value could be false
                    wipe(settings.ExpandedTargetHeaders)
                    panel:Update()
                    self:SetPropagateKeyboardInput(false)
                    return
                end
            end
        end
        panel:CloseTargetPanel()
        self:SetPropagateKeyboardInput(false)
        return
    else
        self:SetPropagateKeyboardInput(true)
    end
end

function panel:Toggle()
    loadoutPanel.targetMode = not loadoutPanel.targetMode
    rematch:Configure()
end

function panel:CloseTargetPanel()
    loadoutPanel.targetMode = false
    rematch:Configure()
end

-- updates the non-UI workingList which is a list of indexes into rematch.targetData
function panel:PopulateTargetList()
    wipe(workingList)
    wipe(headersMade)

    panel.somethingExpanded = false -- until proven otherwise, assume all headers collapsed

    local searchPattern = (panel.searchPattern and panel.searchPattern:trim():len()>0) and panel.searchPattern:trim()

    -- if a search isn't happening, start workingList with "all" to mark an All Targets collapsible header
    if not searchPattern then
        panel:AddHeader("all")
    end
    
    -- add headers and targets to workingList based on currently expanded headers
    for index,info in ipairs(rematch.targetData) do
        if panel:ShouldIndexShow(index,searchPattern) then
            panel:AddHeader("exp",index)
            local expTag = panel:GetHeaderTag("exp",index)
            if searchPattern or settings.ExpandedTargetHeaders[expTag] then
                panel.somethingExpanded = true
                panel:AddHeader("map",index)
                local mapTag = panel:GetHeaderTag("map",index)
                if searchPattern or settings.ExpandedTargetHeaders[mapTag] then
                    tinsert(workingList,index)
                end
            end
        end
    end

    -- adds a "Targets with a (green check) have a saved team" entry if extra help not disabled
    if not settings.HideMenuHelp and #workingList>0 then
        tinsert(workingList,HELP_TAG)
    end
        
end

-- returns a header tag where headerType is "all", "exp" or "map" and targetIndex is an index
-- into rematch.targetData. a header tag is a short string used in workingList to defined a
-- header. X~8 is an expansion (exp) header for expansionID 8, M~8~123 is a map header
-- for expansionID 8 and mapID 123.
function panel:GetHeaderTag(headerType,index)
    if headerType=="all" then
        return HEADER_ALL
    end
    local info = index and rematch.targetData[index]
    if info and headerType=="exp" then
        return format(HEADER_EXP_FORMAT,info[1])
    elseif info and headerType=="map" then
        return format(HEADER_MAP_FORMAT,info[1],info[2])
    end
end

-- adds a header to workingList from a targetData index if it hasn't been added yet
-- headerType is "all", "exp" or "map"; index is an index into rematch.targetData
function panel:AddHeader(headerType,index)
    local tag = panel:GetHeaderTag(headerType,index)
    if not headersMade[tag] then
        headersMade[tag] = true
        tinsert(workingList,tag)
    end
end


function panel:GetExpansionNameFromHeader(header)
    if header==HEADER_ALL then
        return L["All Targets"]
    end
    local expansionID = header:match("[XA]~(.+)")
    if expansionID then
        local expansionName = _G["EXPANSION_NAME"..expansionID]
        if expansionName then
            return expansionName
        else
            return expansionID or UNKNOWN
        end
    end
    return UNKNOWN
end

function panel:GetMapNameFromHeader(header)
    local mapID = header:match("M~.-~(.+)")
    if mapID then
        if tonumber(mapID) then
            mapInfo = C_Map.GetMapInfo(tonumber(mapID))
            return mapInfo and mapInfo.name or UNKNOWN
        else
            return mapID or UNKNOWN
        end
    end
    return UNKNOWN
end

-- styles a list button to be a header (with compact mode and without, these are 26px high)
function panel:FillHeader(button,targetIndex)
    local isMapHeader = targetIndex:sub(1,2)=="M~"
    local isExpHeader = not isMapHeader
    local isExpanded = settings.ExpandedTargetHeaders[targetIndex]
    if targetIndex==HEADER_ALL then -- "All Targets" has expanded state saved in panel.somethingExpanded, not settings.ExpandedTargetHeaders
        isExpanded = panel.somethingExpanded
    end
    button.npcID = nil
    button.Back:SetTexture("Interface\\AddOns\\Rematch\\Textures\\headers")
    if settings.SinglePanel then
        button.Back:SetTexCoord(0,0.59765625,0.5,0.90625)
    else
        button.Back:SetTexCoord(0,0.48046875,0,0.40625)
    end
    button.Back:SetPoint("TOPLEFT",0,0)
    button.Back:SetPoint("BOTTOMRIGHT",0,0)
    button.Name:ClearAllPoints()
    button.Name:SetPoint("TOPLEFT",28,0)
    button.Name:SetPoint("BOTTOMRIGHT",-2,0)
    button.HasTeam:Hide()
    if isExpHeader then -- expansion header
        button.Back:SetVertexColor(1,1,1)
        button.Name:SetTextColor(1,0.82,0)
        button.Name:SetText(panel:GetExpansionNameFromHeader(targetIndex))
        if isExpanded then
            button.Expand:SetTexCoord(0.80078125,0.8515625,0,0.40625)
        else
            button.Expand:SetTexCoord(0.75,0.80078125,0,0.40625)
        end        
    elseif isMapHeader then -- map header
        button.Back:SetVertexColor(0.75,0.75,0.75)
        button.Name:SetTextColor(0.5,0.75,1)
        button.Name:SetText(panel:GetMapNameFromHeader(targetIndex))
        if isExpanded then
            button.Expand:SetTexCoord(0.80078125,0.8515625,0.5,0.90625)
        else
            button.Expand:SetTexCoord(0.75,0.80078125,0.5,0.90625)
        end        
    end
    button.Expand:SetShown(not panel.searchPattern)
end

-- styles a list button to display the "Targets with a (green check) have a saved team."
function panel:FillHelp(button,targetIndex)
    button.Name:ClearAllPoints() 
    button.Name:SetPoint("LEFT",8,0)
    button.Name:SetPoint("RIGHT",-2,0)
    button.Name:SetText(L["Targets with a \124TInterface\\AddOns\\Rematch\\Textures\\hasteam:18\124t have a saved team."])
    button.Expand:Hide()
    button.Name:Show()
    button.Name:SetTextColor(0.65,0.65,0.65)
    button.HasTeam:Hide()
end

function panel:FillRemainingNormalTarget(button,targetIndex)
    local info = rematch.targetData[targetIndex]
    local numPets = info and #info-6 or 0 -- number of pets displayed (on assumption [6] through [8] are pets)
    if button.Border and numPets and numPets>=0 and numPets<=3 then
        button.Border:Show()
        button.Border:SetWidth(numPets*30)
        if numPets==3 then
            button.Border:SetWidth(90)
            button.Border:SetTexCoord(0,0.703125,0.5,0.84375)
        elseif numPets==2 then
            button.Border:SetWidth(61)
            button.Border:SetTexCoord(0.5234375,1.0,0,0.34375)
        else
            button.Border:SetWidth(32)
            button.Border:SetTexCoord(0.75,1.0,0.5,0.84375)
        end
    end
    local nameYOffset = 0
    if button.SubName then
        local questName = rematch:GetQuestNameFromTarget(targetIndex)
        if questName and questName~=rematch:GetNpcNameFromTarget(targetIndex) then
            button.SubName:SetText(questName)
            button.SubName:Show()
            nameYOffset = 16
        end
    end
    button.Back:SetPoint("TOPLEFT",(30*numPets)+(3-numPets)+1,0)
    button.Name:ClearAllPoints()
    button.Name:SetPoint("TOPLEFT",(30*numPets)+(3-numPets)+4,0)
    button.Name:SetPoint("BOTTOMRIGHT",button.hasTeamShown and -22 or -2,nameYOffset)
end

function panel:FillRemainingCompactTarget(button,targetIndex)
    local info = rematch.targetData[targetIndex]
    local numPets = info and #info-6 or 0 -- number of pets displayed (on assumption [7] through [8] are pets)
    button.Back:SetPoint("TOPLEFT",(26*numPets)+2,0)
    button.Name:SetPoint("TOPLEFT",(26*numPets)+4,0)
    button.Name:SetPoint("BOTTOMRIGHT",button.hasTeamShown and -22 or -2,0)
end

function panel:FillTargetListButton()
    local targetIndex = self.index and workingList[self.index]
    if targetIndex then

        self.Name:SetFontObject((settings.SlimListButtons and settings.SlimListSmallText) and GameFontNormalSmall or GameFontNormal)
        self.Name:SetText(targetIndex)
        local isHeader = type(targetIndex)=="string"
        self.isHeader = isHeader

        local info = rematch.targetData[targetIndex]
        local numPets = info and #info-6 or 0 -- number of pets displayed (on assumption [7] through [9] are pets)
        for i=1,3 do
            self.Pets[i]:Hide()
        end
        if self.Border then
            self.Border:Hide()
            self.SubName:Hide()
        end

        -- "Targets with a (green check) have a saved team." list item
        self.Back:SetShown(targetIndex~=HELP_TAG)
        self:EnableMouse(targetIndex~=HELP_TAG)
        if targetIndex==HELP_TAG then
            panel:FillHelp(self)
            return
        end

        if isHeader then -- a header, show expand +/- button
            panel:FillHeader(self,targetIndex)
        else -- a regular target listing, display pets

            -- common stuff for both normal and compact target list buttons
            self.Back:SetTexture("Interface\\AddOns\\Rematch\\Textures\\backplate")
            self.Back:SetTexCoord(0,1,0,0.5)
            self.Back:SetVertexColor(1,1,1)
            self.Name:SetTextColor(1,1,1)
            self.Name:SetText(rematch:GetNpcNameFromTarget(targetIndex))
            self.Expand:Hide()
            local npcID = info and info[3]
            self.hasTeamShown = npcID and RematchSaved[npcID] and true
            self.HasTeam:SetShown(self.hasTeamShown)
            self.npcID = npcID
            if info then
                for i=1,3 do
                    if info[6+i] then
                        local petInfo = rematch.petInfo:Fetch(info[6+i])
                        -- if 3 pets, i=1, petIndex=1; if 1 pet, i=1, petIndex=3
                        -- (this is so pets are displayed in order left-right but remain right justified)
                        --local petIndex = (4-numPets)+i-1
                        self.Pets[i]:SetTexture(petInfo.icon)
                        self.Pets[i].petID = petInfo.petID
                        self.Pets[i]:Show()
                    end
                end
            end

            if settings.SlimListButtons then
                panel:FillRemainingCompactTarget(self,targetIndex)
            else
                panel:FillRemainingNormalTarget(self,targetIndex)
            end

        end

       
        local focus = GetMouseFocus()
        if focus==self and focus:GetScript("OnEnter") then
            rematch:HideTextureHighlight()
            self.Back:SetBlendMode("BLEND")
			self:GetScript("OnEnter")(self)
		end
    end
end

--[[ listbutton script handlers ]]

-- for the following TargetListButtonOnLoad, to avoid creating new functions for every button
local function showPetCard(self) rematch:ShowPetCard(self,self.petID) end
local function hidePetCard(self) rematch:HidePetCard(true) end
local function lockPetCard(self) rematch:LockPetCard(self,self.petID) end

-- when a composite button is created, hook up script handlers for the pet "buttons"
function panel:TargetListButtonOnLoad()
	for i=1,3 do
		self:SetTextureScript(self.Pets[i],"OnEnter",showPetCard)
		self:SetTextureScript(self.Pets[i],"OnLeave",hidePetCard)
		self:SetTextureScript(self.Pets[i],"OnClick",lockPetCard)
	end
end

function panel:TargetListButtonOnClick()
    local index = self.index -- index into workingList
    local workingIndex = workingList[index]
    if workingIndex==HEADER_ALL then -- if "All Targets" clicked
        if panel.somethingExpanded then
            wipe(settings.ExpandedTargetHeaders)
        else -- nothing expanded, now expand them all
            for targetIndex,info in ipairs(rematch.targetData) do -- expand all headers that exist
                settings.ExpandedTargetHeaders[panel:GetHeaderTag("exp",targetIndex)] = true
                settings.ExpandedTargetHeaders[panel:GetHeaderTag("map",targetIndex)] = true
            end
        end
        panel:Update()
    elseif type(workingIndex)=="string" then -- this is a header
        if panel.searchPattern then -- clicking a header while searching should do nothing
            return
        end
        local tag = workingIndex
        if tag:sub(1,1)=="X" then -- expansion header
            for targetIndex,info in ipairs(rematch.targetData) do -- collapse all map headers for this expansion
                if panel:GetHeaderTag("exp",targetIndex):match(tag) then
                    settings.ExpandedTargetHeaders[panel:GetHeaderTag("map",targetIndex)] = nil
                end
            end
        end
        settings.ExpandedTargetHeaders[tag] = not settings.ExpandedTargetHeaders[tag]
        panel:Update()
    else
        panel:CloseTargetPanel()
        rematch.PickNpcID(self)
    end
    if self.isHeader and GetMouseFocus()==self then
        rematch:ShowTextureHighlight(self.Expand)
    end
end

function panel:TargetListButtonOnEnter()
    if self.isHeader then
        if not panel.searchPattern then
            rematch:ShowTextureHighlight(self.Expand)
        end
    else
        self.Back:SetBlendMode("ADD")
    end
end

function panel:TargetListButtonOnLeave()
    if self.isHeader then
        rematch:HideTextureHighlight()
    else
        self.Back:SetBlendMode("BLEND")
    end
end

function panel:TargetListButtonOnMouseDown()
    if self.isHeader then
        rematch:HideTextureHighlight()
    elseif self:HasFocus() then
        -- if mouse is down while over an active texture, don't "press" the main button
        self.Back:SetBlendMode("BLEND")
    end
end

function panel:TargetListButtonOnMouseUp()
    if GetMouseFocus()==self then
        if self.isHeader then
            if not panel.searchPattern then
                rematch:ShowTextureHighlight(self.Expand)
            end
        else
            -- if mouse goes up after it left button, don't "unpress" it
            self.Back:SetBlendMode("ADD")
        end
    end
end

--[[ search ]]

function panel:SearchBoxOnTextChanged()
	local oldPattern = panel.searchPattern
	local text = self:GetText():trim()
	panel.searchPattern = text:len()>0 and rematch:DesensitizeText(text)
	if panel.searchPattern~=oldPattern then
		panel:Update()
	end
end

-- returns true if the targetData at the given index contains the given searchText
function panel:ShouldIndexShow(index,searchPattern)
    if not searchPattern then
        return true -- no searches happening, display all
    elseif rematch:GetExpansionNameFromTarget(index):match(searchPattern) then
        return true -- search matched an expansion name
    elseif rematch:GetMapNameFromTarget(index):match(searchPattern) then
        return true -- search matched a map name
    elseif rematch:GetNpcNameFromTarget(index):match(searchPattern) then
        return true -- search matched an npc name
    elseif (rematch:GetQuestNameFromTarget(index) or ""):match(searchPattern) then
        return true -- search matched a quest name
    else
        local info = rematch.targetData[index]
        for i=7,9 do
            if info[i] then
                local petInfo = rematch.petInfo:Fetch(info[i])
                if petInfo.name and petInfo.name:match(searchPattern) then
                    return true
                end
            end
        end
    end
    -- if reached here, search failed
    return false
end

-- for AutoScrollFrame's dynamicButtonHeight, returns the intended height of the button at the given index
function panel:GetButtonHeight(index)
    if settings.SlimListButtons then
        return 26
    else
        local targetIndex = index and workingList[index]
        if targetIndex and type(targetIndex)=="string" then
            return 26
        else
            return 44
        end
    end
end
