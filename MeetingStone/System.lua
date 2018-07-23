
BuildEnv(...)

System = Addon:NewModule('System', 'LibInvoke-1.0')

function System:OnInitialize()
end

function System:Errorf(formatter, ...)
    self:Error(formatter:format(...))
end

function System.Invoke:Error(msg)
    GUI:CallWarningDialog(msg, 1)
end

function System.Invoke:Message(msg)
    GUI:CallWarningDialog(msg)
end

function System:Messagef(formatter, ...)
    self:Message(formatter:format(...))
end

local frames = CHAT_FRAMES
function System:Log(msg)
    for i, v in ipairs(frames) do
        local frame = _G[v]
        if frame:IsEventRegistered('CHAT_MSG_SYSTEM') then
            local onEvent = frame:GetScript('OnEvent')
            if onEvent then
                onEvent(frame, 'CHAT_MSG_SYSTEM', L['|cff00ffff集合石：|r'] .. msg, '', '', '')
            end
        end
    end
    -- Log:InsertLog(msg)
end

function System:Logf(formatString, ...)
    local args = {...}
    for i, v in ipairs(args) do
        args[i] = '|cfffed000' .. v .. '|r'
    end
    self:Log(formatString:format(unpack(args)))
end
