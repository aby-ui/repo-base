local L = LibStub("AceLocale-3.0"):NewLocale("AtlasLootReverse", "zhCN")
if not L then return end

L["AtlasLootReverse"] = true

-- Chat commands
L["atlaslootreverse"] = true
L["alr"] = true
L["Tooltip embedded: "] = "将掉落信息显示在物品信息中还是单独的信息框中"
L["Commands:\n/alr embed - Toggles the tooltip being embedded or split into another box"] = "AtlasLootReverse命令：\n/altr embed - 切换将掉落信息显示在物品信息中还是单独的信息框中"

L["Drops from %s"] = "来源：%s"  -- %s is boss (instance)
L["Heroic %s"] = "|cff00ff00英雄：%s|r"  -- %s is instance
L["25 Man %s"] = "%s[25]"  -- %s is instance
L["25 Man Heroic %s"] = "|cff00ff00英雄：%s[25]|r"  -- %s is instance
L["PvP %s Set"] = "PVP %s级套装"  -- %s is level
L["Tier %s"] = "T%s"  -- %s is number