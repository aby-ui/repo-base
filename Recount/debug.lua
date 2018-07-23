local Recount = _G.Recount

local revision = tonumber(string.sub("$Revision: 1286 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local _G = _G

local GetChatWindowInfo = GetChatWindowInfo
local GetTime = GetTime

local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

Recount.Debug = false

function Recount:GetDebugFrame()
	for i = 1, NUM_CHAT_WINDOWS do
		local windowName = GetChatWindowInfo(i)
		if windowName == "Debug" then
			return _G["ChatFrame"..i]
		end
	end
end

function Recount:DPrint(str)
	if not Recount.Debug then
		return
	end
	local debugframe = Recount:GetDebugFrame()

	if debugframe then
		debugframe:AddMessage(str)
		--Recount:Print(debugframe, str)
	end
end
