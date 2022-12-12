--[[
## Interface: 100000
## Title: ExaltedPlus
## Notes: Enhancements for paragon reputations
## Author: Kanegasi
## Version: 10.0.0-2
## SavedVariables: ExaltedPlusFactions
## X-Curse-Project-ID: 264245
## X-WoWI-ID: 24383
## X-Wago-ID: kaNe3XK2
--]]
local addonName = ...
U1PLUG["ExaltedPlus"] = function()

    local factions,buln,frame={},function(v) return v end,CreateFrame("frame") --buln = BreakUpLargeNumbers
    ExaltedPlusFactions={}
    function frame.enumfactions()
        if not frame.loaded then
            frame.loaded=true
            for id in pairs(ExaltedPlusFactions) do
                factions[id]={}
            end
        end
        local value, _
        for id,faction in pairs(factions) do
            value,faction.max,_,faction.reward=C_Reputation.GetFactionParagonInfo(id)
            if value then
                faction.timesdone=faction.reward and math.modf(value/faction.max)-1 or math.modf(value/faction.max)
                faction.value=mod(value,faction.max)
            end
        end
    end
    function frame.update()
        for _,row in ReputationFrame.ScrollBox:EnumerateFrames() do
            if row.factionID then
                if C_Reputation.IsFactionParagon(row.factionID) then
                    if not factions[row.factionID] then
                        factions[row.factionID]={}
                    end
                    factions[row.factionID].row=row
                else
                    ExaltedPlusFactions[row.factionID]=nil
                end
            end
        end
        frame.enumfactions()
        frame.repframevis=ReputationFrame:IsVisible()
        for _,bar in pairs(StatusTrackingBarManager.bars) do
            if bar.factionID then
                frame.watchbar=bar
            end
        end
    end
    frame:SetScript("OnUpdate",function(self,elapsed)
        if not self.alpha then
            self.alpha=0.3
        end
        if self.reverse then
            self.alpha=self.alpha-elapsed
        else
            self.alpha=self.alpha+elapsed
        end
        if self.alpha>=1 then
            self.alpha=1
            self.reverse=true
        elseif self.alpha<=0.3 then
            self.alpha=0.3
            self.reverse=false
        end
        if self.repframevis then
            for _,faction in pairs(factions) do
                if faction.reward and faction.row then
                    local red,green,blue=faction.row.Container.ReputationBar:GetStatusBarColor()
                    faction.row.Container.ReputationBar:SetStatusBarColor(red,green,blue,self.alpha)
                end
            end
        end
        if self.pulsewatchbar then
            local red,green,blue=frame.watchbar.StatusBar:GetStatusBarColor()
            frame.watchbar.StatusBar:SetStatusBarColor(red,green,blue,self.alpha)
        end
    end)
    local function gttfind(q,...)
        for i=1,select("#",...) do
            local r=select(i,...)
            if r and r.GetText and r:GetText()==q then
                return r
            end
        end
        return {SetText=function(_,t) GameTooltip:AddLine(t) GameTooltip:Show() end}
    end
    hooksecurefunc("EmbeddedItemTooltip_SetItemByQuestReward",function()
        frame.update()
        local mf=GetMouseFocus()
        if mf and mf.factionID and factions[mf.factionID] and factions[mf.factionID].timesdone then
            local text=format(ARCHAEOLOGY_COMPLETION,factions[mf.factionID].timesdone)
            gttfind(REWARDS,GameTooltip:GetRegions()):SetText(text)
        end
    end)
    --[[
    hooksecurefunc(StatusTrackingBarManager,"UpdateBarsShown",function(_,n,r,id)
        frame.update()
        if frame.watchbar and frame.watchbar:IsShown() then
            local factionName,reaction,_,_,_,factionID=GetWatchedFactionInfo()
            if factions[factionID] and factions[factionID].reward then
                frame.pulsewatchbar=true
                local bartext=factionName.." "..factions[factionID].value.." / "..factions[factionID].max
                frame.watchbar.name=bartext
                frame.watchbar:SetBarText(bartext)
                frame.watchbar:SetBarValues(factions[factionID].value,0,factions[factionID].max,reaction)
            else
                frame.pulsewatchbar=nil
                local red,green,blue=frame.watchbar.StatusBar:GetStatusBarColor()
                frame.watchbar.StatusBar:SetStatusBarColor(red,green,blue,1)
            end
        end
    end)
    --]]
    hooksecurefunc("ReputationFrame_InitReputationRow",function(row)
        frame.update()
        local fact = row.factionID and factions[row.factionID]
        if fact and fact.value and fact.max then
            local factionLevel, _
            ExaltedPlusFactions[row.factionID], _, factionLevel=GetFactionInfo(row.index)
            row.rolloverText=" "..format(REPUTATION_PROGRESS_FORMAT,buln(fact.value),buln(fact.max))
            row.Container.ReputationBar:SetMinMaxValues(0,fact.max)
            row.Container.ReputationBar:SetValue(fact.value)
            --row.Container.Paragon.Check:SetShown(false)
            --row.Container.Paragon.Glow:SetShown(false)
            --row.Container.Paragon.Highlight:SetShown(false)
            row.Container.Paragon.Icon:SetAlpha(fact.reward and 1 or 0.5) --巅峰没奖励的半透明
            --条上数字，待领取的："奖励7 +当前值"  未满的："巅峰*9"
            local times = fact.timesdone or 0
            if fact.reward then
                row.standingText = CONTRIBUTION_REWARD_TOOLTIP_TITLE..""..(times+1).." +"..fact.value
            else
                row.standingText = GetText("FACTION_STANDING_LABEL"..factionLevel,(UnitSex('player'))) .. (times > 0 and "*"..times or "+")
            end
            row.Container.ReputationBar.FactionStanding:SetText(row.standingText)
        end
    end)

    --ExaltedPlusLastFactions
    ExaltedPlusLastFactions = {}
    function EP_RefreshAllFactions()
        for i=1, GetNumFactions() do
            local name, description, standingID, barMin, barMax, barValue,_,_,_,_,_,_,_,factionID = GetFactionInfo(i)
            ExaltedPlusLastFactions[name] = { value = barValue, id = factionID }
        end
    end

    function EP_FindFaction(faction)
        local isGuild = false
        if faction==GUILD then isGuild = true faction = GetGuildInfo("player") end
        if not ExaltedPlusLastFactions[faction] then
            EP_RefreshAllFactions()
        end
        local info = ExaltedPlusLastFactions[faction]
        if not info then return end --没有找到
        local _, _, standingID, barMin, barMax, barValue = GetFactionInfoByID(info.id)
        local reputationInfo = info.id and C_GossipInfo.GetFriendshipReputation(info.id);
        if reputationInfo and reputationInfo.friendshipFactionID > 0 then
            barValue = reputationInfo.standing
        end
        --设置经验条
        local oldName,_,_,_,_ = GetWatchedFactionInfo();
        if UnitLevel("player") == MAX_PLAYER_LEVEL and not isGuild and oldName ~= faction and U1GetCfgValue(addonName, 'ExaltedPlus/autotrace') then
            for i=1, GetNumFactions() do
                if GetFactionInfo(i) == faction then SetWatchedFactionIndex(i) end --也许顺序会变
            end
        end

        local diff = barValue - info.value
        info.value = barValue
        return info, diff
    end

    ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE',function(_,_,msg,...)
        local kind, name, added = 1, strmatch(msg,gsub(FACTION_STANDING_INCREASED_GENERIC,"%%%d?$?s","(.+)")) --"在%s中的声望提升了。" --7.2.5的巅峰不是这种情况了
        if not name then
            kind, name, added = 2, strmatch(msg, (gsub(FACTION_STANDING_INCREASED,"%%[ds]","(.+)"))) --"你在(.+)中的声望值提高了(.+)点。" msg = "你在抗魔联军中的声望值提高了75点。"
        end
        if not name then
            kind, name, added = 3, strmatch(msg, "(.*)现在觉得你更有价值了") --"威·娜莉现在觉得你更有价值了。 [获得了80点声望]"
        end
        if not name then
            kind, name, added = 4, strmatch(msg, "(.*)的奥术能量提升了。") --"钴蓝集所"
        end
        if not name then return end

        local info, diff = EP_FindFaction(name)
        if not info then return end

        --if DEBUG_MODE then print(msg, info.id, added, diff) end
        local reputationInfo = info.id and C_GossipInfo.GetFriendshipReputation(info.id);
        if reputationInfo and reputationInfo.friendshipFactionID > 0 then
            local output = "%s%s的声望提高了%s（%s%d/%d）"
            local curr = reputationInfo.standing - (reputationInfo.reactionThreshold or 0)
            local cap = reputationInfo.nextThreshold - (reputationInfo.reactionThreshold or 0)
            local change = tonumber(added) or diff or 0
            change = change > 0 and change .. "点" or ""
            local rankText = ""
            local rankInfo = C_GossipInfo.GetFriendshipReputationRanks(info.id)
            if rankInfo and rankInfo.maxLevel > 0 then
                rankText = "("..rankInfo.currentLevel.."/"..rankInfo.maxLevel..")"
            end
            msg=format(output, name, rankText, change, reputationInfo.reaction, curr, cap) --钴蓝集所(3/5)的声望提高了19点(低684/900)
        elseif info.id and C_Reputation.IsMajorFaction(info.id) then
            local output = "%s的声望提高了%d点（%s/%d）"
            local majorFactionData = C_MajorFactions.GetMajorFactionData(info.id); --2507
            local levelLabel = RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel;
            msg=format(output, name, added or diff, levelLabel, majorFactionData.renownReputationEarned or 0) --暗夜精灵声望提高了75点（名望1/2570)
        else
            local output = "%s的声望提高了%d点（%s%d）"
            local _, _, level, levelMin, _, levelCurr = GetFactionInfoByID(info.id)
            local levelLabel = GetText("FACTION_STANDING_LABEL"..level,(UnitSex('player')))
            local paragonCurr, cap, unknown, reward = C_Reputation.GetFactionParagonInfo(info.id)
            if paragonCurr then
                local times = math.modf(paragonCurr/cap)
                local remain = mod(paragonCurr, cap)
                msg=format(output, name, added or diff, levelLabel .. (times > 0 and "*" .. times or "").." +", remain) --开悟者的声望提高了75点(崇拜*10 +1000)
            else
                msg=format(output, name, added or diff, levelLabel, levelCurr - levelMin) --暗夜精灵声望提高了75点（崇敬158)
            end
        end



        return false,msg,...
    end)

end