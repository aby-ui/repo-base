local LocalDatabase, GlobalDatabase, SavedVars, Locals, SavedVarsDefault = unpack(select(2, ...))

--<<GENERAL CONFIG ELEMENTS>>-----------------------------------------------------------------------<<>>

    local GeneralConfigElements = {
        [1] = {
            var = "DisableInInstance",		
            element = "CheckButton",   
            text = Locals.DisableInInstance[1],
            tip = Locals.DisableInInstance[2], 
            value = SavedVars.DisableInInstance, 
            func = function(value) SavedVars.DisableInInstance = value LocalDatabase.ResetAllElements() end
        },
        [2] = {
            var = "DisableInCombat",		
            element = "CheckButton",   
            text = Locals.DisableInCombat[1],
            tip = Locals.DisableInCombat[2], 
            value = SavedVars.DisableInCombat, 
            func = function(value) SavedVars.DisableInCombat = value LocalDatabase.ResetAllElements() end
        },
    }

    local IndicatorConfigElements = {
        [1] = {
            var = "TextureVariant",
            element = "Slider",
            text = Locals.TextureVariant[1], 
            tip = Locals.TextureVariant[2], 
            value = SavedVars.TextureVariant, 
            minmax = {1, 5}, 
            step = 1, 
            func = function(value) SavedVars.TextureVariant = value LocalDatabase.ResetAllElements() end
        },
        [2] = {
            var = "Alpha",
            element = "Slider",
            text = Locals.Alpha[1], 
            tip = Locals.Alpha[2], 
            value = SavedVars.Alpha, 
            minmax = {0.1, 1}, 
            step = 0.05, 
            func = function(value) SavedVars.Alpha = value LocalDatabase.ResetAllElements() end
        },
        [3] = {
            element = "Color", 
            text = Locals.NormalQuestcolor[1], 
            tip = Locals.NormalQuestcolor[2], 
            value = SavedVars.NormalQuestcolor, 
            func = function(value) SavedVars.NormalQuestcolor = value LocalDatabase.ResetAllElements() end
        },
        [4] = {
            element = "Color", 
            text = Locals.GroupQuestcolor[1], 
            tip = Locals.GroupQuestcolor[2], 
            value = SavedVars.GroupQuestcolor, 
            func = function(value) SavedVars.GroupQuestcolor = value LocalDatabase.ResetAllElements() end
        },
        [5] = {
            element = "Color", 
            text = Locals.AreaQuestcolor[1], 
            tip = Locals.AreaQuestcolor[2], 
            value = SavedVars.AreaQuestcolor, 
            func = function(value) SavedVars.AreaQuestcolor = value LocalDatabase.ResetAllElements() end
        },
        [6] = {
			var = "Scale",
            element = "Slider", 
            text = Locals.Scale[1], 
            tip = Locals.Scale[2], 
            value = SavedVars.Scale, 
            minmax = {0.5, 3}, 
            step = 0.1, 
            func = function(value) SavedVars.Scale = value LocalDatabase.ResetAllElements() end
        },
        [7] = {
			var = "IconXOffset",
            element = "Slider", 
            text = Locals.IconXOffset[1], 
            tip = Locals.IconXOffset[2], 
            value = SavedVars.IconXOffset, 
            minmax = {-100, 100}, 
            step = 2, 
            func = function(value) SavedVars.IconXOffset = value LocalDatabase.ResetAllElements() end
        },
        [8] = {
			var = "IconYOffset",
            element = "Slider", 
            text = Locals.IconYOffset[1], 
            tip = Locals.IconYOffset[2], 
            value = SavedVars.IconYOffset, 
            minmax = {-100, 100}, 
            step = 2, 
            func = function(value) SavedVars.IconYOffset = value LocalDatabase.ResetAllElements() end
        },
    }

    local TasksConfigElements = {
        [1] = {
            element = "CheckButton",   
            text = Locals.ShowQuestTask[1],
            tip = Locals.ShowQuestTask[2], 
            value = SavedVars.ShowQuestTask, 
            func = function(value) SavedVars.ShowQuestTask = value LocalDatabase.ResetAllElements() end
        },
        [2] = {
            element = "CheckButton",   
            text = Locals.ShowQuestTaskOnMouseOver[1],
            tip = Locals.ShowQuestTaskOnMouseOver[2], 
            value = SavedVars.ShowQuestTaskOnMouseOver, 
            func = function(value) SavedVars.ShowQuestTaskOnMouseOver = value LocalDatabase.ResetAllElements() end
        },
        [3] = {
			var = "TasksXOffset",
            element = "Slider", 
            text = Locals.TasksXOffset[1], 
            tip = Locals.TasksXOffset[2], 
            value = SavedVars.TasksXOffset, 
            minmax = {-100, 100}, 
            step = 2, 
            func = function(value) SavedVars.TasksXOffset = value LocalDatabase.ResetAllElements() end
        },
        [4] = {
			var = "TasksYOffset",
            element = "Slider", 
            text = Locals.TasksYOffset[1], 
            tip = Locals.TasksYOffset[2], 
            value = SavedVars.TasksYOffset, 
            minmax = {-100, 100}, 
            step = 2, 
            func = function(value) SavedVars.TasksYOffset = value LocalDatabase.ResetAllElements() end
        },
        [5] = {
            element = "Slider", 
            text = Locals.TextSize[1], 
            tip = Locals.TextSize[2], 
            value = SavedVars.TextSize, 
            minmax = {2, 20}, 
            step = 1, 
            func = function(value) SavedVars.TextSize = value LocalDatabase.ResetAllElements() end
        },
    }

--<<INIT CONFIG>>-----------------------------------------------------------------------------------<<>>

    function LocalDatabase.InitConfigElements() 
        if GlobalDatabase.Config_Add then                                                             
            GlobalDatabase.Config_Add(GeneralConfigElements, "Kib Quest Mobs", Locals.General, "Interface\\AddOns\\Kib_QuestMobs\\media\\Config_Icon.tga", Locals.TabTip)
            GlobalDatabase.Config_Add(IndicatorConfigElements, "Kib Quest Mobs", Locals.Indicator)
            GlobalDatabase.Config_Add(TasksConfigElements, "Kib Quest Mobs", Locals.Tasks)
        end
    end

----------------------------------------------------------------------------------------------------<<END>>

local function transConfig(config)
    if not config.var then return end
    local c = {
        var = config.var,
        text = config.text,
        tip = "说明`"..config.tip,
        default = function() return SavedVarsDefault[config.var] end,
        callback = function(cfg, v, loading) config.func(v) end
    }
    if config.element == "Slider" then
        c.type = "spin"
        c.range = config.minmax
        c.range[3] = config.step
    end
    return c
end
local function transConfigs(tbl, configs)
    for i, v in ipairs(configs) do
        local cfg = transConfig(v)
        if cfg then tbl[#tbl+1] = cfg end
    end
end
function Kib_TransConfigsTo163()
    local cfgs = {}
    transConfigs(cfgs, GeneralConfigElements)
    transConfigs(cfgs, IndicatorConfigElements)
    transConfigs(cfgs, TasksConfigElements)
    return cfgs
end