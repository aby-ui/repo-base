--如果 UI163_USER_MODE = 1 则不需要写alwaysRegister，而且插件会列在爱不易整合里，如果不提供USER_MODE，只写alwaysRegister，则插件会列在分类里，但仍然在单体插件里，而不是爱不易整合里
--UI163_USER_MODE = 1

U1RegisterAddon("DailyTamerCheck", {
    title = "宠物日常检测",
    defaultEnable = 0,
    tags = {TAG_MAPQUEST},
    desc = "检测宠物日常任务完成情况，配合TomTom插件，可以设置各个任务的路径点。`快捷命令：/dtc 或 /dtcheck",
	nopic = 1,
    icon = "Interface\\ICONS\\INV_MISC_PETMOONKINTA",
	{
		text="设置相关选项",
		type = "text",
		{
			var = "show_npcicons",
			text = "显示宠物类型图标",
			default = false,
			getvalue=function() 
				return GetOptionValue("show_npcicons") 
			end,
			callback = function(cfg, v, loading)
				RefreshOption(cfg.var, 3, v)
			end,
		},
		{
			var = "show_coordinates",
			text = "显示任务坐标",
			getvalue=function() 
				return GetOptionValue("show_coordinates") 
			end,
			callback = function(cfg, v, loading)
				RefreshOption(cfg.var, 0, v)
			end,
		},
		{
			var = "show_npcnames",
			text = "显示NPC名字",
			default = false,
			getvalue=function() 
				return GetOptionValue("show_npcnames") 
			end,
			callback = function(cfg, v, loading)
				RefreshOption(cfg.var, 1, v)
			end,
		},
		{
			var = "show_npclevel",
			text = "显示宠物等级",
			default = false,
			getvalue=function() 
				return GetOptionValue("show_npclevel") 
			end,
			callback = function(cfg, v, loading)
				RefreshOption(cfg.var, 2, v)
			end,
		},
		{
			var = "show_mapicons",
			text = "显示世界地图图标",
			default = false,
			getvalue=function() 
				return GetOptionValue("show_mapicons") 
			end,
			callback = function(cfg, v, loading)
				RefreshOption(cfg.var, 4, v)
			end,
		},
		{
			var = "show_faction",
			text = "显示对立阵营任务",
			default = true,
			getvalue=function() 
				return GetOptionValue("show_faction") 
			end,
			callback = function(cfg, v, loading)
				RefreshOption(cfg.var, 5, v)
			end,
		},
	},
})

U1RegisterAddon("YOBUFF", {
    title = "YOBUFF",
    defaultEnable = 0,
    tags = {"MANAGEMENT"},
    icon = "Interface\\Icons\\Spell_ChargeNegative",
    nopic = 1,
	{
		text = "配置插件",
		callback = function()
			SlashCmdList["YOBUFF"]()
		end,
	},
})