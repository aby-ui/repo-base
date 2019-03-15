-- Core v1.4
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

local CommStarted = false
local CommListeners = {}
function Addon:RegisterAddOnComm(prefix, callback, func)
	if func == nil then func = 0 end

	if not CommStarted then
		C_ChatInfo.RegisterAddonMessagePrefix(Addon.ShortName)
		self:RegisterEvent('CHAT_MSG_ADDON', self)
		CommStarted = true
	end
	if CommListeners[prefix] == nil then
		CommListeners[prefix] = { [callback]=func }
	else
		CommListeners[prefix][callback] = func
	end
end

function Addon:UnregisterAddOnComm(prefix, callback)
	local listeners = CommListeners[prefix]
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
			CommListeners[prefix] = nil
		end
	end
end

function Addon:SendAddOnComm(prefix, message, type, target)
	if (type == "PARTY" and not IsInGroup(LE_PARTY_CATEGORY_HOME))
			or (type == "INSTANCE" and not IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
		return false
	end
	local data = prefix.."|"..message
	C_ChatInfo.SendAddonMessage(Addon.ShortName, data, type, target)
	return true
end

function Addon:CHAT_MSG_ADDON(prefix, message, type, sender)
	if prefix == Addon.ShortName then
		for prefix,listeners in pairs(CommListeners) do
			local matcher = prefix.."|"
			if string.sub(message, 1, #matcher) == matcher then
				local data = string.sub(message, #matcher + 1)
				for callback,func in pairs(listeners) do
					if func == 0 then
						callback.ReceiveAddOnComm(callback, data, type, sender)
					else
						callback[func](callback, data, type, sender)
					end
				end
			end
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
function ModulePrototype:RegisterAddOnComm(func)
	Addon:RegisterAddOnComm(self.Name, self, func)
end
function ModulePrototype:UnregisterAddOnComm()
	Addon:UnregisterAddOnComm(self.Name, self)
end
function ModulePrototype:SendAddOnComm(message, type, target)
	Addon:SendAddOnComm(self.Name, message, type, target)
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
	object.Name = name
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
Addon.ShortName = GetAddOnMetadata(ADDON, "X-Short-Name") or string.sub(ADDON, 1, 16)
Addon.Version = GetAddOnMetadata(ADDON, "X-Packaged-Version")
_G[ADDON] = Addon
