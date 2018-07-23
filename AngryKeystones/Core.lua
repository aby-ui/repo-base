-- Core v1.3
local ADDON, Addon = ...

local Listener = CreateFrame('Frame', ADDON .. 'Listener')
local EventListeners = {}
local function Addon_OnEvent(frame, event, ...)
	if EventListeners[event] then
		for callback, func in pairs(EventListeners[event]) do
			if func == 0 then
				callback[event](callback, ...)
			else
				callback[func](callback, event, ...)
			end
		end
	end
end
Listener:SetScript('OnEvent', Addon_OnEvent)
function Addon:RegisterEvent(event, callback, func)
	if func == nil then func = 0 end
	if EventListeners[event] == nil then
		Listener:RegisterEvent(event)
		EventListeners[event] = { [callback]=func }
	else
		EventListeners[event][callback] = func
	end
end

function Addon:UnregisterEvent(event, callback)
	local listeners = EventListeners[event]
	if listeners then
		local count = 0
		for index,_ in pairs(listeners) do
			if index == callback then
				listeners[index] = nil
			else
				count = count + 1
			end
		end
		if count == 0 then
			EventListeners[event] = nil
			Listener:UnregisterEvent(event)
		end
	end
end

local AddOnListeners = {}
function Addon:ADDON_LOADED(name)
	if AddOnListeners[name] then
		for callback, func in pairs(AddOnListeners[name]) do
			if func == 0 then
				callback[name](callback)
			else
				callback[func](callback, name)
			end
		end
	end
end

function Addon:RegisterAddOnLoaded(name, callback, func)
	if func == nil then func = 0 end
	if IsAddOnLoaded(name) then
		if func == 0 then
			callback[name](callback)
		else
			callback[func](callback, name)
		end
	else
		self:RegisterEvent('ADDON_LOADED', self)
		if AddOnListeners[name] == nil then
			AddOnListeners[name] = { [callback]=func }
		else
			AddOnListeners[name][callback] = func
		end
	end
end

function Addon:UnregisterAddOnLoaded(name, callback)
	local listeners = AddOnListeners[name]
	if listeners then
		local count = 0
		for index,_ in pairs(listeners) do
			if index == callback then
				listeners[index] = nil
			else
				count = count + 1
			end
		end
		if count == 0 then
			AddOnListeners[name] = nil
		end
	end
end

local ModulePrototype = {}
function ModulePrototype:RegisterEvent(event, func)
	Addon:RegisterEvent(event, self, func)
end
function ModulePrototype:UnregisterEvent(event)
	Addon:UnregisterEvent(event, self)
end
function ModulePrototype:RegisterAddOnLoaded(name, func)
	Addon:RegisterAddOnLoaded(name, self, func)
end
function ModulePrototype:UnregisterAddOnLoaded(name)
	Addon:UnregisterAddOnLoaded(name, self)
end
Addon.ModulePrototype = ModulePrototype

Addon.Modules = {}
function Addon:NewModule(name)
	local object = {}
	self.Modules[name] = object
	table.insert(self.Modules, object)
	setmetatable(object, {__index=ModulePrototype})
	return object
end
setmetatable(Addon, {__index = Addon.Modules})

function Addon:ForAllModules(event, ...)
	for _, module in ipairs(Addon.Modules) do
		if type(module) == 'table' and module[event] then
			module[event](module, ...)
		end
	end
end

Addon:RegisterEvent('PLAYER_ENTERING_WORLD', Addon)
function Addon:PLAYER_ENTERING_WORLD()
	self:ForAllModules('BeforeStartup')
	self:ForAllModules('Startup')
	self:ForAllModules('AfterStartup')

	self:UnregisterEvent('PLAYER_ENTERING_WORLD', self)
end

Addon.Name = GetAddOnMetadata(ADDON, "Title")
Addon.Version = GetAddOnMetadata(ADDON, "X-Packaged-Version")
_G[ADDON] = Addon
