--------------------------------------------------------------------------------
-- A DSL wrapper around AceConfigOptions
-- Why? I wanted something slightly more succinct
--------------------------------------------------------------------------------

local _, Addon = ...

local env = setmetatable({}, {__index = _G})

local function option(props)
    return function(...)
        local result = Mixin(props, ...)

        -- disable tooltips if something doesn't have a tooltip
        if not result.desc then
            result.descStyle = "none"
        end

        return result
    end
end

local function make_option(type)
    return function(name)
        return option {type = type, name = name}
    end
end

local function make_args(options)
    local result = {}

    for i = 1, #options do
        local arg = options[i]

        if type(arg) == "function" then
            arg = arg()
        end

        arg.order = i

        result[arg.name] = arg
    end

    return result
end

for key, type in pairs {
    h = "header",
    p = "description",
    button = "execute",
    check = "toggle",
    select = "select",
    range = "range",
    check_group = "multiselect",
    color = "color"
} do
    env[key] = make_option(type)
end

function env.radio_group(name)
    return option {
        name = name,
        type = "select",
        style = "radio"
    }
end

function env.group(name)
    return function(children)
        return option {
            type = "group",
            name = name,
            args = make_args(children)
        }
    end
end

function env.fieldset(name)
    return function(children)
        return option {
            name = name,
            type = "group",
            inline = true,
            args = make_args(children)
        }
    end
end

function env.tablist(props)
    return function(children)
        return option {
            name = name,
            type = "group",
            childGroups = "tab",
            args = make_args(children)
        }
    end
end

function env.tree(props)
    return function(children)
        return option {
            name = name,
            type = "group",
            childGroups = "tree",
            args = make_args(children)
        }
    end
end

function env.menu(props)
    return function(children)
        return option {
            name = name,
            type = "group",
            childGroups = "select",
            args = make_args(children)
        }
    end
end

-- options panels API
do
    local panels = {}

    function Addon:AddOptionsPanel(func, ...)
        local options = setfenv(func, env)(...)
        local args = make_args(options)    

        return self:AddOptionsPanelOptions(options.key, {
            type = "group",
            name = options.name,
            args = args
        })
    end

    function Addon:AddOptionsPanelOptions(key, options)
        return tinsert(
            panels,
            {
                key = key,
                options = options
            }
        )
    end

    function Addon:AddOptionsPanelFrame(key, frame)
        return tinsert(
            self.panels,
            {
                key = key,
                frame = frame
            }
        )
    end

    function Addon:GetOptionsPanels()
        return ipairs(panels)
    end
end
