U1RegisterAddon("wMarker", {
	title = "全能标记助手",
	defaultEnable = 0,
	load = "NORMAL",
	secure = 1,
	nopic = 1,
	tags = { TAG_RAID },
	optionsAfterLogin = 1,
	icon = [[Interface\Icons\INV_Sigil_UlduarAll]],
	desc = "wMarker漂亮的团队标记插件，显示一个各种团队标记的框体以供快速标记，问号为就绪检查，X为清除标记。",

	{
		var = "Raidshown",
		text = "团队标记",
		type = "checklist",
		cols = 2,
		options = {"显示框体", 'shown', "垂直显示", 'vertical','单独时隐藏','alone'},


		getvalue = function()
			local raid = {}
			raid['shown'] = wMarkerAce.db.profile.raid.shown;
			raid['alone'] = wMarkerAce.db.profile.raid.partyShow;
			raid['vertical'] = wMarkerAce.db.profile.raid.vertical;
			return raid
		end,

		callback = function(cfg, v,loading)

			if not v then
				v = {
					alone = false,
					shown = true,
					vertical = true,
				}
			end

			if not wMarkerAce.db.profile.raid then wMarkerAce.db.profile.raid = {} end
			wMarkerAce.db.profile.raid.partyShow = v.alone;
			wMarkerAce.db.profile.raid.shown = v.shown;
			wMarkerAce:updateVisibility()

			wMarkerAce.db.profile.raid.vertical = v.vertical;
			wMarkerAce:raidOrient()
		end,
	},
	{
		var = "worldRaido",
		text = "世界标记",
		type = "checklist",
		cols = 2,
		options = {"显示框体", 'shown', "垂直显示", 'vertical','单独时隐藏','alone'},

		getvalue = function()
			local raid = {}
			raid['shown'] = wMarkerAce.db.profile.world.shown;
			raid['alone'] = wMarkerAce.db.profile.world.partyShow;
			raid['vertical'] = wMarkerAce.db.profile.world.vertical;
			return raid
		end,

		callback = function(cfg, v,loading)
			if not v then
				v = {
					alone = true,
					shown = true,
					vertical = true,
				}
			end
			if not wMarkerAce.db.profile.world then wMarkerAce.db.profile.world = {} end
			wMarkerAce.db.profile.world.shown = v.shown;
			wMarkerAce.db.profile.world.partyShow = v.alone;
			wMarkerAce:updateVisibility()

			wMarkerAce.db.profile.world.vertical = v.vertical;
			wMarkerAce:worldOrient()
		end,
	},

	{
		text = "其他选项",
		callback = function(cfg, v,loading)
			wMarkerAce:SlashInput("")
		end
	}
})