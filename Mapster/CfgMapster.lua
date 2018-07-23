U1RegisterAddon("Mapster", {
    title = "地图增强",
    defaultEnable = 1,
    secure = 1,
    
    tags = { TAG_MAPQUEST },
    icon = [[Interface\Icons\INV_Misc_Map02]],
    desc = "增强世界地图的功能：`- 支持地图框体的缩放及移动`- 支持地图全开`- 支持显示鼠标位置坐标`- 可以改变团员图标的大小`- 可以直接选择副本地图``设置命令：/mapster",

    -------- Options --------
    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_MAPSTER"]("") end,
    },

  --  {
  --      text = "重置所有控制台设定",
  --      callback = function(cfg, v, loading)
  --          MapsterDB = nil; ReloadUI();
  --          NPCMarkMappingDB = nil; ReloadUI();
  --          NPCMarkDB = nil; ReloadUI();
  --          MapMarkHide = nil; ReloadUI();
   --     end,
  --  },
});
