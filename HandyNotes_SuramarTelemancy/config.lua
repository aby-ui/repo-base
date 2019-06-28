local myname, ns = ...

local L = LibStub("AceLocale-3.0"):GetLocale(myname, false)

ns.defaults = {
    profile = {
        icon_scale = 1.5,
        icon_alpha = 1.0,
        entrances = true,
        upcoming = false,
    },
}

ns.options = {
    type = "group",
    name = "苏拉玛传送门", --myname:gsub("HandyNotes_", ""),
    get = function(info) return ns.db[info[#info]] end,
    set = function(info, v)
        ns.db[info[#info]] = v
        ns.HL:SendMessage("HandyNotes_NotifyUpdate", myname:gsub("HandyNotes_", ""))
    end,
    args = {
        icon = {
            type = "group",
            name = "图标设置",
            inline = true,
            args = {
                desc = {
                    name = "调整和设置图标的外观",
                    type = "description",
                    order = 0,
                },
                icon_scale = {
                    type = "range",
                    name = "图标尺寸",
                    desc = "调整图标的大小",
                    min = 0.25, max = 2, step = 0.01,
                    order = 20,
                },
                icon_alpha = {
                    type = "range",
                    name = "图标透明度",
                    desc = "调整图标的透明度",
                    min = 0, max = 1, step = 0.01,
                    order = 30,
                },
            },
        },
        display = {
            type = "group",
            name = "显示的内容",
            inline = true,
            args = {
                entrances = {
                    type = "toggle",
                    name = "显示入口",
                    desc = "显示对应区域传送门的入口处图标",
                    order = 0,
                },
				leyline = {
                    type = "toggle",
                    name = "显示魔网",
                    desc = "显示魔网的位置",
                    order = 0,
                },
                upcoming = {
                    type = "toggle",
                    name = "Show upcoming portals",
                    desc = "Show the upcoming portals, which can't yet be activated because you're not on the right quest step",
                    order = 10,
                },
            },
        },
    },
}
