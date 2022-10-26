WOW_PROJECT_BURNING_CRUSADE_CLASSIC = WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5

local _, ns = ...
local ycc = ns.ycc
if(not ycc) then return end

local WHITE = {r = 1, g = 1, b = 1}
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%%d', '%%s')
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%$d', '%$s') -- '%2$s %1$d-го уровня'

local CLASS_ENG = {} for i=1, GetNumClasses() do local loc, eng = GetClassInfo(i) CLASS_ENG[loc] = eng end

local playerRealmID = GetRealmID();
local playerRealmName = GetRealmName();
local playerFactionGroup = UnitFactionGroup("player");
local function ShowRichPresenceOnly(client, wowProjectID, faction, realmID)
	if (client ~= BNET_CLIENT_WOW) or (wowProjectID ~= WOW_PROJECT_ID) then
		-- If they are not in wow or in a different version of wow, always show rich presence only
		return true;
	elseif (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) and ((faction ~= playerFactionGroup) or (realmID ~= playerRealmID)) then
		-- If we are both in wow classic and our factions or realms don't match, show rich presence only
		return true;
	else
		-- Otherwise show more detailed info about them
		return false;
	end;
end

local function FriendsListButtonMixin_OnEnter_HOOK(self)
	if ( self.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER ) then
		return;
    end
	local anchor, text;
	local FRIENDS_TOOLTIP_WOW_INFO_TEMPLATE = NORMAL_FONT_COLOR_CODE..FRIENDS_LIST_ZONE.."|r%1$s|n"..NORMAL_FONT_COLOR_CODE..FRIENDS_LIST_REALM.."|r%2$s";
	local numGameAccounts = 0;
	local tooltip = FriendsTooltip;
	local isOnline = false;
	local battleTag = "";
	tooltip.height = 0;
	tooltip.maxWidth = 0;

	if self.buttonType == FRIENDS_BUTTON_TYPE_BNET then
		local accountInfo = C_BattleNet.GetFriendAccountInfo(self.id);
		if accountInfo and (true or accountInfo.gameAccountInfo.wowProjectID == WOW_PROJECT_CLASSIC) and WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			local noCharacterName = true;
			local nameText, nameColor = FriendsFrame_GetBNetAccountNameAndStatus(accountInfo, noCharacterName);

			isOnline = accountInfo.gameAccountInfo.isOnline;
			battleTag = accountInfo.battleTag;

			anchor = FriendsFrameTooltip_SetLine(FriendsTooltipHeader, nil, nameText);
			FriendsTooltipHeader:SetTextColor(nameColor:GetRGB());

			if accountInfo.gameAccountInfo.gameAccountID then
                if true then
					local raceName = accountInfo.gameAccountInfo.raceName or UNKNOWN;
					local className = accountInfo.gameAccountInfo.className or UNKNOWN;
					if CanCooperateWithGameAccount(accountInfo) then
						text = string.format(FRIENDS_TOOLTIP_WOW_TOON_TEMPLATE, accountInfo.gameAccountInfo.characterName, accountInfo.gameAccountInfo.characterLevel, raceName, className);
					else
						text = string.format(FRIENDS_TOOLTIP_WOW_TOON_TEMPLATE, accountInfo.gameAccountInfo.characterName..CANNOT_COOPERATE_LABEL, accountInfo.gameAccountInfo.characterLevel, raceName, className);
					end
					FriendsFrameTooltip_SetLine(FriendsTooltipGameAccount1Name, nil, text);
					local areaName = accountInfo.gameAccountInfo.areaName or UNKNOWN;
					local realmName = accountInfo.gameAccountInfo.realmDisplayName or accountInfo.gameAccountInfo.realmID or UNKNOWN;
					anchor = FriendsFrameTooltip_SetLine(FriendsTooltipGameAccount1Info, nil, string.format(FRIENDS_TOOLTIP_WOW_INFO_TEMPLATE, accountInfo.gameAccountInfo.isWowMobile and LOCATION_MOBILE_APP or areaName, realmName), -4);
				end
			else
				FriendsTooltipGameAccount1Info:Hide();
				FriendsTooltipGameAccount1Name:Hide();
            end

            tooltip.button = self;
           	tooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 36, 0);
           	tooltip:SetHeight(tooltip.height + FRIENDS_TOOLTIP_MARGIN_WIDTH);
           	tooltip:SetWidth(min(FRIENDS_TOOLTIP_MAX_WIDTH, tooltip.maxWidth + FRIENDS_TOOLTIP_MARGIN_WIDTH));
           	tooltip:Show();
		end
	end
end

local function UpdateFriendButton(button)
    local playerArea = GetRealZoneText()

    local nameText, infoText

    if not button:IsShown() then
        return
    end

    if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
        local info = C_FriendList.GetFriendInfoByIndex(button.id);
        if(info.connected) then
            nameText = ycc.classColor[info.className] .. info.name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, ycc.diffColor[info.level] .. info.level .. '|r', info.className)
            if(info.area == playerArea) then
                infoText = format('|cff00ff00%s|r', info.area)
            end
        end

    elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
        local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id);
        local gameInfo = accountInfo and accountInfo.gameAccountInfo
        if gameInfo and gameInfo.clientProgram == BNET_CLIENT_WOW and gameInfo.className then
            local class = CLASS_ENG[gameInfo.className]
            if accountInfo.gameAccountInfo.isOnline and gameInfo.areaName == playerArea then
                if ShowRichPresenceOnly(accountInfo.gameAccountInfo.clientProgram, accountInfo.gameAccountInfo.wowProjectID, accountInfo.gameAccountInfo.factionName, accountInfo.gameAccountInfo.realmID) then
                    infoText = format('|cff00ff00%s|r', playerArea)
                end
            end
            if class then
                nameText = BNet_GetBNetAccountName(accountInfo) .. ' ' .. FRIENDS_WOW_NAME_COLOR_CODE..'('.. FONT_COLOR_CODE_CLOSE
                        .. ycc.classColor[class] .. (gameInfo.characterName or "") .. FONT_COLOR_CODE_CLOSE .. FRIENDS_WOW_NAME_COLOR_CODE .. ')' .. FONT_COLOR_CODE_CLOSE
                if gameInfo.wowProjectID == WOW_PROJECT_CLASSIC and WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
                    infoText = "|cffaa0303经典怀旧|r " .. gameInfo.areaName .. " " .. LEVEL .. gameInfo.characterLevel
                elseif gameInfo.wowProjectID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC and WOW_PROJECT_ID ~= WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
                    infoText = "|cff03aa03TBC怀旧|r " .. gameInfo.areaName .. " " .. LEVEL .. gameInfo.characterLevel
                elseif gameInfo.wowProjectID == WOW_PROJECT_WRATH_CLASSIC and WOW_PROJECT_ID ~= WOW_PROJECT_WRATH_CLASSIC then
                    infoText = "|cff03aa03WLK怀旧|r " .. gameInfo.areaName .. " " .. LEVEL .. gameInfo.characterLevel
                end
            end
        end
    end

    if(nameText) then
        button.name:SetText(nameText)
    end
    if(infoText) then
        button.info:SetText(infoText)
    end
end

local function friendsFrame()
    local scrollFrame = FriendsListFrameScrollFrame
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local buttons = scrollFrame.buttons

    for i = 1, #buttons do
        local nameText, infoText
        local button = buttons[i]
        --if not button.__abyui_hooked then
        --    button.__abyui_hooked = true
        --    button:HookScript("OnEnter", FriendsListButtonMixin_OnEnter_HOOK)
        --end

        UpdateFriendButton(button)
    end
end

if FriendsFrame_UpdateFriendButton then
    hooksecurefunc('FriendsFrame_UpdateFriendButton', function(button, elementData) UpdateFriendButton(button) end)
elseif FriendsListFrameScrollFrame then
    hooksecurefunc(FriendsListFrameScrollFrame, 'update', friendsFrame)
    hooksecurefunc('FriendsFrame_UpdateFriends', friendsFrame)
end

if FriendsTooltip then

    --没有其他好办法
    SetOrHookScript(FriendsTooltip, "OnHide", function()
        for i=1, FRIENDS_TOOLTIP_MAX_GAME_ACCOUNTS do
            local line = _G["FriendsTooltipGameAccount"..i.."Name"];
            line:SetWidth(176)
        end
    end)

    hooksecurefunc(FriendsTooltip, "Show", function(self)
        if self._showByAby then self._showByAby = nil return end

        local button = self.button
        if not button and FriendsListFrameScrollFrameScrollChild and button:GetParent() == FriendsListFrameScrollFrameScrollChild then
            return
        end

        if not button.buttonType ~= FRIENDS_BUTTON_TYPE_BNET then
            return
        end

        local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id);
        local gameInfo = accountInfo and accountInfo.gameAccountInfo
        if not gameInfo or not gameInfo.isOnline then
            return
        end

        local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(button.id);
        local gameAccountIndex = 0;
        for i = 1, numGameAccounts do
            local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(button.id, i);
            if (true or not gameAccountInfo.hasFocus) and (gameAccountInfo.clientProgram ~= BNET_CLIENT_APP) and (gameAccountInfo.clientProgram ~= BNET_CLIENT_CLNT) then
                gameAccountIndex = gameAccountIndex + 1;
                if ( gameAccountIndex > FRIENDS_TOOLTIP_MAX_GAME_ACCOUNTS ) then
                    break;
                end
                local characterNameString = _G["FriendsTooltipGameAccount"..gameAccountIndex.."Name"];
                local gameAccountInfoString = _G["FriendsTooltipGameAccount"..gameAccountIndex.."Info"];

                if (gameAccountInfo.clientProgram == BNET_CLIENT_WOW) then
                    -- 把系统显示的角色名称加上颜色
                    local class = gameAccountInfo and CLASS_ENG[gameAccountInfo.className]
                    if class then
                        local old = characterNameString:GetText() or ""
                        local colored = ycc.classColor[class] .. gameAccountInfo.characterName .. FONT_COLOR_CODE_CLOSE
                        if old:find(gameAccountInfo.characterName .. "$") then
                            old = old:gsub(gameAccountInfo.characterName .. "$", colored)
                            characterNameString:SetText(old)
                        elseif old:find(gameAccountInfo.characterName .. "[^\124]") then
                            old = old:gsub(gameAccountInfo.characterName .. "([^\124])", colored .. "%1")
                            characterNameString:SetText(old)
                        end
                    end

                    -- 不同版本的魔兽额外显示等级 种族 地区
                    if gameAccountInfo.wowProjectID ~= WOW_PROJECT_ID then
                        local raceName = accountInfo.gameAccountInfo.raceName or UNKNOWN;
                        local areaName = accountInfo.gameAccountInfo.areaName or "";
                        local line = characterNameString
                        --line:SetWordWrap(false)
                        local old = line:GetText()
                        line:SetText(old .. " " .. accountInfo.gameAccountInfo.characterLevel .. " " .. raceName .. " " .. areaName)
                        local width = line:GetStringWidth()
                        line:SetWidth(width)
                        if width + FRIENDS_TOOLTIP_MARGIN_WIDTH*2 > self:GetWidth() then
                            self:SetWidth(width + FRIENDS_TOOLTIP_MARGIN_WIDTH*2)
                        end
                    end

                    -- 改了区域之后显示中国，改回来
                    local areaName = gameAccountInfo.isWowMobile and LOCATION_MOBILE_APP or (gameAccountInfo.areaName or UNKNOWN);
                    local realmName = gameAccountInfo.realmDisplayName or gameAccountInfo.realmID or UNKNOWN;
                    if not gameAccountInfo.isInCurrentRegion then
                        gameAccountInfoString:SetText(BNET_FRIEND_TOOLTIP_ZONE_AND_REALM:format(areaName, realmName));
                        if FriendsTooltip:GetBottom() and gameAccountInfoString:GetBottom() < FriendsTooltip:GetBottom() + 10 then
                            FriendsTooltip:SetHeight(FriendsTooltip:GetHeight()+15)
                        end
                    end
                end
            end
        end
    end)
end

