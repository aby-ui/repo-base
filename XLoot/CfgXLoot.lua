U1RegisterAddon("XLoot", {
    title = "拾取界面增强",
    defaultEnable = 1,
    load = "NORMAL",

    tags = { TAG_INTERFACE },
    icon = [[Interface\Icons\ACHIEVEMENT_GUILDPERK_BOUNTIFULBAGS]],
    desc = "美化和增强拾取物品的界面。`可以同时显示全部掉落物品，不需翻页，还可以发送物品链接。有很多设置选项，可以调整按品质染色边框等。更详细的设置功能需通过/xloot命令进行。",
	
{
		text = "配置选项",
		tip="如无法打开配置页，请关闭暴雪插件管理页再试。",
        callback = function ()
            CoreIOF_OTC("XLoot")
		end,
    },
	
    --toggle = function(name, info, enable, justload) end,
--[[
    {
        var = "snap",
        default = true,
        text = "拾取框跟随鼠标",
        callback = function(cfg, v, loading) SlashCmdList['XLOOT']("set frame_snap "..tostring(not not v)) end,
    },
    {
        var = "colorborder",
        default = true,
        text = "按物品品质着色边框",
        callback = function(cfg, v, loading) SlashCmdList['XLOOT']("set quality_color_loot "..tostring(not not v)) end,
    },
    {
        var = "colorframe",
        default = false,
        text = "按最高品质着色外边框",
        callback = function(cfg, v, loading) SlashCmdList['XLOOT']("set quality_color_frame "..tostring(not not v)) end,
    },
    {
        var = "type",
        default = true,
        text = "显示物品类型",
        callback = function(cfg, v, loading) SlashCmdList['XLOOT']("set loot_texts_info "..tostring(not not v)) end,
    },
    {
        var = "bind",
        default = true,
        text = "显示物品绑定类型",
        tip = "说明`在物品图标里显示对应的绑定类型：`BoE - 装备绑定`BoP - 拾取绑定`BoU - 使用绑定",
        callback = function(cfg, v, loading) SlashCmdList['XLOOT']("set loot_texts_bind "..tostring(not not v)) end,
    },
    {
        text = "设置外边框颜色",
        callback = function(cfg, v, loading) SlashCmdList['XLOOT']("color frame_border") end,
    },
    {
        text = "设置背景颜色",
        callback = function(cfg, v, loading) SlashCmdList['XLOOT']("frame_color_backdrop") end,
    },
    {
        text = "设置缩放大小",
        var = "scale",
        type = 'spin',
        range = {0.5, 2, 0.1},
        default = 1.1,
        callback = function(cfg, v, loading) SlashCmdList['XLOOT']("set frame_scale "..v) if(XLootFrame:IsVisible()) then XLootFrame:SetScale(v) end end,
    },
]]--	
	
});
