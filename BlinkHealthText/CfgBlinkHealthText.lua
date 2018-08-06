local _, engClass = UnitClass("player")
local mayHaveCombo = ("MONK,PALADIN,WARLOCK,MAGE,ROGUE,DRUID"):find(engClass) and true or false

U1RegisterAddon("BlinkHealthText", {
    title = "简易状态",
    defaultEnable = 0,
    tags = {"COMBATINFO",},
    icon = "Interface\\Icons\\Achievement_GarrisonQuests_0100",
    nopic = 1,
    load = "LOGIN",
    frames = { "SimpleInfoAnchorFrame", "SimpleInfoHitPointAnchorFrameNew" },
	toggle = function(name, info, enable, justload)
        if(justload) then return end
        if enable then
            BlinkHealth:Enable()
        else
            BlinkHealth:Disable()
		end
		return false
	end,

	{
		text = "移动插件",
		callback = function(cfg, v, loading)
            BlinkHealth:ShowAnchor()
		end,
	},
	{
		var = "enableTargetName",
		text = "显示目标名字",
        default = 1,
		callback = function(cfg, v, loading)
            BlinkHealth:ToggleNameVisible(v)
		end,
	},
	{
		var = "enableTargetCast",
		text = "显示目标施法条",
        default = 1,
		callback = function(cfg, v, loading)
            BlinkHealth:ToggleCastingBar(v)
		end,
	},
	{
		var = "enableRune",
		text = "显示符文条",
        default = 1,
		visible = (engClass == "DEATHKNIGHT"),
		callback = function(cfg, v, loading)
            BlinkHealth:ToggleRuneFrameVisible(v)
		end,
	},
	{
		var = "enableNumberHit",
		text = "显示数字连击点数",
        visible = mayHaveCombo,
        default = 1,
		callback = function(cfg, v, loading)
            BlinkHealth:ToggleHitPoint(v)
		end,
	},

    {
   		text = "显示连击点位置",
        visible = mayHaveCombo,
   		callback = function(cfg, v, loading)
               BlinkHealth:ShowHitAnchor()
   		end,
   	},

    {
   		text = "连击点数字大小",
        var = "hitPointSize",
        type = "spin",
        range = { 30, 150, 10 },
        default = 80,
        visible = mayHaveCombo,
   		callback = function(cfg, v, loading)
            BlinkHealth:SetHitPointSize(v)
   		end,
   	},
})