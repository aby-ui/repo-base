--[[
2019-2022 João Cardoso

A library heavily inspired in AceAddon-3.0, with small behavior changes
and additional features that I needed and were incompatible with Ace.
]]--

local Lib = LibStub:NewLibrary('WildAddon-1.0', 1)
if not Lib then return end


--[[ Locals ]]--

local type, tinsert, tremove, pairs = type, tinsert, tremove, pairs
local Events = LibStub('AceEvent-3.0')
local Embeds = {}

local function safecall(object, key, ...)
	if type(object[key]) == 'function' then
		object[key](object, ...)
	end
end

local function embed(object, ...)
  for i= 1, select('#', ...) do
    local lib = select(i, ...)
    if type(lib) == 'string' then
      lib = LibStub(lib)
    end

		if type(lib) == 'table' then
      safecall(lib, 'Embed', object)
    end
	end
  return object
end

local function newobject(domain, id, object, ...)
  if type(object) == 'string' then
    object = embed({}, Lib, Events, object, ...)
  else
    object = embed(object or {}, Lib, Events, ...)
  end

  if domain then
    domain[id] = object
  end

  tinsert(Lib.Loading, object)
  return object
end

local function load()
  if IsLoggedIn() then
    while (#Lib.Loading > 0) do
      safecall(tremove(Lib.Loading, 1), 'OnEnable')
    end
  end
end

Lib.Loading = Lib.Loading or {}
Events.RegisterEvent(Lib, 'PLAYER_LOGIN', load)
Events.RegisterEvent(Lib, 'ADDON_LOADED', load)


--[[ Addon/Module API ]]--

function Embeds:NewModule(...)
  local module = newobject(self, ...)
  module.Tag = self.Tag
  return module
end

function Embeds:RegisterSignal(id, call, ...)
  self:RegisterMessage(self.Tag .. id, call or id, ...)
end

function Embeds:UnregisterSignal(id, ...)
  self:UnregisterMessage(self.Tag .. id, ...)
end

function Embeds:SendSignal(id, ...)
  self:SendMessage(self.Tag .. id, ...)
end


--[[ Public API ]]--

function Lib:NewAddon(name, ...)
  local addon = newobject(_G, name, ...)
  addon.Tag = name:upper() .. '_'
  addon.Name = name
  return addon
end

function Lib:Embed(object)
	for k,v in pairs(Embeds) do
		object[k] = v
	end
end
