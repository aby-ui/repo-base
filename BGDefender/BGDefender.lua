BGD_Prefs = nil

-- Binding Variables
BINDING_HEADER_BGDEFENDER             = "Battleground Defender";
BINDING_NAME_BGDEFENDER_OPTIONS       = "Options Screen";
BINDING_NAME_BGDEFENDER_ANNOUNCE1     = "1 incoming";
BINDING_NAME_BGDEFENDER_ANNOUNCE2     = "2 incoming";
BINDING_NAME_BGDEFENDER_ANNOUNCE3     = "3 incoming";
BINDING_NAME_BGDEFENDER_ANNOUNCE4     = "4 incoming";
BINDING_NAME_BGDEFENDER_ANNOUNCE5     = "5 incoming";
BINDING_NAME_BGDEFENDER_ANNOUNCE6     = "More than 5 incoming";
BINDING_NAME_BGDEFENDER_ANNOUNCE_HELP = "Need help";
BINDING_NAME_BGDEFENDER_ANNOUNCE_SAFE = "Node safe";


---------
function BGD_OnLoad(self)
---------
    self:RegisterEvent("ADDON_LOADED")
    -- self:RegisterEvent("VARIABLES_LOADED")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    --BGD_Msg("BG Defender loaded (ver "..GetAddOnMetadata("BGDefender", "Version").."). Type /bgd help for more information.\nConfigure messages using the options screen.")
    SLASH_BGDefender1 = "/BGDefender"
    SLASH_BGDefender2 = "/bgd"
    SlashCmdList["BGDefender"] = function(msg, editBox)
        BGD_SlashCommandHandler(msg, editBox)
    end
end

---------
function BGD_OnEvent(frame, event, ...)
---------
    -- if (event == "VARIABLES_LOADED") then
	--	frame:UnregisterEvent("VARIABLES_LOADED")
    -- end

    if (event == "ADDON_LOADED") then
		frame:UnregisterEvent("ADDON_LOADED")

        if not BGD_Prefs then
            BGD_Settings_Default()
        else
            -- Update old BATTLEGROUND channel prefs to new INSTANCE_CHAT
            if BGD_Prefs.BGChat == "BATTLEGROUND" then
                BGD_Prefs.BGChat       = "INSTANCE_CHAT"
                BGD_Prefs.BGChatTemp   = "INSTANCE_CHAT"
            end
        end
        BGD_Prefs.version = GetAddOnMetadata("BGDefender", "Version")
        BGD_Opt_Frame_Setup()
        BGD_Opt_Frame_UpdateViews()
        if (BGD_Prefs.locale == nil) then
            BGD_Prefs.locale = GetLocale()
        end
        if (BGD_Prefs.locale ~= "enUS") then
            -- Make sure that the enUS locale is always loaded. Guarantees that there is a fallback
            -- for stuff that hasn't been translated.
            BGD_initLocale("enUS")
        end
        BGD_initLocale(BGD_Prefs.locale)
        BGD_initCustomSubZones()
    end

    if ((event == "ZONE_CHANGED_NEW_AREA") or (event == "ADDON_LOADED")) then
        if(BGD_isInBG()) then
			DEFAULT_CHAT_FRAME:AddMessage("PVP战场求助已加载", 1.0, 0.5, 0.5)
            BGD_Prefs.ShowUI = BGD_Toggle(true)
       else
            BGD_Prefs.ShowUI = BGD_Toggle(false)
       end
    end

	-- BGD_PrintDebugInfo(frame, event)
end


---------
function BGD_PrintDebugInfo(frame, event, ...)
---------
	DEFAULT_CHAT_FRAME:AddMessage("[BGD] DEBUG...", 1.0, 0.2, 0.2)
	if frame~=nil and event~=nil then
		DEFAULT_CHAT_FRAME:AddMessage("[BGD] frame:"..frame:GetName()..", event:"..event, 1.0, 0.2, 0.2)
	end
	-- DEFAULT_CHAT_FRAME:AddMessage("[BGD] MapID:"..WorldMapFrame:GetMapID(), 1.0, 0.2, 0.2)
	DEFAULT_CHAT_FRAME:AddMessage("[BGD] zone:"..GetZoneText(), 1.0, 0.2, 0.2)
	-- DEFAULT_CHAT_FRAME:AddMessage("[BGD] real zone:"..GetRealZoneText(), 1.0, 0.2, 0.2)

	local instanceMapID, instanceName = BGD_GetInstanceMapID()
	DEFAULT_CHAT_FRAME:AddMessage("[BGD] instance name: "..tostring(instanceName), 1.0, 0.2, 0.2)
	DEFAULT_CHAT_FRAME:AddMessage("[BGD] instance map id:"..tostring(instanceMapID), 1.0, 0.2, 0.2)
end


---------
function BGD_GetInstanceMapID()
---------
	-- local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
	local name, _, _, _, _, _, _, instanceMapID, _ = GetInstanceInfo()
	return instanceMapID, name
end


---------
function BGD_initLocale(locale)
---------
    if (locale == "deDE") then
        BGD_init_deDE()
    elseif ((locale == "esMX") or (locale == "esES")) then
        BGD_init_esMX()
    elseif (locale == "frFR") then
        BGD_init_frFR()
    elseif (locale == "ruRU") then
        BGD_init_ruRU()
    elseif (locale == "zhCN") then
        BGD_init_zhCN()
    elseif (locale == "zhTW") then
        BGD_init_zhTW()
    else
        BGD_init_enUS()
    end
end


---------
function BGD_initCustomSubZones()
---------
	BGD_rcSilverShardMines = BGD_RcSMZone();
	BGD_rcDeepwindGorge = BGD_RcDwGZone();
end


---------
function BGD_StartMoving(self)
---------
    if (BGD_Prefs.movable == true) then
        self:StartMoving()
    end
end


---------
function BGD_StopMovingOrSizing(self)
---------
    self:StopMovingOrSizing()
end


---------
function BGD_Toggle_Movable()
---------
    if (BGD_Prefs.movable == true) then
        BGD_Prefs.movable = false
        Button11:SetText(" p ")
    else
        BGD_Prefs.movable = true
        Button11:SetText(" m ")
    end
end


---------
function BGD_SlashCommandHandler(msg, editBox)
---------
    msg = strlower(msg)
    if (msg == "") then
        BGD_Prefs.ShowUI = BGD_Toggle()
    elseif (msg == "show") then
        BGD_Prefs.ShowUI = BGD_Toggle(true)
    elseif (msg == "hide") then
        BGD_Prefs.ShowUI = BGD_Toggle(false)
    elseif (msg == "status") then
        BGD_ShowStatus()
    elseif (msg == "options") or (msg == "o") then
        BGD_Options_Open()
    else
        DEFAULT_CHAT_FRAME:AddMessage("BG Defender Version "..GetAddOnMetadata("BGDefender", "Version"), 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("  /bgd options |cFFFFFFFF- to set announcement channel", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("  /bgd [show/hide] |cFFFFFFFF- show/hide window", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("  /bgd status |cFFFFFFFF- BGDefender status", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("clicking the o button will open the options screen", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("clicking the m or p button will toggle moving the window", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage("clicking the x button will close the UI, but you can reopen it by typing /bgd", 1.0, 0.5, 0.0)
        DEFAULT_CHAT_FRAME:AddMessage(" ", 1.0, 0.5, 0.0)
    end
end


---------
local function BGD_GetPlayerPosition()
---------
	local mapID = C_Map.GetBestMapForUnit("player")
	if mapID~=nil and C_Map.GetPlayerMapPosition~=nil then
		local pos = C_Map.GetPlayerMapPosition(mapID, "player")

		-- Make sure pos and GetXY are defined
		if pos~=nil and pos.GetXY~=nil then
			local px, py = pos:GetXY()
			if px~=nil and py~=nil then
				px=px*100
				py=py*100
				return {px, py}
			end
		end
	end
    return nil
end


---------
local function BGD_GetSubZoneText()
---------
    if BGD_isInNoSubZoneBG() then
        -- Handle battlegrounds that don't have useful subzones.
        local zone = GetZoneText();
        local playerPos = BGD_GetPlayerPosition()

        -- DEFAULT_CHAT_FRAME:AddMessage("BGD debug: player position = {"..playerPos[1]..", "..playerPos[2].."}", 1.0, 0.0, 0.0)

        if playerPos~=nil then
            if zone == BGD_SM then
                local subZoneKey = BGD_rcSilverShardMines:insideZone(playerPos)
                if subZoneKey then
                    return BGD_SM_zones[subZoneKey]
                end
            elseif zone == BGD_DWG then
                local subZoneKey = BGD_rcDeepwindGorge:insideZone(playerPos)
                if subZoneKey then
                    return BGD_DWG_zones[subZoneKey]
                end
            end
        end
        return nil
    else
        return GetSubZoneText()
    end
end


---------
function BGD_NumCall(arg1)
---------
    local location = nil
    local call = ""
    
    if (not BGD_isInBG()) then
        BGD_Msg(BGD_OUT)
        return
    end
    
    location = BGD_GetSubZoneText()
    
    if (location ~= nil and location ~= "") then
        if (arg1==6) then
            call = BGD_INCPLUS
        elseif (arg1==7) then
            call = BGD_HELP
        elseif (arg1==8) then
            call = BGD_SAFE
        else 
            call = BGD_INC
            call = string.gsub(call, "$num", arg1)
        end
        call = string.gsub(call, "$base", location)
        
        local channel = BGD_Prefs.BGChat
        if (BGD_isInRaidBG()) then
            channel = BGD_Prefs.RaidChat
        end
        if (BGD_Prefs.preface == true) then
            call = "BGDefender: " .. call
        end
        if (channel == BGD_GENERAL) then
            local index, name = GetChannelName(BGD_GENERAL.." - "..GetZoneText())
            if (index~=0) then 
                SendChatMessage(call , "CHANNEL", nil, index)
            end
        elseif (channel == "SELF_WISPER") then
            SendChatMessage(call , "WHISPER", nil, UnitName("player"))
        else
            SendChatMessage(call, channel)
        end
    else
        BGD_Msg(BGD_AWAY)
    end
end


---------
function BGD_Msg(text)
---------
    if (text) then
        DEFAULT_CHAT_FRAME:AddMessage(text, 1, 0, 0)
        UIErrorsFrame:AddMessage(text, 1.0, 1.0, 0, 1, 10) 
    end
end


---------
function BGD_isInRaidBG()
---------
    local zone = GetZoneText()
    local found = false
    if ((zone == BGD_WG) or (zone == BGD_TB)) then
        found = true
    end
    return found
end


---------
function BGD_isInBG()
---------
    local bgInstanceMapIDs = {
        [30] = "Alterac Valley",
        [529] = "Arathi Basin",
        -- [1105] = "Deepwind Gorge",
        [566] = "Eye of the Storm",
        [968] = "Eye of the Storm (Rated)",
        [628] = "Isle of Conquest",
        -- [1803] = "Seething Shore",
        -- [727] = "Silvershard Mines",
        [607] = "Strand of the Ancients",
        -- [998] = "Temple of Kotmogu",
        [761] = "The Battle for Gilneas",
        [726] = "Twin Peaks",
        [489] = "Warsong Gulch",
    }
    -- New approach to check which BG we are in by using its InstanceID
    local tmp = bgInstanceMapIDs[BGD_GetInstanceMapID()]
    if tmp~=nil then
        DEFAULT_CHAT_FRAME:AddMessage("[BGD] lookup instance map id: "..tmp, 1.0, 0.7, 0.2)
        return true
    end

    -- Fall back to the old method for special cases.
    local found = false
    local zone = GetZoneText()
    -- if ((zone == BGD_AV)  or (zone == BGD_AB)   or (zone == BGD_WSG)  or (zone == BGD_WSL) or 
    --    (zone == BGD_SWH) or (zone == BGD_EOTS) or (zone == BGD_SOTA) or (zone == BGD_IOC) or
    --    (zone == BGD_GIL) or (zone == BGD_TP)   or (zone == BGD_DMH)  or (zone == BGD_WHS)) then
    --    found = true
    -- else
    if (BGD_isInRaidBG()) then
        found = true
    elseif (BGD_isInNoSubZoneBG()) then 
		found = true
	end
    return found
end


---------
function BGD_isInNoSubZoneBG()
---------
    local zone = GetZoneText()
    local found = false
	local playerPos = BGD_GetPlayerPosition()
	
	-- Make sure we can get our current position
	if playerPos~=nil then
		if (zone == BGD_SM) then
			found = true
		elseif (zone == BGD_DWG) then
			found = true
		end
	end
    return found
end


---------
function BGD_ShowStatus()
---------
    DEFAULT_CHAT_FRAME:AddMessage(" ", 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("战场防御者 |cFF00FF00"..GetAddOnMetadata("BGDefender", "Version").."|r 资讯", 1.0, 0.5, 0.0)
    
    if (BGD_Prefs.ShowUI == true) then
        DEFAULT_CHAT_FRAME:AddMessage("    插件隐藏: |cFF00FF00是", 1.0, 0.5, 0.0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("    插件隐藏: |cFFFF0000否|r (/bgd 切换显示)", 1.0, 0.5, 0.0)
    end
    DEFAULT_CHAT_FRAME:AddMessage("    本地化: |cFF00FF00"..BGD_Prefs.locale, 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("    战场频道: |cFF00FF00"..BGD_Prefs.BGChat, 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("    世界区域频道: |cFF00FF00"..BGD_Prefs.RaidChat, 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("    区域: |cFF00FF00"..GetZoneText().."|r (|cFF00FF00"..GetSubZoneText().."|r)", 1.0, 0.5, 0.0)

    local instanceMapID, instanceName = BGD_GetInstanceMapID()
    DEFAULT_CHAT_FRAME:AddMessage("    副本频道: |cFF00FF00"..instanceName.."|r (|cFF00FF00"..instanceMapID.."|r)", 1.0, 0.5, 0.0)

    if (BGD_isInBG()) then
        DEFAULT_CHAT_FRAME:AddMessage("    自定义一个战场频道? |cFF00FF00是", 1.0, 0.5, 0.0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("    自定义一个战场频道? |cFFFF0000否", 1.0, 0.5, 0.0)
    end
    local tmpPos = BGD_GetPlayerPosition()
	if tmpPos~=nil then
		tmpPos = string.format("%.2f, %.2f", tmpPos[1], tmpPos[2])
	else
		tmpPos = "nil, nil"
	end
    DEFAULT_CHAT_FRAME:AddMessage("    自定义本地地图: |cFF00FF00"..tmpPos, 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("    战场区域: ", 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("        "..BGD_AV..", "..BGD_AB..", "..BGD_WSG..","..BGD_EOTS..", ", 1.0, 1.0, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("        "..BGD_SOTA..", "..BGD_IOC..","..BGD_TP..", "..BGD_GIL..", ", 1.0, 1.0, 1.0)
    -- DEFAULT_CHAT_FRAME:AddMessage("        "..BGD_SM..", "..BGD_DWG, 1.0, 1.0, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("    世界PVP区域: ", 1.0, 0.5, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("        "..BGD_WG..", "..BGD_TB, 1.0, 1.0, 1.0)
    if (BGD_Prefs.preface == true) then
        DEFAULT_CHAT_FRAME:AddMessage("    备注 |cFF00FF00BGDefender:|r 显示文本信息", 1.0, 0.5, 0.5)
    end
end


---------
function BGD_Toggle(state)
---------
    local frame  = getglobal("BGDefenderFrame")
    local status = nil
    if (frame) then
        if (state == false) then
            frame:Hide()
            status = false
        elseif (state == true) then
            frame:Show()
            status = true
        else
            if(frame:IsVisible()) then
                frame:Hide()
                status = false
            else
                frame:Show()
                status = true
            end
        end
        return status
    end
end


---------
function BGD_Close()
---------
    BGD_Prefs.ShowUI = BGD_Toggle(false)
end


---------
function BGD_Options_Open()
---------
    BGD_Prefs.BGChatTemp   = BGD_Prefs.BGChat
    BGD_Prefs.RaidChatTemp = BGD_Prefs.RaidChat
    BGD_Opt_Frame_UpdateViews()
    InterfaceOptionsFrame_OpenToCategory(BGD_Opt_Frame)
end


---------
function BGD_Opt_Frame_OnLoad(BGD_Opt_Frame)
---------
    BGD_Opt_Frame.name    = "BG Defender"
    BGD_Opt_Frame.okay    = function (self) BGD_Opt_Frame_Okay(); end
    BGD_Opt_Frame.default = function (self) BGD_Settings_Default(); BGD_Opt_Frame_UpdateViews(); end
    InterfaceOptions_AddCategory(BGD_Opt_Frame)
end


---------
function BGD_Opt_Frame_OnShow(BGD_Opt_Frame)
---------
    -- Moved from BGD_Opt_Frame_Setup, so we don't initialize the drop downs if we don't need them.
    -- Might workaround some taint issues related to eight or more menu items in the dropdown.
    -- DEFAULT_CHAT_FRAME:AddMessage("BGD debug: Initializing drop down menus.", 1.0, 0.0, 0.0)
    UIDropDownMenu_Initialize(BGD_Opt_Drop1, BGD_Opt_Drop1_Initialize)
    UIDropDownMenu_Initialize(BGD_Opt_Drop2, BGD_Opt_Drop2_Initialize)
    UIDropDownMenu_Initialize(BGD_Opt_Drop3, BGD_Opt_Drop3_Initialize)
    
    BGD_displayLocaleMessages()
end


---------
function BGD_Opt_Frame_Okay()
---------
    BGD_Prefs.BGChat   = BGD_Prefs.BGChatTemp
    BGD_Prefs.RaidChat = BGD_Prefs.RaidChatTemp
end


---------
function BGD_Settings_Default()
---------
    BGD_Prefs = {}
    BGD_Prefs.Title        = GetAddOnMetadata("BGDefender", "Title")
    BGD_Prefs.RaidChat     = "RAID"
    BGD_Prefs.RaidChatTemp = "RAID"
    BGD_Prefs.BGChat       = "INSTANCE_CHAT"
    BGD_Prefs.BGChatTemp   = "INSTANCE_CHAT"
    BGD_Prefs.version      = GetAddOnMetadata("BGDefender", "Version")
    BGD_Prefs.preface      = false
    BGD_Prefs.movable      = true
    BGD_Prefs.ShowUI       = BGD_isInBG()
    BGD_Prefs.locale       = GetLocale()
end




BGD_Opt_Title = nil

BGD_Opt_Txt1  = nil
BGD_Opt_Drop1 = nil

BGD_Opt_Txt2  = nil
BGD_Opt_Drop2 = nil

BGD_Opt_Txt3  = nil
BGD_Opt_Drop3 = nil

BGD_Opt_Btn1  = nil

---------
function BGD_Opt_Frame_Setup()
---------
    if (BGD_Opt_Title == nil) then
        BGD_Opt_Title = BGD_Opt_Frame:CreateFontString( "BGD_Opt_Title", "ARTWORK", "GameFontNormalLarge" )
        BGD_Opt_Title:SetPoint( "TOPLEFT", 16, -16 )
        BGD_Opt_Title:SetText( BGD_Prefs.Title .. " V" .. GetAddOnMetadata("BGDefender", "Version"))
    end

    if (BGD_Opt_Txt1 == nil) then
        BGD_Opt_Txt1 = BGD_Opt_Frame:CreateFontString( "BGD_Opt_Txt1", "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Txt1:SetPoint( "TOPLEFT", "BGD_Opt_Title", "BOTTOMLEFT", 16, -16 )
        BGD_Opt_Txt1:SetText( "战场通报频道: " )
    end
    if (BGD_Opt_Drop1 == nil) then
        BGD_Opt_Drop1 = CreateFrame("Frame", "DropDown1", BGD_Opt_Frame, "UIDropDownMenuTemplate");
        BGD_Opt_Drop1:SetPoint("TOPLEFT", "BGD_Opt_Txt1", "TOPRIGHT", 0, 8)
        UIDropDownMenu_SetWidth(BGD_Opt_Drop1, 140)
    end

    if (BGD_Opt_Txt2 == nil) then
        BGD_Opt_Txt2 = BGD_Opt_Frame:CreateFontString( "BGD_Opt_Txt2", "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Txt2:SetPoint( "TOPLEFT", "BGD_Opt_Txt1", "BOTTOMLEFT", 0, -32 )
        BGD_Opt_Txt2:SetText( "世界PVP区域通报频道:" )
    end
    if (BGD_Opt_Drop2 == nil) then
        BGD_Opt_Drop2 = CreateFrame("Frame", "DropDown2", BGD_Opt_Frame, "UIDropDownMenuTemplate")
        BGD_Opt_Drop2:SetPoint("TOPLEFT", "DropDown1", "BOTTOMLEFT", 0, -10)
        UIDropDownMenu_SetWidth(BGD_Opt_Drop2, 140)
    end

    if (BGD_Opt_Txt3 == nil) then
        BGD_Opt_Txt3 = BGD_Opt_Frame:CreateFontString( "BGD_Opt_Txt3", "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Txt3:SetPoint( "TOPLEFT", "BGD_Opt_Txt2", "BOTTOMLEFT", 0, -32 )
        BGD_Opt_Txt3:SetText( "本地化选择:" )
    end
    if (BGD_Opt_Drop3 == nil) then
        BGD_Opt_Drop3 = CreateFrame("Frame", "DropDown3", BGD_Opt_Frame, "UIDropDownMenuTemplate")
        BGD_Opt_Drop3:SetPoint("TOPLEFT", "DropDown2", "BOTTOMLEFT", 0, -10)
        UIDropDownMenu_SetWidth(BGD_Opt_Drop3, 140)
    end

    -- Moved to BGD_Opt_Frame_OnShow, so we don't initialize the drop downs if we don't need them.
    -- Might workaround some taint issues related to eight or more menu items in the dropdown.
    --UIDropDownMenu_Initialize(BGD_Opt_Drop1, BGD_Opt_Drop1_Initialize);
    --UIDropDownMenu_Initialize(BGD_Opt_Drop2, BGD_Opt_Drop2_Initialize)
    --UIDropDownMenu_Initialize(BGD_Opt_Drop3, BGD_Opt_Drop3_Initialize)

    BGD_displayLocaleMessages()

    if (BGD_Opt_Btn1 == nil) then
        BGD_Opt_Btn1 = CreateFrame("CheckButton", "BGDefenderPrefaceButton", BGD_Opt_Frame)
        BGD_Opt_Btn1:SetWidth(26)
        BGD_Opt_Btn1:SetHeight(26)
        BGD_Opt_Btn1:SetPoint("TOPLEFT", "BGD_Opt_Txt3",  "BOTTOMLEFT", 0, -16)
        BGD_Opt_Btn1:SetScript("OnClick", function(frame)
            local tick = frame:GetChecked()
            if tick then
                BGD_Prefs.preface = true
            else
                BGD_Prefs.preface = false
            end
        end)
        BGD_Opt_Btn1:SetHitRectInsets(0, -180, 0, 0)
        BGD_Opt_Btn1:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
        BGD_Opt_Btn1:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
        BGD_Opt_Btn1:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
        BGD_Opt_Btn1:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
        local BGD_Opt_Btn1Text = BGD_Opt_Btn1:CreateFontString("BGD_Opt_Btn1Text", "ARTWORK", "GameFontHighlight")
        BGD_Opt_Btn1Text:SetPoint("LEFT", BGD_Opt_Btn1, "RIGHT", 0, 1)
        BGD_Opt_Btn1Text:SetText("显示 |cFF00FF00BGDefender:|r 演示帮助信息")
        BGD_Opt_Btn1:SetChecked(BGD_Prefs.preface)
    end
end


BGD_Opt_Messages  = nil
BGD_Opt_Safe      = nil
BGD_Opt_Inc       = nil
BGD_Opt_IncPlus   = nil
BGD_Opt_Help      = nil

---------
function BGD_displayLocaleMessages()
---------
    local call = ""

    BGD_initLocale(BGD_Prefs.locale)
    
    if (BGD_Opt_Messages == nil) then
        BGD_Opt_Messages = BGD_Opt_Frame:CreateFontString( "BGD_Opt_Messages", "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Messages:SetPoint("TOPLEFT", "BGD_Opt_Txt3", "BOTTOMLEFT", 0, -64)
        BGD_Opt_Messages:SetText( "演示信息:" )
    end
    
    if (BGD_Opt_Safe == nil) then
        BGD_Opt_Safe = BGD_Opt_Frame:CreateFontString( "BGD_Opt_Safe", "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Safe:SetPoint("TOPLEFT", "BGD_Opt_Messages", "BOTTOMLEFT", 16, -16)
    end
    call = BGD_SAFE
    call = string.gsub(call, "$base", GetSubZoneText())
    BGD_Opt_Safe:SetText( "安全: |cFF00FF00" ..call )

    if (BGD_Opt_Inc == nil) then
        BGD_Opt_Inc = BGD_Opt_Frame:CreateFontString( "BGD_Opt_Inc", "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Inc:SetPoint("TOPLEFT", "BGD_Opt_Messages", "BOTTOMLEFT", 16, -32)
    end
    call = BGD_INC
    call = string.gsub(call, "$num", 1)
    call = string.gsub(call, "$base", GetSubZoneText())
    BGD_Opt_Inc:SetText( "数量: |cFF00FF00" ..call )
    
    if (BGD_Opt_IncPlus == nil) then
        BGD_Opt_IncPlus = BGD_Opt_Frame:CreateFontString( "BGD_Opt_IncPlus", "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_IncPlus:SetPoint("TOPLEFT", "BGD_Opt_Messages", "BOTTOMLEFT", 16, -48)
    end
    call = BGD_INCPLUS
    call = string.gsub(call, "$base", GetSubZoneText())
    BGD_Opt_IncPlus:SetText( "大于5数量: |cFF00FF00" ..call )
    
    if (BGD_Opt_Help == nil) then
        BGD_Opt_Help = BGD_Opt_Frame:CreateFontString( "BGD_Opt_Help", "ARTWORK", "GameFontNormalSmall" )
        BGD_Opt_Help:SetPoint("TOPLEFT", "BGD_Opt_Messages", "BOTTOMLEFT", 16, -64)
    end
    call = BGD_HELP
    call = string.gsub(call, "$base", GetSubZoneText())
    BGD_Opt_Help:SetText( "求救: |cFF00FF00" ..call )    
end



---------
function BGD_Opt_Drop1_Initialize()
---------
    local info = UIDropDownMenu_CreateInfo()
    info.text = "副本"
    info.checked = (BGD_Prefs.BGChatTemp == "INSTANCE_CHAT")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "INSTANCE_CHAT"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "团队"
    info.checked = (BGD_Prefs.BGChatTemp == "RAID")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "RAID"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "团队警告"
    info.checked = (BGD_Prefs.BGChatTemp == "RAID_WARNING")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "RAID_WARNING"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
    
    info = UIDropDownMenu_CreateInfo()
    info.text = "小队"
    info.checked = (BGD_Prefs.BGChatTemp == "PARTY")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "PARTY"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
    
    info = UIDropDownMenu_CreateInfo()
    info.text = BGD_GENERAL
    info.checked = (BGD_Prefs.BGChatTemp == BGD_GENERAL)
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = BGD_GENERAL
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "大喊"
    info.checked = (BGD_Prefs.BGChatTemp == "YELL")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "YELL"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "密自己(debug)"
    info.checked = (BGD_Prefs.BGChatTemp == "SELF_WISPER")
    function info.func(arg1, arg2)
        BGD_Prefs.BGChatTemp = "SELF_WISPER"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
end


---------
function BGD_Opt_Drop2_Initialize()
---------
    local info = UIDropDownMenu_CreateInfo()
    info.text = "团队"
    info.checked = (BGD_Prefs.RaidChatTemp == "RAID")
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = "RAID"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "团队警告"
    info.checked = (BGD_Prefs.RaidChatTemp == "RAID_WARNING")
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = "RAID_WARNING"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
    
    info = UIDropDownMenu_CreateInfo()
    info.text = "小队"
    info.checked = (BGD_Prefs.RaidChatTemp == "PARTY")
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = "PARTY"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
    
    info = UIDropDownMenu_CreateInfo()
    info.text = BGD_GENERAL
    info.checked = (BGD_Prefs.RaidChatTemp == BGD_GENERAL)
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = BGD_GENERAL
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "大喊"
    info.checked = (BGD_Prefs.RaidChatTemp == "YELL")
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = "YELL"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "密自己(debug)"
    info.checked = (BGD_Prefs.RaidChatTemp == "SELF_WISPER")
    function info.func(arg1, arg2)
        BGD_Prefs.RaidChatTemp = "SELF_WISPER"
        BGD_Opt_Frame_UpdateViews()
    end
    UIDropDownMenu_AddButton(info)
end


---------
function BGD_Opt_Drop3_Initialize()
---------
    local info = UIDropDownMenu_CreateInfo()
    info.text = "enUS"
    info.checked = (BGD_Prefs.locale == "enUS")
    function info.func(arg1, arg2)
        BGD_Prefs.locale = "enUS"
        BGD_initLocale(BGD_Prefs.locale)
        UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)
        BGD_displayLocaleMessages()
    end
    UIDropDownMenu_AddButton(info)

    --fishuiedit
    --[[
    info = UIDropDownMenu_CreateInfo()
    info.text = "deDE"
    info.checked = (BGD_Prefs.locale == "deDE")
    function info.func(arg1, arg2)
        BGD_Prefs.locale = "deDE"
        BGD_initLocale(BGD_Prefs.locale)
        UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)
        BGD_displayLocaleMessages()
    end
    UIDropDownMenu_AddButton(info)
    
    info = UIDropDownMenu_CreateInfo()
    info.text = "esMX"
    info.checked = (BGD_Prefs.locale == "esMX")
    function info.func(arg1, arg2)
        BGD_Prefs.locale = "esMX"
        BGD_initLocale(BGD_Prefs.locale)
        UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)
        BGD_displayLocaleMessages()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "esES"
    info.checked = (BGD_Prefs.locale == "esES")
    function info.func(arg1, arg2)
        BGD_Prefs.locale = "esES"
        BGD_initLocale(BGD_Prefs.locale)
        UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)
        BGD_displayLocaleMessages()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "frFR"
    info.checked = (BGD_Prefs.locale == "frFR")
    function info.func(arg1, arg2)
        BGD_Prefs.locale = "frFR"
        BGD_initLocale(BGD_Prefs.locale)
        UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)
        BGD_displayLocaleMessages()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "ruRU"
    info.checked = (BGD_Prefs.locale == "ruRU")
    function info.func(arg1, arg2)
        BGD_Prefs.locale = "ruRU"
        BGD_initLocale(BGD_Prefs.locale)
        UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)
        BGD_displayLocaleMessages()
    end
    UIDropDownMenu_AddButton(info)
    ]]

    info = UIDropDownMenu_CreateInfo()
    info.text = "zhCN"
    info.checked = (BGD_Prefs.locale == "zhCN")
    function info.func(arg1, arg2)
        BGD_Prefs.locale = "zhCN"
        BGD_initLocale(BGD_Prefs.locale)
        UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)
        BGD_displayLocaleMessages()
    end
    UIDropDownMenu_AddButton(info)

    info = UIDropDownMenu_CreateInfo()
    info.text = "zhTW"
    info.checked = (BGD_Prefs.locale == "zhTW")
    function info.func(arg1, arg2)
        BGD_Prefs.locale = "zhTW"
        BGD_initLocale(BGD_Prefs.locale)
        UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)
        BGD_displayLocaleMessages()
    end
    UIDropDownMenu_AddButton(info)
end


---------
function BGD_Opt_Frame_UpdateViews()
---------
    if (BGD_Prefs.BGChatTemp == "INSTANCE_CHAT") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "副本")
    elseif (BGD_Prefs.BGChatTemp == "RAID") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "团队")
    elseif (BGD_Prefs.BGChatTemp == "RAID_WARNING") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "团队警告")
    elseif (BGD_Prefs.BGChatTemp == "PARTY") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "小队")
    elseif (BGD_Prefs.BGChatTemp == BGD_GENERAL) then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, BGD_GENERAL)
    elseif (BGD_Prefs.BGChatTemp == "YELL") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "大喊")
    elseif (BGD_Prefs.BGChatTemp == "SELF_WISPER") then
        UIDropDownMenu_SetText(BGD_Opt_Drop1, "密自己(debug)")
    end

    if (BGD_Prefs.RaidChatTemp == "RAID") then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, "团队")
    elseif (BGD_Prefs.RaidChatTemp == "RAID_WARNING") then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, "团队警告")
    elseif (BGD_Prefs.RaidChatTemp == "PARTY") then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, "小队")
    elseif (BGD_Prefs.RaidChatTemp == BGD_GENERAL) then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, BGD_GENERAL)
    elseif (BGD_Prefs.RaidChatTemp == "YELL") then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, "大喊")
    elseif (BGD_Prefs.RaidChatTemp == "SELF_WISPER") then
        UIDropDownMenu_SetText(BGD_Opt_Drop2, "密自己(debug)")
    end
    
    UIDropDownMenu_SetText(BGD_Opt_Drop3, BGD_Prefs.locale)

    BGD_Opt_Btn1:SetChecked(BGD_Prefs.preface)
    
    if (BGD_Prefs.movable == true) then
        Button11:SetText(" m ")
    else
        Button11:SetText(" p ")
    end
end
