local Evie, easy, next, securecall, pcall, _, T = {}, newproxy(true), next, securecall, pcall, ...
local frame, listeners, locked, easy_mt = CreateFrame("Frame"), {}, {}, getmetatable(easy)

local function Register(event, func, depth)
	if type(event) ~= "string" or type(func) ~= "function" then
		error('Syntax: RegisterEvent("event", handlerFunction)', type(depth) == "number" and depth or 2)
	end
	local lock = locked[event]
	if lock == true then
		locked[event] = {[func] = 1}
	elseif lock then
		lock[func] = 1
	else
		pcall(frame.RegisterEvent, frame, event)
		listeners[event] = listeners[event] or {}
		listeners[event][func] = 1
	end
end
local function Unregister(event, func)
	local list, lock = listeners[event], locked[event]
	if list and list[func] then
		list[func] = nil
		if not next(list) then
			listeners[event] = nil
			pcall(frame.UnregisterEvent, frame, event)
		end
	end
	if lock and lock ~= true then
		lock[func] = nil
	end
end
local function Raise(_, event, ...)
	if listeners[event] then
		local lock = locked[event]
		locked[event] = lock or true
		for kf in next, listeners[event] do
			if securecall(kf, event, ...) == "remove" then
				Unregister(event, kf)
			end
		end
		if not lock then
			lock, locked[event] = locked[event]
			if lock ~= true then
				for kf in next, lock do
					Register(event, kf)
				end
			end
		end
	end
end
function Evie.RaiseEvent(event, ...)
	return Raise(nil, event, ...)
end
function easy_mt:__newindex(e, f)
	Register(e, f, 3)
end

frame:SetScript("OnEvent", Raise)
easy_mt.__call, easy_mt.__index, Evie.raw = Raise, Evie, Evie
T.Evie, Evie.RegisterEvent, Evie.UnregisterEvent = easy, Register, Unregister