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
        if now >= "20190205" and now <= "20190210" then
            local greetings = {
                {"初一","诸事顺利"}, {"初二", "新春快乐"}, {"初三","多出泰坦"}, {"初四", "早出坐骑"}, {"初五", "年年有余"}, {"初六", "引领潮流"}
            }
            if U1DBG.GreetingCNY ~= now then
                U1DBG.GreetingCNY = now
                local day = tonumber(now) - 20190204
                if greetings[day] then
                    C_Timer.After(1, function()
                        U1Message("大年"..greetings[day][1].."，爱不易祝您猪年大吉，"..greetings[day][2].."！", 1, 1, 0)
                    end)
                end
            end
        end
    end
})