SLASH_TRADELOGSHOW1 = "/tbtdebug";
SlashCmdList["TRADELOGSHOW"] = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage("(debug)TradeId-"..msg.." |Htradelog:"..msg.."|h[DETAIL]|h:");
	TBT_CURRENT_TRADE = TradeLog_TradesHistory[0+msg];
	TradeLog_OutputLog();
	table.remove(TradeLog_TradesHistory, getn(TradeLog_TradesHistory));
end

TBT_CURRENT_TRADE = nil;

local function curr()
	if(not TBT_CURRENT_TRADE) then
		TBT_CURRENT_TRADE = TradeLog_CreateNewTrade();
	end
	return TBT_CURRENT_TRADE;
end

function TradeLog_CreateNewTrade() 
	local trade = {
		id = nil,
		when = nil,
		where = nil,
		who = nil,
		player=UnitName("player"),
		playerMoney = 0,
		targetMoney = 0,
		playerItems = {},
		targetItems = {},
		events = {},  --for analysing cancel reason
		toofar = nil, --for further analysing cancel reason
		result = nil, --[cancelled | complete | error]
		reason = nil, --["self" | "selfrunaway" | "toofar" | "other" | "selfhideui" | ERR_TRADE_BAG_FULL | ERR_TRADE_MAX_COUNT_EXCEEDED | ERR_TRADE_TARGET_BAG_FULL | ERR_TRADE_TARGET_MAX_COUNT_EXCEEDED]
	};
	return trade;
end

function TradeLog_OnLoad(self)
	local menu = CreateFrame("Frame", "TBT_AnnounceChannelDropDown", TradeFrame, "UIDropDownMenuTemplate");
	-- menu:SetPoint("BOTTOMLEFT", "TradeFrame", "BOTTOMLEFT", 80, 49);
	UIDropDownMenu_SetWidth(TBT_AnnounceChannelDropDown, 62, 3);
    TBT_AnnounceChannelDropDown:SetScript("OnShow", function(self) self:SetFrameLevel(TradeFrame:GetFrameLevel()) end)

	local cb = CreateFrame("CheckButton", "TBT_AnnounceCB", TradeFrame, "OptionsCheckButtonTemplate");
	cb:SetPoint("BOTTOMLEFT", "TradeFrame", "BOTTOMLEFT", 16, 0);
	cb:SetWidth(26);
	cb:SetHeight(26);
	TBT_AnnounceCBText:SetText(TRADE_LOG_ANNOUNCE);
	cb.tooltipText = TRADE_LOG_ANNOUNCE_TIP;
	cb:SetScript("OnClick", function(self) TradeLog_Announce_Checked = self:GetChecked()and true or false; end);

    menu:SetPoint('BOTTOMLEFT', cb, 50, -3)

	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("TRADE_SHOW");
	self:RegisterEvent("TRADE_CLOSED");
	self:RegisterEvent("TRADE_REQUEST_CANCEL");
	self:RegisterEvent("PLAYER_TRADE_MONEY");

	self:RegisterEvent("TRADE_MONEY_CHANGED");
	--self:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED"); --this is an uncertain problem, seems TRADE_PLAYER_ITEM_CHANGED always fire 2 times?
	self:RegisterEvent("TRADE_TARGET_ITEM_CHANGED");
	self:RegisterEvent("TRADE_ACCEPT_UPDATE");
	self:RegisterEvent("UI_INFO_MESSAGE");
	self:RegisterEvent("UI_ERROR_MESSAGE");
end

function TradeLog_OnEvent(self, event, arg1, arg2, ...)
	if (event=="UI_ERROR_MESSAGE") then
		if(arg2==ERR_TRADE_BAG_FULL or arg2==ERR_TRADE_MAX_COUNT_EXCEEDED or arg2==ERR_TRADE_TARGET_BAG_FULL or arg2==ERR_TRADE_TARGET_MAX_COUNT_EXCEEDED) then
			curr().result = "error";
			curr().reason=arg2;
			TradeLog_LogTradeAndReset();
		elseif (arg2==ERR_TRADE_TARGET_DEAD or arg2==ERR_TRADE_TOO_FAR) then
			DEFAULT_CHAT_FRAME:AddMessage(arg2, 1, 0.2, 0.2);
		end

	elseif (event=="UI_INFO_MESSAGE" and ( arg2==ERR_TRADE_CANCELLED or arg2==ERR_TRADE_COMPLETE) ) then
		curr().result = (arg2==ERR_TRADE_CANCELLED) and "cancelled" or "complete"
		TradeLog_LogTradeAndReset();

	elseif (event=="TRADE_CLOSED" or event=="TRADE_REQUEST_CANCEL" or event == "TRADE_SHOW") then
		table.insert(curr().events, event);
	
	elseif (event=="TRADE_PLAYER_ITEM_CHANGED") then
		TradeLog_UpdateItemInfo(arg1, "Player", curr().playerItems);
	
	elseif (event=="TRADE_TARGET_ITEM_CHANGED") then
		TradeLog_UpdateItemInfo(arg1, "Target", curr().targetItems);
	
	elseif (event=="TRADE_MONEY_CHANGED") then
		TradeLog_UpdateMoney();
	
	elseif (event=="TRADE_ACCEPT_UPDATE") then
		for i = 1, 7 do
			TradeLog_UpdateItemInfo(i, "Player", curr().playerItems);
			TradeLog_UpdateItemInfo(i, "Target", curr().targetItems);
		end
		TradeLog_UpdateMoney();
	elseif (event=="VARIABLES_LOADED") then
		TradeLog_TradesHistory = TradeLog_TradesHistory or {};

		for k, v in ipairs(TradeLog_TradesHistory) do
			v.id = v.id or k 
		end

		TradeLog_AnnounceChannel = TradeLog_AnnounceChannel or "WHISPER";

		UIDropDownMenu_Initialize(TBT_AnnounceChannelDropDown, TBT_AnnounceChannelDropDown_Initialize);
		UIDropDownMenu_SetSelectedValue(TBT_AnnounceChannelDropDown, TradeLog_AnnounceChannel);

		if(TradeLog_Announce_Checked) then TBT_AnnounceCB:SetChecked(1); end;

        if TradeLogFrame_CreateMinimapButton then TradeLogFrame_CreateMinimapButton() end
	end

	if (event=="TRADE_REQUEST_CANCEL") then --judge the trade distance for further analysing the cancel reason
		if(UnitName("NPC")) then
			curr().toofar = CheckInteractDistance("npc", 2) and "no" or "yes"
		end
	end
	
	if (event=="TRADE_SHOW") then
		--curr().who=GetUnitName("NPC", true):gsub(" %- ", "-");
		curr().who=GetUnitName("NPC", true);
	end
end

function TradeLog_UpdateItemInfo(id, unit, items)
	local funcInfo = getglobal("GetTrade"..unit.."ItemInfo");
	local funcLink = getglobal("GetTrade"..unit.."ItemLink");

	local name, texture, numItems, quality, isUsable, enchantment;
	--why GetTradePlayerItemInfo and GetTradeTargetItemInfo return different things?
	if(unit=="Target") then
		name, texture, numItems, quality, isUsable, enchantment = funcInfo(id);
	else
		name, texture, numItems, quality, enchantment = funcInfo(id);
	end

	if(not name) then
		items[id] = nil;
		return;
	end

	local itemLink = funcLink(id);

	items[id] = {
		name = name,
		texture = texture,
		numItems = numItems,
		isUsable = isUsable,
		enchantment = enchantment,
		itemLink = itemLink,
	}
end

function TradeLog_UpdateMoney()
	curr().playerMoney = GetPlayerTradeMoney();
	curr().targetMoney = GetTargetTradeMoney();
end

function TradeLog_AnalyseCancelReason()
	local reason = "unknown"; --should be unknown only when no trade window opened.
	local e = curr().events;
	local n = table.getn(e);
	if(n>=3 and e[n]=="TRADE_REQUEST_CANCEL" and e[n-1]=="TRADE_CLOSED" and e[n-2]=="TRADE_CLOSED") then
		reason = "self";
	elseif(n>=3 and e[n]=="TRADE_REQUEST_CANCEL" and e[n-1]=="TRADE_CLOSED" and e[n-2]=="TRADE_SHOW") then
		reason = "selfrunaway";
	elseif(n>=3 and e[n]=="TRADE_CLOSED" and e[n-1]=="TRADE_CLOSED" and e[n-2]=="TRADE_REQUEST_CANCEL") then
		if(curr().toofar == "yes") then
			reason = "toofar";
		elseif(curr().toofar == "no") then
			reason = "other";
		else
			reason = "wrong!!"; --this should not happen, if you see, contact me :p
		end
	elseif(n>=3 and e[n]=="TRADE_REQUEST_CANCEL" and e[n-1]=="TRADE_SHOW" and e[n-2]=="TRADE_CLOSED") then
		reason = "selfhideui";
	end

	curr().events = nil; --reason analyzed, abandon it to release that tiny memory
	return reason;
end

function TradeLog_LogTradeAndReset()
	curr().when = date("%Y-%m-%d %H:%M:%S");
	curr().where = GetRealZoneText();
	if( curr().result == "cancelled" ) then
		curr().reason = TradeLog_AnalyseCancelReason();
	elseif( curr().result == "error" ) then
		curr().reason = curr().reason;
	end
	TradeLog_OutputLog();
	TBT_CURRENT_TRADE = nil;
end

function TBT_nextId(tab)
	local n = 0;
	for k,v in ipairs(tab) do
		if(v.id>n) then n=v.id end;
	end
	return n+1;
end;

function TradeLog_GetTradeList(money, items, enchant, moneyText, countOnly)
	local list = {}
	if(money > 0) then
		table.insert( list, moneyText(money) );
	end
	local count = 0
	for i=1,6 do
		if(items[i]) then
			count = count + 1
			local tmp = items[i].itemLink;
			if(items[i].numItems>1) then
				tmp = tmp.."x"..items[i].numItems;
			end
			if(not countOnly) then table.insert(list, tmp) end
		end
	end
	if(countOnly and count>0) then
		local text = string.gsub(TRADE_LOG_ITEM_NUMBER, "%%d", count)
		table.insert(list, text)
	end

	if(enchant and enchant.name and enchant.enchantment) then
		table.insert(list, countOnly and TRADE_LOG_ENCHANT or enchant.enchantment)
	end
	return list;
end

local function SendChat(msg, name)
	local channel = TradeLog_FindAnnounceChannel(TradeLog_AnnounceChannel);
	if(channel=="WHISPER")then
		SendChatMessage(msg,channel,nil,name);
	else
		SendChatMessage(msg,channel);
	end
end

function TradeLog_FindAnnounceChannel(channel)
	--channel should be WHISPER, RAID, PARTY, SAY, YELL
	if(channel=="RAID") then
		if (UnitInRaid("player")) then 
			return "RAID";
		elseif ( IsInGroup() ) then
			return "PARTY";
		else
			return "SAY";
		end
	elseif(channel=="PARTY") then
		if ( IsInGroup() ) then
			return "PARTY";
		else
			return "SAY";
		end
	end
	return channel;
end

function TradeLog_Output(trade, func, plain)
	local whoLink = plain and trade.who or "|Hplayer:"..trade.who.."|h"..trade.who.."|h";
	if(trade.result == "complete") then
		local playerList = TradeLog_GetTradeList( trade.playerMoney, trade.playerItems, trade.targetItems[7], plain and TradeLog_GetMoneyPlainText or TradeLog_GetMoneyColorText)
		local targetList = TradeLog_GetTradeList( trade.targetMoney, trade.targetItems, trade.playerItems[7], plain and TradeLog_GetMoneyPlainText or TradeLog_GetMoneyColorText)

		if(#playerList==0 and #targetList==0) then
			func(string.gsub(TRADE_LOG_SUCCESS_NO_EXCHANGE, "%%t", whoLink), 1, 1, 0);
		else
			if(plain) then
				local breaked = false
				local first = true
				local msg = string.gsub(TRADE_LOG_SUCCESS, "%%t", whoLink);
				if(#playerList > 0) then
					msg = msg.."("..TRADE_LOG_HANDOUT..")"
					for _, v in pairs(playerList) do
						if(strlen(msg..v) > 255) then
							breaked = true;
							func(msg)
							msg = "("..TRADE_LOG_HANDOUT..")"..v
							first = false
						else
							if(not first) then msg = msg.."," end
							first = false
							msg = msg..v
						end
					end
					first = true
				end

				if(#targetList > 0) then
					if(breaked) then 
						func(msg)
						msg = "("..TRADE_LOG_RECEIVE..")"
					else
						msg = msg.." ("..TRADE_LOG_RECEIVE..")"
					end
					for _, v in pairs(targetList) do
						if(strlen(msg..v) > 255) then
							func(msg)
							msg = "("..TRADE_LOG_RECEIVE..")"..v
							first = false
						else
							if(not first) then msg = msg.."," end
							first = false
							msg = msg..v
						end
					end
				end

				func(msg)

			else
				local detailString = TradeLogFrame and ("|CFF00B4FF|Htradelog:"..TEXT(curr().id).."|h["..TRADE_LOG_DETAIL.."]|h|r") or TRADE_LOG_DETAIL;
				func(string.gsub(TRADE_LOG_SUCCESS, "%%t", whoLink)..detailString..":", 1, 1, 0);
				if(#playerList>0) then
					func("("..TRADE_LOG_HANDOUT..") "..table.concat(playerList, ","), 1, 0.8, 0.8);
				end
				if(#targetList>0) then
					func("("..TRADE_LOG_RECEIVE..") "..table.concat(targetList, ","), 0.8, 1, 0.8);
				end
			end
		end


	elseif(trade.result == "cancelled") then
		msg = string.gsub(TRADE_LOG_CANCELLED, "%%t", whoLink);
		msg = string.gsub(msg, "%%r", CANCEL_REASON_TEXT[trade.reason]);
		func(msg, 1, 0.5, 0.5);
	else

		msg = string.gsub(TRADE_LOG_FAILED, "%%t", whoLink);
		msg = string.gsub(msg, "%%r", trade.reason);
		func(msg, 1, 0.1, 0.1);
	end

end

function TradeLog_OutputLog()
	local numPlayer, numTarget, enPlayer, enTarget, msg;
	if(not curr().who) then
		--never show the trade window
		if( curr().reason =="selfhideui" ) then
			DEFAULT_CHAT_FRAME:AddMessage(string.gsub(TRADE_LOG_FAILED_NO_TARGET, "%%r", CANCEL_REASON_TEXT[curr().reason]));
		else
			--TBT_debug("debug : no window opened");
		end
		return;
	end
	curr().id = TBT_nextId(TradeLog_TradesHistory);
	table.insert(TradeLog_TradesHistory, curr());
	if(type(TradeListScrollFrame_Update)=="function") then TradeListScrollFrame_Update(); end

	TradeLog_Output(curr(), function(m, r, g, b) DEFAULT_CHAT_FRAME:AddMessage(m, r, g, b) end);
	if(TBT_AnnounceCB:GetChecked()) then
		TradeLog_Output(curr(), function(m) SendChat(m, curr().who) end, true);
	end
end

function TradeLog_GetMoneyColorText(money)
	local GSC_GOLD="ffd100"
	local GSC_SILVER="e6e6e6"
	local GSC_COPPER="c8602c"

	local g = math.floor( money / 10000 );
	local s = math.floor( money / 100 ) - g*100 ;
	local c = money - ( g * 100 + s ) * 100;

	local text = ""
	if(g>0) then text = text.."|cffffff00"..g.."|r".."|cff"..GSC_GOLD..TRADE_LOG_MONEY_NAME.gold.."|r"; end
	if(s>0) then text = text.."|cffffff00"..s.."|r".."|cff"..GSC_SILVER..TRADE_LOG_MONEY_NAME.silver.."|r"; end
	if(c>0) then text = text.."|cffffff00"..c.."|r".."|cff"..GSC_COPPER..TRADE_LOG_MONEY_NAME.copper.."|r"; end

	return text;
end

function TradeLog_GetMoneyPlainText(money)
	local g = math.floor( money / 10000 );
	local s = math.floor( money / 100 ) - g*100 ;
	local c = money - ( g * 100 + s ) * 100;

	local text = ""
	if(g>0) then text = text..g..TRADE_LOG_MONEY_NAME.gold; end
	if(s>0) then text = text..s..TRADE_LOG_MONEY_NAME.silver; end
	if(c>0) then text = text..c..TRADE_LOG_MONEY_NAME.copper; end

	return text;
end

function TradeLog_TradeTooltip(self, trade)
	GameTooltip_SetDefaultAnchor(GameTooltip, self);
	if(trade.result=="complete")then
		local playerList = TradeLog_GetTradeList( trade.playerMoney, trade.playerItems, trade.targetItems[7], TradeLog_GetMoneyColorText)
		local targetList = TradeLog_GetTradeList( trade.targetMoney, trade.targetItems, trade.playerItems[7], TradeLog_GetMoneyColorText)

		GameTooltip:SetText(TRADE_LOG_RESULT_TEXT.complete.." - "..trade.who, 1, 1, 1);
		local _,_,month,day,hour,min = string.find(trade.when, "(%d+)-(%d+) (%d+):(%d+)")
		local when = (month..TRADE_LOG_MONTH_SUFFIX..day..TRADE_LOG_DAY_SUFFIX.." "..hour..":"..min);
		GameTooltip:AddDoubleLine(when, trade.where);
		GameTooltip:AddDoubleLine(TRADE_LOG_HANDOUT, TRADE_LOG_RECEIVE, 0.6, 0.6, 0.6, 1, 1, 1);
		--if trade.playerMoney + trade.targetMoney > 0 then
		--	GameTooltip:AddDoubleLine(TradeLog_GetMoneyColorText(trade.playerMoney).." ", " "..TradeLog_GetMoneyColorText(trade.targetMoney), 0.6, 0.6, 0.6, 1, 1, 1);
		--end
		for  i=1, math.max(#playerList, #targetList) do
			GameTooltip:AddDoubleLine(playerList[i] or " ", targetList[i] or " ");
		end
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(TRADE_LOG_COMPLETE_TOOLTIP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	elseif(trade.result=="cancelled")then
		GameTooltip:SetText(TRADE_LOG_RESULT_TEXT.cancelled.." - "..trade.who, 1, 0.5, 0.5);
		GameTooltip:AddLine(CANCEL_REASON_TEXT[trade.reason], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	else
		GameTooltip:SetText(TRADE_LOG_RESULT_TEXT.error, 1, 0.1, 0.1);
		GameTooltip:AddLine(trade.reason, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	end	
	GameTooltip:Show();
end

--for UI
function TBT_AnnounceChannelDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedValue(TBT_AnnounceChannelDropDown, self.value);
	TBT_AnnounceCB:SetChecked(1);
	TradeLog_AnnounceChannel = self.value;
end

function TBT_AnnounceChannelDropDown_Initialize()
	local selectedValue = UIDropDownMenu_GetSelectedValue(getglobal("TBT_AnnounceChannelDropDown"));
	local info;

	info = {};
	info.text = TRADE_LOG_CHANNELS.whisper;
	info.func = TBT_AnnounceChannelDropDown_OnClick;
	info.value = "WHISPER"
	if ( info.value == selectedValue ) then
		info.checked = 1;
	end
	UIDropDownMenu_AddButton(info);
	
	info = {};
	info.text = TRADE_LOG_CHANNELS.raid;
	info.func = TBT_AnnounceChannelDropDown_OnClick;
	info.value = "RAID"
	if ( info.value == selectedValue ) then
		info.checked = 1;
	end
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TRADE_LOG_CHANNELS.party;
	info.func = TBT_AnnounceChannelDropDown_OnClick;
	info.value = "PARTY"
	if ( info.value == selectedValue ) then
		info.checked = 1;
	end
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TRADE_LOG_CHANNELS.say;
	info.func = TBT_AnnounceChannelDropDown_OnClick;
	info.value = "SAY"
	if ( info.value == selectedValue ) then
		info.checked = 1;
	end
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TRADE_LOG_CHANNELS.yell;
	info.func = TBT_AnnounceChannelDropDown_OnClick;
	info.value = "YELL"
	if ( info.value == selectedValue ) then
		info.checked = 1;
	end
	UIDropDownMenu_AddButton(info);
end

local frame = CreateFrame("Frame");
frame:SetScript("OnEvent", TradeLog_OnEvent);
TradeLog_OnLoad(frame);
