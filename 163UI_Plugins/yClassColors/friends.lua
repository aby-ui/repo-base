
local _, ns = ...
local ycc = ns.ycc
if(not ycc) then return end

local WHITE = {r = 1, g = 1, b = 1}
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%%d', '%%s')
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%$d', '%$s') -- '%2$s %1$d-го уровня'

local CLASS_ENG = {} for i=1, GetNumClasses() do local loc, eng = GetClassInfo(i) CLASS_ENG[loc] = eng end
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
		if accountInfo and accountInfo.gameAccountInfo.wowProjectID == WOW_PROJECT_CLASSIC and WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
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

local function friendsFrame()
    local scrollFrame = FriendsListFrameScrollFrame
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local buttons = scrollFrame.buttons

    local playerArea = GetRealZoneText()

    for i = 1, #buttons do
        local nameText, infoText, nameColor
        local button = buttons[i]
        local index = offset + i
        --if not button.__abyui_hooked then
        --    button.__abyui_hooked = true
        --    button:HookScript("OnEnter", FriendsListButtonMixin_OnEnter_HOOK)
        --end

        if(button:IsShown()) then
            if ( button.buttonType == FRIENDS_BUTTON_TYPE_WOW ) then
                local name, level, class, area, connected, status, note = GetFriendInfo(button.id)
                if(connected) then
                    nameText = ycc.classColor[class] .. name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, ycc.diffColor[level] .. level .. '|r', class)
                    if(areaName == playerArea) then
                        infoText = format('|cff00ff00%s|r', area)
                    end
                end
            elseif (button.buttonType == FRIENDS_BUTTON_TYPE_BNET) then
                local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id);
                local gameInfo = accountInfo and accountInfo.gameAccountInfo
                if gameInfo and gameInfo.className then
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
                            infoText = "|cff880303怀旧服|r" .. gameInfo.areaName .. " " .. LEVEL .. gameInfo.characterLevel
                        end
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
end
hooksecurefunc(FriendsListFrameScrollFrame, 'update', friendsFrame)
hooksecurefunc('FriendsFrame_UpdateFriends', friendsFrame)


