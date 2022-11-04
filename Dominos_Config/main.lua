local AddonName, AddonTable = ...
local Addon = LibStub('AceAddon-3.0'):NewAddon(AddonTable, AddonName, 'AceEvent-3.0', 'AceConsole-3.0')

local ParentAddonName = (GetAddOnDependencies(AddonName))
local ParentAddon = LibStub('AceAddon-3.0'):GetAddon(ParentAddonName)

--------------------------------------------------------------------------------
-- Interface Options Menu
--------------------------------------------------------------------------------

Addon.optionsMenuPanels = { }

function Addon:OnEnable()
    ParentAddon.callbacks:Fire('OPTIONS_MENU_LOADING', self)

    -- register ace config options
    LibStub('AceConfig-3.0'):RegisterOptionsTable(
        ParentAddonName,
        function()
            local options = {
                type = 'group',
                name = ParentAddonName,
                childGroups = "tab",
                args = {}
            }

            for _, panel in self:GetOptionsPanels() do
                if panel.options then
                    options.args[panel.key] = panel.options
                end
            end

            return options
        end
    )


    ParentAddon.callbacks:Fire('OPTIONS_MENU_LOADED', self)
end

-- A DSL for fun
local env = setmetatable({}, {__index = _G})

local function option(props)
    return function(...)
        local result = _G.Mixin(props, ...)

        -- disable tooltips if something doesn't have a tooltip
        if not result.desc then
            result.descStyle = 'none'
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

        if type(arg) == 'function' then
            arg = arg()
        end

        arg.order = i

        result[arg.name] = arg
    end

    return result
end

for key, type in pairs {
    h = 'header',
    p = 'description',
    button = 'execute',
    check = 'toggle',
    select = 'select',
    range = 'range',
    check_group = 'multiselect',
    color = 'color'
} do
    env[key] = make_option(type)
end

function env.radio_group(name)
    return option {name = name, type = 'select', style = 'radio'}
end

function env.group(name)
    return function(children)
        return option {type = 'group', name = name, args = make_args(children)}
    end
end

function env.fieldset(name)
    return function(children)
        return option {
            name = name,
            type = 'group',
            inline = true,
            args = make_args(children)
        }
    end
end

function env.tablist(props)
    return function(children)
        return option {
            type = 'group',
            childGroups = 'tab',
            args = make_args(children)
        }
    end
end

function env.tree(props)
    return function(children)
        return option {
            -- name = name,
            type = 'group',
            childGroups = 'tree',
            args = make_args(children)
        }
    end
end

function env.menu(props)
    return function(children)
        return option {
            -- name = name,
            type = 'group',
            childGroups = 'select',
            args = make_args(children)
        }
    end
end

-- shows the first options panel frame we have
function Addon:ShowPrimaryOptionsPanel()
    local dialog = LibStub('AceConfigDialog-3.0')

    dialog:Open(ParentAddonName)
    dialog:SelectGroup(ParentAddonName, self.optionsMenuPanels[1].key)
end

function Addon:AddOptionsPanel(func, ...)
    local options = setfenv(func, env)(...)
    local args = make_args(options)

    return self:AddOptionsPanelOptions(options.key, {
        type = 'group',
        order = options.order,
        name = options.name,
        args = args
    })
end

function Addon:AddOptionsPanelOptions(key, options)
    return table.insert(self.optionsMenuPanels, {key = key, options = options})
end

function Addon:AddOptionsPanelFrame(key, frame)
    return table.insert(self.optionsMenuPanels, {key = key, frame = frame})
end

function Addon:GetOptionsPanels()
    return ipairs(self.optionsMenuPanels)
end

--------------------------------------------------------------------------------
-- Utility Methods
--------------------------------------------------------------------------------

local function GetTimeMS()
    return GetTime() * 1000
end

function Addon:GetParent()
    return ParentAddon
end

function Addon:GetLocale()
    return LibStub("AceLocale-3.0"):GetLocale(ParentAddonName .. '-Config')
end

function Addon:CreateClass(...)
    return ParentAddon:CreateClass(...)
end

-- returns a function that generates unique names for frames
-- in the format <AddonName>_<Prefix>[1, 2, ...]
function Addon:CreateNameGenerator(prefix)
    local id = 0

    return function()
        id = id + 1
        return _G.strjoin('_', AddonName, prefix, id)
    end
end

-- a rough equivalent of js request animation frame
do
    local subscribers = {}
    local rendering = false

    local function render()
        while next(subscribers) do
            table.remove(subscribers):OnRender()
        end

        rendering = false
    end

    function Addon:Render(frame)
        for _, f in pairs(subscribers) do
            if f == frame then
                return false
            end
        end

        table.insert(subscribers, 1, frame)

        if not rendering then
            rendering = true
            C_Timer.After(GetTickTime(), render)
        end

        return true
    end
end

-- prevent a function from being called until <delay> ms after the last call
function Addon:Debounce(func, delay)
    local args = {}
    local lastCall = 0

    local function callback()
        if (GetTimeMS() - lastCall) >= delay then
            if #args > 0 then
                func(unpack(args))
            else
                func()
            end
        end
    end

    return function(...)
        for i = #args, -1, 1 do
            args[i] = nil
        end

        for i = 1, select('#', ...) do
            args[i] = (select(i, ...))
        end

        lastCall = GetTimeMS()
        _G.C_Timer.After(delay / 1000, callback)
    end
end

--------------------------------------------------------------------------------
-- Exports
--------------------------------------------------------------------------------

ParentAddon.Options = Addon
