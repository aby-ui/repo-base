local _, addon = ...

if GetLocale():sub(1,2)=="zh" then
    addon.L["List of commands"] = "List of commands"
    addon.L["Shows all commands"] = "Shows all commands"
    addon.L["Shows the config frame"] = "Shows the config frame"
    addon.L["Loads a talent profile"] = "Loads a talent profile"
    addon.L["Resets the suggestion frame location"] = "Resets the suggestion frame location"
    addon.L["Switch Switch Options"] = "Switch Switch 天赋方案选项"
    addon.L["General"] = "一般选项"
    addon.L["Debug mode"] = "调试模式"
    addon.L["Prompact to use Tome to change talents?"] = "提示需要使用书卷才能切换天赋?"
    addon.L["Autofade timer for auto-change frame"] = "自动切换窗口渐隐时间"
    addon.L["(0 to disable auto-fade)"] = "(0为不自动关闭)"
    addon.L["Profiles for instance auto-change:"] = "场景切换选项"
    addon.L["If you select a profile from any of the dropdown boxes, when etering the specific instance, you will be greeted with a popup that will ask you if you want to change to that profile."] = "如果你在下面的下拉框里选择了一个方案，则进入对应的场景时，会弹出是否切换天赋的对话框。"
    addon.L["Arenas"] = "竞技场"
    addon.L["Battlegrounds"] = "战场"
    addon.L["Raid"] = "团队副本"
    addon.L["Party"] = "小队副本"
    addon.L["Heroic"] = "英雄"
    addon.L["Mythic"] = "史诗"
    addon.L["Do you want to use a tome to change talents?"] = "你想要的使用一本书卷来切换天赋吗?"
    addon.L["Yes"] = "是"
    addon.L["No"] = "否"
    addon.L["New"] = "新建"
    addon.L["Delete"] = "删除"
    addon.L["Change!"] = "更换!"
    addon.L["Cancel"] = "取消"
    addon.L["Save"] = "保存"
    addon.L["Edit"] = "修改"
    addon.L["Rename"] = "改名"
    addon.L["Talents"] = "方案"
    addon.L["Rename profile"] = "修改方案名称"
    addon.L["Ok"] = "确认"
    addon.L["Changing talents"] = "正在切换天赋"
    addon.L["Would you like to change you talents to %s?"] = "是否把天赋切换为方案 %s?"
    addon.L["Frame will close after %s seconds..."] = "窗口将在 %s 秒后关闭..."
    addon.L["Could not change talents to Profile '%s' as it does not exit"] = "没有方案'%s',无法切换天赋"
    addon.L["Could not find a Tome to use and change talents"] = "背包里无法找到静心书卷"
    addon.L["Could not change talents as you are not in a rested area, or dont have the buff"] = "无法切换天赋，因为你不在休息状态"
    addon.L["It seems like the talent from tier: '%s' and column: '%s' have been moved or changed, check you talents!"] = "似乎第'%s'层第'%s'个天赋被移除或改动了，检查一下!"
    addon.L["Changed talents to '%s'"] = "已切换天赋为方案'%s'"
    addon.L["Saving will override '%s' configuration"] = "继续保存会覆盖'%s'的设置"
    addon.L["You want to delete the profile '%s'?"] = "你想要删除方案'%s'吗?"
    addon.L["Create/Ovewrite a profile"] = "创建或覆盖一个方案"
    addon.L["Name too long!"] = "名字太长了"
    addon.L["'Custom' cannot be used as name!"] = "无法把方案命名为'自定义'!"
    addon.L["Talent profile %s created!"] = "天赋方案'%s'已创建!"
    addon.L["Profile '%s' overwritten!"] = "原天赋方案'%s'已被覆盖!"
    addon.L["Save pvp talents?"] = "保存当前PVP天赋?"
    addon.L["Talent Porfile Editor"] = "天赋方案管理"
    addon.L["Editing '%s'"] = "正在修改 '%s'"
    addon.L["Auto equip gear set with this talent profile?"] = "随此方案自动装备套装？"
    addon.L["Gear set to auto-equip:"] = "要自动装备的套装："
end