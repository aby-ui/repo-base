function RecentTradeFrame_GetTimeLong(y1,m1,d1,h1,mi1,y2,m2,d2,h2,mi2)
	--1 trade time 2 now
	y1 = tonumber(y1) m1 = tonumber(m1) d1 = tonumber(d1) h1 = tonumber(h1) mi1 = tonumber(mi1)
	y2 = tonumber(y2) m2 = tonumber(m2) d2 = tonumber(d2) h2 = tonumber(h2) mi2 = tonumber(mi2)
	local DoM = {31,28,31,30,31,30,31,31,30,31,30,31}
	local days = 0
	while y1<y2 or (y1==y2 and m1<m2) or (y1==y2 and m1==m2 and d1<d2) do
		if y1%400==0 or (y1%100~=0 and y1%4==0) then DoM[2] = 29 else DoM[2] = 28 end
		d1=d1+1
		if d1>DoM[m1] then
			d1=1
			m1=m1+1
			if m1>12 then
				y1=y1+1
				m1=1
			end
		end		
		days = days + 1
	end
	if days==0 and not (y1==y2 and m1==m2 and d1==d2) then return nil end
	local minutes = (h2*60+mi2) - (h1*60+mi1)
	if(minutes < 0) then
		days = days - 1;
		minutes = minutes + 24*60
	end

	if(days < 0) then return nil end
	if(days > 7) then return nil end
	if(days > 0) then return string.format(RECENT_TRADE_TIME, days, DAYS) end
	if(minutes/60 >= 1) then return string.format(RECENT_TRADE_TIME, math.floor(minutes/60), HOURS) end
	return string.format(RECENT_TRADE_TIME, (minutes%60), MINUTES)
end

function RecentTradeFrame_UpdateList(name)
	RecentTradeFrameTitle:SetText(RECENT_TRADE_TITLE)
	local i = 0
	local now = date("%Y-%m-%d %H:%M:%S");
	local _, _, y2, m2, d2, h2, mi2 = string.find(now, "(%d+)-(%d+)-(%d+) (%d+):(%d+)")

	if TradeLog_TradesHistory then
		for j = #TradeLog_TradesHistory, 1, -1 do
			local trade = TradeLog_TradesHistory[j]
			if trade.who == name and trade.result == "complete" then
				local _,_,year,month,day,hour,min = string.find(trade.when, "(%d+)-(%d+)-(%d+) (%d+):(%d+)")
				if(not year) then
					_,_,month,day,hour,min = string.find(trade.when, "(%d+)-(%d+) (%d+):(%d+)")
					year = y2
				end
				local timeLong = RecentTradeFrame_GetTimeLong(year, month, day, hour, min, y2,m2,d2,h2,mi2)
				if(timeLong) then
					local text = timeLong.." "..trade.where
					i = i+1;

					local playerList = TradeLog_GetTradeList( trade.playerMoney, trade.playerItems, trade.targetItems[7], TradeLog_GetMoneyPlainText, true)
					local targetList = TradeLog_GetTradeList( trade.targetMoney, trade.targetItems, trade.playerItems[7], TradeLog_GetMoneyPlainText, true)

					if(#playerList==0 and #targetList==0) then
						text = text.."\n|cffffffff"..NONE.."|r"
					else
						if(#playerList>0) then
							text = text.."\n|cffff7f7f"..TRADE_LOG_HANDOUT.." "..table.concat(playerList, " ").."|r";
						end
						if(#targetList>0) then
							text = text.."\n|cff7fff7f"..TRADE_LOG_RECEIVE.." "..table.concat(targetList, " ").."|r";
						end
					end

					getglobal("RecentTradeFrameButton"..i.."Text"):SetText(text)
					getglobal("RecentTradeFrameButton"..i).offset = j
					getglobal("RecentTradeFrameButton"..i):Show()
					if i>=8 then break end
				end
			end
		end
	end

	if(i==0) then 
		RecentTradeFrame:Hide()
	else
		RecentTradeFrame:Show()
	end

	if ProfessionTabs then
		RecentTradeFrame:SetPoint("TOPLEFT", TradeFrame, "TOPRIGHT", 32, 3)
	end

	while i < 8 do
		i = i + 1;
		getglobal("RecentTradeFrameButton"..i.."Text"):SetText("")
		getglobal("RecentTradeFrameButton"..i).offset = nil
		getglobal("RecentTradeFrameButton"..i):Hide()
	end

end
