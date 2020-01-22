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
        if now >= "20200124" and now <= "20200130" then
            local greetings = {
                {"大年三十啦，愿大家免疫病痛，平安快乐"}, {"初一","数你给力"}, {"初二", "新春快乐"}, {"初三","手红不用肝"}, {"初四", "突袭顺利"}, {"初五", "低保到手"}, {"初六", "引领潮流"}
            }
            if U1DBG.GreetingCNY ~= now then
                U1DBG.GreetingCNY = now
                local day = tonumber(now) - 20200124 + 1
                if greetings[day] then
                    C_Timer.After(1, function()
                        U1Message(#greetings[day] == 1 and greetings[day][1] or "大年"..greetings[day][1].."，爱不易祝您鼠年大吉，"..greetings[day][2].."！", 1, 1, 0)
                    end)
                end
            end
        end
    end
})