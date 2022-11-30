----------------------------------------------------------------------------------------------------
------------------------------------------AddOn NAMESPACE-------------------------------------------
----------------------------------------------------------------------------------------------------

local FOLDER_NAME, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(FOLDER_NAME)
local L = private.locale

----------------------------------------------------------------------------------------------------
-------------------------------------------DEV CONFIG TAB-------------------------------------------
----------------------------------------------------------------------------------------------------

-- Activate the developer mode with:
-- /script HandyNotes_ValdrakkenDB.global.dev = true
-- /reload

local function devmode()
    private.config.options.args["DEV"] = {
        type = "group",
        name = L["dev_config_tab"],
        -- desc = L[""],
        order = 2,
        args = {
            force_nodes = {
                type = "toggle",
                name = L["dev_config_force_nodes"],
                desc = L["dev_config_force_nodes_desc"],
                order = 0,
            },
            show_prints = {
                type = "toggle",
                name = L["dev_config_show_prints"],
                desc = L["dev_config_show_prints_desc"],
                order = 1,
            },
        },
    }

    SLASH_VALREFRESH1 = "/valrefresh"
    SlashCmdList["VALREFRESH"] = function(msg)
        addon:Refresh()
        print("Valdrakken refreshed")
    end

    SLASH_VAL1 = "/val"
    SlashCmdList["VAL"] = function(msg)
        Settings.OpenToCategory('HandyNotes')
        LibStub('AceConfigDialog-3.0'):SelectGroup('HandyNotes', 'plugins', 'Valdrakken')
    end

end

function addon:debugmsg(msg)

    if private.global.dev and private.db.show_prints then
        print("|CFFFF6666Valdrakken: |r" .. msg)
    end

end

private.devmode = devmode
