-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local _, ns = ...

-------------------------------------------------------------------------------
------------------------------------ CLASS ------------------------------------
-------------------------------------------------------------------------------

ns.Class = function(name, parent, attrs)
    if type(name) ~= 'string' then error('name param must be a string') end
    if parent and not ns.IsClass(parent) then
        error('parent param must be a class')
    end

    local Class = attrs or {}
    Class.getters = Class.getters or {}
    Class.setters = Class.setters or {}

    local instance_metatable = {
        __tostring = function(self)
            return '<' .. name .. ' instance at ' .. self.__address .. '>'
        end,

        __index = function(self, index)
            -- Walk up the class hierarchy and check for a static value
            -- followed by a getter function on each parent class
            local _Class = Class
            repeat
                -- Use rawget to skip __index on Class, we want to
                -- check each class object individually
                local value = rawget(_Class, index)
                if value ~= nil then return value end
                local getter = _Class.getters[index]
                if getter then return getter(self) end
                _Class = _Class.__parent
            until _Class == nil
        end,

        __newindex = function(self, index, value)
            local setter = Class.setters[index]
            if setter then
                setter(self, value)
            else
                rawset(self, index, value)
            end
        end
    }

    setmetatable(Class, {
        __call = function(self, ...)
            local instance = {}
            instance.__class = Class
            instance.__address = tostring(instance):gsub('table: ', '', 1)
            setmetatable(instance, instance_metatable)
            instance:Initialize(...)
            return instance
        end,

        __tostring = function() return '<class "' .. name .. '">' end,

        -- Make parent class attributes accessible on child class objects
        __index = parent
    })

    if parent then
        -- Set parent class and allow parent class setters to be used
        Class.__parent = parent
        setmetatable(Class.setters, {__index = parent.setters})
    elseif not Class.Initialize then
        -- Add default Initialize() method for base class
        Class.Initialize = function(self) end
    end

    return Class
end

-------------------------------------------------------------------------------
----------------------------------- HELPERS -----------------------------------
-------------------------------------------------------------------------------

ns.IsClass = function(class)
    return type(class) == 'table' and class.getters and class.setters
end

ns.IsInstance = function(instance, class)
    if type(instance) ~= 'table' then return false end
    local function compare(c1, c2)
        if c2 == nil then return false end
        if c1 == c2 then return true end
        return compare(c1, c2.__parent)
    end
    return compare(class, instance.__class)
end

ns.Clone = function(instance, newattrs)
    local clone = {}
    for k, v in pairs(instance) do clone[k] = v end
    if newattrs then for k, v in pairs(newattrs) do clone[k] = v end end
    return instance.__class(clone)
end
