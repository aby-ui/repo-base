--## Interface: 80000
--## Title: ExaltedPlus
--## Notes: Enhancements for paragon reputations
--## Version: 7
--## Author: Kanegasi
local addonName = ...
U1PLUG["ExaltedPlus"] = function()
local rpt,f=ReputationParagonTooltip,CreateFrame('frame', "ExaltedPlusFrame") f.a=0
f:RegisterEvent('QUEST_LOG_UPDATE') f:RegisterEvent('UPDATE_FACTION')
f:SetScript('OnEvent',function()
	for k in ReputationFrame.paragonFramesPool:EnumerateActive() do if k.factionID then
		local id,n=k.factionID,GetFactionInfoByID(k.factionID) f[n]=k
		if not f[id] or f[id].n~=n then f[id]={n=n,v=C_Reputation.GetFactionParagonInfo(id)} end
	end end
end)
f:SetScript('OnUpdate',function(s,e)
	if s.b then s.a=s.a-e else s.a=s.a+e end
	if s.a>=1 then s.a=1 s.b=true elseif s.a<=0 then s.a=0 s.b=false end
	if ReputationFrame:IsVisible() then for i=1,NUM_FACTIONS_DISPLAYED do
		if s[i] then _G['ReputationBar'..i..'ReputationBar']:SetStatusBarColor(0,1,0,s.a) end
	end end
	--if s.w then ReputationWatchBar.StatusBar:SetStatusBarColor(0,1,0,s.a) end
end)
function EP_FindFaction(faction)
    local isGuild = false
    if faction==GUILD then isGuild = true faction = GetGuildInfo("player") end
    for i=1, GetNumFactions() do
        local name, description, standingID, barMin, barMax, barValue,_,_,_,_,_,_,_,factionID = GetFactionInfo(i)
        if name == faction then
            local oldName,_,_,_,_ = GetWatchedFactionInfo();
            if UnitLevel("player") == MAX_PLAYER_LEVEL and not isGuild and oldName ~= name and U1GetCfgValue(addonName, 'ExaltedPlus/autotrace') then SetWatchedFactionIndex(i) end
            return standingID, barValue - barMin, factionID
        end
    end
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE',function(_,_,msg,...)
	local n,id,v=strmatch(msg,gsub(FACTION_STANDING_INCREASED_GENERIC,"%%%d?$?s","(.+)")) --"在%s中的声望提升了。" --7.2.5的巅峰不是这种情况了
    local template = "%s的声望提高了%d点（%s%d）"
	if f[n] then
        EP_FindFaction(n)
		id,v=f[n].factionID,C_Reputation.GetFactionParagonInfo(f[n].factionID)
		if f[id] then
            if v-f[id].v~=0 then f[id].d=v-f[id].v f[id].v=v end
		    msg=format(template, n, f[id].d, "巅峰", v) --暗夜精灵声望提高了75点（崇敬158）--msg=format(FACTION_STANDING_INCREASED,n.."+",f[id].d) end
        end
    else
        --"你在(.+)中的声望值提高了(.+)点。" msg = "你在抗魔联军中的声望值提高了75点。"
        local n, v = strmatch(msg, (gsub(FACTION_STANDING_INCREASED,"%%[ds]","(.+)")))
        if n then
            local standingID, curr, factionID = EP_FindFaction(n)
            if standingID then
                if C_Reputation.IsFactionParagon(factionID) then
                    local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID);
                    msg=format(template, n, v, "巅峰", currentValue)
                else
                    msg = format(template, n, v, _G['FACTION_STANDING_LABEL' .. standingID], curr)
                end
            end
        end
    end

	return false,msg,...
end)
--[[ 163ui 7.2.5 wrong position hooksecurefunc('EmbeddedItemTooltip_SetItemByQuestReward',function(t)
	if t==rpt.ItemTooltip and rpt.factionID and f[rpt.factionID] and f[rpt.factionID].c then
		local c=format(ARCHAEOLOGY_COMPLETION,f[rpt.factionID].c)
		rpt:AddLine(c) t.Tooltip:AddLine('\n') t.Tooltip:Show()
		for i=1,rpt:NumLines() do if _G[rpt:GetName()..'TextLeft'..i]:GetText()==c then
			_G[rpt:GetName()..'TextLeft'..i]:SetPoint('BOTTOMLEFT',0,-70)
		end end
	end
end)--]]
hooksecurefunc('GameTooltip_AddQuestRewardsToTooltip',function(tip)
    if tip == rpt then
        local text = _G["ReputationParagonTooltipTextLeft" .. tip:NumLines()]
        if text:GetText() == TOOLTIP_QUEST_REWARDS_STYLE_DEFAULT.headerText and f and f[rpt.factionID] then
            local c = format(ARCHAEOLOGY_COMPLETION,f[rpt.factionID].c)
            text:SetText(text:GetText() .. "  ( " .. c .. " )")
        end
    end
end)

--[[--StatusTrackingBarManager.UpdateBarsShown
hooksecurefunc('MainMenuBar_UpdateExperienceBars',function()
	local n,r,_,m,v,id,c=GetWatchedFactionInfo()
	if n and id and ReputationWatchBar:IsShown() then
		if (GetFriendshipReputation(id)) then r=5 end c=FACTION_BAR_COLORS[r]
		v,m,_,f.w=C_Reputation.GetFactionParagonInfo(id)
		if v and m then ReputationWatchBar.StatusBar:SetAnimatedValues(f.w and mod(v,m)+m or mod(v,m),0,m,r)
		ReputationWatchBar.OverlayFrame.Text:SetText(n.." "..(f.w and mod(v,m)+m or mod(v,m)).." / "..m) end
		if not f.w then ReputationWatchBar.StatusBar:SetStatusBarColor(c.r,c.g,c.b,1) end
	end
end)
--]]
hooksecurefunc('ReputationFrame_Update',function()
	for i=1,NUM_FACTIONS_DISPLAYED do
		local n,x,r,_,m,v,row,bar,_,_,_,_,_,id=GetFactionInfo(ReputationListScrollFrame.offset+i)
		if id and f[n] and f[id] then
			v,m,_,f[i]=C_Reputation.GetFactionParagonInfo(id)
			f[id].c=f[i] and math.modf(v/m)-1 or math.modf(v/m) v=f[i] and mod(v,m)+m or mod(v,m)
			x=f[i] and CONTRIBUTION_REWARD_TOOLTIP_TITLE or GetText("FACTION_STANDING_LABEL"..r,(UnitSex('player'))).."+"
			f[n].Check:SetShown(false)f[n].Glow:SetShown(false)f[n].Highlight:SetShown(false)f[n].Icon:SetAlpha(f[i] and 1 or .6)
			row=_G['ReputationBar'..i] row.rolloverText=' '..format(REPUTATION_PROGRESS_FORMAT,v,m) row.standingText=x
			bar=_G['ReputationBar'..i..'ReputationBar'] bar:SetMinMaxValues(0,m) bar:SetValue(v)
			_G['ReputationBar'..i..'ReputationBarFactionStanding']:SetText(x)
		else f[i]=nil end
	end
end)
end