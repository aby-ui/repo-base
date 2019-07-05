local Addon = _G[...]
local FX = {}

local effects = {}

function FX:Create(id, name, desc)
    if type(id) ~= "string" then
        error('Usage: OmniCC.FX:Create("id", ["name", "description"])', 2)
    end

    if effects[id] then
        error(('FX %q already registered'):format(id), 2)
    end

    local fx = { id = id, name = name, desc = desc }

    effects[id] = fx

    return fx
end

function FX:Get(id)
    if id then
        return effects[id]
    end
end

function FX:All()
    return pairs(effects)
end

function FX:Run(cooldown, effectID)
    if cooldown:IsForbidden() then return end

    local fx = self:Get(effectID)

    if fx then
        fx:Run(cooldown)
    end
end

Addon.FX = FX