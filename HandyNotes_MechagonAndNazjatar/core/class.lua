local _, ns = ...

ns.Class = function (name, parent)
    parent = parent or {}
    local Class = { getters = {}, setters = {} }

    setmetatable(Class, {
        __call = function (self, instance)
            instance = instance or {}
            instance.__class = Class;

            local address = tostring(instance):gsub("table: ", "", 1)

            setmetatable(instance, {
                __tostring = function ()
                    return '<'..name..' object at '..address..'>'
                end,

                __index = function (self, index)
                    local getter = Class.getters[index]
                    if getter then return getter(self) end
                    return Class[index]
                end,

                __newindex = function (self, index, value)
                    local setter = Class.setters[index]
                    if setter then
                        setter(self, value)
                    else
                        rawset(self, index, value)
                    end
                end
            })

            local init = Class.init
            if init then init(instance) end

            return instance
        end,

        __tostring = function ()
            return '<class "'..name..'">'
        end,

        __index = parent
    })

    if parent then
        setmetatable(Class.getters, { __index = parent.getters })
        setmetatable(Class.setters, { __index = parent.setters })
        Class.__parent = parent
    else
        -- Add default init() method for base class
        Class.init = function (self) end
    end

    return Class
end

ns.isinstance = function (instance, class)
    local function compare (c1, c2)
        if c2 == nil then return false end
        if c1 == c2 then return true end
        return compare(c1, c2.__parent)
    end
    return compare(class, instance.__class)
end
