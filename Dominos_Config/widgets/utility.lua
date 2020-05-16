local AddonName, Addon = ...
local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")

function Addon:CreateClass(...)
	return Dominos:CreateClass(...)
end

-- returns a function that generates unique names for frames
-- in the format <AddonName>_<Prefix>[1, 2, ...]
function Addon:CreateNameGenerator(prefix)
    local id = 0
	return function()
        id = id + 1
        return strjoin("_", AddonName, prefix, id)
	end
end

-- a rough equivalent of js request animation frame
do
    local After = C_Timer.After
	local subscribers = {}
    local rendering = false    

    local function render()
		while next(subscribers) do
			tremove(subscribers):OnRender()
        end
        
        rendering = false
    end

    function Addon:Render(frame)
		for _, f in pairs(subscribers) do
			if f == frame then
				return false
			end
        end
        
		tinsert(subscribers, 1, frame)
        
        if not rendering then
            rendering = true            
            After(GetTickTime(), render)
        end

        return true
	end
end

-- prevent a function from being called until <delay> ms after the last call
do
    local unpack = unpack
    local twipe = table.wipe
    local GetTime = _G.GetTime
    local now = function() return GetTime() * 1000 end
    local after = _G.C_Timer.After

    function Addon:Debounce(func, delay)
        local args = {}
        local lastCall = 0

        local function callback()
            if (now() - lastCall) >= delay then
                if #args > 0 then
                    func(unpack(args))
                else
                    func()
                end
            end
        end

        return function(...)
            twipe(args)
            for i = 1, select('#', ...) do
                args[i] = (select(i, ...))
            end

            lastCall = now()
            after(delay / 1000, callback)
        end
    end
end

Dominos.Options = Addon