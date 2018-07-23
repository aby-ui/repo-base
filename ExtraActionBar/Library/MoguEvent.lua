local __MAJOR_VERSION_NUMBER = 1;
local __MINOR_VERSION_NUMBER = 0;
local BEvent = {registry={},frame = nil};
BEvent.frame = CreateFrame("Frame", "MOGUEventFrame", UIparent);

BEvent.frame:SetScript("OnEvent", function(self, __event, ...)	
	BEvent:__EventHandler(__event, ...);
end)
-- 额外额外
local __stack = setmetatable({}, {__mode = "__k"});
function BEvent:__EventHandler(__event, ...)
	assert(__event and type(__event)=="string","Invalid __event. The type of __event must be string.");

	local __tmp = next(__stack) or {};	
	__stack[__tmp] = nil;
	
	if (__event and BEvent.registry[__event]) then
		for __obj, __method in pairs(BEvent.registry[__event]) do
			if (__event == "COMBAT_LOG_EVENT_UNFILTERED" or __event == "COMBAT_LOG_EVENT") then
				__tmp[__obj] = BEvent.registry[__event][__obj][select(2, CombatLogGetCurrentEventInfo())];
			else
				__tmp[__obj] = __method;
			end
		end
	end

	for __o, __m in pairs(__tmp) do
		if (type(__m) == "string") then
			if (__o[__m] and type(__o[__m]) == "function") then
                if __event == "COMBAT_LOG_EVENT_UNFILTERED" then
                    __o[__m](__o, CombatLogGetCurrentEventInfo());
                else
                    __o[__m](__o, ...);
                end
			end
		elseif (__m and type(__m) == "function") then
            if __event == "COMBAT_LOG_EVENT_UNFILTERED" then
                __m(__event, CombatLogGetCurrentEventInfo());
            else
    			__m(__event, ...);
            end
		end
		__tmp[__o] = nil;
	end
end

function BEvent:RegisterEvent(__event, __method)
	assert(__event and type(__event) == "string", "BEvent: Invalid event. The type of event must be string.");
	-- 额外额外COMBAT_LOG_EVENT_UNFILTERED
	if (__event == "COMBAT_LOG_EVENT_UNFILTERED" or __event == "COMBAT_LOG_EVENT") then
		assert(__method and type(__method) == "string", string.gsub("BEvent: '$EVENT' - Invalid combat log event.", "$EVENT", tostring(__method)));
		if (not BEvent.registry[__event]) then
			BEvent.registry[__event] = {};
			BEvent.frame:RegisterEvent(__event);
		end
		BEvent.registry[__event][self] = BEvent.registry[__event][self] or {};		
		BEvent.registry[__event][self][__method] = __method;
	else
		__method = __method or __event;
		if (not BEvent.registry[__event]) then
			BEvent.registry[__event] = {};
			BEvent.frame:RegisterEvent(__event);
		end	
		BEvent.registry[__event][self] = __method;
	end
end

function BEvent:UnregisterEvent(__event, __method)
	assert(type(__event)=="string","Invalid event. The type of event must be string.");
	
	if (BEvent.registry[__event] and BEvent.registry[__event][self]) then
		if (__event == "COMBAT_LOG_EVENT_UNFILTERED" or __event == "COMBAT_LOG_EVENT") then
			if ( __method and BEvent.registry[__event][self][__method]) then
				BEvent.registry[__event][self][__method] = nil;
			else
				BEvent.registry[__event][self] = nil;
			end
		else
			BEvent.registry[__event][self] = nil;
		end

		if (not next(BEvent.registry[__event])) then
			BEvent.registry[__event] = nil
			BEvent.frame:UnregisterEvent(__event)
		end
	end
end

function BEvent:UnregisterAllEvent()
	for __event, __data in pairs(BEvent.registry) do
		if (__data[self]) then
			self:UnregisterEvent(__event);
		end
	end
end

BEvent.Initialization = {};
function BEvent:Init(...)	
	local __tab = select(1, ...);
	__tab = type(__tab) == "table" and __tab or {};
	__tab.name = __tab.name or __tab[1] or "Unknown";
	__tab.func = __tab.func or __tab[2] or function() end;
	BEvent:RegisterEvent("ADDON_LOADED");
	table.insert(BEvent.Initialization, __tab);	
end

function BEvent.ADDON_LOADED()
	local __k, __v;
	for __k, __v in pairs(BEvent.Initialization) do
		if (arg1 == __v.name) then
			assert(__v.func, string.format("<%s> need a init function", __v.name));

			__v:func();
			table.remove(BEvent.Initialization, __k);			
			break;
		end
	end
end

function BEvent:constructor()	
end

BLibrary:Register(BEvent,"BEvent",__MAJOR_VERSION_NUMBER,__MINOR_VERSION_NUMBER);