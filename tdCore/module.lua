
local assert, pairs, select, type = assert, pairs, select, type

local Addon = tdCore.Addon

local function OnUpdate(self, elapsed)
    if self.__interval == 0 then
        self:__onUpdate(elapsed)
    else
        self.__elapsed = self.__elapsed + elapsed
        if self.__elapsed >= self.__interval then
            self:__onUpdate(self.__elapsed)
            self.__elapsed = 0
        end
    end
end

local Embeds = {
    Event = function(obj)
        obj:SetScript('OnEvent', tdCore.OnEvent)
    end,
    
    Update = {
        StartUpdate = function(obj, interval, onUpdate)
            onUpdate = onUpdate or obj.OnUpdate
            if onUpdate then
                obj.__onUpdate = onUpdate
                obj.__interval = interval or 0
                obj.__elapsed = 0
                obj:SetScript('OnUpdate', OnUpdate)
                obj:Show()
            end
        end,
        StopUpdate = function(obj)
            obj:SetScript('OnUpdate', nil)
            obj.__onUpdate = nil
            obj.__elapsed = nil
        end,
    }
}

function Addon:Embed(obj, ...)
    for i = 1, select('#', ...) do
        local embed = self:GetEmbed(select(i, ...))
        
        if type(embed) == 'function' then
            embed(obj)
        elseif type(embed) == 'table' then
            for name, method in pairs(embed) do
                obj[name] = method
            end
        end
    end
end

function Addon:GetEmbed(name)
    return self.__embeds and self.__embeds[name] or Embeds[name] or name
end

function Addon:NewModule(name, obj, ...)
    assert(type(name) == 'string', 'Bad argument #1 to `NewModule\' (string expected)')
    if not self.__modules[name] then
        obj = tdCore:NewClass(name, type(obj) == 'table' and obj or {})
        obj:RegisterHandle('OnProfileUpdate')
        obj.__debugName = self:GetName()
        obj.Debug = function(self, ...)
            tdCore:Debug(self.__debugName, ...)
        end
        
        self:Embed(obj, ...)
        self.__modules[name] = obj
        
        if obj.Hide and type(obj.Hide) == 'function' then obj:Hide() end
    end
    return self.__modules[name]
end

function Addon:GetModule(name)
    assert(type(name) == 'string', 'Bad argument #1 to `GetModule\' (string expected)')
    
    return self.__modules[name]
end
Addon.__call = Addon.GetModule

function Addon:IterateModules()
    return pairs(self.__modules)
end

function Addon:RegisterEmbed(name, embed)
    assert(type(name) == 'string', 'Bad argument #1 to `RegisterEmbed\' (string expected)')
    assert(type(embed) == 'table' or type(embed) == 'function', 'Bad argument #1 to `RegisterEmbed\' (table or function expected)')
    
    self.__embeds = self.__embeds or {}
    self.__embeds[name] = embed
end
