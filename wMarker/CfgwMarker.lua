U1RegisterAddon("wMarker", {
    title = "全能标记助手",
    defaultEnable = 0,
    load = "NORMAL",
    secure = 1,
	nopic = 1,
    tags = { TAG_RAID },
	optionsAfterVar = 1,
    icon = [[Interface\Icons\INV_Sigil_UlduarAll]],
    desc = "wMarker漂亮的团队标记插件，显示一个各种团队标记的框体以供快速标记，问号为就绪检查，X为清除标记。",

{
		var = "Raidshown",
		text = "团队标记",
		type = "checklist",
		cols = 2,
		options = {"显示框体", 'shown', "垂直显示", 'vertical','单独时隐藏','alone'},
	

        getvalue = function()
            raid = {}
            raid['shown'] = wMarkerDB.shown;
			raid['alone'] = wMarkerDB.partyShow;
			raid['vertical'] = wMarkerDB.vertical;
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
		
		if not wMarkerDB then wMarkerDB = {} end
			wMarkerDB.partyShow = v.alone;
			wMarkerDB.shown = v.shown;
			wMarker:visibility()
			
			wMarkerDB.vertical = v.vertical;
			wMarker:orien()
		end,
},	
{
		var = "worldRaido",
		text = "世界标记",
		type = "checklist",
		cols = 2,
		options = {"显示框体", 'shown', "垂直显示", 'vertical','单独时隐藏','alone'},
		
        getvalue = function()
            raid = {}
            raid['shown'] = wFlaresDB.shown;
			raid['alone'] = wFlaresDB.partyShow;
			raid['vertical'] = wFlaresDB.vertical;
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
		if not wFlaresDB then wFlaresDB = {} end
			wFlaresDB.shown = v.shown;
			wFlaresDB.partyShow = v.alone;
			wMarker:visibility()
			
			wFlaresDB.vertical = v.vertical;
			wFlares:orien()
		end,
},

})