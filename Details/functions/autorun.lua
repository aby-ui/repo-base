local Details = _G.Details
local DF = _G.DetailsFramework
local C_Timer = _G.C_Timer

--auto run scripts
Details.AutoRunCode = {}
local codeTable

--compile and store code
function Details:RecompileAutoRunCode()
    for codeKey, code in pairs(codeTable) do
        local func, errorText = _G.loadstring(code)
        if (func) then
            DetailsFramework:SetEnvironment(func)
            Details.AutoRunCode[codeKey] = func
        else
            --if the code didn't pass, create a dummy function for it without triggering errors
            Details.AutoRunCode[codeKey] = function() end
        end
    end
end

--function to dispatch events
function Details:DispatchAutoRunCode(codeKey)
    local func = Details.AutoRunCode[codeKey]
    DF:QuickDispatch(func)
end

--auto run frame to dispatch scrtips for some events that details! doesn't handle
local autoRunCodeEventFrame = _G.CreateFrame("frame")

if (not _G.DetailsFramework.IsClassicWow()) then
    autoRunCodeEventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end

autoRunCodeEventFrame.OnEventFunc = function(self, event)
    --> ignore events triggered more than once in a small time window
    if (autoRunCodeEventFrame [event] and not autoRunCodeEventFrame [event]._cancelled) then
        return
    end

    if (event == "PLAYER_SPECIALIZATION_CHANGED") then
        --> create a trigger for the event, many times it is triggered more than once
        --> so if the event is triggered a second time, it will be ignored
        local newTimer = C_Timer.NewTimer(1, function()
            Details:DispatchAutoRunCode("on_specchanged")
            
            --> clear and invalidate the timer
            autoRunCodeEventFrame[event]:Cancel()
            autoRunCodeEventFrame[event] = nil
        end)
        
        --> store the trigger
        autoRunCodeEventFrame[event] = newTimer
    end
end

autoRunCodeEventFrame:SetScript("OnEvent", autoRunCodeEventFrame.OnEventFunc)

--dispatch scripts at startup
C_Timer.After(2, function()
    Details:DispatchAutoRunCode("on_init")
    Details:DispatchAutoRunCode("on_specchanged")
    Details:DispatchAutoRunCode("on_zonechanged")

    if (_G.InCombatLockdown()) then
        Details:DispatchAutoRunCode("on_entercombat")
    else
        Details:DispatchAutoRunCode("on_leavecombat")
    end

    Details:DispatchAutoRunCode("on_groupchange")
end)

function Details:StartAutoRun()
    --compile code
    codeTable = Details.run_code
    Details:RecompileAutoRunCode()
end
