
local GUI = LibStub:NewLibrary('NetEaseGUI-2.0', 2)
if not GUI then
    return
end

local Class = LibStub('LibClass-2.0')

GUI._EmbedTargets = GUI._EmbedTargets or {}
GUI._Classes = GUI._Classes or {}
GUI._ClassVersions = GUI._ClassVersions or {}

local _Classes = GUI._Classes
local _ClassVersions = GUI._ClassVersions
local _EmbedTargets = GUI._EmbedTargets

---- Class

function GUI:NewClass(name, super, version, ...)
    local class = _Classes[name]
    local oldversion = _ClassVersions[name]

    if not class or not oldversion or (version and oldversion < version) then
        class = Class:New(super)

        _Classes[name] = class
        _ClassVersions[name] = version

        self:Embed(class, ...)
        return class
    end
end

function GUI:GetClass(name)
    if not _Classes[name] then
        error('Can`t found Class ' .. name, 2)
    end
    return _Classes[name]
end

---- Embed

function GUI:Embed(target, ...)
    if type(target) == 'string' then
        error('', 2)
    end
    if not target then
        return
    end
    for i = 1, select('#', ...) do
        local name = select(i, ...)
        local embed = GUI:GetEmbed(name)
        if embed then
            for k, v in pairs(embed) do
                if type(v) == 'function' then
                    target[k] = v
                end
            end

            if type(embed.OnEmbed) == 'function' then
                embed:OnEmbed(target)
            end

            _EmbedTargets[name][target] = true
        end
    end
end

function GUI:NewEmbed(name, version)
    _EmbedTargets[name] = _EmbedTargets[name] or {}

    local embed, oldversion = LibStub:NewLibrary('NetEaseGUI-2.0.Embed.' .. name, version)
    if oldversion and next(_EmbedTargets[name]) then
        C_Timer.After(0, function()
            self:ReEmbed('NetEaseGUI-2.0.Embed.' .. name)
        end)
    end
    return embed and wipe(embed), oldversion
end

function GUI:GetEmbed(name)
    return LibStub('NetEaseGUI-2.0.Embed.' .. name)
end

function GUI:ReEmbed(name)
    local targets = _EmbedTargets[name]
    if targets then
        for target in pairs(targets) do
            self:Embed(targets, name)
        end
    end
end
