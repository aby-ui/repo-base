-- These are functions that were deprecated in 8.2.5, and will be removed in the next expansion.
-- Please upgrade to the updated APIs as soon as possible.

if not IsPublicBuild() then
	return;
end

-- Old Recruit A Friend system removal
do
	-- Use C_RecruitAFriend.IsEnabled instead.
	C_RecruitAFriend.IsSendingEnabled = C_RecruitAFriend.IsEnabled;

	-- Use C_RecruitAFriend.IsEnabled instead.
	C_RecruitAFriend.CheckEmailEnabled = C_RecruitAFriend.IsEnabled;

	-- No longer supported
	C_RecruitAFriend.SendRecruit = function(email, message, name)
	end

	-- No longer supported
	SendSoRByText = function()
		return false;
	end

	-- No longer supported
	CanSendSoRByText = function()
		return false;
	end

	-- No longer supported
	GetNumSoRRemaining = function()
		return 0;
	end

	-- No longer supported
	GuildRosterSendSoR = function()
		return false;
	end
end

-- Newbie tooltips haven't been supported for a long time, so GameTooltip_AddNewbieTip has been removed
do
	-- Use GameTooltip:SetOwner and GameTooltip_SetTitle instead
	function GameTooltip_AddNewbieTip(frame, normalText, r, g, b, newbieText, noNormalText)
		if not noNormalText then
			GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
			GameTooltip_SetTitle(GameTooltip, normalText);
		end
	end
end

-- IsQuestFlaggedCompleted was moved to C_QuestLog, functionality remains identical
do
	IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted;
end

-- Converting BNet friend API over to returning a single table that contains all info needed instead of multiple calls which return a million values
do
	local function getDeprecatedAccountInfo(accountInfo)
		if accountInfo then
			local wowProjectID = accountInfo.gameAccountInfo.wowProjectID or 0;
			local clientProgram = accountInfo.gameAccountInfo.clientProgram ~= "" and accountInfo.gameAccountInfo.clientProgram or nil;

			return	accountInfo.bnetAccountID, accountInfo.accountName, accountInfo.battleTag, accountInfo.isBattleTagFriend,
					accountInfo.gameAccountInfo.characterName, accountInfo.gameAccountInfo.gameAccountID, clientProgram,
					accountInfo.gameAccountInfo.isOnline, accountInfo.lastOnlineTime, accountInfo.isAFK, accountInfo.isDND, accountInfo.customMessage, accountInfo.note, accountInfo.isFriend,
					accountInfo.customMessageTime, wowProjectID, accountInfo.rafLinkType == Enum.RafLinkType.Recruit, accountInfo.gameAccountInfo.canSummon, accountInfo.isFavorite, accountInfo.gameAccountInfo.isWowMobile;
		end
	end

	-- Use C_BattleNet.GetFriendAccountInfo instead.
	BNGetFriendInfo = function(friendIndex)
		local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex);
		return getDeprecatedAccountInfo(accountInfo);
	end

	-- Use C_BattleNet.GetAccountInfoByID instead.
	BNGetFriendInfoByID = function(id)
		local accountInfo = C_BattleNet.GetAccountInfoByID(id);
		return getDeprecatedAccountInfo(accountInfo);
	end

	local function getDeprecatedGameAccountInfo(gameAccountInfo, accountInfo)
		if gameAccountInfo and accountInfo then
			local wowProjectID = gameAccountInfo.wowProjectID or 0;
			local characterName = gameAccountInfo.characterName or "";
			local realmName = gameAccountInfo.realmName or "";
			local realmID = gameAccountInfo.realmID or 0;
			local factionName = gameAccountInfo.factionName or "";
			local raceName = gameAccountInfo.raceName or "";
			local className = gameAccountInfo.className or "";
			local areaName = gameAccountInfo.areaName or "";
			local characterLevel = gameAccountInfo.characterLevel or "";
			local richPresence = gameAccountInfo.richPresence or "";
			local gameAccountID = gameAccountInfo.gameAccountID or 0;
			local playerGuid = gameAccountInfo.playerGuid or 0;

			return	gameAccountInfo.hasFocus, characterName, gameAccountInfo.clientProgram,
					realmName, realmID, factionName, raceName, className, "", areaName, characterLevel,
					richPresence, accountInfo.customMessage, accountInfo.customMessageTime,
					gameAccountInfo.isOnline, gameAccountID, accountInfo.bnetAccountID, gameAccountInfo.isGameAFK, gameAccountInfo.isGameBusy,
					playerGuid, wowProjectID, gameAccountInfo.isWowMobile;
		end
	end

	-- Use C_BattleNet.GetFriendGameAccountInfo (and GetFriendAccountInfo if you need the customMessage or bnetAccountID) instead.
	BNGetFriendGameAccountInfo = function(friendIndex, accountIndex)
		local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(friendIndex, accountIndex);
		local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex);
		return getDeprecatedGameAccountInfo(gameAccountInfo, accountInfo);
	end

		-- Use C_BattleNet.GetGameAccountInfoByID (and GetAccountInfoByID if you need the customMessage or bnetAccountID) instead.
	BNGetGameAccountInfo = function(id, accountIndex)
		local gameAccountInfo = C_BattleNet.GetGameAccountInfoByID(id, accountIndex);
		local accountInfo = C_BattleNet.GetAccountInfoByID(id);
		return getDeprecatedGameAccountInfo(gameAccountInfo, accountInfo);
	end

	-- Use C_BattleNet.GetGameAccountInfoByGUID (and GetAccountInfoByGUID if you need the customMessage or bnetAccountID) instead.
	BNGetGameAccountInfoByGUID = function(guid)
		local gameAccountInfo = C_BattleNet.GetGameAccountInfoByGUID(guid);
		local accountInfo = C_BattleNet.GetAccountInfoByGUID(guid);
		return getDeprecatedGameAccountInfo(gameAccountInfo, accountInfo);
	end

	-- Use C_BattleNet.GetFriendNumGameAccounts instead.
	BNGetNumFriendGameAccounts = function(friendIndex)
		return C_BattleNet.GetFriendNumGameAccounts(friendIndex);
	end
end

-- CompactUnitFrame.lua changes
-- 不能有，不然会污染

-- BuffFrame.lua changes
-- 不能有，不然会污染

-- Party changes
do
	LeaveParty = C_PartyInfo.LeaveParty;
	ConvertToRaid = C_PartyInfo.ConvertToRaid;
	ConvertToParty = C_PartyInfo.ConvertToParty;
	CanGroupInvite = C_PartyInfo.CanInvite;
	InviteToGroup = C_PartyInfo.InviteUnit;
	InviteUnit = C_PartyInfo.InviteUnit;
	RequestInviteFromUnit = C_PartyInfo.RequestInviteFromUnit;

	function RealPartyIsFull()
		if ( (GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) < MAX_PARTY_MEMBERS) or (IsInRaid(LE_PARTY_CATEGORY_HOME) and (GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) < MAX_RAID_MEMBERS)) ) then
			return false;
		else
			return true;
		end
	end
end

-- PVP Scoreboard changes
-- Use GetMatchPVPStatIDs replaced with GetMatchPVPStatColumns. These are being ordered
-- for backward compatibility.
do
	C_PvP.GetMatchPVPStatIDs = function()
		local statColumns = C_PvP.GetMatchPVPStatColumns();
		table.sort(statColumns, function(lhs,rhs)
			return lhs.orderIndex < rhs.orderIndex;
		end);

		local pvpStatIDs = {};
		for index = 1, #statColumns do
			tinsert(pvpStatIDs, statColumns[index].pvpStatID)
		end

		return pvpStatIDs;
	end
end