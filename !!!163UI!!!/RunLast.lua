local _, U1 = ...

--[=[
local fm = CreateFrame("Frame")
for k, _ in pairs(U1.captureEvents) do fm:RegisterEvent(k) end
fm:SetScript("OnEvent", function(self, event, ...) print(event, ...) end)
--]=]

--[[
--/run C_LFGList.Search(3, {{matches={"王座"}}}, 1, 4, {})

_G.HLFG = function(catId, terms, filter, prefer, language) 
    print("Search =========== catId", catId)
    print("terms:", (Stringfy(terms, "", -1, true, true):gsub("\n", "")))
    print("filter:", (Stringfy(filter, "", -1, true, true):gsub("\n", "")), "prefered:", (Stringfy(prefer, "", -1, true, true):gsub("\n", "")))
    if language then print("language:", (Stringfy(language, "", -1, true, true):gsub("\n", ""))) end
end

hooksecurefunc(C_LFGList, "Search", _G.HLFG);
--]]

CoreRegisterEvent("INIT_COMPLETED", {
    INIT_COMPLETED = function()
        if not U1DBG then return end
        local now = date("%Y%m%d")
        if now >= "20210211" and now <= "20210217" then
            local greetings = {
                {"大年三十啦，愿大家身体健康，万事如意"}, {"初一", "首胜顺利"}, {"初二", "大帝一把过"}, {"初三", "骑上粉火箭"}, {"初四", "进组顺利"}, {"初五", "开出幽灵虎"}, {"初六", "低保到手"}
            }
            if U1DBG.GreetingCNY ~= now then
                U1DBG.GreetingCNY = now
                local day = tonumber(now) - 20210211 + 1
                if greetings[day] then
                    C_Timer.After(3, function()
                        U1Message(#greetings[day] == 1 and greetings[day][1] or "大年"..greetings[day][1].."，爱不易祝您牛年大吉，"..greetings[day][2].."！", 1, 1, 0)
                    end)
                end
            end
        end
    end
})

--[[------------------------------------------------------------
掉线后上线可能看不到释放框，好像是8.0奥迪尔
---------------------------------------------------------------]]
CoreRegisterEvent("INIT_COMPLETED", { INIT_COMPLETED = function()
    if ( UnitIsDead("player") and not StaticPopup_Visible("DEATH") ) then
        if ( GetReleaseTimeRemaining() == 0 ) then
            StaticPopup_Show("DEATH");
            local name = StaticPopup_Visible("DEATH")
            if name then _G[name].text:SetText(DEATH_RELEASE_NOTIMER) end
        end
    end
end})