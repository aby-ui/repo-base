local L = LibStub("AceLocale-3.0"):NewLocale("AtlasLootReverse", "zhTW")
if not L then return end

L["AtlasLootReverse"] = true

-- Chat commands
L["atlaslootreverse"] = true
L["alr"] = true
L["Tooltip embedded: "] = "將掉落資訊顯示在物品資訊中還是單獨的資訊框中"
L["Commands:\n/alr embed - Toggles the tooltip being embedded or split into another box"] = "AtlasLootReverse命令：\n/altr embed - 切換將掉落資訊顯示在物品資訊中還是單獨的資訊框中"

L["Drops from %s"] = "來源：%s"  -- %s is boss (instance)
L["Heroic %s"] = "|cff00ff00英雄：%s|r"  -- %s is instance
L["25 Man %s"] = "%s[25]"  -- %s is instance
L["25 Man Heroic %s"] = "|cff00ff00英雄：%s[25]|r"  -- %s is instance
L["PvP %s Set"] = "PVP %s級套裝"  -- %s is level
L["Tier %s"] = "T%s"  -- %s is number
